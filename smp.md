# SMP GC Race Condition Analysis

Tracking investigation of SMP garbage collector race conditions in Gambit Scheme.
Related: [PR #783](https://github.com/gambit/gambit/pull/783), issue #650, issue #813.

---

## Minimal Reproducer

```scheme
(declare (standard-bindings) (extended-bindings) (not safe))

(thread-join!
 (##thread-start!
  (##make-thread
   (##lambda ()
     (##map ##identity (##make-list 34000))))))
```

Run with: `gsi -:p2 test.scm` (compiled with `CFLAGS=-gdwarf -g3 -O0`).

The crash is non-deterministic. Original reporter saw ~13-18 failures per 1000 runs with `-:p4`.

---

## Symptom

The stack break handler (`_kernel.scm:1180+`) expects a return address (pointer into the label table) but finds the value **`0x3050`**, which is a `___sFRAME` heap object header. This causes a segfault when the handler tries to dereference it as a code label.

### Decoding 0x3050

```
0x3050 = 0011_0000_0101_0000 binary

bits [2:0]  = 0b000 = ___MOVABLE0  (GC generation tag)
bits [7:3]  = 0b01010 = 10 = ___sFRAME  (subtype)
bits [15:8] = 0x30 = 48 bytes
```

On 64-bit: `___MAKE_HD_WORDS(6, ___sFRAME)` — a 6-word movable frame object header.
This is exactly what `mark_captured_continuation` writes at `lib/mem.c:3736`.

---

## Prior SMP Fixes (from PR #783 history)

PR #783 uncovered three layers of SMP bugs. The first two were fixed; the third (this one) was not fully resolved.

| Commit      | Fix                                                                                                                                                           | Layer |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|
| `d0bf2c36`  | `___stack_overflow_undo_if_possible` was corrupting memory in SMP. Added null msection marker to distinguish initial break frames from overflow break frames. | 1     |
| `4325936c`  | `___os_condvar_select` could trigger GC without `___W_ALL`/`___R_ALL`, leaving stale cached register state. Wrapped with write-back/read-back.                | 2     |
| *(unfixed)* | Stack corruption during GC mark phase — one processor's `mark_captured_continuation` interferes with frames visible to another processor.                     | 3     |

---

## GC Architecture Overview

Gambit uses a **cooperative stop-the-world GC** with **parallel marking**.

### GC Phases (lib/mem.c, ~line 6749)

```
All processors rendezvous via BARRIER()
  │
  ├─ garbage_collect_setup_phase()     ── BARRIER() ──
  ├─ garbage_collect_mark_strong_phase()  ── BARRIER() ──
  ├─ garbage_collect_mark_weak_phase()    ── BARRIER() ──
  ├─ garbage_collect_cleanup_phase()      ── BARRIER() ──
  └─ resize_heap() [processor 0 only]    ── BARRIER() ──
```

No mutator code runs during GC. However, **within each phase**, all processors execute in parallel.

### Mark Strong Phase (line 6624)

Each processor **independently and in parallel** does:

```
1. mark_continuation()          — walk own stack, copy captured frames to heap
2. mark_registers()             — mark own VM registers
3. mark_saved()                 — mark own saved state
4. mark_type_cache()
5. mark_processor_scmobj()
6. mark_reachable_from_marked() — parallel transitive closure with work-stealing
```

**Critical: there is NO barrier between steps 1-5 and step 6.** Processors enter `mark_reachable_from_marked` at different times.

### Work-Stealing in mark_reachable_from_marked (line 6478)

Each processor scans its own heap allocation area. When idle, it steals completed chunks from other processors' FIFO queues (`heap_chunks_to_scan`) using spinlocks. This means a `___sFRAME` object allocated by Processor A can be scanned by Processor B.

---

## The Race Condition

### Key Function: mark_captured_continuation (lib/mem.c:3647)

This function copies continuation frames from the **stack** to the **heap** during GC marking. For each frame it:

1. Reads return address `ra1` from stack frame (line 3682)
2. Allocates heap space and writes:
   - `*alloc++ = ___MAKE_HD_WORDS(words, ___sFRAME)` — header (line 3736)
   - `*alloc++ = ra1` — return address as body[0] (line 3741)
   - frame slots copied from stack (lines 3746-3747)
3. Writes forwarding pointer into original stack frame's link slot (line 3768)
4. Overwrites original RA slot with `ra2` for non-first frames (line 3763)
5. Updates `alloc_heap_ptr` only at chunk boundaries or when done (lines 3726, 3776, 3788)

The function holds `MISC_MEM_LOCK` (a spinlock) for its entire duration, but this lock **only** serializes concurrent `mark_captured_continuation` calls — it does NOT block the scanner.

### Call Sites

`mark_captured_continuation` is called from two contexts:

| Context             | Caller                               | Line                              | When                                |
|---------------------|--------------------------------------|-----------------------------------|-------------------------------------|
| Root scanning       | `mark_continuation` → line 3945      | Each processor on its own stack   | During root marking                 |
| Transitive scanning | `case ___sCONTINUATION:` → line 4077 | Any processor on any continuation | During `mark_reachable_from_marked` |

### Race Scenario

1. **Processor A** has a large continuation chain (34,000 element `##map`). Its `mark_continuation` → `mark_captured_continuation` takes a long time, copying many frames to heap.

2. **Processor B** finishes root marking quickly, enters `mark_reachable_from_marked`, and starts scanning heap objects.

3. Processor A calls `end_heap_chunk` / `start_heap_chunk` at line 3774-3778 when chunk limits are reached, publishing completed chunks to the FIFO.

4. Processor B **steals** a completed chunk from Processor A's FIFO (line 6521-6536). The chunk contains `___sFRAME` objects and possibly `___sCONTINUATION` objects.

5. When Processor B scans a `___sCONTINUATION` in the stolen chunk (line 4076-4078):
   ```c
   case ___sCONTINUATION:
       mark_captured_continuation(___PSP &body[___CONTINUATION_FRAME]);
   ```
   This calls `mark_captured_continuation` on a continuation that may reference the **same stack frame chain** Processor A is still copying.

6. Both processors now read/write the same stack frames. `MISC_MEM_LOCK` serializes the heap allocation but NOT the stack reads/writes:
   - Processor A writes forwarding pointer to `___FP_SET_STK(fp,link+1,forw)` (line 3768)
   - Processor A overwrites RA: `___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)` (line 3763)
   - Processor B reads the same stack locations, potentially seeing partially-modified state

### Memory Ordering Issue

Even without overlapping continuation chains, on weakly-ordered architectures (ARM, POWER) or via store-buffer effects on x86, when Processor B scans a stolen chunk:

- It may see `alloc[0] = 0x3050` (header — written first, visible)
- But read stale data for `alloc[1]` (ra1 — not yet visible)

The `___SHARED_MEMORY_BARRIER()` in the work-stealing code (line 6532) provides a barrier on the **consuming** side, but there is no corresponding barrier on the **producing** side in `mark_captured_continuation` after writing frame objects to heap.

### How 0x3050 Ends Up as a Return Address

Several paths could produce this:

1. **Adjacent frame aliasing**: Scanner misaligns and reads the header of frame N+1 as the body of frame N, interpreting a header word as a return address.

2. **Stale heap read**: Scanner sees the header word but the return address slot still holds pre-initialization content due to memory ordering.

3. **Double-copy race**: Two processors both enter `mark_captured_continuation` for overlapping frame chains. The forwarding-pointer check (line 3710) sees a partially-installed forwarding pointer, follows it to a heap frame that is only partially written (header present, RA not yet written).

---

## What MISC_MEM_LOCK Protects (and Doesn't)

**Protected:**
- Heap allocator state (`alloc_heap_ptr`, chunk management)
- Serialization of concurrent `mark_captured_continuation` calls

**NOT protected:**
- Stack frame reads during `mark_captured_continuation` vs concurrent stack modification
- Scanner reading `___sFRAME` objects while they're being written
- Memory ordering between producer (frame copier) and consumer (scanner)

---

## Potential Fix Approaches

### Approach 1: Barrier Between Root Marking and Transitive Scanning

Split `garbage_collect_mark_strong_phase` to add a `BARRIER()` after root marking:

```c
// All processors mark their own roots
mark_continuation(___PSPNC);
mark_registers(___PSPNC);
mark_saved(___PSPNC);
mark_type_cache(___PSPNC);
mark_processor_scmobj(___PSPNC);

BARRIER();  // <-- NEW: ensure all continuation copying is complete

mark_reachable_from_marked(___PSPNC);
```

**Pros:** Simple, correct, prevents cross-processor continuation races entirely.
**Cons:** Reduces parallelism — fast processors idle waiting for slow ones before scanning can begin.

### Approach 2: Memory Barriers in mark_captured_continuation

Add `___SHARED_MEMORY_BARRIER()` after writing each complete frame object:

```c
for (i=fs; i>0; i--)
    *alloc++ = ___FP_STK(fp,i);

___SHARED_MEMORY_BARRIER();  // <-- ensure frame is fully visible before publishing
```

**Pros:** Preserves parallelism.
**Cons:** Only fixes memory ordering; doesn't fix the overlapping-chain race if two processors enter `mark_captured_continuation` for the same frames.

### Approach 3: Defer Continuation Scanning

When scanning a `___sCONTINUATION` object during `mark_reachable_from_marked`, instead of immediately calling `mark_captured_continuation`, enqueue it for processing after the current scan completes — ensuring only the owning processor handles its continuations.

**Pros:** Eliminates cross-processor continuation chain races entirely.
**Cons:** More complex implementation; may affect GC performance for continuation-heavy workloads.

### Approach 4: Combined (Recommended)

Apply Approach 1 (barrier) as the primary fix, and Approach 2 (memory barriers) as defense-in-depth. The barrier is the most conservative and correct solution; the memory barriers provide additional safety for any future changes to the scan ordering.

---

## Files of Interest

| File | Relevant Code |
|------|---------------|
| `lib/mem.c:3647-3794` | `mark_captured_continuation` — frame copying with forwarding pointers |
| `lib/mem.c:3878-3946` | `mark_continuation` — stack walking, calls `mark_captured_continuation` |
| `lib/mem.c:4076-4078` | `case ___sCONTINUATION:` in scanner — second call site for `mark_captured_continuation` |
| `lib/mem.c:4081-4127` | `case ___sFRAME:` in scanner — reads `body[0]` as return address |
| `lib/mem.c:4259-4364` | `scan_movable_objs_to_scan` — incomplete chunk scanning with `alloc_heap_ptr` fence |
| `lib/mem.c:6478-6583` | `mark_reachable_from_marked` — parallel work-stealing scan |
| `lib/mem.c:6624-6680` | `garbage_collect_mark_strong_phase` — parallel root marking + scan (no internal barrier) |
| `lib/_kernel.scm:1180+` | Stack break handler — reads return addresses from frames |
| `lib/setup.c:542+` | `barrier_sync_op` — tree-based barrier synchronization |
| `lib/setup.c:1132+` | `on_all_processors` — GC trigger mechanism |
| `include/gambit.h.in:3185` | `___MAKE_HD_WORDS` macro definition |
| `include/gambit.h.in:8298` | `___STACK_TRIP_ON` — interrupt delivery for GC coordination |

---

## Open Questions

- [ ] Can a `___sCONTINUATION` object in the heap ever point to a **different processor's** stack? If continuations are strictly per-thread, the overlapping-chain race may not occur from the transitive scan path — but it could still occur from shared data structures.
- [ ] What is the exact timing between `end_heap_chunk` publishing and the scanner stealing? Is there a window where the chunk link word is visible but the last frame in the chunk is not fully written?
- [ ] Does the `##map` on a 34,000-element list create continuation objects that become heap-reachable before GC, or only stack-resident frames? This affects whether the `case ___sCONTINUATION:` path is triggered during the mark phase.
- [ ] The RR recording shows the corruption occurs between events 440-441 in a `mark_captured_continuation` call. What is the other processor doing at that exact point?

---

## Bug #2: GC Eager Rehash Corrupts Non-eq? Hash Tables

### Root Cause

In SMP builds, Gambit uses **eager rehash** for gc-hash-tables during GC. The function `gc_hash_table_rehash_in_situ` (lib/mem.c) repositions entries using the pointer-based hash function `___GCHASHTABLE_HASH_STEP` — which computes hash based on the **memory address** of the key object.

This is correct for **eq? tables**, where the C-level `___gc_hash_table_ref` also uses `___GCHASHTABLE_HASH_STEP` for lookup.

However, **non-eq? tables** (e.g., default `make-table` with `test: ##equal?`) use a **content-based** Scheme hash function (`##equal?-hash`) in the Scheme-level `##table-access` for lookup. After GC eagerly repositions entries using pointer-based hash, `##table-access` cannot find them because it looks at the wrong position.

### Proof

1. `make-table` with default `test: ##equal?` → `table-ref` fails after GC
2. `make-table test: eq?` → `table-ref` always works after GC
3. `table-search` (iterates all slots) always finds the entry
4. The `equal?-hash` return value is stable across GC (content doesn't change)
5. Direct inspection shows entries physically moved to different slots in the gc-hash-table body after GC

### Configuration

- Build: `--enable-single-host --enable-multiple-threaded-vms --enable-smp`
- Original code: `#define ___GC_HASH_TABLE_REHASH_EAGERLY` for SMP builds
- Single-threaded builds: `#define ___GC_HASH_TABLE_REHASH_LAZILY` (not affected)

### Fix Applied

Changed `lib/mem.c` to always use `___GC_HASH_TABLE_REHASH_LAZILY`:

```c
#define ___GC_HASH_TABLE_REHASH_LAZILY  /* was: ___GC_HASH_TABLE_REHASH_EAGERLY for SMP */
```

With lazy rehash:
- **eq? tables**: rehashed on first access via `___gc_hash_table_ref`/`___gc_hash_table_set` (C code checks KEY_MOVED flag, calls `gc_hash_table_rehash_in_situ` which uses pointer-hash → correct for eq? tables)
- **non-eq? tables**: no rehash needed — entries stay at content-hash positions which are stable across GC. `##table-access` (Scheme level) uses content-based hash → finds entries correctly

The `process_gc_hash_tables` function still sets `KEY_MOVED` on all tables with `MEM_ALLOC_KEYS` (assume worst case), but the eager rehash call is guarded by `#ifndef ___GC_HASH_TABLE_REHASH_LAZILY` so it's now a no-op.

### Key Technical Details

- gc-hash-table body layout: NEXT(0), FLAGS(1), COUNT(2), MIN_COUNT(3), FREE(4), KEY0(5), VAL0(6), ...
- Flag bits: WEAK_KEYS=1, WEAK_VALS=2, KEY_MOVED=4, ENTRY_DELETED=8, MEM_ALLOC_KEYS=16, NEED_REHASH=32, UNION_FIND=64
- `gc_hash_table_rehash_in_situ` clears KEY_MOVED after repositioning, so post-GC inspection shows entries at wrong positions with KEY_MOVED=0 (already cleared)
- The `##table-access` code checks NEED_REHASH (flag 32), not KEY_MOVED (flag 4)
- `___gc_hash_table_ref` (C level, for eq? tables) checks KEY_MOVED (flag 4)

### Important Debug Lesson

The compiled binary links against `gambit-install/lib/libgambit.a` (installed location), NOT `lib/libgambit.a` (build directory). Changes to `lib/mem.c` only affect compiled tests after copying the updated `libgambit.a` to the install directory. The interpreter (gsi) links against the build directory's `libgambit.a`, so interpreted tests reflected changes immediately while compiled tests silently used the old code.

---

## Test Results Summary

### Fix: BARRIER() + lazy rehash (both applied in lib/mem.c)

| Test | Mode | -:p1 | -:p2 | -:p4 |
|------|------|------|------|------|
| table-test.scm (default make-table) | interpreted | PASS | PASS | — |
| table-test.scm (default make-table) | compiled | PASS 20/20 | PASS 20/20 | — |
| table-test-eq.scm (eq? table) | compiled | PASS 20/20 | — | — |
| box-heap.scm (12 SMP stress tests) | interpreted | — | PASS | — |
| box-heap.scm (12 SMP stress tests) | compiled | PASS | PASS | — |
| smp-test-12.scm | compiled | PASS | PASS | — |
| smp-test-15.scm | compiled | — | PASS | — |
| smp-test-18.scm | compiled | — | PASS 5/5 | PASS 3/3 |

---

## Changelog

- **2026-02-26**: Initial analysis. Identified `mark_captured_continuation` race between root marking and transitive scanning. Decoded 0x3050 as `___MAKE_HD_WORDS(6, ___sFRAME)`. Catalogued prior SMP fixes from PR #783. Proposed four fix approaches.
- **2026-02-26**: Applied BARRIER() fix between root marking and transitive scanning. All 24 SMP tests pass interpreted.
- **2026-02-26**: Discovered GC eager rehash bug. Compiled test 03 (table operations) crashes/fails because `gc_hash_table_rehash_in_situ` uses pointer-based hash which corrupts non-eq? tables.
- **2026-02-27**: Confirmed root cause with direct gc-hash-table body inspection. Fixed by switching SMP builds from eager to lazy rehash. Key debug insight: compiled binaries link against installed (not build) libgambit.a, so changes must be copied to install directory. All tests now pass across all configurations (interpreted/compiled, -:p1/-:p2/-:p4).

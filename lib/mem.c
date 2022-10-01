/* File: "mem.c" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.  */

#define ___INCLUDED_FROM_MEM
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
#include "os_base.h"
#include "os_time.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"
#include "actlog.h"

/* The following includes are needed for debugging. */

#include <stdlib.h>
#include <string.h>


/*---------------------------------------------------------------------------*/

#ifdef ___DEBUG_GARBAGE_COLLECT

/*
 * Defining the symbol ENABLE_CONSISTENCY_CHECKS will enable the GC to
 * perform checks that detect when the heap is in an inconsistent
 * state.  This is useful to detect bugs in the GC and the rest of the
 * system.  To perform the consistency checks, the verbosity level in
 * ___GSTATE->setup_params.debug_settings must be at least 1.  The checks are
 * very extensive and consequently are expensive.  They should only be
 * used for debugging.
 */

#define ENABLE_CONSISTENCY_CHECKS


/*
 * Defining the symbol SHOW_FRAMES will cause the GC to print out a
 * trace of the continuation frames that are processed.
 */

#undef SHOW_FRAMES


#define ENABLE_GC_TRACE_PHASES
#define ENABLE_GC_ACTLOG_PHASES
#define ENABLE_GC_ACTLOG_SCAN_COMPLETE_HEAP_CHUNK

#endif


/*---------------------------------------------------------------------------*/

/*
 * Object representation.
 *
 * Memory allocated Scheme objects can be allocated using one of three
 * allocation strategies:
 *
 *    Permanently allocated:
 *      These objects, called 'permanent objects' for short, are never
 *      moved or reclaimed, and all pointers to memory allocated
 *      objects they contain must point to permanent objects.  As a
 *      consequence, the GC does not have to scan permanent objects.
 *      Permanent objects can be allocated on the C heap, but they are
 *      typically allocated in C global variables and structures that
 *      are set up when the program starts up or when a module is
 *      dynamically loaded.
 *
 *    Still dynamically allocated:
 *      These objects, called 'still objects' for short, are allocated
 *      on the C heap.  Still objects are never moved but they can be
 *      reclaimed by the GC.  A mark-and-sweep GC is used to
 *      garbage-collect still objects.
 *
 *    Movable dynamically allocated:
 *      These objects, called 'movable objects' for short, are allocated
 *      in an area of memory that is managed by a compacting GC.  The GC
 *      can move and reclaim movable objects.
 *
 * Scheme objects are encoded using integers of type ___WORD.  A
 * ___WORD either encodes an immediate value or encodes a pointer
 * when the object is memory allocated.  The two lower bits of a
 * ___WORD contain a primary type tag for the object and the other
 * bits contain the immediate value or the pointer.  Because all
 * memory allocated objects are aligned on ___WORD boundaries (and a
 * ___WORD is either 4 or 8 bytes), the two lower bits of pointers
 * are zero and can be used to store the tag without reducing the
 * address space.  The four tags are:
 *
 *  immediate:
 *    ___tFIXNUM    object is a small integer (fixnum)
 *    ___tSPECIAL   object is a boolean, character, or other immediate
 *
 *  memory allocated:
 *    if ___USE_SAME_TAG_FOR_PAIRS_AND_SUBTYPED is defined
 *    ___tMEM1 = ___tSUBTYPED = ___tPAIR   subtyped object, possibly a pair
 *    ___tMEM2                             contained object, or a pair
 *    otherwise
 *    ___tMEM1 = ___tSUBTYPED              subtyped object, but not a pair
 *    ___tMEM2 = ___tPAIR                  a pair
 *
 * A special type of object exists to support object finalization:
 * 'will' objects.  Wills contain a weak reference to an object, the
 * testator and a strong reference to a procedure, the action
 * procedure.  A will becomes executable when its testator object is
 * not strongly reachable (i.e. the testator object is either
 * unreachable or only reachable using paths from the roots that
 * traverse at least one weak reference).  When the GC detects that a
 * will has become executable it is placed on a list of executable
 * wills.  Following the GC, this list is traversed to invoke the
 * action procedures.
 *
 * All memory allocated objects, including pairs, are composed of at
 * least a head and a body.  The head is a single ___WORD that
 * contains 3 "head" tag bits (the 3 lower bits), a subtype tag (the
 * next 5 bits), and the length of the object in bytes (the remaining
 * bits).  The head is followed by the body of the object, which
 * contains the rest of the information associated with the object.
 * Depending on the subtype, the body can contain raw binary data
 * (such as when the object is a string) and Scheme objects (such as
 * when the object is a vector).  Memory allocated objects have the
 * following layout:
 *
 *      _head_   _____body______
 *     /      \ /               \
 *    +--------+--------+--------+
 *    |llllssst|        |        |
 *    +--------+--------+--------+
 *      ^   ^ ^
 *      |   | |
 * length   | |
 *    subtype head tag
 *
 * Of the 8 possible head tags, only 5 are currently used:
 *
 *    ___PERM     (P) the object is a permanent object
 *    ___STILL    (S) the object is a still object
 *    ___MOVABLE0 (M) the object is a movable object in generation 0
 *    ___FORW     (F) the object has been moved by the GC (counts as 2 tags)
 *
 * Permanent objects have the following layout:
 *
 *      _head_   _____body______
 *     /      \ /               \
 *    +--------+--------+--------+
 *    |       P|        |        |
 *    +--------+--------+--------+
 *
 * Still objects have the following layout:
 *
 *      _link_   _ref__   length   _mark_   _head_   _____body______
 *     /      \ / count\ /      \ /      \ /      \ /               \
 *    +--------+--------+--------+--------+--------+--------+--------+
 *    |        |        |        |        |       S|        |        |
 *    +--------+--------+--------+--------+--------+--------+--------+
 *
 * All still objects are linked in a list using the 'link' field.  The
 * 'refcount' field contains a reference count, which counts the
 * number of pointers to this object that are hidden from the GC
 * (typically these hidden pointers are in C data structures).  When
 * 'refcount' is zero, the object will survive a GC only if it is
 * pointed to by a GC root or a live Scheme object.  The 'length'
 * field contains the length of the object and is only used to
 * maintain statistics on the space allocated.  The 'mark' field is
 * used by the GC to indicate that the object has been marked (at the
 * start of a GC it is set to -1).  The 'mark' field links all objects
 * that have been marked but have not yet been scanned.  It contains a
 * pointer to the next still object that needs to be scanned.
 *
 * Movable objects have the following layout:
 *
 *      _head_   _____body______
 *     /      \ /               \
 *    +--------+--------+--------+
 *    |       M|        |        |
 *    +--------+--------+--------+
 *
 * When a movable object is moved by the GC, the head is replaced
 * with a pointer to the copy, tagged with ___FORW.
 *
 * Layout of body.
 *
 *      _head_   __________body__________
 *     /      \ /                        \
 *    +--------+--------+--------+--------+
 *    |        | field_0| field_1|  etc.  |
 *    +--------+--------+--------+--------+
 *
 * Some types of objects have bodies that only contain pointers to
 * other Scheme objects.  For example, pairs have two fields (car and
 * cdr) and vectors have one field per element.  Other object types
 * have bodies that only contain raw binary data (such as strings and
 * bignums).  The remaining object types have bodies that contain both
 * pointers to Scheme objects and raw binary data.  Their layout is
 * summarized below.
 *
 * Symbols:
 *     subtype = ___sSYMBOL
 *     field_0 = name (a string or a fixnum <n> for a symbol named "g<n>")
 *     field_1 = hash code (non-negative fixnum)
 *     field_2 = link to next symbol in symbol table (#f for uninterned)
 *     field_3 = C pointer to global variable (0 if none exists)
 *
 *     Note: interned symbols must be permanently allocated;
 *           uninterned symbols can be permanent, still or movable
 *
 * Keywords:
 *     subtype = ___sKEYWORD
 *     field_0 = name (a string or a fixnum <n> for a keyword named "g<n>")
 *     field_1 = hash code (non-negative fixnum)
 *     field_2 = link to next symbol in keyword table (#f for uninterned)
 *
 * Procedures:
 *
 *   nonclosures (toplevel procedures)
 *     subtype = ___sPROCEDURE (length contains parameter descriptor)
 *     field_0 = C pointer to this object
 *     field_1 = C pointer to label (only when using gcc)
 *     field_2 = C pointer to host C procedure
 *
 *   closures:
 *     subtype = ___sPROCEDURE
 *     field_0 = C pointer to entry procedure
 *     field_1 = free variable 1
 *     field_2 = free variable 2
 *     ...
 *
 *     Note: the entry procedure must be a nonclosure procedure
 *
 * Return points:
 *     subtype = ___sRETURN
 *     field_0 = return frame descriptor
 *     field_1 = C pointer to label (only when using gcc)
 *     field_2 = C pointer to host C procedure
 *
 * Wills:
 *     subtype = ___sWEAK
 *     field_0 = C pointer to field_0 of next will in list
 *     field_1 = testator object
 *     field_2 = action procedure
 *
 *     Note: wills must be movable
 *
 * GC hash tables:
 *     subtype = ___sWEAK
 *     field_0 = C pointer to field_0 of next GC hash table in list
 *     field_1 = flags
 *     field_2 = count*2 (twice number of active key-value entries)
 *     field_3 = used*2 (twice number of total entries including deleted)
 *     field_4 = key of entry #0
 *     field_5 = value of entry #0
 *     ...
 *
 * Continuations:
 *     subtype = ___sCONTINUATION
 *     field_0 = first frame (C pointer to stack at first and then Scheme obj)
 *     field_1 = dynamic environment (#f when continuation is delimited)
 *
 * Frame:
 *     subtype = ___sFRAME
 *     field_0 = return address
 *     field_1 = frame slot 1
 *     field_2 = frame slot 2
 *     ...
 */


/*---------------------------------------------------------------------------*/

#define ___PSTATE_MEM(var) ___ps->mem.var
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var

#define tospace_offset          ___PSTATE_MEM(tospace_offset_)
#define msection_free_list      ___PSTATE_MEM(msection_free_list_)
#define stack_msection          ___PSTATE_MEM(stack_msection_)
#define alloc_stack_start       ___PSTATE_MEM(alloc_stack_start_)
#define alloc_stack_ptr         ___PSTATE_MEM(alloc_stack_ptr_)
#define alloc_stack_limit       ___PSTATE_MEM(alloc_stack_limit_)
#define heap_msection           ___PSTATE_MEM(heap_msection_)
#define alloc_heap_start        ___PSTATE_MEM(alloc_heap_start_)
#define alloc_heap_ptr          ___PSTATE_MEM(alloc_heap_ptr_)
#define alloc_heap_limit        ___PSTATE_MEM(alloc_heap_limit_)
#define alloc_heap_chunk_start  ___PSTATE_MEM(alloc_heap_chunk_start_)
#define alloc_heap_chunk_limit  ___PSTATE_MEM(alloc_heap_chunk_limit_)

#ifndef ___SINGLE_THREADED_VMS
#define heap_chunks_to_scan_lock ___PSTATE_MEM(heap_chunks_to_scan_lock_)
#endif

#define heap_chunks_to_scan     ___PSTATE_MEM(heap_chunks_to_scan_)
#define heap_chunks_to_scan_head ___PSTATE_MEM(heap_chunks_to_scan_head_)
#define heap_chunks_to_scan_tail ___PSTATE_MEM(heap_chunks_to_scan_tail_)
#define scan_ptr                ___PSTATE_MEM(scan_ptr_)
#define still_objs_to_scan      ___PSTATE_MEM(still_objs_to_scan_)
#define still_objs              ___PSTATE_MEM(still_objs_)
#define words_still_objs        ___PSTATE_MEM(words_still_objs_)
#define words_still_objs_deferred ___PSTATE_MEM(words_still_objs_deferred_)
#define bytes_allocated_minus_occupied ___PSTATE_MEM(bytes_allocated_minus_occupied_)
#define rc_head                 ___PSTATE_MEM(rc_head_)
#define traverse_weak_refs      ___PSTATE_MEM(traverse_weak_refs_)
#define nonexecutable_wills     ___PSTATE_MEM(nonexecutable_wills_)
#define executable_wills        ___PSTATE_MEM(executable_wills_)
#define reached_gc_hash_tables  ___PSTATE_MEM(reached_gc_hash_tables_)
#define words_prev_msections    ___PSTATE_MEM(words_prev_msections_)
#define stack_fudge_used        ___PSTATE_MEM(stack_fudge_used_)
#define heap_fudge_used         ___PSTATE_MEM(heap_fudge_used_)

#ifdef ___DEBUG_GARBAGE_COLLECT
#define reference_location      ___PSTATE_MEM(reference_location_)
#define container_body          ___PSTATE_MEM(container_body_)
#define mark_array_call_line    ___PSTATE_MEM(mark_array_call_line_)
#endif

#define heap_size               ___VMSTATE_MEM(heap_size_)
#define normal_overflow_reserve ___VMSTATE_MEM(normal_overflow_reserve_)
#define overflow_reserve        ___VMSTATE_MEM(overflow_reserve_)
#define occupied_words_movable  ___VMSTATE_MEM(occupied_words_movable_)
#define occupied_words_still    ___VMSTATE_MEM(occupied_words_still_)
#define the_msections           ___VMSTATE_MEM(the_msections_)
#define alloc_msection          ___VMSTATE_MEM(alloc_msection_)
#define nb_msections_assigned   ___VMSTATE_MEM(nb_msections_assigned_)
#define target_processor_count  ___VMSTATE_MEM(target_processor_count_)

#ifndef ___SINGLE_THREADED_VMS
#define misc_mem_lock           ___VMSTATE_MEM(misc_mem_lock_)
#define alloc_mem_lock          ___VMSTATE_MEM(alloc_mem_lock_)
#define scan_termination_mutex  ___VMSTATE_MEM(scan_termination_mutex_)
#define scan_termination_condvar ___VMSTATE_MEM(scan_termination_condvar_)
#define scan_workers_count      ___VMSTATE_MEM(scan_workers_count_)
#endif

#define nb_gcs                  ___VMSTATE_MEM(nb_gcs_)
#define gc_user_time            ___VMSTATE_MEM(gc_user_time_)
#define gc_sys_time             ___VMSTATE_MEM(gc_sys_time_)
#define gc_real_time            ___VMSTATE_MEM(gc_real_time_)

#define latest_gc_user_time     ___VMSTATE_MEM(latest_gc_user_time_)
#define latest_gc_sys_time      ___VMSTATE_MEM(latest_gc_sys_time_)
#define latest_gc_real_time     ___VMSTATE_MEM(latest_gc_real_time_)
#define latest_gc_heap_size     ___VMSTATE_MEM(latest_gc_heap_size_)
#define latest_gc_alloc         ___VMSTATE_MEM(latest_gc_alloc_)
#define latest_gc_live          ___VMSTATE_MEM(latest_gc_live_)
#define latest_gc_movable       ___VMSTATE_MEM(latest_gc_movable_)
#define latest_gc_still         ___VMSTATE_MEM(latest_gc_still_)

#define custom_msection_alloc   ___VMSTATE_MEM(custom_msection_alloc_)

/* words occupied by this processor by movable objects */

#define words_movable_objs(ps) \
(2*(ps->mem.words_prev_msections_ \
    + (ps->mem.alloc_heap_ptr_ - ps->mem.alloc_heap_start_) \
    + (ps->mem.alloc_stack_start_ - ps->mem.alloc_stack_ptr_)))

/* bytes occupied by this processor */

#define bytes_occupied(ps) \
(___CAST(___F64,ps->mem.words_still_objs_ \
                + ps->mem.words_still_objs_deferred_ \
                + words_movable_objs(___ps)) * ___WS)

/*---------------------------------------------------------------------------*/

#ifdef ___SINGLE_THREADED_VMS

#define ALLOC_MEM_LOCK()
#define ALLOC_MEM_UNLOCK()
#define MISC_MEM_LOCK()
#define MISC_MEM_UNLOCK()

#else

#define ALLOC_MEM_LOCK() ___SPINLOCK_LOCK(alloc_mem_lock)
#define ALLOC_MEM_UNLOCK() ___SPINLOCK_UNLOCK(alloc_mem_lock)
#define MISC_MEM_LOCK() ___SPINLOCK_LOCK(misc_mem_lock)
#define MISC_MEM_UNLOCK() ___SPINLOCK_UNLOCK(misc_mem_lock)

#endif


/*---------------------------------------------------------------------------*/

/*
 * Memory for movable objects (including continuation frames) are
 * allocated in fixed size msections.  Each processor starts off with
 * an msection for its stack (for allocating continuation frames) and
 * an msection for allocating small objects.  Stack allocations are
 * done by decrementing the stack pointer and small objects are
 * allocated by incrementing the heap pointer.  Each msection is
 * divided in two zones of equal size, used as a fromspace and tospace
 * by the garbage collector.  When a processor fills a fromspace, a
 * new msection is obtained from a list of free msections to continue
 * allocating.  The diagram below shows a possible layout of msections
 * for a situation with 3 processors and 12 msections:
 *
 *      sp                                                       hp
 *       v                                                       v
 *   +---+---+-------+  +-----+-+-------+  +----+--+-------+  +--+----+-------+
 * 0 |   |###|       |  |#####| |       |  |####|  |       |  |##|    |       |
 *   +---+---+-------+  +-----+-+-------+  +----+--+-------+  +--+----+-------+
 *
 *    sp                   hp
 *     v                   v
 *   +-+-----+-------+  +--+----+-------+
 * 1 | |#####|       |  |##|    |       |
 *   +-+-----+-------+  +--+----+-------+
 *
 *       sp                                      hp
 *        v                                      v
 *   +----+--+-------+  +----+--+-------+  +-----+-+-------+
 * 2 |    |##|       |  |####|  |       |  |#####| |       |
 *   +----+--+-------+  +----+--+-------+  +-----+-+-------+
 *
 *
 * free list of msections (msections yet to be assigned to processors):
 *   +-------+-------+  +-------+-------+  +-------+-------+
 *   |       |       |  |       |       |  |       |       |
 *   +-------+-------+  +-------+-------+  +-------+-------+
 *
 *
 * In this example, 4 msections are assigned to processor 0.  The first one
 * is being used as a stack to allocate continuation frames.  The other
 * msections of that processor are being used for allocating small objects
 * (two msections are full and the last is not yet full).  There are
 * three msections in the free list of msections.
 *
 * The heap size is defined as the space occupied by still objects and
 * msections at the end of the latest garbage collection.  To determine
 * when to trigger a garbage collection, the memory manager needs to know
 * approximately (but conservatively) how much of the heap is free.  The
 * free heap space is defined as the heap size minus the space of the
 * msections assigned to processors minus the space occupied by still
 * objects minus the overflow reserve.  When an allocation request would
 * cause the free heap space to become negative, a garbage collection is
 * performed first to free space and possibly resize the heap.
 *
 * A given msection can be used for allocating small objects or for
 * allocating continuation frames or for both.  The position of the
 * various pointers is as follows (only the fromspace is shown).
 *
 * Msection only used for allocating movable objects:
 *
 *   <-------------------------- ___MSECTION_SIZE/2 ------------------------->
 *  +----+----+---------------------------------------------------------------+
 *  |obj1|obj2|                                         |<-___MSECTION_FUDGE->|
 *  +----+----+---------------------------------------------------------------+
 *  ^         ^                                         ^                     ^
 *  |         |                                         |                     |
 *  |         alloc_heap_ptr            ___ps->heap_limit      alloc_heap_limit
 *  alloc_heap_start
 *
 * Msection only used for allocating continuation frames:
 *
 *   <-------------------------- ___MSECTION_SIZE/2 ------------------------->
 *  +-----------------------------------------------------------+------+------+
 *  |<-___MSECTION_FUDGE->|                                     |frame2|frame1|
 *  +-----------------------------------------------------------+------+------+
 *  ^                     ^                                     ^             ^
 *  |                     |                                     |             |
 *  alloc_stack_limit     ___ps->stack_limit      alloc_stack_ptr             |
 *                                                            alloc_stack_start
 *
 * Msection used for allocating movable objects and allocating
 * continuation frames:
 *
 *   <-------------------------- ___MSECTION_SIZE/2 ------------------------->
 *  +----+-------------------------------------------------------------+------+
 *  |objs|        |<-___MSECTION_FUDGE->|<-___MSECTION_FUDGE->|        |frames|
 *  +----+-------------------------------------------------------------+------+
 *  ^    ^        ^                     ^                     ^        ^      ^
 *  |    |        |                     |                     |        |      |
 *  |    |        |     alloc_heap_limit alloc_stack_limit    |        |      |
 *  |    |        ___ps->heap_limit          ___ps->stack_limit        |      |
 *  |    alloc_heap_ptr                                  alloc_stack_ptr      |
 *  alloc_heap_start                                          alloc_stack_start
 */

#define compute_heap_space() \
(___CAST(___SIZE_TS,the_msections->nb_sections) * ___MSECTION_SIZE + occupied_words_still)

#define compute_assigned_heap_space() \
(___CAST(___SIZE_TS,nb_msections_assigned) * ___MSECTION_SIZE + occupied_words_still)

#define compute_free_heap_space() \
(heap_size - compute_assigned_heap_space() - overflow_reserve)

/*---------------------------------------------------------------------------*/

/* Constants related to representation of permanent and still objects: */

#ifdef ___USE_HANDLES
#define ___PERM_HANDLE 0
#define ___PERM_BODY 2
#else
#define ___PERM_HANDLE ___PERM_BODY
#define ___PERM_BODY 1
#endif
#define ___PERM_HEADER (___PERM_BODY-1)

#define ___STILL_LINK 0
#define ___STILL_REFCOUNT 1
#define ___STILL_LENGTH 2
#define ___STILL_MARK 3
#ifdef ___USE_HANDLES
#define ___STILL_HANDLE 4
#define ___STILL_BODY 6
#else
#define ___STILL_HANDLE ___STILL_BODY
#define ___STILL_BODY (5+1)/************/
#endif
#define ___STILL_HEADER (___STILL_BODY-1)


/*---------------------------------------------------------------------------*/

/* Allocation and reclamation of aligned blocks of memory.  */


/*
 * 'alloc_mem_aligned_aux (words, multiplier, modulus, heap)'
 * allocates an aligned block of memory (using '___alloc_mem' when
 * heap is false, and '___alloc_mem_heap' when heap is true).  'words'
 * is the size of the block in words and 'multiplier' and 'modulus'
 * specify its alignment in words.  'multiplier' must be a power of
 * two and 0<=modulus<multiplier.  The pointer returned corresponds to
 * an address that is equal to (i*multiplier+modulus)*sizeof (___WORD)
 * for some 'i'.
 */

___HIDDEN void *alloc_mem_aligned_aux
   ___P((___SIZE_TS words,
         unsigned int multiplier,
         unsigned int modulus,
         ___BOOL heap),
        (words,
         multiplier,
         modulus,
         heap)
___SIZE_TS words;
unsigned int multiplier;
unsigned int modulus;
___BOOL heap;)
{
  void *container; /* pointer to block returned by ___alloc_mem{_heap} */
  unsigned int extra; /* space for alignment to multiplier */

  /* Make sure alignment is sufficient for pointers */

  if (multiplier < sizeof (void*) / ___WS)
    multiplier = sizeof (void*) / ___WS;

  /* How many extra bytes are needed for padding */

  extra = (multiplier * ___WS) - 1;
  if (modulus < sizeof (void*) / ___WS)
    extra += sizeof (void*);

  if (heap)
    container = ___ALLOC_MEM_HEAP(extra + (words+modulus) * ___WS);
  else
    container = ___ALLOC_MEM(extra + (words+modulus) * ___WS);

  if (container == 0)
    return 0;
  else
    {
      void *ptr = ___CAST(void*,
                          (((___CAST(___WORD,container) + extra) &
                            -___CAST(___WORD,multiplier * ___WS)) +
                           modulus * ___WS));
      void **cptr = ___CAST(void**,
                            (___CAST(___WORD,ptr) - ___CAST(___WORD,sizeof (void*))) &
                            -___CAST(___WORD,sizeof (void*)));

      *cptr = container;
      return ptr;
    }
}


___HIDDEN void *alloc_mem_aligned
   ___P((___SIZE_TS words,
         unsigned int multiplier,
         unsigned int modulus),
        (words,
         multiplier,
         modulus)
___SIZE_TS words;
unsigned int multiplier;
unsigned int modulus;)
{
  return alloc_mem_aligned_aux (words, multiplier, modulus, 0);
}


___HIDDEN void *alloc_mem_aligned_heap
   ___P((___SIZE_TS words,
         unsigned int multiplier,
         unsigned int modulus),
        (words,
         multiplier,
         modulus)
___SIZE_TS words;
unsigned int multiplier;
unsigned int modulus;)
{
  return alloc_mem_aligned_aux (words, multiplier, modulus, 1);
}


/*
 * 'free_mem_aligned (ptr)' reclaims the aligned block of memory 'ptr'
 * that was allocated using 'alloc_mem_aligned'.
 */

___HIDDEN void free_mem_aligned
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  void **cptr = ___CAST(void**,
                        (___CAST(___WORD,ptr) - ___CAST(___WORD,sizeof (void*))) &
                        -___CAST(___WORD,sizeof (void*)));
  ___FREE_MEM(*cptr);
}


/*
 * 'free_mem_aligned_heap (ptr)' reclaims the aligned block of memory
 * 'ptr' that was allocated using 'alloc_mem_aligned_heap'.
 */

___HIDDEN void free_mem_aligned_heap
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  void **cptr = ___CAST(void**,
                        (___CAST(___WORD,ptr) - ___CAST(___WORD,sizeof (void*))) &
                        -___CAST(___WORD,sizeof (void*)));
  ___FREE_MEM_HEAP(*cptr);
}


/*---------------------------------------------------------------------------*/

/* Allocation of reference counted blocks of memory. */

___HIDDEN void setup_rc
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  rc_head.prev = &rc_head;
  rc_head.next = &rc_head;
  rc_head.refcount = 1;
  rc_head.data = ___FAL;
}

___HIDDEN void cleanup_rc
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___rc_header *h = rc_head.next;

  rc_head.prev = &rc_head;
  rc_head.next = &rc_head;

  while (h != &rc_head)
    {
      ___rc_header *next = h->next;
      ___FREE_MEM(h);
      h = next;
    }
}


___EXP_FUNC(void*,___alloc_rc_no_register)
   ___P((___SIZE_T bytes),
        (bytes)
___SIZE_T bytes;)
{
  ___rc_header *h = ___CAST(___rc_header*,
                            ___ALLOC_MEM(bytes + sizeof (___rc_header)));

  if (h != 0)
    {
      h->refcount = 1;
      h->data = ___FAL;

      return ___CAST(void*,h+1);
    }

  return 0;
}


___EXP_FUNC(void,___register_rc)
   ___P((___PSD
         void *ptr),
        (___PSV
         ptr)
___PSDKR
void *ptr;)
{
  ___PSGET
  ___rc_header *h = ___CAST(___rc_header*, ptr) - 1;
  ___rc_header *head = &rc_head;
  ___rc_header *tail = head->prev;

  h->prev = tail;
  h->next = head;
  head->prev = h;
  tail->next = h;
}


___EXP_FUNC(void*,___alloc_rc)
   ___P((___PSD
         ___SIZE_T bytes),
        (___PSV
         bytes)
___PSDKR
___SIZE_T bytes;)
{
  ___PSGET
  void *ptr = ___alloc_rc_no_register (bytes);

  if (ptr != 0) ___register_rc (___PSP ptr);

  return ptr;
}


___EXP_FUNC(void,___release_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  if (ptr != 0)
    {
      ___rc_header *h = ___CAST(___rc_header*,ptr) - 1;

      if (--h->refcount == 0)
        {
          ___rc_header *prev = h->prev;
          ___rc_header *next = h->next;

          next->prev = prev;
          prev->next = next;

          ___FREE_MEM(h);
        }
    }
}


___EXP_FUNC(void,___addref_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  if (ptr != 0)
    {
      ___rc_header *h = ___CAST(___rc_header*,ptr) - 1;
      h->refcount++;
    }
}


___EXP_FUNC(int,___refcount_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  ___rc_header *h = ___CAST(___rc_header*,ptr) - 1;
  return h->refcount;
}


___EXP_FUNC(___SCMOBJ,___data_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  ___rc_header *h = ___CAST(___rc_header*,ptr) - 1;
  return h->data;
}


___EXP_FUNC(void,___set_data_rc)
   ___P((void *ptr,
         ___SCMOBJ val),
        (ptr,
         val)
void *ptr;
___SCMOBJ val;)
{
  ___rc_header *h = ___CAST(___rc_header*,ptr) - 1;
  h->data = val;
}


/*---------------------------------------------------------------------------*/

/* Allocation of movable objects.  */

/*
 * 'find_msection (ms, ptr)' finds the position in the 'ms->sections'
 * array of the msection that contains the pointer 'ptr'.  More
 * precisely, if ___ALLOC_MEM_UP is defined, it returns the integer
 * 'i' (-1<=i<=n-1) such that 'ptr' is between the start of section i
 * and section i+1.  -1 is returned if 'ptr' is lower than the lowest
 * section and 'n' is returned if 'ptr' is not lower than the highest
 * section.  If ___ALLOC_MEM_UP is not defined, it returns the integer
 * 'i' (0<=i<=n) such that 'ptr' is between the start of section i and
 * section i-1.  n is returned if 'ptr' is lower than the lowest
 * section and 0 is returned if 'ptr' is not lower than the highest
 * section.
 */

___HIDDEN int find_msection
   ___P((___msections *ms,
         void *ptr),
        (ms,
         ptr)
___msections *ms;
void *ptr;)
{
  int ns = ms->nb_sections;
  ___msection **sections = ms->sections;
  int lo, hi;

#ifdef ___ALLOC_MEM_UP
  if (ns == 0 ||
      ptr < ___CAST(void*,sections[0]))
    return -1;
#else
  if (ns == 0 ||
      ptr < ___CAST(void*,sections[ns-1]))
    return ns;
#endif

  /* binary search */

  lo = 0;
  hi = ns-1;

  /* loop invariant: lo <= find_msection (ms, ptr) <= hi */

  while (lo < hi)
    {
      int mid = (lo+hi) / 2; /* lo <= mid < hi */
#ifdef ___ALLOC_MEM_UP
      if (ptr < ___CAST(void*,sections[mid+1])) hi = mid; else lo = mid+1;
#else
      if (ptr < ___CAST(void*,sections[mid])) lo = mid+1; else hi = mid;
#endif
    }

  return lo;
}


/*
 * 'adjust_msections (msp, n)' contracts or expands the msections
 * pointed to by 'msp' so that it contains 'n' sections.  When the
 * msections is contracted, the last sections allocated (i.e. those at
 * the end of the doubly-linked list of sections) will be reclaimed.
 * When expanding the msections there may not be enough memory to
 * allocate new sections so the operation may fail.  However
 * 'adjust_msections' will always leave the msections in a consistent
 * state and there will be at least as many sections as when the
 * expansion was started.  Failure can be detected by checking the
 * 'nb_sections' field.
 */

___HIDDEN void adjust_msections
   ___P((___msections **msp,
         int n),
        (msp,
         n)
___msections **msp;
int n;)
{
  int max_ns, ns;
  ___msections *ms = *msp;
  ___msection *hd;
  ___msection *tl;

  if (ms == 0)
    {
      max_ns = 0;
      ns = 0;
      hd = 0;
      tl = 0;
    }
  else
    {
      max_ns = ms->max_nb_sections;
      ns = ms->nb_sections;
      hd = ms->head;
      tl = ms->tail;
    }

  if (ms == 0 || n > max_ns)
    {
      /* must allocate a new msections structure */

      ___msections *new_ms;
      int i;

      while (n > max_ns) /* grow max_nb_sections until big enough */
        max_ns = 2*max_ns + 1;

      new_ms = ___CAST(___msections*,
                       alloc_mem_aligned
                         (___WORDS(___sizeof_msections(max_ns)),
                          1,
                          0));

      if (new_ms == 0)
        return;

      new_ms->max_nb_sections = max_ns;
      new_ms->nb_sections = ns;
      new_ms->head = hd;
      new_ms->tail = tl;

      for (i=ns-1; i>=0; i--)
        new_ms->sections[i] = ms->sections[i];

      if (ms != 0)
        free_mem_aligned (ms);

      ms = new_ms;

      *msp = ms;
    }

  if (n < ns)
    {
      /* contraction of the msections */

      int j;

      while (ns > n)
        {
          ___msection *s = tl;

          tl = tl->prev;

          if (tl == 0)
            hd = 0;
          else
            tl->next = 0;

          for (j=s->pos; j<ns-1; j++)
            {
              ms->sections[j] = ms->sections[j+1];
              ms->sections[j]->pos = j;
            }

          free_mem_aligned_heap (s);

          ns--;
        }

      ms->nb_sections = ns;
      ms->head = hd;
      ms->tail = tl;

      /*
       * Contraction of the msections structure is not performed
       * because there is typically very little memory to be
       * reclaimed.
       */
    }
  else
    {
      /* expansion of the msections */

      int i, j;

      while (ns < n)
        {
          ___msection *s = ___CAST(___msection*,
                                   alloc_mem_aligned_heap
                                     (___WORDS(___sizeof_msection(___MSECTION_SIZE)),
                                      1,
                                      0));

          if (s == 0)
            return;

          i = find_msection (ms, ___CAST(void*,s));

#ifdef ___ALLOC_MEM_UP
          i++;
#endif

          for (j=ns; j>i; j--)
            {
              ms->sections[j] = ms->sections[j-1];
              ms->sections[j]->pos = j;
            }

          ms->sections[i] = s;

          if (tl == 0)
            {
              hd = s;
              s->index = 0;
            }
          else
            {
              tl->next = s;
              s->index = tl->index + 1;
            }

          s->pos = i;
          s->prev = tl;
          s->next = 0;

          tl = s;

          ms->nb_sections = ++ns;
          ms->head = hd;
          ms->tail = tl;
        }
    }
}


/*
 * 'free_msections (msp)' releases all memory associated with the
 * msections pointed to by 'msp'.
 */

___HIDDEN void free_msections
   ___P((___msections **msp),
        (msp)
___msections **msp;)
{
  ___msections *ms = *msp;

  if (ms != 0)
    {
      int i;

      for (i=ms->nb_sections-1; i>=0; i--)
        free_mem_aligned_heap (ms->sections[i]);

      free_mem_aligned (ms);

      *msp = 0;
    }
}


/*---------------------------------------------------------------------------*/

/* Allocation of permanent objects.  */

/*
 * 'alloc_mem_aligned_psection (words, multiplier, modulus)' allocates
 * an aligned block of memory inside a new psection.  'words' is the
 * size of the block in words and 'multiplier' and 'modulus' specify
 * its alignment in words.  'multiplier' must be a power of two and
 * 0<=modulus<multiplier.  The pointer returned corresponds to an
 * address that is equal to (i*multiplier+modulus)*sizeof (___WORD) for
 * some 'i'.
 */

___HIDDEN void *alloc_mem_aligned_psection
   ___P((___SIZE_TS words,
         unsigned int multiplier,
         unsigned int modulus),
        (words,
         multiplier,
         modulus)
___SIZE_TS words;
unsigned int multiplier;
unsigned int modulus;)
{
  void *container;

  /* Make sure alignment is sufficient for pointers */

  if (multiplier < sizeof (void*) / ___WS)
    multiplier = sizeof (void*) / ___WS;

  /* Make space for psection link and modulus */

  if (modulus < (sizeof (void*) + ___WS - 1) / ___WS)
    modulus += ((sizeof (void*) + multiplier * ___WS - 1) / ___WS) &
               -multiplier;

  /* Allocate container */

  container = alloc_mem_aligned_heap (words+modulus, multiplier, 0);

  if (container == 0)
    return 0;

  *___CAST(void**,container) = ___GSTATE->mem.psections;
  ___GSTATE->mem.psections = container;
  return ___CAST(void*,___CAST(___WORD*,container) + modulus);
}


/*
 * 'alloc_mem_aligned_perm (words, multiplier, modulus)' allocates an
 * aligned block of memory inside a psection.  If there is enough free
 * space in a previously allocated psection that psection is used,
 * otherwise a new psection is allocated.  'words' is the size of the
 * block in words and 'multiplier' and 'modulus' specify its alignment
 * in words.  'multiplier' must be a power of two and
 * 0<=modulus<multiplier.  The pointer returned corresponds to an
 * address that is equal to (i*multiplier+modulus)*sizeof (___WORD) for
 * some 'i'.
 */

___HIDDEN void *alloc_mem_aligned_perm
   ___P((___SIZE_TS words,
         int multiplier,
         int modulus),
        (words,
         multiplier,
         modulus)
___SIZE_TS words;
int multiplier;
int modulus;)
{
  ___SIZE_TS waste;
  ___WORD *base;

  /*
   * Try to satisfy request in current psection.
   */

  if (___GSTATE->mem.palloc_ptr != 0)
    {
      ___WORD *new_palloc_ptr;

      base = ___CAST(___WORD*,
                     ___CAST(___WORD,___GSTATE->mem.palloc_ptr+multiplier-1-modulus) &
                     (multiplier * -___WS)) +
             modulus;

      new_palloc_ptr = base + words;

      if (new_palloc_ptr <= ___GSTATE->mem.palloc_limit) /* did it fit in the psection? */
        {
          ___GSTATE->mem.palloc_ptr = new_palloc_ptr;
          return base;
        }

      waste = ___GSTATE->mem.palloc_limit - ___GSTATE->mem.palloc_ptr;
    }
  else
    waste = 0;

  /*
   * Request can't be satisfied in current psection so we must
   * allocate a new psection.
   */

  if (waste > ___PSECTION_WASTE || words > ___PSECTION_SIZE)
    return alloc_mem_aligned_psection (words, multiplier, modulus);

  base = ___CAST(___WORD*,
                 alloc_mem_aligned_psection
                   (___PSECTION_SIZE,
                    multiplier,
                    modulus));

  if (base != 0)
    {
      ___GSTATE->mem.palloc_ptr = base + words;
      ___GSTATE->mem.palloc_limit = base + ___PSECTION_SIZE;
    }

  return base;
}


___HIDDEN void free_psections ___PVOID
{
  void *base = ___GSTATE->mem.psections;

  ___GSTATE->mem.psections = 0;

  while (base != 0)
    {
      void *link = *___CAST(void**,base);
      free_mem_aligned_heap (base);
      base = link;
    }
}


void ___glo_list_setup ___PVOID
{
  int i;

  ___GSTATE->mem.glo_list.count = 0;

  for (i=___GLO_SUBLIST_COUNT-1; i>=0; i--)
    {
      ___glo_sublist_struct *sl = &___GSTATE->mem.glo_list.sublist[i];
      sl->head = 0;
      sl->tail = 0;
    }
}


void ___glo_list_add
   ___P((___glo_struct *glo),
        (glo)
___glo_struct *glo;)
{
  int i = ___GSTATE->mem.glo_list.count++ % ___GLO_SUBLIST_COUNT;
  ___glo_sublist_struct *sl = &___GSTATE->mem.glo_list.sublist[i];

  glo->next = 0;

  if (sl->head == 0)
    sl->head = glo;
  else
    sl->tail->next = glo;

  sl->tail = glo;
}


___glo_struct *___glo_list_search_obj
   ___P((___PSD
         ___SCMOBJ obj,
         ___BOOL prm),
        (___PSV
         obj,
         prm)
___PSDKR
___SCMOBJ obj;
___BOOL prm;)
{
  ___PSGET

  ___glo_struct *glo = 0;
  int glo_depth = 999999999;
  int i;

  for (i=___GLO_SUBLIST_COUNT-1; i>=0; i--)
    {
      ___glo_sublist_struct *sl = &___GSTATE->mem.glo_list.sublist[i];
      ___glo_struct *probe = sl->head;
      int probe_depth = 0;

      if (prm)
        {
          while (probe != 0 && ___PRMCELL(probe->prm) != obj)
            {
              probe = probe->next;
              if (++probe_depth > glo_depth) break;
            }
        }
      else
        {
          while (probe != 0 && ___GLOCELL(probe->val) != obj)
            {
              probe = probe->next;
              if (++probe_depth > glo_depth) break;
            }
        }

      if (probe != 0)
        {
          if (glo == 0 || probe_depth <= glo_depth)
            {
              glo = probe;
              glo_depth = probe_depth;
            }
        }
    }

  return glo;
}


___SCMOBJ ___glo_struct_to_global_var
   ___P((___glo_struct *glo),
        (glo)
___glo_struct *glo;)
{
  ___SCMOBJ result = ___FAL;

  if (glo != 0)
    {
      int len = ___INT(___VECTORLENGTH(___GSTATE->symbol_table));
      int i;

      for (i=1; i<len; i++)
        {
          ___SCMOBJ probe = ___FIELD(___GSTATE->symbol_table,i);

          while (probe != ___NUL)
            {
              if (___GLOBALVARSTRUCT(probe) == glo)
                {
                  result = probe;
                  goto end_search;
                }
              probe = ___FIELD(probe,___SYMKEY_NEXT);
            }
        }
    end_search:;
    }

  return result;
}


___SCMOBJ ___obj_to_global_var
   ___P((___PSD
         ___SCMOBJ obj,
         ___BOOL prm),
        (___PSV
         obj,
         prm)
___PSDKR
___SCMOBJ obj;
___BOOL prm;)
{
  ___PSGET

  /*
   * Find the global variable that is bound to the object obj.
   * If prm is true then the prm field of the global variable
   * is checked, otherwise the val field is checked.
   */

  return ___glo_struct_to_global_var (___glo_list_search_obj (___PSP obj, prm));
}


___SCMOBJ ___make_global_var
   ___P((___SCMOBJ sym),
        (sym)
___SCMOBJ sym;)
{
  if (___GLOBALVARSTRUCT(sym) == 0)
    {
      ___glo_struct *glo = ___CAST(___glo_struct*,
                                   alloc_mem_aligned_perm
                                     (___WORDS(sizeof (___glo_struct)),
                                      1,
                                      0));

      if (glo == 0)
        return ___FIX(___HEAP_OVERFLOW_ERR);

#ifdef ___SINGLE_VM
      glo->val = ___UNB1;
#else
      glo->val = ___GSTATE->mem.glo_list.count;
#endif

      ___glo_list_add (glo);

      ___PRMCELL(glo->prm) = ___FAL;

      ___FIELD(sym,___SYMBOL_GLOBAL) = ___CAST(___SCMOBJ,glo);
    }

  return sym;
}


#ifdef ___USE_find_global_var_bound_to

___SCMOBJ ___find_global_var_bound_to
   ___P((___SCMOBJ val),
        (val)
___SCMOBJ val;)
{
  ___SCMOBJ sym = ___NUL;
  int i;

  for (i = ___INT(___VECTORLENGTH(___GSTATE->symbol_table)) - 1; i>0; i--)
    {
      sym = ___FIELD(___GSTATE->symbol_table,i);

      while (sym != ___NUL)
       {
          ___glo_struct *g = ___GLOBALVARSTRUCT(sym);

          if (g != 0 &&
              (___PRMCELL(g->prm) == val || ___GLOCELL(g->val) == val))
            {
              i = 0;
              break;
            }

          sym = ___FIELD(sym,___SYMKEY_NEXT);
        }
    }

  return sym;
}

#endif


/*---------------------------------------------------------------------------*/

/*
 * '___still_obj_refcount_inc (obj)' increments the reference count of
 * the still object 'obj'.
 */

___EXP_FUNC(void,___still_obj_refcount_inc)
   ___P((___WORD obj),
        (obj)
___WORD obj;)
{
  ___BODY0(obj)[___STILL_REFCOUNT-___STILL_BODY]++;
}


/*
 * '___still_obj_refcount_dec (obj)' decrements the reference count of
 * the still object 'obj'.
 */

___EXP_FUNC(void,___still_obj_refcount_dec)
   ___P((___WORD obj),
        (obj)
___WORD obj;)
{
  ___BODY0(obj)[___STILL_REFCOUNT-___STILL_BODY]--;
}


/*
 * '___still_obj_refcount (obj)' returns the reference count of
 * the still object 'obj'.
 */

___EXP_FUNC(___WORD,___still_obj_refcount)
   ___P((___WORD obj),
        (obj)
___WORD obj;)
{
  return ___BODY0(obj)[___STILL_REFCOUNT-___STILL_BODY];
}


/*---------------------------------------------------------------------------*/

/*
 * '___alloc_scmobj (___ps, subtype, bytes)' allocates a permanent or
 * still Scheme object (depending on '___ps') of subtype 'subtype'
 * with a body containing 'bytes' bytes, and returns it as an encoded
 * Scheme object.  When '___ps' is NULL, a permanent object is
 * allocated, and when '___ps' is not NULL, a still object is
 * allocated in the heap of that processor's VM.  The initialization
 * of the object's body must be done by the caller.  In the case of
 * still objects this initialization must be done before the next
 * allocation is requested.  The 'refcount' field of still objects is
 * initially 1.  A fixnum error code is returned when there is an
 * error.
 */

___HIDDEN ___WORD alloc_scmobj_perm
   ___P((int subtype,
         ___SIZE_TS bytes),
        (subtype,
         bytes)
int subtype;
___SIZE_TS bytes;)
{
  void *ptr;
  ___WORD *base;
  ___WORD *body;
  ___SIZE_TS words = ___PERM_BODY + ___WORDS(bytes);

  /*
   * Some objects, such as ___sFOREIGN, ___sS64VECTOR, ___sU64VECTOR,
   * ___sF64VECTOR, ___sFLONUM and ___sBIGNUM, must have a body that
   * is aligned on a multiple of 8 on some machines.  Here, we force
   * alignment to a multiple of 8 even if not necessary in all cases
   * because it is typically more efficient due to a better
   * utilization of the cache.
   */

  ptr = alloc_mem_aligned_perm (words,
                                8>>___LWS,
                                (-___PERM_BODY)&((8>>___LWS)-1));

  if (ptr == 0)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  base = ___CAST(___WORD*,ptr);
  body = base + ___PERM_BODY;

#ifdef ___USE_HANDLES
  base[___PERM_HANDLE] = ___CAST(___WORD,body);
#endif

  base[___PERM_HEADER] = ___MAKE_HD(bytes, subtype, ___PERM);

  if (subtype == ___sPAIR)
    return ___PAIR_FROM_BODY(body);
  else
    return ___SUBTYPED_FROM_BODY(body);
}


___HIDDEN ___WORD alloc_scmobj_still
   ___P((___processor_state ___ps,
         int subtype,
         ___SIZE_TS bytes),
        (___ps,
         subtype,
         bytes)
___processor_state ___ps;
int subtype;
___SIZE_TS bytes;)
{
  void *ptr;
  ___WORD *base;
  ___WORD *body;
  ___SIZE_TS words = ___STILL_BODY + ___WORDS(bytes);
  ___SIZE_TS words_including_deferred = words + words_still_objs_deferred;

#ifdef CALL_GC_FREQUENTLY
  if (--___gc_calls_to_punt < 0) goto invoke_gc;
#endif

  if (words_including_deferred <= ___MAX_STILL_DEFERRED)
    {
      /*
       * Allocate the still object and defer its accounting at the VM
       * level.
       */

      /*
       * Some objects, such as ___sFOREIGN, ___sS64VECTOR,
       * ___sU64VECTOR, ___sF64VECTOR, ___sFLONUM and ___sBIGNUM, must
       * have a body that is aligned on a multiple of 8 on some
       * machines.  Here, we force alignment to a multiple of 8 even
       * if not necessary in all cases because it is typically more
       * efficient due to a better utilization of the cache.
       */

      if ((ptr = alloc_mem_aligned_heap (words,
                                         8>>___LWS,
                                         (-___STILL_BODY)&((8>>___LWS)-1)))
          == 0)
        {
          /*
           * Couldn't allocate the still object (probably the C heap is full).
           */

          return ___FIX(___HEAP_OVERFLOW_ERR);
        }

      words_still_objs_deferred = words_including_deferred;
    }
  else
    {
      /*
       * The space for the still object (and the deferred previous
       * ones) is considerable, so the availability of the space must
       * be checked at the VM level.  The VM's memory allocation lock
       * must be acquired to ensure correct bookkeeping.
       */

      ALLOC_MEM_LOCK();

      if (words_including_deferred <= compute_free_heap_space())
        {
          /*
           * There is sufficient free heap space, so no need to call GC.
           */

          occupied_words_still += words_including_deferred;

          ALLOC_MEM_UNLOCK();

          /*
           * Space accounting for previous still objects is now accounted
           * for at the VM level.
           */

          words_still_objs_deferred = 0;
        }
      else
        {
          /*
           * There is insufficient free heap space, so call GC.
           */

          ALLOC_MEM_UNLOCK();

#ifdef CALL_GC_FREQUENTLY
        invoke_gc:
#endif

          if (___garbage_collect (___PSP words))
            return ___FIX(___HEAP_OVERFLOW_ERR);
        }

      /*
       * Allocate the still object.  See comments above for other call
       * to alloc_mem_aligned_heap.
       */

      if ((ptr = alloc_mem_aligned_heap (words,
                                         8>>___LWS,
                                         (-___STILL_BODY)&((8>>___LWS)-1)))
          == 0)
        {
          /*
           * Couldn't allocate the still object (probably the C heap is full).
           * So undo its accounting at the VM level.
           */

          ALLOC_MEM_LOCK();

          occupied_words_still -= words;

          ALLOC_MEM_UNLOCK();

          return ___FIX(___HEAP_OVERFLOW_ERR);
        }
    }

  /* Initialize still object and add it to the still_objs list. */

  base = ___CAST(___WORD*,ptr);
  body = base + ___STILL_BODY;

  base[___STILL_LINK] = still_objs;
  still_objs = ___CAST(___WORD,base);
  base[___STILL_REFCOUNT] = 1;
  base[___STILL_LENGTH] = words;

#ifdef ___USE_HANDLES
  base[___STILL_HANDLE] = ___CAST(___WORD,body);
#endif

  base[___STILL_HEADER] = ___MAKE_HD(bytes, subtype, ___STILL);

  /* Return tagged reference to still object. */

  if (subtype == ___sPAIR)
    return ___PAIR_FROM_BODY(body);
  else
    return ___SUBTYPED_FROM_BODY(body);
}


___EXP_FUNC(___WORD,___alloc_scmobj)
   ___P((___processor_state ___ps,
         int subtype,
         ___SIZE_TS bytes),
        (___ps,
         subtype,
         bytes)
___processor_state ___ps;
int subtype;
___SIZE_TS bytes;)
{
  if (___ps == NULL)
    return alloc_scmobj_perm (subtype, bytes);
  else
    return alloc_scmobj_still (___ps, subtype, bytes);
}


___EXP_FUNC(___SCMOBJ,___release_scmobj)
   ___P((___SCMOBJ obj),
        (obj)
___SCMOBJ obj;)
{
  if (___MEM_ALLOCATED(obj) &&
      ___HD_TYP(___HEADER(obj)) == ___STILL)
    ___still_obj_refcount_dec (obj);
  return obj;
}


/*
 * '___make_pair (___ps, car, cdr)' creates a Scheme pair having the
 * values 'car' and 'cdr' in its CAR and CDR fields.  The 'car' and
 * 'cdr' arguments must not be movable objects and any still object
 * must be reachable some other way or have a nonzero refcount.  A
 * permanent or still object is allocated, depending on '___ps'.  When
 * '___ps' is NULL, a permanent object is allocated, and when '___ps'
 * is not NULL, a still object is allocated in the heap of that
 * processor.  The 'refcount' field of still objects is initially 1.
 * A fixnum error code is returned when there is an error.
 */

___EXP_FUNC(___WORD,___make_pair)
   ___P((___processor_state ___ps,
         ___WORD car,
         ___WORD cdr),
        (___ps,
         car,
         cdr)
___processor_state ___ps;
___WORD car;
___WORD cdr;)
{
  ___WORD obj = ___alloc_scmobj (___ps, ___sPAIR, ___PAIR_SIZE<<___LWS);

  if (!___FIXNUMP(obj))
    {
      ___CAR_FIELD(obj) = car;
      ___CDR_FIELD(obj) = cdr;
    }

  return obj;
}


/*
 * '___make_vector (___ps, length, init)' creates a Scheme vector of
 * length 'length' and initialized with the value 'init'.  The 'init'
 * argument must not be a movable object and if it is a still object
 * it must be reachable some other way or have a nonzero refcount.  A
 * permanent or still object is allocated, depending on '___ps'.  When
 * '___ps' is NULL, a permanent object is allocated, and when '___ps'
 * is not NULL, a still object is allocated in the heap of that
 * processor.  The 'refcount' field of still objects is initially 1.
 * A fixnum error code is returned when there is an error.
 */

___EXP_FUNC(___WORD,___make_vector)
   ___P((___processor_state ___ps,
         ___SIZE_TS length,
         ___WORD init),
        (___ps,
         length,
         init)
___processor_state ___ps;
___SIZE_TS length;
___WORD init;)
{
  if (length > ___CAST(___WORD,___LMASK >> (___LF+___LWS)))
    return ___FIX(___HEAP_OVERFLOW_ERR);
  else
    {
      ___WORD obj = ___alloc_scmobj (___ps, ___sVECTOR, length<<___LWS);

      if (!___FIXNUMP(obj))
        {
          int i;
          for (i=0; i<length; i++)
            ___FIELD(obj, i) = init;
        }

      return obj;
    }
}


/*---------------------------------------------------------------------------*/

/*
 * Routines to manage symbol table, keyword table and global variable
 * table.
 */

/*
 * The hashing functions '___hash_UTF_8_string (str)' and
 * '___hash_scheme_string (str)' must compute the same value as the
 * function 'targ-hash' in the file gsc/_t-c-3.scm.  A fixnum error
 * code is returned when there is an error.
 *
 * These functions implement an adaptation of the FNV1a hash algorithm
 * (see https://tools.ietf.org/html/draft-eastlake-fnv-12).  Instead
 * of iterating over bytes, an iteration over Unicode code points is
 * used.  This will give the same result if the string contains only
 * ISO-8859-1 characters.  However, only the lower 29 bits of the
 * standard 32 bit FNV1a algorithm are returned so the result fits in
 * a fixnum on a 32 bit word architecture.
 */

#define FN1a_prime        0x01000193
#define FN1a_offset_basis 0x011C9DC5

#define HASH_STEP(h,c) (((h)^(c)) * FN1a_prime) & ___MAX_FIX32

___SCMOBJ ___hash_UTF_8_string
   ___P((___UTF_8STRING str),
        (str)
___UTF_8STRING str;)
{
  ___UM32 h = FN1a_offset_basis;
  ___UTF_8STRING p = str;
  ___UCS_4 c;

  for (;;)
    {
      ___UTF_8STRING start = p;
      ___UTF_8_get_var (&p, c);
      if (p == start || c > ___MAX_CHR)
        return ___FIX(___CTOS_UTF_8STRING_ERR);
      if (c == 0)
        break;
      h = HASH_STEP(h,c);
    }

  return ___FIX(h);
}


___SCMOBJ ___hash_scheme_string
   ___P((___SCMOBJ str),
        (str)
___SCMOBJ str;)
{
  ___SIZE_T i, n = ___INT(___STRINGLENGTH(str));
  ___UM32 h = FN1a_offset_basis;

  for (i=0; i<n; i++)
    h = HASH_STEP(h,___INT(___STRINGREF(str,___FIX(i))));

  return ___FIX(h);
}


___HIDDEN ___SCMOBJ symkey_table
   ___P((unsigned int subtype),
        (subtype)
unsigned int subtype;)
{
  switch (subtype)
    {
    case ___sKEYWORD:
      return ___GSTATE->keyword_table;
    default: /* assume ___sSYMBOL */
      return ___GSTATE->symbol_table;
    }
}


___HIDDEN void symkey_table_set
   ___P((unsigned int subtype,
         ___SCMOBJ new_table),
        (subtype,
         new_table)
unsigned int subtype;
___SCMOBJ new_table;)
{
  switch (subtype)
    {
    case ___sKEYWORD:
      ___GSTATE->keyword_table = new_table;
      break;
    default: /* assume ___sSYMBOL */
      ___GSTATE->symbol_table = new_table;
      break;
    }
}


___HIDDEN ___SCMOBJ alloc_symkey_table
   ___P((unsigned int subtype,
         ___SIZE_TS length),
        (subtype,
         length)
unsigned int subtype;
___SIZE_TS length;)
{
  ___SCMOBJ tbl = ___make_vector (NULL, length+1, ___NUL);

  if (!___FIXNUMP(tbl))
    ___FIELD(tbl,0) = ___FIX(0);

  return tbl;
}


void ___intern_symkey
   ___P((___SCMOBJ symkey),
        (symkey)
___SCMOBJ symkey;)
{
  unsigned int subtype = ___INT(___SUBTYPE(symkey));
  ___SCMOBJ tbl = symkey_table (subtype);
  int i = ___INT(___FIELD(symkey,___SYMKEY_HASH))
          % (___INT(___VECTORLENGTH(tbl)) - 1)
          + 1;

  /*
   * Add symbol/keyword to the appropriate list.
   */

  ___FIELD(symkey,___SYMKEY_NEXT) = ___FIELD(tbl,i);
  ___FIELD(tbl,i) = symkey;

  ___FIELD(tbl,0) = ___FIXADD(___FIELD(tbl,0),___FIX(1));

  /*
   * Grow and rehash the table when it is too loaded (above an average
   * list length of 4).
   */

  if (___INT(___FIELD(tbl,0)) > ___INT(___VECTORLENGTH(tbl)) * 4)
    {
      int new_len = (___INT(___VECTORLENGTH(tbl))-1) * 2;
      ___SCMOBJ newtbl = alloc_symkey_table (subtype, new_len);

      if (!___FIXNUMP(newtbl))
        {
          for (i=___INT(___VECTORLENGTH(tbl))-1; i>0; i--)
            {
              ___SCMOBJ probe = ___FIELD(tbl,i);

              while (probe != ___NUL)
                {
                  ___SCMOBJ symkey = probe;
                  int j = ___INT(___FIELD(symkey,___SYMKEY_HASH))%new_len + 1;

                  probe = ___FIELD(symkey,___SYMKEY_NEXT);
                  ___FIELD(symkey,___SYMKEY_NEXT) = ___FIELD(newtbl,j);
                  ___FIELD(newtbl,j) = symkey;
                }
            }

          ___FIELD(newtbl,0) = ___FIELD(tbl,0);

          symkey_table_set (subtype, newtbl);
        }
    }
}


___SCMOBJ ___new_symkey
   ___P((___SCMOBJ name, /* name must be a permanent object */
         unsigned int subtype),
        (name,
         subtype)
___SCMOBJ name;
unsigned int subtype;)
{
  ___SCMOBJ obj;
  ___SCMOBJ tbl;

  switch (subtype)
    {
    case ___sKEYWORD:
      obj = ___alloc_scmobj (NULL, ___sKEYWORD, ___KEYWORD_SIZE<<___LWS);
      break;
    default: /* assume ___sSYMBOL */
      obj = ___alloc_scmobj (NULL, ___sSYMBOL, ___SYMBOL_SIZE<<___LWS);
      break;
    }

  if (___FIXNUMP(obj))
    return obj;

  tbl = symkey_table (subtype);

  /* object layout is same for ___sSYMBOL and ___sKEYWORD */

  ___FIELD(obj,___SYMKEY_NAME) = name;
  ___FIELD(obj,___SYMKEY_HASH) = ___hash_scheme_string (name);

  if (subtype == ___sSYMBOL)
    ___FIELD(obj,___SYMBOL_GLOBAL) = ___CAST(___SCMOBJ,___CAST(___glo_struct*,0));

  ___intern_symkey (obj);

  return obj;
}


___SCMOBJ ___find_symkey_from_UTF_8_string
   ___P((char *str,
         unsigned int subtype),
        (str,
         subtype)
char *str;
unsigned int subtype;)
{
  ___SCMOBJ tbl;
  ___SCMOBJ probe;
  ___SCMOBJ h = ___hash_UTF_8_string (str);

  if (h < ___FIX(0))
    return h;

  tbl = symkey_table (subtype);
  probe = ___FIELD(tbl, ___INT(h) % (___INT(___VECTORLENGTH(tbl))-1) + 1);

  while (probe != ___NUL)
    {
      ___SCMOBJ name = ___FIELD(probe,___SYMKEY_NAME);
      ___SIZE_T i;
      ___SIZE_T n = ___INT(___STRINGLENGTH(name));
      ___UTF_8STRING p = str;
      ___UCS_4 c;
      for (i=0; i<n; i++)
        if (___UTF_8_get_var (&p, c) !=
            ___CAST(___UCS_4,___INT(___STRINGREF(name,___FIX(i)))))
          goto next;
      if (___UTF_8_get_var (&p, c) == 0)
        return probe;
    next:
      probe = ___FIELD(probe,___SYMKEY_NEXT);
    }

  return ___FAL;
}


___SCMOBJ ___find_symkey_from_scheme_string
   ___P((___SCMOBJ str,
         unsigned int subtype),
        (str,
         subtype)
___SCMOBJ str;
unsigned int subtype;)
{
  ___SCMOBJ tbl;
  ___SCMOBJ probe;
  ___SCMOBJ h = ___hash_scheme_string (str);

  tbl = symkey_table (subtype);
  probe = ___FIELD(tbl, ___INT(h) % (___INT(___VECTORLENGTH(tbl))-1) + 1);

  while (probe != ___NUL)
    {
      ___SCMOBJ name = ___FIELD(probe,___SYMKEY_NAME);
      ___SIZE_TS i = 0;
      ___SIZE_TS n = ___INT(___STRINGLENGTH(name));
      if (___INT(___STRINGLENGTH(str)) == n)
        {
          for (i=0; i<n; i++)
            if (___STRINGREF(str,___FIX(i)) != ___STRINGREF(name,___FIX(i)))
              goto next;
          return probe;
        }
    next:
      probe = ___FIELD(probe,___SYMKEY_NEXT);
    }

  return ___FAL;
}


___SCMOBJ ___make_symkey_from_UTF_8_string
   ___P((___UTF_8STRING str,
         unsigned int subtype),
        (str,
         subtype)
___UTF_8STRING str;
unsigned int subtype;)
{
  ___SCMOBJ obj = ___find_symkey_from_UTF_8_string (str, subtype);

  if (obj == ___FAL)
    {
      ___SCMOBJ name;
      ___SCMOBJ err;

      if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ
                   (NULL, /* allocate as permanent object */
                    str,
                    &name,
                    -1))
          != ___FIX(___NO_ERR))
        return err;

      obj = ___new_symkey (name, subtype);
    }

  return obj;
}


___SCMOBJ ___make_symkey_from_scheme_string
   ___P((___SCMOBJ str,
         unsigned int subtype),
        (str,
         subtype)
___SCMOBJ str;
unsigned int subtype;)
{
  ___SCMOBJ obj = ___find_symkey_from_scheme_string (str, subtype);

  if (obj == ___FAL)
    {
      ___SIZE_T n = ___INT(___STRINGLENGTH(str));
      ___SCMOBJ name = ___alloc_scmobj (NULL, ___sSTRING, n<<___LCS);

      if (___FIXNUMP(name))
        return name;

      memmove (___BODY_AS(name,___tSUBTYPED),
               ___BODY_AS(str,___tSUBTYPED),
               n<<___LCS);

      obj = ___new_symkey (name, subtype);
    }

  return obj;
}


void ___for_each_symkey
   ___P((unsigned int subtype,
         void (*visit) (___SCMOBJ symkey, void *data),
         void *data),
        (subtype,
         visit,
         data)
unsigned int subtype;
void (*visit) ();
void *data;)
{
  ___SCMOBJ tbl = symkey_table (subtype);
  int i;

  for (i=___INT(___VECTORLENGTH(tbl))-1; i>0; i--)
    {
      ___SCMOBJ probe = ___FIELD(tbl, i);

      while (probe != ___NUL)
        {
          visit (probe, data);
          probe = ___FIELD(probe,___SYMKEY_NEXT);
        }
    }
}


/*---------------------------------------------------------------------------*/


#define fromspace_offset ((___MSECTION_SIZE>>1) - tospace_offset)

#define start_of_fromspace(ms) ms->base + fromspace_offset

#define start_of_tospace(ms) ms->base + tospace_offset

#define SET_MAX(var,val) do { if ((var) < (val)) var = val; } while (0)
#define SET_MIN(var,val) do { if ((var) > (val)) var = val; } while (0)


/*---------------------------------------------------------------------------*/

#ifdef ___DEBUG_GARBAGE_COLLECT


#define ZAP_USING_INVALID_HEAD_TAG_not
#define ZAP_PATTERN ___CAST(___WORD,0xcafebabe)
#define INVALID_HEAD_TAG 4


char *subtype_to_string
   ___P((int subtype),
        (subtype)
int subtype;)
{
  switch (subtype)
    {
    case ___sVECTOR:       return "vector";
    case ___sPAIR:         return "pair";
    case ___sRATNUM:       return "ratnum";
    case ___sCPXNUM:       return "cpxnum";
    case ___sSTRUCTURE:    return "structure";
    case ___sBOXVALUES:    return "boxvalues";
    case ___sMEROON:       return "meroon";
    case ___sJAZZ:         return "jazz";
    case ___sSYMBOL:       return "symbol";
    case ___sKEYWORD:      return "keyword";
    case ___sFRAME:        return "frame";
    case ___sCONTINUATION: return "continuation";
    case ___sPROMISE:      return "promise";
    case ___sWEAK:         return "weak";
    case ___sPROCEDURE:    return "procedure";
    case ___sRETURN:       return "return";
    case ___sFOREIGN:      return "foreign";
    case ___sSTRING:       return "string";
    case ___sS8VECTOR:     return "s8vector";
    case ___sU8VECTOR:     return "u8vector";
    case ___sS16VECTOR:    return "s16vector";
    case ___sU16VECTOR:    return "u16vector";
    case ___sS32VECTOR:    return "s32vector";
    case ___sU32VECTOR:    return "u32vector";
    case ___sF32VECTOR:    return "f32vector";
    case ___sS64VECTOR:    return "s64vector";
    case ___sU64VECTOR:    return "u64vector";
    case ___sF64VECTOR:    return "f64vector";
    case ___sFLONUM:       return "flonum";
    case ___sBIGNUM:       return "bignum";
    default:               return "UNKNOWN SUBTYPE";
    }
}

void print_value
   ___P((___SCMOBJ val),
        (val)
___SCMOBJ val;)
{
  ___SCMOBJ ___temp;
  if (___MEM_ALLOCATED(val))
    {
      ___WORD* body = ___BODY0(val);
      ___WORD head = body[-1];
      int subtype;
      int shift = 0;

      if (___TYP(head) == ___FORW)
        {
          /* indirect forwarding pointer */
          body = ___BODY0(head);
          head = body[-1];
        }

      if (head == ZAP_PATTERN)
        ___printf ("[WARNING: HEAD=ZAP_PATTERN] ");
      else if (___HD_TYP(head) == INVALID_HEAD_TAG)
        {
          ___printf ("[WARNING: HEAD HAS INVALID TAG] ");
          shift = ___HTB;
        }

      head >>= shift;
      subtype = ___HD_SUBTYPE(head);

      if (subtype == ___sPAIR)
        {
          ___printf ("0x%" ___PRIxWORD " (... . ...)", val);
        }
      else
        {
          ___SCMOBJ sym;
          if (subtype == ___sPROCEDURE || subtype == ___sRETURN)
            {
              ___printf ("0x%" ___PRIxWORD " ", val);
              if (subtype == ___sPROCEDURE)
                ___printf ("#<procedure ");
              else
                ___printf ("#<return ");
              if ((sym = ___find_global_var_bound_to (val)) != ___NUL)
                print_value (___FIELD(sym,___SYMKEY_NAME));
              else
                {
                  if (___HD_TYP(head) == ___PERM)
                    {
                      ___SCMOBJ *start = &body[-1];
                      ___SCMOBJ *ptr = start;
                      while (!___TESTHEADERTAG(*ptr,___sVECTOR))
                        ptr -= ___LABEL_SIZE;
                      ptr += ___LABEL_SIZE;
                      if (ptr == start)
                        ___printf ("???");
                      else
                        {
                          ___printf ("%d in ", (start-ptr)/___LABEL_SIZE);
                          print_value (___TAG(ptr,___tSUBTYPED));
                        }
                    }
                  else
                    ___printf ("???");
                }
              ___printf (">");
            }
          else if (subtype == ___sSTRING)
            {
              int i;
              ___SCMOBJ str = ___SUBTYPED_FROM_BODY(body);
              ___printf ("\"");
              for (i=0; i<___INT(___STRINGLENGTH(str)); i++)
                ___printf ("%c", ___INT(___STRINGREF(str,___FIX(i))));
              ___printf ("\"");
            }
          else if (subtype == ___sSYMBOL)
            {
              ___printf ("#<symbol ");
              print_value (body[___SYMKEY_NAME]>>shift);
              ___printf (">");
            }
          else
            {
              ___printf ("#<%s>", subtype_to_string (subtype));
            }
        }
    }
  else if (___FIXNUMP(val))
    ___printf ("%d", ___INT(val));
  else if (___CHARP(val))
    ___printf ("#\\x%x", ___INT(val));
  else if (val == ___FAL)
    ___printf ("#f");
  else if (val == ___TRU)
    ___printf ("#t");
  else if (val == ___NUL)
    ___printf ("()");
  else if (val == ___EOF)
    ___printf ("#!eof");
  else if (val == ___VOID)
    ___printf ("#!void");
  else if (val == ___ABSENT)
    ___printf ("#absent");
  else if (val == ___UNB1)
    ___printf ("#!unbound");
  else if (val == ___UNB2)
    ___printf ("#!unbound2");
  else if (val == ___OPTIONAL)
    ___printf ("#!optional");
  else if (val == ___KEYOBJ)
    ___printf ("#!key");
  else if (val == ___REST)
    ___printf ("#!rest");
  else if (val == ___UNUSED)
    ___printf ("#unused");
  else if (val == ___DELETED)
    ___printf ("#deleted");
  else
    ___printf ("#unknown(0x" ___PRIxWORD ")", val);
}

void print_stack
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___WORD *stack_limit = ___ps->stack_limit;
  ___WORD *fp = ___ps->fp;
  ___WORD *stack_break = ___ps->stack_break;
  ___WORD *stack_start = ___ps->stack_start;
  ___msection *stack_ms = ___ps->mem.stack_msection_;
  ___WORD *probe;

  ___printf ("------------------ current stack\n");

  ___printf ("stack_msection = %p\n", stack_ms);
  ___printf ("stack_msection->index = %d\n", stack_ms->index);
  ___printf ("stack_msection->pos   = %d\n", stack_ms->pos);
  ___printf ("stack_msection->next  = %p\n", stack_ms->next);
  ___printf ("stack_msection->prev  = %p\n", stack_ms->prev);
  ___printf ("fp = %p\n", fp);
  ___printf ("stack_break = %p\n", stack_break);
  ___printf ("stack_start = %p\n", stack_start);

  probe = stack_limit - 3;

  while (probe < stack_start)
    {
      int span = 0;
      int skip = 99999999;

#define SET_DIST_LO_HI(ctx_lo, ctx_hi, ptr) \
do { \
  int dist = probe - ptr; \
  if (dist < ctx_lo) \
    SET_MIN(skip, ctx_lo - dist); \
  else if (dist <= ctx_hi) \
    SET_MAX(span, ctx_hi - dist + 1); \
} while (0)

      SET_DIST_LO_HI( -3,  3, stack_limit);
      SET_DIST_LO_HI(-10, 10, fp);
      SET_DIST_LO_HI(-10, 10, stack_break);
      SET_DIST_LO_HI(-15,  0, stack_start);

      if (span > 0)
        {
          while (span > 0)
            {
              int i;
              if (probe < stack_start)
                ___printf ("%p %p", probe, *probe);
              else
                ___printf ("%p", probe);
              if (probe == stack_limit) ___printf (" <--stack_limit");
              if (probe == fp)          ___printf (" <--fp");
              if (probe == stack_break) ___printf (" <--stack_break");
              if (probe == stack_start) ___printf (" <--stack_start");
              i = probe - stack_break;
              if (i == ___BREAK_FRAME_NEXT)
                ___printf (" [BREAK_FRAME_NEXT]");
              else
                {
                  i = probe - (stack_start - ___FIRST_BREAK_FRAME_SPACE);
                  switch (i)
                    {
                    case ___BREAK_FRAME_NEXT:
                      ___printf (" [BREAK_FRAME_NEXT]");
                      break;
                    case ___FIRST_BREAK_FRAME_STACK_MSECTION:
                      ___printf (" [FIRST_BREAK_FRAME_STACK_MSECTION]");
                      break;
                    case ___FIRST_BREAK_FRAME_STACK_BREAK:
                      ___printf (" [FIRST_BREAK_FRAME_STACK_BREAK]");
                      break;
                    }
                }
              ___printf ("\n");
              probe++;
              span--;
            }
        }
      else
        {
          ___printf("...\n");
            probe += skip;
        }
    }
}

#endif


#ifdef ENABLE_CONSISTENCY_CHECKS

#define IN_OBJECT           0
#define IN_REGISTER         1
#define IN_SAVED            2
#define IN_TYPE_CACHE       3
#define IN_PROCESSOR_SCMOBJ 4
#define IN_VM_SCMOBJ        5
#define IN_SYMKEY_TABLE     6
#define IN_GLOBAL_VAR       7
#define IN_WILL_LIST        8
#define IN_CONTINUATION     9
#define IN_RC               10


___HIDDEN void print_prefix
   ___P((char *prefix,
         int indent),
        (prefix,
         indent)
char *prefix;
int indent;)
{
  int i;

  ___printf ("%s", prefix);

  for (i=0; i<indent; i++)
    ___printf (" ");
}


___HIDDEN void print_object
   ___P((___WORD obj,
         int max_depth,
         char *prefix,
         int indent),
        (obj,
         max_depth,
         prefix,
         indent)
___WORD obj;
int max_depth;
char *prefix;
int indent;)
{
  int typ = ___TYP(obj);

  print_prefix (prefix, indent);

  if (typ == ___tFIXNUM)
    ___printf ("%d\n", ___INT(obj));
  else if (typ == ___tSPECIAL)
    {
      if (obj >= 0)
        ___printf ("#\\%c\n", ___INT(obj));
      else if (obj == ___FAL)
        ___printf ("#f\n");
      else if (obj == ___TRU)
        ___printf ("#t\n");
      else if (obj == ___NUL)
        ___printf ("()\n");
      else if (obj == ___EOF)
        ___printf ("#!eof\n");
      else if (obj == ___VOID)
        ___printf ("#!void\n");
      else if (obj == ___ABSENT)
        ___printf ("#<absent>\n");
      else if (obj == ___UNB1)
        ___printf ("#<unbound1>\n");
      else if (obj == ___UNB2)
        ___printf ("#<unbound2>\n");
      else if (obj == ___OPTIONAL)
        ___printf ("#!optional\n");
      else if (obj == ___KEYOBJ)
        ___printf ("#!key\n");
      else if (obj == ___REST)
        ___printf ("#!rest\n");
      else if (obj == ___UNUSED)
        ___printf ("#<unused>\n");
      else if (obj == ___DELETED)
        ___printf ("#<deleted>\n");
      else
        ___printf ("#<unknown 0x%" ___PRIxWORD ">\n", obj);
    }
  else
    {
      ___WORD* body = ___BODY0(obj);
      ___WORD head = body[-1];
      int subtype;
      int shift = 0;

      if (___TYP(head) == ___FORW)
        {
          /* indirect forwarding pointer */
          body = ___BODY0(head);
          head = body[-1];
        }

      if (___HD_TYP(head) == INVALID_HEAD_TAG)
        shift = ___HTB;

      head >>= shift;
      subtype = ___HD_SUBTYPE(head);

      switch (subtype)
        {
        case ___sVECTOR:
          if (max_depth > 0)
            {
              int i;
              ___printf ("#(\n");
              for (i=0; i<___CAST(int,___HD_WORDS(head)); i++)
                print_object (___FIELD(obj,i)>>shift, max_depth-1, prefix, indent+2);
              print_prefix (prefix, indent);
              ___printf (")\n");
            }
          else
            ___printf ("#(...)\n");
          break;
        case ___sPAIR:
          if (max_depth > 0)
            {
              ___printf ("(\n");
              print_object (___CAR(obj)>>shift, max_depth-1, prefix, indent+1);
              print_prefix (prefix, indent);
              ___printf (" .\n");
              print_object (___CDR(obj)>>shift, max_depth-1, prefix, indent+1);
              print_prefix (prefix, indent);
              ___printf (")\n");
            }
          else
            ___printf ("(...)\n");
          break;
        case ___sRATNUM:
          ___printf ("RATNUM\n");
          break;
        case ___sCPXNUM:
          ___printf ("CPXNUM\n");
          break;
        case ___sSTRUCTURE:
          ___printf ("STRUCTURE\n");
          break;
        case ___sBOXVALUES:
          ___printf ("BOXVALUES\n");
          break;
        case ___sMEROON:
          ___printf ("MEROON\n");
          break;
        case ___sSYMBOL:
          ___printf ("SYMBOL ");
          print_object (___FIELD(obj,___SYMKEY_NAME)>>shift, max_depth-1, "", 0);
          break;
        case ___sKEYWORD:
          ___printf ("KEYWORD ");
          print_object (___FIELD(obj,___SYMKEY_NAME)>>shift, max_depth-1, "", 0);
          break;
        case ___sFRAME:
          ___printf ("FRAME\n");
          break;
        case ___sCONTINUATION:
          ___printf ("CONTINUATION\n");
          break;
        case ___sPROMISE:
          ___printf ("PROMISE\n");
          break;
        case ___sWEAK:
          ___printf ("WEAK\n");
          break;
        case ___sPROCEDURE:
          ___printf ("PROCEDURE\n");
          break;
        case ___sRETURN:
          ___printf ("RETURN\n");
          break;
        case ___sFOREIGN:
          ___printf ("FOREIGN\n");
          break;
        case ___sSTRING:
          {
            int i;
            int len = ___HD_BYTES(head)>>___LCS;
            ___printf ("STRING ");
            for (i=0; i<len; i++)
              ___printf ("%c", ___INT(___STRINGREF(obj,___FIX(i))));
            ___printf ("\n");
          }
          break;
        case ___sS8VECTOR:
          ___printf ("S8VECTOR\n");
          break;
        case ___sU8VECTOR:
          ___printf ("U8VECTOR\n");
          break;
        case ___sS16VECTOR:
          ___printf ("S16VECTOR\n");
          break;
        case ___sU16VECTOR:
          ___printf ("U16VECTOR\n");
          break;
        case ___sS32VECTOR:
          ___printf ("S32VECTOR\n");
          break;
        case ___sU32VECTOR:
          ___printf ("U32VECTOR\n");
          break;
        case ___sF32VECTOR:
          ___printf ("F32VECTOR\n");
          break;
        case ___sS64VECTOR:
          ___printf ("S64VECTOR\n");
          break;
        case ___sU64VECTOR:
          ___printf ("U64VECTOR\n");
          break;
        case ___sF64VECTOR:
          ___printf ("F64VECTOR\n");
          break;
        case ___sFLONUM:
          ___printf ("FLONUM\n");
          break;
        case ___sBIGNUM:
          ___printf ("BIGNUM\n");
          break;
        default:
          ___printf ("UNKNOWN\n");
          break;
        }
    }
}


___HIDDEN void print_global_var_name
   ___P((___glo_struct *glo),
        (glo)
___glo_struct *glo;)
{
  ___SCMOBJ sym = ___NUL;
  int i;

  for (i = ___INT(___VECTORLENGTH(___GSTATE->symbol_table)) - 1; i>0; i--)
    {
      sym = ___FIELD(___GSTATE->symbol_table,i);

      while (sym != ___NUL)
        {
          ___SCMOBJ g = ___FIELD(sym,___SYMBOL_GLOBAL);

          if (g != ___FIX(0))
            {
              ___glo_struct *p = ___CAST(___glo_struct*,g);

              if (p == glo)
                {
                  ___SCMOBJ name = ___FIELD(sym,___SYMKEY_NAME);
                  for (i=0; i<___INT(___STRINGLENGTH(name)); i++)
                    ___printf ("%c", ___INT(___STRINGREF(name,___FIX(i))));
                  i = 0;
                  break;
                }
            }

          sym = ___FIELD(sym,___SYMKEY_NEXT);
        }
    }
}


___HIDDEN void dump_memory_map
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  int ns = the_msections->nb_sections;
  ___msection **sections = the_msections->sections;
  int i;

  ___printf (">>> Memory map:\n");

  for (i=0; i<ns; i++)
    ___printf (">>>  msection %2d:  %p .. %p .. %p\n",
               i,
               sections[i]->base,
               sections[i]->base + (___MSECTION_SIZE>>1),
               sections[i]->base + ___MSECTION_SIZE);

  ___printf (">>>  alloc_msection       = %p\n", alloc_msection);
  ___printf (">>>  stack_msection       = %p\n", stack_msection);
  ___printf (">>>  heap_msection        = %p\n", heap_msection);
  ___printf (">>>  alloc_stack_ptr      = %p\n", alloc_stack_ptr);
  ___printf (">>>  alloc_stack_limit    = %p\n", alloc_stack_limit);
  ___printf (">>>  alloc_heap_limit     = %p\n", alloc_heap_limit);
  ___printf (">>>  alloc_heap_ptr       = %p\n", alloc_heap_ptr);
  ___printf (">>>  scan_ptr             = %p\n", scan_ptr);
}

___HIDDEN void explain_problem
   ___P((___PSD
         ___WORD obj,
         int shift,
         char *msg),
        (___PSV
         obj,
         shift,
         msg)
___PSDKR
___WORD obj;
int shift;
char *msg;)
{
  ___PSGET

  dump_memory_map (___PSPNC);

  ___printf (">>> The object 0x%" ___PRIxWORD " %s\n", obj, msg);

  {
    int j;
    ___WORD head = ___BODY0(obj)[-1]>>shift;
    ___SIZE_TS words = ___HD_WORDS(head);
    if (words > 10)
      words = 10;
    for (j=-1; j<words; j++)
      {
        ___printf (">>>  body[%2d] = 0x%" ___PRIxWORD "\n", j, ___BODY0(obj)[j]>>shift);
        print_object (___BODY0(obj)[j]>>shift, 1, ">>>             ", 0);
      }
  }

  switch (reference_location)
    {
    case IN_OBJECT:
      {
        ___WORD container;
        ___WORD head = container_body[-1];
        ___SIZE_TS words = ___HD_WORDS(head);
        int subtype = ___HD_SUBTYPE(head);
        int i;

        if (subtype == ___sPAIR)
          container = ___PAIR_FROM_BODY(container_body);
        else
          container = ___SUBTYPED_FROM_BODY(container_body);

        ___printf (">>> The reference was found in ");
        if (___HD_TYP(head) == ___PERM)
          ___printf ("___PERM ");
        else if (___HD_TYP(head) == ___STILL)
          ___printf ("___STILL ");
        else if (___HD_TYP(head) == ___MOVABLE0)
          ___printf ("___MOVABLE0 ");
        else if (___TYP(head) == ___FORW)
          ___printf ("___FORW ");
        else
          ___printf ("UNKNOWN ");
        ___printf ("object with body at %p:\n", container_body);

        ___printf (">>>  subtype = %d\n", subtype);
        ___printf (">>>  length  = %ld words\n", words);
        if (words <= 100)
          {
            for (i=-1; i<words; i++)
              ___printf (">>>  body[%2d] = 0x%" ___PRIxWORD "\n", i, container_body[i]);
          }
        else
          {
            for (i=0; i<50; i++)
              ___printf (">>>  body[%2d] = 0x%" ___PRIxWORD "\n", i, container_body[i]);
            ___printf ("...\n");
            for (i=words-50; i<words; i++)
              ___printf (">>>  body[%2d] = 0x%" ___PRIxWORD "\n", i, container_body[i]);
          }
        ___printf (">>> container =\n");
        print_object (container, 4, ">>>   ", 0);
        break;
      }

    case IN_REGISTER:
      ___printf (">>> The reference was found in a register\n");
      break;

    case IN_SAVED:
      ___printf (">>> The reference was found in the saved objects\n");
      break;

    case IN_TYPE_CACHE:
      ___printf (">>> The reference was found in a type cache\n");
      break;

    case IN_PROCESSOR_SCMOBJ:
      ___printf (">>> The reference was found in the processor object\n");
      break;

    case IN_VM_SCMOBJ:
      ___printf (">>> The reference was found in the VM object\n");
      break;

    case IN_SYMKEY_TABLE:
      ___printf (">>> The reference was found in the symbol or keyword table\n");
      break;

    case IN_GLOBAL_VAR:
      ___printf (">>> The reference was found in a global variable\n");
      break;

    case IN_WILL_LIST:
      ___printf (">>> The reference was found in a will list\n");
      break;

    case IN_CONTINUATION:
      ___printf (">>> The reference was found in a continuation\n");
      break;

    case IN_RC:
      ___printf (">>> The reference was found in a reference counted object\n");
      break;
    }
}


___HIDDEN void bug
   ___P((___PSD
         ___WORD obj,
         int shift,
         char *msg),
        (___PSV
         obj,
         shift,
         msg)
___PSDKR
___WORD obj;
int shift;
char *msg;)
{
  ___PSGET
  char *msgs[2];

  ___printf (">>> P%d: the GC has detected the following inconsistency\n",
             ___PROCESSOR_ID(___ps,___VMSTATE_FROM_PSTATE(___ps)));
  ___printf (">>> during call of mark_array on line %d of mem.c:\n",
             mark_array_call_line);
  explain_problem (___PSP obj, shift, msg);
  msgs[0] = "GC inconsistency detected";
  msgs[1] = 0;
  ___fatal_error (msgs);
}


___HIDDEN void validate_old_obj
   ___P((___PSD
         ___WORD obj),
        (___PSV
         obj)
___PSDKR
___WORD obj;)
{
  ___PSGET
  ___WORD *hd_ptr = ___BODY0(obj)-1;
  ___WORD head;
  int i = find_msection (the_msections, hd_ptr);
  if (i >= 0 && i < the_msections->nb_sections)
    {
      ___PTRDIFF_T pos = hd_ptr - the_msections->sections[i]->base;
      if (pos >= 0 && pos < ___MSECTION_SIZE)
        {
          head = *hd_ptr;
          if (___TYP(head) == ___FORW)
            {
              ___WORD *hd_ptr2 = ___BODY0(head)-1;
              int i2 = find_msection (the_msections, hd_ptr2);
              if (i2 >= 0 && i2 < the_msections->nb_sections)
                {
                  ___PTRDIFF_T pos2 = hd_ptr2 -
                                      (the_msections->sections[i2]->base +
                                       tospace_offset);
                  if (pos2 < 0 || pos2 >= ___MSECTION_SIZE>>1)
                    bug (___PSP obj, 0, "was copied outside of tospace");
                  else if (___HD_TYP((*hd_ptr2)) != ___MOVABLE0)
                    bug (___PSP obj, 0, "was copied and copy is not ___MOVABLE0");
                }
              else
                bug (___PSP obj, 0, "was copied outside of tospace");
            }
          else if (___HD_TYP(head) != ___MOVABLE0)
            bug (___PSP obj, ___HTB, "should be ___MOVABLE0");
          else
            {
              pos -= tospace_offset;
              if (pos >= 0 && pos < ___MSECTION_SIZE>>1)
                bug (___PSP obj, 0, "is in tospace");
            }
          return;
        }
    }
  head = *hd_ptr; /* this dereference will likely bomb if there is a bug */
  if (___HD_TYP(head) != ___PERM && ___HD_TYP(head) != ___STILL)
    bug (___PSP obj, 0, "is not ___PERM or ___STILL");
}


___HIDDEN void zap_section
   ___P((___WORD *start,
         ___WORD *end),
        (start,
         end)
___WORD *start;
___WORD *end;)
{
  while (start < end)
    {
#ifdef ZAP_USING_INVALID_HEAD_TAG
      *start = (*start << ___HTB) | INVALID_HEAD_TAG;
#else
      *start = ZAP_PATTERN;
#endif
      start++;
    }
}


___HIDDEN int unzapped_words
   ___P((___WORD *start,
         int words),
        (start,
         words)
___WORD *start;
int words;)
{
  ___WORD *ptr = start;

  while (words > 0 && *ptr++ == ZAP_PATTERN)
    words--;

  return words;
}


___HIDDEN void check_fudge_used
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  int s;
  int h;

  s = unzapped_words (___ps->stack_limit - ___MSECTION_FUDGE,
                      ___MSECTION_FUDGE);

  if (s > stack_fudge_used)
    stack_fudge_used = s;

  h = ___ps->hp - ___ps->heap_limit;

  if (h > heap_fudge_used)
    heap_fudge_used = h;

#ifdef ___DEBUG_GARBAGE_COLLECT
  ___printf ("********* used fudge: stack = %d  heap = %d\n", s, h);
#endif
}


#endif


/*---------------------------------------------------------------------------*/

#ifdef ___DEBUG_GARBAGE_COLLECT

#define fatal_heap_overflow() fatal_heap_overflow_debug (__LINE__)

___HIDDEN void fatal_heap_overflow_debug
   ___P((int line),
        (line)
int line;)

#else

___HIDDEN void fatal_heap_overflow ___PVOID

#endif
{
  char *msgs[2];

#ifdef ___DEBUG_GARBAGE_COLLECT
  ___printf ("fatal_heap_overflow called at mem.c:%d\n", line);
#endif

  msgs[0] = "Heap overflow";
  msgs[1] = 0;

  ___fatal_error (msgs);
}


___HIDDEN ___msection *next_msection_without_locking
   ___P((___processor_state ___ps,
         ___msection *ms),
        (___ps,
         ms)
___processor_state ___ps;
___msection *ms;)
{
  ___msection *result;

  /*
   * This function allocates an msection from the list of free
   * msections.  This is done when a processor has used up all of the
   * space in its current reserved msection (either heap_msection for
   * a heap allocation or stack_msection for a stack allocation).
   * This operation must be done in a critical section because
   * multiple processors may exhaust their space concurrently, either
   * when doing a GC or when ___stack_limit or ___heap_limit are
   * called.  However, this mutual exclusion is the responsibility of
   * the caller of next_msection_without_locking.
   *
   * A spinlock is appropriate for this critical section because the
   * critical section takes very little time and the requests for new
   * msections happen relatively much less frequently.  An experiment
   * on a 2.6 GHz Intel Core i7 using a tight allocation loop of pairs
   * and ___MSECTION_SIZE=131072, indicates that the critical section
   * lasts 0.2 microseconds and next_msection_without_locking
   * is called every 300 microseconds.
   */

  if (custom_msection_alloc != 0)
    return custom_msection_alloc ();

  if (nb_msections_assigned == 0)
    result = the_msections->head; /* start at head of free msections */
  else
    result = alloc_msection->next; /* move to next free msection */

  if (result == 0)
    {
      /*
       * If there are no free msections to allocate the next heap or
       * stack msection, it is possible to use ms for both the heap
       * allocations and stack allocations.  But if it is currently
       * the case that both use the same msection, then it is an error
       * because the garbage collector should have been called to free
       * some space.
       */

      if (stack_msection == heap_msection)
        fatal_heap_overflow ();

      result = ms;
    }
  else
    {
      alloc_msection = result;
      nb_msections_assigned++;
    }

  return result;
}


___HIDDEN void set_stack_msection
   ___P((___processor_state ___ps,
         ___msection *ms),
        (___ps,
         ms)
___processor_state ___ps;
___msection *ms;)
{
  stack_msection = ms;

  alloc_stack_limit = start_of_tospace(ms);
  alloc_stack_start = alloc_stack_limit + (___MSECTION_SIZE>>1);
  alloc_stack_ptr = alloc_stack_start;
}


___HIDDEN void set_stack_msection_possibly_sharing_with_heap
   ___P((___processor_state ___ps,
         ___msection *ms),
        (___ps,
         ms)
___processor_state ___ps;
___msection *ms;)
{
  set_stack_msection (___ps, ms);

  if (ms == heap_msection)
    {
      /*
       * The same msection will be used for the stack and the heap, so
       * adjust the heap and stack limits accordingly.  3/4 of the
       * remaining usable space is assigned to the stack.
       */

      ___SIZE_TS space = alloc_heap_limit - alloc_heap_ptr;

      if (space < 2*___MSECTION_FUDGE)
        fatal_heap_overflow ();

      space = (space - 2*___MSECTION_FUDGE) >> 2; /* 1/4 of usable space */

      alloc_heap_limit = alloc_heap_ptr + (space + ___MSECTION_FUDGE);
      alloc_stack_limit = alloc_stack_ptr - (3*space + ___MSECTION_FUDGE);
    }

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
    zap_section (alloc_stack_limit, alloc_stack_ptr);
#endif
}


___HIDDEN void stack_msection_stop_using
   ___P((___processor_state ___ps,
         ___WORD *stack_start,
         ___WORD *stack_ptr),
        (___ps,
         stack_start,
         stack_ptr)
___processor_state ___ps;
___WORD *stack_start;
___WORD *stack_ptr;)
{
  words_prev_msections += stack_start - stack_ptr;
}


___HIDDEN void stack_msection_resume_using
   ___P((___processor_state ___ps,
         ___WORD *stack_start,
         ___WORD *stack_ptr),
        (___ps,
         stack_start,
         stack_ptr)
___processor_state ___ps;
___WORD *stack_start;
___WORD *stack_ptr;)
{
  words_prev_msections -= stack_start - stack_ptr;
}


___HIDDEN void next_stack_msection_without_locking
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___msection *ms;
  ms = next_msection_without_locking (___ps, heap_msection);
  set_stack_msection_possibly_sharing_with_heap (___ps, ms);
}


___HIDDEN void next_stack_msection
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___msection *ms;
  ALLOC_MEM_LOCK();
  ms = next_msection_without_locking (___ps, heap_msection);
  ALLOC_MEM_UNLOCK();
  set_stack_msection_possibly_sharing_with_heap (___ps, ms);
}


___HIDDEN void start_heap_chunk
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  alloc_heap_chunk_start = alloc_heap_ptr;
  alloc_heap_chunk_limit = alloc_heap_ptr + ___MSECTION_CHUNK;
}


#define NULL_CHUNK_LINK ___TAG(0, ___FORW)


___HIDDEN void end_heap_chunk
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  /*
   * Add the end of chunk marker.
   *
   * This is done even when the chunk is empty, in case the chunk is
   * currently being scanned.
   */

  *alloc_heap_ptr++ = NULL_CHUNK_LINK; /* leave space for next chunk's link */

  if (alloc_heap_ptr != alloc_heap_chunk_start &&
      !(scan_ptr >= alloc_heap_chunk_start && scan_ptr < alloc_heap_ptr))
    {
      /*
       * The chunk being ended is not empty and it isn't currently
       * being scanned, so add it to the heap chunk FIFO and wake any
       * idle processor.
       */

      ___WORD *new_tail = alloc_heap_chunk_start-1;

#ifndef ___SINGLE_THREADED_VMS
      ___SPINLOCK_LOCK(heap_chunks_to_scan_lock);
#endif

      *heap_chunks_to_scan_tail = ___TAG(new_tail, ___FORW);

      /*
       * A memory barrier is needed to ensure that the content of the
       * chunk, including the end of chunk and the link to the chunk,
       * is visible to other processors.
       */

      ___SHARED_MEMORY_BARRIER();

      heap_chunks_to_scan_tail = new_tail;

      /*
       * A memory barrier is needed to ensure that the new tail of the
       * heap chunk FIFO are visible to other processors.  This can't
       * be combined with the previous memory barrier because the
       * ordering is important (as soon as the modification of
       * heap_chunks_to_scan_tail is observed by another processor, it
       * may attempt to read the content of the chunk).
       */

      ___SHARED_MEMORY_BARRIER();

#ifndef ___SINGLE_THREADED_VMS
      ___SPINLOCK_UNLOCK(heap_chunks_to_scan_lock);
      ___CONDVAR_SIGNAL(scan_termination_condvar);
#endif
    }
}


___HIDDEN void set_heap_msection
   ___P((___processor_state ___ps,
         ___msection *ms),
        (___ps,
         ms)
___processor_state ___ps;
___msection *ms;)
{
  heap_msection = ms;

  alloc_heap_start = start_of_tospace(ms);
  alloc_heap_limit = alloc_heap_start + (___MSECTION_SIZE>>1);
  alloc_heap_ptr = alloc_heap_start;
}


___HIDDEN void set_heap_msection_possibly_sharing_with_stack
   ___P((___processor_state ___ps,
         ___msection *ms),
        (___ps,
         ms)
___processor_state ___ps;
___msection *ms;)
{
  set_heap_msection (___ps, ms);

  if (ms == stack_msection)
    {
      /*
       * The same msection will be used for the stack and the heap, so
       * adjust the heap and stack limits accordingly.  3/4 of the
       * remaining usable space is assigned to the heap.
       */

      ___SIZE_TS space = alloc_stack_ptr - alloc_stack_limit;

      if (space < 2*___MSECTION_FUDGE)
        fatal_heap_overflow ();

      space = (space - 2*___MSECTION_FUDGE) >> 2; /* 1/4 of usable space */

      alloc_stack_limit = alloc_stack_ptr - (space + ___MSECTION_FUDGE);
      alloc_heap_limit = alloc_heap_ptr + (3*space + ___MSECTION_FUDGE);
    }

#ifdef ENABLE_CONSISTENCY_CHECKS
  //  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
  //    zap_section (alloc_heap_ptr, alloc_heap_limit);
#endif
}


___HIDDEN void next_heap_msection_without_locking
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___msection *ms;
  words_prev_msections += alloc_heap_ptr - alloc_heap_start;
  ms = next_msection_without_locking (___ps, stack_msection);
  set_heap_msection_possibly_sharing_with_stack (___ps, ms);
}


___HIDDEN void next_heap_msection
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___msection *ms;
  words_prev_msections += alloc_heap_ptr - alloc_heap_start;
  ALLOC_MEM_LOCK();
  ms = next_msection_without_locking (___ps, stack_msection);
  ALLOC_MEM_UNLOCK();
  set_heap_msection_possibly_sharing_with_stack (___ps, ms);
}


___HIDDEN void prepare_heap_msection
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  /*
   * Heap chunks are non-empty, except possibly for the last chunk in
   * the msection.  Consequently, an msection may end with 2
   * consecutive end of chunk markers.  One for the last non-empty
   * chunk and one for an empty chunk.  The heap allocation limit must
   * be adjusted to handle this case.
   */

  alloc_heap_limit -= 2; /* leave space for 2 end of chunk markers */

  *alloc_heap_ptr++ = NULL_CHUNK_LINK; /* link of msection's first chunk */

  start_heap_chunk (___ps);
}


___HIDDEN void setup_stack_heap_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___vms->mem.var

  ___msection *alloc = the_msections->head;
  int np = ___vms->processor_count;
  int i;

  for (i=0; i<np; i++)
    {
      ___processor_state ___ps = ___PSTATE_FROM_PROCESSOR_ID(i,___vms);

      tospace_offset = fromspace_offset;  /* Flip fromspace and tospace */

      msection_free_list = 0;

      words_prev_msections = 0;

      stack_msection = 0;
      heap_msection = 0;

      set_stack_msection (___ps, alloc);
      alloc = alloc->next;

      alloc_msection = alloc;

      set_heap_msection (___ps, alloc);
      alloc = alloc->next;

      prepare_heap_msection (___ps);
      scan_ptr = alloc_heap_chunk_start;

      heap_chunks_to_scan = NULL_CHUNK_LINK;
      heap_chunks_to_scan_head = &heap_chunks_to_scan;
      heap_chunks_to_scan_tail = &heap_chunks_to_scan;
    }

  nb_msections_assigned = np*2;

#ifndef ___SINGLE_THREADED_VMS

  /* Initialize the active scanning workers count */

  scan_workers_count[0] = np;
  scan_workers_count[1] = np;

#endif

#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var
}


/*---------------------------------------------------------------------------*/

#ifdef ENABLE_CONSISTENCY_CHECKS

#define mark_array(start,n) mark_array_debug (start,n,__LINE__)

___HIDDEN void mark_array_debug
   ___P((___PSD
         ___WORD *start,
         ___WORD n,
         int line),
        (___PSV
         start,
         n,
         line)
___PSDKR
___WORD *start;
___WORD n;
int line;)

#else

___HIDDEN void mark_array
   ___P((___PSD
         ___WORD *start,
         ___WORD n),
        (___PSV
         start,
         n)
___PSDKR
___WORD *start;
___WORD n;)

#endif
{
  ___PSGET
  ___WORD *alloc = alloc_heap_ptr;
  ___WORD *limit = alloc_heap_limit;

#ifdef ENABLE_CONSISTENCY_CHECKS
  mark_array_call_line = line;
#endif

  while (n-- > 0)
    {
      ___WORD *cell = start++;

    again: /* looping back here is possible when tail marking */
      {
        ___WORD obj = *cell;

        if (___MEM_ALLOCATED(obj))
          {
            ___WORD *body;
            ___WORD head;
            int head_typ;
            int subtype;

#ifdef ENABLE_CONSISTENCY_CHECKS
            if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
              validate_old_obj (___PSP obj);
#endif

            body = ___BODY0(obj);
            head = body[-1];
            subtype = ___HD_SUBTYPE(head);
            head_typ = ___HD_TYP(head);

            if (head_typ == ___MOVABLE0)
              {
                ___SIZE_TS words = ___HD_WORDS(head);
                /*TODO: add allocation of handle if using handles*/
#if ___WS == 4
                ___BOOL pad = 0;
                while (alloc + words + (subtype >= ___sS64VECTOR ? 2 : 1) >
                       limit)
#else
                while (alloc + words + 1 > limit)
#endif
                  {
                    alloc_heap_ptr = alloc;
                    end_heap_chunk (___ps);
                    next_heap_msection (___ps);
                    prepare_heap_msection (___ps);
                    alloc = alloc_heap_ptr;
                    limit = alloc_heap_limit;
                  }
#if ___WS != 8
                /*
                 * ___sS64VECTOR, ___sU64VECTOR, ___sF64VECTOR,
                 * ___sFLONUM and ___sBIGNUM need to be aligned on a
                 * multiple of 8.
                 */
                if (subtype >= ___sS64VECTOR)
                  {
                    if ((___CAST(___WORD,alloc) & (8-1)) == 0)
                      *alloc++ = ___MAKE_HD_WORDS(0, ___sVECTOR);
                    else
                      pad = 1;
                  }
#endif
                *alloc++ = head;

#ifdef ___SINGLE_THREADED_VMS

                body[-1] = ___TAG(alloc - ___REFERENCE_TO_BODY, ___FORW);

#else

                {
                  ___WORD head_now =
                    ___COMPARE_AND_SWAP_WORD(&body[-1],
                                             head,
                                             ___TAG(alloc - ___REFERENCE_TO_BODY, ___FORW));

                  if (head_now != head)
                    {
                      /*
                       * Other processor forwarded the object first so
                       * the allocation must be undone and head_now is
                       * the correct forwarding pointer.
                       */

                      alloc--;
                      *cell = ___TAG(___UNTAG_AS(head_now, ___FORW), ___TYP(obj));
                      continue;
                    }
                }

#endif

                *cell = ___TAG(alloc - ___REFERENCE_TO_BODY, ___TYP(obj));

                if (words > 0 && subtype <= ___sBOXVALUES)
                  cell = alloc;
                else
                  cell = 0;

                while (words > 0)
                  {
                    *alloc++ = *body++;
                    words--;
                  }
#if ___WS == 4
                if (pad)
                  *alloc++ = ___MAKE_HD_WORDS(0, ___sVECTOR);
#endif
                if (alloc >= alloc_heap_chunk_limit)
                  {
                    alloc_heap_ptr = alloc;
                    end_heap_chunk (___ps);
                    start_heap_chunk (___ps);
                    alloc = alloc_heap_ptr;
                  }

                if (cell != 0) goto again;
              }
            else if (head_typ == ___STILL)
              {
#ifdef ___SINGLE_THREADED_VMS

                if (body[___STILL_MARK - ___STILL_BODY] == -1)
                  {
                    body[___STILL_MARK - ___STILL_BODY]
                      = ___CAST(___WORD,still_objs_to_scan);
                    still_objs_to_scan
                      = ___CAST(___WORD,body - ___STILL_BODY);
                  }

#else

                if (___COMPARE_AND_SWAP_WORD(&body[___STILL_MARK - ___STILL_BODY],
                                             -1,
                                             ___CAST(___WORD,still_objs_to_scan))
                    == -1)
                  {
                    still_objs_to_scan
                      = ___CAST(___WORD,body - ___STILL_BODY);
                  }
#endif
              }
            else if (___TYP(head_typ) == ___FORW)
              {
                *cell = ___TAG(___UNTAG_AS(head, ___FORW), ___TYP(obj));
              }
#ifdef ENABLE_CONSISTENCY_CHECKS
            else if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1 &&
                     head_typ != ___PERM)
              bug (___PSP obj, 0, "was not ___PERM, ___STILL, ___MOVABLE0 or ___FORW");
#endif
          }
      }
    }

  alloc_heap_ptr = alloc;
}


___HIDDEN void mark_captured_continuation
   ___P((___PSD
         ___WORD *orig_ptr),
        (___PSV
         orig_ptr)
___PSDKR
___WORD *orig_ptr;)
{
  ___PSGET
  ___WORD *ptr = orig_ptr;
  int fs, link, i;
  ___WORD *fp;
  ___WORD ra1;
  ___WORD ra2;
  ___WORD cf;

  cf = *ptr;

#ifdef SHOW_FRAMES
  ___printf ("mark_captured_continuation cf=%p\n", ___CAST(void*,cf));
#endif

  if (___TYP(cf) == ___tFIXNUM && cf != ___END_OF_CONT_MARKER)
    {
      /* continuation frame is in the stack */

      ___WORD *alloc = alloc_heap_ptr;
      ___WORD *limit = alloc_heap_limit;

      MISC_MEM_LOCK();

      next_frame:

      fp = ___CAST(___WORD*,cf);

      ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

#ifdef SHOW_FRAMES
        ___printf ("  frame [ra=0x%" ___PRIxWORD "] ", ra1);
#endif

      if (ra1 == ___GSTATE->internal_return)
        {
          ___WORD actual_ra = ___FP_STK(fp,___RETI_RA);
          ___RETI_GET_FS_LINK(actual_ra,fs,link)
          ___COVER_MARK_CAPTURED_CONTINUATION_RETI;
        }
      else
        {
          ___RETN_GET_FS_LINK(ra1,fs,link)
          ___COVER_MARK_CAPTURED_CONTINUATION_RETN;
        }

#ifdef SHOW_FRAMES
        ___printf ("fs=%d link=%d fp=%p ra=", fs, link, fp);
        print_value (ra1);
        ___printf ("\n");
#endif

      ___FP_ADJFP(fp,-___FRAME_SPACE(fs)) /* get base of frame */

      ra2 = ___FP_STK(fp,link+1);

      if (___TYP(ra2) == ___tFIXNUM)
        {
          ___COVER_MARK_CAPTURED_CONTINUATION_ALREADY_COPIED;
          *ptr = ra2; /* already copied, replace by forwarding pointer */
        }
      else
        {
          ___WORD forw;
          ___SIZE_TS words;

          ___COVER_MARK_CAPTURED_CONTINUATION_COPY;

          words = fs + ___FRAME_EXTRA_SLOTS;

          while (alloc + words + ___SUBTYPED_BODY > limit)
            {
              alloc_heap_ptr = alloc;
              end_heap_chunk (___ps);
              next_heap_msection (___ps);
              prepare_heap_msection (___ps);
              alloc = alloc_heap_ptr;
              limit = alloc_heap_limit;
            }

          /*TODO: add allocation of handle if using handles*/

          *alloc++ = ___MAKE_HD_WORDS(words, ___sFRAME);
#if ___SUBTYPED_BODY != 1
          #error "___SUBTYPED_BODY != 1"
#endif
          forw = ___TAG(alloc - ___REFERENCE_TO_BODY, ___tFIXNUM);
          *alloc++ = ra1;
#if ___FRAME_EXTRA_SLOTS != 1
          #error "___FRAME_EXTRA_SLOTS != 1"
#endif

          for (i=fs; i>0; i--)
            *alloc++ = ___FP_STK(fp,i);

          if (ra2 == ___GSTATE->handler_break)
            {
              /* first frame of that section */

              ___COVER_MARK_CAPTURED_CONTINUATION_FIRST_FRAME;

              cf = ___FP_STK(fp,-___BREAK_FRAME_NEXT);
            }
          else
            {
              /* not the first frame of that section */

              ___COVER_MARK_CAPTURED_CONTINUATION_NOT_FIRST_FRAME;

              ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)
              cf = ___CAST(___WORD,fp);
            }

          ___FP_SET_STK(alloc,link+1,cf)
          ___FP_SET_STK(fp,link+1,forw) /* leave a forwarding pointer */

          *ptr = forw;

          ptr = &___FP_STK(alloc,link+1);

          if (alloc_heap_ptr >= alloc_heap_chunk_limit)
            {
              alloc_heap_ptr = alloc;
              end_heap_chunk (___ps);
              start_heap_chunk (___ps);
              alloc = alloc_heap_ptr;
            }

          if (___TYP(cf) == ___tFIXNUM && cf != ___END_OF_CONT_MARKER)
            goto next_frame;
        }

      *orig_ptr = ___TAG(___UNTAG_AS(*orig_ptr, ___tFIXNUM), ___tSUBTYPED);

      alloc_heap_ptr = alloc;

      MISC_MEM_UNLOCK();
    }
  else
    mark_array (___PSP orig_ptr, 1);
}


___HIDDEN void mark_frame
   ___P((___PSD
         ___WORD *fp,
         int fs,
         ___WORD gcmap,
         ___WORD *nextgcmap),
        (___PSV
         fp,
         fs,
         gcmap,
         nextgcmap)
___PSDKR
___WORD *fp;
int fs;
___WORD gcmap;
___WORD *nextgcmap;)
{
  int i = 1;

  for (;;)
    {
      if (gcmap & 1)
        {
          int j = i;
          do
            {
              if (i == fs)
                {
#ifdef SHOW_FRAMES
                  {
                    int k = j;
                    while (k <= i)
                      {
                        ___WORD obj = ___FP_STK(fp,k);
                        ___printf ("  %2d: ", k);
                        print_value (obj);
                        ___printf ("\n");
                        k++;
                      }
                  }
#endif
                  mark_array (___PSP &___FP_STK(fp,i), i-j+1);
                  return;
                }
              if ((i & (___WORD_WIDTH-1)) == 0)
                gcmap = *nextgcmap++;
              else
                gcmap >>= 1;
              i++;
            } while (gcmap & 1);
#ifdef SHOW_FRAMES
          {
            int k = j;
            while (k < i)
              {
                ___WORD obj = ___FP_STK(fp,k);
                ___printf ("  %2d: ", k);
                print_value (obj);
                ___printf ("\n");
                k++;
              }
          }
#endif
          mark_array (___PSP &___FP_STK(fp,i-1), i-j);
        }
      if (i == fs)
        return;
      if ((i & (___WORD_WIDTH-1)) == 0)
        {
          gcmap = *nextgcmap++;
#ifdef SHOW_FRAMES
          ___printf ("gcmap = 0x%" ___PRIxWORD "\n", gcmap);
#endif
        }
      else
        gcmap >>= 1;
      i++;
    }
}


___HIDDEN void mark_continuation
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  int fs, link;
  ___WORD *fp;
  ___WORD ra1;
  ___WORD ra2;
  ___WORD gcmap;
  ___WORD *nextgcmap = 0;

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_CONTINUATION;
#endif

  fp = ___ps->fp;

#ifdef SHOW_FRAMES
  ___printf ("mark_continuation fp=%p\n", fp);
#endif

  if (fp != ___ps->stack_break)
    for (;;)
      {
        ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

#ifdef SHOW_FRAMES
        ___printf ("  frame [ra=0x%" ___PRIxWORD "] ", ra1);
#endif

        if (ra1 == ___GSTATE->internal_return)
          {
            ___WORD actual_ra = ___FP_STK(fp,___RETI_RA);
            ___RETI_GET_FS_LINK_GCMAP(actual_ra,fs,link,gcmap,nextgcmap)
            ___COVER_MARK_CONTINUATION_RETI;
          }
        else
          {
            ___RETN_GET_FS_LINK_GCMAP(ra1,fs,link,gcmap,nextgcmap)
            ___COVER_MARK_CONTINUATION_RETN;
          }

#ifdef SHOW_FRAMES
        ___printf ("fs=%d link=%d fp=%p ra=", fs, link, fp);
        print_value (ra1);
        ___printf ("\n");
#endif

        ___FP_ADJFP(fp,-___FRAME_SPACE(fs)) /* get base of frame */

        ra2 = ___FP_STK(fp,link+1);

#ifdef SHOW_FRAMES
        if (fp == ___ps->stack_break)
          ___printf ("  (first frame above break frame)\n");
#endif

        mark_frame (___PSP fp, fs, gcmap, nextgcmap);

        if (fp == ___ps->stack_break)
          break;

        ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)
      }

  mark_captured_continuation (___PSP &___FP_STK(fp,-___BREAK_FRAME_NEXT));
}


___HIDDEN void mark_rc
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___rc_header *h = rc_head.next;

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_RC;
#endif

  while (h != &rc_head)
    {
      ___rc_header *next = h->next;
      mark_array (___PSP &h->data, 1);
      h = next;
    }
}


#define UNMARKED_MOVABLE(obj) \
((unmarked_typ = ___HD_TYP((unmarked_body=___BODY0(obj))[-1])) == ___MOVABLE0)

#define UNMARKED_STILL(obj) \
(unmarked_typ == ___STILL && \
 unmarked_body[___STILL_MARK - ___STILL_BODY] == -1)

#define UNMARKED(obj) \
(UNMARKED_MOVABLE(obj) || UNMARKED_STILL(obj))


___HIDDEN ___SIZE_TS scan
   ___P((___PSD
         ___WORD *body,
         ___WORD head),
        (___PSV
         body,
         head)
___PSDKR
___WORD *body;
___WORD head;)
{
  ___PSGET
  ___SIZE_TS words = ___HD_WORDS(head);
  int subtype = ___HD_SUBTYPE(head);

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_OBJECT;
  container_body = body;
#endif

  switch (subtype)
    {
    case ___sFOREIGN:
    case ___sSTRING:
    case ___sS8VECTOR:
    case ___sU8VECTOR:
    case ___sS16VECTOR:
    case ___sU16VECTOR:
    case ___sS32VECTOR:
    case ___sU32VECTOR:
    case ___sS64VECTOR:
    case ___sU64VECTOR:
    case ___sF32VECTOR:
    case ___sF64VECTOR:
    case ___sFLONUM:
    case ___sBIGNUM:
      break;

    case ___sWEAK:
      if (words == ___WILL_SIZE)
        {
          /* Object is a will */

          /*
           * The will contains a weak reference to its testator object
           * and a strong reference to the action procedure.
           * Consequently, the action procedure must be marked and,
           * only if traverse_weak_refs is true, the testator object
           * is also marked.  The link field is never scanned.
           */

          if (traverse_weak_refs)
            mark_array (___PSP body+1, 2); /* scan action and testator */
          else
            {
              mark_array (___PSP body+2, 1); /* scan action only */

              /*
               * Remember that this will's testator object remains to
               * be marked by the process_wills function.
               */

              body[0] = body[0] | ___UNMARKED_TESTATOR_WILL;
            }
        }
      else
        {
          /* Object is a GC hash table */

          int flags = ___INT(body[___GCHASHTABLE_FLAGS]);
          int i;

          if ((flags & ___GCHASHTABLE_FLAG_WEAK_KEYS) == 0 &&
              (flags & ___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS))
            {
              for (i=words-2; i>=___GCHASHTABLE_KEY0; i-=2)
                mark_array (___PSP body+i, 1); /* mark objects in key fields */
            }

          if ((flags & ___GCHASHTABLE_FLAG_WEAK_VALS) == 0)
            {
              for (i=words-1; i>=___GCHASHTABLE_VAL0; i-=2)
                mark_array (___PSP body+i, 1); /* mark objects in value fields */
            }

          body[0] = reached_gc_hash_tables;
          reached_gc_hash_tables = ___CAST(___WORD,body);
        }
      break;

    case ___sSYMBOL:
    case ___sKEYWORD:
      mark_array (___PSP body, 1); /* only scan name of symbols & keywords */
      break;

    case ___sCONTINUATION:
      mark_captured_continuation (___PSP &body[___CONTINUATION_FRAME]);
      mark_array (___PSP body+1, words-1); /* skip the frame pointer */
      break;

    case ___sFRAME:
      {
        int fs, link;
        ___WORD *fp = body + ___FRAME_EXTRA_SLOTS;
        ___WORD ra = body[0];
        ___WORD gcmap;
        ___WORD *nextgcmap = 0;
        ___WORD frame;

#ifdef SHOW_FRAMES
        ___printf ("___sFRAME object\n");
        ___printf ("  frame [ra=0x%" ___PRIxWORD "] ", ra);
#endif

        if (ra == ___GSTATE->internal_return)
          {
            ___WORD actual_ra = body[___FRAME_RETI_RA];
            ___RETI_GET_FS_LINK_GCMAP(actual_ra,fs,link,gcmap,nextgcmap)
            ___COVER_SCAN_FRAME_RETI;
          }
        else
          {
            ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
            ___COVER_SCAN_FRAME_RETN;
          }

#ifdef SHOW_FRAMES
        ___printf ("fs=%d link=%d fp=%p ra=", fs, link, fp);
        print_value (ra);
        ___printf ("\n");
#endif

        fp += fs;

        frame = ___FP_STK(fp,link+1);

        if (___TYP(frame) == ___tFIXNUM && frame != ___END_OF_CONT_MARKER)
          ___FP_SET_STK(fp,link+1,___FAL)

        mark_frame (___PSP fp, fs, gcmap, nextgcmap);

        if (___TYP(frame) == ___tFIXNUM && frame != ___END_OF_CONT_MARKER)
          ___FP_SET_STK(fp,link+1,___TAG(___UNTAG_AS(frame, ___tFIXNUM), ___tSUBTYPED))

        mark_array (___PSP &body[0], 1);
      }
      break;

    case ___sPROCEDURE:

      /*
       * The object can only be a closure (nonclosures are permanent objects).
       */

#ifdef ___SUPPORT_LOWLEVEL_EXEC

      /* update the closure's lowlevel code trampoline */

      ___CLO_LOWLEVEL_TRAMPOLINE_SETUP(body,
                                       body[___LABEL_ENTRY_OR_DESCR]);

#endif

      /* only need to scan the free variables */

      mark_array (___PSP body+___CLO_FREEVARS, words-___CLO_FREEVARS);

      break;

    default:

      if (___HD_TYP(head) == ___MOVABLE0 && subtype <= ___sBOXVALUES)
        mark_array (___PSP body+1, words-1);
      else
        mark_array (___PSP body, words);

      break;
    }

  return words;
}


#define scan_no_fast_path(ptr, head) \
do { \
  ptr += scan (___PSP (ptr)+1, head) + 1; \
} while (0)


#ifdef ___USE_SCAN_NO_FAST_PATH

#define scan_and_advance(ptr, head) scan_no_fast_path(ptr, head)

#else

#define scan_and_advance(ptr, head) \
do { \
  if ((head) == ___MAKE_HD_WORDS(___PAIR_SIZE,___sPAIR)) \
    { \
      mark_array (___PSP (ptr)+2, ___PAIR_SIZE-1); \
      ptr += ___PAIR_SIZE+1; \
    } \
  else \
    scan_no_fast_path(ptr, head); \
} while (0)

#endif


___HIDDEN void setup_still_objs_to_scan
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___WORD *base = ___CAST(___WORD*,still_objs);
  ___WORD *to_scan = 0;

  while (base != 0)
    {
      if (base[___STILL_REFCOUNT] == 0)
        base[___STILL_MARK] = -1;
      else
        {
          base[___STILL_MARK] = ___CAST(___WORD,to_scan);
          to_scan = base;
        }
      base = ___CAST(___WORD*,base[___STILL_LINK]);
    }

  still_objs_to_scan = ___CAST(___WORD,to_scan);
}


___HIDDEN void scan_still_objs_to_scan
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___WORD *base;

  while ((base = ___CAST(___WORD*,still_objs_to_scan)) != 0)
    {
      ___WORD *body = base + ___STILL_BODY;
      still_objs_to_scan = base[___STILL_MARK];
      scan (___PSP body, body[-1]);
    }
}


___HIDDEN void scan_complete_heap_chunk
   ___P((___PSD
         ___WORD *start),
        (___PSV
         start)
___PSDKR
___WORD *start;)
{
  ___PSGET
  ___WORD *ptr = start;
  ___WORD head;

#ifdef ENABLE_GC_ACTLOG_SCAN_COMPLETE_HEAP_CHUNK
  ___ACTLOG_BEGIN_PS(scan_complete_heap_chunk,_);
#endif

  while (___TYP((head = *ptr)) != ___FORW) /* not end of complete chunk? */
    {
      scan_and_advance(ptr, head); /* note: this advances ptr */
    }

#ifdef ENABLE_GC_ACTLOG_SCAN_COMPLETE_HEAP_CHUNK
  ___ACTLOG_END_PS();
#endif
}


___HIDDEN void scan_movable_objs_to_scan
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  /*

    SITUATION #1: scanning a complete chunk

     chunk 1  chunk 2   chunk 3   incomplete chunk
    +-------+---------+---------+------------------+-----
    |L      |L        |L        |L                 |
    +-------+---------+---------+------------------+-----
                 ^                                  ^
          scan_ptr                                  alloc_heap_ptr


    SITUATION #2: scanning the incomplete chunk

     chunk 1  chunk 2   chunk 3   incomplete chunk
    +-------+---------+---------+------------------+-----
    |L      |L        |L        |L                 |
    +-------+---------+---------+------------------+-----
                                         ^          ^
                                  scan_ptr          alloc_heap_ptr


    SITUATION #3: done scanning all movable objects

     chunk 1  chunk 2   chunk 3   incomplete chunk
    +-------+---------+---------+------------------+-----
    |L      |L        |L        |L                 |
    +-------+---------+---------+------------------+-----
                                                    ^
                                            scan_ptr alloc_heap_ptr

     L = link to next chunk tagged with ___FORW

   */

  ___WORD *ptr = scan_ptr;
  ___VOLATILE ___WORD *hcsh;

  while (ptr != alloc_heap_ptr) /* SITUATION #1 or #2 ? */
    {
      ___WORD head;
      while (___TYP((head = *ptr)) != ___FORW) /* not end of complete chunk? */
        {
          scan_and_advance(ptr, head); /* note: this advances ptr */
          if (ptr == alloc_heap_ptr) /* end of incomplete chunk? */
            {
              /* SITUATION #3, done scanning all movable objects */
              scan_ptr = ptr;
              return;
            }
        }

      scan_ptr = ptr; /* remember where scan ended */

      /*
       * SITUATION #1, at end of complete chunk.
       */

      ___SPINLOCK_LOCK(heap_chunks_to_scan_lock);

      while ((hcsh=heap_chunks_to_scan_head) != heap_chunks_to_scan_tail)
        {
          /*
           * Get the next complete heap chunk from heap chunk FIFO and
           * scan it.
           */

          ptr = ___UNTAG_AS(*hcsh, ___FORW);

          heap_chunks_to_scan_head = ptr;

          ___SHARED_MEMORY_BARRIER(); /* share heap_chunks_to_scan_head */

          ___SPINLOCK_UNLOCK(heap_chunks_to_scan_lock);

          scan_complete_heap_chunk (___PSP ptr+1);

          ___SPINLOCK_LOCK(heap_chunks_to_scan_lock);
        }

      ___SPINLOCK_UNLOCK(heap_chunks_to_scan_lock);

      /*
       * Scan the incomplete heap chunk currently being created.
       */

      ptr = alloc_heap_chunk_start;

      scan_ptr = ptr;
    }
}


___HIDDEN void free_unmarked_still_objs
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___WORD *last = &still_objs;
  ___WORD *base = ___CAST(___WORD*,*last);
  ___SIZE_TS live_words_still = 0;

  while (base != 0)
    {
      ___WORD link = base[___STILL_LINK];
      if (base[___STILL_MARK] == -1)
        {
          ___WORD head = base[___STILL_BODY-1];
          if (___HD_SUBTYPE(head) == ___sFOREIGN)
            ___release_foreign
              (___TAG(base + ___STILL_BODY - ___REFERENCE_TO_BODY, ___tSUBTYPED));
          free_mem_aligned_heap (base);
        }
      else
        {
          live_words_still += base[___STILL_LENGTH];
          *last = ___CAST(___WORD,base);
          last = base + ___STILL_LINK;
        }
      base = ___CAST(___WORD*,link);
    }

  *last = 0;

  words_still_objs = live_words_still;
  words_still_objs_deferred = 0;

  /*
   * In principle the occupied_words_still could be updated here but
   * this would require acquiring a lock, so instead the
   * occupied_words_still will be recomputed from all of the
   * processor's words_still_objs when computing the space occupied by
   * live objects prior to resizing the heap.
   */
}


___HIDDEN void free_still_objs
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___WORD *base = ___CAST(___WORD*,still_objs);

  still_objs = 0;

  while (base != 0)
    {
      ___WORD link = base[___STILL_LINK];
      ___WORD head = base[___STILL_BODY-1];
      if (___HD_SUBTYPE(head) == ___sFOREIGN)
        ___release_foreign
          (___TAG(base + ___STILL_BODY - ___REFERENCE_TO_BODY, ___tSUBTYPED));
      free_mem_aligned_heap (base);
      base = ___CAST(___WORD*,link);
    }
}


___HIDDEN ___SIZE_TS adjust_heap
   ___P((___SIZE_TS live),
        (live)
___SIZE_TS live;)
{
  ___SIZE_TS target;

  if (___GSTATE->setup_params.adjust_heap_hook != 0)
    return ___GSTATE->setup_params.adjust_heap_hook (live);

  if (___GSTATE->setup_params.live_percent < 100)
    target = live / ___GSTATE->setup_params.live_percent * 100;
  else
    target = live + ___MSECTION_BIGGEST;

  SET_MAX(target,
          ___CAST(___SIZE_TS,(___GSTATE->setup_params.min_heap >> ___LWS)));

  if (___GSTATE->setup_params.max_heap > 0)
    SET_MIN(target,
            ___CAST(___SIZE_TS,(___GSTATE->setup_params.max_heap >> ___LWS)));

  return target;
}


___HIDDEN void prepare_mem_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SIZE_TS avail;
  ___SIZE_TS stack_avail;
  ___SIZE_TS stack_left_before_fudge;
  ___SIZE_TS heap_avail;
  ___SIZE_TS heap_left_before_fudge;

#ifdef ___CALL_GC_FREQUENTLY
  avail = 0;
  ___ps->mem.gc_calls_to_punt_ = 2000;
#else
  avail = compute_free_heap_space()/2;
  SET_MAX(avail,0);
#endif

  stack_avail = avail/2;
  stack_left_before_fudge = (alloc_stack_ptr - alloc_stack_limit)
                            - ___MSECTION_FUDGE;

  ___ps->fp = alloc_stack_ptr;
  ___ps->stack_limit = alloc_stack_ptr
                       - ((stack_avail < stack_left_before_fudge)
                          ? stack_avail
                          : stack_left_before_fudge);

  heap_avail = avail - stack_avail;
  heap_left_before_fudge = (alloc_heap_limit - alloc_heap_ptr)
                           - ___MSECTION_FUDGE;

  ___ps->hp = alloc_heap_ptr;
  ___ps->heap_limit = alloc_heap_ptr
                      + ((heap_avail < heap_left_before_fudge)
                         ? heap_avail
                         : heap_left_before_fudge);

  /* set stack overflow and interrupt detection limit */

  ___refresh_interrupts_pstate (___ps);

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
    {
      ___WORD *end = ___ps->stack_limit;
      ___WORD *start = end - ___MSECTION_FUDGE;
      if (end > alloc_stack_ptr)
        end = alloc_stack_ptr;
      zap_section (start, end);
      if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) == 3)
        {
          ___printf ("heap_size          = %d\n", heap_size);
          ___printf ("avail              = %d\n", avail);
          ___printf ("stack_avail        = %d\n", stack_avail);
          ___printf ("heap_avail         = %d\n", heap_avail);
          ___printf ("stack_msection     = %p\n", stack_msection);
          ___printf ("heap_msection      = %p\n", heap_msection);
          ___printf ("___ps->stack_start = %p\n", ___ps->stack_start);
          ___printf ("___ps->stack_break = %p\n", ___ps->stack_break);
          ___printf ("___ps->fp          = %p\n", ___ps->fp);
          ___printf ("alloc_stack_ptr    = %p\n", alloc_stack_ptr);
          ___printf ("___ps->stack_limit = %p\n", ___ps->stack_limit);
          ___printf ("alloc_stack_limit  = %p\n", alloc_stack_limit);
          ___printf ("alloc_heap_limit   = %p\n", alloc_heap_limit);
          ___printf ("___ps->heap_limit  = %p\n", ___ps->heap_limit);
          ___printf ("___ps->hp          = %p\n", ___ps->hp);
          ___printf ("alloc_heap_ptr     = %p\n", alloc_heap_ptr);
          ___printf ("alloc_heap_start   = %p\n", alloc_heap_start);
        }
    }
#endif
}


___SCMOBJ ___setup_mem_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___SCMOBJ err;

  /*
   * Setup processor's activity log.
   */

  if ((err = ___setup_actlog_pstate (___ps)) != ___FIX(___NO_ERR))
    return err;

  /*
   * Setup location of tospace.
   */

  tospace_offset = ___PSTATE_FROM_PROCESSOR_ID(0,___vms)->mem.tospace_offset_;

  ___SPINLOCK_INIT(heap_chunks_to_scan_lock);

  /*
   * Allocate processor's stack and heap.
   */

  msection_free_list = 0;

  words_prev_msections = 0;

  stack_msection = 0;
  alloc_stack_start = 0;
  alloc_stack_ptr = 0;

  heap_msection = 0;
  alloc_heap_start = 0;
  alloc_heap_ptr = 0;

  next_stack_msection (___ps); /* allocate one msection for stack */
  next_heap_msection (___ps);  /* allocate one msection for local heap */

  /* Setup list of still objects. */

  still_objs = 0;
  words_still_objs = 0;
  words_still_objs_deferred = 0;

  /* Keep track of bytes allocated */

  bytes_allocated_minus_occupied = 0.0;

  /*
   * Setup reference counted memory management.
   */

  setup_rc (___ps);

  /*
   * Create "first break frame" of initial top section.  This first
   * break frame has a null msection link because it is not created
   * due to a stack section overflow (this information is needed by
   * ___stack_overflow_undo_if_possible).
   */

  ___ps->stack_start = alloc_stack_start;
  alloc_stack_ptr = alloc_stack_start;

  ___FP_ADJFP(alloc_stack_ptr,___FIRST_BREAK_FRAME_SPACE)

  ___FP_SET_STK(alloc_stack_ptr,
                -___BREAK_FRAME_NEXT,
                ___END_OF_CONT_MARKER) /* no next frame */

  ___FP_SET_STK(alloc_stack_ptr,
                -___FIRST_BREAK_FRAME_STACK_MSECTION,
                ___CAST(___WORD,
                        ___CAST(___msection*,NULL))) /* not a stack section overflow */

  ___ps->stack_break = alloc_stack_ptr;

  /*
   * Setup will lists.
   */

  nonexecutable_wills = ___TAG(0,0); /* tagged empty list */
  executable_wills = ___TAG(0,___EXECUTABLE_WILL); /* tagged empty list */

#ifdef ___DEBUG_CTRL_FLOW_HISTORY

  {
    int i;
    ___ps->ctrl_flow_history_index = 0;
    for (i=___CTRL_FLOW_HISTORY_LENGTH-1; i>=0; i--)
      ___ps->ctrl_flow_history[i].line = 0;
  }

#endif

#ifdef ___DEBUG_STACK_LIMIT
  ___ps->poll_location.line = 0;
  ___ps->stack_limit_location.line = 0;
#endif

#ifdef ___DEBUG_HEAP_LIMIT
  ___ps->check_heap_location.line = 0;
  ___ps->heap_limit_location.line = 0;
#endif

#ifdef ___HEARTBEAT_USING_POLL_COUNTDOWN
  ___ps->heartbeat_interval = ___HEARTBEAT_USING_POLL_COUNTDOWN;
  ___ps->heartbeat_countdown = ___ps->heartbeat_interval;
#endif

  prepare_mem_pstate (___ps);

  return err;
}


___SCMOBJ ___setup_mem_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___vms->mem.var

  int init_nb_sections;

#ifndef ___SINGLE_THREADED_VMS

  /*
   * Initialize spinlock for VM level memory allocation.
   */

  ___SPINLOCK_INIT(misc_mem_lock);
  ___SPINLOCK_INIT(alloc_mem_lock);

  /*
   * Initialize condition variable to determine end of scan at VM level.
   */

  ___MUTEX_INIT(scan_termination_mutex);
  ___CONDVAR_INIT(scan_termination_condvar);

#endif

#ifndef ___SINGLE_VM

  /*
   * Add to tail of virtual machine circular list.
   */

  ___MUTEX_LOCK(___GSTATE->vm_list_mut);

  {
    ___virtual_machine_state head = &___GSTATE->vmstate0;
    ___virtual_machine_state tail = head->prev;

    ___vms->prev = tail;
    ___vms->next = head;
    head->prev = ___vms;
    tail->next = ___vms;
  }

  ___MUTEX_UNLOCK(___GSTATE->vm_list_mut);

  /* TODO: implement expansion of glos array when number of globals grows beyond 20000 */

  { int n = 20000;
    ___vms->glos = ___CAST(___SCMOBJ*,___ALLOC_MEM(n * sizeof (___SCMOBJ)));
    while (--n>=0) { ___vms->glos[n] = ___UNB1; }
  }

#endif

  /*
   * It is important to initialize the_msections first so
   * that if the program terminates early the procedure
   * ___cleanup_mem_vmstate will not access dangling pointers.
   */

  the_msections = 0;

  /*
   * Setup location of tospace.
   */

  ___PSTATE_FROM_PROCESSOR_ID(0,___vms)->mem.tospace_offset_ = 0;

  /*
   * Set the overflow reserve so that the rest parameter handler can
   * construct the rest parameter list without having to call the
   * garbage collector.
   */

  normal_overflow_reserve = 2*((___MAX_NB_PARMS+___SUBTYPED_BODY) +
                               ___MAX_NB_ARGS*(___PAIR_SIZE+___PAIR_BODY));
  overflow_reserve = normal_overflow_reserve;

  /* Setup GC statistics */

  nb_gcs = 0.0;
  gc_user_time = 0.0;
  gc_sys_time = 0.0;
  gc_real_time = 0.0;

  latest_gc_real_time = 0.0;
  latest_gc_heap_size = ___CAST(___F64,heap_size) * ___WS;
  latest_gc_live = 0.0;
  latest_gc_movable = 0.0;
  latest_gc_still = 0.0;

  /* No custom msection allocator */

  custom_msection_alloc = 0;

  /* Allocate msections of VM */

  init_nb_sections =
    ___MIN_NB_MSECTIONS_PER_PROCESSOR * ___vms->processor_count +
    ___CEILING_DIV((___GSTATE->setup_params.min_heap >> ___LWS) +
                   normal_overflow_reserve,
                   ___MSECTION_SIZE - 2*___MSECTION_FUDGE);

  adjust_msections (&the_msections, init_nb_sections);

  if (the_msections == 0 ||
      the_msections->nb_sections != init_nb_sections)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  occupied_words_movable = 0;
  occupied_words_still = 0;

  nb_msections_assigned = 0;

  heap_size = compute_heap_space();

  return ___FIX(___NO_ERR);

#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var
}


___SCMOBJ ___setup_mem ___PVOID
{
  if (___GSTATE->setup_params.min_heap == 0)
    {
      /*
       * Choose a reasonable minimum heap size.
       */

      ___GSTATE->setup_params.min_heap = ___cpu_cache_size (0, 0) / 2;

      SET_MAX(___GSTATE->setup_params.min_heap, ___DEFAULT_MIN_HEAP);
    }

  if (___GSTATE->setup_params.live_percent <= 0 ||
      ___GSTATE->setup_params.live_percent > 100)
    {
      /*
       * Choose a reasonable minimum live percent.
       */

      ___GSTATE->setup_params.live_percent = ___DEFAULT_LIVE_PERCENT;
    }

  /*
   * Setup psections.
   */

  ___GSTATE->mem.psections = 0;
  ___GSTATE->mem.palloc_ptr = 0;

  /*
   * Create empty global variable list, symbol table and keyword
   * table.
   */

  ___glo_list_setup ();

  {
    ___SCMOBJ t = alloc_symkey_table (___sSYMBOL, INIT_SYMBOL_TABLE_LENGTH);

    if (___FIXNUMP(t))
      return t;

    ___GSTATE->symbol_table = t;
  }

  {
    ___SCMOBJ t = alloc_symkey_table (___sKEYWORD, INIT_KEYWORD_TABLE_LENGTH);

    if (___FIXNUMP(t))
      return t;

    ___GSTATE->keyword_table = t;
  }

  return ___FIX(___NO_ERR);
}


void ___cleanup_mem_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  free_still_objs (___ps);
  cleanup_rc (___ps);
}


void ___cleanup_mem_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___vms->mem.var

#ifndef ___SINGLE_THREADED_VMS

  /*
   * Destroy spinlock for VM level memory allocation.
   */

  ___SPINLOCK_DESTROY(misc_mem_lock);
  ___SPINLOCK_DESTROY(alloc_mem_lock);

  /*
   * Destroy condition variable to determine end of scan at VM level.
   */

  ___CONDVAR_DESTROY(scan_termination_condvar);
  ___MUTEX_DESTROY(scan_termination_mutex);

#endif

  ___cleanup_mem_pstate (___PSTATE_FROM_PROCESSOR_ID(0,___vms));/*TODO: other processors?*/

  free_msections (&the_msections);

#ifndef ___SINGLE_VM

  /*
   * Remove from virtual machine circular list.
   */

  /* It is assumed that ___GSTATE->vm_list_mut is currently locked */

  {
    ___virtual_machine_state prev = ___vms->prev;
    ___virtual_machine_state next = ___vms->next;

    next->prev = prev;
    prev->next = next;
  }

#endif

#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var
}


void ___cleanup_mem ___PVOID
{
  free_psections ();
}


___HIDDEN void determine_will_executability
   ___P((___WORD list),
        (list)
___WORD list;)
{
  while (___UNTAG(list) != 0)
    {
      ___WORD* will_body = ___UNTAG(list) + ___SUBTYPED_BODY;
      ___WORD will_head = will_body[-1];
      ___WORD testator;

      ___WORD *unmarked_body; /* used by the UNMARKED macro */
      int unmarked_typ;

      if (___TYP(will_head) == ___FORW) /* was will forwarded? */
        will_body = ___BODY0_AS(will_head,___FORW);

      list = will_body[___WILL_NEXT];

      testator = will_body[___WILL_TESTATOR];

      if (___MEM_ALLOCATED(testator) &&
          UNMARKED(testator)) /* testator was not marked? */
        {
          /*
           * All paths to testator object from roots pass through
           * weak references, so mark will as executable.
           */

          will_body[___WILL_NEXT] = list | ___EXECUTABLE_WILL;
        }
    }
}


___HIDDEN void process_wills
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___WORD* tail_exec;
  ___WORD* tail_nonexec;
  ___WORD curr;

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_WILL_LIST;
#endif

  determine_will_executability (nonexecutable_wills);

  /*
   * Finish scanning the wills whose testator object remains to be
   * marked.
   *
   * The wills that have become executable are also transferred from
   * the nonexecutable wills list to the executable wills list.
   */

  tail_exec = &executable_wills;
  curr = *tail_exec;

  while (___UNTAG(curr) != 0)
    {
      ___WORD will = ___SUBTYPED_FROM_START(___UNTAG(curr));

      mark_array (___PSP &will, 1);

      *tail_exec = ___TAG(___SUBTYPED_TO_START(will),___EXECUTABLE_WILL);
      tail_exec = &___BODY0_AS(will,___tSUBTYPED)[___WILL_NEXT];
      curr = *tail_exec;
      if (curr & ___UNMARKED_TESTATOR_WILL)
        mark_array (___PSP tail_exec+___WILL_TESTATOR, 1); /* mark testator object */
    }

  tail_nonexec = &nonexecutable_wills;
  curr = *tail_nonexec;

  while (___UNTAG(curr) != 0)
    {
      ___WORD will = ___SUBTYPED_FROM_START(___UNTAG(curr));

      mark_array (___PSP &will, 1);

      if (___BODY0_AS(will,___tSUBTYPED)[___WILL_NEXT] & ___EXECUTABLE_WILL)
        {
          /* move will to executable will list */

          *tail_exec = ___TAG(___SUBTYPED_TO_START(will),___EXECUTABLE_WILL);
          tail_exec = &___BODY0_AS(will,___tSUBTYPED)[___WILL_NEXT];
          curr = *tail_exec;
          if (curr & ___UNMARKED_TESTATOR_WILL)
            mark_array (___PSP tail_exec+___WILL_TESTATOR, 1); /* mark testator object */
        }
      else
        {
          /* leave will in nonexecutable will list */

          *tail_nonexec = ___TAG(___SUBTYPED_TO_START(will),0);
          tail_nonexec = &___BODY0_AS(will,___tSUBTYPED)[___WILL_NEXT];
          curr = *tail_nonexec;
          if (curr & ___UNMARKED_TESTATOR_WILL)
            mark_array (___PSP tail_nonexec+___WILL_TESTATOR, 1); /* mark testator object */
        }
    }

  *tail_exec = ___TAG(0,___EXECUTABLE_WILL);
  *tail_nonexec = ___TAG(0,0);
}


___HIDDEN void process_gc_hash_tables
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___WORD curr = reached_gc_hash_tables;

  while (curr != ___TAG(0,0))
    {
      ___WORD* body = ___CAST(___WORD*,curr);
      ___SIZE_TS words = ___HD_WORDS(body[-1]);
      int flags = ___INT(body[___GCHASHTABLE_FLAGS]);
      int i;

      curr = body[___GCHASHTABLE_NEXT];

      body[___GCHASHTABLE_NEXT] = ___FIX(0);

      if (((___GCHASHTABLE_FLAG_WEAK_KEYS | ___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS)
           & flags) ==
          (___GCHASHTABLE_FLAG_WEAK_KEYS | ___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS))
        {
          if (flags & ___GCHASHTABLE_FLAG_WEAK_VALS)
            {
              /*
               * GC hash table is weak on keys and on values.
               */

              /*
               * Eliminate GC hash table entries with an unmarked key
               * or an unmarked value.
               */

              for (i=words-2; i>=___GCHASHTABLE_KEY0; i-=2)
                {
                  ___WORD *unmarked_body; /* used by the UNMARKED macro */
                  int unmarked_typ;

                  ___WORD key = body[i];
                  ___WORD val = body[i+1];

                  if (___MEM_ALLOCATED(key))
                    {
                      ___WORD key_head = ___BODY0(key)[-1];

                      if (___TYP(key_head) == ___FORW)
                        {
                          /*
                           * The key is movable and has been
                           * forwarded.
                           */

                          if (___MEM_ALLOCATED(val))
                            {
                              ___WORD val_head = ___BODY0(val)[-1];

                              if (___TYP(val_head) == ___FORW)
                                {
                                  /*
                                   * The key is movable and has been
                                   * forwarded and the value is
                                   * movable and has been forwarded,
                                   * so update key field and value
                                   * field and remember to rehash next
                                   * time the GC hash table is
                                   * accessed.
                                   */

                                  body[i] =
                                    ___TAG(___UNTAG_AS(key_head, ___FORW),
                                           ___TYP(key));
                                  body[i+1] =
                                    ___TAG(___UNTAG_AS(val_head, ___FORW),
                                           ___TYP(val));
                                  flags |= ___GCHASHTABLE_FLAG_KEY_MOVED;
                                }
                              else if (UNMARKED(val))
                                {
                                  /*
                                   * Change the entry to indicate it
                                   * has been deleted.
                                   */

                                  body[i] = ___DELETED;
                                  body[i+1] = ___UNUSED;
                                  body[___GCHASHTABLE_COUNT] =
                                    ___FIXSUB(body[___GCHASHTABLE_COUNT],
                                              ___FIX(1));
                                  flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                                }
                              else
                                {
                                  /*
                                   * The key is movable and has been
                                   * forwarded and the value is not
                                   * movable and is reachable, so
                                   * update key field and remember to
                                   * rehash next time the GC hash
                                   * table is accessed.
                                   */

                                  body[i] =
                                    ___TAG(___UNTAG_AS(key_head, ___FORW),
                                           ___TYP(key));
                                  flags |= ___GCHASHTABLE_FLAG_KEY_MOVED;
                                }
                            }
                          else
                            {
                              /*
                               * The key is movable and has been
                               * forwarded, and the value is not
                               * memory allocated, so update key field
                               * and remember to rehash next time the
                               * GC hash table is accessed.
                               */

                              body[i] =
                                ___TAG(___UNTAG_AS(key_head, ___FORW),
                                       ___TYP(key));
                              flags |= ___GCHASHTABLE_FLAG_KEY_MOVED;
                            }
                        }
                      else if (UNMARKED(key))
                        {
                          /*
                           * Change the entry to indicate it has been
                           * deleted.
                           */

                          body[i] = ___DELETED;
                          body[i+1] = ___UNUSED;
                          body[___GCHASHTABLE_COUNT] =
                            ___FIXSUB(body[___GCHASHTABLE_COUNT],___FIX(1));
                          flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                        }
                      else
                        {
                          /*
                           * The key is not movable and is reachable.
                           */

                          if (___MEM_ALLOCATED(val))
                            {
                              ___WORD val_head = ___BODY0(val)[-1];

                              if (___TYP(val_head) == ___FORW)
                                {
                                  /*
                                   * The key is not movable and is
                                   * reachable and the value is
                                   * movable and has been forwarded,
                                   * so update value field.
                                   */

                                  body[i+1] =
                                    ___TAG(___UNTAG_AS(val_head, ___FORW),
                                           ___TYP(val));
                                }
                              else if (UNMARKED(val))
                                {
                                  /*
                                   * Change the entry to indicate it
                                   * has been deleted.
                                   */

                                  body[i] = ___DELETED;
                                  body[i+1] = ___UNUSED;
                                  body[___GCHASHTABLE_COUNT] =
                                    ___FIXSUB(body[___GCHASHTABLE_COUNT],
                                              ___FIX(1));
                                  flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                                }
                              else
                                {
                                  /*
                                   * The key is not movable and is
                                   * reachable and the value is not
                                   * movable and is reachable, so
                                   * leave fields untouched.
                                   */
                                }
                            }
                          else
                            {
                              /*
                               * The key is not movable and is
                               * reachable and the value is not memory
                               * allocated, so leave fields untouched.
                               */
                            }
                        }
                    }
                  else
                    {
                      /*
                       * The key is not memory allocated.
                       */

                      if (___MEM_ALLOCATED(val))
                        {
                          ___WORD val_head = ___BODY0(val)[-1];

                          if (___TYP(val_head) == ___FORW)
                            {
                              /*
                               * The key is not memory allocated and
                               * the value is movable and has been
                               * forwarded, so update value field.
                               */

                              body[i+1] =
                                ___TAG(___UNTAG_AS(val_head, ___FORW),
                                       ___TYP(val));
                            }
                          else if (UNMARKED(val))
                            {
                              /*
                               * Change the entry to indicate it
                               * has been deleted.
                               */

                              body[i] = ___DELETED;
                              body[i+1] = ___UNUSED;
                              body[___GCHASHTABLE_COUNT] =
                                ___FIXSUB(body[___GCHASHTABLE_COUNT],
                                          ___FIX(1));
                              flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                            }
                          else
                            {
                              /*
                               * The key is not memory allocated and
                               * the value is not movable and is
                               * reachable, so leave fields untouched.
                               */
                            }
                        }
                      else
                        {
                          /*
                           * The key is not memory allocated and the
                           * value is not memory allocated, so leave
                           * fields untouched.
                           */
                        }
                    }
                }
            }
          else
            {
              /*
               * GC hash table is weak on keys only.
               */

              /*
               * Eliminate GC hash table entries with an unmarked key.
               */

              for (i=words-2; i>=___GCHASHTABLE_KEY0; i-=2)
                {
                  ___WORD *unmarked_body; /* used by the UNMARKED macro */
                  int unmarked_typ;

                  ___WORD key = body[i];

                  if (___MEM_ALLOCATED(key))
                    {
                      ___WORD head = ___BODY0(key)[-1];

                      if (___TYP(head) == ___FORW)
                        {
                          /*
                           * The key is movable and has been
                           * forwarded, so update key field and
                           * remember to rehash next time the
                           * GC hash table is accessed.
                           */

                          body[i] = ___TAG(___UNTAG_AS(head, ___FORW),
                                           ___TYP(key));
                          flags |= ___GCHASHTABLE_FLAG_KEY_MOVED;
                        }
                      else if (UNMARKED(key))
                        {
                          /*
                           * Change the entry to indicate it has been
                           * deleted.
                           */

                          body[i] = ___DELETED;
                          body[i+1] = ___UNUSED;
                          body[___GCHASHTABLE_COUNT] =
                            ___FIXSUB(body[___GCHASHTABLE_COUNT],___FIX(1));
                          flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                        }
                    }
                }
            }
        }
      else
        {
          if (flags & ___GCHASHTABLE_FLAG_WEAK_VALS)
            {
              /*
               * GC hash table is weak on values only.
               */

              /*
               * Eliminate GC hash table entries with an unmarked value.
               */

              for (i=words-2; i>=___GCHASHTABLE_KEY0; i-=2)
                {
                  ___WORD *unmarked_body; /* used by the UNMARKED macro */
                  int unmarked_typ;

                  ___WORD val = body[i+1];

                  if (___MEM_ALLOCATED(val))
                    {
                      ___WORD head = ___BODY0(val)[-1];

                      if (___TYP(head) == ___FORW)
                        {
                          /*
                           * The value is movable and has been
                           * forwarded, so update value field.
                           */

                          body[i+1] = ___TAG(___UNTAG_AS(head, ___FORW),
                                             ___TYP(val));
                        }
                      else if (UNMARKED(val))
                        {
                          /*
                           * Change the entry to indicate it has been
                           * deleted.
                           */

                          body[i] = ___DELETED;
                          body[i+1] = ___UNUSED;
                          body[___GCHASHTABLE_COUNT] =
                            ___FIXSUB(body[___GCHASHTABLE_COUNT],___FIX(1));
                          flags |= ___GCHASHTABLE_FLAG_ENTRY_DELETED;
                        }
                    }
                }
            }

          if (flags & ___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS)
            flags |= ___GCHASHTABLE_FLAG_KEY_MOVED; /* assume worst case */
        }

      body[___GCHASHTABLE_FLAGS] = ___FIX(flags);
    }
}


___HIDDEN void gc_hash_table_rehash_in_situ
   ___P((___SCMOBJ ht),
        (ht)
___SCMOBJ ht;)
{
  ___WORD* body = ___BODY_AS(ht,___tSUBTYPED);
  ___SIZE_TS words = ___HD_WORDS(body[-1]);
  int size2 = words - ___GCHASHTABLE_KEY0;
  int i;

  body[___GCHASHTABLE_FLAGS] =
    ___FIXAND(body[___GCHASHTABLE_FLAGS],
              ___FIXNOT(___FIX(___GCHASHTABLE_FLAG_KEY_MOVED)));

  if (!___FIXZEROP(___FIXAND(body[___GCHASHTABLE_FLAGS],
                             ___FIX(___GCHASHTABLE_FLAG_UNION_FIND))))
    {
#if 0

      /*
       * Compress paths.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___SCMOBJ val = body[i+___GCHASHTABLE_VAL0];
          if (___FIXNUMP(val)) /* parent links are encoded as fixnums */
            {
              if (!___FIXODDP(val)) { /* not compressed yet */
                int probe2 = ___INT(val);
                int prev2 = i;
                ___SCMOBJ x;
                for (;;) {
                  ___SCMOBJ v = body[probe2+___GCHASHTABLE_VAL0];
                  if (___FIXNUMP(v)) { /* link to parent? */
                    if (___FIXODDP(v)) { /* compressed path? */
                      x = v;
                      break;
                    }
                    body[probe2+___GCHASHTABLE_VAL0] = prev2;
                    prev2 = probe2;
                    probe2 = ___INT(v);
                  } else { /* reached root of class */
                    x = ___FIX(probe2+1);
                    break;
                  }
                }
                while (prev2 != i) {
                  probe2 = body[prev2+___GCHASHTABLE_VAL0];
                  body[prev2+___GCHASHTABLE_VAL0] = x;
                  prev2 = probe2;
                }
                body[i+___GCHASHTABLE_VAL0] = x;
              }
            }
        }

      for (i=size2-2; i>=0; i-=2)
        {
          ___SCMOBJ val = body[i+___GCHASHTABLE_VAL0];
          if (___FIXNUMP(val))
            body[i+___GCHASHTABLE_VAL0] = ___FIX(___INT(val)&~1);
        }

#endif

      /*
       * Replace entry values that are parent links by the key of
       * their parent.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___SCMOBJ val = body[i+___GCHASHTABLE_VAL0];
          if (___FIXNUMP(val)) /* parent links are encoded as fixnums */
            body[i+___GCHASHTABLE_VAL0] = body[___INT(val)+___GCHASHTABLE_KEY0];
        }
    }

  if (___FIXZEROP(___FIXAND(body[___GCHASHTABLE_FLAGS],
                            ___FIX(___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS))))
    {
      /*
       * Free deleted entries and mark key field of all active
       * entries.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___WORD key = body[i+___GCHASHTABLE_KEY0];
          if (key == ___DELETED)
            {
              body[i+___GCHASHTABLE_KEY0] = ___UNUSED;
              body[___GCHASHTABLE_FREE] =
                ___FIXADD(body[___GCHASHTABLE_FREE], ___FIX(1));
            }
          else if (key != ___UNUSED)
            body[i+___GCHASHTABLE_KEY0] = ___MEM_ALLOCATED_SET(key);
        }

      /*
       * Move the active entries.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___WORD key = body[i+___GCHASHTABLE_KEY0];

          if (___MEM_ALLOCATED(key))
            {
              /* this is an active entry that has not been moved yet */

              ___SCMOBJ val = body[i+___GCHASHTABLE_VAL0];
              ___SCMOBJ obj;
              int probe2;
              int step2;

              body[i+___GCHASHTABLE_KEY0] = ___UNUSED;
              body[i+___GCHASHTABLE_VAL0] = ___UNUSED;

            chain_non_mem_alloc:
              key = ___MEM_ALLOCATED_CLEAR(key); /* recover true encoding */
              ___GCHASHTABLE_HASH_STEP(probe2, step2, key, size2>>1);
              probe2 <<= 1;
              step2 <<= 1;

            next_non_mem_alloc:
              obj = body[probe2+___GCHASHTABLE_KEY0];

              if (obj == ___UNUSED)
                {
                  /* storing into an unused entry */

                  body[probe2+___GCHASHTABLE_KEY0] = key;
                  body[probe2+___GCHASHTABLE_VAL0] = val;
                }
              else if (___MEM_ALLOCATED(obj))
                {
                  /* storing into an active entry */

                  body[probe2+___GCHASHTABLE_KEY0] = key;
                  key = obj;
                  obj = body[probe2+___GCHASHTABLE_VAL0];
                  body[probe2+___GCHASHTABLE_VAL0] = val;
                  val = obj;
                  goto chain_non_mem_alloc; /* now move overwritten entry */
                }
              else
                {
                  /* an entry has been moved here, so keep looking */

                  probe2 -= step2;
                  if (probe2 < 0)
                    probe2 += size2;
                  goto next_non_mem_alloc;
                }
            }
        }
    }
  else
    {
      /*
       * Free deleted entries and mark key field of all active
       * entries.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___WORD key = body[i+___GCHASHTABLE_KEY0];
          if (key == ___DELETED)
            {
              body[i+___GCHASHTABLE_KEY0] = ___UNUSED;
              body[___GCHASHTABLE_FREE] =
                ___FIXADD(body[___GCHASHTABLE_FREE], ___FIX(1));
            }
          else if (key != ___UNUSED)
            body[i+___GCHASHTABLE_KEY0] = ___MEM_ALLOCATED_CLEAR(key);
        }

      /*
       * Move the active entries.
       */

      for (i=size2-2; i>=0; i-=2)
        {
          ___WORD key = body[i+___GCHASHTABLE_KEY0];

          if (key != ___UNUSED && !___MEM_ALLOCATED(key))
            {
              /* this is an active entry that has not been moved yet */

              ___SCMOBJ val = body[i+___GCHASHTABLE_VAL0];
              ___SCMOBJ obj;
              int probe2;
              int step2;

              body[i+___GCHASHTABLE_KEY0] = ___UNUSED;
              body[i+___GCHASHTABLE_VAL0] = ___UNUSED;

            chain_mem_alloc:
              key = ___MEM_ALLOCATED_SET(key); /* recover true encoding */
              ___GCHASHTABLE_HASH_STEP(probe2, step2, key, size2>>1);
              probe2 <<= 1;
              step2 <<= 1;

            next_mem_alloc:
              obj = body[probe2+___GCHASHTABLE_KEY0];

              if (obj == ___UNUSED)
                {
                  /* storing into an unused entry */

                  body[probe2+___GCHASHTABLE_KEY0] = key;
                  body[probe2+___GCHASHTABLE_VAL0] = val;
                }
              else if (!___MEM_ALLOCATED(obj))
                {
                  /* storing into an active entry */

                  body[probe2+___GCHASHTABLE_KEY0] = key;
                  key = obj;
                  obj = body[probe2+___GCHASHTABLE_VAL0];
                  body[probe2+___GCHASHTABLE_VAL0] = val;
                  val = obj;
                  goto chain_mem_alloc; /* now move overwritten entry */
                }
              else
                {
                  /* an entry has been moved here, so keep looking */

                  probe2 -= step2;
                  if (probe2 < 0)
                    probe2 += size2;
                  goto next_mem_alloc;
                }
            }
        }
    }
}


___SCMOBJ ___gc_hash_table_ref
   ___P((___SCMOBJ ht,
         ___SCMOBJ key),
        (ht,
         key)
___SCMOBJ ht;
___SCMOBJ key;)
{
  int size2;
  int probe2;
  int step2;
  ___SCMOBJ obj;

  if (!___FIXZEROP(___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
                             ___FIX(___GCHASHTABLE_FLAG_KEY_MOVED))))
    gc_hash_table_rehash_in_situ (ht);

  size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;
  ___GCHASHTABLE_HASH_STEP(probe2, step2, key, size2>>1);
  probe2 <<= 1;
  step2 <<= 1;
  obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

  if (___EQP(obj,key))
    return ___FIELD(ht, probe2+___GCHASHTABLE_VAL0);
  else if (!___EQP(obj,___UNUSED))
    {
      for (;;)
        {
          probe2 -= step2;
          if (probe2 < 0)
            probe2 += size2;
          obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

          if (___EQP(obj,key))
            return ___FIELD(ht, probe2+___GCHASHTABLE_VAL0);
          else if (___EQP(obj,___UNUSED))
            break;
        }
    }

  return ___UNUSED; /* key was not found */
}


___SCMOBJ ___gc_hash_table_set
   ___P((___SCMOBJ ht,
         ___SCMOBJ key,
         ___SCMOBJ val),
        (ht,
         key,
         val)
___SCMOBJ ht;
___SCMOBJ key;
___SCMOBJ val;)
{
  int size2;
  int probe2;
  int step2;
  ___SCMOBJ obj;

  if (!___FIXZEROP(___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
                             ___FIX(___GCHASHTABLE_FLAG_KEY_MOVED))))
    gc_hash_table_rehash_in_situ (ht);

  size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;
  ___GCHASHTABLE_HASH_STEP(probe2, step2, key, size2>>1);
  probe2 <<= 1;
  step2 <<= 1;
  obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

  if (!___EQP(val,___ABSENT))
    {
      /* trying to add or replace an entry */

      if (___EQP(obj,key))
        {
        replace_entry:
          ___FIELD(ht, probe2+___GCHASHTABLE_VAL0) = val;
        }
      else if (___EQP(obj,___UNUSED))
        {
        add_entry:
          ___FIELD(ht, probe2+___GCHASHTABLE_KEY0) = key;
          ___FIELD(ht, probe2+___GCHASHTABLE_VAL0) = val;
          ___FIELD(ht, ___GCHASHTABLE_COUNT) =
            ___FIXADD(___FIELD(ht, ___GCHASHTABLE_COUNT), ___FIX(1));
          if (___FIXNEGATIVEP(___FIELD(ht, ___GCHASHTABLE_FREE) =
                                ___FIXSUB(___FIELD(ht, ___GCHASHTABLE_FREE),
                                          ___FIX(1))))
            return ___TRU;
        }
      else
        {
          int deleted2 = -1;

          for (;;)
            {
              if (deleted2 < 0 && ___EQP(obj,___DELETED))
                deleted2 = probe2;

              probe2 -= step2;
              if (probe2 < 0)
                probe2 += size2;
              obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

              if (___EQP(obj,key))
                goto replace_entry;

              if (___EQP(obj,___UNUSED))
                {
                  if (deleted2 < 0)
                    goto add_entry;

                  ___FIELD(ht, deleted2+___GCHASHTABLE_KEY0) = key;
                  ___FIELD(ht, deleted2+___GCHASHTABLE_VAL0) = val;
                  ___FIELD(ht, ___GCHASHTABLE_COUNT) =
                    ___FIXADD(___FIELD(ht, ___GCHASHTABLE_COUNT), ___FIX(1));

                  break;
                }
            }
        }
    }
  else
    {
      /* trying to delete an entry */

      if (___EQP(obj,key))
        {
        delete_entry:
          ___FIELD(ht, probe2+___GCHASHTABLE_KEY0) = ___DELETED;
          ___FIELD(ht, probe2+___GCHASHTABLE_VAL0) = ___UNUSED;
          ___FIELD(ht, ___GCHASHTABLE_COUNT) =
            ___FIXSUB(___FIELD(ht, ___GCHASHTABLE_COUNT),
                      ___FIX(1));
          if (___FIXLT(___FIELD(ht, ___GCHASHTABLE_COUNT),
                       ___FIELD(ht, ___GCHASHTABLE_MIN_COUNT)))
            return ___TRU;
        }
      else if (!___EQP(obj,___UNUSED))
        {
          for (;;)
            {
              probe2 -= step2;
              if (probe2 < 0)
                probe2 += size2;
              obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

              if (___EQP(obj,key))
                goto delete_entry;

              if (___EQP(obj,___UNUSED))
                break;
            }
        }
    }

 /*
  * Hash table does not need to be resized.
  */

  return ___FAL;
}


#define FIND_COMPRESS_KEY(key,key_probe2,key_step2,obj,k,k_probe2,k_prev2,k_step2,o,k_p2) \
do {                                                                          \
  ___GCHASHTABLE_HASH_STEP(key_probe2,key_step2,key,size2>>1);                \
  key_probe2 <<= 1;                                                           \
  key_step2 <<= 1;                                                            \
  obj = ___FIELD(ht, key_probe2+___GCHASHTABLE_KEY0);                         \
                                                                              \
  while (!(___EQP(obj,key) || ___EQP(obj,___UNUSED)))                         \
    {                                                                         \
      key_probe2 -= key_step2;                                                \
      if (key_probe2 < 0)                                                     \
        key_probe2 += size2;                                                  \
      obj = ___FIELD(ht, key_probe2+___GCHASHTABLE_KEY0);                     \
    }                                                                         \
                                                                              \
  if (___EQP(obj,key))                                                        \
    {                                                                         \
      /*                                                                      \
       * key was found, compress its path.                                    \
       */                                                                     \
                                                                              \
      k = ___FIELD(ht, key_probe2+___GCHASHTABLE_VAL0);                       \
                                                                              \
      if (___SPECIALP(k))                                                     \
        {                                                                     \
          k_probe2 = key_probe2;                                              \
        }                                                                     \
      else                                                                    \
        {                                                                     \
          ___SCMOBJ k_prev2 = key_probe2;                                     \
                                                                              \
          for (;;)                                                            \
            {                                                                 \
              if (___FIXNUMP(k))                                              \
                {                                                             \
                  k_probe2 = ___INT(k);                                       \
                }                                                             \
              else                                                            \
                {                                                             \
                  ___SCMOBJ o;                                                \
                  ___SCMOBJ k_step2;                                          \
                  ___GCHASHTABLE_HASH_STEP(k_probe2,k_step2,k,size2>>1);      \
                  k_probe2 <<= 1;                                             \
                  k_step2 <<= 1;                                              \
                  o = ___FIELD(ht, k_probe2+___GCHASHTABLE_KEY0);             \
                                                                              \
                  while (!___EQP(o,k))                                        \
                    {                                                         \
                      k_probe2 -= k_step2;                                    \
                      if (k_probe2 < 0)                                       \
                        k_probe2 += size2;                                    \
                      o = ___FIELD(ht, k_probe2+___GCHASHTABLE_KEY0);         \
                    }                                                         \
                }                                                             \
                                                                              \
              k = ___FIELD(ht, k_probe2+___GCHASHTABLE_VAL0);                 \
                                                                              \
              if (___SPECIALP(k))                                             \
                break;                                                        \
                                                                              \
              ___FIELD(ht, k_probe2+___GCHASHTABLE_VAL0) = ___FIX(k_prev2);   \
              k_prev2 = k_probe2;                                             \
            }                                                                 \
                                                                              \
          for (;;)                                                            \
            {                                                                 \
              ___SCMOBJ k_p2 = ___INT(___FIELD(ht, k_prev2+___GCHASHTABLE_VAL0)); \
              ___FIELD(ht, k_prev2+___GCHASHTABLE_VAL0) = ___FIX(k_probe2);   \
              if (k_prev2 == key_probe2)                                      \
                break;                                                        \
              k_prev2 = k_p2;                                                 \
            }                                                                 \
        }                                                                     \
    }                                                                         \
 } while (0)


___SCMOBJ ___gc_hash_table_union_find
   ___P((___SCMOBJ ht,
         ___SCMOBJ key1,
         ___SCMOBJ key2,
         ___BOOL find),
        (ht,
         key1,
         key2,
         find)
___SCMOBJ ht;
___SCMOBJ key1;
___SCMOBJ key2;
___BOOL find;)
{
  /*
   * This function takes a GC hash table "ht", which must have its
   * ___GCHASHTABLE_FLAG_UNION_FIND flag set, and two memory allocated
   * objects "key1" and "key2", and determines if these objects are
   * part of the same equivalence class.  If "find" is false, the hash
   * table is modified to force these objects to be in the same
   * equivalence class (union operation).  The returned value
   * indicates which keys were found in the table, if they are part of
   * the same equivalence class and if the GC hash table needs to
   * grow.  The possible return values are:
   *
   *    0       key1 and key2 found in ht, and in same equiv class
   *    1       key1 and key2 found in ht, but not in same equiv class
   *    2 or 3  only one of key1 and key2 found in ht (2 = need to grow ht)
   *    4 or 5  neither key1 or key2 found in ht (4 = need to grow ht)
   */

  int size2;
  ___SCMOBJ key1_probe2;
  ___SCMOBJ key1_step2;
  ___SCMOBJ key2_probe2;
  ___SCMOBJ key2_step2;
  ___SCMOBJ allocated;
  ___SCMOBJ obj1;
  ___SCMOBJ obj2;
  ___SCMOBJ k1 = ___FIX(0);
  ___SCMOBJ k1_probe2 = ___FIX(0);
  ___SCMOBJ k2 = ___FIX(0);
  ___SCMOBJ k2_probe2 = ___FIX(0);

  if (!___FIXZEROP(___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
                             ___FIX(___GCHASHTABLE_FLAG_KEY_MOVED))))
    gc_hash_table_rehash_in_situ (ht);

  size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;

  /* Search for key1 */

  FIND_COMPRESS_KEY(key1,
                    key1_probe2,
                    key1_step2,
                    obj1,
                    k1,
                    k1_probe2,
                    k1_prev2,
                    k1_step2,
                    o1,
                    k1_p2);

  /* Search for key2 */

  FIND_COMPRESS_KEY(key2,
                    key2_probe2,
                    key2_step2,
                    obj2,
                    k2,
                    k2_probe2,
                    k2_prev2,
                    k2_step2,
                    o2,
                    k2_p2);

  /* What needs to be done depends on which keys were found */

  if (___EQP(obj1,key1))
    {
      if (___EQP(obj2,key2))
        {
          /* both key1 and key2 were found in the table */

          if (k1_probe2 == k2_probe2)
            return ___FIX(0); /* keys are in the same equiv class */

          if (find)
            return ___FIX(1); /* keys are not in the same equiv class */

          k1 = ___INT(k1);
          k2 = ___INT(k2);

          if (k1 > k2) /* choose biggest equivalence class */
            {
              ___FIELD(ht, k1_probe2+___GCHASHTABLE_VAL0) = ___SPECIAL(k1+k2);
              ___FIELD(ht, k2_probe2+___GCHASHTABLE_VAL0) = ___FIX(k1_probe2);
            }
          else
            {
              ___FIELD(ht, k2_probe2+___GCHASHTABLE_VAL0) = ___SPECIAL(k1+k2);
              ___FIELD(ht, k1_probe2+___GCHASHTABLE_VAL0) = ___FIX(k2_probe2);
            }

          return ___FIX(1);
        }
      else
        {
          /* key1 was found in the table, but key2 was not found */

          if (find)
            return ___FIX(3); /* keys are not in the same equiv class */

          k1 = ___INT(k1);

          ___FIELD(ht, k1_probe2+___GCHASHTABLE_VAL0) = ___SPECIAL(k1+1);
          ___FIELD(ht, key2_probe2+___GCHASHTABLE_KEY0) = key2;
          ___FIELD(ht, key2_probe2+___GCHASHTABLE_VAL0) = ___FIX(k1_probe2);
          allocated = 1;
        }
    }
  else
    {
      /* key1 was not found */

      if (___EQP(obj2,key2))
        {
          /* key2 was found in the table, but key1 was not found */

          if (find)
            return ___FIX(3); /* keys are not in the same equiv class */

          k2 = ___INT(k2);

          ___FIELD(ht, k2_probe2+___GCHASHTABLE_VAL0) = ___SPECIAL(k2+1);
          ___FIELD(ht, key1_probe2+___GCHASHTABLE_KEY0) = key1;
          ___FIELD(ht, key1_probe2+___GCHASHTABLE_VAL0) = ___FIX(k2_probe2);
          allocated = 1;
        }
      else
        {
          /* key1 and key2 were not found in the table */

          if (find)
            return ___FIX(5); /* keys are not in the same equiv class */

          ___FIELD(ht, key1_probe2+___GCHASHTABLE_KEY0) = key1;
          ___FIELD(ht, key1_probe2+___GCHASHTABLE_VAL0) = ___SPECIAL(2);

          if (key1_probe2 == key2_probe2)
            {
              /*
               * Both keys hash to the same entry so search for other
               * free entry.  This will succeed because GC hash tables
               * are guaranteed to have 2 free entries.
               */
              do
                {
                  key2_probe2 -= key2_step2;
                  if (key2_probe2 < 0)
                    key2_probe2 += size2;
                } while (!___EQP(___FIELD(ht, key2_probe2+___GCHASHTABLE_KEY0),
                                 ___UNUSED));
            }

          ___FIELD(ht, key2_probe2+___GCHASHTABLE_KEY0) = key2;
          ___FIELD(ht, key2_probe2+___GCHASHTABLE_VAL0) = ___FIX(key1_probe2);
          allocated = 2;
        }
    }

  ___FIELD(ht, ___GCHASHTABLE_COUNT) =
    ___FIXADD(___FIELD(ht, ___GCHASHTABLE_COUNT), ___FIX(allocated));

  if (___FIXNEGATIVEP(___FIELD(ht, ___GCHASHTABLE_FREE) =
                      ___FIXSUB(___FIELD(ht, ___GCHASHTABLE_FREE),
                                ___FIX(allocated))))
    return ___FIX(allocated*2); /* signal that table needs to grow */
  else
    return ___FIX(allocated*2+1); /* signal that table doesn't need to grow */
}


___SCMOBJ ___gc_hash_table_rehash
   ___P((___SCMOBJ ht_src,
         ___SCMOBJ ht_dst),
        (ht_src,
         ht_dst)
___SCMOBJ ht_src;
___SCMOBJ ht_dst;)
{
  ___SCMOBJ* body_src = ___BODY_AS(ht_src,___tSUBTYPED);
  ___SIZE_TS words = ___HD_WORDS(body_src[-1]);
  int size2 = words - ___GCHASHTABLE_KEY0;
  int i;

  if (___FIXZEROP(___FIXAND(body_src[___GCHASHTABLE_FLAGS],
                            ___FIX(___GCHASHTABLE_FLAG_UNION_FIND))))
    {
      for (i=size2-2; i>=0; i-=2)
        {
          ___SCMOBJ key = body_src[i+___GCHASHTABLE_KEY0];

          if (key != ___UNUSED &&
              key != ___DELETED)
            {
              ___SCMOBJ val = body_src[i+___GCHASHTABLE_VAL0];
              ___gc_hash_table_set (ht_dst, key, val);
            }
        }
    }
  else
    {
      for (i=size2-2; i>=0; i-=2)
        {
          ___SCMOBJ key = body_src[i+___GCHASHTABLE_KEY0];

          if (key != ___UNUSED)
            {
              ___SCMOBJ val = body_src[i+___GCHASHTABLE_VAL0];
              if (___FIXNUMP(val)) {
                val = body_src[___INT(val)+___GCHASHTABLE_KEY0];
              }
              ___gc_hash_table_set (ht_dst, key, val);
            }
        }
    }

  return ht_dst;
}


___HIDDEN void move_continuation
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  ___WORD *start;
  ___SIZE_TS length;
  ___WORD *p1;
  ___WORD *p2;

  start = ___ps->fp;
  length = (___ps->stack_break + ___FIRST_BREAK_FRAME_SPACE) - start;

  p1 = start + length;
  p2 = alloc_stack_ptr;

  ___ps->stack_start = alloc_stack_start;
  ___ps->stack_break = p2 - ___FIRST_BREAK_FRAME_SPACE;

  while (p1 != start)
    *--p2 = *--p1;

  alloc_stack_ptr = p2;

  ___FP_SET_STK(alloc_stack_ptr,
                -___FIRST_BREAK_FRAME_STACK_MSECTION,
                ___CAST(___WORD,
                        ___CAST(___msection*,NULL))) /* not a stack section overflow */
}


___HIDDEN void determine_occupied_words
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___vms->mem.var

  /*
   * Compute space occupied by live objects.
   */

  int p;
  int np = ___vms->processor_count;
  ___SIZE_TS movable = 0;
  ___SIZE_TS still = 0;
  ___F64 bytes_allocated = 0.0;

  for (p=0; p<np; p++)
    {
      ___processor_state ps = ___PSTATE_FROM_PROCESSOR_ID(p,___vms);

      movable += words_movable_objs(ps);

      still += ps->mem.words_still_objs_;

      /*
       * Note that at this point bytes_allocated_minus_occupied is
       * actually the number of bytes allocated by the processor.
       */

      bytes_allocated += ps->mem.bytes_allocated_minus_occupied_;
    }

  occupied_words_movable = movable;
  occupied_words_still = still;

  latest_gc_alloc = bytes_allocated;

#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var
}


___HIDDEN ___BOOL resize_heap
   ___P((___virtual_machine_state ___vms,
         ___SIZE_TS requested_words_still),
        (___vms,
         requested_words_still)
___virtual_machine_state ___vms;
___SIZE_TS requested_words_still;)
{
#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___vms->mem.var

  ___BOOL overflow = 0;
  ___SIZE_TS target_heap_space;
  ___SIZE_TS target_movable_space;
  int target_nb_sections;
  ___SIZE_TS live;

  determine_occupied_words (___vms);

  occupied_words_still += requested_words_still; /* pretend requested space is live */

  live = occupied_words_movable + occupied_words_still;

  /*
   * Determine the target size of the heap in msections given the
   * space requested for the still object.
   */

  target_heap_space = adjust_heap (live);

  if (live > target_heap_space)
    {
      /*
       * Trigger a recoverable heap overflow.
       */

      overflow = 1;

      /*
       * Take some space from the overflow reserve.
       */

      overflow_reserve >>= 5; /* make 96.875% of reserve usable */

      if (overflow_reserve == 0)
        fatal_heap_overflow ();

      /*
       * Cancel allocation of still object.
       */

      occupied_words_still -= requested_words_still;
      live -= requested_words_still;

      target_heap_space = adjust_heap (live);
    }

  if (live + normal_overflow_reserve <= target_heap_space)
    {
      /*
       * Now that there is enough free space, reset the overflow
       * reserve to its normal value.
       */

      overflow_reserve = normal_overflow_reserve;
    }

  target_movable_space = target_heap_space - occupied_words_still;

  SET_MAX(target_movable_space, 0);

  /*
   * Compute the number of msections required after the GC.  The code
   * reserves ___MIN_NB_MSECTIONS_PER_PROCESSOR per processor taking
   * the target number of processors into account in case the GC was
   * called as part of the resizing of the VM.
   */

  target_nb_sections =
    ___MIN_NB_MSECTIONS_PER_PROCESSOR * target_processor_count +
    ___CEILING_DIV(target_movable_space + normal_overflow_reserve,
                   ___MSECTION_SIZE - 2*___MSECTION_FUDGE);

  SET_MAX(target_nb_sections,
          nb_msections_assigned);

  adjust_msections (&the_msections, target_nb_sections);

  heap_size = compute_heap_space();

  /*
   * Maintain GC statistics.
   */

  latest_gc_heap_size = ___CAST(___F64,heap_size) * ___WS;

  latest_gc_live = ___CAST(___F64,live) * ___WS;
  latest_gc_movable = ___CAST(___F64,occupied_words_movable) * ___WS;
  latest_gc_still = ___CAST(___F64,occupied_words_still) * ___WS;

  return overflow;

#undef ___VMSTATE_MEM
#define ___VMSTATE_MEM(var) ___VMSTATE_FROM_PSTATE(___ps)->mem.var
}


___HIDDEN void mark_registers
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_REGISTER;
#endif

  mark_array (___PSP ___ps->r, sizeof(___ps->r)/sizeof(*___ps->r));
}


___HIDDEN void mark_saved
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_SAVED;
#endif

  mark_array (___PSP ___ps->saved, sizeof(___ps->saved)/sizeof(*___ps->saved));
}


___HIDDEN void mark_type_cache
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_TYPE_CACHE;
#endif

  mark_array (___PSP ___ps->type_cache, sizeof(___ps->type_cache)/sizeof(*___ps->type_cache));
}


___HIDDEN void mark_processor_scmobj
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_PROCESSOR_SCMOBJ;
#endif

  mark_array (___PSP
              ___BODY0_AS(___PROCESSOR_SCMOBJ(___ps),___tSUBTYPED),
              ___PROCESSOR_SIZE);
}


___HIDDEN void mark_vm_scmobj
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_VM_SCMOBJ;
#endif

  mark_array (___PSP
              ___BODY0_AS(___VM_SCMOBJ(___vms),___tSUBTYPED),
              ___VM_SIZE);
}


___HIDDEN void mark_global_variables
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  int id = ___PROCESSOR_ID(___ps,___vms); /* id of this processor */

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_GLOBAL_VAR;
#endif

  /*
   * Mark a portion of the global variables.
   */

#ifdef ___SINGLE_VM

  {
    int np = ___vms->processor_count;
    int lo = (id * ___GLO_SUBLIST_COUNT) / np;
    int hi = ((id+1) * ___GLO_SUBLIST_COUNT) / np;

    while (lo < hi)
      {
        ___glo_sublist_struct *sl = &___GSTATE->mem.glo_list.sublist[lo];
        ___glo_struct *glo = sl->head;

        while (glo != 0)
          {
#ifdef ___DEBUG_GARBAGE_COLLECT_globals
            print_global_var_name (glo);
            ___printf ("\n");
#endif
            mark_array (___PSP &___GLOCELL(glo->val), 1);
            glo = glo->next;
          }

        lo++;
      }
  }

#else

  {
    int n = ___GSTATE->mem.glo_list.count;
    int np = ___vms->processor_count;
    int lo = (id * n) / np;
    int hi = ((id+1) * n) / np;

    mark_array (___PSP
                ___VMSTATE_FROM_PSTATE(___ps)->glos+lo,
                hi-lo);
  }

#endif
}


___HIDDEN void mark_symkey_tables
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_SYMKEY_TABLE;
#endif

  mark_array (___PSP &___GSTATE->symbol_table, 1);
  mark_array (___PSP &___GSTATE->keyword_table, 1);
}


___HIDDEN void mark_reachable_from_marked
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

#ifndef ___SINGLE_THREADED_VMS

  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___VOLATILE ___WORD *workers_count = &scan_workers_count[traverse_weak_refs];
  int np = ___vms->processor_count;
  int id = ___PROCESSOR_ID(___ps,___vms); /* id of this processor */
  int i;

 continue_local_scan:

#endif

  do
    {
      scan_still_objs_to_scan (___PSPNC);
      scan_movable_objs_to_scan (___PSPNC);
    } while (___CAST(___WORD*,still_objs_to_scan) != 0);

#ifndef ___SINGLE_THREADED_VMS

#define ___GC_SCAN_STEAL_WORK_CYCLES 1000

  for (;;)
    {
      /* Try stealing a queued chunk from another processor */

      for (i = (np-1) * ___GC_SCAN_STEAL_WORK_CYCLES - 1; i>=0; i--)
        {
          ___processor_state ps = ___PSTATE_FROM_PROCESSOR_ID((i + i%(np-1) + 1) % np,___vms);
          ___VOLATILE ___WORD *hcsh;

          if (ps->mem.heap_chunks_to_scan_head_ !=
              ps->mem.heap_chunks_to_scan_tail_)
            {
              /* only try stealing when chunk FIFO is non-empty */

              ___SPINLOCK_LOCK(ps->mem.heap_chunks_to_scan_lock_);

              if ((hcsh=ps->mem.heap_chunks_to_scan_head_) !=
                  ps->mem.heap_chunks_to_scan_tail_)
                {
                  /* chunk FIFO is really non-empty */

                  ___WORD *ptr = ___UNTAG_AS(*hcsh, ___FORW);

                  ps->mem.heap_chunks_to_scan_head_ = ptr;

                  ___SHARED_MEMORY_BARRIER(); /* share heap_chunks_to_scan_head */

                  ___SPINLOCK_UNLOCK(ps->mem.heap_chunks_to_scan_lock_);

                  scan_complete_heap_chunk (___PSP ptr+1);

                  goto continue_local_scan;
                }
              else
                {
                  ___SPINLOCK_UNLOCK(ps->mem.heap_chunks_to_scan_lock_);
                }
            }
        }

      /* Signal being idle and wait for more work or termination */

      ___MUTEX_LOCK(scan_termination_mutex);

      if (--(*workers_count) == 0)
        {
          /* Scan has terminated */

          for (i=np-1; i>=0; i--)
            ___CONDVAR_SIGNAL(scan_termination_condvar);

          ___MUTEX_UNLOCK(scan_termination_mutex);

          break;
        }
      else
        {
          /* Other processors are still actively scanning chunks */

          ___ACTLOG_BEGIN_PS(gc_wait,lightgray);
          ___CONDVAR_WAIT(scan_termination_condvar,scan_termination_mutex);
          ___ACTLOG_END_PS();

          if (*workers_count == 0)
            {
              ___MUTEX_UNLOCK(scan_termination_mutex);
              break;
            }

          (*workers_count)++;

          ___MUTEX_UNLOCK(scan_termination_mutex);
        }
    }

#endif
}


___HIDDEN void garbage_collect_setup_phase
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_BEGIN_PS(setup_phase,_);
#endif

#ifdef ENABLE_GC_TRACE_PHASES
  if (___PROCESSOR_ID(___ps,___vms) == 0)
    ___printf ("garbage_collect_setup_phase\n");
  BARRIER();
#endif

  /* Assign initial stack and heap msections to each processor */

  if (___PROCESSOR_ID(___ps,___vms) == 0)
    setup_stack_heap_vmstate (___vms);

  /* Create list of externally referenced still objects to trace */

  setup_still_objs_to_scan (___PSPNC);

  /* Account for deferred accounting of still object allocation */

  words_still_objs += words_still_objs_deferred;
  words_still_objs_deferred = 0;

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_END_PS();
#endif
}


___HIDDEN void garbage_collect_mark_strong_phase
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_BEGIN_PS(mark_strong_phase,_);
#endif

#ifdef ENABLE_GC_TRACE_PHASES
  if (___PROCESSOR_ID(___ps,___vms) == 0)
    ___printf ("garbage_collect_mark_strong_phase\n");
  BARRIER();
#endif

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
    {
      stack_fudge_used = 0;
      heap_fudge_used = 0;
    }
#endif

  /* maintain list of GC hash tables reached by GC */

  reached_gc_hash_tables = 0;

  traverse_weak_refs = 0; /* don't traverse weak references in this phase */

  if (___PROCESSOR_ID(___ps,___vms) == 0)
    {
      mark_vm_scmobj (___PSPNC);
      mark_symkey_tables (___PSPNC);
      mark_rc (___PSPNC);
    }

  mark_global_variables (___PSPNC);

  mark_continuation (___PSPNC);

  mark_registers (___PSPNC);

  mark_saved (___PSPNC);

  mark_type_cache (___PSPNC);

  mark_processor_scmobj (___PSPNC);

  mark_reachable_from_marked (___PSPNC);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_END_PS();
#endif
}


___HIDDEN void garbage_collect_mark_weak_phase
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

  /*
   * At this point all of the objects accessible from the roots
   * without having to traverse a weak reference have been scanned
   * by the GC.
   */

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_BEGIN_PS(mark_weak_phase,_);
#endif

#ifdef ENABLE_GC_TRACE_PHASES
  if (___PROCESSOR_ID(___ps,___vms) == 0)
    ___printf ("garbage_collect_mark_weak_phase\n");
  BARRIER();
#endif

  traverse_weak_refs = 1; /* traverse weak references in this phase */

  process_wills (___PSPNC);

  mark_reachable_from_marked (___PSPNC);

  move_continuation (___PSPNC);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_END_PS();
#endif
}


___HIDDEN void garbage_collect_cleanup_phase
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_BEGIN_PS(cleanup_phase,_);
#endif

#ifdef ENABLE_GC_TRACE_PHASES
  if (___PROCESSOR_ID(___ps,___vms) == 0)
    ___printf ("garbage_collect_cleanup_phase\n");
  BARRIER();
#endif

  process_gc_hash_tables (___PSPNC);

  free_unmarked_still_objs (___PSPNC);

#ifdef ENABLE_GC_ACTLOG_PHASES
  ___ACTLOG_END_PS();
#endif
}


___BOOL ___garbage_collect_pstate
   ___P((___processor_state ___ps,
         ___SIZE_TS requested_words_still),
        (___ps,
         requested_words_still)
___processor_state ___ps;
___SIZE_TS requested_words_still;)
{
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___BOOL overflow = 0;
  ___F64 user_time_start, sys_time_start, real_time_start;
  ___F64 user_time_end, sys_time_end, real_time_end;
  ___F64 user_time, sys_time, real_time;

  ___ACTLOG_BEGIN_PS(gc,red);

  /* Start measuring GC statistics */

  if (___PROCESSOR_ID(___ps,___vms) == 0)
    {
#ifdef ENABLE_GC_TRACE_PHASES
      ___printf ("----------------------------------------- GC START #%d\n", ___CAST(int,nb_gcs)+1);
#endif
      ___process_times (&user_time_start, &sys_time_start, &real_time_start);
    }

  /* Print debugging info */

#ifdef ___DEBUG_GARBAGE_COLLECT

  {
    int p;
    int np = ___vms->processor_count;
    for (p=0; p<np; p++)
      {
        if (___PROCESSOR_ID(___ps,___vms) == p)
          {
            ___printf ("processor #%d\n", p);
            ___printf ("heap_size          = %d\n", heap_size);
            ___printf ("tospace_offset     = %d\n", ___ps->mem.tospace_offset_);
            ___printf ("___ps->stack_start = %p\n", ___ps->stack_start);
            ___printf ("___ps->stack_break = %p\n", ___ps->stack_break);
            ___printf ("___ps->fp          = %p\n", ___ps->fp);
            ___printf ("___ps->stack_limit = %p\n", ___ps->stack_limit);
            ___printf ("___ps->heap_limit  = %p\n", ___ps->heap_limit);
            ___printf ("___ps->hp          = %p\n", ___ps->hp);
          }
        BARRIER();
      }
  }

#endif


  /* Recover processor's stack and heap pointers */

  alloc_stack_ptr = ___ps->fp;
  alloc_heap_ptr  = ___ps->hp;


  /* Keep track of bytes allocated by this processor */

  bytes_allocated_minus_occupied += bytes_occupied(___ps);

  BARRIER();


  /* Setup the stacks and heaps of all the processors */

  garbage_collect_setup_phase (___PSPNC);

  BARRIER();


  /* Mark the objects that are reachable strongly */

  garbage_collect_mark_strong_phase (___PSPNC);

  BARRIER();


  /* Mark the objects that are reachable weakly */

  garbage_collect_mark_weak_phase (___PSPNC);

  BARRIER();


  /* Process gc hash tables and free unreachable still objects */

  garbage_collect_cleanup_phase (___PSPNC);

  BARRIER();


  /* Resize heap */

  if (___PROCESSOR_ID(___ps,___vms) == 0)
    overflow = resize_heap (___vms, requested_words_still);

  BARRIER();


  /* Guarantee heap fudge */

  if (alloc_heap_ptr > alloc_heap_limit - ___MSECTION_FUDGE)
    next_heap_msection (___ps);


  /* Keep track of bytes allocated by this processor */

  bytes_allocated_minus_occupied -= bytes_occupied(___ps);


  /* Finalize measuring GC statistics */

  if (___PROCESSOR_ID(___ps,___vms) == 0)
    {
      ___process_times (&user_time_end, &sys_time_end, &real_time_end);

      user_time = user_time_end - user_time_start;
      sys_time = sys_time_end - sys_time_start;
      real_time = real_time_end - real_time_start;

      nb_gcs = nb_gcs + 1.0;
      gc_user_time += user_time;
      gc_sys_time += sys_time;
      gc_real_time += real_time;

      latest_gc_user_time = user_time;
      latest_gc_sys_time = sys_time;
      latest_gc_real_time = real_time;

      ___raise_interrupt_pstate (___ps, ___INTR_GC); /* raise gc interrupt */

#ifdef ENABLE_GC_TRACE_PHASES
      ___printf ("----------------------------------------- GC END #%d\n", ___CAST(int,nb_gcs));
#endif
    }

  /* Prepare to continue executing program */

  prepare_mem_pstate (___ps);


  ___ACTLOG_END_PS();

  return overflow;
}


#ifdef ___DEBUG_STACK_LIMIT

___BOOL ___stack_limit_debug
   ___P((___PSD
         int line,
         char *file),
        (___PSV
         line,
         file)
___PSDKR
int line;
char *file;)

#else

___BOOL ___stack_limit
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)

#endif
{
  ___PSGET

  /*
   * In a multithreaded VM, the function ___stack_limit can be called
   * concurrently by multiple processors. The VM level memory allocation
   * lock is used to implement a critical section.
   */

  /* Recover processor's stack and heap pointers */

  alloc_stack_ptr = ___ps->fp;
  alloc_heap_ptr  = ___ps->hp;

#ifdef ___DEBUG_STACK_LIMIT
  ___ps->stack_limit_line = line;
  ___ps->stack_limit_file = file;
  ___printf ("___POLL caused ___stack_limit call at %s:%d\n",
             ___ps->poll_file,
             ___ps->poll_line);
#endif

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
    check_fudge_used (___PSPNC);
#endif

  if (alloc_stack_ptr < alloc_stack_limit + ___MSECTION_FUDGE)
    {
      /*
       * There isn't enough free space in the current stack msection.
       */

      ___msection *prev_stack_msection = stack_msection;
      ___WORD *prev_alloc_stack_start = alloc_stack_start;
      ___WORD *prev_alloc_stack_ptr = alloc_stack_ptr;
      ___WORD *prev_stack_break = ___ps->stack_break;
      ___WORD *fp;
      int frame_count;
      int words;

      /*
       * Get a new stack msection.
       */

      ___msection *ms = msection_free_list;

      if (stack_msection != heap_msection &&
          ms != NULL)
        {
          /* we can reuse an existing one */

          msection_free_list = ___CAST(___msection*,ms->base[0]);

          set_stack_msection (___ps, ms);
        }
      else
        {
          /* we need to allocate a new msection */

          ALLOC_MEM_LOCK();

          if (
#ifdef CALL_GC_FREQUENTLY
              --___gc_calls_to_punt < 0 ||
#endif
              compute_free_heap_space() < ___MSECTION_SIZE)
            {
              ALLOC_MEM_UNLOCK();

              /*
               * Because the GC preserves the topmost contiguous
               * frames in the stack msection (the frames between the
               * stack pointer and the latest break frame), the
               * occupation of the stack msection would increase
               * gradually with subsequent calls to ___stack_limit and
               * this would eventually cause an uncontrolled overflow
               * of the stack msection.
               *
               * To avoid this, a break frame is added at the top of
               * the stack when the topmost contiguous frames in the
               * stack msection take too much space.  This will cause
               * the GC to move all the frames to the heap.
               */

              if ((___ps->stack_break - alloc_stack_ptr) >
                  (___ps->stack_start - ___ps->stack_limit)*2/3)
                {
                  /*
                   * At the top of the current stack msection there are
                   * contiguous frames that occupy more than 2/3 of the
                   * available space.
                   */

                  /*
                   * Add a break frame.
                   */

                  ___FP_ADJFP(alloc_stack_ptr,___BREAK_FRAME_SPACE)
                  ___FP_SET_STK(alloc_stack_ptr,
                                -___BREAK_FRAME_NEXT,
                                ___CAST(___WORD,prev_alloc_stack_ptr))
                  ___ps->stack_break = alloc_stack_ptr;
                }

              prepare_mem_pstate (___ps);

              return 1; /* trigger GC */
            }

          next_stack_msection_without_locking (___ps);

          ALLOC_MEM_UNLOCK();
        }

      /*
       * Move to the new stack msection.
       */

      ___ps->stack_start = alloc_stack_start;
      alloc_stack_ptr = alloc_stack_start;

      /*
       * Create a "break frame" in the new stack msection.  The break
       * frame is used by the break handler (see _kernel.scm).
       */

      ___FP_ADJFP(alloc_stack_ptr,___FIRST_BREAK_FRAME_SPACE)

      /*
       * Because ___stack_limit is only called by the stack-limit
       * handler in _kernel.scm and it has pushed an internal
       * return frame to the top of the stack, the frame pointer
       * can't be pointing to a break frame,
       * i.e. prev_alloc_stack_ptr != prev_stack_break.
       *
       * If the topmost frame were to be left on the stack, when
       * ___stack_overflow_undo_if_possible would return to it, an
       * uncontrolled overflow of the stack would be possible (because
       * the generated code assumes that after returning from a call
       * to ___stack_limit it is OK to perform a function call without
       * checking the stack limit).
       *
       * For this reason, is is necessary for correctness to transfer
       * the topmost frame to the new stack msection.  However, only
       * transferring the topmost frame may cause the stack limit
       * handler to be called frequently if there are many shallow
       * function calls in a row (calls to ___stack_limit followed by
       * ___stack_overflow_undo_if_possible in a tight loop).  To
       * avoid this performance issue, it is best to transfer a
       * certain number of frames, but no more than up to the break
       * frame.
       */

      fp = prev_alloc_stack_ptr;
      frame_count = 0; /* count of frames to transfer */

      for (;;)
        {
          int fs, link;
          ___WORD ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);
          ___WORD ra2;

          frame_count++;

          if (ra1 == ___GSTATE->internal_return)
            {
              ___WORD actual_ra = ___FP_STK(fp,___RETI_RA);
              ___RETI_GET_FS_LINK(actual_ra,fs,link)
            }
          else
            {
              ___RETN_GET_FS_LINK(ra1,fs,link)
            }

          ___FP_ADJFP(fp,-___FRAME_SPACE(fs)) /* get base of frame */

          ra2 = ___FP_STK(fp,link+1);

          words = fp - prev_alloc_stack_ptr;

          if (fp == prev_stack_break)
            {
              /* reached the break frame */

              /* best to not transfer any frames to new stack msection */

              /*
               * Add a break frame.
               */

              ___FP_ADJFP(alloc_stack_ptr,___BREAK_FRAME_SPACE)
              ___FP_SET_STK(alloc_stack_ptr,
                            -___BREAK_FRAME_NEXT,
                            ___CAST(___WORD,prev_alloc_stack_ptr))
              ___ps->stack_break = alloc_stack_ptr;

              fp = alloc_stack_ptr;

              break;
            }

          ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)

          words = fp - prev_alloc_stack_ptr;

          if (frame_count >= 5 || words >= 100)
            {
              /* reached max frame count or max volume */

              /*
               * Save state of previous stack msection in the
               * first break frame of new stack msection to allow
               * returning to the previous stack msection when
               * ___stack_overflow_undo_if_possible is called.
               */

              ___FP_SET_STK(alloc_stack_ptr,
                            -___FIRST_BREAK_FRAME_STACK_MSECTION,
                            ___CAST(___WORD,prev_stack_msection))

              ___FP_SET_STK(alloc_stack_ptr,
                            -___FIRST_BREAK_FRAME_STACK_BREAK,
                            ___CAST(___WORD,prev_stack_break))

              ___FP_SET_STK(alloc_stack_ptr,
                            -___BREAK_FRAME_NEXT,
                            ___CAST(___WORD,fp))

              ___ps->stack_break = alloc_stack_ptr;

              memmove (alloc_stack_ptr - words,
                       prev_alloc_stack_ptr,
                       words << ___LWS);

              ___FP_SET_STK(alloc_stack_ptr,
                            link+1,
                            ___GSTATE->handler_break)

              ___FP_ADJFP(alloc_stack_ptr, words)

              break;
            }
        }

      stack_msection_stop_using (___ps, prev_alloc_stack_start, fp);
    }

  prepare_mem_pstate (___ps);

  return 0;
}


___WORD ___stack_overflow_undo_if_possible
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___D_FP
  ___R_FP

  ___msection *ms;

  if (stack_msection != heap_msection &&
      ___ps->stack_start == &___STK(-___FIRST_BREAK_FRAME_SPACE) &&
      (ms = ___CAST(___msection*,___STK(-___FIRST_BREAK_FRAME_STACK_MSECTION)))
      != NULL)
    {
      /*
       * The current stack msection is not shared with the heap and
       * the break frame is at the start of the stack msection and it
       * was created due to a stack section overflow, so the stack can
       * be moved to the previous stack msection.
       */

      stack_msection->base[0] = ___CAST(___WORD,msection_free_list);
      msection_free_list = stack_msection;

      set_stack_msection (___ps, ms);

      ___ps->stack_break =
        ___CAST(___WORD*,___STK(-___FIRST_BREAK_FRAME_STACK_BREAK));

      alloc_stack_ptr =
        ___CAST(___WORD*,___STK(-___BREAK_FRAME_NEXT));

      ___ps->stack_start = alloc_stack_start;

      stack_msection_resume_using (___ps, alloc_stack_start, alloc_stack_ptr);

      prepare_mem_pstate (___ps);

      ___SET_FP(alloc_stack_ptr)

      return ___FRAME_FETCH_RA;
    }

  return ___FAL;
}


#ifdef ___DEBUG_HEAP_LIMIT

___BOOL ___heap_limit_debug
   ___P((___PSD
         int line,
         char *file),
        (___PSV
         line,
         file)
___PSDKR
int line;
char *file;)

#else

___BOOL ___heap_limit
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)

#endif
{
  ___PSGET

  /*
   * In a multithreaded VM, the function ___heap_limit can be called
   * concurrently by multiple processors. The VM level memory allocation
   * lock is used to implement a critical section.
   */

  /* Recover processor's stack and heap pointers */

  alloc_stack_ptr = ___ps->fp;
  alloc_heap_ptr  = ___ps->hp;

#ifdef ___DEBUG_HEAP_LIMIT
  ___ps->heap_limit_line = line;
  ___ps->heap_limit_file = file;
#endif

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___GSTATE->setup_params.debug_settings) >= 1)
    check_fudge_used (___PSPNC);
#endif

  {
    /*
     * Get a new heap msection.
     */

    ___msection *ms = msection_free_list;

    if (stack_msection != heap_msection &&
        ms != NULL)
      {
        /* we can reuse an existing one */

        msection_free_list = ___CAST(___msection*,ms->base[0]);

        set_heap_msection (___ps, ms);
      }
    else
      {
        /* we need to allocate a new msection */

        ALLOC_MEM_LOCK();

        if (
#ifdef CALL_GC_FREQUENTLY
            --___gc_calls_to_punt >= 0 &&
#endif
            compute_free_heap_space() >= ___MSECTION_SIZE)
          {
            if (alloc_heap_ptr > alloc_heap_limit - ___MSECTION_FUDGE)
              next_heap_msection_without_locking (___ps);

            ALLOC_MEM_UNLOCK();
          }
        else
          {
            ALLOC_MEM_UNLOCK();

            return 1; /* trigger GC */
          }
      }
  }

  prepare_mem_pstate (___ps);

  return 0;
}


/*---------------------------------------------------------------------------*/


___F64 ___bytes_allocated
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  /* Recover processor's stack and heap pointers */

  alloc_stack_ptr = ___ps->fp;
  alloc_heap_ptr  = ___ps->hp;

  return bytes_allocated_minus_occupied + bytes_occupied(___ps) +
         ___CAST(___F64,occupied_words_still) * ___WS;
}


/*---------------------------------------------------------------------------*/

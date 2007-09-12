/* File: "mem.c", Time-stamp: <2007-09-11 23:51:00 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.  */

#define ___INCLUDED_FROM_MEM
#define ___VERSION 400001
#include "gambit.h"

#include "os_base.h"
#include "os_time.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"

/* The following includes are needed for debugging. */

#include <stdlib.h>
#include <string.h>

/**********************************/
#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE
#define ___alloc_mem(bytes) ___alloc_mem_debug(bytes,__LINE__,__FILE__)
#endif
#endif


/*---------------------------------------------------------------------------*/

#ifdef ___DEBUG

/*
 * Defining the symbol ENABLE_CONSISTENCY_CHECKS will enable the GC to
 * perform checks that detect when the heap is in an inconsistent
 * state.  This is useful to detect bugs in the GC and the rest of the
 * system.  To perform the consistency checks, the verbosity level in
 * ___setup_params.debug_settings must be at least 1.  The checks are
 * very extensive and consequently are expensive.  They should only be
 * used for debugging.
 */

#define ENABLE_CONSISTENCY_CHECKS


/*
 * Defining the symbol GATHER_STATS will cause the GC to gather
 * statistics on the objects it encounters in the heap.
 */

#define GATHER_STATS


/*
 * Defining the symbol SHOW_FRAMES will cause the GC to print out a
 * trace of the continuation frames that are processed.
 */

#undef SHOW_FRAMES

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
 *    ___tPAIR      object is a pair
 *    ___tSUBTYPED  object is memory allocated but not a pair
 * 
 * A special type of object exists to support object finalization:
 * 'will' objects.  Wills contain an object (the will's testator) and
 * may also contain a procedure (the will's action procedure).  An
 * object is finalizable when all paths to the object from the root
 * set pass through a will.  When the GC detects that an object is
 * finalizable the corresponding wills are placed on a list of
 * executable wills (for wills with an action procedure).  Following
 * the GC, this list is traversed to invoke the action procedures.
 * 
 * All memory allocated objects, including pairs, are composed of at
 * least a head and a body.  The head is a single ___WORD that
 * contains 3 "head" tag bits (the 3 lower bits), a subtype tag (the
 * next 5 bits), and the length of the object in bytes (the remaining
 * bits).  The head immediately precedes the body of the object, which
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
 *     field_0 = name (a Scheme string)
 *     field_1 = hash code (fixnum)
 *     field_2 = C pointer to global variable (0 if none allocated)
 * 
 *     Note: interned symbols must be permanently allocated;
 *           uninterned symbols can be permanent, still or movable
 * 
 * Keywords:
 *     subtype = ___sKEYWORD
 *     field_0 = name (a Scheme string) not including the trailing ':'
 *     field_1 = hash code (fixnum)
 * 
 * Procedures:
 * 
 *   nonclosures (toplevel procedures)
 *     subtype = ___sPROCEDURE (length contains parameter descriptor)
 *     field_0 = C pointer to field_0 - ___BODY_OFS
 *     field_1 = C pointer to label (only when using gcc)
 *     field_2 = C pointer to host C procedure
 * 
 *   closures:
 *     subtype = ___sPROCEDURE
 *     field_0 = C pointer to field_0 of entry procedure - ___BODY_OFS
 *     field_1 = free variable 1
 *     field_2 = free variable 2
 *     ...
 * 
 *     Note: the entry procedure must be a nonclosure procedure
 * 
 * Return points:
 *     subtype = ___sPROCEDURE
 *     field_0 = return frame descriptor
 *     field_1 = C pointer to label (only when using gcc)
 *     field_2 = C pointer to host C procedure
 * 
 * Wills:
 *     subtype = ___sWEAK
 *     field_0 = next will in list with special tag in lower bits
 *     field_1 = testator object
 *     field_2 = action procedure (if this field exists)
 * 
 *     Note: wills must be movable
 * 
 * GC hash tables:
 *     subtype = ___sWEAK
 *     field_0 = next GC hash table in list with special tag in lower bits
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
 *     field_1 = dynamic environment (optional)
 * 
 * Frame:
 *     subtype = ___sFRAME
 *     field_0 = return address
 *     field_1 = frame slot 1
 *     field_2 = frame slot 2
 *     ...
 */


/*---------------------------------------------------------------------------*/

/*
 * Movable Scheme objects are allocated in an area of memory
 * distributed in multiple noncontiguous sections (collectively
 * called the "msections").  All sections are of the same size and are
 * allocated through the '___alloc_mem' function.  The number of
 * sections can expand and contract to accommodate the needs of the
 * program.
 */

typedef struct msect
  {
    int index;          /* index in list of sections */
    int pos;            /* position in msections's 'sections' array */
    ___WORD *alloc;     /* heap allocation pointer, grows towards high addr. */
    struct msect *prev; /* previous section in list of sections */
    struct msect *next; /* next section in list of sections */
    ___WORD base[1];    /* content of section */
  } msection;

#define sizeof_msection(n) (sizeof (msection) + ((n)-1) * ___WS)

typedef struct
  {
    int max_nb_sections;   /* actual size of 'sections' array */
    int nb_sections;       /* number of sections */
    msection *head;        /* head of doubly-linked list of sections */
    msection *tail;        /* tail of doubly-linked list of sections */
    msection *sections[1]; /* each section ordered by address */
                           /* (increasing order if ___ALLOC_MEM_UP */
                           /* is defined otherwise decreasing order) */
  } msections;

#define sizeof_msections(n) (sizeof (msections) + ((n)-1) * sizeof (msection*))


/* size of heap in words (number of words that can be occupied) */
___HIDDEN long heap_size;

/*
 * 'normal_overflow_reserve' is the number of words reserved in the
 * heap in normal circumstances for handling heap overflows.
 */
___HIDDEN long normal_overflow_reserve;

/*
 * 'overflow_reserve' is the number of words currently reserved in the
 * heap for handling heap overflows.  Initially 'overflow_reserve' is
 * set to 'normal_overflow_reserve'.  When a heap overflow occurs,
 * some fraction of the 'overflow_reserve' is made available to the
 * heap overflow handler.  When a GC makes at least
 * 'normal_overflow_reserve' free, then 'overflow_reserve' is reset to
 * 'normal_overflow_reserve'.
 */
___HIDDEN long overflow_reserve;

/* words occupied by nonmovable objects */
___HIDDEN long words_nonmovable;

/* words occupied in heap by movable objects excluding current msections */
___HIDDEN long words_prev_msections;

/* words occupied in heap by movable objects including current msections */
#define WORDS_MOVABLE \
(2*(words_prev_msections + \
(alloc_stack_start - alloc_stack_ptr) + \
(alloc_heap_ptr - alloc_heap_start)))

/* words occupied in heap including current msections */
#define WORDS_OCCUPIED (words_nonmovable + WORDS_MOVABLE)

/* words usable in msections */
#define WORDS_MOVABLE_USABLE \
(2*the_msections->nb_sections*((___MSECTION_SIZE>>1)-___MSECTION_FUDGE+1))

/* words available in heap */
#define WORDS_AVAILABLE \
(words_nonmovable + WORDS_MOVABLE_USABLE - \
overflow_reserve - 2*___MSECTION_FUDGE)

/* list of still objects */
___HIDDEN ___WORD still_objs;

/* still objects remaining to scan */
___HIDDEN ___WORD still_objs_to_scan;

/* the msections */
___HIDDEN msections *the_msections;

/* location of tospace in each msection */
___HIDDEN ___BOOL tospace_at_top;

/* number of msections used */
___HIDDEN int nb_msections_used;

/* last msection allocated */
___HIDDEN msection *alloc_msection;

/* msection where continuation frames are currently being allocated */
___HIDDEN msection *stack_msection;

/* start of allocation of continuation frames in stack_msection */
___HIDDEN ___WORD *alloc_stack_start;

/* allocation pointer for continuation frames in stack_msection */
___HIDDEN ___WORD *alloc_stack_ptr;

/* allocation limit for continuation frames in stack_msection */
___HIDDEN ___WORD *alloc_stack_limit;

/* msection where movable objects are currently being allocated */
___HIDDEN msection *heap_msection;

/* start of allocation of movable objects in heap_msection */
___HIDDEN ___WORD *alloc_heap_start;

/* allocation pointer for movable objects in heap_msection */
___HIDDEN ___WORD *alloc_heap_ptr;

/* allocation limit for movable objects in heap_msection */
___HIDDEN ___WORD *alloc_heap_limit;

/* msection currently being scanned */
___HIDDEN msection *scan_msection;

/* scan pointer in msection being scanned */
___HIDDEN ___WORD *scan_ptr;

/* indicates if weak references must be traversed */
___HIDDEN ___BOOL traverse_weak_refs;

/* wills reached by GC */
___HIDDEN ___WORD reached_floating_wills;

/* GC hash tables reached by GC */
___HIDDEN ___WORD reached_gc_hash_tables;

#ifdef CALL_GC_FREQUENTLY
int ___gc_calls_to_punt = 2000; /* for GC stress test */
#endif

/* 
 * A given msection can be used for allocating movable objects, or for
 * allocating continuation frames, or for both.  The position of the
 * various pointers is as follows.
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
 *  |objs|    |<-___MSECTION_FUDGE->| O.R. |<-___MSECTION_FUDGE->|     |frames|
 *  +----+-------------------------------------------------------------+------+
 *  ^    ^    ^                     ^      ^                     ^     ^      ^
 *  |    |    |                     |      |                     |     |      |
 *  |    |    |      alloc_heap_limit      alloc_stack_limit     |     |      |
 *  |    |    ___ps->heap_limit                 ___ps->stack_limit     |      |
 *  |    alloc_heap_ptr                                  alloc_stack_ptr      |
 *  alloc_heap_start                                          alloc_stack_start
 */


/*---------------------------------------------------------------------------*/

/* Constants related to representation of permanent and still objects: */

#ifdef ___USE_HANDLES
#define ___PERM_HAND_OFS 0
#define ___PERM_BODY_OFS 2
#else
#define ___PERM_HAND_OFS ___PERM_BODY_OFS
#define ___PERM_BODY_OFS 1
#endif

#define ___STILL_LINK_OFS 0
#define ___STILL_REFCOUNT_OFS 1
#define ___STILL_LENGTH_OFS 2
#define ___STILL_MARK_OFS 3
#ifdef ___USE_HANDLES
#define ___STILL_HAND_OFS 4
#define ___STILL_BODY_OFS 6
#else
#define ___STILL_HAND_OFS ___STILL_BODY_OFS
#define ___STILL_BODY_OFS (5+1)/************/
#endif


/*---------------------------------------------------------------------------*/

/* Allocation and reclamation of aligned blocks of memory.  */


/*
 * 'alloc_mem_aligned (words, multiplier, modulus)' allocates an
 * aligned block of memory through the '___alloc_mem' function.
 * 'words' is the size of the block in words and 'multiplier' and
 * 'modulus' specify its alignment in words.  'multiplier' must be a
 * power of two and 0<=modulus<multiplier.  The pointer returned
 * corresponds to an address that is equal to
 * (i*multiplier+modulus)*sizeof (___WORD) for some 'i'.
 */

___HIDDEN void *alloc_mem_aligned
   ___P((long words,
         unsigned int multiplier,
         unsigned int modulus),
        (words,
         multiplier,
         modulus)
long words;
unsigned int multiplier;
unsigned int modulus;)
{
  void *container; /* pointer to block returned by ___alloc_mem */
  unsigned int extra; /* space for alignment to multiplier */

  /* Make sure alignment is sufficient for pointers */

  if (multiplier < sizeof (void*) / ___WS)
    multiplier = sizeof (void*) / ___WS;

  /* How many extra bytes are needed for padding */

  extra = (multiplier * ___WS) - 1;
  if (modulus < sizeof (void*) / ___WS)
    extra += sizeof (void*);

  container = ___alloc_mem (extra + (words+modulus) * ___WS);

  if (container == 0)
    return 0;
  else
    {
      void *ptr = ___CAST(void*,
                          (((___CAST(long,container) + extra) &
                            -___CAST(long,multiplier * ___WS)) +
                           modulus * ___WS));
      void **cptr = ___CAST(void**,
                            (___CAST(long,ptr) - ___CAST(long,sizeof (void*))) &
                            -___CAST(long,sizeof (void*)));

      *cptr = container;
      return ptr;
    }
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
                        (___CAST(long,ptr) - ___CAST(long,sizeof (void*))) &
                        -___CAST(long,sizeof (void*)));
  ___free_mem (*cptr);
}


/*---------------------------------------------------------------------------*/

/* Allocation of reference counted blocks of memory. */

typedef struct rc_header_struct
  {
    struct rc_header_struct *prev;
    struct rc_header_struct *next;
    ___SCMOBJ refcount; /* integer but declared ___SCMOBJ for alignment */
    ___SCMOBJ data; /* needed for C closures */
  } rc_header;


___HIDDEN rc_header rc_head;


___HIDDEN void setup_rc ___PVOID
{
  rc_head.prev = &rc_head;
  rc_head.next = &rc_head;
  rc_head.refcount = 1;
  rc_head.data = ___FAL;
}

___HIDDEN void cleanup_rc ___PVOID
{
  rc_header *h = rc_head.next;

  rc_head.prev = &rc_head;
  rc_head.next = &rc_head;

  while (h != &rc_head)
    {
      rc_header *next = h->next;
      ___free_mem (h);
      h = next;
    }
}


___EXP_FUNC(void*,___alloc_rc)
   ___P((unsigned long bytes),
        (bytes)
unsigned long bytes;)
{
  rc_header *h = ___CAST(rc_header*,
                         ___alloc_mem (bytes + sizeof (rc_header)));

  if (h != 0)
    {
      rc_header *head = &rc_head;
      rc_header *tail = head->prev;

      h->prev = tail;
      h->next = head;
      head->prev = h;
      tail->next = h;

      h->refcount = 1;
      h->data = ___FAL;

      return ___CAST(void*,h+1);
    }

  return 0;
}


___EXP_FUNC(void,___release_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  if (ptr != 0)
    {
      rc_header *h = ___CAST(rc_header*,ptr) - 1;

      if (--h->refcount == 0)
        {
          rc_header *prev = h->prev;
          rc_header *next = h->next;

          next->prev = prev;
          prev->next = next;

          ___free_mem (h);
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
      rc_header *h = ___CAST(rc_header*,ptr) - 1;
      h->refcount++;
    }
}


___EXP_FUNC(___SCMOBJ,___data_rc)
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  rc_header *h = ___CAST(rc_header*,ptr) - 1;
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
  rc_header *h = ___CAST(rc_header*,ptr) - 1;
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
   ___P((msections *ms,
         void *ptr),
        (ms,
         ptr)
msections *ms;
void *ptr;)
{
  int ns = ms->nb_sections;
  msection **sections = ms->sections;
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
   ___P((msections **msp,
         int n),
        (msp,
         n)
msections **msp;
int n;)
{
  int max_ns, ns;
  msections *ms = *msp;
  msection *hd;
  msection *tl;

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

      msections *new_ms;
      int i;

      while (n > max_ns) /* grow max_nb_sections until big enough */
        max_ns = 2*max_ns + 1;

      new_ms = ___CAST(msections*,
                       alloc_mem_aligned
                         (___WORDS(sizeof_msections(max_ns)),
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
          msection *s = tl;

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

          free_mem_aligned (s);

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
          msection *s = ___CAST(msection*,
                                alloc_mem_aligned
                                  (___WORDS(sizeof_msection(___MSECTION_SIZE)),
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
   ___P((msections **msp),
        (msp)
msections **msp;)
{
  msections *ms = *msp;

  if (ms != 0)
    {
      int i;

      for (i=ms->nb_sections-1; i>=0; i--)
        free_mem_aligned (ms->sections[i]);

      free_mem_aligned (ms);

      *msp = 0;
    }
}


/*---------------------------------------------------------------------------*/

/* Allocation of permanent objects.  */

/*
 * Permanent objects are allocated in sections called "psections".
 * Each section contains multiple objects.  The sections are kept in a
 * list so that the storage they occupy can be reclaimed when the
 * program terminates.
 */

___HIDDEN void *psections;       /* list of psections */
___HIDDEN ___WORD *palloc_ptr;   /* allocation pointer in current psection */
___HIDDEN ___WORD *palloc_limit; /* allocation limit in current psection */


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
   ___P((long words,
         unsigned int multiplier,
         unsigned int modulus),
        (words,
         multiplier,
         modulus)
long words;
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

  container = alloc_mem_aligned (words+modulus, multiplier, 0);

  if (container == 0)
    return 0;

  *___CAST(void**,container) = psections;
  psections = container;
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
   ___P((long words,
         int multiplier,
         int modulus),
        (words,
         multiplier,
         modulus)
long words;
int multiplier;
int modulus;)
{
  long waste;
  ___WORD *base;

  /*
   * Try to satisfy request in current psection.
   */

  if (palloc_ptr != 0)
    {
      ___WORD *new_palloc_ptr;

      base = ___CAST(___WORD*,
                     ___CAST(long,palloc_ptr+multiplier-1-modulus) &
                     (multiplier * -___WS)) +
             modulus;

      new_palloc_ptr = base + words;

      if (new_palloc_ptr <= palloc_limit) /* did it fit in the psection? */
        {
          palloc_ptr = new_palloc_ptr;
          return base;
        }

      waste = palloc_limit - palloc_ptr;
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
      palloc_ptr = base + words;
      palloc_limit = base + ___PSECTION_SIZE;
    }

  return base;
}


___HIDDEN void free_psections ___PVOID
{
  void *base = psections;

  psections = 0;

  while (base != 0)
    {
      void *link = *___CAST(void**,base);
      free_mem_aligned (base);
      base = link;
    }
}


___SCMOBJ ___alloc_global_var
   ___P((___glo_struct **glo),
        (glo)
___glo_struct **glo;)
{
  ___glo_struct *p = ___CAST(___glo_struct*,
                             alloc_mem_aligned_perm
                               (___WORDS(sizeof (___glo_struct)),
                                1,
                                0));
  if (p == 0)
    return ___FIX(___HEAP_OVERFLOW_ERR);
  *glo = p;
  return ___FIX(___NO_ERR);
}


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
  ___UNTAG(obj)[___BODY_OFS - ___STILL_BODY_OFS + ___STILL_REFCOUNT_OFS]++;
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
  ___UNTAG(obj)[___BODY_OFS - ___STILL_BODY_OFS + ___STILL_REFCOUNT_OFS]--;
}


/*---------------------------------------------------------------------------*/

/* 
 * '___alloc_scmobj (subtype, bytes, kind)' allocates a permanent or
 * still Scheme object (depending on 'kind') of subtype 'subtype' with
 * a body containing 'bytes' bytes, and returns it as an encoded
 * Scheme object.  A permanent object is allocated when 'kind' =
 * ___PERM and a still object is allocated when 'kind' = ___STILL.
 * The initialization of the object's body must be done by the caller.
 * In the case of still objects this initialization must be done
 * before the next allocation is requested.  The 'refcount' field of
 * still objects is initially 1.  A fixnum error code is returned when
 * there is an error.
 */

___EXP_FUNC(___WORD,___alloc_scmobj)
   ___P((int subtype,
         long bytes,
         int kind),
        (subtype,
         bytes,
         kind)
int subtype;
long bytes;
int kind;)
{
  void *ptr;
  ___processor_state ___ps = ___PSTATE;
  long words = (kind==___PERM ? ___PERM_BODY_OFS : ___STILL_BODY_OFS)
               + ___WORDS(bytes);

  alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
  alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

  words_nonmovable += words;

  if (WORDS_OCCUPIED > heap_size
#ifdef CALL_GC_FREQUENTLY
      || --___gc_calls_to_punt < 0
#endif
     )
    {
      ___BOOL overflow;

      words_nonmovable -= words;

      overflow = ___garbage_collect (words);

      words_nonmovable += words;

      alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
      alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

      if (overflow || WORDS_OCCUPIED > heap_size)
        {
          words_nonmovable -= words;
          return ___FIX(___HEAP_OVERFLOW_ERR);
        }
    }

  /* 
   * Some objects, such as ___sFOREIGN, ___sS64VECTOR, ___sU64VECTOR,
   * ___sF64VECTOR, ___sFLONUM and ___sBIGNUM, must have a body that
   * is aligned on a multiple of 8 on some machines.  Here, we force
   * alignment to a multiple of 8 even if not necessary in all cases
   * because it is typically more efficient due to a better
   * utilization of the cache.
   */

  if (kind == ___PERM)
    ptr = alloc_mem_aligned_perm (words,
                                  8>>___LWS,
                                  (-___PERM_BODY_OFS)&((8>>___LWS)-1));
  else
    ptr = alloc_mem_aligned (words,
                             8>>___LWS,
                             (-___STILL_BODY_OFS)&((8>>___LWS)-1));

  if (ptr == 0)
    {
      words_nonmovable -= words;
      return ___FIX(___HEAP_OVERFLOW_ERR);
    }
  else if (kind == ___PERM)
    {
      ___WORD *base = ___CAST(___WORD*,ptr);

#ifdef ___USE_HANDLES
      base[___PERM_HAND_OFS] = ___CAST(___WORD,base+___PERM_BODY_OFS-___BODY_OFS);
#endif
      base[___PERM_BODY_OFS-1] = ___MAKE_HD(bytes, subtype, ___PERM);

      return ___TAG((base + ___PERM_HAND_OFS - ___BODY_OFS),
                    (subtype == ___sPAIR ? ___tPAIR : ___tSUBTYPED));
    }
  else
    {
      ___WORD *base = ___CAST(___WORD*,ptr);

      base[___STILL_LINK_OFS] = still_objs;
      still_objs = ___CAST(___WORD,base);
      base[___STILL_REFCOUNT_OFS] = 1;
      base[___STILL_LENGTH_OFS] = words;
#ifdef ___USE_HANDLES
      base[___STILL_HAND_OFS] = ___CAST(___WORD,base+___STILL_BODY_OFS-___BODY_OFS);
#endif
      base[___STILL_BODY_OFS-1] = ___MAKE_HD(bytes, subtype, ___STILL);

      return ___TAG((base + ___STILL_HAND_OFS - ___BODY_OFS),
                    (subtype == ___sPAIR ? ___tPAIR : ___tSUBTYPED));
    }
}


___EXP_FUNC(void,___release_scmobj)
   ___P((___WORD obj),
        (obj)
___WORD obj;)
{
  if (___MEM_ALLOCATED(obj) &&
      ___HD_TYP(___BODY(obj)[-1]) == ___STILL)
    ___still_obj_refcount_dec (obj);
}


/* 
 * '___make_pair (car, cdr, kind)' creates a Scheme pair having the
 * values 'car' and 'cdr' in its CAR and CDR fields.  The 'car' and
 * 'cdr' arguments must not be movable objects and any still object
 * must be reachable some other way or have a nonzero refcount.  A
 * permanent or still object is allocated, depending on 'kind'
 * (___PERM for permanent object, ___STILL for still object).  A
 * fixnum error code is returned when there is an error.
 */

___EXP_FUNC(___WORD,___make_pair)
   ___P((___WORD car,
         ___WORD cdr,
         int kind),
        (car,
         cdr,
         kind)
___WORD car;
___WORD cdr;
int kind;)
{
  ___WORD obj = ___alloc_scmobj (___sPAIR, ___PAIR_SIZE<<___LWS, kind);

  if (!___FIXNUMP(obj))
    {
      ___PAIR_CAR(obj) = car;
      ___PAIR_CDR(obj) = cdr;
    }

  return obj;
}


/* 
 * '___make_vector (length, init, kind)' creates a Scheme vector of
 * length 'length' and initialized with the value 'init'.  The 'init'
 * argument must not be a movable object and if it is a still object
 * it must be reachable some other way or have a nonzero refcount.  A
 * permanent or still object is allocated, depending on 'kind'
 * (___PERM for permanent object, ___STILL for still object).  A
 * fixnum error code is returned when there is an error.
 */

___EXP_FUNC(___WORD,___make_vector)
   ___P((long length,
         ___WORD init,
         int kind),
        (length,
         init,
         kind)
long length;
___WORD init;
int kind;)
{
  if (length > ___CAST(long,___LMASK >> (___LF+___LWS)))
    return ___FIX(___HEAP_OVERFLOW_ERR);
  else
    {
      ___WORD obj = ___alloc_scmobj (___sVECTOR, length<<___LWS, kind);

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

___HIDDEN ___WORD *start_of_fromspace
   ___P((msection *s),
        (s)
msection *s;)
{
  if (tospace_at_top)
    return s->base;
  else
    return s->base + (___MSECTION_SIZE>>1);
}


___HIDDEN ___WORD *start_of_tospace
   ___P((msection *s),
        (s)
msection *s;)
{
  if (tospace_at_top)
    return s->base + (___MSECTION_SIZE>>1);
  else
    return s->base;
}


___HIDDEN void fatal_heap_overflow ___PVOID
{
  char *msgs[2];
  msgs[0] = "Heap overflow";
  msgs[1] = 0;
  ___fatal_error (msgs);
}


___HIDDEN msection *next_msection
   ___P((msection *ms),
        (ms)
msection *ms;)
{
  msection *result;

  if (nb_msections_used == 0)
    result = the_msections->head;
  else
    result = alloc_msection->next;

  if (result == 0)
    {
      if (stack_msection == heap_msection)
        fatal_heap_overflow ();
      result = ms;
    }
  else
    {
      alloc_msection = result;
      nb_msections_used++;
    }

  return result;
}


___HIDDEN void next_stack_msection ___PVOID
{
  if (stack_msection != 0)
    words_prev_msections += alloc_stack_start - alloc_stack_ptr;

  stack_msection = next_msection (heap_msection);
  alloc_stack_limit = start_of_tospace (stack_msection);
  alloc_stack_start = alloc_stack_limit + (___MSECTION_SIZE>>1);
  alloc_stack_ptr = alloc_stack_start;
}


___HIDDEN void next_heap_msection ___PVOID
{
  if (heap_msection != 0)
    {
      words_prev_msections += alloc_heap_ptr - alloc_heap_start;
      heap_msection->alloc = alloc_heap_ptr;
    }

  heap_msection = next_msection (stack_msection);
  alloc_heap_start = start_of_tospace (heap_msection);
  alloc_heap_limit = alloc_heap_start + (___MSECTION_SIZE>>1);
  alloc_heap_ptr = alloc_heap_start;
}


/*---------------------------------------------------------------------------*/

#ifdef ___DEBUG

void print_string
   ___P((___SCMOBJ str),
        (str)
___SCMOBJ str;)
{
  int i;
  for (i=0; i<___INT(___STRINGLENGTH(str)); i++)
    ___printf ("%c", ___INT(___STRINGREF(str,___FIX(i))));
}

void print_subtyped
   ___P((___SCMOBJ val),
        (val)
___SCMOBJ val;)
{
  ___SCMOBJ ___temp;
  if (___SUBTYPEDP(val))
    {
      ___SCMOBJ sym;
      if (___PROCEDUREP(val) || ___RETURNP(val))
        {
          if (___PROCEDUREP(val))
            ___printf ("#<procedure ");
          else
            ___printf ("#<return ");
          if ((sym = find_global_var_bound_to (val)) != ___NUL)
            print_string (___FIELD(sym,___SYMKEY_NAME));
          else
            {
              if (___HD_TYP(___HEADER(val)) == ___PERM)
                {
                  ___SCMOBJ *start = ___CAST(___SCMOBJ*,val-___tSUBTYPED);
                  ___SCMOBJ *ptr = start;
                  while (!___TESTHEADERTAG(*ptr,___sVECTOR))
                    ptr -= ___LS;
                  ptr += ___LS;
                  if (ptr == start)
                    ___printf ("???");
                  else
                    {
                      ___printf ("%d in ", (start-ptr)/___LS);
                      print_subtyped (___TAG(ptr,___tSUBTYPED));
                    }
                }
              else
                ___printf ("???");
            }
          ___printf (">");
        }
      else if (___STRINGP(val))
        {
          ___printf ("\"");
          print_string (val);
          ___printf ("\"");
        }
      else
        {
          ___printf ("#<other ???>");
        }
    }
}

void print_value
   ___P((___SCMOBJ val),
        (val)
___SCMOBJ val;)
{
  ___SCMOBJ ___temp;
  if (___FIXNUMP(val))
    ___printf ("%d", ___INT(val));
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
  else if (___CHARP(val))
    ___printf ("#\\x%x", ___INT(val));
  else if (___PAIRP(val))
    ___printf ("0x%08x (... . ...)", val);
  else if (___SUBTYPEDP(val))
    {
      ___SCMOBJ sym;
      ___printf ("0x%08x ", val);
      print_subtyped (val);
    }
  else
    ___printf ("0x%08x other", val);
}

#endif


#ifdef ENABLE_CONSISTENCY_CHECKS

___HIDDEN int reference_location; /* where is offending reference located */

#define IN_OBJECT       0
#define IN_REGISTER     1
#define IN_GLOBAL_VAR   2
#define IN_WILL_LIST    3
#define IN_CONTINUATION 4
#define IN_RC           5

___HIDDEN ___WORD *container_body; /* pointer to body of object      */
                                   /* containing offending reference */

___HIDDEN int mark_array_call_line;


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
      else if (obj == ___KEY_OBJ)
        ___printf ("#!key\n");
      else if (obj == ___REST)
        ___printf ("#!rest\n");
      else if (obj == ___UNUSED)
        ___printf ("#<unused>\n");
      else if (obj == ___DELETED)
        ___printf ("#<deleted>\n");
      else
        ___printf ("#<unknown>\n");
    }
  else
    {
      ___WORD* body = ___BODY(obj);
      ___WORD head = body[-1];
      int subtype = ___HD_SUBTYPE(head);

      switch (subtype)
        {
        case ___sVECTOR:
          if (max_depth > 0)
            {
              int i;
              ___printf ("#(\n");
              for (i=0; i<___CAST(int,___HD_WORDS(head)); i++)
                print_object (___FIELD(obj,i), max_depth-1, prefix, indent+2);
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
              print_object (___CAR(obj), max_depth-1, prefix, indent+1);
              print_prefix (prefix, indent);
              ___printf (" .\n");
              print_object (___CDR(obj), max_depth-1, prefix, indent+1);
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
          ___printf ("SYMBOL\n");
          break;
        case ___sKEYWORD:
          ___printf ("KEYWORD\n");
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
          ___printf ("STRING\n");
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


___HIDDEN void dump_memory_map ___PVOID
{
  int ns = the_msections->nb_sections;
  msection **sections = the_msections->sections;
  int i;

  ___printf (">>> Memory map:\n");

  for (i=0; i<ns; i++)
    ___printf (">>>  msection %2d:  0x%08x .. 0x%08x .. 0x%08x\n",
               i,
               sections[i]->base,
               sections[i]->base + (___MSECTION_SIZE>>1),
               sections[i]->base + ___MSECTION_SIZE);

  ___printf (">>>  alloc_msection       = 0x%08x\n", alloc_msection);
  ___printf (">>>  stack_msection       = 0x%08x\n", stack_msection);
  ___printf (">>>  heap_msection        = 0x%08x\n", heap_msection);
  ___printf (">>>  scan_msection        = 0x%08x\n", scan_msection);
  ___printf (">>>  alloc_stack_ptr      = 0x%08x\n", alloc_stack_ptr);
  ___printf (">>>  alloc_stack_limit    = 0x%08x\n", alloc_stack_limit);
  ___printf (">>>  alloc_heap_limit     = 0x%08x\n", alloc_heap_limit);
  ___printf (">>>  alloc_heap_ptr       = 0x%08x\n", alloc_heap_ptr);
  ___printf (">>>  scan_ptr             = 0x%08x\n", scan_ptr);
  ___printf (">>>  scan_msection->alloc = 0x%08x\n", scan_msection->alloc);
}

___HIDDEN void explain_problem
   ___P((___WORD obj,
         char *msg),
        (obj,
         msg)
___WORD obj;
char *msg;)
{
  dump_memory_map ();

  ___printf (">>> The object 0x%08x %s\n", obj, msg);

  {
    int j;
    for (j=-1; j<10; j++)
      {
        ___printf (">>>  body[%2d] = 0x%08x\n", j, ___BODY(obj)[j]);
        print_object (___BODY(obj)[j], 1, ">>>             ", 0);
      }
  }

  switch (reference_location)
    {
    case IN_OBJECT:
      {
        ___WORD container;
        ___WORD head = container_body[-1];
        long words = ___HD_WORDS(head);
        int subtype = ___HD_SUBTYPE(head);
        int i;

        if (subtype == ___sPAIR)
          container = ___TAG(container_body-___BODY_OFS,___tPAIR);
        else
          container = ___TAG(container_body-___BODY_OFS,___tSUBTYPED);

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
        ___printf ("object with body at 0x%08x:\n", container_body);

        ___printf (">>>  subtype = %d\n", subtype);
        ___printf (">>>  length  = %ld words\n", words);
        if (words <= 100)
          {
            for (i=0; i<words; i++)
              ___printf (">>>  body[%2d] = 0x%08x\n", i, container_body[i]);
          }
        else
          {
            for (i=0; i<50; i++)
              ___printf (">>>  body[%2d] = 0x%08x\n", i, container_body[i]);
            ___printf ("...\n");
            for (i=words-50; i<words; i++)
              ___printf (">>>  body[%2d] = 0x%08x\n", i, container_body[i]);
          }
        ___printf (">>> container =\n");
        print_object (container, 4, ">>>   ", 0);
        break;
      }

    case IN_REGISTER:
      ___printf (">>> The reference was found in a register\n");
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
   ___P((___WORD obj,
         char *msg),
        (obj,
         msg)
___WORD obj;
char *msg;)
{
  char *msgs[2];
  ___printf (">>> The GC has detected the following inconsistency\n");
  ___printf (">>> during call of mark_array on line %d of mem.c:\n",
             mark_array_call_line);
  explain_problem (obj, msg);
  msgs[0] = "GC inconsistency detected";
  msgs[1] = 0;
  ___fatal_error (msgs);
}


___HIDDEN void validate_old_obj
   ___P((___WORD obj),
        (obj)
___WORD obj;)
{
  ___WORD *hd_ptr = ___BODY(obj)-1;
  ___WORD head;
  int i = find_msection (the_msections, hd_ptr);
  if (i >= 0 && i < the_msections->nb_sections)
    {
      long pos = hd_ptr - the_msections->sections[i]->base;
      if (pos >= 0 && pos < ___MSECTION_SIZE)
        {
          head = *hd_ptr;
          if (___TYP(head) == ___FORW)
            {
              ___WORD *hd_ptr2 = ___UNTAG_AS(head,___FORW)+___BODY_OFS-1;
              int i2 = find_msection (the_msections, hd_ptr2);
              if (i2 >= 0 && i2 < the_msections->nb_sections)
                {
                  long pos2 = hd_ptr2 - the_msections->sections[i2]->base;
                  if (tospace_at_top
                      ? (pos2 < ___MSECTION_SIZE>>1 ||
                         pos2 >= ___MSECTION_SIZE)
                      : (pos2 < 0 ||
                         pos2 >= ___MSECTION_SIZE>>1))
                    bug (obj, "was copied outside of tospace");
                  else if (___HD_TYP((*hd_ptr2)) != ___MOVABLE0)
                    bug (obj, "was copied and copy is not ___MOVABLE0");
                }
              else
                bug (obj, "was copied outside of tospace");
            }
          else if (___HD_TYP(head) != ___MOVABLE0)
            bug (obj, "should be ___MOVABLE0");
          else if (tospace_at_top
                   ? (pos >= ___MSECTION_SIZE>>1 &&
                      pos < ___MSECTION_SIZE)
                   : (pos >= 0 &&
                      pos < ___MSECTION_SIZE>>1))
            bug (obj, "is in tospace");
          return;
        }
    }
  head = *hd_ptr; /* this dereference will likely bomb if there is a bug */
  if (___HD_TYP(head) != ___PERM && ___HD_TYP(head) != ___STILL)
    bug (obj, "is not ___PERM or ___STILL");
}


#define ZAP_PATTERN ___CAST(___WORD,0xcafebabe)


___HIDDEN void zap_section
   ___P((___WORD *start,
         int words),
        (start,
         words)
___WORD *start;
int words;)
{
  while (words > 0)
    {
      *start++ = ZAP_PATTERN;
      words--;
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


___HIDDEN int stack_fudge_used; /* space used in msection stack fudge */
___HIDDEN int heap_fudge_used; /* space used in msection heap fudge */


___HIDDEN void check_fudge_used ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  int n;

  n = unzapped_words (___ps->stack_limit - ___MSECTION_FUDGE,
                      ___MSECTION_FUDGE);

  if (n > stack_fudge_used)
    stack_fudge_used = n;

#ifdef ___DEBUG_GARBAGE_COLLECT
  ___printf ("********* used stack fudge = %d\n", n);
#endif

  n = ___ps->hp - ___ps->heap_limit;

  if (n > heap_fudge_used)
    heap_fudge_used = n;

#ifdef ___DEBUG_GARBAGE_COLLECT
  ___printf ("********* used heap fudge = %d\n", n);
#endif
}


___HIDDEN void zap_fromspace ___PVOID
{
  int i;
  for (i=0; i<the_msections->nb_sections; i++)
    zap_section (start_of_fromspace (the_msections->sections[i]),
                 ___MSECTION_SIZE>>1);
}

#endif


/*---------------------------------------------------------------------------*/

#ifdef GATHER_STATS

#define MAX_STAT_SIZE 20

___HIDDEN long movable_pair_objs;
___HIDDEN long movable_subtyped_objs[MAX_STAT_SIZE+2];

#endif


/*---------------------------------------------------------------------------*/

#ifdef ENABLE_CONSISTENCY_CHECKS

#define mark_array(start,n) mark_array_debug (start, n, __LINE__)

___HIDDEN void mark_array_debug
   ___P((___WORD *start,
         ___WORD n,
         int line),
        (start,
         n,
         line)
___WORD *start;
___WORD n;
int line;)

#else

___HIDDEN void mark_array
   ___P((___WORD *start,
         ___WORD n),
        (start,
         n)
___WORD *start;
___WORD n;)

#endif
{
  ___WORD *alloc = alloc_heap_ptr;
  ___WORD *limit = alloc_heap_limit;

#ifdef ENABLE_CONSISTENCY_CHECKS
  mark_array_call_line = line;
#endif

  while (n > 0)
    {
      ___WORD obj = *start;

      if (___MEM_ALLOCATED(obj))
        {
          ___WORD *body;
          ___WORD head;
          int head_typ;
          int subtype;

#ifdef ENABLE_CONSISTENCY_CHECKS
          if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
            validate_old_obj (obj);
#endif

          body = ___UNTAG(obj) + ___BODY_OFS;
          head = body[-1];
          subtype = ___HD_SUBTYPE(head);
          head_typ = ___HD_TYP(head);

          if (head_typ == ___MOVABLE0)
            {
              long words = ___HD_WORDS(head);
#if ___WS == 4
              ___BOOL pad = 0;
              while (alloc + words + (subtype >= ___sS64VECTOR ? 2 : 1) >
                     limit)
#else
              while (alloc + words + 1 > limit)
#endif
                {
                  alloc_heap_ptr = alloc;
                  next_heap_msection ();
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
#ifdef GATHER_STATS
              if (subtype == ___sPAIR)
                movable_pair_objs++;
              else if (words <= MAX_STAT_SIZE)
                movable_subtyped_objs[words]++;
              else
                movable_subtyped_objs[MAX_STAT_SIZE+1]++;
#endif
              *alloc++ = head;
              *start = ___TAG((alloc - ___BODY_OFS), ___TYP(obj));
              body[-1] = ___TAG((alloc - ___BODY_OFS), ___FORW);
              while (words > 0)
                {
                  *alloc++ = *body++;
                  words--;
                }
#if ___WS == 4
              if (pad)
                *alloc++ = ___MAKE_HD_WORDS(0, ___sVECTOR);
#endif
            }
          else if (head_typ == ___STILL)
            {
              if (body[___STILL_MARK_OFS - ___STILL_BODY_OFS] == -1)
                {
                  body[___STILL_MARK_OFS - ___STILL_BODY_OFS]
                    = ___CAST(___WORD,still_objs_to_scan);
                  still_objs_to_scan
                    = ___CAST(___WORD,body - ___STILL_BODY_OFS);
                }
            }
          else if (___TYP(head_typ) == ___FORW)
            {
              ___WORD *copy_body = ___UNTAG_AS(head, ___FORW) + ___BODY_OFS;
              *start = ___TAG((copy_body - ___BODY_OFS), ___TYP(obj));
            }
#ifdef ENABLE_CONSISTENCY_CHECKS
          else if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1 &&
                   head_typ != ___PERM)
            bug (obj, "was not ___PERM, ___STILL, ___MOVABLE0 or ___FORW");
#endif
        }

      start++;
      n--;
    }

  alloc_heap_ptr = alloc;
}


___HIDDEN void mark_captured_continuation
   ___P((___WORD *orig_ptr),
        (orig_ptr)
___WORD *orig_ptr;)
{
  ___processor_state ___ps = ___PSTATE;
  ___WORD *ptr = orig_ptr;
  int fs, link, i;
  ___WORD *fp;
  ___WORD ra1;
  ___WORD ra2;
  ___WORD cf;

  cf = *ptr;

  if (___TYP(cf) == ___tFIXNUM && cf != ___FIX(0))
    {
      /* continuation's frame is in the stack */

      ___WORD *alloc = alloc_heap_ptr;
      ___WORD *limit = alloc_heap_limit;

      next_frame:

      fp = ___CAST(___WORD*,cf);

      ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

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

      ___FP_ADJFP(fp,-___FRAME_SPACE(fs)); /* get base of frame */

      ra2 = ___FP_STK(fp,link+1);

      if (___TYP(ra2) == ___tFIXNUM)
        {
          ___COVER_MARK_CAPTURED_CONTINUATION_ALREADY_COPIED;
          *ptr = ra2; /* already copied, replace by forwarding pointer */

        }
      else
        {
          ___WORD forw;
          long words;

          ___COVER_MARK_CAPTURED_CONTINUATION_COPY;

          words = fs + ___FRAME_EXTRA_SLOTS;

          while (alloc + words + ___SUBTYPED_OVERHEAD > limit)
            {
              alloc_heap_ptr = alloc;
              next_heap_msection ();
              alloc = alloc_heap_ptr;
              limit = alloc_heap_limit;
            }

          *alloc++ = ___MAKE_HD_WORDS(words, ___sFRAME);
#if ___SUBTYPED_OVERHEAD != 1
          @error "___SUBTYPED_OVERHEAD != 1"
#endif
          forw = ___TAG((alloc - ___BODY_OFS), ___tFIXNUM);
          *alloc++ = ra1;
#if ___FRAME_EXTRA_SLOTS != 1
          @error "___FRAME_EXTRA_SLOTS != 1"
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

          if (___TYP(cf) == ___tFIXNUM && cf != ___FIX(0))
            goto next_frame;
        }

      *orig_ptr = ___TAG(___UNTAG_AS(*orig_ptr, ___tFIXNUM), ___tSUBTYPED);

      alloc_heap_ptr = alloc;
    }
  else
    mark_array (orig_ptr, 1);
}


___HIDDEN void mark_frame
   ___P((___WORD *fp,
         int fs,
         ___WORD gcmap,
         ___WORD *nextgcmap),
        (fp,
         fs,
         gcmap,
         nextgcmap)
___WORD *fp;
int fs;
___WORD gcmap;
___WORD *nextgcmap;)
{
  int i = 1;

#ifdef SHOW_FRAMESzzz

  {
    int k = 1;
    while (k <= fs)
      {
        ___WORD obj = ___FP_STK(fp,k);
        ___printf ("  %2d: ", k);
        print_value (obj);
        ___printf ("\n");
        k++;
      }
  }

#endif

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
                  mark_array (&___FP_STK(fp,i), i-j+1);
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
          mark_array (&___FP_STK(fp,i-1), i-j);
        }
      if (i == fs)
        return;
      if ((i & (___WORD_WIDTH-1)) == 0)
        gcmap = *nextgcmap++;
      else
        gcmap >>= 1;
      i++;
    }
}


___HIDDEN void mark_continuation ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  int fs, link;
  ___WORD *fp;
  ___WORD ra1;
  ___WORD ra2;
  ___WORD gcmap;
  ___WORD *nextgcmap = 0;

  fp = ___ps->fp;

  if (fp != ___ps->stack_break)
    for (;;)
      {
        ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

#ifdef SHOW_FRAMES
        ___printf ("continuation frame, ");
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
        ___printf ("fs=%d link=%d fp=0x%08x ra=", fs, link, ___CAST(___WORD,fp));
        print_value (ra1);
#endif

        ___FP_ADJFP(fp,-___FRAME_SPACE(fs)); /* get base of frame */

        ra2 = ___FP_STK(fp,link+1);

#ifdef SHOW_FRAMES
        if (fp == ___ps->stack_break)
          ___printf (" (first frame)\n");
        else
          ___printf (" (not first frame)\n");
#endif

        mark_frame (fp, fs, gcmap, nextgcmap);

        if (fp == ___ps->stack_break)
          break;

        ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)
      }

  mark_captured_continuation (&___FP_STK(fp,-___BREAK_FRAME_NEXT));
}


___HIDDEN void mark_rc ___PVOID
{
  rc_header *h = rc_head.next;

  while (h != &rc_head)
    {
      rc_header *next = h->next;
      mark_array (&h->data, 1);
      h = next;
    }
}


#define UNMARKED_MOVABLE(obj) \
((unmarked_typ = ___HD_TYP((unmarked_body=___BODY(obj))[-1])) == ___MOVABLE0)

#define UNMARKED_STILL(obj) \
(unmarked_typ == ___STILL && \
 unmarked_body[___STILL_MARK_OFS - ___STILL_BODY_OFS] == -1)

#define UNMARKED(obj) \
(UNMARKED_MOVABLE(obj) || UNMARKED_STILL(obj))


___HIDDEN long scan
   ___P((___WORD *body),
        (body)
___WORD *body;)
{
  ___WORD head = body[-1];
  long words = ___HD_WORDS(head);
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
          if (traverse_weak_refs)
            mark_array (body+1, words-1); /* don't scan link */
          else
            {
              ___WORD link = body[0];
              if (link == ___FLOATING_WILL) /* floating will? */
                {
                  /*
                   * Maintain a list of all the wills reached by the GC
                   * that are not in the executable or nonexecutable will
                   * lists.
                   */
                  body[0] = reached_floating_wills;
                  reached_floating_wills = ___TAG((body-1),___REACH_WILL);
                }
              else
                body[0] = link | ___REACH_WILL;
            }
        }
      else
        {
          int flags = ___INT(body[___GCHASHTABLE_FLAGS]);
          int i;

          if ((flags & ___GCHASHTABLE_FLAG_WEAK_KEYS) == 0 &&
              (flags & ___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS))
            {
              for (i=words-2; i>=___GCHASHTABLE_KEY0; i-=2)
                mark_array (body+i, 1); /* mark objects in key fields */
            }

          if ((flags & ___GCHASHTABLE_FLAG_WEAK_VALS) == 0)
            {
              for (i=words-1; i>=___GCHASHTABLE_VAL0; i-=2)
                mark_array (body+i, 1); /* mark objects in value fields */
            }

          body[0] = reached_gc_hash_tables;
          reached_gc_hash_tables = ___TAG((body-1),0);
        }
      break;

    case ___sSYMBOL:
    case ___sKEYWORD:
      mark_array (body, 1); /* only scan name of symbols & keywords */
      break;

    case ___sCONTINUATION:
      mark_captured_continuation (&body[___CONTINUATION_FRAME]);
      mark_array (body+1, words-1); /* skip the frame pointer */
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
        ___printf ("___sFRAME object, ");
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
        ___printf ("fs=%d link=%d fp=0x%08x ra=", fs, link, ___CAST(___WORD,fp));
        print_value (ra);
        ___printf ("\n");
#endif

        fp += fs;

        frame = ___FP_STK(fp,link+1);

        if (___TYP(frame) == ___tFIXNUM && frame != ___FIX(0))
          ___FP_SET_STK(fp,link+1,___FAL)

        mark_frame (fp, fs, gcmap, nextgcmap);

        if (___TYP(frame) == ___tFIXNUM && frame != ___FIX(0))
          ___FP_SET_STK(fp,link+1,___TAG(___UNTAG_AS(frame, ___tFIXNUM), ___tSUBTYPED))

        mark_array (&body[0], 1);
      }
      break;

    case ___sPROCEDURE:
      if (___HD_TYP(head) != ___PERM) /* only scan closures */
        mark_array (body+1, words-1); /* only scan free variables */
      break;

    default:
      mark_array (body, words);
      break;
    }

  return words;
}


___HIDDEN void init_still_objs_to_scan ___PVOID
{
  ___WORD *base = ___CAST(___WORD*,still_objs);
  ___WORD *to_scan = 0;

  while (base != 0)
    {
      if (base[___STILL_REFCOUNT_OFS] == 0)
        base[___STILL_MARK_OFS] = -1;
      else
        {
          base[___STILL_MARK_OFS] = ___CAST(___WORD,to_scan);
          to_scan = base;
        }
      base = ___CAST(___WORD*,base[___STILL_LINK_OFS]);
    }

  still_objs_to_scan = ___CAST(___WORD,to_scan);
}


___HIDDEN void scan_still_objs_to_scan ___PVOID
{
  ___WORD *base;

  while ((base = ___CAST(___WORD*,still_objs_to_scan)) != 0)
    {
      still_objs_to_scan = base[___STILL_MARK_OFS];
      scan (base + ___STILL_BODY_OFS);
    };
}


___HIDDEN void scan_movable_objs_to_scan ___PVOID
{
  ___WORD *body;
  long words;

  for (;;)
    {
      if (scan_msection == heap_msection)
        {
          if (scan_ptr >= alloc_heap_ptr)
            break;
        }
      else if (scan_ptr >= scan_msection->alloc)
        {
          scan_msection = scan_msection->next;
          scan_ptr = start_of_tospace (scan_msection);
          continue;
        }
      body = scan_ptr + 1;
      words = scan (body);
      scan_ptr = body + words;
    };
}


___HIDDEN void free_unmarked_still_objs ___PVOID
{
  ___WORD *last = &still_objs;
  ___WORD *base = ___CAST(___WORD*,*last);

  while (base != 0)
    {
      ___WORD link = base[___STILL_LINK_OFS];
      if (base[___STILL_MARK_OFS] == -1)
        {
          ___WORD head = base[___STILL_BODY_OFS-1];
          if (___HD_SUBTYPE(head) == ___sFOREIGN)
            ___release_foreign
              (___TAG((base + ___STILL_BODY_OFS - ___BODY_OFS), ___tSUBTYPED));
          words_nonmovable -= base[___STILL_LENGTH_OFS];
          free_mem_aligned (base);
        }
      else
        {
          *last = ___CAST(___WORD,base);
          last = base + ___STILL_LINK_OFS;
        }
      base = ___CAST(___WORD*,link);
    }

  *last = 0;
}


___HIDDEN void free_still_objs ___PVOID
{
  ___WORD *base = ___CAST(___WORD*,still_objs);

  still_objs = 0;

  while (base != 0)
    {
      ___WORD link = base[___STILL_LINK_OFS];
      ___WORD head = base[___STILL_BODY_OFS-1];
      if (___HD_SUBTYPE(head) == ___sFOREIGN)
        ___release_foreign
          (___TAG((base + ___STILL_BODY_OFS - ___BODY_OFS), ___tSUBTYPED));
      free_mem_aligned (base);
      base = ___CAST(___WORD*,link);
    }
}


___HIDDEN long adjust_heap
   ___P((long avail,
         long live),
        (avail,
         live)
long avail;
long live;)
{
  long target;
  int live_percent;

  if (___setup_params.gc_hook != 0)
    return ___setup_params.gc_hook (avail, live);

  live_percent = ___setup_params.live_percent;

  if (live_percent <= 0 || live_percent > 100)
    live_percent = ___DEFAULT_LIVE_PERCENT;

  if (live_percent < 100)
    target = live / live_percent * 100;
  else
    target = live + ___MSECTION_BIGGEST;

  if (target < ___CAST(long,(___setup_params.min_heap >> ___LWS)))
    target = ___CAST(long,(___setup_params.min_heap >> ___LWS));

  if (___setup_params.max_heap > 0 &&
      target > ___CAST(long,(___setup_params.max_heap >> ___LWS)))
    target = ___CAST(long,(___setup_params.max_heap >> ___LWS));

  return target;
}


___HIDDEN void setup_pstate ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  long avail;
  long stack_avail;
  long stack_left_before_fudge;
  long heap_avail;
  long heap_left_before_fudge;

#ifdef CALL_GC_FREQUENTLY
  avail = 0;
#else
  if (heap_size < WORDS_OCCUPIED)
    avail = 0;
  else
    avail = (heap_size - WORDS_OCCUPIED) / 2;
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

  ___begin_interrupt_service ();
  ___end_interrupt_service (0);

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
    {
      ___WORD *end = ___ps->stack_limit;
      ___WORD *start = end - ___MSECTION_FUDGE;
      if (end > alloc_stack_ptr)
        end = alloc_stack_ptr;
      zap_section (start, end - start);
      if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) == 3)
        {
          ___printf ("heap_size          = %d\n", heap_size);
          ___printf ("WORDS_OCCUPIED     = %d\n", WORDS_OCCUPIED);
          ___printf ("avail              = %d\n", avail);
          ___printf ("stack_avail        = %d\n", stack_avail);
          ___printf ("heap_avail         = %d\n", heap_avail);
          ___printf ("stack_msection     = 0x%08x\n", stack_msection);
          ___printf ("heap_msection      = 0x%08x\n", heap_msection);
          ___printf ("___ps->stack_start = 0x%08x\n", ___ps->stack_start);
          ___printf ("___ps->stack_break = 0x%08x\n", ___ps->stack_break);
          ___printf ("___ps->fp          = 0x%08x\n", ___ps->fp);
          ___printf ("alloc_stack_ptr    = 0x%08x\n", alloc_stack_ptr);
          ___printf ("___ps->stack_limit = 0x%08x\n", ___ps->stack_limit);
          ___printf ("alloc_stack_limit  = 0x%08x\n", alloc_stack_limit);
          ___printf ("alloc_heap_limit   = 0x%08x\n", alloc_heap_limit);
          ___printf ("___ps->heap_limit  = 0x%08x\n", ___ps->heap_limit);
          ___printf ("___ps->hp          = 0x%08x\n", ___ps->hp);
          ___printf ("alloc_heap_ptr     = 0x%08x\n", alloc_heap_ptr);
          ___printf ("alloc_heap_start   = 0x%08x\n", alloc_heap_start);
        }
    }
#endif
}


___SCMOBJ ___setup_mem ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  int init_nb_sections;

  /*
   * It is important to initialize the following pointers first so
   * that if the program terminates early the procedure ___cleanup_mem
   * will not access dangling pointers.
   */

  the_msections = 0;
  psections     = 0;
  still_objs    = 0;

  setup_rc ();

  /*
   * Set the overflow reserve so that the rest parameter handler can
   * construct the rest parameter list without having to call the
   * garbage collector.
   */

  normal_overflow_reserve = 2*((___MAX_NB_PARMS+___SUBTYPED_OVERHEAD) +
                               ___MAX_NB_ARGS*(___PAIR_SIZE+___PAIR_OVERHEAD));
  overflow_reserve = normal_overflow_reserve;

  /* Allocate heap */

  init_nb_sections = ((___setup_params.min_heap >> ___LWS) +
                      overflow_reserve + 2*___MSECTION_FUDGE +
                      2*((___MSECTION_SIZE>>1)-___MSECTION_FUDGE+1) - 1) /
                     (2*((___MSECTION_SIZE>>1)-___MSECTION_FUDGE+1));

  if (init_nb_sections < ___MIN_NB_MSECTIONS)
    init_nb_sections = ___MIN_NB_MSECTIONS;

  adjust_msections (&the_msections, init_nb_sections);

  if (the_msections == 0 ||
      the_msections->nb_sections != init_nb_sections)
    return ___FIX(___HEAP_OVERFLOW_ERR);

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
    {
      zap_fromspace ();
      stack_fudge_used = 0;
      heap_fudge_used = 0;
    }
#endif

  words_nonmovable = 0;
  words_prev_msections = 0;

  tospace_at_top = 0;
  stack_msection = 0;
  heap_msection = 0;
  nb_msections_used = 0;

  next_stack_msection ();
  next_heap_msection ();

  palloc_ptr = 0;

  /*
   * Create "break frame" of initial top section.
   */

  ___ps->stack_start = alloc_stack_start;
  alloc_stack_ptr = alloc_stack_start;

  ___FP_ADJFP(alloc_stack_ptr,___BREAK_FRAME_SPACE)
  ___FP_SET_STK(alloc_stack_ptr,-___BREAK_FRAME_NEXT,0)

  ___ps->stack_break = alloc_stack_ptr;

  /* 
   * Setup will lists.
   */

  ___ps->executable_wills = ___TAG(0,___EXEC_WILL); /* tagged empty list */
  ___ps->nonexecutable_wills = ___TAG(0,0); /* tagged empty list */

  heap_size = WORDS_AVAILABLE;

#ifdef ___DEBUG_STACK_LIMIT
  ___ps->poll_line = 0;
  ___ps->stack_limit_line = 0;
#endif

#ifdef ___DEBUG_HEAP_LIMIT
  ___ps->check_heap_line = 0;
  ___ps->heap_limit_line = 0;
#endif

  setup_pstate ();

  /* Setup global state */

  ___GSTATE->nb_gcs = 0.0;
  ___GSTATE->gc_user_time = 0.0;
  ___GSTATE->gc_sys_time = 0.0;
  ___GSTATE->gc_real_time = 0.0;
  ___GSTATE->bytes_allocated_minus_occupied = 0.0;

  ___GSTATE->last_gc_real_time = 0.0;
  ___GSTATE->last_gc_heap_size = ___CAST(___F64,heap_size) * ___WS;
  ___GSTATE->last_gc_live = 0.0;
  ___GSTATE->last_gc_movable = 0.0;
  ___GSTATE->last_gc_nonmovable = 0.0;

  return ___FIX(___NO_ERR);
}


void ___cleanup_mem ___PVOID
{
  free_msections (&the_msections);
  free_psections ();
  free_still_objs ();
  cleanup_rc ();
}


___HIDDEN void determine_will_executability
   ___P((___WORD list),
        (list)
___WORD list;)
{
  while (___UNTAG(list) != 0)
    {
      ___WORD* will_body = ___BODY(list);
      ___WORD will_head = will_body[-1];
      ___WORD testator;

      ___WORD *unmarked_body; /* used by the UNMARKED macro */
      int unmarked_typ;

      if (___TYP(will_head) == ___FORW) /* was will forwarded? */
        will_body = ___BODY_AS(will_head,___FORW);

      list = will_body[0];

      testator = will_body[1];

      if (___MEM_ALLOCATED(testator) && 
          UNMARKED(testator)) /* testator was not marked? */
        {
          /*
           * All paths to testator object from roots pass through
           * wills, so mark will as executable.
           */

          will_body[0] = list | ___EXEC_WILL;
        }
    }
}


___HIDDEN void process_wills ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  ___WORD* tail_exec;
  ___WORD* tail_nonexec;
  ___WORD curr;

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_WILL_LIST;
#endif

  determine_will_executability (___ps->nonexecutable_wills);
  determine_will_executability (reached_floating_wills);

  /*
   * Move executable wills to executable will list and also mark all
   * wills in case they were not reached.
   */

  tail_exec = &___ps->executable_wills;
  curr = *tail_exec;

  while (___UNTAG(curr) != 0)
    {
      ___WORD will = ___TAG(___UNTAG(curr),___tSUBTYPED);

      mark_array (&will, 1);

      *tail_exec = ___TAG(___UNTAG(will),___EXEC_WILL);
      tail_exec = &___BODY_AS(will,___tSUBTYPED)[0];
      curr = *tail_exec;
      if (curr & ___REACH_WILL) /* was will reached? */
        mark_array (tail_exec+1, ___WILL_SIZE-1);
    }

  tail_nonexec = &___ps->nonexecutable_wills;
  curr = *tail_nonexec;

  while (___UNTAG(curr) != 0)
    {
      ___WORD will = ___TAG(___UNTAG(curr),___tSUBTYPED);

      mark_array (&will, 1);

      if (___BODY_AS(will,___tSUBTYPED)[0] & ___EXEC_WILL)
        {
          /* move will to executable will list */

          *tail_exec = ___TAG(___UNTAG(will),___EXEC_WILL);
          tail_exec = &___BODY_AS(will,___tSUBTYPED)[0];
          curr = *tail_exec;
          if (curr & ___REACH_WILL) /* was will reached? */
            mark_array (tail_exec+1, ___WILL_SIZE-1);
        }
      else
        {
          /* leave will in nonexecutable will list */

          *tail_nonexec = ___TAG(___UNTAG(will),0);
          tail_nonexec = &___BODY_AS(will,___tSUBTYPED)[0];
          curr = *tail_nonexec;
          if (curr & ___REACH_WILL) /* was will reached? */
            mark_array (tail_nonexec+1, ___WILL_SIZE-1);
        }
    }

  *tail_exec = ___TAG(0,___EXEC_WILL);
  *tail_nonexec = ___TAG(0,0);

  curr = reached_floating_wills;

  while (___UNTAG(curr) != 0)
    {
      ___WORD* will_body = ___BODY(curr);

      curr = will_body[0];

      if (will_body[0] & ___EXEC_WILL)
        will_body[1] = ___FAL; /* zap testator */

      mark_array (will_body+1, ___HD_WORDS(will_body[-1])-1);

      will_body[0] = ___FLOATING_WILL;
    }
}


___HIDDEN void process_gc_hash_tables ___PVOID
{
  ___WORD curr = reached_gc_hash_tables;

  while (curr != ___TAG(0,0))
    {
      ___WORD* body = ___BODY(curr);
      long words = ___HD_WORDS(body[-1]);
      int flags = ___INT(body[___GCHASHTABLE_FLAGS]);
      int i;

      curr = body[0];

      body[0] = ___FIX(0);

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
                      ___WORD key_head = ___BODY(key)[-1];

                      if (___TYP(key_head) == ___FORW)
                        {
                          /*
                           * The key is movable and has been
                           * forwarded.
                           */

                          if (___MEM_ALLOCATED(val))
                            {
                              ___WORD val_head = ___BODY(val)[-1];

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
                              ___WORD val_head = ___BODY(val)[-1];

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
                          ___WORD val_head = ___BODY(val)[-1];

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
                      ___WORD head = ___BODY(key)[-1];

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
                      ___WORD head = ___BODY(val)[-1];

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


void ___gc_hash_table_rehash_in_situ
   ___P((___SCMOBJ ht),
        (ht)
___SCMOBJ ht;)
{
  ___WORD* body = ___BODY_AS(ht,___tSUBTYPED);
  long words = ___HD_WORDS(body[-1]);
  int size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;
  int i;

  ___FIELD(ht, ___GCHASHTABLE_FLAGS) =
    ___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
              ___FIXNOT(___FIX(___GCHASHTABLE_FLAG_KEY_MOVED)));

  if (___FIXZEROP(___FIXAND(body[___GCHASHTABLE_FLAGS],
                            ___FIX(___GCHASHTABLE_FLAG_MEM_ALLOC_KEYS))))
    {
      /*
       * Free deleted entries and mark key field of all active
       * entries.
       */

      for (i=___GCHASHTABLE_KEY0; i<words; i+=2)
        {
          ___WORD key = body[i];
          if (key == ___DELETED)
            {
              body[i] = ___UNUSED;
              body[___GCHASHTABLE_FREE] =
                ___FIXADD(body[___GCHASHTABLE_FREE], ___FIX(1));
            }
          else if (key != ___UNUSED)
            body[i] = ___MEM_ALLOCATED_SET(key);
        }

      /*
       * Move the active entries.
       */

      for (i=___GCHASHTABLE_KEY0; i<words; i+=2)
        {
          ___WORD key = body[i];

          if (___MEM_ALLOCATED(key))
            {
              /* this is an active entry that has not been moved yet */

              ___SCMOBJ val = body[i+1];
              ___SCMOBJ obj;
              int probe2;
              int step2;

              body[i] = ___UNUSED;
              body[i+1] = ___UNUSED;

            chain_non_mem_alloc:
              key = ___MEM_ALLOCATED_CLEAR(key); /* recover true encoding */
              probe2 = ___GCHASHTABLE_HASH1(key,size2>>1) << 1;
              step2 = ___GCHASHTABLE_HASH2(key,size2>>1) << 1;

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

      for (i=___GCHASHTABLE_KEY0; i<words; i+=2)
        {
          ___WORD key = body[i];
          if (key == ___DELETED)
            {
              body[i] = ___UNUSED;
              body[___GCHASHTABLE_FREE] =
                ___FIXADD(body[___GCHASHTABLE_FREE], ___FIX(1));
            }
          else
            body[i] = ___MEM_ALLOCATED_CLEAR(key);
        }

      /*
       * Move the active entries.
       */

      for (i=___GCHASHTABLE_KEY0; i<words; i+=2)
        {
          ___WORD key = body[i];

          if (key != ___UNUSED && !___MEM_ALLOCATED(key))
            {
              /* this is an active entry that has not been moved yet */

              ___SCMOBJ val = body[i+1];
              ___SCMOBJ obj;
              int probe2;
              int step2;

              body[i] = ___UNUSED;
              body[i+1] = ___UNUSED;

            chain_mem_alloc:
              key = ___MEM_ALLOCATED_SET(key); /* recover true encoding */
              probe2 = ___GCHASHTABLE_HASH1(key,size2>>1) << 1;
              step2 = ___GCHASHTABLE_HASH2(key,size2>>1) << 1;

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
  ___SCMOBJ obj;

  if (!___FIXZEROP(___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
                             ___FIX(___GCHASHTABLE_FLAG_KEY_MOVED))))
    ___gc_hash_table_rehash_in_situ (ht);

  size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;
  probe2 = ___GCHASHTABLE_HASH1(key,size2>>1) << 1;
  obj = ___FIELD(ht, probe2+___GCHASHTABLE_KEY0);

  if (___EQP(obj,key))
    return ___FIELD(ht, probe2+___GCHASHTABLE_VAL0);
  else if (!___EQP(obj,___UNUSED))
    {
      int step2 = ___GCHASHTABLE_HASH2(key,size2>>1) << 1;

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
  ___SCMOBJ obj;

  if (!___FIXZEROP(___FIXAND(___FIELD(ht, ___GCHASHTABLE_FLAGS),
                             ___FIX(___GCHASHTABLE_FLAG_KEY_MOVED))))
    ___gc_hash_table_rehash_in_situ (ht);

  size2 = ___INT(___VECTORLENGTH(ht)) - ___GCHASHTABLE_KEY0;
  probe2 = ___GCHASHTABLE_HASH1(key,size2>>1) << 1;
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
          int step2 = ___GCHASHTABLE_HASH2(key,size2>>1) << 1;
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
          int step2 = ___GCHASHTABLE_HASH2(key,size2>>1) << 1;

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

___SCMOBJ ___gc_hash_table_rehash
   ___P((___SCMOBJ ht_src,
         ___SCMOBJ ht_dst),
        (ht_src,
         ht_dst)
___SCMOBJ ht_src;
___SCMOBJ ht_dst;)
{
  ___WORD* body_src = ___BODY_AS(ht_src,___tSUBTYPED);
  long words = ___HD_WORDS(body_src[-1]);
  int i;

  for (i=___GCHASHTABLE_KEY0; i<words; i+=2)
    {
      ___WORD key = body_src[i];

      if (key != ___UNUSED &&
          key != ___DELETED)
        ___gc_hash_table_set (ht_dst, key, body_src[i+1]);
    }

  return ht_dst;
}

#ifdef ___DEBUG_GARBAGE_COLLECT

___BOOL ___garbage_collect_debug
   ___P((long nonmovable_words_needed,
         int line,
         char *file),
        (nonmovable_words_needed,
         line,
         file)
long nonmovable_words_needed;
int line;
char *file;)

#else

___BOOL ___garbage_collect
   ___P((long nonmovable_words_needed),
        (nonmovable_words_needed)
long nonmovable_words_needed;)

#endif
{
  long avail;
  int target_nb_sections;
  int stack_msection_index;
  ___BOOL overflow = 0;
  ___processor_state ___ps = ___PSTATE;
  ___F64 user_time_start, sys_time_start, real_time_start;
  ___F64 user_time_end, sys_time_end, real_time_end;
  ___F64 gc_user_time, gc_sys_time, gc_real_time;

  ___process_times (&user_time_start, &sys_time_start, &real_time_start);

  alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
  alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

#ifdef ___DEBUG_GARBAGE_COLLECT
  ___printf ("----------------------------------------- GC\n");
  ___printf ("heap_size          = %d\n", heap_size);
  ___printf ("WORDS_OCCUPIED     = %d\n", WORDS_OCCUPIED);
  ___printf ("___ps->stack_start = 0x%08x\n", ___ps->stack_start);
  ___printf ("___ps->stack_break = 0x%08x\n", ___ps->stack_break);
  ___printf ("___ps->fp          = 0x%08x\n", ___ps->fp);
  ___printf ("___ps->stack_limit = 0x%08x\n", ___ps->stack_limit);
  ___printf ("___ps->heap_limit  = 0x%08x\n", ___ps->heap_limit);
  ___printf ("___ps->hp          = 0x%08x\n", ___ps->hp);
#endif

  words_nonmovable += nonmovable_words_needed;

  ___GSTATE->bytes_allocated_minus_occupied =
    ___GSTATE->bytes_allocated_minus_occupied +
    ___CAST(___F64,WORDS_OCCUPIED) * ___WS;

#ifdef GATHER_STATS
  movable_pair_objs = 0;
  {
    int i;
    for (i=0; i<=MAX_STAT_SIZE+1; i++)
      movable_subtyped_objs[i] = 0;
  }
#endif

  stack_msection_index = stack_msection->index;

  words_prev_msections = 0;

  tospace_at_top = !tospace_at_top;
  stack_msection = 0;
  heap_msection = 0;
  nb_msections_used = 0;

  next_heap_msection ();

  scan_msection = heap_msection;
  scan_ptr = alloc_heap_ptr;

  /* maintain lists of wills and GC hash tables reached by GC */

  reached_floating_wills = ___TAG(0,___REACH_WILL);
  reached_gc_hash_tables = ___TAG(0,0);

  /* trace externally referenced still objects */

  init_still_objs_to_scan ();

  /* trace registers */

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_REGISTER;
#endif

  mark_array (&___ps->current_thread, 1);
  mark_array (&___ps->run_queue, 1);

  mark_array (___ps->r, ___NB_GVM_REGS);

  mark_array (&___GSTATE->symbol_table, 1);
  mark_array (&___GSTATE->keyword_table, 1);

  /* trace global variables */

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_GLOBAL_VAR;
#endif

  {
    ___WORD p = ___ps->glo_list_head;

    while (p != 0)
      {
#ifdef ___DEBUG_GARBAGE_COLLECT
        print_global_var_name (p);
#endif
        mark_array (&___CAST(___glo_struct*,p)->val, 1);
        p = ___CAST(___glo_struct*,p)->next;
      }
  }

  /* trace continuation */

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_CONTINUATION;
#endif

  mark_continuation ();

  /* trace reference counted objects */

#ifdef ENABLE_CONSISTENCY_CHECKS
  reference_location = IN_RC;
#endif

  mark_rc ();

  /* mark objects reachable from marked objects */

  traverse_weak_refs = 0; /* don't traverse weak references in first pass */

  again:

  if (___CAST(___WORD*,still_objs_to_scan) != 0)
    scan_still_objs_to_scan ();

  if (scan_msection != heap_msection ||
      scan_ptr < alloc_heap_ptr)
    {
      scan_movable_objs_to_scan ();
      goto again;
    }

  if (!traverse_weak_refs)
    {
      /* 
       * At this point all of the objects accessible from the roots
       * without having to traverse a weak reference have been scanned
       * by the GC.
       */

      traverse_weak_refs = 1;

      process_wills ();

      goto again;
    }

  process_gc_hash_tables ();

  free_unmarked_still_objs ();

  target_nb_sections = (adjust_heap (WORDS_AVAILABLE,
                                     WORDS_OCCUPIED
                                     + nonmovable_words_needed)
                        - words_nonmovable
                        + normal_overflow_reserve
                        + 2*___MSECTION_FUDGE
                        + 2*((___MSECTION_SIZE>>1)-___MSECTION_FUDGE+1) - 1)
                       / (2*((___MSECTION_SIZE>>1)-___MSECTION_FUDGE+1));

  if (target_nb_sections < nb_msections_used)
    {
      target_nb_sections = the_msections->nb_sections;
      overflow = 1;
    }

  if (target_nb_sections < ___MIN_NB_MSECTIONS)
    target_nb_sections = ___MIN_NB_MSECTIONS;

  /* Move the stack */

  {
    ___WORD *start;
    long length;
    ___WORD *p1;
    ___WORD *p2;

    start = alloc_stack_ptr;
    length = (___ps->stack_break + ___BREAK_FRAME_SPACE) - start;

    if (stack_msection_index >= target_nb_sections)
      {
        /*
         * The msection currently containing the stack is about to be
         * reclaimed by the call to 'adjust_msections'.  So we need to
         * save the stack before moving it to its final destination.
         */

        p1 = start + length;
        p2 = start_of_fromspace (the_msections->head) + length;

        while (p1 != start)
          *--p2 = *--p1;

        start = p2;
      }

    adjust_msections (&the_msections, target_nb_sections);

    next_stack_msection ();

    p1 = start + length;
    p2 = alloc_stack_ptr;

    ___ps->stack_start = alloc_stack_start;
    ___ps->stack_break = p2 - ___BREAK_FRAME_SPACE;

    while (p1 != start)
      *--p2 = *--p1;

    alloc_stack_ptr = p2;
  }

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
    zap_fromspace ();
#endif

  if (alloc_heap_ptr > alloc_heap_limit - ___MSECTION_FUDGE)
    next_heap_msection ();

  avail = WORDS_AVAILABLE + overflow_reserve - WORDS_OCCUPIED;

  if (avail <= overflow_reserve + (WORDS_MOVABLE_USABLE >> 10))
    {
      overflow = 1;
      overflow_reserve >>= 5; /* make 96.875% of reserve usable */
      if (overflow_reserve == 0)
        fatal_heap_overflow ();
    }
  else if (avail >= normal_overflow_reserve)
    overflow_reserve = normal_overflow_reserve; /* restore overflow reserve */

  ___GSTATE->bytes_allocated_minus_occupied =
    ___GSTATE->bytes_allocated_minus_occupied -
    ___CAST(___F64,WORDS_OCCUPIED) * ___WS;

  words_nonmovable -= nonmovable_words_needed;

  heap_size = WORDS_AVAILABLE;

  setup_pstate ();

  ___process_times (&user_time_end, &sys_time_end, &real_time_end);

  gc_user_time = user_time_end - user_time_start;
  gc_sys_time = sys_time_end - sys_time_start;
  gc_real_time = real_time_end - real_time_start;

  ___GSTATE->nb_gcs = ___GSTATE->nb_gcs + 1.0;
  ___GSTATE->gc_user_time += gc_user_time;
  ___GSTATE->gc_sys_time += gc_sys_time;
  ___GSTATE->gc_real_time += gc_real_time;

  ___GSTATE->last_gc_user_time = gc_user_time;
  ___GSTATE->last_gc_sys_time = gc_sys_time;
  ___GSTATE->last_gc_real_time = gc_real_time;
  ___GSTATE->last_gc_heap_size = ___CAST(___F64,heap_size) * ___WS;
  ___GSTATE->last_gc_alloc =
    ___GSTATE->bytes_allocated_minus_occupied +
    ___CAST(___F64,WORDS_OCCUPIED) * ___WS;
  ___GSTATE->last_gc_live = ___CAST(___F64,WORDS_OCCUPIED) * ___WS;
  ___GSTATE->last_gc_movable = ___CAST(___F64,WORDS_MOVABLE) * ___WS;
  ___GSTATE->last_gc_nonmovable = ___CAST(___F64,words_nonmovable) * ___WS;

  ___raise_interrupt (___INTR_GC); /* raise gc interrupt */

  return overflow;
}


#ifdef ___DEBUG_STACK_LIMIT

___BOOL ___stack_limit_debug
   ___P((int line,
         char *file),
        (line,
         file)
int line;
char *file;)

#else

___BOOL ___stack_limit ___PVOID

#endif
{
  ___processor_state ___ps = ___PSTATE;
  long avail;

#ifdef ___DEBUG_STACK_LIMIT
  ___ps->stack_limit_line = line;
  ___ps->stack_limit_file = file;
  ___printf ("___POLL caused ___stack_limit call at %s:%d\n",
             ___ps->poll_file,
             ___ps->poll_line);
#endif

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
    check_fudge_used ();
#endif

  alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
  alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

  avail = (heap_size - WORDS_OCCUPIED) / 2;

  if (avail > ___MSECTION_WASTE
#ifdef CALL_GC_FREQUENTLY
      && --___gc_calls_to_punt >= 0
#endif
     )
    {
      if (alloc_stack_ptr < alloc_stack_limit + ___MSECTION_FUDGE)
        {
          ___WORD frame;

          if (alloc_stack_ptr != ___ps->stack_break)
            frame = ___CAST(___WORD,alloc_stack_ptr);
          else
            frame = ___FP_STK(alloc_stack_ptr,-___BREAK_FRAME_NEXT);

          next_stack_msection ();

          /*
           * Create a "break frame" in the new stack msection.
           */

          ___ps->stack_start = alloc_stack_start;
          alloc_stack_ptr = alloc_stack_start;

          ___FP_ADJFP(alloc_stack_ptr,___BREAK_FRAME_SPACE)
          ___FP_SET_STK(alloc_stack_ptr,-___BREAK_FRAME_NEXT,frame)

          ___ps->stack_break = alloc_stack_ptr;
        }

      setup_pstate ();

      return 0;
    }

  return 1;
}


#ifdef ___DEBUG_HEAP_LIMIT

___BOOL ___heap_limit_debug
   ___P((int line,
         char *file),
        (line,
         file)
int line;
char *file;)

#else

___BOOL ___heap_limit ___PVOID

#endif
{
  ___processor_state ___ps = ___PSTATE;
  long avail;

#ifdef ___DEBUG_HEAP_LIMIT
  ___ps->heap_limit_line = line;
  ___ps->heap_limit_file = file;
#endif

#ifdef ENABLE_CONSISTENCY_CHECKS
  if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) >= 1)
    check_fudge_used ();
#endif

  alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
  alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

  avail = (heap_size - WORDS_OCCUPIED) / 2;

  if (avail > ___MSECTION_WASTE
#ifdef CALL_GC_FREQUENTLY
      && --___gc_calls_to_punt >= 0
#endif
     )
    {
      if (alloc_heap_ptr > alloc_heap_limit - ___MSECTION_FUDGE)
        next_heap_msection ();

      setup_pstate ();

      return 0;
    }

  return 1;
}


/*---------------------------------------------------------------------------*/


___F64 ___bytes_allocated ___PVOID
{
  ___processor_state ___ps = ___PSTATE;

  alloc_stack_ptr = ___ps->fp; /* needed by 'WORDS_OCCUPIED' */
  alloc_heap_ptr  = ___ps->hp; /* needed by 'WORDS_OCCUPIED' */

  return ___GSTATE->bytes_allocated_minus_occupied +
         ___CAST(___F64,WORDS_OCCUPIED) * ___WS;
}


/*---------------------------------------------------------------------------*/

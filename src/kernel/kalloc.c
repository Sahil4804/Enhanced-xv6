// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct spinlock lock_for_ref;
int refc[(PGROUNDUP(PHYSTOP) >> PGSHIFT)] = {0};
void kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&lock_for_ref, "lock_for_ref");
  acquire(&lock_for_ref);
  memset(&refc, sizeof(refc), 0);
  release(&lock_for_ref);
  freerange(end, (void *)PHYSTOP);
  // printf("kinit done\n");
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
  {
    add_ref(p);
    kfree(p);
  }
}
int get_ref_index(void *pa)
{
  return ((uint64)pa >> PGSHIFT);
}
void add_ref(void *pa)
{
  acquire(&lock_for_ref);
  int index = get_ref_index(pa);
  if (index == -1)
  {
    release(&lock_for_ref);
    return;
  }
  refc[index] = refc[index] + 1;
  release(&lock_for_ref);
}

void dec_ref(void *pa)
{

  acquire(&lock_for_ref);
  int index = get_ref_index(pa);
  if (index == -1)
  {
    release(&lock_for_ref);
    return;
  }
  int cur_count = refc[index];
  if (cur_count <= 0)
  {
    release(&lock_for_ref);
    panic("def a freed page!");
  }
  refc[index] = refc[index] - 1;
  release(&lock_for_ref);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{

  // int res=dec_ref(pa);
  acquire(&lock_for_ref);
  int index = get_ref_index(pa);
  if (index == -1)
  {
    release(&lock_for_ref);
    return;
  }
  refc[index] = refc[index] - 1;
  int flag = 1;
  if (refc[index] == 0)
  {
    /* code */
    flag = 0;
  }

  release(&lock_for_ref);
  if (flag == 1)
  {
    return;
  }

  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run *)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if (r)
  {
    memset((char *)r, 5, PGSIZE); // fill with junk
    add_ref((void *)r);
  }
  return (void *)r;
}

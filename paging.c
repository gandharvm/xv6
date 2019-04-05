#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "paging.h"
#include "fs.h"



/* Allocate eight consecutive disk blocks.
 * Save the content of the physical page in the pte
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{	
	// Allocate a disk block to write

	uint block_addr = balloc_page(ROOTDEV);

	char *va = (char *)P2V(PTE_ADDR(*pte));

	// cprintf("va: %x\n",va);

	// Writing the PTE into the disk block
	write_page_to_disk(ROOTDEV, va, block_addr);

	kfree(va);

	// Save the block id into PTE
	// Setting the swapped flag for the PTE
	uint Blk = block_addr << 12;

	*pte = Blk;

	// cprintf("Bit before : %x\n", *pte & PTE_P);

	*pte = *pte | PTE_SWP;
	// Mark the PTE corresponding to swapped va as invalid
	*pte = *pte & ~PTE_P;

	// cprintf("Bit after : %x\n", *pte & PTE_P);



}

/* Select a victim and swap the contents to the disk.
 */

int
swap_page(pde_t *pgdir)
{

	pte_t *victim = select_a_victim(pgdir);

	// cprintf("Victim: %x\n" ,victim);
	
	swap_page_from_pte(victim);

	return 1;
}


/* Map a physical page to the virtual address addr.
 * If the page table entry points to a swapped block
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
	struct proc *curproc = myproc();
	uint blk = getswappedblk(pgdir,addr);

	allocuvm(pgdir,addr,addr+PGSIZE);
	pte_t *ptentry = uva2pte(pgdir, addr);

	switchuvm(curproc);

	// if blk was not -1, read_page_from_disk
	if ( blk != -1 )
	{	
		
		char *pg = P2V(PTE_ADDR(*ptentry));
		read_page_from_disk(ROOTDEV,pg,blk);
		bfree_page(ROOTDEV,blk);
		
	}
}

/* page fault handler */
void
handle_pgfault()
{
	unsigned addr;
	struct proc *curproc = myproc();

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
	addr &= ~0xfff;

	map_address(curproc->pgdir, addr);

}



/* Map a physical page to the virtual address addr.
 * If the page table entry points to a swapped block
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address2(pde_t *pgdir, uint addr)
{
	// Check if it was previously swapped and restore contents
	pde_t *pde;

	pde = &pgdir[PDX(addr)];
	pte_t *pgtab;
	pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
	pte_t *pte = &pgtab[PTX(addr)];

	
	if (*pte & PTE_SWP)
	{
		uint block_addr = *pte >> 10;



		char * addr = kalloc();
		if (addr == 0)
		{
			swap_page(pgdir);
			addr = kalloc();
		}
		*pte = *addr | PTE_P;
		// cprintf("got the swapped page!!");
		read_page_from_disk(ROOTDEV,addr,block_addr);

	}
	else{
		// Allocating physical address corresponding to virtual address, addr
		
		// char* mem = kalloc();

		if(allocuvm(pgdir,addr,addr + PGSIZE) == 0){
		// if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U|PTE_A) < 0){
	
			// Implement swap_pages here
			swap_page(pgdir);

			// Allocate again
			allocuvm(pgdir,addr,addr + PGSIZE);
			// cprintf("Allocated again!!");
		}
	}
	

}

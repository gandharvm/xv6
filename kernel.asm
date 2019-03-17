
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2f 10 80       	mov    $0x80102fe0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 70 10 80       	push   $0x80107020
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 95 42 00 00       	call   801042f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 70 10 80       	push   $0x80107027
80100097:	50                   	push   %eax
80100098:	e8 43 41 00 00       	call   801041e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <write_page_to_disk>:
 * starting at blk.
 */
void
write_page_to_disk(uint dev, char *pg, uint blk)
{
}
801000d0:	c3                   	ret    
801000d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000df:	90                   	nop

801000e0 <read_page_from_disk>:
801000e0:	c3                   	ret    
801000e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ef:	90                   	nop

801000f0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000f0:	55                   	push   %ebp
801000f1:	89 e5                	mov    %esp,%ebp
801000f3:	57                   	push   %edi
801000f4:	56                   	push   %esi
801000f5:	53                   	push   %ebx
801000f6:	83 ec 18             	sub    $0x18,%esp
801000f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000ff:	68 c0 b5 10 80       	push   $0x8010b5c0
80100104:	e8 e7 42 00 00       	call   801043f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
8010010f:	83 c4 10             	add    $0x10,%esp
80100112:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100118:	75 11                	jne    8010012b <bread+0x3b>
8010011a:	eb 24                	jmp    80100140 <bread+0x50>
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100123:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100129:	74 15                	je     80100140 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010012b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010012e:	75 f0                	jne    80100120 <bread+0x30>
80100130:	3b 73 08             	cmp    0x8(%ebx),%esi
80100133:	75 eb                	jne    80100120 <bread+0x30>
      b->refcnt++;
80100135:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100139:	eb 3f                	jmp    8010017a <bread+0x8a>
8010013b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010013f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100140:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100146:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010014c:	75 0d                	jne    8010015b <bread+0x6b>
8010014e:	eb 70                	jmp    801001c0 <bread+0xd0>
80100150:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100153:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100159:	74 65                	je     801001c0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010015b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010015e:	85 c0                	test   %eax,%eax
80100160:	75 ee                	jne    80100150 <bread+0x60>
80100162:	f6 03 04             	testb  $0x4,(%ebx)
80100165:	75 e9                	jne    80100150 <bread+0x60>
      b->dev = dev;
80100167:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010016a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010016d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100173:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100182:	e8 89 43 00 00       	call   80104510 <release>
      acquiresleep(&b->lock);
80100187:	8d 43 0c             	lea    0xc(%ebx),%eax
8010018a:	89 04 24             	mov    %eax,(%esp)
8010018d:	e8 8e 40 00 00       	call   80104220 <acquiresleep>
80100192:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100195:	f6 03 02             	testb  $0x2,(%ebx)
80100198:	74 0e                	je     801001a8 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010019a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010019d:	89 d8                	mov    %ebx,%eax
8010019f:	5b                   	pop    %ebx
801001a0:	5e                   	pop    %esi
801001a1:	5f                   	pop    %edi
801001a2:	5d                   	pop    %ebp
801001a3:	c3                   	ret    
801001a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
801001a8:	83 ec 0c             	sub    $0xc,%esp
801001ab:	53                   	push   %ebx
801001ac:	e8 7f 20 00 00       	call   80102230 <iderw>
801001b1:	83 c4 10             	add    $0x10,%esp
}
801001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001b7:	89 d8                	mov    %ebx,%eax
801001b9:	5b                   	pop    %ebx
801001ba:	5e                   	pop    %esi
801001bb:	5f                   	pop    %edi
801001bc:	5d                   	pop    %ebp
801001bd:	c3                   	ret    
801001be:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001c0:	83 ec 0c             	sub    $0xc,%esp
801001c3:	68 2e 70 10 80       	push   $0x8010702e
801001c8:	e8 e3 01 00 00       	call   801003b0 <panic>
801001cd:	8d 76 00             	lea    0x0(%esi),%esi

801001d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 10             	sub    $0x10,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001da:	8d 43 0c             	lea    0xc(%ebx),%eax
801001dd:	50                   	push   %eax
801001de:	e8 dd 40 00 00       	call   801042c0 <holdingsleep>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	85 c0                	test   %eax,%eax
801001e8:	74 0f                	je     801001f9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ea:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001f3:	c9                   	leave  
  iderw(b);
801001f4:	e9 37 20 00 00       	jmp    80102230 <iderw>
    panic("bwrite");
801001f9:	83 ec 0c             	sub    $0xc,%esp
801001fc:	68 3f 70 10 80       	push   $0x8010703f
80100201:	e8 aa 01 00 00       	call   801003b0 <panic>
80100206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010020d:	8d 76 00             	lea    0x0(%esi),%esi

80100210 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100210:	55                   	push   %ebp
80100211:	89 e5                	mov    %esp,%ebp
80100213:	56                   	push   %esi
80100214:	53                   	push   %ebx
80100215:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100218:	8d 73 0c             	lea    0xc(%ebx),%esi
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 9c 40 00 00       	call   801042c0 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	74 66                	je     80100291 <brelse+0x81>
    panic("brelse");
	
  releasesleep(&b->lock);
8010022b:	83 ec 0c             	sub    $0xc,%esp
8010022e:	56                   	push   %esi
8010022f:	e8 4c 40 00 00       	call   80104280 <releasesleep>

  acquire(&bcache.lock);
80100234:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010023b:	e8 b0 41 00 00       	call   801043f0 <acquire>
  b->refcnt--;
80100240:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100243:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100246:	83 e8 01             	sub    $0x1,%eax
80100249:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010024c:	85 c0                	test   %eax,%eax
8010024e:	75 2f                	jne    8010027f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100250:	8b 43 54             	mov    0x54(%ebx),%eax
80100253:	8b 53 50             	mov    0x50(%ebx),%edx
80100256:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100259:	8b 43 50             	mov    0x50(%ebx),%eax
8010025c:	8b 53 54             	mov    0x54(%ebx),%edx
8010025f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100262:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100267:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010026e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100271:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100276:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100279:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010027f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100286:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100289:	5b                   	pop    %ebx
8010028a:	5e                   	pop    %esi
8010028b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010028c:	e9 7f 42 00 00       	jmp    80104510 <release>
    panic("brelse");
80100291:	83 ec 0c             	sub    $0xc,%esp
80100294:	68 46 70 10 80       	push   $0x80107046
80100299:	e8 12 01 00 00       	call   801003b0 <panic>
8010029e:	66 90                	xchg   %ax,%ax

801002a0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	53                   	push   %ebx
801002a6:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
801002a9:	ff 75 08             	pushl  0x8(%ebp)
{
801002ac:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801002af:	e8 8c 15 00 00       	call   80101840 <iunlock>
  target = n;
  acquire(&cons.lock);
801002b4:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002bb:	e8 30 41 00 00       	call   801043f0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002c3:	83 c4 10             	add    $0x10,%esp
801002c6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002c8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002ca:	85 f6                	test   %esi,%esi
801002cc:	0f 8e a0 00 00 00    	jle    80100372 <consoleread+0xd2>
801002d2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002d4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002da:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002e0:	74 29                	je     8010030b <consoleread+0x6b>
801002e2:	eb 5c                	jmp    80100340 <consoleread+0xa0>
801002e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002e8:	83 ec 08             	sub    $0x8,%esp
801002eb:	68 20 a5 10 80       	push   $0x8010a520
801002f0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002f5:	e8 86 3b 00 00       	call   80103e80 <sleep>
    while(input.r == input.w){
801002fa:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
80100300:	83 c4 10             	add    $0x10,%esp
80100303:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
80100309:	75 35                	jne    80100340 <consoleread+0xa0>
      if(myproc()->killed){
8010030b:	e8 00 36 00 00       	call   80103910 <myproc>
80100310:	8b 48 24             	mov    0x24(%eax),%ecx
80100313:	85 c9                	test   %ecx,%ecx
80100315:	74 d1                	je     801002e8 <consoleread+0x48>
        release(&cons.lock);
80100317:	83 ec 0c             	sub    $0xc,%esp
8010031a:	68 20 a5 10 80       	push   $0x8010a520
8010031f:	e8 ec 41 00 00       	call   80104510 <release>
        ilock(ip);
80100324:	5a                   	pop    %edx
80100325:	ff 75 08             	pushl  0x8(%ebp)
80100328:	e8 33 14 00 00       	call   80101760 <ilock>
        return -1;
8010032d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100330:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100338:	5b                   	pop    %ebx
80100339:	5e                   	pop    %esi
8010033a:	5f                   	pop    %edi
8010033b:	5d                   	pop    %ebp
8010033c:	c3                   	ret    
8010033d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100340:	8d 42 01             	lea    0x1(%edx),%eax
80100343:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100348:	89 d0                	mov    %edx,%eax
8010034a:	83 e0 7f             	and    $0x7f,%eax
8010034d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100354:	83 f8 04             	cmp    $0x4,%eax
80100357:	74 46                	je     8010039f <consoleread+0xff>
    *dst++ = c;
80100359:	89 da                	mov    %ebx,%edx
    --n;
8010035b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010035e:	f7 da                	neg    %edx
80100360:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100363:	83 f8 0a             	cmp    $0xa,%eax
80100366:	74 31                	je     80100399 <consoleread+0xf9>
  while(n > 0){
80100368:	85 db                	test   %ebx,%ebx
8010036a:	0f 85 64 ff ff ff    	jne    801002d4 <consoleread+0x34>
80100370:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100372:	83 ec 0c             	sub    $0xc,%esp
80100375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100378:	68 20 a5 10 80       	push   $0x8010a520
8010037d:	e8 8e 41 00 00       	call   80104510 <release>
  ilock(ip);
80100382:	58                   	pop    %eax
80100383:	ff 75 08             	pushl  0x8(%ebp)
80100386:	e8 d5 13 00 00       	call   80101760 <ilock>
  return target - n;
8010038b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010038e:	83 c4 10             	add    $0x10,%esp
}
80100391:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100394:	5b                   	pop    %ebx
80100395:	5e                   	pop    %esi
80100396:	5f                   	pop    %edi
80100397:	5d                   	pop    %ebp
80100398:	c3                   	ret    
80100399:	89 f0                	mov    %esi,%eax
8010039b:	29 d8                	sub    %ebx,%eax
8010039d:	eb d3                	jmp    80100372 <consoleread+0xd2>
      if(n < target){
8010039f:	89 f0                	mov    %esi,%eax
801003a1:	29 d8                	sub    %ebx,%eax
801003a3:	39 f3                	cmp    %esi,%ebx
801003a5:	73 cb                	jae    80100372 <consoleread+0xd2>
        input.r--;
801003a7:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801003ad:	eb c3                	jmp    80100372 <consoleread+0xd2>
801003af:	90                   	nop

801003b0 <panic>:
{
801003b0:	55                   	push   %ebp
801003b1:	89 e5                	mov    %esp,%ebp
801003b3:	56                   	push   %esi
801003b4:	53                   	push   %ebx
801003b5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003b8:	fa                   	cli    
  cons.locking = 0;
801003b9:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003c0:	00 00 00 
  getcallerpcs(&s, pcs);
801003c3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003c6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003c9:	e8 92 24 00 00       	call   80102860 <lapicid>
801003ce:	83 ec 08             	sub    $0x8,%esp
801003d1:	50                   	push   %eax
801003d2:	68 4d 70 10 80       	push   $0x8010704d
801003d7:	e8 f4 02 00 00       	call   801006d0 <cprintf>
  cprintf(s);
801003dc:	58                   	pop    %eax
801003dd:	ff 75 08             	pushl  0x8(%ebp)
801003e0:	e8 eb 02 00 00       	call   801006d0 <cprintf>
  cprintf("\n");
801003e5:	c7 04 24 75 79 10 80 	movl   $0x80107975,(%esp)
801003ec:	e8 df 02 00 00       	call   801006d0 <cprintf>
  getcallerpcs(&s, pcs);
801003f1:	8d 45 08             	lea    0x8(%ebp),%eax
801003f4:	5a                   	pop    %edx
801003f5:	59                   	pop    %ecx
801003f6:	53                   	push   %ebx
801003f7:	50                   	push   %eax
801003f8:	e8 13 3f 00 00       	call   80104310 <getcallerpcs>
  for(i=0; i<10; i++)
801003fd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100400:	83 ec 08             	sub    $0x8,%esp
80100403:	ff 33                	pushl  (%ebx)
80100405:	83 c3 04             	add    $0x4,%ebx
80100408:	68 61 70 10 80       	push   $0x80107061
8010040d:	e8 be 02 00 00       	call   801006d0 <cprintf>
  for(i=0; i<10; i++)
80100412:	83 c4 10             	add    $0x10,%esp
80100415:	39 f3                	cmp    %esi,%ebx
80100417:	75 e7                	jne    80100400 <panic+0x50>
  panicked = 1; // freeze other CPU
80100419:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100420:	00 00 00 
    ;
80100423:	eb fe                	jmp    80100423 <panic+0x73>
80100425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010042c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100430 <consputc.part.0>:
consputc(int c)
80100430:	55                   	push   %ebp
80100431:	89 e5                	mov    %esp,%ebp
80100433:	57                   	push   %edi
80100434:	56                   	push   %esi
80100435:	53                   	push   %ebx
80100436:	89 c3                	mov    %eax,%ebx
80100438:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010043b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100440:	0f 84 ea 00 00 00    	je     80100530 <consputc.part.0+0x100>
    uartputc(c);
80100446:	83 ec 0c             	sub    $0xc,%esp
80100449:	50                   	push   %eax
8010044a:	e8 d1 57 00 00       	call   80105c20 <uartputc>
8010044f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100452:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100457:	b8 0e 00 00 00       	mov    $0xe,%eax
8010045c:	89 fa                	mov    %edi,%edx
8010045e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010045f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100464:	89 ca                	mov    %ecx,%edx
80100466:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100467:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046a:	89 fa                	mov    %edi,%edx
8010046c:	c1 e0 08             	shl    $0x8,%eax
8010046f:	89 c6                	mov    %eax,%esi
80100471:	b8 0f 00 00 00       	mov    $0xf,%eax
80100476:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100477:	89 ca                	mov    %ecx,%edx
80100479:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010047a:	0f b6 c0             	movzbl %al,%eax
8010047d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010047f:	83 fb 0a             	cmp    $0xa,%ebx
80100482:	0f 84 90 00 00 00    	je     80100518 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100488:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010048e:	74 70                	je     80100500 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100490:	0f b6 db             	movzbl %bl,%ebx
80100493:	8d 70 01             	lea    0x1(%eax),%esi
80100496:	80 cf 07             	or     $0x7,%bh
80100499:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004a0:	80 
  if(pos < 0 || pos > 25*80)
801004a1:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
801004a7:	0f 8f f9 00 00 00    	jg     801005a6 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
801004ad:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
801004b3:	0f 8f a7 00 00 00    	jg     80100560 <consputc.part.0+0x130>
801004b9:	89 f0                	mov    %esi,%eax
801004bb:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004c2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004c5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004cd:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d2:	89 da                	mov    %ebx,%edx
801004d4:	ee                   	out    %al,(%dx)
801004d5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004da:	89 f8                	mov    %edi,%eax
801004dc:	89 ca                	mov    %ecx,%edx
801004de:	ee                   	out    %al,(%dx)
801004df:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e4:	89 da                	mov    %ebx,%edx
801004e6:	ee                   	out    %al,(%dx)
801004e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004eb:	89 ca                	mov    %ecx,%edx
801004ed:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ee:	b8 20 07 00 00       	mov    $0x720,%eax
801004f3:	66 89 06             	mov    %ax,(%esi)
}
801004f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004f9:	5b                   	pop    %ebx
801004fa:	5e                   	pop    %esi
801004fb:	5f                   	pop    %edi
801004fc:	5d                   	pop    %ebp
801004fd:	c3                   	ret    
801004fe:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
80100500:	8d 70 ff             	lea    -0x1(%eax),%esi
80100503:	85 c0                	test   %eax,%eax
80100505:	75 9a                	jne    801004a1 <consputc.part.0+0x71>
80100507:	be 00 80 0b 80       	mov    $0x800b8000,%esi
8010050c:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100510:	31 ff                	xor    %edi,%edi
80100512:	eb b4                	jmp    801004c8 <consputc.part.0+0x98>
80100514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100518:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010051d:	f7 e2                	mul    %edx
8010051f:	c1 ea 06             	shr    $0x6,%edx
80100522:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100525:	c1 e0 04             	shl    $0x4,%eax
80100528:	8d 70 50             	lea    0x50(%eax),%esi
8010052b:	e9 71 ff ff ff       	jmp    801004a1 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100530:	83 ec 0c             	sub    $0xc,%esp
80100533:	6a 08                	push   $0x8
80100535:	e8 e6 56 00 00       	call   80105c20 <uartputc>
8010053a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100541:	e8 da 56 00 00       	call   80105c20 <uartputc>
80100546:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010054d:	e8 ce 56 00 00       	call   80105c20 <uartputc>
80100552:	83 c4 10             	add    $0x10,%esp
80100555:	e9 f8 fe ff ff       	jmp    80100452 <consputc.part.0+0x22>
8010055a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010056b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100570:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100577:	68 a0 80 0b 80       	push   $0x800b80a0
8010057c:	68 00 80 0b 80       	push   $0x800b8000
80100581:	e8 7a 40 00 00       	call   80104600 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100586:	b8 80 07 00 00       	mov    $0x780,%eax
8010058b:	83 c4 0c             	add    $0xc,%esp
8010058e:	29 d8                	sub    %ebx,%eax
80100590:	01 c0                	add    %eax,%eax
80100592:	50                   	push   %eax
80100593:	6a 00                	push   $0x0
80100595:	56                   	push   %esi
80100596:	e8 c5 3f 00 00       	call   80104560 <memset>
8010059b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010059e:	83 c4 10             	add    $0x10,%esp
801005a1:	e9 22 ff ff ff       	jmp    801004c8 <consputc.part.0+0x98>
    panic("pos under/overflow");
801005a6:	83 ec 0c             	sub    $0xc,%esp
801005a9:	68 65 70 10 80       	push   $0x80107065
801005ae:	e8 fd fd ff ff       	call   801003b0 <panic>
801005b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005c0 <printint>:
{
801005c0:	55                   	push   %ebp
801005c1:	89 e5                	mov    %esp,%ebp
801005c3:	57                   	push   %edi
801005c4:	56                   	push   %esi
801005c5:	53                   	push   %ebx
801005c6:	83 ec 2c             	sub    $0x2c,%esp
801005c9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005cc:	85 c9                	test   %ecx,%ecx
801005ce:	74 04                	je     801005d4 <printint+0x14>
801005d0:	85 c0                	test   %eax,%eax
801005d2:	78 68                	js     8010063c <printint+0x7c>
    x = xx;
801005d4:	89 c1                	mov    %eax,%ecx
801005d6:	31 f6                	xor    %esi,%esi
  i = 0;
801005d8:	31 db                	xor    %ebx,%ebx
801005da:	eb 04                	jmp    801005e0 <printint+0x20>
  }while((x /= base) != 0);
801005dc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005de:	89 fb                	mov    %edi,%ebx
801005e0:	89 c8                	mov    %ecx,%eax
801005e2:	31 d2                	xor    %edx,%edx
801005e4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005e7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ea:	0f b6 92 90 70 10 80 	movzbl -0x7fef8f70(%edx),%edx
801005f1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005f5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005f8:	76 e2                	jbe    801005dc <printint+0x1c>
  if(sign)
801005fa:	85 f6                	test   %esi,%esi
801005fc:	75 32                	jne    80100630 <printint+0x70>
801005fe:	0f be c2             	movsbl %dl,%eax
80100601:	89 df                	mov    %ebx,%edi
  if(panicked){
80100603:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100609:	85 c9                	test   %ecx,%ecx
8010060b:	75 20                	jne    8010062d <printint+0x6d>
8010060d:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100611:	e8 1a fe ff ff       	call   80100430 <consputc.part.0>
  while(--i >= 0)
80100616:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100619:	39 d8                	cmp    %ebx,%eax
8010061b:	74 27                	je     80100644 <printint+0x84>
  if(panicked){
8010061d:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100623:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100626:	83 eb 01             	sub    $0x1,%ebx
80100629:	85 d2                	test   %edx,%edx
8010062b:	74 e4                	je     80100611 <printint+0x51>
  asm volatile("cli");
8010062d:	fa                   	cli    
      ;
8010062e:	eb fe                	jmp    8010062e <printint+0x6e>
    buf[i++] = '-';
80100630:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100635:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010063a:	eb c7                	jmp    80100603 <printint+0x43>
    x = -xx;
8010063c:	f7 d8                	neg    %eax
8010063e:	89 ce                	mov    %ecx,%esi
80100640:	89 c1                	mov    %eax,%ecx
80100642:	eb 94                	jmp    801005d8 <printint+0x18>
}
80100644:	83 c4 2c             	add    $0x2c,%esp
80100647:	5b                   	pop    %ebx
80100648:	5e                   	pop    %esi
80100649:	5f                   	pop    %edi
8010064a:	5d                   	pop    %ebp
8010064b:	c3                   	ret    
8010064c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100650 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 18             	sub    $0x18,%esp
80100659:	8b 7d 10             	mov    0x10(%ebp),%edi
8010065c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010065f:	ff 75 08             	pushl  0x8(%ebp)
80100662:	e8 d9 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100667:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010066e:	e8 7d 3d 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++)
80100673:	83 c4 10             	add    $0x10,%esp
80100676:	85 ff                	test   %edi,%edi
80100678:	7e 36                	jle    801006b0 <consolewrite+0x60>
  if(panicked){
8010067a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100680:	85 c9                	test   %ecx,%ecx
80100682:	75 21                	jne    801006a5 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100684:	0f b6 03             	movzbl (%ebx),%eax
80100687:	8d 73 01             	lea    0x1(%ebx),%esi
8010068a:	01 fb                	add    %edi,%ebx
8010068c:	e8 9f fd ff ff       	call   80100430 <consputc.part.0>
  for(i = 0; i < n; i++)
80100691:	39 de                	cmp    %ebx,%esi
80100693:	74 1b                	je     801006b0 <consolewrite+0x60>
  if(panicked){
80100695:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010069b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010069e:	83 c6 01             	add    $0x1,%esi
801006a1:	85 d2                	test   %edx,%edx
801006a3:	74 e7                	je     8010068c <consolewrite+0x3c>
801006a5:	fa                   	cli    
      ;
801006a6:	eb fe                	jmp    801006a6 <consolewrite+0x56>
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop
  release(&cons.lock);
801006b0:	83 ec 0c             	sub    $0xc,%esp
801006b3:	68 20 a5 10 80       	push   $0x8010a520
801006b8:	e8 53 3e 00 00       	call   80104510 <release>
  ilock(ip);
801006bd:	58                   	pop    %eax
801006be:	ff 75 08             	pushl  0x8(%ebp)
801006c1:	e8 9a 10 00 00       	call   80101760 <ilock>

  return n;
}
801006c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006c9:	89 f8                	mov    %edi,%eax
801006cb:	5b                   	pop    %ebx
801006cc:	5e                   	pop    %esi
801006cd:	5f                   	pop    %edi
801006ce:	5d                   	pop    %ebp
801006cf:	c3                   	ret    

801006d0 <cprintf>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006d9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006e1:	85 c0                	test   %eax,%eax
801006e3:	0f 85 df 00 00 00    	jne    801007c8 <cprintf+0xf8>
  if (fmt == 0)
801006e9:	8b 45 08             	mov    0x8(%ebp),%eax
801006ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ef:	85 c0                	test   %eax,%eax
801006f1:	0f 84 5e 01 00 00    	je     80100855 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f7:	0f b6 00             	movzbl (%eax),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	74 32                	je     80100730 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006fe:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100701:	31 f6                	xor    %esi,%esi
    if(c != '%'){
80100703:	83 f8 25             	cmp    $0x25,%eax
80100706:	74 40                	je     80100748 <cprintf+0x78>
  if(panicked){
80100708:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010070e:	85 c9                	test   %ecx,%ecx
80100710:	74 0b                	je     8010071d <cprintf+0x4d>
80100712:	fa                   	cli    
      ;
80100713:	eb fe                	jmp    80100713 <cprintf+0x43>
80100715:	8d 76 00             	lea    0x0(%esi),%esi
80100718:	b8 25 00 00 00       	mov    $0x25,%eax
8010071d:	e8 0e fd ff ff       	call   80100430 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100725:	83 c6 01             	add    $0x1,%esi
80100728:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010072c:	85 c0                	test   %eax,%eax
8010072e:	75 d3                	jne    80100703 <cprintf+0x33>
  if(locking)
80100730:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100733:	85 db                	test   %ebx,%ebx
80100735:	0f 85 05 01 00 00    	jne    80100840 <cprintf+0x170>
}
8010073b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073e:	5b                   	pop    %ebx
8010073f:	5e                   	pop    %esi
80100740:	5f                   	pop    %edi
80100741:	5d                   	pop    %ebp
80100742:	c3                   	ret    
80100743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100747:	90                   	nop
    c = fmt[++i] & 0xff;
80100748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010074b:	83 c6 01             	add    $0x1,%esi
8010074e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100752:	85 ff                	test   %edi,%edi
80100754:	74 da                	je     80100730 <cprintf+0x60>
    switch(c){
80100756:	83 ff 70             	cmp    $0x70,%edi
80100759:	0f 84 7e 00 00 00    	je     801007dd <cprintf+0x10d>
8010075f:	7f 26                	jg     80100787 <cprintf+0xb7>
80100761:	83 ff 25             	cmp    $0x25,%edi
80100764:	0f 84 be 00 00 00    	je     80100828 <cprintf+0x158>
8010076a:	83 ff 64             	cmp    $0x64,%edi
8010076d:	75 46                	jne    801007b5 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010076f:	8b 03                	mov    (%ebx),%eax
80100771:	8d 7b 04             	lea    0x4(%ebx),%edi
80100774:	b9 01 00 00 00       	mov    $0x1,%ecx
80100779:	ba 0a 00 00 00       	mov    $0xa,%edx
8010077e:	89 fb                	mov    %edi,%ebx
80100780:	e8 3b fe ff ff       	call   801005c0 <printint>
      break;
80100785:	eb 9b                	jmp    80100722 <cprintf+0x52>
80100787:	83 ff 73             	cmp    $0x73,%edi
8010078a:	75 24                	jne    801007b0 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010078c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010078f:	8b 1b                	mov    (%ebx),%ebx
80100791:	85 db                	test   %ebx,%ebx
80100793:	75 68                	jne    801007fd <cprintf+0x12d>
80100795:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010079a:	bb 78 70 10 80       	mov    $0x80107078,%ebx
  if(panicked){
8010079f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801007a5:	85 d2                	test   %edx,%edx
801007a7:	74 4c                	je     801007f5 <cprintf+0x125>
801007a9:	fa                   	cli    
      ;
801007aa:	eb fe                	jmp    801007aa <cprintf+0xda>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007b0:	83 ff 78             	cmp    $0x78,%edi
801007b3:	74 28                	je     801007dd <cprintf+0x10d>
  if(panicked){
801007b5:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801007bb:	85 d2                	test   %edx,%edx
801007bd:	74 4c                	je     8010080b <cprintf+0x13b>
801007bf:	fa                   	cli    
      ;
801007c0:	eb fe                	jmp    801007c0 <cprintf+0xf0>
801007c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007c8:	83 ec 0c             	sub    $0xc,%esp
801007cb:	68 20 a5 10 80       	push   $0x8010a520
801007d0:	e8 1b 3c 00 00       	call   801043f0 <acquire>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	e9 0c ff ff ff       	jmp    801006e9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007dd:	8b 03                	mov    (%ebx),%eax
801007df:	8d 7b 04             	lea    0x4(%ebx),%edi
801007e2:	31 c9                	xor    %ecx,%ecx
801007e4:	ba 10 00 00 00       	mov    $0x10,%edx
801007e9:	89 fb                	mov    %edi,%ebx
801007eb:	e8 d0 fd ff ff       	call   801005c0 <printint>
      break;
801007f0:	e9 2d ff ff ff       	jmp    80100722 <cprintf+0x52>
801007f5:	e8 36 fc ff ff       	call   80100430 <consputc.part.0>
      for(; *s; s++)
801007fa:	83 c3 01             	add    $0x1,%ebx
801007fd:	0f be 03             	movsbl (%ebx),%eax
80100800:	84 c0                	test   %al,%al
80100802:	75 9b                	jne    8010079f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
80100804:	89 fb                	mov    %edi,%ebx
80100806:	e9 17 ff ff ff       	jmp    80100722 <cprintf+0x52>
8010080b:	b8 25 00 00 00       	mov    $0x25,%eax
80100810:	e8 1b fc ff ff       	call   80100430 <consputc.part.0>
  if(panicked){
80100815:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010081a:	85 c0                	test   %eax,%eax
8010081c:	74 4a                	je     80100868 <cprintf+0x198>
8010081e:	fa                   	cli    
      ;
8010081f:	eb fe                	jmp    8010081f <cprintf+0x14f>
80100821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100828:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010082e:	85 c9                	test   %ecx,%ecx
80100830:	0f 84 e2 fe ff ff    	je     80100718 <cprintf+0x48>
80100836:	fa                   	cli    
      ;
80100837:	eb fe                	jmp    80100837 <cprintf+0x167>
80100839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 20 a5 10 80       	push   $0x8010a520
80100848:	e8 c3 3c 00 00       	call   80104510 <release>
8010084d:	83 c4 10             	add    $0x10,%esp
}
80100850:	e9 e6 fe ff ff       	jmp    8010073b <cprintf+0x6b>
    panic("null fmt");
80100855:	83 ec 0c             	sub    $0xc,%esp
80100858:	68 7f 70 10 80       	push   $0x8010707f
8010085d:	e8 4e fb ff ff       	call   801003b0 <panic>
80100862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100868:	89 f8                	mov    %edi,%eax
8010086a:	e8 c1 fb ff ff       	call   80100430 <consputc.part.0>
8010086f:	e9 ae fe ff ff       	jmp    80100722 <cprintf+0x52>
80100874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010087b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010087f:	90                   	nop

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 a5 10 80       	push   $0x8010a520
80100893:	e8 58 3b 00 00       	call   801043f0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	ff d7                	call   *%edi
8010089d:	89 c3                	mov    %eax,%ebx
8010089f:	85 c0                	test   %eax,%eax
801008a1:	0f 88 38 01 00 00    	js     801009df <consoleintr+0x15f>
    switch(c){
801008a7:	83 fb 10             	cmp    $0x10,%ebx
801008aa:	0f 84 f0 00 00 00    	je     801009a0 <consoleintr+0x120>
801008b0:	0f 8e ba 00 00 00    	jle    80100970 <consoleintr+0xf0>
801008b6:	83 fb 15             	cmp    $0x15,%ebx
801008b9:	75 35                	jne    801008f0 <consoleintr+0x70>
      while(input.e != input.w &&
801008bb:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008c6:	74 d3                	je     8010089b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008c8:	83 e8 01             	sub    $0x1,%eax
801008cb:	89 c2                	mov    %eax,%edx
801008cd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008d0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008d7:	74 c2                	je     8010089b <consoleintr+0x1b>
  if(panicked){
801008d9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008df:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008e4:	85 d2                	test   %edx,%edx
801008e6:	0f 84 be 00 00 00    	je     801009aa <consoleintr+0x12a>
801008ec:	fa                   	cli    
      ;
801008ed:	eb fe                	jmp    801008ed <consoleintr+0x6d>
801008ef:	90                   	nop
801008f0:	83 fb 7f             	cmp    $0x7f,%ebx
801008f3:	0f 84 7c 00 00 00    	je     80100975 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008f9:	85 db                	test   %ebx,%ebx
801008fb:	74 9e                	je     8010089b <consoleintr+0x1b>
801008fd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100902:	89 c2                	mov    %eax,%edx
80100904:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
8010090a:	83 fa 7f             	cmp    $0x7f,%edx
8010090d:	77 8c                	ja     8010089b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
8010090f:	8d 48 01             	lea    0x1(%eax),%ecx
80100912:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100918:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
8010091b:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100921:	83 fb 0d             	cmp    $0xd,%ebx
80100924:	0f 84 d1 00 00 00    	je     801009fb <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100930:	85 d2                	test   %edx,%edx
80100932:	0f 85 ce 00 00 00    	jne    80100a06 <consoleintr+0x186>
80100938:	89 d8                	mov    %ebx,%eax
8010093a:	e8 f1 fa ff ff       	call   80100430 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010093f:	83 fb 0a             	cmp    $0xa,%ebx
80100942:	0f 84 d2 00 00 00    	je     80100a1a <consoleintr+0x19a>
80100948:	83 fb 04             	cmp    $0x4,%ebx
8010094b:	0f 84 c9 00 00 00    	je     80100a1a <consoleintr+0x19a>
80100951:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100956:	83 e8 80             	sub    $0xffffff80,%eax
80100959:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010095f:	0f 85 36 ff ff ff    	jne    8010089b <consoleintr+0x1b>
80100965:	e9 b5 00 00 00       	jmp    80100a1f <consoleintr+0x19f>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100970:	83 fb 08             	cmp    $0x8,%ebx
80100973:	75 84                	jne    801008f9 <consoleintr+0x79>
      if(input.e != input.w){
80100975:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010097a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100980:	0f 84 15 ff ff ff    	je     8010089b <consoleintr+0x1b>
        input.e--;
80100986:	83 e8 01             	sub    $0x1,%eax
80100989:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010098e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100993:	85 c0                	test   %eax,%eax
80100995:	74 39                	je     801009d0 <consoleintr+0x150>
80100997:	fa                   	cli    
      ;
80100998:	eb fe                	jmp    80100998 <consoleintr+0x118>
8010099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
801009a0:	be 01 00 00 00       	mov    $0x1,%esi
801009a5:	e9 f1 fe ff ff       	jmp    8010089b <consoleintr+0x1b>
801009aa:	b8 00 01 00 00       	mov    $0x100,%eax
801009af:	e8 7c fa ff ff       	call   80100430 <consputc.part.0>
      while(input.e != input.w &&
801009b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b9:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801009bf:	0f 85 03 ff ff ff    	jne    801008c8 <consoleintr+0x48>
801009c5:	e9 d1 fe ff ff       	jmp    8010089b <consoleintr+0x1b>
801009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009d0:	b8 00 01 00 00       	mov    $0x100,%eax
801009d5:	e8 56 fa ff ff       	call   80100430 <consputc.part.0>
801009da:	e9 bc fe ff ff       	jmp    8010089b <consoleintr+0x1b>
  release(&cons.lock);
801009df:	83 ec 0c             	sub    $0xc,%esp
801009e2:	68 20 a5 10 80       	push   $0x8010a520
801009e7:	e8 24 3b 00 00       	call   80104510 <release>
  if(doprocdump) {
801009ec:	83 c4 10             	add    $0x10,%esp
801009ef:	85 f6                	test   %esi,%esi
801009f1:	75 46                	jne    80100a39 <consoleintr+0x1b9>
}
801009f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009f6:	5b                   	pop    %ebx
801009f7:	5e                   	pop    %esi
801009f8:	5f                   	pop    %edi
801009f9:	5d                   	pop    %ebp
801009fa:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009fb:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
80100a02:	85 d2                	test   %edx,%edx
80100a04:	74 0a                	je     80100a10 <consoleintr+0x190>
80100a06:	fa                   	cli    
      ;
80100a07:	eb fe                	jmp    80100a07 <consoleintr+0x187>
80100a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 16 fa ff ff       	call   80100430 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a1a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a27:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a2c:	e8 0f 36 00 00       	call   80104040 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 62 fe ff ff       	jmp    8010089b <consoleintr+0x1b>
}
80100a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a3c:	5b                   	pop    %ebx
80100a3d:	5e                   	pop    %esi
80100a3e:	5f                   	pop    %edi
80100a3f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a40:	e9 db 36 00 00       	jmp    80104120 <procdump>
80100a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a50 <consoleinit>:

void
consoleinit(void)
{
80100a50:	55                   	push   %ebp
80100a51:	89 e5                	mov    %esp,%ebp
80100a53:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a56:	68 88 70 10 80       	push   $0x80107088
80100a5b:	68 20 a5 10 80       	push   $0x8010a520
80100a60:	e8 8b 38 00 00       	call   801042f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a65:	58                   	pop    %eax
80100a66:	5a                   	pop    %edx
80100a67:	6a 00                	push   $0x0
80100a69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a6b:	c7 05 6c 09 11 80 50 	movl   $0x80100650,0x8011096c
80100a72:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a75:	c7 05 68 09 11 80 a0 	movl   $0x801002a0,0x80110968
80100a7c:	02 10 80 
  cons.locking = 1;
80100a7f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a89:	e8 52 19 00 00       	call   801023e0 <ioapicenable>
}
80100a8e:	83 c4 10             	add    $0x10,%esp
80100a91:	c9                   	leave  
80100a92:	c3                   	ret    
80100a93:	66 90                	xchg   %ax,%ax
80100a95:	66 90                	xchg   %ax,%ax
80100a97:	66 90                	xchg   %ax,%ax
80100a99:	66 90                	xchg   %ax,%ax
80100a9b:	66 90                	xchg   %ax,%ax
80100a9d:	66 90                	xchg   %ax,%ax
80100a9f:	90                   	nop

80100aa0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	57                   	push   %edi
80100aa4:	56                   	push   %esi
80100aa5:	53                   	push   %ebx
80100aa6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aac:	e8 5f 2e 00 00       	call   80103910 <myproc>
80100ab1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ab7:	e8 14 22 00 00       	call   80102cd0 <begin_op>

  if((ip = namei(path)) == 0){
80100abc:	83 ec 0c             	sub    $0xc,%esp
80100abf:	ff 75 08             	pushl  0x8(%ebp)
80100ac2:	e8 39 15 00 00       	call   80102000 <namei>
80100ac7:	83 c4 10             	add    $0x10,%esp
80100aca:	85 c0                	test   %eax,%eax
80100acc:	0f 84 02 03 00 00    	je     80100dd4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ad2:	83 ec 0c             	sub    $0xc,%esp
80100ad5:	89 c3                	mov    %eax,%ebx
80100ad7:	50                   	push   %eax
80100ad8:	e8 83 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100add:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ae3:	6a 34                	push   $0x34
80100ae5:	6a 00                	push   $0x0
80100ae7:	50                   	push   %eax
80100ae8:	53                   	push   %ebx
80100ae9:	e8 52 0f 00 00       	call   80101a40 <readi>
80100aee:	83 c4 20             	add    $0x20,%esp
80100af1:	83 f8 34             	cmp    $0x34,%eax
80100af4:	74 22                	je     80100b18 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	53                   	push   %ebx
80100afa:	e8 f1 0e 00 00       	call   801019f0 <iunlockput>
    end_op();
80100aff:	e8 3c 22 00 00       	call   80102d40 <end_op>
80100b04:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b0f:	5b                   	pop    %ebx
80100b10:	5e                   	pop    %esi
80100b11:	5f                   	pop    %edi
80100b12:	5d                   	pop    %ebp
80100b13:	c3                   	ret    
80100b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b18:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b1f:	45 4c 46 
80100b22:	75 d2                	jne    80100af6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b24:	e8 27 62 00 00       	call   80106d50 <setupkvm>
80100b29:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b2f:	85 c0                	test   %eax,%eax
80100b31:	74 c3                	je     80100af6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b33:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b3a:	00 
80100b3b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b41:	0f 84 ac 02 00 00    	je     80100df3 <exec+0x353>
  sz = 0;
80100b47:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b4e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b51:	31 ff                	xor    %edi,%edi
80100b53:	e9 8e 00 00 00       	jmp    80100be6 <exec+0x146>
80100b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b5f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b67:	75 6c                	jne    80100bd5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b75:	0f 82 87 00 00 00    	jb     80100c02 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b81:	72 7f                	jb     80100c02 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b83:	83 ec 04             	sub    $0x4,%esp
80100b86:	50                   	push   %eax
80100b87:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b93:	e8 f8 5f 00 00       	call   80106b90 <allocuvm>
80100b98:	83 c4 10             	add    $0x10,%esp
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	74 5d                	je     80100c02 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100ba5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bab:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bb0:	75 50                	jne    80100c02 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100bbb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bc1:	53                   	push   %ebx
80100bc2:	50                   	push   %eax
80100bc3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bc9:	e8 02 5f 00 00       	call   80106ad0 <loaduvm>
80100bce:	83 c4 20             	add    $0x20,%esp
80100bd1:	85 c0                	test   %eax,%eax
80100bd3:	78 2d                	js     80100c02 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bdc:	83 c7 01             	add    $0x1,%edi
80100bdf:	83 c6 20             	add    $0x20,%esi
80100be2:	39 f8                	cmp    %edi,%eax
80100be4:	7e 3a                	jle    80100c20 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bec:	6a 20                	push   $0x20
80100bee:	56                   	push   %esi
80100bef:	50                   	push   %eax
80100bf0:	53                   	push   %ebx
80100bf1:	e8 4a 0e 00 00       	call   80101a40 <readi>
80100bf6:	83 c4 10             	add    $0x10,%esp
80100bf9:	83 f8 20             	cmp    $0x20,%eax
80100bfc:	0f 84 5e ff ff ff    	je     80100b60 <exec+0xc0>
    freevm(pgdir);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c0b:	e8 c0 60 00 00       	call   80106cd0 <freevm>
  if(ip){
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	e9 de fe ff ff       	jmp    80100af6 <exec+0x56>
80100c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c1f:	90                   	nop
80100c20:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c26:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c2c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c32:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c38:	83 ec 0c             	sub    $0xc,%esp
80100c3b:	53                   	push   %ebx
80100c3c:	e8 af 0d 00 00       	call   801019f0 <iunlockput>
  end_op();
80100c41:	e8 fa 20 00 00       	call   80102d40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c46:	83 c4 0c             	add    $0xc,%esp
80100c49:	56                   	push   %esi
80100c4a:	57                   	push   %edi
80100c4b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c51:	57                   	push   %edi
80100c52:	e8 39 5f 00 00       	call   80106b90 <allocuvm>
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	89 c6                	mov    %eax,%esi
80100c5c:	85 c0                	test   %eax,%eax
80100c5e:	0f 84 94 00 00 00    	je     80100cf8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c64:	83 ec 08             	sub    $0x8,%esp
80100c67:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6f:	50                   	push   %eax
80100c70:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c71:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c73:	e8 a8 61 00 00       	call   80106e20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c7b:	83 c4 10             	add    $0x10,%esp
80100c7e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c84:	8b 00                	mov    (%eax),%eax
80100c86:	85 c0                	test   %eax,%eax
80100c88:	0f 84 8b 00 00 00    	je     80100d19 <exec+0x279>
80100c8e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c94:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c9a:	eb 23                	jmp    80100cbf <exec+0x21f>
80100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ca3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100caa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cad:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cb3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cb6:	85 c0                	test   %eax,%eax
80100cb8:	74 59                	je     80100d13 <exec+0x273>
    if(argc >= MAXARG)
80100cba:	83 ff 20             	cmp    $0x20,%edi
80100cbd:	74 39                	je     80100cf8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbf:	83 ec 0c             	sub    $0xc,%esp
80100cc2:	50                   	push   %eax
80100cc3:	e8 a8 3a 00 00       	call   80104770 <strlen>
80100cc8:	f7 d0                	not    %eax
80100cca:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ccc:	58                   	pop    %eax
80100ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd6:	e8 95 3a 00 00       	call   80104770 <strlen>
80100cdb:	83 c0 01             	add    $0x1,%eax
80100cde:	50                   	push   %eax
80100cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ce2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ce5:	53                   	push   %ebx
80100ce6:	56                   	push   %esi
80100ce7:	e8 a4 62 00 00       	call   80106f90 <copyout>
80100cec:	83 c4 20             	add    $0x20,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	79 ad                	jns    80100ca0 <exec+0x200>
80100cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cf7:	90                   	nop
    freevm(pgdir);
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d01:	e8 ca 5f 00 00       	call   80106cd0 <freevm>
80100d06:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d0e:	e9 f9 fd ff ff       	jmp    80100b0c <exec+0x6c>
80100d13:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d19:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d20:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d22:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d29:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d2f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d38:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d3a:	50                   	push   %eax
80100d3b:	52                   	push   %edx
80100d3c:	53                   	push   %ebx
80100d3d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d43:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d4a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d53:	e8 38 62 00 00       	call   80106f90 <copyout>
80100d58:	83 c4 10             	add    $0x10,%esp
80100d5b:	85 c0                	test   %eax,%eax
80100d5d:	78 99                	js     80100cf8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d62:	8b 55 08             	mov    0x8(%ebp),%edx
80100d65:	0f b6 00             	movzbl (%eax),%eax
80100d68:	84 c0                	test   %al,%al
80100d6a:	74 13                	je     80100d7f <exec+0x2df>
80100d6c:	89 d1                	mov    %edx,%ecx
80100d6e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d70:	83 c1 01             	add    $0x1,%ecx
80100d73:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d75:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d78:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d7b:	84 c0                	test   %al,%al
80100d7d:	75 f1                	jne    80100d70 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d7f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d85:	83 ec 04             	sub    $0x4,%esp
80100d88:	6a 10                	push   $0x10
80100d8a:	89 f8                	mov    %edi,%eax
80100d8c:	52                   	push   %edx
80100d8d:	83 c0 6c             	add    $0x6c,%eax
80100d90:	50                   	push   %eax
80100d91:	e8 9a 39 00 00       	call   80104730 <safestrcpy>
  curproc->pgdir = pgdir;
80100d96:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d9c:	89 f8                	mov    %edi,%eax
80100d9e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100da1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100da3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100da6:	89 c1                	mov    %eax,%ecx
80100da8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dae:	8b 40 18             	mov    0x18(%eax),%eax
80100db1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100db4:	8b 41 18             	mov    0x18(%ecx),%eax
80100db7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dba:	89 0c 24             	mov    %ecx,(%esp)
80100dbd:	e8 7e 5b 00 00       	call   80106940 <switchuvm>
  freevm(oldpgdir);
80100dc2:	89 3c 24             	mov    %edi,(%esp)
80100dc5:	e8 06 5f 00 00       	call   80106cd0 <freevm>
  return 0;
80100dca:	83 c4 10             	add    $0x10,%esp
80100dcd:	31 c0                	xor    %eax,%eax
80100dcf:	e9 38 fd ff ff       	jmp    80100b0c <exec+0x6c>
    end_op();
80100dd4:	e8 67 1f 00 00       	call   80102d40 <end_op>
    cprintf("exec: fail\n");
80100dd9:	83 ec 0c             	sub    $0xc,%esp
80100ddc:	68 a1 70 10 80       	push   $0x801070a1
80100de1:	e8 ea f8 ff ff       	call   801006d0 <cprintf>
    return -1;
80100de6:	83 c4 10             	add    $0x10,%esp
80100de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dee:	e9 19 fd ff ff       	jmp    80100b0c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df3:	31 ff                	xor    %edi,%edi
80100df5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dfa:	e9 39 fe ff ff       	jmp    80100c38 <exec+0x198>
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e06:	68 ad 70 10 80       	push   $0x801070ad
80100e0b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e10:	e8 db 34 00 00       	call   801042f0 <initlock>
}
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	c9                   	leave  
80100e19:	c3                   	ret    
80100e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e24:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e31:	e8 ba 35 00 00       	call   801043f0 <acquire>
80100e36:	83 c4 10             	add    $0x10,%esp
80100e39:	eb 10                	jmp    80100e4b <filealloc+0x2b>
80100e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e3f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e49:	74 25                	je     80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e61:	e8 aa 36 00 00       	call   80104510 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e66:	89 d8                	mov    %ebx,%eax
      return f;
80100e68:	83 c4 10             	add    $0x10,%esp
}
80100e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e6e:	c9                   	leave  
80100e6f:	c3                   	ret    
  release(&ftable.lock);
80100e70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e75:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7a:	e8 91 36 00 00       	call   80104510 <release>
}
80100e7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e81:	83 c4 10             	add    $0x10,%esp
}
80100e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e87:	c9                   	leave  
80100e88:	c3                   	ret    
80100e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
80100e94:	83 ec 10             	sub    $0x10,%esp
80100e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e9a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9f:	e8 4c 35 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100ea4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ea7:	83 c4 10             	add    $0x10,%esp
80100eaa:	85 c0                	test   %eax,%eax
80100eac:	7e 1a                	jle    80100ec8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100eae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100eb1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100eb4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eb7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ebc:	e8 4f 36 00 00       	call   80104510 <release>
  return f;
}
80100ec1:	89 d8                	mov    %ebx,%eax
80100ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec6:	c9                   	leave  
80100ec7:	c3                   	ret    
    panic("filedup");
80100ec8:	83 ec 0c             	sub    $0xc,%esp
80100ecb:	68 b4 70 10 80       	push   $0x801070b4
80100ed0:	e8 db f4 ff ff       	call   801003b0 <panic>
80100ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	57                   	push   %edi
80100ee4:	56                   	push   %esi
80100ee5:	53                   	push   %ebx
80100ee6:	83 ec 28             	sub    $0x28,%esp
80100ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eec:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ef1:	e8 fa 34 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100ef6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ef9:	83 c4 10             	add    $0x10,%esp
80100efc:	85 c0                	test   %eax,%eax
80100efe:	0f 8e a3 00 00 00    	jle    80100fa7 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100f04:	83 e8 01             	sub    $0x1,%eax
80100f07:	89 43 04             	mov    %eax,0x4(%ebx)
80100f0a:	75 44                	jne    80100f50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f0c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f13:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f1e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f24:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f29:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f2c:	e8 df 35 00 00       	call   80104510 <release>

  if(ff.type == FD_PIPE)
80100f31:	83 c4 10             	add    $0x10,%esp
80100f34:	83 ff 01             	cmp    $0x1,%edi
80100f37:	74 2f                	je     80100f68 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f39:	83 ff 02             	cmp    $0x2,%edi
80100f3c:	74 4a                	je     80100f88 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f41:	5b                   	pop    %ebx
80100f42:	5e                   	pop    %esi
80100f43:	5f                   	pop    %edi
80100f44:	5d                   	pop    %ebp
80100f45:	c3                   	ret    
80100f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f4d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f50:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5a:	5b                   	pop    %ebx
80100f5b:	5e                   	pop    %esi
80100f5c:	5f                   	pop    %edi
80100f5d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f5e:	e9 ad 35 00 00       	jmp    80104510 <release>
80100f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f67:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f68:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f6c:	83 ec 08             	sub    $0x8,%esp
80100f6f:	53                   	push   %ebx
80100f70:	56                   	push   %esi
80100f71:	e8 0a 25 00 00       	call   80103480 <pipeclose>
80100f76:	83 c4 10             	add    $0x10,%esp
}
80100f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7c:	5b                   	pop    %ebx
80100f7d:	5e                   	pop    %esi
80100f7e:	5f                   	pop    %edi
80100f7f:	5d                   	pop    %ebp
80100f80:	c3                   	ret    
80100f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f88:	e8 43 1d 00 00       	call   80102cd0 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	pushl  -0x20(%ebp)
80100f93:	e8 f8 08 00 00       	call   80101890 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 99 1d 00 00       	jmp    80102d40 <end_op>
    panic("fileclose");
80100fa7:	83 ec 0c             	sub    $0xc,%esp
80100faa:	68 bc 70 10 80       	push   $0x801070bc
80100faf:	e8 fc f3 ff ff       	call   801003b0 <panic>
80100fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fbf:	90                   	nop

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 04             	sub    $0x4,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fcd:	75 31                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	ff 73 10             	pushl  0x10(%ebx)
80100fd5:	e8 86 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fda:	58                   	pop    %eax
80100fdb:	5a                   	pop    %edx
80100fdc:	ff 75 0c             	pushl  0xc(%ebp)
80100fdf:	ff 73 10             	pushl  0x10(%ebx)
80100fe2:	e8 29 0a 00 00       	call   80101a10 <stati>
    iunlock(f->ip);
80100fe7:	59                   	pop    %ecx
80100fe8:	ff 73 10             	pushl  0x10(%ebx)
80100feb:	e8 50 08 00 00       	call   80101840 <iunlock>
    return 0;
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010101c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010101f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101022:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101026:	74 60                	je     80101088 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101028:	8b 03                	mov    (%ebx),%eax
8010102a:	83 f8 01             	cmp    $0x1,%eax
8010102d:	74 41                	je     80101070 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102f:	83 f8 02             	cmp    $0x2,%eax
80101032:	75 5b                	jne    8010108f <fileread+0x7f>
    ilock(f->ip);
80101034:	83 ec 0c             	sub    $0xc,%esp
80101037:	ff 73 10             	pushl  0x10(%ebx)
8010103a:	e8 21 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010103f:	57                   	push   %edi
80101040:	ff 73 14             	pushl  0x14(%ebx)
80101043:	56                   	push   %esi
80101044:	ff 73 10             	pushl  0x10(%ebx)
80101047:	e8 f4 09 00 00       	call   80101a40 <readi>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	89 c6                	mov    %eax,%esi
80101051:	85 c0                	test   %eax,%eax
80101053:	7e 03                	jle    80101058 <fileread+0x48>
      f->off += r;
80101055:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 dd 07 00 00       	call   80101840 <iunlock>
    return r;
80101063:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	89 f0                	mov    %esi,%eax
8010106b:	5b                   	pop    %ebx
8010106c:	5e                   	pop    %esi
8010106d:	5f                   	pop    %edi
8010106e:	5d                   	pop    %ebp
8010106f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101070:	8b 43 0c             	mov    0xc(%ebx),%eax
80101073:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	5b                   	pop    %ebx
8010107a:	5e                   	pop    %esi
8010107b:	5f                   	pop    %edi
8010107c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010107d:	e9 ae 25 00 00       	jmp    80103630 <piperead>
80101082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010108d:	eb d7                	jmp    80101066 <fileread+0x56>
  panic("fileread");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 c6 70 10 80       	push   $0x801070c6
80101097:	e8 14 f3 ff ff       	call   801003b0 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 1c             	sub    $0x1c,%esp
801010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010ac:	8b 75 08             	mov    0x8(%ebp),%esi
801010af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010bc:	0f 84 bb 00 00 00    	je     8010117d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010c2:	8b 06                	mov    (%esi),%eax
801010c4:	83 f8 01             	cmp    $0x1,%eax
801010c7:	0f 84 bf 00 00 00    	je     8010118c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cd:	83 f8 02             	cmp    $0x2,%eax
801010d0:	0f 85 c8 00 00 00    	jne    8010119e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 30                	jg     8010110f <filewrite+0x6f>
801010df:	e9 94 00 00 00       	jmp    80101178 <filewrite+0xd8>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010f4:	e8 47 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f9:	e8 42 1c 00 00       	call   80102d40 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101101:	83 c4 10             	add    $0x10,%esp
80101104:	39 c3                	cmp    %eax,%ebx
80101106:	75 60                	jne    80101168 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101108:	01 df                	add    %ebx,%edi
    while(i < n){
8010110a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010110d:	7e 69                	jle    80101178 <filewrite+0xd8>
      int n1 = n - i;
8010110f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101112:	b8 00 06 00 00       	mov    $0x600,%eax
80101117:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101119:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010111f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101122:	e8 a9 1b 00 00       	call   80102cd0 <begin_op>
      ilock(f->ip);
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	ff 76 10             	pushl  0x10(%esi)
8010112d:	e8 2e 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101132:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101135:	53                   	push   %ebx
80101136:	ff 76 14             	pushl  0x14(%esi)
80101139:	01 f8                	add    %edi,%eax
8010113b:	50                   	push   %eax
8010113c:	ff 76 10             	pushl  0x10(%esi)
8010113f:	e8 fc 09 00 00       	call   80101b40 <writei>
80101144:	83 c4 20             	add    $0x20,%esp
80101147:	85 c0                	test   %eax,%eax
80101149:	7f 9d                	jg     801010e8 <filewrite+0x48>
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 76 10             	pushl  0x10(%esi)
80101151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101154:	e8 e7 06 00 00       	call   80101840 <iunlock>
      end_op();
80101159:	e8 e2 1b 00 00       	call   80102d40 <end_op>
      if(r < 0)
8010115e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	85 c0                	test   %eax,%eax
80101166:	75 15                	jne    8010117d <filewrite+0xdd>
        panic("short filewrite");
80101168:	83 ec 0c             	sub    $0xc,%esp
8010116b:	68 cf 70 10 80       	push   $0x801070cf
80101170:	e8 3b f2 ff ff       	call   801003b0 <panic>
80101175:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101178:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010117b:	74 05                	je     80101182 <filewrite+0xe2>
    return -1;
8010117d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101182:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101185:	89 f8                	mov    %edi,%eax
80101187:	5b                   	pop    %ebx
80101188:	5e                   	pop    %esi
80101189:	5f                   	pop    %edi
8010118a:	5d                   	pop    %ebp
8010118b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010118c:	8b 46 0c             	mov    0xc(%esi),%eax
8010118f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101192:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101195:	5b                   	pop    %ebx
80101196:	5e                   	pop    %esi
80101197:	5f                   	pop    %edi
80101198:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101199:	e9 82 23 00 00       	jmp    80103520 <pipewrite>
  panic("filewrite");
8010119e:	83 ec 0c             	sub    $0xc,%esp
801011a1:	68 d5 70 10 80       	push   $0x801070d5
801011a6:	e8 05 f2 ff ff       	call   801003b0 <panic>
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 05 ef ff ff       	call   801000f0 <bread>
801011eb:	83 c4 10             	add    $0x10,%esp
801011ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
80101202:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	89 fa                	mov    %edi,%edx
8010121b:	85 df                	test   %ebx,%edi
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 d4 ef ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 df 70 10 80       	push   $0x801070df
80101259:	e8 52 f1 ff ff       	call   801003b0 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 3e 1c 00 00       	call   80102eb0 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 96 ef ff ff       	call   80100210 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 6b ee ff ff       	call   801000f0 <bread>
  memset(bp->data, 0, BSIZE);
80101285:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101288:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010128a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 c6 32 00 00       	call   80104560 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 0e 1c 00 00       	call   80102eb0 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 66 ef ff ff       	call   80100210 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
801012da:	e8 11 31 00 00       	call   801043f0 <acquire>
801012df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e5:	eb 1b                	jmp    80101302 <iget+0x42>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f0:	39 3b                	cmp    %edi,(%ebx)
801012f2:	74 6c                	je     80101360 <iget+0xa0>
801012f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101300:	73 26                	jae    80101328 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101302:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101305:	85 c9                	test   %ecx,%ecx
80101307:	7f e7                	jg     801012f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e7                	jne    801012f4 <iget+0x34>
8010130d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101313:	85 c9                	test   %ecx,%ecx
80101315:	75 70                	jne    80101387 <iget+0xc7>
80101317:	89 de                	mov    %ebx,%esi
80101319:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101321:	72 df                	jb     80101302 <iget+0x42>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101328:	85 f6                	test   %esi,%esi
8010132a:	74 74                	je     801013a0 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010132c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010132f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101331:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101334:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010133b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101342:	68 e0 09 11 80       	push   $0x801109e0
80101347:	e8 c4 31 00 00       	call   80104510 <release>

  return ip;
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101352:	89 f0                	mov    %esi,%eax
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101360:	39 53 04             	cmp    %edx,0x4(%ebx)
80101363:	75 8f                	jne    801012f4 <iget+0x34>
      release(&icache.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101368:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010136b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010136d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101370:	68 e0 09 11 80       	push   $0x801109e0
80101375:	e8 96 31 00 00       	call   80104510 <release>
      return ip;
8010137a:	83 c4 10             	add    $0x10,%esp
}
8010137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101380:	89 f0                	mov    %esi,%eax
80101382:	5b                   	pop    %ebx
80101383:	5e                   	pop    %esi
80101384:	5f                   	pop    %edi
80101385:	5d                   	pop    %ebp
80101386:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101387:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010138c:	73 12                	jae    801013a0 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138e:	8b 48 08             	mov    0x8(%eax),%ecx
80101391:	89 c3                	mov    %eax,%ebx
80101393:	85 c9                	test   %ecx,%ecx
80101395:	0f 8f 55 ff ff ff    	jg     801012f0 <iget+0x30>
8010139b:	e9 6d ff ff ff       	jmp    8010130d <iget+0x4d>
    panic("iget: no inodes");
801013a0:	83 ec 0c             	sub    $0xc,%esp
801013a3:	68 f5 70 10 80       	push   $0x801070f5
801013a8:	e8 03 f0 ff ff       	call   801003b0 <panic>
801013ad:	8d 76 00             	lea    0x0(%esi),%esi

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	89 c6                	mov    %eax,%esi
801013b7:	53                   	push   %ebx
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	0f 86 84 00 00 00    	jbe    80101448 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013c7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ca:	0f 87 98 00 00 00    	ja     80101468 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013d6:	8b 00                	mov    (%eax),%eax
801013d8:	85 d2                	test   %edx,%edx
801013da:	74 54                	je     80101430 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013dc:	83 ec 08             	sub    $0x8,%esp
801013df:	52                   	push   %edx
801013e0:	50                   	push   %eax
801013e1:	e8 0a ed ff ff       	call   801000f0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ed:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ef:	8b 1a                	mov    (%edx),%ebx
801013f1:	85 db                	test   %ebx,%ebx
801013f3:	74 1b                	je     80101410 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	57                   	push   %edi
801013f9:	e8 12 ee ff ff       	call   80100210 <brelse>
    return addr;
801013fe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101404:	89 d8                	mov    %ebx,%eax
80101406:	5b                   	pop    %ebx
80101407:	5e                   	pop    %esi
80101408:	5f                   	pop    %edi
80101409:	5d                   	pop    %ebp
8010140a:	c3                   	ret    
8010140b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010140f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101410:	8b 06                	mov    (%esi),%eax
80101412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101415:	e8 96 fd ff ff       	call   801011b0 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101420:	89 c3                	mov    %eax,%ebx
80101422:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101424:	57                   	push   %edi
80101425:	e8 86 1a 00 00       	call   80102eb0 <log_write>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	eb c6                	jmp    801013f5 <bmap+0x45>
8010142f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	e8 7b fd ff ff       	call   801011b0 <balloc>
80101435:	89 c2                	mov    %eax,%edx
80101437:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143d:	8b 06                	mov    (%esi),%eax
8010143f:	eb 9b                	jmp    801013dc <bmap+0x2c>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101448:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010144b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010144e:	85 db                	test   %ebx,%ebx
80101450:	75 af                	jne    80101401 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101452:	8b 00                	mov    (%eax),%eax
80101454:	e8 57 fd ff ff       	call   801011b0 <balloc>
80101459:	89 47 5c             	mov    %eax,0x5c(%edi)
8010145c:	89 c3                	mov    %eax,%ebx
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	89 d8                	mov    %ebx,%eax
80101463:	5b                   	pop    %ebx
80101464:	5e                   	pop    %esi
80101465:	5f                   	pop    %edi
80101466:	5d                   	pop    %ebp
80101467:	c3                   	ret    
  panic("bmap: out of range");
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	68 05 71 10 80       	push   $0x80107105
80101470:	e8 3b ef ff ff       	call   801003b0 <panic>
80101475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 5b ec ff ff       	call   801000f0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101495:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101498:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010149a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 5a 31 00 00       	call   80104600 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 59 ed ff ff       	jmp    80100210 <brelse>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	89 c6                	mov    %eax,%esi
801014c6:	53                   	push   %ebx
801014c7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c0 09 11 80       	push   $0x801109c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	5a                   	pop    %edx
801014d9:	89 da                	mov    %ebx,%edx
801014db:	c1 ea 0c             	shr    $0xc,%edx
801014de:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014e4:	52                   	push   %edx
801014e5:	56                   	push   %esi
801014e6:	e8 05 ec ff ff       	call   801000f0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
8010150e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101510:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101519:	56                   	push   %esi
8010151a:	e8 91 19 00 00       	call   80102eb0 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 e9 ec ff ff       	call   80100210 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 18 71 10 80       	push   $0x80107118
80101539:	e8 72 ee ff ff       	call   801003b0 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <balloc_page>:
}
80101540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101545:	c3                   	ret    
80101546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154d:	8d 76 00             	lea    0x0(%esi),%esi

80101550 <bfree_page>:
}
80101550:	c3                   	ret    
80101551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 71 10 80       	push   $0x8010712b
80101571:	68 e0 09 11 80       	push   $0x801109e0
80101576:	e8 75 2d 00 00       	call   801042f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 71 10 80       	push   $0x80107132
80101588:	53                   	push   %ebx
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010158f:	e8 4c 2c 00 00       	call   801041e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  readsb(dev, &sb);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	68 c0 09 11 80       	push   $0x801109c0
801015a7:	ff 75 08             	pushl  0x8(%ebp)
801015aa:	e8 d1 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015af:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015b5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015bb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015c1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015c7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015cd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015d3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015d9:	68 98 71 10 80       	push   $0x80107198
801015de:	e8 ed f0 ff ff       	call   801006d0 <cprintf>
}
801015e3:	83 c4 30             	add    $0x30,%esp
801015e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015e9:	c9                   	leave  
801015ea:	c3                   	ret    
801015eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop

801015f0 <ialloc>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 1c             	sub    $0x1c,%esp
801015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015fc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101603:	8b 75 08             	mov    0x8(%ebp),%esi
80101606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101609:	0f 86 91 00 00 00    	jbe    801016a0 <ialloc+0xb0>
8010160f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101614:	eb 21                	jmp    80101637 <ialloc+0x47>
80101616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101626:	57                   	push   %edi
80101627:	e8 e4 eb ff ff       	call   80100210 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 d8                	mov    %ebx,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 a4 ea ff ff       	call   801000f0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 d8                	mov    %ebx,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 ed 2e 00 00       	call   80104560 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 3c 24             	mov    %edi,(%esp)
80101680:	e8 2b 18 00 00       	call   80102eb0 <log_write>
      brelse(bp);
80101685:	89 3c 24             	mov    %edi,(%esp)
80101688:	e8 83 eb ff ff       	call   80100210 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 da                	mov    %ebx,%edx
80101695:	89 f0                	mov    %esi,%eax
}
80101697:	5b                   	pop    %ebx
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 20 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 38 71 10 80       	push   $0x80107138
801016a8:	e8 03 ed ff ff       	call   801003b0 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016be:	83 ec 08             	sub    $0x8,%esp
801016c1:	c1 e8 03             	shr    $0x3,%eax
801016c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ca:	50                   	push   %eax
801016cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ce:	e8 1d ea ff ff       	call   801000f0 <bread>
  dip->type = ip->type;
801016d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101703:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101707:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170d:	6a 34                	push   $0x34
8010170f:	53                   	push   %ebx
80101710:	50                   	push   %eax
80101711:	e8 ea 2e 00 00       	call   80104600 <memmove>
  log_write(bp);
80101716:	89 34 24             	mov    %esi,(%esp)
80101719:	e8 92 17 00 00       	call   80102eb0 <log_write>
  brelse(bp);
8010171e:	89 75 08             	mov    %esi,0x8(%ebp)
80101721:	83 c4 10             	add    $0x10,%esp
}
80101724:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101727:	5b                   	pop    %ebx
80101728:	5e                   	pop    %esi
80101729:	5d                   	pop    %ebp
  brelse(bp);
8010172a:	e9 e1 ea ff ff       	jmp    80100210 <brelse>
8010172f:	90                   	nop

80101730 <idup>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	53                   	push   %ebx
80101734:	83 ec 10             	sub    $0x10,%esp
80101737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173a:	68 e0 09 11 80       	push   $0x801109e0
8010173f:	e8 ac 2c 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101744:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101748:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010174f:	e8 bc 2d 00 00       	call   80104510 <release>
}
80101754:	89 d8                	mov    %ebx,%eax
80101756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101759:	c9                   	leave  
8010175a:	c3                   	ret    
8010175b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	0f 84 b7 00 00 00    	je     80101827 <ilock+0xc7>
80101770:	8b 53 08             	mov    0x8(%ebx),%edx
80101773:	85 d2                	test   %edx,%edx
80101775:	0f 8e ac 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177b:	83 ec 0c             	sub    $0xc,%esp
8010177e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101781:	50                   	push   %eax
80101782:	e8 99 2a 00 00       	call   80104220 <acquiresleep>
  if(ip->valid == 0){
80101787:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178a:	83 c4 10             	add    $0x10,%esp
8010178d:	85 c0                	test   %eax,%eax
8010178f:	74 0f                	je     801017a0 <ilock+0x40>
}
80101791:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101794:	5b                   	pop    %ebx
80101795:	5e                   	pop    %esi
80101796:	5d                   	pop    %ebp
80101797:	c3                   	ret    
80101798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 39 e9 ff ff       	call   801000f0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 03 2e 00 00       	call   80104600 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 0b ea ff ff       	call   80100210 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 77 ff ff ff    	jne    80101791 <ilock+0x31>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 50 71 10 80       	push   $0x80107150
80101822:	e8 89 eb ff ff       	call   801003b0 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 4a 71 10 80       	push   $0x8010714a
8010182f:	e8 7c eb ff ff       	call   801003b0 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	56                   	push   %esi
80101844:	53                   	push   %ebx
80101845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101848:	85 db                	test   %ebx,%ebx
8010184a:	74 28                	je     80101874 <iunlock+0x34>
8010184c:	83 ec 0c             	sub    $0xc,%esp
8010184f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101852:	56                   	push   %esi
80101853:	e8 68 2a 00 00       	call   801042c0 <holdingsleep>
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 c0                	test   %eax,%eax
8010185d:	74 15                	je     80101874 <iunlock+0x34>
8010185f:	8b 43 08             	mov    0x8(%ebx),%eax
80101862:	85 c0                	test   %eax,%eax
80101864:	7e 0e                	jle    80101874 <iunlock+0x34>
  releasesleep(&ip->lock);
80101866:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101869:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010186c:	5b                   	pop    %ebx
8010186d:	5e                   	pop    %esi
8010186e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010186f:	e9 0c 2a 00 00       	jmp    80104280 <releasesleep>
    panic("iunlock");
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 5f 71 10 80       	push   $0x8010715f
8010187c:	e8 2f eb ff ff       	call   801003b0 <panic>
80101881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <iput>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 28             	sub    $0x28,%esp
80101899:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010189c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010189f:	57                   	push   %edi
801018a0:	e8 7b 29 00 00       	call   80104220 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018a8:	83 c4 10             	add    $0x10,%esp
801018ab:	85 d2                	test   %edx,%edx
801018ad:	74 07                	je     801018b6 <iput+0x26>
801018af:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b4:	74 32                	je     801018e8 <iput+0x58>
  releasesleep(&ip->lock);
801018b6:	83 ec 0c             	sub    $0xc,%esp
801018b9:	57                   	push   %edi
801018ba:	e8 c1 29 00 00       	call   80104280 <releasesleep>
  acquire(&icache.lock);
801018bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018c6:	e8 25 2b 00 00       	call   801043f0 <acquire>
  ip->ref--;
801018cb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018cf:	83 c4 10             	add    $0x10,%esp
801018d2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5f                   	pop    %edi
801018df:	5d                   	pop    %ebp
  release(&icache.lock);
801018e0:	e9 2b 2c 00 00       	jmp    80104510 <release>
801018e5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018e8:	83 ec 0c             	sub    $0xc,%esp
801018eb:	68 e0 09 11 80       	push   $0x801109e0
801018f0:	e8 fb 2a 00 00       	call   801043f0 <acquire>
    int r = ip->ref;
801018f5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ff:	e8 0c 2c 00 00       	call   80104510 <release>
    if(r == 1){
80101904:	83 c4 10             	add    $0x10,%esp
80101907:	83 fe 01             	cmp    $0x1,%esi
8010190a:	75 aa                	jne    801018b6 <iput+0x26>
8010190c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101912:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101915:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101918:	89 cf                	mov    %ecx,%edi
8010191a:	eb 0b                	jmp    80101927 <iput+0x97>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101920:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101923:	39 fe                	cmp    %edi,%esi
80101925:	74 19                	je     80101940 <iput+0xb0>
    if(ip->addrs[i]){
80101927:	8b 16                	mov    (%esi),%edx
80101929:	85 d2                	test   %edx,%edx
8010192b:	74 f3                	je     80101920 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010192d:	8b 03                	mov    (%ebx),%eax
8010192f:	e8 8c fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101934:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010193a:	eb e4                	jmp    80101920 <iput+0x90>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101940:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101946:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101949:	85 c0                	test   %eax,%eax
8010194b:	75 33                	jne    80101980 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010194d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101950:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101957:	53                   	push   %ebx
80101958:	e8 53 fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
8010195d:	31 c0                	xor    %eax,%eax
8010195f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101963:	89 1c 24             	mov    %ebx,(%esp)
80101966:	e8 45 fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
8010196b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101972:	83 c4 10             	add    $0x10,%esp
80101975:	e9 3c ff ff ff       	jmp    801018b6 <iput+0x26>
8010197a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101980:	83 ec 08             	sub    $0x8,%esp
80101983:	50                   	push   %eax
80101984:	ff 33                	pushl  (%ebx)
80101986:	e8 65 e7 ff ff       	call   801000f0 <bread>
8010198b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010198e:	83 c4 10             	add    $0x10,%esp
80101991:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010199a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010199d:	89 cf                	mov    %ecx,%edi
8010199f:	eb 0e                	jmp    801019af <iput+0x11f>
801019a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019a8:	83 c6 04             	add    $0x4,%esi
801019ab:	39 f7                	cmp    %esi,%edi
801019ad:	74 11                	je     801019c0 <iput+0x130>
      if(a[j])
801019af:	8b 16                	mov    (%esi),%edx
801019b1:	85 d2                	test   %edx,%edx
801019b3:	74 f3                	je     801019a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801019b5:	8b 03                	mov    (%ebx),%eax
801019b7:	e8 04 fb ff ff       	call   801014c0 <bfree>
801019bc:	eb ea                	jmp    801019a8 <iput+0x118>
801019be:	66 90                	xchg   %ax,%ax
    brelse(bp);
801019c0:	83 ec 0c             	sub    $0xc,%esp
801019c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019c6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019c9:	e8 42 e8 ff ff       	call   80100210 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ce:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019d4:	8b 03                	mov    (%ebx),%eax
801019d6:	e8 e5 fa ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019db:	83 c4 10             	add    $0x10,%esp
801019de:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019e5:	00 00 00 
801019e8:	e9 60 ff ff ff       	jmp    8010194d <iput+0xbd>
801019ed:	8d 76 00             	lea    0x0(%esi),%esi

801019f0 <iunlockput>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	53                   	push   %ebx
801019f4:	83 ec 10             	sub    $0x10,%esp
801019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019fa:	53                   	push   %ebx
801019fb:	e8 40 fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a03:	83 c4 10             	add    $0x10,%esp
}
80101a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a09:	c9                   	leave  
  iput(ip);
80101a0a:	e9 81 fe ff ff       	jmp    80101890 <iput>
80101a0f:	90                   	nop

80101a10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	8b 55 08             	mov    0x8(%ebp),%edx
80101a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a19:	8b 0a                	mov    (%edx),%ecx
80101a1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a33:	8b 52 58             	mov    0x58(%edx),%edx
80101a36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop

80101a40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a57:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a63:	0f 84 a7 00 00 00    	je     80101b10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	8b 40 58             	mov    0x58(%eax),%eax
80101a6f:	39 c6                	cmp    %eax,%esi
80101a71:	0f 87 ba 00 00 00    	ja     80101b31 <readi+0xf1>
80101a77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a7a:	89 f9                	mov    %edi,%ecx
80101a7c:	01 f1                	add    %esi,%ecx
80101a7e:	0f 82 ad 00 00 00    	jb     80101b31 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a84:	89 c2                	mov    %eax,%edx
80101a86:	29 f2                	sub    %esi,%edx
80101a88:	39 c8                	cmp    %ecx,%eax
80101a8a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a8d:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101a8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a92:	85 d2                	test   %edx,%edx
80101a94:	74 6c                	je     80101b02 <readi+0xc2>
80101a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a9d:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101aa3:	89 f2                	mov    %esi,%edx
80101aa5:	c1 ea 09             	shr    $0x9,%edx
80101aa8:	89 d8                	mov    %ebx,%eax
80101aaa:	e8 01 f9 ff ff       	call   801013b0 <bmap>
80101aaf:	83 ec 08             	sub    $0x8,%esp
80101ab2:	50                   	push   %eax
80101ab3:	ff 33                	pushl  (%ebx)
80101ab5:	e8 36 e6 ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101abd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ac2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac7:	89 f0                	mov    %esi,%eax
80101ac9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ace:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ad0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ad5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad9:	39 d9                	cmp    %ebx,%ecx
80101adb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ade:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101adf:	01 df                	add    %ebx,%edi
80101ae1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ae3:	50                   	push   %eax
80101ae4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ae7:	e8 14 2b 00 00       	call   80104600 <memmove>
    brelse(bp);
80101aec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aef:	89 14 24             	mov    %edx,(%esp)
80101af2:	e8 19 e7 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b00:	77 9e                	ja     80101aa0 <readi+0x60>
  }
  return n;
80101b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b08:	5b                   	pop    %ebx
80101b09:	5e                   	pop    %esi
80101b0a:	5f                   	pop    %edi
80101b0b:	5d                   	pop    %ebp
80101b0c:	c3                   	ret    
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 17                	ja     80101b31 <readi+0xf1>
80101b1a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 0c                	je     80101b31 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b2f:	ff e0                	jmp    *%eax
      return -1;
80101b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b36:	eb cd                	jmp    80101b05 <readi+0xc5>
80101b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b3f:	90                   	nop

80101b40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	57                   	push   %edi
80101b44:	56                   	push   %esi
80101b45:	53                   	push   %ebx
80101b46:	83 ec 1c             	sub    $0x1c,%esp
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b63:	0f 84 b7 00 00 00    	je     80101c20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b6f:	0f 82 e7 00 00 00    	jb     80101c5c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b78:	89 f8                	mov    %edi,%eax
80101b7a:	01 f0                	add    %esi,%eax
80101b7c:	0f 82 da 00 00 00    	jb     80101c5c <writei+0x11c>
80101b82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b87:	0f 87 cf 00 00 00    	ja     80101c5c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b8d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b94:	85 ff                	test   %edi,%edi
80101b96:	74 79                	je     80101c11 <writei+0xd1>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ba3:	89 f2                	mov    %esi,%edx
80101ba5:	c1 ea 09             	shr    $0x9,%edx
80101ba8:	89 f8                	mov    %edi,%eax
80101baa:	e8 01 f8 ff ff       	call   801013b0 <bmap>
80101baf:	83 ec 08             	sub    $0x8,%esp
80101bb2:	50                   	push   %eax
80101bb3:	ff 37                	pushl  (%edi)
80101bb5:	e8 36 e5 ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bba:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bbf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bc2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc7:	89 f0                	mov    %esi,%eax
80101bc9:	83 c4 0c             	add    $0xc,%esp
80101bcc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bd1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bd3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd7:	39 d9                	cmp    %ebx,%ecx
80101bd9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bdc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bdd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bdf:	ff 75 dc             	pushl  -0x24(%ebp)
80101be2:	50                   	push   %eax
80101be3:	e8 18 2a 00 00       	call   80104600 <memmove>
    log_write(bp);
80101be8:	89 3c 24             	mov    %edi,(%esp)
80101beb:	e8 c0 12 00 00       	call   80102eb0 <log_write>
    brelse(bp);
80101bf0:	89 3c 24             	mov    %edi,(%esp)
80101bf3:	e8 18 e6 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c01:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c07:	77 97                	ja     80101ba0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c0f:	77 37                	ja     80101c48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c17:	5b                   	pop    %ebx
80101c18:	5e                   	pop    %esi
80101c19:	5f                   	pop    %edi
80101c1a:	5d                   	pop    %ebp
80101c1b:	c3                   	ret    
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c24:	66 83 f8 09          	cmp    $0x9,%ax
80101c28:	77 32                	ja     80101c5c <writei+0x11c>
80101c2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c31:	85 c0                	test   %eax,%eax
80101c33:	74 27                	je     80101c5c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5f                   	pop    %edi
80101c3e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c3f:	ff e0                	jmp    *%eax
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c4b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c51:	50                   	push   %eax
80101c52:	e8 59 fa ff ff       	call   801016b0 <iupdate>
80101c57:	83 c4 10             	add    $0x10,%esp
80101c5a:	eb b5                	jmp    80101c11 <writei+0xd1>
      return -1;
80101c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c61:	eb b1                	jmp    80101c14 <writei+0xd4>
80101c63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c76:	6a 0e                	push   $0xe
80101c78:	ff 75 0c             	pushl  0xc(%ebp)
80101c7b:	ff 75 08             	pushl  0x8(%ebp)
80101c7e:	e8 ed 29 00 00       	call   80104670 <strncmp>
}
80101c83:	c9                   	leave  
80101c84:	c3                   	ret    
80101c85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
80101c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ca1:	0f 85 85 00 00 00    	jne    80101d2c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca7:	8b 53 58             	mov    0x58(%ebx),%edx
80101caa:	31 ff                	xor    %edi,%edi
80101cac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101caf:	85 d2                	test   %edx,%edx
80101cb1:	74 3e                	je     80101cf1 <dirlookup+0x61>
80101cb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cb7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cb8:	6a 10                	push   $0x10
80101cba:	57                   	push   %edi
80101cbb:	56                   	push   %esi
80101cbc:	53                   	push   %ebx
80101cbd:	e8 7e fd ff ff       	call   80101a40 <readi>
80101cc2:	83 c4 10             	add    $0x10,%esp
80101cc5:	83 f8 10             	cmp    $0x10,%eax
80101cc8:	75 55                	jne    80101d1f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101cca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ccf:	74 18                	je     80101ce9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cd1:	83 ec 04             	sub    $0x4,%esp
80101cd4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cd7:	6a 0e                	push   $0xe
80101cd9:	50                   	push   %eax
80101cda:	ff 75 0c             	pushl  0xc(%ebp)
80101cdd:	e8 8e 29 00 00       	call   80104670 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ce2:	83 c4 10             	add    $0x10,%esp
80101ce5:	85 c0                	test   %eax,%eax
80101ce7:	74 17                	je     80101d00 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ce9:	83 c7 10             	add    $0x10,%edi
80101cec:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cef:	72 c7                	jb     80101cb8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cf4:	31 c0                	xor    %eax,%eax
}
80101cf6:	5b                   	pop    %ebx
80101cf7:	5e                   	pop    %esi
80101cf8:	5f                   	pop    %edi
80101cf9:	5d                   	pop    %ebp
80101cfa:	c3                   	ret    
80101cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cff:	90                   	nop
      if(poff)
80101d00:	8b 45 10             	mov    0x10(%ebp),%eax
80101d03:	85 c0                	test   %eax,%eax
80101d05:	74 05                	je     80101d0c <dirlookup+0x7c>
        *poff = off;
80101d07:	8b 45 10             	mov    0x10(%ebp),%eax
80101d0a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d0c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d10:	8b 03                	mov    (%ebx),%eax
80101d12:	e8 a9 f5 ff ff       	call   801012c0 <iget>
}
80101d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1a:	5b                   	pop    %ebx
80101d1b:	5e                   	pop    %esi
80101d1c:	5f                   	pop    %edi
80101d1d:	5d                   	pop    %ebp
80101d1e:	c3                   	ret    
      panic("dirlookup read");
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	68 79 71 10 80       	push   $0x80107179
80101d27:	e8 84 e6 ff ff       	call   801003b0 <panic>
    panic("dirlookup not DIR");
80101d2c:	83 ec 0c             	sub    $0xc,%esp
80101d2f:	68 67 71 10 80       	push   $0x80107167
80101d34:	e8 77 e6 ff ff       	call   801003b0 <panic>
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	89 c3                	mov    %eax,%ebx
80101d48:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d4b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d4e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d51:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d54:	0f 84 86 01 00 00    	je     80101ee0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d5a:	e8 b1 1b 00 00       	call   80103910 <myproc>
  acquire(&icache.lock);
80101d5f:	83 ec 0c             	sub    $0xc,%esp
80101d62:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d64:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d67:	68 e0 09 11 80       	push   $0x801109e0
80101d6c:	e8 7f 26 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101d71:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d75:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d7c:	e8 8f 27 00 00       	call   80104510 <release>
80101d81:	83 c4 10             	add    $0x10,%esp
80101d84:	eb 0d                	jmp    80101d93 <namex+0x53>
80101d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d90:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d93:	0f b6 07             	movzbl (%edi),%eax
80101d96:	3c 2f                	cmp    $0x2f,%al
80101d98:	74 f6                	je     80101d90 <namex+0x50>
  if(*path == 0)
80101d9a:	84 c0                	test   %al,%al
80101d9c:	0f 84 ee 00 00 00    	je     80101e90 <namex+0x150>
  while(*path != '/' && *path != 0)
80101da2:	0f b6 07             	movzbl (%edi),%eax
80101da5:	3c 2f                	cmp    $0x2f,%al
80101da7:	0f 84 fb 00 00 00    	je     80101ea8 <namex+0x168>
80101dad:	89 fb                	mov    %edi,%ebx
80101daf:	84 c0                	test   %al,%al
80101db1:	0f 84 f1 00 00 00    	je     80101ea8 <namex+0x168>
80101db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbe:	66 90                	xchg   %ax,%ax
    path++;
80101dc0:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101dc3:	0f b6 03             	movzbl (%ebx),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 04                	je     80101dce <namex+0x8e>
80101dca:	84 c0                	test   %al,%al
80101dcc:	75 f2                	jne    80101dc0 <namex+0x80>
  len = path - s;
80101dce:	89 d8                	mov    %ebx,%eax
80101dd0:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101dd2:	83 f8 0d             	cmp    $0xd,%eax
80101dd5:	0f 8e 85 00 00 00    	jle    80101e60 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101ddb:	83 ec 04             	sub    $0x4,%esp
80101dde:	6a 0e                	push   $0xe
80101de0:	57                   	push   %edi
    path++;
80101de1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101de3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101de6:	e8 15 28 00 00       	call   80104600 <memmove>
80101deb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dee:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101df1:	75 0d                	jne    80101e00 <namex+0xc0>
80101df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101df7:	90                   	nop
    path++;
80101df8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dfb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dfe:	74 f8                	je     80101df8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 57 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e09:	83 c4 10             	add    $0x10,%esp
80101e0c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e11:	0f 85 a1 00 00 00    	jne    80101eb8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e1a:	85 d2                	test   %edx,%edx
80101e1c:	74 09                	je     80101e27 <namex+0xe7>
80101e1e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e21:	0f 84 d9 00 00 00    	je     80101f00 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e27:	83 ec 04             	sub    $0x4,%esp
80101e2a:	6a 00                	push   $0x0
80101e2c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e2f:	56                   	push   %esi
80101e30:	e8 5b fe ff ff       	call   80101c90 <dirlookup>
80101e35:	83 c4 10             	add    $0x10,%esp
80101e38:	89 c3                	mov    %eax,%ebx
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	74 7a                	je     80101eb8 <namex+0x178>
  iunlock(ip);
80101e3e:	83 ec 0c             	sub    $0xc,%esp
80101e41:	56                   	push   %esi
80101e42:	e8 f9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e47:	89 34 24             	mov    %esi,(%esp)
80101e4a:	89 de                	mov    %ebx,%esi
80101e4c:	e8 3f fa ff ff       	call   80101890 <iput>
  while(*path == '/')
80101e51:	83 c4 10             	add    $0x10,%esp
80101e54:	e9 3a ff ff ff       	jmp    80101d93 <namex+0x53>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e63:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e66:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e69:	83 ec 04             	sub    $0x4,%esp
80101e6c:	50                   	push   %eax
80101e6d:	57                   	push   %edi
    name[len] = 0;
80101e6e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e70:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e73:	e8 88 27 00 00       	call   80104600 <memmove>
    name[len] = 0;
80101e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7b:	83 c4 10             	add    $0x10,%esp
80101e7e:	c6 00 00             	movb   $0x0,(%eax)
80101e81:	e9 68 ff ff ff       	jmp    80101dee <namex+0xae>
80101e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e93:	85 c0                	test   %eax,%eax
80101e95:	0f 85 85 00 00 00    	jne    80101f20 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9e:	89 f0                	mov    %esi,%eax
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
80101ea5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eab:	89 fb                	mov    %edi,%ebx
80101ead:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101eb0:	31 c0                	xor    %eax,%eax
80101eb2:	eb b5                	jmp    80101e69 <namex+0x129>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	56                   	push   %esi
80101ebc:	e8 7f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ec1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ec4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ec6:	e8 c5 f9 ff ff       	call   80101890 <iput>
      return 0;
80101ecb:	83 c4 10             	add    $0x10,%esp
}
80101ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed1:	89 f0                	mov    %esi,%eax
80101ed3:	5b                   	pop    %ebx
80101ed4:	5e                   	pop    %esi
80101ed5:	5f                   	pop    %edi
80101ed6:	5d                   	pop    %ebp
80101ed7:	c3                   	ret    
80101ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ee0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ee5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eea:	89 df                	mov    %ebx,%edi
80101eec:	e8 cf f3 ff ff       	call   801012c0 <iget>
80101ef1:	89 c6                	mov    %eax,%esi
80101ef3:	e9 9b fe ff ff       	jmp    80101d93 <namex+0x53>
80101ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eff:	90                   	nop
      iunlock(ip);
80101f00:	83 ec 0c             	sub    $0xc,%esp
80101f03:	56                   	push   %esi
80101f04:	e8 37 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f09:	83 c4 10             	add    $0x10,%esp
}
80101f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0f:	89 f0                	mov    %esi,%eax
80101f11:	5b                   	pop    %ebx
80101f12:	5e                   	pop    %esi
80101f13:	5f                   	pop    %edi
80101f14:	5d                   	pop    %ebp
80101f15:	c3                   	ret    
80101f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f20:	83 ec 0c             	sub    $0xc,%esp
80101f23:	56                   	push   %esi
    return 0;
80101f24:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f26:	e8 65 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f2b:	83 c4 10             	add    $0x10,%esp
80101f2e:	e9 68 ff ff ff       	jmp    80101e9b <namex+0x15b>
80101f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f40 <dirlink>:
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 20             	sub    $0x20,%esp
80101f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f4c:	6a 00                	push   $0x0
80101f4e:	ff 75 0c             	pushl  0xc(%ebp)
80101f51:	53                   	push   %ebx
80101f52:	e8 39 fd ff ff       	call   80101c90 <dirlookup>
80101f57:	83 c4 10             	add    $0x10,%esp
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	75 67                	jne    80101fc5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f5e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f61:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f64:	85 ff                	test   %edi,%edi
80101f66:	74 29                	je     80101f91 <dirlink+0x51>
80101f68:	31 ff                	xor    %edi,%edi
80101f6a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f6d:	eb 09                	jmp    80101f78 <dirlink+0x38>
80101f6f:	90                   	nop
80101f70:	83 c7 10             	add    $0x10,%edi
80101f73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f76:	73 19                	jae    80101f91 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f78:	6a 10                	push   $0x10
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	e8 be fa ff ff       	call   80101a40 <readi>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	83 f8 10             	cmp    $0x10,%eax
80101f88:	75 4e                	jne    80101fd8 <dirlink+0x98>
    if(de.inum == 0)
80101f8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f8f:	75 df                	jne    80101f70 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f91:	83 ec 04             	sub    $0x4,%esp
80101f94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f97:	6a 0e                	push   $0xe
80101f99:	ff 75 0c             	pushl  0xc(%ebp)
80101f9c:	50                   	push   %eax
80101f9d:	e8 2e 27 00 00       	call   801046d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fa2:	6a 10                	push   $0x10
  de.inum = inum;
80101fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fa7:	57                   	push   %edi
80101fa8:	56                   	push   %esi
80101fa9:	53                   	push   %ebx
  de.inum = inum;
80101faa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fae:	e8 8d fb ff ff       	call   80101b40 <writei>
80101fb3:	83 c4 20             	add    $0x20,%esp
80101fb6:	83 f8 10             	cmp    $0x10,%eax
80101fb9:	75 2a                	jne    80101fe5 <dirlink+0xa5>
  return 0;
80101fbb:	31 c0                	xor    %eax,%eax
}
80101fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc0:	5b                   	pop    %ebx
80101fc1:	5e                   	pop    %esi
80101fc2:	5f                   	pop    %edi
80101fc3:	5d                   	pop    %ebp
80101fc4:	c3                   	ret    
    iput(ip);
80101fc5:	83 ec 0c             	sub    $0xc,%esp
80101fc8:	50                   	push   %eax
80101fc9:	e8 c2 f8 ff ff       	call   80101890 <iput>
    return -1;
80101fce:	83 c4 10             	add    $0x10,%esp
80101fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd6:	eb e5                	jmp    80101fbd <dirlink+0x7d>
      panic("dirlink read");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 88 71 10 80       	push   $0x80107188
80101fe0:	e8 cb e3 ff ff       	call   801003b0 <panic>
    panic("dirlink");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 86 77 10 80       	push   $0x80107786
80101fed:	e8 be e3 ff ff       	call   801003b0 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <namei>:

struct inode*
namei(char *path)
{
80102000:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102001:	31 d2                	xor    %edx,%edx
{
80102003:	89 e5                	mov    %esp,%ebp
80102005:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102008:	8b 45 08             	mov    0x8(%ebp),%eax
8010200b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010200e:	e8 2d fd ff ff       	call   80101d40 <namex>
}
80102013:	c9                   	leave  
80102014:	c3                   	ret    
80102015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102020 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102020:	55                   	push   %ebp
  return namex(path, 1, name);
80102021:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102026:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010202e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010202f:	e9 0c fd ff ff       	jmp    80101d40 <namex>
80102034:	66 90                	xchg   %ax,%ax
80102036:	66 90                	xchg   %ax,%ax
80102038:	66 90                	xchg   %ax,%ax
8010203a:	66 90                	xchg   %ax,%ax
8010203c:	66 90                	xchg   %ax,%ax
8010203e:	66 90                	xchg   %ax,%ax

80102040 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	56                   	push   %esi
80102044:	53                   	push   %ebx
  if(b == 0)
80102045:	85 c0                	test   %eax,%eax
80102047:	0f 84 af 00 00 00    	je     801020fc <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010204d:	8b 70 08             	mov    0x8(%eax),%esi
80102050:	89 c3                	mov    %eax,%ebx
80102052:	81 fe ff f3 01 00    	cmp    $0x1f3ff,%esi
80102058:	0f 87 91 00 00 00    	ja     801020ef <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205e:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102067:	90                   	nop
80102068:	89 ca                	mov    %ecx,%edx
8010206a:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010206b:	83 e0 c0             	and    $0xffffffc0,%eax
8010206e:	3c 40                	cmp    $0x40,%al
80102070:	75 f6                	jne    80102068 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102072:	31 c0                	xor    %eax,%eax
80102074:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102079:	ee                   	out    %al,(%dx)
8010207a:	b8 01 00 00 00       	mov    $0x1,%eax
8010207f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102084:	ee                   	out    %al,(%dx)
80102085:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010208a:	89 f0                	mov    %esi,%eax
8010208c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010208d:	89 f0                	mov    %esi,%eax
8010208f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102094:	c1 f8 08             	sar    $0x8,%eax
80102097:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80102098:	89 f0                	mov    %esi,%eax
8010209a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010209f:	c1 f8 10             	sar    $0x10,%eax
801020a2:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020a3:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020a7:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ac:	c1 e0 04             	shl    $0x4,%eax
801020af:	83 e0 10             	and    $0x10,%eax
801020b2:	83 c8 e0             	or     $0xffffffe0,%eax
801020b5:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020b6:	f6 03 04             	testb  $0x4,(%ebx)
801020b9:	75 15                	jne    801020d0 <idestart+0x90>
801020bb:	b8 20 00 00 00       	mov    $0x20,%eax
801020c0:	89 ca                	mov    %ecx,%edx
801020c2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020c6:	5b                   	pop    %ebx
801020c7:	5e                   	pop    %esi
801020c8:	5d                   	pop    %ebp
801020c9:	c3                   	ret    
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020d0:	b8 30 00 00 00       	mov    $0x30,%eax
801020d5:	89 ca                	mov    %ecx,%edx
801020d7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020d8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020dd:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020e0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e5:	fc                   	cld    
801020e6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020eb:	5b                   	pop    %ebx
801020ec:	5e                   	pop    %esi
801020ed:	5d                   	pop    %ebp
801020ee:	c3                   	ret    
    panic("incorrect blockno");
801020ef:	83 ec 0c             	sub    $0xc,%esp
801020f2:	68 f4 71 10 80       	push   $0x801071f4
801020f7:	e8 b4 e2 ff ff       	call   801003b0 <panic>
    panic("idestart");
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	68 eb 71 10 80       	push   $0x801071eb
80102104:	e8 a7 e2 ff ff       	call   801003b0 <panic>
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <ideinit>:
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102116:	68 06 72 10 80       	push   $0x80107206
8010211b:	68 80 a5 10 80       	push   $0x8010a580
80102120:	e8 cb 21 00 00       	call   801042f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102125:	58                   	pop    %eax
80102126:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010212b:	5a                   	pop    %edx
8010212c:	83 e8 01             	sub    $0x1,%eax
8010212f:	50                   	push   %eax
80102130:	6a 0e                	push   $0xe
80102132:	e8 a9 02 00 00       	call   801023e0 <ioapicenable>
80102137:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010213a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010213f:	90                   	nop
80102140:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102141:	83 e0 c0             	and    $0xffffffc0,%eax
80102144:	3c 40                	cmp    $0x40,%al
80102146:	75 f8                	jne    80102140 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102148:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010214d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102152:	ee                   	out    %al,(%dx)
80102153:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102158:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010215d:	eb 06                	jmp    80102165 <ideinit+0x55>
8010215f:	90                   	nop
  for(i=0; i<1000; i++){
80102160:	83 e9 01             	sub    $0x1,%ecx
80102163:	74 0f                	je     80102174 <ideinit+0x64>
80102165:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102166:	84 c0                	test   %al,%al
80102168:	74 f6                	je     80102160 <ideinit+0x50>
      havedisk1 = 1;
8010216a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102171:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102174:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102179:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010217e:	ee                   	out    %al,(%dx)
}
8010217f:	c9                   	leave  
80102180:	c3                   	ret    
80102181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218f:	90                   	nop

80102190 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102199:	68 80 a5 10 80       	push   $0x8010a580
8010219e:	e8 4d 22 00 00       	call   801043f0 <acquire>

  if((b = idequeue) == 0){
801021a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	85 db                	test   %ebx,%ebx
801021ae:	74 63                	je     80102213 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801021b0:	8b 43 58             	mov    0x58(%ebx),%eax
801021b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801021b8:	8b 33                	mov    (%ebx),%esi
801021ba:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021c0:	75 2f                	jne    801021f1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ce:	66 90                	xchg   %ax,%ax
801021d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021d1:	89 c1                	mov    %eax,%ecx
801021d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021d6:	80 f9 40             	cmp    $0x40,%cl
801021d9:	75 f5                	jne    801021d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021db:	a8 21                	test   $0x21,%al
801021dd:	75 12                	jne    801021f1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ec:	fc                   	cld    
801021ed:	f3 6d                	rep insl (%dx),%es:(%edi)
801021ef:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021f1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021f4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021f7:	83 ce 02             	or     $0x2,%esi
801021fa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021fc:	53                   	push   %ebx
801021fd:	e8 3e 1e 00 00       	call   80104040 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102202:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	85 c0                	test   %eax,%eax
8010220c:	74 05                	je     80102213 <ideintr+0x83>
    idestart(idequeue);
8010220e:	e8 2d fe ff ff       	call   80102040 <idestart>
    release(&idelock);
80102213:	83 ec 0c             	sub    $0xc,%esp
80102216:	68 80 a5 10 80       	push   $0x8010a580
8010221b:	e8 f0 22 00 00       	call   80104510 <release>

  release(&idelock);
}
80102220:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102223:	5b                   	pop    %ebx
80102224:	5e                   	pop    %esi
80102225:	5f                   	pop    %edi
80102226:	5d                   	pop    %ebp
80102227:	c3                   	ret    
80102228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop

80102230 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	53                   	push   %ebx
80102234:	83 ec 10             	sub    $0x10,%esp
80102237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010223a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010223d:	50                   	push   %eax
8010223e:	e8 7d 20 00 00       	call   801042c0 <holdingsleep>
80102243:	83 c4 10             	add    $0x10,%esp
80102246:	85 c0                	test   %eax,%eax
80102248:	0f 84 d3 00 00 00    	je     80102321 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010224e:	8b 03                	mov    (%ebx),%eax
80102250:	83 e0 06             	and    $0x6,%eax
80102253:	83 f8 02             	cmp    $0x2,%eax
80102256:	0f 84 b8 00 00 00    	je     80102314 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010225c:	8b 53 04             	mov    0x4(%ebx),%edx
8010225f:	85 d2                	test   %edx,%edx
80102261:	74 0d                	je     80102270 <iderw+0x40>
80102263:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102268:	85 c0                	test   %eax,%eax
8010226a:	0f 84 97 00 00 00    	je     80102307 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102270:	83 ec 0c             	sub    $0xc,%esp
80102273:	68 80 a5 10 80       	push   $0x8010a580
80102278:	e8 73 21 00 00       	call   801043f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010227d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102283:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	85 d2                	test   %edx,%edx
8010228f:	75 09                	jne    8010229a <iderw+0x6a>
80102291:	eb 6d                	jmp    80102300 <iderw+0xd0>
80102293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102297:	90                   	nop
80102298:	89 c2                	mov    %eax,%edx
8010229a:	8b 42 58             	mov    0x58(%edx),%eax
8010229d:	85 c0                	test   %eax,%eax
8010229f:	75 f7                	jne    80102298 <iderw+0x68>
801022a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022ac:	74 42                	je     801022f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022ae:	8b 03                	mov    (%ebx),%eax
801022b0:	83 e0 06             	and    $0x6,%eax
801022b3:	83 f8 02             	cmp    $0x2,%eax
801022b6:	74 23                	je     801022db <iderw+0xab>
801022b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop
    sleep(b, &idelock);
801022c0:	83 ec 08             	sub    $0x8,%esp
801022c3:	68 80 a5 10 80       	push   $0x8010a580
801022c8:	53                   	push   %ebx
801022c9:	e8 b2 1b 00 00       	call   80103e80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022ce:	8b 03                	mov    (%ebx),%eax
801022d0:	83 c4 10             	add    $0x10,%esp
801022d3:	83 e0 06             	and    $0x6,%eax
801022d6:	83 f8 02             	cmp    $0x2,%eax
801022d9:	75 e5                	jne    801022c0 <iderw+0x90>
  }


  release(&idelock);
801022db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022e5:	c9                   	leave  
  release(&idelock);
801022e6:	e9 25 22 00 00       	jmp    80104510 <release>
801022eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop
    idestart(b);
801022f0:	89 d8                	mov    %ebx,%eax
801022f2:	e8 49 fd ff ff       	call   80102040 <idestart>
801022f7:	eb b5                	jmp    801022ae <iderw+0x7e>
801022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102300:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102305:	eb 9d                	jmp    801022a4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102307:	83 ec 0c             	sub    $0xc,%esp
8010230a:	68 35 72 10 80       	push   $0x80107235
8010230f:	e8 9c e0 ff ff       	call   801003b0 <panic>
    panic("iderw: nothing to do");
80102314:	83 ec 0c             	sub    $0xc,%esp
80102317:	68 20 72 10 80       	push   $0x80107220
8010231c:	e8 8f e0 ff ff       	call   801003b0 <panic>
    panic("iderw: buf not locked");
80102321:	83 ec 0c             	sub    $0xc,%esp
80102324:	68 0a 72 10 80       	push   $0x8010720a
80102329:	e8 82 e0 ff ff       	call   801003b0 <panic>
8010232e:	66 90                	xchg   %ax,%ax

80102330 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102330:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102331:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102338:	00 c0 fe 
{
8010233b:	89 e5                	mov    %esp,%ebp
8010233d:	56                   	push   %esi
8010233e:	53                   	push   %ebx
  ioapic->reg = reg;
8010233f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102346:	00 00 00 
  return ioapic->data;
80102349:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010234f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102352:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102358:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010235e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102365:	c1 ee 10             	shr    $0x10,%esi
80102368:	89 f0                	mov    %esi,%eax
8010236a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010236d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102370:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102373:	39 c2                	cmp    %eax,%edx
80102375:	74 16                	je     8010238d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 54 72 10 80       	push   $0x80107254
8010237f:	e8 4c e3 ff ff       	call   801006d0 <cprintf>
80102384:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010238a:	83 c4 10             	add    $0x10,%esp
8010238d:	83 c6 21             	add    $0x21,%esi
{
80102390:	ba 10 00 00 00       	mov    $0x10,%edx
80102395:	b8 20 00 00 00       	mov    $0x20,%eax
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801023a0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023a2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023a4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023aa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023ad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801023b3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801023b6:	8d 5a 01             	lea    0x1(%edx),%ebx
801023b9:	83 c2 02             	add    $0x2,%edx
801023bc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801023be:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023c4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801023cb:	39 f0                	cmp    %esi,%eax
801023cd:	75 d1                	jne    801023a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023d2:	5b                   	pop    %ebx
801023d3:	5e                   	pop    %esi
801023d4:	5d                   	pop    %ebp
801023d5:	c3                   	ret    
801023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023dd:	8d 76 00             	lea    0x0(%esi),%esi

801023e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023e0:	55                   	push   %ebp
  ioapic->reg = reg;
801023e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023e7:	89 e5                	mov    %esp,%ebp
801023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023ec:	8d 50 20             	lea    0x20(%eax),%edx
801023ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102401:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102404:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102406:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010240b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010240e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	66 90                	xchg   %ax,%ax
80102415:	66 90                	xchg   %ax,%ax
80102417:	66 90                	xchg   %ax,%ax
80102419:	66 90                	xchg   %ax,%ax
8010241b:	66 90                	xchg   %ax,%ax
8010241d:	66 90                	xchg   %ax,%ax
8010241f:	90                   	nop

80102420 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	53                   	push   %ebx
80102424:	83 ec 04             	sub    $0x4,%esp
80102427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010242a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102430:	75 76                	jne    801024a8 <kfree+0x88>
80102432:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102438:	72 6e                	jb     801024a8 <kfree+0x88>
8010243a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102440:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
80102445:	77 61                	ja     801024a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102447:	83 ec 04             	sub    $0x4,%esp
8010244a:	68 00 10 00 00       	push   $0x1000
8010244f:	6a 01                	push   $0x1
80102451:	53                   	push   %ebx
80102452:	e8 09 21 00 00       	call   80104560 <memset>

  if(kmem.use_lock)
80102457:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	85 d2                	test   %edx,%edx
80102462:	75 1c                	jne    80102480 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102464:	a1 78 26 11 80       	mov    0x80112678,%eax
80102469:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010246b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102470:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102476:	85 c0                	test   %eax,%eax
80102478:	75 1e                	jne    80102498 <kfree+0x78>
    release(&kmem.lock);
}
8010247a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010247d:	c9                   	leave  
8010247e:	c3                   	ret    
8010247f:	90                   	nop
    acquire(&kmem.lock);
80102480:	83 ec 0c             	sub    $0xc,%esp
80102483:	68 40 26 11 80       	push   $0x80112640
80102488:	e8 63 1f 00 00       	call   801043f0 <acquire>
8010248d:	83 c4 10             	add    $0x10,%esp
80102490:	eb d2                	jmp    80102464 <kfree+0x44>
80102492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102498:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010249f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024a2:	c9                   	leave  
    release(&kmem.lock);
801024a3:	e9 68 20 00 00       	jmp    80104510 <release>
    panic("kfree");
801024a8:	83 ec 0c             	sub    $0xc,%esp
801024ab:	68 86 72 10 80       	push   $0x80107286
801024b0:	e8 fb de ff ff       	call   801003b0 <panic>
801024b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <freerange>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801024c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801024ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024dd:	39 de                	cmp    %ebx,%esi
801024df:	72 23                	jb     80102504 <freerange+0x44>
801024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024f7:	50                   	push   %eax
801024f8:	e8 23 ff ff ff       	call   80102420 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	39 f3                	cmp    %esi,%ebx
80102502:	76 e4                	jbe    801024e8 <freerange+0x28>
}
80102504:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102507:	5b                   	pop    %ebx
80102508:	5e                   	pop    %esi
80102509:	5d                   	pop    %ebp
8010250a:	c3                   	ret    
8010250b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010250f:	90                   	nop

80102510 <kinit1>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	56                   	push   %esi
80102514:	53                   	push   %ebx
80102515:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102518:	83 ec 08             	sub    $0x8,%esp
8010251b:	68 8c 72 10 80       	push   $0x8010728c
80102520:	68 40 26 11 80       	push   $0x80112640
80102525:	e8 c6 1d 00 00       	call   801042f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010252a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102530:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102537:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010253a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102540:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102546:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010254c:	39 de                	cmp    %ebx,%esi
8010254e:	72 1c                	jb     8010256c <kinit1+0x5c>
    kfree(p);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102559:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010255f:	50                   	push   %eax
80102560:	e8 bb fe ff ff       	call   80102420 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102565:	83 c4 10             	add    $0x10,%esp
80102568:	39 de                	cmp    %ebx,%esi
8010256a:	73 e4                	jae    80102550 <kinit1+0x40>
}
8010256c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010256f:	5b                   	pop    %ebx
80102570:	5e                   	pop    %esi
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret    
80102573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102580 <kinit2>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <kinit2+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 63 fe ff ff       	call   80102420 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit2+0x28>
  kmem.use_lock = 1;
801025c4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025cb:	00 00 00 
}
801025ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d1:	5b                   	pop    %ebx
801025d2:	5e                   	pop    %esi
801025d3:	5d                   	pop    %ebp
801025d4:	c3                   	ret    
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	53                   	push   %ebx
801025e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025e7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025ec:	85 c0                	test   %eax,%eax
801025ee:	75 20                	jne    80102610 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025f0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025f6:	85 db                	test   %ebx,%ebx
801025f8:	74 07                	je     80102601 <kalloc+0x21>
    kmem.freelist = r->next;
801025fa:	8b 03                	mov    (%ebx),%eax
801025fc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102601:	89 d8                	mov    %ebx,%eax
80102603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102606:	c9                   	leave  
80102607:	c3                   	ret    
80102608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop
    acquire(&kmem.lock);
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	68 40 26 11 80       	push   $0x80112640
80102618:	e8 d3 1d 00 00       	call   801043f0 <acquire>
  r = kmem.freelist;
8010261d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102623:	83 c4 10             	add    $0x10,%esp
80102626:	a1 74 26 11 80       	mov    0x80112674,%eax
8010262b:	85 db                	test   %ebx,%ebx
8010262d:	74 08                	je     80102637 <kalloc+0x57>
    kmem.freelist = r->next;
8010262f:	8b 13                	mov    (%ebx),%edx
80102631:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102637:	85 c0                	test   %eax,%eax
80102639:	74 c6                	je     80102601 <kalloc+0x21>
    release(&kmem.lock);
8010263b:	83 ec 0c             	sub    $0xc,%esp
8010263e:	68 40 26 11 80       	push   $0x80112640
80102643:	e8 c8 1e 00 00       	call   80104510 <release>
}
80102648:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010264a:	83 c4 10             	add    $0x10,%esp
}
8010264d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102650:	c9                   	leave  
80102651:	c3                   	ret    
80102652:	66 90                	xchg   %ax,%ax
80102654:	66 90                	xchg   %ax,%ax
80102656:	66 90                	xchg   %ax,%ax
80102658:	66 90                	xchg   %ax,%ax
8010265a:	66 90                	xchg   %ax,%ax
8010265c:	66 90                	xchg   %ax,%ax
8010265e:	66 90                	xchg   %ax,%ax

80102660 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102660:	ba 64 00 00 00       	mov    $0x64,%edx
80102665:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102666:	a8 01                	test   $0x1,%al
80102668:	0f 84 c2 00 00 00    	je     80102730 <kbdgetc+0xd0>
{
8010266e:	55                   	push   %ebp
8010266f:	ba 60 00 00 00       	mov    $0x60,%edx
80102674:	89 e5                	mov    %esp,%ebp
80102676:	53                   	push   %ebx
80102677:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102678:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010267b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102681:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102687:	74 57                	je     801026e0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102689:	89 d9                	mov    %ebx,%ecx
8010268b:	83 e1 40             	and    $0x40,%ecx
8010268e:	84 c0                	test   %al,%al
80102690:	78 5e                	js     801026f0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102692:	85 c9                	test   %ecx,%ecx
80102694:	74 09                	je     8010269f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102696:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102699:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010269c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010269f:	0f b6 8a c0 73 10 80 	movzbl -0x7fef8c40(%edx),%ecx
  shift ^= togglecode[data];
801026a6:	0f b6 82 c0 72 10 80 	movzbl -0x7fef8d40(%edx),%eax
  shift |= shiftcode[data];
801026ad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026af:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026b1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026b3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026b9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026bc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026bf:	8b 04 85 a0 72 10 80 	mov    -0x7fef8d60(,%eax,4),%eax
801026c6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026ca:	74 0b                	je     801026d7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801026cc:	8d 50 9f             	lea    -0x61(%eax),%edx
801026cf:	83 fa 19             	cmp    $0x19,%edx
801026d2:	77 44                	ja     80102718 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026d4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026d7:	5b                   	pop    %ebx
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026e0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026e3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026e5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026eb:	5b                   	pop    %ebx
801026ec:	5d                   	pop    %ebp
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026f0:	83 e0 7f             	and    $0x7f,%eax
801026f3:	85 c9                	test   %ecx,%ecx
801026f5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026fa:	0f b6 8a c0 73 10 80 	movzbl -0x7fef8c40(%edx),%ecx
80102701:	83 c9 40             	or     $0x40,%ecx
80102704:	0f b6 c9             	movzbl %cl,%ecx
80102707:	f7 d1                	not    %ecx
80102709:	21 d9                	and    %ebx,%ecx
}
8010270b:	5b                   	pop    %ebx
8010270c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010270d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102718:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010271b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010271e:	5b                   	pop    %ebx
8010271f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102720:	83 f9 1a             	cmp    $0x1a,%ecx
80102723:	0f 42 c2             	cmovb  %edx,%eax
}
80102726:	c3                   	ret    
80102727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272e:	66 90                	xchg   %ax,%ax
    return -1;
80102730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102735:	c3                   	ret    
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <kbdintr>:

void
kbdintr(void)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102746:	68 60 26 10 80       	push   $0x80102660
8010274b:	e8 30 e1 ff ff       	call   80100880 <consoleintr>
}
80102750:	83 c4 10             	add    $0x10,%esp
80102753:	c9                   	leave  
80102754:	c3                   	ret    
80102755:	66 90                	xchg   %ax,%ax
80102757:	66 90                	xchg   %ax,%ax
80102759:	66 90                	xchg   %ax,%ax
8010275b:	66 90                	xchg   %ax,%ax
8010275d:	66 90                	xchg   %ax,%ax
8010275f:	90                   	nop

80102760 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102765:	85 c0                	test   %eax,%eax
80102767:	0f 84 cb 00 00 00    	je     80102838 <lapicinit+0xd8>
  lapic[index] = value;
8010276d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102774:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102777:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102781:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102784:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102787:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010278e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102791:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102794:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010279b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010279e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027bb:	8b 50 30             	mov    0x30(%eax),%edx
801027be:	c1 ea 10             	shr    $0x10,%edx
801027c1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801027c7:	75 77                	jne    80102840 <lapicinit+0xe0>
  lapic[index] = value;
801027c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102804:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102811:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
80102817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102820:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102826:	80 e6 10             	and    $0x10,%dh
80102829:	75 f5                	jne    80102820 <lapicinit+0xc0>
  lapic[index] = value;
8010282b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102832:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102838:	c3                   	ret    
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102840:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102847:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284a:	8b 50 20             	mov    0x20(%eax),%edx
8010284d:	e9 77 ff ff ff       	jmp    801027c9 <lapicinit+0x69>
80102852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102860 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102860:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	74 07                	je     80102870 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102869:	8b 40 20             	mov    0x20(%eax),%eax
8010286c:	c1 e8 18             	shr    $0x18,%eax
8010286f:	c3                   	ret    
    return 0;
80102870:	31 c0                	xor    %eax,%eax
}
80102872:	c3                   	ret    
80102873:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102880 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102880:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102885:	85 c0                	test   %eax,%eax
80102887:	74 0d                	je     80102896 <lapiceoi+0x16>
  lapic[index] = value;
80102889:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102890:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102893:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102896:	c3                   	ret    
80102897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801028a0:	c3                   	ret    
801028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop

801028b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801028b6:	ba 70 00 00 00       	mov    $0x70,%edx
801028bb:	89 e5                	mov    %esp,%ebp
801028bd:	53                   	push   %ebx
801028be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028c4:	ee                   	out    %al,(%dx)
801028c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ca:	ba 71 00 00 00       	mov    $0x71,%edx
801028cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028dd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028e0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028e2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028ee:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102903:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102906:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102909:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102910:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102913:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102916:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010291c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010291f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102925:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102928:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010292e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102931:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102937:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102938:	8b 40 20             	mov    0x20(%eax),%eax
}
8010293b:	5d                   	pop    %ebp
8010293c:	c3                   	ret    
8010293d:	8d 76 00             	lea    0x0(%esi),%esi

80102940 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102940:	55                   	push   %ebp
80102941:	b8 0b 00 00 00       	mov    $0xb,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	57                   	push   %edi
8010294e:	56                   	push   %esi
8010294f:	53                   	push   %ebx
80102950:	83 ec 4c             	sub    $0x4c,%esp
80102953:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102954:	ba 71 00 00 00       	mov    $0x71,%edx
80102959:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010295a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102962:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102965:	8d 76 00             	lea    0x0(%esi),%esi
80102968:	31 c0                	xor    %eax,%eax
8010296a:	89 da                	mov    %ebx,%edx
8010296c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102972:	89 ca                	mov    %ecx,%edx
80102974:	ec                   	in     (%dx),%al
80102975:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102978:	89 da                	mov    %ebx,%edx
8010297a:	b8 02 00 00 00       	mov    $0x2,%eax
8010297f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	89 ca                	mov    %ecx,%edx
80102982:	ec                   	in     (%dx),%al
80102983:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102986:	89 da                	mov    %ebx,%edx
80102988:	b8 04 00 00 00       	mov    $0x4,%eax
8010298d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298e:	89 ca                	mov    %ecx,%edx
80102990:	ec                   	in     (%dx),%al
80102991:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102994:	89 da                	mov    %ebx,%edx
80102996:	b8 07 00 00 00       	mov    $0x7,%eax
8010299b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299c:	89 ca                	mov    %ecx,%edx
8010299e:	ec                   	in     (%dx),%al
8010299f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a2:	89 da                	mov    %ebx,%edx
801029a4:	b8 08 00 00 00       	mov    $0x8,%eax
801029a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029aa:	89 ca                	mov    %ecx,%edx
801029ac:	ec                   	in     (%dx),%al
801029ad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029af:	89 da                	mov    %ebx,%edx
801029b1:	b8 09 00 00 00       	mov    $0x9,%eax
801029b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b7:	89 ca                	mov    %ecx,%edx
801029b9:	ec                   	in     (%dx),%al
801029ba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029bc:	89 da                	mov    %ebx,%edx
801029be:	b8 0a 00 00 00       	mov    $0xa,%eax
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	89 ca                	mov    %ecx,%edx
801029c6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029c7:	84 c0                	test   %al,%al
801029c9:	78 9d                	js     80102968 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029cb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029cf:	89 fa                	mov    %edi,%edx
801029d1:	0f b6 fa             	movzbl %dl,%edi
801029d4:	89 f2                	mov    %esi,%edx
801029d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029d9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029dd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029e8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029ec:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029f2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029f9:	31 c0                	xor    %eax,%eax
801029fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fc:	89 ca                	mov    %ecx,%edx
801029fe:	ec                   	in     (%dx),%al
801029ff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a02:	89 da                	mov    %ebx,%edx
80102a04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a07:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	89 ca                	mov    %ecx,%edx
80102a0f:	ec                   	in     (%dx),%al
80102a10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a13:	89 da                	mov    %ebx,%edx
80102a15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a29:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2f:	89 ca                	mov    %ecx,%edx
80102a31:	ec                   	in     (%dx),%al
80102a32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a35:	89 da                	mov    %ebx,%edx
80102a37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	89 ca                	mov    %ecx,%edx
80102a42:	ec                   	in     (%dx),%al
80102a43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a46:	89 da                	mov    %ebx,%edx
80102a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a51:	89 ca                	mov    %ecx,%edx
80102a53:	ec                   	in     (%dx),%al
80102a54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a60:	6a 18                	push   $0x18
80102a62:	50                   	push   %eax
80102a63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a66:	50                   	push   %eax
80102a67:	e8 44 1b 00 00       	call   801045b0 <memcmp>
80102a6c:	83 c4 10             	add    $0x10,%esp
80102a6f:	85 c0                	test   %eax,%eax
80102a71:	0f 85 f1 fe ff ff    	jne    80102968 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a7b:	75 78                	jne    80102af5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a80:	89 c2                	mov    %eax,%edx
80102a82:	83 e0 0f             	and    $0xf,%eax
80102a85:	c1 ea 04             	shr    $0x4,%edx
80102a88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a94:	89 c2                	mov    %eax,%edx
80102a96:	83 e0 0f             	and    $0xf,%eax
80102a99:	c1 ea 04             	shr    $0x4,%edx
80102a9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102aa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102aa8:	89 c2                	mov    %eax,%edx
80102aaa:	83 e0 0f             	and    $0xf,%eax
80102aad:	c1 ea 04             	shr    $0x4,%edx
80102ab0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ab3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102abc:	89 c2                	mov    %eax,%edx
80102abe:	83 e0 0f             	and    $0xf,%eax
80102ac1:	c1 ea 04             	shr    $0x4,%edx
80102ac4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ac7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102acd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ad0:	89 c2                	mov    %eax,%edx
80102ad2:	83 e0 0f             	and    $0xf,%eax
80102ad5:	c1 ea 04             	shr    $0x4,%edx
80102ad8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ade:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ae1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	83 e0 0f             	and    $0xf,%eax
80102ae9:	c1 ea 04             	shr    $0x4,%edx
80102aec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102af5:	8b 75 08             	mov    0x8(%ebp),%esi
80102af8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102afb:	89 06                	mov    %eax,(%esi)
80102afd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b00:	89 46 04             	mov    %eax,0x4(%esi)
80102b03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b06:	89 46 08             	mov    %eax,0x8(%esi)
80102b09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b12:	89 46 10             	mov    %eax,0x10(%esi)
80102b15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b25:	5b                   	pop    %ebx
80102b26:	5e                   	pop    %esi
80102b27:	5f                   	pop    %edi
80102b28:	5d                   	pop    %ebp
80102b29:	c3                   	ret    
80102b2a:	66 90                	xchg   %ax,%ax
80102b2c:	66 90                	xchg   %ax,%ax
80102b2e:	66 90                	xchg   %ax,%ax

80102b30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b30:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b36:	85 c9                	test   %ecx,%ecx
80102b38:	0f 8e 8a 00 00 00    	jle    80102bc8 <install_trans+0x98>
{
80102b3e:	55                   	push   %ebp
80102b3f:	89 e5                	mov    %esp,%ebp
80102b41:	57                   	push   %edi
80102b42:	56                   	push   %esi
80102b43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b44:	31 db                	xor    %ebx,%ebx
{
80102b46:	83 ec 0c             	sub    $0xc,%esp
80102b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b55:	83 ec 08             	sub    $0x8,%esp
80102b58:	01 d8                	add    %ebx,%eax
80102b5a:	83 c0 01             	add    $0x1,%eax
80102b5d:	50                   	push   %eax
80102b5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b64:	e8 87 d5 ff ff       	call   801000f0 <bread>
80102b69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b6b:	58                   	pop    %eax
80102b6c:	5a                   	pop    %edx
80102b6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b74:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b7d:	e8 6e d5 ff ff       	call   801000f0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b82:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b85:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b87:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b8a:	68 00 02 00 00       	push   $0x200
80102b8f:	50                   	push   %eax
80102b90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b93:	50                   	push   %eax
80102b94:	e8 67 1a 00 00       	call   80104600 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b99:	89 34 24             	mov    %esi,(%esp)
80102b9c:	e8 2f d6 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80102ba1:	89 3c 24             	mov    %edi,(%esp)
80102ba4:	e8 67 d6 ff ff       	call   80100210 <brelse>
    brelse(dbuf);
80102ba9:	89 34 24             	mov    %esi,(%esp)
80102bac:	e8 5f d6 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102bba:	7f 94                	jg     80102b50 <install_trans+0x20>
  }
}
80102bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bbf:	5b                   	pop    %ebx
80102bc0:	5e                   	pop    %esi
80102bc1:	5f                   	pop    %edi
80102bc2:	5d                   	pop    %ebp
80102bc3:	c3                   	ret    
80102bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bc8:	c3                   	ret    
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	53                   	push   %ebx
80102bd4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bd7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bdd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102be3:	e8 08 d5 ff ff       	call   801000f0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102be8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102beb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bed:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bf2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	7e 19                	jle    80102c12 <write_head+0x42>
80102bf9:	31 d2                	xor    %edx,%edx
80102bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c00:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c0b:	83 c2 01             	add    $0x1,%edx
80102c0e:	39 d0                	cmp    %edx,%eax
80102c10:	75 ee                	jne    80102c00 <write_head+0x30>
  }
  bwrite(buf);
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	53                   	push   %ebx
80102c16:	e8 b5 d5 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80102c1b:	89 1c 24             	mov    %ebx,(%esp)
80102c1e:	e8 ed d5 ff ff       	call   80100210 <brelse>
}
80102c23:	83 c4 10             	add    $0x10,%esp
80102c26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c29:	c9                   	leave  
80102c2a:	c3                   	ret    
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <initlog>:
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 2c             	sub    $0x2c,%esp
80102c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c3a:	68 c0 74 10 80       	push   $0x801074c0
80102c3f:	68 80 26 11 80       	push   $0x80112680
80102c44:	e8 a7 16 00 00       	call   801042f0 <initlock>
  readsb(dev, &sb);
80102c49:	58                   	pop    %eax
80102c4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c4d:	5a                   	pop    %edx
80102c4e:	50                   	push   %eax
80102c4f:	53                   	push   %ebx
80102c50:	e8 2b e8 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
80102c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c58:	59                   	pop    %ecx
  log.dev = dev;
80102c59:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c62:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c67:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c6d:	5a                   	pop    %edx
80102c6e:	50                   	push   %eax
80102c6f:	53                   	push   %ebx
80102c70:	e8 7b d4 ff ff       	call   801000f0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c78:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c7b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c81:	85 c9                	test   %ecx,%ecx
80102c83:	7e 1d                	jle    80102ca2 <initlog+0x72>
80102c85:	31 d2                	xor    %edx,%edx
80102c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c90:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c94:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d1                	cmp    %edx,%ecx
80102ca0:	75 ee                	jne    80102c90 <initlog+0x60>
  brelse(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	50                   	push   %eax
80102ca6:	e8 65 d5 ff ff       	call   80100210 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cab:	e8 80 fe ff ff       	call   80102b30 <install_trans>
  log.lh.n = 0;
80102cb0:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cb7:	00 00 00 
  write_head(); // clear the log
80102cba:	e8 11 ff ff ff       	call   80102bd0 <write_head>
}
80102cbf:	83 c4 10             	add    $0x10,%esp
80102cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc5:	c9                   	leave  
80102cc6:	c3                   	ret    
80102cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cd6:	68 80 26 11 80       	push   $0x80112680
80102cdb:	e8 10 17 00 00       	call   801043f0 <acquire>
80102ce0:	83 c4 10             	add    $0x10,%esp
80102ce3:	eb 18                	jmp    80102cfd <begin_op+0x2d>
80102ce5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ce8:	83 ec 08             	sub    $0x8,%esp
80102ceb:	68 80 26 11 80       	push   $0x80112680
80102cf0:	68 80 26 11 80       	push   $0x80112680
80102cf5:	e8 86 11 00 00       	call   80103e80 <sleep>
80102cfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cfd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d02:	85 c0                	test   %eax,%eax
80102d04:	75 e2                	jne    80102ce8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d06:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d0b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d11:	83 c0 01             	add    $0x1,%eax
80102d14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d1a:	83 fa 1e             	cmp    $0x1e,%edx
80102d1d:	7f c9                	jg     80102ce8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d22:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d27:	68 80 26 11 80       	push   $0x80112680
80102d2c:	e8 df 17 00 00       	call   80104510 <release>
      break;
    }
  }
}
80102d31:	83 c4 10             	add    $0x10,%esp
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    
80102d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3d:	8d 76 00             	lea    0x0(%esi),%esi

80102d40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	57                   	push   %edi
80102d44:	56                   	push   %esi
80102d45:	53                   	push   %ebx
80102d46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d49:	68 80 26 11 80       	push   $0x80112680
80102d4e:	e8 9d 16 00 00       	call   801043f0 <acquire>
  log.outstanding -= 1;
80102d53:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d58:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d64:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d6a:	85 f6                	test   %esi,%esi
80102d6c:	0f 85 22 01 00 00    	jne    80102e94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d72:	85 db                	test   %ebx,%ebx
80102d74:	0f 85 f6 00 00 00    	jne    80102e70 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d7a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d81:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d84:	83 ec 0c             	sub    $0xc,%esp
80102d87:	68 80 26 11 80       	push   $0x80112680
80102d8c:	e8 7f 17 00 00       	call   80104510 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d91:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d97:	83 c4 10             	add    $0x10,%esp
80102d9a:	85 c9                	test   %ecx,%ecx
80102d9c:	7f 42                	jg     80102de0 <end_op+0xa0>
    acquire(&log.lock);
80102d9e:	83 ec 0c             	sub    $0xc,%esp
80102da1:	68 80 26 11 80       	push   $0x80112680
80102da6:	e8 45 16 00 00       	call   801043f0 <acquire>
    wakeup(&log);
80102dab:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102db2:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102db9:	00 00 00 
    wakeup(&log);
80102dbc:	e8 7f 12 00 00       	call   80104040 <wakeup>
    release(&log.lock);
80102dc1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dc8:	e8 43 17 00 00       	call   80104510 <release>
80102dcd:	83 c4 10             	add    $0x10,%esp
}
80102dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dd3:	5b                   	pop    %ebx
80102dd4:	5e                   	pop    %esi
80102dd5:	5f                   	pop    %edi
80102dd6:	5d                   	pop    %ebp
80102dd7:	c3                   	ret    
80102dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102de0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102de5:	83 ec 08             	sub    $0x8,%esp
80102de8:	01 d8                	add    %ebx,%eax
80102dea:	83 c0 01             	add    $0x1,%eax
80102ded:	50                   	push   %eax
80102dee:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102df4:	e8 f7 d2 ff ff       	call   801000f0 <bread>
80102df9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dfb:	58                   	pop    %eax
80102dfc:	5a                   	pop    %edx
80102dfd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e04:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e0d:	e8 de d2 ff ff       	call   801000f0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e12:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e15:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e17:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e1a:	68 00 02 00 00       	push   $0x200
80102e1f:	50                   	push   %eax
80102e20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e23:	50                   	push   %eax
80102e24:	e8 d7 17 00 00       	call   80104600 <memmove>
    bwrite(to);  // write the log
80102e29:	89 34 24             	mov    %esi,(%esp)
80102e2c:	e8 9f d3 ff ff       	call   801001d0 <bwrite>
    brelse(from);
80102e31:	89 3c 24             	mov    %edi,(%esp)
80102e34:	e8 d7 d3 ff ff       	call   80100210 <brelse>
    brelse(to);
80102e39:	89 34 24             	mov    %esi,(%esp)
80102e3c:	e8 cf d3 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e4a:	7c 94                	jl     80102de0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e4c:	e8 7f fd ff ff       	call   80102bd0 <write_head>
    install_trans(); // Now install writes to home locations
80102e51:	e8 da fc ff ff       	call   80102b30 <install_trans>
    log.lh.n = 0;
80102e56:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e5d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e60:	e8 6b fd ff ff       	call   80102bd0 <write_head>
80102e65:	e9 34 ff ff ff       	jmp    80102d9e <end_op+0x5e>
80102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	68 80 26 11 80       	push   $0x80112680
80102e78:	e8 c3 11 00 00       	call   80104040 <wakeup>
  release(&log.lock);
80102e7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e84:	e8 87 16 00 00       	call   80104510 <release>
80102e89:	83 c4 10             	add    $0x10,%esp
}
80102e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8f:	5b                   	pop    %ebx
80102e90:	5e                   	pop    %esi
80102e91:	5f                   	pop    %edi
80102e92:	5d                   	pop    %ebp
80102e93:	c3                   	ret    
    panic("log.committing");
80102e94:	83 ec 0c             	sub    $0xc,%esp
80102e97:	68 c4 74 10 80       	push   $0x801074c4
80102e9c:	e8 0f d5 ff ff       	call   801003b0 <panic>
80102ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop

80102eb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
80102eb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102eb7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ec0:	83 fa 1d             	cmp    $0x1d,%edx
80102ec3:	0f 8f 94 00 00 00    	jg     80102f5d <log_write+0xad>
80102ec9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102ece:	83 e8 01             	sub    $0x1,%eax
80102ed1:	39 c2                	cmp    %eax,%edx
80102ed3:	0f 8d 84 00 00 00    	jge    80102f5d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ed9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ede:	85 c0                	test   %eax,%eax
80102ee0:	0f 8e 84 00 00 00    	jle    80102f6a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ee6:	83 ec 0c             	sub    $0xc,%esp
80102ee9:	68 80 26 11 80       	push   $0x80112680
80102eee:	e8 fd 14 00 00       	call   801043f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ef9:	83 c4 10             	add    $0x10,%esp
80102efc:	85 d2                	test   %edx,%edx
80102efe:	7e 51                	jle    80102f51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f00:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f03:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f05:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102f0b:	75 0c                	jne    80102f19 <log_write+0x69>
80102f0d:	eb 39                	jmp    80102f48 <log_write+0x98>
80102f0f:	90                   	nop
80102f10:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f17:	74 2f                	je     80102f48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f19:	83 c0 01             	add    $0x1,%eax
80102f1c:	39 c2                	cmp    %eax,%edx
80102f1e:	75 f0                	jne    80102f10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f20:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f27:	83 c2 01             	add    $0x1,%edx
80102f2a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f36:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f3d:	c9                   	leave  
  release(&log.lock);
80102f3e:	e9 cd 15 00 00       	jmp    80104510 <release>
80102f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f47:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f48:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f4f:	eb df                	jmp    80102f30 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f51:	8b 43 08             	mov    0x8(%ebx),%eax
80102f54:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f59:	75 d5                	jne    80102f30 <log_write+0x80>
80102f5b:	eb ca                	jmp    80102f27 <log_write+0x77>
    panic("too big a transaction");
80102f5d:	83 ec 0c             	sub    $0xc,%esp
80102f60:	68 d3 74 10 80       	push   $0x801074d3
80102f65:	e8 46 d4 ff ff       	call   801003b0 <panic>
    panic("log_write outside of trans");
80102f6a:	83 ec 0c             	sub    $0xc,%esp
80102f6d:	68 e9 74 10 80       	push   $0x801074e9
80102f72:	e8 39 d4 ff ff       	call   801003b0 <panic>
80102f77:	66 90                	xchg   %ax,%ax
80102f79:	66 90                	xchg   %ax,%ax
80102f7b:	66 90                	xchg   %ax,%ax
80102f7d:	66 90                	xchg   %ax,%ax
80102f7f:	90                   	nop

80102f80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f87:	e8 64 09 00 00       	call   801038f0 <cpuid>
80102f8c:	89 c3                	mov    %eax,%ebx
80102f8e:	e8 5d 09 00 00       	call   801038f0 <cpuid>
80102f93:	83 ec 04             	sub    $0x4,%esp
80102f96:	53                   	push   %ebx
80102f97:	50                   	push   %eax
80102f98:	68 04 75 10 80       	push   $0x80107504
80102f9d:	e8 2e d7 ff ff       	call   801006d0 <cprintf>
  idtinit();       // load idt register
80102fa2:	e8 19 28 00 00       	call   801057c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fa7:	e8 c4 08 00 00       	call   80103870 <mycpu>
80102fac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fae:	b8 01 00 00 00       	mov    $0x1,%eax
80102fb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fba:	e8 e1 0b 00 00       	call   80103ba0 <scheduler>
80102fbf:	90                   	nop

80102fc0 <mpenter>:
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fc6:	e8 65 39 00 00       	call   80106930 <switchkvm>
  seginit();
80102fcb:	e8 d0 38 00 00       	call   801068a0 <seginit>
  lapicinit();
80102fd0:	e8 8b f7 ff ff       	call   80102760 <lapicinit>
  mpmain();
80102fd5:	e8 a6 ff ff ff       	call   80102f80 <mpmain>
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <main>:
{
80102fe0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fe4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fe7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fea:	55                   	push   %ebp
80102feb:	89 e5                	mov    %esp,%ebp
80102fed:	53                   	push   %ebx
80102fee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fef:	83 ec 08             	sub    $0x8,%esp
80102ff2:	68 00 00 40 80       	push   $0x80400000
80102ff7:	68 a8 54 11 80       	push   $0x801154a8
80102ffc:	e8 0f f5 ff ff       	call   80102510 <kinit1>
  kvmalloc();      // kernel page table
80103001:	e8 ca 3d 00 00       	call   80106dd0 <kvmalloc>
  mpinit();        // detect other processors
80103006:	e8 85 01 00 00       	call   80103190 <mpinit>
  lapicinit();     // interrupt controller
8010300b:	e8 50 f7 ff ff       	call   80102760 <lapicinit>
  seginit();       // segment descriptors
80103010:	e8 8b 38 00 00       	call   801068a0 <seginit>
  picinit();       // disable pic
80103015:	e8 46 03 00 00       	call   80103360 <picinit>
  ioapicinit();    // another interrupt controller
8010301a:	e8 11 f3 ff ff       	call   80102330 <ioapicinit>
  consoleinit();   // console hardware
8010301f:	e8 2c da ff ff       	call   80100a50 <consoleinit>
  uartinit();      // serial port
80103024:	e8 37 2b 00 00       	call   80105b60 <uartinit>
  pinit();         // process table
80103029:	e8 22 08 00 00       	call   80103850 <pinit>
  tvinit();        // trap vectors
8010302e:	e8 0d 27 00 00       	call   80105740 <tvinit>
  binit();         // buffer cache
80103033:	e8 08 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103038:	e8 c3 dd ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
8010303d:	e8 ce f0 ff ff       	call   80102110 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103042:	83 c4 0c             	add    $0xc,%esp
80103045:	68 8a 00 00 00       	push   $0x8a
8010304a:	68 8c a4 10 80       	push   $0x8010a48c
8010304f:	68 00 70 00 80       	push   $0x80007000
80103054:	e8 a7 15 00 00       	call   80104600 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103063:	00 00 00 
80103066:	05 80 27 11 80       	add    $0x80112780,%eax
8010306b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103070:	76 7e                	jbe    801030f0 <main+0x110>
80103072:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103077:	eb 20                	jmp    80103099 <main+0xb9>
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103080:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103087:	00 00 00 
8010308a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103090:	05 80 27 11 80       	add    $0x80112780,%eax
80103095:	39 c3                	cmp    %eax,%ebx
80103097:	73 57                	jae    801030f0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103099:	e8 d2 07 00 00       	call   80103870 <mycpu>
8010309e:	39 d8                	cmp    %ebx,%eax
801030a0:	74 de                	je     80103080 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030a2:	e8 39 f5 ff ff       	call   801025e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030a7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801030aa:	c7 05 f8 6f 00 80 c0 	movl   $0x80102fc0,0x80006ff8
801030b1:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030b4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801030bb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030be:	05 00 10 00 00       	add    $0x1000,%eax
801030c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801030c8:	0f b6 03             	movzbl (%ebx),%eax
801030cb:	68 00 70 00 00       	push   $0x7000
801030d0:	50                   	push   %eax
801030d1:	e8 da f7 ff ff       	call   801028b0 <lapicstartap>
801030d6:	83 c4 10             	add    $0x10,%esp
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	74 f6                	je     801030e0 <main+0x100>
801030ea:	eb 94                	jmp    80103080 <main+0xa0>
801030ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030f0:	83 ec 08             	sub    $0x8,%esp
801030f3:	68 00 00 40 80       	push   $0x80400000
801030f8:	68 00 00 40 80       	push   $0x80400000
801030fd:	e8 7e f4 ff ff       	call   80102580 <kinit2>
  userinit();      // first user process
80103102:	e8 39 08 00 00       	call   80103940 <userinit>
  mpmain();        // finish this processor's setup
80103107:	e8 74 fe ff ff       	call   80102f80 <mpmain>
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	57                   	push   %edi
80103114:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103115:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010311b:	53                   	push   %ebx
  e = addr+len;
8010311c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010311f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103122:	39 de                	cmp    %ebx,%esi
80103124:	72 10                	jb     80103136 <mpsearch1+0x26>
80103126:	eb 50                	jmp    80103178 <mpsearch1+0x68>
80103128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
80103130:	89 fe                	mov    %edi,%esi
80103132:	39 fb                	cmp    %edi,%ebx
80103134:	76 42                	jbe    80103178 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103136:	83 ec 04             	sub    $0x4,%esp
80103139:	8d 7e 10             	lea    0x10(%esi),%edi
8010313c:	6a 04                	push   $0x4
8010313e:	68 18 75 10 80       	push   $0x80107518
80103143:	56                   	push   %esi
80103144:	e8 67 14 00 00       	call   801045b0 <memcmp>
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	85 c0                	test   %eax,%eax
8010314e:	75 e0                	jne    80103130 <mpsearch1+0x20>
80103150:	89 f1                	mov    %esi,%ecx
80103152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103158:	0f b6 11             	movzbl (%ecx),%edx
8010315b:	83 c1 01             	add    $0x1,%ecx
8010315e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103160:	39 f9                	cmp    %edi,%ecx
80103162:	75 f4                	jne    80103158 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103164:	84 c0                	test   %al,%al
80103166:	75 c8                	jne    80103130 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103168:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316b:	89 f0                	mov    %esi,%eax
8010316d:	5b                   	pop    %ebx
8010316e:	5e                   	pop    %esi
8010316f:	5f                   	pop    %edi
80103170:	5d                   	pop    %ebp
80103171:	c3                   	ret    
80103172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010317b:	31 f6                	xor    %esi,%esi
}
8010317d:	5b                   	pop    %ebx
8010317e:	89 f0                	mov    %esi,%eax
80103180:	5e                   	pop    %esi
80103181:	5f                   	pop    %edi
80103182:	5d                   	pop    %ebp
80103183:	c3                   	ret    
80103184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop

80103190 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103199:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031a7:	c1 e0 08             	shl    $0x8,%eax
801031aa:	09 d0                	or     %edx,%eax
801031ac:	c1 e0 04             	shl    $0x4,%eax
801031af:	75 1b                	jne    801031cc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031b1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031b8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031bf:	c1 e0 08             	shl    $0x8,%eax
801031c2:	09 d0                	or     %edx,%eax
801031c4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031c7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031cc:	ba 00 04 00 00       	mov    $0x400,%edx
801031d1:	e8 3a ff ff ff       	call   80103110 <mpsearch1>
801031d6:	89 c7                	mov    %eax,%edi
801031d8:	85 c0                	test   %eax,%eax
801031da:	0f 84 c0 00 00 00    	je     801032a0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031e3:	85 db                	test   %ebx,%ebx
801031e5:	0f 84 d5 00 00 00    	je     801032c0 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031eb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031ee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031f4:	6a 04                	push   $0x4
801031f6:	68 35 75 10 80       	push   $0x80107535
801031fb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031ff:	e8 ac 13 00 00       	call   801045b0 <memcmp>
80103204:	83 c4 10             	add    $0x10,%esp
80103207:	85 c0                	test   %eax,%eax
80103209:	0f 85 b1 00 00 00    	jne    801032c0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010320f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103216:	3c 01                	cmp    $0x1,%al
80103218:	0f 95 c2             	setne  %dl
8010321b:	3c 04                	cmp    $0x4,%al
8010321d:	0f 95 c0             	setne  %al
80103220:	20 c2                	and    %al,%dl
80103222:	0f 85 98 00 00 00    	jne    801032c0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103228:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010322f:	66 85 c9             	test   %cx,%cx
80103232:	74 21                	je     80103255 <mpinit+0xc5>
80103234:	89 d8                	mov    %ebx,%eax
80103236:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103239:	31 d2                	xor    %edx,%edx
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop
    sum += addr[i];
80103240:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103247:	83 c0 01             	add    $0x1,%eax
8010324a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010324c:	39 c6                	cmp    %eax,%esi
8010324e:	75 f0                	jne    80103240 <mpinit+0xb0>
80103250:	84 d2                	test   %dl,%dl
80103252:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103255:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103258:	85 c9                	test   %ecx,%ecx
8010325a:	74 64                	je     801032c0 <mpinit+0x130>
8010325c:	84 d2                	test   %dl,%dl
8010325e:	75 60                	jne    801032c0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103260:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103266:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010326b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103272:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103278:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010327d:	01 d1                	add    %edx,%ecx
8010327f:	89 ce                	mov    %ecx,%esi
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103288:	39 c6                	cmp    %eax,%esi
8010328a:	76 4b                	jbe    801032d7 <mpinit+0x147>
    switch(*p){
8010328c:	0f b6 10             	movzbl (%eax),%edx
8010328f:	80 fa 04             	cmp    $0x4,%dl
80103292:	0f 87 bf 00 00 00    	ja     80103357 <mpinit+0x1c7>
80103298:	ff 24 95 5c 75 10 80 	jmp    *-0x7fef8aa4(,%edx,4)
8010329f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801032a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032aa:	e8 61 fe ff ff       	call   80103110 <mpsearch1>
801032af:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032b1:	85 c0                	test   %eax,%eax
801032b3:	0f 85 27 ff ff ff    	jne    801031e0 <mpinit+0x50>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801032c0:	83 ec 0c             	sub    $0xc,%esp
801032c3:	68 1d 75 10 80       	push   $0x8010751d
801032c8:	e8 e3 d0 ff ff       	call   801003b0 <panic>
801032cd:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	39 c6                	cmp    %eax,%esi
801032d5:	77 b5                	ja     8010328c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032d7:	85 db                	test   %ebx,%ebx
801032d9:	74 6f                	je     8010334a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032db:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032df:	74 15                	je     801032f6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032e1:	b8 70 00 00 00       	mov    $0x70,%eax
801032e6:	ba 22 00 00 00       	mov    $0x22,%edx
801032eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ec:	ba 23 00 00 00       	mov    $0x23,%edx
801032f1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032f2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f5:	ee                   	out    %al,(%dx)
  }
}
801032f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032f9:	5b                   	pop    %ebx
801032fa:	5e                   	pop    %esi
801032fb:	5f                   	pop    %edi
801032fc:	5d                   	pop    %ebp
801032fd:	c3                   	ret    
801032fe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103300:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80103306:	83 fa 07             	cmp    $0x7,%edx
80103309:	7f 1f                	jg     8010332a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010330b:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103311:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103314:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103318:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
8010331e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103321:	83 c2 01             	add    $0x1,%edx
80103324:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
8010332a:	83 c0 14             	add    $0x14,%eax
      continue;
8010332d:	e9 56 ff ff ff       	jmp    80103288 <mpinit+0xf8>
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103338:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010333c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010333f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103345:	e9 3e ff ff ff       	jmp    80103288 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010334a:	83 ec 0c             	sub    $0xc,%esp
8010334d:	68 3c 75 10 80       	push   $0x8010753c
80103352:	e8 59 d0 ff ff       	call   801003b0 <panic>
      ismp = 0;
80103357:	31 db                	xor    %ebx,%ebx
80103359:	e9 31 ff ff ff       	jmp    8010328f <mpinit+0xff>
8010335e:	66 90                	xchg   %ax,%ax

80103360 <picinit>:
80103360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103365:	ba 21 00 00 00       	mov    $0x21,%edx
8010336a:	ee                   	out    %al,(%dx)
8010336b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103370:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103371:	c3                   	ret    
80103372:	66 90                	xchg   %ax,%ax
80103374:	66 90                	xchg   %ax,%ax
80103376:	66 90                	xchg   %ax,%ax
80103378:	66 90                	xchg   %ax,%ax
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010338c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010338f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103395:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010339b:	e8 80 da ff ff       	call   80100e20 <filealloc>
801033a0:	89 03                	mov    %eax,(%ebx)
801033a2:	85 c0                	test   %eax,%eax
801033a4:	0f 84 a8 00 00 00    	je     80103452 <pipealloc+0xd2>
801033aa:	e8 71 da ff ff       	call   80100e20 <filealloc>
801033af:	89 06                	mov    %eax,(%esi)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 84 87 00 00 00    	je     80103440 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033b9:	e8 22 f2 ff ff       	call   801025e0 <kalloc>
801033be:	89 c7                	mov    %eax,%edi
801033c0:	85 c0                	test   %eax,%eax
801033c2:	0f 84 b0 00 00 00    	je     80103478 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801033c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033dc:	00 00 00 
  p->nwrite = 0;
801033df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033e6:	00 00 00 
  p->nread = 0;
801033e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033f0:	00 00 00 
  initlock(&p->lock, "pipe");
801033f3:	68 70 75 10 80       	push   $0x80107570
801033f8:	50                   	push   %eax
801033f9:	e8 f2 0e 00 00       	call   801042f0 <initlock>
  (*f0)->type = FD_PIPE;
801033fe:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103400:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103403:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103409:	8b 03                	mov    (%ebx),%eax
8010340b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010340f:	8b 03                	mov    (%ebx),%eax
80103411:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103415:	8b 03                	mov    (%ebx),%eax
80103417:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010341a:	8b 06                	mov    (%esi),%eax
8010341c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103422:	8b 06                	mov    (%esi),%eax
80103424:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103428:	8b 06                	mov    (%esi),%eax
8010342a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010342e:	8b 06                	mov    (%esi),%eax
80103430:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103436:	31 c0                	xor    %eax,%eax
}
80103438:	5b                   	pop    %ebx
80103439:	5e                   	pop    %esi
8010343a:	5f                   	pop    %edi
8010343b:	5d                   	pop    %ebp
8010343c:	c3                   	ret    
8010343d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103440:	8b 03                	mov    (%ebx),%eax
80103442:	85 c0                	test   %eax,%eax
80103444:	74 1e                	je     80103464 <pipealloc+0xe4>
    fileclose(*f0);
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	50                   	push   %eax
8010344a:	e8 91 da ff ff       	call   80100ee0 <fileclose>
8010344f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103452:	8b 06                	mov    (%esi),%eax
80103454:	85 c0                	test   %eax,%eax
80103456:	74 0c                	je     80103464 <pipealloc+0xe4>
    fileclose(*f1);
80103458:	83 ec 0c             	sub    $0xc,%esp
8010345b:	50                   	push   %eax
8010345c:	e8 7f da ff ff       	call   80100ee0 <fileclose>
80103461:	83 c4 10             	add    $0x10,%esp
}
80103464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010346c:	5b                   	pop    %ebx
8010346d:	5e                   	pop    %esi
8010346e:	5f                   	pop    %edi
8010346f:	5d                   	pop    %ebp
80103470:	c3                   	ret    
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103478:	8b 03                	mov    (%ebx),%eax
8010347a:	85 c0                	test   %eax,%eax
8010347c:	75 c8                	jne    80103446 <pipealloc+0xc6>
8010347e:	eb d2                	jmp    80103452 <pipealloc+0xd2>

80103480 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	56                   	push   %esi
80103484:	53                   	push   %ebx
80103485:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103488:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	53                   	push   %ebx
8010348f:	e8 5c 0f 00 00       	call   801043f0 <acquire>
  if(writable){
80103494:	83 c4 10             	add    $0x10,%esp
80103497:	85 f6                	test   %esi,%esi
80103499:	74 65                	je     80103500 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801034a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034ab:	00 00 00 
    wakeup(&p->nread);
801034ae:	50                   	push   %eax
801034af:	e8 8c 0b 00 00       	call   80104040 <wakeup>
801034b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034bd:	85 d2                	test   %edx,%edx
801034bf:	75 0a                	jne    801034cb <pipeclose+0x4b>
801034c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034c7:	85 c0                	test   %eax,%eax
801034c9:	74 15                	je     801034e0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d1:	5b                   	pop    %ebx
801034d2:	5e                   	pop    %esi
801034d3:	5d                   	pop    %ebp
    release(&p->lock);
801034d4:	e9 37 10 00 00       	jmp    80104510 <release>
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	53                   	push   %ebx
801034e4:	e8 27 10 00 00       	call   80104510 <release>
    kfree((char*)p);
801034e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ec:	83 c4 10             	add    $0x10,%esp
}
801034ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034f2:	5b                   	pop    %ebx
801034f3:	5e                   	pop    %esi
801034f4:	5d                   	pop    %ebp
    kfree((char*)p);
801034f5:	e9 26 ef ff ff       	jmp    80102420 <kfree>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103509:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103510:	00 00 00 
    wakeup(&p->nwrite);
80103513:	50                   	push   %eax
80103514:	e8 27 0b 00 00       	call   80104040 <wakeup>
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	eb 99                	jmp    801034b7 <pipeclose+0x37>
8010351e:	66 90                	xchg   %ax,%ax

80103520 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 28             	sub    $0x28,%esp
80103529:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010352c:	53                   	push   %ebx
8010352d:	e8 be 0e 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++){
80103532:	8b 45 10             	mov    0x10(%ebp),%eax
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	85 c0                	test   %eax,%eax
8010353a:	0f 8e c8 00 00 00    	jle    80103608 <pipewrite+0xe8>
80103540:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103543:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103549:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010354f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103552:	03 4d 10             	add    0x10(%ebp),%ecx
80103555:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103558:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010355e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103564:	39 d0                	cmp    %edx,%eax
80103566:	75 71                	jne    801035d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103568:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010356e:	85 c0                	test   %eax,%eax
80103570:	74 4e                	je     801035c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103572:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103578:	eb 3a                	jmp    801035b4 <pipewrite+0x94>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	57                   	push   %edi
80103584:	e8 b7 0a 00 00       	call   80104040 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103589:	5a                   	pop    %edx
8010358a:	59                   	pop    %ecx
8010358b:	53                   	push   %ebx
8010358c:	56                   	push   %esi
8010358d:	e8 ee 08 00 00       	call   80103e80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103592:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103598:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010359e:	83 c4 10             	add    $0x10,%esp
801035a1:	05 00 02 00 00       	add    $0x200,%eax
801035a6:	39 c2                	cmp    %eax,%edx
801035a8:	75 36                	jne    801035e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035aa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035b0:	85 c0                	test   %eax,%eax
801035b2:	74 0c                	je     801035c0 <pipewrite+0xa0>
801035b4:	e8 57 03 00 00       	call   80103910 <myproc>
801035b9:	8b 40 24             	mov    0x24(%eax),%eax
801035bc:	85 c0                	test   %eax,%eax
801035be:	74 c0                	je     80103580 <pipewrite+0x60>
        release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 47 0f 00 00       	call   80104510 <release>
        return -1;
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035d4:	5b                   	pop    %ebx
801035d5:	5e                   	pop    %esi
801035d6:	5f                   	pop    %edi
801035d7:	5d                   	pop    %ebp
801035d8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d9:	89 c2                	mov    %eax,%edx
801035db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035df:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035e3:	8d 42 01             	lea    0x1(%edx),%eax
801035e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035f2:	0f b6 0e             	movzbl (%esi),%ecx
801035f5:	83 c6 01             	add    $0x1,%esi
801035f8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035fb:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103602:	0f 85 50 ff ff ff    	jne    80103558 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103608:	83 ec 0c             	sub    $0xc,%esp
8010360b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103611:	50                   	push   %eax
80103612:	e8 29 0a 00 00       	call   80104040 <wakeup>
  release(&p->lock);
80103617:	89 1c 24             	mov    %ebx,(%esp)
8010361a:	e8 f1 0e 00 00       	call   80104510 <release>
  return n;
8010361f:	83 c4 10             	add    $0x10,%esp
80103622:	8b 45 10             	mov    0x10(%ebp),%eax
80103625:	eb aa                	jmp    801035d1 <pipewrite+0xb1>
80103627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010362e:	66 90                	xchg   %ax,%ax

80103630 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 18             	sub    $0x18,%esp
80103639:	8b 75 08             	mov    0x8(%ebp),%esi
8010363c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	56                   	push   %esi
80103640:	e8 ab 0d 00 00       	call   801043f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010364e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103654:	75 6a                	jne    801036c0 <piperead+0x90>
80103656:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010365c:	85 db                	test   %ebx,%ebx
8010365e:	0f 84 c4 00 00 00    	je     80103728 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103664:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010366a:	eb 2d                	jmp    80103699 <piperead+0x69>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	56                   	push   %esi
80103674:	53                   	push   %ebx
80103675:	e8 06 08 00 00       	call   80103e80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103683:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103689:	75 35                	jne    801036c0 <piperead+0x90>
8010368b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103691:	85 d2                	test   %edx,%edx
80103693:	0f 84 8f 00 00 00    	je     80103728 <piperead+0xf8>
    if(myproc()->killed){
80103699:	e8 72 02 00 00       	call   80103910 <myproc>
8010369e:	8b 48 24             	mov    0x24(%eax),%ecx
801036a1:	85 c9                	test   %ecx,%ecx
801036a3:	74 cb                	je     80103670 <piperead+0x40>
      release(&p->lock);
801036a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036ad:	56                   	push   %esi
801036ae:	e8 5d 0e 00 00       	call   80104510 <release>
      return -1;
801036b3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036b9:	89 d8                	mov    %ebx,%eax
801036bb:	5b                   	pop    %ebx
801036bc:	5e                   	pop    %esi
801036bd:	5f                   	pop    %edi
801036be:	5d                   	pop    %ebp
801036bf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c0:	8b 45 10             	mov    0x10(%ebp),%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	7e 61                	jle    80103728 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036c7:	31 db                	xor    %ebx,%ebx
801036c9:	eb 13                	jmp    801036de <piperead+0xae>
801036cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop
801036d0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036d6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036dc:	74 1f                	je     801036fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036de:	8d 41 01             	lea    0x1(%ecx),%eax
801036e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036e7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036ed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036f5:	83 c3 01             	add    $0x1,%ebx
801036f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036fb:	75 d3                	jne    801036d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036fd:	83 ec 0c             	sub    $0xc,%esp
80103700:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103706:	50                   	push   %eax
80103707:	e8 34 09 00 00       	call   80104040 <wakeup>
  release(&p->lock);
8010370c:	89 34 24             	mov    %esi,(%esp)
8010370f:	e8 fc 0d 00 00       	call   80104510 <release>
  return i;
80103714:	83 c4 10             	add    $0x10,%esp
}
80103717:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010371a:	89 d8                	mov    %ebx,%eax
8010371c:	5b                   	pop    %ebx
8010371d:	5e                   	pop    %esi
8010371e:	5f                   	pop    %edi
8010371f:	5d                   	pop    %ebp
80103720:	c3                   	ret    
80103721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103728:	31 db                	xor    %ebx,%ebx
8010372a:	eb d1                	jmp    801036fd <piperead+0xcd>
8010372c:	66 90                	xchg   %ax,%ax
8010372e:	66 90                	xchg   %ax,%ax

80103730 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103734:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103739:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010373c:	68 20 2d 11 80       	push   $0x80112d20
80103741:	e8 aa 0c 00 00       	call   801043f0 <acquire>
80103746:	83 c4 10             	add    $0x10,%esp
80103749:	eb 10                	jmp    8010375b <allocproc+0x2b>
8010374b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103750:	83 c3 7c             	add    $0x7c,%ebx
80103753:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103759:	74 75                	je     801037d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010375b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010375e:	85 c0                	test   %eax,%eax
80103760:	75 ee                	jne    80103750 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103762:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103767:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010376a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103771:	89 43 10             	mov    %eax,0x10(%ebx)
80103774:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103777:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010377c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103782:	e8 89 0d 00 00       	call   80104510 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103787:	e8 54 ee ff ff       	call   801025e0 <kalloc>
8010378c:	83 c4 10             	add    $0x10,%esp
8010378f:	89 43 08             	mov    %eax,0x8(%ebx)
80103792:	85 c0                	test   %eax,%eax
80103794:	74 53                	je     801037e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103796:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010379c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010379f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037a7:	c7 40 14 32 57 10 80 	movl   $0x80105732,0x14(%eax)
  p->context = (struct context*)sp;
801037ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037b1:	6a 14                	push   $0x14
801037b3:	6a 00                	push   $0x0
801037b5:	50                   	push   %eax
801037b6:	e8 a5 0d 00 00       	call   80104560 <memset>
  p->context->eip = (uint)forkret;
801037bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037c1:	c7 40 10 00 38 10 80 	movl   $0x80103800,0x10(%eax)
}
801037c8:	89 d8                	mov    %ebx,%eax
801037ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037cd:	c9                   	leave  
801037ce:	c3                   	ret    
801037cf:	90                   	nop
  release(&ptable.lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037d5:	68 20 2d 11 80       	push   $0x80112d20
801037da:	e8 31 0d 00 00       	call   80104510 <release>
}
801037df:	89 d8                	mov    %ebx,%eax
  return 0;
801037e1:	83 c4 10             	add    $0x10,%esp
}
801037e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e7:	c9                   	leave  
801037e8:	c3                   	ret    
    p->state = UNUSED;
801037e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037f0:	31 db                	xor    %ebx,%ebx
}
801037f2:	89 d8                	mov    %ebx,%eax
801037f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103800 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103806:	68 20 2d 11 80       	push   $0x80112d20
8010380b:	e8 00 0d 00 00       	call   80104510 <release>

  if (first) {
80103810:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	85 c0                	test   %eax,%eax
8010381a:	75 04                	jne    80103820 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010381c:	c9                   	leave  
8010381d:	c3                   	ret    
8010381e:	66 90                	xchg   %ax,%ax
    first = 0;
80103820:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103827:	00 00 00 
    iinit(ROOTDEV);
8010382a:	83 ec 0c             	sub    $0xc,%esp
8010382d:	6a 01                	push   $0x1
8010382f:	e8 2c dd ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103834:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010383b:	e8 f0 f3 ff ff       	call   80102c30 <initlog>
80103840:	83 c4 10             	add    $0x10,%esp
}
80103843:	c9                   	leave  
80103844:	c3                   	ret    
80103845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <pinit>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103856:	68 75 75 10 80       	push   $0x80107575
8010385b:	68 20 2d 11 80       	push   $0x80112d20
80103860:	e8 8b 0a 00 00       	call   801042f0 <initlock>
}
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	c9                   	leave  
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103870 <mycpu>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103875:	9c                   	pushf  
80103876:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103877:	f6 c4 02             	test   $0x2,%ah
8010387a:	75 5d                	jne    801038d9 <mycpu+0x69>
  apicid = lapicid();
8010387c:	e8 df ef ff ff       	call   80102860 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103881:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103887:	85 f6                	test   %esi,%esi
80103889:	7e 41                	jle    801038cc <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010388b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103892:	39 d0                	cmp    %edx,%eax
80103894:	74 2f                	je     801038c5 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103896:	31 d2                	xor    %edx,%edx
80103898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389f:	90                   	nop
801038a0:	83 c2 01             	add    $0x1,%edx
801038a3:	39 f2                	cmp    %esi,%edx
801038a5:	74 25                	je     801038cc <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
801038a7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801038ad:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
801038b4:	39 c3                	cmp    %eax,%ebx
801038b6:	75 e8                	jne    801038a0 <mycpu+0x30>
801038b8:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
801038be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c1:	5b                   	pop    %ebx
801038c2:	5e                   	pop    %esi
801038c3:	5d                   	pop    %ebp
801038c4:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038c5:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801038ca:	eb f2                	jmp    801038be <mycpu+0x4e>
  panic("unknown apicid\n");
801038cc:	83 ec 0c             	sub    $0xc,%esp
801038cf:	68 7c 75 10 80       	push   $0x8010757c
801038d4:	e8 d7 ca ff ff       	call   801003b0 <panic>
    panic("mycpu called with interrupts enabled\n");
801038d9:	83 ec 0c             	sub    $0xc,%esp
801038dc:	68 58 76 10 80       	push   $0x80107658
801038e1:	e8 ca ca ff ff       	call   801003b0 <panic>
801038e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <cpuid>:
cpuid() {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038f6:	e8 75 ff ff ff       	call   80103870 <mycpu>
}
801038fb:	c9                   	leave  
  return mycpu()-cpus;
801038fc:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103901:	c1 f8 04             	sar    $0x4,%eax
80103904:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010390a:	c3                   	ret    
8010390b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010390f:	90                   	nop

80103910 <myproc>:
myproc(void) {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103917:	e8 84 0a 00 00       	call   801043a0 <pushcli>
  c = mycpu();
8010391c:	e8 4f ff ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103927:	e8 84 0b 00 00       	call   801044b0 <popcli>
}
8010392c:	83 c4 04             	add    $0x4,%esp
8010392f:	89 d8                	mov    %ebx,%eax
80103931:	5b                   	pop    %ebx
80103932:	5d                   	pop    %ebp
80103933:	c3                   	ret    
80103934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop

80103940 <userinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103947:	e8 e4 fd ff ff       	call   80103730 <allocproc>
8010394c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010394e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103953:	e8 f8 33 00 00       	call   80106d50 <setupkvm>
80103958:	89 43 04             	mov    %eax,0x4(%ebx)
8010395b:	85 c0                	test   %eax,%eax
8010395d:	0f 84 bd 00 00 00    	je     80103a20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103963:	83 ec 04             	sub    $0x4,%esp
80103966:	68 2c 00 00 00       	push   $0x2c
8010396b:	68 60 a4 10 80       	push   $0x8010a460
80103970:	50                   	push   %eax
80103971:	e8 da 30 00 00       	call   80106a50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103976:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103979:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010397f:	6a 4c                	push   $0x4c
80103981:	6a 00                	push   $0x0
80103983:	ff 73 18             	pushl  0x18(%ebx)
80103986:	e8 d5 0b 00 00       	call   80104560 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398b:	8b 43 18             	mov    0x18(%ebx),%eax
8010398e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103993:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103996:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010399f:	8b 43 18             	mov    0x18(%ebx),%eax
801039a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039a6:	8b 43 18             	mov    0x18(%ebx),%eax
801039a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039b1:	8b 43 18             	mov    0x18(%ebx),%eax
801039b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039bc:	8b 43 18             	mov    0x18(%ebx),%eax
801039bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039c6:	8b 43 18             	mov    0x18(%ebx),%eax
801039c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039d0:	8b 43 18             	mov    0x18(%ebx),%eax
801039d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039dd:	6a 10                	push   $0x10
801039df:	68 a5 75 10 80       	push   $0x801075a5
801039e4:	50                   	push   %eax
801039e5:	e8 46 0d 00 00       	call   80104730 <safestrcpy>
  p->cwd = namei("/");
801039ea:	c7 04 24 ae 75 10 80 	movl   $0x801075ae,(%esp)
801039f1:	e8 0a e6 ff ff       	call   80102000 <namei>
801039f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039f9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a00:	e8 eb 09 00 00       	call   801043f0 <acquire>
  p->state = RUNNABLE;
80103a05:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a13:	e8 f8 0a 00 00       	call   80104510 <release>
}
80103a18:	83 c4 10             	add    $0x10,%esp
80103a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1e:	c9                   	leave  
80103a1f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a20:	83 ec 0c             	sub    $0xc,%esp
80103a23:	68 8c 75 10 80       	push   $0x8010758c
80103a28:	e8 83 c9 ff ff       	call   801003b0 <panic>
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi

80103a30 <growproc>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103a38:	e8 63 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a3d:	e8 2e fe ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103a42:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103a48:	e8 63 0a 00 00       	call   801044b0 <popcli>
  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103a4d:	85 db                	test   %ebx,%ebx
80103a4f:	78 1f                	js     80103a70 <growproc+0x40>
80103a51:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103a57:	77 17                	ja     80103a70 <growproc+0x40>
80103a59:	03 1e                	add    (%esi),%ebx
80103a5b:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103a61:	77 0d                	ja     80103a70 <growproc+0x40>
  curproc->sz += n;
80103a63:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103a65:	31 c0                	xor    %eax,%eax
}
80103a67:	5b                   	pop    %ebx
80103a68:	5e                   	pop    %esi
80103a69:	5d                   	pop    %ebp
80103a6a:	c3                   	ret    
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop
	  return -1;
80103a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a75:	eb f0                	jmp    80103a67 <growproc+0x37>
80103a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <fork>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a89:	e8 12 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a8e:	e8 dd fd ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103a93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a99:	e8 12 0a 00 00       	call   801044b0 <popcli>
  if((np = allocproc()) == 0){
80103a9e:	e8 8d fc ff ff       	call   80103730 <allocproc>
80103aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	0f 84 b7 00 00 00    	je     80103b65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	ff 33                	pushl  (%ebx)
80103ab3:	89 c7                	mov    %eax,%edi
80103ab5:	ff 73 04             	pushl  0x4(%ebx)
80103ab8:	e8 93 33 00 00       	call   80106e50 <copyuvm>
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	89 47 04             	mov    %eax,0x4(%edi)
80103ac3:	85 c0                	test   %eax,%eax
80103ac5:	0f 84 a1 00 00 00    	je     80103b6c <fork+0xec>
  np->sz = curproc->sz;
80103acb:	8b 03                	mov    (%ebx),%eax
80103acd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ad0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ad2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ad5:	89 c8                	mov    %ecx,%eax
80103ad7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ada:	b9 13 00 00 00       	mov    $0x13,%ecx
80103adf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ae4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ae6:	8b 40 18             	mov    0x18(%eax),%eax
80103ae9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103af0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103af4:	85 c0                	test   %eax,%eax
80103af6:	74 13                	je     80103b0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	50                   	push   %eax
80103afc:	e8 8f d3 ff ff       	call   80100e90 <filedup>
80103b01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b0b:	83 c6 01             	add    $0x1,%esi
80103b0e:	83 fe 10             	cmp    $0x10,%esi
80103b11:	75 dd                	jne    80103af0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b13:	83 ec 0c             	sub    $0xc,%esp
80103b16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b1c:	e8 0f dc ff ff       	call   80101730 <idup>
80103b21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b2d:	6a 10                	push   $0x10
80103b2f:	53                   	push   %ebx
80103b30:	50                   	push   %eax
80103b31:	e8 fa 0b 00 00       	call   80104730 <safestrcpy>
  pid = np->pid;
80103b36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b40:	e8 ab 08 00 00       	call   801043f0 <acquire>
  np->state = RUNNABLE;
80103b45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b53:	e8 b8 09 00 00       	call   80104510 <release>
  return pid;
80103b58:	83 c4 10             	add    $0x10,%esp
}
80103b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b5e:	89 d8                	mov    %ebx,%eax
80103b60:	5b                   	pop    %ebx
80103b61:	5e                   	pop    %esi
80103b62:	5f                   	pop    %edi
80103b63:	5d                   	pop    %ebp
80103b64:	c3                   	ret    
    return -1;
80103b65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b6a:	eb ef                	jmp    80103b5b <fork+0xdb>
    kfree(np->kstack);
80103b6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b6f:	83 ec 0c             	sub    $0xc,%esp
80103b72:	ff 73 08             	pushl  0x8(%ebx)
80103b75:	e8 a6 e8 ff ff       	call   80102420 <kfree>
    np->kstack = 0;
80103b7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b81:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b84:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b90:	eb c9                	jmp    80103b5b <fork+0xdb>
80103b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <scheduler>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ba9:	e8 c2 fc ff ff       	call   80103870 <mycpu>
  c->proc = 0;
80103bae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bb5:	00 00 00 
  struct cpu *c = mycpu();
80103bb8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103bba:	8d 78 04             	lea    0x4(%eax),%edi
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103bc0:	fb                   	sti    
    acquire(&ptable.lock);
80103bc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bc4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103bc9:	68 20 2d 11 80       	push   $0x80112d20
80103bce:	e8 1d 08 00 00       	call   801043f0 <acquire>
80103bd3:	83 c4 10             	add    $0x10,%esp
80103bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103be0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103be4:	75 33                	jne    80103c19 <scheduler+0x79>
      switchuvm(p);
80103be6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103be9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bef:	53                   	push   %ebx
80103bf0:	e8 4b 2d 00 00       	call   80106940 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bf5:	58                   	pop    %eax
80103bf6:	5a                   	pop    %edx
80103bf7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bfa:	57                   	push   %edi
      p->state = RUNNING;
80103bfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c02:	e8 84 0b 00 00       	call   8010478b <swtch>
      switchkvm();
80103c07:	e8 24 2d 00 00       	call   80106930 <switchkvm>
      c->proc = 0;
80103c0c:	83 c4 10             	add    $0x10,%esp
80103c0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c16:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c19:	83 c3 7c             	add    $0x7c,%ebx
80103c1c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c22:	75 bc                	jne    80103be0 <scheduler+0x40>
    release(&ptable.lock);
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	68 20 2d 11 80       	push   $0x80112d20
80103c2c:	e8 df 08 00 00       	call   80104510 <release>
    sti();
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	eb 8a                	jmp    80103bc0 <scheduler+0x20>
80103c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <sched>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
  pushcli();
80103c45:	e8 56 07 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103c4a:	e8 21 fc ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103c4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c55:	e8 56 08 00 00       	call   801044b0 <popcli>
  if(!holding(&ptable.lock))
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 20 2d 11 80       	push   $0x80112d20
80103c62:	e8 f9 06 00 00       	call   80104360 <holding>
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	74 4f                	je     80103cbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c6e:	e8 fd fb ff ff       	call   80103870 <mycpu>
80103c73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c7a:	75 68                	jne    80103ce4 <sched+0xa4>
  if(p->state == RUNNING)
80103c7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c80:	74 55                	je     80103cd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c82:	9c                   	pushf  
80103c83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c84:	f6 c4 02             	test   $0x2,%ah
80103c87:	75 41                	jne    80103cca <sched+0x8a>
  intena = mycpu()->intena;
80103c89:	e8 e2 fb ff ff       	call   80103870 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c97:	e8 d4 fb ff ff       	call   80103870 <mycpu>
80103c9c:	83 ec 08             	sub    $0x8,%esp
80103c9f:	ff 70 04             	pushl  0x4(%eax)
80103ca2:	53                   	push   %ebx
80103ca3:	e8 e3 0a 00 00       	call   8010478b <swtch>
  mycpu()->intena = intena;
80103ca8:	e8 c3 fb ff ff       	call   80103870 <mycpu>
}
80103cad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb9:	5b                   	pop    %ebx
80103cba:	5e                   	pop    %esi
80103cbb:	5d                   	pop    %ebp
80103cbc:	c3                   	ret    
    panic("sched ptable.lock");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 b0 75 10 80       	push   $0x801075b0
80103cc5:	e8 e6 c6 ff ff       	call   801003b0 <panic>
    panic("sched interruptible");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 dc 75 10 80       	push   $0x801075dc
80103cd2:	e8 d9 c6 ff ff       	call   801003b0 <panic>
    panic("sched running");
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 ce 75 10 80       	push   $0x801075ce
80103cdf:	e8 cc c6 ff ff       	call   801003b0 <panic>
    panic("sched locks");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 c2 75 10 80       	push   $0x801075c2
80103cec:	e8 bf c6 ff ff       	call   801003b0 <panic>
80103cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop

80103d00 <exit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d09:	e8 92 06 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103d0e:	e8 5d fb ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103d13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d19:	e8 92 07 00 00       	call   801044b0 <popcli>
  if(curproc == initproc)
80103d1e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d21:	8d 7e 68             	lea    0x68(%esi),%edi
80103d24:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d2a:	0f 84 e7 00 00 00    	je     80103e17 <exit+0x117>
    if(curproc->ofile[fd]){
80103d30:	8b 03                	mov    (%ebx),%eax
80103d32:	85 c0                	test   %eax,%eax
80103d34:	74 12                	je     80103d48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 a1 d1 ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
80103d3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d45:	83 c4 10             	add    $0x10,%esp
80103d48:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d4b:	39 fb                	cmp    %edi,%ebx
80103d4d:	75 e1                	jne    80103d30 <exit+0x30>
  begin_op();
80103d4f:	e8 7c ef ff ff       	call   80102cd0 <begin_op>
  iput(curproc->cwd);
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	ff 76 68             	pushl  0x68(%esi)
80103d5a:	e8 31 db ff ff       	call   80101890 <iput>
  end_op();
80103d5f:	e8 dc ef ff ff       	call   80102d40 <end_op>
  curproc->cwd = 0;
80103d64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d6b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d72:	e8 79 06 00 00       	call   801043f0 <acquire>
  wakeup1(curproc->parent);
80103d77:	8b 56 14             	mov    0x14(%esi),%edx
80103d7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d7d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d82:	eb 0e                	jmp    80103d92 <exit+0x92>
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	83 c0 7c             	add    $0x7c,%eax
80103d8b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d90:	74 1c                	je     80103dae <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d92:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d96:	75 f0                	jne    80103d88 <exit+0x88>
80103d98:	3b 50 20             	cmp    0x20(%eax),%edx
80103d9b:	75 eb                	jne    80103d88 <exit+0x88>
      p->state = RUNNABLE;
80103d9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da4:	83 c0 7c             	add    $0x7c,%eax
80103da7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dac:	75 e4                	jne    80103d92 <exit+0x92>
      p->parent = initproc;
80103dae:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103db9:	eb 10                	jmp    80103dcb <exit+0xcb>
80103dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop
80103dc0:	83 c2 7c             	add    $0x7c,%edx
80103dc3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103dc9:	74 33                	je     80103dfe <exit+0xfe>
    if(p->parent == curproc){
80103dcb:	39 72 14             	cmp    %esi,0x14(%edx)
80103dce:	75 f0                	jne    80103dc0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103dd0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103dd4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dd7:	75 e7                	jne    80103dc0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dde:	eb 0a                	jmp    80103dea <exit+0xea>
80103de0:	83 c0 7c             	add    $0x7c,%eax
80103de3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103de8:	74 d6                	je     80103dc0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dee:	75 f0                	jne    80103de0 <exit+0xe0>
80103df0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103df3:	75 eb                	jne    80103de0 <exit+0xe0>
      p->state = RUNNABLE;
80103df5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dfc:	eb e2                	jmp    80103de0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103dfe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e05:	e8 36 fe ff ff       	call   80103c40 <sched>
  panic("zombie exit");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 fd 75 10 80       	push   $0x801075fd
80103e12:	e8 99 c5 ff ff       	call   801003b0 <panic>
    panic("init exiting");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 f0 75 10 80       	push   $0x801075f0
80103e1f:	e8 8c c5 ff ff       	call   801003b0 <panic>
80103e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <yield>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e37:	68 20 2d 11 80       	push   $0x80112d20
80103e3c:	e8 af 05 00 00       	call   801043f0 <acquire>
  pushcli();
80103e41:	e8 5a 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e46:	e8 25 fa ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103e4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e51:	e8 5a 06 00 00       	call   801044b0 <popcli>
  myproc()->state = RUNNABLE;
80103e56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e5d:	e8 de fd ff ff       	call   80103c40 <sched>
  release(&ptable.lock);
80103e62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e69:	e8 a2 06 00 00       	call   80104510 <release>
}
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e74:	c9                   	leave  
80103e75:	c3                   	ret    
80103e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <sleep>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e8f:	e8 0c 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e94:	e8 d7 f9 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103e99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e9f:	e8 0c 06 00 00       	call   801044b0 <popcli>
  if(p == 0)
80103ea4:	85 db                	test   %ebx,%ebx
80103ea6:	0f 84 87 00 00 00    	je     80103f33 <sleep+0xb3>
  if(lk == 0)
80103eac:	85 f6                	test   %esi,%esi
80103eae:	74 76                	je     80103f26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103eb0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103eb6:	74 50                	je     80103f08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 20 2d 11 80       	push   $0x80112d20
80103ec0:	e8 2b 05 00 00       	call   801043f0 <acquire>
    release(lk);
80103ec5:	89 34 24             	mov    %esi,(%esp)
80103ec8:	e8 43 06 00 00       	call   80104510 <release>
  p->chan = chan;
80103ecd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ed0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed7:	e8 64 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103edc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ee3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eea:	e8 21 06 00 00       	call   80104510 <release>
    acquire(lk);
80103eef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ef2:	83 c4 10             	add    $0x10,%esp
}
80103ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5e                   	pop    %esi
80103efa:	5f                   	pop    %edi
80103efb:	5d                   	pop    %ebp
    acquire(lk);
80103efc:	e9 ef 04 00 00       	jmp    801043f0 <acquire>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f12:	e8 29 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103f17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5f                   	pop    %edi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    
    panic("sleep without lk");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 0f 76 10 80       	push   $0x8010760f
80103f2e:	e8 7d c4 ff ff       	call   801003b0 <panic>
    panic("sleep");
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 09 76 10 80       	push   $0x80107609
80103f3b:	e8 70 c4 ff ff       	call   801003b0 <panic>

80103f40 <wait>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	57                   	push   %edi
80103f44:	56                   	push   %esi
80103f45:	53                   	push   %ebx
80103f46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f49:	e8 52 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103f4e:	e8 1d f9 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103f53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f59:	e8 52 05 00 00       	call   801044b0 <popcli>
  acquire(&ptable.lock);
80103f5e:	83 ec 0c             	sub    $0xc,%esp
80103f61:	68 20 2d 11 80       	push   $0x80112d20
80103f66:	e8 85 04 00 00       	call   801043f0 <acquire>
80103f6b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f6e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f70:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f75:	eb 14                	jmp    80103f8b <wait+0x4b>
80103f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	83 c3 7c             	add    $0x7c,%ebx
80103f83:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f89:	74 1b                	je     80103fa6 <wait+0x66>
      if(p->parent != curproc)
80103f8b:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f8e:	75 f0                	jne    80103f80 <wait+0x40>
      if(p->state == ZOMBIE){
80103f90:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f94:	74 32                	je     80103fc8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f96:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f99:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9e:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103fa4:	75 e5                	jne    80103f8b <wait+0x4b>
    if(!havekids || curproc->killed){
80103fa6:	85 c0                	test   %eax,%eax
80103fa8:	74 7e                	je     80104028 <wait+0xe8>
80103faa:	8b 46 24             	mov    0x24(%esi),%eax
80103fad:	85 c0                	test   %eax,%eax
80103faf:	75 77                	jne    80104028 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fb1:	83 ec 08             	sub    $0x8,%esp
80103fb4:	68 20 2d 11 80       	push   $0x80112d20
80103fb9:	56                   	push   %esi
80103fba:	e8 c1 fe ff ff       	call   80103e80 <sleep>
    havekids = 0;
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	eb aa                	jmp    80103f6e <wait+0x2e>
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fd1:	e8 4a e4 ff ff       	call   80102420 <kfree>
        pgdir = p->pgdir;
80103fd6:	8b 7b 04             	mov    0x4(%ebx),%edi
        p->name[0] = 0;
80103fd9:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        release(&ptable.lock);
80103fdd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->kstack = 0;
80103fe4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pgdir = 0;
80103feb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
80103ff2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ff9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104000:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104007:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010400e:	e8 fd 04 00 00       	call   80104510 <release>
        freevm(pgdir);
80104013:	89 3c 24             	mov    %edi,(%esp)
80104016:	e8 b5 2c 00 00       	call   80106cd0 <freevm>
        return pid;
8010401b:	83 c4 10             	add    $0x10,%esp
}
8010401e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104021:	89 f0                	mov    %esi,%eax
80104023:	5b                   	pop    %ebx
80104024:	5e                   	pop    %esi
80104025:	5f                   	pop    %edi
80104026:	5d                   	pop    %ebp
80104027:	c3                   	ret    
      release(&ptable.lock);
80104028:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010402b:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104030:	68 20 2d 11 80       	push   $0x80112d20
80104035:	e8 d6 04 00 00       	call   80104510 <release>
      return -1;
8010403a:	83 c4 10             	add    $0x10,%esp
8010403d:	eb df                	jmp    8010401e <wait+0xde>
8010403f:	90                   	nop

80104040 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 9c 03 00 00       	call   801043f0 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0c                	jmp    8010406a <wakeup+0x2a>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	83 c0 7c             	add    $0x7c,%eax
80104063:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104068:	74 1c                	je     80104086 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010406e:	75 f0                	jne    80104060 <wakeup+0x20>
80104070:	3b 58 20             	cmp    0x20(%eax),%ebx
80104073:	75 eb                	jne    80104060 <wakeup+0x20>
      p->state = RUNNABLE;
80104075:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	83 c0 7c             	add    $0x7c,%eax
8010407f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104084:	75 e4                	jne    8010406a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104086:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010408d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104090:	c9                   	leave  
  release(&ptable.lock);
80104091:	e9 7a 04 00 00       	jmp    80104510 <release>
80104096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040aa:	68 20 2d 11 80       	push   $0x80112d20
801040af:	e8 3c 03 00 00       	call   801043f0 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040bc:	eb 0c                	jmp    801040ca <kill+0x2a>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	83 c0 7c             	add    $0x7c,%eax
801040c3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040c8:	74 36                	je     80104100 <kill+0x60>
    if(p->pid == pid){
801040ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801040cd:	75 f1                	jne    801040c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040da:	75 07                	jne    801040e3 <kill+0x43>
        p->state = RUNNABLE;
801040dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	68 20 2d 11 80       	push   $0x80112d20
801040eb:	e8 20 04 00 00       	call   80104510 <release>
      return 0;
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f8:	c9                   	leave  
801040f9:	c3                   	ret    
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	68 20 2d 11 80       	push   $0x80112d20
80104108:	e8 03 04 00 00       	call   80104510 <release>
  return -1;
8010410d:	83 c4 10             	add    $0x10,%esp
80104110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104118:	c9                   	leave  
80104119:	c3                   	ret    
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104128:	53                   	push   %ebx
80104129:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010412e:	83 ec 3c             	sub    $0x3c,%esp
80104131:	eb 24                	jmp    80104157 <procdump+0x37>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 75 79 10 80       	push   $0x80107975
80104140:	e8 8b c5 ff ff       	call   801006d0 <cprintf>
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104151:	0f 84 81 00 00 00    	je     801041d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104157:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 ea                	je     80104148 <procdump+0x28>
      state = "???";
8010415e:	ba 20 76 10 80       	mov    $0x80107620,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104163:	83 f8 05             	cmp    $0x5,%eax
80104166:	77 11                	ja     80104179 <procdump+0x59>
80104168:	8b 14 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%edx
      state = "???";
8010416f:	b8 20 76 10 80       	mov    $0x80107620,%eax
80104174:	85 d2                	test   %edx,%edx
80104176:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104179:	53                   	push   %ebx
8010417a:	52                   	push   %edx
8010417b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010417e:	68 24 76 10 80       	push   $0x80107624
80104183:	e8 48 c5 ff ff       	call   801006d0 <cprintf>
    if(p->state == SLEEPING){
80104188:	83 c4 10             	add    $0x10,%esp
8010418b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010418f:	75 a7                	jne    80104138 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104191:	83 ec 08             	sub    $0x8,%esp
80104194:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104197:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010419a:	50                   	push   %eax
8010419b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010419e:	8b 40 0c             	mov    0xc(%eax),%eax
801041a1:	83 c0 08             	add    $0x8,%eax
801041a4:	50                   	push   %eax
801041a5:	e8 66 01 00 00       	call   80104310 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801041aa:	83 c4 10             	add    $0x10,%esp
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
801041b0:	8b 17                	mov    (%edi),%edx
801041b2:	85 d2                	test   %edx,%edx
801041b4:	74 82                	je     80104138 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041b6:	83 ec 08             	sub    $0x8,%esp
801041b9:	83 c7 04             	add    $0x4,%edi
801041bc:	52                   	push   %edx
801041bd:	68 61 70 10 80       	push   $0x80107061
801041c2:	e8 09 c5 ff ff       	call   801006d0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	39 fe                	cmp    %edi,%esi
801041cc:	75 e2                	jne    801041b0 <procdump+0x90>
801041ce:	e9 65 ff ff ff       	jmp    80104138 <procdump+0x18>
801041d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d7:	90                   	nop
  }
}
801041d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041db:	5b                   	pop    %ebx
801041dc:	5e                   	pop    %esi
801041dd:	5f                   	pop    %edi
801041de:	5d                   	pop    %ebp
801041df:	c3                   	ret    

801041e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801041ea:	68 98 76 10 80       	push   $0x80107698
801041ef:	8d 43 04             	lea    0x4(%ebx),%eax
801041f2:	50                   	push   %eax
801041f3:	e8 f8 00 00 00       	call   801042f0 <initlock>
  lk->name = name;
801041f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801041fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104201:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104204:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010420b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010420e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104211:	c9                   	leave  
80104212:	c3                   	ret    
80104213:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104228:	8d 73 04             	lea    0x4(%ebx),%esi
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	56                   	push   %esi
8010422f:	e8 bc 01 00 00       	call   801043f0 <acquire>
  while (lk->locked) {
80104234:	8b 13                	mov    (%ebx),%edx
80104236:	83 c4 10             	add    $0x10,%esp
80104239:	85 d2                	test   %edx,%edx
8010423b:	74 16                	je     80104253 <acquiresleep+0x33>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104240:	83 ec 08             	sub    $0x8,%esp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	e8 36 fc ff ff       	call   80103e80 <sleep>
  while (lk->locked) {
8010424a:	8b 03                	mov    (%ebx),%eax
8010424c:	83 c4 10             	add    $0x10,%esp
8010424f:	85 c0                	test   %eax,%eax
80104251:	75 ed                	jne    80104240 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104253:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104259:	e8 b2 f6 ff ff       	call   80103910 <myproc>
8010425e:	8b 40 10             	mov    0x10(%eax),%eax
80104261:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104264:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104267:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010426a:	5b                   	pop    %ebx
8010426b:	5e                   	pop    %esi
8010426c:	5d                   	pop    %ebp
  release(&lk->lk);
8010426d:	e9 9e 02 00 00       	jmp    80104510 <release>
80104272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104280 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
80104285:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104288:	8d 73 04             	lea    0x4(%ebx),%esi
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	56                   	push   %esi
8010428f:	e8 5c 01 00 00       	call   801043f0 <acquire>
  lk->locked = 0;
80104294:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010429a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042a1:	89 1c 24             	mov    %ebx,(%esp)
801042a4:	e8 97 fd ff ff       	call   80104040 <wakeup>
  release(&lk->lk);
801042a9:	89 75 08             	mov    %esi,0x8(%ebp)
801042ac:	83 c4 10             	add    $0x10,%esp
}
801042af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b2:	5b                   	pop    %ebx
801042b3:	5e                   	pop    %esi
801042b4:	5d                   	pop    %ebp
  release(&lk->lk);
801042b5:	e9 56 02 00 00       	jmp    80104510 <release>
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801042c8:	8d 5e 04             	lea    0x4(%esi),%ebx
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	53                   	push   %ebx
801042cf:	e8 1c 01 00 00       	call   801043f0 <acquire>
  r = lk->locked;
801042d4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801042d6:	89 1c 24             	mov    %ebx,(%esp)
801042d9:	e8 32 02 00 00       	call   80104510 <release>
  return r;
}
801042de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e1:	89 f0                	mov    %esi,%eax
801042e3:	5b                   	pop    %ebx
801042e4:	5e                   	pop    %esi
801042e5:	5d                   	pop    %ebp
801042e6:	c3                   	ret    
801042e7:	66 90                	xchg   %ax,%ax
801042e9:	66 90                	xchg   %ax,%ax
801042eb:	66 90                	xchg   %ax,%ax
801042ed:	66 90                	xchg   %ax,%ax
801042ef:	90                   	nop

801042f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801042ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104302:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104309:	5d                   	pop    %ebp
8010430a:	c3                   	ret    
8010430b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop

80104310 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104310:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104311:	31 d2                	xor    %edx,%edx
{
80104313:	89 e5                	mov    %esp,%ebp
80104315:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104316:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010431c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010431f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104320:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010432c:	77 1a                	ja     80104348 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010432e:	8b 58 04             	mov    0x4(%eax),%ebx
80104331:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104334:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104337:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104339:	83 fa 0a             	cmp    $0xa,%edx
8010433c:	75 e2                	jne    80104320 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010433e:	5b                   	pop    %ebx
8010433f:	5d                   	pop    %ebp
80104340:	c3                   	ret    
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010434b:	8d 51 28             	lea    0x28(%ecx),%edx
8010434e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104356:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104359:	39 c2                	cmp    %eax,%edx
8010435b:	75 f3                	jne    80104350 <getcallerpcs+0x40>
}
8010435d:	5b                   	pop    %ebx
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

80104360 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 04             	sub    $0x4,%esp
80104367:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010436a:	8b 02                	mov    (%edx),%eax
8010436c:	85 c0                	test   %eax,%eax
8010436e:	75 10                	jne    80104380 <holding+0x20>
}
80104370:	83 c4 04             	add    $0x4,%esp
80104373:	31 c0                	xor    %eax,%eax
80104375:	5b                   	pop    %ebx
80104376:	5d                   	pop    %ebp
80104377:	c3                   	ret    
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104380:	8b 5a 08             	mov    0x8(%edx),%ebx
80104383:	e8 e8 f4 ff ff       	call   80103870 <mycpu>
80104388:	39 c3                	cmp    %eax,%ebx
8010438a:	0f 94 c0             	sete   %al
}
8010438d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104390:	0f b6 c0             	movzbl %al,%eax
}
80104393:	5b                   	pop    %ebx
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret    
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
801043a7:	9c                   	pushf  
801043a8:	5b                   	pop    %ebx
  asm volatile("cli");
801043a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043aa:	e8 c1 f4 ff ff       	call   80103870 <mycpu>
801043af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043b5:	85 c0                	test   %eax,%eax
801043b7:	74 17                	je     801043d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801043b9:	e8 b2 f4 ff ff       	call   80103870 <mycpu>
801043be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043c5:	83 c4 04             	add    $0x4,%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801043d0:	e8 9b f4 ff ff       	call   80103870 <mycpu>
801043d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801043e1:	eb d6                	jmp    801043b9 <pushcli+0x19>
801043e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <acquire>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801043f5:	e8 a6 ff ff ff       	call   801043a0 <pushcli>
  if(holding(lk))
801043fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801043fd:	8b 03                	mov    (%ebx),%eax
801043ff:	85 c0                	test   %eax,%eax
80104401:	0f 85 81 00 00 00    	jne    80104488 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104407:	ba 01 00 00 00       	mov    $0x1,%edx
8010440c:	eb 05                	jmp    80104413 <acquire+0x23>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104413:	89 d0                	mov    %edx,%eax
80104415:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104418:	85 c0                	test   %eax,%eax
8010441a:	75 f4                	jne    80104410 <acquire+0x20>
  __sync_synchronize();
8010441c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104421:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104424:	e8 47 f4 ff ff       	call   80103870 <mycpu>
  ebp = (uint*)v - 2;
80104429:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010442b:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
8010442e:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104436:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010443c:	77 22                	ja     80104460 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104441:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104445:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104448:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010444a:	83 f8 0a             	cmp    $0xa,%eax
8010444d:	75 e1                	jne    80104430 <acquire+0x40>
}
8010444f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5d                   	pop    %ebp
80104455:	c3                   	ret    
80104456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
80104460:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104464:	83 c3 34             	add    $0x34,%ebx
80104467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104476:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104479:	39 c3                	cmp    %eax,%ebx
8010447b:	75 f3                	jne    80104470 <acquire+0x80>
}
8010447d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104480:	5b                   	pop    %ebx
80104481:	5e                   	pop    %esi
80104482:	5d                   	pop    %ebp
80104483:	c3                   	ret    
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104488:	8b 73 08             	mov    0x8(%ebx),%esi
8010448b:	e8 e0 f3 ff ff       	call   80103870 <mycpu>
80104490:	39 c6                	cmp    %eax,%esi
80104492:	0f 85 6f ff ff ff    	jne    80104407 <acquire+0x17>
    panic("acquire");
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	68 a3 76 10 80       	push   $0x801076a3
801044a0:	e8 0b bf ff ff       	call   801003b0 <panic>
801044a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <popcli>:

void
popcli(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044b6:	9c                   	pushf  
801044b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044b8:	f6 c4 02             	test   $0x2,%ah
801044bb:	75 35                	jne    801044f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044bd:	e8 ae f3 ff ff       	call   80103870 <mycpu>
801044c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044c9:	78 34                	js     801044ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044cb:	e8 a0 f3 ff ff       	call   80103870 <mycpu>
801044d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044d6:	85 d2                	test   %edx,%edx
801044d8:	74 06                	je     801044e0 <popcli+0x30>
    sti();
}
801044da:	c9                   	leave  
801044db:	c3                   	ret    
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044e0:	e8 8b f3 ff ff       	call   80103870 <mycpu>
801044e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044eb:	85 c0                	test   %eax,%eax
801044ed:	74 eb                	je     801044da <popcli+0x2a>
  asm volatile("sti");
801044ef:	fb                   	sti    
}
801044f0:	c9                   	leave  
801044f1:	c3                   	ret    
    panic("popcli - interruptible");
801044f2:	83 ec 0c             	sub    $0xc,%esp
801044f5:	68 ab 76 10 80       	push   $0x801076ab
801044fa:	e8 b1 be ff ff       	call   801003b0 <panic>
    panic("popcli");
801044ff:	83 ec 0c             	sub    $0xc,%esp
80104502:	68 c2 76 10 80       	push   $0x801076c2
80104507:	e8 a4 be ff ff       	call   801003b0 <panic>
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <release>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104518:	8b 03                	mov    (%ebx),%eax
8010451a:	85 c0                	test   %eax,%eax
8010451c:	75 12                	jne    80104530 <release+0x20>
    panic("release");
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 c9 76 10 80       	push   $0x801076c9
80104526:	e8 85 be ff ff       	call   801003b0 <panic>
8010452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104530:	8b 73 08             	mov    0x8(%ebx),%esi
80104533:	e8 38 f3 ff ff       	call   80103870 <mycpu>
80104538:	39 c6                	cmp    %eax,%esi
8010453a:	75 e2                	jne    8010451e <release+0xe>
  lk->pcs[0] = 0;
8010453c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104543:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010454a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010454f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104555:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104558:	5b                   	pop    %ebx
80104559:	5e                   	pop    %esi
8010455a:	5d                   	pop    %ebp
  popcli();
8010455b:	e9 50 ff ff ff       	jmp    801044b0 <popcli>

80104560 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	8b 55 08             	mov    0x8(%ebp),%edx
80104567:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010456a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010456b:	89 d0                	mov    %edx,%eax
8010456d:	09 c8                	or     %ecx,%eax
8010456f:	a8 03                	test   $0x3,%al
80104571:	75 2d                	jne    801045a0 <memset+0x40>
    c &= 0xFF;
80104573:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104577:	c1 e9 02             	shr    $0x2,%ecx
8010457a:	89 f8                	mov    %edi,%eax
8010457c:	89 fb                	mov    %edi,%ebx
8010457e:	c1 e0 18             	shl    $0x18,%eax
80104581:	c1 e3 10             	shl    $0x10,%ebx
80104584:	09 d8                	or     %ebx,%eax
80104586:	09 f8                	or     %edi,%eax
80104588:	c1 e7 08             	shl    $0x8,%edi
8010458b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010458d:	89 d7                	mov    %edx,%edi
8010458f:	fc                   	cld    
80104590:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104592:	5b                   	pop    %ebx
80104593:	89 d0                	mov    %edx,%eax
80104595:	5f                   	pop    %edi
80104596:	5d                   	pop    %ebp
80104597:	c3                   	ret    
80104598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop
  asm volatile("cld; rep stosb" :
801045a0:	89 d7                	mov    %edx,%edi
801045a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801045a5:	fc                   	cld    
801045a6:	f3 aa                	rep stos %al,%es:(%edi)
801045a8:	5b                   	pop    %ebx
801045a9:	89 d0                	mov    %edx,%eax
801045ab:	5f                   	pop    %edi
801045ac:	5d                   	pop    %ebp
801045ad:	c3                   	ret    
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	8b 75 10             	mov    0x10(%ebp),%esi
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ba:	53                   	push   %ebx
801045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801045be:	85 f6                	test   %esi,%esi
801045c0:	74 22                	je     801045e4 <memcmp+0x34>
    if(*s1 != *s2)
801045c2:	0f b6 08             	movzbl (%eax),%ecx
801045c5:	0f b6 1a             	movzbl (%edx),%ebx
801045c8:	01 c6                	add    %eax,%esi
801045ca:	38 cb                	cmp    %cl,%bl
801045cc:	74 0c                	je     801045da <memcmp+0x2a>
801045ce:	eb 20                	jmp    801045f0 <memcmp+0x40>
801045d0:	0f b6 08             	movzbl (%eax),%ecx
801045d3:	0f b6 1a             	movzbl (%edx),%ebx
801045d6:	38 d9                	cmp    %bl,%cl
801045d8:	75 16                	jne    801045f0 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
801045da:	83 c0 01             	add    $0x1,%eax
801045dd:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801045e0:	39 c6                	cmp    %eax,%esi
801045e2:	75 ec                	jne    801045d0 <memcmp+0x20>
  }

  return 0;
}
801045e4:	5b                   	pop    %ebx
  return 0;
801045e5:	31 c0                	xor    %eax,%eax
}
801045e7:	5e                   	pop    %esi
801045e8:	5d                   	pop    %ebp
801045e9:	c3                   	ret    
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
801045f0:	0f b6 c1             	movzbl %cl,%eax
801045f3:	29 d8                	sub    %ebx,%eax
}
801045f5:	5b                   	pop    %ebx
801045f6:	5e                   	pop    %esi
801045f7:	5d                   	pop    %ebp
801045f8:	c3                   	ret    
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	8b 45 08             	mov    0x8(%ebp),%eax
80104607:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010460a:	56                   	push   %esi
8010460b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010460e:	39 c6                	cmp    %eax,%esi
80104610:	73 26                	jae    80104638 <memmove+0x38>
80104612:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104615:	39 f8                	cmp    %edi,%eax
80104617:	73 1f                	jae    80104638 <memmove+0x38>
80104619:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010461c:	85 c9                	test   %ecx,%ecx
8010461e:	74 0f                	je     8010462f <memmove+0x2f>
      *--d = *--s;
80104620:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104624:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104627:	83 ea 01             	sub    $0x1,%edx
8010462a:	83 fa ff             	cmp    $0xffffffff,%edx
8010462d:	75 f1                	jne    80104620 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010462f:	5e                   	pop    %esi
80104630:	5f                   	pop    %edi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
80104638:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
8010463b:	89 c7                	mov    %eax,%edi
8010463d:	85 c9                	test   %ecx,%ecx
8010463f:	74 ee                	je     8010462f <memmove+0x2f>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104648:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104649:	39 d6                	cmp    %edx,%esi
8010464b:	75 fb                	jne    80104648 <memmove+0x48>
}
8010464d:	5e                   	pop    %esi
8010464e:	5f                   	pop    %edi
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465f:	90                   	nop

80104660 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104660:	eb 9e                	jmp    80104600 <memmove>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	8b 7d 10             	mov    0x10(%ebp),%edi
80104677:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010467a:	56                   	push   %esi
8010467b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010467e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
8010467f:	85 ff                	test   %edi,%edi
80104681:	74 2f                	je     801046b2 <strncmp+0x42>
80104683:	0f b6 11             	movzbl (%ecx),%edx
80104686:	0f b6 1e             	movzbl (%esi),%ebx
80104689:	84 d2                	test   %dl,%dl
8010468b:	74 37                	je     801046c4 <strncmp+0x54>
8010468d:	38 da                	cmp    %bl,%dl
8010468f:	75 33                	jne    801046c4 <strncmp+0x54>
80104691:	01 f7                	add    %esi,%edi
80104693:	eb 13                	jmp    801046a8 <strncmp+0x38>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
80104698:	0f b6 11             	movzbl (%ecx),%edx
8010469b:	84 d2                	test   %dl,%dl
8010469d:	74 21                	je     801046c0 <strncmp+0x50>
8010469f:	0f b6 18             	movzbl (%eax),%ebx
801046a2:	89 c6                	mov    %eax,%esi
801046a4:	38 da                	cmp    %bl,%dl
801046a6:	75 1c                	jne    801046c4 <strncmp+0x54>
    n--, p++, q++;
801046a8:	8d 46 01             	lea    0x1(%esi),%eax
801046ab:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801046ae:	39 f8                	cmp    %edi,%eax
801046b0:	75 e6                	jne    80104698 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801046b2:	5b                   	pop    %ebx
    return 0;
801046b3:	31 c0                	xor    %eax,%eax
}
801046b5:	5e                   	pop    %esi
801046b6:	5f                   	pop    %edi
801046b7:	5d                   	pop    %ebp
801046b8:	c3                   	ret    
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801046c4:	0f b6 c2             	movzbl %dl,%eax
801046c7:	29 d8                	sub    %ebx,%eax
}
801046c9:	5b                   	pop    %ebx
801046ca:	5e                   	pop    %esi
801046cb:	5f                   	pop    %edi
801046cc:	5d                   	pop    %ebp
801046cd:	c3                   	ret    
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801046d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
801046da:	56                   	push   %esi
801046db:	53                   	push   %ebx
801046dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
801046df:	eb 1a                	jmp    801046fb <strncpy+0x2b>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e8:	83 c2 01             	add    $0x1,%edx
801046eb:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
801046ef:	83 c1 01             	add    $0x1,%ecx
801046f2:	88 41 ff             	mov    %al,-0x1(%ecx)
801046f5:	84 c0                	test   %al,%al
801046f7:	74 09                	je     80104702 <strncpy+0x32>
801046f9:	89 fb                	mov    %edi,%ebx
801046fb:	8d 7b ff             	lea    -0x1(%ebx),%edi
801046fe:	85 db                	test   %ebx,%ebx
80104700:	7f e6                	jg     801046e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104702:	89 ce                	mov    %ecx,%esi
80104704:	85 ff                	test   %edi,%edi
80104706:	7e 1b                	jle    80104723 <strncpy+0x53>
80104708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
    *s++ = 0;
80104710:	83 c6 01             	add    $0x1,%esi
80104713:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104717:	89 f2                	mov    %esi,%edx
80104719:	f7 d2                	not    %edx
8010471b:	01 ca                	add    %ecx,%edx
8010471d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
8010471f:	85 d2                	test   %edx,%edx
80104721:	7f ed                	jg     80104710 <strncpy+0x40>
  return os;
}
80104723:	5b                   	pop    %ebx
80104724:	8b 45 08             	mov    0x8(%ebp),%eax
80104727:	5e                   	pop    %esi
80104728:	5f                   	pop    %edi
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104737:	8b 45 08             	mov    0x8(%ebp),%eax
8010473a:	53                   	push   %ebx
8010473b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010473e:	85 c9                	test   %ecx,%ecx
80104740:	7e 26                	jle    80104768 <safestrcpy+0x38>
80104742:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104746:	89 c1                	mov    %eax,%ecx
80104748:	eb 17                	jmp    80104761 <safestrcpy+0x31>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104750:	83 c2 01             	add    $0x1,%edx
80104753:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104757:	83 c1 01             	add    $0x1,%ecx
8010475a:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010475d:	84 db                	test   %bl,%bl
8010475f:	74 04                	je     80104765 <safestrcpy+0x35>
80104761:	39 f2                	cmp    %esi,%edx
80104763:	75 eb                	jne    80104750 <safestrcpy+0x20>
    ;
  *s = 0;
80104765:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104768:	5b                   	pop    %ebx
80104769:	5e                   	pop    %esi
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <strlen>:

int
strlen(const char *s)
{
80104770:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104771:	31 c0                	xor    %eax,%eax
{
80104773:	89 e5                	mov    %esp,%ebp
80104775:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104778:	80 3a 00             	cmpb   $0x0,(%edx)
8010477b:	74 0c                	je     80104789 <strlen+0x19>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	83 c0 01             	add    $0x1,%eax
80104783:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104787:	75 f7                	jne    80104780 <strlen+0x10>
    ;
  return n;
}
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    

8010478b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010478b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010478f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104793:	55                   	push   %ebp
  pushl %ebx
80104794:	53                   	push   %ebx
  pushl %esi
80104795:	56                   	push   %esi
  pushl %edi
80104796:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104797:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104799:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010479b:	5f                   	pop    %edi
  popl %esi
8010479c:	5e                   	pop    %esi
  popl %ebx
8010479d:	5b                   	pop    %ebx
  popl %ebp
8010479e:	5d                   	pop    %ebp
  ret
8010479f:	c3                   	ret    

801047a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801047aa:	e8 61 f1 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047af:	8b 00                	mov    (%eax),%eax
801047b1:	39 d8                	cmp    %ebx,%eax
801047b3:	76 1b                	jbe    801047d0 <fetchint+0x30>
801047b5:	8d 53 04             	lea    0x4(%ebx),%edx
801047b8:	39 d0                	cmp    %edx,%eax
801047ba:	72 14                	jb     801047d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801047bf:	8b 13                	mov    (%ebx),%edx
801047c1:	89 10                	mov    %edx,(%eax)
  return 0;
801047c3:	31 c0                	xor    %eax,%eax
}
801047c5:	83 c4 04             	add    $0x4,%esp
801047c8:	5b                   	pop    %ebx
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop
    return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	eb ee                	jmp    801047c5 <fetchint+0x25>
801047d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047de:	66 90                	xchg   %ax,%ax

801047e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801047ea:	e8 21 f1 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz)
801047ef:	39 18                	cmp    %ebx,(%eax)
801047f1:	76 29                	jbe    8010481c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801047f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801047f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801047fa:	39 d3                	cmp    %edx,%ebx
801047fc:	73 1e                	jae    8010481c <fetchstr+0x3c>
    if(*s == 0)
801047fe:	80 3b 00             	cmpb   $0x0,(%ebx)
80104801:	74 35                	je     80104838 <fetchstr+0x58>
80104803:	89 d8                	mov    %ebx,%eax
80104805:	eb 0e                	jmp    80104815 <fetchstr+0x35>
80104807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480e:	66 90                	xchg   %ax,%ax
80104810:	80 38 00             	cmpb   $0x0,(%eax)
80104813:	74 1b                	je     80104830 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104815:	83 c0 01             	add    $0x1,%eax
80104818:	39 c2                	cmp    %eax,%edx
8010481a:	77 f4                	ja     80104810 <fetchstr+0x30>
    return -1;
8010481c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104821:	83 c4 04             	add    $0x4,%esp
80104824:	5b                   	pop    %ebx
80104825:	5d                   	pop    %ebp
80104826:	c3                   	ret    
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
80104830:	83 c4 04             	add    $0x4,%esp
80104833:	29 d8                	sub    %ebx,%eax
80104835:	5b                   	pop    %ebx
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret    
    if(*s == 0)
80104838:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010483a:	eb e5                	jmp    80104821 <fetchstr+0x41>
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104845:	e8 c6 f0 ff ff       	call   80103910 <myproc>
8010484a:	8b 55 08             	mov    0x8(%ebp),%edx
8010484d:	8b 40 18             	mov    0x18(%eax),%eax
80104850:	8b 40 44             	mov    0x44(%eax),%eax
80104853:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104856:	e8 b5 f0 ff ff       	call   80103910 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010485b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010485e:	8b 00                	mov    (%eax),%eax
80104860:	39 c6                	cmp    %eax,%esi
80104862:	73 1c                	jae    80104880 <argint+0x40>
80104864:	8d 53 08             	lea    0x8(%ebx),%edx
80104867:	39 d0                	cmp    %edx,%eax
80104869:	72 15                	jb     80104880 <argint+0x40>
  *ip = *(int*)(addr);
8010486b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486e:	8b 53 04             	mov    0x4(%ebx),%edx
80104871:	89 10                	mov    %edx,(%eax)
  return 0;
80104873:	31 c0                	xor    %eax,%eax
}
80104875:	5b                   	pop    %ebx
80104876:	5e                   	pop    %esi
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104885:	eb ee                	jmp    80104875 <argint+0x35>
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax

80104890 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	83 ec 10             	sub    $0x10,%esp
80104898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010489b:	e8 70 f0 ff ff       	call   80103910 <myproc>
 
  if(argint(n, &i) < 0)
801048a0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801048a3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801048a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048a8:	50                   	push   %eax
801048a9:	ff 75 08             	pushl  0x8(%ebp)
801048ac:	e8 8f ff ff ff       	call   80104840 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801048b1:	83 c4 10             	add    $0x10,%esp
801048b4:	85 c0                	test   %eax,%eax
801048b6:	78 28                	js     801048e0 <argptr+0x50>
801048b8:	85 db                	test   %ebx,%ebx
801048ba:	78 24                	js     801048e0 <argptr+0x50>
801048bc:	8b 16                	mov    (%esi),%edx
801048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c1:	39 c2                	cmp    %eax,%edx
801048c3:	76 1b                	jbe    801048e0 <argptr+0x50>
801048c5:	01 c3                	add    %eax,%ebx
801048c7:	39 da                	cmp    %ebx,%edx
801048c9:	72 15                	jb     801048e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801048ce:	89 02                	mov    %eax,(%edx)
  return 0;
801048d0:	31 c0                	xor    %eax,%eax
}
801048d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d5:	5b                   	pop    %ebx
801048d6:	5e                   	pop    %esi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e5:	eb eb                	jmp    801048d2 <argptr+0x42>
801048e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801048f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048f9:	50                   	push   %eax
801048fa:	ff 75 08             	pushl  0x8(%ebp)
801048fd:	e8 3e ff ff ff       	call   80104840 <argint>
80104902:	83 c4 10             	add    $0x10,%esp
80104905:	85 c0                	test   %eax,%eax
80104907:	78 17                	js     80104920 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104909:	83 ec 08             	sub    $0x8,%esp
8010490c:	ff 75 0c             	pushl  0xc(%ebp)
8010490f:	ff 75 f4             	pushl  -0xc(%ebp)
80104912:	e8 c9 fe ff ff       	call   801047e0 <fetchstr>
80104917:	83 c4 10             	add    $0x10,%esp
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104920:	c9                   	leave  
    return -1;
80104921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104926:	c3                   	ret    
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax

80104930 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104937:	e8 d4 ef ff ff       	call   80103910 <myproc>
8010493c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010493e:	8b 40 18             	mov    0x18(%eax),%eax
80104941:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104944:	8d 50 ff             	lea    -0x1(%eax),%edx
80104947:	83 fa 16             	cmp    $0x16,%edx
8010494a:	77 1c                	ja     80104968 <syscall+0x38>
8010494c:	8b 14 85 00 77 10 80 	mov    -0x7fef8900(,%eax,4),%edx
80104953:	85 d2                	test   %edx,%edx
80104955:	74 11                	je     80104968 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104957:	ff d2                	call   *%edx
80104959:	8b 53 18             	mov    0x18(%ebx),%edx
8010495c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010495f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104968:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104969:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010496c:	50                   	push   %eax
8010496d:	ff 73 10             	pushl  0x10(%ebx)
80104970:	68 d1 76 10 80       	push   $0x801076d1
80104975:	e8 56 bd ff ff       	call   801006d0 <cprintf>
    curproc->tf->eax = -1;
8010497a:	8b 43 18             	mov    0x18(%ebx),%eax
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104996:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104999:	83 ec 44             	sub    $0x44,%esp
8010499c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010499f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801049a2:	53                   	push   %ebx
801049a3:	50                   	push   %eax
{
801049a4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801049a7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801049aa:	e8 71 d6 ff ff       	call   80102020 <nameiparent>
801049af:	83 c4 10             	add    $0x10,%esp
801049b2:	85 c0                	test   %eax,%eax
801049b4:	0f 84 46 01 00 00    	je     80104b00 <create+0x170>
    return 0;
  ilock(dp);
801049ba:	83 ec 0c             	sub    $0xc,%esp
801049bd:	89 c6                	mov    %eax,%esi
801049bf:	50                   	push   %eax
801049c0:	e8 9b cd ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801049c5:	83 c4 0c             	add    $0xc,%esp
801049c8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801049cb:	50                   	push   %eax
801049cc:	53                   	push   %ebx
801049cd:	56                   	push   %esi
801049ce:	e8 bd d2 ff ff       	call   80101c90 <dirlookup>
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	89 c7                	mov    %eax,%edi
801049d8:	85 c0                	test   %eax,%eax
801049da:	74 54                	je     80104a30 <create+0xa0>
    iunlockput(dp);
801049dc:	83 ec 0c             	sub    $0xc,%esp
801049df:	56                   	push   %esi
801049e0:	e8 0b d0 ff ff       	call   801019f0 <iunlockput>
    ilock(ip);
801049e5:	89 3c 24             	mov    %edi,(%esp)
801049e8:	e8 73 cd ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049f5:	75 19                	jne    80104a10 <create+0x80>
801049f7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801049fc:	75 12                	jne    80104a10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a01:	89 f8                	mov    %edi,%eax
80104a03:	5b                   	pop    %ebx
80104a04:	5e                   	pop    %esi
80104a05:	5f                   	pop    %edi
80104a06:	5d                   	pop    %ebp
80104a07:	c3                   	ret    
80104a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
    iunlockput(ip);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	57                   	push   %edi
    return 0;
80104a14:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a16:	e8 d5 cf ff ff       	call   801019f0 <iunlockput>
    return 0;
80104a1b:	83 c4 10             	add    $0x10,%esp
}
80104a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a21:	89 f8                	mov    %edi,%eax
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5f                   	pop    %edi
80104a26:	5d                   	pop    %ebp
80104a27:	c3                   	ret    
80104a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104a30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104a34:	83 ec 08             	sub    $0x8,%esp
80104a37:	50                   	push   %eax
80104a38:	ff 36                	pushl  (%esi)
80104a3a:	e8 b1 cb ff ff       	call   801015f0 <ialloc>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	89 c7                	mov    %eax,%edi
80104a44:	85 c0                	test   %eax,%eax
80104a46:	0f 84 cd 00 00 00    	je     80104b19 <create+0x189>
  ilock(ip);
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	50                   	push   %eax
80104a50:	e8 0b cd ff ff       	call   80101760 <ilock>
  ip->major = major;
80104a55:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a59:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104a5d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a61:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104a65:	b8 01 00 00 00       	mov    $0x1,%eax
80104a6a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104a6e:	89 3c 24             	mov    %edi,(%esp)
80104a71:	e8 3a cc ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104a76:	83 c4 10             	add    $0x10,%esp
80104a79:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a7e:	74 30                	je     80104ab0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104a80:	83 ec 04             	sub    $0x4,%esp
80104a83:	ff 77 04             	pushl  0x4(%edi)
80104a86:	53                   	push   %ebx
80104a87:	56                   	push   %esi
80104a88:	e8 b3 d4 ff ff       	call   80101f40 <dirlink>
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	85 c0                	test   %eax,%eax
80104a92:	78 78                	js     80104b0c <create+0x17c>
  iunlockput(dp);
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	56                   	push   %esi
80104a98:	e8 53 cf ff ff       	call   801019f0 <iunlockput>
  return ip;
80104a9d:	83 c4 10             	add    $0x10,%esp
}
80104aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa3:	89 f8                	mov    %edi,%eax
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5f                   	pop    %edi
80104aa8:	5d                   	pop    %ebp
80104aa9:	c3                   	ret    
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ab0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ab3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104ab8:	56                   	push   %esi
80104ab9:	e8 f2 cb ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104abe:	83 c4 0c             	add    $0xc,%esp
80104ac1:	ff 77 04             	pushl  0x4(%edi)
80104ac4:	68 7c 77 10 80       	push   $0x8010777c
80104ac9:	57                   	push   %edi
80104aca:	e8 71 d4 ff ff       	call   80101f40 <dirlink>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	78 18                	js     80104aee <create+0x15e>
80104ad6:	83 ec 04             	sub    $0x4,%esp
80104ad9:	ff 76 04             	pushl  0x4(%esi)
80104adc:	68 7b 77 10 80       	push   $0x8010777b
80104ae1:	57                   	push   %edi
80104ae2:	e8 59 d4 ff ff       	call   80101f40 <dirlink>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	79 92                	jns    80104a80 <create+0xf0>
      panic("create dots");
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	68 6f 77 10 80       	push   $0x8010776f
80104af6:	e8 b5 b8 ff ff       	call   801003b0 <panic>
80104afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
}
80104b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b03:	31 ff                	xor    %edi,%edi
}
80104b05:	5b                   	pop    %ebx
80104b06:	89 f8                	mov    %edi,%eax
80104b08:	5e                   	pop    %esi
80104b09:	5f                   	pop    %edi
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
    panic("create: dirlink");
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	68 7e 77 10 80       	push   $0x8010777e
80104b14:	e8 97 b8 ff ff       	call   801003b0 <panic>
    panic("create: ialloc");
80104b19:	83 ec 0c             	sub    $0xc,%esp
80104b1c:	68 60 77 10 80       	push   $0x80107760
80104b21:	e8 8a b8 ff ff       	call   801003b0 <panic>
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi

80104b30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	89 d6                	mov    %edx,%esi
80104b36:	53                   	push   %ebx
80104b37:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b39:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b3f:	50                   	push   %eax
80104b40:	6a 00                	push   $0x0
80104b42:	e8 f9 fc ff ff       	call   80104840 <argint>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	78 2a                	js     80104b78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b52:	77 24                	ja     80104b78 <argfd.constprop.0+0x48>
80104b54:	e8 b7 ed ff ff       	call   80103910 <myproc>
80104b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104b60:	85 c0                	test   %eax,%eax
80104b62:	74 14                	je     80104b78 <argfd.constprop.0+0x48>
  if(pfd)
80104b64:	85 db                	test   %ebx,%ebx
80104b66:	74 02                	je     80104b6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104b68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104b6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104b6c:	31 c0                	xor    %eax,%eax
}
80104b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret    
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7d:	eb ef                	jmp    80104b6e <argfd.constprop.0+0x3e>
80104b7f:	90                   	nop

80104b80 <sys_dup>:
{
80104b80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	56                   	push   %esi
80104b86:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104b87:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b8a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104b8d:	e8 9e ff ff ff       	call   80104b30 <argfd.constprop.0>
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 1a                	js     80104bb0 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104b96:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b99:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104b9b:	e8 70 ed ff ff       	call   80103910 <myproc>
    if(curproc->ofile[fd] == 0){
80104ba0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ba4:	85 d2                	test   %edx,%edx
80104ba6:	74 18                	je     80104bc0 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104ba8:	83 c3 01             	add    $0x1,%ebx
80104bab:	83 fb 10             	cmp    $0x10,%ebx
80104bae:	75 f0                	jne    80104ba0 <sys_dup+0x20>
}
80104bb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104bb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104bb8:	89 d8                	mov    %ebx,%eax
80104bba:	5b                   	pop    %ebx
80104bbb:	5e                   	pop    %esi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104bc0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bca:	e8 c1 c2 ff ff       	call   80100e90 <filedup>
  return fd;
80104bcf:	83 c4 10             	add    $0x10,%esp
}
80104bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd5:	89 d8                	mov    %ebx,%eax
80104bd7:	5b                   	pop    %ebx
80104bd8:	5e                   	pop    %esi
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop

80104be0 <sys_read>:
{
80104be0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 40 ff ff ff       	call   80104b30 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_read+0x60>
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 3e fc ff ff       	call   80104840 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_read+0x60>
80104c09:	83 ec 04             	sub    $0x4,%esp
80104c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 76 fc ff ff       	call   80104890 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_read+0x60>
  return fileread(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 de c3 ff ff       	call   80101010 <fileread>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	c9                   	leave  
    return -1;
80104c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c46:	c3                   	ret    
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <sys_write>:
{
80104c50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c51:	31 c0                	xor    %eax,%eax
{
80104c53:	89 e5                	mov    %esp,%ebp
80104c55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c5b:	e8 d0 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104c60:	85 c0                	test   %eax,%eax
80104c62:	78 4c                	js     80104cb0 <sys_write+0x60>
80104c64:	83 ec 08             	sub    $0x8,%esp
80104c67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c6a:	50                   	push   %eax
80104c6b:	6a 02                	push   $0x2
80104c6d:	e8 ce fb ff ff       	call   80104840 <argint>
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	85 c0                	test   %eax,%eax
80104c77:	78 37                	js     80104cb0 <sys_write+0x60>
80104c79:	83 ec 04             	sub    $0x4,%esp
80104c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c82:	50                   	push   %eax
80104c83:	6a 01                	push   $0x1
80104c85:	e8 06 fc ff ff       	call   80104890 <argptr>
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	85 c0                	test   %eax,%eax
80104c8f:	78 1f                	js     80104cb0 <sys_write+0x60>
  return filewrite(f, p, n);
80104c91:	83 ec 04             	sub    $0x4,%esp
80104c94:	ff 75 f0             	pushl  -0x10(%ebp)
80104c97:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c9d:	e8 fe c3 ff ff       	call   801010a0 <filewrite>
80104ca2:	83 c4 10             	add    $0x10,%esp
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	c9                   	leave  
    return -1;
80104cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb6:	c3                   	ret    
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <sys_close>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104cc6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ccc:	e8 5f fe ff ff       	call   80104b30 <argfd.constprop.0>
80104cd1:	85 c0                	test   %eax,%eax
80104cd3:	78 2b                	js     80104d00 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104cd5:	e8 36 ec ff ff       	call   80103910 <myproc>
80104cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104cdd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ce0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ce7:	00 
  fileclose(f);
80104ce8:	ff 75 f4             	pushl  -0xc(%ebp)
80104ceb:	e8 f0 c1 ff ff       	call   80100ee0 <fileclose>
  return 0;
80104cf0:	83 c4 10             	add    $0x10,%esp
80104cf3:	31 c0                	xor    %eax,%eax
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	c9                   	leave  
    return -1;
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <sys_fstat>:
{
80104d10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d11:	31 c0                	xor    %eax,%eax
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d1b:	e8 10 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 2c                	js     80104d50 <sys_fstat+0x40>
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d2a:	6a 14                	push   $0x14
80104d2c:	50                   	push   %eax
80104d2d:	6a 01                	push   $0x1
80104d2f:	e8 5c fb ff ff       	call   80104890 <argptr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	78 15                	js     80104d50 <sys_fstat+0x40>
  return filestat(f, st);
80104d3b:	83 ec 08             	sub    $0x8,%esp
80104d3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d41:	ff 75 f0             	pushl  -0x10(%ebp)
80104d44:	e8 77 c2 ff ff       	call   80100fc0 <filestat>
80104d49:	83 c4 10             	add    $0x10,%esp
}
80104d4c:	c9                   	leave  
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax
80104d50:	c9                   	leave  
    return -1;
80104d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d56:	c3                   	ret    
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <sys_link>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d65:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104d68:	53                   	push   %ebx
80104d69:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d6c:	50                   	push   %eax
80104d6d:	6a 00                	push   $0x0
80104d6f:	e8 7c fb ff ff       	call   801048f0 <argstr>
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	85 c0                	test   %eax,%eax
80104d79:	0f 88 fb 00 00 00    	js     80104e7a <sys_link+0x11a>
80104d7f:	83 ec 08             	sub    $0x8,%esp
80104d82:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d85:	50                   	push   %eax
80104d86:	6a 01                	push   $0x1
80104d88:	e8 63 fb ff ff       	call   801048f0 <argstr>
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	85 c0                	test   %eax,%eax
80104d92:	0f 88 e2 00 00 00    	js     80104e7a <sys_link+0x11a>
  begin_op();
80104d98:	e8 33 df ff ff       	call   80102cd0 <begin_op>
  if((ip = namei(old)) == 0){
80104d9d:	83 ec 0c             	sub    $0xc,%esp
80104da0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104da3:	e8 58 d2 ff ff       	call   80102000 <namei>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	89 c3                	mov    %eax,%ebx
80104dad:	85 c0                	test   %eax,%eax
80104daf:	0f 84 e4 00 00 00    	je     80104e99 <sys_link+0x139>
  ilock(ip);
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	50                   	push   %eax
80104db9:	e8 a2 c9 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dc6:	0f 84 b5 00 00 00    	je     80104e81 <sys_link+0x121>
  iupdate(ip);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104dcf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104dd4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104dd7:	53                   	push   %ebx
80104dd8:	e8 d3 c8 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80104ddd:	89 1c 24             	mov    %ebx,(%esp)
80104de0:	e8 5b ca ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104de5:	58                   	pop    %eax
80104de6:	5a                   	pop    %edx
80104de7:	57                   	push   %edi
80104de8:	ff 75 d0             	pushl  -0x30(%ebp)
80104deb:	e8 30 d2 ff ff       	call   80102020 <nameiparent>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	89 c6                	mov    %eax,%esi
80104df5:	85 c0                	test   %eax,%eax
80104df7:	74 5b                	je     80104e54 <sys_link+0xf4>
  ilock(dp);
80104df9:	83 ec 0c             	sub    $0xc,%esp
80104dfc:	50                   	push   %eax
80104dfd:	e8 5e c9 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	8b 03                	mov    (%ebx),%eax
80104e07:	39 06                	cmp    %eax,(%esi)
80104e09:	75 3d                	jne    80104e48 <sys_link+0xe8>
80104e0b:	83 ec 04             	sub    $0x4,%esp
80104e0e:	ff 73 04             	pushl  0x4(%ebx)
80104e11:	57                   	push   %edi
80104e12:	56                   	push   %esi
80104e13:	e8 28 d1 ff ff       	call   80101f40 <dirlink>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	78 29                	js     80104e48 <sys_link+0xe8>
  iunlockput(dp);
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	56                   	push   %esi
80104e23:	e8 c8 cb ff ff       	call   801019f0 <iunlockput>
  iput(ip);
80104e28:	89 1c 24             	mov    %ebx,(%esp)
80104e2b:	e8 60 ca ff ff       	call   80101890 <iput>
  end_op();
80104e30:	e8 0b df ff ff       	call   80102d40 <end_op>
  return 0;
80104e35:	83 c4 10             	add    $0x10,%esp
80104e38:	31 c0                	xor    %eax,%eax
}
80104e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5f                   	pop    %edi
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	56                   	push   %esi
80104e4c:	e8 9f cb ff ff       	call   801019f0 <iunlockput>
    goto bad;
80104e51:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 03 c9 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80104e5d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e62:	89 1c 24             	mov    %ebx,(%esp)
80104e65:	e8 46 c8 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80104e6a:	89 1c 24             	mov    %ebx,(%esp)
80104e6d:	e8 7e cb ff ff       	call   801019f0 <iunlockput>
  end_op();
80104e72:	e8 c9 de ff ff       	call   80102d40 <end_op>
  return -1;
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7f:	eb b9                	jmp    80104e3a <sys_link+0xda>
    iunlockput(ip);
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	53                   	push   %ebx
80104e85:	e8 66 cb ff ff       	call   801019f0 <iunlockput>
    end_op();
80104e8a:	e8 b1 de ff ff       	call   80102d40 <end_op>
    return -1;
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e97:	eb a1                	jmp    80104e3a <sys_link+0xda>
    end_op();
80104e99:	e8 a2 de ff ff       	call   80102d40 <end_op>
    return -1;
80104e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea3:	eb 95                	jmp    80104e3a <sys_link+0xda>
80104ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <sys_unlink>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104eb5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104eb8:	53                   	push   %ebx
80104eb9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104ebc:	50                   	push   %eax
80104ebd:	6a 00                	push   $0x0
80104ebf:	e8 2c fa ff ff       	call   801048f0 <argstr>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	0f 88 91 01 00 00    	js     80105060 <sys_unlink+0x1b0>
  begin_op();
80104ecf:	e8 fc dd ff ff       	call   80102cd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ed4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	53                   	push   %ebx
80104edb:	ff 75 c0             	pushl  -0x40(%ebp)
80104ede:	e8 3d d1 ff ff       	call   80102020 <nameiparent>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	89 c6                	mov    %eax,%esi
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	0f 84 7a 01 00 00    	je     8010506a <sys_unlink+0x1ba>
  ilock(dp);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	50                   	push   %eax
80104ef4:	e8 67 c8 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ef9:	58                   	pop    %eax
80104efa:	5a                   	pop    %edx
80104efb:	68 7c 77 10 80       	push   $0x8010777c
80104f00:	53                   	push   %ebx
80104f01:	e8 6a cd ff ff       	call   80101c70 <namecmp>
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	0f 84 0f 01 00 00    	je     80105020 <sys_unlink+0x170>
80104f11:	83 ec 08             	sub    $0x8,%esp
80104f14:	68 7b 77 10 80       	push   $0x8010777b
80104f19:	53                   	push   %ebx
80104f1a:	e8 51 cd ff ff       	call   80101c70 <namecmp>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	0f 84 f6 00 00 00    	je     80105020 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f30:	50                   	push   %eax
80104f31:	53                   	push   %ebx
80104f32:	56                   	push   %esi
80104f33:	e8 58 cd ff ff       	call   80101c90 <dirlookup>
80104f38:	83 c4 10             	add    $0x10,%esp
80104f3b:	89 c3                	mov    %eax,%ebx
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	0f 84 db 00 00 00    	je     80105020 <sys_unlink+0x170>
  ilock(ip);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	50                   	push   %eax
80104f49:	e8 12 c8 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f56:	0f 8e 37 01 00 00    	jle    80105093 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f61:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104f64:	74 6a                	je     80104fd0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104f66:	83 ec 04             	sub    $0x4,%esp
80104f69:	6a 10                	push   $0x10
80104f6b:	6a 00                	push   $0x0
80104f6d:	57                   	push   %edi
80104f6e:	e8 ed f5 ff ff       	call   80104560 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f73:	6a 10                	push   $0x10
80104f75:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f78:	57                   	push   %edi
80104f79:	56                   	push   %esi
80104f7a:	e8 c1 cb ff ff       	call   80101b40 <writei>
80104f7f:	83 c4 20             	add    $0x20,%esp
80104f82:	83 f8 10             	cmp    $0x10,%eax
80104f85:	0f 85 fb 00 00 00    	jne    80105086 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104f8b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f90:	0f 84 aa 00 00 00    	je     80105040 <sys_unlink+0x190>
  iunlockput(dp);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	56                   	push   %esi
80104f9a:	e8 51 ca ff ff       	call   801019f0 <iunlockput>
  ip->nlink--;
80104f9f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fa4:	89 1c 24             	mov    %ebx,(%esp)
80104fa7:	e8 04 c7 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80104fac:	89 1c 24             	mov    %ebx,(%esp)
80104faf:	e8 3c ca ff ff       	call   801019f0 <iunlockput>
  end_op();
80104fb4:	e8 87 dd ff ff       	call   80102d40 <end_op>
  return 0;
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	31 c0                	xor    %eax,%eax
}
80104fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fc1:	5b                   	pop    %ebx
80104fc2:	5e                   	pop    %esi
80104fc3:	5f                   	pop    %edi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fd0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fd4:	76 90                	jbe    80104f66 <sys_unlink+0xb6>
80104fd6:	ba 20 00 00 00       	mov    $0x20,%edx
80104fdb:	eb 0f                	jmp    80104fec <sys_unlink+0x13c>
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	83 c2 10             	add    $0x10,%edx
80104fe3:	39 53 58             	cmp    %edx,0x58(%ebx)
80104fe6:	0f 86 7a ff ff ff    	jbe    80104f66 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fec:	6a 10                	push   $0x10
80104fee:	52                   	push   %edx
80104fef:	57                   	push   %edi
80104ff0:	53                   	push   %ebx
80104ff1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104ff4:	e8 47 ca ff ff       	call   80101a40 <readi>
80104ff9:	83 c4 10             	add    $0x10,%esp
80104ffc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80104fff:	83 f8 10             	cmp    $0x10,%eax
80105002:	75 75                	jne    80105079 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105004:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105009:	74 d5                	je     80104fe0 <sys_unlink+0x130>
    iunlockput(ip);
8010500b:	83 ec 0c             	sub    $0xc,%esp
8010500e:	53                   	push   %ebx
8010500f:	e8 dc c9 ff ff       	call   801019f0 <iunlockput>
    goto bad;
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	56                   	push   %esi
80105024:	e8 c7 c9 ff ff       	call   801019f0 <iunlockput>
  end_op();
80105029:	e8 12 dd ff ff       	call   80102d40 <end_op>
  return -1;
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105036:	eb 86                	jmp    80104fbe <sys_unlink+0x10e>
80105038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503f:	90                   	nop
    iupdate(dp);
80105040:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105043:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105048:	56                   	push   %esi
80105049:	e8 62 c6 ff ff       	call   801016b0 <iupdate>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	e9 40 ff ff ff       	jmp    80104f96 <sys_unlink+0xe6>
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	e9 54 ff ff ff       	jmp    80104fbe <sys_unlink+0x10e>
    end_op();
8010506a:	e8 d1 dc ff ff       	call   80102d40 <end_op>
    return -1;
8010506f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105074:	e9 45 ff ff ff       	jmp    80104fbe <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105079:	83 ec 0c             	sub    $0xc,%esp
8010507c:	68 a0 77 10 80       	push   $0x801077a0
80105081:	e8 2a b3 ff ff       	call   801003b0 <panic>
    panic("unlink: writei");
80105086:	83 ec 0c             	sub    $0xc,%esp
80105089:	68 b2 77 10 80       	push   $0x801077b2
8010508e:	e8 1d b3 ff ff       	call   801003b0 <panic>
    panic("unlink: nlink < 1");
80105093:	83 ec 0c             	sub    $0xc,%esp
80105096:	68 8e 77 10 80       	push   $0x8010778e
8010509b:	e8 10 b3 ff ff       	call   801003b0 <panic>

801050a0 <sys_open>:

int
sys_open(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 3c f8 ff ff       	call   801048f0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 8e 00 00 00    	js     8010514d <sys_open+0xad>
801050bf:	83 ec 08             	sub    $0x8,%esp
801050c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 73 f7 ff ff       	call   80104840 <argint>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 79                	js     8010514d <sys_open+0xad>
    return -1;

  begin_op();
801050d4:	e8 f7 db ff ff       	call   80102cd0 <begin_op>

  if(omode & O_CREATE){
801050d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050dd:	75 79                	jne    80105158 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050df:	83 ec 0c             	sub    $0xc,%esp
801050e2:	ff 75 e0             	pushl  -0x20(%ebp)
801050e5:	e8 16 cf ff ff       	call   80102000 <namei>
801050ea:	83 c4 10             	add    $0x10,%esp
801050ed:	89 c6                	mov    %eax,%esi
801050ef:	85 c0                	test   %eax,%eax
801050f1:	0f 84 7e 00 00 00    	je     80105175 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	50                   	push   %eax
801050fb:	e8 60 c6 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105108:	0f 84 c2 00 00 00    	je     801051d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010510e:	e8 0d bd ff ff       	call   80100e20 <filealloc>
80105113:	89 c7                	mov    %eax,%edi
80105115:	85 c0                	test   %eax,%eax
80105117:	74 23                	je     8010513c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105119:	e8 f2 e7 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010511e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	74 60                	je     80105188 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_open+0x80>
    if(f)
      fileclose(f);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	57                   	push   %edi
80105134:	e8 a7 bd ff ff       	call   80100ee0 <fileclose>
80105139:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	56                   	push   %esi
80105140:	e8 ab c8 ff ff       	call   801019f0 <iunlockput>
    end_op();
80105145:	e8 f6 db ff ff       	call   80102d40 <end_op>
    return -1;
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105152:	eb 6d                	jmp    801051c1 <sys_open+0x121>
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010515e:	31 c9                	xor    %ecx,%ecx
80105160:	ba 02 00 00 00       	mov    $0x2,%edx
80105165:	6a 00                	push   $0x0
80105167:	e8 24 f8 ff ff       	call   80104990 <create>
    if(ip == 0){
8010516c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010516f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105171:	85 c0                	test   %eax,%eax
80105173:	75 99                	jne    8010510e <sys_open+0x6e>
      end_op();
80105175:	e8 c6 db ff ff       	call   80102d40 <end_op>
      return -1;
8010517a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010517f:	eb 40                	jmp    801051c1 <sys_open+0x121>
80105181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105188:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010518b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010518f:	56                   	push   %esi
80105190:	e8 ab c6 ff ff       	call   80101840 <iunlock>
  end_op();
80105195:	e8 a6 db ff ff       	call   80102d40 <end_op>

  f->type = FD_INODE;
8010519a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801051a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801051ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051b2:	f7 d0                	not    %eax
801051b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801051ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801051c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c4:	89 d8                	mov    %ebx,%eax
801051c6:	5b                   	pop    %ebx
801051c7:	5e                   	pop    %esi
801051c8:	5f                   	pop    %edi
801051c9:	5d                   	pop    %ebp
801051ca:	c3                   	ret    
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801051d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051d3:	85 c9                	test   %ecx,%ecx
801051d5:	0f 84 33 ff ff ff    	je     8010510e <sys_open+0x6e>
801051db:	e9 5c ff ff ff       	jmp    8010513c <sys_open+0x9c>

801051e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051e6:	e8 e5 da ff ff       	call   80102cd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051eb:	83 ec 08             	sub    $0x8,%esp
801051ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 f7 f6 ff ff       	call   801048f0 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 30                	js     80105230 <sys_mkdir+0x50>
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105206:	31 c9                	xor    %ecx,%ecx
80105208:	ba 01 00 00 00       	mov    $0x1,%edx
8010520d:	6a 00                	push   $0x0
8010520f:	e8 7c f7 ff ff       	call   80104990 <create>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	74 15                	je     80105230 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	50                   	push   %eax
8010521f:	e8 cc c7 ff ff       	call   801019f0 <iunlockput>
  end_op();
80105224:	e8 17 db ff ff       	call   80102d40 <end_op>
  return 0;
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	31 c0                	xor    %eax,%eax
}
8010522e:	c9                   	leave  
8010522f:	c3                   	ret    
    end_op();
80105230:	e8 0b db ff ff       	call   80102d40 <end_op>
    return -1;
80105235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523a:	c9                   	leave  
8010523b:	c3                   	ret    
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_mknod>:

int
sys_mknod(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105246:	e8 85 da ff ff       	call   80102cd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010524b:	83 ec 08             	sub    $0x8,%esp
8010524e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105251:	50                   	push   %eax
80105252:	6a 00                	push   $0x0
80105254:	e8 97 f6 ff ff       	call   801048f0 <argstr>
80105259:	83 c4 10             	add    $0x10,%esp
8010525c:	85 c0                	test   %eax,%eax
8010525e:	78 60                	js     801052c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105260:	83 ec 08             	sub    $0x8,%esp
80105263:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105266:	50                   	push   %eax
80105267:	6a 01                	push   $0x1
80105269:	e8 d2 f5 ff ff       	call   80104840 <argint>
  if((argstr(0, &path)) < 0 ||
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	85 c0                	test   %eax,%eax
80105273:	78 4b                	js     801052c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010527b:	50                   	push   %eax
8010527c:	6a 02                	push   $0x2
8010527e:	e8 bd f5 ff ff       	call   80104840 <argint>
     argint(1, &major) < 0 ||
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 36                	js     801052c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010528a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105295:	ba 03 00 00 00       	mov    $0x3,%edx
8010529a:	50                   	push   %eax
8010529b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010529e:	e8 ed f6 ff ff       	call   80104990 <create>
     argint(2, &minor) < 0 ||
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	74 16                	je     801052c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	50                   	push   %eax
801052ae:	e8 3d c7 ff ff       	call   801019f0 <iunlockput>
  end_op();
801052b3:	e8 88 da ff ff       	call   80102d40 <end_op>
  return 0;
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	31 c0                	xor    %eax,%eax
}
801052bd:	c9                   	leave  
801052be:	c3                   	ret    
801052bf:	90                   	nop
    end_op();
801052c0:	e8 7b da ff ff       	call   80102d40 <end_op>
    return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ca:	c9                   	leave  
801052cb:	c3                   	ret    
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_chdir>:

int
sys_chdir(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052d8:	e8 33 e6 ff ff       	call   80103910 <myproc>
801052dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052df:	e8 ec d9 ff ff       	call   80102cd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052e4:	83 ec 08             	sub    $0x8,%esp
801052e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ea:	50                   	push   %eax
801052eb:	6a 00                	push   $0x0
801052ed:	e8 fe f5 ff ff       	call   801048f0 <argstr>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 77                	js     80105370 <sys_chdir+0xa0>
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	ff 75 f4             	pushl  -0xc(%ebp)
801052ff:	e8 fc cc ff ff       	call   80102000 <namei>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	89 c3                	mov    %eax,%ebx
80105309:	85 c0                	test   %eax,%eax
8010530b:	74 63                	je     80105370 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	50                   	push   %eax
80105311:	e8 4a c4 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010531e:	75 30                	jne    80105350 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	53                   	push   %ebx
80105324:	e8 17 c5 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105329:	58                   	pop    %eax
8010532a:	ff 76 68             	pushl  0x68(%esi)
8010532d:	e8 5e c5 ff ff       	call   80101890 <iput>
  end_op();
80105332:	e8 09 da ff ff       	call   80102d40 <end_op>
  curproc->cwd = ip;
80105337:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	31 c0                	xor    %eax,%eax
}
8010533f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5d                   	pop    %ebp
80105345:	c3                   	ret    
80105346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	53                   	push   %ebx
80105354:	e8 97 c6 ff ff       	call   801019f0 <iunlockput>
    end_op();
80105359:	e8 e2 d9 ff ff       	call   80102d40 <end_op>
    return -1;
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105366:	eb d7                	jmp    8010533f <sys_chdir+0x6f>
80105368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536f:	90                   	nop
    end_op();
80105370:	e8 cb d9 ff ff       	call   80102d40 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537a:	eb c3                	jmp    8010533f <sys_chdir+0x6f>
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_exec>:

int
sys_exec(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105385:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010538b:	53                   	push   %ebx
8010538c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105392:	50                   	push   %eax
80105393:	6a 00                	push   $0x0
80105395:	e8 56 f5 ff ff       	call   801048f0 <argstr>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 88 87 00 00 00    	js     8010542c <sys_exec+0xac>
801053a5:	83 ec 08             	sub    $0x8,%esp
801053a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053ae:	50                   	push   %eax
801053af:	6a 01                	push   $0x1
801053b1:	e8 8a f4 ff ff       	call   80104840 <argint>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 6f                	js     8010542c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053bd:	83 ec 04             	sub    $0x4,%esp
801053c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801053c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801053c8:	68 80 00 00 00       	push   $0x80
801053cd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053d3:	6a 00                	push   $0x0
801053d5:	50                   	push   %eax
801053d6:	e8 85 f1 ff ff       	call   80104560 <memset>
801053db:	83 c4 10             	add    $0x10,%esp
801053de:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053e6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801053ed:	83 ec 08             	sub    $0x8,%esp
801053f0:	57                   	push   %edi
801053f1:	01 f0                	add    %esi,%eax
801053f3:	50                   	push   %eax
801053f4:	e8 a7 f3 ff ff       	call   801047a0 <fetchint>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	78 2c                	js     8010542c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105400:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105406:	85 c0                	test   %eax,%eax
80105408:	74 36                	je     80105440 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010540a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105416:	52                   	push   %edx
80105417:	50                   	push   %eax
80105418:	e8 c3 f3 ff ff       	call   801047e0 <fetchstr>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 08                	js     8010542c <sys_exec+0xac>
  for(i=0;; i++){
80105424:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105427:	83 fb 20             	cmp    $0x20,%ebx
8010542a:	75 b4                	jne    801053e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010542c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010542f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105434:	5b                   	pop    %ebx
80105435:	5e                   	pop    %esi
80105436:	5f                   	pop    %edi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105449:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105450:	00 00 00 00 
  return exec(path, argv);
80105454:	50                   	push   %eax
80105455:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010545b:	e8 40 b6 ff ff       	call   80100aa0 <exec>
80105460:	83 c4 10             	add    $0x10,%esp
}
80105463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_pipe>:

int
sys_pipe(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105475:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105478:	53                   	push   %ebx
80105479:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010547c:	6a 08                	push   $0x8
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 0a f4 ff ff       	call   80104890 <argptr>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 4a                	js     801054d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010548d:	83 ec 08             	sub    $0x8,%esp
80105490:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105493:	50                   	push   %eax
80105494:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105497:	50                   	push   %eax
80105498:	e8 e3 de ff ff       	call   80103380 <pipealloc>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 33                	js     801054d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054a9:	e8 62 e4 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054b4:	85 f6                	test   %esi,%esi
801054b6:	74 28                	je     801054e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c3 01             	add    $0x1,%ebx
801054bb:	83 fb 10             	cmp    $0x10,%ebx
801054be:	75 f0                	jne    801054b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	ff 75 e0             	pushl  -0x20(%ebp)
801054c6:	e8 15 ba ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
801054cb:	58                   	pop    %eax
801054cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801054cf:	e8 0c ba ff ff       	call   80100ee0 <fileclose>
    return -1;
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dc:	eb 53                	jmp    80105531 <sys_pipe+0xc1>
801054de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801054e0:	8d 73 08             	lea    0x8(%ebx),%esi
801054e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054ea:	e8 21 e4 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ef:	31 d2                	xor    %edx,%edx
801054f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054fc:	85 c9                	test   %ecx,%ecx
801054fe:	74 20                	je     80105520 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105500:	83 c2 01             	add    $0x1,%edx
80105503:	83 fa 10             	cmp    $0x10,%edx
80105506:	75 f0                	jne    801054f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105508:	e8 03 e4 ff ff       	call   80103910 <myproc>
8010550d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105514:	00 
80105515:	eb a9                	jmp    801054c0 <sys_pipe+0x50>
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105520:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105524:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105527:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105529:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010552c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010552f:	31 c0                	xor    %eax,%eax
}
80105531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105534:	5b                   	pop    %ebx
80105535:	5e                   	pop    %esi
80105536:	5f                   	pop    %edi
80105537:	5d                   	pop    %ebp
80105538:	c3                   	ret    
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_bstat>:
 */
int
sys_bstat(void)
{
	return numallocblocks;
}
80105540:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
80105545:	c3                   	ret    
80105546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554d:	8d 76 00             	lea    0x0(%esi),%esi

80105550 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int*)&addr) < 0)
80105556:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105559:	50                   	push   %eax
8010555a:	6a 00                	push   $0x0
8010555c:	e8 df f2 ff ff       	call   80104840 <argint>
    return -1;
  // swap addr
  return 0;
}
80105561:	c9                   	leave  
  if(argint(0, (int*)&addr) < 0)
80105562:	c1 f8 1f             	sar    $0x1f,%eax
}
80105565:	c3                   	ret    
80105566:	66 90                	xchg   %ax,%ax
80105568:	66 90                	xchg   %ax,%ax
8010556a:	66 90                	xchg   %ax,%ax
8010556c:	66 90                	xchg   %ax,%ax
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105570:	e9 0b e5 ff ff       	jmp    80103a80 <fork>
80105575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exit>:
}

int
sys_exit(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  exit();
80105586:	e8 75 e7 ff ff       	call   80103d00 <exit>
  return 0;  // not reached
}
8010558b:	31 c0                	xor    %eax,%eax
8010558d:	c9                   	leave  
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105590:	e9 ab e9 ff ff       	jmp    80103f40 <wait>
80105595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_kill>:
}

int
sys_kill(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a9:	50                   	push   %eax
801055aa:	6a 00                	push   $0x0
801055ac:	e8 8f f2 ff ff       	call   80104840 <argint>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	85 c0                	test   %eax,%eax
801055b6:	78 18                	js     801055d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	ff 75 f4             	pushl  -0xc(%ebp)
801055be:	e8 dd ea ff ff       	call   801040a0 <kill>
801055c3:	83 c4 10             	add    $0x10,%esp
}
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    
801055c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
801055d0:	c9                   	leave  
    return -1;
801055d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d6:	c3                   	ret    
801055d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055de:	66 90                	xchg   %ax,%ax

801055e0 <sys_getpid>:

int
sys_getpid(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801055e6:	e8 25 e3 ff ff       	call   80103910 <myproc>
801055eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801055ee:	c9                   	leave  
801055ef:	c3                   	ret    

801055f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 3e f2 ff ff       	call   80104840 <argint>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 27                	js     80105630 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105609:	e8 02 e3 ff ff       	call   80103910 <myproc>
  if(growproc(n) < 0)
8010560e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105611:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105613:	ff 75 f4             	pushl  -0xc(%ebp)
80105616:	e8 15 e4 ff ff       	call   80103a30 <growproc>
8010561b:	83 c4 10             	add    $0x10,%esp
8010561e:	85 c0                	test   %eax,%eax
80105620:	78 0e                	js     80105630 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105622:	89 d8                	mov    %ebx,%eax
80105624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105627:	c9                   	leave  
80105628:	c3                   	ret    
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105630:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105635:	eb eb                	jmp    80105622 <sys_sbrk+0x32>
80105637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563e:	66 90                	xchg   %ax,%ax

80105640 <sys_sleep>:

int
sys_sleep(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105644:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105647:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010564a:	50                   	push   %eax
8010564b:	6a 00                	push   $0x0
8010564d:	e8 ee f1 ff ff       	call   80104840 <argint>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 88 8a 00 00 00    	js     801056e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	68 60 4c 11 80       	push   $0x80114c60
80105665:	e8 86 ed ff ff       	call   801043f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010566a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010566d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 d2                	test   %edx,%edx
80105678:	75 27                	jne    801056a1 <sys_sleep+0x61>
8010567a:	eb 54                	jmp    801056d0 <sys_sleep+0x90>
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	68 60 4c 11 80       	push   $0x80114c60
80105688:	68 a0 54 11 80       	push   $0x801154a0
8010568d:	e8 ee e7 ff ff       	call   80103e80 <sleep>
  while(ticks - ticks0 < n){
80105692:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	29 d8                	sub    %ebx,%eax
8010569c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010569f:	73 2f                	jae    801056d0 <sys_sleep+0x90>
    if(myproc()->killed){
801056a1:	e8 6a e2 ff ff       	call   80103910 <myproc>
801056a6:	8b 40 24             	mov    0x24(%eax),%eax
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 d3                	je     80105680 <sys_sleep+0x40>
      release(&tickslock);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	68 60 4c 11 80       	push   $0x80114c60
801056b5:	e8 56 ee ff ff       	call   80104510 <release>
      return -1;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 60 4c 11 80       	push   $0x80114c60
801056d8:	e8 33 ee ff ff       	call   80104510 <release>
  return 0;
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	31 c0                	xor    %eax,%eax
}
801056e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
    return -1;
801056e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ec:	eb f4                	jmp    801056e2 <sys_sleep+0xa2>
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	53                   	push   %ebx
801056f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056f7:	68 60 4c 11 80       	push   $0x80114c60
801056fc:	e8 ef ec ff ff       	call   801043f0 <acquire>
  xticks = ticks;
80105701:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105707:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010570e:	e8 fd ed ff ff       	call   80104510 <release>
  return xticks;
}
80105713:	89 d8                	mov    %ebx,%eax
80105715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105718:	c9                   	leave  
80105719:	c3                   	ret    

8010571a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010571a:	1e                   	push   %ds
  pushl %es
8010571b:	06                   	push   %es
  pushl %fs
8010571c:	0f a0                	push   %fs
  pushl %gs
8010571e:	0f a8                	push   %gs
  pushal
80105720:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105721:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105725:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105727:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105729:	54                   	push   %esp
  call trap
8010572a:	e8 c1 00 00 00       	call   801057f0 <trap>
  addl $4, %esp
8010572f:	83 c4 04             	add    $0x4,%esp

80105732 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105732:	61                   	popa   
  popl %gs
80105733:	0f a9                	pop    %gs
  popl %fs
80105735:	0f a1                	pop    %fs
  popl %es
80105737:	07                   	pop    %es
  popl %ds
80105738:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105739:	83 c4 08             	add    $0x8,%esp
  iret
8010573c:	cf                   	iret   
8010573d:	66 90                	xchg   %ax,%ax
8010573f:	90                   	nop

80105740 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105740:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105741:	31 c0                	xor    %eax,%eax
{
80105743:	89 e5                	mov    %esp,%ebp
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105750:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105757:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010575e:	08 00 00 8e 
80105762:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105769:	80 
8010576a:	c1 ea 10             	shr    $0x10,%edx
8010576d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105774:	80 
  for(i = 0; i < 256; i++)
80105775:	83 c0 01             	add    $0x1,%eax
80105778:	3d 00 01 00 00       	cmp    $0x100,%eax
8010577d:	75 d1                	jne    80105750 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010577f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105782:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105787:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010578e:	00 00 ef 
  initlock(&tickslock, "time");
80105791:	68 c1 77 10 80       	push   $0x801077c1
80105796:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010579b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801057a1:	c1 e8 10             	shr    $0x10,%eax
801057a4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801057aa:	e8 41 eb ff ff       	call   801042f0 <initlock>
}
801057af:	83 c4 10             	add    $0x10,%esp
801057b2:	c9                   	leave  
801057b3:	c3                   	ret    
801057b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop

801057c0 <idtinit>:

void
idtinit(void)
{
801057c0:	55                   	push   %ebp
  pd[0] = size-1;
801057c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057c6:	89 e5                	mov    %esp,%ebp
801057c8:	83 ec 10             	sub    $0x10,%esp
801057cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057cf:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801057d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057d8:	c1 e8 10             	shr    $0x10,%eax
801057db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801057df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
801057f6:	83 ec 1c             	sub    $0x1c,%esp
801057f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801057fc:	8b 47 30             	mov    0x30(%edi),%eax
801057ff:	83 f8 40             	cmp    $0x40,%eax
80105802:	0f 84 d0 01 00 00    	je     801059d8 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105808:	83 e8 0e             	sub    $0xe,%eax
8010580b:	83 f8 31             	cmp    $0x31,%eax
8010580e:	77 10                	ja     80105820 <trap+0x30>
80105810:	ff 24 85 68 78 10 80 	jmp    *-0x7fef8798(,%eax,4)
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105820:	e8 eb e0 ff ff       	call   80103910 <myproc>
80105825:	8b 5f 38             	mov    0x38(%edi),%ebx
80105828:	85 c0                	test   %eax,%eax
8010582a:	0f 84 34 02 00 00    	je     80105a64 <trap+0x274>
80105830:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105834:	0f 84 2a 02 00 00    	je     80105a64 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010583a:	0f 20 d1             	mov    %cr2,%ecx
8010583d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105840:	e8 ab e0 ff ff       	call   801038f0 <cpuid>
80105845:	8b 77 30             	mov    0x30(%edi),%esi
80105848:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010584b:	8b 47 34             	mov    0x34(%edi),%eax
8010584e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105851:	e8 ba e0 ff ff       	call   80103910 <myproc>
80105856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105859:	e8 b2 e0 ff ff       	call   80103910 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010585e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105861:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105864:	51                   	push   %ecx
80105865:	53                   	push   %ebx
80105866:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105867:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010586a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010586d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105870:	56                   	push   %esi
80105871:	52                   	push   %edx
80105872:	ff 70 10             	pushl  0x10(%eax)
80105875:	68 24 78 10 80       	push   $0x80107824
8010587a:	e8 51 ae ff ff       	call   801006d0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010587f:	83 c4 20             	add    $0x20,%esp
80105882:	e8 89 e0 ff ff       	call   80103910 <myproc>
80105887:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010588e:	e8 7d e0 ff ff       	call   80103910 <myproc>
80105893:	85 c0                	test   %eax,%eax
80105895:	74 1d                	je     801058b4 <trap+0xc4>
80105897:	e8 74 e0 ff ff       	call   80103910 <myproc>
8010589c:	8b 50 24             	mov    0x24(%eax),%edx
8010589f:	85 d2                	test   %edx,%edx
801058a1:	74 11                	je     801058b4 <trap+0xc4>
801058a3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058a7:	83 e0 03             	and    $0x3,%eax
801058aa:	66 83 f8 03          	cmp    $0x3,%ax
801058ae:	0f 84 5c 01 00 00    	je     80105a10 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058b4:	e8 57 e0 ff ff       	call   80103910 <myproc>
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 0b                	je     801058c8 <trap+0xd8>
801058bd:	e8 4e e0 ff ff       	call   80103910 <myproc>
801058c2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058c6:	74 38                	je     80105900 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058c8:	e8 43 e0 ff ff       	call   80103910 <myproc>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	74 1d                	je     801058ee <trap+0xfe>
801058d1:	e8 3a e0 ff ff       	call   80103910 <myproc>
801058d6:	8b 40 24             	mov    0x24(%eax),%eax
801058d9:	85 c0                	test   %eax,%eax
801058db:	74 11                	je     801058ee <trap+0xfe>
801058dd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058e1:	83 e0 03             	and    $0x3,%eax
801058e4:	66 83 f8 03          	cmp    $0x3,%ax
801058e8:	0f 84 13 01 00 00    	je     80105a01 <trap+0x211>
    exit();
}
801058ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f1:	5b                   	pop    %ebx
801058f2:	5e                   	pop    %esi
801058f3:	5f                   	pop    %edi
801058f4:	5d                   	pop    %ebp
801058f5:	c3                   	ret    
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105900:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105904:	75 c2                	jne    801058c8 <trap+0xd8>
    yield();
80105906:	e8 25 e5 ff ff       	call   80103e30 <yield>
8010590b:	eb bb                	jmp    801058c8 <trap+0xd8>
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
  	handle_pgfault();
80105910:	e8 ab 01 00 00       	call   80105ac0 <handle_pgfault>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105915:	e8 f6 df ff ff       	call   80103910 <myproc>
8010591a:	85 c0                	test   %eax,%eax
8010591c:	0f 85 75 ff ff ff    	jne    80105897 <trap+0xa7>
80105922:	eb 90                	jmp    801058b4 <trap+0xc4>
80105924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105928:	e8 c3 df ff ff       	call   801038f0 <cpuid>
8010592d:	85 c0                	test   %eax,%eax
8010592f:	0f 84 fb 00 00 00    	je     80105a30 <trap+0x240>
    lapiceoi();
80105935:	e8 46 cf ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010593a:	e8 d1 df ff ff       	call   80103910 <myproc>
8010593f:	85 c0                	test   %eax,%eax
80105941:	0f 85 50 ff ff ff    	jne    80105897 <trap+0xa7>
80105947:	e9 68 ff ff ff       	jmp    801058b4 <trap+0xc4>
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105950:	e8 eb cd ff ff       	call   80102740 <kbdintr>
    lapiceoi();
80105955:	e8 26 cf ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010595a:	e8 b1 df ff ff       	call   80103910 <myproc>
8010595f:	85 c0                	test   %eax,%eax
80105961:	0f 85 30 ff ff ff    	jne    80105897 <trap+0xa7>
80105967:	e9 48 ff ff ff       	jmp    801058b4 <trap+0xc4>
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105970:	e8 db 02 00 00       	call   80105c50 <uartintr>
    lapiceoi();
80105975:	e8 06 cf ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010597a:	e8 91 df ff ff       	call   80103910 <myproc>
8010597f:	85 c0                	test   %eax,%eax
80105981:	0f 85 10 ff ff ff    	jne    80105897 <trap+0xa7>
80105987:	e9 28 ff ff ff       	jmp    801058b4 <trap+0xc4>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105990:	8b 77 38             	mov    0x38(%edi),%esi
80105993:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105997:	e8 54 df ff ff       	call   801038f0 <cpuid>
8010599c:	56                   	push   %esi
8010599d:	53                   	push   %ebx
8010599e:	50                   	push   %eax
8010599f:	68 cc 77 10 80       	push   $0x801077cc
801059a4:	e8 27 ad ff ff       	call   801006d0 <cprintf>
    lapiceoi();
801059a9:	e8 d2 ce ff ff       	call   80102880 <lapiceoi>
    break;
801059ae:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b1:	e8 5a df ff ff       	call   80103910 <myproc>
801059b6:	85 c0                	test   %eax,%eax
801059b8:	0f 85 d9 fe ff ff    	jne    80105897 <trap+0xa7>
801059be:	e9 f1 fe ff ff       	jmp    801058b4 <trap+0xc4>
801059c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059c7:	90                   	nop
    ideintr();
801059c8:	e8 c3 c7 ff ff       	call   80102190 <ideintr>
801059cd:	e9 63 ff ff ff       	jmp    80105935 <trap+0x145>
801059d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801059d8:	e8 33 df ff ff       	call   80103910 <myproc>
801059dd:	8b 58 24             	mov    0x24(%eax),%ebx
801059e0:	85 db                	test   %ebx,%ebx
801059e2:	75 3c                	jne    80105a20 <trap+0x230>
    myproc()->tf = tf;
801059e4:	e8 27 df ff ff       	call   80103910 <myproc>
801059e9:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059ec:	e8 3f ef ff ff       	call   80104930 <syscall>
    if(myproc()->killed)
801059f1:	e8 1a df ff ff       	call   80103910 <myproc>
801059f6:	8b 48 24             	mov    0x24(%eax),%ecx
801059f9:	85 c9                	test   %ecx,%ecx
801059fb:	0f 84 ed fe ff ff    	je     801058ee <trap+0xfe>
}
80105a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a04:	5b                   	pop    %ebx
80105a05:	5e                   	pop    %esi
80105a06:	5f                   	pop    %edi
80105a07:	5d                   	pop    %ebp
      exit();
80105a08:	e9 f3 e2 ff ff       	jmp    80103d00 <exit>
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a10:	e8 eb e2 ff ff       	call   80103d00 <exit>
80105a15:	e9 9a fe ff ff       	jmp    801058b4 <trap+0xc4>
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105a20:	e8 db e2 ff ff       	call   80103d00 <exit>
80105a25:	eb bd                	jmp    801059e4 <trap+0x1f4>
80105a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2e:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	68 60 4c 11 80       	push   $0x80114c60
80105a38:	e8 b3 e9 ff ff       	call   801043f0 <acquire>
      wakeup(&ticks);
80105a3d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a44:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a4b:	e8 f0 e5 ff ff       	call   80104040 <wakeup>
      release(&tickslock);
80105a50:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a57:	e8 b4 ea ff ff       	call   80104510 <release>
80105a5c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a5f:	e9 d1 fe ff ff       	jmp    80105935 <trap+0x145>
80105a64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a67:	e8 84 de ff ff       	call   801038f0 <cpuid>
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	56                   	push   %esi
80105a70:	53                   	push   %ebx
80105a71:	50                   	push   %eax
80105a72:	ff 77 30             	pushl  0x30(%edi)
80105a75:	68 f0 77 10 80       	push   $0x801077f0
80105a7a:	e8 51 ac ff ff       	call   801006d0 <cprintf>
      panic("trap");
80105a7f:	83 c4 14             	add    $0x14,%esp
80105a82:	68 c6 77 10 80       	push   $0x801077c6
80105a87:	e8 24 a9 ff ff       	call   801003b0 <panic>
80105a8c:	66 90                	xchg   %ax,%ax
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <swap_page_from_pte>:
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{
}
80105a90:	c3                   	ret    
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop

80105aa0 <swap_page>:

/* Select a victim and swap the contents to the disk.
 */
int
swap_page(pde_t *pgdir)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 14             	sub    $0x14,%esp
	panic("swap_page is not implemented");
80105aa6:	68 30 79 10 80       	push   $0x80107930
80105aab:	e8 00 a9 ff ff       	call   801003b0 <panic>

80105ab0 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 14             	sub    $0x14,%esp
	panic("map_address is not implemented");
80105ab6:	68 50 79 10 80       	push   $0x80107950
80105abb:	e8 f0 a8 ff ff       	call   801003b0 <panic>

80105ac0 <handle_pgfault>:
}

/* page fault handler */
void
handle_pgfault()
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105ac6:	e8 45 de ff ff       	call   80103910 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105acb:	0f 20 d0             	mov    %cr2,%eax
	panic("map_address is not implemented");
80105ace:	83 ec 0c             	sub    $0xc,%esp
80105ad1:	68 50 79 10 80       	push   $0x80107950
80105ad6:	e8 d5 a8 ff ff       	call   801003b0 <panic>
80105adb:	66 90                	xchg   %ax,%ax
80105add:	66 90                	xchg   %ax,%ax
80105adf:	90                   	nop

80105ae0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ae0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	74 17                	je     80105b00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ae9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105aef:	a8 01                	test   $0x1,%al
80105af1:	74 0d                	je     80105b00 <uartgetc+0x20>
80105af3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105af8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105af9:	0f b6 c0             	movzbl %al,%eax
80105afc:	c3                   	ret    
80105afd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <uartputc.part.0>:
uartputc(int c)
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	89 c7                	mov    %eax,%edi
80105b16:	56                   	push   %esi
80105b17:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b1c:	53                   	push   %ebx
80105b1d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b22:	83 ec 0c             	sub    $0xc,%esp
80105b25:	eb 1b                	jmp    80105b42 <uartputc.part.0+0x32>
80105b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	6a 0a                	push   $0xa
80105b35:	e8 66 cd ff ff       	call   801028a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	83 eb 01             	sub    $0x1,%ebx
80105b40:	74 07                	je     80105b49 <uartputc.part.0+0x39>
80105b42:	89 f2                	mov    %esi,%edx
80105b44:	ec                   	in     (%dx),%al
80105b45:	a8 20                	test   $0x20,%al
80105b47:	74 e7                	je     80105b30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4e:	89 f8                	mov    %edi,%eax
80105b50:	ee                   	out    %al,(%dx)
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	5b                   	pop    %ebx
80105b55:	5e                   	pop    %esi
80105b56:	5f                   	pop    %edi
80105b57:	5d                   	pop    %ebp
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <uartinit>:
{
80105b60:	55                   	push   %ebp
80105b61:	31 c9                	xor    %ecx,%ecx
80105b63:	89 c8                	mov    %ecx,%eax
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	57                   	push   %edi
80105b68:	56                   	push   %esi
80105b69:	53                   	push   %ebx
80105b6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b6f:	89 da                	mov    %ebx,%edx
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	ee                   	out    %al,(%dx)
80105b75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b7f:	89 fa                	mov    %edi,%edx
80105b81:	ee                   	out    %al,(%dx)
80105b82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b8c:	ee                   	out    %al,(%dx)
80105b8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b92:	89 c8                	mov    %ecx,%eax
80105b94:	89 f2                	mov    %esi,%edx
80105b96:	ee                   	out    %al,(%dx)
80105b97:	b8 03 00 00 00       	mov    $0x3,%eax
80105b9c:	89 fa                	mov    %edi,%edx
80105b9e:	ee                   	out    %al,(%dx)
80105b9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ba4:	89 c8                	mov    %ecx,%eax
80105ba6:	ee                   	out    %al,(%dx)
80105ba7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bac:	89 f2                	mov    %esi,%edx
80105bae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105baf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105bb5:	3c ff                	cmp    $0xff,%al
80105bb7:	74 56                	je     80105c0f <uartinit+0xaf>
  uart = 1;
80105bb9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105bc0:	00 00 00 
80105bc3:	89 da                	mov    %ebx,%edx
80105bc5:	ec                   	in     (%dx),%al
80105bc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bcb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105bcc:	83 ec 08             	sub    $0x8,%esp
80105bcf:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105bd4:	bb 6f 79 10 80       	mov    $0x8010796f,%ebx
  ioapicenable(IRQ_COM1, 0);
80105bd9:	6a 00                	push   $0x0
80105bdb:	6a 04                	push   $0x4
80105bdd:	e8 fe c7 ff ff       	call   801023e0 <ioapicenable>
80105be2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105be5:	b8 78 00 00 00       	mov    $0x78,%eax
80105bea:	eb 08                	jmp    80105bf4 <uartinit+0x94>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bf0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bf4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bfa:	85 d2                	test   %edx,%edx
80105bfc:	74 08                	je     80105c06 <uartinit+0xa6>
    uartputc(*p);
80105bfe:	0f be c0             	movsbl %al,%eax
80105c01:	e8 0a ff ff ff       	call   80105b10 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105c06:	89 f0                	mov    %esi,%eax
80105c08:	83 c3 01             	add    $0x1,%ebx
80105c0b:	84 c0                	test   %al,%al
80105c0d:	75 e1                	jne    80105bf0 <uartinit+0x90>
}
80105c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c12:	5b                   	pop    %ebx
80105c13:	5e                   	pop    %esi
80105c14:	5f                   	pop    %edi
80105c15:	5d                   	pop    %ebp
80105c16:	c3                   	ret    
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartputc>:
{
80105c20:	55                   	push   %ebp
  if(!uart)
80105c21:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c27:	89 e5                	mov    %esp,%ebp
80105c29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c2c:	85 d2                	test   %edx,%edx
80105c2e:	74 10                	je     80105c40 <uartputc+0x20>
}
80105c30:	5d                   	pop    %ebp
80105c31:	e9 da fe ff ff       	jmp    80105b10 <uartputc.part.0>
80105c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
80105c40:	5d                   	pop    %ebp
80105c41:	c3                   	ret    
80105c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c50 <uartintr>:

void
uartintr(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c56:	68 e0 5a 10 80       	push   $0x80105ae0
80105c5b:	e8 20 ac ff ff       	call   80100880 <consoleintr>
}
80105c60:	83 c4 10             	add    $0x10,%esp
80105c63:	c9                   	leave  
80105c64:	c3                   	ret    

80105c65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $0
80105c67:	6a 00                	push   $0x0
  jmp alltraps
80105c69:	e9 ac fa ff ff       	jmp    8010571a <alltraps>

80105c6e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $1
80105c70:	6a 01                	push   $0x1
  jmp alltraps
80105c72:	e9 a3 fa ff ff       	jmp    8010571a <alltraps>

80105c77 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $2
80105c79:	6a 02                	push   $0x2
  jmp alltraps
80105c7b:	e9 9a fa ff ff       	jmp    8010571a <alltraps>

80105c80 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $3
80105c82:	6a 03                	push   $0x3
  jmp alltraps
80105c84:	e9 91 fa ff ff       	jmp    8010571a <alltraps>

80105c89 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $4
80105c8b:	6a 04                	push   $0x4
  jmp alltraps
80105c8d:	e9 88 fa ff ff       	jmp    8010571a <alltraps>

80105c92 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $5
80105c94:	6a 05                	push   $0x5
  jmp alltraps
80105c96:	e9 7f fa ff ff       	jmp    8010571a <alltraps>

80105c9b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $6
80105c9d:	6a 06                	push   $0x6
  jmp alltraps
80105c9f:	e9 76 fa ff ff       	jmp    8010571a <alltraps>

80105ca4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $7
80105ca6:	6a 07                	push   $0x7
  jmp alltraps
80105ca8:	e9 6d fa ff ff       	jmp    8010571a <alltraps>

80105cad <vector8>:
.globl vector8
vector8:
  pushl $8
80105cad:	6a 08                	push   $0x8
  jmp alltraps
80105caf:	e9 66 fa ff ff       	jmp    8010571a <alltraps>

80105cb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $9
80105cb6:	6a 09                	push   $0x9
  jmp alltraps
80105cb8:	e9 5d fa ff ff       	jmp    8010571a <alltraps>

80105cbd <vector10>:
.globl vector10
vector10:
  pushl $10
80105cbd:	6a 0a                	push   $0xa
  jmp alltraps
80105cbf:	e9 56 fa ff ff       	jmp    8010571a <alltraps>

80105cc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105cc4:	6a 0b                	push   $0xb
  jmp alltraps
80105cc6:	e9 4f fa ff ff       	jmp    8010571a <alltraps>

80105ccb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ccb:	6a 0c                	push   $0xc
  jmp alltraps
80105ccd:	e9 48 fa ff ff       	jmp    8010571a <alltraps>

80105cd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105cd2:	6a 0d                	push   $0xd
  jmp alltraps
80105cd4:	e9 41 fa ff ff       	jmp    8010571a <alltraps>

80105cd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105cd9:	6a 0e                	push   $0xe
  jmp alltraps
80105cdb:	e9 3a fa ff ff       	jmp    8010571a <alltraps>

80105ce0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $15
80105ce2:	6a 0f                	push   $0xf
  jmp alltraps
80105ce4:	e9 31 fa ff ff       	jmp    8010571a <alltraps>

80105ce9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $16
80105ceb:	6a 10                	push   $0x10
  jmp alltraps
80105ced:	e9 28 fa ff ff       	jmp    8010571a <alltraps>

80105cf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cf2:	6a 11                	push   $0x11
  jmp alltraps
80105cf4:	e9 21 fa ff ff       	jmp    8010571a <alltraps>

80105cf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $18
80105cfb:	6a 12                	push   $0x12
  jmp alltraps
80105cfd:	e9 18 fa ff ff       	jmp    8010571a <alltraps>

80105d02 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $19
80105d04:	6a 13                	push   $0x13
  jmp alltraps
80105d06:	e9 0f fa ff ff       	jmp    8010571a <alltraps>

80105d0b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $20
80105d0d:	6a 14                	push   $0x14
  jmp alltraps
80105d0f:	e9 06 fa ff ff       	jmp    8010571a <alltraps>

80105d14 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $21
80105d16:	6a 15                	push   $0x15
  jmp alltraps
80105d18:	e9 fd f9 ff ff       	jmp    8010571a <alltraps>

80105d1d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $22
80105d1f:	6a 16                	push   $0x16
  jmp alltraps
80105d21:	e9 f4 f9 ff ff       	jmp    8010571a <alltraps>

80105d26 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $23
80105d28:	6a 17                	push   $0x17
  jmp alltraps
80105d2a:	e9 eb f9 ff ff       	jmp    8010571a <alltraps>

80105d2f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $24
80105d31:	6a 18                	push   $0x18
  jmp alltraps
80105d33:	e9 e2 f9 ff ff       	jmp    8010571a <alltraps>

80105d38 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $25
80105d3a:	6a 19                	push   $0x19
  jmp alltraps
80105d3c:	e9 d9 f9 ff ff       	jmp    8010571a <alltraps>

80105d41 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $26
80105d43:	6a 1a                	push   $0x1a
  jmp alltraps
80105d45:	e9 d0 f9 ff ff       	jmp    8010571a <alltraps>

80105d4a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $27
80105d4c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d4e:	e9 c7 f9 ff ff       	jmp    8010571a <alltraps>

80105d53 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $28
80105d55:	6a 1c                	push   $0x1c
  jmp alltraps
80105d57:	e9 be f9 ff ff       	jmp    8010571a <alltraps>

80105d5c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $29
80105d5e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d60:	e9 b5 f9 ff ff       	jmp    8010571a <alltraps>

80105d65 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $30
80105d67:	6a 1e                	push   $0x1e
  jmp alltraps
80105d69:	e9 ac f9 ff ff       	jmp    8010571a <alltraps>

80105d6e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $31
80105d70:	6a 1f                	push   $0x1f
  jmp alltraps
80105d72:	e9 a3 f9 ff ff       	jmp    8010571a <alltraps>

80105d77 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $32
80105d79:	6a 20                	push   $0x20
  jmp alltraps
80105d7b:	e9 9a f9 ff ff       	jmp    8010571a <alltraps>

80105d80 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $33
80105d82:	6a 21                	push   $0x21
  jmp alltraps
80105d84:	e9 91 f9 ff ff       	jmp    8010571a <alltraps>

80105d89 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $34
80105d8b:	6a 22                	push   $0x22
  jmp alltraps
80105d8d:	e9 88 f9 ff ff       	jmp    8010571a <alltraps>

80105d92 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $35
80105d94:	6a 23                	push   $0x23
  jmp alltraps
80105d96:	e9 7f f9 ff ff       	jmp    8010571a <alltraps>

80105d9b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $36
80105d9d:	6a 24                	push   $0x24
  jmp alltraps
80105d9f:	e9 76 f9 ff ff       	jmp    8010571a <alltraps>

80105da4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $37
80105da6:	6a 25                	push   $0x25
  jmp alltraps
80105da8:	e9 6d f9 ff ff       	jmp    8010571a <alltraps>

80105dad <vector38>:
.globl vector38
vector38:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $38
80105daf:	6a 26                	push   $0x26
  jmp alltraps
80105db1:	e9 64 f9 ff ff       	jmp    8010571a <alltraps>

80105db6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $39
80105db8:	6a 27                	push   $0x27
  jmp alltraps
80105dba:	e9 5b f9 ff ff       	jmp    8010571a <alltraps>

80105dbf <vector40>:
.globl vector40
vector40:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $40
80105dc1:	6a 28                	push   $0x28
  jmp alltraps
80105dc3:	e9 52 f9 ff ff       	jmp    8010571a <alltraps>

80105dc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $41
80105dca:	6a 29                	push   $0x29
  jmp alltraps
80105dcc:	e9 49 f9 ff ff       	jmp    8010571a <alltraps>

80105dd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $42
80105dd3:	6a 2a                	push   $0x2a
  jmp alltraps
80105dd5:	e9 40 f9 ff ff       	jmp    8010571a <alltraps>

80105dda <vector43>:
.globl vector43
vector43:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $43
80105ddc:	6a 2b                	push   $0x2b
  jmp alltraps
80105dde:	e9 37 f9 ff ff       	jmp    8010571a <alltraps>

80105de3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $44
80105de5:	6a 2c                	push   $0x2c
  jmp alltraps
80105de7:	e9 2e f9 ff ff       	jmp    8010571a <alltraps>

80105dec <vector45>:
.globl vector45
vector45:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $45
80105dee:	6a 2d                	push   $0x2d
  jmp alltraps
80105df0:	e9 25 f9 ff ff       	jmp    8010571a <alltraps>

80105df5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $46
80105df7:	6a 2e                	push   $0x2e
  jmp alltraps
80105df9:	e9 1c f9 ff ff       	jmp    8010571a <alltraps>

80105dfe <vector47>:
.globl vector47
vector47:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $47
80105e00:	6a 2f                	push   $0x2f
  jmp alltraps
80105e02:	e9 13 f9 ff ff       	jmp    8010571a <alltraps>

80105e07 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $48
80105e09:	6a 30                	push   $0x30
  jmp alltraps
80105e0b:	e9 0a f9 ff ff       	jmp    8010571a <alltraps>

80105e10 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $49
80105e12:	6a 31                	push   $0x31
  jmp alltraps
80105e14:	e9 01 f9 ff ff       	jmp    8010571a <alltraps>

80105e19 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $50
80105e1b:	6a 32                	push   $0x32
  jmp alltraps
80105e1d:	e9 f8 f8 ff ff       	jmp    8010571a <alltraps>

80105e22 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $51
80105e24:	6a 33                	push   $0x33
  jmp alltraps
80105e26:	e9 ef f8 ff ff       	jmp    8010571a <alltraps>

80105e2b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $52
80105e2d:	6a 34                	push   $0x34
  jmp alltraps
80105e2f:	e9 e6 f8 ff ff       	jmp    8010571a <alltraps>

80105e34 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $53
80105e36:	6a 35                	push   $0x35
  jmp alltraps
80105e38:	e9 dd f8 ff ff       	jmp    8010571a <alltraps>

80105e3d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $54
80105e3f:	6a 36                	push   $0x36
  jmp alltraps
80105e41:	e9 d4 f8 ff ff       	jmp    8010571a <alltraps>

80105e46 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $55
80105e48:	6a 37                	push   $0x37
  jmp alltraps
80105e4a:	e9 cb f8 ff ff       	jmp    8010571a <alltraps>

80105e4f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $56
80105e51:	6a 38                	push   $0x38
  jmp alltraps
80105e53:	e9 c2 f8 ff ff       	jmp    8010571a <alltraps>

80105e58 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $57
80105e5a:	6a 39                	push   $0x39
  jmp alltraps
80105e5c:	e9 b9 f8 ff ff       	jmp    8010571a <alltraps>

80105e61 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $58
80105e63:	6a 3a                	push   $0x3a
  jmp alltraps
80105e65:	e9 b0 f8 ff ff       	jmp    8010571a <alltraps>

80105e6a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $59
80105e6c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e6e:	e9 a7 f8 ff ff       	jmp    8010571a <alltraps>

80105e73 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $60
80105e75:	6a 3c                	push   $0x3c
  jmp alltraps
80105e77:	e9 9e f8 ff ff       	jmp    8010571a <alltraps>

80105e7c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $61
80105e7e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e80:	e9 95 f8 ff ff       	jmp    8010571a <alltraps>

80105e85 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $62
80105e87:	6a 3e                	push   $0x3e
  jmp alltraps
80105e89:	e9 8c f8 ff ff       	jmp    8010571a <alltraps>

80105e8e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $63
80105e90:	6a 3f                	push   $0x3f
  jmp alltraps
80105e92:	e9 83 f8 ff ff       	jmp    8010571a <alltraps>

80105e97 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $64
80105e99:	6a 40                	push   $0x40
  jmp alltraps
80105e9b:	e9 7a f8 ff ff       	jmp    8010571a <alltraps>

80105ea0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $65
80105ea2:	6a 41                	push   $0x41
  jmp alltraps
80105ea4:	e9 71 f8 ff ff       	jmp    8010571a <alltraps>

80105ea9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $66
80105eab:	6a 42                	push   $0x42
  jmp alltraps
80105ead:	e9 68 f8 ff ff       	jmp    8010571a <alltraps>

80105eb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $67
80105eb4:	6a 43                	push   $0x43
  jmp alltraps
80105eb6:	e9 5f f8 ff ff       	jmp    8010571a <alltraps>

80105ebb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $68
80105ebd:	6a 44                	push   $0x44
  jmp alltraps
80105ebf:	e9 56 f8 ff ff       	jmp    8010571a <alltraps>

80105ec4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $69
80105ec6:	6a 45                	push   $0x45
  jmp alltraps
80105ec8:	e9 4d f8 ff ff       	jmp    8010571a <alltraps>

80105ecd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $70
80105ecf:	6a 46                	push   $0x46
  jmp alltraps
80105ed1:	e9 44 f8 ff ff       	jmp    8010571a <alltraps>

80105ed6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $71
80105ed8:	6a 47                	push   $0x47
  jmp alltraps
80105eda:	e9 3b f8 ff ff       	jmp    8010571a <alltraps>

80105edf <vector72>:
.globl vector72
vector72:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $72
80105ee1:	6a 48                	push   $0x48
  jmp alltraps
80105ee3:	e9 32 f8 ff ff       	jmp    8010571a <alltraps>

80105ee8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $73
80105eea:	6a 49                	push   $0x49
  jmp alltraps
80105eec:	e9 29 f8 ff ff       	jmp    8010571a <alltraps>

80105ef1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $74
80105ef3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ef5:	e9 20 f8 ff ff       	jmp    8010571a <alltraps>

80105efa <vector75>:
.globl vector75
vector75:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $75
80105efc:	6a 4b                	push   $0x4b
  jmp alltraps
80105efe:	e9 17 f8 ff ff       	jmp    8010571a <alltraps>

80105f03 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $76
80105f05:	6a 4c                	push   $0x4c
  jmp alltraps
80105f07:	e9 0e f8 ff ff       	jmp    8010571a <alltraps>

80105f0c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $77
80105f0e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f10:	e9 05 f8 ff ff       	jmp    8010571a <alltraps>

80105f15 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $78
80105f17:	6a 4e                	push   $0x4e
  jmp alltraps
80105f19:	e9 fc f7 ff ff       	jmp    8010571a <alltraps>

80105f1e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $79
80105f20:	6a 4f                	push   $0x4f
  jmp alltraps
80105f22:	e9 f3 f7 ff ff       	jmp    8010571a <alltraps>

80105f27 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $80
80105f29:	6a 50                	push   $0x50
  jmp alltraps
80105f2b:	e9 ea f7 ff ff       	jmp    8010571a <alltraps>

80105f30 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $81
80105f32:	6a 51                	push   $0x51
  jmp alltraps
80105f34:	e9 e1 f7 ff ff       	jmp    8010571a <alltraps>

80105f39 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $82
80105f3b:	6a 52                	push   $0x52
  jmp alltraps
80105f3d:	e9 d8 f7 ff ff       	jmp    8010571a <alltraps>

80105f42 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $83
80105f44:	6a 53                	push   $0x53
  jmp alltraps
80105f46:	e9 cf f7 ff ff       	jmp    8010571a <alltraps>

80105f4b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $84
80105f4d:	6a 54                	push   $0x54
  jmp alltraps
80105f4f:	e9 c6 f7 ff ff       	jmp    8010571a <alltraps>

80105f54 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $85
80105f56:	6a 55                	push   $0x55
  jmp alltraps
80105f58:	e9 bd f7 ff ff       	jmp    8010571a <alltraps>

80105f5d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $86
80105f5f:	6a 56                	push   $0x56
  jmp alltraps
80105f61:	e9 b4 f7 ff ff       	jmp    8010571a <alltraps>

80105f66 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $87
80105f68:	6a 57                	push   $0x57
  jmp alltraps
80105f6a:	e9 ab f7 ff ff       	jmp    8010571a <alltraps>

80105f6f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $88
80105f71:	6a 58                	push   $0x58
  jmp alltraps
80105f73:	e9 a2 f7 ff ff       	jmp    8010571a <alltraps>

80105f78 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $89
80105f7a:	6a 59                	push   $0x59
  jmp alltraps
80105f7c:	e9 99 f7 ff ff       	jmp    8010571a <alltraps>

80105f81 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $90
80105f83:	6a 5a                	push   $0x5a
  jmp alltraps
80105f85:	e9 90 f7 ff ff       	jmp    8010571a <alltraps>

80105f8a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $91
80105f8c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f8e:	e9 87 f7 ff ff       	jmp    8010571a <alltraps>

80105f93 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $92
80105f95:	6a 5c                	push   $0x5c
  jmp alltraps
80105f97:	e9 7e f7 ff ff       	jmp    8010571a <alltraps>

80105f9c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $93
80105f9e:	6a 5d                	push   $0x5d
  jmp alltraps
80105fa0:	e9 75 f7 ff ff       	jmp    8010571a <alltraps>

80105fa5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $94
80105fa7:	6a 5e                	push   $0x5e
  jmp alltraps
80105fa9:	e9 6c f7 ff ff       	jmp    8010571a <alltraps>

80105fae <vector95>:
.globl vector95
vector95:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $95
80105fb0:	6a 5f                	push   $0x5f
  jmp alltraps
80105fb2:	e9 63 f7 ff ff       	jmp    8010571a <alltraps>

80105fb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $96
80105fb9:	6a 60                	push   $0x60
  jmp alltraps
80105fbb:	e9 5a f7 ff ff       	jmp    8010571a <alltraps>

80105fc0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $97
80105fc2:	6a 61                	push   $0x61
  jmp alltraps
80105fc4:	e9 51 f7 ff ff       	jmp    8010571a <alltraps>

80105fc9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $98
80105fcb:	6a 62                	push   $0x62
  jmp alltraps
80105fcd:	e9 48 f7 ff ff       	jmp    8010571a <alltraps>

80105fd2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $99
80105fd4:	6a 63                	push   $0x63
  jmp alltraps
80105fd6:	e9 3f f7 ff ff       	jmp    8010571a <alltraps>

80105fdb <vector100>:
.globl vector100
vector100:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $100
80105fdd:	6a 64                	push   $0x64
  jmp alltraps
80105fdf:	e9 36 f7 ff ff       	jmp    8010571a <alltraps>

80105fe4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $101
80105fe6:	6a 65                	push   $0x65
  jmp alltraps
80105fe8:	e9 2d f7 ff ff       	jmp    8010571a <alltraps>

80105fed <vector102>:
.globl vector102
vector102:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $102
80105fef:	6a 66                	push   $0x66
  jmp alltraps
80105ff1:	e9 24 f7 ff ff       	jmp    8010571a <alltraps>

80105ff6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $103
80105ff8:	6a 67                	push   $0x67
  jmp alltraps
80105ffa:	e9 1b f7 ff ff       	jmp    8010571a <alltraps>

80105fff <vector104>:
.globl vector104
vector104:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $104
80106001:	6a 68                	push   $0x68
  jmp alltraps
80106003:	e9 12 f7 ff ff       	jmp    8010571a <alltraps>

80106008 <vector105>:
.globl vector105
vector105:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $105
8010600a:	6a 69                	push   $0x69
  jmp alltraps
8010600c:	e9 09 f7 ff ff       	jmp    8010571a <alltraps>

80106011 <vector106>:
.globl vector106
vector106:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $106
80106013:	6a 6a                	push   $0x6a
  jmp alltraps
80106015:	e9 00 f7 ff ff       	jmp    8010571a <alltraps>

8010601a <vector107>:
.globl vector107
vector107:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $107
8010601c:	6a 6b                	push   $0x6b
  jmp alltraps
8010601e:	e9 f7 f6 ff ff       	jmp    8010571a <alltraps>

80106023 <vector108>:
.globl vector108
vector108:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $108
80106025:	6a 6c                	push   $0x6c
  jmp alltraps
80106027:	e9 ee f6 ff ff       	jmp    8010571a <alltraps>

8010602c <vector109>:
.globl vector109
vector109:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $109
8010602e:	6a 6d                	push   $0x6d
  jmp alltraps
80106030:	e9 e5 f6 ff ff       	jmp    8010571a <alltraps>

80106035 <vector110>:
.globl vector110
vector110:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $110
80106037:	6a 6e                	push   $0x6e
  jmp alltraps
80106039:	e9 dc f6 ff ff       	jmp    8010571a <alltraps>

8010603e <vector111>:
.globl vector111
vector111:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $111
80106040:	6a 6f                	push   $0x6f
  jmp alltraps
80106042:	e9 d3 f6 ff ff       	jmp    8010571a <alltraps>

80106047 <vector112>:
.globl vector112
vector112:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $112
80106049:	6a 70                	push   $0x70
  jmp alltraps
8010604b:	e9 ca f6 ff ff       	jmp    8010571a <alltraps>

80106050 <vector113>:
.globl vector113
vector113:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $113
80106052:	6a 71                	push   $0x71
  jmp alltraps
80106054:	e9 c1 f6 ff ff       	jmp    8010571a <alltraps>

80106059 <vector114>:
.globl vector114
vector114:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $114
8010605b:	6a 72                	push   $0x72
  jmp alltraps
8010605d:	e9 b8 f6 ff ff       	jmp    8010571a <alltraps>

80106062 <vector115>:
.globl vector115
vector115:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $115
80106064:	6a 73                	push   $0x73
  jmp alltraps
80106066:	e9 af f6 ff ff       	jmp    8010571a <alltraps>

8010606b <vector116>:
.globl vector116
vector116:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $116
8010606d:	6a 74                	push   $0x74
  jmp alltraps
8010606f:	e9 a6 f6 ff ff       	jmp    8010571a <alltraps>

80106074 <vector117>:
.globl vector117
vector117:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $117
80106076:	6a 75                	push   $0x75
  jmp alltraps
80106078:	e9 9d f6 ff ff       	jmp    8010571a <alltraps>

8010607d <vector118>:
.globl vector118
vector118:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $118
8010607f:	6a 76                	push   $0x76
  jmp alltraps
80106081:	e9 94 f6 ff ff       	jmp    8010571a <alltraps>

80106086 <vector119>:
.globl vector119
vector119:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $119
80106088:	6a 77                	push   $0x77
  jmp alltraps
8010608a:	e9 8b f6 ff ff       	jmp    8010571a <alltraps>

8010608f <vector120>:
.globl vector120
vector120:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $120
80106091:	6a 78                	push   $0x78
  jmp alltraps
80106093:	e9 82 f6 ff ff       	jmp    8010571a <alltraps>

80106098 <vector121>:
.globl vector121
vector121:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $121
8010609a:	6a 79                	push   $0x79
  jmp alltraps
8010609c:	e9 79 f6 ff ff       	jmp    8010571a <alltraps>

801060a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $122
801060a3:	6a 7a                	push   $0x7a
  jmp alltraps
801060a5:	e9 70 f6 ff ff       	jmp    8010571a <alltraps>

801060aa <vector123>:
.globl vector123
vector123:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $123
801060ac:	6a 7b                	push   $0x7b
  jmp alltraps
801060ae:	e9 67 f6 ff ff       	jmp    8010571a <alltraps>

801060b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $124
801060b5:	6a 7c                	push   $0x7c
  jmp alltraps
801060b7:	e9 5e f6 ff ff       	jmp    8010571a <alltraps>

801060bc <vector125>:
.globl vector125
vector125:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $125
801060be:	6a 7d                	push   $0x7d
  jmp alltraps
801060c0:	e9 55 f6 ff ff       	jmp    8010571a <alltraps>

801060c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $126
801060c7:	6a 7e                	push   $0x7e
  jmp alltraps
801060c9:	e9 4c f6 ff ff       	jmp    8010571a <alltraps>

801060ce <vector127>:
.globl vector127
vector127:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $127
801060d0:	6a 7f                	push   $0x7f
  jmp alltraps
801060d2:	e9 43 f6 ff ff       	jmp    8010571a <alltraps>

801060d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $128
801060d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060de:	e9 37 f6 ff ff       	jmp    8010571a <alltraps>

801060e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $129
801060e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ea:	e9 2b f6 ff ff       	jmp    8010571a <alltraps>

801060ef <vector130>:
.globl vector130
vector130:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $130
801060f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060f6:	e9 1f f6 ff ff       	jmp    8010571a <alltraps>

801060fb <vector131>:
.globl vector131
vector131:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $131
801060fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106102:	e9 13 f6 ff ff       	jmp    8010571a <alltraps>

80106107 <vector132>:
.globl vector132
vector132:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $132
80106109:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010610e:	e9 07 f6 ff ff       	jmp    8010571a <alltraps>

80106113 <vector133>:
.globl vector133
vector133:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $133
80106115:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010611a:	e9 fb f5 ff ff       	jmp    8010571a <alltraps>

8010611f <vector134>:
.globl vector134
vector134:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $134
80106121:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106126:	e9 ef f5 ff ff       	jmp    8010571a <alltraps>

8010612b <vector135>:
.globl vector135
vector135:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $135
8010612d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106132:	e9 e3 f5 ff ff       	jmp    8010571a <alltraps>

80106137 <vector136>:
.globl vector136
vector136:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $136
80106139:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010613e:	e9 d7 f5 ff ff       	jmp    8010571a <alltraps>

80106143 <vector137>:
.globl vector137
vector137:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $137
80106145:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010614a:	e9 cb f5 ff ff       	jmp    8010571a <alltraps>

8010614f <vector138>:
.globl vector138
vector138:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $138
80106151:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106156:	e9 bf f5 ff ff       	jmp    8010571a <alltraps>

8010615b <vector139>:
.globl vector139
vector139:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $139
8010615d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106162:	e9 b3 f5 ff ff       	jmp    8010571a <alltraps>

80106167 <vector140>:
.globl vector140
vector140:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $140
80106169:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010616e:	e9 a7 f5 ff ff       	jmp    8010571a <alltraps>

80106173 <vector141>:
.globl vector141
vector141:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $141
80106175:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010617a:	e9 9b f5 ff ff       	jmp    8010571a <alltraps>

8010617f <vector142>:
.globl vector142
vector142:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $142
80106181:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106186:	e9 8f f5 ff ff       	jmp    8010571a <alltraps>

8010618b <vector143>:
.globl vector143
vector143:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $143
8010618d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106192:	e9 83 f5 ff ff       	jmp    8010571a <alltraps>

80106197 <vector144>:
.globl vector144
vector144:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $144
80106199:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010619e:	e9 77 f5 ff ff       	jmp    8010571a <alltraps>

801061a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $145
801061a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061aa:	e9 6b f5 ff ff       	jmp    8010571a <alltraps>

801061af <vector146>:
.globl vector146
vector146:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $146
801061b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801061b6:	e9 5f f5 ff ff       	jmp    8010571a <alltraps>

801061bb <vector147>:
.globl vector147
vector147:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $147
801061bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801061c2:	e9 53 f5 ff ff       	jmp    8010571a <alltraps>

801061c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $148
801061c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801061ce:	e9 47 f5 ff ff       	jmp    8010571a <alltraps>

801061d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $149
801061d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061da:	e9 3b f5 ff ff       	jmp    8010571a <alltraps>

801061df <vector150>:
.globl vector150
vector150:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $150
801061e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061e6:	e9 2f f5 ff ff       	jmp    8010571a <alltraps>

801061eb <vector151>:
.globl vector151
vector151:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $151
801061ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061f2:	e9 23 f5 ff ff       	jmp    8010571a <alltraps>

801061f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $152
801061f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061fe:	e9 17 f5 ff ff       	jmp    8010571a <alltraps>

80106203 <vector153>:
.globl vector153
vector153:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $153
80106205:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010620a:	e9 0b f5 ff ff       	jmp    8010571a <alltraps>

8010620f <vector154>:
.globl vector154
vector154:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $154
80106211:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106216:	e9 ff f4 ff ff       	jmp    8010571a <alltraps>

8010621b <vector155>:
.globl vector155
vector155:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $155
8010621d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106222:	e9 f3 f4 ff ff       	jmp    8010571a <alltraps>

80106227 <vector156>:
.globl vector156
vector156:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $156
80106229:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010622e:	e9 e7 f4 ff ff       	jmp    8010571a <alltraps>

80106233 <vector157>:
.globl vector157
vector157:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $157
80106235:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010623a:	e9 db f4 ff ff       	jmp    8010571a <alltraps>

8010623f <vector158>:
.globl vector158
vector158:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $158
80106241:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106246:	e9 cf f4 ff ff       	jmp    8010571a <alltraps>

8010624b <vector159>:
.globl vector159
vector159:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $159
8010624d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106252:	e9 c3 f4 ff ff       	jmp    8010571a <alltraps>

80106257 <vector160>:
.globl vector160
vector160:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $160
80106259:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010625e:	e9 b7 f4 ff ff       	jmp    8010571a <alltraps>

80106263 <vector161>:
.globl vector161
vector161:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $161
80106265:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010626a:	e9 ab f4 ff ff       	jmp    8010571a <alltraps>

8010626f <vector162>:
.globl vector162
vector162:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $162
80106271:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106276:	e9 9f f4 ff ff       	jmp    8010571a <alltraps>

8010627b <vector163>:
.globl vector163
vector163:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $163
8010627d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106282:	e9 93 f4 ff ff       	jmp    8010571a <alltraps>

80106287 <vector164>:
.globl vector164
vector164:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $164
80106289:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010628e:	e9 87 f4 ff ff       	jmp    8010571a <alltraps>

80106293 <vector165>:
.globl vector165
vector165:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $165
80106295:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010629a:	e9 7b f4 ff ff       	jmp    8010571a <alltraps>

8010629f <vector166>:
.globl vector166
vector166:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $166
801062a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062a6:	e9 6f f4 ff ff       	jmp    8010571a <alltraps>

801062ab <vector167>:
.globl vector167
vector167:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $167
801062ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801062b2:	e9 63 f4 ff ff       	jmp    8010571a <alltraps>

801062b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $168
801062b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801062be:	e9 57 f4 ff ff       	jmp    8010571a <alltraps>

801062c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $169
801062c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801062ca:	e9 4b f4 ff ff       	jmp    8010571a <alltraps>

801062cf <vector170>:
.globl vector170
vector170:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $170
801062d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062d6:	e9 3f f4 ff ff       	jmp    8010571a <alltraps>

801062db <vector171>:
.globl vector171
vector171:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $171
801062dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062e2:	e9 33 f4 ff ff       	jmp    8010571a <alltraps>

801062e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $172
801062e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062ee:	e9 27 f4 ff ff       	jmp    8010571a <alltraps>

801062f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $173
801062f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062fa:	e9 1b f4 ff ff       	jmp    8010571a <alltraps>

801062ff <vector174>:
.globl vector174
vector174:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $174
80106301:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106306:	e9 0f f4 ff ff       	jmp    8010571a <alltraps>

8010630b <vector175>:
.globl vector175
vector175:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $175
8010630d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106312:	e9 03 f4 ff ff       	jmp    8010571a <alltraps>

80106317 <vector176>:
.globl vector176
vector176:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $176
80106319:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010631e:	e9 f7 f3 ff ff       	jmp    8010571a <alltraps>

80106323 <vector177>:
.globl vector177
vector177:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $177
80106325:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010632a:	e9 eb f3 ff ff       	jmp    8010571a <alltraps>

8010632f <vector178>:
.globl vector178
vector178:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $178
80106331:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106336:	e9 df f3 ff ff       	jmp    8010571a <alltraps>

8010633b <vector179>:
.globl vector179
vector179:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $179
8010633d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106342:	e9 d3 f3 ff ff       	jmp    8010571a <alltraps>

80106347 <vector180>:
.globl vector180
vector180:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $180
80106349:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010634e:	e9 c7 f3 ff ff       	jmp    8010571a <alltraps>

80106353 <vector181>:
.globl vector181
vector181:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $181
80106355:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010635a:	e9 bb f3 ff ff       	jmp    8010571a <alltraps>

8010635f <vector182>:
.globl vector182
vector182:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $182
80106361:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106366:	e9 af f3 ff ff       	jmp    8010571a <alltraps>

8010636b <vector183>:
.globl vector183
vector183:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $183
8010636d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106372:	e9 a3 f3 ff ff       	jmp    8010571a <alltraps>

80106377 <vector184>:
.globl vector184
vector184:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $184
80106379:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010637e:	e9 97 f3 ff ff       	jmp    8010571a <alltraps>

80106383 <vector185>:
.globl vector185
vector185:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $185
80106385:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010638a:	e9 8b f3 ff ff       	jmp    8010571a <alltraps>

8010638f <vector186>:
.globl vector186
vector186:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $186
80106391:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106396:	e9 7f f3 ff ff       	jmp    8010571a <alltraps>

8010639b <vector187>:
.globl vector187
vector187:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $187
8010639d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063a2:	e9 73 f3 ff ff       	jmp    8010571a <alltraps>

801063a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $188
801063a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063ae:	e9 67 f3 ff ff       	jmp    8010571a <alltraps>

801063b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $189
801063b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801063ba:	e9 5b f3 ff ff       	jmp    8010571a <alltraps>

801063bf <vector190>:
.globl vector190
vector190:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $190
801063c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801063c6:	e9 4f f3 ff ff       	jmp    8010571a <alltraps>

801063cb <vector191>:
.globl vector191
vector191:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $191
801063cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063d2:	e9 43 f3 ff ff       	jmp    8010571a <alltraps>

801063d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $192
801063d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063de:	e9 37 f3 ff ff       	jmp    8010571a <alltraps>

801063e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $193
801063e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ea:	e9 2b f3 ff ff       	jmp    8010571a <alltraps>

801063ef <vector194>:
.globl vector194
vector194:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $194
801063f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063f6:	e9 1f f3 ff ff       	jmp    8010571a <alltraps>

801063fb <vector195>:
.globl vector195
vector195:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $195
801063fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106402:	e9 13 f3 ff ff       	jmp    8010571a <alltraps>

80106407 <vector196>:
.globl vector196
vector196:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $196
80106409:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010640e:	e9 07 f3 ff ff       	jmp    8010571a <alltraps>

80106413 <vector197>:
.globl vector197
vector197:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $197
80106415:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010641a:	e9 fb f2 ff ff       	jmp    8010571a <alltraps>

8010641f <vector198>:
.globl vector198
vector198:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $198
80106421:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106426:	e9 ef f2 ff ff       	jmp    8010571a <alltraps>

8010642b <vector199>:
.globl vector199
vector199:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $199
8010642d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106432:	e9 e3 f2 ff ff       	jmp    8010571a <alltraps>

80106437 <vector200>:
.globl vector200
vector200:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $200
80106439:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010643e:	e9 d7 f2 ff ff       	jmp    8010571a <alltraps>

80106443 <vector201>:
.globl vector201
vector201:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $201
80106445:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010644a:	e9 cb f2 ff ff       	jmp    8010571a <alltraps>

8010644f <vector202>:
.globl vector202
vector202:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $202
80106451:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106456:	e9 bf f2 ff ff       	jmp    8010571a <alltraps>

8010645b <vector203>:
.globl vector203
vector203:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $203
8010645d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106462:	e9 b3 f2 ff ff       	jmp    8010571a <alltraps>

80106467 <vector204>:
.globl vector204
vector204:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $204
80106469:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010646e:	e9 a7 f2 ff ff       	jmp    8010571a <alltraps>

80106473 <vector205>:
.globl vector205
vector205:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $205
80106475:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010647a:	e9 9b f2 ff ff       	jmp    8010571a <alltraps>

8010647f <vector206>:
.globl vector206
vector206:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $206
80106481:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106486:	e9 8f f2 ff ff       	jmp    8010571a <alltraps>

8010648b <vector207>:
.globl vector207
vector207:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $207
8010648d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106492:	e9 83 f2 ff ff       	jmp    8010571a <alltraps>

80106497 <vector208>:
.globl vector208
vector208:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $208
80106499:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010649e:	e9 77 f2 ff ff       	jmp    8010571a <alltraps>

801064a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $209
801064a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064aa:	e9 6b f2 ff ff       	jmp    8010571a <alltraps>

801064af <vector210>:
.globl vector210
vector210:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $210
801064b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801064b6:	e9 5f f2 ff ff       	jmp    8010571a <alltraps>

801064bb <vector211>:
.globl vector211
vector211:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $211
801064bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801064c2:	e9 53 f2 ff ff       	jmp    8010571a <alltraps>

801064c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $212
801064c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801064ce:	e9 47 f2 ff ff       	jmp    8010571a <alltraps>

801064d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $213
801064d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064da:	e9 3b f2 ff ff       	jmp    8010571a <alltraps>

801064df <vector214>:
.globl vector214
vector214:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $214
801064e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064e6:	e9 2f f2 ff ff       	jmp    8010571a <alltraps>

801064eb <vector215>:
.globl vector215
vector215:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $215
801064ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064f2:	e9 23 f2 ff ff       	jmp    8010571a <alltraps>

801064f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $216
801064f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064fe:	e9 17 f2 ff ff       	jmp    8010571a <alltraps>

80106503 <vector217>:
.globl vector217
vector217:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $217
80106505:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010650a:	e9 0b f2 ff ff       	jmp    8010571a <alltraps>

8010650f <vector218>:
.globl vector218
vector218:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $218
80106511:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106516:	e9 ff f1 ff ff       	jmp    8010571a <alltraps>

8010651b <vector219>:
.globl vector219
vector219:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $219
8010651d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106522:	e9 f3 f1 ff ff       	jmp    8010571a <alltraps>

80106527 <vector220>:
.globl vector220
vector220:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $220
80106529:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010652e:	e9 e7 f1 ff ff       	jmp    8010571a <alltraps>

80106533 <vector221>:
.globl vector221
vector221:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $221
80106535:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010653a:	e9 db f1 ff ff       	jmp    8010571a <alltraps>

8010653f <vector222>:
.globl vector222
vector222:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $222
80106541:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106546:	e9 cf f1 ff ff       	jmp    8010571a <alltraps>

8010654b <vector223>:
.globl vector223
vector223:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $223
8010654d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106552:	e9 c3 f1 ff ff       	jmp    8010571a <alltraps>

80106557 <vector224>:
.globl vector224
vector224:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $224
80106559:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010655e:	e9 b7 f1 ff ff       	jmp    8010571a <alltraps>

80106563 <vector225>:
.globl vector225
vector225:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $225
80106565:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010656a:	e9 ab f1 ff ff       	jmp    8010571a <alltraps>

8010656f <vector226>:
.globl vector226
vector226:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $226
80106571:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106576:	e9 9f f1 ff ff       	jmp    8010571a <alltraps>

8010657b <vector227>:
.globl vector227
vector227:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $227
8010657d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106582:	e9 93 f1 ff ff       	jmp    8010571a <alltraps>

80106587 <vector228>:
.globl vector228
vector228:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $228
80106589:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010658e:	e9 87 f1 ff ff       	jmp    8010571a <alltraps>

80106593 <vector229>:
.globl vector229
vector229:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $229
80106595:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010659a:	e9 7b f1 ff ff       	jmp    8010571a <alltraps>

8010659f <vector230>:
.globl vector230
vector230:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $230
801065a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065a6:	e9 6f f1 ff ff       	jmp    8010571a <alltraps>

801065ab <vector231>:
.globl vector231
vector231:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $231
801065ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801065b2:	e9 63 f1 ff ff       	jmp    8010571a <alltraps>

801065b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $232
801065b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801065be:	e9 57 f1 ff ff       	jmp    8010571a <alltraps>

801065c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $233
801065c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801065ca:	e9 4b f1 ff ff       	jmp    8010571a <alltraps>

801065cf <vector234>:
.globl vector234
vector234:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $234
801065d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065d6:	e9 3f f1 ff ff       	jmp    8010571a <alltraps>

801065db <vector235>:
.globl vector235
vector235:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $235
801065dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065e2:	e9 33 f1 ff ff       	jmp    8010571a <alltraps>

801065e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $236
801065e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065ee:	e9 27 f1 ff ff       	jmp    8010571a <alltraps>

801065f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $237
801065f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065fa:	e9 1b f1 ff ff       	jmp    8010571a <alltraps>

801065ff <vector238>:
.globl vector238
vector238:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $238
80106601:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106606:	e9 0f f1 ff ff       	jmp    8010571a <alltraps>

8010660b <vector239>:
.globl vector239
vector239:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $239
8010660d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106612:	e9 03 f1 ff ff       	jmp    8010571a <alltraps>

80106617 <vector240>:
.globl vector240
vector240:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $240
80106619:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010661e:	e9 f7 f0 ff ff       	jmp    8010571a <alltraps>

80106623 <vector241>:
.globl vector241
vector241:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $241
80106625:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010662a:	e9 eb f0 ff ff       	jmp    8010571a <alltraps>

8010662f <vector242>:
.globl vector242
vector242:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $242
80106631:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106636:	e9 df f0 ff ff       	jmp    8010571a <alltraps>

8010663b <vector243>:
.globl vector243
vector243:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $243
8010663d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106642:	e9 d3 f0 ff ff       	jmp    8010571a <alltraps>

80106647 <vector244>:
.globl vector244
vector244:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $244
80106649:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010664e:	e9 c7 f0 ff ff       	jmp    8010571a <alltraps>

80106653 <vector245>:
.globl vector245
vector245:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $245
80106655:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010665a:	e9 bb f0 ff ff       	jmp    8010571a <alltraps>

8010665f <vector246>:
.globl vector246
vector246:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $246
80106661:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106666:	e9 af f0 ff ff       	jmp    8010571a <alltraps>

8010666b <vector247>:
.globl vector247
vector247:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $247
8010666d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106672:	e9 a3 f0 ff ff       	jmp    8010571a <alltraps>

80106677 <vector248>:
.globl vector248
vector248:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $248
80106679:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010667e:	e9 97 f0 ff ff       	jmp    8010571a <alltraps>

80106683 <vector249>:
.globl vector249
vector249:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $249
80106685:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010668a:	e9 8b f0 ff ff       	jmp    8010571a <alltraps>

8010668f <vector250>:
.globl vector250
vector250:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $250
80106691:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106696:	e9 7f f0 ff ff       	jmp    8010571a <alltraps>

8010669b <vector251>:
.globl vector251
vector251:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $251
8010669d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066a2:	e9 73 f0 ff ff       	jmp    8010571a <alltraps>

801066a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $252
801066a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066ae:	e9 67 f0 ff ff       	jmp    8010571a <alltraps>

801066b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $253
801066b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801066ba:	e9 5b f0 ff ff       	jmp    8010571a <alltraps>

801066bf <vector254>:
.globl vector254
vector254:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $254
801066c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801066c6:	e9 4f f0 ff ff       	jmp    8010571a <alltraps>

801066cb <vector255>:
.globl vector255
vector255:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $255
801066cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066d2:	e9 43 f0 ff ff       	jmp    8010571a <alltraps>
801066d7:	66 90                	xchg   %ax,%ax
801066d9:	66 90                	xchg   %ax,%ax
801066db:	66 90                	xchg   %ax,%ax
801066dd:	66 90                	xchg   %ax,%ax
801066df:	90                   	nop

801066e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066e7:	c1 ea 16             	shr    $0x16,%edx
{
801066ea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066ee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066f1:	8b 07                	mov    (%edi),%eax
801066f3:	a8 01                	test   $0x1,%al
801066f5:	74 29                	je     80106720 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066fc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106702:	c1 ee 0a             	shr    $0xa,%esi
}
80106705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106708:	89 f2                	mov    %esi,%edx
8010670a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106710:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106713:	5b                   	pop    %ebx
80106714:	5e                   	pop    %esi
80106715:	5f                   	pop    %edi
80106716:	5d                   	pop    %ebp
80106717:	c3                   	ret    
80106718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106720:	85 c9                	test   %ecx,%ecx
80106722:	74 2c                	je     80106750 <walkpgdir+0x70>
80106724:	e8 b7 be ff ff       	call   801025e0 <kalloc>
80106729:	89 c3                	mov    %eax,%ebx
8010672b:	85 c0                	test   %eax,%eax
8010672d:	74 21                	je     80106750 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010672f:	83 ec 04             	sub    $0x4,%esp
80106732:	68 00 10 00 00       	push   $0x1000
80106737:	6a 00                	push   $0x0
80106739:	50                   	push   %eax
8010673a:	e8 21 de ff ff       	call   80104560 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010673f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	83 c8 07             	or     $0x7,%eax
8010674b:	89 07                	mov    %eax,(%edi)
8010674d:	eb b3                	jmp    80106702 <walkpgdir+0x22>
8010674f:	90                   	nop
}
80106750:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106753:	31 c0                	xor    %eax,%eax
}
80106755:	5b                   	pop    %ebx
80106756:	5e                   	pop    %esi
80106757:	5f                   	pop    %edi
80106758:	5d                   	pop    %ebp
80106759:	c3                   	ret    
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106765:	89 d6                	mov    %edx,%esi
{
80106767:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106768:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010676e:	83 ec 1c             	sub    $0x1c,%esp
80106771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106774:	8b 7d 08             	mov    0x8(%ebp),%edi
80106777:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010677b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106780:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106783:	29 f7                	sub    %esi,%edi
80106785:	eb 21                	jmp    801067a8 <mappages+0x48>
80106787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010678e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106790:	f6 00 01             	testb  $0x1,(%eax)
80106793:	75 45                	jne    801067da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106795:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106798:	83 cb 01             	or     $0x1,%ebx
8010679b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010679d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801067a0:	74 2e                	je     801067d0 <mappages+0x70>
      break;
    a += PGSIZE;
801067a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ab:	b9 01 00 00 00       	mov    $0x1,%ecx
801067b0:	89 f2                	mov    %esi,%edx
801067b2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801067b5:	e8 26 ff ff ff       	call   801066e0 <walkpgdir>
801067ba:	85 c0                	test   %eax,%eax
801067bc:	75 d2                	jne    80106790 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801067be:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801067c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067c6:	5b                   	pop    %ebx
801067c7:	5e                   	pop    %esi
801067c8:	5f                   	pop    %edi
801067c9:	5d                   	pop    %ebp
801067ca:	c3                   	ret    
801067cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067cf:	90                   	nop
801067d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801067d3:	31 c0                	xor    %eax,%eax
}
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
      panic("remap");
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	68 77 79 10 80       	push   $0x80107977
801067e2:	e8 c9 9b ff ff       	call   801003b0 <panic>
801067e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ee:	66 90                	xchg   %ax,%ax

801067f0 <deallocuvm.part.0>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	89 c7                	mov    %eax,%edi
801067f6:	56                   	push   %esi
801067f7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067f8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106804:	83 ec 1c             	sub    $0x1c,%esp
80106807:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010680a:	39 d3                	cmp    %edx,%ebx
8010680c:	73 5a                	jae    80106868 <deallocuvm.part.0+0x78>
8010680e:	89 d6                	mov    %edx,%esi
80106810:	eb 10                	jmp    80106822 <deallocuvm.part.0+0x32>
80106812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106818:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010681e:	39 de                	cmp    %ebx,%esi
80106820:	76 46                	jbe    80106868 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106822:	31 c9                	xor    %ecx,%ecx
80106824:	89 da                	mov    %ebx,%edx
80106826:	89 f8                	mov    %edi,%eax
80106828:	e8 b3 fe ff ff       	call   801066e0 <walkpgdir>
    if(!pte)
8010682d:	85 c0                	test   %eax,%eax
8010682f:	74 47                	je     80106878 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106831:	8b 10                	mov    (%eax),%edx
80106833:	f6 c2 01             	test   $0x1,%dl
80106836:	74 e0                	je     80106818 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106838:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010683e:	74 46                	je     80106886 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106840:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106843:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010684c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106852:	52                   	push   %edx
80106853:	e8 c8 bb ff ff       	call   80102420 <kfree>
      *pte = 0;
80106858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010685b:	83 c4 10             	add    $0x10,%esp
8010685e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106864:	39 de                	cmp    %ebx,%esi
80106866:	77 ba                	ja     80106822 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106868:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010686b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010686e:	5b                   	pop    %ebx
8010686f:	5e                   	pop    %esi
80106870:	5f                   	pop    %edi
80106871:	5d                   	pop    %ebp
80106872:	c3                   	ret    
80106873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106877:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106878:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010687e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106884:	eb 98                	jmp    8010681e <deallocuvm.part.0+0x2e>
        panic("kfree");
80106886:	83 ec 0c             	sub    $0xc,%esp
80106889:	68 86 72 10 80       	push   $0x80107286
8010688e:	e8 1d 9b ff ff       	call   801003b0 <panic>
80106893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068a0 <seginit>:
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068a6:	e8 45 d0 ff ff       	call   801038f0 <cpuid>
  pd[0] = size-1;
801068ab:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068b0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068ba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801068c1:	ff 00 00 
801068c4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801068cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068ce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801068d5:	ff 00 00 
801068d8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801068df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068e2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068e9:	ff 00 00 
801068ec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068f6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068fd:	ff 00 00 
80106900:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106907:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010690a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010690f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106913:	c1 e8 10             	shr    $0x10,%eax
80106916:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010691a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010691d:	0f 01 10             	lgdtl  (%eax)
}
80106920:	c9                   	leave  
80106921:	c3                   	ret    
80106922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106930:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106935:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010693a:	0f 22 d8             	mov    %eax,%cr3
}
8010693d:	c3                   	ret    
8010693e:	66 90                	xchg   %ax,%ax

80106940 <switchuvm>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	83 ec 1c             	sub    $0x1c,%esp
80106949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010694c:	85 db                	test   %ebx,%ebx
8010694e:	0f 84 cb 00 00 00    	je     80106a1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106954:	8b 43 08             	mov    0x8(%ebx),%eax
80106957:	85 c0                	test   %eax,%eax
80106959:	0f 84 da 00 00 00    	je     80106a39 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010695f:	8b 43 04             	mov    0x4(%ebx),%eax
80106962:	85 c0                	test   %eax,%eax
80106964:	0f 84 c2 00 00 00    	je     80106a2c <switchuvm+0xec>
  pushcli();
8010696a:	e8 31 da ff ff       	call   801043a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010696f:	e8 fc ce ff ff       	call   80103870 <mycpu>
80106974:	89 c6                	mov    %eax,%esi
80106976:	e8 f5 ce ff ff       	call   80103870 <mycpu>
8010697b:	89 c7                	mov    %eax,%edi
8010697d:	e8 ee ce ff ff       	call   80103870 <mycpu>
80106982:	83 c7 08             	add    $0x8,%edi
80106985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106988:	e8 e3 ce ff ff       	call   80103870 <mycpu>
8010698d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106990:	ba 67 00 00 00       	mov    $0x67,%edx
80106995:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010699c:	83 c0 08             	add    $0x8,%eax
8010699f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069ab:	83 c1 08             	add    $0x8,%ecx
801069ae:	c1 e8 18             	shr    $0x18,%eax
801069b1:	c1 e9 10             	shr    $0x10,%ecx
801069b4:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
801069ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801069c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801069c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801069d1:	e8 9a ce ff ff       	call   80103870 <mycpu>
801069d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069dd:	e8 8e ce ff ff       	call   80103870 <mycpu>
801069e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069e6:	8b 73 08             	mov    0x8(%ebx),%esi
801069e9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069ef:	e8 7c ce ff ff       	call   80103870 <mycpu>
801069f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069f7:	e8 74 ce ff ff       	call   80103870 <mycpu>
801069fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a00:	b8 28 00 00 00       	mov    $0x28,%eax
80106a05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a08:	8b 43 04             	mov    0x4(%ebx),%eax
80106a0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a10:	0f 22 d8             	mov    %eax,%cr3
}
80106a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a16:	5b                   	pop    %ebx
80106a17:	5e                   	pop    %esi
80106a18:	5f                   	pop    %edi
80106a19:	5d                   	pop    %ebp
  popcli();
80106a1a:	e9 91 da ff ff       	jmp    801044b0 <popcli>
    panic("switchuvm: no process");
80106a1f:	83 ec 0c             	sub    $0xc,%esp
80106a22:	68 7d 79 10 80       	push   $0x8010797d
80106a27:	e8 84 99 ff ff       	call   801003b0 <panic>
    panic("switchuvm: no pgdir");
80106a2c:	83 ec 0c             	sub    $0xc,%esp
80106a2f:	68 a8 79 10 80       	push   $0x801079a8
80106a34:	e8 77 99 ff ff       	call   801003b0 <panic>
    panic("switchuvm: no kstack");
80106a39:	83 ec 0c             	sub    $0xc,%esp
80106a3c:	68 93 79 10 80       	push   $0x80107993
80106a41:	e8 6a 99 ff ff       	call   801003b0 <panic>
80106a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4d:	8d 76 00             	lea    0x0(%esi),%esi

80106a50 <inituvm>:
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
80106a59:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a6b:	77 49                	ja     80106ab6 <inituvm+0x66>
  mem = kalloc();
80106a6d:	e8 6e bb ff ff       	call   801025e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a72:	83 ec 04             	sub    $0x4,%esp
80106a75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a7c:	6a 00                	push   $0x0
80106a7e:	50                   	push   %eax
80106a7f:	e8 dc da ff ff       	call   80104560 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a84:	58                   	pop    %eax
80106a85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a8b:	5a                   	pop    %edx
80106a8c:	6a 06                	push   $0x6
80106a8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a93:	31 d2                	xor    %edx,%edx
80106a95:	50                   	push   %eax
80106a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a99:	e8 c2 fc ff ff       	call   80106760 <mappages>
  memmove(mem, init, sz);
80106a9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106aa1:	83 c4 10             	add    $0x10,%esp
80106aa4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106aa7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aad:	5b                   	pop    %ebx
80106aae:	5e                   	pop    %esi
80106aaf:	5f                   	pop    %edi
80106ab0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ab1:	e9 4a db ff ff       	jmp    80104600 <memmove>
    panic("inituvm: more than a page");
80106ab6:	83 ec 0c             	sub    $0xc,%esp
80106ab9:	68 bc 79 10 80       	push   $0x801079bc
80106abe:	e8 ed 98 ff ff       	call   801003b0 <panic>
80106ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <loaduvm>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 1c             	sub    $0x1c,%esp
80106ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106adc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106adf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ae4:	0f 85 8d 00 00 00    	jne    80106b77 <loaduvm+0xa7>
80106aea:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106aec:	89 f3                	mov    %esi,%ebx
80106aee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af1:	8b 45 14             	mov    0x14(%ebp),%eax
80106af4:	01 f0                	add    %esi,%eax
80106af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106af9:	85 f6                	test   %esi,%esi
80106afb:	75 11                	jne    80106b0e <loaduvm+0x3e>
80106afd:	eb 61                	jmp    80106b60 <loaduvm+0x90>
80106aff:	90                   	nop
80106b00:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106b06:	89 f0                	mov    %esi,%eax
80106b08:	29 d8                	sub    %ebx,%eax
80106b0a:	39 c6                	cmp    %eax,%esi
80106b0c:	76 52                	jbe    80106b60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b11:	8b 45 08             	mov    0x8(%ebp),%eax
80106b14:	31 c9                	xor    %ecx,%ecx
80106b16:	29 da                	sub    %ebx,%edx
80106b18:	e8 c3 fb ff ff       	call   801066e0 <walkpgdir>
80106b1d:	85 c0                	test   %eax,%eax
80106b1f:	74 49                	je     80106b6a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b21:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b23:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b26:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b30:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b36:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b39:	29 d9                	sub    %ebx,%ecx
80106b3b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b40:	57                   	push   %edi
80106b41:	51                   	push   %ecx
80106b42:	50                   	push   %eax
80106b43:	ff 75 10             	pushl  0x10(%ebp)
80106b46:	e8 f5 ae ff ff       	call   80101a40 <readi>
80106b4b:	83 c4 10             	add    $0x10,%esp
80106b4e:	39 f8                	cmp    %edi,%eax
80106b50:	74 ae                	je     80106b00 <loaduvm+0x30>
}
80106b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b5a:	5b                   	pop    %ebx
80106b5b:	5e                   	pop    %esi
80106b5c:	5f                   	pop    %edi
80106b5d:	5d                   	pop    %ebp
80106b5e:	c3                   	ret    
80106b5f:	90                   	nop
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b6a:	83 ec 0c             	sub    $0xc,%esp
80106b6d:	68 d6 79 10 80       	push   $0x801079d6
80106b72:	e8 39 98 ff ff       	call   801003b0 <panic>
    panic("loaduvm: addr must be page aligned");
80106b77:	83 ec 0c             	sub    $0xc,%esp
80106b7a:	68 44 7a 10 80       	push   $0x80107a44
80106b7f:	e8 2c 98 ff ff       	call   801003b0 <panic>
80106b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b8f:	90                   	nop

80106b90 <allocuvm>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b99:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b9c:	85 ff                	test   %edi,%edi
80106b9e:	0f 88 ac 00 00 00    	js     80106c50 <allocuvm+0xc0>
  if(newsz < oldsz)
80106ba4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ba7:	0f 82 93 00 00 00    	jb     80106c40 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bb0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106bb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106bbc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bbf:	0f 86 7e 00 00 00    	jbe    80106c43 <allocuvm+0xb3>
80106bc5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106bc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bcb:	eb 42                	jmp    80106c0f <allocuvm+0x7f>
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106bd0:	83 ec 04             	sub    $0x4,%esp
80106bd3:	68 00 10 00 00       	push   $0x1000
80106bd8:	6a 00                	push   $0x0
80106bda:	50                   	push   %eax
80106bdb:	e8 80 d9 ff ff       	call   80104560 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106be0:	58                   	pop    %eax
80106be1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106be7:	5a                   	pop    %edx
80106be8:	6a 06                	push   $0x6
80106bea:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bef:	89 da                	mov    %ebx,%edx
80106bf1:	50                   	push   %eax
80106bf2:	89 f8                	mov    %edi,%eax
80106bf4:	e8 67 fb ff ff       	call   80106760 <mappages>
80106bf9:	83 c4 10             	add    $0x10,%esp
80106bfc:	85 c0                	test   %eax,%eax
80106bfe:	78 60                	js     80106c60 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106c00:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c06:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c09:	0f 86 81 00 00 00    	jbe    80106c90 <allocuvm+0x100>
    mem = kalloc();
80106c0f:	e8 cc b9 ff ff       	call   801025e0 <kalloc>
80106c14:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c16:	85 c0                	test   %eax,%eax
80106c18:	75 b6                	jne    80106bd0 <allocuvm+0x40>
  if(newsz >= oldsz)
80106c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c1d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c20:	74 2e                	je     80106c50 <allocuvm+0xc0>
80106c22:	89 c1                	mov    %eax,%ecx
80106c24:	8b 55 10             	mov    0x10(%ebp),%edx
80106c27:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c2a:	31 ff                	xor    %edi,%edi
80106c2c:	e8 bf fb ff ff       	call   801067f0 <deallocuvm.part.0>
}
80106c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c34:	89 f8                	mov    %edi,%eax
80106c36:	5b                   	pop    %ebx
80106c37:	5e                   	pop    %esi
80106c38:	5f                   	pop    %edi
80106c39:	5d                   	pop    %ebp
80106c3a:	c3                   	ret    
80106c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c3f:	90                   	nop
    return oldsz;
80106c40:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c46:	89 f8                	mov    %edi,%eax
80106c48:	5b                   	pop    %ebx
80106c49:	5e                   	pop    %esi
80106c4a:	5f                   	pop    %edi
80106c4b:	5d                   	pop    %ebp
80106c4c:	c3                   	ret    
80106c4d:	8d 76 00             	lea    0x0(%esi),%esi
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c53:	31 ff                	xor    %edi,%edi
}
80106c55:	5b                   	pop    %ebx
80106c56:	89 f8                	mov    %edi,%eax
80106c58:	5e                   	pop    %esi
80106c59:	5f                   	pop    %edi
80106c5a:	5d                   	pop    %ebp
80106c5b:	c3                   	ret    
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(newsz >= oldsz)
80106c60:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c63:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c66:	74 0d                	je     80106c75 <allocuvm+0xe5>
80106c68:	89 c1                	mov    %eax,%ecx
80106c6a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c70:	e8 7b fb ff ff       	call   801067f0 <deallocuvm.part.0>
      kfree(mem);
80106c75:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c78:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c7a:	56                   	push   %esi
80106c7b:	e8 a0 b7 ff ff       	call   80102420 <kfree>
      return 0;
80106c80:	83 c4 10             	add    $0x10,%esp
}
80106c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c86:	89 f8                	mov    %edi,%eax
80106c88:	5b                   	pop    %ebx
80106c89:	5e                   	pop    %esi
80106c8a:	5f                   	pop    %edi
80106c8b:	5d                   	pop    %ebp
80106c8c:	c3                   	ret    
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi
80106c90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c96:	5b                   	pop    %ebx
80106c97:	5e                   	pop    %esi
80106c98:	89 f8                	mov    %edi,%eax
80106c9a:	5f                   	pop    %edi
80106c9b:	5d                   	pop    %ebp
80106c9c:	c3                   	ret    
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ca0 <deallocuvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ca6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106cac:	39 d1                	cmp    %edx,%ecx
80106cae:	73 10                	jae    80106cc0 <deallocuvm+0x20>
}
80106cb0:	5d                   	pop    %ebp
80106cb1:	e9 3a fb ff ff       	jmp    801067f0 <deallocuvm.part.0>
80106cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbd:	8d 76 00             	lea    0x0(%esi),%esi
80106cc0:	89 d0                	mov    %edx,%eax
80106cc2:	5d                   	pop    %ebp
80106cc3:	c3                   	ret    
80106cc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ccf:	90                   	nop

80106cd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 0c             	sub    $0xc,%esp
80106cd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106cdc:	85 f6                	test   %esi,%esi
80106cde:	74 59                	je     80106d39 <freevm+0x69>
  if(newsz >= oldsz)
80106ce0:	31 c9                	xor    %ecx,%ecx
80106ce2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ce7:	89 f0                	mov    %esi,%eax
80106ce9:	89 f3                	mov    %esi,%ebx
80106ceb:	e8 00 fb ff ff       	call   801067f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cf0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cf6:	eb 0f                	jmp    80106d07 <freevm+0x37>
80106cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cff:	90                   	nop
80106d00:	83 c3 04             	add    $0x4,%ebx
80106d03:	39 df                	cmp    %ebx,%edi
80106d05:	74 23                	je     80106d2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d07:	8b 03                	mov    (%ebx),%eax
80106d09:	a8 01                	test   $0x1,%al
80106d0b:	74 f3                	je     80106d00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d12:	83 ec 0c             	sub    $0xc,%esp
80106d15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d1d:	50                   	push   %eax
80106d1e:	e8 fd b6 ff ff       	call   80102420 <kfree>
80106d23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d26:	39 df                	cmp    %ebx,%edi
80106d28:	75 dd                	jne    80106d07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d30:	5b                   	pop    %ebx
80106d31:	5e                   	pop    %esi
80106d32:	5f                   	pop    %edi
80106d33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d34:	e9 e7 b6 ff ff       	jmp    80102420 <kfree>
    panic("freevm: no pgdir");
80106d39:	83 ec 0c             	sub    $0xc,%esp
80106d3c:	68 f4 79 10 80       	push   $0x801079f4
80106d41:	e8 6a 96 ff ff       	call   801003b0 <panic>
80106d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi

80106d50 <setupkvm>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	56                   	push   %esi
80106d54:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d55:	e8 86 b8 ff ff       	call   801025e0 <kalloc>
80106d5a:	89 c6                	mov    %eax,%esi
80106d5c:	85 c0                	test   %eax,%eax
80106d5e:	74 42                	je     80106da2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d60:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d63:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d68:	68 00 10 00 00       	push   $0x1000
80106d6d:	6a 00                	push   $0x0
80106d6f:	50                   	push   %eax
80106d70:	e8 eb d7 ff ff       	call   80104560 <memset>
80106d75:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d78:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d7b:	83 ec 08             	sub    $0x8,%esp
80106d7e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d81:	ff 73 0c             	pushl  0xc(%ebx)
80106d84:	8b 13                	mov    (%ebx),%edx
80106d86:	50                   	push   %eax
80106d87:	29 c1                	sub    %eax,%ecx
80106d89:	89 f0                	mov    %esi,%eax
80106d8b:	e8 d0 f9 ff ff       	call   80106760 <mappages>
80106d90:	83 c4 10             	add    $0x10,%esp
80106d93:	85 c0                	test   %eax,%eax
80106d95:	78 19                	js     80106db0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d97:	83 c3 10             	add    $0x10,%ebx
80106d9a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106da0:	75 d6                	jne    80106d78 <setupkvm+0x28>
}
80106da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da5:	89 f0                	mov    %esi,%eax
80106da7:	5b                   	pop    %ebx
80106da8:	5e                   	pop    %esi
80106da9:	5d                   	pop    %ebp
80106daa:	c3                   	ret    
80106dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106daf:	90                   	nop
      freevm(pgdir);
80106db0:	83 ec 0c             	sub    $0xc,%esp
80106db3:	56                   	push   %esi
      return 0;
80106db4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106db6:	e8 15 ff ff ff       	call   80106cd0 <freevm>
      return 0;
80106dbb:	83 c4 10             	add    $0x10,%esp
}
80106dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106dc1:	89 f0                	mov    %esi,%eax
80106dc3:	5b                   	pop    %ebx
80106dc4:	5e                   	pop    %esi
80106dc5:	5d                   	pop    %ebp
80106dc6:	c3                   	ret    
80106dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <kvmalloc>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dd6:	e8 75 ff ff ff       	call   80106d50 <setupkvm>
80106ddb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106de0:	05 00 00 00 80       	add    $0x80000000,%eax
80106de5:	0f 22 d8             	mov    %eax,%cr3
}
80106de8:	c9                   	leave  
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106df0 <select_a_victim>:
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
	return 0;
}
80106df0:	31 c0                	xor    %eax,%eax
80106df2:	c3                   	ret    
80106df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e00 <clearaccessbit>:

// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{
}
80106e00:	c3                   	ret    
80106e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0f:	90                   	nop

80106e10 <getswappedblk>:
// was swapped, -1 otherwise.
int
getswappedblk(pde_t *pgdir, uint va)
{
  return -1;
}
80106e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e15:	c3                   	ret    
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi

80106e20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e21:	31 c9                	xor    %ecx,%ecx
{
80106e23:	89 e5                	mov    %esp,%ebp
80106e25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2e:	e8 ad f8 ff ff       	call   801066e0 <walkpgdir>
  if(pte == 0)
80106e33:	85 c0                	test   %eax,%eax
80106e35:	74 05                	je     80106e3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e3a:	c9                   	leave  
80106e3b:	c3                   	ret    
    panic("clearpteu");
80106e3c:	83 ec 0c             	sub    $0xc,%esp
80106e3f:	68 05 7a 10 80       	push   $0x80107a05
80106e44:	e8 67 95 ff ff       	call   801003b0 <panic>
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e59:	e8 f2 fe ff ff       	call   80106d50 <setupkvm>
80106e5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e61:	85 c0                	test   %eax,%eax
80106e63:	0f 84 a0 00 00 00    	je     80106f09 <copyuvm+0xb9>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e6c:	85 c9                	test   %ecx,%ecx
80106e6e:	0f 84 95 00 00 00    	je     80106f09 <copyuvm+0xb9>
80106e74:	31 f6                	xor    %esi,%esi
80106e76:	eb 4e                	jmp    80106ec6 <copyuvm+0x76>
80106e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7f:	90                   	nop
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;

    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e80:	83 ec 04             	sub    $0x4,%esp
80106e83:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e8c:	68 00 10 00 00       	push   $0x1000
80106e91:	57                   	push   %edi
80106e92:	50                   	push   %eax
80106e93:	e8 68 d7 ff ff       	call   80104600 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e98:	58                   	pop    %eax
80106e99:	5a                   	pop    %edx
80106e9a:	53                   	push   %ebx
80106e9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ea1:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ea6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106eac:	52                   	push   %edx
80106ead:	89 f2                	mov    %esi,%edx
80106eaf:	e8 ac f8 ff ff       	call   80106760 <mappages>
80106eb4:	83 c4 10             	add    $0x10,%esp
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	78 39                	js     80106ef4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106ebb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ec1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106ec4:	76 43                	jbe    80106f09 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec9:	31 c9                	xor    %ecx,%ecx
80106ecb:	89 f2                	mov    %esi,%edx
80106ecd:	e8 0e f8 ff ff       	call   801066e0 <walkpgdir>
80106ed2:	85 c0                	test   %eax,%eax
80106ed4:	74 3e                	je     80106f14 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106ed6:	8b 18                	mov    (%eax),%ebx
80106ed8:	f6 c3 01             	test   $0x1,%bl
80106edb:	74 44                	je     80106f21 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106edd:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106edf:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106ee5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106eeb:	e8 f0 b6 ff ff       	call   801025e0 <kalloc>
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	75 8c                	jne    80106e80 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ef4:	83 ec 0c             	sub    $0xc,%esp
80106ef7:	ff 75 e0             	pushl  -0x20(%ebp)
80106efa:	e8 d1 fd ff ff       	call   80106cd0 <freevm>
  return 0;
80106eff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106f06:	83 c4 10             	add    $0x10,%esp
}
80106f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f0f:	5b                   	pop    %ebx
80106f10:	5e                   	pop    %esi
80106f11:	5f                   	pop    %edi
80106f12:	5d                   	pop    %ebp
80106f13:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106f14:	83 ec 0c             	sub    $0xc,%esp
80106f17:	68 0f 7a 10 80       	push   $0x80107a0f
80106f1c:	e8 8f 94 ff ff       	call   801003b0 <panic>
      panic("copyuvm: page not present");
80106f21:	83 ec 0c             	sub    $0xc,%esp
80106f24:	68 29 7a 10 80       	push   $0x80107a29
80106f29:	e8 82 94 ff ff       	call   801003b0 <panic>
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f31:	31 c9                	xor    %ecx,%ecx
{
80106f33:	89 e5                	mov    %esp,%ebp
80106f35:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3e:	e8 9d f7 ff ff       	call   801066e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f43:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f45:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f46:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f4d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f50:	05 00 00 00 80       	add    $0x80000000,%eax
80106f55:	83 fa 05             	cmp    $0x5,%edx
80106f58:	ba 00 00 00 00       	mov    $0x0,%edx
80106f5d:	0f 45 c2             	cmovne %edx,%eax
}
80106f60:	c3                   	ret    
80106f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6f:	90                   	nop

80106f70 <uva2pte>:

// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
80106f70:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80106f71:	31 c9                	xor    %ecx,%ecx
{
80106f73:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80106f75:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106f7b:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80106f7c:	e9 5f f7 ff ff       	jmp    801066e0 <walkpgdir>
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8f:	90                   	nop

80106f90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	8b 75 14             	mov    0x14(%ebp),%esi
80106f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f9f:	85 f6                	test   %esi,%esi
80106fa1:	75 38                	jne    80106fdb <copyout+0x4b>
80106fa3:	eb 6b                	jmp    80107010 <copyout+0x80>
80106fa5:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fab:	89 fb                	mov    %edi,%ebx
80106fad:	29 d3                	sub    %edx,%ebx
80106faf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106fb5:	39 f3                	cmp    %esi,%ebx
80106fb7:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fba:	29 fa                	sub    %edi,%edx
80106fbc:	83 ec 04             	sub    $0x4,%esp
80106fbf:	01 c2                	add    %eax,%edx
80106fc1:	53                   	push   %ebx
80106fc2:	ff 75 10             	pushl  0x10(%ebp)
80106fc5:	52                   	push   %edx
80106fc6:	e8 35 d6 ff ff       	call   80104600 <memmove>
    len -= n;
    buf += n;
80106fcb:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106fce:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106fd4:	83 c4 10             	add    $0x10,%esp
80106fd7:	29 de                	sub    %ebx,%esi
80106fd9:	74 35                	je     80107010 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106fdb:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fdd:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106fe0:	89 55 0c             	mov    %edx,0xc(%ebp)
80106fe3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fe9:	57                   	push   %edi
80106fea:	ff 75 08             	pushl  0x8(%ebp)
80106fed:	e8 3e ff ff ff       	call   80106f30 <uva2ka>
    if(pa0 == 0)
80106ff2:	83 c4 10             	add    $0x10,%esp
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	75 af                	jne    80106fa8 <copyout+0x18>
  }
  return 0;
}
80106ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5f                   	pop    %edi
80107004:	5d                   	pop    %ebp
80107005:	c3                   	ret    
80107006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    


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
8010002d:	b8 90 31 10 80       	mov    $0x80103190,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	57                   	push   %edi
80100044:	56                   	push   %esi
80100045:	53                   	push   %ebx
80100046:	89 c6                	mov    %eax,%esi
80100048:	89 d7                	mov    %edx,%edi
8010004a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
8010004d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100052:	e8 49 45 00 00       	call   801045a0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100057:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
8010005d:	83 c4 10             	add    $0x10,%esp
80100060:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100066:	75 13                	jne    8010007b <bget+0x3b>
80100068:	eb 26                	jmp    80100090 <bget+0x50>
8010006a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100070:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100073:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100079:	74 15                	je     80100090 <bget+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010007b:	39 73 04             	cmp    %esi,0x4(%ebx)
8010007e:	75 f0                	jne    80100070 <bget+0x30>
80100080:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100083:	75 eb                	jne    80100070 <bget+0x30>
      b->refcnt++;
80100085:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100089:	eb 3f                	jmp    801000ca <bget+0x8a>
8010008b:	90                   	nop
8010008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100090:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100096:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010009c:	75 0d                	jne    801000ab <bget+0x6b>
8010009e:	eb 4f                	jmp    801000ef <bget+0xaf>
801000a0:	8b 5b 50             	mov    0x50(%ebx),%ebx
801000a3:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a9:	74 44                	je     801000ef <bget+0xaf>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000ab:	8b 43 4c             	mov    0x4c(%ebx),%eax
801000ae:	85 c0                	test   %eax,%eax
801000b0:	75 ee                	jne    801000a0 <bget+0x60>
801000b2:	f6 03 04             	testb  $0x4,(%ebx)
801000b5:	75 e9                	jne    801000a0 <bget+0x60>
      b->dev = dev;
801000b7:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000ba:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000c3:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000ca:	83 ec 0c             	sub    $0xc,%esp
801000cd:	68 c0 b5 10 80       	push   $0x8010b5c0
801000d2:	e8 e9 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
801000d7:	8d 43 0c             	lea    0xc(%ebx),%eax
801000da:	89 04 24             	mov    %eax,(%esp)
801000dd:	e8 fe 42 00 00       	call   801043e0 <acquiresleep>
      return b;
801000e2:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e8:	89 d8                	mov    %ebx,%eax
801000ea:	5b                   	pop    %ebx
801000eb:	5e                   	pop    %esi
801000ec:	5f                   	pop    %edi
801000ed:	5d                   	pop    %ebp
801000ee:	c3                   	ret    
  panic("bget: no buffers");
801000ef:	83 ec 0c             	sub    $0xc,%esp
801000f2:	68 c0 74 10 80       	push   $0x801074c0
801000f7:	e8 a4 03 00 00       	call   801004a0 <panic>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100100 <binit>:
{
80100100:	55                   	push   %ebp
80100101:	89 e5                	mov    %esp,%ebp
80100103:	53                   	push   %ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100104:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100109:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010010c:	68 d1 74 10 80       	push   $0x801074d1
80100111:	68 c0 b5 10 80       	push   $0x8010b5c0
80100116:	e8 95 43 00 00       	call   801044b0 <initlock>
  bcache.head.prev = &bcache.head;
8010011b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100122:	fc 10 80 
  bcache.head.next = &bcache.head;
80100125:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010012c:	fc 10 80 
8010012f:	83 c4 10             	add    $0x10,%esp
80100132:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100137:	eb 09                	jmp    80100142 <binit+0x42>
80100139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100140:	89 c3                	mov    %eax,%ebx
    initsleeplock(&b->lock, "buffer");
80100142:	8d 43 0c             	lea    0xc(%ebx),%eax
80100145:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100148:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010014b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100152:	68 d8 74 10 80       	push   $0x801074d8
80100157:	50                   	push   %eax
80100158:	e8 43 42 00 00       	call   801043a0 <initsleeplock>
    bcache.head.next->prev = b;
8010015d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100162:	83 c4 10             	add    $0x10,%esp
80100165:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
80100167:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010016a:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
80100170:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100176:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
8010017b:	72 c3                	jb     80100140 <binit+0x40>
}
8010017d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100180:	c9                   	leave  
80100181:	c3                   	ret    
80100182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100190 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100190:	55                   	push   %ebp
80100191:	89 e5                	mov    %esp,%ebp
80100193:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100196:	8b 55 0c             	mov    0xc(%ebp),%edx
80100199:	8b 45 08             	mov    0x8(%ebp),%eax
8010019c:	e8 9f fe ff ff       	call   80100040 <bget>
  if((b->flags & B_VALID) == 0) {
801001a1:	f6 00 02             	testb  $0x2,(%eax)
801001a4:	74 0a                	je     801001b0 <bread+0x20>
    iderw(b);
  }
  return b;
}
801001a6:	c9                   	leave  
801001a7:	c3                   	ret    
801001a8:	90                   	nop
801001a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	50                   	push   %eax
801001b7:	e8 14 22 00 00       	call   801023d0 <iderw>
801001bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001bf:	83 c4 10             	add    $0x10,%esp
}
801001c2:	c9                   	leave  
801001c3:	c3                   	ret    
801001c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801001ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
801001de:	e8 9d 42 00 00       	call   80104480 <holdingsleep>
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
801001f4:	e9 d7 21 00 00       	jmp    801023d0 <iderw>
    panic("bwrite");
801001f9:	83 ec 0c             	sub    $0xc,%esp
801001fc:	68 df 74 10 80       	push   $0x801074df
80100201:	e8 9a 02 00 00       	call   801004a0 <panic>
80100206:	8d 76 00             	lea    0x0(%esi),%esi
80100209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
80100218:	83 ec 0c             	sub    $0xc,%esp
8010021b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010021e:	56                   	push   %esi
8010021f:	e8 5c 42 00 00       	call   80104480 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	74 66                	je     80100291 <brelse+0x81>
    panic("brelse");
	
  releasesleep(&b->lock);
8010022b:	83 ec 0c             	sub    $0xc,%esp
8010022e:	56                   	push   %esi
8010022f:	e8 0c 42 00 00       	call   80104440 <releasesleep>

  acquire(&bcache.lock);
80100234:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010023b:	e8 60 43 00 00       	call   801045a0 <acquire>
  b->refcnt--;
80100240:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100243:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100246:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100249:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010024b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
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
8010028c:	e9 2f 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
80100291:	83 ec 0c             	sub    $0xc,%esp
80100294:	68 e6 74 10 80       	push   $0x801074e6
80100299:	e8 02 02 00 00       	call   801004a0 <panic>
8010029e:	66 90                	xchg   %ax,%ax

801002a0 <write_page_to_disk>:
{ 
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	53                   	push   %ebx
801002a6:	83 ec 1c             	sub    $0x1c,%esp
801002a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801002ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002af:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
801002b5:	89 fe                	mov    %edi,%esi
801002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801002ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    b[i] = bget(dev, blk+i);
801002c0:	8b 45 08             	mov    0x8(%ebp),%eax
801002c3:	89 da                	mov    %ebx,%edx
801002c5:	e8 76 fd ff ff       	call   80100040 <bget>
    for (index = 0; index < 512; index++) {
801002ca:	31 d2                	xor    %edx,%edx
    b[i] = bget(dev, blk+i);
801002cc:	89 c7                	mov    %eax,%edi
801002ce:	66 90                	xchg   %ax,%ax
      b[i] -> data[index] = pg[(i*512) + index];
801002d0:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
801002d4:	88 44 17 5c          	mov    %al,0x5c(%edi,%edx,1)
    for (index = 0; index < 512; index++) {
801002d8:	83 c2 01             	add    $0x1,%edx
801002db:	81 fa 00 02 00 00    	cmp    $0x200,%edx
801002e1:	75 ed                	jne    801002d0 <write_page_to_disk+0x30>
    bwrite(b[i]);
801002e3:	83 ec 0c             	sub    $0xc,%esp
801002e6:	83 c3 01             	add    $0x1,%ebx
801002e9:	81 c6 00 02 00 00    	add    $0x200,%esi
801002ef:	57                   	push   %edi
801002f0:	e8 db fe ff ff       	call   801001d0 <bwrite>
    brelse(b[i]);
801002f5:	89 3c 24             	mov    %edi,(%esp)
801002f8:	e8 13 ff ff ff       	call   80100210 <brelse>
  for (int i = 0; i < 8; ++i) {
801002fd:	83 c4 10             	add    $0x10,%esp
80100300:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100303:	75 bb                	jne    801002c0 <write_page_to_disk+0x20>
}
80100305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100308:	5b                   	pop    %ebx
80100309:	5e                   	pop    %esi
8010030a:	5f                   	pop    %edi
8010030b:	5d                   	pop    %ebp
8010030c:	c3                   	ret    
8010030d:	8d 76 00             	lea    0x0(%esi),%esi

80100310 <read_page_from_disk>:
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	57                   	push   %edi
80100314:	56                   	push   %esi
80100315:	53                   	push   %ebx
80100316:	83 ec 0c             	sub    $0xc,%esp
80100319:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010031c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010031f:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80100325:	8d 76 00             	lea    0x0(%esi),%esi
    b[i] = bread(ROOTDEV, blk + i);
80100328:	83 ec 08             	sub    $0x8,%esp
8010032b:	53                   	push   %ebx
8010032c:	6a 01                	push   $0x1
8010032e:	e8 5d fe ff ff       	call   80100190 <bread>
80100333:	83 c4 10             	add    $0x10,%esp
    for (index = 0; index < 512; index++) {
80100336:	31 d2                	xor    %edx,%edx
80100338:	90                   	nop
80100339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pg[(i*512) + index] = b[i] -> data[index];
80100340:	0f b6 4c 10 5c       	movzbl 0x5c(%eax,%edx,1),%ecx
80100345:	88 0c 17             	mov    %cl,(%edi,%edx,1)
    for (index = 0; index < 512; index++) {
80100348:	83 c2 01             	add    $0x1,%edx
8010034b:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80100351:	75 ed                	jne    80100340 <read_page_from_disk+0x30>
    brelse(b[i]);
80100353:	83 ec 0c             	sub    $0xc,%esp
80100356:	81 c7 00 02 00 00    	add    $0x200,%edi
8010035c:	83 c3 01             	add    $0x1,%ebx
8010035f:	50                   	push   %eax
80100360:	e8 ab fe ff ff       	call   80100210 <brelse>
  for (int i = 0; i < 8; i++) {
80100365:	83 c4 10             	add    $0x10,%esp
80100368:	39 fe                	cmp    %edi,%esi
8010036a:	75 bc                	jne    80100328 <read_page_from_disk+0x18>
}
8010036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010036f:	5b                   	pop    %ebx
80100370:	5e                   	pop    %esi
80100371:	5f                   	pop    %edi
80100372:	5d                   	pop    %ebp
80100373:	c3                   	ret    
80100374:	66 90                	xchg   %ax,%ax
80100376:	66 90                	xchg   %ax,%ax
80100378:	66 90                	xchg   %ax,%ax
8010037a:	66 90                	xchg   %ax,%ax
8010037c:	66 90                	xchg   %ax,%ax
8010037e:	66 90                	xchg   %ax,%ax

80100380 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	57                   	push   %edi
80100384:	56                   	push   %esi
80100385:	53                   	push   %ebx
80100386:	83 ec 28             	sub    $0x28,%esp
80100389:	8b 7d 08             	mov    0x8(%ebp),%edi
8010038c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010038f:	57                   	push   %edi
80100390:	e8 8b 16 00 00       	call   80101a20 <iunlock>
  target = n;
  acquire(&cons.lock);
80100395:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010039c:	e8 ff 41 00 00       	call   801045a0 <acquire>
  while(n > 0){
801003a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801003a4:	83 c4 10             	add    $0x10,%esp
801003a7:	31 c0                	xor    %eax,%eax
801003a9:	85 db                	test   %ebx,%ebx
801003ab:	0f 8e a1 00 00 00    	jle    80100452 <consoleread+0xd2>
    while(input.r == input.w){
801003b1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801003b7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801003bd:	74 2c                	je     801003eb <consoleread+0x6b>
801003bf:	eb 5f                	jmp    80100420 <consoleread+0xa0>
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	68 20 a5 10 80       	push   $0x8010a520
801003d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801003d5:	e8 66 3c 00 00       	call   80104040 <sleep>
    while(input.r == input.w){
801003da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801003e0:	83 c4 10             	add    $0x10,%esp
801003e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801003e9:	75 35                	jne    80100420 <consoleread+0xa0>
      if(myproc()->killed){
801003eb:	e8 e0 36 00 00       	call   80103ad0 <myproc>
801003f0:	8b 40 24             	mov    0x24(%eax),%eax
801003f3:	85 c0                	test   %eax,%eax
801003f5:	74 d1                	je     801003c8 <consoleread+0x48>
        release(&cons.lock);
801003f7:	83 ec 0c             	sub    $0xc,%esp
801003fa:	68 20 a5 10 80       	push   $0x8010a520
801003ff:	e8 bc 42 00 00       	call   801046c0 <release>
        ilock(ip);
80100404:	89 3c 24             	mov    %edi,(%esp)
80100407:	e8 34 15 00 00       	call   80101940 <ilock>
        return -1;
8010040c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010040f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100417:	5b                   	pop    %ebx
80100418:	5e                   	pop    %esi
80100419:	5f                   	pop    %edi
8010041a:	5d                   	pop    %ebp
8010041b:	c3                   	ret    
8010041c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100420:	8d 42 01             	lea    0x1(%edx),%eax
80100423:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100428:	89 d0                	mov    %edx,%eax
8010042a:	83 e0 7f             	and    $0x7f,%eax
8010042d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100434:	83 f8 04             	cmp    $0x4,%eax
80100437:	74 3f                	je     80100478 <consoleread+0xf8>
    *dst++ = c;
80100439:	83 c6 01             	add    $0x1,%esi
    --n;
8010043c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010043f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100442:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100445:	74 43                	je     8010048a <consoleread+0x10a>
  while(n > 0){
80100447:	85 db                	test   %ebx,%ebx
80100449:	0f 85 62 ff ff ff    	jne    801003b1 <consoleread+0x31>
8010044f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100452:	83 ec 0c             	sub    $0xc,%esp
80100455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100458:	68 20 a5 10 80       	push   $0x8010a520
8010045d:	e8 5e 42 00 00       	call   801046c0 <release>
  ilock(ip);
80100462:	89 3c 24             	mov    %edi,(%esp)
80100465:	e8 d6 14 00 00       	call   80101940 <ilock>
  return target - n;
8010046a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010046d:	83 c4 10             	add    $0x10,%esp
}
80100470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100473:	5b                   	pop    %ebx
80100474:	5e                   	pop    %esi
80100475:	5f                   	pop    %edi
80100476:	5d                   	pop    %ebp
80100477:	c3                   	ret    
80100478:	8b 45 10             	mov    0x10(%ebp),%eax
8010047b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010047d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100480:	73 d0                	jae    80100452 <consoleread+0xd2>
        input.r--;
80100482:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100488:	eb c8                	jmp    80100452 <consoleread+0xd2>
8010048a:	8b 45 10             	mov    0x10(%ebp),%eax
8010048d:	29 d8                	sub    %ebx,%eax
8010048f:	eb c1                	jmp    80100452 <consoleread+0xd2>
80100491:	eb 0d                	jmp    801004a0 <panic>
80100493:	90                   	nop
80100494:	90                   	nop
80100495:	90                   	nop
80100496:	90                   	nop
80100497:	90                   	nop
80100498:	90                   	nop
80100499:	90                   	nop
8010049a:	90                   	nop
8010049b:	90                   	nop
8010049c:	90                   	nop
8010049d:	90                   	nop
8010049e:	90                   	nop
8010049f:	90                   	nop

801004a0 <panic>:
{
801004a0:	55                   	push   %ebp
801004a1:	89 e5                	mov    %esp,%ebp
801004a3:	56                   	push   %esi
801004a4:	53                   	push   %ebx
801004a5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801004a8:	fa                   	cli    
  cons.locking = 0;
801004a9:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801004b0:	00 00 00 
  getcallerpcs(&s, pcs);
801004b3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004b6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801004b9:	e8 52 25 00 00       	call   80102a10 <lapicid>
801004be:	83 ec 08             	sub    $0x8,%esp
801004c1:	50                   	push   %eax
801004c2:	68 ed 74 10 80       	push   $0x801074ed
801004c7:	e8 a4 02 00 00       	call   80100770 <cprintf>
  cprintf(s);
801004cc:	58                   	pop    %eax
801004cd:	ff 75 08             	pushl  0x8(%ebp)
801004d0:	e8 9b 02 00 00       	call   80100770 <cprintf>
  cprintf("\n");
801004d5:	c7 04 24 c4 7e 10 80 	movl   $0x80107ec4,(%esp)
801004dc:	e8 8f 02 00 00       	call   80100770 <cprintf>
  getcallerpcs(&s, pcs);
801004e1:	5a                   	pop    %edx
801004e2:	8d 45 08             	lea    0x8(%ebp),%eax
801004e5:	59                   	pop    %ecx
801004e6:	53                   	push   %ebx
801004e7:	50                   	push   %eax
801004e8:	e8 e3 3f 00 00       	call   801044d0 <getcallerpcs>
801004ed:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004f0:	83 ec 08             	sub    $0x8,%esp
801004f3:	ff 33                	pushl  (%ebx)
801004f5:	83 c3 04             	add    $0x4,%ebx
801004f8:	68 01 75 10 80       	push   $0x80107501
801004fd:	e8 6e 02 00 00       	call   80100770 <cprintf>
  for(i=0; i<10; i++)
80100502:	83 c4 10             	add    $0x10,%esp
80100505:	39 f3                	cmp    %esi,%ebx
80100507:	75 e7                	jne    801004f0 <panic+0x50>
  panicked = 1; // freeze other CPU
80100509:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100510:	00 00 00 
80100513:	eb fe                	jmp    80100513 <panic+0x73>
80100515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100520 <consputc>:
  if(panicked){
80100520:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100526:	85 c9                	test   %ecx,%ecx
80100528:	74 06                	je     80100530 <consputc+0x10>
8010052a:	fa                   	cli    
8010052b:	eb fe                	jmp    8010052b <consputc+0xb>
8010052d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	57                   	push   %edi
80100534:	56                   	push   %esi
80100535:	53                   	push   %ebx
80100536:	89 c6                	mov    %eax,%esi
80100538:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010053b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100540:	0f 84 b1 00 00 00    	je     801005f7 <consputc+0xd7>
    uartputc(c);
80100546:	83 ec 0c             	sub    $0xc,%esp
80100549:	50                   	push   %eax
8010054a:	e8 61 5a 00 00       	call   80105fb0 <uartputc>
8010054f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100552:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100557:	b8 0e 00 00 00       	mov    $0xe,%eax
8010055c:	89 da                	mov    %ebx,%edx
8010055e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010055f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100564:	89 ca                	mov    %ecx,%edx
80100566:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100567:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056a:	89 da                	mov    %ebx,%edx
8010056c:	c1 e0 08             	shl    $0x8,%eax
8010056f:	89 c7                	mov    %eax,%edi
80100571:	b8 0f 00 00 00       	mov    $0xf,%eax
80100576:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100577:	89 ca                	mov    %ecx,%edx
80100579:	ec                   	in     (%dx),%al
8010057a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010057d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010057f:	83 fe 0a             	cmp    $0xa,%esi
80100582:	0f 84 f3 00 00 00    	je     8010067b <consputc+0x15b>
  else if(c == BACKSPACE){
80100588:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010058e:	0f 84 d7 00 00 00    	je     8010066b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100594:	89 f0                	mov    %esi,%eax
80100596:	0f b6 c0             	movzbl %al,%eax
80100599:	80 cc 07             	or     $0x7,%ah
8010059c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005a3:	80 
801005a4:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
801005a7:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801005ad:	0f 8f ab 00 00 00    	jg     8010065e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801005b3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801005b9:	7f 66                	jg     80100621 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005bb:	be d4 03 00 00       	mov    $0x3d4,%esi
801005c0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005c5:	89 f2                	mov    %esi,%edx
801005c7:	ee                   	out    %al,(%dx)
801005c8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801005cd:	89 d8                	mov    %ebx,%eax
801005cf:	c1 f8 08             	sar    $0x8,%eax
801005d2:	89 ca                	mov    %ecx,%edx
801005d4:	ee                   	out    %al,(%dx)
801005d5:	b8 0f 00 00 00       	mov    $0xf,%eax
801005da:	89 f2                	mov    %esi,%edx
801005dc:	ee                   	out    %al,(%dx)
801005dd:	89 d8                	mov    %ebx,%eax
801005df:	89 ca                	mov    %ecx,%edx
801005e1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801005e2:	b8 20 07 00 00       	mov    $0x720,%eax
801005e7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005ee:	80 
}
801005ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f2:	5b                   	pop    %ebx
801005f3:	5e                   	pop    %esi
801005f4:	5f                   	pop    %edi
801005f5:	5d                   	pop    %ebp
801005f6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005f7:	83 ec 0c             	sub    $0xc,%esp
801005fa:	6a 08                	push   $0x8
801005fc:	e8 af 59 00 00       	call   80105fb0 <uartputc>
80100601:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100608:	e8 a3 59 00 00       	call   80105fb0 <uartputc>
8010060d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100614:	e8 97 59 00 00       	call   80105fb0 <uartputc>
80100619:	83 c4 10             	add    $0x10,%esp
8010061c:	e9 31 ff ff ff       	jmp    80100552 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100621:	52                   	push   %edx
80100622:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100627:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010062a:	68 a0 80 0b 80       	push   $0x800b80a0
8010062f:	68 00 80 0b 80       	push   $0x800b8000
80100634:	e8 97 41 00 00       	call   801047d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100639:	b8 80 07 00 00       	mov    $0x780,%eax
8010063e:	83 c4 0c             	add    $0xc,%esp
80100641:	29 d8                	sub    %ebx,%eax
80100643:	01 c0                	add    %eax,%eax
80100645:	50                   	push   %eax
80100646:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100649:	6a 00                	push   $0x0
8010064b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100650:	50                   	push   %eax
80100651:	e8 ca 40 00 00       	call   80104720 <memset>
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	e9 5d ff ff ff       	jmp    801005bb <consputc+0x9b>
    panic("pos under/overflow");
8010065e:	83 ec 0c             	sub    $0xc,%esp
80100661:	68 05 75 10 80       	push   $0x80107505
80100666:	e8 35 fe ff ff       	call   801004a0 <panic>
    if(pos > 0) --pos;
8010066b:	85 db                	test   %ebx,%ebx
8010066d:	0f 84 48 ff ff ff    	je     801005bb <consputc+0x9b>
80100673:	83 eb 01             	sub    $0x1,%ebx
80100676:	e9 2c ff ff ff       	jmp    801005a7 <consputc+0x87>
    pos += 80 - pos%80;
8010067b:	89 d8                	mov    %ebx,%eax
8010067d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100682:	99                   	cltd   
80100683:	f7 f9                	idiv   %ecx
80100685:	29 d1                	sub    %edx,%ecx
80100687:	01 cb                	add    %ecx,%ebx
80100689:	e9 19 ff ff ff       	jmp    801005a7 <consputc+0x87>
8010068e:	66 90                	xchg   %ax,%ax

80100690 <printint>:
{
80100690:	55                   	push   %ebp
80100691:	89 e5                	mov    %esp,%ebp
80100693:	57                   	push   %edi
80100694:	56                   	push   %esi
80100695:	53                   	push   %ebx
80100696:	89 d3                	mov    %edx,%ebx
80100698:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010069b:	85 c9                	test   %ecx,%ecx
{
8010069d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801006a0:	74 04                	je     801006a6 <printint+0x16>
801006a2:	85 c0                	test   %eax,%eax
801006a4:	78 5a                	js     80100700 <printint+0x70>
    x = xx;
801006a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
801006ad:	31 c9                	xor    %ecx,%ecx
801006af:	8d 75 d7             	lea    -0x29(%ebp),%esi
801006b2:	eb 06                	jmp    801006ba <printint+0x2a>
801006b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801006b8:	89 f9                	mov    %edi,%ecx
801006ba:	31 d2                	xor    %edx,%edx
801006bc:	8d 79 01             	lea    0x1(%ecx),%edi
801006bf:	f7 f3                	div    %ebx
801006c1:	0f b6 92 30 75 10 80 	movzbl -0x7fef8ad0(%edx),%edx
  }while((x /= base) != 0);
801006c8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801006ca:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801006cd:	75 e9                	jne    801006b8 <printint+0x28>
  if(sign)
801006cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006d2:	85 c0                	test   %eax,%eax
801006d4:	74 08                	je     801006de <printint+0x4e>
    buf[i++] = '-';
801006d6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006db:	8d 79 02             	lea    0x2(%ecx),%edi
801006de:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801006e8:	0f be 03             	movsbl (%ebx),%eax
801006eb:	83 eb 01             	sub    $0x1,%ebx
801006ee:	e8 2d fe ff ff       	call   80100520 <consputc>
  while(--i >= 0)
801006f3:	39 f3                	cmp    %esi,%ebx
801006f5:	75 f1                	jne    801006e8 <printint+0x58>
}
801006f7:	83 c4 2c             	add    $0x2c,%esp
801006fa:	5b                   	pop    %ebx
801006fb:	5e                   	pop    %esi
801006fc:	5f                   	pop    %edi
801006fd:	5d                   	pop    %ebp
801006fe:	c3                   	ret    
801006ff:	90                   	nop
    x = -xx;
80100700:	f7 d8                	neg    %eax
80100702:	eb a9                	jmp    801006ad <printint+0x1d>
80100704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010070a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100710 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100710:	55                   	push   %ebp
80100711:	89 e5                	mov    %esp,%ebp
80100713:	57                   	push   %edi
80100714:	56                   	push   %esi
80100715:	53                   	push   %ebx
80100716:	83 ec 18             	sub    $0x18,%esp
80100719:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010071c:	ff 75 08             	pushl  0x8(%ebp)
8010071f:	e8 fc 12 00 00       	call   80101a20 <iunlock>
  acquire(&cons.lock);
80100724:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010072b:	e8 70 3e 00 00       	call   801045a0 <acquire>
  for(i = 0; i < n; i++)
80100730:	83 c4 10             	add    $0x10,%esp
80100733:	85 f6                	test   %esi,%esi
80100735:	7e 18                	jle    8010074f <consolewrite+0x3f>
80100737:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010073a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010073d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100740:	0f b6 07             	movzbl (%edi),%eax
80100743:	83 c7 01             	add    $0x1,%edi
80100746:	e8 d5 fd ff ff       	call   80100520 <consputc>
  for(i = 0; i < n; i++)
8010074b:	39 fb                	cmp    %edi,%ebx
8010074d:	75 f1                	jne    80100740 <consolewrite+0x30>
  release(&cons.lock);
8010074f:	83 ec 0c             	sub    $0xc,%esp
80100752:	68 20 a5 10 80       	push   $0x8010a520
80100757:	e8 64 3f 00 00       	call   801046c0 <release>
  ilock(ip);
8010075c:	58                   	pop    %eax
8010075d:	ff 75 08             	pushl  0x8(%ebp)
80100760:	e8 db 11 00 00       	call   80101940 <ilock>

  return n;
}
80100765:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100768:	89 f0                	mov    %esi,%eax
8010076a:	5b                   	pop    %ebx
8010076b:	5e                   	pop    %esi
8010076c:	5f                   	pop    %edi
8010076d:	5d                   	pop    %ebp
8010076e:	c3                   	ret    
8010076f:	90                   	nop

80100770 <cprintf>:
{
80100770:	55                   	push   %ebp
80100771:	89 e5                	mov    %esp,%ebp
80100773:	57                   	push   %edi
80100774:	56                   	push   %esi
80100775:	53                   	push   %ebx
80100776:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100779:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010077e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100780:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100783:	0f 85 6f 01 00 00    	jne    801008f8 <cprintf+0x188>
  if (fmt == 0)
80100789:	8b 45 08             	mov    0x8(%ebp),%eax
8010078c:	85 c0                	test   %eax,%eax
8010078e:	89 c7                	mov    %eax,%edi
80100790:	0f 84 77 01 00 00    	je     8010090d <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100796:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100799:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010079e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a1:	85 c0                	test   %eax,%eax
801007a3:	75 56                	jne    801007fb <cprintf+0x8b>
801007a5:	eb 79                	jmp    80100820 <cprintf+0xb0>
801007a7:	89 f6                	mov    %esi,%esi
801007a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801007b0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801007b3:	85 d2                	test   %edx,%edx
801007b5:	74 69                	je     80100820 <cprintf+0xb0>
801007b7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801007ba:	83 fa 70             	cmp    $0x70,%edx
801007bd:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007c0:	0f 84 84 00 00 00    	je     8010084a <cprintf+0xda>
801007c6:	7f 78                	jg     80100840 <cprintf+0xd0>
801007c8:	83 fa 25             	cmp    $0x25,%edx
801007cb:	0f 84 ff 00 00 00    	je     801008d0 <cprintf+0x160>
801007d1:	83 fa 64             	cmp    $0x64,%edx
801007d4:	0f 85 8e 00 00 00    	jne    80100868 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801007da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007dd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007e2:	8d 48 04             	lea    0x4(%eax),%ecx
801007e5:	8b 00                	mov    (%eax),%eax
801007e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007ea:	b9 01 00 00 00       	mov    $0x1,%ecx
801007ef:	e8 9c fe ff ff       	call   80100690 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007f4:	0f b6 06             	movzbl (%esi),%eax
801007f7:	85 c0                	test   %eax,%eax
801007f9:	74 25                	je     80100820 <cprintf+0xb0>
801007fb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801007fe:	83 f8 25             	cmp    $0x25,%eax
80100801:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100804:	74 aa                	je     801007b0 <cprintf+0x40>
80100806:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100809:	e8 12 fd ff ff       	call   80100520 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080e:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100816:	85 c0                	test   %eax,%eax
80100818:	75 e1                	jne    801007fb <cprintf+0x8b>
8010081a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100820:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100823:	85 c0                	test   %eax,%eax
80100825:	74 10                	je     80100837 <cprintf+0xc7>
    release(&cons.lock);
80100827:	83 ec 0c             	sub    $0xc,%esp
8010082a:	68 20 a5 10 80       	push   $0x8010a520
8010082f:	e8 8c 3e 00 00       	call   801046c0 <release>
80100834:	83 c4 10             	add    $0x10,%esp
}
80100837:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	90                   	nop
    switch(c){
80100840:	83 fa 73             	cmp    $0x73,%edx
80100843:	74 43                	je     80100888 <cprintf+0x118>
80100845:	83 fa 78             	cmp    $0x78,%edx
80100848:	75 1e                	jne    80100868 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010084a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010084d:	ba 10 00 00 00       	mov    $0x10,%edx
80100852:	8d 48 04             	lea    0x4(%eax),%ecx
80100855:	8b 00                	mov    (%eax),%eax
80100857:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010085a:	31 c9                	xor    %ecx,%ecx
8010085c:	e8 2f fe ff ff       	call   80100690 <printint>
      break;
80100861:	eb 91                	jmp    801007f4 <cprintf+0x84>
80100863:	90                   	nop
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100868:	b8 25 00 00 00       	mov    $0x25,%eax
8010086d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100870:	e8 ab fc ff ff       	call   80100520 <consputc>
      consputc(c);
80100875:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100878:	89 d0                	mov    %edx,%eax
8010087a:	e8 a1 fc ff ff       	call   80100520 <consputc>
      break;
8010087f:	e9 70 ff ff ff       	jmp    801007f4 <cprintf+0x84>
80100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010088b:	8b 10                	mov    (%eax),%edx
8010088d:	8d 48 04             	lea    0x4(%eax),%ecx
80100890:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100893:	85 d2                	test   %edx,%edx
80100895:	74 49                	je     801008e0 <cprintf+0x170>
      for(; *s; s++)
80100897:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010089a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010089d:	84 c0                	test   %al,%al
8010089f:	0f 84 4f ff ff ff    	je     801007f4 <cprintf+0x84>
801008a5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008a8:	89 d3                	mov    %edx,%ebx
801008aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008b0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801008b3:	e8 68 fc ff ff       	call   80100520 <consputc>
      for(; *s; s++)
801008b8:	0f be 03             	movsbl (%ebx),%eax
801008bb:	84 c0                	test   %al,%al
801008bd:	75 f1                	jne    801008b0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008c8:	e9 27 ff ff ff       	jmp    801007f4 <cprintf+0x84>
801008cd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801008d0:	b8 25 00 00 00       	mov    $0x25,%eax
801008d5:	e8 46 fc ff ff       	call   80100520 <consputc>
      break;
801008da:	e9 15 ff ff ff       	jmp    801007f4 <cprintf+0x84>
801008df:	90                   	nop
        s = "(null)";
801008e0:	ba 18 75 10 80       	mov    $0x80107518,%edx
      for(; *s; s++)
801008e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008e8:	b8 28 00 00 00       	mov    $0x28,%eax
801008ed:	89 d3                	mov    %edx,%ebx
801008ef:	eb bf                	jmp    801008b0 <cprintf+0x140>
801008f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801008f8:	83 ec 0c             	sub    $0xc,%esp
801008fb:	68 20 a5 10 80       	push   $0x8010a520
80100900:	e8 9b 3c 00 00       	call   801045a0 <acquire>
80100905:	83 c4 10             	add    $0x10,%esp
80100908:	e9 7c fe ff ff       	jmp    80100789 <cprintf+0x19>
    panic("null fmt");
8010090d:	83 ec 0c             	sub    $0xc,%esp
80100910:	68 1f 75 10 80       	push   $0x8010751f
80100915:	e8 86 fb ff ff       	call   801004a0 <panic>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100920 <consoleintr>:
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	57                   	push   %edi
80100924:	56                   	push   %esi
80100925:	53                   	push   %ebx
  int c, doprocdump = 0;
80100926:	31 f6                	xor    %esi,%esi
{
80100928:	83 ec 18             	sub    $0x18,%esp
8010092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010092e:	68 20 a5 10 80       	push   $0x8010a520
80100933:	e8 68 3c 00 00       	call   801045a0 <acquire>
  while((c = getc()) >= 0){
80100938:	83 c4 10             	add    $0x10,%esp
8010093b:	90                   	nop
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100940:	ff d3                	call   *%ebx
80100942:	85 c0                	test   %eax,%eax
80100944:	89 c7                	mov    %eax,%edi
80100946:	78 48                	js     80100990 <consoleintr+0x70>
    switch(c){
80100948:	83 ff 10             	cmp    $0x10,%edi
8010094b:	0f 84 e7 00 00 00    	je     80100a38 <consoleintr+0x118>
80100951:	7e 5d                	jle    801009b0 <consoleintr+0x90>
80100953:	83 ff 15             	cmp    $0x15,%edi
80100956:	0f 84 ec 00 00 00    	je     80100a48 <consoleintr+0x128>
8010095c:	83 ff 7f             	cmp    $0x7f,%edi
8010095f:	75 54                	jne    801009b5 <consoleintr+0x95>
      if(input.e != input.w){
80100961:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100966:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096c:	74 d2                	je     80100940 <consoleintr+0x20>
        input.e--;
8010096e:	83 e8 01             	sub    $0x1,%eax
80100971:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100976:	b8 00 01 00 00       	mov    $0x100,%eax
8010097b:	e8 a0 fb ff ff       	call   80100520 <consputc>
  while((c = getc()) >= 0){
80100980:	ff d3                	call   *%ebx
80100982:	85 c0                	test   %eax,%eax
80100984:	89 c7                	mov    %eax,%edi
80100986:	79 c0                	jns    80100948 <consoleintr+0x28>
80100988:	90                   	nop
80100989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100990:	83 ec 0c             	sub    $0xc,%esp
80100993:	68 20 a5 10 80       	push   $0x8010a520
80100998:	e8 23 3d 00 00       	call   801046c0 <release>
  if(doprocdump) {
8010099d:	83 c4 10             	add    $0x10,%esp
801009a0:	85 f6                	test   %esi,%esi
801009a2:	0f 85 f8 00 00 00    	jne    80100aa0 <consoleintr+0x180>
}
801009a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ab:	5b                   	pop    %ebx
801009ac:	5e                   	pop    %esi
801009ad:	5f                   	pop    %edi
801009ae:	5d                   	pop    %ebp
801009af:	c3                   	ret    
    switch(c){
801009b0:	83 ff 08             	cmp    $0x8,%edi
801009b3:	74 ac                	je     80100961 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009b5:	85 ff                	test   %edi,%edi
801009b7:	74 87                	je     80100940 <consoleintr+0x20>
801009b9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801009c6:	83 fa 7f             	cmp    $0x7f,%edx
801009c9:	0f 87 71 ff ff ff    	ja     80100940 <consoleintr+0x20>
801009cf:	8d 50 01             	lea    0x1(%eax),%edx
801009d2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009d5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009d8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801009de:	0f 84 cc 00 00 00    	je     80100ab0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801009e4:	89 f9                	mov    %edi,%ecx
801009e6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801009ec:	89 f8                	mov    %edi,%eax
801009ee:	e8 2d fb ff ff       	call   80100520 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009f3:	83 ff 0a             	cmp    $0xa,%edi
801009f6:	0f 84 c5 00 00 00    	je     80100ac1 <consoleintr+0x1a1>
801009fc:	83 ff 04             	cmp    $0x4,%edi
801009ff:	0f 84 bc 00 00 00    	je     80100ac1 <consoleintr+0x1a1>
80100a05:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100a0a:	83 e8 80             	sub    $0xffffff80,%eax
80100a0d:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100a13:	0f 85 27 ff ff ff    	jne    80100940 <consoleintr+0x20>
          wakeup(&input.r);
80100a19:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a1c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a21:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a26:	e8 d5 37 00 00       	call   80104200 <wakeup>
80100a2b:	83 c4 10             	add    $0x10,%esp
80100a2e:	e9 0d ff ff ff       	jmp    80100940 <consoleintr+0x20>
80100a33:	90                   	nop
80100a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100a38:	be 01 00 00 00       	mov    $0x1,%esi
80100a3d:	e9 fe fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100a48:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100a4d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100a53:	75 2b                	jne    80100a80 <consoleintr+0x160>
80100a55:	e9 e6 fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100a60:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100a65:	b8 00 01 00 00       	mov    $0x100,%eax
80100a6a:	e8 b1 fa ff ff       	call   80100520 <consputc>
      while(input.e != input.w &&
80100a6f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100a74:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100a7a:	0f 84 c0 fe ff ff    	je     80100940 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a80:	83 e8 01             	sub    $0x1,%eax
80100a83:	89 c2                	mov    %eax,%edx
80100a85:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a88:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100a8f:	75 cf                	jne    80100a60 <consoleintr+0x140>
80100a91:	e9 aa fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a96:	8d 76 00             	lea    0x0(%esi),%esi
80100a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100aa7:	e9 34 38 00 00       	jmp    801042e0 <procdump>
80100aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ab0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100ab7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100abc:	e8 5f fa ff ff       	call   80100520 <consputc>
80100ac1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100ac6:	e9 4e ff ff ff       	jmp    80100a19 <consoleintr+0xf9>
80100acb:	90                   	nop
80100acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ad6:	68 28 75 10 80       	push   $0x80107528
80100adb:	68 20 a5 10 80       	push   $0x8010a520
80100ae0:	e8 cb 39 00 00       	call   801044b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ae5:	58                   	pop    %eax
80100ae6:	5a                   	pop    %edx
80100ae7:	6a 00                	push   $0x0
80100ae9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100aeb:	c7 05 6c 09 11 80 10 	movl   $0x80100710,0x8011096c
80100af2:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80100af5:	c7 05 68 09 11 80 80 	movl   $0x80100380,0x80110968
80100afc:	03 10 80 
  cons.locking = 1;
80100aff:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100b06:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b09:	e8 72 1a 00 00       	call   80102580 <ioapicenable>
}
80100b0e:	83 c4 10             	add    $0x10,%esp
80100b11:	c9                   	leave  
80100b12:	c3                   	ret    
80100b13:	66 90                	xchg   %ax,%ax
80100b15:	66 90                	xchg   %ax,%ax
80100b17:	66 90                	xchg   %ax,%ax
80100b19:	66 90                	xchg   %ax,%ax
80100b1b:	66 90                	xchg   %ax,%ax
80100b1d:	66 90                	xchg   %ax,%ax
80100b1f:	90                   	nop

80100b20 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b20:	55                   	push   %ebp
80100b21:	89 e5                	mov    %esp,%ebp
80100b23:	57                   	push   %edi
80100b24:	56                   	push   %esi
80100b25:	53                   	push   %ebx
80100b26:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b2c:	e8 9f 2f 00 00       	call   80103ad0 <myproc>
80100b31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100b37:	e8 44 23 00 00       	call   80102e80 <begin_op>

  if((ip = namei(path)) == 0){
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	pushl  0x8(%ebp)
80100b42:	e8 59 16 00 00       	call   801021a0 <namei>
80100b47:	83 c4 10             	add    $0x10,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 84 91 01 00 00    	je     80100ce3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	89 c3                	mov    %eax,%ebx
80100b57:	50                   	push   %eax
80100b58:	e8 e3 0d 00 00       	call   80101940 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b63:	6a 34                	push   $0x34
80100b65:	6a 00                	push   $0x0
80100b67:	50                   	push   %eax
80100b68:	53                   	push   %ebx
80100b69:	e8 b2 10 00 00       	call   80101c20 <readi>
80100b6e:	83 c4 20             	add    $0x20,%esp
80100b71:	83 f8 34             	cmp    $0x34,%eax
80100b74:	74 22                	je     80100b98 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b76:	83 ec 0c             	sub    $0xc,%esp
80100b79:	53                   	push   %ebx
80100b7a:	e8 51 10 00 00       	call   80101bd0 <iunlockput>
    end_op();
80100b7f:	e8 6c 23 00 00       	call   80102ef0 <end_op>
80100b84:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b8f:	5b                   	pop    %ebx
80100b90:	5e                   	pop    %esi
80100b91:	5f                   	pop    %edi
80100b92:	5d                   	pop    %ebp
80100b93:	c3                   	ret    
80100b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b98:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b9f:	45 4c 46 
80100ba2:	75 d2                	jne    80100b76 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100ba4:	e8 67 66 00 00       	call   80107210 <setupkvm>
80100ba9:	85 c0                	test   %eax,%eax
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	74 c3                	je     80100b76 <exec+0x56>
  sz = 0;
80100bb3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bbc:	00 
80100bbd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100bc3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bc9:	0f 84 8c 02 00 00    	je     80100e5b <exec+0x33b>
80100bcf:	31 f6                	xor    %esi,%esi
80100bd1:	eb 7f                	jmp    80100c52 <exec+0x132>
80100bd3:	90                   	nop
80100bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bd8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bdf:	75 63                	jne    80100c44 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100be1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100be7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bed:	0f 82 86 00 00 00    	jb     80100c79 <exec+0x159>
80100bf3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bf9:	72 7e                	jb     80100c79 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfb:	83 ec 04             	sub    $0x4,%esp
80100bfe:	50                   	push   %eax
80100bff:	57                   	push   %edi
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 75 64 00 00       	call   80107080 <allocuvm>
80100c0b:	83 c4 10             	add    $0x10,%esp
80100c0e:	85 c0                	test   %eax,%eax
80100c10:	89 c7                	mov    %eax,%edi
80100c12:	74 65                	je     80100c79 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100c14:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c1a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c1f:	75 58                	jne    80100c79 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c21:	83 ec 0c             	sub    $0xc,%esp
80100c24:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c2a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c30:	53                   	push   %ebx
80100c31:	50                   	push   %eax
80100c32:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c38:	e8 93 61 00 00       	call   80106dd0 <loaduvm>
80100c3d:	83 c4 20             	add    $0x20,%esp
80100c40:	85 c0                	test   %eax,%eax
80100c42:	78 35                	js     80100c79 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c44:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4b:	83 c6 01             	add    $0x1,%esi
80100c4e:	39 f0                	cmp    %esi,%eax
80100c50:	7e 3d                	jle    80100c8f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c52:	89 f0                	mov    %esi,%eax
80100c54:	6a 20                	push   $0x20
80100c56:	c1 e0 05             	shl    $0x5,%eax
80100c59:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100c5f:	50                   	push   %eax
80100c60:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c66:	50                   	push   %eax
80100c67:	53                   	push   %ebx
80100c68:	e8 b3 0f 00 00       	call   80101c20 <readi>
80100c6d:	83 c4 10             	add    $0x10,%esp
80100c70:	83 f8 20             	cmp    $0x20,%eax
80100c73:	0f 84 5f ff ff ff    	je     80100bd8 <exec+0xb8>
    freevm(pgdir);
80100c79:	83 ec 0c             	sub    $0xc,%esp
80100c7c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c82:	e8 09 65 00 00       	call   80107190 <freevm>
80100c87:	83 c4 10             	add    $0x10,%esp
80100c8a:	e9 e7 fe ff ff       	jmp    80100b76 <exec+0x56>
80100c8f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c9b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ca1:	83 ec 0c             	sub    $0xc,%esp
80100ca4:	53                   	push   %ebx
80100ca5:	e8 26 0f 00 00       	call   80101bd0 <iunlockput>
  end_op();
80100caa:	e8 41 22 00 00       	call   80102ef0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100caf:	83 c4 0c             	add    $0xc,%esp
80100cb2:	56                   	push   %esi
80100cb3:	57                   	push   %edi
80100cb4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cba:	e8 c1 63 00 00       	call   80107080 <allocuvm>
80100cbf:	83 c4 10             	add    $0x10,%esp
80100cc2:	85 c0                	test   %eax,%eax
80100cc4:	89 c6                	mov    %eax,%esi
80100cc6:	75 3a                	jne    80100d02 <exec+0x1e2>
    freevm(pgdir);
80100cc8:	83 ec 0c             	sub    $0xc,%esp
80100ccb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cd1:	e8 ba 64 00 00       	call   80107190 <freevm>
80100cd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cde:	e9 a9 fe ff ff       	jmp    80100b8c <exec+0x6c>
    end_op();
80100ce3:	e8 08 22 00 00       	call   80102ef0 <end_op>
    cprintf("exec: fail\n");
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	68 41 75 10 80       	push   $0x80107541
80100cf0:	e8 7b fa ff ff       	call   80100770 <cprintf>
    return -1;
80100cf5:	83 c4 10             	add    $0x10,%esp
80100cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfd:	e9 8a fe ff ff       	jmp    80100b8c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d02:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d08:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100d0b:	31 ff                	xor    %edi,%edi
80100d0d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0f:	50                   	push   %eax
80100d10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d16:	e8 95 65 00 00       	call   801072b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d1e:	83 c4 10             	add    $0x10,%esp
80100d21:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d27:	8b 00                	mov    (%eax),%eax
80100d29:	85 c0                	test   %eax,%eax
80100d2b:	74 70                	je     80100d9d <exec+0x27d>
80100d2d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100d33:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d39:	eb 0a                	jmp    80100d45 <exec+0x225>
80100d3b:	90                   	nop
80100d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100d40:	83 ff 20             	cmp    $0x20,%edi
80100d43:	74 83                	je     80100cc8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d45:	83 ec 0c             	sub    $0xc,%esp
80100d48:	50                   	push   %eax
80100d49:	e8 f2 3b 00 00       	call   80104940 <strlen>
80100d4e:	f7 d0                	not    %eax
80100d50:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d55:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d56:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d59:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d5c:	e8 df 3b 00 00       	call   80104940 <strlen>
80100d61:	83 c0 01             	add    $0x1,%eax
80100d64:	50                   	push   %eax
80100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d68:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d6b:	53                   	push   %ebx
80100d6c:	56                   	push   %esi
80100d6d:	e8 ae 66 00 00       	call   80107420 <copyout>
80100d72:	83 c4 20             	add    $0x20,%esp
80100d75:	85 c0                	test   %eax,%eax
80100d77:	0f 88 4b ff ff ff    	js     80100cc8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d80:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d87:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d8a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d90:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d93:	85 c0                	test   %eax,%eax
80100d95:	75 a9                	jne    80100d40 <exec+0x220>
80100d97:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d9d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100da4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100da6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100dad:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100db1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100db8:	ff ff ff 
  ustack[1] = argc;
80100dbb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dc1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100dc3:	83 c0 0c             	add    $0xc,%eax
80100dc6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc8:	50                   	push   %eax
80100dc9:	52                   	push   %edx
80100dca:	53                   	push   %ebx
80100dcb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd7:	e8 44 66 00 00       	call   80107420 <copyout>
80100ddc:	83 c4 10             	add    $0x10,%esp
80100ddf:	85 c0                	test   %eax,%eax
80100de1:	0f 88 e1 fe ff ff    	js     80100cc8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100de7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dea:	0f b6 00             	movzbl (%eax),%eax
80100ded:	84 c0                	test   %al,%al
80100def:	74 17                	je     80100e08 <exec+0x2e8>
80100df1:	8b 55 08             	mov    0x8(%ebp),%edx
80100df4:	89 d1                	mov    %edx,%ecx
80100df6:	83 c1 01             	add    $0x1,%ecx
80100df9:	3c 2f                	cmp    $0x2f,%al
80100dfb:	0f b6 01             	movzbl (%ecx),%eax
80100dfe:	0f 44 d1             	cmove  %ecx,%edx
80100e01:	84 c0                	test   %al,%al
80100e03:	75 f1                	jne    80100df6 <exec+0x2d6>
80100e05:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e08:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e0e:	50                   	push   %eax
80100e0f:	6a 10                	push   $0x10
80100e11:	ff 75 08             	pushl  0x8(%ebp)
80100e14:	89 f8                	mov    %edi,%eax
80100e16:	83 c0 6c             	add    $0x6c,%eax
80100e19:	50                   	push   %eax
80100e1a:	e8 e1 3a 00 00       	call   80104900 <safestrcpy>
  curproc->pgdir = pgdir;
80100e1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100e25:	89 f9                	mov    %edi,%ecx
80100e27:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100e2a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100e2d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100e2f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100e32:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e38:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e3b:	8b 41 18             	mov    0x18(%ecx),%eax
80100e3e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e41:	89 0c 24             	mov    %ecx,(%esp)
80100e44:	e8 f7 5d 00 00       	call   80106c40 <switchuvm>
  freevm(oldpgdir);
80100e49:	89 3c 24             	mov    %edi,(%esp)
80100e4c:	e8 3f 63 00 00       	call   80107190 <freevm>
  return 0;
80100e51:	83 c4 10             	add    $0x10,%esp
80100e54:	31 c0                	xor    %eax,%eax
80100e56:	e9 31 fd ff ff       	jmp    80100b8c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e5b:	be 00 20 00 00       	mov    $0x2000,%esi
80100e60:	e9 3c fe ff ff       	jmp    80100ca1 <exec+0x181>
80100e65:	66 90                	xchg   %ax,%ax
80100e67:	66 90                	xchg   %ax,%ax
80100e69:	66 90                	xchg   %ax,%ax
80100e6b:	66 90                	xchg   %ax,%ax
80100e6d:	66 90                	xchg   %ax,%ax
80100e6f:	90                   	nop

80100e70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e76:	68 4d 75 10 80       	push   $0x8010754d
80100e7b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e80:	e8 2b 36 00 00       	call   801044b0 <initlock>
}
80100e85:	83 c4 10             	add    $0x10,%esp
80100e88:	c9                   	leave  
80100e89:	c3                   	ret    
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e94:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea1:	e8 fa 36 00 00       	call   801045a0 <acquire>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb 10                	jmp    80100ebb <filealloc+0x2b>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb0:	83 c3 18             	add    $0x18,%ebx
80100eb3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100eb9:	74 25                	je     80100ee0 <filealloc+0x50>
    if(f->ref == 0){
80100ebb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	75 ee                	jne    80100eb0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ec2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ec5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 ea 37 00 00       	call   801046c0 <release>
      return f;
80100ed6:	89 d8                	mov    %ebx,%eax
80100ed8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ede:	c9                   	leave  
80100edf:	c3                   	ret    
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
80100ee3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee8:	e8 d3 37 00 00       	call   801046c0 <release>
  return 0;
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	31 c0                	xor    %eax,%eax
}
80100ef2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef5:	c9                   	leave  
80100ef6:	c3                   	ret    
80100ef7:	89 f6                	mov    %esi,%esi
80100ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 10             	sub    $0x10,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f0a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100f0f:	e8 8c 36 00 00       	call   801045a0 <acquire>
  if(f->ref < 1)
80100f14:	8b 43 04             	mov    0x4(%ebx),%eax
80100f17:	83 c4 10             	add    $0x10,%esp
80100f1a:	85 c0                	test   %eax,%eax
80100f1c:	7e 1a                	jle    80100f38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f21:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f27:	68 c0 ff 10 80       	push   $0x8010ffc0
80100f2c:	e8 8f 37 00 00       	call   801046c0 <release>
  return f;
}
80100f31:	89 d8                	mov    %ebx,%eax
80100f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    
    panic("filedup");
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	68 54 75 10 80       	push   $0x80107554
80100f40:	e8 5b f5 ff ff       	call   801004a0 <panic>
80100f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 28             	sub    $0x28,%esp
80100f59:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100f5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100f61:	e8 3a 36 00 00       	call   801045a0 <acquire>
  if(f->ref < 1)
80100f66:	8b 47 04             	mov    0x4(%edi),%eax
80100f69:	83 c4 10             	add    $0x10,%esp
80100f6c:	85 c0                	test   %eax,%eax
80100f6e:	0f 8e 9b 00 00 00    	jle    8010100f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f74:	83 e8 01             	sub    $0x1,%eax
80100f77:	85 c0                	test   %eax,%eax
80100f79:	89 47 04             	mov    %eax,0x4(%edi)
80100f7c:	74 1a                	je     80100f98 <fileclose+0x48>
    release(&ftable.lock);
80100f7e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f88:	5b                   	pop    %ebx
80100f89:	5e                   	pop    %esi
80100f8a:	5f                   	pop    %edi
80100f8b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8c:	e9 2f 37 00 00       	jmp    801046c0 <release>
80100f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f98:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100f9c:	8b 1f                	mov    (%edi),%ebx
  release(&ftable.lock);
80100f9e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fa1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->type = FD_NONE;
80100fa4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100faa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fad:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100fb0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100fb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fb8:	e8 03 37 00 00       	call   801046c0 <release>
  if(ff.type == FD_PIPE)
80100fbd:	83 c4 10             	add    $0x10,%esp
80100fc0:	83 fb 01             	cmp    $0x1,%ebx
80100fc3:	74 13                	je     80100fd8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100fc5:	83 fb 02             	cmp    $0x2,%ebx
80100fc8:	74 26                	je     80100ff0 <fileclose+0xa0>
}
80100fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fcd:	5b                   	pop    %ebx
80100fce:	5e                   	pop    %esi
80100fcf:	5f                   	pop    %edi
80100fd0:	5d                   	pop    %ebp
80100fd1:	c3                   	ret    
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100fd8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fdc:	83 ec 08             	sub    $0x8,%esp
80100fdf:	53                   	push   %ebx
80100fe0:	56                   	push   %esi
80100fe1:	e8 4a 26 00 00       	call   80103630 <pipeclose>
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	eb df                	jmp    80100fca <fileclose+0x7a>
80100feb:	90                   	nop
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ff0:	e8 8b 1e 00 00       	call   80102e80 <begin_op>
    iput(ff.ip);
80100ff5:	83 ec 0c             	sub    $0xc,%esp
80100ff8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ffb:	e8 70 0a 00 00       	call   80101a70 <iput>
    end_op();
80101000:	83 c4 10             	add    $0x10,%esp
}
80101003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101006:	5b                   	pop    %ebx
80101007:	5e                   	pop    %esi
80101008:	5f                   	pop    %edi
80101009:	5d                   	pop    %ebp
    end_op();
8010100a:	e9 e1 1e 00 00       	jmp    80102ef0 <end_op>
    panic("fileclose");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 5c 75 10 80       	push   $0x8010755c
80101017:	e8 84 f4 ff ff       	call   801004a0 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	pushl  0x10(%ebx)
80101035:	e8 06 09 00 00       	call   80101940 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	pushl  0xc(%ebp)
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 a9 0b 00 00       	call   80101bf0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	pushl  0x10(%ebx)
8010104b:	e8 d0 09 00 00       	call   80101a20 <iunlock>
    return 0;
80101050:	83 c4 10             	add    $0x10,%esp
80101053:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101058:	c9                   	leave  
80101059:	c3                   	ret    
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	pushl  0x10(%ebx)
8010109a:	e8 a1 08 00 00       	call   80101940 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	pushl  0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	pushl  0x10(%ebx)
801010a7:	e8 74 0b 00 00       	call   80101c20 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	85 c0                	test   %eax,%eax
801010b1:	89 c6                	mov    %eax,%esi
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	pushl  0x10(%ebx)
801010be:	e8 5d 09 00 00       	call   80101a20 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010c6:	89 f0                	mov    %esi,%eax
  }
  panic("fileread");
}
801010c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 ee 26 00 00       	jmp    801037d0 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ed:	eb d9                	jmp    801010c8 <fileread+0x58>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 66 75 10 80       	push   $0x80107566
801010f7:	e8 a4 f3 ff ff       	call   801004a0 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 75 08             	mov    0x8(%ebp),%esi
8010110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010110f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101113:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101116:	8b 45 10             	mov    0x10(%ebp),%eax
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 aa 00 00 00    	je     801011cc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 06                	mov    (%esi),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 c2 00 00 00    	je     801011ef <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 d8 00 00 00    	jne    8010120e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101139:	31 ff                	xor    %edi,%edi
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 34                	jg     80101173 <filewrite+0x73>
8010113f:	e9 9c 00 00 00       	jmp    801011e0 <filewrite+0xe0>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101151:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101154:	e8 c7 08 00 00       	call   80101a20 <iunlock>
      end_op();
80101159:	e8 92 1d 00 00       	call   80102ef0 <end_op>
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101164:	39 d8                	cmp    %ebx,%eax
80101166:	0f 85 95 00 00 00    	jne    80101201 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010116c:	01 c7                	add    %eax,%edi
    while(i < n){
8010116e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101171:	7e 6d                	jle    801011e0 <filewrite+0xe0>
      int n1 = n - i;
80101173:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101176:	b8 00 06 00 00       	mov    $0x600,%eax
8010117b:	29 fb                	sub    %edi,%ebx
8010117d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101183:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101186:	e8 f5 1c 00 00       	call   80102e80 <begin_op>
      ilock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	ff 76 10             	pushl  0x10(%esi)
80101191:	e8 aa 07 00 00       	call   80101940 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	53                   	push   %ebx
8010119a:	ff 76 14             	pushl  0x14(%esi)
8010119d:	01 f8                	add    %edi,%eax
8010119f:	50                   	push   %eax
801011a0:	ff 76 10             	pushl  0x10(%esi)
801011a3:	e8 78 0b 00 00       	call   80101d20 <writei>
801011a8:	83 c4 20             	add    $0x20,%esp
801011ab:	85 c0                	test   %eax,%eax
801011ad:	7f 99                	jg     80101148 <filewrite+0x48>
      iunlock(f->ip);
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	ff 76 10             	pushl  0x10(%esi)
801011b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011b8:	e8 63 08 00 00       	call   80101a20 <iunlock>
      end_op();
801011bd:	e8 2e 1d 00 00       	call   80102ef0 <end_op>
      if(r < 0)
801011c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c5:	83 c4 10             	add    $0x10,%esp
801011c8:	85 c0                	test   %eax,%eax
801011ca:	74 98                	je     80101164 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return i == n ? n : -1;
801011cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011d4:	5b                   	pop    %ebx
801011d5:	5e                   	pop    %esi
801011d6:	5f                   	pop    %edi
801011d7:	5d                   	pop    %ebp
801011d8:	c3                   	ret    
801011d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801011e0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011e3:	75 e7                	jne    801011cc <filewrite+0xcc>
}
801011e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e8:	89 f8                	mov    %edi,%eax
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
801011ee:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ef:	8b 46 0c             	mov    0xc(%esi),%eax
801011f2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f8:	5b                   	pop    %ebx
801011f9:	5e                   	pop    %esi
801011fa:	5f                   	pop    %edi
801011fb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011fc:	e9 cf 24 00 00       	jmp    801036d0 <pipewrite>
        panic("short filewrite");
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	68 6f 75 10 80       	push   $0x8010756f
80101209:	e8 92 f2 ff ff       	call   801004a0 <panic>
  panic("filewrite");
8010120e:	83 ec 0c             	sub    $0xc,%esp
80101211:	68 75 75 10 80       	push   $0x80107575
80101216:	e8 85 f2 ff ff       	call   801004a0 <panic>
8010121b:	66 90                	xchg   %ax,%ax
8010121d:	66 90                	xchg   %ax,%ax
8010121f:	90                   	nop

80101220 <bzero>:
}

// Zero a block.
static void
bzero(int dev, int bno)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	53                   	push   %ebx
80101224:	83 ec 0c             	sub    $0xc,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101227:	52                   	push   %edx
80101228:	50                   	push   %eax
80101229:	e8 62 ef ff ff       	call   80100190 <bread>
8010122e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101230:	8d 40 5c             	lea    0x5c(%eax),%eax
80101233:	83 c4 0c             	add    $0xc,%esp
80101236:	68 00 02 00 00       	push   $0x200
8010123b:	6a 00                	push   $0x0
8010123d:	50                   	push   %eax
8010123e:	e8 dd 34 00 00       	call   80104720 <memset>
  bwrite(bp);
80101243:	89 1c 24             	mov    %ebx,(%esp)
80101246:	e8 85 ef ff ff       	call   801001d0 <bwrite>
  brelse(bp);
8010124b:	89 1c 24             	mov    %ebx,(%esp)
8010124e:	e8 bd ef ff ff       	call   80100210 <brelse>
}
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101259:	c9                   	leave  
8010125a:	c3                   	ret    
8010125b:	90                   	nop
8010125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101260 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
80101269:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010126c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101271:	85 c0                	test   %eax,%eax
80101273:	0f 84 8c 00 00 00    	je     80101305 <balloc+0xa5>
80101279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101280:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101283:	83 ec 08             	sub    $0x8,%esp
80101286:	89 f0                	mov    %esi,%eax
80101288:	c1 f8 0c             	sar    $0xc,%eax
8010128b:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101291:	50                   	push   %eax
80101292:	ff 75 d8             	pushl  -0x28(%ebp)
80101295:	e8 f6 ee ff ff       	call   80100190 <bread>
8010129a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129d:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801012a2:	83 c4 10             	add    $0x10,%esp
801012a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a8:	31 c0                	xor    %eax,%eax
801012aa:	eb 30                	jmp    801012dc <balloc+0x7c>
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012b5:	bb 01 00 00 00       	mov    $0x1,%ebx
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	85 df                	test   %ebx,%edi
801012cb:	89 fa                	mov    %edi,%edx
801012cd:	74 49                	je     80101318 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012e7:	e8 24 ef ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012ff:	0f 87 7b ff ff ff    	ja     80101280 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	68 7f 75 10 80       	push   $0x8010757f
8010130d:	e8 8e f1 ff ff       	call   801004a0 <panic>
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        bwrite(bp);
8010131b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010131e:	09 da                	or     %ebx,%edx
80101320:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        bwrite(bp);
80101324:	57                   	push   %edi
80101325:	e8 a6 ee ff ff       	call   801001d0 <bwrite>
        brelse(bp);
8010132a:	89 3c 24             	mov    %edi,(%esp)
8010132d:	e8 de ee ff ff       	call   80100210 <brelse>
        bzero(dev, b + bi);
80101332:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101335:	89 f2                	mov    %esi,%edx
80101337:	e8 e4 fe ff ff       	call   80101220 <bzero>
}
8010133c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133f:	89 f0                	mov    %esi,%eax
80101341:	5b                   	pop    %ebx
80101342:	5e                   	pop    %esi
80101343:	5f                   	pop    %edi
80101344:	5d                   	pop    %ebp
80101345:	c3                   	ret    
80101346:	8d 76 00             	lea    0x0(%esi),%esi
80101349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101358:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 09 11 80       	push   $0x801109e0
8010136a:	e8 31 32 00 00       	call   801045a0 <acquire>
8010136f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101375:	eb 17                	jmp    8010138e <iget+0x3e>
80101377:	89 f6                	mov    %esi,%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101380:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101386:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010138c:	73 22                	jae    801013b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101391:	85 c9                	test   %ecx,%ecx
80101393:	7e 04                	jle    80101399 <iget+0x49>
80101395:	39 3b                	cmp    %edi,(%ebx)
80101397:	74 4f                	je     801013e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e3                	jne    80101380 <iget+0x30>
8010139d:	85 c9                	test   %ecx,%ecx
8010139f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013ae:	72 de                	jb     8010138e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b0:	85 f6                	test   %esi,%esi
801013b2:	74 5b                	je     8010140f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013ca:	68 e0 09 11 80       	push   $0x801109e0
801013cf:	e8 ec 32 00 00       	call   801046c0 <release>

  return ip;
801013d4:	83 c4 10             	add    $0x10,%esp
}
801013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013da:	89 f0                	mov    %esi,%eax
801013dc:	5b                   	pop    %ebx
801013dd:	5e                   	pop    %esi
801013de:	5f                   	pop    %edi
801013df:	5d                   	pop    %ebp
801013e0:	c3                   	ret    
801013e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013eb:	75 ac                	jne    80101399 <iget+0x49>
      release(&icache.lock);
801013ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013f5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801013fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013fd:	e8 be 32 00 00       	call   801046c0 <release>
      return ip;
80101402:	83 c4 10             	add    $0x10,%esp
}
80101405:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101408:	89 f0                	mov    %esi,%eax
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
8010140e:	c3                   	ret    
    panic("iget: no inodes");
8010140f:	83 ec 0c             	sub    $0xc,%esp
80101412:	68 95 75 10 80       	push   $0x80107595
80101417:	e8 84 f0 ff ff       	call   801004a0 <panic>
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	53                   	push   %ebx
80101426:	89 c6                	mov    %eax,%esi
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	77 18                	ja     80101448 <bmap+0x28>
80101430:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101433:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101436:	85 db                	test   %ebx,%ebx
80101438:	74 76                	je     801014b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143d:	89 d8                	mov    %ebx,%eax
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5f                   	pop    %edi
80101442:	5d                   	pop    %ebp
80101443:	c3                   	ret    
80101444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101448:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010144b:	83 fb 7f             	cmp    $0x7f,%ebx
8010144e:	0f 87 90 00 00 00    	ja     801014e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101454:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010145a:	8b 00                	mov    (%eax),%eax
8010145c:	85 d2                	test   %edx,%edx
8010145e:	74 70                	je     801014d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101460:	83 ec 08             	sub    $0x8,%esp
80101463:	52                   	push   %edx
80101464:	50                   	push   %eax
80101465:	e8 26 ed ff ff       	call   80100190 <bread>
    if((addr = a[bn]) == 0){
8010146a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010146e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101471:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101473:	8b 1a                	mov    (%edx),%ebx
80101475:	85 db                	test   %ebx,%ebx
80101477:	75 1d                	jne    80101496 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101479:	8b 06                	mov    (%esi),%eax
8010147b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010147e:	e8 dd fd ff ff       	call   80101260 <balloc>
80101483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101486:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101489:	89 c3                	mov    %eax,%ebx
8010148b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010148d:	57                   	push   %edi
8010148e:	e8 cd 1b 00 00       	call   80103060 <log_write>
80101493:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101496:	83 ec 0c             	sub    $0xc,%esp
80101499:	57                   	push   %edi
8010149a:	e8 71 ed ff ff       	call   80100210 <brelse>
8010149f:	83 c4 10             	add    $0x10,%esp
}
801014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a5:	89 d8                	mov    %ebx,%eax
801014a7:	5b                   	pop    %ebx
801014a8:	5e                   	pop    %esi
801014a9:	5f                   	pop    %edi
801014aa:	5d                   	pop    %ebp
801014ab:	c3                   	ret    
801014ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014b0:	8b 00                	mov    (%eax),%eax
801014b2:	e8 a9 fd ff ff       	call   80101260 <balloc>
801014b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014bd:	89 c3                	mov    %eax,%ebx
}
801014bf:	89 d8                	mov    %ebx,%eax
801014c1:	5b                   	pop    %ebx
801014c2:	5e                   	pop    %esi
801014c3:	5f                   	pop    %edi
801014c4:	5d                   	pop    %ebp
801014c5:	c3                   	ret    
801014c6:	8d 76 00             	lea    0x0(%esi),%esi
801014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d0:	e8 8b fd ff ff       	call   80101260 <balloc>
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014dd:	8b 06                	mov    (%esi),%eax
801014df:	e9 7c ff ff ff       	jmp    80101460 <bmap+0x40>
  panic("bmap: out of range");
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	68 a5 75 10 80       	push   $0x801075a5
801014ec:	e8 af ef ff ff       	call   801004a0 <panic>
801014f1:	eb 0d                	jmp    80101500 <readsb>
801014f3:	90                   	nop
801014f4:	90                   	nop
801014f5:	90                   	nop
801014f6:	90                   	nop
801014f7:	90                   	nop
801014f8:	90                   	nop
801014f9:	90                   	nop
801014fa:	90                   	nop
801014fb:	90                   	nop
801014fc:	90                   	nop
801014fd:	90                   	nop
801014fe:	90                   	nop
801014ff:	90                   	nop

80101500 <readsb>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	56                   	push   %esi
80101504:	53                   	push   %ebx
80101505:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101508:	83 ec 08             	sub    $0x8,%esp
8010150b:	6a 01                	push   $0x1
8010150d:	ff 75 08             	pushl  0x8(%ebp)
80101510:	e8 7b ec ff ff       	call   80100190 <bread>
80101515:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101517:	8d 40 5c             	lea    0x5c(%eax),%eax
8010151a:	83 c4 0c             	add    $0xc,%esp
8010151d:	6a 1c                	push   $0x1c
8010151f:	50                   	push   %eax
80101520:	56                   	push   %esi
80101521:	e8 aa 32 00 00       	call   801047d0 <memmove>
  brelse(bp);
80101526:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101529:	83 c4 10             	add    $0x10,%esp
}
8010152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5d                   	pop    %ebp
  brelse(bp);
80101532:	e9 d9 ec ff ff       	jmp    80100210 <brelse>
80101537:	89 f6                	mov    %esi,%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <bfree>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	89 d3                	mov    %edx,%ebx
80101547:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	68 c0 09 11 80       	push   $0x801109c0
80101551:	50                   	push   %eax
80101552:	e8 a9 ff ff ff       	call   80101500 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101557:	58                   	pop    %eax
80101558:	5a                   	pop    %edx
80101559:	89 da                	mov    %ebx,%edx
8010155b:	c1 ea 0c             	shr    $0xc,%edx
8010155e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101564:	52                   	push   %edx
80101565:	56                   	push   %esi
80101566:	e8 25 ec ff ff       	call   80100190 <bread>
  m = 1 << (bi % 8);
8010156b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010156d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101570:	ba 01 00 00 00       	mov    $0x1,%edx
80101575:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101578:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010157e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101581:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101583:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101588:	85 d1                	test   %edx,%ecx
8010158a:	74 25                	je     801015b1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010158c:	f7 d2                	not    %edx
8010158e:	89 c6                	mov    %eax,%esi
  bwrite(bp);
80101590:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101593:	21 ca                	and    %ecx,%edx
80101595:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  bwrite(bp);
80101599:	56                   	push   %esi
8010159a:	e8 31 ec ff ff       	call   801001d0 <bwrite>
  brelse(bp);
8010159f:	89 34 24             	mov    %esi,(%esp)
801015a2:	e8 69 ec ff ff       	call   80100210 <brelse>
}
801015a7:	83 c4 10             	add    $0x10,%esp
801015aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ad:	5b                   	pop    %ebx
801015ae:	5e                   	pop    %esi
801015af:	5d                   	pop    %ebp
801015b0:	c3                   	ret    
    panic("freeing free block");
801015b1:	83 ec 0c             	sub    $0xc,%esp
801015b4:	68 b8 75 10 80       	push   $0x801075b8
801015b9:	e8 e2 ee ff ff       	call   801004a0 <panic>
801015be:	66 90                	xchg   %ax,%ax

801015c0 <balloc_page>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 2c             	sub    $0x2c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015c9:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801015ce:	85 c0                	test   %eax,%eax
801015d0:	0f 84 28 01 00 00    	je     801016fe <balloc_page+0x13e>
801015d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015dd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	bf 08 00 00 00       	mov    $0x8,%edi
801015e8:	89 d8                	mov    %ebx,%eax
801015ea:	29 df                	sub    %ebx,%edi
801015ec:	c1 f8 0c             	sar    $0xc,%eax
801015ef:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801015f5:	50                   	push   %eax
801015f6:	ff 75 08             	pushl  0x8(%ebp)
801015f9:	e8 92 eb ff ff       	call   80100190 <bread>
801015fe:	89 c6                	mov    %eax,%esi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101600:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101605:	89 7d c8             	mov    %edi,-0x38(%ebp)
80101608:	83 c4 10             	add    $0x10,%esp
8010160b:	89 df                	mov    %ebx,%edi
8010160d:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101610:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80101616:	89 45 cc             	mov    %eax,-0x34(%ebp)
80101619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101620:	89 f8                	mov    %edi,%eax
80101622:	2b 45 d4             	sub    -0x2c(%ebp),%eax
80101625:	39 7d d0             	cmp    %edi,-0x30(%ebp)
80101628:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010162b:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010162e:	0f 86 ac 00 00 00    	jbe    801016e0 <balloc_page+0x120>
80101634:	8b 45 c8             	mov    -0x38(%ebp),%eax
        m = 1 << (mover % 8);
80101637:	bb 01 00 00 00       	mov    $0x1,%ebx
8010163c:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010163f:	01 f8                	add    %edi,%eax
80101641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101644:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101647:	89 f6                	mov    %esi,%esi
80101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101650:	89 c2                	mov    %eax,%edx
        m = 1 << (mover % 8);
80101652:	89 c1                	mov    %eax,%ecx
80101654:	89 df                	mov    %ebx,%edi
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101656:	c1 fa 03             	sar    $0x3,%edx
        m = 1 << (mover % 8);
80101659:	83 e1 07             	and    $0x7,%ecx
        if((bp->data[mover/8] & m) == 0){  // Is block free?
8010165c:	0f b6 54 16 5c       	movzbl 0x5c(%esi,%edx,1),%edx
        m = 1 << (mover % 8);
80101661:	d3 e7                	shl    %cl,%edi
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101663:	85 fa                	test   %edi,%edx
80101665:	75 69                	jne    801016d0 <balloc_page+0x110>
            mover += 1;
80101667:	83 c0 01             	add    $0x1,%eax
      for(int i=0; i<8; i++){
8010166a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
8010166d:	75 e1                	jne    80101650 <balloc_page+0x90>
8010166f:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101672:	8b 45 e0             	mov    -0x20(%ebp),%eax
          m = 1 << (mover % 8);
80101675:	bb 01 00 00 00       	mov    $0x1,%ebx
8010167a:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010167d:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101680:	83 c0 08             	add    $0x8,%eax
80101683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          bp->data[mover/8] |= m;  // Mark block in use.
80101686:	89 f8                	mov    %edi,%eax
          m = 1 << (mover % 8);
80101688:	89 f9                	mov    %edi,%ecx
8010168a:	89 da                	mov    %ebx,%edx
          bp->data[mover/8] |= m;  // Mark block in use.
8010168c:	c1 f8 03             	sar    $0x3,%eax
          m = 1 << (mover % 8);
8010168f:	83 e1 07             	and    $0x7,%ecx
          bwrite(bp);
80101692:	83 ec 0c             	sub    $0xc,%esp
          m = 1 << (mover % 8);
80101695:	d3 e2                	shl    %cl,%edx
          bp->data[mover/8] |= m;  // Mark block in use.
80101697:	08 54 06 5c          	or     %dl,0x5c(%esi,%eax,1)
          bwrite(bp);
8010169b:	56                   	push   %esi
8010169c:	e8 2f eb ff ff       	call   801001d0 <bwrite>
          bzero(dev, b + mover);
801016a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016a4:	8d 14 07             	lea    (%edi,%eax,1),%edx
801016a7:	8b 45 08             	mov    0x8(%ebp),%eax
          mover += 1;
801016aa:	83 c7 01             	add    $0x1,%edi
          bzero(dev, b + mover);
801016ad:	e8 6e fb ff ff       	call   80101220 <bzero>
        for(int i=0; i<8; i++){
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801016b8:	75 cc                	jne    80101686 <balloc_page+0xc6>
        brelse(bp);
801016ba:	83 ec 0c             	sub    $0xc,%esp
801016bd:	8b 7d e0             	mov    -0x20(%ebp),%edi
801016c0:	56                   	push   %esi
801016c1:	e8 4a eb ff ff       	call   80100210 <brelse>
}
801016c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016c9:	89 f8                	mov    %edi,%eax
801016cb:	5b                   	pop    %ebx
801016cc:	5e                   	pop    %esi
801016cd:	5f                   	pop    %edi
801016ce:	5d                   	pop    %ebp
801016cf:	c3                   	ret    
801016d0:	8b 7d dc             	mov    -0x24(%ebp),%edi
801016d3:	83 c7 01             	add    $0x1,%edi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016d6:	39 7d cc             	cmp    %edi,-0x34(%ebp)
801016d9:	0f 85 41 ff ff ff    	jne    80101620 <balloc_page+0x60>
801016df:	90                   	nop
    brelse(bp);
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	56                   	push   %esi
801016e4:	e8 27 eb ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801016e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801016ec:	83 c4 10             	add    $0x10,%esp
801016ef:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801016f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016f8:	0f 87 df fe ff ff    	ja     801015dd <balloc_page+0x1d>
  panic("balloc pages : out of blocks");
801016fe:	83 ec 0c             	sub    $0xc,%esp
80101701:	68 cb 75 10 80       	push   $0x801075cb
80101706:	e8 95 ed ff ff       	call   801004a0 <panic>
8010170b:	90                   	nop
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <bfree_page>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	83 ec 0c             	sub    $0xc,%esp
80101719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010171c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010171f:	8d 73 08             	lea    0x8(%ebx),%esi
80101722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bfree(dev,b+bi);
80101728:	89 da                	mov    %ebx,%edx
8010172a:	89 f8                	mov    %edi,%eax
8010172c:	83 c3 01             	add    $0x1,%ebx
8010172f:	e8 0c fe ff ff       	call   80101540 <bfree>
  for(uint bi=0;bi<8;bi++){
80101734:	39 f3                	cmp    %esi,%ebx
80101736:	75 f0                	jne    80101728 <bfree_page+0x18>
}
80101738:	83 c4 0c             	add    $0xc,%esp
8010173b:	5b                   	pop    %ebx
8010173c:	5e                   	pop    %esi
8010173d:	5f                   	pop    %edi
8010173e:	5d                   	pop    %ebp
8010173f:	c3                   	ret    

80101740 <iinit>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
80101744:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101749:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010174c:	68 e8 75 10 80       	push   $0x801075e8
80101751:	68 e0 09 11 80       	push   $0x801109e0
80101756:	e8 55 2d 00 00       	call   801044b0 <initlock>
8010175b:	83 c4 10             	add    $0x10,%esp
8010175e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101760:	83 ec 08             	sub    $0x8,%esp
80101763:	68 ef 75 10 80       	push   $0x801075ef
80101768:	53                   	push   %ebx
80101769:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010176f:	e8 2c 2c 00 00       	call   801043a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101774:	83 c4 10             	add    $0x10,%esp
80101777:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010177d:	75 e1                	jne    80101760 <iinit+0x20>
  readsb(dev, &sb);
8010177f:	83 ec 08             	sub    $0x8,%esp
80101782:	68 c0 09 11 80       	push   $0x801109c0
80101787:	ff 75 08             	pushl  0x8(%ebp)
8010178a:	e8 71 fd ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010178f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101795:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010179b:	ff 35 d0 09 11 80    	pushl  0x801109d0
801017a1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801017a7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801017ad:	ff 35 c4 09 11 80    	pushl  0x801109c4
801017b3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801017b9:	68 54 76 10 80       	push   $0x80107654
801017be:	e8 ad ef ff ff       	call   80100770 <cprintf>
}
801017c3:	83 c4 30             	add    $0x30,%esp
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave  
801017ca:	c3                   	ret    
801017cb:	90                   	nop
801017cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017d0 <ialloc>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017d9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801017e3:	8b 75 08             	mov    0x8(%ebp),%esi
801017e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017e9:	0f 86 91 00 00 00    	jbe    80101880 <ialloc+0xb0>
801017ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801017f4:	eb 21                	jmp    80101817 <ialloc+0x47>
801017f6:	8d 76 00             	lea    0x0(%esi),%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101800:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101803:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101806:	57                   	push   %edi
80101807:	e8 04 ea ff ff       	call   80100210 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010180c:	83 c4 10             	add    $0x10,%esp
8010180f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101815:	76 69                	jbe    80101880 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101817:	89 d8                	mov    %ebx,%eax
80101819:	83 ec 08             	sub    $0x8,%esp
8010181c:	c1 e8 03             	shr    $0x3,%eax
8010181f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101825:	50                   	push   %eax
80101826:	56                   	push   %esi
80101827:	e8 64 e9 ff ff       	call   80100190 <bread>
8010182c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010182e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101830:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101833:	83 e0 07             	and    $0x7,%eax
80101836:	c1 e0 06             	shl    $0x6,%eax
80101839:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010183d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101841:	75 bd                	jne    80101800 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101843:	83 ec 04             	sub    $0x4,%esp
80101846:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101849:	6a 40                	push   $0x40
8010184b:	6a 00                	push   $0x0
8010184d:	51                   	push   %ecx
8010184e:	e8 cd 2e 00 00       	call   80104720 <memset>
      dip->type = type;
80101853:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101857:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010185a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010185d:	89 3c 24             	mov    %edi,(%esp)
80101860:	e8 fb 17 00 00       	call   80103060 <log_write>
      brelse(bp);
80101865:	89 3c 24             	mov    %edi,(%esp)
80101868:	e8 a3 e9 ff ff       	call   80100210 <brelse>
      return iget(dev, inum);
8010186d:	83 c4 10             	add    $0x10,%esp
}
80101870:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101873:	89 da                	mov    %ebx,%edx
80101875:	89 f0                	mov    %esi,%eax
}
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5f                   	pop    %edi
8010187a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010187b:	e9 d0 fa ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
80101880:	83 ec 0c             	sub    $0xc,%esp
80101883:	68 f5 75 10 80       	push   $0x801075f5
80101888:	e8 13 ec ff ff       	call   801004a0 <panic>
8010188d:	8d 76 00             	lea    0x0(%esi),%esi

80101890 <iupdate>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101898:	83 ec 08             	sub    $0x8,%esp
8010189b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010189e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018a1:	c1 e8 03             	shr    $0x3,%eax
801018a4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801018aa:	50                   	push   %eax
801018ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801018ae:	e8 dd e8 ff ff       	call   80100190 <bread>
801018b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801018b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018bf:	83 e0 07             	and    $0x7,%eax
801018c2:	c1 e0 06             	shl    $0x6,%eax
801018c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ed:	6a 34                	push   $0x34
801018ef:	53                   	push   %ebx
801018f0:	50                   	push   %eax
801018f1:	e8 da 2e 00 00       	call   801047d0 <memmove>
  log_write(bp);
801018f6:	89 34 24             	mov    %esi,(%esp)
801018f9:	e8 62 17 00 00       	call   80103060 <log_write>
  brelse(bp);
801018fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101901:	83 c4 10             	add    $0x10,%esp
}
80101904:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101907:	5b                   	pop    %ebx
80101908:	5e                   	pop    %esi
80101909:	5d                   	pop    %ebp
  brelse(bp);
8010190a:	e9 01 e9 ff ff       	jmp    80100210 <brelse>
8010190f:	90                   	nop

80101910 <idup>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010191a:	68 e0 09 11 80       	push   $0x801109e0
8010191f:	e8 7c 2c 00 00       	call   801045a0 <acquire>
  ip->ref++;
80101924:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101928:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010192f:	e8 8c 2d 00 00       	call   801046c0 <release>
}
80101934:	89 d8                	mov    %ebx,%eax
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <ilock>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	56                   	push   %esi
80101944:	53                   	push   %ebx
80101945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101948:	85 db                	test   %ebx,%ebx
8010194a:	0f 84 b7 00 00 00    	je     80101a07 <ilock+0xc7>
80101950:	8b 53 08             	mov    0x8(%ebx),%edx
80101953:	85 d2                	test   %edx,%edx
80101955:	0f 8e ac 00 00 00    	jle    80101a07 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010195b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010195e:	83 ec 0c             	sub    $0xc,%esp
80101961:	50                   	push   %eax
80101962:	e8 79 2a 00 00       	call   801043e0 <acquiresleep>
  if(ip->valid == 0){
80101967:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010196a:	83 c4 10             	add    $0x10,%esp
8010196d:	85 c0                	test   %eax,%eax
8010196f:	74 0f                	je     80101980 <ilock+0x40>
}
80101971:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101974:	5b                   	pop    %ebx
80101975:	5e                   	pop    %esi
80101976:	5d                   	pop    %ebp
80101977:	c3                   	ret    
80101978:	90                   	nop
80101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101980:	8b 43 04             	mov    0x4(%ebx),%eax
80101983:	83 ec 08             	sub    $0x8,%esp
80101986:	c1 e8 03             	shr    $0x3,%eax
80101989:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010198f:	50                   	push   %eax
80101990:	ff 33                	pushl  (%ebx)
80101992:	e8 f9 e7 ff ff       	call   80100190 <bread>
80101997:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101999:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010199c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010199f:	83 e0 07             	and    $0x7,%eax
801019a2:	c1 e0 06             	shl    $0x6,%eax
801019a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019a9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019ac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019d1:	6a 34                	push   $0x34
801019d3:	50                   	push   %eax
801019d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019d7:	50                   	push   %eax
801019d8:	e8 f3 2d 00 00       	call   801047d0 <memmove>
    brelse(bp);
801019dd:	89 34 24             	mov    %esi,(%esp)
801019e0:	e8 2b e8 ff ff       	call   80100210 <brelse>
    if(ip->type == 0)
801019e5:	83 c4 10             	add    $0x10,%esp
801019e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801019f4:	0f 85 77 ff ff ff    	jne    80101971 <ilock+0x31>
      panic("ilock: no type");
801019fa:	83 ec 0c             	sub    $0xc,%esp
801019fd:	68 0d 76 10 80       	push   $0x8010760d
80101a02:	e8 99 ea ff ff       	call   801004a0 <panic>
    panic("ilock");
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 07 76 10 80       	push   $0x80107607
80101a0f:	e8 8c ea ff ff       	call   801004a0 <panic>
80101a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a20 <iunlock>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 28                	je     80101a54 <iunlock+0x34>
80101a2c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a2f:	83 ec 0c             	sub    $0xc,%esp
80101a32:	56                   	push   %esi
80101a33:	e8 48 2a 00 00       	call   80104480 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 15                	je     80101a54 <iunlock+0x34>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 0e                	jle    80101a54 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a4c:	5b                   	pop    %ebx
80101a4d:	5e                   	pop    %esi
80101a4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a4f:	e9 ec 29 00 00       	jmp    80104440 <releasesleep>
    panic("iunlock");
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	68 1c 76 10 80       	push   $0x8010761c
80101a5c:	e8 3f ea ff ff       	call   801004a0 <panic>
80101a61:	eb 0d                	jmp    80101a70 <iput>
80101a63:	90                   	nop
80101a64:	90                   	nop
80101a65:	90                   	nop
80101a66:	90                   	nop
80101a67:	90                   	nop
80101a68:	90                   	nop
80101a69:	90                   	nop
80101a6a:	90                   	nop
80101a6b:	90                   	nop
80101a6c:	90                   	nop
80101a6d:	90                   	nop
80101a6e:	90                   	nop
80101a6f:	90                   	nop

80101a70 <iput>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 28             	sub    $0x28,%esp
80101a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a7f:	57                   	push   %edi
80101a80:	e8 5b 29 00 00       	call   801043e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	85 d2                	test   %edx,%edx
80101a8d:	74 07                	je     80101a96 <iput+0x26>
80101a8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a94:	74 32                	je     80101ac8 <iput+0x58>
  releasesleep(&ip->lock);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	57                   	push   %edi
80101a9a:	e8 a1 29 00 00       	call   80104440 <releasesleep>
  acquire(&icache.lock);
80101a9f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101aa6:	e8 f5 2a 00 00       	call   801045a0 <acquire>
  ip->ref--;
80101aab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5f                   	pop    %edi
80101abf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ac0:	e9 fb 2b 00 00       	jmp    801046c0 <release>
80101ac5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ac8:	83 ec 0c             	sub    $0xc,%esp
80101acb:	68 e0 09 11 80       	push   $0x801109e0
80101ad0:	e8 cb 2a 00 00       	call   801045a0 <acquire>
    int r = ip->ref;
80101ad5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ad8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101adf:	e8 dc 2b 00 00       	call   801046c0 <release>
    if(r == 1){
80101ae4:	83 c4 10             	add    $0x10,%esp
80101ae7:	83 fe 01             	cmp    $0x1,%esi
80101aea:	75 aa                	jne    80101a96 <iput+0x26>
80101aec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101af2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101af5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101af8:	89 cf                	mov    %ecx,%edi
80101afa:	eb 0b                	jmp    80101b07 <iput+0x97>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b00:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b03:	39 fe                	cmp    %edi,%esi
80101b05:	74 19                	je     80101b20 <iput+0xb0>
    if(ip->addrs[i]){
80101b07:	8b 16                	mov    (%esi),%edx
80101b09:	85 d2                	test   %edx,%edx
80101b0b:	74 f3                	je     80101b00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b0d:	8b 03                	mov    (%ebx),%eax
80101b0f:	e8 2c fa ff ff       	call   80101540 <bfree>
      ip->addrs[i] = 0;
80101b14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b1a:	eb e4                	jmp    80101b00 <iput+0x90>
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b29:	85 c0                	test   %eax,%eax
80101b2b:	75 33                	jne    80101b60 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b37:	53                   	push   %ebx
80101b38:	e8 53 fd ff ff       	call   80101890 <iupdate>
      ip->type = 0;
80101b3d:	31 c0                	xor    %eax,%eax
80101b3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b43:	89 1c 24             	mov    %ebx,(%esp)
80101b46:	e8 45 fd ff ff       	call   80101890 <iupdate>
      ip->valid = 0;
80101b4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b52:	83 c4 10             	add    $0x10,%esp
80101b55:	e9 3c ff ff ff       	jmp    80101a96 <iput+0x26>
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b60:	83 ec 08             	sub    $0x8,%esp
80101b63:	50                   	push   %eax
80101b64:	ff 33                	pushl  (%ebx)
80101b66:	e8 25 e6 ff ff       	call   80100190 <bread>
80101b6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b71:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b77:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b7a:	83 c4 10             	add    $0x10,%esp
80101b7d:	89 cf                	mov    %ecx,%edi
80101b7f:	eb 0e                	jmp    80101b8f <iput+0x11f>
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b88:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b8b:	39 fe                	cmp    %edi,%esi
80101b8d:	74 0f                	je     80101b9e <iput+0x12e>
      if(a[j])
80101b8f:	8b 16                	mov    (%esi),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 f3                	je     80101b88 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b95:	8b 03                	mov    (%ebx),%eax
80101b97:	e8 a4 f9 ff ff       	call   80101540 <bfree>
80101b9c:	eb ea                	jmp    80101b88 <iput+0x118>
    brelse(bp);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ba4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ba7:	e8 64 e6 ff ff       	call   80100210 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bb2:	8b 03                	mov    (%ebx),%eax
80101bb4:	e8 87 f9 ff ff       	call   80101540 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bb9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101bc0:	00 00 00 
80101bc3:	83 c4 10             	add    $0x10,%esp
80101bc6:	e9 62 ff ff ff       	jmp    80101b2d <iput+0xbd>
80101bcb:	90                   	nop
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bd0 <iunlockput>:
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	53                   	push   %ebx
80101bd4:	83 ec 10             	sub    $0x10,%esp
80101bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bda:	53                   	push   %ebx
80101bdb:	e8 40 fe ff ff       	call   80101a20 <iunlock>
  iput(ip);
80101be0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101be3:	83 c4 10             	add    $0x10,%esp
}
80101be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101be9:	c9                   	leave  
  iput(ip);
80101bea:	e9 81 fe ff ff       	jmp    80101a70 <iput>
80101bef:	90                   	nop

80101bf0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	8b 55 08             	mov    0x8(%ebp),%edx
80101bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bf9:	8b 0a                	mov    (%edx),%ecx
80101bfb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bfe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c13:	8b 52 58             	mov    0x58(%edx),%edx
80101c16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c43:	0f 84 a7 00 00 00    	je     80101cf0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4c:	8b 40 58             	mov    0x58(%eax),%eax
80101c4f:	39 c6                	cmp    %eax,%esi
80101c51:	0f 87 ba 00 00 00    	ja     80101d11 <readi+0xf1>
80101c57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c5a:	89 f9                	mov    %edi,%ecx
80101c5c:	01 f1                	add    %esi,%ecx
80101c5e:	0f 82 ad 00 00 00    	jb     80101d11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c64:	89 c2                	mov    %eax,%edx
80101c66:	29 f2                	sub    %esi,%edx
80101c68:	39 c8                	cmp    %ecx,%eax
80101c6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c6d:	31 ff                	xor    %edi,%edi
80101c6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c74:	74 6c                	je     80101ce2 <readi+0xc2>
80101c76:	8d 76 00             	lea    0x0(%esi),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c83:	89 f2                	mov    %esi,%edx
80101c85:	c1 ea 09             	shr    $0x9,%edx
80101c88:	89 d8                	mov    %ebx,%eax
80101c8a:	e8 91 f7 ff ff       	call   80101420 <bmap>
80101c8f:	83 ec 08             	sub    $0x8,%esp
80101c92:	50                   	push   %eax
80101c93:	ff 33                	pushl  (%ebx)
80101c95:	e8 f6 e4 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9f:	89 f0                	mov    %esi,%eax
80101ca1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cab:	83 c4 0c             	add    $0xc,%esp
80101cae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cb0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101cb4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb7:	29 fb                	sub    %edi,%ebx
80101cb9:	39 d9                	cmp    %ebx,%ecx
80101cbb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cbe:	53                   	push   %ebx
80101cbf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101cc2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101cc7:	e8 04 2b 00 00       	call   801047d0 <memmove>
    brelse(bp);
80101ccc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ccf:	89 14 24             	mov    %edx,(%esp)
80101cd2:	e8 39 e5 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ce0:	77 9e                	ja     80101c80 <readi+0x60>
  }
  return n;
80101ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce8:	5b                   	pop    %ebx
80101ce9:	5e                   	pop    %esi
80101cea:	5f                   	pop    %edi
80101ceb:	5d                   	pop    %ebp
80101cec:	c3                   	ret    
80101ced:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 17                	ja     80101d11 <readi+0xf1>
80101cfa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 0c                	je     80101d11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d0f:	ff e0                	jmp    *%eax
      return -1;
80101d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d16:	eb cd                	jmp    80101ce5 <readi+0xc5>
80101d18:	90                   	nop
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d43:	0f 84 b7 00 00 00    	je     80101e00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d4f:	0f 82 eb 00 00 00    	jb     80101e40 <writei+0x120>
80101d55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d58:	31 d2                	xor    %edx,%edx
80101d5a:	89 f8                	mov    %edi,%eax
80101d5c:	01 f0                	add    %esi,%eax
80101d5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d66:	0f 87 d4 00 00 00    	ja     80101e40 <writei+0x120>
80101d6c:	85 d2                	test   %edx,%edx
80101d6e:	0f 85 cc 00 00 00    	jne    80101e40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d74:	85 ff                	test   %edi,%edi
80101d76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d7d:	74 72                	je     80101df1 <writei+0xd1>
80101d7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d83:	89 f2                	mov    %esi,%edx
80101d85:	c1 ea 09             	shr    $0x9,%edx
80101d88:	89 f8                	mov    %edi,%eax
80101d8a:	e8 91 f6 ff ff       	call   80101420 <bmap>
80101d8f:	83 ec 08             	sub    $0x8,%esp
80101d92:	50                   	push   %eax
80101d93:	ff 37                	pushl  (%edi)
80101d95:	e8 f6 e3 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101da0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101da2:	89 f0                	mov    %esi,%eax
80101da4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101da9:	83 c4 0c             	add    $0xc,%esp
80101dac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101db1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101db3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101db7:	39 d9                	cmp    %ebx,%ecx
80101db9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dbc:	53                   	push   %ebx
80101dbd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dc0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101dc2:	50                   	push   %eax
80101dc3:	e8 08 2a 00 00       	call   801047d0 <memmove>
    log_write(bp);
80101dc8:	89 3c 24             	mov    %edi,(%esp)
80101dcb:	e8 90 12 00 00       	call   80103060 <log_write>
    brelse(bp);
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	e8 38 e4 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ddb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dde:	83 c4 10             	add    $0x10,%esp
80101de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101de7:	77 97                	ja     80101d80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dec:	3b 70 58             	cmp    0x58(%eax),%esi
80101def:	77 37                	ja     80101e28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df7:	5b                   	pop    %ebx
80101df8:	5e                   	pop    %esi
80101df9:	5f                   	pop    %edi
80101dfa:	5d                   	pop    %ebp
80101dfb:	c3                   	ret    
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e04:	66 83 f8 09          	cmp    $0x9,%ax
80101e08:	77 36                	ja     80101e40 <writei+0x120>
80101e0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101e11:	85 c0                	test   %eax,%eax
80101e13:	74 2b                	je     80101e40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e1f:	ff e0                	jmp    *%eax
80101e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e31:	50                   	push   %eax
80101e32:	e8 59 fa ff ff       	call   80101890 <iupdate>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb b5                	jmp    80101df1 <writei+0xd1>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e45:	eb ad                	jmp    80101df4 <writei+0xd4>
80101e47:	89 f6                	mov    %esi,%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e56:	6a 0e                	push   $0xe
80101e58:	ff 75 0c             	pushl  0xc(%ebp)
80101e5b:	ff 75 08             	pushl  0x8(%ebp)
80101e5e:	e8 dd 29 00 00       	call   80104840 <strncmp>
}
80101e63:	c9                   	leave  
80101e64:	c3                   	ret    
80101e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 1c             	sub    $0x1c,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e81:	0f 85 85 00 00 00    	jne    80101f0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e87:	8b 53 58             	mov    0x58(%ebx),%edx
80101e8a:	31 ff                	xor    %edi,%edi
80101e8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8f:	85 d2                	test   %edx,%edx
80101e91:	74 3e                	je     80101ed1 <dirlookup+0x61>
80101e93:	90                   	nop
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 7e fd ff ff       	call   80101c20 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 55                	jne    80101eff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	74 18                	je     80101ec9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	50                   	push   %eax
80101eba:	ff 75 0c             	pushl  0xc(%ebp)
80101ebd:	e8 7e 29 00 00       	call   80104840 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	85 c0                	test   %eax,%eax
80101ec7:	74 17                	je     80101ee0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ec9:	83 c7 10             	add    $0x10,%edi
80101ecc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ecf:	72 c7                	jb     80101e98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ed4:	31 c0                	xor    %eax,%eax
}
80101ed6:	5b                   	pop    %ebx
80101ed7:	5e                   	pop    %esi
80101ed8:	5f                   	pop    %edi
80101ed9:	5d                   	pop    %ebp
80101eda:	c3                   	ret    
80101edb:	90                   	nop
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee3:	85 c0                	test   %eax,%eax
80101ee5:	74 05                	je     80101eec <dirlookup+0x7c>
        *poff = off;
80101ee7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101eec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ef0:	8b 03                	mov    (%ebx),%eax
80101ef2:	e8 59 f4 ff ff       	call   80101350 <iget>
}
80101ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efa:	5b                   	pop    %ebx
80101efb:	5e                   	pop    %esi
80101efc:	5f                   	pop    %edi
80101efd:	5d                   	pop    %ebp
80101efe:	c3                   	ret    
      panic("dirlookup read");
80101eff:	83 ec 0c             	sub    $0xc,%esp
80101f02:	68 36 76 10 80       	push   $0x80107636
80101f07:	e8 94 e5 ff ff       	call   801004a0 <panic>
    panic("dirlookup not DIR");
80101f0c:	83 ec 0c             	sub    $0xc,%esp
80101f0f:	68 24 76 10 80       	push   $0x80107624
80101f14:	e8 87 e5 ff ff       	call   801004a0 <panic>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	89 cf                	mov    %ecx,%edi
80101f28:	89 c3                	mov    %eax,%ebx
80101f2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f33:	0f 84 67 01 00 00    	je     801020a0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f39:	e8 92 1b 00 00       	call   80103ad0 <myproc>
  acquire(&icache.lock);
80101f3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f44:	68 e0 09 11 80       	push   $0x801109e0
80101f49:	e8 52 26 00 00       	call   801045a0 <acquire>
  ip->ref++;
80101f4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f52:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101f59:	e8 62 27 00 00       	call   801046c0 <release>
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	eb 08                	jmp    80101f6b <namex+0x4b>
80101f63:	90                   	nop
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	0f b6 03             	movzbl (%ebx),%eax
80101f6e:	3c 2f                	cmp    $0x2f,%al
80101f70:	74 f6                	je     80101f68 <namex+0x48>
  if(*path == 0)
80101f72:	84 c0                	test   %al,%al
80101f74:	0f 84 ee 00 00 00    	je     80102068 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f7a:	0f b6 03             	movzbl (%ebx),%eax
80101f7d:	3c 2f                	cmp    $0x2f,%al
80101f7f:	0f 84 b3 00 00 00    	je     80102038 <namex+0x118>
80101f85:	84 c0                	test   %al,%al
80101f87:	89 da                	mov    %ebx,%edx
80101f89:	75 09                	jne    80101f94 <namex+0x74>
80101f8b:	e9 a8 00 00 00       	jmp    80102038 <namex+0x118>
80101f90:	84 c0                	test   %al,%al
80101f92:	74 0a                	je     80101f9e <namex+0x7e>
    path++;
80101f94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f97:	0f b6 02             	movzbl (%edx),%eax
80101f9a:	3c 2f                	cmp    $0x2f,%al
80101f9c:	75 f2                	jne    80101f90 <namex+0x70>
80101f9e:	89 d1                	mov    %edx,%ecx
80101fa0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101fa2:	83 f9 0d             	cmp    $0xd,%ecx
80101fa5:	0f 8e 91 00 00 00    	jle    8010203c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101fab:	83 ec 04             	sub    $0x4,%esp
80101fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fb1:	6a 0e                	push   $0xe
80101fb3:	53                   	push   %ebx
80101fb4:	57                   	push   %edi
80101fb5:	e8 16 28 00 00       	call   801047d0 <memmove>
    path++;
80101fba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101fbd:	83 c4 10             	add    $0x10,%esp
    path++;
80101fc0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fc5:	75 11                	jne    80101fd8 <namex+0xb8>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101fd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fd6:	74 f8                	je     80101fd0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	56                   	push   %esi
80101fdc:	e8 5f f9 ff ff       	call   80101940 <ilock>
    if(ip->type != T_DIR){
80101fe1:	83 c4 10             	add    $0x10,%esp
80101fe4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fe9:	0f 85 91 00 00 00    	jne    80102080 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ff2:	85 d2                	test   %edx,%edx
80101ff4:	74 09                	je     80101fff <namex+0xdf>
80101ff6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ff9:	0f 84 b7 00 00 00    	je     801020b6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fff:	83 ec 04             	sub    $0x4,%esp
80102002:	6a 00                	push   $0x0
80102004:	57                   	push   %edi
80102005:	56                   	push   %esi
80102006:	e8 65 fe ff ff       	call   80101e70 <dirlookup>
8010200b:	83 c4 10             	add    $0x10,%esp
8010200e:	85 c0                	test   %eax,%eax
80102010:	74 6e                	je     80102080 <namex+0x160>
  iunlock(ip);
80102012:	83 ec 0c             	sub    $0xc,%esp
80102015:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102018:	56                   	push   %esi
80102019:	e8 02 fa ff ff       	call   80101a20 <iunlock>
  iput(ip);
8010201e:	89 34 24             	mov    %esi,(%esp)
80102021:	e8 4a fa ff ff       	call   80101a70 <iput>
80102026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	89 c6                	mov    %eax,%esi
8010202e:	e9 38 ff ff ff       	jmp    80101f6b <namex+0x4b>
80102033:	90                   	nop
80102034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102038:	89 da                	mov    %ebx,%edx
8010203a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010203c:	83 ec 04             	sub    $0x4,%esp
8010203f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102042:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102045:	51                   	push   %ecx
80102046:	53                   	push   %ebx
80102047:	57                   	push   %edi
80102048:	e8 83 27 00 00       	call   801047d0 <memmove>
    name[len] = 0;
8010204d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102050:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102053:	83 c4 10             	add    $0x10,%esp
80102056:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010205a:	89 d3                	mov    %edx,%ebx
8010205c:	e9 61 ff ff ff       	jmp    80101fc2 <namex+0xa2>
80102061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010206b:	85 c0                	test   %eax,%eax
8010206d:	75 5d                	jne    801020cc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010206f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102072:	89 f0                	mov    %esi,%eax
80102074:	5b                   	pop    %ebx
80102075:	5e                   	pop    %esi
80102076:	5f                   	pop    %edi
80102077:	5d                   	pop    %ebp
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102080:	83 ec 0c             	sub    $0xc,%esp
80102083:	56                   	push   %esi
80102084:	e8 97 f9 ff ff       	call   80101a20 <iunlock>
  iput(ip);
80102089:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010208c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010208e:	e8 dd f9 ff ff       	call   80101a70 <iput>
      return 0;
80102093:	83 c4 10             	add    $0x10,%esp
}
80102096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102099:	89 f0                	mov    %esi,%eax
8010209b:	5b                   	pop    %ebx
8010209c:	5e                   	pop    %esi
8010209d:	5f                   	pop    %edi
8010209e:	5d                   	pop    %ebp
8010209f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020a0:	ba 01 00 00 00       	mov    $0x1,%edx
801020a5:	b8 01 00 00 00       	mov    $0x1,%eax
801020aa:	e8 a1 f2 ff ff       	call   80101350 <iget>
801020af:	89 c6                	mov    %eax,%esi
801020b1:	e9 b5 fe ff ff       	jmp    80101f6b <namex+0x4b>
      iunlock(ip);
801020b6:	83 ec 0c             	sub    $0xc,%esp
801020b9:	56                   	push   %esi
801020ba:	e8 61 f9 ff ff       	call   80101a20 <iunlock>
      return ip;
801020bf:	83 c4 10             	add    $0x10,%esp
}
801020c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c5:	89 f0                	mov    %esi,%eax
801020c7:	5b                   	pop    %ebx
801020c8:	5e                   	pop    %esi
801020c9:	5f                   	pop    %edi
801020ca:	5d                   	pop    %ebp
801020cb:	c3                   	ret    
    iput(ip);
801020cc:	83 ec 0c             	sub    $0xc,%esp
801020cf:	56                   	push   %esi
    return 0;
801020d0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020d2:	e8 99 f9 ff ff       	call   80101a70 <iput>
    return 0;
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	eb 93                	jmp    8010206f <namex+0x14f>
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <dirlink>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 20             	sub    $0x20,%esp
801020e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020ec:	6a 00                	push   $0x0
801020ee:	ff 75 0c             	pushl  0xc(%ebp)
801020f1:	53                   	push   %ebx
801020f2:	e8 79 fd ff ff       	call   80101e70 <dirlookup>
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	85 c0                	test   %eax,%eax
801020fc:	75 67                	jne    80102165 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102101:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102104:	85 ff                	test   %edi,%edi
80102106:	74 29                	je     80102131 <dirlink+0x51>
80102108:	31 ff                	xor    %edi,%edi
8010210a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010210d:	eb 09                	jmp    80102118 <dirlink+0x38>
8010210f:	90                   	nop
80102110:	83 c7 10             	add    $0x10,%edi
80102113:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102116:	73 19                	jae    80102131 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102118:	6a 10                	push   $0x10
8010211a:	57                   	push   %edi
8010211b:	56                   	push   %esi
8010211c:	53                   	push   %ebx
8010211d:	e8 fe fa ff ff       	call   80101c20 <readi>
80102122:	83 c4 10             	add    $0x10,%esp
80102125:	83 f8 10             	cmp    $0x10,%eax
80102128:	75 4e                	jne    80102178 <dirlink+0x98>
    if(de.inum == 0)
8010212a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010212f:	75 df                	jne    80102110 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102131:	8d 45 da             	lea    -0x26(%ebp),%eax
80102134:	83 ec 04             	sub    $0x4,%esp
80102137:	6a 0e                	push   $0xe
80102139:	ff 75 0c             	pushl  0xc(%ebp)
8010213c:	50                   	push   %eax
8010213d:	e8 5e 27 00 00       	call   801048a0 <strncpy>
  de.inum = inum;
80102142:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102145:	6a 10                	push   $0x10
80102147:	57                   	push   %edi
80102148:	56                   	push   %esi
80102149:	53                   	push   %ebx
  de.inum = inum;
8010214a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010214e:	e8 cd fb ff ff       	call   80101d20 <writei>
80102153:	83 c4 20             	add    $0x20,%esp
80102156:	83 f8 10             	cmp    $0x10,%eax
80102159:	75 2a                	jne    80102185 <dirlink+0xa5>
  return 0;
8010215b:	31 c0                	xor    %eax,%eax
}
8010215d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102160:	5b                   	pop    %ebx
80102161:	5e                   	pop    %esi
80102162:	5f                   	pop    %edi
80102163:	5d                   	pop    %ebp
80102164:	c3                   	ret    
    iput(ip);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	50                   	push   %eax
80102169:	e8 02 f9 ff ff       	call   80101a70 <iput>
    return -1;
8010216e:	83 c4 10             	add    $0x10,%esp
80102171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102176:	eb e5                	jmp    8010215d <dirlink+0x7d>
      panic("dirlink read");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 45 76 10 80       	push   $0x80107645
80102180:	e8 1b e3 ff ff       	call   801004a0 <panic>
    panic("dirlink");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 66 7c 10 80       	push   $0x80107c66
8010218d:	e8 0e e3 ff ff       	call   801004a0 <panic>
80102192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <namei>:

struct inode*
namei(char *path)
{
801021a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021a1:	31 d2                	xor    %edx,%edx
{
801021a3:	89 e5                	mov    %esp,%ebp
801021a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021a8:	8b 45 08             	mov    0x8(%ebp),%eax
801021ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021ae:	e8 6d fd ff ff       	call   80101f20 <namex>
}
801021b3:	c9                   	leave  
801021b4:	c3                   	ret    
801021b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021c0:	55                   	push   %ebp
  return namex(path, 1, name);
801021c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021cf:	e9 4c fd ff ff       	jmp    80101f20 <namex>
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021e0:	55                   	push   %ebp
  if(b == 0)
801021e1:	85 c0                	test   %eax,%eax
{
801021e3:	89 e5                	mov    %esp,%ebp
801021e5:	56                   	push   %esi
801021e6:	53                   	push   %ebx
  if(b == 0)
801021e7:	0f 84 af 00 00 00    	je     8010229c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021ed:	8b 58 08             	mov    0x8(%eax),%ebx
801021f0:	89 c6                	mov    %eax,%esi
801021f2:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
801021f8:	0f 87 91 00 00 00    	ja     8010228f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fe:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102208:	89 ca                	mov    %ecx,%edx
8010220a:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010220b:	83 e0 c0             	and    $0xffffffc0,%eax
8010220e:	3c 40                	cmp    $0x40,%al
80102210:	75 f6                	jne    80102208 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102212:	31 c0                	xor    %eax,%eax
80102214:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102219:	ee                   	out    %al,(%dx)
8010221a:	b8 01 00 00 00       	mov    $0x1,%eax
8010221f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102224:	ee                   	out    %al,(%dx)
80102225:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010222a:	89 d8                	mov    %ebx,%eax
8010222c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010222d:	89 d8                	mov    %ebx,%eax
8010222f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102234:	c1 f8 08             	sar    $0x8,%eax
80102237:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80102238:	89 d8                	mov    %ebx,%eax
8010223a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010223f:	c1 f8 10             	sar    $0x10,%eax
80102242:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102243:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102247:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224c:	c1 e0 04             	shl    $0x4,%eax
8010224f:	83 e0 10             	and    $0x10,%eax
80102252:	83 c8 e0             	or     $0xffffffe0,%eax
80102255:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102256:	f6 06 04             	testb  $0x4,(%esi)
80102259:	75 15                	jne    80102270 <idestart+0x90>
8010225b:	b8 20 00 00 00       	mov    $0x20,%eax
80102260:	89 ca                	mov    %ecx,%edx
80102262:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102266:	5b                   	pop    %ebx
80102267:	5e                   	pop    %esi
80102268:	5d                   	pop    %ebp
80102269:	c3                   	ret    
8010226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102270:	b8 30 00 00 00       	mov    $0x30,%eax
80102275:	89 ca                	mov    %ecx,%edx
80102277:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102278:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010227d:	83 c6 5c             	add    $0x5c,%esi
80102280:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102285:	fc                   	cld    
80102286:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102288:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010228b:	5b                   	pop    %ebx
8010228c:	5e                   	pop    %esi
8010228d:	5d                   	pop    %ebp
8010228e:	c3                   	ret    
    panic("incorrect blockno");
8010228f:	83 ec 0c             	sub    $0xc,%esp
80102292:	68 b0 76 10 80       	push   $0x801076b0
80102297:	e8 04 e2 ff ff       	call   801004a0 <panic>
    panic("idestart");
8010229c:	83 ec 0c             	sub    $0xc,%esp
8010229f:	68 a7 76 10 80       	push   $0x801076a7
801022a4:	e8 f7 e1 ff ff       	call   801004a0 <panic>
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideinit>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022b6:	68 c2 76 10 80       	push   $0x801076c2
801022bb:	68 80 a5 10 80       	push   $0x8010a580
801022c0:	e8 eb 21 00 00       	call   801044b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022c5:	58                   	pop    %eax
801022c6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801022cb:	5a                   	pop    %edx
801022cc:	83 e8 01             	sub    $0x1,%eax
801022cf:	50                   	push   %eax
801022d0:	6a 0e                	push   $0xe
801022d2:	e8 a9 02 00 00       	call   80102580 <ioapicenable>
801022d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	83 e0 c0             	and    $0xffffffc0,%eax
801022e4:	3c 40                	cmp    $0x40,%al
801022e6:	75 f8                	jne    801022e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f2:	ee                   	out    %al,(%dx)
801022f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022fd:	eb 06                	jmp    80102305 <ideinit+0x55>
801022ff:	90                   	nop
  for(i=0; i<1000; i++){
80102300:	83 e9 01             	sub    $0x1,%ecx
80102303:	74 0f                	je     80102314 <ideinit+0x64>
80102305:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102306:	84 c0                	test   %al,%al
80102308:	74 f6                	je     80102300 <ideinit+0x50>
      havedisk1 = 1;
8010230a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102311:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102314:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102319:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010231e:	ee                   	out    %al,(%dx)
}
8010231f:	c9                   	leave  
80102320:	c3                   	ret    
80102321:	eb 0d                	jmp    80102330 <ideintr>
80102323:	90                   	nop
80102324:	90                   	nop
80102325:	90                   	nop
80102326:	90                   	nop
80102327:	90                   	nop
80102328:	90                   	nop
80102329:	90                   	nop
8010232a:	90                   	nop
8010232b:	90                   	nop
8010232c:	90                   	nop
8010232d:	90                   	nop
8010232e:	90                   	nop
8010232f:	90                   	nop

80102330 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102339:	68 80 a5 10 80       	push   $0x8010a580
8010233e:	e8 5d 22 00 00       	call   801045a0 <acquire>

  if((b = idequeue) == 0){
80102343:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 db                	test   %ebx,%ebx
8010234e:	74 67                	je     801023b7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102350:	8b 43 58             	mov    0x58(%ebx),%eax
80102353:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102358:	8b 3b                	mov    (%ebx),%edi
8010235a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102360:	75 31                	jne    80102393 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102362:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102367:	89 f6                	mov    %esi,%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102370:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102371:	89 c6                	mov    %eax,%esi
80102373:	83 e6 c0             	and    $0xffffffc0,%esi
80102376:	89 f1                	mov    %esi,%ecx
80102378:	80 f9 40             	cmp    $0x40,%cl
8010237b:	75 f3                	jne    80102370 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010237d:	a8 21                	test   $0x21,%al
8010237f:	75 12                	jne    80102393 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102381:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102384:	b9 80 00 00 00       	mov    $0x80,%ecx
80102389:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010238e:	fc                   	cld    
8010238f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102391:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102393:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102396:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102399:	89 f9                	mov    %edi,%ecx
8010239b:	83 c9 02             	or     $0x2,%ecx
8010239e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801023a0:	53                   	push   %ebx
801023a1:	e8 5a 1e 00 00       	call   80104200 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023a6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801023ab:	83 c4 10             	add    $0x10,%esp
801023ae:	85 c0                	test   %eax,%eax
801023b0:	74 05                	je     801023b7 <ideintr+0x87>
    idestart(idequeue);
801023b2:	e8 29 fe ff ff       	call   801021e0 <idestart>
    release(&idelock);
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 80 a5 10 80       	push   $0x8010a580
801023bf:	e8 fc 22 00 00       	call   801046c0 <release>

  release(&idelock);
}
801023c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c7:	5b                   	pop    %ebx
801023c8:	5e                   	pop    %esi
801023c9:	5f                   	pop    %edi
801023ca:	5d                   	pop    %ebp
801023cb:	c3                   	ret    
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 10             	sub    $0x10,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023da:	8d 43 0c             	lea    0xc(%ebx),%eax
801023dd:	50                   	push   %eax
801023de:	e8 9d 20 00 00       	call   80104480 <holdingsleep>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	85 c0                	test   %eax,%eax
801023e8:	0f 84 c6 00 00 00    	je     801024b4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 e0 06             	and    $0x6,%eax
801023f3:	83 f8 02             	cmp    $0x2,%eax
801023f6:	0f 84 ab 00 00 00    	je     801024a7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023fc:	8b 53 04             	mov    0x4(%ebx),%edx
801023ff:	85 d2                	test   %edx,%edx
80102401:	74 0d                	je     80102410 <iderw+0x40>
80102403:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102408:	85 c0                	test   %eax,%eax
8010240a:	0f 84 b1 00 00 00    	je     801024c1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	68 80 a5 10 80       	push   $0x8010a580
80102418:	e8 83 21 00 00       	call   801045a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102423:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102426:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010242d:	85 d2                	test   %edx,%edx
8010242f:	75 09                	jne    8010243a <iderw+0x6a>
80102431:	eb 6d                	jmp    801024a0 <iderw+0xd0>
80102433:	90                   	nop
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 c2                	mov    %eax,%edx
8010243a:	8b 42 58             	mov    0x58(%edx),%eax
8010243d:	85 c0                	test   %eax,%eax
8010243f:	75 f7                	jne    80102438 <iderw+0x68>
80102441:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102444:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102446:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010244c:	74 42                	je     80102490 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 e0 06             	and    $0x6,%eax
80102453:	83 f8 02             	cmp    $0x2,%eax
80102456:	74 23                	je     8010247b <iderw+0xab>
80102458:	90                   	nop
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102460:	83 ec 08             	sub    $0x8,%esp
80102463:	68 80 a5 10 80       	push   $0x8010a580
80102468:	53                   	push   %ebx
80102469:	e8 d2 1b 00 00       	call   80104040 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010246e:	8b 03                	mov    (%ebx),%eax
80102470:	83 c4 10             	add    $0x10,%esp
80102473:	83 e0 06             	and    $0x6,%eax
80102476:	83 f8 02             	cmp    $0x2,%eax
80102479:	75 e5                	jne    80102460 <iderw+0x90>
  }


  release(&idelock);
8010247b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102485:	c9                   	leave  
  release(&idelock);
80102486:	e9 35 22 00 00       	jmp    801046c0 <release>
8010248b:	90                   	nop
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102490:	89 d8                	mov    %ebx,%eax
80102492:	e8 49 fd ff ff       	call   801021e0 <idestart>
80102497:	eb b5                	jmp    8010244e <iderw+0x7e>
80102499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024a0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801024a5:	eb 9d                	jmp    80102444 <iderw+0x74>
    panic("iderw: nothing to do");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 dc 76 10 80       	push   $0x801076dc
801024af:	e8 ec df ff ff       	call   801004a0 <panic>
    panic("iderw: buf not locked");
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	68 c6 76 10 80       	push   $0x801076c6
801024bc:	e8 df df ff ff       	call   801004a0 <panic>
    panic("iderw: ide disk 1 not present");
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	68 f1 76 10 80       	push   $0x801076f1
801024c9:	e8 d2 df ff ff       	call   801004a0 <panic>
801024ce:	66 90                	xchg   %ax,%ax

801024d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024d8:	00 c0 fe 
{
801024db:	89 e5                	mov    %esp,%ebp
801024dd:	56                   	push   %esi
801024de:	53                   	push   %ebx
  ioapic->reg = reg;
801024df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024e6:	00 00 00 
  return ioapic->data;
801024e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024fe:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102505:	89 f0                	mov    %esi,%eax
80102507:	c1 e8 10             	shr    $0x10,%eax
8010250a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010250d:	8b 41 10             	mov    0x10(%ecx),%eax
  if(id != ioapicid)
80102510:	c1 e8 18             	shr    $0x18,%eax
80102513:	39 d0                	cmp    %edx,%eax
80102515:	74 16                	je     8010252d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102517:	83 ec 0c             	sub    $0xc,%esp
8010251a:	68 10 77 10 80       	push   $0x80107710
8010251f:	e8 4c e2 ff ff       	call   80100770 <cprintf>
80102524:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010252a:	83 c4 10             	add    $0x10,%esp
8010252d:	83 c6 21             	add    $0x21,%esi
{
80102530:	ba 10 00 00 00       	mov    $0x10,%edx
80102535:	b8 20 00 00 00       	mov    $0x20,%eax
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102540:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102542:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102548:	89 c3                	mov    %eax,%ebx
8010254a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102550:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102553:	89 59 10             	mov    %ebx,0x10(%ecx)
80102556:	8d 5a 01             	lea    0x1(%edx),%ebx
80102559:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010255c:	39 f0                	cmp    %esi,%eax
  ioapic->reg = reg;
8010255e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102560:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102566:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010256d:	75 d1                	jne    80102540 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010256f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102572:	5b                   	pop    %ebx
80102573:	5e                   	pop    %esi
80102574:	5d                   	pop    %ebp
80102575:	c3                   	ret    
80102576:	8d 76 00             	lea    0x0(%esi),%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102580:	55                   	push   %ebp
  ioapic->reg = reg;
80102581:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010258c:	8d 50 20             	lea    0x20(%eax),%edx
8010258f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102593:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102595:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapic->reg = reg;
8010259b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010259e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
801025c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP){
801025ca:	89 d8                	mov    %ebx,%eax
801025cc:	25 ff 0f 00 00       	and    $0xfff,%eax
801025d1:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801025d7:	72 79                	jb     80102652 <kfree+0x92>
801025d9:	85 c0                	test   %eax,%eax
801025db:	75 75                	jne    80102652 <kfree+0x92>
801025dd:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
801025e3:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
801025e9:	77 67                	ja     80102652 <kfree+0x92>
    cprintf("In kfree : %x PHYSTOP : %d\n", v, PHYSTOP);
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025eb:	83 ec 04             	sub    $0x4,%esp
801025ee:	68 00 10 00 00       	push   $0x1000
801025f3:	6a 01                	push   $0x1
801025f5:	53                   	push   %ebx
801025f6:	e8 25 21 00 00       	call   80104720 <memset>

  if(kmem.use_lock)
801025fb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102601:	83 c4 10             	add    $0x10,%esp
80102604:	85 d2                	test   %edx,%edx
80102606:	75 38                	jne    80102640 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102608:	a1 78 26 11 80       	mov    0x80112678,%eax
8010260d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010260f:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102614:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010261a:	85 c0                	test   %eax,%eax
8010261c:	75 0a                	jne    80102628 <kfree+0x68>
    release(&kmem.lock);
}
8010261e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102621:	c9                   	leave  
80102622:	c3                   	ret    
80102623:	90                   	nop
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102628:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010262f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102632:	c9                   	leave  
    release(&kmem.lock);
80102633:	e9 88 20 00 00       	jmp    801046c0 <release>
80102638:	90                   	nop
80102639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	68 40 26 11 80       	push   $0x80112640
80102648:	e8 53 1f 00 00       	call   801045a0 <acquire>
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	eb b6                	jmp    80102608 <kfree+0x48>
    cprintf("FIRST : %d\n", (uint)v % PGSIZE);
80102652:	83 ec 08             	sub    $0x8,%esp
80102655:	50                   	push   %eax
80102656:	68 42 77 10 80       	push   $0x80107742
8010265b:	e8 10 e1 ff ff       	call   80100770 <cprintf>
    cprintf("In kfree : %x PHYSTOP : %d\n", v, PHYSTOP);
80102660:	83 c4 0c             	add    $0xc,%esp
80102663:	68 00 00 40 00       	push   $0x400000
80102668:	53                   	push   %ebx
80102669:	68 4e 77 10 80       	push   $0x8010774e
8010266e:	e8 fd e0 ff ff       	call   80100770 <cprintf>
    panic("kfree");
80102673:	c7 04 24 6a 77 10 80 	movl   $0x8010776a,(%esp)
8010267a:	e8 21 de ff ff       	call   801004a0 <panic>
8010267f:	90                   	nop

80102680 <freerange>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <freerange+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 03 ff ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 f3                	cmp    %esi,%ebx
801026c2:	76 e4                	jbe    801026a8 <freerange+0x28>
}
801026c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c7:	5b                   	pop    %ebx
801026c8:	5e                   	pop    %esi
801026c9:	5d                   	pop    %ebp
801026ca:	c3                   	ret    
801026cb:	90                   	nop
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026d0 <kinit1>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
801026d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026d8:	83 ec 08             	sub    $0x8,%esp
801026db:	68 70 77 10 80       	push   $0x80107770
801026e0:	68 40 26 11 80       	push   $0x80112640
801026e5:	e8 c6 1d 00 00       	call   801044b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026f0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102700:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102706:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010270c:	39 de                	cmp    %ebx,%esi
8010270e:	72 1c                	jb     8010272c <kinit1+0x5c>
    kfree(p);
80102710:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102716:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102719:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010271f:	50                   	push   %eax
80102720:	e8 9b fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102725:	83 c4 10             	add    $0x10,%esp
80102728:	39 de                	cmp    %ebx,%esi
8010272a:	73 e4                	jae    80102710 <kinit1+0x40>
}
8010272c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010272f:	5b                   	pop    %ebx
80102730:	5e                   	pop    %esi
80102731:	5d                   	pop    %ebp
80102732:	c3                   	ret    
80102733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <kinit2>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <kinit2+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 43 fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 de                	cmp    %ebx,%esi
80102782:	73 e4                	jae    80102768 <kinit2+0x28>
  kmem.use_lock = 1;
80102784:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010278b:	00 00 00 
}
8010278e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102791:	5b                   	pop    %ebx
80102792:	5e                   	pop    %esi
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027a7:	a1 74 26 11 80       	mov    0x80112674,%eax
801027ac:	85 c0                	test   %eax,%eax
801027ae:	75 30                	jne    801027e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027b0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801027b6:	85 db                	test   %ebx,%ebx
801027b8:	74 1c                	je     801027d6 <kalloc+0x36>
    kmem.freelist = r->next;
801027ba:	8b 13                	mov    (%ebx),%edx
801027bc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801027c2:	85 c0                	test   %eax,%eax
801027c4:	74 10                	je     801027d6 <kalloc+0x36>
    release(&kmem.lock);
801027c6:	83 ec 0c             	sub    $0xc,%esp
801027c9:	68 40 26 11 80       	push   $0x80112640
801027ce:	e8 ed 1e 00 00       	call   801046c0 <release>
801027d3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801027d6:	89 d8                	mov    %ebx,%eax
801027d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027db:	c9                   	leave  
801027dc:	c3                   	ret    
801027dd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 40 26 11 80       	push   $0x80112640
801027e8:	e8 b3 1d 00 00       	call   801045a0 <acquire>
  r = kmem.freelist;
801027ed:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	a1 74 26 11 80       	mov    0x80112674,%eax
801027fb:	85 db                	test   %ebx,%ebx
801027fd:	75 bb                	jne    801027ba <kalloc+0x1a>
801027ff:	eb c1                	jmp    801027c2 <kalloc+0x22>
80102801:	66 90                	xchg   %ax,%ax
80102803:	66 90                	xchg   %ax,%ax
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102810:	ba 64 00 00 00       	mov    $0x64,%edx
80102815:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102816:	a8 01                	test   $0x1,%al
80102818:	0f 84 c2 00 00 00    	je     801028e0 <kbdgetc+0xd0>
8010281e:	ba 60 00 00 00       	mov    $0x60,%edx
80102823:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102824:	0f b6 d0             	movzbl %al,%edx
80102827:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010282d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102833:	0f 84 7f 00 00 00    	je     801028b8 <kbdgetc+0xa8>
{
80102839:	55                   	push   %ebp
8010283a:	89 e5                	mov    %esp,%ebp
8010283c:	53                   	push   %ebx
8010283d:	89 cb                	mov    %ecx,%ebx
8010283f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102842:	84 c0                	test   %al,%al
80102844:	78 4a                	js     80102890 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102846:	85 db                	test   %ebx,%ebx
80102848:	74 09                	je     80102853 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010284a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010284d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102850:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102853:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
8010285a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010285c:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
80102863:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102865:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102867:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010286d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102870:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102873:	8b 04 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%eax
8010287a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010287e:	74 31                	je     801028b1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102880:	8d 50 9f             	lea    -0x61(%eax),%edx
80102883:	83 fa 19             	cmp    $0x19,%edx
80102886:	77 40                	ja     801028c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102888:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010288b:	5b                   	pop    %ebx
8010288c:	5d                   	pop    %ebp
8010288d:	c3                   	ret    
8010288e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 db                	test   %ebx,%ebx
80102895:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102898:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
8010289f:	83 c8 40             	or     $0x40,%eax
801028a2:	0f b6 c0             	movzbl %al,%eax
801028a5:	f7 d0                	not    %eax
801028a7:	21 c1                	and    %eax,%ecx
    return 0;
801028a9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801028ab:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801028b1:	5b                   	pop    %ebx
801028b2:	5d                   	pop    %ebp
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801028b8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801028bb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028bd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801028c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028ce:	5b                   	pop    %ebx
      c += 'a' - 'A';
801028cf:	83 f9 1a             	cmp    $0x1a,%ecx
801028d2:	0f 42 c2             	cmovb  %edx,%eax
}
801028d5:	5d                   	pop    %ebp
801028d6:	c3                   	ret    
801028d7:	89 f6                	mov    %esi,%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801028e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028e5:	c3                   	ret    
801028e6:	8d 76 00             	lea    0x0(%esi),%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <kbdintr>:

void
kbdintr(void)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028f6:	68 10 28 10 80       	push   $0x80102810
801028fb:	e8 20 e0 ff ff       	call   80100920 <consoleintr>
}
80102900:	83 c4 10             	add    $0x10,%esp
80102903:	c9                   	leave  
80102904:	c3                   	ret    
80102905:	66 90                	xchg   %ax,%ax
80102907:	66 90                	xchg   %ax,%ax
80102909:	66 90                	xchg   %ax,%ax
8010290b:	66 90                	xchg   %ax,%ax
8010290d:	66 90                	xchg   %ax,%ax
8010290f:	90                   	nop

80102910 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102910:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102915:	55                   	push   %ebp
80102916:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102918:	85 c0                	test   %eax,%eax
8010291a:	0f 84 c8 00 00 00    	je     801029e8 <lapicinit+0xd8>
  lapic[index] = value;
80102920:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102927:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102941:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010294e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102951:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102954:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010295b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102961:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102968:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010296e:	8b 50 30             	mov    0x30(%eax),%edx
80102971:	c1 ea 10             	shr    $0x10,%edx
80102974:	80 fa 03             	cmp    $0x3,%dl
80102977:	77 77                	ja     801029f0 <lapicinit+0xe0>
  lapic[index] = value;
80102979:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102980:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102986:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102990:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102993:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010299a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
801029c7:	89 f6                	mov    %esi,%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029d6:	80 e6 10             	and    $0x10,%dh
801029d9:	75 f5                	jne    801029d0 <lapicinit+0xc0>
  lapic[index] = value;
801029db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029e8:	5d                   	pop    %ebp
801029e9:	c3                   	ret    
801029ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801029f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fa:	8b 50 20             	mov    0x20(%eax),%edx
801029fd:	e9 77 ff ff ff       	jmp    80102979 <lapicinit+0x69>
80102a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a10:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102a16:	55                   	push   %ebp
80102a17:	31 c0                	xor    %eax,%eax
80102a19:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a1b:	85 d2                	test   %edx,%edx
80102a1d:	74 06                	je     80102a25 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102a1f:	8b 42 20             	mov    0x20(%edx),%eax
80102a22:	c1 e8 18             	shr    $0x18,%eax
}
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    
80102a27:	89 f6                	mov    %esi,%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a30:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102a38:	85 c0                	test   %eax,%eax
80102a3a:	74 0d                	je     80102a49 <lapiceoi+0x19>
  lapic[index] = value;
80102a3c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a43:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a46:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a49:	5d                   	pop    %ebp
80102a4a:	c3                   	ret    
80102a4b:	90                   	nop
80102a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
}
80102a53:	5d                   	pop    %ebp
80102a54:	c3                   	ret    
80102a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a61:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a66:	ba 70 00 00 00       	mov    $0x70,%edx
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	53                   	push   %ebx
80102a6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a74:	ee                   	out    %al,(%dx)
80102a75:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a7a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a80:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a82:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a8d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a90:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a93:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a95:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a98:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a9e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102aa3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ab3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ac0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102acc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102acf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ad8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ade:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ae1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aea:	5b                   	pop    %ebx
80102aeb:	5d                   	pop    %ebp
80102aec:	c3                   	ret    
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102af0:	55                   	push   %ebp
80102af1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102af6:	ba 70 00 00 00       	mov    $0x70,%edx
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	57                   	push   %edi
80102afe:	56                   	push   %esi
80102aff:	53                   	push   %ebx
80102b00:	83 ec 4c             	sub    $0x4c,%esp
80102b03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b04:	ba 71 00 00 00       	mov    $0x71,%edx
80102b09:	ec                   	in     (%dx),%al
80102b0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b15:	8d 76 00             	lea    0x0(%esi),%esi
80102b18:	31 c0                	xor    %eax,%eax
80102b1a:	89 da                	mov    %ebx,%edx
80102b1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b22:	89 ca                	mov    %ecx,%edx
80102b24:	ec                   	in     (%dx),%al
80102b25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b28:	89 da                	mov    %ebx,%edx
80102b2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
80102b33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 da                	mov    %ebx,%edx
80102b38:	b8 04 00 00 00       	mov    $0x4,%eax
80102b3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3e:	89 ca                	mov    %ecx,%edx
80102b40:	ec                   	in     (%dx),%al
80102b41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b44:	89 da                	mov    %ebx,%edx
80102b46:	b8 07 00 00 00       	mov    $0x7,%eax
80102b4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4c:	89 ca                	mov    %ecx,%edx
80102b4e:	ec                   	in     (%dx),%al
80102b4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b52:	89 da                	mov    %ebx,%edx
80102b54:	b8 08 00 00 00       	mov    $0x8,%eax
80102b59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5a:	89 ca                	mov    %ecx,%edx
80102b5c:	ec                   	in     (%dx),%al
80102b5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5f:	89 da                	mov    %ebx,%edx
80102b61:	b8 09 00 00 00       	mov    $0x9,%eax
80102b66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b67:	89 ca                	mov    %ecx,%edx
80102b69:	ec                   	in     (%dx),%al
80102b6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6c:	89 da                	mov    %ebx,%edx
80102b6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b74:	89 ca                	mov    %ecx,%edx
80102b76:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b77:	84 c0                	test   %al,%al
80102b79:	78 9d                	js     80102b18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b7f:	89 fa                	mov    %edi,%edx
80102b81:	0f b6 fa             	movzbl %dl,%edi
80102b84:	89 f2                	mov    %esi,%edx
80102b86:	0f b6 f2             	movzbl %dl,%esi
80102b89:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8c:	89 da                	mov    %ebx,%edx
80102b8e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b91:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b94:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b98:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b9b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ba2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ba6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ba9:	31 c0                	xor    %eax,%eax
80102bab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bac:	89 ca                	mov    %ecx,%edx
80102bae:	ec                   	in     (%dx),%al
80102baf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb2:	89 da                	mov    %ebx,%edx
80102bb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bb7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbd:	89 ca                	mov    %ecx,%edx
80102bbf:	ec                   	in     (%dx),%al
80102bc0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc3:	89 da                	mov    %ebx,%edx
80102bc5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	89 ca                	mov    %ecx,%edx
80102bd0:	ec                   	in     (%dx),%al
80102bd1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd4:	89 da                	mov    %ebx,%edx
80102bd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bd9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdf:	89 ca                	mov    %ecx,%edx
80102be1:	ec                   	in     (%dx),%al
80102be2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be5:	89 da                	mov    %ebx,%edx
80102be7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bea:	b8 08 00 00 00       	mov    $0x8,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bfb:	b8 09 00 00 00       	mov    $0x9,%eax
80102c00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c01:	89 ca                	mov    %ecx,%edx
80102c03:	ec                   	in     (%dx),%al
80102c04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c10:	6a 18                	push   $0x18
80102c12:	50                   	push   %eax
80102c13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c16:	50                   	push   %eax
80102c17:	e8 54 1b 00 00       	call   80104770 <memcmp>
80102c1c:	83 c4 10             	add    $0x10,%esp
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	0f 85 f1 fe ff ff    	jne    80102b18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c2b:	75 78                	jne    80102ca5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c30:	89 c2                	mov    %eax,%edx
80102c32:	83 e0 0f             	and    $0xf,%eax
80102c35:	c1 ea 04             	shr    $0x4,%edx
80102c38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c44:	89 c2                	mov    %eax,%edx
80102c46:	83 e0 0f             	and    $0xf,%eax
80102c49:	c1 ea 04             	shr    $0x4,%edx
80102c4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	83 e0 0f             	and    $0xf,%eax
80102c5d:	c1 ea 04             	shr    $0x4,%edx
80102c60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c6c:	89 c2                	mov    %eax,%edx
80102c6e:	83 e0 0f             	and    $0xf,%eax
80102c71:	c1 ea 04             	shr    $0x4,%edx
80102c74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c80:	89 c2                	mov    %eax,%edx
80102c82:	83 e0 0f             	and    $0xf,%eax
80102c85:	c1 ea 04             	shr    $0x4,%edx
80102c88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c94:	89 c2                	mov    %eax,%edx
80102c96:	83 e0 0f             	and    $0xf,%eax
80102c99:	c1 ea 04             	shr    $0x4,%edx
80102c9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ca5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ca8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cab:	89 06                	mov    %eax,(%esi)
80102cad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cb0:	89 46 04             	mov    %eax,0x4(%esi)
80102cb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cb6:	89 46 08             	mov    %eax,0x8(%esi)
80102cb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102cbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cc2:	89 46 10             	mov    %eax,0x10(%esi)
80102cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ccb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd5:	5b                   	pop    %ebx
80102cd6:	5e                   	pop    %esi
80102cd7:	5f                   	pop    %edi
80102cd8:	5d                   	pop    %ebp
80102cd9:	c3                   	ret    
80102cda:	66 90                	xchg   %ax,%ax
80102cdc:	66 90                	xchg   %ax,%ax
80102cde:	66 90                	xchg   %ax,%ax

80102ce0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ce6:	85 c9                	test   %ecx,%ecx
80102ce8:	0f 8e 85 00 00 00    	jle    80102d73 <install_trans+0x93>
{
80102cee:	55                   	push   %ebp
80102cef:	89 e5                	mov    %esp,%ebp
80102cf1:	57                   	push   %edi
80102cf2:	56                   	push   %esi
80102cf3:	53                   	push   %ebx
80102cf4:	31 db                	xor    %ebx,%ebx
80102cf6:	83 ec 0c             	sub    $0xc,%esp
80102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d05:	83 ec 08             	sub    $0x8,%esp
80102d08:	01 d8                	add    %ebx,%eax
80102d0a:	83 c0 01             	add    $0x1,%eax
80102d0d:	50                   	push   %eax
80102d0e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d14:	e8 77 d4 ff ff       	call   80100190 <bread>
80102d19:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1b:	58                   	pop    %eax
80102d1c:	5a                   	pop    %edx
80102d1d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d24:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d2d:	e8 5e d4 ff ff       	call   80100190 <bread>
80102d32:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d34:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d37:	83 c4 0c             	add    $0xc,%esp
80102d3a:	68 00 02 00 00       	push   $0x200
80102d3f:	50                   	push   %eax
80102d40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d43:	50                   	push   %eax
80102d44:	e8 87 1a 00 00       	call   801047d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d49:	89 34 24             	mov    %esi,(%esp)
80102d4c:	e8 7f d4 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80102d51:	89 3c 24             	mov    %edi,(%esp)
80102d54:	e8 b7 d4 ff ff       	call   80100210 <brelse>
    brelse(dbuf);
80102d59:	89 34 24             	mov    %esi,(%esp)
80102d5c:	e8 af d4 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d61:	83 c4 10             	add    $0x10,%esp
80102d64:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102d6a:	7f 94                	jg     80102d00 <install_trans+0x20>
  }
}
80102d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5f                   	pop    %edi
80102d72:	5d                   	pop    %ebp
80102d73:	f3 c3                	repz ret 
80102d75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d87:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102d8d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d93:	e8 f8 d3 ff ff       	call   80100190 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d98:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d9e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102da1:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102da3:	85 c9                	test   %ecx,%ecx
  hb->n = log.lh.n;
80102da5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102da8:	7e 1f                	jle    80102dc9 <write_head+0x49>
80102daa:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102db1:	31 d2                	xor    %edx,%edx
80102db3:	90                   	nop
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102db8:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102dbe:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102dc2:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc5:	39 c2                	cmp    %eax,%edx
80102dc7:	75 ef                	jne    80102db8 <write_head+0x38>
  }
  bwrite(buf);
80102dc9:	83 ec 0c             	sub    $0xc,%esp
80102dcc:	53                   	push   %ebx
80102dcd:	e8 fe d3 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80102dd2:	89 1c 24             	mov    %ebx,(%esp)
80102dd5:	e8 36 d4 ff ff       	call   80100210 <brelse>
}
80102dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ddd:	c9                   	leave  
80102dde:	c3                   	ret    
80102ddf:	90                   	nop

80102de0 <initlog>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 2c             	sub    $0x2c,%esp
80102de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dea:	68 a0 79 10 80       	push   $0x801079a0
80102def:	68 80 26 11 80       	push   $0x80112680
80102df4:	e8 b7 16 00 00       	call   801044b0 <initlock>
  readsb(dev, &sb);
80102df9:	58                   	pop    %eax
80102dfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dfd:	5a                   	pop    %edx
80102dfe:	50                   	push   %eax
80102dff:	53                   	push   %ebx
80102e00:	e8 fb e6 ff ff       	call   80101500 <readsb>
  log.size = sb.nlog;
80102e05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e0b:	59                   	pop    %ecx
  log.dev = dev;
80102e0c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102e12:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102e18:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102e1d:	5a                   	pop    %edx
80102e1e:	50                   	push   %eax
80102e1f:	53                   	push   %ebx
80102e20:	e8 6b d3 ff ff       	call   80100190 <bread>
  log.lh.n = lh->n;
80102e25:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e28:	83 c4 10             	add    $0x10,%esp
80102e2b:	85 c9                	test   %ecx,%ecx
  log.lh.n = lh->n;
80102e2d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102e33:	7e 1c                	jle    80102e51 <initlog+0x71>
80102e35:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102e3c:	31 d2                	xor    %edx,%edx
80102e3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e40:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e44:	83 c2 04             	add    $0x4,%edx
80102e47:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e4d:	39 da                	cmp    %ebx,%edx
80102e4f:	75 ef                	jne    80102e40 <initlog+0x60>
  brelse(buf);
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	50                   	push   %eax
80102e55:	e8 b6 d3 ff ff       	call   80100210 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e5a:	e8 81 fe ff ff       	call   80102ce0 <install_trans>
  log.lh.n = 0;
80102e5f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e66:	00 00 00 
  write_head(); // clear the log
80102e69:	e8 12 ff ff ff       	call   80102d80 <write_head>
}
80102e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e71:	c9                   	leave  
80102e72:	c3                   	ret    
80102e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e86:	68 80 26 11 80       	push   $0x80112680
80102e8b:	e8 10 17 00 00       	call   801045a0 <acquire>
80102e90:	83 c4 10             	add    $0x10,%esp
80102e93:	eb 18                	jmp    80102ead <begin_op+0x2d>
80102e95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e98:	83 ec 08             	sub    $0x8,%esp
80102e9b:	68 80 26 11 80       	push   $0x80112680
80102ea0:	68 80 26 11 80       	push   $0x80112680
80102ea5:	e8 96 11 00 00       	call   80104040 <sleep>
80102eaa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ead:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102eb2:	85 c0                	test   %eax,%eax
80102eb4:	75 e2                	jne    80102e98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102eb6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ebb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ec1:	83 c0 01             	add    $0x1,%eax
80102ec4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ec7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eca:	83 fa 1e             	cmp    $0x1e,%edx
80102ecd:	7f c9                	jg     80102e98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ecf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ed2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102ed7:	68 80 26 11 80       	push   $0x80112680
80102edc:	e8 df 17 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	c9                   	leave  
80102ee5:	c3                   	ret    
80102ee6:	8d 76 00             	lea    0x0(%esi),%esi
80102ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ef0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	57                   	push   %edi
80102ef4:	56                   	push   %esi
80102ef5:	53                   	push   %ebx
80102ef6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ef9:	68 80 26 11 80       	push   $0x80112680
80102efe:	e8 9d 16 00 00       	call   801045a0 <acquire>
  log.outstanding -= 1;
80102f03:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102f08:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102f0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f11:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102f14:	85 db                	test   %ebx,%ebx
  log.outstanding -= 1;
80102f16:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102f1b:	0f 85 23 01 00 00    	jne    80103044 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f21:	85 c0                	test   %eax,%eax
80102f23:	0f 85 f7 00 00 00    	jne    80103020 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f29:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102f2c:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102f33:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f36:	31 db                	xor    %ebx,%ebx
  release(&log.lock);
80102f38:	68 80 26 11 80       	push   $0x80112680
80102f3d:	e8 7e 17 00 00       	call   801046c0 <release>
  if (log.lh.n > 0) {
80102f42:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102f48:	83 c4 10             	add    $0x10,%esp
80102f4b:	85 c9                	test   %ecx,%ecx
80102f4d:	0f 8e 8a 00 00 00    	jle    80102fdd <end_op+0xed>
80102f53:	90                   	nop
80102f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f58:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102f5d:	83 ec 08             	sub    $0x8,%esp
80102f60:	01 d8                	add    %ebx,%eax
80102f62:	83 c0 01             	add    $0x1,%eax
80102f65:	50                   	push   %eax
80102f66:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102f6c:	e8 1f d2 ff ff       	call   80100190 <bread>
80102f71:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f73:	58                   	pop    %eax
80102f74:	5a                   	pop    %edx
80102f75:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102f7c:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f82:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f85:	e8 06 d2 ff ff       	call   80100190 <bread>
80102f8a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f8c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f8f:	83 c4 0c             	add    $0xc,%esp
80102f92:	68 00 02 00 00       	push   $0x200
80102f97:	50                   	push   %eax
80102f98:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f9b:	50                   	push   %eax
80102f9c:	e8 2f 18 00 00       	call   801047d0 <memmove>
    bwrite(to);  // write the log
80102fa1:	89 34 24             	mov    %esi,(%esp)
80102fa4:	e8 27 d2 ff ff       	call   801001d0 <bwrite>
    brelse(from);
80102fa9:	89 3c 24             	mov    %edi,(%esp)
80102fac:	e8 5f d2 ff ff       	call   80100210 <brelse>
    brelse(to);
80102fb1:	89 34 24             	mov    %esi,(%esp)
80102fb4:	e8 57 d2 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fb9:	83 c4 10             	add    $0x10,%esp
80102fbc:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102fc2:	7c 94                	jl     80102f58 <end_op+0x68>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fc4:	e8 b7 fd ff ff       	call   80102d80 <write_head>
    install_trans(); // Now install writes to home locations
80102fc9:	e8 12 fd ff ff       	call   80102ce0 <install_trans>
    log.lh.n = 0;
80102fce:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102fd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd8:	e8 a3 fd ff ff       	call   80102d80 <write_head>
    acquire(&log.lock);
80102fdd:	83 ec 0c             	sub    $0xc,%esp
80102fe0:	68 80 26 11 80       	push   $0x80112680
80102fe5:	e8 b6 15 00 00       	call   801045a0 <acquire>
    wakeup(&log);
80102fea:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102ff1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ff8:	00 00 00 
    wakeup(&log);
80102ffb:	e8 00 12 00 00       	call   80104200 <wakeup>
    release(&log.lock);
80103000:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80103007:	e8 b4 16 00 00       	call   801046c0 <release>
8010300c:	83 c4 10             	add    $0x10,%esp
}
8010300f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103012:	5b                   	pop    %ebx
80103013:	5e                   	pop    %esi
80103014:	5f                   	pop    %edi
80103015:	5d                   	pop    %ebp
80103016:	c3                   	ret    
80103017:	89 f6                	mov    %esi,%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    wakeup(&log);
80103020:	83 ec 0c             	sub    $0xc,%esp
80103023:	68 80 26 11 80       	push   $0x80112680
80103028:	e8 d3 11 00 00       	call   80104200 <wakeup>
  release(&log.lock);
8010302d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80103034:	e8 87 16 00 00       	call   801046c0 <release>
80103039:	83 c4 10             	add    $0x10,%esp
}
8010303c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
    panic("log.committing");
80103044:	83 ec 0c             	sub    $0xc,%esp
80103047:	68 a4 79 10 80       	push   $0x801079a4
8010304c:	e8 4f d4 ff ff       	call   801004a0 <panic>
80103051:	eb 0d                	jmp    80103060 <log_write>
80103053:	90                   	nop
80103054:	90                   	nop
80103055:	90                   	nop
80103056:	90                   	nop
80103057:	90                   	nop
80103058:	90                   	nop
80103059:	90                   	nop
8010305a:	90                   	nop
8010305b:	90                   	nop
8010305c:	90                   	nop
8010305d:	90                   	nop
8010305e:	90                   	nop
8010305f:	90                   	nop

80103060 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103067:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
8010306d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103070:	83 fa 1d             	cmp    $0x1d,%edx
80103073:	0f 8f 97 00 00 00    	jg     80103110 <log_write+0xb0>
80103079:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010307e:	83 e8 01             	sub    $0x1,%eax
80103081:	39 c2                	cmp    %eax,%edx
80103083:	0f 8d 87 00 00 00    	jge    80103110 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103089:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010308e:	85 c0                	test   %eax,%eax
80103090:	0f 8e 87 00 00 00    	jle    8010311d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103096:	83 ec 0c             	sub    $0xc,%esp
80103099:	68 80 26 11 80       	push   $0x80112680
8010309e:	e8 fd 14 00 00       	call   801045a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030a3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	83 fa 00             	cmp    $0x0,%edx
801030af:	7e 50                	jle    80103101 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030b1:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030b4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030b6:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
801030bc:	75 0b                	jne    801030c9 <log_write+0x69>
801030be:	eb 38                	jmp    801030f8 <log_write+0x98>
801030c0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
801030c7:	74 2f                	je     801030f8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801030c9:	83 c0 01             	add    $0x1,%eax
801030cc:	39 d0                	cmp    %edx,%eax
801030ce:	75 f0                	jne    801030c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
801030e0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801030e3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
801030ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030ed:	c9                   	leave  
  release(&log.lock);
801030ee:	e9 cd 15 00 00       	jmp    801046c0 <release>
801030f3:	90                   	nop
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
801030f8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
801030ff:	eb df                	jmp    801030e0 <log_write+0x80>
80103101:	8b 43 08             	mov    0x8(%ebx),%eax
80103104:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80103109:	75 d5                	jne    801030e0 <log_write+0x80>
8010310b:	eb ca                	jmp    801030d7 <log_write+0x77>
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 b3 79 10 80       	push   $0x801079b3
80103118:	e8 83 d3 ff ff       	call   801004a0 <panic>
    panic("log_write outside of trans");
8010311d:	83 ec 0c             	sub    $0xc,%esp
80103120:	68 c9 79 10 80       	push   $0x801079c9
80103125:	e8 76 d3 ff ff       	call   801004a0 <panic>
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103137:	e8 74 09 00 00       	call   80103ab0 <cpuid>
8010313c:	89 c3                	mov    %eax,%ebx
8010313e:	e8 6d 09 00 00       	call   80103ab0 <cpuid>
80103143:	83 ec 04             	sub    $0x4,%esp
80103146:	53                   	push   %ebx
80103147:	50                   	push   %eax
80103148:	68 e4 79 10 80       	push   $0x801079e4
8010314d:	e8 1e d6 ff ff       	call   80100770 <cprintf>
  idtinit();       // load idt register
80103152:	e8 79 28 00 00       	call   801059d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103157:	e8 d4 08 00 00       	call   80103a30 <mycpu>
8010315c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010315e:	b8 01 00 00 00       	mov    $0x1,%eax
80103163:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010316a:	e8 f1 0b 00 00       	call   80103d60 <scheduler>
8010316f:	90                   	nop

80103170 <mpenter>:
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103176:	e8 a5 3a 00 00       	call   80106c20 <switchkvm>
  seginit();
8010317b:	e8 10 3a 00 00       	call   80106b90 <seginit>
  lapicinit();
80103180:	e8 8b f7 ff ff       	call   80102910 <lapicinit>
  mpmain();
80103185:	e8 a6 ff ff ff       	call   80103130 <mpmain>
8010318a:	66 90                	xchg   %ax,%ax
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <main>:
{
80103190:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103194:	83 e4 f0             	and    $0xfffffff0,%esp
80103197:	ff 71 fc             	pushl  -0x4(%ecx)
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	53                   	push   %ebx
8010319e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010319f:	83 ec 08             	sub    $0x8,%esp
801031a2:	68 00 00 40 80       	push   $0x80400000
801031a7:	68 a8 54 11 80       	push   $0x801154a8
801031ac:	e8 1f f5 ff ff       	call   801026d0 <kinit1>
  kvmalloc();      // kernel page table
801031b1:	e8 da 40 00 00       	call   80107290 <kvmalloc>
  mpinit();        // detect other processors
801031b6:	e8 75 01 00 00       	call   80103330 <mpinit>
  lapicinit();     // interrupt controller
801031bb:	e8 50 f7 ff ff       	call   80102910 <lapicinit>
  seginit();       // segment descriptors
801031c0:	e8 cb 39 00 00       	call   80106b90 <seginit>
  picinit();       // disable pic
801031c5:	e8 46 03 00 00       	call   80103510 <picinit>
  ioapicinit();    // another interrupt controller
801031ca:	e8 01 f3 ff ff       	call   801024d0 <ioapicinit>
  consoleinit();   // console hardware
801031cf:	e8 fc d8 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
801031d4:	e8 17 2d 00 00       	call   80105ef0 <uartinit>
  pinit();         // process table
801031d9:	e8 32 08 00 00       	call   80103a10 <pinit>
  tvinit();        // trap vectors
801031de:	e8 6d 27 00 00       	call   80105950 <tvinit>
  binit();         // buffer cache
801031e3:	e8 18 cf ff ff       	call   80100100 <binit>
  fileinit();      // file table
801031e8:	e8 83 dc ff ff       	call   80100e70 <fileinit>
  ideinit();       // disk 
801031ed:	e8 be f0 ff ff       	call   801022b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031f2:	83 c4 0c             	add    $0xc,%esp
801031f5:	68 8a 00 00 00       	push   $0x8a
801031fa:	68 8c a4 10 80       	push   $0x8010a48c
801031ff:	68 00 70 00 80       	push   $0x80007000
80103204:	e8 c7 15 00 00       	call   801047d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103209:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103210:	00 00 00 
80103213:	83 c4 10             	add    $0x10,%esp
80103216:	05 80 27 11 80       	add    $0x80112780,%eax
8010321b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103220:	76 71                	jbe    80103293 <main+0x103>
80103222:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103227:	89 f6                	mov    %esi,%esi
80103229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103230:	e8 fb 07 00 00       	call   80103a30 <mycpu>
80103235:	39 d8                	cmp    %ebx,%eax
80103237:	74 41                	je     8010327a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103239:	e8 62 f5 ff ff       	call   801027a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010323e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103243:	c7 05 f8 6f 00 80 70 	movl   $0x80103170,0x80006ff8
8010324a:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010324d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103254:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103257:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010325c:	0f b6 03             	movzbl (%ebx),%eax
8010325f:	83 ec 08             	sub    $0x8,%esp
80103262:	68 00 70 00 00       	push   $0x7000
80103267:	50                   	push   %eax
80103268:	e8 f3 f7 ff ff       	call   80102a60 <lapicstartap>
8010326d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010327a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103281:	00 00 00 
80103284:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010328a:	05 80 27 11 80       	add    $0x80112780,%eax
8010328f:	39 c3                	cmp    %eax,%ebx
80103291:	72 9d                	jb     80103230 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103293:	83 ec 08             	sub    $0x8,%esp
80103296:	68 00 00 40 80       	push   $0x80400000
8010329b:	68 00 00 40 80       	push   $0x80400000
801032a0:	e8 9b f4 ff ff       	call   80102740 <kinit2>
  userinit();      // first user process
801032a5:	e8 56 08 00 00       	call   80103b00 <userinit>
  mpmain();        // finish this processor's setup
801032aa:	e8 81 fe ff ff       	call   80103130 <mpmain>
801032af:	90                   	nop

801032b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032bb:	53                   	push   %ebx
  e = addr+len;
801032bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032c2:	39 de                	cmp    %ebx,%esi
801032c4:	72 10                	jb     801032d6 <mpsearch1+0x26>
801032c6:	eb 50                	jmp    80103318 <mpsearch1+0x68>
801032c8:	90                   	nop
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d0:	39 fb                	cmp    %edi,%ebx
801032d2:	89 fe                	mov    %edi,%esi
801032d4:	76 42                	jbe    80103318 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032d6:	83 ec 04             	sub    $0x4,%esp
801032d9:	8d 7e 10             	lea    0x10(%esi),%edi
801032dc:	6a 04                	push   $0x4
801032de:	68 f8 79 10 80       	push   $0x801079f8
801032e3:	56                   	push   %esi
801032e4:	e8 87 14 00 00       	call   80104770 <memcmp>
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	85 c0                	test   %eax,%eax
801032ee:	75 e0                	jne    801032d0 <mpsearch1+0x20>
801032f0:	89 f1                	mov    %esi,%ecx
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 11             	movzbl (%ecx),%edx
801032fb:	83 c1 01             	add    $0x1,%ecx
801032fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103300:	39 f9                	cmp    %edi,%ecx
80103302:	75 f4                	jne    801032f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103304:	84 c0                	test   %al,%al
80103306:	75 c8                	jne    801032d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330b:	89 f0                	mov    %esi,%eax
8010330d:	5b                   	pop    %ebx
8010330e:	5e                   	pop    %esi
8010330f:	5f                   	pop    %edi
80103310:	5d                   	pop    %ebp
80103311:	c3                   	ret    
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010331b:	31 f6                	xor    %esi,%esi
}
8010331d:	89 f0                	mov    %esi,%eax
8010331f:	5b                   	pop    %ebx
80103320:	5e                   	pop    %esi
80103321:	5f                   	pop    %edi
80103322:	5d                   	pop    %ebp
80103323:	c3                   	ret    
80103324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010332a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103330 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	57                   	push   %edi
80103334:	56                   	push   %esi
80103335:	53                   	push   %ebx
80103336:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103339:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103340:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103347:	c1 e0 08             	shl    $0x8,%eax
8010334a:	09 d0                	or     %edx,%eax
8010334c:	c1 e0 04             	shl    $0x4,%eax
8010334f:	85 c0                	test   %eax,%eax
80103351:	75 1b                	jne    8010336e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103353:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010335a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103361:	c1 e0 08             	shl    $0x8,%eax
80103364:	09 d0                	or     %edx,%eax
80103366:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103369:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010336e:	ba 00 04 00 00       	mov    $0x400,%edx
80103373:	e8 38 ff ff ff       	call   801032b0 <mpsearch1>
80103378:	85 c0                	test   %eax,%eax
8010337a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010337d:	0f 84 3d 01 00 00    	je     801034c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103386:	8b 58 04             	mov    0x4(%eax),%ebx
80103389:	85 db                	test   %ebx,%ebx
8010338b:	0f 84 4f 01 00 00    	je     801034e0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103391:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103397:	83 ec 04             	sub    $0x4,%esp
8010339a:	6a 04                	push   $0x4
8010339c:	68 15 7a 10 80       	push   $0x80107a15
801033a1:	56                   	push   %esi
801033a2:	e8 c9 13 00 00       	call   80104770 <memcmp>
801033a7:	83 c4 10             	add    $0x10,%esp
801033aa:	85 c0                	test   %eax,%eax
801033ac:	0f 85 2e 01 00 00    	jne    801034e0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801033b2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801033b9:	3c 01                	cmp    $0x1,%al
801033bb:	0f 95 c2             	setne  %dl
801033be:	3c 04                	cmp    $0x4,%al
801033c0:	0f 95 c0             	setne  %al
801033c3:	20 c2                	and    %al,%dl
801033c5:	0f 85 15 01 00 00    	jne    801034e0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801033cb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801033d2:	66 85 ff             	test   %di,%di
801033d5:	74 1a                	je     801033f1 <mpinit+0xc1>
801033d7:	89 f0                	mov    %esi,%eax
801033d9:	01 f7                	add    %esi,%edi
  sum = 0;
801033db:	31 d2                	xor    %edx,%edx
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 08             	movzbl (%eax),%ecx
801033e3:	83 c0 01             	add    $0x1,%eax
801033e6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033e8:	39 c7                	cmp    %eax,%edi
801033ea:	75 f4                	jne    801033e0 <mpinit+0xb0>
801033ec:	84 d2                	test   %dl,%dl
801033ee:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801033f1:	85 f6                	test   %esi,%esi
801033f3:	0f 84 e7 00 00 00    	je     801034e0 <mpinit+0x1b0>
801033f9:	84 d2                	test   %dl,%dl
801033fb:	0f 85 df 00 00 00    	jne    801034e0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103401:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103407:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010340c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103413:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103419:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341e:	01 d6                	add    %edx,%esi
80103420:	39 c6                	cmp    %eax,%esi
80103422:	76 23                	jbe    80103447 <mpinit+0x117>
    switch(*p){
80103424:	0f b6 10             	movzbl (%eax),%edx
80103427:	80 fa 04             	cmp    $0x4,%dl
8010342a:	0f 87 ca 00 00 00    	ja     801034fa <mpinit+0x1ca>
80103430:	ff 24 95 3c 7a 10 80 	jmp    *-0x7fef85c4(,%edx,4)
80103437:	89 f6                	mov    %esi,%esi
80103439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103440:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103443:	39 c6                	cmp    %eax,%esi
80103445:	77 dd                	ja     80103424 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103447:	85 db                	test   %ebx,%ebx
80103449:	0f 84 9e 00 00 00    	je     801034ed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010344f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103452:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103456:	74 15                	je     8010346d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103458:	b8 70 00 00 00       	mov    $0x70,%eax
8010345d:	ba 22 00 00 00       	mov    $0x22,%edx
80103462:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103463:	ba 23 00 00 00       	mov    $0x23,%edx
80103468:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103469:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010346c:	ee                   	out    %al,(%dx)
  }
}
8010346d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103470:	5b                   	pop    %ebx
80103471:	5e                   	pop    %esi
80103472:	5f                   	pop    %edi
80103473:	5d                   	pop    %ebp
80103474:	c3                   	ret    
80103475:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103478:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010347e:	83 f9 07             	cmp    $0x7,%ecx
80103481:	7f 19                	jg     8010349c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103483:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103487:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010348d:	83 c1 01             	add    $0x1,%ecx
80103490:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103496:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010349c:	83 c0 14             	add    $0x14,%eax
      continue;
8010349f:	e9 7c ff ff ff       	jmp    80103420 <mpinit+0xf0>
801034a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801034ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034af:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801034b5:	e9 66 ff ff ff       	jmp    80103420 <mpinit+0xf0>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801034c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801034c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801034ca:	e8 e1 fd ff ff       	call   801032b0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034cf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801034d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034d4:	0f 85 a9 fe ff ff    	jne    80103383 <mpinit+0x53>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	68 fd 79 10 80       	push   $0x801079fd
801034e8:	e8 b3 cf ff ff       	call   801004a0 <panic>
    panic("Didn't find a suitable machine");
801034ed:	83 ec 0c             	sub    $0xc,%esp
801034f0:	68 1c 7a 10 80       	push   $0x80107a1c
801034f5:	e8 a6 cf ff ff       	call   801004a0 <panic>
      ismp = 0;
801034fa:	31 db                	xor    %ebx,%ebx
801034fc:	e9 26 ff ff ff       	jmp    80103427 <mpinit+0xf7>
80103501:	66 90                	xchg   %ax,%ax
80103503:	66 90                	xchg   %ax,%ax
80103505:	66 90                	xchg   %ax,%ax
80103507:	66 90                	xchg   %ax,%ax
80103509:	66 90                	xchg   %ax,%ax
8010350b:	66 90                	xchg   %ax,%ax
8010350d:	66 90                	xchg   %ax,%ax
8010350f:	90                   	nop

80103510 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103510:	55                   	push   %ebp
80103511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103516:	ba 21 00 00 00       	mov    $0x21,%edx
8010351b:	89 e5                	mov    %esp,%ebp
8010351d:	ee                   	out    %al,(%dx)
8010351e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103523:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103524:	5d                   	pop    %ebp
80103525:	c3                   	ret    
80103526:	66 90                	xchg   %ax,%ax
80103528:	66 90                	xchg   %ax,%ax
8010352a:	66 90                	xchg   %ax,%ax
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 0c             	sub    $0xc,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010353f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103545:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010354b:	e8 40 d9 ff ff       	call   80100e90 <filealloc>
80103550:	85 c0                	test   %eax,%eax
80103552:	89 06                	mov    %eax,(%esi)
80103554:	0f 84 a8 00 00 00    	je     80103602 <pipealloc+0xd2>
8010355a:	e8 31 d9 ff ff       	call   80100e90 <filealloc>
8010355f:	85 c0                	test   %eax,%eax
80103561:	89 03                	mov    %eax,(%ebx)
80103563:	0f 84 87 00 00 00    	je     801035f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103569:	e8 32 f2 ff ff       	call   801027a0 <kalloc>
8010356e:	85 c0                	test   %eax,%eax
80103570:	89 c7                	mov    %eax,%edi
80103572:	0f 84 b0 00 00 00    	je     80103628 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103578:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
8010357b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103582:	00 00 00 
  p->writeopen = 1;
80103585:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010358c:	00 00 00 
  p->nwrite = 0;
8010358f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103596:	00 00 00 
  p->nread = 0;
80103599:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035a0:	00 00 00 
  initlock(&p->lock, "pipe");
801035a3:	68 50 7a 10 80       	push   $0x80107a50
801035a8:	50                   	push   %eax
801035a9:	e8 02 0f 00 00       	call   801044b0 <initlock>
  (*f0)->type = FD_PIPE;
801035ae:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035b9:	8b 06                	mov    (%esi),%eax
801035bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035bf:	8b 06                	mov    (%esi),%eax
801035c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035c5:	8b 06                	mov    (%esi),%eax
801035c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035ca:	8b 03                	mov    (%ebx),%eax
801035cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035d2:	8b 03                	mov    (%ebx),%eax
801035d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035d8:	8b 03                	mov    (%ebx),%eax
801035da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035de:	8b 03                	mov    (%ebx),%eax
801035e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035e6:	31 c0                	xor    %eax,%eax
}
801035e8:	5b                   	pop    %ebx
801035e9:	5e                   	pop    %esi
801035ea:	5f                   	pop    %edi
801035eb:	5d                   	pop    %ebp
801035ec:	c3                   	ret    
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801035f0:	8b 06                	mov    (%esi),%eax
801035f2:	85 c0                	test   %eax,%eax
801035f4:	74 1e                	je     80103614 <pipealloc+0xe4>
    fileclose(*f0);
801035f6:	83 ec 0c             	sub    $0xc,%esp
801035f9:	50                   	push   %eax
801035fa:	e8 51 d9 ff ff       	call   80100f50 <fileclose>
801035ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103602:	8b 03                	mov    (%ebx),%eax
80103604:	85 c0                	test   %eax,%eax
80103606:	74 0c                	je     80103614 <pipealloc+0xe4>
    fileclose(*f1);
80103608:	83 ec 0c             	sub    $0xc,%esp
8010360b:	50                   	push   %eax
8010360c:	e8 3f d9 ff ff       	call   80100f50 <fileclose>
80103611:	83 c4 10             	add    $0x10,%esp
}
80103614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103628:	8b 06                	mov    (%esi),%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	75 c8                	jne    801035f6 <pipealloc+0xc6>
8010362e:	eb d2                	jmp    80103602 <pipealloc+0xd2>

80103630 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103638:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	53                   	push   %ebx
8010363f:	e8 5c 0f 00 00       	call   801045a0 <acquire>
  if(writable){
80103644:	83 c4 10             	add    $0x10,%esp
80103647:	85 f6                	test   %esi,%esi
80103649:	74 45                	je     80103690 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010364b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103651:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103654:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010365b:	00 00 00 
    wakeup(&p->nread);
8010365e:	50                   	push   %eax
8010365f:	e8 9c 0b 00 00       	call   80104200 <wakeup>
80103664:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103667:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010366d:	85 d2                	test   %edx,%edx
8010366f:	75 0a                	jne    8010367b <pipeclose+0x4b>
80103671:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103677:	85 c0                	test   %eax,%eax
80103679:	74 35                	je     801036b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010367b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010367e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103681:	5b                   	pop    %ebx
80103682:	5e                   	pop    %esi
80103683:	5d                   	pop    %ebp
    release(&p->lock);
80103684:	e9 37 10 00 00       	jmp    801046c0 <release>
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103690:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103696:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103699:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036a0:	00 00 00 
    wakeup(&p->nwrite);
801036a3:	50                   	push   %eax
801036a4:	e8 57 0b 00 00       	call   80104200 <wakeup>
801036a9:	83 c4 10             	add    $0x10,%esp
801036ac:	eb b9                	jmp    80103667 <pipeclose+0x37>
801036ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 07 10 00 00       	call   801046c0 <release>
    kfree((char*)p);
801036b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036bc:	83 c4 10             	add    $0x10,%esp
}
801036bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036c2:	5b                   	pop    %ebx
801036c3:	5e                   	pop    %esi
801036c4:	5d                   	pop    %ebp
    kfree((char*)p);
801036c5:	e9 f6 ee ff ff       	jmp    801025c0 <kfree>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 28             	sub    $0x28,%esp
801036d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036dc:	53                   	push   %ebx
801036dd:	e8 be 0e 00 00       	call   801045a0 <acquire>
  for(i = 0; i < n; i++){
801036e2:	8b 45 10             	mov    0x10(%ebp),%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	85 c0                	test   %eax,%eax
801036ea:	0f 8e b9 00 00 00    	jle    801037a9 <pipewrite+0xd9>
801036f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036f3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036ff:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103705:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103708:	03 4d 10             	add    0x10(%ebp),%ecx
8010370b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010370e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103714:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010371a:	39 d0                	cmp    %edx,%eax
8010371c:	74 38                	je     80103756 <pipewrite+0x86>
8010371e:	eb 59                	jmp    80103779 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103720:	e8 ab 03 00 00       	call   80103ad0 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	75 34                	jne    80103760 <pipewrite+0x90>
      wakeup(&p->nread);
8010372c:	83 ec 0c             	sub    $0xc,%esp
8010372f:	57                   	push   %edi
80103730:	e8 cb 0a 00 00       	call   80104200 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103735:	58                   	pop    %eax
80103736:	5a                   	pop    %edx
80103737:	53                   	push   %ebx
80103738:	56                   	push   %esi
80103739:	e8 02 09 00 00       	call   80104040 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010373e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103744:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010374a:	83 c4 10             	add    $0x10,%esp
8010374d:	05 00 02 00 00       	add    $0x200,%eax
80103752:	39 c2                	cmp    %eax,%edx
80103754:	75 2a                	jne    80103780 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103756:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010375c:	85 c0                	test   %eax,%eax
8010375e:	75 c0                	jne    80103720 <pipewrite+0x50>
        release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 57 0f 00 00       	call   801046c0 <release>
        return -1;
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103771:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103774:	5b                   	pop    %ebx
80103775:	5e                   	pop    %esi
80103776:	5f                   	pop    %edi
80103777:	5d                   	pop    %ebp
80103778:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103779:	89 c2                	mov    %eax,%edx
8010377b:	90                   	nop
8010377c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103780:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103783:	8d 42 01             	lea    0x1(%edx),%eax
80103786:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010378a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103790:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103796:	0f b6 09             	movzbl (%ecx),%ecx
80103799:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010379d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  for(i = 0; i < n; i++){
801037a0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801037a3:	0f 85 65 ff ff ff    	jne    8010370e <pipewrite+0x3e>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037a9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037af:	83 ec 0c             	sub    $0xc,%esp
801037b2:	50                   	push   %eax
801037b3:	e8 48 0a 00 00       	call   80104200 <wakeup>
  release(&p->lock);
801037b8:	89 1c 24             	mov    %ebx,(%esp)
801037bb:	e8 00 0f 00 00       	call   801046c0 <release>
  return n;
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	8b 45 10             	mov    0x10(%ebp),%eax
801037c6:	eb a9                	jmp    80103771 <pipewrite+0xa1>
801037c8:	90                   	nop
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 18             	sub    $0x18,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037df:	53                   	push   %ebx
801037e0:	e8 bb 0d 00 00       	call   801045a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037ee:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801037f4:	75 6a                	jne    80103860 <piperead+0x90>
801037f6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801037fc:	85 f6                	test   %esi,%esi
801037fe:	0f 84 cc 00 00 00    	je     801038d0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103804:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010380a:	eb 2d                	jmp    80103839 <piperead+0x69>
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103810:	83 ec 08             	sub    $0x8,%esp
80103813:	53                   	push   %ebx
80103814:	56                   	push   %esi
80103815:	e8 26 08 00 00       	call   80104040 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010381a:	83 c4 10             	add    $0x10,%esp
8010381d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103823:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103829:	75 35                	jne    80103860 <piperead+0x90>
8010382b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103831:	85 d2                	test   %edx,%edx
80103833:	0f 84 97 00 00 00    	je     801038d0 <piperead+0x100>
    if(myproc()->killed){
80103839:	e8 92 02 00 00       	call   80103ad0 <myproc>
8010383e:	8b 48 24             	mov    0x24(%eax),%ecx
80103841:	85 c9                	test   %ecx,%ecx
80103843:	74 cb                	je     80103810 <piperead+0x40>
      release(&p->lock);
80103845:	83 ec 0c             	sub    $0xc,%esp
80103848:	53                   	push   %ebx
80103849:	e8 72 0e 00 00       	call   801046c0 <release>
      return -1;
8010384e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80103854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103859:	5b                   	pop    %ebx
8010385a:	5e                   	pop    %esi
8010385b:	5f                   	pop    %edi
8010385c:	5d                   	pop    %ebp
8010385d:	c3                   	ret    
8010385e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103860:	8b 45 10             	mov    0x10(%ebp),%eax
80103863:	85 c0                	test   %eax,%eax
80103865:	7e 69                	jle    801038d0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103867:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010386d:	31 c9                	xor    %ecx,%ecx
8010386f:	eb 15                	jmp    80103886 <piperead+0xb6>
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103878:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010387e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103884:	74 5a                	je     801038e0 <piperead+0x110>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103886:	8d 70 01             	lea    0x1(%eax),%esi
80103889:	25 ff 01 00 00       	and    $0x1ff,%eax
8010388e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103894:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103899:	88 04 0f             	mov    %al,(%edi,%ecx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010389c:	83 c1 01             	add    $0x1,%ecx
8010389f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801038a2:	75 d4                	jne    80103878 <piperead+0xa8>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038a4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	50                   	push   %eax
801038ae:	e8 4d 09 00 00       	call   80104200 <wakeup>
  release(&p->lock);
801038b3:	89 1c 24             	mov    %ebx,(%esp)
801038b6:	e8 05 0e 00 00       	call   801046c0 <release>
  return i;
801038bb:	8b 45 10             	mov    0x10(%ebp),%eax
801038be:	83 c4 10             	add    $0x10,%esp
}
801038c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c4:	5b                   	pop    %ebx
801038c5:	5e                   	pop    %esi
801038c6:	5f                   	pop    %edi
801038c7:	5d                   	pop    %ebp
801038c8:	c3                   	ret    
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038d0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801038d7:	eb cb                	jmp    801038a4 <piperead+0xd4>
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801038e3:	eb bf                	jmp    801038a4 <piperead+0xd4>
801038e5:	66 90                	xchg   %ax,%ax
801038e7:	66 90                	xchg   %ax,%ax
801038e9:	66 90                	xchg   %ax,%ax
801038eb:	66 90                	xchg   %ax,%ax
801038ed:	66 90                	xchg   %ax,%ax
801038ef:	90                   	nop

801038f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038f4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801038f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038fc:	68 20 2d 11 80       	push   $0x80112d20
80103901:	e8 9a 0c 00 00       	call   801045a0 <acquire>
80103906:	83 c4 10             	add    $0x10,%esp
80103909:	eb 10                	jmp    8010391b <allocproc+0x2b>
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103910:	83 c3 7c             	add    $0x7c,%ebx
80103913:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103919:	73 75                	jae    80103990 <allocproc+0xa0>
    if(p->state == UNUSED)
8010391b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010391e:	85 c0                	test   %eax,%eax
80103920:	75 ee                	jne    80103910 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103922:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103927:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010392a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103931:	8d 50 01             	lea    0x1(%eax),%edx
80103934:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103937:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010393c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103942:	e8 79 0d 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103947:	e8 54 ee ff ff       	call   801027a0 <kalloc>
8010394c:	83 c4 10             	add    $0x10,%esp
8010394f:	85 c0                	test   %eax,%eax
80103951:	89 43 08             	mov    %eax,0x8(%ebx)
80103954:	74 53                	je     801039a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103956:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010395c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010395f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103964:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103967:	c7 40 14 42 59 10 80 	movl   $0x80105942,0x14(%eax)
  p->context = (struct context*)sp;
8010396e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103971:	6a 14                	push   $0x14
80103973:	6a 00                	push   $0x0
80103975:	50                   	push   %eax
80103976:	e8 a5 0d 00 00       	call   80104720 <memset>
  p->context->eip = (uint)forkret;
8010397b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010397e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103981:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
80103988:	89 d8                	mov    %ebx,%eax
8010398a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398d:	c9                   	leave  
8010398e:	c3                   	ret    
8010398f:	90                   	nop
  release(&ptable.lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103993:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103995:	68 20 2d 11 80       	push   $0x80112d20
8010399a:	e8 21 0d 00 00       	call   801046c0 <release>
}
8010399f:	89 d8                	mov    %ebx,%eax
  return 0;
801039a1:	83 c4 10             	add    $0x10,%esp
}
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave  
801039a8:	c3                   	ret    
    p->state = UNUSED;
801039a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039b0:	31 db                	xor    %ebx,%ebx
801039b2:	eb d4                	jmp    80103988 <allocproc+0x98>
801039b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039c6:	68 20 2d 11 80       	push   $0x80112d20
801039cb:	e8 f0 0c 00 00       	call   801046c0 <release>

  if (first) {
801039d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    
801039de:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801039e0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801039e3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039ea:	00 00 00 
    iinit(ROOTDEV);
801039ed:	6a 01                	push   $0x1
801039ef:	e8 4c dd ff ff       	call   80101740 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 e0 f3 ff ff       	call   80102de0 <initlog>
80103a00:	83 c4 10             	add    $0x10,%esp
}
80103a03:	c9                   	leave  
80103a04:	c3                   	ret    
80103a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 55 7a 10 80       	push   $0x80107a55
80103a1b:	68 20 2d 11 80       	push   $0x80112d20
80103a20:	e8 8b 0a 00 00       	call   801044b0 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave  
80103a29:	c3                   	ret    
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf  
80103a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 5e                	jne    80103a9a <mycpu+0x6a>
  apicid = lapicid();
80103a3c:	e8 cf ef ff ff       	call   80102a10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a41:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 42                	jle    80103a8d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a4b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103a52:	39 d0                	cmp    %edx,%eax
80103a54:	74 30                	je     80103a86 <mycpu+0x56>
80103a56:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a5b:	31 d2                	xor    %edx,%edx
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi
80103a60:	83 c2 01             	add    $0x1,%edx
80103a63:	39 f2                	cmp    %esi,%edx
80103a65:	74 26                	je     80103a8d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a67:	0f b6 19             	movzbl (%ecx),%ebx
80103a6a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a70:	39 c3                	cmp    %eax,%ebx
80103a72:	75 ec                	jne    80103a60 <mycpu+0x30>
80103a74:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a7a:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a82:	5b                   	pop    %ebx
80103a83:	5e                   	pop    %esi
80103a84:	5d                   	pop    %ebp
80103a85:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a86:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
80103a8b:	eb f2                	jmp    80103a7f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a8d:	83 ec 0c             	sub    $0xc,%esp
80103a90:	68 5c 7a 10 80       	push   $0x80107a5c
80103a95:	e8 06 ca ff ff       	call   801004a0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	68 38 7b 10 80       	push   $0x80107b38
80103aa2:	e8 f9 c9 ff ff       	call   801004a0 <panic>
80103aa7:	89 f6                	mov    %esi,%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <cpuid>:
cpuid() {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ab6:	e8 75 ff ff ff       	call   80103a30 <mycpu>
80103abb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103ac0:	c9                   	leave  
  return mycpu()-cpus;
80103ac1:	c1 f8 04             	sar    $0x4,%eax
80103ac4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aca:	c3                   	ret    
80103acb:	90                   	nop
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <myproc>:
myproc(void) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ad7:	e8 84 0a 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103adc:	e8 4f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ae1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae7:	e8 74 0b 00 00       	call   80104660 <popcli>
}
80103aec:	83 c4 04             	add    $0x4,%esp
80103aef:	89 d8                	mov    %ebx,%eax
80103af1:	5b                   	pop    %ebx
80103af2:	5d                   	pop    %ebp
80103af3:	c3                   	ret    
80103af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b00 <userinit>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b07:	e8 e4 fd ff ff       	call   801038f0 <allocproc>
80103b0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b0e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103b13:	e8 f8 36 00 00       	call   80107210 <setupkvm>
80103b18:	85 c0                	test   %eax,%eax
80103b1a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b1d:	0f 84 bd 00 00 00    	je     80103be0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b23:	83 ec 04             	sub    $0x4,%esp
80103b26:	68 2c 00 00 00       	push   $0x2c
80103b2b:	68 60 a4 10 80       	push   $0x8010a460
80103b30:	50                   	push   %eax
80103b31:	e8 1a 32 00 00       	call   80106d50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b3f:	6a 4c                	push   $0x4c
80103b41:	6a 00                	push   $0x0
80103b43:	ff 73 18             	pushl  0x18(%ebx)
80103b46:	e8 d5 0b 00 00       	call   80104720 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b53:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b58:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b71:	8b 43 18             	mov    0x18(%ebx),%eax
80103b74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b86:	8b 43 18             	mov    0x18(%ebx),%eax
80103b89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b90:	8b 43 18             	mov    0x18(%ebx),%eax
80103b93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	68 85 7a 10 80       	push   $0x80107a85
80103ba4:	50                   	push   %eax
80103ba5:	e8 56 0d 00 00       	call   80104900 <safestrcpy>
  p->cwd = namei("/");
80103baa:	c7 04 24 8e 7a 10 80 	movl   $0x80107a8e,(%esp)
80103bb1:	e8 ea e5 ff ff       	call   801021a0 <namei>
80103bb6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bb9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc0:	e8 db 09 00 00       	call   801045a0 <acquire>
  p->state = RUNNABLE;
80103bc5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bcc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bd3:	e8 e8 0a 00 00       	call   801046c0 <release>
}
80103bd8:	83 c4 10             	add    $0x10,%esp
80103bdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bde:	c9                   	leave  
80103bdf:	c3                   	ret    
    panic("userinit: out of memory?");
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 6c 7a 10 80       	push   $0x80107a6c
80103be8:	e8 b3 c8 ff ff       	call   801004a0 <panic>
80103bed:	8d 76 00             	lea    0x0(%esi),%esi

80103bf0 <growproc>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
80103bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103bf8:	e8 63 09 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103bfd:	e8 2e fe ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c02:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c08:	e8 53 0a 00 00       	call   80104660 <popcli>
  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103c0d:	85 db                	test   %ebx,%ebx
80103c0f:	78 1f                	js     80103c30 <growproc+0x40>
80103c11:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103c17:	77 17                	ja     80103c30 <growproc+0x40>
80103c19:	03 1e                	add    (%esi),%ebx
80103c1b:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103c21:	77 0d                	ja     80103c30 <growproc+0x40>
  curproc->sz += n;
80103c23:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103c25:	31 c0                	xor    %eax,%eax
}
80103c27:	5b                   	pop    %ebx
80103c28:	5e                   	pop    %esi
80103c29:	5d                   	pop    %ebp
80103c2a:	c3                   	ret    
80103c2b:	90                   	nop
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  return -1;
80103c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c35:	eb f0                	jmp    80103c27 <growproc+0x37>
80103c37:	89 f6                	mov    %esi,%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <fork>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c49:	e8 12 09 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103c4e:	e8 dd fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c59:	e8 02 0a 00 00       	call   80104660 <popcli>
  if((np = allocproc()) == 0){
80103c5e:	e8 8d fc ff ff       	call   801038f0 <allocproc>
80103c63:	85 c0                	test   %eax,%eax
80103c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c68:	0f 84 b7 00 00 00    	je     80103d25 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c6e:	83 ec 08             	sub    $0x8,%esp
80103c71:	ff 33                	pushl  (%ebx)
80103c73:	ff 73 04             	pushl  0x4(%ebx)
80103c76:	89 c7                	mov    %eax,%edi
80103c78:	e8 63 36 00 00       	call   801072e0 <copyuvm>
80103c7d:	83 c4 10             	add    $0x10,%esp
80103c80:	85 c0                	test   %eax,%eax
80103c82:	89 47 04             	mov    %eax,0x4(%edi)
80103c85:	0f 84 a1 00 00 00    	je     80103d2c <fork+0xec>
  np->sz = curproc->sz;
80103c8b:	8b 03                	mov    (%ebx),%eax
80103c8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c90:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c92:	89 59 14             	mov    %ebx,0x14(%ecx)
80103c95:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c97:	8b 79 18             	mov    0x18(%ecx),%edi
80103c9a:	8b 73 18             	mov    0x18(%ebx),%esi
80103c9d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ca2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ca4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ca6:	8b 40 18             	mov    0x18(%eax),%eax
80103ca9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cb0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	74 13                	je     80103ccb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	50                   	push   %eax
80103cbc:	e8 3f d2 ff ff       	call   80100f00 <filedup>
80103cc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cc4:	83 c4 10             	add    $0x10,%esp
80103cc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ccb:	83 c6 01             	add    $0x1,%esi
80103cce:	83 fe 10             	cmp    $0x10,%esi
80103cd1:	75 dd                	jne    80103cb0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cd3:	83 ec 0c             	sub    $0xc,%esp
80103cd6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cdc:	e8 2f dc ff ff       	call   80101910 <idup>
80103ce1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ce7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cea:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ced:	6a 10                	push   $0x10
80103cef:	53                   	push   %ebx
80103cf0:	50                   	push   %eax
80103cf1:	e8 0a 0c 00 00       	call   80104900 <safestrcpy>
  pid = np->pid;
80103cf6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cf9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d00:	e8 9b 08 00 00       	call   801045a0 <acquire>
  np->state = RUNNABLE;
80103d05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d13:	e8 a8 09 00 00       	call   801046c0 <release>
  return pid;
80103d18:	83 c4 10             	add    $0x10,%esp
}
80103d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d1e:	89 d8                	mov    %ebx,%eax
80103d20:	5b                   	pop    %ebx
80103d21:	5e                   	pop    %esi
80103d22:	5f                   	pop    %edi
80103d23:	5d                   	pop    %ebp
80103d24:	c3                   	ret    
    return -1;
80103d25:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d2a:	eb ef                	jmp    80103d1b <fork+0xdb>
    kfree(np->kstack);
80103d2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	ff 73 08             	pushl  0x8(%ebx)
80103d35:	e8 86 e8 ff ff       	call   801025c0 <kfree>
    np->kstack = 0;
80103d3a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d41:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d50:	eb c9                	jmp    80103d1b <fork+0xdb>
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <scheduler>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d69:	e8 c2 fc ff ff       	call   80103a30 <mycpu>
80103d6e:	8d 78 04             	lea    0x4(%eax),%edi
80103d71:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d73:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d7a:	00 00 00 
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d80:	fb                   	sti    
    acquire(&ptable.lock);
80103d81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d84:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103d89:	68 20 2d 11 80       	push   $0x80112d20
80103d8e:	e8 0d 08 00 00       	call   801045a0 <acquire>
80103d93:	83 c4 10             	add    $0x10,%esp
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103da0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103da4:	75 33                	jne    80103dd9 <scheduler+0x79>
      switchuvm(p);
80103da6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103da9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103daf:	53                   	push   %ebx
80103db0:	e8 8b 2e 00 00       	call   80106c40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103db5:	58                   	pop    %eax
80103db6:	5a                   	pop    %edx
80103db7:	ff 73 1c             	pushl  0x1c(%ebx)
80103dba:	57                   	push   %edi
      p->state = RUNNING;
80103dbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103dc2:	e8 94 0b 00 00       	call   8010495b <swtch>
      switchkvm();
80103dc7:	e8 54 2e 00 00       	call   80106c20 <switchkvm>
      c->proc = 0;
80103dcc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dd3:	00 00 00 
80103dd6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd9:	83 c3 7c             	add    $0x7c,%ebx
80103ddc:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103de2:	72 bc                	jb     80103da0 <scheduler+0x40>
    release(&ptable.lock);
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 20 2d 11 80       	push   $0x80112d20
80103dec:	e8 cf 08 00 00       	call   801046c0 <release>
    sti();
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	eb 8a                	jmp    80103d80 <scheduler+0x20>
80103df6:	8d 76 00             	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <sched>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	56                   	push   %esi
80103e04:	53                   	push   %ebx
  pushcli();
80103e05:	e8 56 07 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103e0a:	e8 21 fc ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103e0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e15:	e8 46 08 00 00       	call   80104660 <popcli>
  if(!holding(&ptable.lock))
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 20 2d 11 80       	push   $0x80112d20
80103e22:	e8 f9 06 00 00       	call   80104520 <holding>
80103e27:	83 c4 10             	add    $0x10,%esp
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 4f                	je     80103e7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e2e:	e8 fd fb ff ff       	call   80103a30 <mycpu>
80103e33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e3a:	75 68                	jne    80103ea4 <sched+0xa4>
  if(p->state == RUNNING)
80103e3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e40:	74 55                	je     80103e97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e42:	9c                   	pushf  
80103e43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e44:	f6 c4 02             	test   $0x2,%ah
80103e47:	75 41                	jne    80103e8a <sched+0x8a>
  intena = mycpu()->intena;
80103e49:	e8 e2 fb ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e57:	e8 d4 fb ff ff       	call   80103a30 <mycpu>
80103e5c:	83 ec 08             	sub    $0x8,%esp
80103e5f:	ff 70 04             	pushl  0x4(%eax)
80103e62:	53                   	push   %ebx
80103e63:	e8 f3 0a 00 00       	call   8010495b <swtch>
  mycpu()->intena = intena;
80103e68:	e8 c3 fb ff ff       	call   80103a30 <mycpu>
}
80103e6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e79:	5b                   	pop    %ebx
80103e7a:	5e                   	pop    %esi
80103e7b:	5d                   	pop    %ebp
80103e7c:	c3                   	ret    
    panic("sched ptable.lock");
80103e7d:	83 ec 0c             	sub    $0xc,%esp
80103e80:	68 90 7a 10 80       	push   $0x80107a90
80103e85:	e8 16 c6 ff ff       	call   801004a0 <panic>
    panic("sched interruptible");
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 bc 7a 10 80       	push   $0x80107abc
80103e92:	e8 09 c6 ff ff       	call   801004a0 <panic>
    panic("sched running");
80103e97:	83 ec 0c             	sub    $0xc,%esp
80103e9a:	68 ae 7a 10 80       	push   $0x80107aae
80103e9f:	e8 fc c5 ff ff       	call   801004a0 <panic>
    panic("sched locks");
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 a2 7a 10 80       	push   $0x80107aa2
80103eac:	e8 ef c5 ff ff       	call   801004a0 <panic>
80103eb1:	eb 0d                	jmp    80103ec0 <exit>
80103eb3:	90                   	nop
80103eb4:	90                   	nop
80103eb5:	90                   	nop
80103eb6:	90                   	nop
80103eb7:	90                   	nop
80103eb8:	90                   	nop
80103eb9:	90                   	nop
80103eba:	90                   	nop
80103ebb:	90                   	nop
80103ebc:	90                   	nop
80103ebd:	90                   	nop
80103ebe:	90                   	nop
80103ebf:	90                   	nop

80103ec0 <exit>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ec9:	e8 92 06 00 00       	call   80104560 <pushcli>
  c = mycpu();
80103ece:	e8 5d fb ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ed3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed9:	e8 82 07 00 00       	call   80104660 <popcli>
  if(curproc == initproc)
80103ede:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ee4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ee7:	8d 7e 68             	lea    0x68(%esi),%edi
80103eea:	0f 84 e7 00 00 00    	je     80103fd7 <exit+0x117>
    if(curproc->ofile[fd]){
80103ef0:	8b 03                	mov    (%ebx),%eax
80103ef2:	85 c0                	test   %eax,%eax
80103ef4:	74 12                	je     80103f08 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	50                   	push   %eax
80103efa:	e8 51 d0 ff ff       	call   80100f50 <fileclose>
      curproc->ofile[fd] = 0;
80103eff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f0b:	39 fb                	cmp    %edi,%ebx
80103f0d:	75 e1                	jne    80103ef0 <exit+0x30>
  begin_op();
80103f0f:	e8 6c ef ff ff       	call   80102e80 <begin_op>
  iput(curproc->cwd);
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	ff 76 68             	pushl  0x68(%esi)
80103f1a:	e8 51 db ff ff       	call   80101a70 <iput>
  end_op();
80103f1f:	e8 cc ef ff ff       	call   80102ef0 <end_op>
  curproc->cwd = 0;
80103f24:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f2b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f32:	e8 69 06 00 00       	call   801045a0 <acquire>
  wakeup1(curproc->parent);
80103f37:	8b 56 14             	mov    0x14(%esi),%edx
80103f3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f3d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f42:	eb 0e                	jmp    80103f52 <exit+0x92>
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f48:	83 c0 7c             	add    $0x7c,%eax
80103f4b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f50:	73 1c                	jae    80103f6e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103f52:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f56:	75 f0                	jne    80103f48 <exit+0x88>
80103f58:	3b 50 20             	cmp    0x20(%eax),%edx
80103f5b:	75 eb                	jne    80103f48 <exit+0x88>
      p->state = RUNNABLE;
80103f5d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f64:	83 c0 7c             	add    $0x7c,%eax
80103f67:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f6c:	72 e4                	jb     80103f52 <exit+0x92>
      p->parent = initproc;
80103f6e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103f79:	eb 10                	jmp    80103f8b <exit+0xcb>
80103f7b:	90                   	nop
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f80:	83 c2 7c             	add    $0x7c,%edx
80103f83:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103f89:	73 33                	jae    80103fbe <exit+0xfe>
    if(p->parent == curproc){
80103f8b:	39 72 14             	cmp    %esi,0x14(%edx)
80103f8e:	75 f0                	jne    80103f80 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f90:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f94:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f97:	75 e7                	jne    80103f80 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f99:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f9e:	eb 0a                	jmp    80103faa <exit+0xea>
80103fa0:	83 c0 7c             	add    $0x7c,%eax
80103fa3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fa8:	73 d6                	jae    80103f80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103faa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fae:	75 f0                	jne    80103fa0 <exit+0xe0>
80103fb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fb3:	75 eb                	jne    80103fa0 <exit+0xe0>
      p->state = RUNNABLE;
80103fb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fbc:	eb e2                	jmp    80103fa0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fbe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fc5:	e8 36 fe ff ff       	call   80103e00 <sched>
  panic("zombie exit");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 dd 7a 10 80       	push   $0x80107add
80103fd2:	e8 c9 c4 ff ff       	call   801004a0 <panic>
    panic("init exiting");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 d0 7a 10 80       	push   $0x80107ad0
80103fdf:	e8 bc c4 ff ff       	call   801004a0 <panic>
80103fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ff0 <yield>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ff7:	68 20 2d 11 80       	push   $0x80112d20
80103ffc:	e8 9f 05 00 00       	call   801045a0 <acquire>
  pushcli();
80104001:	e8 5a 05 00 00       	call   80104560 <pushcli>
  c = mycpu();
80104006:	e8 25 fa ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010400b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104011:	e8 4a 06 00 00       	call   80104660 <popcli>
  myproc()->state = RUNNABLE;
80104016:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010401d:	e8 de fd ff ff       	call   80103e00 <sched>
  release(&ptable.lock);
80104022:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104029:	e8 92 06 00 00       	call   801046c0 <release>
}
8010402e:	83 c4 10             	add    $0x10,%esp
80104031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104034:	c9                   	leave  
80104035:	c3                   	ret    
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <sleep>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	8b 7d 08             	mov    0x8(%ebp),%edi
8010404c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010404f:	e8 0c 05 00 00       	call   80104560 <pushcli>
  c = mycpu();
80104054:	e8 d7 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104059:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010405f:	e8 fc 05 00 00       	call   80104660 <popcli>
  if(p == 0)
80104064:	85 db                	test   %ebx,%ebx
80104066:	0f 84 87 00 00 00    	je     801040f3 <sleep+0xb3>
  if(lk == 0)
8010406c:	85 f6                	test   %esi,%esi
8010406e:	74 76                	je     801040e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104070:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104076:	74 50                	je     801040c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 20 2d 11 80       	push   $0x80112d20
80104080:	e8 1b 05 00 00       	call   801045a0 <acquire>
    release(lk);
80104085:	89 34 24             	mov    %esi,(%esp)
80104088:	e8 33 06 00 00       	call   801046c0 <release>
  p->chan = chan;
8010408d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104090:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104097:	e8 64 fd ff ff       	call   80103e00 <sched>
  p->chan = 0;
8010409c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040a3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040aa:	e8 11 06 00 00       	call   801046c0 <release>
    acquire(lk);
801040af:	89 75 08             	mov    %esi,0x8(%ebp)
801040b2:	83 c4 10             	add    $0x10,%esp
}
801040b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b8:	5b                   	pop    %ebx
801040b9:	5e                   	pop    %esi
801040ba:	5f                   	pop    %edi
801040bb:	5d                   	pop    %ebp
    acquire(lk);
801040bc:	e9 df 04 00 00       	jmp    801045a0 <acquire>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 29 fd ff ff       	call   80103e00 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
    panic("sleep without lk");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 ef 7a 10 80       	push   $0x80107aef
801040ee:	e8 ad c3 ff ff       	call   801004a0 <panic>
    panic("sleep");
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	68 e9 7a 10 80       	push   $0x80107ae9
801040fb:	e8 a0 c3 ff ff       	call   801004a0 <panic>

80104100 <wait>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104109:	e8 52 04 00 00       	call   80104560 <pushcli>
  c = mycpu();
8010410e:	e8 1d f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104113:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104119:	e8 42 05 00 00       	call   80104660 <popcli>
  acquire(&ptable.lock);
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	68 20 2d 11 80       	push   $0x80112d20
80104126:	e8 75 04 00 00       	call   801045a0 <acquire>
8010412b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010412e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104130:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104135:	eb 14                	jmp    8010414b <wait+0x4b>
80104137:	89 f6                	mov    %esi,%esi
80104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104140:	83 c3 7c             	add    $0x7c,%ebx
80104143:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104149:	73 1b                	jae    80104166 <wait+0x66>
      if(p->parent != curproc)
8010414b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010414e:	75 f0                	jne    80104140 <wait+0x40>
      if(p->state == ZOMBIE){
80104150:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104154:	74 32                	je     80104188 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104156:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104159:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104164:	72 e5                	jb     8010414b <wait+0x4b>
    if(!havekids || curproc->killed){
80104166:	85 c0                	test   %eax,%eax
80104168:	74 7e                	je     801041e8 <wait+0xe8>
8010416a:	8b 46 24             	mov    0x24(%esi),%eax
8010416d:	85 c0                	test   %eax,%eax
8010416f:	75 77                	jne    801041e8 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104171:	83 ec 08             	sub    $0x8,%esp
80104174:	68 20 2d 11 80       	push   $0x80112d20
80104179:	56                   	push   %esi
8010417a:	e8 c1 fe ff ff       	call   80104040 <sleep>
    havekids = 0;
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	eb aa                	jmp    8010412e <wait+0x2e>
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010418e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104191:	e8 2a e4 ff ff       	call   801025c0 <kfree>
        pgdir = p->pgdir;
80104196:	8b 7b 04             	mov    0x4(%ebx),%edi
        release(&ptable.lock);
80104199:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->kstack = 0;
801041a0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pgdir = 0;
801041a7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
801041ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041bc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041c0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041ce:	e8 ed 04 00 00       	call   801046c0 <release>
        freevm(pgdir);
801041d3:	89 3c 24             	mov    %edi,(%esp)
801041d6:	e8 b5 2f 00 00       	call   80107190 <freevm>
        return pid;
801041db:	83 c4 10             	add    $0x10,%esp
}
801041de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041e1:	89 f0                	mov    %esi,%eax
801041e3:	5b                   	pop    %ebx
801041e4:	5e                   	pop    %esi
801041e5:	5f                   	pop    %edi
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
      release(&ptable.lock);
801041e8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041f0:	68 20 2d 11 80       	push   $0x80112d20
801041f5:	e8 c6 04 00 00       	call   801046c0 <release>
      return -1;
801041fa:	83 c4 10             	add    $0x10,%esp
801041fd:	eb df                	jmp    801041de <wait+0xde>
801041ff:	90                   	nop

80104200 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
80104207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010420a:	68 20 2d 11 80       	push   $0x80112d20
8010420f:	e8 8c 03 00 00       	call   801045a0 <acquire>
80104214:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104217:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010421c:	eb 0c                	jmp    8010422a <wakeup+0x2a>
8010421e:	66 90                	xchg   %ax,%ax
80104220:	83 c0 7c             	add    $0x7c,%eax
80104223:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104228:	73 1c                	jae    80104246 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010422a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010422e:	75 f0                	jne    80104220 <wakeup+0x20>
80104230:	3b 58 20             	cmp    0x20(%eax),%ebx
80104233:	75 eb                	jne    80104220 <wakeup+0x20>
      p->state = RUNNABLE;
80104235:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010423c:	83 c0 7c             	add    $0x7c,%eax
8010423f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104244:	72 e4                	jb     8010422a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104246:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010424d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104250:	c9                   	leave  
  release(&ptable.lock);
80104251:	e9 6a 04 00 00       	jmp    801046c0 <release>
80104256:	8d 76 00             	lea    0x0(%esi),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010426a:	68 20 2d 11 80       	push   $0x80112d20
8010426f:	e8 2c 03 00 00       	call   801045a0 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104277:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010427c:	eb 0c                	jmp    8010428a <kill+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 c0 7c             	add    $0x7c,%eax
80104283:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104288:	73 36                	jae    801042c0 <kill+0x60>
    if(p->pid == pid){
8010428a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010428d:	75 f1                	jne    80104280 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010428f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104293:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010429a:	75 07                	jne    801042a3 <kill+0x43>
        p->state = RUNNABLE;
8010429c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	68 20 2d 11 80       	push   $0x80112d20
801042ab:	e8 10 04 00 00       	call   801046c0 <release>
      return 0;
801042b0:	83 c4 10             	add    $0x10,%esp
801042b3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801042b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b8:	c9                   	leave  
801042b9:	c3                   	ret    
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	68 20 2d 11 80       	push   $0x80112d20
801042c8:	e8 f3 03 00 00       	call   801046c0 <release>
  return -1;
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d8:	c9                   	leave  
801042d9:	c3                   	ret    
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801042ee:	83 ec 3c             	sub    $0x3c,%esp
801042f1:	eb 24                	jmp    80104317 <procdump+0x37>
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 c4 7e 10 80       	push   $0x80107ec4
80104300:	e8 6b c4 ff ff       	call   80100770 <cprintf>
80104305:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104308:	83 c3 7c             	add    $0x7c,%ebx
8010430b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104311:	0f 83 81 00 00 00    	jae    80104398 <procdump+0xb8>
    if(p->state == UNUSED)
80104317:	8b 43 0c             	mov    0xc(%ebx),%eax
8010431a:	85 c0                	test   %eax,%eax
8010431c:	74 ea                	je     80104308 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010431e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104321:	ba 00 7b 10 80       	mov    $0x80107b00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104326:	77 11                	ja     80104339 <procdump+0x59>
80104328:	8b 14 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%edx
      state = "???";
8010432f:	b8 00 7b 10 80       	mov    $0x80107b00,%eax
80104334:	85 d2                	test   %edx,%edx
80104336:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104339:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010433c:	50                   	push   %eax
8010433d:	52                   	push   %edx
8010433e:	ff 73 10             	pushl  0x10(%ebx)
80104341:	68 04 7b 10 80       	push   $0x80107b04
80104346:	e8 25 c4 ff ff       	call   80100770 <cprintf>
    if(p->state == SLEEPING){
8010434b:	83 c4 10             	add    $0x10,%esp
8010434e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104352:	75 a4                	jne    801042f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104354:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104357:	83 ec 08             	sub    $0x8,%esp
8010435a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010435d:	50                   	push   %eax
8010435e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104361:	8b 40 0c             	mov    0xc(%eax),%eax
80104364:	83 c0 08             	add    $0x8,%eax
80104367:	50                   	push   %eax
80104368:	e8 63 01 00 00       	call   801044d0 <getcallerpcs>
8010436d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104370:	8b 17                	mov    (%edi),%edx
80104372:	85 d2                	test   %edx,%edx
80104374:	74 82                	je     801042f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104376:	83 ec 08             	sub    $0x8,%esp
80104379:	83 c7 04             	add    $0x4,%edi
8010437c:	52                   	push   %edx
8010437d:	68 01 75 10 80       	push   $0x80107501
80104382:	e8 e9 c3 ff ff       	call   80100770 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104387:	83 c4 10             	add    $0x10,%esp
8010438a:	39 fe                	cmp    %edi,%esi
8010438c:	75 e2                	jne    80104370 <procdump+0x90>
8010438e:	e9 65 ff ff ff       	jmp    801042f8 <procdump+0x18>
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439b:	5b                   	pop    %ebx
8010439c:	5e                   	pop    %esi
8010439d:	5f                   	pop    %edi
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043aa:	68 78 7b 10 80       	push   $0x80107b78
801043af:	8d 43 04             	lea    0x4(%ebx),%eax
801043b2:	50                   	push   %eax
801043b3:	e8 f8 00 00 00       	call   801044b0 <initlock>
  lk->name = name;
801043b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d1:	c9                   	leave  
801043d2:	c3                   	ret    
801043d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	8d 73 04             	lea    0x4(%ebx),%esi
801043ee:	56                   	push   %esi
801043ef:	e8 ac 01 00 00       	call   801045a0 <acquire>
  while (lk->locked) {
801043f4:	8b 13                	mov    (%ebx),%edx
801043f6:	83 c4 10             	add    $0x10,%esp
801043f9:	85 d2                	test   %edx,%edx
801043fb:	74 16                	je     80104413 <acquiresleep+0x33>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104400:	83 ec 08             	sub    $0x8,%esp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	e8 36 fc ff ff       	call   80104040 <sleep>
  while (lk->locked) {
8010440a:	8b 03                	mov    (%ebx),%eax
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	85 c0                	test   %eax,%eax
80104411:	75 ed                	jne    80104400 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104413:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104419:	e8 b2 f6 ff ff       	call   80103ad0 <myproc>
8010441e:	8b 40 10             	mov    0x10(%eax),%eax
80104421:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104424:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104427:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010442a:	5b                   	pop    %ebx
8010442b:	5e                   	pop    %esi
8010442c:	5d                   	pop    %ebp
  release(&lk->lk);
8010442d:	e9 8e 02 00 00       	jmp    801046c0 <release>
80104432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	8d 73 04             	lea    0x4(%ebx),%esi
8010444e:	56                   	push   %esi
8010444f:	e8 4c 01 00 00       	call   801045a0 <acquire>
  lk->locked = 0;
80104454:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010445a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104461:	89 1c 24             	mov    %ebx,(%esp)
80104464:	e8 97 fd ff ff       	call   80104200 <wakeup>
  release(&lk->lk);
80104469:	89 75 08             	mov    %esi,0x8(%ebp)
8010446c:	83 c4 10             	add    $0x10,%esp
}
8010446f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104472:	5b                   	pop    %ebx
80104473:	5e                   	pop    %esi
80104474:	5d                   	pop    %ebp
  release(&lk->lk);
80104475:	e9 46 02 00 00       	jmp    801046c0 <release>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010448e:	53                   	push   %ebx
8010448f:	e8 0c 01 00 00       	call   801045a0 <acquire>
  r = lk->locked;
80104494:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104496:	89 1c 24             	mov    %ebx,(%esp)
80104499:	e8 22 02 00 00       	call   801046c0 <release>
  return r;
}
8010449e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a1:	89 f0                	mov    %esi,%eax
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5d                   	pop    %ebp
801044a6:	c3                   	ret    
801044a7:	66 90                	xchg   %ax,%ax
801044a9:	66 90                	xchg   %ax,%ax
801044ab:	66 90                	xchg   %ax,%ax
801044ad:	66 90                	xchg   %ax,%ax
801044af:	90                   	nop

801044b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044d1:	31 d2                	xor    %edx,%edx
{
801044d3:	89 e5                	mov    %esp,%ebp
801044d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044dc:	83 e8 08             	sub    $0x8,%eax
801044df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ec:	77 1a                	ja     80104508 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ee:	8b 58 04             	mov    0x4(%eax),%ebx
801044f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044f9:	83 fa 0a             	cmp    $0xa,%edx
801044fc:	75 e2                	jne    801044e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044fe:	5b                   	pop    %ebx
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104508:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010450b:	83 c1 28             	add    $0x28,%ecx
8010450e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104516:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104519:	39 c1                	cmp    %eax,%ecx
8010451b:	75 f3                	jne    80104510 <getcallerpcs+0x40>
}
8010451d:	5b                   	pop    %ebx
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
80104527:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010452a:	8b 02                	mov    (%edx),%eax
8010452c:	85 c0                	test   %eax,%eax
8010452e:	75 10                	jne    80104540 <holding+0x20>
}
80104530:	83 c4 04             	add    $0x4,%esp
80104533:	31 c0                	xor    %eax,%eax
80104535:	5b                   	pop    %ebx
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	90                   	nop
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104540:	8b 5a 08             	mov    0x8(%edx),%ebx
80104543:	e8 e8 f4 ff ff       	call   80103a30 <mycpu>
80104548:	39 c3                	cmp    %eax,%ebx
8010454a:	0f 94 c0             	sete   %al
}
8010454d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104550:	0f b6 c0             	movzbl %al,%eax
}
80104553:	5b                   	pop    %ebx
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 04             	sub    $0x4,%esp
80104567:	9c                   	pushf  
80104568:	5b                   	pop    %ebx
  asm volatile("cli");
80104569:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010456a:	e8 c1 f4 ff ff       	call   80103a30 <mycpu>
8010456f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104575:	85 c0                	test   %eax,%eax
80104577:	75 11                	jne    8010458a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104579:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010457f:	e8 ac f4 ff ff       	call   80103a30 <mycpu>
80104584:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010458a:	e8 a1 f4 ff ff       	call   80103a30 <mycpu>
8010458f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104596:	83 c4 04             	add    $0x4,%esp
80104599:	5b                   	pop    %ebx
8010459a:	5d                   	pop    %ebp
8010459b:	c3                   	ret    
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <acquire>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045a5:	e8 b6 ff ff ff       	call   80104560 <pushcli>
  if(holding(lk))
801045aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045ad:	8b 03                	mov    (%ebx),%eax
801045af:	85 c0                	test   %eax,%eax
801045b1:	0f 85 81 00 00 00    	jne    80104638 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801045b7:	ba 01 00 00 00       	mov    $0x1,%edx
801045bc:	eb 05                	jmp    801045c3 <acquire+0x23>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c3:	89 d0                	mov    %edx,%eax
801045c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045c8:	85 c0                	test   %eax,%eax
801045ca:	75 f4                	jne    801045c0 <acquire+0x20>
  __sync_synchronize();
801045cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045d4:	e8 57 f4 ff ff       	call   80103a30 <mycpu>
  for(i = 0; i < 10; i++){
801045d9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801045db:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801045de:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045e1:	89 e8                	mov    %ebp,%eax
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045f4:	77 1a                	ja     80104610 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801045f6:	8b 58 04             	mov    0x4(%eax),%ebx
801045f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104601:	83 fa 0a             	cmp    $0xa,%edx
80104604:	75 e2                	jne    801045e8 <acquire+0x48>
}
80104606:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104609:	5b                   	pop    %ebx
8010460a:	5e                   	pop    %esi
8010460b:	5d                   	pop    %ebp
8010460c:	c3                   	ret    
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
80104610:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104613:	83 c1 28             	add    $0x28,%ecx
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104626:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104629:	39 c8                	cmp    %ecx,%eax
8010462b:	75 f3                	jne    80104620 <acquire+0x80>
}
8010462d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104630:	5b                   	pop    %ebx
80104631:	5e                   	pop    %esi
80104632:	5d                   	pop    %ebp
80104633:	c3                   	ret    
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104638:	8b 73 08             	mov    0x8(%ebx),%esi
8010463b:	e8 f0 f3 ff ff       	call   80103a30 <mycpu>
80104640:	39 c6                	cmp    %eax,%esi
80104642:	0f 85 6f ff ff ff    	jne    801045b7 <acquire+0x17>
    panic("acquire");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 83 7b 10 80       	push   $0x80107b83
80104650:	e8 4b be ff ff       	call   801004a0 <panic>
80104655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf  
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 35                	jne    801046a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 be f3 ff ff       	call   80103a30 <mycpu>
80104672:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104679:	78 34                	js     801046af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010467b:	e8 b0 f3 ff ff       	call   80103a30 <mycpu>
80104680:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104686:	85 d2                	test   %edx,%edx
80104688:	74 06                	je     80104690 <popcli+0x30>
    sti();
}
8010468a:	c9                   	leave  
8010468b:	c3                   	ret    
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104690:	e8 9b f3 ff ff       	call   80103a30 <mycpu>
80104695:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	74 eb                	je     8010468a <popcli+0x2a>
  asm volatile("sti");
8010469f:	fb                   	sti    
}
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
    panic("popcli - interruptible");
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	68 8b 7b 10 80       	push   $0x80107b8b
801046aa:	e8 f1 bd ff ff       	call   801004a0 <panic>
    panic("popcli");
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 a2 7b 10 80       	push   $0x80107ba2
801046b7:	e8 e4 bd ff ff       	call   801004a0 <panic>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801046c8:	8b 03                	mov    (%ebx),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	74 0c                	je     801046da <release+0x1a>
801046ce:	8b 73 08             	mov    0x8(%ebx),%esi
801046d1:	e8 5a f3 ff ff       	call   80103a30 <mycpu>
801046d6:	39 c6                	cmp    %eax,%esi
801046d8:	74 16                	je     801046f0 <release+0x30>
    panic("release");
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 a9 7b 10 80       	push   $0x80107ba9
801046e2:	e8 b9 bd ff ff       	call   801004a0 <panic>
801046e7:	89 f6                	mov    %esi,%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801046f0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046f7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046fe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104703:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104709:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010470c:	5b                   	pop    %ebx
8010470d:	5e                   	pop    %esi
8010470e:	5d                   	pop    %ebp
  popcli();
8010470f:	e9 4c ff ff ff       	jmp    80104660 <popcli>
80104714:	66 90                	xchg   %ax,%ax
80104716:	66 90                	xchg   %ax,%ax
80104718:	66 90                	xchg   %ax,%ax
8010471a:	66 90                	xchg   %ax,%ax
8010471c:	66 90                	xchg   %ax,%ax
8010471e:	66 90                	xchg   %ax,%ax

80104720 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	53                   	push   %ebx
80104725:	8b 55 08             	mov    0x8(%ebp),%edx
80104728:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010472b:	f6 c2 03             	test   $0x3,%dl
8010472e:	75 05                	jne    80104735 <memset+0x15>
80104730:	f6 c1 03             	test   $0x3,%cl
80104733:	74 13                	je     80104748 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104735:	89 d7                	mov    %edx,%edi
80104737:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473a:	fc                   	cld    
8010473b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010473d:	5b                   	pop    %ebx
8010473e:	89 d0                	mov    %edx,%eax
80104740:	5f                   	pop    %edi
80104741:	5d                   	pop    %ebp
80104742:	c3                   	ret    
80104743:	90                   	nop
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104748:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010474c:	c1 e9 02             	shr    $0x2,%ecx
8010474f:	89 f8                	mov    %edi,%eax
80104751:	89 fb                	mov    %edi,%ebx
80104753:	c1 e0 18             	shl    $0x18,%eax
80104756:	c1 e3 10             	shl    $0x10,%ebx
80104759:	09 d8                	or     %ebx,%eax
8010475b:	09 f8                	or     %edi,%eax
8010475d:	c1 e7 08             	shl    $0x8,%edi
80104760:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104762:	89 d7                	mov    %edx,%edi
80104764:	fc                   	cld    
80104765:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104767:	5b                   	pop    %ebx
80104768:	89 d0                	mov    %edx,%eax
8010476a:	5f                   	pop    %edi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104779:	8b 75 08             	mov    0x8(%ebp),%esi
8010477c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010477f:	85 db                	test   %ebx,%ebx
80104781:	74 29                	je     801047ac <memcmp+0x3c>
    if(*s1 != *s2)
80104783:	0f b6 16             	movzbl (%esi),%edx
80104786:	0f b6 0f             	movzbl (%edi),%ecx
80104789:	38 d1                	cmp    %dl,%cl
8010478b:	75 2b                	jne    801047b8 <memcmp+0x48>
8010478d:	b8 01 00 00 00       	mov    $0x1,%eax
80104792:	eb 14                	jmp    801047a8 <memcmp+0x38>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104798:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010479c:	83 c0 01             	add    $0x1,%eax
8010479f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047a4:	38 ca                	cmp    %cl,%dl
801047a6:	75 10                	jne    801047b8 <memcmp+0x48>
  while(n-- > 0){
801047a8:	39 d8                	cmp    %ebx,%eax
801047aa:	75 ec                	jne    80104798 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047ac:	5b                   	pop    %ebx
  return 0;
801047ad:	31 c0                	xor    %eax,%eax
}
801047af:	5e                   	pop    %esi
801047b0:	5f                   	pop    %edi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801047b8:	0f b6 c2             	movzbl %dl,%eax
}
801047bb:	5b                   	pop    %ebx
      return *s1 - *s2;
801047bc:	29 c8                	sub    %ecx,%eax
}
801047be:	5e                   	pop    %esi
801047bf:	5f                   	pop    %edi
801047c0:	5d                   	pop    %ebp
801047c1:	c3                   	ret    
801047c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 45 08             	mov    0x8(%ebp),%eax
801047d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047db:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047de:	39 c3                	cmp    %eax,%ebx
801047e0:	73 26                	jae    80104808 <memmove+0x38>
801047e2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047e5:	39 c8                	cmp    %ecx,%eax
801047e7:	73 1f                	jae    80104808 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047e9:	85 f6                	test   %esi,%esi
801047eb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047ee:	74 0f                	je     801047ff <memmove+0x2f>
      *--d = *--s;
801047f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047f7:	83 ea 01             	sub    $0x1,%edx
801047fa:	83 fa ff             	cmp    $0xffffffff,%edx
801047fd:	75 f1                	jne    801047f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047ff:	5b                   	pop    %ebx
80104800:	5e                   	pop    %esi
80104801:	5d                   	pop    %ebp
80104802:	c3                   	ret    
80104803:	90                   	nop
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104808:	31 d2                	xor    %edx,%edx
8010480a:	85 f6                	test   %esi,%esi
8010480c:	74 f1                	je     801047ff <memmove+0x2f>
8010480e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104810:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104814:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104817:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010481a:	39 d6                	cmp    %edx,%esi
8010481c:	75 f2                	jne    80104810 <memmove+0x40>
}
8010481e:	5b                   	pop    %ebx
8010481f:	5e                   	pop    %esi
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104833:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104834:	eb 9a                	jmp    801047d0 <memmove>
80104836:	8d 76 00             	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	8b 7d 10             	mov    0x10(%ebp),%edi
80104848:	53                   	push   %ebx
80104849:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010484c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010484f:	85 ff                	test   %edi,%edi
80104851:	74 2f                	je     80104882 <strncmp+0x42>
80104853:	0f b6 01             	movzbl (%ecx),%eax
80104856:	0f b6 1e             	movzbl (%esi),%ebx
80104859:	84 c0                	test   %al,%al
8010485b:	74 37                	je     80104894 <strncmp+0x54>
8010485d:	38 c3                	cmp    %al,%bl
8010485f:	75 33                	jne    80104894 <strncmp+0x54>
80104861:	01 f7                	add    %esi,%edi
80104863:	eb 13                	jmp    80104878 <strncmp+0x38>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
80104868:	0f b6 01             	movzbl (%ecx),%eax
8010486b:	84 c0                	test   %al,%al
8010486d:	74 21                	je     80104890 <strncmp+0x50>
8010486f:	0f b6 1a             	movzbl (%edx),%ebx
80104872:	89 d6                	mov    %edx,%esi
80104874:	38 d8                	cmp    %bl,%al
80104876:	75 1c                	jne    80104894 <strncmp+0x54>
    n--, p++, q++;
80104878:	8d 56 01             	lea    0x1(%esi),%edx
8010487b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010487e:	39 fa                	cmp    %edi,%edx
80104880:	75 e6                	jne    80104868 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104882:	5b                   	pop    %ebx
    return 0;
80104883:	31 c0                	xor    %eax,%eax
}
80104885:	5e                   	pop    %esi
80104886:	5f                   	pop    %edi
80104887:	5d                   	pop    %ebp
80104888:	c3                   	ret    
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104890:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104894:	29 d8                	sub    %ebx,%eax
}
80104896:	5b                   	pop    %ebx
80104897:	5e                   	pop    %esi
80104898:	5f                   	pop    %edi
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	90                   	nop
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 45 08             	mov    0x8(%ebp),%eax
801048a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048ae:	89 c2                	mov    %eax,%edx
801048b0:	eb 19                	jmp    801048cb <strncpy+0x2b>
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b8:	83 c3 01             	add    $0x1,%ebx
801048bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048bf:	83 c2 01             	add    $0x1,%edx
801048c2:	84 c9                	test   %cl,%cl
801048c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801048c7:	74 09                	je     801048d2 <strncpy+0x32>
801048c9:	89 f1                	mov    %esi,%ecx
801048cb:	85 c9                	test   %ecx,%ecx
801048cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048d0:	7f e6                	jg     801048b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801048d2:	31 c9                	xor    %ecx,%ecx
801048d4:	85 f6                	test   %esi,%esi
801048d6:	7e 17                	jle    801048ef <strncpy+0x4f>
801048d8:	90                   	nop
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048e0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048e4:	89 f3                	mov    %esi,%ebx
801048e6:	83 c1 01             	add    $0x1,%ecx
801048e9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048eb:	85 db                	test   %ebx,%ebx
801048ed:	7f f1                	jg     801048e0 <strncpy+0x40>
  return os;
}
801048ef:	5b                   	pop    %ebx
801048f0:	5e                   	pop    %esi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104908:	8b 45 08             	mov    0x8(%ebp),%eax
8010490b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010490e:	85 c9                	test   %ecx,%ecx
80104910:	7e 26                	jle    80104938 <safestrcpy+0x38>
80104912:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104916:	89 c1                	mov    %eax,%ecx
80104918:	eb 17                	jmp    80104931 <safestrcpy+0x31>
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104920:	83 c2 01             	add    $0x1,%edx
80104923:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104927:	83 c1 01             	add    $0x1,%ecx
8010492a:	84 db                	test   %bl,%bl
8010492c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010492f:	74 04                	je     80104935 <safestrcpy+0x35>
80104931:	39 f2                	cmp    %esi,%edx
80104933:	75 eb                	jne    80104920 <safestrcpy+0x20>
    ;
  *s = 0;
80104935:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104938:	5b                   	pop    %ebx
80104939:	5e                   	pop    %esi
8010493a:	5d                   	pop    %ebp
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <strlen>:

int
strlen(const char *s)
{
80104940:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104941:	31 c0                	xor    %eax,%eax
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104948:	80 3a 00             	cmpb   $0x0,(%edx)
8010494b:	74 0c                	je     80104959 <strlen+0x19>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
80104950:	83 c0 01             	add    $0x1,%eax
80104953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104957:	75 f7                	jne    80104950 <strlen+0x10>
    ;
  return n;
}
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    

8010495b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010495b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010495f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104963:	55                   	push   %ebp
  pushl %ebx
80104964:	53                   	push   %ebx
  pushl %esi
80104965:	56                   	push   %esi
  pushl %edi
80104966:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104967:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104969:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010496b:	5f                   	pop    %edi
  popl %esi
8010496c:	5e                   	pop    %esi
  popl %ebx
8010496d:	5b                   	pop    %ebx
  popl %ebp
8010496e:	5d                   	pop    %ebp
  ret
8010496f:	c3                   	ret    

80104970 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010497a:	e8 51 f1 ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010497f:	8b 00                	mov    (%eax),%eax
80104981:	39 d8                	cmp    %ebx,%eax
80104983:	76 1b                	jbe    801049a0 <fetchint+0x30>
80104985:	8d 53 04             	lea    0x4(%ebx),%edx
80104988:	39 d0                	cmp    %edx,%eax
8010498a:	72 14                	jb     801049a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010498c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498f:	8b 13                	mov    (%ebx),%edx
80104991:	89 10                	mov    %edx,(%eax)
  return 0;
80104993:	31 c0                	xor    %eax,%eax
}
80104995:	83 c4 04             	add    $0x4,%esp
80104998:	5b                   	pop    %ebx
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    
8010499b:	90                   	nop
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a5:	eb ee                	jmp    80104995 <fetchint+0x25>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ba:	e8 11 f1 ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz)
801049bf:	39 18                	cmp    %ebx,(%eax)
801049c1:	76 29                	jbe    801049ec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049c6:	89 da                	mov    %ebx,%edx
801049c8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801049ca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801049cc:	39 c3                	cmp    %eax,%ebx
801049ce:	73 1c                	jae    801049ec <fetchstr+0x3c>
    if(*s == 0)
801049d0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049d3:	75 10                	jne    801049e5 <fetchstr+0x35>
801049d5:	eb 39                	jmp    80104a10 <fetchstr+0x60>
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049e0:	80 3a 00             	cmpb   $0x0,(%edx)
801049e3:	74 1b                	je     80104a00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049e5:	83 c2 01             	add    $0x1,%edx
801049e8:	39 d0                	cmp    %edx,%eax
801049ea:	77 f4                	ja     801049e0 <fetchstr+0x30>
    return -1;
801049ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049f1:	83 c4 04             	add    $0x4,%esp
801049f4:	5b                   	pop    %ebx
801049f5:	5d                   	pop    %ebp
801049f6:	c3                   	ret    
801049f7:	89 f6                	mov    %esi,%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a00:	83 c4 04             	add    $0x4,%esp
80104a03:	89 d0                	mov    %edx,%eax
80104a05:	29 d8                	sub    %ebx,%eax
80104a07:	5b                   	pop    %ebx
80104a08:	5d                   	pop    %ebp
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a12:	eb dd                	jmp    801049f1 <fetchstr+0x41>
80104a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a25:	e8 a6 f0 ff ff       	call   80103ad0 <myproc>
80104a2a:	8b 40 18             	mov    0x18(%eax),%eax
80104a2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a30:	8b 40 44             	mov    0x44(%eax),%eax
80104a33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a36:	e8 95 f0 ff ff       	call   80103ad0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a40:	39 c6                	cmp    %eax,%esi
80104a42:	73 1c                	jae    80104a60 <argint+0x40>
80104a44:	8d 53 08             	lea    0x8(%ebx),%edx
80104a47:	39 d0                	cmp    %edx,%eax
80104a49:	72 15                	jb     80104a60 <argint+0x40>
  *ip = *(int*)(addr);
80104a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a51:	89 10                	mov    %edx,(%eax)
  return 0;
80104a53:	31 c0                	xor    %eax,%eax
}
80104a55:	5b                   	pop    %ebx
80104a56:	5e                   	pop    %esi
80104a57:	5d                   	pop    %ebp
80104a58:	c3                   	ret    
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	eb ee                	jmp    80104a55 <argint+0x35>
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	83 ec 10             	sub    $0x10,%esp
80104a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a7b:	e8 50 f0 ff ff       	call   80103ad0 <myproc>
80104a80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a85:	83 ec 08             	sub    $0x8,%esp
80104a88:	50                   	push   %eax
80104a89:	ff 75 08             	pushl  0x8(%ebp)
80104a8c:	e8 8f ff ff ff       	call   80104a20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a91:	83 c4 10             	add    $0x10,%esp
80104a94:	85 c0                	test   %eax,%eax
80104a96:	78 28                	js     80104ac0 <argptr+0x50>
80104a98:	85 db                	test   %ebx,%ebx
80104a9a:	78 24                	js     80104ac0 <argptr+0x50>
80104a9c:	8b 16                	mov    (%esi),%edx
80104a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa1:	39 c2                	cmp    %eax,%edx
80104aa3:	76 1b                	jbe    80104ac0 <argptr+0x50>
80104aa5:	01 c3                	add    %eax,%ebx
80104aa7:	39 da                	cmp    %ebx,%edx
80104aa9:	72 15                	jb     80104ac0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aae:	89 02                	mov    %eax,(%edx)
  return 0;
80104ab0:	31 c0                	xor    %eax,%eax
}
80104ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab5:	5b                   	pop    %ebx
80104ab6:	5e                   	pop    %esi
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret    
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb eb                	jmp    80104ab2 <argptr+0x42>
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ad9:	50                   	push   %eax
80104ada:	ff 75 08             	pushl  0x8(%ebp)
80104add:	e8 3e ff ff ff       	call   80104a20 <argint>
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	78 17                	js     80104b00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ae9:	83 ec 08             	sub    $0x8,%esp
80104aec:	ff 75 0c             	pushl  0xc(%ebp)
80104aef:	ff 75 f4             	pushl  -0xc(%ebp)
80104af2:	e8 b9 fe ff ff       	call   801049b0 <fetchstr>
80104af7:	83 c4 10             	add    $0x10,%esp
}
80104afa:	c9                   	leave  
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b05:	c9                   	leave  
80104b06:	c3                   	ret    
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b17:	e8 b4 ef ff ff       	call   80103ad0 <myproc>
80104b1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b1e:	8b 40 18             	mov    0x18(%eax),%eax
80104b21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b27:	83 fa 16             	cmp    $0x16,%edx
80104b2a:	77 1c                	ja     80104b48 <syscall+0x38>
80104b2c:	8b 14 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%edx
80104b33:	85 d2                	test   %edx,%edx
80104b35:	74 11                	je     80104b48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b37:	ff d2                	call   *%edx
80104b39:	8b 53 18             	mov    0x18(%ebx),%edx
80104b3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b4c:	50                   	push   %eax
80104b4d:	ff 73 10             	pushl  0x10(%ebx)
80104b50:	68 b1 7b 10 80       	push   $0x80107bb1
80104b55:	e8 16 bc ff ff       	call   80100770 <cprintf>
    curproc->tf->eax = -1;
80104b5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6a:	c9                   	leave  
80104b6b:	c3                   	ret    
80104b6c:	66 90                	xchg   %ax,%ax
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b76:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104b79:	83 ec 44             	sub    $0x44,%esp
80104b7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b82:	56                   	push   %esi
80104b83:	50                   	push   %eax
{
80104b84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b8a:	e8 31 d6 ff ff       	call   801021c0 <nameiparent>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	85 c0                	test   %eax,%eax
80104b94:	0f 84 46 01 00 00    	je     80104ce0 <create+0x170>
    return 0;
  ilock(dp);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	89 c3                	mov    %eax,%ebx
80104b9f:	50                   	push   %eax
80104ba0:	e8 9b cd ff ff       	call   80101940 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ba5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ba8:	83 c4 0c             	add    $0xc,%esp
80104bab:	50                   	push   %eax
80104bac:	56                   	push   %esi
80104bad:	53                   	push   %ebx
80104bae:	e8 bd d2 ff ff       	call   80101e70 <dirlookup>
80104bb3:	83 c4 10             	add    $0x10,%esp
80104bb6:	85 c0                	test   %eax,%eax
80104bb8:	89 c7                	mov    %eax,%edi
80104bba:	74 34                	je     80104bf0 <create+0x80>
    iunlockput(dp);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	53                   	push   %ebx
80104bc0:	e8 0b d0 ff ff       	call   80101bd0 <iunlockput>
    ilock(ip);
80104bc5:	89 3c 24             	mov    %edi,(%esp)
80104bc8:	e8 73 cd ff ff       	call   80101940 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104bd5:	0f 85 95 00 00 00    	jne    80104c70 <create+0x100>
80104bdb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104be0:	0f 85 8a 00 00 00    	jne    80104c70 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be9:	89 f8                	mov    %edi,%eax
80104beb:	5b                   	pop    %ebx
80104bec:	5e                   	pop    %esi
80104bed:	5f                   	pop    %edi
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104bf0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	ff 33                	pushl  (%ebx)
80104bfa:	e8 d1 cb ff ff       	call   801017d0 <ialloc>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	85 c0                	test   %eax,%eax
80104c04:	89 c7                	mov    %eax,%edi
80104c06:	0f 84 e8 00 00 00    	je     80104cf4 <create+0x184>
  ilock(ip);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	50                   	push   %eax
80104c10:	e8 2b cd ff ff       	call   80101940 <ilock>
  ip->major = major;
80104c15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c2e:	89 3c 24             	mov    %edi,(%esp)
80104c31:	e8 5a cc ff ff       	call   80101890 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c3e:	74 50                	je     80104c90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c40:	83 ec 04             	sub    $0x4,%esp
80104c43:	ff 77 04             	pushl  0x4(%edi)
80104c46:	56                   	push   %esi
80104c47:	53                   	push   %ebx
80104c48:	e8 93 d4 ff ff       	call   801020e0 <dirlink>
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	0f 88 8f 00 00 00    	js     80104ce7 <create+0x177>
  iunlockput(dp);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	53                   	push   %ebx
80104c5c:	e8 6f cf ff ff       	call   80101bd0 <iunlockput>
  return ip;
80104c61:	83 c4 10             	add    $0x10,%esp
}
80104c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c67:	89 f8                	mov    %edi,%eax
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5f                   	pop    %edi
80104c6c:	5d                   	pop    %ebp
80104c6d:	c3                   	ret    
80104c6e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	57                   	push   %edi
    return 0;
80104c74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c76:	e8 55 cf ff ff       	call   80101bd0 <iunlockput>
    return 0;
80104c7b:	83 c4 10             	add    $0x10,%esp
}
80104c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c81:	89 f8                	mov    %edi,%eax
80104c83:	5b                   	pop    %ebx
80104c84:	5e                   	pop    %esi
80104c85:	5f                   	pop    %edi
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	90                   	nop
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	53                   	push   %ebx
80104c99:	e8 f2 cb ff ff       	call   80101890 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c9e:	83 c4 0c             	add    $0xc,%esp
80104ca1:	ff 77 04             	pushl  0x4(%edi)
80104ca4:	68 5c 7c 10 80       	push   $0x80107c5c
80104ca9:	57                   	push   %edi
80104caa:	e8 31 d4 ff ff       	call   801020e0 <dirlink>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	78 1c                	js     80104cd2 <create+0x162>
80104cb6:	83 ec 04             	sub    $0x4,%esp
80104cb9:	ff 73 04             	pushl  0x4(%ebx)
80104cbc:	68 5b 7c 10 80       	push   $0x80107c5b
80104cc1:	57                   	push   %edi
80104cc2:	e8 19 d4 ff ff       	call   801020e0 <dirlink>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	0f 89 6e ff ff ff    	jns    80104c40 <create+0xd0>
      panic("create dots");
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	68 4f 7c 10 80       	push   $0x80107c4f
80104cda:	e8 c1 b7 ff ff       	call   801004a0 <panic>
80104cdf:	90                   	nop
    return 0;
80104ce0:	31 ff                	xor    %edi,%edi
80104ce2:	e9 ff fe ff ff       	jmp    80104be6 <create+0x76>
    panic("create: dirlink");
80104ce7:	83 ec 0c             	sub    $0xc,%esp
80104cea:	68 5e 7c 10 80       	push   $0x80107c5e
80104cef:	e8 ac b7 ff ff       	call   801004a0 <panic>
    panic("create: ialloc");
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	68 40 7c 10 80       	push   $0x80107c40
80104cfc:	e8 9f b7 ff ff       	call   801004a0 <panic>
80104d01:	eb 0d                	jmp    80104d10 <argfd.constprop.0>
80104d03:	90                   	nop
80104d04:	90                   	nop
80104d05:	90                   	nop
80104d06:	90                   	nop
80104d07:	90                   	nop
80104d08:	90                   	nop
80104d09:	90                   	nop
80104d0a:	90                   	nop
80104d0b:	90                   	nop
80104d0c:	90                   	nop
80104d0d:	90                   	nop
80104d0e:	90                   	nop
80104d0f:	90                   	nop

80104d10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d1a:	89 d6                	mov    %edx,%esi
80104d1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d1f:	50                   	push   %eax
80104d20:	6a 00                	push   $0x0
80104d22:	e8 f9 fc ff ff       	call   80104a20 <argint>
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	78 2a                	js     80104d58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d32:	77 24                	ja     80104d58 <argfd.constprop.0+0x48>
80104d34:	e8 97 ed ff ff       	call   80103ad0 <myproc>
80104d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d40:	85 c0                	test   %eax,%eax
80104d42:	74 14                	je     80104d58 <argfd.constprop.0+0x48>
  if(pfd)
80104d44:	85 db                	test   %ebx,%ebx
80104d46:	74 02                	je     80104d4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d4a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d4c:	31 c0                	xor    %eax,%eax
}
80104d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d51:	5b                   	pop    %ebx
80104d52:	5e                   	pop    %esi
80104d53:	5d                   	pop    %ebp
80104d54:	c3                   	ret    
80104d55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d5d:	eb ef                	jmp    80104d4e <argfd.constprop.0+0x3e>
80104d5f:	90                   	nop

80104d60 <sys_dup>:
{
80104d60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	56                   	push   %esi
80104d66:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d67:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d6a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d6d:	e8 9e ff ff ff       	call   80104d10 <argfd.constprop.0>
80104d72:	85 c0                	test   %eax,%eax
80104d74:	78 42                	js     80104db8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104d76:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d79:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d7b:	e8 50 ed ff ff       	call   80103ad0 <myproc>
80104d80:	eb 0e                	jmp    80104d90 <sys_dup+0x30>
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d88:	83 c3 01             	add    $0x1,%ebx
80104d8b:	83 fb 10             	cmp    $0x10,%ebx
80104d8e:	74 28                	je     80104db8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d94:	85 d2                	test   %edx,%edx
80104d96:	75 f0                	jne    80104d88 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d98:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104da2:	e8 59 c1 ff ff       	call   80100f00 <filedup>
  return fd;
80104da7:	83 c4 10             	add    $0x10,%esp
}
80104daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dad:	89 d8                	mov    %ebx,%eax
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104db8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104dc0:	89 d8                	mov    %ebx,%eax
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret    
80104dc6:	8d 76 00             	lea    0x0(%esi),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_read>:
{
80104dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ddb:	e8 30 ff ff ff       	call   80104d10 <argfd.constprop.0>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 4c                	js     80104e30 <sys_read+0x60>
80104de4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104de7:	83 ec 08             	sub    $0x8,%esp
80104dea:	50                   	push   %eax
80104deb:	6a 02                	push   $0x2
80104ded:	e8 2e fc ff ff       	call   80104a20 <argint>
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	85 c0                	test   %eax,%eax
80104df7:	78 37                	js     80104e30 <sys_read+0x60>
80104df9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dfc:	83 ec 04             	sub    $0x4,%esp
80104dff:	ff 75 f0             	pushl  -0x10(%ebp)
80104e02:	50                   	push   %eax
80104e03:	6a 01                	push   $0x1
80104e05:	e8 66 fc ff ff       	call   80104a70 <argptr>
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	78 1f                	js     80104e30 <sys_read+0x60>
  return fileread(f, p, n);
80104e11:	83 ec 04             	sub    $0x4,%esp
80104e14:	ff 75 f0             	pushl  -0x10(%ebp)
80104e17:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e1d:	e8 4e c2 ff ff       	call   80101070 <fileread>
80104e22:	83 c4 10             	add    $0x10,%esp
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <sys_write>:
{
80104e40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e4b:	e8 c0 fe ff ff       	call   80104d10 <argfd.constprop.0>
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 4c                	js     80104ea0 <sys_write+0x60>
80104e54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e57:	83 ec 08             	sub    $0x8,%esp
80104e5a:	50                   	push   %eax
80104e5b:	6a 02                	push   $0x2
80104e5d:	e8 be fb ff ff       	call   80104a20 <argint>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 37                	js     80104ea0 <sys_write+0x60>
80104e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e6c:	83 ec 04             	sub    $0x4,%esp
80104e6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e72:	50                   	push   %eax
80104e73:	6a 01                	push   $0x1
80104e75:	e8 f6 fb ff ff       	call   80104a70 <argptr>
80104e7a:	83 c4 10             	add    $0x10,%esp
80104e7d:	85 c0                	test   %eax,%eax
80104e7f:	78 1f                	js     80104ea0 <sys_write+0x60>
  return filewrite(f, p, n);
80104e81:	83 ec 04             	sub    $0x4,%esp
80104e84:	ff 75 f0             	pushl  -0x10(%ebp)
80104e87:	ff 75 f4             	pushl  -0xc(%ebp)
80104e8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e8d:	e8 6e c2 ff ff       	call   80101100 <filewrite>
80104e92:	83 c4 10             	add    $0x10,%esp
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <sys_close>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104eb6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104eb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ebc:	e8 4f fe ff ff       	call   80104d10 <argfd.constprop.0>
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	78 2b                	js     80104ef0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ec5:	e8 06 ec ff ff       	call   80103ad0 <myproc>
80104eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ecd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ed0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ed7:	00 
  fileclose(f);
80104ed8:	ff 75 f4             	pushl  -0xc(%ebp)
80104edb:	e8 70 c0 ff ff       	call   80100f50 <fileclose>
  return 0;
80104ee0:	83 c4 10             	add    $0x10,%esp
80104ee3:	31 c0                	xor    %eax,%eax
}
80104ee5:	c9                   	leave  
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <sys_fstat>:
{
80104f00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f01:	31 c0                	xor    %eax,%eax
{
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f0b:	e8 00 fe ff ff       	call   80104d10 <argfd.constprop.0>
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 2c                	js     80104f40 <sys_fstat+0x40>
80104f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f17:	83 ec 04             	sub    $0x4,%esp
80104f1a:	6a 14                	push   $0x14
80104f1c:	50                   	push   %eax
80104f1d:	6a 01                	push   $0x1
80104f1f:	e8 4c fb ff ff       	call   80104a70 <argptr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	78 15                	js     80104f40 <sys_fstat+0x40>
  return filestat(f, st);
80104f2b:	83 ec 08             	sub    $0x8,%esp
80104f2e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f31:	ff 75 f0             	pushl  -0x10(%ebp)
80104f34:	e8 e7 c0 ff ff       	call   80101020 <filestat>
80104f39:	83 c4 10             	add    $0x10,%esp
}
80104f3c:	c9                   	leave  
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_link>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f56:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 6c fb ff ff       	call   80104ad0 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 fb 00 00 00    	js     8010506a <sys_link+0x11a>
80104f6f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f72:	83 ec 08             	sub    $0x8,%esp
80104f75:	50                   	push   %eax
80104f76:	6a 01                	push   $0x1
80104f78:	e8 53 fb ff ff       	call   80104ad0 <argstr>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	85 c0                	test   %eax,%eax
80104f82:	0f 88 e2 00 00 00    	js     8010506a <sys_link+0x11a>
  begin_op();
80104f88:	e8 f3 de ff ff       	call   80102e80 <begin_op>
  if((ip = namei(old)) == 0){
80104f8d:	83 ec 0c             	sub    $0xc,%esp
80104f90:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f93:	e8 08 d2 ff ff       	call   801021a0 <namei>
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	89 c3                	mov    %eax,%ebx
80104f9f:	0f 84 ea 00 00 00    	je     8010508f <sys_link+0x13f>
  ilock(ip);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	50                   	push   %eax
80104fa9:	e8 92 c9 ff ff       	call   80101940 <ilock>
  if(ip->type == T_DIR){
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fb6:	0f 84 bb 00 00 00    	je     80105077 <sys_link+0x127>
  ip->nlink++;
80104fbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fc1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104fc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fc7:	53                   	push   %ebx
80104fc8:	e8 c3 c8 ff ff       	call   80101890 <iupdate>
  iunlock(ip);
80104fcd:	89 1c 24             	mov    %ebx,(%esp)
80104fd0:	e8 4b ca ff ff       	call   80101a20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fd5:	58                   	pop    %eax
80104fd6:	5a                   	pop    %edx
80104fd7:	57                   	push   %edi
80104fd8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fdb:	e8 e0 d1 ff ff       	call   801021c0 <nameiparent>
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	85 c0                	test   %eax,%eax
80104fe5:	89 c6                	mov    %eax,%esi
80104fe7:	74 5b                	je     80105044 <sys_link+0xf4>
  ilock(dp);
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	50                   	push   %eax
80104fed:	e8 4e c9 ff ff       	call   80101940 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	8b 03                	mov    (%ebx),%eax
80104ff7:	39 06                	cmp    %eax,(%esi)
80104ff9:	75 3d                	jne    80105038 <sys_link+0xe8>
80104ffb:	83 ec 04             	sub    $0x4,%esp
80104ffe:	ff 73 04             	pushl  0x4(%ebx)
80105001:	57                   	push   %edi
80105002:	56                   	push   %esi
80105003:	e8 d8 d0 ff ff       	call   801020e0 <dirlink>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	85 c0                	test   %eax,%eax
8010500d:	78 29                	js     80105038 <sys_link+0xe8>
  iunlockput(dp);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	56                   	push   %esi
80105013:	e8 b8 cb ff ff       	call   80101bd0 <iunlockput>
  iput(ip);
80105018:	89 1c 24             	mov    %ebx,(%esp)
8010501b:	e8 50 ca ff ff       	call   80101a70 <iput>
  end_op();
80105020:	e8 cb de ff ff       	call   80102ef0 <end_op>
  return 0;
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	31 c0                	xor    %eax,%eax
}
8010502a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010502d:	5b                   	pop    %ebx
8010502e:	5e                   	pop    %esi
8010502f:	5f                   	pop    %edi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	56                   	push   %esi
8010503c:	e8 8f cb ff ff       	call   80101bd0 <iunlockput>
    goto bad;
80105041:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	53                   	push   %ebx
80105048:	e8 f3 c8 ff ff       	call   80101940 <ilock>
  ip->nlink--;
8010504d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105052:	89 1c 24             	mov    %ebx,(%esp)
80105055:	e8 36 c8 ff ff       	call   80101890 <iupdate>
  iunlockput(ip);
8010505a:	89 1c 24             	mov    %ebx,(%esp)
8010505d:	e8 6e cb ff ff       	call   80101bd0 <iunlockput>
  end_op();
80105062:	e8 89 de ff ff       	call   80102ef0 <end_op>
  return -1;
80105067:	83 c4 10             	add    $0x10,%esp
}
8010506a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010506d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5f                   	pop    %edi
80105075:	5d                   	pop    %ebp
80105076:	c3                   	ret    
    iunlockput(ip);
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	53                   	push   %ebx
8010507b:	e8 50 cb ff ff       	call   80101bd0 <iunlockput>
    end_op();
80105080:	e8 6b de ff ff       	call   80102ef0 <end_op>
    return -1;
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb 9b                	jmp    8010502a <sys_link+0xda>
    end_op();
8010508f:	e8 5c de ff ff       	call   80102ef0 <end_op>
    return -1;
80105094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105099:	eb 8f                	jmp    8010502a <sys_link+0xda>
8010509b:	90                   	nop
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_unlink>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 1c fa ff ff       	call   80104ad0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 77 01 00 00    	js     80105236 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801050bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801050c2:	e8 b9 dd ff ff       	call   80102e80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050c7:	83 ec 08             	sub    $0x8,%esp
801050ca:	53                   	push   %ebx
801050cb:	ff 75 c0             	pushl  -0x40(%ebp)
801050ce:	e8 ed d0 ff ff       	call   801021c0 <nameiparent>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	89 c6                	mov    %eax,%esi
801050da:	0f 84 60 01 00 00    	je     80105240 <sys_unlink+0x1a0>
  ilock(dp);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	50                   	push   %eax
801050e4:	e8 57 c8 ff ff       	call   80101940 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050e9:	58                   	pop    %eax
801050ea:	5a                   	pop    %edx
801050eb:	68 5c 7c 10 80       	push   $0x80107c5c
801050f0:	53                   	push   %ebx
801050f1:	e8 5a cd ff ff       	call   80101e50 <namecmp>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	0f 84 03 01 00 00    	je     80105204 <sys_unlink+0x164>
80105101:	83 ec 08             	sub    $0x8,%esp
80105104:	68 5b 7c 10 80       	push   $0x80107c5b
80105109:	53                   	push   %ebx
8010510a:	e8 41 cd ff ff       	call   80101e50 <namecmp>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	85 c0                	test   %eax,%eax
80105114:	0f 84 ea 00 00 00    	je     80105204 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010511a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010511d:	83 ec 04             	sub    $0x4,%esp
80105120:	50                   	push   %eax
80105121:	53                   	push   %ebx
80105122:	56                   	push   %esi
80105123:	e8 48 cd ff ff       	call   80101e70 <dirlookup>
80105128:	83 c4 10             	add    $0x10,%esp
8010512b:	85 c0                	test   %eax,%eax
8010512d:	89 c3                	mov    %eax,%ebx
8010512f:	0f 84 cf 00 00 00    	je     80105204 <sys_unlink+0x164>
  ilock(ip);
80105135:	83 ec 0c             	sub    $0xc,%esp
80105138:	50                   	push   %eax
80105139:	e8 02 c8 ff ff       	call   80101940 <ilock>
  if(ip->nlink < 1)
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105146:	0f 8e 10 01 00 00    	jle    8010525c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010514c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105151:	74 6d                	je     801051c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105153:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105156:	83 ec 04             	sub    $0x4,%esp
80105159:	6a 10                	push   $0x10
8010515b:	6a 00                	push   $0x0
8010515d:	50                   	push   %eax
8010515e:	e8 bd f5 ff ff       	call   80104720 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105163:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105166:	6a 10                	push   $0x10
80105168:	ff 75 c4             	pushl  -0x3c(%ebp)
8010516b:	50                   	push   %eax
8010516c:	56                   	push   %esi
8010516d:	e8 ae cb ff ff       	call   80101d20 <writei>
80105172:	83 c4 20             	add    $0x20,%esp
80105175:	83 f8 10             	cmp    $0x10,%eax
80105178:	0f 85 eb 00 00 00    	jne    80105269 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010517e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105183:	0f 84 97 00 00 00    	je     80105220 <sys_unlink+0x180>
  iunlockput(dp);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	56                   	push   %esi
8010518d:	e8 3e ca ff ff       	call   80101bd0 <iunlockput>
  ip->nlink--;
80105192:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105197:	89 1c 24             	mov    %ebx,(%esp)
8010519a:	e8 f1 c6 ff ff       	call   80101890 <iupdate>
  iunlockput(ip);
8010519f:	89 1c 24             	mov    %ebx,(%esp)
801051a2:	e8 29 ca ff ff       	call   80101bd0 <iunlockput>
  end_op();
801051a7:	e8 44 dd ff ff       	call   80102ef0 <end_op>
  return 0;
801051ac:	83 c4 10             	add    $0x10,%esp
801051af:	31 c0                	xor    %eax,%eax
}
801051b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b4:	5b                   	pop    %ebx
801051b5:	5e                   	pop    %esi
801051b6:	5f                   	pop    %edi
801051b7:	5d                   	pop    %ebp
801051b8:	c3                   	ret    
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051c4:	76 8d                	jbe    80105153 <sys_unlink+0xb3>
801051c6:	bf 20 00 00 00       	mov    $0x20,%edi
801051cb:	eb 0f                	jmp    801051dc <sys_unlink+0x13c>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c7 10             	add    $0x10,%edi
801051d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801051d6:	0f 83 77 ff ff ff    	jae    80105153 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051df:	6a 10                	push   $0x10
801051e1:	57                   	push   %edi
801051e2:	50                   	push   %eax
801051e3:	53                   	push   %ebx
801051e4:	e8 37 ca ff ff       	call   80101c20 <readi>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	83 f8 10             	cmp    $0x10,%eax
801051ef:	75 5e                	jne    8010524f <sys_unlink+0x1af>
    if(de.inum != 0)
801051f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051f6:	74 d8                	je     801051d0 <sys_unlink+0x130>
    iunlockput(ip);
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	53                   	push   %ebx
801051fc:	e8 cf c9 ff ff       	call   80101bd0 <iunlockput>
    goto bad;
80105201:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	56                   	push   %esi
80105208:	e8 c3 c9 ff ff       	call   80101bd0 <iunlockput>
  end_op();
8010520d:	e8 de dc ff ff       	call   80102ef0 <end_op>
  return -1;
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521a:	eb 95                	jmp    801051b1 <sys_unlink+0x111>
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105220:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	56                   	push   %esi
80105229:	e8 62 c6 ff ff       	call   80101890 <iupdate>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	e9 53 ff ff ff       	jmp    80105189 <sys_unlink+0xe9>
    return -1;
80105236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523b:	e9 71 ff ff ff       	jmp    801051b1 <sys_unlink+0x111>
    end_op();
80105240:	e8 ab dc ff ff       	call   80102ef0 <end_op>
    return -1;
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524a:	e9 62 ff ff ff       	jmp    801051b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	68 80 7c 10 80       	push   $0x80107c80
80105257:	e8 44 b2 ff ff       	call   801004a0 <panic>
    panic("unlink: nlink < 1");
8010525c:	83 ec 0c             	sub    $0xc,%esp
8010525f:	68 6e 7c 10 80       	push   $0x80107c6e
80105264:	e8 37 b2 ff ff       	call   801004a0 <panic>
    panic("unlink: writei");
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	68 92 7c 10 80       	push   $0x80107c92
80105271:	e8 2a b2 ff ff       	call   801004a0 <panic>
80105276:	8d 76 00             	lea    0x0(%esi),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_open>:

int
sys_open(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105286:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105289:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 3c f8 ff ff       	call   80104ad0 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 1d 01 00 00    	js     801053bc <sys_open+0x13c>
8010529f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052a2:	83 ec 08             	sub    $0x8,%esp
801052a5:	50                   	push   %eax
801052a6:	6a 01                	push   $0x1
801052a8:	e8 73 f7 ff ff       	call   80104a20 <argint>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	0f 88 04 01 00 00    	js     801053bc <sys_open+0x13c>
    return -1;

  begin_op();
801052b8:	e8 c3 db ff ff       	call   80102e80 <begin_op>

  if(omode & O_CREATE){
801052bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052c1:	0f 85 a9 00 00 00    	jne    80105370 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	ff 75 e0             	pushl  -0x20(%ebp)
801052cd:	e8 ce ce ff ff       	call   801021a0 <namei>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	89 c6                	mov    %eax,%esi
801052d9:	0f 84 b2 00 00 00    	je     80105391 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801052df:	83 ec 0c             	sub    $0xc,%esp
801052e2:	50                   	push   %eax
801052e3:	e8 58 c6 ff ff       	call   80101940 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052f0:	0f 84 aa 00 00 00    	je     801053a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052f6:	e8 95 bb ff ff       	call   80100e90 <filealloc>
801052fb:	85 c0                	test   %eax,%eax
801052fd:	89 c7                	mov    %eax,%edi
801052ff:	0f 84 a6 00 00 00    	je     801053ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105305:	e8 c6 e7 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010530a:	31 db                	xor    %ebx,%ebx
8010530c:	eb 0e                	jmp    8010531c <sys_open+0x9c>
8010530e:	66 90                	xchg   %ax,%ax
80105310:	83 c3 01             	add    $0x1,%ebx
80105313:	83 fb 10             	cmp    $0x10,%ebx
80105316:	0f 84 ac 00 00 00    	je     801053c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010531c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105320:	85 d2                	test   %edx,%edx
80105322:	75 ec                	jne    80105310 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105324:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105327:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010532b:	56                   	push   %esi
8010532c:	e8 ef c6 ff ff       	call   80101a20 <iunlock>
  end_op();
80105331:	e8 ba db ff ff       	call   80102ef0 <end_op>

  f->type = FD_INODE;
80105336:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010533c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010533f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105342:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105345:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010534c:	89 d0                	mov    %edx,%eax
8010534e:	f7 d0                	not    %eax
80105350:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105353:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105356:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105359:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010535d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105360:	89 d8                	mov    %ebx,%eax
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5f                   	pop    %edi
80105365:	5d                   	pop    %ebp
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105376:	31 c9                	xor    %ecx,%ecx
80105378:	6a 00                	push   $0x0
8010537a:	ba 02 00 00 00       	mov    $0x2,%edx
8010537f:	e8 ec f7 ff ff       	call   80104b70 <create>
    if(ip == 0){
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105389:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010538b:	0f 85 65 ff ff ff    	jne    801052f6 <sys_open+0x76>
      end_op();
80105391:	e8 5a db ff ff       	call   80102ef0 <end_op>
      return -1;
80105396:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010539b:	eb c0                	jmp    8010535d <sys_open+0xdd>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053a3:	85 c9                	test   %ecx,%ecx
801053a5:	0f 84 4b ff ff ff    	je     801052f6 <sys_open+0x76>
    iunlockput(ip);
801053ab:	83 ec 0c             	sub    $0xc,%esp
801053ae:	56                   	push   %esi
801053af:	e8 1c c8 ff ff       	call   80101bd0 <iunlockput>
    end_op();
801053b4:	e8 37 db ff ff       	call   80102ef0 <end_op>
    return -1;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053c1:	eb 9a                	jmp    8010535d <sys_open+0xdd>
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	57                   	push   %edi
801053cc:	e8 7f bb ff ff       	call   80100f50 <fileclose>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	eb d5                	jmp    801053ab <sys_open+0x12b>
801053d6:	8d 76 00             	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053e6:	e8 95 da ff ff       	call   80102e80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ee:	83 ec 08             	sub    $0x8,%esp
801053f1:	50                   	push   %eax
801053f2:	6a 00                	push   $0x0
801053f4:	e8 d7 f6 ff ff       	call   80104ad0 <argstr>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	78 30                	js     80105430 <sys_mkdir+0x50>
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105406:	31 c9                	xor    %ecx,%ecx
80105408:	6a 00                	push   $0x0
8010540a:	ba 01 00 00 00       	mov    $0x1,%edx
8010540f:	e8 5c f7 ff ff       	call   80104b70 <create>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	74 15                	je     80105430 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010541b:	83 ec 0c             	sub    $0xc,%esp
8010541e:	50                   	push   %eax
8010541f:	e8 ac c7 ff ff       	call   80101bd0 <iunlockput>
  end_op();
80105424:	e8 c7 da ff ff       	call   80102ef0 <end_op>
  return 0;
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	31 c0                	xor    %eax,%eax
}
8010542e:	c9                   	leave  
8010542f:	c3                   	ret    
    end_op();
80105430:	e8 bb da ff ff       	call   80102ef0 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543a:	c9                   	leave  
8010543b:	c3                   	ret    
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_mknod>:

int
sys_mknod(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105446:	e8 35 da ff ff       	call   80102e80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010544b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010544e:	83 ec 08             	sub    $0x8,%esp
80105451:	50                   	push   %eax
80105452:	6a 00                	push   $0x0
80105454:	e8 77 f6 ff ff       	call   80104ad0 <argstr>
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	85 c0                	test   %eax,%eax
8010545e:	78 60                	js     801054c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105463:	83 ec 08             	sub    $0x8,%esp
80105466:	50                   	push   %eax
80105467:	6a 01                	push   $0x1
80105469:	e8 b2 f5 ff ff       	call   80104a20 <argint>
  if((argstr(0, &path)) < 0 ||
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	85 c0                	test   %eax,%eax
80105473:	78 4b                	js     801054c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105475:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105478:	83 ec 08             	sub    $0x8,%esp
8010547b:	50                   	push   %eax
8010547c:	6a 02                	push   $0x2
8010547e:	e8 9d f5 ff ff       	call   80104a20 <argint>
     argint(1, &major) < 0 ||
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	78 36                	js     801054c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010548a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010548e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105491:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105495:	ba 03 00 00 00       	mov    $0x3,%edx
8010549a:	50                   	push   %eax
8010549b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010549e:	e8 cd f6 ff ff       	call   80104b70 <create>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	74 16                	je     801054c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054aa:	83 ec 0c             	sub    $0xc,%esp
801054ad:	50                   	push   %eax
801054ae:	e8 1d c7 ff ff       	call   80101bd0 <iunlockput>
  end_op();
801054b3:	e8 38 da ff ff       	call   80102ef0 <end_op>
  return 0;
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	31 c0                	xor    %eax,%eax
}
801054bd:	c9                   	leave  
801054be:	c3                   	ret    
801054bf:	90                   	nop
    end_op();
801054c0:	e8 2b da ff ff       	call   80102ef0 <end_op>
    return -1;
801054c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ca:	c9                   	leave  
801054cb:	c3                   	ret    
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_chdir>:

int
sys_chdir(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
801054d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054d8:	e8 f3 e5 ff ff       	call   80103ad0 <myproc>
801054dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054df:	e8 9c d9 ff ff       	call   80102e80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e7:	83 ec 08             	sub    $0x8,%esp
801054ea:	50                   	push   %eax
801054eb:	6a 00                	push   $0x0
801054ed:	e8 de f5 ff ff       	call   80104ad0 <argstr>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 77                	js     80105570 <sys_chdir+0xa0>
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	ff 75 f4             	pushl  -0xc(%ebp)
801054ff:	e8 9c cc ff ff       	call   801021a0 <namei>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	89 c3                	mov    %eax,%ebx
8010550b:	74 63                	je     80105570 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010550d:	83 ec 0c             	sub    $0xc,%esp
80105510:	50                   	push   %eax
80105511:	e8 2a c4 ff ff       	call   80101940 <ilock>
  if(ip->type != T_DIR){
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010551e:	75 30                	jne    80105550 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	53                   	push   %ebx
80105524:	e8 f7 c4 ff ff       	call   80101a20 <iunlock>
  iput(curproc->cwd);
80105529:	58                   	pop    %eax
8010552a:	ff 76 68             	pushl  0x68(%esi)
8010552d:	e8 3e c5 ff ff       	call   80101a70 <iput>
  end_op();
80105532:	e8 b9 d9 ff ff       	call   80102ef0 <end_op>
  curproc->cwd = ip;
80105537:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	31 c0                	xor    %eax,%eax
}
8010553f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105542:	5b                   	pop    %ebx
80105543:	5e                   	pop    %esi
80105544:	5d                   	pop    %ebp
80105545:	c3                   	ret    
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 77 c6 ff ff       	call   80101bd0 <iunlockput>
    end_op();
80105559:	e8 92 d9 ff ff       	call   80102ef0 <end_op>
    return -1;
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105566:	eb d7                	jmp    8010553f <sys_chdir+0x6f>
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105570:	e8 7b d9 ff ff       	call   80102ef0 <end_op>
    return -1;
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557a:	eb c3                	jmp    8010553f <sys_chdir+0x6f>
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exec>:

int
sys_exec(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105586:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010558c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105592:	50                   	push   %eax
80105593:	6a 00                	push   $0x0
80105595:	e8 36 f5 ff ff       	call   80104ad0 <argstr>
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	85 c0                	test   %eax,%eax
8010559f:	0f 88 87 00 00 00    	js     8010562c <sys_exec+0xac>
801055a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	50                   	push   %eax
801055af:	6a 01                	push   $0x1
801055b1:	e8 6a f4 ff ff       	call   80104a20 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 6f                	js     8010562c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801055c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055c8:	68 80 00 00 00       	push   $0x80
801055cd:	6a 00                	push   $0x0
801055cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055d5:	50                   	push   %eax
801055d6:	e8 45 f1 ff ff       	call   80104720 <memset>
801055db:	83 c4 10             	add    $0x10,%esp
801055de:	eb 2c                	jmp    8010560c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801055e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055e6:	85 c0                	test   %eax,%eax
801055e8:	74 56                	je     80105640 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055f6:	52                   	push   %edx
801055f7:	50                   	push   %eax
801055f8:	e8 b3 f3 ff ff       	call   801049b0 <fetchstr>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	78 28                	js     8010562c <sys_exec+0xac>
  for(i=0;; i++){
80105604:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105607:	83 fb 20             	cmp    $0x20,%ebx
8010560a:	74 20                	je     8010562c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010560c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105612:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105619:	83 ec 08             	sub    $0x8,%esp
8010561c:	57                   	push   %edi
8010561d:	01 f0                	add    %esi,%eax
8010561f:	50                   	push   %eax
80105620:	e8 4b f3 ff ff       	call   80104970 <fetchint>
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	85 c0                	test   %eax,%eax
8010562a:	79 b4                	jns    801055e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010562c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010562f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105634:	5b                   	pop    %ebx
80105635:	5e                   	pop    %esi
80105636:	5f                   	pop    %edi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105640:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105646:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105649:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105650:	00 00 00 00 
  return exec(path, argv);
80105654:	50                   	push   %eax
80105655:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010565b:	e8 c0 b4 ff ff       	call   80100b20 <exec>
80105660:	83 c4 10             	add    $0x10,%esp
}
80105663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	90                   	nop
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_pipe>:

int
sys_pipe(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105676:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105679:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010567c:	6a 08                	push   $0x8
8010567e:	50                   	push   %eax
8010567f:	6a 00                	push   $0x0
80105681:	e8 ea f3 ff ff       	call   80104a70 <argptr>
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	85 c0                	test   %eax,%eax
8010568b:	0f 88 ae 00 00 00    	js     8010573f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105691:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105694:	83 ec 08             	sub    $0x8,%esp
80105697:	50                   	push   %eax
80105698:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010569b:	50                   	push   %eax
8010569c:	e8 8f de ff ff       	call   80103530 <pipealloc>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	85 c0                	test   %eax,%eax
801056a6:	0f 88 93 00 00 00    	js     8010573f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056b1:	e8 1a e4 ff ff       	call   80103ad0 <myproc>
801056b6:	eb 10                	jmp    801056c8 <sys_pipe+0x58>
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c3 01             	add    $0x1,%ebx
801056c3:	83 fb 10             	cmp    $0x10,%ebx
801056c6:	74 60                	je     80105728 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801056c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056cc:	85 f6                	test   %esi,%esi
801056ce:	75 f0                	jne    801056c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801056d0:	8d 73 08             	lea    0x8(%ebx),%esi
801056d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056da:	e8 f1 e3 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056df:	31 d2                	xor    %edx,%edx
801056e1:	eb 0d                	jmp    801056f0 <sys_pipe+0x80>
801056e3:	90                   	nop
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e8:	83 c2 01             	add    $0x1,%edx
801056eb:	83 fa 10             	cmp    $0x10,%edx
801056ee:	74 28                	je     80105718 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801056f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056f4:	85 c9                	test   %ecx,%ecx
801056f6:	75 f0                	jne    801056e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801056f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105701:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105704:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105707:	31 c0                	xor    %eax,%eax
}
80105709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010570c:	5b                   	pop    %ebx
8010570d:	5e                   	pop    %esi
8010570e:	5f                   	pop    %edi
8010570f:	5d                   	pop    %ebp
80105710:	c3                   	ret    
80105711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105718:	e8 b3 e3 ff ff       	call   80103ad0 <myproc>
8010571d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105724:	00 
80105725:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	ff 75 e0             	pushl  -0x20(%ebp)
8010572e:	e8 1d b8 ff ff       	call   80100f50 <fileclose>
    fileclose(wf);
80105733:	58                   	pop    %eax
80105734:	ff 75 e4             	pushl  -0x1c(%ebp)
80105737:	e8 14 b8 ff ff       	call   80100f50 <fileclose>
    return -1;
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105744:	eb c3                	jmp    80105709 <sys_pipe+0x99>
80105746:	8d 76 00             	lea    0x0(%esi),%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <sys_bstat>:

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
80105750:	55                   	push   %ebp
	return numallocblocks;
}
80105751:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
{
80105756:	89 e5                	mov    %esp,%ebp
}
80105758:	5d                   	pop    %ebp
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105760 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int*)&addr) < 0)
80105766:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105769:	50                   	push   %eax
8010576a:	6a 00                	push   $0x0
8010576c:	e8 af f2 ff ff       	call   80104a20 <argint>

  // Invalidate the TLB 
  // invlpg((void *)addr); 

  return 0;
}
80105771:	c9                   	leave  
  if(argint(0, (int*)&addr) < 0)
80105772:	c1 f8 1f             	sar    $0x1f,%eax
}
80105775:	c3                   	ret    
80105776:	66 90                	xchg   %ax,%ax
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105783:	5d                   	pop    %ebp
  return fork();
80105784:	e9 b7 e4 ff ff       	jmp    80103c40 <fork>
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_exit>:

int
sys_exit(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  exit();
80105796:	e8 25 e7 ff ff       	call   80103ec0 <exit>
  return 0;  // not reached
}
8010579b:	31 c0                	xor    %eax,%eax
8010579d:	c9                   	leave  
8010579e:	c3                   	ret    
8010579f:	90                   	nop

801057a0 <sys_wait>:

int
sys_wait(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801057a3:	5d                   	pop    %ebp
  return wait();
801057a4:	e9 57 e9 ff ff       	jmp    80104100 <wait>
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_kill>:

int
sys_kill(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b9:	50                   	push   %eax
801057ba:	6a 00                	push   $0x0
801057bc:	e8 5f f2 ff ff       	call   80104a20 <argint>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 18                	js     801057e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	ff 75 f4             	pushl  -0xc(%ebp)
801057ce:	e8 8d ea ff ff       	call   80104260 <kill>
801057d3:	83 c4 10             	add    $0x10,%esp
}
801057d6:	c9                   	leave  
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_getpid>:

int
sys_getpid(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057f6:	e8 d5 e2 ff ff       	call   80103ad0 <myproc>
801057fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057fe:	c9                   	leave  
801057ff:	c3                   	ret    

80105800 <sys_sbrk>:

int
sys_sbrk(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105804:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105807:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010580a:	50                   	push   %eax
8010580b:	6a 00                	push   $0x0
8010580d:	e8 0e f2 ff ff       	call   80104a20 <argint>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	78 27                	js     80105840 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105819:	e8 b2 e2 ff ff       	call   80103ad0 <myproc>
  if(growproc(n) < 0)
8010581e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105821:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105823:	ff 75 f4             	pushl  -0xc(%ebp)
80105826:	e8 c5 e3 ff ff       	call   80103bf0 <growproc>
8010582b:	83 c4 10             	add    $0x10,%esp
8010582e:	85 c0                	test   %eax,%eax
80105830:	78 0e                	js     80105840 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105832:	89 d8                	mov    %ebx,%eax
80105834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105837:	c9                   	leave  
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105840:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105845:	eb eb                	jmp    80105832 <sys_sbrk+0x32>
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_sleep>:

int
sys_sleep(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105854:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105857:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010585a:	50                   	push   %eax
8010585b:	6a 00                	push   $0x0
8010585d:	e8 be f1 ff ff       	call   80104a20 <argint>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	0f 88 8a 00 00 00    	js     801058f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	68 60 4c 11 80       	push   $0x80114c60
80105875:	e8 26 ed ff ff       	call   801045a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010587a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010587d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105880:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105886:	85 d2                	test   %edx,%edx
80105888:	75 27                	jne    801058b1 <sys_sleep+0x61>
8010588a:	eb 54                	jmp    801058e0 <sys_sleep+0x90>
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105890:	83 ec 08             	sub    $0x8,%esp
80105893:	68 60 4c 11 80       	push   $0x80114c60
80105898:	68 a0 54 11 80       	push   $0x801154a0
8010589d:	e8 9e e7 ff ff       	call   80104040 <sleep>
  while(ticks - ticks0 < n){
801058a2:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	29 d8                	sub    %ebx,%eax
801058ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058af:	73 2f                	jae    801058e0 <sys_sleep+0x90>
    if(myproc()->killed){
801058b1:	e8 1a e2 ff ff       	call   80103ad0 <myproc>
801058b6:	8b 40 24             	mov    0x24(%eax),%eax
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 d3                	je     80105890 <sys_sleep+0x40>
      release(&tickslock);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	68 60 4c 11 80       	push   $0x80114c60
801058c5:	e8 f6 ed ff ff       	call   801046c0 <release>
      return -1;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801058d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	68 60 4c 11 80       	push   $0x80114c60
801058e8:	e8 d3 ed ff ff       	call   801046c0 <release>
  return 0;
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	31 c0                	xor    %eax,%eax
}
801058f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
    return -1;
801058f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fc:	eb f4                	jmp    801058f2 <sys_sleep+0xa2>
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
80105904:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105907:	68 60 4c 11 80       	push   $0x80114c60
8010590c:	e8 8f ec ff ff       	call   801045a0 <acquire>
  xticks = ticks;
80105911:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105917:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010591e:	e8 9d ed ff ff       	call   801046c0 <release>
  return xticks;
}
80105923:	89 d8                	mov    %ebx,%eax
80105925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105928:	c9                   	leave  
80105929:	c3                   	ret    

8010592a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010592a:	1e                   	push   %ds
  pushl %es
8010592b:	06                   	push   %es
  pushl %fs
8010592c:	0f a0                	push   %fs
  pushl %gs
8010592e:	0f a8                	push   %gs
  pushal
80105930:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105931:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105935:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105937:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105939:	54                   	push   %esp
  call trap
8010593a:	e8 c1 00 00 00       	call   80105a00 <trap>
  addl $4, %esp
8010593f:	83 c4 04             	add    $0x4,%esp

80105942 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105942:	61                   	popa   
  popl %gs
80105943:	0f a9                	pop    %gs
  popl %fs
80105945:	0f a1                	pop    %fs
  popl %es
80105947:	07                   	pop    %es
  popl %ds
80105948:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105949:	83 c4 08             	add    $0x8,%esp
  iret
8010594c:	cf                   	iret   
8010594d:	66 90                	xchg   %ax,%ax
8010594f:	90                   	nop

80105950 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105950:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105951:	31 c0                	xor    %eax,%eax
{
80105953:	89 e5                	mov    %esp,%ebp
80105955:	83 ec 08             	sub    $0x8,%esp
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105960:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105967:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010596e:	08 00 00 8e 
80105972:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105979:	80 
8010597a:	c1 ea 10             	shr    $0x10,%edx
8010597d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105984:	80 
  for(i = 0; i < 256; i++)
80105985:	83 c0 01             	add    $0x1,%eax
80105988:	3d 00 01 00 00       	cmp    $0x100,%eax
8010598d:	75 d1                	jne    80105960 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010598f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105994:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105997:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010599e:	00 00 ef 
  initlock(&tickslock, "time");
801059a1:	68 a1 7c 10 80       	push   $0x80107ca1
801059a6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059ab:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801059b1:	c1 e8 10             	shr    $0x10,%eax
801059b4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801059ba:	e8 f1 ea ff ff       	call   801044b0 <initlock>
}
801059bf:	83 c4 10             	add    $0x10,%esp
801059c2:	c9                   	leave  
801059c3:	c3                   	ret    
801059c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059d0 <idtinit>:

void
idtinit(void)
{
801059d0:	55                   	push   %ebp
  pd[0] = size-1;
801059d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059d6:	89 e5                	mov    %esp,%ebp
801059d8:	83 ec 10             	sub    $0x10,%esp
801059db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059df:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801059e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059e8:	c1 e8 10             	shr    $0x10,%eax
801059eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
80105a06:	83 ec 1c             	sub    $0x1c,%esp
80105a09:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105a0c:	8b 47 30             	mov    0x30(%edi),%eax
80105a0f:	83 f8 40             	cmp    $0x40,%eax
80105a12:	0f 84 f0 00 00 00    	je     80105b08 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a18:	83 e8 0e             	sub    $0xe,%eax
80105a1b:	83 f8 31             	cmp    $0x31,%eax
80105a1e:	77 10                	ja     80105a30 <trap+0x30>
80105a20:	ff 24 85 48 7d 10 80 	jmp    *-0x7fef82b8(,%eax,4)
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a30:	e8 9b e0 ff ff       	call   80103ad0 <myproc>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a3a:	0f 84 04 02 00 00    	je     80105c44 <trap+0x244>
80105a40:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a44:	0f 84 fa 01 00 00    	je     80105c44 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a4a:	0f 20 d1             	mov    %cr2,%ecx
80105a4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a50:	e8 5b e0 ff ff       	call   80103ab0 <cpuid>
80105a55:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a58:	8b 47 34             	mov    0x34(%edi),%eax
80105a5b:	8b 77 30             	mov    0x30(%edi),%esi
80105a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a61:	e8 6a e0 ff ff       	call   80103ad0 <myproc>
80105a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a69:	e8 62 e0 ff ff       	call   80103ad0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a74:	51                   	push   %ecx
80105a75:	53                   	push   %ebx
80105a76:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a77:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a7a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a7d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a7e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a81:	52                   	push   %edx
80105a82:	ff 70 10             	pushl  0x10(%eax)
80105a85:	68 04 7d 10 80       	push   $0x80107d04
80105a8a:	e8 e1 ac ff ff       	call   80100770 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a8f:	83 c4 20             	add    $0x20,%esp
80105a92:	e8 39 e0 ff ff       	call   80103ad0 <myproc>
80105a97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a9e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aa0:	e8 2b e0 ff ff       	call   80103ad0 <myproc>
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 1d                	je     80105ac6 <trap+0xc6>
80105aa9:	e8 22 e0 ff ff       	call   80103ad0 <myproc>
80105aae:	8b 50 24             	mov    0x24(%eax),%edx
80105ab1:	85 d2                	test   %edx,%edx
80105ab3:	74 11                	je     80105ac6 <trap+0xc6>
80105ab5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ab9:	83 e0 03             	and    $0x3,%eax
80105abc:	66 83 f8 03          	cmp    $0x3,%ax
80105ac0:	0f 84 3a 01 00 00    	je     80105c00 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ac6:	e8 05 e0 ff ff       	call   80103ad0 <myproc>
80105acb:	85 c0                	test   %eax,%eax
80105acd:	74 0b                	je     80105ada <trap+0xda>
80105acf:	e8 fc df ff ff       	call   80103ad0 <myproc>
80105ad4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ad8:	74 66                	je     80105b40 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ada:	e8 f1 df ff ff       	call   80103ad0 <myproc>
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	74 19                	je     80105afc <trap+0xfc>
80105ae3:	e8 e8 df ff ff       	call   80103ad0 <myproc>
80105ae8:	8b 40 24             	mov    0x24(%eax),%eax
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	74 0d                	je     80105afc <trap+0xfc>
80105aef:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105af3:	83 e0 03             	and    $0x3,%eax
80105af6:	66 83 f8 03          	cmp    $0x3,%ax
80105afa:	74 35                	je     80105b31 <trap+0x131>
    exit();
}
80105afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aff:	5b                   	pop    %ebx
80105b00:	5e                   	pop    %esi
80105b01:	5f                   	pop    %edi
80105b02:	5d                   	pop    %ebp
80105b03:	c3                   	ret    
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b08:	e8 c3 df ff ff       	call   80103ad0 <myproc>
80105b0d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b10:	85 db                	test   %ebx,%ebx
80105b12:	0f 85 d8 00 00 00    	jne    80105bf0 <trap+0x1f0>
    myproc()->tf = tf;
80105b18:	e8 b3 df ff ff       	call   80103ad0 <myproc>
80105b1d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105b20:	e8 eb ef ff ff       	call   80104b10 <syscall>
    if(myproc()->killed)
80105b25:	e8 a6 df ff ff       	call   80103ad0 <myproc>
80105b2a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b2d:	85 c9                	test   %ecx,%ecx
80105b2f:	74 cb                	je     80105afc <trap+0xfc>
}
80105b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b34:	5b                   	pop    %ebx
80105b35:	5e                   	pop    %esi
80105b36:	5f                   	pop    %edi
80105b37:	5d                   	pop    %ebp
      exit();
80105b38:	e9 83 e3 ff ff       	jmp    80103ec0 <exit>
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b44:	75 94                	jne    80105ada <trap+0xda>
    yield();
80105b46:	e8 a5 e4 ff ff       	call   80103ff0 <yield>
80105b4b:	eb 8d                	jmp    80105ada <trap+0xda>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
  	handle_pgfault();
80105b50:	e8 1b 02 00 00       	call   80105d70 <handle_pgfault>
  	break;
80105b55:	e9 46 ff ff ff       	jmp    80105aa0 <trap+0xa0>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b60:	e8 4b df ff ff       	call   80103ab0 <cpuid>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	0f 84 a3 00 00 00    	je     80105c10 <trap+0x210>
    lapiceoi();
80105b6d:	e8 be ce ff ff       	call   80102a30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b72:	e8 59 df ff ff       	call   80103ad0 <myproc>
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 85 2a ff ff ff    	jne    80105aa9 <trap+0xa9>
80105b7f:	e9 42 ff ff ff       	jmp    80105ac6 <trap+0xc6>
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b88:	e8 63 cd ff ff       	call   801028f0 <kbdintr>
    lapiceoi();
80105b8d:	e8 9e ce ff ff       	call   80102a30 <lapiceoi>
    break;
80105b92:	e9 09 ff ff ff       	jmp    80105aa0 <trap+0xa0>
80105b97:	89 f6                	mov    %esi,%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105ba0:	e8 3b 04 00 00       	call   80105fe0 <uartintr>
    lapiceoi();
80105ba5:	e8 86 ce ff ff       	call   80102a30 <lapiceoi>
    break;
80105baa:	e9 f1 fe ff ff       	jmp    80105aa0 <trap+0xa0>
80105baf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bb0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bb4:	8b 77 38             	mov    0x38(%edi),%esi
80105bb7:	e8 f4 de ff ff       	call   80103ab0 <cpuid>
80105bbc:	56                   	push   %esi
80105bbd:	53                   	push   %ebx
80105bbe:	50                   	push   %eax
80105bbf:	68 ac 7c 10 80       	push   $0x80107cac
80105bc4:	e8 a7 ab ff ff       	call   80100770 <cprintf>
    lapiceoi();
80105bc9:	e8 62 ce ff ff       	call   80102a30 <lapiceoi>
    break;
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	e9 ca fe ff ff       	jmp    80105aa0 <trap+0xa0>
80105bd6:	8d 76 00             	lea    0x0(%esi),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105be0:	e8 4b c7 ff ff       	call   80102330 <ideintr>
80105be5:	eb 86                	jmp    80105b6d <trap+0x16d>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105bf0:	e8 cb e2 ff ff       	call   80103ec0 <exit>
80105bf5:	e9 1e ff ff ff       	jmp    80105b18 <trap+0x118>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105c00:	e8 bb e2 ff ff       	call   80103ec0 <exit>
80105c05:	e9 bc fe ff ff       	jmp    80105ac6 <trap+0xc6>
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	68 60 4c 11 80       	push   $0x80114c60
80105c18:	e8 83 e9 ff ff       	call   801045a0 <acquire>
      wakeup(&ticks);
80105c1d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105c24:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105c2b:	e8 d0 e5 ff ff       	call   80104200 <wakeup>
      release(&tickslock);
80105c30:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105c37:	e8 84 ea ff ff       	call   801046c0 <release>
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	e9 29 ff ff ff       	jmp    80105b6d <trap+0x16d>
80105c44:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c47:	e8 64 de ff ff       	call   80103ab0 <cpuid>
80105c4c:	83 ec 0c             	sub    $0xc,%esp
80105c4f:	56                   	push   %esi
80105c50:	53                   	push   %ebx
80105c51:	50                   	push   %eax
80105c52:	ff 77 30             	pushl  0x30(%edi)
80105c55:	68 d0 7c 10 80       	push   $0x80107cd0
80105c5a:	e8 11 ab ff ff       	call   80100770 <cprintf>
      panic("trap");
80105c5f:	83 c4 14             	add    $0x14,%esp
80105c62:	68 a6 7c 10 80       	push   $0x80107ca6
80105c67:	e8 34 a8 ff ff       	call   801004a0 <panic>
80105c6c:	66 90                	xchg   %ax,%ax
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <swap_page_from_pte>:
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{	
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	83 ec 18             	sub    $0x18,%esp
80105c79:	8b 75 08             	mov    0x8(%ebp),%esi
	// Allocate a disk block to write

	uint block_addr = balloc_page(ROOTDEV);
80105c7c:	6a 01                	push   $0x1
80105c7e:	e8 3d b9 ff ff       	call   801015c0 <balloc_page>

	char *va = (char *)P2V(PTE_ADDR(*pte));
80105c83:	8b 3e                	mov    (%esi),%edi

	// cprintf("va: %x\n",va);

	// Writing the PTE into the disk block
	write_page_to_disk(ROOTDEV, va, block_addr);
80105c85:	83 c4 0c             	add    $0xc,%esp
	uint block_addr = balloc_page(ROOTDEV);
80105c88:	89 c3                	mov    %eax,%ebx
	write_page_to_disk(ROOTDEV, va, block_addr);
80105c8a:	50                   	push   %eax

	kfree(va);

	// Save the block id into PTE
	// Setting the swapped flag for the PTE
	uint Blk = block_addr << 12;
80105c8b:	c1 e3 0c             	shl    $0xc,%ebx

	*pte = Blk;

	// cprintf("Bit before : %x\n", *pte & PTE_P);

	*pte = *pte | PTE_SWP;
80105c8e:	80 cf 02             	or     $0x2,%bh
	char *va = (char *)P2V(PTE_ADDR(*pte));
80105c91:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80105c97:	81 c7 00 00 00 80    	add    $0x80000000,%edi
	write_page_to_disk(ROOTDEV, va, block_addr);
80105c9d:	57                   	push   %edi
80105c9e:	6a 01                	push   $0x1
80105ca0:	e8 fb a5 ff ff       	call   801002a0 <write_page_to_disk>
	kfree(va);
80105ca5:	89 3c 24             	mov    %edi,(%esp)
80105ca8:	e8 13 c9 ff ff       	call   801025c0 <kfree>
	*pte = *pte | PTE_SWP;
80105cad:	89 1e                	mov    %ebx,(%esi)

	// cprintf("Bit after : %x\n", *pte & PTE_P);



}
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb5:	5b                   	pop    %ebx
80105cb6:	5e                   	pop    %esi
80105cb7:	5f                   	pop    %edi
80105cb8:	5d                   	pop    %ebp
80105cb9:	c3                   	ret    
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cc0 <swap_page>:
/* Select a victim and swap the contents to the disk.
 */

int
swap_page(pde_t *pgdir)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 14             	sub    $0x14,%esp

	pte_t *victim = select_a_victim(pgdir);
80105cc6:	ff 75 08             	pushl  0x8(%ebp)
80105cc9:	e8 22 12 00 00       	call   80106ef0 <select_a_victim>

	// cprintf("Victim: %x\n" ,victim);
	
	swap_page_from_pte(victim);
80105cce:	89 04 24             	mov    %eax,(%esp)
80105cd1:	e8 9a ff ff ff       	call   80105c70 <swap_page_from_pte>

	return 1;
}
80105cd6:	b8 01 00 00 00       	mov    $0x1,%eax
80105cdb:	c9                   	leave  
80105cdc:	c3                   	ret    
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi

80105ce0 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
80105ce6:	83 ec 1c             	sub    $0x1c,%esp
80105ce9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105cec:	8b 75 08             	mov    0x8(%ebp),%esi
	struct proc *curproc = myproc();
80105cef:	e8 dc dd ff ff       	call   80103ad0 <myproc>
	uint blk = getswappedblk(pgdir,addr);
80105cf4:	83 ec 08             	sub    $0x8,%esp
	struct proc *curproc = myproc();
80105cf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint blk = getswappedblk(pgdir,addr);
80105cfa:	53                   	push   %ebx
80105cfb:	56                   	push   %esi
80105cfc:	e8 4f 12 00 00       	call   80106f50 <getswappedblk>
80105d01:	89 c7                	mov    %eax,%edi

	allocuvm(pgdir,addr,addr+PGSIZE);
80105d03:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80105d09:	83 c4 0c             	add    $0xc,%esp
80105d0c:	50                   	push   %eax
80105d0d:	53                   	push   %ebx
80105d0e:	56                   	push   %esi
80105d0f:	e8 6c 13 00 00       	call   80107080 <allocuvm>
	pte_t *ptentry = uva2pte(pgdir, addr);
80105d14:	58                   	pop    %eax
80105d15:	5a                   	pop    %edx
80105d16:	53                   	push   %ebx
80105d17:	56                   	push   %esi
80105d18:	e8 e3 16 00 00       	call   80107400 <uva2pte>

	switchuvm(curproc);
80105d1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	pte_t *ptentry = uva2pte(pgdir, addr);
80105d20:	89 c3                	mov    %eax,%ebx
	switchuvm(curproc);
80105d22:	89 14 24             	mov    %edx,(%esp)
80105d25:	e8 16 0f 00 00       	call   80106c40 <switchuvm>

	// if blk was not -1, read_page_from_disk
	if ( blk != -1 )
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	83 ff ff             	cmp    $0xffffffff,%edi
80105d30:	74 36                	je     80105d68 <map_address+0x88>
	{	
		
		char *pg = P2V(PTE_ADDR(*ptentry));
		read_page_from_disk(ROOTDEV,pg,blk);
80105d32:	83 ec 04             	sub    $0x4,%esp
80105d35:	57                   	push   %edi
		char *pg = P2V(PTE_ADDR(*ptentry));
80105d36:	8b 03                	mov    (%ebx),%eax
80105d38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105d3d:	05 00 00 00 80       	add    $0x80000000,%eax
		read_page_from_disk(ROOTDEV,pg,blk);
80105d42:	50                   	push   %eax
80105d43:	6a 01                	push   $0x1
80105d45:	e8 c6 a5 ff ff       	call   80100310 <read_page_from_disk>
		bfree_page(ROOTDEV,blk);
80105d4a:	89 7d 0c             	mov    %edi,0xc(%ebp)
80105d4d:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
80105d54:	83 c4 10             	add    $0x10,%esp
		
	}
}
80105d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d5a:	5b                   	pop    %ebx
80105d5b:	5e                   	pop    %esi
80105d5c:	5f                   	pop    %edi
80105d5d:	5d                   	pop    %ebp
		bfree_page(ROOTDEV,blk);
80105d5e:	e9 ad b9 ff ff       	jmp    80101710 <bfree_page>
80105d63:	90                   	nop
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80105d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6b:	5b                   	pop    %ebx
80105d6c:	5e                   	pop    %esi
80105d6d:	5f                   	pop    %edi
80105d6e:	5d                   	pop    %ebp
80105d6f:	c3                   	ret    

80105d70 <handle_pgfault>:

/* page fault handler */
void
handle_pgfault()
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105d76:	e8 55 dd ff ff       	call   80103ad0 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105d7b:	0f 20 d2             	mov    %cr2,%edx
	addr &= ~0xfff;

	map_address(curproc->pgdir, addr);
80105d7e:	83 ec 08             	sub    $0x8,%esp
	addr &= ~0xfff;
80105d81:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	map_address(curproc->pgdir, addr);
80105d87:	52                   	push   %edx
80105d88:	ff 70 04             	pushl  0x4(%eax)
80105d8b:	e8 50 ff ff ff       	call   80105ce0 <map_address>

}
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	c9                   	leave  
80105d94:	c3                   	ret    
80105d95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <map_address2>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address2(pde_t *pgdir, uint addr)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	83 ec 0c             	sub    $0xc,%esp
80105da9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105dac:	8b 75 08             	mov    0x8(%ebp),%esi
	// Check if it was previously swapped and restore contents
	pde_t *pde;

	pde = &pgdir[PDX(addr)];
80105daf:	89 d8                	mov    %ebx,%eax
80105db1:	c1 e8 16             	shr    $0x16,%eax
	pte_t *pgtab;
	pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105db4:	8b 14 86             	mov    (%esi,%eax,4),%edx
	pte_t *pte = &pgtab[PTX(addr)];
80105db7:	89 d8                	mov    %ebx,%eax
80105db9:	c1 e8 0a             	shr    $0xa,%eax
80105dbc:	25 fc 0f 00 00       	and    $0xffc,%eax
	pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105dc1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	pte_t *pte = &pgtab[PTX(addr)];
80105dc7:	8d bc 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edi

	
	if (*pte & PTE_SWP)
80105dce:	8b 07                	mov    (%edi),%eax
80105dd0:	f6 c4 02             	test   $0x2,%ah
80105dd3:	74 33                	je     80105e08 <map_address2+0x68>
	{
		uint block_addr = *pte >> 10;
80105dd5:	c1 e8 0a             	shr    $0xa,%eax
80105dd8:	89 c3                	mov    %eax,%ebx



		char * addr = kalloc();
80105dda:	e8 c1 c9 ff ff       	call   801027a0 <kalloc>
		if (addr == 0)
80105ddf:	85 c0                	test   %eax,%eax
80105de1:	74 6d                	je     80105e50 <map_address2+0xb0>
		{
			swap_page(pgdir);
			addr = kalloc();
		}
		*pte = *addr | PTE_P;
80105de3:	0f b6 10             	movzbl (%eax),%edx
		// cprintf("got the swapped page!!");
		read_page_from_disk(ROOTDEV,addr,block_addr);
80105de6:	83 ec 04             	sub    $0x4,%esp
		*pte = *addr | PTE_P;
80105de9:	83 ca 01             	or     $0x1,%edx
80105dec:	0f be d2             	movsbl %dl,%edx
80105def:	89 17                	mov    %edx,(%edi)
		read_page_from_disk(ROOTDEV,addr,block_addr);
80105df1:	53                   	push   %ebx
80105df2:	50                   	push   %eax
80105df3:	6a 01                	push   $0x1
80105df5:	e8 16 a5 ff ff       	call   80100310 <read_page_from_disk>
80105dfa:	83 c4 10             	add    $0x10,%esp
			// cprintf("Allocated again!!");
		}
	}
	

}
80105dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e00:	5b                   	pop    %ebx
80105e01:	5e                   	pop    %esi
80105e02:	5f                   	pop    %edi
80105e03:	5d                   	pop    %ebp
80105e04:	c3                   	ret    
80105e05:	8d 76 00             	lea    0x0(%esi),%esi
		if(allocuvm(pgdir,addr,addr + PGSIZE) == 0){
80105e08:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
80105e0e:	83 ec 04             	sub    $0x4,%esp
80105e11:	57                   	push   %edi
80105e12:	53                   	push   %ebx
80105e13:	56                   	push   %esi
80105e14:	e8 67 12 00 00       	call   80107080 <allocuvm>
80105e19:	83 c4 10             	add    $0x10,%esp
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	75 dd                	jne    80105dfd <map_address2+0x5d>
	pte_t *victim = select_a_victim(pgdir);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	56                   	push   %esi
80105e24:	e8 c7 10 00 00       	call   80106ef0 <select_a_victim>
	swap_page_from_pte(victim);
80105e29:	89 04 24             	mov    %eax,(%esp)
80105e2c:	e8 3f fe ff ff       	call   80105c70 <swap_page_from_pte>
			allocuvm(pgdir,addr,addr + PGSIZE);
80105e31:	83 c4 0c             	add    $0xc,%esp
80105e34:	57                   	push   %edi
80105e35:	53                   	push   %ebx
80105e36:	56                   	push   %esi
80105e37:	e8 44 12 00 00       	call   80107080 <allocuvm>
80105e3c:	83 c4 10             	add    $0x10,%esp
}
80105e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e42:	5b                   	pop    %ebx
80105e43:	5e                   	pop    %esi
80105e44:	5f                   	pop    %edi
80105e45:	5d                   	pop    %ebp
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	pte_t *victim = select_a_victim(pgdir);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	56                   	push   %esi
80105e54:	e8 97 10 00 00       	call   80106ef0 <select_a_victim>
	swap_page_from_pte(victim);
80105e59:	89 04 24             	mov    %eax,(%esp)
80105e5c:	e8 0f fe ff ff       	call   80105c70 <swap_page_from_pte>
			addr = kalloc();
80105e61:	e8 3a c9 ff ff       	call   801027a0 <kalloc>
80105e66:	83 c4 10             	add    $0x10,%esp
80105e69:	e9 75 ff ff ff       	jmp    80105de3 <map_address2+0x43>
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e70:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105e75:	55                   	push   %ebp
80105e76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e78:	85 c0                	test   %eax,%eax
80105e7a:	74 1c                	je     80105e98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e82:	a8 01                	test   $0x1,%al
80105e84:	74 12                	je     80105e98 <uartgetc+0x28>
80105e86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e8c:	0f b6 c0             	movzbl %al,%eax
}
80105e8f:	5d                   	pop    %ebp
80105e90:	c3                   	ret    
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e9d:	5d                   	pop    %ebp
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop

80105ea0 <uartputc.part.0>:
uartputc(int c)
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	89 c7                	mov    %eax,%edi
80105ea8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ead:	be fd 03 00 00       	mov    $0x3fd,%esi
80105eb2:	83 ec 0c             	sub    $0xc,%esp
80105eb5:	eb 1b                	jmp    80105ed2 <uartputc.part.0+0x32>
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	6a 0a                	push   $0xa
80105ec5:	e8 86 cb ff ff       	call   80102a50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	83 eb 01             	sub    $0x1,%ebx
80105ed0:	74 07                	je     80105ed9 <uartputc.part.0+0x39>
80105ed2:	89 f2                	mov    %esi,%edx
80105ed4:	ec                   	in     (%dx),%al
80105ed5:	a8 20                	test   $0x20,%al
80105ed7:	74 e7                	je     80105ec0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ed9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ede:	89 f8                	mov    %edi,%eax
80105ee0:	ee                   	out    %al,(%dx)
}
80105ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee4:	5b                   	pop    %ebx
80105ee5:	5e                   	pop    %esi
80105ee6:	5f                   	pop    %edi
80105ee7:	5d                   	pop    %ebp
80105ee8:	c3                   	ret    
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <uartinit>:
{
80105ef0:	55                   	push   %ebp
80105ef1:	31 c9                	xor    %ecx,%ecx
80105ef3:	89 c8                	mov    %ecx,%eax
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	57                   	push   %edi
80105ef8:	56                   	push   %esi
80105ef9:	53                   	push   %ebx
80105efa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105eff:	89 da                	mov    %ebx,%edx
80105f01:	83 ec 0c             	sub    $0xc,%esp
80105f04:	ee                   	out    %al,(%dx)
80105f05:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f0f:	89 fa                	mov    %edi,%edx
80105f11:	ee                   	out    %al,(%dx)
80105f12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1c:	ee                   	out    %al,(%dx)
80105f1d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f22:	89 c8                	mov    %ecx,%eax
80105f24:	89 f2                	mov    %esi,%edx
80105f26:	ee                   	out    %al,(%dx)
80105f27:	b8 03 00 00 00       	mov    $0x3,%eax
80105f2c:	89 fa                	mov    %edi,%edx
80105f2e:	ee                   	out    %al,(%dx)
80105f2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f34:	89 c8                	mov    %ecx,%eax
80105f36:	ee                   	out    %al,(%dx)
80105f37:	b8 01 00 00 00       	mov    $0x1,%eax
80105f3c:	89 f2                	mov    %esi,%edx
80105f3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f45:	3c ff                	cmp    $0xff,%al
80105f47:	74 5a                	je     80105fa3 <uartinit+0xb3>
  uart = 1;
80105f49:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f50:	00 00 00 
80105f53:	89 da                	mov    %ebx,%edx
80105f55:	ec                   	in     (%dx),%al
80105f56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f5c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f5f:	bb 10 7e 10 80       	mov    $0x80107e10,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f64:	6a 00                	push   $0x0
80105f66:	6a 04                	push   $0x4
80105f68:	e8 13 c6 ff ff       	call   80102580 <ioapicenable>
80105f6d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f70:	b8 78 00 00 00       	mov    $0x78,%eax
80105f75:	eb 13                	jmp    80105f8a <uartinit+0x9a>
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f80:	83 c3 01             	add    $0x1,%ebx
80105f83:	0f be 03             	movsbl (%ebx),%eax
80105f86:	84 c0                	test   %al,%al
80105f88:	74 19                	je     80105fa3 <uartinit+0xb3>
  if(!uart)
80105f8a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105f90:	85 d2                	test   %edx,%edx
80105f92:	74 ec                	je     80105f80 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105f94:	83 c3 01             	add    $0x1,%ebx
80105f97:	e8 04 ff ff ff       	call   80105ea0 <uartputc.part.0>
80105f9c:	0f be 03             	movsbl (%ebx),%eax
80105f9f:	84 c0                	test   %al,%al
80105fa1:	75 e7                	jne    80105f8a <uartinit+0x9a>
}
80105fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa6:	5b                   	pop    %ebx
80105fa7:	5e                   	pop    %esi
80105fa8:	5f                   	pop    %edi
80105fa9:	5d                   	pop    %ebp
80105faa:	c3                   	ret    
80105fab:	90                   	nop
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <uartputc>:
  if(!uart)
80105fb0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105fb6:	55                   	push   %ebp
80105fb7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fb9:	85 d2                	test   %edx,%edx
{
80105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105fbe:	74 10                	je     80105fd0 <uartputc+0x20>
}
80105fc0:	5d                   	pop    %ebp
80105fc1:	e9 da fe ff ff       	jmp    80105ea0 <uartputc.part.0>
80105fc6:	8d 76 00             	lea    0x0(%esi),%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fd0:	5d                   	pop    %ebp
80105fd1:	c3                   	ret    
80105fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <uartintr>:

void
uartintr(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fe6:	68 70 5e 10 80       	push   $0x80105e70
80105feb:	e8 30 a9 ff ff       	call   80100920 <consoleintr>
}
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	c9                   	leave  
80105ff4:	c3                   	ret    

80105ff5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $0
80105ff7:	6a 00                	push   $0x0
  jmp alltraps
80105ff9:	e9 2c f9 ff ff       	jmp    8010592a <alltraps>

80105ffe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $1
80106000:	6a 01                	push   $0x1
  jmp alltraps
80106002:	e9 23 f9 ff ff       	jmp    8010592a <alltraps>

80106007 <vector2>:
.globl vector2
vector2:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $2
80106009:	6a 02                	push   $0x2
  jmp alltraps
8010600b:	e9 1a f9 ff ff       	jmp    8010592a <alltraps>

80106010 <vector3>:
.globl vector3
vector3:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $3
80106012:	6a 03                	push   $0x3
  jmp alltraps
80106014:	e9 11 f9 ff ff       	jmp    8010592a <alltraps>

80106019 <vector4>:
.globl vector4
vector4:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $4
8010601b:	6a 04                	push   $0x4
  jmp alltraps
8010601d:	e9 08 f9 ff ff       	jmp    8010592a <alltraps>

80106022 <vector5>:
.globl vector5
vector5:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $5
80106024:	6a 05                	push   $0x5
  jmp alltraps
80106026:	e9 ff f8 ff ff       	jmp    8010592a <alltraps>

8010602b <vector6>:
.globl vector6
vector6:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $6
8010602d:	6a 06                	push   $0x6
  jmp alltraps
8010602f:	e9 f6 f8 ff ff       	jmp    8010592a <alltraps>

80106034 <vector7>:
.globl vector7
vector7:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $7
80106036:	6a 07                	push   $0x7
  jmp alltraps
80106038:	e9 ed f8 ff ff       	jmp    8010592a <alltraps>

8010603d <vector8>:
.globl vector8
vector8:
  pushl $8
8010603d:	6a 08                	push   $0x8
  jmp alltraps
8010603f:	e9 e6 f8 ff ff       	jmp    8010592a <alltraps>

80106044 <vector9>:
.globl vector9
vector9:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $9
80106046:	6a 09                	push   $0x9
  jmp alltraps
80106048:	e9 dd f8 ff ff       	jmp    8010592a <alltraps>

8010604d <vector10>:
.globl vector10
vector10:
  pushl $10
8010604d:	6a 0a                	push   $0xa
  jmp alltraps
8010604f:	e9 d6 f8 ff ff       	jmp    8010592a <alltraps>

80106054 <vector11>:
.globl vector11
vector11:
  pushl $11
80106054:	6a 0b                	push   $0xb
  jmp alltraps
80106056:	e9 cf f8 ff ff       	jmp    8010592a <alltraps>

8010605b <vector12>:
.globl vector12
vector12:
  pushl $12
8010605b:	6a 0c                	push   $0xc
  jmp alltraps
8010605d:	e9 c8 f8 ff ff       	jmp    8010592a <alltraps>

80106062 <vector13>:
.globl vector13
vector13:
  pushl $13
80106062:	6a 0d                	push   $0xd
  jmp alltraps
80106064:	e9 c1 f8 ff ff       	jmp    8010592a <alltraps>

80106069 <vector14>:
.globl vector14
vector14:
  pushl $14
80106069:	6a 0e                	push   $0xe
  jmp alltraps
8010606b:	e9 ba f8 ff ff       	jmp    8010592a <alltraps>

80106070 <vector15>:
.globl vector15
vector15:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $15
80106072:	6a 0f                	push   $0xf
  jmp alltraps
80106074:	e9 b1 f8 ff ff       	jmp    8010592a <alltraps>

80106079 <vector16>:
.globl vector16
vector16:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $16
8010607b:	6a 10                	push   $0x10
  jmp alltraps
8010607d:	e9 a8 f8 ff ff       	jmp    8010592a <alltraps>

80106082 <vector17>:
.globl vector17
vector17:
  pushl $17
80106082:	6a 11                	push   $0x11
  jmp alltraps
80106084:	e9 a1 f8 ff ff       	jmp    8010592a <alltraps>

80106089 <vector18>:
.globl vector18
vector18:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $18
8010608b:	6a 12                	push   $0x12
  jmp alltraps
8010608d:	e9 98 f8 ff ff       	jmp    8010592a <alltraps>

80106092 <vector19>:
.globl vector19
vector19:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $19
80106094:	6a 13                	push   $0x13
  jmp alltraps
80106096:	e9 8f f8 ff ff       	jmp    8010592a <alltraps>

8010609b <vector20>:
.globl vector20
vector20:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $20
8010609d:	6a 14                	push   $0x14
  jmp alltraps
8010609f:	e9 86 f8 ff ff       	jmp    8010592a <alltraps>

801060a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $21
801060a6:	6a 15                	push   $0x15
  jmp alltraps
801060a8:	e9 7d f8 ff ff       	jmp    8010592a <alltraps>

801060ad <vector22>:
.globl vector22
vector22:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $22
801060af:	6a 16                	push   $0x16
  jmp alltraps
801060b1:	e9 74 f8 ff ff       	jmp    8010592a <alltraps>

801060b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $23
801060b8:	6a 17                	push   $0x17
  jmp alltraps
801060ba:	e9 6b f8 ff ff       	jmp    8010592a <alltraps>

801060bf <vector24>:
.globl vector24
vector24:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $24
801060c1:	6a 18                	push   $0x18
  jmp alltraps
801060c3:	e9 62 f8 ff ff       	jmp    8010592a <alltraps>

801060c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $25
801060ca:	6a 19                	push   $0x19
  jmp alltraps
801060cc:	e9 59 f8 ff ff       	jmp    8010592a <alltraps>

801060d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $26
801060d3:	6a 1a                	push   $0x1a
  jmp alltraps
801060d5:	e9 50 f8 ff ff       	jmp    8010592a <alltraps>

801060da <vector27>:
.globl vector27
vector27:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $27
801060dc:	6a 1b                	push   $0x1b
  jmp alltraps
801060de:	e9 47 f8 ff ff       	jmp    8010592a <alltraps>

801060e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $28
801060e5:	6a 1c                	push   $0x1c
  jmp alltraps
801060e7:	e9 3e f8 ff ff       	jmp    8010592a <alltraps>

801060ec <vector29>:
.globl vector29
vector29:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $29
801060ee:	6a 1d                	push   $0x1d
  jmp alltraps
801060f0:	e9 35 f8 ff ff       	jmp    8010592a <alltraps>

801060f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $30
801060f7:	6a 1e                	push   $0x1e
  jmp alltraps
801060f9:	e9 2c f8 ff ff       	jmp    8010592a <alltraps>

801060fe <vector31>:
.globl vector31
vector31:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $31
80106100:	6a 1f                	push   $0x1f
  jmp alltraps
80106102:	e9 23 f8 ff ff       	jmp    8010592a <alltraps>

80106107 <vector32>:
.globl vector32
vector32:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $32
80106109:	6a 20                	push   $0x20
  jmp alltraps
8010610b:	e9 1a f8 ff ff       	jmp    8010592a <alltraps>

80106110 <vector33>:
.globl vector33
vector33:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $33
80106112:	6a 21                	push   $0x21
  jmp alltraps
80106114:	e9 11 f8 ff ff       	jmp    8010592a <alltraps>

80106119 <vector34>:
.globl vector34
vector34:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $34
8010611b:	6a 22                	push   $0x22
  jmp alltraps
8010611d:	e9 08 f8 ff ff       	jmp    8010592a <alltraps>

80106122 <vector35>:
.globl vector35
vector35:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $35
80106124:	6a 23                	push   $0x23
  jmp alltraps
80106126:	e9 ff f7 ff ff       	jmp    8010592a <alltraps>

8010612b <vector36>:
.globl vector36
vector36:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $36
8010612d:	6a 24                	push   $0x24
  jmp alltraps
8010612f:	e9 f6 f7 ff ff       	jmp    8010592a <alltraps>

80106134 <vector37>:
.globl vector37
vector37:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $37
80106136:	6a 25                	push   $0x25
  jmp alltraps
80106138:	e9 ed f7 ff ff       	jmp    8010592a <alltraps>

8010613d <vector38>:
.globl vector38
vector38:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $38
8010613f:	6a 26                	push   $0x26
  jmp alltraps
80106141:	e9 e4 f7 ff ff       	jmp    8010592a <alltraps>

80106146 <vector39>:
.globl vector39
vector39:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $39
80106148:	6a 27                	push   $0x27
  jmp alltraps
8010614a:	e9 db f7 ff ff       	jmp    8010592a <alltraps>

8010614f <vector40>:
.globl vector40
vector40:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $40
80106151:	6a 28                	push   $0x28
  jmp alltraps
80106153:	e9 d2 f7 ff ff       	jmp    8010592a <alltraps>

80106158 <vector41>:
.globl vector41
vector41:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $41
8010615a:	6a 29                	push   $0x29
  jmp alltraps
8010615c:	e9 c9 f7 ff ff       	jmp    8010592a <alltraps>

80106161 <vector42>:
.globl vector42
vector42:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $42
80106163:	6a 2a                	push   $0x2a
  jmp alltraps
80106165:	e9 c0 f7 ff ff       	jmp    8010592a <alltraps>

8010616a <vector43>:
.globl vector43
vector43:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $43
8010616c:	6a 2b                	push   $0x2b
  jmp alltraps
8010616e:	e9 b7 f7 ff ff       	jmp    8010592a <alltraps>

80106173 <vector44>:
.globl vector44
vector44:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $44
80106175:	6a 2c                	push   $0x2c
  jmp alltraps
80106177:	e9 ae f7 ff ff       	jmp    8010592a <alltraps>

8010617c <vector45>:
.globl vector45
vector45:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $45
8010617e:	6a 2d                	push   $0x2d
  jmp alltraps
80106180:	e9 a5 f7 ff ff       	jmp    8010592a <alltraps>

80106185 <vector46>:
.globl vector46
vector46:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $46
80106187:	6a 2e                	push   $0x2e
  jmp alltraps
80106189:	e9 9c f7 ff ff       	jmp    8010592a <alltraps>

8010618e <vector47>:
.globl vector47
vector47:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $47
80106190:	6a 2f                	push   $0x2f
  jmp alltraps
80106192:	e9 93 f7 ff ff       	jmp    8010592a <alltraps>

80106197 <vector48>:
.globl vector48
vector48:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $48
80106199:	6a 30                	push   $0x30
  jmp alltraps
8010619b:	e9 8a f7 ff ff       	jmp    8010592a <alltraps>

801061a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $49
801061a2:	6a 31                	push   $0x31
  jmp alltraps
801061a4:	e9 81 f7 ff ff       	jmp    8010592a <alltraps>

801061a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $50
801061ab:	6a 32                	push   $0x32
  jmp alltraps
801061ad:	e9 78 f7 ff ff       	jmp    8010592a <alltraps>

801061b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $51
801061b4:	6a 33                	push   $0x33
  jmp alltraps
801061b6:	e9 6f f7 ff ff       	jmp    8010592a <alltraps>

801061bb <vector52>:
.globl vector52
vector52:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $52
801061bd:	6a 34                	push   $0x34
  jmp alltraps
801061bf:	e9 66 f7 ff ff       	jmp    8010592a <alltraps>

801061c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $53
801061c6:	6a 35                	push   $0x35
  jmp alltraps
801061c8:	e9 5d f7 ff ff       	jmp    8010592a <alltraps>

801061cd <vector54>:
.globl vector54
vector54:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $54
801061cf:	6a 36                	push   $0x36
  jmp alltraps
801061d1:	e9 54 f7 ff ff       	jmp    8010592a <alltraps>

801061d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $55
801061d8:	6a 37                	push   $0x37
  jmp alltraps
801061da:	e9 4b f7 ff ff       	jmp    8010592a <alltraps>

801061df <vector56>:
.globl vector56
vector56:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $56
801061e1:	6a 38                	push   $0x38
  jmp alltraps
801061e3:	e9 42 f7 ff ff       	jmp    8010592a <alltraps>

801061e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $57
801061ea:	6a 39                	push   $0x39
  jmp alltraps
801061ec:	e9 39 f7 ff ff       	jmp    8010592a <alltraps>

801061f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $58
801061f3:	6a 3a                	push   $0x3a
  jmp alltraps
801061f5:	e9 30 f7 ff ff       	jmp    8010592a <alltraps>

801061fa <vector59>:
.globl vector59
vector59:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $59
801061fc:	6a 3b                	push   $0x3b
  jmp alltraps
801061fe:	e9 27 f7 ff ff       	jmp    8010592a <alltraps>

80106203 <vector60>:
.globl vector60
vector60:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $60
80106205:	6a 3c                	push   $0x3c
  jmp alltraps
80106207:	e9 1e f7 ff ff       	jmp    8010592a <alltraps>

8010620c <vector61>:
.globl vector61
vector61:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $61
8010620e:	6a 3d                	push   $0x3d
  jmp alltraps
80106210:	e9 15 f7 ff ff       	jmp    8010592a <alltraps>

80106215 <vector62>:
.globl vector62
vector62:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $62
80106217:	6a 3e                	push   $0x3e
  jmp alltraps
80106219:	e9 0c f7 ff ff       	jmp    8010592a <alltraps>

8010621e <vector63>:
.globl vector63
vector63:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $63
80106220:	6a 3f                	push   $0x3f
  jmp alltraps
80106222:	e9 03 f7 ff ff       	jmp    8010592a <alltraps>

80106227 <vector64>:
.globl vector64
vector64:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $64
80106229:	6a 40                	push   $0x40
  jmp alltraps
8010622b:	e9 fa f6 ff ff       	jmp    8010592a <alltraps>

80106230 <vector65>:
.globl vector65
vector65:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $65
80106232:	6a 41                	push   $0x41
  jmp alltraps
80106234:	e9 f1 f6 ff ff       	jmp    8010592a <alltraps>

80106239 <vector66>:
.globl vector66
vector66:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $66
8010623b:	6a 42                	push   $0x42
  jmp alltraps
8010623d:	e9 e8 f6 ff ff       	jmp    8010592a <alltraps>

80106242 <vector67>:
.globl vector67
vector67:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $67
80106244:	6a 43                	push   $0x43
  jmp alltraps
80106246:	e9 df f6 ff ff       	jmp    8010592a <alltraps>

8010624b <vector68>:
.globl vector68
vector68:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $68
8010624d:	6a 44                	push   $0x44
  jmp alltraps
8010624f:	e9 d6 f6 ff ff       	jmp    8010592a <alltraps>

80106254 <vector69>:
.globl vector69
vector69:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $69
80106256:	6a 45                	push   $0x45
  jmp alltraps
80106258:	e9 cd f6 ff ff       	jmp    8010592a <alltraps>

8010625d <vector70>:
.globl vector70
vector70:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $70
8010625f:	6a 46                	push   $0x46
  jmp alltraps
80106261:	e9 c4 f6 ff ff       	jmp    8010592a <alltraps>

80106266 <vector71>:
.globl vector71
vector71:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $71
80106268:	6a 47                	push   $0x47
  jmp alltraps
8010626a:	e9 bb f6 ff ff       	jmp    8010592a <alltraps>

8010626f <vector72>:
.globl vector72
vector72:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $72
80106271:	6a 48                	push   $0x48
  jmp alltraps
80106273:	e9 b2 f6 ff ff       	jmp    8010592a <alltraps>

80106278 <vector73>:
.globl vector73
vector73:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $73
8010627a:	6a 49                	push   $0x49
  jmp alltraps
8010627c:	e9 a9 f6 ff ff       	jmp    8010592a <alltraps>

80106281 <vector74>:
.globl vector74
vector74:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $74
80106283:	6a 4a                	push   $0x4a
  jmp alltraps
80106285:	e9 a0 f6 ff ff       	jmp    8010592a <alltraps>

8010628a <vector75>:
.globl vector75
vector75:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $75
8010628c:	6a 4b                	push   $0x4b
  jmp alltraps
8010628e:	e9 97 f6 ff ff       	jmp    8010592a <alltraps>

80106293 <vector76>:
.globl vector76
vector76:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $76
80106295:	6a 4c                	push   $0x4c
  jmp alltraps
80106297:	e9 8e f6 ff ff       	jmp    8010592a <alltraps>

8010629c <vector77>:
.globl vector77
vector77:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $77
8010629e:	6a 4d                	push   $0x4d
  jmp alltraps
801062a0:	e9 85 f6 ff ff       	jmp    8010592a <alltraps>

801062a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $78
801062a7:	6a 4e                	push   $0x4e
  jmp alltraps
801062a9:	e9 7c f6 ff ff       	jmp    8010592a <alltraps>

801062ae <vector79>:
.globl vector79
vector79:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $79
801062b0:	6a 4f                	push   $0x4f
  jmp alltraps
801062b2:	e9 73 f6 ff ff       	jmp    8010592a <alltraps>

801062b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $80
801062b9:	6a 50                	push   $0x50
  jmp alltraps
801062bb:	e9 6a f6 ff ff       	jmp    8010592a <alltraps>

801062c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $81
801062c2:	6a 51                	push   $0x51
  jmp alltraps
801062c4:	e9 61 f6 ff ff       	jmp    8010592a <alltraps>

801062c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $82
801062cb:	6a 52                	push   $0x52
  jmp alltraps
801062cd:	e9 58 f6 ff ff       	jmp    8010592a <alltraps>

801062d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $83
801062d4:	6a 53                	push   $0x53
  jmp alltraps
801062d6:	e9 4f f6 ff ff       	jmp    8010592a <alltraps>

801062db <vector84>:
.globl vector84
vector84:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $84
801062dd:	6a 54                	push   $0x54
  jmp alltraps
801062df:	e9 46 f6 ff ff       	jmp    8010592a <alltraps>

801062e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $85
801062e6:	6a 55                	push   $0x55
  jmp alltraps
801062e8:	e9 3d f6 ff ff       	jmp    8010592a <alltraps>

801062ed <vector86>:
.globl vector86
vector86:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $86
801062ef:	6a 56                	push   $0x56
  jmp alltraps
801062f1:	e9 34 f6 ff ff       	jmp    8010592a <alltraps>

801062f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $87
801062f8:	6a 57                	push   $0x57
  jmp alltraps
801062fa:	e9 2b f6 ff ff       	jmp    8010592a <alltraps>

801062ff <vector88>:
.globl vector88
vector88:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $88
80106301:	6a 58                	push   $0x58
  jmp alltraps
80106303:	e9 22 f6 ff ff       	jmp    8010592a <alltraps>

80106308 <vector89>:
.globl vector89
vector89:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $89
8010630a:	6a 59                	push   $0x59
  jmp alltraps
8010630c:	e9 19 f6 ff ff       	jmp    8010592a <alltraps>

80106311 <vector90>:
.globl vector90
vector90:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $90
80106313:	6a 5a                	push   $0x5a
  jmp alltraps
80106315:	e9 10 f6 ff ff       	jmp    8010592a <alltraps>

8010631a <vector91>:
.globl vector91
vector91:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $91
8010631c:	6a 5b                	push   $0x5b
  jmp alltraps
8010631e:	e9 07 f6 ff ff       	jmp    8010592a <alltraps>

80106323 <vector92>:
.globl vector92
vector92:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $92
80106325:	6a 5c                	push   $0x5c
  jmp alltraps
80106327:	e9 fe f5 ff ff       	jmp    8010592a <alltraps>

8010632c <vector93>:
.globl vector93
vector93:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $93
8010632e:	6a 5d                	push   $0x5d
  jmp alltraps
80106330:	e9 f5 f5 ff ff       	jmp    8010592a <alltraps>

80106335 <vector94>:
.globl vector94
vector94:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $94
80106337:	6a 5e                	push   $0x5e
  jmp alltraps
80106339:	e9 ec f5 ff ff       	jmp    8010592a <alltraps>

8010633e <vector95>:
.globl vector95
vector95:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $95
80106340:	6a 5f                	push   $0x5f
  jmp alltraps
80106342:	e9 e3 f5 ff ff       	jmp    8010592a <alltraps>

80106347 <vector96>:
.globl vector96
vector96:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $96
80106349:	6a 60                	push   $0x60
  jmp alltraps
8010634b:	e9 da f5 ff ff       	jmp    8010592a <alltraps>

80106350 <vector97>:
.globl vector97
vector97:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $97
80106352:	6a 61                	push   $0x61
  jmp alltraps
80106354:	e9 d1 f5 ff ff       	jmp    8010592a <alltraps>

80106359 <vector98>:
.globl vector98
vector98:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $98
8010635b:	6a 62                	push   $0x62
  jmp alltraps
8010635d:	e9 c8 f5 ff ff       	jmp    8010592a <alltraps>

80106362 <vector99>:
.globl vector99
vector99:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $99
80106364:	6a 63                	push   $0x63
  jmp alltraps
80106366:	e9 bf f5 ff ff       	jmp    8010592a <alltraps>

8010636b <vector100>:
.globl vector100
vector100:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $100
8010636d:	6a 64                	push   $0x64
  jmp alltraps
8010636f:	e9 b6 f5 ff ff       	jmp    8010592a <alltraps>

80106374 <vector101>:
.globl vector101
vector101:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $101
80106376:	6a 65                	push   $0x65
  jmp alltraps
80106378:	e9 ad f5 ff ff       	jmp    8010592a <alltraps>

8010637d <vector102>:
.globl vector102
vector102:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $102
8010637f:	6a 66                	push   $0x66
  jmp alltraps
80106381:	e9 a4 f5 ff ff       	jmp    8010592a <alltraps>

80106386 <vector103>:
.globl vector103
vector103:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $103
80106388:	6a 67                	push   $0x67
  jmp alltraps
8010638a:	e9 9b f5 ff ff       	jmp    8010592a <alltraps>

8010638f <vector104>:
.globl vector104
vector104:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $104
80106391:	6a 68                	push   $0x68
  jmp alltraps
80106393:	e9 92 f5 ff ff       	jmp    8010592a <alltraps>

80106398 <vector105>:
.globl vector105
vector105:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $105
8010639a:	6a 69                	push   $0x69
  jmp alltraps
8010639c:	e9 89 f5 ff ff       	jmp    8010592a <alltraps>

801063a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $106
801063a3:	6a 6a                	push   $0x6a
  jmp alltraps
801063a5:	e9 80 f5 ff ff       	jmp    8010592a <alltraps>

801063aa <vector107>:
.globl vector107
vector107:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $107
801063ac:	6a 6b                	push   $0x6b
  jmp alltraps
801063ae:	e9 77 f5 ff ff       	jmp    8010592a <alltraps>

801063b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $108
801063b5:	6a 6c                	push   $0x6c
  jmp alltraps
801063b7:	e9 6e f5 ff ff       	jmp    8010592a <alltraps>

801063bc <vector109>:
.globl vector109
vector109:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $109
801063be:	6a 6d                	push   $0x6d
  jmp alltraps
801063c0:	e9 65 f5 ff ff       	jmp    8010592a <alltraps>

801063c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $110
801063c7:	6a 6e                	push   $0x6e
  jmp alltraps
801063c9:	e9 5c f5 ff ff       	jmp    8010592a <alltraps>

801063ce <vector111>:
.globl vector111
vector111:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $111
801063d0:	6a 6f                	push   $0x6f
  jmp alltraps
801063d2:	e9 53 f5 ff ff       	jmp    8010592a <alltraps>

801063d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $112
801063d9:	6a 70                	push   $0x70
  jmp alltraps
801063db:	e9 4a f5 ff ff       	jmp    8010592a <alltraps>

801063e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $113
801063e2:	6a 71                	push   $0x71
  jmp alltraps
801063e4:	e9 41 f5 ff ff       	jmp    8010592a <alltraps>

801063e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $114
801063eb:	6a 72                	push   $0x72
  jmp alltraps
801063ed:	e9 38 f5 ff ff       	jmp    8010592a <alltraps>

801063f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $115
801063f4:	6a 73                	push   $0x73
  jmp alltraps
801063f6:	e9 2f f5 ff ff       	jmp    8010592a <alltraps>

801063fb <vector116>:
.globl vector116
vector116:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $116
801063fd:	6a 74                	push   $0x74
  jmp alltraps
801063ff:	e9 26 f5 ff ff       	jmp    8010592a <alltraps>

80106404 <vector117>:
.globl vector117
vector117:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $117
80106406:	6a 75                	push   $0x75
  jmp alltraps
80106408:	e9 1d f5 ff ff       	jmp    8010592a <alltraps>

8010640d <vector118>:
.globl vector118
vector118:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $118
8010640f:	6a 76                	push   $0x76
  jmp alltraps
80106411:	e9 14 f5 ff ff       	jmp    8010592a <alltraps>

80106416 <vector119>:
.globl vector119
vector119:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $119
80106418:	6a 77                	push   $0x77
  jmp alltraps
8010641a:	e9 0b f5 ff ff       	jmp    8010592a <alltraps>

8010641f <vector120>:
.globl vector120
vector120:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $120
80106421:	6a 78                	push   $0x78
  jmp alltraps
80106423:	e9 02 f5 ff ff       	jmp    8010592a <alltraps>

80106428 <vector121>:
.globl vector121
vector121:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $121
8010642a:	6a 79                	push   $0x79
  jmp alltraps
8010642c:	e9 f9 f4 ff ff       	jmp    8010592a <alltraps>

80106431 <vector122>:
.globl vector122
vector122:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $122
80106433:	6a 7a                	push   $0x7a
  jmp alltraps
80106435:	e9 f0 f4 ff ff       	jmp    8010592a <alltraps>

8010643a <vector123>:
.globl vector123
vector123:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $123
8010643c:	6a 7b                	push   $0x7b
  jmp alltraps
8010643e:	e9 e7 f4 ff ff       	jmp    8010592a <alltraps>

80106443 <vector124>:
.globl vector124
vector124:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $124
80106445:	6a 7c                	push   $0x7c
  jmp alltraps
80106447:	e9 de f4 ff ff       	jmp    8010592a <alltraps>

8010644c <vector125>:
.globl vector125
vector125:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $125
8010644e:	6a 7d                	push   $0x7d
  jmp alltraps
80106450:	e9 d5 f4 ff ff       	jmp    8010592a <alltraps>

80106455 <vector126>:
.globl vector126
vector126:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $126
80106457:	6a 7e                	push   $0x7e
  jmp alltraps
80106459:	e9 cc f4 ff ff       	jmp    8010592a <alltraps>

8010645e <vector127>:
.globl vector127
vector127:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $127
80106460:	6a 7f                	push   $0x7f
  jmp alltraps
80106462:	e9 c3 f4 ff ff       	jmp    8010592a <alltraps>

80106467 <vector128>:
.globl vector128
vector128:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $128
80106469:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010646e:	e9 b7 f4 ff ff       	jmp    8010592a <alltraps>

80106473 <vector129>:
.globl vector129
vector129:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $129
80106475:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010647a:	e9 ab f4 ff ff       	jmp    8010592a <alltraps>

8010647f <vector130>:
.globl vector130
vector130:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $130
80106481:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106486:	e9 9f f4 ff ff       	jmp    8010592a <alltraps>

8010648b <vector131>:
.globl vector131
vector131:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $131
8010648d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106492:	e9 93 f4 ff ff       	jmp    8010592a <alltraps>

80106497 <vector132>:
.globl vector132
vector132:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $132
80106499:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010649e:	e9 87 f4 ff ff       	jmp    8010592a <alltraps>

801064a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $133
801064a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064aa:	e9 7b f4 ff ff       	jmp    8010592a <alltraps>

801064af <vector134>:
.globl vector134
vector134:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $134
801064b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064b6:	e9 6f f4 ff ff       	jmp    8010592a <alltraps>

801064bb <vector135>:
.globl vector135
vector135:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $135
801064bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064c2:	e9 63 f4 ff ff       	jmp    8010592a <alltraps>

801064c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $136
801064c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ce:	e9 57 f4 ff ff       	jmp    8010592a <alltraps>

801064d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $137
801064d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064da:	e9 4b f4 ff ff       	jmp    8010592a <alltraps>

801064df <vector138>:
.globl vector138
vector138:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $138
801064e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064e6:	e9 3f f4 ff ff       	jmp    8010592a <alltraps>

801064eb <vector139>:
.globl vector139
vector139:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $139
801064ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064f2:	e9 33 f4 ff ff       	jmp    8010592a <alltraps>

801064f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $140
801064f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064fe:	e9 27 f4 ff ff       	jmp    8010592a <alltraps>

80106503 <vector141>:
.globl vector141
vector141:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $141
80106505:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010650a:	e9 1b f4 ff ff       	jmp    8010592a <alltraps>

8010650f <vector142>:
.globl vector142
vector142:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $142
80106511:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106516:	e9 0f f4 ff ff       	jmp    8010592a <alltraps>

8010651b <vector143>:
.globl vector143
vector143:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $143
8010651d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106522:	e9 03 f4 ff ff       	jmp    8010592a <alltraps>

80106527 <vector144>:
.globl vector144
vector144:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $144
80106529:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010652e:	e9 f7 f3 ff ff       	jmp    8010592a <alltraps>

80106533 <vector145>:
.globl vector145
vector145:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $145
80106535:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010653a:	e9 eb f3 ff ff       	jmp    8010592a <alltraps>

8010653f <vector146>:
.globl vector146
vector146:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $146
80106541:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106546:	e9 df f3 ff ff       	jmp    8010592a <alltraps>

8010654b <vector147>:
.globl vector147
vector147:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $147
8010654d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106552:	e9 d3 f3 ff ff       	jmp    8010592a <alltraps>

80106557 <vector148>:
.globl vector148
vector148:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $148
80106559:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010655e:	e9 c7 f3 ff ff       	jmp    8010592a <alltraps>

80106563 <vector149>:
.globl vector149
vector149:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $149
80106565:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010656a:	e9 bb f3 ff ff       	jmp    8010592a <alltraps>

8010656f <vector150>:
.globl vector150
vector150:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $150
80106571:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106576:	e9 af f3 ff ff       	jmp    8010592a <alltraps>

8010657b <vector151>:
.globl vector151
vector151:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $151
8010657d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106582:	e9 a3 f3 ff ff       	jmp    8010592a <alltraps>

80106587 <vector152>:
.globl vector152
vector152:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $152
80106589:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010658e:	e9 97 f3 ff ff       	jmp    8010592a <alltraps>

80106593 <vector153>:
.globl vector153
vector153:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $153
80106595:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010659a:	e9 8b f3 ff ff       	jmp    8010592a <alltraps>

8010659f <vector154>:
.globl vector154
vector154:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $154
801065a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065a6:	e9 7f f3 ff ff       	jmp    8010592a <alltraps>

801065ab <vector155>:
.globl vector155
vector155:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $155
801065ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065b2:	e9 73 f3 ff ff       	jmp    8010592a <alltraps>

801065b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $156
801065b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065be:	e9 67 f3 ff ff       	jmp    8010592a <alltraps>

801065c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $157
801065c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ca:	e9 5b f3 ff ff       	jmp    8010592a <alltraps>

801065cf <vector158>:
.globl vector158
vector158:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $158
801065d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065d6:	e9 4f f3 ff ff       	jmp    8010592a <alltraps>

801065db <vector159>:
.globl vector159
vector159:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $159
801065dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065e2:	e9 43 f3 ff ff       	jmp    8010592a <alltraps>

801065e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $160
801065e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ee:	e9 37 f3 ff ff       	jmp    8010592a <alltraps>

801065f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $161
801065f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065fa:	e9 2b f3 ff ff       	jmp    8010592a <alltraps>

801065ff <vector162>:
.globl vector162
vector162:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $162
80106601:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106606:	e9 1f f3 ff ff       	jmp    8010592a <alltraps>

8010660b <vector163>:
.globl vector163
vector163:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $163
8010660d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106612:	e9 13 f3 ff ff       	jmp    8010592a <alltraps>

80106617 <vector164>:
.globl vector164
vector164:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $164
80106619:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010661e:	e9 07 f3 ff ff       	jmp    8010592a <alltraps>

80106623 <vector165>:
.globl vector165
vector165:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $165
80106625:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010662a:	e9 fb f2 ff ff       	jmp    8010592a <alltraps>

8010662f <vector166>:
.globl vector166
vector166:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $166
80106631:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106636:	e9 ef f2 ff ff       	jmp    8010592a <alltraps>

8010663b <vector167>:
.globl vector167
vector167:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $167
8010663d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106642:	e9 e3 f2 ff ff       	jmp    8010592a <alltraps>

80106647 <vector168>:
.globl vector168
vector168:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $168
80106649:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010664e:	e9 d7 f2 ff ff       	jmp    8010592a <alltraps>

80106653 <vector169>:
.globl vector169
vector169:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $169
80106655:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010665a:	e9 cb f2 ff ff       	jmp    8010592a <alltraps>

8010665f <vector170>:
.globl vector170
vector170:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $170
80106661:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106666:	e9 bf f2 ff ff       	jmp    8010592a <alltraps>

8010666b <vector171>:
.globl vector171
vector171:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $171
8010666d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106672:	e9 b3 f2 ff ff       	jmp    8010592a <alltraps>

80106677 <vector172>:
.globl vector172
vector172:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $172
80106679:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010667e:	e9 a7 f2 ff ff       	jmp    8010592a <alltraps>

80106683 <vector173>:
.globl vector173
vector173:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $173
80106685:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010668a:	e9 9b f2 ff ff       	jmp    8010592a <alltraps>

8010668f <vector174>:
.globl vector174
vector174:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $174
80106691:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106696:	e9 8f f2 ff ff       	jmp    8010592a <alltraps>

8010669b <vector175>:
.globl vector175
vector175:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $175
8010669d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066a2:	e9 83 f2 ff ff       	jmp    8010592a <alltraps>

801066a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $176
801066a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ae:	e9 77 f2 ff ff       	jmp    8010592a <alltraps>

801066b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $177
801066b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ba:	e9 6b f2 ff ff       	jmp    8010592a <alltraps>

801066bf <vector178>:
.globl vector178
vector178:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $178
801066c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066c6:	e9 5f f2 ff ff       	jmp    8010592a <alltraps>

801066cb <vector179>:
.globl vector179
vector179:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $179
801066cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066d2:	e9 53 f2 ff ff       	jmp    8010592a <alltraps>

801066d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $180
801066d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066de:	e9 47 f2 ff ff       	jmp    8010592a <alltraps>

801066e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $181
801066e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ea:	e9 3b f2 ff ff       	jmp    8010592a <alltraps>

801066ef <vector182>:
.globl vector182
vector182:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $182
801066f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066f6:	e9 2f f2 ff ff       	jmp    8010592a <alltraps>

801066fb <vector183>:
.globl vector183
vector183:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $183
801066fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106702:	e9 23 f2 ff ff       	jmp    8010592a <alltraps>

80106707 <vector184>:
.globl vector184
vector184:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $184
80106709:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010670e:	e9 17 f2 ff ff       	jmp    8010592a <alltraps>

80106713 <vector185>:
.globl vector185
vector185:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $185
80106715:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010671a:	e9 0b f2 ff ff       	jmp    8010592a <alltraps>

8010671f <vector186>:
.globl vector186
vector186:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $186
80106721:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106726:	e9 ff f1 ff ff       	jmp    8010592a <alltraps>

8010672b <vector187>:
.globl vector187
vector187:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $187
8010672d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106732:	e9 f3 f1 ff ff       	jmp    8010592a <alltraps>

80106737 <vector188>:
.globl vector188
vector188:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $188
80106739:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010673e:	e9 e7 f1 ff ff       	jmp    8010592a <alltraps>

80106743 <vector189>:
.globl vector189
vector189:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $189
80106745:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010674a:	e9 db f1 ff ff       	jmp    8010592a <alltraps>

8010674f <vector190>:
.globl vector190
vector190:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $190
80106751:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106756:	e9 cf f1 ff ff       	jmp    8010592a <alltraps>

8010675b <vector191>:
.globl vector191
vector191:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $191
8010675d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106762:	e9 c3 f1 ff ff       	jmp    8010592a <alltraps>

80106767 <vector192>:
.globl vector192
vector192:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $192
80106769:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010676e:	e9 b7 f1 ff ff       	jmp    8010592a <alltraps>

80106773 <vector193>:
.globl vector193
vector193:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $193
80106775:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010677a:	e9 ab f1 ff ff       	jmp    8010592a <alltraps>

8010677f <vector194>:
.globl vector194
vector194:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $194
80106781:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106786:	e9 9f f1 ff ff       	jmp    8010592a <alltraps>

8010678b <vector195>:
.globl vector195
vector195:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $195
8010678d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106792:	e9 93 f1 ff ff       	jmp    8010592a <alltraps>

80106797 <vector196>:
.globl vector196
vector196:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $196
80106799:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010679e:	e9 87 f1 ff ff       	jmp    8010592a <alltraps>

801067a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $197
801067a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067aa:	e9 7b f1 ff ff       	jmp    8010592a <alltraps>

801067af <vector198>:
.globl vector198
vector198:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $198
801067b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067b6:	e9 6f f1 ff ff       	jmp    8010592a <alltraps>

801067bb <vector199>:
.globl vector199
vector199:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $199
801067bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067c2:	e9 63 f1 ff ff       	jmp    8010592a <alltraps>

801067c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $200
801067c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ce:	e9 57 f1 ff ff       	jmp    8010592a <alltraps>

801067d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $201
801067d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067da:	e9 4b f1 ff ff       	jmp    8010592a <alltraps>

801067df <vector202>:
.globl vector202
vector202:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $202
801067e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067e6:	e9 3f f1 ff ff       	jmp    8010592a <alltraps>

801067eb <vector203>:
.globl vector203
vector203:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $203
801067ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067f2:	e9 33 f1 ff ff       	jmp    8010592a <alltraps>

801067f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $204
801067f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067fe:	e9 27 f1 ff ff       	jmp    8010592a <alltraps>

80106803 <vector205>:
.globl vector205
vector205:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $205
80106805:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010680a:	e9 1b f1 ff ff       	jmp    8010592a <alltraps>

8010680f <vector206>:
.globl vector206
vector206:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $206
80106811:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106816:	e9 0f f1 ff ff       	jmp    8010592a <alltraps>

8010681b <vector207>:
.globl vector207
vector207:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $207
8010681d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106822:	e9 03 f1 ff ff       	jmp    8010592a <alltraps>

80106827 <vector208>:
.globl vector208
vector208:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $208
80106829:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010682e:	e9 f7 f0 ff ff       	jmp    8010592a <alltraps>

80106833 <vector209>:
.globl vector209
vector209:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $209
80106835:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010683a:	e9 eb f0 ff ff       	jmp    8010592a <alltraps>

8010683f <vector210>:
.globl vector210
vector210:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $210
80106841:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106846:	e9 df f0 ff ff       	jmp    8010592a <alltraps>

8010684b <vector211>:
.globl vector211
vector211:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $211
8010684d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106852:	e9 d3 f0 ff ff       	jmp    8010592a <alltraps>

80106857 <vector212>:
.globl vector212
vector212:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $212
80106859:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010685e:	e9 c7 f0 ff ff       	jmp    8010592a <alltraps>

80106863 <vector213>:
.globl vector213
vector213:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $213
80106865:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010686a:	e9 bb f0 ff ff       	jmp    8010592a <alltraps>

8010686f <vector214>:
.globl vector214
vector214:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $214
80106871:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106876:	e9 af f0 ff ff       	jmp    8010592a <alltraps>

8010687b <vector215>:
.globl vector215
vector215:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $215
8010687d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106882:	e9 a3 f0 ff ff       	jmp    8010592a <alltraps>

80106887 <vector216>:
.globl vector216
vector216:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $216
80106889:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010688e:	e9 97 f0 ff ff       	jmp    8010592a <alltraps>

80106893 <vector217>:
.globl vector217
vector217:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $217
80106895:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010689a:	e9 8b f0 ff ff       	jmp    8010592a <alltraps>

8010689f <vector218>:
.globl vector218
vector218:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $218
801068a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068a6:	e9 7f f0 ff ff       	jmp    8010592a <alltraps>

801068ab <vector219>:
.globl vector219
vector219:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $219
801068ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068b2:	e9 73 f0 ff ff       	jmp    8010592a <alltraps>

801068b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $220
801068b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068be:	e9 67 f0 ff ff       	jmp    8010592a <alltraps>

801068c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $221
801068c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ca:	e9 5b f0 ff ff       	jmp    8010592a <alltraps>

801068cf <vector222>:
.globl vector222
vector222:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $222
801068d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068d6:	e9 4f f0 ff ff       	jmp    8010592a <alltraps>

801068db <vector223>:
.globl vector223
vector223:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $223
801068dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068e2:	e9 43 f0 ff ff       	jmp    8010592a <alltraps>

801068e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $224
801068e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ee:	e9 37 f0 ff ff       	jmp    8010592a <alltraps>

801068f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $225
801068f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068fa:	e9 2b f0 ff ff       	jmp    8010592a <alltraps>

801068ff <vector226>:
.globl vector226
vector226:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $226
80106901:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106906:	e9 1f f0 ff ff       	jmp    8010592a <alltraps>

8010690b <vector227>:
.globl vector227
vector227:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $227
8010690d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106912:	e9 13 f0 ff ff       	jmp    8010592a <alltraps>

80106917 <vector228>:
.globl vector228
vector228:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $228
80106919:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010691e:	e9 07 f0 ff ff       	jmp    8010592a <alltraps>

80106923 <vector229>:
.globl vector229
vector229:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $229
80106925:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010692a:	e9 fb ef ff ff       	jmp    8010592a <alltraps>

8010692f <vector230>:
.globl vector230
vector230:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $230
80106931:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106936:	e9 ef ef ff ff       	jmp    8010592a <alltraps>

8010693b <vector231>:
.globl vector231
vector231:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $231
8010693d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106942:	e9 e3 ef ff ff       	jmp    8010592a <alltraps>

80106947 <vector232>:
.globl vector232
vector232:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $232
80106949:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010694e:	e9 d7 ef ff ff       	jmp    8010592a <alltraps>

80106953 <vector233>:
.globl vector233
vector233:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $233
80106955:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010695a:	e9 cb ef ff ff       	jmp    8010592a <alltraps>

8010695f <vector234>:
.globl vector234
vector234:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $234
80106961:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106966:	e9 bf ef ff ff       	jmp    8010592a <alltraps>

8010696b <vector235>:
.globl vector235
vector235:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $235
8010696d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106972:	e9 b3 ef ff ff       	jmp    8010592a <alltraps>

80106977 <vector236>:
.globl vector236
vector236:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $236
80106979:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010697e:	e9 a7 ef ff ff       	jmp    8010592a <alltraps>

80106983 <vector237>:
.globl vector237
vector237:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $237
80106985:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010698a:	e9 9b ef ff ff       	jmp    8010592a <alltraps>

8010698f <vector238>:
.globl vector238
vector238:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $238
80106991:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106996:	e9 8f ef ff ff       	jmp    8010592a <alltraps>

8010699b <vector239>:
.globl vector239
vector239:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $239
8010699d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069a2:	e9 83 ef ff ff       	jmp    8010592a <alltraps>

801069a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $240
801069a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ae:	e9 77 ef ff ff       	jmp    8010592a <alltraps>

801069b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $241
801069b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ba:	e9 6b ef ff ff       	jmp    8010592a <alltraps>

801069bf <vector242>:
.globl vector242
vector242:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $242
801069c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069c6:	e9 5f ef ff ff       	jmp    8010592a <alltraps>

801069cb <vector243>:
.globl vector243
vector243:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $243
801069cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069d2:	e9 53 ef ff ff       	jmp    8010592a <alltraps>

801069d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $244
801069d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069de:	e9 47 ef ff ff       	jmp    8010592a <alltraps>

801069e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $245
801069e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ea:	e9 3b ef ff ff       	jmp    8010592a <alltraps>

801069ef <vector246>:
.globl vector246
vector246:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $246
801069f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069f6:	e9 2f ef ff ff       	jmp    8010592a <alltraps>

801069fb <vector247>:
.globl vector247
vector247:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $247
801069fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a02:	e9 23 ef ff ff       	jmp    8010592a <alltraps>

80106a07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $248
80106a09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a0e:	e9 17 ef ff ff       	jmp    8010592a <alltraps>

80106a13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $249
80106a15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a1a:	e9 0b ef ff ff       	jmp    8010592a <alltraps>

80106a1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $250
80106a21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a26:	e9 ff ee ff ff       	jmp    8010592a <alltraps>

80106a2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $251
80106a2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a32:	e9 f3 ee ff ff       	jmp    8010592a <alltraps>

80106a37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $252
80106a39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a3e:	e9 e7 ee ff ff       	jmp    8010592a <alltraps>

80106a43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $253
80106a45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a4a:	e9 db ee ff ff       	jmp    8010592a <alltraps>

80106a4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $254
80106a51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a56:	e9 cf ee ff ff       	jmp    8010592a <alltraps>

80106a5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $255
80106a5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a62:	e9 c3 ee ff ff       	jmp    8010592a <alltraps>
80106a67:	66 90                	xchg   %ax,%ax
80106a69:	66 90                	xchg   %ax,%ax
80106a6b:	66 90                	xchg   %ax,%ax
80106a6d:	66 90                	xchg   %ax,%ax
80106a6f:	90                   	nop

80106a70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a76:	89 d3                	mov    %edx,%ebx
{
80106a78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a7a:	c1 eb 16             	shr    $0x16,%ebx
80106a7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106a80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a83:	8b 06                	mov    (%esi),%eax
80106a85:	a8 01                	test   $0x1,%al
80106a87:	74 27                	je     80106ab0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx

    // cprintf("New Page allocated! \n");

    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a94:	c1 ef 0a             	shr    $0xa,%edi
}
80106a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a9a:	89 fa                	mov    %edi,%edx
80106a9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106aa2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106aa5:	5b                   	pop    %ebx
80106aa6:	5e                   	pop    %esi
80106aa7:	5f                   	pop    %edi
80106aa8:	5d                   	pop    %ebp
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ab0:	85 c9                	test   %ecx,%ecx
80106ab2:	74 2c                	je     80106ae0 <walkpgdir+0x70>
80106ab4:	e8 e7 bc ff ff       	call   801027a0 <kalloc>
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	89 c3                	mov    %eax,%ebx
80106abd:	74 21                	je     80106ae0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106abf:	83 ec 04             	sub    $0x4,%esp
80106ac2:	68 00 10 00 00       	push   $0x1000
80106ac7:	6a 00                	push   $0x0
80106ac9:	50                   	push   %eax
80106aca:	e8 51 dc ff ff       	call   80104720 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106acf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ad5:	83 c4 10             	add    $0x10,%esp
80106ad8:	83 c8 07             	or     $0x7,%eax
80106adb:	89 06                	mov    %eax,(%esi)
80106add:	eb b5                	jmp    80106a94 <walkpgdir+0x24>
80106adf:	90                   	nop
}
80106ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ae3:	31 c0                	xor    %eax,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106af0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106af6:	89 d3                	mov    %edx,%ebx
80106af8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106afe:	83 ec 1c             	sub    $0x1c,%esp
80106b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(*pte & PTE_P){
      cprintf("PTE Entry before panic : %x\n", *pte);
      panic("remap");

    }
    *pte = pa | perm | PTE_P;
80106b13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b16:	29 df                	sub    %ebx,%edi
80106b18:	83 c8 01             	or     $0x1,%eax
80106b1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b1e:	eb 17                	jmp    80106b37 <mappages+0x47>
    if(*pte & PTE_P){
80106b20:	8b 10                	mov    (%eax),%edx
80106b22:	f6 c2 01             	test   $0x1,%dl
80106b25:	75 43                	jne    80106b6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b27:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b2a:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b2d:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b2f:	74 2f                	je     80106b60 <mappages+0x70>
      break;
    a += PGSIZE;
80106b31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b3a:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b3f:	89 da                	mov    %ebx,%edx
80106b41:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b44:	e8 27 ff ff ff       	call   80106a70 <walkpgdir>
80106b49:	85 c0                	test   %eax,%eax
80106b4b:	75 d3                	jne    80106b20 <mappages+0x30>
    pa += PGSIZE;
  }

  return 0;
}
80106b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
      cprintf("PTE Entry before panic : %x\n", *pte);
80106b6a:	83 ec 08             	sub    $0x8,%esp
80106b6d:	52                   	push   %edx
80106b6e:	68 18 7e 10 80       	push   $0x80107e18
80106b73:	e8 f8 9b ff ff       	call   80100770 <cprintf>
      panic("remap");
80106b78:	c7 04 24 35 7e 10 80 	movl   $0x80107e35,(%esp)
80106b7f:	e8 1c 99 ff ff       	call   801004a0 <panic>
80106b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b90 <seginit>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b96:	e8 15 cf ff ff       	call   80103ab0 <cpuid>
80106b9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106ba1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ba6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106baa:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106bb1:	ff 00 00 
80106bb4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106bbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bbe:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106bc5:	ff 00 00 
80106bc8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106bcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bd2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106bd9:	ff 00 00 
80106bdc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106be3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106be6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106bed:	ff 00 00 
80106bf0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106bf7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bfa:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106bff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c03:	c1 e8 10             	shr    $0x10,%eax
80106c06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c0d:	0f 01 10             	lgdtl  (%eax)
}
80106c10:	c9                   	leave  
80106c11:	c3                   	ret    
80106c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c20:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
80106c25:	55                   	push   %ebp
80106c26:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c28:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c2d:	0f 22 d8             	mov    %eax,%cr3
}
80106c30:	5d                   	pop    %ebp
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c40 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 1c             	sub    $0x1c,%esp
80106c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106c4c:	85 db                	test   %ebx,%ebx
80106c4e:	0f 84 cb 00 00 00    	je     80106d1f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106c54:	8b 43 08             	mov    0x8(%ebx),%eax
80106c57:	85 c0                	test   %eax,%eax
80106c59:	0f 84 da 00 00 00    	je     80106d39 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106c5f:	8b 43 04             	mov    0x4(%ebx),%eax
80106c62:	85 c0                	test   %eax,%eax
80106c64:	0f 84 c2 00 00 00    	je     80106d2c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106c6a:	e8 f1 d8 ff ff       	call   80104560 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c6f:	e8 bc cd ff ff       	call   80103a30 <mycpu>
80106c74:	89 c6                	mov    %eax,%esi
80106c76:	e8 b5 cd ff ff       	call   80103a30 <mycpu>
80106c7b:	89 c7                	mov    %eax,%edi
80106c7d:	e8 ae cd ff ff       	call   80103a30 <mycpu>
80106c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c85:	83 c7 08             	add    $0x8,%edi
80106c88:	e8 a3 cd ff ff       	call   80103a30 <mycpu>
80106c8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c90:	83 c0 08             	add    $0x8,%eax
80106c93:	ba 67 00 00 00       	mov    $0x67,%edx
80106c98:	c1 e8 18             	shr    $0x18,%eax
80106c9b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106ca2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106ca9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106caf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cb4:	83 c1 08             	add    $0x8,%ecx
80106cb7:	c1 e9 10             	shr    $0x10,%ecx
80106cba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106cc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cc5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ccc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106cd1:	e8 5a cd ff ff       	call   80103a30 <mycpu>
80106cd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cdd:	e8 4e cd ff ff       	call   80103a30 <mycpu>
80106ce2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ce6:	8b 73 08             	mov    0x8(%ebx),%esi
80106ce9:	e8 42 cd ff ff       	call   80103a30 <mycpu>
80106cee:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cf4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cf7:	e8 34 cd ff ff       	call   80103a30 <mycpu>
80106cfc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d00:	b8 28 00 00 00       	mov    $0x28,%eax
80106d05:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d08:	8b 43 04             	mov    0x4(%ebx),%eax
80106d0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d10:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d16:	5b                   	pop    %ebx
80106d17:	5e                   	pop    %esi
80106d18:	5f                   	pop    %edi
80106d19:	5d                   	pop    %ebp
  popcli();
80106d1a:	e9 41 d9 ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
80106d1f:	83 ec 0c             	sub    $0xc,%esp
80106d22:	68 3b 7e 10 80       	push   $0x80107e3b
80106d27:	e8 74 97 ff ff       	call   801004a0 <panic>
    panic("switchuvm: no pgdir");
80106d2c:	83 ec 0c             	sub    $0xc,%esp
80106d2f:	68 66 7e 10 80       	push   $0x80107e66
80106d34:	e8 67 97 ff ff       	call   801004a0 <panic>
    panic("switchuvm: no kstack");
80106d39:	83 ec 0c             	sub    $0xc,%esp
80106d3c:	68 51 7e 10 80       	push   $0x80107e51
80106d41:	e8 5a 97 ff ff       	call   801004a0 <panic>
80106d46:	8d 76 00             	lea    0x0(%esi),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
80106d56:	83 ec 1c             	sub    $0x1c,%esp
80106d59:	8b 75 10             	mov    0x10(%ebp),%esi
80106d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106d62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106d68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d6b:	77 49                	ja     80106db6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106d6d:	e8 2e ba ff ff       	call   801027a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d72:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106d75:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d77:	68 00 10 00 00       	push   $0x1000
80106d7c:	6a 00                	push   $0x0
80106d7e:	50                   	push   %eax
80106d7f:	e8 9c d9 ff ff       	call   80104720 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d84:	58                   	pop    %eax
80106d85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d8b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d90:	5a                   	pop    %edx
80106d91:	6a 06                	push   $0x6
80106d93:	50                   	push   %eax
80106d94:	31 d2                	xor    %edx,%edx
80106d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d99:	e8 52 fd ff ff       	call   80106af0 <mappages>
  memmove(mem, init, sz);
80106d9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106da1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106da4:	83 c4 10             	add    $0x10,%esp
80106da7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dad:	5b                   	pop    %ebx
80106dae:	5e                   	pop    %esi
80106daf:	5f                   	pop    %edi
80106db0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106db1:	e9 1a da ff ff       	jmp    801047d0 <memmove>
    panic("inituvm: more than a page");
80106db6:	83 ec 0c             	sub    $0xc,%esp
80106db9:	68 7a 7e 10 80       	push   $0x80107e7a
80106dbe:	e8 dd 96 ff ff       	call   801004a0 <panic>
80106dc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106dd9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106de0:	0f 85 91 00 00 00    	jne    80106e77 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106de6:	8b 75 18             	mov    0x18(%ebp),%esi
80106de9:	31 db                	xor    %ebx,%ebx
80106deb:	85 f6                	test   %esi,%esi
80106ded:	75 1a                	jne    80106e09 <loaduvm+0x39>
80106def:	eb 6f                	jmp    80106e60 <loaduvm+0x90>
80106df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dfe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e04:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e07:	76 57                	jbe    80106e60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e09:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e0f:	31 c9                	xor    %ecx,%ecx
80106e11:	01 da                	add    %ebx,%edx
80106e13:	e8 58 fc ff ff       	call   80106a70 <walkpgdir>
80106e18:	85 c0                	test   %eax,%eax
80106e1a:	74 4e                	je     80106e6a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106e1c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e21:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e2b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e31:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e34:	01 d9                	add    %ebx,%ecx
80106e36:	05 00 00 00 80       	add    $0x80000000,%eax
80106e3b:	57                   	push   %edi
80106e3c:	51                   	push   %ecx
80106e3d:	50                   	push   %eax
80106e3e:	ff 75 10             	pushl  0x10(%ebp)
80106e41:	e8 da ad ff ff       	call   80101c20 <readi>
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	39 f8                	cmp    %edi,%eax
80106e4b:	74 ab                	je     80106df8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e55:	5b                   	pop    %ebx
80106e56:	5e                   	pop    %esi
80106e57:	5f                   	pop    %edi
80106e58:	5d                   	pop    %ebp
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e63:	31 c0                	xor    %eax,%eax
}
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e6a:	83 ec 0c             	sub    $0xc,%esp
80106e6d:	68 94 7e 10 80       	push   $0x80107e94
80106e72:	e8 29 96 ff ff       	call   801004a0 <panic>
    panic("loaduvm: addr must be page aligned");
80106e77:	83 ec 0c             	sub    $0xc,%esp
80106e7a:	68 18 7f 10 80       	push   $0x80107f18
80106e7f:	e8 1c 96 ff ff       	call   801004a0 <panic>
80106e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e90 <clearaccessbit>:


// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{   
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
  uint i;
  int counter = 0;
80106e96:	31 ff                	xor    %edi,%edi


    // Looping until we find a valid page
    for (i = 0; i < KERNBASE ; i += PGSIZE){
80106e98:	31 db                	xor    %ebx,%ebx
{   
80106e9a:	83 ec 0c             	sub    $0xc,%esp
80106e9d:	8b 75 08             	mov    0x8(%ebp),%esi
80106ea0:	eb 0e                	jmp    80106eb0 <clearaccessbit+0x20>
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (i = 0; i < KERNBASE ; i += PGSIZE){
80106ea8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eae:	78 2b                	js     80106edb <clearaccessbit+0x4b>
// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
  return walkpgdir(pgdir, (void*)uva, 0);
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	89 da                	mov    %ebx,%edx
80106eb4:	89 f0                	mov    %esi,%eax
80106eb6:	e8 b5 fb ff ff       	call   80106a70 <walkpgdir>
    if((ptentry!=0) && ((*ptentry & PTE_P)!=0) && ((*ptentry & PTE_SWP)==0) && ((*ptentry & PTE_U)!=0)){
80106ebb:	85 c0                	test   %eax,%eax
80106ebd:	74 e9                	je     80106ea8 <clearaccessbit+0x18>
80106ebf:	8b 10                	mov    (%eax),%edx
80106ec1:	89 d1                	mov    %edx,%ecx
80106ec3:	81 e1 05 02 00 00    	and    $0x205,%ecx
80106ec9:	83 f9 05             	cmp    $0x5,%ecx
80106ecc:	75 da                	jne    80106ea8 <clearaccessbit+0x18>
      counter += 1;
80106ece:	83 c7 01             	add    $0x1,%edi
      *ptentry = *ptentry & ~PTE_A;
80106ed1:	83 e2 df             	and    $0xffffffdf,%edx
      if(counter > 20) {
80106ed4:	83 ff 14             	cmp    $0x14,%edi
      *ptentry = *ptentry & ~PTE_A;
80106ed7:	89 10                	mov    %edx,(%eax)
      if(counter > 20) {
80106ed9:	7e cd                	jle    80106ea8 <clearaccessbit+0x18>
}
80106edb:	83 c4 0c             	add    $0xc,%esp
80106ede:	5b                   	pop    %ebx
80106edf:	5e                   	pop    %esi
80106ee0:	5f                   	pop    %edi
80106ee1:	5d                   	pop    %ebp
80106ee2:	c3                   	ret    
80106ee3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <select_a_victim>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	56                   	push   %esi
80106ef4:	53                   	push   %ebx
80106ef5:	8b 75 08             	mov    0x8(%ebp),%esi
	  for (i = 0; i <KERNBASE; i += PGSIZE)
80106ef8:	31 db                	xor    %ebx,%ebx
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return walkpgdir(pgdir, (void*)uva, 0);
80106f00:	31 c9                	xor    %ecx,%ecx
80106f02:	89 da                	mov    %ebx,%edx
80106f04:	89 f0                	mov    %esi,%eax
80106f06:	e8 65 fb ff ff       	call   80106a70 <walkpgdir>
        if((ptentry != 0)&& ((*ptentry & PTE_P)!=0) && ((*ptentry & PTE_SWP)==0) && ((*ptentry & PTE_A)==0) && ((*ptentry & PTE_U)!=0)){
80106f0b:	85 c0                	test   %eax,%eax
80106f0d:	74 0f                	je     80106f1e <select_a_victim+0x2e>
80106f0f:	8b 10                	mov    (%eax),%edx
80106f11:	89 d1                	mov    %edx,%ecx
80106f13:	81 e1 25 02 00 00    	and    $0x225,%ecx
80106f19:	83 f9 05             	cmp    $0x5,%ecx
80106f1c:	74 1a                	je     80106f38 <select_a_victim+0x48>
	  for (i = 0; i <KERNBASE; i += PGSIZE)
80106f1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f24:	79 da                	jns    80106f00 <select_a_victim+0x10>
	      clearaccessbit(pgdir);
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	56                   	push   %esi
80106f2a:	e8 61 ff ff ff       	call   80106e90 <clearaccessbit>
80106f2f:	83 c4 10             	add    $0x10,%esp
80106f32:	eb c4                	jmp    80106ef8 <select_a_victim+0x8>
80106f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	          *ptentry = *ptentry | PTE_A;
80106f38:	83 ca 20             	or     $0x20,%edx
80106f3b:	89 10                	mov    %edx,(%eax)
}
80106f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f40:	5b                   	pop    %ebx
80106f41:	5e                   	pop    %esi
80106f42:	5d                   	pop    %ebp
80106f43:	c3                   	ret    
80106f44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f50 <getswappedblk>:
{ 
80106f50:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80106f51:	31 c9                	xor    %ecx,%ecx
{ 
80106f53:	89 e5                	mov    %esp,%ebp
80106f55:	83 ec 08             	sub    $0x8,%esp
  return walkpgdir(pgdir, (void*)uva, 0);
80106f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5e:	e8 0d fb ff ff       	call   80106a70 <walkpgdir>
  if((*ptentry & PTE_SWP)){
80106f63:	8b 10                	mov    (%eax),%edx
80106f65:	f6 c6 02             	test   $0x2,%dh
80106f68:	74 16                	je     80106f80 <getswappedblk+0x30>
    int value = *ptentry >> 12;
80106f6a:	c1 ea 0c             	shr    $0xc,%edx
    *ptentry = 0;
80106f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80106f73:	89 d0                	mov    %edx,%eax
80106f75:	c9                   	leave  
80106f76:	c3                   	ret    
80106f77:	89 f6                	mov    %esi,%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  return -1;
80106f80:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106f85:	eb ec                	jmp    80106f73 <getswappedblk+0x23>
80106f87:	89 f6                	mov    %esi,%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <deallocuvm.part.0>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
80106f96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f9c:	89 c6                	mov    %eax,%esi
  a = PGROUNDUP(newsz);
80106f9e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fa4:	83 ec 1c             	sub    $0x1c,%esp
80106fa7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106faa:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106faf:	72 30                	jb     80106fe1 <deallocuvm.part.0+0x51>
80106fb1:	eb 72                	jmp    80107025 <deallocuvm.part.0+0x95>
80106fb3:	90                   	nop
80106fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106fb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fbd:	74 7f                	je     8010703e <deallocuvm.part.0+0xae>
      kfree(v);
80106fbf:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fc2:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fc7:	50                   	push   %eax
80106fc8:	e8 f3 b5 ff ff       	call   801025c0 <kfree>
      *pte = 0;
80106fcd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80106fd3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106fd6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fdc:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80106fdf:	73 44                	jae    80107025 <deallocuvm.part.0+0x95>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fe1:	31 c9                	xor    %ecx,%ecx
80106fe3:	89 da                	mov    %ebx,%edx
80106fe5:	89 f0                	mov    %esi,%eax
80106fe7:	e8 84 fa ff ff       	call   80106a70 <walkpgdir>
    if(!pte)
80106fec:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fee:	89 c7                	mov    %eax,%edi
    if(!pte)
80106ff0:	74 3e                	je     80107030 <deallocuvm.part.0+0xa0>
    else if((*pte & PTE_P) != 0 ){
80106ff2:	8b 00                	mov    (%eax),%eax
80106ff4:	a8 01                	test   $0x1,%al
80106ff6:	75 c0                	jne    80106fb8 <deallocuvm.part.0+0x28>
    else if ((*pte & PTE_SWP) != 0){
80106ff8:	f6 c4 02             	test   $0x2,%ah
80106ffb:	74 d9                	je     80106fd6 <deallocuvm.part.0+0x46>
      uint BLK = getswappedblk(pgdir,a);
80106ffd:	83 ec 08             	sub    $0x8,%esp
80107000:	53                   	push   %ebx
80107001:	56                   	push   %esi
  for(; a  < oldsz; a += PGSIZE){
80107002:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      uint BLK = getswappedblk(pgdir,a);
80107008:	e8 43 ff ff ff       	call   80106f50 <getswappedblk>
      bfree_page(ROOTDEV,BLK);
8010700d:	5a                   	pop    %edx
8010700e:	59                   	pop    %ecx
8010700f:	50                   	push   %eax
80107010:	6a 01                	push   $0x1
80107012:	e8 f9 a6 ff ff       	call   80101710 <bfree_page>
      *pte = 0;
80107017:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
8010701a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
      *pte = 0;
8010701d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  for(; a  < oldsz; a += PGSIZE){
80107023:	72 bc                	jb     80106fe1 <deallocuvm.part.0+0x51>
}
80107025:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010702b:	5b                   	pop    %ebx
8010702c:	5e                   	pop    %esi
8010702d:	5f                   	pop    %edi
8010702e:	5d                   	pop    %ebp
8010702f:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107030:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107036:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
8010703c:	eb 98                	jmp    80106fd6 <deallocuvm.part.0+0x46>
        panic("kfree");
8010703e:	83 ec 0c             	sub    $0xc,%esp
80107041:	68 6a 77 10 80       	push   $0x8010776a
80107046:	e8 55 94 ff ff       	call   801004a0 <panic>
8010704b:	90                   	nop
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107050 <deallocuvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	8b 55 0c             	mov    0xc(%ebp),%edx
80107056:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107059:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010705c:	39 d1                	cmp    %edx,%ecx
8010705e:	73 10                	jae    80107070 <deallocuvm+0x20>
}
80107060:	5d                   	pop    %ebp
80107061:	e9 2a ff ff ff       	jmp    80106f90 <deallocuvm.part.0>
80107066:	8d 76 00             	lea    0x0(%esi),%esi
80107069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107070:	89 d0                	mov    %edx,%eax
80107072:	5d                   	pop    %ebp
80107073:	c3                   	ret    
80107074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010707a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107080 <allocuvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107089:	8b 7d 10             	mov    0x10(%ebp),%edi
8010708c:	85 ff                	test   %edi,%edi
8010708e:	0f 88 ac 00 00 00    	js     80107140 <allocuvm+0xc0>
  if(newsz < oldsz)
80107094:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107097:	0f 82 93 00 00 00    	jb     80107130 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010709d:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801070a6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801070ac:	39 75 10             	cmp    %esi,0x10(%ebp)
801070af:	0f 86 7e 00 00 00    	jbe    80107133 <allocuvm+0xb3>
801070b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801070b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070bb:	eb 42                	jmp    801070ff <allocuvm+0x7f>
801070bd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801070c0:	83 ec 04             	sub    $0x4,%esp
801070c3:	68 00 10 00 00       	push   $0x1000
801070c8:	6a 00                	push   $0x0
801070ca:	53                   	push   %ebx
801070cb:	e8 50 d6 ff ff       	call   80104720 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem),PTE_W|PTE_U) < 0){
801070d0:	58                   	pop    %eax
801070d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070dc:	5a                   	pop    %edx
801070dd:	6a 06                	push   $0x6
801070df:	50                   	push   %eax
801070e0:	89 f2                	mov    %esi,%edx
801070e2:	89 f8                	mov    %edi,%eax
801070e4:	e8 07 fa ff ff       	call   80106af0 <mappages>
801070e9:	83 c4 10             	add    $0x10,%esp
801070ec:	85 c0                	test   %eax,%eax
801070ee:	78 60                	js     80107150 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801070f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801070f9:	0f 86 81 00 00 00    	jbe    80107180 <allocuvm+0x100>
    mem = kalloc();
801070ff:	e8 9c b6 ff ff       	call   801027a0 <kalloc>
    if(mem == 0){
80107104:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107106:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107108:	75 b6                	jne    801070c0 <allocuvm+0x40>
      swap_page(pgdir);
8010710a:	83 ec 0c             	sub    $0xc,%esp
8010710d:	57                   	push   %edi
8010710e:	e8 ad eb ff ff       	call   80105cc0 <swap_page>
      mem = kalloc();
80107113:	e8 88 b6 ff ff       	call   801027a0 <kalloc>
      if (mem == 0)
80107118:	83 c4 10             	add    $0x10,%esp
8010711b:	85 c0                	test   %eax,%eax
      mem = kalloc();
8010711d:	89 c3                	mov    %eax,%ebx
      if (mem == 0)
8010711f:	75 9f                	jne    801070c0 <allocuvm+0x40>
        panic("2nd kalloc failed \n");
80107121:	83 ec 0c             	sub    $0xc,%esp
80107124:	68 b2 7e 10 80       	push   $0x80107eb2
80107129:	e8 72 93 ff ff       	call   801004a0 <panic>
8010712e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107130:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	89 f8                	mov    %edi,%eax
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret    
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107143:	31 ff                	xor    %edi,%edi
}
80107145:	89 f8                	mov    %edi,%eax
80107147:	5b                   	pop    %ebx
80107148:	5e                   	pop    %esi
80107149:	5f                   	pop    %edi
8010714a:	5d                   	pop    %ebp
8010714b:	c3                   	ret    
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(newsz >= oldsz)
80107150:	8b 45 0c             	mov    0xc(%ebp),%eax
80107153:	39 45 10             	cmp    %eax,0x10(%ebp)
80107156:	76 0d                	jbe    80107165 <allocuvm+0xe5>
80107158:	89 c1                	mov    %eax,%ecx
8010715a:	8b 55 10             	mov    0x10(%ebp),%edx
8010715d:	8b 45 08             	mov    0x8(%ebp),%eax
80107160:	e8 2b fe ff ff       	call   80106f90 <deallocuvm.part.0>
      kfree(mem);
80107165:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107168:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010716a:	53                   	push   %ebx
8010716b:	e8 50 b4 ff ff       	call   801025c0 <kfree>
      return 0;
80107170:	83 c4 10             	add    $0x10,%esp
}
80107173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107176:	89 f8                	mov    %edi,%eax
80107178:	5b                   	pop    %ebx
80107179:	5e                   	pop    %esi
8010717a:	5f                   	pop    %edi
8010717b:	5d                   	pop    %ebp
8010717c:	c3                   	ret    
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
80107180:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107183:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107186:	5b                   	pop    %ebx
80107187:	89 f8                	mov    %edi,%eax
80107189:	5e                   	pop    %esi
8010718a:	5f                   	pop    %edi
8010718b:	5d                   	pop    %ebp
8010718c:	c3                   	ret    
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <freevm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 0c             	sub    $0xc,%esp
80107199:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
8010719c:	85 f6                	test   %esi,%esi
8010719e:	74 59                	je     801071f9 <freevm+0x69>
801071a0:	31 c9                	xor    %ecx,%ecx
801071a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071a7:	89 f0                	mov    %esi,%eax
801071a9:	e8 e2 fd ff ff       	call   80106f90 <deallocuvm.part.0>
801071ae:	89 f3                	mov    %esi,%ebx
801071b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071b6:	eb 0f                	jmp    801071c7 <freevm+0x37>
801071b8:	90                   	nop
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801071c3:	39 fb                	cmp    %edi,%ebx
801071c5:	74 23                	je     801071ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071c7:	8b 03                	mov    (%ebx),%eax
801071c9:	a8 01                	test   $0x1,%al
801071cb:	74 f3                	je     801071c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071d2:	83 ec 0c             	sub    $0xc,%esp
801071d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071dd:	50                   	push   %eax
801071de:	e8 dd b3 ff ff       	call   801025c0 <kfree>
801071e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071e6:	39 fb                	cmp    %edi,%ebx
801071e8:	75 dd                	jne    801071c7 <freevm+0x37>
  kfree((char*)pgdir);
801071ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f0:	5b                   	pop    %ebx
801071f1:	5e                   	pop    %esi
801071f2:	5f                   	pop    %edi
801071f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071f4:	e9 c7 b3 ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
801071f9:	83 ec 0c             	sub    $0xc,%esp
801071fc:	68 c6 7e 10 80       	push   $0x80107ec6
80107201:	e8 9a 92 ff ff       	call   801004a0 <panic>
80107206:	8d 76 00             	lea    0x0(%esi),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <setupkvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	56                   	push   %esi
80107214:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107215:	e8 86 b5 ff ff       	call   801027a0 <kalloc>
8010721a:	85 c0                	test   %eax,%eax
8010721c:	89 c6                	mov    %eax,%esi
8010721e:	74 42                	je     80107262 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107223:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107228:	68 00 10 00 00       	push   $0x1000
8010722d:	6a 00                	push   $0x0
8010722f:	50                   	push   %eax
80107230:	e8 eb d4 ff ff       	call   80104720 <memset>
80107235:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107238:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010723b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010723e:	83 ec 08             	sub    $0x8,%esp
80107241:	8b 13                	mov    (%ebx),%edx
80107243:	ff 73 0c             	pushl  0xc(%ebx)
80107246:	50                   	push   %eax
80107247:	29 c1                	sub    %eax,%ecx
80107249:	89 f0                	mov    %esi,%eax
8010724b:	e8 a0 f8 ff ff       	call   80106af0 <mappages>
80107250:	83 c4 10             	add    $0x10,%esp
80107253:	85 c0                	test   %eax,%eax
80107255:	78 19                	js     80107270 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107257:	83 c3 10             	add    $0x10,%ebx
8010725a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107260:	75 d6                	jne    80107238 <setupkvm+0x28>
}
80107262:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107265:	89 f0                	mov    %esi,%eax
80107267:	5b                   	pop    %ebx
80107268:	5e                   	pop    %esi
80107269:	5d                   	pop    %ebp
8010726a:	c3                   	ret    
8010726b:	90                   	nop
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107270:	83 ec 0c             	sub    $0xc,%esp
80107273:	56                   	push   %esi
      return 0;
80107274:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107276:	e8 15 ff ff ff       	call   80107190 <freevm>
      return 0;
8010727b:	83 c4 10             	add    $0x10,%esp
}
8010727e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107281:	89 f0                	mov    %esi,%eax
80107283:	5b                   	pop    %ebx
80107284:	5e                   	pop    %esi
80107285:	5d                   	pop    %ebp
80107286:	c3                   	ret    
80107287:	89 f6                	mov    %esi,%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <kvmalloc>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107296:	e8 75 ff ff ff       	call   80107210 <setupkvm>
8010729b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a0:	05 00 00 00 80       	add    $0x80000000,%eax
801072a5:	0f 22 d8             	mov    %eax,%cr3
}
801072a8:	c9                   	leave  
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <clearpteu>:
{
801072b0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801072b1:	31 c9                	xor    %ecx,%ecx
{
801072b3:	89 e5                	mov    %esp,%ebp
801072b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072bb:	8b 45 08             	mov    0x8(%ebp),%eax
801072be:	e8 ad f7 ff ff       	call   80106a70 <walkpgdir>
  if(pte == 0)
801072c3:	85 c0                	test   %eax,%eax
801072c5:	74 05                	je     801072cc <clearpteu+0x1c>
  *pte &= ~PTE_U;
801072c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072ca:	c9                   	leave  
801072cb:	c3                   	ret    
    panic("clearpteu");
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	68 d7 7e 10 80       	push   $0x80107ed7
801072d4:	e8 c7 91 ff ff       	call   801004a0 <panic>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <copyuvm>:
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801072e9:	e8 22 ff ff ff       	call   80107210 <setupkvm>
801072ee:	85 c0                	test   %eax,%eax
801072f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072f3:	0f 84 a0 00 00 00    	je     80107399 <copyuvm+0xb9>
  for(i = 0; i < sz; i += PGSIZE){
801072f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072fc:	85 c9                	test   %ecx,%ecx
801072fe:	0f 84 95 00 00 00    	je     80107399 <copyuvm+0xb9>
80107304:	31 f6                	xor    %esi,%esi
80107306:	eb 4e                	jmp    80107356 <copyuvm+0x76>
80107308:	90                   	nop
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
80107313:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010731c:	68 00 10 00 00       	push   $0x1000
80107321:	57                   	push   %edi
80107322:	50                   	push   %eax
80107323:	e8 a8 d4 ff ff       	call   801047d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107328:	58                   	pop    %eax
80107329:	5a                   	pop    %edx
8010732a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010732d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107330:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107335:	53                   	push   %ebx
80107336:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010733c:	52                   	push   %edx
8010733d:	89 f2                	mov    %esi,%edx
8010733f:	e8 ac f7 ff ff       	call   80106af0 <mappages>
80107344:	83 c4 10             	add    $0x10,%esp
80107347:	85 c0                	test   %eax,%eax
80107349:	78 39                	js     80107384 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010734b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107351:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107354:	76 43                	jbe    80107399 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107356:	8b 45 08             	mov    0x8(%ebp),%eax
80107359:	31 c9                	xor    %ecx,%ecx
8010735b:	89 f2                	mov    %esi,%edx
8010735d:	e8 0e f7 ff ff       	call   80106a70 <walkpgdir>
80107362:	85 c0                	test   %eax,%eax
80107364:	74 3e                	je     801073a4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107366:	8b 18                	mov    (%eax),%ebx
80107368:	f6 c3 01             	test   $0x1,%bl
8010736b:	74 44                	je     801073b1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010736d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010736f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107375:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010737b:	e8 20 b4 ff ff       	call   801027a0 <kalloc>
80107380:	85 c0                	test   %eax,%eax
80107382:	75 8c                	jne    80107310 <copyuvm+0x30>
  freevm(d);
80107384:	83 ec 0c             	sub    $0xc,%esp
80107387:	ff 75 e0             	pushl  -0x20(%ebp)
8010738a:	e8 01 fe ff ff       	call   80107190 <freevm>
  return 0;
8010738f:	83 c4 10             	add    $0x10,%esp
80107392:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107399:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010739c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739f:	5b                   	pop    %ebx
801073a0:	5e                   	pop    %esi
801073a1:	5f                   	pop    %edi
801073a2:	5d                   	pop    %ebp
801073a3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801073a4:	83 ec 0c             	sub    $0xc,%esp
801073a7:	68 e1 7e 10 80       	push   $0x80107ee1
801073ac:	e8 ef 90 ff ff       	call   801004a0 <panic>
      panic("copyuvm: page not present");
801073b1:	83 ec 0c             	sub    $0xc,%esp
801073b4:	68 fb 7e 10 80       	push   $0x80107efb
801073b9:	e8 e2 90 ff ff       	call   801004a0 <panic>
801073be:	66 90                	xchg   %ax,%ax

801073c0 <uva2ka>:
{
801073c0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801073c1:	31 c9                	xor    %ecx,%ecx
{
801073c3:	89 e5                	mov    %esp,%ebp
801073c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073cb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ce:	e8 9d f6 ff ff       	call   80106a70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801073d3:	8b 00                	mov    (%eax),%eax
}
801073d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801073d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073e0:	05 00 00 00 80       	add    $0x80000000,%eax
801073e5:	83 fa 05             	cmp    $0x5,%edx
801073e8:	ba 00 00 00 00       	mov    $0x0,%edx
801073ed:	0f 45 c2             	cmovne %edx,%eax
}
801073f0:	c3                   	ret    
801073f1:	eb 0d                	jmp    80107400 <uva2pte>
801073f3:	90                   	nop
801073f4:	90                   	nop
801073f5:	90                   	nop
801073f6:	90                   	nop
801073f7:	90                   	nop
801073f8:	90                   	nop
801073f9:	90                   	nop
801073fa:	90                   	nop
801073fb:	90                   	nop
801073fc:	90                   	nop
801073fd:	90                   	nop
801073fe:	90                   	nop
801073ff:	90                   	nop

80107400 <uva2pte>:
{
80107400:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80107401:	31 c9                	xor    %ecx,%ecx
{
80107403:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80107405:	8b 55 0c             	mov    0xc(%ebp),%edx
80107408:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010740b:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
8010740c:	e9 5f f6 ff ff       	jmp    80106a70 <walkpgdir>
80107411:	eb 0d                	jmp    80107420 <copyout>
80107413:	90                   	nop
80107414:	90                   	nop
80107415:	90                   	nop
80107416:	90                   	nop
80107417:	90                   	nop
80107418:	90                   	nop
80107419:	90                   	nop
8010741a:	90                   	nop
8010741b:	90                   	nop
8010741c:	90                   	nop
8010741d:	90                   	nop
8010741e:	90                   	nop
8010741f:	90                   	nop

80107420 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
80107429:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010742c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010742f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107432:	85 db                	test   %ebx,%ebx
80107434:	75 40                	jne    80107476 <copyout+0x56>
80107436:	eb 70                	jmp    801074a8 <copyout+0x88>
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107443:	89 f1                	mov    %esi,%ecx
80107445:	29 d1                	sub    %edx,%ecx
80107447:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010744d:	39 d9                	cmp    %ebx,%ecx
8010744f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107452:	29 f2                	sub    %esi,%edx
80107454:	83 ec 04             	sub    $0x4,%esp
80107457:	01 d0                	add    %edx,%eax
80107459:	51                   	push   %ecx
8010745a:	57                   	push   %edi
8010745b:	50                   	push   %eax
8010745c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010745f:	e8 6c d3 ff ff       	call   801047d0 <memmove>
    len -= n;
    buf += n;
80107464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107467:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010746a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107470:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107472:	29 cb                	sub    %ecx,%ebx
80107474:	74 32                	je     801074a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107476:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107478:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010747b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010747e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107484:	56                   	push   %esi
80107485:	ff 75 08             	pushl  0x8(%ebp)
80107488:	e8 33 ff ff ff       	call   801073c0 <uva2ka>
    if(pa0 == 0)
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	75 ac                	jne    80107440 <copyout+0x20>
  }
  return 0;
}
80107494:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010749c:	5b                   	pop    %ebx
8010749d:	5e                   	pop    %esi
8010749e:	5f                   	pop    %edi
8010749f:	5d                   	pop    %ebp
801074a0:	c3                   	ret    
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074ab:	31 c0                	xor    %eax,%eax
}
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    


kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp
8010002d:	b8 e0 31 10 80       	mov    $0x801031e0,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <bget>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	57                   	push   %edi
80100044:	56                   	push   %esi
80100045:	53                   	push   %ebx
80100046:	89 c6                	mov    %eax,%esi
80100048:	89 d7                	mov    %edx,%edi
8010004a:	83 ec 18             	sub    $0x18,%esp
8010004d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100052:	e8 99 45 00 00       	call   801045f0 <acquire>
80100057:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
8010005d:	83 c4 10             	add    $0x10,%esp
80100060:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100066:	75 13                	jne    8010007b <bget+0x3b>
80100068:	eb 26                	jmp    80100090 <bget+0x50>
8010006a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100070:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100073:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100079:	74 15                	je     80100090 <bget+0x50>
8010007b:	39 73 04             	cmp    %esi,0x4(%ebx)
8010007e:	75 f0                	jne    80100070 <bget+0x30>
80100080:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100083:	75 eb                	jne    80100070 <bget+0x30>
80100085:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100089:	eb 3f                	jmp    801000ca <bget+0x8a>
8010008b:	90                   	nop
8010008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100090:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100096:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010009c:	75 0d                	jne    801000ab <bget+0x6b>
8010009e:	eb 4f                	jmp    801000ef <bget+0xaf>
801000a0:	8b 5b 50             	mov    0x50(%ebx),%ebx
801000a3:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000a9:	74 44                	je     801000ef <bget+0xaf>
801000ab:	8b 43 4c             	mov    0x4c(%ebx),%eax
801000ae:	85 c0                	test   %eax,%eax
801000b0:	75 ee                	jne    801000a0 <bget+0x60>
801000b2:	f6 03 04             	testb  $0x4,(%ebx)
801000b5:	75 e9                	jne    801000a0 <bget+0x60>
801000b7:	89 73 04             	mov    %esi,0x4(%ebx)
801000ba:	89 7b 08             	mov    %edi,0x8(%ebx)
801000bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801000c3:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
801000ca:	83 ec 0c             	sub    $0xc,%esp
801000cd:	68 c0 c5 10 80       	push   $0x8010c5c0
801000d2:	e8 39 46 00 00       	call   80104710 <release>
801000d7:	8d 43 0c             	lea    0xc(%ebx),%eax
801000da:	89 04 24             	mov    %eax,(%esp)
801000dd:	e8 4e 43 00 00       	call   80104430 <acquiresleep>
801000e2:	83 c4 10             	add    $0x10,%esp
801000e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e8:	89 d8                	mov    %ebx,%eax
801000ea:	5b                   	pop    %ebx
801000eb:	5e                   	pop    %esi
801000ec:	5f                   	pop    %edi
801000ed:	5d                   	pop    %ebp
801000ee:	c3                   	ret    
801000ef:	83 ec 0c             	sub    $0xc,%esp
801000f2:	68 a0 75 10 80       	push   $0x801075a0
801000f7:	e8 a4 03 00 00       	call   801004a0 <panic>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100100 <binit>:
80100100:	55                   	push   %ebp
80100101:	89 e5                	mov    %esp,%ebp
80100103:	53                   	push   %ebx
80100104:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
80100109:	83 ec 0c             	sub    $0xc,%esp
8010010c:	68 b1 75 10 80       	push   $0x801075b1
80100111:	68 c0 c5 10 80       	push   $0x8010c5c0
80100116:	e8 e5 43 00 00       	call   80104500 <initlock>
8010011b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100122:	0c 11 80 
80100125:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010012c:	0c 11 80 
8010012f:	83 c4 10             	add    $0x10,%esp
80100132:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100137:	eb 09                	jmp    80100142 <binit+0x42>
80100139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100140:	89 c3                	mov    %eax,%ebx
80100142:	8d 43 0c             	lea    0xc(%ebx),%eax
80100145:	83 ec 08             	sub    $0x8,%esp
80100148:	89 53 54             	mov    %edx,0x54(%ebx)
8010014b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
80100152:	68 b8 75 10 80       	push   $0x801075b8
80100157:	50                   	push   %eax
80100158:	e8 93 42 00 00       	call   801043f0 <initsleeplock>
8010015d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100162:	83 c4 10             	add    $0x10,%esp
80100165:	89 da                	mov    %ebx,%edx
80100167:	89 58 50             	mov    %ebx,0x50(%eax)
8010016a:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
80100170:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
80100176:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
8010017b:	72 c3                	jb     80100140 <binit+0x40>
8010017d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100180:	c9                   	leave  
80100181:	c3                   	ret    
80100182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100190 <bread>:
80100190:	55                   	push   %ebp
80100191:	89 e5                	mov    %esp,%ebp
80100193:	83 ec 18             	sub    $0x18,%esp
80100196:	8b 55 0c             	mov    0xc(%ebp),%edx
80100199:	8b 45 08             	mov    0x8(%ebp),%eax
8010019c:	e8 9f fe ff ff       	call   80100040 <bget>
801001a1:	f6 00 02             	testb  $0x2,(%eax)
801001a4:	74 0a                	je     801001b0 <bread+0x20>
801001a6:	c9                   	leave  
801001a7:	c3                   	ret    
801001a8:	90                   	nop
801001a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	50                   	push   %eax
801001b7:	e8 64 22 00 00       	call   80102420 <iderw>
801001bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001bf:	83 c4 10             	add    $0x10,%esp
801001c2:	c9                   	leave  
801001c3:	c3                   	ret    
801001c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801001ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001d0 <bwrite>:
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 10             	sub    $0x10,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001da:	8d 43 0c             	lea    0xc(%ebx),%eax
801001dd:	50                   	push   %eax
801001de:	e8 ed 42 00 00       	call   801044d0 <holdingsleep>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	85 c0                	test   %eax,%eax
801001e8:	74 0f                	je     801001f9 <bwrite+0x29>
801001ea:	83 0b 04             	orl    $0x4,(%ebx)
801001ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001f3:	c9                   	leave  
801001f4:	e9 27 22 00 00       	jmp    80102420 <iderw>
801001f9:	83 ec 0c             	sub    $0xc,%esp
801001fc:	68 bf 75 10 80       	push   $0x801075bf
80100201:	e8 9a 02 00 00       	call   801004a0 <panic>
80100206:	8d 76 00             	lea    0x0(%esi),%esi
80100209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100210 <brelse>:
80100210:	55                   	push   %ebp
80100211:	89 e5                	mov    %esp,%ebp
80100213:	56                   	push   %esi
80100214:	53                   	push   %ebx
80100215:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100218:	83 ec 0c             	sub    $0xc,%esp
8010021b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010021e:	56                   	push   %esi
8010021f:	e8 ac 42 00 00       	call   801044d0 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	74 66                	je     80100291 <brelse+0x81>
8010022b:	83 ec 0c             	sub    $0xc,%esp
8010022e:	56                   	push   %esi
8010022f:	e8 5c 42 00 00       	call   80104490 <releasesleep>
80100234:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010023b:	e8 b0 43 00 00       	call   801045f0 <acquire>
80100240:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100243:	83 c4 10             	add    $0x10,%esp
80100246:	83 e8 01             	sub    $0x1,%eax
80100249:	85 c0                	test   %eax,%eax
8010024b:	89 43 4c             	mov    %eax,0x4c(%ebx)
8010024e:	75 2f                	jne    8010027f <brelse+0x6f>
80100250:	8b 43 54             	mov    0x54(%ebx),%eax
80100253:	8b 53 50             	mov    0x50(%ebx),%edx
80100256:	89 50 50             	mov    %edx,0x50(%eax)
80100259:	8b 43 50             	mov    0x50(%ebx),%eax
8010025c:	8b 53 54             	mov    0x54(%ebx),%edx
8010025f:	89 50 54             	mov    %edx,0x54(%eax)
80100262:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100267:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
8010026e:	89 43 54             	mov    %eax,0x54(%ebx)
80100271:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100276:	89 58 50             	mov    %ebx,0x50(%eax)
80100279:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
8010027f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
80100286:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100289:	5b                   	pop    %ebx
8010028a:	5e                   	pop    %esi
8010028b:	5d                   	pop    %ebp
8010028c:	e9 7f 44 00 00       	jmp    80104710 <release>
80100291:	83 ec 0c             	sub    $0xc,%esp
80100294:	68 c6 75 10 80       	push   $0x801075c6
80100299:	e8 02 02 00 00       	call   801004a0 <panic>
8010029e:	66 90                	xchg   %ax,%ax

801002a0 <write_page_to_disk>:
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
801002c0:	8b 45 08             	mov    0x8(%ebp),%eax
801002c3:	89 da                	mov    %ebx,%edx
801002c5:	e8 76 fd ff ff       	call   80100040 <bget>
801002ca:	31 d2                	xor    %edx,%edx
801002cc:	89 c7                	mov    %eax,%edi
801002ce:	66 90                	xchg   %ax,%ax
801002d0:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
801002d4:	88 44 17 5c          	mov    %al,0x5c(%edi,%edx,1)
801002d8:	83 c2 01             	add    $0x1,%edx
801002db:	81 fa 00 02 00 00    	cmp    $0x200,%edx
801002e1:	75 ed                	jne    801002d0 <write_page_to_disk+0x30>
801002e3:	83 ec 0c             	sub    $0xc,%esp
801002e6:	83 c3 01             	add    $0x1,%ebx
801002e9:	81 c6 00 02 00 00    	add    $0x200,%esi
801002ef:	57                   	push   %edi
801002f0:	e8 db fe ff ff       	call   801001d0 <bwrite>
801002f5:	89 3c 24             	mov    %edi,(%esp)
801002f8:	e8 13 ff ff ff       	call   80100210 <brelse>
801002fd:	83 c4 10             	add    $0x10,%esp
80100300:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100303:	75 bb                	jne    801002c0 <write_page_to_disk+0x20>
80100305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100308:	5b                   	pop    %ebx
80100309:	5e                   	pop    %esi
8010030a:	5f                   	pop    %edi
8010030b:	5d                   	pop    %ebp
8010030c:	c3                   	ret    
8010030d:	8d 76 00             	lea    0x0(%esi),%esi

80100310 <read_page_from_disk>:
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
80100328:	83 ec 08             	sub    $0x8,%esp
8010032b:	53                   	push   %ebx
8010032c:	6a 01                	push   $0x1
8010032e:	e8 5d fe ff ff       	call   80100190 <bread>
80100333:	83 c4 10             	add    $0x10,%esp
80100336:	31 d2                	xor    %edx,%edx
80100338:	90                   	nop
80100339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100340:	0f b6 4c 10 5c       	movzbl 0x5c(%eax,%edx,1),%ecx
80100345:	88 0c 17             	mov    %cl,(%edi,%edx,1)
80100348:	83 c2 01             	add    $0x1,%edx
8010034b:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80100351:	75 ed                	jne    80100340 <read_page_from_disk+0x30>
80100353:	83 ec 0c             	sub    $0xc,%esp
80100356:	81 c7 00 02 00 00    	add    $0x200,%edi
8010035c:	83 c3 01             	add    $0x1,%ebx
8010035f:	50                   	push   %eax
80100360:	e8 ab fe ff ff       	call   80100210 <brelse>
80100365:	83 c4 10             	add    $0x10,%esp
80100368:	39 fe                	cmp    %edi,%esi
8010036a:	75 bc                	jne    80100328 <read_page_from_disk+0x18>
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
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	57                   	push   %edi
80100384:	56                   	push   %esi
80100385:	53                   	push   %ebx
80100386:	83 ec 28             	sub    $0x28,%esp
80100389:	8b 7d 08             	mov    0x8(%ebp),%edi
8010038c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010038f:	57                   	push   %edi
80100390:	e8 9b 16 00 00       	call   80101a30 <iunlock>
80100395:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010039c:	e8 4f 42 00 00       	call   801045f0 <acquire>
801003a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801003a4:	83 c4 10             	add    $0x10,%esp
801003a7:	31 c0                	xor    %eax,%eax
801003a9:	85 db                	test   %ebx,%ebx
801003ab:	0f 8e a1 00 00 00    	jle    80100452 <consoleread+0xd2>
801003b1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801003b7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801003bd:	74 2c                	je     801003eb <consoleread+0x6b>
801003bf:	eb 5f                	jmp    80100420 <consoleread+0xa0>
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	68 20 b5 10 80       	push   $0x8010b520
801003d0:	68 a0 0f 11 80       	push   $0x80110fa0
801003d5:	e8 b6 3c 00 00       	call   80104090 <sleep>
801003da:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801003e0:	83 c4 10             	add    $0x10,%esp
801003e3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801003e9:	75 35                	jne    80100420 <consoleread+0xa0>
801003eb:	e8 30 37 00 00       	call   80103b20 <myproc>
801003f0:	8b 40 24             	mov    0x24(%eax),%eax
801003f3:	85 c0                	test   %eax,%eax
801003f5:	74 d1                	je     801003c8 <consoleread+0x48>
801003f7:	83 ec 0c             	sub    $0xc,%esp
801003fa:	68 20 b5 10 80       	push   $0x8010b520
801003ff:	e8 0c 43 00 00       	call   80104710 <release>
80100404:	89 3c 24             	mov    %edi,(%esp)
80100407:	e8 44 15 00 00       	call   80101950 <ilock>
8010040c:	83 c4 10             	add    $0x10,%esp
8010040f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100417:	5b                   	pop    %ebx
80100418:	5e                   	pop    %esi
80100419:	5f                   	pop    %edi
8010041a:	5d                   	pop    %ebp
8010041b:	c3                   	ret    
8010041c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100420:	8d 42 01             	lea    0x1(%edx),%eax
80100423:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100428:	89 d0                	mov    %edx,%eax
8010042a:	83 e0 7f             	and    $0x7f,%eax
8010042d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
80100434:	83 f8 04             	cmp    $0x4,%eax
80100437:	74 3f                	je     80100478 <consoleread+0xf8>
80100439:	83 c6 01             	add    $0x1,%esi
8010043c:	83 eb 01             	sub    $0x1,%ebx
8010043f:	83 f8 0a             	cmp    $0xa,%eax
80100442:	88 46 ff             	mov    %al,-0x1(%esi)
80100445:	74 43                	je     8010048a <consoleread+0x10a>
80100447:	85 db                	test   %ebx,%ebx
80100449:	0f 85 62 ff ff ff    	jne    801003b1 <consoleread+0x31>
8010044f:	8b 45 10             	mov    0x10(%ebp),%eax
80100452:	83 ec 0c             	sub    $0xc,%esp
80100455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100458:	68 20 b5 10 80       	push   $0x8010b520
8010045d:	e8 ae 42 00 00       	call   80104710 <release>
80100462:	89 3c 24             	mov    %edi,(%esp)
80100465:	e8 e6 14 00 00       	call   80101950 <ilock>
8010046a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010046d:	83 c4 10             	add    $0x10,%esp
80100470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100473:	5b                   	pop    %ebx
80100474:	5e                   	pop    %esi
80100475:	5f                   	pop    %edi
80100476:	5d                   	pop    %ebp
80100477:	c3                   	ret    
80100478:	8b 45 10             	mov    0x10(%ebp),%eax
8010047b:	29 d8                	sub    %ebx,%eax
8010047d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100480:	73 d0                	jae    80100452 <consoleread+0xd2>
80100482:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
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
801004a0:	55                   	push   %ebp
801004a1:	89 e5                	mov    %esp,%ebp
801004a3:	56                   	push   %esi
801004a4:	53                   	push   %ebx
801004a5:	83 ec 30             	sub    $0x30,%esp
801004a8:	fa                   	cli    
801004a9:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801004b0:	00 00 00 
801004b3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004b6:	8d 75 f8             	lea    -0x8(%ebp),%esi
801004b9:	e8 a2 25 00 00       	call   80102a60 <lapicid>
801004be:	83 ec 08             	sub    $0x8,%esp
801004c1:	50                   	push   %eax
801004c2:	68 cd 75 10 80       	push   $0x801075cd
801004c7:	e8 a4 02 00 00       	call   80100770 <cprintf>
801004cc:	58                   	pop    %eax
801004cd:	ff 75 08             	pushl  0x8(%ebp)
801004d0:	e8 9b 02 00 00       	call   80100770 <cprintf>
801004d5:	c7 04 24 a4 7f 10 80 	movl   $0x80107fa4,(%esp)
801004dc:	e8 8f 02 00 00       	call   80100770 <cprintf>
801004e1:	5a                   	pop    %edx
801004e2:	8d 45 08             	lea    0x8(%ebp),%eax
801004e5:	59                   	pop    %ecx
801004e6:	53                   	push   %ebx
801004e7:	50                   	push   %eax
801004e8:	e8 33 40 00 00       	call   80104520 <getcallerpcs>
801004ed:	83 c4 10             	add    $0x10,%esp
801004f0:	83 ec 08             	sub    $0x8,%esp
801004f3:	ff 33                	pushl  (%ebx)
801004f5:	83 c3 04             	add    $0x4,%ebx
801004f8:	68 e1 75 10 80       	push   $0x801075e1
801004fd:	e8 6e 02 00 00       	call   80100770 <cprintf>
80100502:	83 c4 10             	add    $0x10,%esp
80100505:	39 f3                	cmp    %esi,%ebx
80100507:	75 e7                	jne    801004f0 <panic+0x50>
80100509:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100510:	00 00 00 
80100513:	eb fe                	jmp    80100513 <panic+0x73>
80100515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100520 <consputc>:
80100520:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100526:	85 c9                	test   %ecx,%ecx
80100528:	74 06                	je     80100530 <consputc+0x10>
8010052a:	fa                   	cli    
8010052b:	eb fe                	jmp    8010052b <consputc+0xb>
8010052d:	8d 76 00             	lea    0x0(%esi),%esi
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	57                   	push   %edi
80100534:	56                   	push   %esi
80100535:	53                   	push   %ebx
80100536:	89 c6                	mov    %eax,%esi
80100538:	83 ec 0c             	sub    $0xc,%esp
8010053b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100540:	0f 84 b1 00 00 00    	je     801005f7 <consputc+0xd7>
80100546:	83 ec 0c             	sub    $0xc,%esp
80100549:	50                   	push   %eax
8010054a:	e8 f1 5a 00 00       	call   80106040 <uartputc>
8010054f:	83 c4 10             	add    $0x10,%esp
80100552:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100557:	b8 0e 00 00 00       	mov    $0xe,%eax
8010055c:	89 da                	mov    %ebx,%edx
8010055e:	ee                   	out    %al,(%dx)
8010055f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100564:	89 ca                	mov    %ecx,%edx
80100566:	ec                   	in     (%dx),%al
80100567:	0f b6 c0             	movzbl %al,%eax
8010056a:	89 da                	mov    %ebx,%edx
8010056c:	c1 e0 08             	shl    $0x8,%eax
8010056f:	89 c7                	mov    %eax,%edi
80100571:	b8 0f 00 00 00       	mov    $0xf,%eax
80100576:	ee                   	out    %al,(%dx)
80100577:	89 ca                	mov    %ecx,%edx
80100579:	ec                   	in     (%dx),%al
8010057a:	0f b6 d8             	movzbl %al,%ebx
8010057d:	09 fb                	or     %edi,%ebx
8010057f:	83 fe 0a             	cmp    $0xa,%esi
80100582:	0f 84 f3 00 00 00    	je     8010067b <consputc+0x15b>
80100588:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010058e:	0f 84 d7 00 00 00    	je     8010066b <consputc+0x14b>
80100594:	89 f0                	mov    %esi,%eax
80100596:	0f b6 c0             	movzbl %al,%eax
80100599:	80 cc 07             	or     $0x7,%ah
8010059c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005a3:	80 
801005a4:	83 c3 01             	add    $0x1,%ebx
801005a7:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801005ad:	0f 8f ab 00 00 00    	jg     8010065e <consputc+0x13e>
801005b3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801005b9:	7f 66                	jg     80100621 <consputc+0x101>
801005bb:	be d4 03 00 00       	mov    $0x3d4,%esi
801005c0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005c5:	89 f2                	mov    %esi,%edx
801005c7:	ee                   	out    %al,(%dx)
801005c8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
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
801005e2:	b8 20 07 00 00       	mov    $0x720,%eax
801005e7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005ee:	80 
801005ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f2:	5b                   	pop    %ebx
801005f3:	5e                   	pop    %esi
801005f4:	5f                   	pop    %edi
801005f5:	5d                   	pop    %ebp
801005f6:	c3                   	ret    
801005f7:	83 ec 0c             	sub    $0xc,%esp
801005fa:	6a 08                	push   $0x8
801005fc:	e8 3f 5a 00 00       	call   80106040 <uartputc>
80100601:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100608:	e8 33 5a 00 00       	call   80106040 <uartputc>
8010060d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100614:	e8 27 5a 00 00       	call   80106040 <uartputc>
80100619:	83 c4 10             	add    $0x10,%esp
8010061c:	e9 31 ff ff ff       	jmp    80100552 <consputc+0x32>
80100621:	52                   	push   %edx
80100622:	68 60 0e 00 00       	push   $0xe60
80100627:	83 eb 50             	sub    $0x50,%ebx
8010062a:	68 a0 80 0b 80       	push   $0x800b80a0
8010062f:	68 00 80 0b 80       	push   $0x800b8000
80100634:	e8 e7 41 00 00       	call   80104820 <memmove>
80100639:	b8 80 07 00 00       	mov    $0x780,%eax
8010063e:	83 c4 0c             	add    $0xc,%esp
80100641:	29 d8                	sub    %ebx,%eax
80100643:	01 c0                	add    %eax,%eax
80100645:	50                   	push   %eax
80100646:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100649:	6a 00                	push   $0x0
8010064b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100650:	50                   	push   %eax
80100651:	e8 1a 41 00 00       	call   80104770 <memset>
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	e9 5d ff ff ff       	jmp    801005bb <consputc+0x9b>
8010065e:	83 ec 0c             	sub    $0xc,%esp
80100661:	68 e5 75 10 80       	push   $0x801075e5
80100666:	e8 35 fe ff ff       	call   801004a0 <panic>
8010066b:	85 db                	test   %ebx,%ebx
8010066d:	0f 84 48 ff ff ff    	je     801005bb <consputc+0x9b>
80100673:	83 eb 01             	sub    $0x1,%ebx
80100676:	e9 2c ff ff ff       	jmp    801005a7 <consputc+0x87>
8010067b:	89 d8                	mov    %ebx,%eax
8010067d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100682:	99                   	cltd   
80100683:	f7 f9                	idiv   %ecx
80100685:	29 d1                	sub    %edx,%ecx
80100687:	01 cb                	add    %ecx,%ebx
80100689:	e9 19 ff ff ff       	jmp    801005a7 <consputc+0x87>
8010068e:	66 90                	xchg   %ax,%ax

80100690 <printint>:
80100690:	55                   	push   %ebp
80100691:	89 e5                	mov    %esp,%ebp
80100693:	57                   	push   %edi
80100694:	56                   	push   %esi
80100695:	53                   	push   %ebx
80100696:	89 d3                	mov    %edx,%ebx
80100698:	83 ec 2c             	sub    $0x2c,%esp
8010069b:	85 c9                	test   %ecx,%ecx
8010069d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
801006a0:	74 04                	je     801006a6 <printint+0x16>
801006a2:	85 c0                	test   %eax,%eax
801006a4:	78 5a                	js     80100700 <printint+0x70>
801006a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801006ad:	31 c9                	xor    %ecx,%ecx
801006af:	8d 75 d7             	lea    -0x29(%ebp),%esi
801006b2:	eb 06                	jmp    801006ba <printint+0x2a>
801006b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006b8:	89 f9                	mov    %edi,%ecx
801006ba:	31 d2                	xor    %edx,%edx
801006bc:	8d 79 01             	lea    0x1(%ecx),%edi
801006bf:	f7 f3                	div    %ebx
801006c1:	0f b6 92 10 76 10 80 	movzbl -0x7fef89f0(%edx),%edx
801006c8:	85 c0                	test   %eax,%eax
801006ca:	88 14 3e             	mov    %dl,(%esi,%edi,1)
801006cd:	75 e9                	jne    801006b8 <printint+0x28>
801006cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006d2:	85 c0                	test   %eax,%eax
801006d4:	74 08                	je     801006de <printint+0x4e>
801006d6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006db:	8d 79 02             	lea    0x2(%ecx),%edi
801006de:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006e8:	0f be 03             	movsbl (%ebx),%eax
801006eb:	83 eb 01             	sub    $0x1,%ebx
801006ee:	e8 2d fe ff ff       	call   80100520 <consputc>
801006f3:	39 f3                	cmp    %esi,%ebx
801006f5:	75 f1                	jne    801006e8 <printint+0x58>
801006f7:	83 c4 2c             	add    $0x2c,%esp
801006fa:	5b                   	pop    %ebx
801006fb:	5e                   	pop    %esi
801006fc:	5f                   	pop    %edi
801006fd:	5d                   	pop    %ebp
801006fe:	c3                   	ret    
801006ff:	90                   	nop
80100700:	f7 d8                	neg    %eax
80100702:	eb a9                	jmp    801006ad <printint+0x1d>
80100704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010070a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100710 <consolewrite>:
80100710:	55                   	push   %ebp
80100711:	89 e5                	mov    %esp,%ebp
80100713:	57                   	push   %edi
80100714:	56                   	push   %esi
80100715:	53                   	push   %ebx
80100716:	83 ec 18             	sub    $0x18,%esp
80100719:	8b 75 10             	mov    0x10(%ebp),%esi
8010071c:	ff 75 08             	pushl  0x8(%ebp)
8010071f:	e8 0c 13 00 00       	call   80101a30 <iunlock>
80100724:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010072b:	e8 c0 3e 00 00       	call   801045f0 <acquire>
80100730:	83 c4 10             	add    $0x10,%esp
80100733:	85 f6                	test   %esi,%esi
80100735:	7e 18                	jle    8010074f <consolewrite+0x3f>
80100737:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010073a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010073d:	8d 76 00             	lea    0x0(%esi),%esi
80100740:	0f b6 07             	movzbl (%edi),%eax
80100743:	83 c7 01             	add    $0x1,%edi
80100746:	e8 d5 fd ff ff       	call   80100520 <consputc>
8010074b:	39 fb                	cmp    %edi,%ebx
8010074d:	75 f1                	jne    80100740 <consolewrite+0x30>
8010074f:	83 ec 0c             	sub    $0xc,%esp
80100752:	68 20 b5 10 80       	push   $0x8010b520
80100757:	e8 b4 3f 00 00       	call   80104710 <release>
8010075c:	58                   	pop    %eax
8010075d:	ff 75 08             	pushl  0x8(%ebp)
80100760:	e8 eb 11 00 00       	call   80101950 <ilock>
80100765:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100768:	89 f0                	mov    %esi,%eax
8010076a:	5b                   	pop    %ebx
8010076b:	5e                   	pop    %esi
8010076c:	5f                   	pop    %edi
8010076d:	5d                   	pop    %ebp
8010076e:	c3                   	ret    
8010076f:	90                   	nop

80100770 <cprintf>:
80100770:	55                   	push   %ebp
80100771:	89 e5                	mov    %esp,%ebp
80100773:	57                   	push   %edi
80100774:	56                   	push   %esi
80100775:	53                   	push   %ebx
80100776:	83 ec 1c             	sub    $0x1c,%esp
80100779:	a1 54 b5 10 80       	mov    0x8010b554,%eax
8010077e:	85 c0                	test   %eax,%eax
80100780:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100783:	0f 85 6f 01 00 00    	jne    801008f8 <cprintf+0x188>
80100789:	8b 45 08             	mov    0x8(%ebp),%eax
8010078c:	85 c0                	test   %eax,%eax
8010078e:	89 c7                	mov    %eax,%edi
80100790:	0f 84 77 01 00 00    	je     8010090d <cprintf+0x19d>
80100796:	0f b6 00             	movzbl (%eax),%eax
80100799:	8d 4d 0c             	lea    0xc(%ebp),%ecx
8010079c:	31 db                	xor    %ebx,%ebx
8010079e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007a1:	85 c0                	test   %eax,%eax
801007a3:	75 56                	jne    801007fb <cprintf+0x8b>
801007a5:	eb 79                	jmp    80100820 <cprintf+0xb0>
801007a7:	89 f6                	mov    %esi,%esi
801007a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801007b0:	0f b6 16             	movzbl (%esi),%edx
801007b3:	85 d2                	test   %edx,%edx
801007b5:	74 69                	je     80100820 <cprintf+0xb0>
801007b7:	83 c3 02             	add    $0x2,%ebx
801007ba:	83 fa 70             	cmp    $0x70,%edx
801007bd:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007c0:	0f 84 84 00 00 00    	je     8010084a <cprintf+0xda>
801007c6:	7f 78                	jg     80100840 <cprintf+0xd0>
801007c8:	83 fa 25             	cmp    $0x25,%edx
801007cb:	0f 84 ff 00 00 00    	je     801008d0 <cprintf+0x160>
801007d1:	83 fa 64             	cmp    $0x64,%edx
801007d4:	0f 85 8e 00 00 00    	jne    80100868 <cprintf+0xf8>
801007da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007dd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007e2:	8d 48 04             	lea    0x4(%eax),%ecx
801007e5:	8b 00                	mov    (%eax),%eax
801007e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007ea:	b9 01 00 00 00       	mov    $0x1,%ecx
801007ef:	e8 9c fe ff ff       	call   80100690 <printint>
801007f4:	0f b6 06             	movzbl (%esi),%eax
801007f7:	85 c0                	test   %eax,%eax
801007f9:	74 25                	je     80100820 <cprintf+0xb0>
801007fb:	8d 53 01             	lea    0x1(%ebx),%edx
801007fe:	83 f8 25             	cmp    $0x25,%eax
80100801:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100804:	74 aa                	je     801007b0 <cprintf+0x40>
80100806:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100809:	e8 12 fd ff ff       	call   80100520 <consputc>
8010080e:	0f b6 06             	movzbl (%esi),%eax
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	89 d3                	mov    %edx,%ebx
80100816:	85 c0                	test   %eax,%eax
80100818:	75 e1                	jne    801007fb <cprintf+0x8b>
8010081a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100820:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100823:	85 c0                	test   %eax,%eax
80100825:	74 10                	je     80100837 <cprintf+0xc7>
80100827:	83 ec 0c             	sub    $0xc,%esp
8010082a:	68 20 b5 10 80       	push   $0x8010b520
8010082f:	e8 dc 3e 00 00       	call   80104710 <release>
80100834:	83 c4 10             	add    $0x10,%esp
80100837:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	90                   	nop
80100840:	83 fa 73             	cmp    $0x73,%edx
80100843:	74 43                	je     80100888 <cprintf+0x118>
80100845:	83 fa 78             	cmp    $0x78,%edx
80100848:	75 1e                	jne    80100868 <cprintf+0xf8>
8010084a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010084d:	ba 10 00 00 00       	mov    $0x10,%edx
80100852:	8d 48 04             	lea    0x4(%eax),%ecx
80100855:	8b 00                	mov    (%eax),%eax
80100857:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010085a:	31 c9                	xor    %ecx,%ecx
8010085c:	e8 2f fe ff ff       	call   80100690 <printint>
80100861:	eb 91                	jmp    801007f4 <cprintf+0x84>
80100863:	90                   	nop
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100868:	b8 25 00 00 00       	mov    $0x25,%eax
8010086d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100870:	e8 ab fc ff ff       	call   80100520 <consputc>
80100875:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100878:	89 d0                	mov    %edx,%eax
8010087a:	e8 a1 fc ff ff       	call   80100520 <consputc>
8010087f:	e9 70 ff ff ff       	jmp    801007f4 <cprintf+0x84>
80100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010088b:	8b 10                	mov    (%eax),%edx
8010088d:	8d 48 04             	lea    0x4(%eax),%ecx
80100890:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100893:	85 d2                	test   %edx,%edx
80100895:	74 49                	je     801008e0 <cprintf+0x170>
80100897:	0f be 02             	movsbl (%edx),%eax
8010089a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010089d:	84 c0                	test   %al,%al
8010089f:	0f 84 4f ff ff ff    	je     801007f4 <cprintf+0x84>
801008a5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008a8:	89 d3                	mov    %edx,%ebx
801008aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008b0:	83 c3 01             	add    $0x1,%ebx
801008b3:	e8 68 fc ff ff       	call   80100520 <consputc>
801008b8:	0f be 03             	movsbl (%ebx),%eax
801008bb:	84 c0                	test   %al,%al
801008bd:	75 f1                	jne    801008b0 <cprintf+0x140>
801008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008c8:	e9 27 ff ff ff       	jmp    801007f4 <cprintf+0x84>
801008cd:	8d 76 00             	lea    0x0(%esi),%esi
801008d0:	b8 25 00 00 00       	mov    $0x25,%eax
801008d5:	e8 46 fc ff ff       	call   80100520 <consputc>
801008da:	e9 15 ff ff ff       	jmp    801007f4 <cprintf+0x84>
801008df:	90                   	nop
801008e0:	ba f8 75 10 80       	mov    $0x801075f8,%edx
801008e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008e8:	b8 28 00 00 00       	mov    $0x28,%eax
801008ed:	89 d3                	mov    %edx,%ebx
801008ef:	eb bf                	jmp    801008b0 <cprintf+0x140>
801008f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008f8:	83 ec 0c             	sub    $0xc,%esp
801008fb:	68 20 b5 10 80       	push   $0x8010b520
80100900:	e8 eb 3c 00 00       	call   801045f0 <acquire>
80100905:	83 c4 10             	add    $0x10,%esp
80100908:	e9 7c fe ff ff       	jmp    80100789 <cprintf+0x19>
8010090d:	83 ec 0c             	sub    $0xc,%esp
80100910:	68 ff 75 10 80       	push   $0x801075ff
80100915:	e8 86 fb ff ff       	call   801004a0 <panic>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100920 <consoleintr>:
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	57                   	push   %edi
80100924:	56                   	push   %esi
80100925:	53                   	push   %ebx
80100926:	31 f6                	xor    %esi,%esi
80100928:	83 ec 18             	sub    $0x18,%esp
8010092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010092e:	68 20 b5 10 80       	push   $0x8010b520
80100933:	e8 b8 3c 00 00       	call   801045f0 <acquire>
80100938:	83 c4 10             	add    $0x10,%esp
8010093b:	90                   	nop
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100940:	ff d3                	call   *%ebx
80100942:	85 c0                	test   %eax,%eax
80100944:	89 c7                	mov    %eax,%edi
80100946:	78 48                	js     80100990 <consoleintr+0x70>
80100948:	83 ff 10             	cmp    $0x10,%edi
8010094b:	0f 84 e7 00 00 00    	je     80100a38 <consoleintr+0x118>
80100951:	7e 5d                	jle    801009b0 <consoleintr+0x90>
80100953:	83 ff 15             	cmp    $0x15,%edi
80100956:	0f 84 ec 00 00 00    	je     80100a48 <consoleintr+0x128>
8010095c:	83 ff 7f             	cmp    $0x7f,%edi
8010095f:	75 54                	jne    801009b5 <consoleintr+0x95>
80100961:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100966:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096c:	74 d2                	je     80100940 <consoleintr+0x20>
8010096e:	83 e8 01             	sub    $0x1,%eax
80100971:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
80100976:	b8 00 01 00 00       	mov    $0x100,%eax
8010097b:	e8 a0 fb ff ff       	call   80100520 <consputc>
80100980:	ff d3                	call   *%ebx
80100982:	85 c0                	test   %eax,%eax
80100984:	89 c7                	mov    %eax,%edi
80100986:	79 c0                	jns    80100948 <consoleintr+0x28>
80100988:	90                   	nop
80100989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100990:	83 ec 0c             	sub    $0xc,%esp
80100993:	68 20 b5 10 80       	push   $0x8010b520
80100998:	e8 73 3d 00 00       	call   80104710 <release>
8010099d:	83 c4 10             	add    $0x10,%esp
801009a0:	85 f6                	test   %esi,%esi
801009a2:	0f 85 f8 00 00 00    	jne    80100aa0 <consoleintr+0x180>
801009a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ab:	5b                   	pop    %ebx
801009ac:	5e                   	pop    %esi
801009ad:	5f                   	pop    %edi
801009ae:	5d                   	pop    %ebp
801009af:	c3                   	ret    
801009b0:	83 ff 08             	cmp    $0x8,%edi
801009b3:	74 ac                	je     80100961 <consoleintr+0x41>
801009b5:	85 ff                	test   %edi,%edi
801009b7:	74 87                	je     80100940 <consoleintr+0x20>
801009b9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801009c6:	83 fa 7f             	cmp    $0x7f,%edx
801009c9:	0f 87 71 ff ff ff    	ja     80100940 <consoleintr+0x20>
801009cf:	8d 50 01             	lea    0x1(%eax),%edx
801009d2:	83 e0 7f             	and    $0x7f,%eax
801009d5:	83 ff 0d             	cmp    $0xd,%edi
801009d8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
801009de:	0f 84 cc 00 00 00    	je     80100ab0 <consoleintr+0x190>
801009e4:	89 f9                	mov    %edi,%ecx
801009e6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
801009ec:	89 f8                	mov    %edi,%eax
801009ee:	e8 2d fb ff ff       	call   80100520 <consputc>
801009f3:	83 ff 0a             	cmp    $0xa,%edi
801009f6:	0f 84 c5 00 00 00    	je     80100ac1 <consoleintr+0x1a1>
801009fc:	83 ff 04             	cmp    $0x4,%edi
801009ff:	0f 84 bc 00 00 00    	je     80100ac1 <consoleintr+0x1a1>
80100a05:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100a0a:	83 e8 80             	sub    $0xffffff80,%eax
80100a0d:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100a13:	0f 85 27 ff ff ff    	jne    80100940 <consoleintr+0x20>
80100a19:	83 ec 0c             	sub    $0xc,%esp
80100a1c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
80100a21:	68 a0 0f 11 80       	push   $0x80110fa0
80100a26:	e8 25 38 00 00       	call   80104250 <wakeup>
80100a2b:	83 c4 10             	add    $0x10,%esp
80100a2e:	e9 0d ff ff ff       	jmp    80100940 <consoleintr+0x20>
80100a33:	90                   	nop
80100a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a38:	be 01 00 00 00       	mov    $0x1,%esi
80100a3d:	e9 fe fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a48:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a4d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100a53:	75 2b                	jne    80100a80 <consoleintr+0x160>
80100a55:	e9 e6 fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a60:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
80100a65:	b8 00 01 00 00       	mov    $0x100,%eax
80100a6a:	e8 b1 fa ff ff       	call   80100520 <consputc>
80100a6f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a74:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100a7a:	0f 84 c0 fe ff ff    	je     80100940 <consoleintr+0x20>
80100a80:	83 e8 01             	sub    $0x1,%eax
80100a83:	89 c2                	mov    %eax,%edx
80100a85:	83 e2 7f             	and    $0x7f,%edx
80100a88:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100a8f:	75 cf                	jne    80100a60 <consoleintr+0x140>
80100a91:	e9 aa fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a96:	8d 76 00             	lea    0x0(%esi),%esi
80100a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
80100aa7:	e9 84 38 00 00       	jmp    80104330 <procdump>
80100aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ab0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
80100ab7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100abc:	e8 5f fa ff ff       	call   80100520 <consputc>
80100ac1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100ac6:	e9 4e ff ff ff       	jmp    80100a19 <consoleintr+0xf9>
80100acb:	90                   	nop
80100acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ad0 <consoleinit>:
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 10             	sub    $0x10,%esp
80100ad6:	68 08 76 10 80       	push   $0x80107608
80100adb:	68 20 b5 10 80       	push   $0x8010b520
80100ae0:	e8 1b 3a 00 00       	call   80104500 <initlock>
80100ae5:	58                   	pop    %eax
80100ae6:	5a                   	pop    %edx
80100ae7:	6a 00                	push   $0x0
80100ae9:	6a 01                	push   $0x1
80100aeb:	c7 05 6c 19 11 80 10 	movl   $0x80100710,0x8011196c
80100af2:	07 10 80 
80100af5:	c7 05 68 19 11 80 80 	movl   $0x80100380,0x80111968
80100afc:	03 10 80 
80100aff:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100b06:	00 00 00 
80100b09:	e8 c2 1a 00 00       	call   801025d0 <ioapicenable>
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
80100b20:	55                   	push   %ebp
80100b21:	89 e5                	mov    %esp,%ebp
80100b23:	57                   	push   %edi
80100b24:	56                   	push   %esi
80100b25:	53                   	push   %ebx
80100b26:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80100b2c:	e8 ef 2f 00 00       	call   80103b20 <myproc>
80100b31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b37:	e8 94 23 00 00       	call   80102ed0 <begin_op>
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	pushl  0x8(%ebp)
80100b42:	e8 a9 16 00 00       	call   801021f0 <namei>
80100b47:	83 c4 10             	add    $0x10,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 84 91 01 00 00    	je     80100ce3 <exec+0x1c3>
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	89 c3                	mov    %eax,%ebx
80100b57:	50                   	push   %eax
80100b58:	e8 f3 0d 00 00       	call   80101950 <ilock>
80100b5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b63:	6a 34                	push   $0x34
80100b65:	6a 00                	push   $0x0
80100b67:	50                   	push   %eax
80100b68:	53                   	push   %ebx
80100b69:	e8 c2 10 00 00       	call   80101c30 <readi>
80100b6e:	83 c4 20             	add    $0x20,%esp
80100b71:	83 f8 34             	cmp    $0x34,%eax
80100b74:	74 22                	je     80100b98 <exec+0x78>
80100b76:	83 ec 0c             	sub    $0xc,%esp
80100b79:	53                   	push   %ebx
80100b7a:	e8 61 10 00 00       	call   80101be0 <iunlockput>
80100b7f:	e8 bc 23 00 00       	call   80102f40 <end_op>
80100b84:	83 c4 10             	add    $0x10,%esp
80100b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b8f:	5b                   	pop    %ebx
80100b90:	5e                   	pop    %esi
80100b91:	5f                   	pop    %edi
80100b92:	5d                   	pop    %ebp
80100b93:	c3                   	ret    
80100b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b98:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b9f:	45 4c 46 
80100ba2:	75 d2                	jne    80100b76 <exec+0x56>
80100ba4:	e8 07 67 00 00       	call   801072b0 <setupkvm>
80100ba9:	85 c0                	test   %eax,%eax
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	74 c3                	je     80100b76 <exec+0x56>
80100bb3:	31 ff                	xor    %edi,%edi
80100bb5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bbc:	00 
80100bbd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100bc3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bc9:	0f 84 8c 02 00 00    	je     80100e5b <exec+0x33b>
80100bcf:	31 f6                	xor    %esi,%esi
80100bd1:	eb 7f                	jmp    80100c52 <exec+0x132>
80100bd3:	90                   	nop
80100bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bd8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bdf:	75 63                	jne    80100c44 <exec+0x124>
80100be1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100be7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bed:	0f 82 86 00 00 00    	jb     80100c79 <exec+0x159>
80100bf3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bf9:	72 7e                	jb     80100c79 <exec+0x159>
80100bfb:	83 ec 04             	sub    $0x4,%esp
80100bfe:	50                   	push   %eax
80100bff:	57                   	push   %edi
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 65 00 00       	call   80107120 <allocuvm>
80100c0b:	83 c4 10             	add    $0x10,%esp
80100c0e:	85 c0                	test   %eax,%eax
80100c10:	89 c7                	mov    %eax,%edi
80100c12:	74 65                	je     80100c79 <exec+0x159>
80100c14:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c1a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c1f:	75 58                	jne    80100c79 <exec+0x159>
80100c21:	83 ec 0c             	sub    $0xc,%esp
80100c24:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c2a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c30:	53                   	push   %ebx
80100c31:	50                   	push   %eax
80100c32:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c38:	e8 13 62 00 00       	call   80106e50 <loaduvm>
80100c3d:	83 c4 20             	add    $0x20,%esp
80100c40:	85 c0                	test   %eax,%eax
80100c42:	78 35                	js     80100c79 <exec+0x159>
80100c44:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4b:	83 c6 01             	add    $0x1,%esi
80100c4e:	39 f0                	cmp    %esi,%eax
80100c50:	7e 3d                	jle    80100c8f <exec+0x16f>
80100c52:	89 f0                	mov    %esi,%eax
80100c54:	6a 20                	push   $0x20
80100c56:	c1 e0 05             	shl    $0x5,%eax
80100c59:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100c5f:	50                   	push   %eax
80100c60:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c66:	50                   	push   %eax
80100c67:	53                   	push   %ebx
80100c68:	e8 c3 0f 00 00       	call   80101c30 <readi>
80100c6d:	83 c4 10             	add    $0x10,%esp
80100c70:	83 f8 20             	cmp    $0x20,%eax
80100c73:	0f 84 5f ff ff ff    	je     80100bd8 <exec+0xb8>
80100c79:	83 ec 0c             	sub    $0xc,%esp
80100c7c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c82:	e8 a9 65 00 00       	call   80107230 <freevm>
80100c87:	83 c4 10             	add    $0x10,%esp
80100c8a:	e9 e7 fe ff ff       	jmp    80100b76 <exec+0x56>
80100c8f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c9b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
80100ca1:	83 ec 0c             	sub    $0xc,%esp
80100ca4:	53                   	push   %ebx
80100ca5:	e8 36 0f 00 00       	call   80101be0 <iunlockput>
80100caa:	e8 91 22 00 00       	call   80102f40 <end_op>
80100caf:	83 c4 0c             	add    $0xc,%esp
80100cb2:	56                   	push   %esi
80100cb3:	57                   	push   %edi
80100cb4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cba:	e8 61 64 00 00       	call   80107120 <allocuvm>
80100cbf:	83 c4 10             	add    $0x10,%esp
80100cc2:	85 c0                	test   %eax,%eax
80100cc4:	89 c6                	mov    %eax,%esi
80100cc6:	75 3a                	jne    80100d02 <exec+0x1e2>
80100cc8:	83 ec 0c             	sub    $0xc,%esp
80100ccb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cd1:	e8 5a 65 00 00       	call   80107230 <freevm>
80100cd6:	83 c4 10             	add    $0x10,%esp
80100cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cde:	e9 a9 fe ff ff       	jmp    80100b8c <exec+0x6c>
80100ce3:	e8 58 22 00 00       	call   80102f40 <end_op>
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	68 21 76 10 80       	push   $0x80107621
80100cf0:	e8 7b fa ff ff       	call   80100770 <cprintf>
80100cf5:	83 c4 10             	add    $0x10,%esp
80100cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfd:	e9 8a fe ff ff       	jmp    80100b8c <exec+0x6c>
80100d02:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d08:	83 ec 08             	sub    $0x8,%esp
80100d0b:	31 ff                	xor    %edi,%edi
80100d0d:	89 f3                	mov    %esi,%ebx
80100d0f:	50                   	push   %eax
80100d10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d16:	e8 35 66 00 00       	call   80107350 <clearpteu>
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
80100d40:	83 ff 20             	cmp    $0x20,%edi
80100d43:	74 83                	je     80100cc8 <exec+0x1a8>
80100d45:	83 ec 0c             	sub    $0xc,%esp
80100d48:	50                   	push   %eax
80100d49:	e8 42 3c 00 00       	call   80104990 <strlen>
80100d4e:	f7 d0                	not    %eax
80100d50:	01 c3                	add    %eax,%ebx
80100d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d55:	5a                   	pop    %edx
80100d56:	83 e3 fc             	and    $0xfffffffc,%ebx
80100d59:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d5c:	e8 2f 3c 00 00       	call   80104990 <strlen>
80100d61:	83 c0 01             	add    $0x1,%eax
80100d64:	50                   	push   %eax
80100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d68:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d6b:	53                   	push   %ebx
80100d6c:	56                   	push   %esi
80100d6d:	e8 9e 67 00 00       	call   80107510 <copyout>
80100d72:	83 c4 20             	add    $0x20,%esp
80100d75:	85 c0                	test   %eax,%eax
80100d77:	0f 88 4b ff ff ff    	js     80100cc8 <exec+0x1a8>
80100d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d80:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100d87:	83 c7 01             	add    $0x1,%edi
80100d8a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d90:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d93:	85 c0                	test   %eax,%eax
80100d95:	75 a9                	jne    80100d40 <exec+0x220>
80100d97:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100da4:	89 d9                	mov    %ebx,%ecx
80100da6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100dad:	00 00 00 00 
80100db1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100db8:	ff ff ff 
80100dbb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
80100dc1:	29 c1                	sub    %eax,%ecx
80100dc3:	83 c0 0c             	add    $0xc,%eax
80100dc6:	29 c3                	sub    %eax,%ebx
80100dc8:	50                   	push   %eax
80100dc9:	52                   	push   %edx
80100dca:	53                   	push   %ebx
80100dcb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100dd1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100dd7:	e8 34 67 00 00       	call   80107510 <copyout>
80100ddc:	83 c4 10             	add    $0x10,%esp
80100ddf:	85 c0                	test   %eax,%eax
80100de1:	0f 88 e1 fe ff ff    	js     80100cc8 <exec+0x1a8>
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
80100e08:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e0e:	50                   	push   %eax
80100e0f:	6a 10                	push   $0x10
80100e11:	ff 75 08             	pushl  0x8(%ebp)
80100e14:	89 f8                	mov    %edi,%eax
80100e16:	83 c0 6c             	add    $0x6c,%eax
80100e19:	50                   	push   %eax
80100e1a:	e8 31 3b 00 00       	call   80104950 <safestrcpy>
80100e1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e25:	89 f9                	mov    %edi,%ecx
80100e27:	8b 7f 04             	mov    0x4(%edi),%edi
80100e2a:	8b 41 18             	mov    0x18(%ecx),%eax
80100e2d:	89 31                	mov    %esi,(%ecx)
80100e2f:	89 51 04             	mov    %edx,0x4(%ecx)
80100e32:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e38:	89 50 38             	mov    %edx,0x38(%eax)
80100e3b:	8b 41 18             	mov    0x18(%ecx),%eax
80100e3e:	89 58 44             	mov    %ebx,0x44(%eax)
80100e41:	89 0c 24             	mov    %ecx,(%esp)
80100e44:	e8 77 5e 00 00       	call   80106cc0 <switchuvm>
80100e49:	89 3c 24             	mov    %edi,(%esp)
80100e4c:	e8 df 63 00 00       	call   80107230 <freevm>
80100e51:	83 c4 10             	add    $0x10,%esp
80100e54:	31 c0                	xor    %eax,%eax
80100e56:	e9 31 fd ff ff       	jmp    80100b8c <exec+0x6c>
80100e5b:	be 00 20 00 00       	mov    $0x2000,%esi
80100e60:	e9 3c fe ff ff       	jmp    80100ca1 <exec+0x181>
80100e65:	66 90                	xchg   %ax,%ax
80100e67:	66 90                	xchg   %ax,%ax
80100e69:	66 90                	xchg   %ax,%ax
80100e6b:	66 90                	xchg   %ax,%ax
80100e6d:	66 90                	xchg   %ax,%ax
80100e6f:	90                   	nop

80100e70 <fileinit>:
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	83 ec 10             	sub    $0x10,%esp
80100e76:	68 2d 76 10 80       	push   $0x8010762d
80100e7b:	68 c0 0f 11 80       	push   $0x80110fc0
80100e80:	e8 7b 36 00 00       	call   80104500 <initlock>
80100e85:	83 c4 10             	add    $0x10,%esp
80100e88:	c9                   	leave  
80100e89:	c3                   	ret    
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e90 <filealloc>:
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
80100e94:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
80100e99:	83 ec 10             	sub    $0x10,%esp
80100e9c:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea1:	e8 4a 37 00 00       	call   801045f0 <acquire>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb 10                	jmp    80100ebb <filealloc+0x2b>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eb0:	83 c3 18             	add    $0x18,%ebx
80100eb3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100eb9:	74 25                	je     80100ee0 <filealloc+0x50>
80100ebb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	75 ee                	jne    80100eb0 <filealloc+0x20>
80100ec2:	83 ec 0c             	sub    $0xc,%esp
80100ec5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100ecc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed1:	e8 3a 38 00 00       	call   80104710 <release>
80100ed6:	89 d8                	mov    %ebx,%eax
80100ed8:	83 c4 10             	add    $0x10,%esp
80100edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ede:	c9                   	leave  
80100edf:	c3                   	ret    
80100ee0:	83 ec 0c             	sub    $0xc,%esp
80100ee3:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee8:	e8 23 38 00 00       	call   80104710 <release>
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	31 c0                	xor    %eax,%eax
80100ef2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef5:	c9                   	leave  
80100ef6:	c3                   	ret    
80100ef7:	89 f6                	mov    %esi,%esi
80100ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f00 <filedup>:
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 10             	sub    $0x10,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f0a:	68 c0 0f 11 80       	push   $0x80110fc0
80100f0f:	e8 dc 36 00 00       	call   801045f0 <acquire>
80100f14:	8b 43 04             	mov    0x4(%ebx),%eax
80100f17:	83 c4 10             	add    $0x10,%esp
80100f1a:	85 c0                	test   %eax,%eax
80100f1c:	7e 1a                	jle    80100f38 <filedup+0x38>
80100f1e:	83 c0 01             	add    $0x1,%eax
80100f21:	83 ec 0c             	sub    $0xc,%esp
80100f24:	89 43 04             	mov    %eax,0x4(%ebx)
80100f27:	68 c0 0f 11 80       	push   $0x80110fc0
80100f2c:	e8 df 37 00 00       	call   80104710 <release>
80100f31:	89 d8                	mov    %ebx,%eax
80100f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	68 34 76 10 80       	push   $0x80107634
80100f40:	e8 5b f5 ff ff       	call   801004a0 <panic>
80100f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f50 <fileclose>:
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 28             	sub    $0x28,%esp
80100f59:	8b 7d 08             	mov    0x8(%ebp),%edi
80100f5c:	68 c0 0f 11 80       	push   $0x80110fc0
80100f61:	e8 8a 36 00 00       	call   801045f0 <acquire>
80100f66:	8b 47 04             	mov    0x4(%edi),%eax
80100f69:	83 c4 10             	add    $0x10,%esp
80100f6c:	85 c0                	test   %eax,%eax
80100f6e:	0f 8e 9b 00 00 00    	jle    8010100f <fileclose+0xbf>
80100f74:	83 e8 01             	sub    $0x1,%eax
80100f77:	85 c0                	test   %eax,%eax
80100f79:	89 47 04             	mov    %eax,0x4(%edi)
80100f7c:	74 1a                	je     80100f98 <fileclose+0x48>
80100f7e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
80100f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f88:	5b                   	pop    %ebx
80100f89:	5e                   	pop    %esi
80100f8a:	5f                   	pop    %edi
80100f8b:	5d                   	pop    %ebp
80100f8c:	e9 7f 37 00 00       	jmp    80104710 <release>
80100f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f98:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100f9c:	8b 1f                	mov    (%edi),%ebx
80100f9e:	83 ec 0c             	sub    $0xc,%esp
80100fa1:	8b 77 0c             	mov    0xc(%edi),%esi
80100fa4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100faa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fad:	8b 47 10             	mov    0x10(%edi),%eax
80100fb0:	68 c0 0f 11 80       	push   $0x80110fc0
80100fb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100fb8:	e8 53 37 00 00       	call   80104710 <release>
80100fbd:	83 c4 10             	add    $0x10,%esp
80100fc0:	83 fb 01             	cmp    $0x1,%ebx
80100fc3:	74 13                	je     80100fd8 <fileclose+0x88>
80100fc5:	83 fb 02             	cmp    $0x2,%ebx
80100fc8:	74 26                	je     80100ff0 <fileclose+0xa0>
80100fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fcd:	5b                   	pop    %ebx
80100fce:	5e                   	pop    %esi
80100fcf:	5f                   	pop    %edi
80100fd0:	5d                   	pop    %ebp
80100fd1:	c3                   	ret    
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fdc:	83 ec 08             	sub    $0x8,%esp
80100fdf:	53                   	push   %ebx
80100fe0:	56                   	push   %esi
80100fe1:	e8 9a 26 00 00       	call   80103680 <pipeclose>
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	eb df                	jmp    80100fca <fileclose+0x7a>
80100feb:	90                   	nop
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ff0:	e8 db 1e 00 00       	call   80102ed0 <begin_op>
80100ff5:	83 ec 0c             	sub    $0xc,%esp
80100ff8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ffb:	e8 80 0a 00 00       	call   80101a80 <iput>
80101000:	83 c4 10             	add    $0x10,%esp
80101003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101006:	5b                   	pop    %ebx
80101007:	5e                   	pop    %esi
80101008:	5f                   	pop    %edi
80101009:	5d                   	pop    %ebp
8010100a:	e9 31 1f 00 00       	jmp    80102f40 <end_op>
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 3c 76 10 80       	push   $0x8010763c
80101017:	e8 84 f4 ff ff       	call   801004a0 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filestat>:
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	pushl  0x10(%ebx)
80101035:	e8 16 09 00 00       	call   80101950 <ilock>
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	pushl  0xc(%ebp)
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 b9 0b 00 00       	call   80101c00 <stati>
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	pushl  0x10(%ebx)
8010104b:	e8 e0 09 00 00       	call   80101a30 <iunlock>
80101050:	83 c4 10             	add    $0x10,%esp
80101053:	31 c0                	xor    %eax,%eax
80101055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101058:	c9                   	leave  
80101059:	c3                   	ret    
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	pushl  0x10(%ebx)
8010109a:	e8 b1 08 00 00       	call   80101950 <ilock>
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	pushl  0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	pushl  0x10(%ebx)
801010a7:	e8 84 0b 00 00       	call   80101c30 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	85 c0                	test   %eax,%eax
801010b1:	89 c6                	mov    %eax,%esi
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	pushl  0x10(%ebx)
801010be:	e8 6d 09 00 00       	call   80101a30 <iunlock>
801010c3:	83 c4 10             	add    $0x10,%esp
801010c6:	89 f0                	mov    %esi,%eax
801010c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret    
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
801010dd:	e9 3e 27 00 00       	jmp    80103820 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ed:	eb d9                	jmp    801010c8 <fileread+0x58>
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 46 76 10 80       	push   $0x80107646
801010f7:	e8 a4 f3 ff ff       	call   801004a0 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 75 08             	mov    0x8(%ebp),%esi
8010110c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80101113:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101116:	8b 45 10             	mov    0x10(%ebp),%eax
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111c:	0f 84 aa 00 00 00    	je     801011cc <filewrite+0xcc>
80101122:	8b 06                	mov    (%esi),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 c2 00 00 00    	je     801011ef <filewrite+0xef>
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 d8 00 00 00    	jne    8010120e <filewrite+0x10e>
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101139:	31 ff                	xor    %edi,%edi
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 34                	jg     80101173 <filewrite+0x73>
8010113f:	e9 9c 00 00 00       	jmp    801011e0 <filewrite+0xe0>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101148:	01 46 14             	add    %eax,0x14(%esi)
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 76 10             	pushl  0x10(%esi)
80101151:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101154:	e8 d7 08 00 00       	call   80101a30 <iunlock>
80101159:	e8 e2 1d 00 00       	call   80102f40 <end_op>
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 d8                	cmp    %ebx,%eax
80101166:	0f 85 95 00 00 00    	jne    80101201 <filewrite+0x101>
8010116c:	01 c7                	add    %eax,%edi
8010116e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101171:	7e 6d                	jle    801011e0 <filewrite+0xe0>
80101173:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101176:	b8 00 06 00 00       	mov    $0x600,%eax
8010117b:	29 fb                	sub    %edi,%ebx
8010117d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101183:	0f 4f d8             	cmovg  %eax,%ebx
80101186:	e8 45 1d 00 00       	call   80102ed0 <begin_op>
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	ff 76 10             	pushl  0x10(%esi)
80101191:	e8 ba 07 00 00       	call   80101950 <ilock>
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	53                   	push   %ebx
8010119a:	ff 76 14             	pushl  0x14(%esi)
8010119d:	01 f8                	add    %edi,%eax
8010119f:	50                   	push   %eax
801011a0:	ff 76 10             	pushl  0x10(%esi)
801011a3:	e8 88 0b 00 00       	call   80101d30 <writei>
801011a8:	83 c4 20             	add    $0x20,%esp
801011ab:	85 c0                	test   %eax,%eax
801011ad:	7f 99                	jg     80101148 <filewrite+0x48>
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	ff 76 10             	pushl  0x10(%esi)
801011b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011b8:	e8 73 08 00 00       	call   80101a30 <iunlock>
801011bd:	e8 7e 1d 00 00       	call   80102f40 <end_op>
801011c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c5:	83 c4 10             	add    $0x10,%esp
801011c8:	85 c0                	test   %eax,%eax
801011ca:	74 98                	je     80101164 <filewrite+0x64>
801011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d4:	5b                   	pop    %ebx
801011d5:	5e                   	pop    %esi
801011d6:	5f                   	pop    %edi
801011d7:	5d                   	pop    %ebp
801011d8:	c3                   	ret    
801011d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011e0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011e3:	75 e7                	jne    801011cc <filewrite+0xcc>
801011e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e8:	89 f8                	mov    %edi,%eax
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
801011ee:	c3                   	ret    
801011ef:	8b 46 0c             	mov    0xc(%esi),%eax
801011f2:	89 45 08             	mov    %eax,0x8(%ebp)
801011f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f8:	5b                   	pop    %ebx
801011f9:	5e                   	pop    %esi
801011fa:	5f                   	pop    %edi
801011fb:	5d                   	pop    %ebp
801011fc:	e9 1f 25 00 00       	jmp    80103720 <pipewrite>
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	68 4f 76 10 80       	push   $0x8010764f
80101209:	e8 92 f2 ff ff       	call   801004a0 <panic>
8010120e:	83 ec 0c             	sub    $0xc,%esp
80101211:	68 55 76 10 80       	push   $0x80107655
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
  memset(bp->data, 0, BSIZE);
8010122e:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101231:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101233:	8d 40 5c             	lea    0x5c(%eax),%eax
80101236:	68 00 02 00 00       	push   $0x200
8010123b:	6a 00                	push   $0x0
8010123d:	50                   	push   %eax
8010123e:	e8 2d 35 00 00       	call   80104770 <memset>
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
8010125b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop

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
8010126c:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101271:	85 c0                	test   %eax,%eax
80101273:	0f 84 8c 00 00 00    	je     80101305 <balloc+0xa5>
80101279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101280:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101283:	83 ec 08             	sub    $0x8,%esp
80101286:	89 f0                	mov    %esi,%eax
80101288:	c1 f8 0c             	sar    $0xc,%eax
8010128b:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101291:	50                   	push   %eax
80101292:	ff 75 d8             	pushl  -0x28(%ebp)
80101295:	e8 f6 ee ff ff       	call   80100190 <bread>
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a0:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801012a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a8:	31 c0                	xor    %eax,%eax
801012aa:	eb 30                	jmp    801012dc <balloc+0x7c>
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
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
801012f9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012ff:	0f 87 7b ff ff ff    	ja     80101280 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	68 5f 76 10 80       	push   $0x8010765f
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
80101346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134d:	8d 76 00             	lea    0x0(%esi),%esi

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
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 81 32 00 00       	call   801045f0 <acquire>
8010136f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
801013a3:	85 c9                	test   %ecx,%ecx
801013a5:	75 70                	jne    80101417 <iget+0xc7>
801013a7:	89 de                	mov    %ebx,%esi
801013a9:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 74                	je     80101430 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 34 33 00 00       	call   80104710 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      ip->ref++;
801013fd:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101400:	68 e0 19 11 80       	push   $0x801119e0
80101405:	e8 06 33 00 00       	call   80104710 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	3d 34 36 11 80       	cmp    $0x80113634,%eax
8010141c:	73 12                	jae    80101430 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141e:	8b 48 08             	mov    0x8(%eax),%ecx
80101421:	89 c3                	mov    %eax,%ebx
80101423:	85 c9                	test   %ecx,%ecx
80101425:	0f 8f 55 ff ff ff    	jg     80101380 <iget+0x30>
8010142b:	e9 6d ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101430:	83 ec 0c             	sub    $0xc,%esp
80101433:	68 75 76 10 80       	push   $0x80107675
80101438:	e8 63 f0 ff ff       	call   801004a0 <panic>
8010143d:	8d 76 00             	lea    0x0(%esi),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101466:	8b 00                	mov    (%eax),%eax
80101468:	85 d2                	test   %edx,%edx
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	52                   	push   %edx
80101470:	50                   	push   %eax
80101471:	e8 1a ed ff ff       	call   80100190 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 82 ed ff ff       	call   80100210 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 b6 fd ff ff       	call   80101260 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 f6 1b 00 00       	call   801030b0 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	e8 9b fd ff ff       	call   80101260 <balloc>
801014c5:	89 c2                	mov    %eax,%edx
801014c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cd:	8b 06                	mov    (%esi),%eax
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 77 fd ff ff       	call   80101260 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 85 76 10 80       	push   $0x80107685
80101500:	e8 9b ef ff ff       	call   801004a0 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	56                   	push   %esi
80101514:	53                   	push   %ebx
80101515:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101518:	83 ec 08             	sub    $0x8,%esp
8010151b:	6a 01                	push   $0x1
8010151d:	ff 75 08             	pushl  0x8(%ebp)
80101520:	e8 6b ec ff ff       	call   80100190 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101525:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101528:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010152d:	6a 1c                	push   $0x1c
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 ea 32 00 00       	call   80104820 <memmove>
  brelse(bp);
80101536:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101539:	83 c4 10             	add    $0x10,%esp
}
8010153c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5d                   	pop    %ebp
  brelse(bp);
80101542:	e9 c9 ec ff ff       	jmp    80100210 <brelse>
80101547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154e:	66 90                	xchg   %ax,%ax

80101550 <bfree>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	89 c6                	mov    %eax,%esi
80101556:	53                   	push   %ebx
80101557:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	68 c0 19 11 80       	push   $0x801119c0
80101561:	50                   	push   %eax
80101562:	e8 a9 ff ff ff       	call   80101510 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101567:	58                   	pop    %eax
80101568:	5a                   	pop    %edx
80101569:	89 da                	mov    %ebx,%edx
8010156b:	c1 ea 0c             	shr    $0xc,%edx
8010156e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101574:	52                   	push   %edx
80101575:	56                   	push   %esi
80101576:	e8 15 ec ff ff       	call   80100190 <bread>
  m = 1 << (bi % 8);
8010157b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010157d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101580:	ba 01 00 00 00       	mov    $0x1,%edx
80101585:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101588:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010158e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101591:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101593:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101598:	85 d1                	test   %edx,%ecx
8010159a:	74 25                	je     801015c1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010159c:	f7 d2                	not    %edx
8010159e:	89 c6                	mov    %eax,%esi
  bwrite(bp);
801015a0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015a3:	21 ca                	and    %ecx,%edx
801015a5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  bwrite(bp);
801015a9:	56                   	push   %esi
801015aa:	e8 21 ec ff ff       	call   801001d0 <bwrite>
  brelse(bp);
801015af:	89 34 24             	mov    %esi,(%esp)
801015b2:	e8 59 ec ff ff       	call   80100210 <brelse>
}
801015b7:	83 c4 10             	add    $0x10,%esp
801015ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bd:	5b                   	pop    %ebx
801015be:	5e                   	pop    %esi
801015bf:	5d                   	pop    %ebp
801015c0:	c3                   	ret    
    panic("freeing free block");
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	68 98 76 10 80       	push   $0x80107698
801015c9:	e8 d2 ee ff ff       	call   801004a0 <panic>
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <balloc_page>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 2c             	sub    $0x2c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015d9:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801015de:	85 c0                	test   %eax,%eax
801015e0:	0f 84 11 01 00 00    	je     801016f7 <balloc_page+0x127>
801015e6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
        m = 1 << (mover % 8);
801015ed:	be 01 00 00 00       	mov    $0x1,%esi
    bp = bread(dev, BBLOCK(b, sb));
801015f2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801015f5:	83 ec 08             	sub    $0x8,%esp
801015f8:	89 d8                	mov    %ebx,%eax
801015fa:	c1 f8 0c             	sar    $0xc,%eax
801015fd:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101603:	50                   	push   %eax
80101604:	ff 75 08             	pushl  0x8(%ebp)
80101607:	e8 84 eb ff ff       	call   80100190 <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010160c:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010160f:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, BBLOCK(b, sb));
80101612:	89 c7                	mov    %eax,%edi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101614:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101619:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010161c:	b8 08 00 00 00       	mov    $0x8,%eax
80101621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101628:	8d 58 f8             	lea    -0x8(%eax),%ebx
8010162b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010162e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101631:	39 4d d8             	cmp    %ecx,-0x28(%ebp)
80101634:	0f 86 9b 00 00 00    	jbe    801016d5 <balloc_page+0x105>
8010163a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010163d:	8d 58 f8             	lea    -0x8(%eax),%ebx
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101640:	89 da                	mov    %ebx,%edx
        m = 1 << (mover % 8);
80101642:	89 d9                	mov    %ebx,%ecx
80101644:	89 f0                	mov    %esi,%eax
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101646:	c1 fa 03             	sar    $0x3,%edx
        m = 1 << (mover % 8);
80101649:	83 e1 07             	and    $0x7,%ecx
        if((bp->data[mover/8] & m) == 0){  // Is block free?
8010164c:	0f b6 54 17 5c       	movzbl 0x5c(%edi,%edx,1),%edx
        m = 1 << (mover % 8);
80101651:	d3 e0                	shl    %cl,%eax
        if((bp->data[mover/8] & m) == 0){  // Is block free?
80101653:	85 c2                	test   %eax,%edx
80101655:	75 69                	jne    801016c0 <balloc_page+0xf0>
            mover += 1;
80101657:	83 c3 01             	add    $0x1,%ebx
      for(int i=0; i<8; i++){
8010165a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010165d:	75 e1                	jne    80101640 <balloc_page+0x70>
          m = 1 << (mover % 8);
8010165f:	be 01 00 00 00       	mov    $0x1,%esi
          bp->data[mover/8] |= m;  // Mark block in use.
80101664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
          m = 1 << (mover % 8);
80101667:	89 f2                	mov    %esi,%edx
          bwrite(bp);
80101669:	83 ec 0c             	sub    $0xc,%esp
          bp->data[mover/8] |= m;  // Mark block in use.
8010166c:	89 c8                	mov    %ecx,%eax
          m = 1 << (mover % 8);
8010166e:	83 e1 07             	and    $0x7,%ecx
          bp->data[mover/8] |= m;  // Mark block in use.
80101671:	c1 f8 03             	sar    $0x3,%eax
          m = 1 << (mover % 8);
80101674:	d3 e2                	shl    %cl,%edx
          bp->data[mover/8] |= m;  // Mark block in use.
80101676:	08 54 07 5c          	or     %dl,0x5c(%edi,%eax,1)
          bwrite(bp);
8010167a:	57                   	push   %edi
8010167b:	e8 50 eb ff ff       	call   801001d0 <bwrite>
          bzero(dev, b + mover);
80101680:	8b 45 08             	mov    0x8(%ebp),%eax
80101683:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101686:	03 55 d4             	add    -0x2c(%ebp),%edx
80101689:	e8 92 fb ff ff       	call   80101220 <bzero>
          mover += 1;
8010168e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80101692:	8b 55 e0             	mov    -0x20(%ebp),%edx
        for(int i=0; i<8; i++){
80101695:	83 c4 10             	add    $0x10,%esp
80101698:	39 da                	cmp    %ebx,%edx
8010169a:	75 c8                	jne    80101664 <balloc_page+0x94>
        brelse(bp);
8010169c:	83 ec 0c             	sub    $0xc,%esp
8010169f:	57                   	push   %edi
801016a0:	e8 6b eb ff ff       	call   80100210 <brelse>
}
801016a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
        numallocblocks++;
801016a8:	83 05 5c b5 10 80 01 	addl   $0x1,0x8010b55c
}
801016af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b2:	5b                   	pop    %ebx
801016b3:	5e                   	pop    %esi
801016b4:	5f                   	pop    %edi
801016b5:	5d                   	pop    %ebp
801016b6:	c3                   	ret    
801016b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016be:	66 90                	xchg   %ax,%ax
801016c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      flag = 0;
801016c3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801016c7:	83 c0 01             	add    $0x1,%eax
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016ca:	3d 08 10 00 00       	cmp    $0x1008,%eax
801016cf:	0f 85 53 ff ff ff    	jne    80101628 <balloc_page+0x58>
    brelse(bp);
801016d5:	83 ec 0c             	sub    $0xc,%esp
801016d8:	57                   	push   %edi
801016d9:	e8 32 eb ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801016de:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016eb:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801016f1:	0f 87 fb fe ff ff    	ja     801015f2 <balloc_page+0x22>
  panic("balloc pages : out of blocks");
801016f7:	83 ec 0c             	sub    $0xc,%esp
801016fa:	68 ab 76 10 80       	push   $0x801076ab
801016ff:	e8 9c ed ff ff       	call   801004a0 <panic>
80101704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

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
8010172f:	e8 1c fe ff ff       	call   80101550 <bfree>
  for(uint bi=0;bi<8;bi++){
80101734:	39 f3                	cmp    %esi,%ebx
80101736:	75 f0                	jne    80101728 <bfree_page+0x18>
  numallocblocks--;
80101738:	83 2d 5c b5 10 80 01 	subl   $0x1,0x8010b55c
}
8010173f:	83 c4 0c             	add    $0xc,%esp
80101742:	5b                   	pop    %ebx
80101743:	5e                   	pop    %esi
80101744:	5f                   	pop    %edi
80101745:	5d                   	pop    %ebp
80101746:	c3                   	ret    
80101747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174e:	66 90                	xchg   %ax,%ax

80101750 <iinit>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101759:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010175c:	68 c8 76 10 80       	push   $0x801076c8
80101761:	68 e0 19 11 80       	push   $0x801119e0
80101766:	e8 95 2d 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
8010176b:	83 c4 10             	add    $0x10,%esp
8010176e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101770:	83 ec 08             	sub    $0x8,%esp
80101773:	68 cf 76 10 80       	push   $0x801076cf
80101778:	53                   	push   %ebx
80101779:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010177f:	e8 6c 2c 00 00       	call   801043f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101784:	83 c4 10             	add    $0x10,%esp
80101787:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010178d:	75 e1                	jne    80101770 <iinit+0x20>
  readsb(dev, &sb);
8010178f:	83 ec 08             	sub    $0x8,%esp
80101792:	68 c0 19 11 80       	push   $0x801119c0
80101797:	ff 75 08             	pushl  0x8(%ebp)
8010179a:	e8 71 fd ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010179f:	ff 35 d8 19 11 80    	pushl  0x801119d8
801017a5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801017ab:	ff 35 d0 19 11 80    	pushl  0x801119d0
801017b1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801017b7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801017bd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801017c3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801017c9:	68 34 77 10 80       	push   $0x80107734
801017ce:	e8 9d ef ff ff       	call   80100770 <cprintf>
}
801017d3:	83 c4 30             	add    $0x30,%esp
801017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017d9:	c9                   	leave  
801017da:	c3                   	ret    
801017db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop

801017e0 <ialloc>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801017ec:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801017f3:	8b 75 08             	mov    0x8(%ebp),%esi
801017f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017f9:	0f 86 91 00 00 00    	jbe    80101890 <ialloc+0xb0>
801017ff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101804:	eb 21                	jmp    80101827 <ialloc+0x47>
80101806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101810:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101813:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101816:	57                   	push   %edi
80101817:	e8 f4 e9 ff ff       	call   80100210 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010181c:	83 c4 10             	add    $0x10,%esp
8010181f:	3b 1d c8 19 11 80    	cmp    0x801119c8,%ebx
80101825:	73 69                	jae    80101890 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101827:	89 d8                	mov    %ebx,%eax
80101829:	83 ec 08             	sub    $0x8,%esp
8010182c:	c1 e8 03             	shr    $0x3,%eax
8010182f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101835:	50                   	push   %eax
80101836:	56                   	push   %esi
80101837:	e8 54 e9 ff ff       	call   80100190 <bread>
    if(dip->type == 0){  // a free inode
8010183c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010183f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101841:	89 d8                	mov    %ebx,%eax
80101843:	83 e0 07             	and    $0x7,%eax
80101846:	c1 e0 06             	shl    $0x6,%eax
80101849:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010184d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101851:	75 bd                	jne    80101810 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101853:	83 ec 04             	sub    $0x4,%esp
80101856:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101859:	6a 40                	push   $0x40
8010185b:	6a 00                	push   $0x0
8010185d:	51                   	push   %ecx
8010185e:	e8 0d 2f 00 00       	call   80104770 <memset>
      dip->type = type;
80101863:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101867:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010186a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010186d:	89 3c 24             	mov    %edi,(%esp)
80101870:	e8 3b 18 00 00       	call   801030b0 <log_write>
      brelse(bp);
80101875:	89 3c 24             	mov    %edi,(%esp)
80101878:	e8 93 e9 ff ff       	call   80100210 <brelse>
      return iget(dev, inum);
8010187d:	83 c4 10             	add    $0x10,%esp
}
80101880:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101883:	89 da                	mov    %ebx,%edx
80101885:	89 f0                	mov    %esi,%eax
}
80101887:	5b                   	pop    %ebx
80101888:	5e                   	pop    %esi
80101889:	5f                   	pop    %edi
8010188a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010188b:	e9 c0 fa ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
80101890:	83 ec 0c             	sub    $0xc,%esp
80101893:	68 d5 76 10 80       	push   $0x801076d5
80101898:	e8 03 ec ff ff       	call   801004a0 <panic>
8010189d:	8d 76 00             	lea    0x0(%esi),%esi

801018a0 <iupdate>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018a8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ab:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ae:	83 ec 08             	sub    $0x8,%esp
801018b1:	c1 e8 03             	shr    $0x3,%eax
801018b4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801018ba:	50                   	push   %eax
801018bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801018be:	e8 cd e8 ff ff       	call   80100190 <bread>
  dip->type = ip->type;
801018c3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018c7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ca:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801018cf:	83 e0 07             	and    $0x7,%eax
801018d2:	c1 e0 06             	shl    $0x6,%eax
801018d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018e0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018fd:	6a 34                	push   $0x34
801018ff:	53                   	push   %ebx
80101900:	50                   	push   %eax
80101901:	e8 1a 2f 00 00       	call   80104820 <memmove>
  log_write(bp);
80101906:	89 34 24             	mov    %esi,(%esp)
80101909:	e8 a2 17 00 00       	call   801030b0 <log_write>
  brelse(bp);
8010190e:	89 75 08             	mov    %esi,0x8(%ebp)
80101911:	83 c4 10             	add    $0x10,%esp
}
80101914:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101917:	5b                   	pop    %ebx
80101918:	5e                   	pop    %esi
80101919:	5d                   	pop    %ebp
  brelse(bp);
8010191a:	e9 f1 e8 ff ff       	jmp    80100210 <brelse>
8010191f:	90                   	nop

80101920 <idup>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010192a:	68 e0 19 11 80       	push   $0x801119e0
8010192f:	e8 bc 2c 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101934:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101938:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010193f:	e8 cc 2d 00 00       	call   80104710 <release>
}
80101944:	89 d8                	mov    %ebx,%eax
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
8010194a:	c3                   	ret    
8010194b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010194f:	90                   	nop

80101950 <ilock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	0f 84 b7 00 00 00    	je     80101a17 <ilock+0xc7>
80101960:	8b 53 08             	mov    0x8(%ebx),%edx
80101963:	85 d2                	test   %edx,%edx
80101965:	0f 8e ac 00 00 00    	jle    80101a17 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010196b:	83 ec 0c             	sub    $0xc,%esp
8010196e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101971:	50                   	push   %eax
80101972:	e8 b9 2a 00 00       	call   80104430 <acquiresleep>
  if(ip->valid == 0){
80101977:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	85 c0                	test   %eax,%eax
8010197f:	74 0f                	je     80101990 <ilock+0x40>
}
80101981:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101984:	5b                   	pop    %ebx
80101985:	5e                   	pop    %esi
80101986:	5d                   	pop    %ebp
80101987:	c3                   	ret    
80101988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101990:	8b 43 04             	mov    0x4(%ebx),%eax
80101993:	83 ec 08             	sub    $0x8,%esp
80101996:	c1 e8 03             	shr    $0x3,%eax
80101999:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010199f:	50                   	push   %eax
801019a0:	ff 33                	pushl  (%ebx)
801019a2:	e8 e9 e7 ff ff       	call   80100190 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019a7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019aa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019ac:	8b 43 04             	mov    0x4(%ebx),%eax
801019af:	83 e0 07             	and    $0x7,%eax
801019b2:	c1 e0 06             	shl    $0x6,%eax
801019b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019b9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019bc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019db:	8b 50 fc             	mov    -0x4(%eax),%edx
801019de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019e1:	6a 34                	push   $0x34
801019e3:	50                   	push   %eax
801019e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019e7:	50                   	push   %eax
801019e8:	e8 33 2e 00 00       	call   80104820 <memmove>
    brelse(bp);
801019ed:	89 34 24             	mov    %esi,(%esp)
801019f0:	e8 1b e8 ff ff       	call   80100210 <brelse>
    if(ip->type == 0)
801019f5:	83 c4 10             	add    $0x10,%esp
801019f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a04:	0f 85 77 ff ff ff    	jne    80101981 <ilock+0x31>
      panic("ilock: no type");
80101a0a:	83 ec 0c             	sub    $0xc,%esp
80101a0d:	68 ed 76 10 80       	push   $0x801076ed
80101a12:	e8 89 ea ff ff       	call   801004a0 <panic>
    panic("ilock");
80101a17:	83 ec 0c             	sub    $0xc,%esp
80101a1a:	68 e7 76 10 80       	push   $0x801076e7
80101a1f:	e8 7c ea ff ff       	call   801004a0 <panic>
80101a24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a2f:	90                   	nop

80101a30 <iunlock>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 28                	je     80101a64 <iunlock+0x34>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 88 2a 00 00       	call   801044d0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 15                	je     80101a64 <iunlock+0x34>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 0e                	jle    80101a64 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a56:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a5c:	5b                   	pop    %ebx
80101a5d:	5e                   	pop    %esi
80101a5e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a5f:	e9 2c 2a 00 00       	jmp    80104490 <releasesleep>
    panic("iunlock");
80101a64:	83 ec 0c             	sub    $0xc,%esp
80101a67:	68 fc 76 10 80       	push   $0x801076fc
80101a6c:	e8 2f ea ff ff       	call   801004a0 <panic>
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <iput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 28             	sub    $0x28,%esp
80101a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a8c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a8f:	57                   	push   %edi
80101a90:	e8 9b 29 00 00       	call   80104430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a95:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 d2                	test   %edx,%edx
80101a9d:	74 07                	je     80101aa6 <iput+0x26>
80101a9f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101aa4:	74 32                	je     80101ad8 <iput+0x58>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	57                   	push   %edi
80101aaa:	e8 e1 29 00 00       	call   80104490 <releasesleep>
  acquire(&icache.lock);
80101aaf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ab6:	e8 35 2b 00 00       	call   801045f0 <acquire>
  ip->ref--;
80101abb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101abf:	83 c4 10             	add    $0x10,%esp
80101ac2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101acc:	5b                   	pop    %ebx
80101acd:	5e                   	pop    %esi
80101ace:	5f                   	pop    %edi
80101acf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ad0:	e9 3b 2c 00 00       	jmp    80104710 <release>
80101ad5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ad8:	83 ec 0c             	sub    $0xc,%esp
80101adb:	68 e0 19 11 80       	push   $0x801119e0
80101ae0:	e8 0b 2b 00 00       	call   801045f0 <acquire>
    int r = ip->ref;
80101ae5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ae8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101aef:	e8 1c 2c 00 00       	call   80104710 <release>
    if(r == 1){
80101af4:	83 c4 10             	add    $0x10,%esp
80101af7:	83 fe 01             	cmp    $0x1,%esi
80101afa:	75 aa                	jne    80101aa6 <iput+0x26>
80101afc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b05:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b08:	89 cf                	mov    %ecx,%edi
80101b0a:	eb 0b                	jmp    80101b17 <iput+0x97>
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b10:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b13:	39 fe                	cmp    %edi,%esi
80101b15:	74 19                	je     80101b30 <iput+0xb0>
    if(ip->addrs[i]){
80101b17:	8b 16                	mov    (%esi),%edx
80101b19:	85 d2                	test   %edx,%edx
80101b1b:	74 f3                	je     80101b10 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b1d:	8b 03                	mov    (%ebx),%eax
80101b1f:	e8 2c fa ff ff       	call   80101550 <bfree>
      ip->addrs[i] = 0;
80101b24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b2a:	eb e4                	jmp    80101b10 <iput+0x90>
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b30:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b39:	85 c0                	test   %eax,%eax
80101b3b:	75 33                	jne    80101b70 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b3d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b40:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b47:	53                   	push   %ebx
80101b48:	e8 53 fd ff ff       	call   801018a0 <iupdate>
      ip->type = 0;
80101b4d:	31 c0                	xor    %eax,%eax
80101b4f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b53:	89 1c 24             	mov    %ebx,(%esp)
80101b56:	e8 45 fd ff ff       	call   801018a0 <iupdate>
      ip->valid = 0;
80101b5b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b62:	83 c4 10             	add    $0x10,%esp
80101b65:	e9 3c ff ff ff       	jmp    80101aa6 <iput+0x26>
80101b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b70:	83 ec 08             	sub    $0x8,%esp
80101b73:	50                   	push   %eax
80101b74:	ff 33                	pushl  (%ebx)
80101b76:	e8 15 e6 ff ff       	call   80100190 <bread>
80101b7b:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b7e:	83 c4 10             	add    $0x10,%esp
80101b81:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101b8a:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b8d:	89 cf                	mov    %ecx,%edi
80101b8f:	eb 0e                	jmp    80101b9f <iput+0x11f>
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b98:	83 c6 04             	add    $0x4,%esi
80101b9b:	39 f7                	cmp    %esi,%edi
80101b9d:	74 11                	je     80101bb0 <iput+0x130>
      if(a[j])
80101b9f:	8b 16                	mov    (%esi),%edx
80101ba1:	85 d2                	test   %edx,%edx
80101ba3:	74 f3                	je     80101b98 <iput+0x118>
        bfree(ip->dev, a[j]);
80101ba5:	8b 03                	mov    (%ebx),%eax
80101ba7:	e8 a4 f9 ff ff       	call   80101550 <bfree>
80101bac:	eb ea                	jmp    80101b98 <iput+0x118>
80101bae:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bb6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bb9:	e8 52 e6 ff ff       	call   80100210 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bbe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bc4:	8b 03                	mov    (%ebx),%eax
80101bc6:	e8 85 f9 ff ff       	call   80101550 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bcb:	83 c4 10             	add    $0x10,%esp
80101bce:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101bd5:	00 00 00 
80101bd8:	e9 60 ff ff ff       	jmp    80101b3d <iput+0xbd>
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi

80101be0 <iunlockput>:
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	53                   	push   %ebx
80101be4:	83 ec 10             	sub    $0x10,%esp
80101be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bea:	53                   	push   %ebx
80101beb:	e8 40 fe ff ff       	call   80101a30 <iunlock>
  iput(ip);
80101bf0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101bf3:	83 c4 10             	add    $0x10,%esp
}
80101bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bf9:	c9                   	leave  
  iput(ip);
80101bfa:	e9 81 fe ff ff       	jmp    80101a80 <iput>
80101bff:	90                   	nop

80101c00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	8b 55 08             	mov    0x8(%ebp),%edx
80101c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c09:	8b 0a                	mov    (%edx),%ecx
80101c0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c23:	8b 52 58             	mov    0x58(%edx),%edx
80101c26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c2f:	90                   	nop

80101c30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c47:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c53:	0f 84 a7 00 00 00    	je     80101d00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	8b 40 58             	mov    0x58(%eax),%eax
80101c5f:	39 c6                	cmp    %eax,%esi
80101c61:	0f 87 ba 00 00 00    	ja     80101d21 <readi+0xf1>
80101c67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c6a:	89 f9                	mov    %edi,%ecx
80101c6c:	01 f1                	add    %esi,%ecx
80101c6e:	0f 82 ad 00 00 00    	jb     80101d21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c74:	89 c2                	mov    %eax,%edx
80101c76:	29 f2                	sub    %esi,%edx
80101c78:	39 c8                	cmp    %ecx,%eax
80101c7a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c7d:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101c7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c82:	85 d2                	test   %edx,%edx
80101c84:	74 6c                	je     80101cf2 <readi+0xc2>
80101c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c93:	89 f2                	mov    %esi,%edx
80101c95:	c1 ea 09             	shr    $0x9,%edx
80101c98:	89 d8                	mov    %ebx,%eax
80101c9a:	e8 a1 f7 ff ff       	call   80101440 <bmap>
80101c9f:	83 ec 08             	sub    $0x8,%esp
80101ca2:	50                   	push   %eax
80101ca3:	ff 33                	pushl  (%ebx)
80101ca5:	e8 e6 e4 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101caa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101cad:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cb2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb7:	89 f0                	mov    %esi,%eax
80101cb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cbe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cc5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc9:	39 d9                	cmp    %ebx,%ecx
80101ccb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ccf:	01 df                	add    %ebx,%edi
80101cd1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101cd3:	50                   	push   %eax
80101cd4:	ff 75 e0             	pushl  -0x20(%ebp)
80101cd7:	e8 44 2b 00 00       	call   80104820 <memmove>
    brelse(bp);
80101cdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101cdf:	89 14 24             	mov    %edx,(%esp)
80101ce2:	e8 29 e5 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101cf0:	77 9e                	ja     80101c90 <readi+0x60>
  }
  return n;
80101cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cf8:	5b                   	pop    %ebx
80101cf9:	5e                   	pop    %esi
80101cfa:	5f                   	pop    %edi
80101cfb:	5d                   	pop    %ebp
80101cfc:	c3                   	ret    
80101cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d04:	66 83 f8 09          	cmp    $0x9,%ax
80101d08:	77 17                	ja     80101d21 <readi+0xf1>
80101d0a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101d11:	85 c0                	test   %eax,%eax
80101d13:	74 0c                	je     80101d21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d1f:	ff e0                	jmp    *%eax
      return -1;
80101d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d26:	eb cd                	jmp    80101cf5 <readi+0xc5>
80101d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2f:	90                   	nop

80101d30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d53:	0f 84 b7 00 00 00    	je     80101e10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d5f:	0f 82 e7 00 00 00    	jb     80101e4c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d68:	89 f8                	mov    %edi,%eax
80101d6a:	01 f0                	add    %esi,%eax
80101d6c:	0f 82 da 00 00 00    	jb     80101e4c <writei+0x11c>
80101d72:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d77:	0f 87 cf 00 00 00    	ja     80101e4c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d84:	85 ff                	test   %edi,%edi
80101d86:	74 79                	je     80101e01 <writei+0xd1>
80101d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d93:	89 f2                	mov    %esi,%edx
80101d95:	c1 ea 09             	shr    $0x9,%edx
80101d98:	89 f8                	mov    %edi,%eax
80101d9a:	e8 a1 f6 ff ff       	call   80101440 <bmap>
80101d9f:	83 ec 08             	sub    $0x8,%esp
80101da2:	50                   	push   %eax
80101da3:	ff 37                	pushl  (%edi)
80101da5:	e8 e6 e3 ff ff       	call   80100190 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101daa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101daf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101db2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101db5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101db7:	89 f0                	mov    %esi,%eax
80101db9:	83 c4 0c             	add    $0xc,%esp
80101dbc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101dc1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101dc3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101dc7:	39 d9                	cmp    %ebx,%ecx
80101dc9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dcc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dcd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101dcf:	ff 75 dc             	pushl  -0x24(%ebp)
80101dd2:	50                   	push   %eax
80101dd3:	e8 48 2a 00 00       	call   80104820 <memmove>
    log_write(bp);
80101dd8:	89 3c 24             	mov    %edi,(%esp)
80101ddb:	e8 d0 12 00 00       	call   801030b0 <log_write>
    brelse(bp);
80101de0:	89 3c 24             	mov    %edi,(%esp)
80101de3:	e8 28 e4 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101de8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101df4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101df7:	77 97                	ja     80101d90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101df9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dfc:	3b 70 58             	cmp    0x58(%eax),%esi
80101dff:	77 37                	ja     80101e38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e01:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e14:	66 83 f8 09          	cmp    $0x9,%ax
80101e18:	77 32                	ja     80101e4c <writei+0x11c>
80101e1a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101e21:	85 c0                	test   %eax,%eax
80101e23:	74 27                	je     80101e4c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101e25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2b:	5b                   	pop    %ebx
80101e2c:	5e                   	pop    %esi
80101e2d:	5f                   	pop    %edi
80101e2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e2f:	ff e0                	jmp    *%eax
80101e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e3b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e3e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e41:	50                   	push   %eax
80101e42:	e8 59 fa ff ff       	call   801018a0 <iupdate>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb b5                	jmp    80101e01 <writei+0xd1>
      return -1;
80101e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e51:	eb b1                	jmp    80101e04 <writei+0xd4>
80101e53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e66:	6a 0e                	push   $0xe
80101e68:	ff 75 0c             	pushl  0xc(%ebp)
80101e6b:	ff 75 08             	pushl  0x8(%ebp)
80101e6e:	e8 1d 2a 00 00       	call   80104890 <strncmp>
}
80101e73:	c9                   	leave  
80101e74:	c3                   	ret    
80101e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 1c             	sub    $0x1c,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e91:	0f 85 85 00 00 00    	jne    80101f1c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e97:	8b 53 58             	mov    0x58(%ebx),%edx
80101e9a:	31 ff                	xor    %edi,%edi
80101e9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	74 3e                	je     80101ee1 <dirlookup+0x61>
80101ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ea7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea8:	6a 10                	push   $0x10
80101eaa:	57                   	push   %edi
80101eab:	56                   	push   %esi
80101eac:	53                   	push   %ebx
80101ead:	e8 7e fd ff ff       	call   80101c30 <readi>
80101eb2:	83 c4 10             	add    $0x10,%esp
80101eb5:	83 f8 10             	cmp    $0x10,%eax
80101eb8:	75 55                	jne    80101f0f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ebf:	74 18                	je     80101ed9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ec1:	83 ec 04             	sub    $0x4,%esp
80101ec4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ec7:	6a 0e                	push   $0xe
80101ec9:	50                   	push   %eax
80101eca:	ff 75 0c             	pushl  0xc(%ebp)
80101ecd:	e8 be 29 00 00       	call   80104890 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ed2:	83 c4 10             	add    $0x10,%esp
80101ed5:	85 c0                	test   %eax,%eax
80101ed7:	74 17                	je     80101ef0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ed9:	83 c7 10             	add    $0x10,%edi
80101edc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101edf:	72 c7                	jb     80101ea8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ee4:	31 c0                	xor    %eax,%eax
}
80101ee6:	5b                   	pop    %ebx
80101ee7:	5e                   	pop    %esi
80101ee8:	5f                   	pop    %edi
80101ee9:	5d                   	pop    %ebp
80101eea:	c3                   	ret    
80101eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eef:	90                   	nop
      if(poff)
80101ef0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	74 05                	je     80101efc <dirlookup+0x7c>
        *poff = off;
80101ef7:	8b 45 10             	mov    0x10(%ebp),%eax
80101efa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101efc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f00:	8b 03                	mov    (%ebx),%eax
80101f02:	e8 49 f4 ff ff       	call   80101350 <iget>
}
80101f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0a:	5b                   	pop    %ebx
80101f0b:	5e                   	pop    %esi
80101f0c:	5f                   	pop    %edi
80101f0d:	5d                   	pop    %ebp
80101f0e:	c3                   	ret    
      panic("dirlookup read");
80101f0f:	83 ec 0c             	sub    $0xc,%esp
80101f12:	68 16 77 10 80       	push   $0x80107716
80101f17:	e8 84 e5 ff ff       	call   801004a0 <panic>
    panic("dirlookup not DIR");
80101f1c:	83 ec 0c             	sub    $0xc,%esp
80101f1f:	68 04 77 10 80       	push   $0x80107704
80101f24:	e8 77 e5 ff ff       	call   801004a0 <panic>
80101f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	89 c3                	mov    %eax,%ebx
80101f38:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f3b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f3e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101f44:	0f 84 86 01 00 00    	je     801020d0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f4a:	e8 d1 1b 00 00       	call   80103b20 <myproc>
  acquire(&icache.lock);
80101f4f:	83 ec 0c             	sub    $0xc,%esp
80101f52:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101f54:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f57:	68 e0 19 11 80       	push   $0x801119e0
80101f5c:	e8 8f 26 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101f61:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f65:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101f6c:	e8 9f 27 00 00       	call   80104710 <release>
80101f71:	83 c4 10             	add    $0x10,%esp
80101f74:	eb 0d                	jmp    80101f83 <namex+0x53>
80101f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101f80:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101f83:	0f b6 07             	movzbl (%edi),%eax
80101f86:	3c 2f                	cmp    $0x2f,%al
80101f88:	74 f6                	je     80101f80 <namex+0x50>
  if(*path == 0)
80101f8a:	84 c0                	test   %al,%al
80101f8c:	0f 84 ee 00 00 00    	je     80102080 <namex+0x150>
  while(*path != '/' && *path != 0)
80101f92:	0f b6 07             	movzbl (%edi),%eax
80101f95:	3c 2f                	cmp    $0x2f,%al
80101f97:	0f 84 fb 00 00 00    	je     80102098 <namex+0x168>
80101f9d:	89 fb                	mov    %edi,%ebx
80101f9f:	84 c0                	test   %al,%al
80101fa1:	0f 84 f1 00 00 00    	je     80102098 <namex+0x168>
80101fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fae:	66 90                	xchg   %ax,%ax
    path++;
80101fb0:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101fb3:	0f b6 03             	movzbl (%ebx),%eax
80101fb6:	3c 2f                	cmp    $0x2f,%al
80101fb8:	74 04                	je     80101fbe <namex+0x8e>
80101fba:	84 c0                	test   %al,%al
80101fbc:	75 f2                	jne    80101fb0 <namex+0x80>
  len = path - s;
80101fbe:	89 d8                	mov    %ebx,%eax
80101fc0:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101fc2:	83 f8 0d             	cmp    $0xd,%eax
80101fc5:	0f 8e 85 00 00 00    	jle    80102050 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101fcb:	83 ec 04             	sub    $0x4,%esp
80101fce:	6a 0e                	push   $0xe
80101fd0:	57                   	push   %edi
    path++;
80101fd1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101fd3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101fd6:	e8 45 28 00 00       	call   80104820 <memmove>
80101fdb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fde:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fe1:	75 0d                	jne    80101ff0 <namex+0xc0>
80101fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe7:	90                   	nop
    path++;
80101fe8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101feb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101fee:	74 f8                	je     80101fe8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ff0:	83 ec 0c             	sub    $0xc,%esp
80101ff3:	56                   	push   %esi
80101ff4:	e8 57 f9 ff ff       	call   80101950 <ilock>
    if(ip->type != T_DIR){
80101ff9:	83 c4 10             	add    $0x10,%esp
80101ffc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102001:	0f 85 a1 00 00 00    	jne    801020a8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102007:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010200a:	85 d2                	test   %edx,%edx
8010200c:	74 09                	je     80102017 <namex+0xe7>
8010200e:	80 3f 00             	cmpb   $0x0,(%edi)
80102011:	0f 84 d9 00 00 00    	je     801020f0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102017:	83 ec 04             	sub    $0x4,%esp
8010201a:	6a 00                	push   $0x0
8010201c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010201f:	56                   	push   %esi
80102020:	e8 5b fe ff ff       	call   80101e80 <dirlookup>
80102025:	83 c4 10             	add    $0x10,%esp
80102028:	89 c3                	mov    %eax,%ebx
8010202a:	85 c0                	test   %eax,%eax
8010202c:	74 7a                	je     801020a8 <namex+0x178>
  iunlock(ip);
8010202e:	83 ec 0c             	sub    $0xc,%esp
80102031:	56                   	push   %esi
80102032:	e8 f9 f9 ff ff       	call   80101a30 <iunlock>
  iput(ip);
80102037:	89 34 24             	mov    %esi,(%esp)
8010203a:	89 de                	mov    %ebx,%esi
8010203c:	e8 3f fa ff ff       	call   80101a80 <iput>
  while(*path == '/')
80102041:	83 c4 10             	add    $0x10,%esp
80102044:	e9 3a ff ff ff       	jmp    80101f83 <namex+0x53>
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102050:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102053:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102056:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102059:	83 ec 04             	sub    $0x4,%esp
8010205c:	50                   	push   %eax
8010205d:	57                   	push   %edi
    name[len] = 0;
8010205e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102060:	ff 75 e4             	pushl  -0x1c(%ebp)
80102063:	e8 b8 27 00 00       	call   80104820 <memmove>
    name[len] = 0;
80102068:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010206b:	83 c4 10             	add    $0x10,%esp
8010206e:	c6 00 00             	movb   $0x0,(%eax)
80102071:	e9 68 ff ff ff       	jmp    80101fde <namex+0xae>
80102076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010207d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102080:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102083:	85 c0                	test   %eax,%eax
80102085:	0f 85 85 00 00 00    	jne    80102110 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010208b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208e:	89 f0                	mov    %esi,%eax
80102090:	5b                   	pop    %ebx
80102091:	5e                   	pop    %esi
80102092:	5f                   	pop    %edi
80102093:	5d                   	pop    %ebp
80102094:	c3                   	ret    
80102095:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010209b:	89 fb                	mov    %edi,%ebx
8010209d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801020a0:	31 c0                	xor    %eax,%eax
801020a2:	eb b5                	jmp    80102059 <namex+0x129>
801020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	56                   	push   %esi
801020ac:	e8 7f f9 ff ff       	call   80101a30 <iunlock>
  iput(ip);
801020b1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020b4:	31 f6                	xor    %esi,%esi
  iput(ip);
801020b6:	e8 c5 f9 ff ff       	call   80101a80 <iput>
      return 0;
801020bb:	83 c4 10             	add    $0x10,%esp
}
801020be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c1:	89 f0                	mov    %esi,%eax
801020c3:	5b                   	pop    %ebx
801020c4:	5e                   	pop    %esi
801020c5:	5f                   	pop    %edi
801020c6:	5d                   	pop    %ebp
801020c7:	c3                   	ret    
801020c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801020d0:	ba 01 00 00 00       	mov    $0x1,%edx
801020d5:	b8 01 00 00 00       	mov    $0x1,%eax
801020da:	89 df                	mov    %ebx,%edi
801020dc:	e8 6f f2 ff ff       	call   80101350 <iget>
801020e1:	89 c6                	mov    %eax,%esi
801020e3:	e9 9b fe ff ff       	jmp    80101f83 <namex+0x53>
801020e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ef:	90                   	nop
      iunlock(ip);
801020f0:	83 ec 0c             	sub    $0xc,%esp
801020f3:	56                   	push   %esi
801020f4:	e8 37 f9 ff ff       	call   80101a30 <iunlock>
      return ip;
801020f9:	83 c4 10             	add    $0x10,%esp
}
801020fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ff:	89 f0                	mov    %esi,%eax
80102101:	5b                   	pop    %ebx
80102102:	5e                   	pop    %esi
80102103:	5f                   	pop    %edi
80102104:	5d                   	pop    %ebp
80102105:	c3                   	ret    
80102106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	56                   	push   %esi
    return 0;
80102114:	31 f6                	xor    %esi,%esi
    iput(ip);
80102116:	e8 65 f9 ff ff       	call   80101a80 <iput>
    return 0;
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	e9 68 ff ff ff       	jmp    8010208b <namex+0x15b>
80102123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102130 <dirlink>:
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 20             	sub    $0x20,%esp
80102139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010213c:	6a 00                	push   $0x0
8010213e:	ff 75 0c             	pushl  0xc(%ebp)
80102141:	53                   	push   %ebx
80102142:	e8 39 fd ff ff       	call   80101e80 <dirlookup>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	85 c0                	test   %eax,%eax
8010214c:	75 67                	jne    801021b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010214e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102151:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102154:	85 ff                	test   %edi,%edi
80102156:	74 29                	je     80102181 <dirlink+0x51>
80102158:	31 ff                	xor    %edi,%edi
8010215a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010215d:	eb 09                	jmp    80102168 <dirlink+0x38>
8010215f:	90                   	nop
80102160:	83 c7 10             	add    $0x10,%edi
80102163:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102166:	73 19                	jae    80102181 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102168:	6a 10                	push   $0x10
8010216a:	57                   	push   %edi
8010216b:	56                   	push   %esi
8010216c:	53                   	push   %ebx
8010216d:	e8 be fa ff ff       	call   80101c30 <readi>
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	83 f8 10             	cmp    $0x10,%eax
80102178:	75 4e                	jne    801021c8 <dirlink+0x98>
    if(de.inum == 0)
8010217a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010217f:	75 df                	jne    80102160 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102181:	83 ec 04             	sub    $0x4,%esp
80102184:	8d 45 da             	lea    -0x26(%ebp),%eax
80102187:	6a 0e                	push   $0xe
80102189:	ff 75 0c             	pushl  0xc(%ebp)
8010218c:	50                   	push   %eax
8010218d:	e8 5e 27 00 00       	call   801048f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102192:	6a 10                	push   $0x10
  de.inum = inum;
80102194:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
80102199:	53                   	push   %ebx
  de.inum = inum;
8010219a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219e:	e8 8d fb ff ff       	call   80101d30 <writei>
801021a3:	83 c4 20             	add    $0x20,%esp
801021a6:	83 f8 10             	cmp    $0x10,%eax
801021a9:	75 2a                	jne    801021d5 <dirlink+0xa5>
  return 0;
801021ab:	31 c0                	xor    %eax,%eax
}
801021ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b0:	5b                   	pop    %ebx
801021b1:	5e                   	pop    %esi
801021b2:	5f                   	pop    %edi
801021b3:	5d                   	pop    %ebp
801021b4:	c3                   	ret    
    iput(ip);
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	50                   	push   %eax
801021b9:	e8 c2 f8 ff ff       	call   80101a80 <iput>
    return -1;
801021be:	83 c4 10             	add    $0x10,%esp
801021c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c6:	eb e5                	jmp    801021ad <dirlink+0x7d>
      panic("dirlink read");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 25 77 10 80       	push   $0x80107725
801021d0:	e8 cb e2 ff ff       	call   801004a0 <panic>
    panic("dirlink");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 46 7d 10 80       	push   $0x80107d46
801021dd:	e8 be e2 ff ff       	call   801004a0 <panic>
801021e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021f0 <namei>:

struct inode*
namei(char *path)
{
801021f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021f1:	31 d2                	xor    %edx,%edx
{
801021f3:	89 e5                	mov    %esp,%ebp
801021f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021f8:	8b 45 08             	mov    0x8(%ebp),%eax
801021fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021fe:	e8 2d fd ff ff       	call   80101f30 <namex>
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    
80102205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102210 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102210:	55                   	push   %ebp
  return namex(path, 1, name);
80102211:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102216:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010221b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010221e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010221f:	e9 0c fd ff ff       	jmp    80101f30 <namex>
80102224:	66 90                	xchg   %ax,%ax
80102226:	66 90                	xchg   %ax,%ax
80102228:	66 90                	xchg   %ax,%ax
8010222a:	66 90                	xchg   %ax,%ax
8010222c:	66 90                	xchg   %ax,%ax
8010222e:	66 90                	xchg   %ax,%ax

80102230 <idestart>:
80102230:	55                   	push   %ebp
80102231:	85 c0                	test   %eax,%eax
80102233:	89 e5                	mov    %esp,%ebp
80102235:	56                   	push   %esi
80102236:	53                   	push   %ebx
80102237:	0f 84 af 00 00 00    	je     801022ec <idestart+0xbc>
8010223d:	8b 58 08             	mov    0x8(%eax),%ebx
80102240:	89 c6                	mov    %eax,%esi
80102242:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
80102248:	0f 87 91 00 00 00    	ja     801022df <idestart+0xaf>
8010224e:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 ca                	mov    %ecx,%edx
8010225a:	ec                   	in     (%dx),%al
8010225b:	83 e0 c0             	and    $0xffffffc0,%eax
8010225e:	3c 40                	cmp    $0x40,%al
80102260:	75 f6                	jne    80102258 <idestart+0x28>
80102262:	31 c0                	xor    %eax,%eax
80102264:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102269:	ee                   	out    %al,(%dx)
8010226a:	b8 01 00 00 00       	mov    $0x1,%eax
8010226f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102274:	ee                   	out    %al,(%dx)
80102275:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010227a:	89 d8                	mov    %ebx,%eax
8010227c:	ee                   	out    %al,(%dx)
8010227d:	89 d8                	mov    %ebx,%eax
8010227f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102284:	c1 f8 08             	sar    $0x8,%eax
80102287:	ee                   	out    %al,(%dx)
80102288:	89 d8                	mov    %ebx,%eax
8010228a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010228f:	c1 f8 10             	sar    $0x10,%eax
80102292:	ee                   	out    %al,(%dx)
80102293:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102297:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010229c:	c1 e0 04             	shl    $0x4,%eax
8010229f:	83 e0 10             	and    $0x10,%eax
801022a2:	83 c8 e0             	or     $0xffffffe0,%eax
801022a5:	ee                   	out    %al,(%dx)
801022a6:	f6 06 04             	testb  $0x4,(%esi)
801022a9:	75 15                	jne    801022c0 <idestart+0x90>
801022ab:	b8 20 00 00 00       	mov    $0x20,%eax
801022b0:	89 ca                	mov    %ecx,%edx
801022b2:	ee                   	out    %al,(%dx)
801022b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022b6:	5b                   	pop    %ebx
801022b7:	5e                   	pop    %esi
801022b8:	5d                   	pop    %ebp
801022b9:	c3                   	ret    
801022ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022c0:	b8 30 00 00 00       	mov    $0x30,%eax
801022c5:	89 ca                	mov    %ecx,%edx
801022c7:	ee                   	out    %al,(%dx)
801022c8:	b9 80 00 00 00       	mov    $0x80,%ecx
801022cd:	83 c6 5c             	add    $0x5c,%esi
801022d0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022d5:	fc                   	cld    
801022d6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801022d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022db:	5b                   	pop    %ebx
801022dc:	5e                   	pop    %esi
801022dd:	5d                   	pop    %ebp
801022de:	c3                   	ret    
801022df:	83 ec 0c             	sub    $0xc,%esp
801022e2:	68 90 77 10 80       	push   $0x80107790
801022e7:	e8 b4 e1 ff ff       	call   801004a0 <panic>
801022ec:	83 ec 0c             	sub    $0xc,%esp
801022ef:	68 87 77 10 80       	push   $0x80107787
801022f4:	e8 a7 e1 ff ff       	call   801004a0 <panic>
801022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102300 <ideinit>:
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	83 ec 10             	sub    $0x10,%esp
80102306:	68 a2 77 10 80       	push   $0x801077a2
8010230b:	68 80 b5 10 80       	push   $0x8010b580
80102310:	e8 eb 21 00 00       	call   80104500 <initlock>
80102315:	58                   	pop    %eax
80102316:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010231b:	5a                   	pop    %edx
8010231c:	83 e8 01             	sub    $0x1,%eax
8010231f:	50                   	push   %eax
80102320:	6a 0e                	push   $0xe
80102322:	e8 a9 02 00 00       	call   801025d0 <ioapicenable>
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010232f:	90                   	nop
80102330:	ec                   	in     (%dx),%al
80102331:	83 e0 c0             	and    $0xffffffc0,%eax
80102334:	3c 40                	cmp    $0x40,%al
80102336:	75 f8                	jne    80102330 <ideinit+0x30>
80102338:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010233d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102342:	ee                   	out    %al,(%dx)
80102343:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102348:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010234d:	eb 06                	jmp    80102355 <ideinit+0x55>
8010234f:	90                   	nop
80102350:	83 e9 01             	sub    $0x1,%ecx
80102353:	74 0f                	je     80102364 <ideinit+0x64>
80102355:	ec                   	in     (%dx),%al
80102356:	84 c0                	test   %al,%al
80102358:	74 f6                	je     80102350 <ideinit+0x50>
8010235a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102361:	00 00 00 
80102364:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102369:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010236e:	ee                   	out    %al,(%dx)
8010236f:	c9                   	leave  
80102370:	c3                   	ret    
80102371:	eb 0d                	jmp    80102380 <ideintr>
80102373:	90                   	nop
80102374:	90                   	nop
80102375:	90                   	nop
80102376:	90                   	nop
80102377:	90                   	nop
80102378:	90                   	nop
80102379:	90                   	nop
8010237a:	90                   	nop
8010237b:	90                   	nop
8010237c:	90                   	nop
8010237d:	90                   	nop
8010237e:	90                   	nop
8010237f:	90                   	nop

80102380 <ideintr>:
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 18             	sub    $0x18,%esp
80102389:	68 80 b5 10 80       	push   $0x8010b580
8010238e:	e8 5d 22 00 00       	call   801045f0 <acquire>
80102393:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 db                	test   %ebx,%ebx
8010239e:	74 67                	je     80102407 <ideintr+0x87>
801023a0:	8b 43 58             	mov    0x58(%ebx),%eax
801023a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564
801023a8:	8b 3b                	mov    (%ebx),%edi
801023aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801023b0:	75 31                	jne    801023e3 <ideintr+0x63>
801023b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023b7:	89 f6                	mov    %esi,%esi
801023b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023c0:	ec                   	in     (%dx),%al
801023c1:	89 c6                	mov    %eax,%esi
801023c3:	83 e6 c0             	and    $0xffffffc0,%esi
801023c6:	89 f1                	mov    %esi,%ecx
801023c8:	80 f9 40             	cmp    $0x40,%cl
801023cb:	75 f3                	jne    801023c0 <ideintr+0x40>
801023cd:	a8 21                	test   $0x21,%al
801023cf:	75 12                	jne    801023e3 <ideintr+0x63>
801023d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801023d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801023d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023de:	fc                   	cld    
801023df:	f3 6d                	rep insl (%dx),%es:(%edi)
801023e1:	8b 3b                	mov    (%ebx),%edi
801023e3:	83 e7 fb             	and    $0xfffffffb,%edi
801023e6:	83 ec 0c             	sub    $0xc,%esp
801023e9:	89 f9                	mov    %edi,%ecx
801023eb:	83 c9 02             	or     $0x2,%ecx
801023ee:	89 0b                	mov    %ecx,(%ebx)
801023f0:	53                   	push   %ebx
801023f1:	e8 5a 1e 00 00       	call   80104250 <wakeup>
801023f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801023fb:	83 c4 10             	add    $0x10,%esp
801023fe:	85 c0                	test   %eax,%eax
80102400:	74 05                	je     80102407 <ideintr+0x87>
80102402:	e8 29 fe ff ff       	call   80102230 <idestart>
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 80 b5 10 80       	push   $0x8010b580
8010240f:	e8 fc 22 00 00       	call   80104710 <release>
80102414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5f                   	pop    %edi
8010241a:	5d                   	pop    %ebp
8010241b:	c3                   	ret    
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102420 <iderw>:
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	53                   	push   %ebx
80102424:	83 ec 10             	sub    $0x10,%esp
80102427:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010242a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010242d:	50                   	push   %eax
8010242e:	e8 9d 20 00 00       	call   801044d0 <holdingsleep>
80102433:	83 c4 10             	add    $0x10,%esp
80102436:	85 c0                	test   %eax,%eax
80102438:	0f 84 c6 00 00 00    	je     80102504 <iderw+0xe4>
8010243e:	8b 03                	mov    (%ebx),%eax
80102440:	83 e0 06             	and    $0x6,%eax
80102443:	83 f8 02             	cmp    $0x2,%eax
80102446:	0f 84 ab 00 00 00    	je     801024f7 <iderw+0xd7>
8010244c:	8b 53 04             	mov    0x4(%ebx),%edx
8010244f:	85 d2                	test   %edx,%edx
80102451:	74 0d                	je     80102460 <iderw+0x40>
80102453:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102458:	85 c0                	test   %eax,%eax
8010245a:	0f 84 b1 00 00 00    	je     80102511 <iderw+0xf1>
80102460:	83 ec 0c             	sub    $0xc,%esp
80102463:	68 80 b5 10 80       	push   $0x8010b580
80102468:	e8 83 21 00 00       	call   801045f0 <acquire>
8010246d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102473:	83 c4 10             	add    $0x10,%esp
80102476:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
8010247d:	85 d2                	test   %edx,%edx
8010247f:	75 09                	jne    8010248a <iderw+0x6a>
80102481:	eb 6d                	jmp    801024f0 <iderw+0xd0>
80102483:	90                   	nop
80102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102488:	89 c2                	mov    %eax,%edx
8010248a:	8b 42 58             	mov    0x58(%edx),%eax
8010248d:	85 c0                	test   %eax,%eax
8010248f:	75 f7                	jne    80102488 <iderw+0x68>
80102491:	83 c2 58             	add    $0x58,%edx
80102494:	89 1a                	mov    %ebx,(%edx)
80102496:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010249c:	74 42                	je     801024e0 <iderw+0xc0>
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 e0 06             	and    $0x6,%eax
801024a3:	83 f8 02             	cmp    $0x2,%eax
801024a6:	74 23                	je     801024cb <iderw+0xab>
801024a8:	90                   	nop
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024b0:	83 ec 08             	sub    $0x8,%esp
801024b3:	68 80 b5 10 80       	push   $0x8010b580
801024b8:	53                   	push   %ebx
801024b9:	e8 d2 1b 00 00       	call   80104090 <sleep>
801024be:	8b 03                	mov    (%ebx),%eax
801024c0:	83 c4 10             	add    $0x10,%esp
801024c3:	83 e0 06             	and    $0x6,%eax
801024c6:	83 f8 02             	cmp    $0x2,%eax
801024c9:	75 e5                	jne    801024b0 <iderw+0x90>
801024cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
801024d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d5:	c9                   	leave  
801024d6:	e9 35 22 00 00       	jmp    80104710 <release>
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e0:	89 d8                	mov    %ebx,%eax
801024e2:	e8 49 fd ff ff       	call   80102230 <idestart>
801024e7:	eb b5                	jmp    8010249e <iderw+0x7e>
801024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801024f5:	eb 9d                	jmp    80102494 <iderw+0x74>
801024f7:	83 ec 0c             	sub    $0xc,%esp
801024fa:	68 bc 77 10 80       	push   $0x801077bc
801024ff:	e8 9c df ff ff       	call   801004a0 <panic>
80102504:	83 ec 0c             	sub    $0xc,%esp
80102507:	68 a6 77 10 80       	push   $0x801077a6
8010250c:	e8 8f df ff ff       	call   801004a0 <panic>
80102511:	83 ec 0c             	sub    $0xc,%esp
80102514:	68 d1 77 10 80       	push   $0x801077d1
80102519:	e8 82 df ff ff       	call   801004a0 <panic>
8010251e:	66 90                	xchg   %ax,%ax

80102520 <ioapicinit>:
80102520:	55                   	push   %ebp
80102521:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102528:	00 c0 fe 
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	56                   	push   %esi
8010252e:	53                   	push   %ebx
8010252f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102536:	00 00 00 
80102539:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010253f:	8b 72 10             	mov    0x10(%edx),%esi
80102542:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80102548:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010254e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
80102555:	89 f0                	mov    %esi,%eax
80102557:	c1 e8 10             	shr    $0x10,%eax
8010255a:	0f b6 f0             	movzbl %al,%esi
8010255d:	8b 41 10             	mov    0x10(%ecx),%eax
80102560:	c1 e8 18             	shr    $0x18,%eax
80102563:	39 d0                	cmp    %edx,%eax
80102565:	74 16                	je     8010257d <ioapicinit+0x5d>
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 f0 77 10 80       	push   $0x801077f0
8010256f:	e8 fc e1 ff ff       	call   80100770 <cprintf>
80102574:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010257a:	83 c4 10             	add    $0x10,%esp
8010257d:	83 c6 21             	add    $0x21,%esi
80102580:	ba 10 00 00 00       	mov    $0x10,%edx
80102585:	b8 20 00 00 00       	mov    $0x20,%eax
8010258a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102590:	89 11                	mov    %edx,(%ecx)
80102592:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102598:	89 c3                	mov    %eax,%ebx
8010259a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801025a0:	83 c0 01             	add    $0x1,%eax
801025a3:	89 59 10             	mov    %ebx,0x10(%ecx)
801025a6:	8d 5a 01             	lea    0x1(%edx),%ebx
801025a9:	83 c2 02             	add    $0x2,%edx
801025ac:	39 f0                	cmp    %esi,%eax
801025ae:	89 19                	mov    %ebx,(%ecx)
801025b0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801025b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801025bd:	75 d1                	jne    80102590 <ioapicinit+0x70>
801025bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c2:	5b                   	pop    %ebx
801025c3:	5e                   	pop    %esi
801025c4:	5d                   	pop    %ebp
801025c5:	c3                   	ret    
801025c6:	8d 76 00             	lea    0x0(%esi),%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <ioapicenable>:
801025d0:	55                   	push   %ebp
801025d1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801025d7:	89 e5                	mov    %esp,%ebp
801025d9:	8b 45 08             	mov    0x8(%ebp),%eax
801025dc:	8d 50 20             	lea    0x20(%eax),%edx
801025df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
801025e3:	89 01                	mov    %eax,(%ecx)
801025e5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801025eb:	83 c0 01             	add    $0x1,%eax
801025ee:	89 51 10             	mov    %edx,0x10(%ecx)
801025f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801025f4:	89 01                	mov    %eax,(%ecx)
801025f6:	a1 34 36 11 80       	mov    0x80113634,%eax
801025fb:	c1 e2 18             	shl    $0x18,%edx
801025fe:	89 50 10             	mov    %edx,0x10(%eax)
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	66 90                	xchg   %ax,%ax
80102605:	66 90                	xchg   %ax,%ax
80102607:	66 90                	xchg   %ax,%ax
80102609:	66 90                	xchg   %ax,%ax
8010260b:	66 90                	xchg   %ax,%ax
8010260d:	66 90                	xchg   %ax,%ax
8010260f:	90                   	nop

80102610 <kfree>:
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	53                   	push   %ebx
80102614:	83 ec 04             	sub    $0x4,%esp
80102617:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010261a:	89 d8                	mov    %ebx,%eax
8010261c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102621:	81 fb a8 64 11 80    	cmp    $0x801164a8,%ebx
80102627:	72 79                	jb     801026a2 <kfree+0x92>
80102629:	85 c0                	test   %eax,%eax
8010262b:	75 75                	jne    801026a2 <kfree+0x92>
8010262d:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80102633:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
80102639:	77 67                	ja     801026a2 <kfree+0x92>
8010263b:	83 ec 04             	sub    $0x4,%esp
8010263e:	68 00 10 00 00       	push   $0x1000
80102643:	6a 01                	push   $0x1
80102645:	53                   	push   %ebx
80102646:	e8 25 21 00 00       	call   80104770 <memset>
8010264b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102651:	83 c4 10             	add    $0x10,%esp
80102654:	85 d2                	test   %edx,%edx
80102656:	75 38                	jne    80102690 <kfree+0x80>
80102658:	a1 78 36 11 80       	mov    0x80113678,%eax
8010265d:	89 03                	mov    %eax,(%ebx)
8010265f:	a1 74 36 11 80       	mov    0x80113674,%eax
80102664:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
8010266a:	85 c0                	test   %eax,%eax
8010266c:	75 0a                	jne    80102678 <kfree+0x68>
8010266e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102671:	c9                   	leave  
80102672:	c3                   	ret    
80102673:	90                   	nop
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102678:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
8010267f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102682:	c9                   	leave  
80102683:	e9 88 20 00 00       	jmp    80104710 <release>
80102688:	90                   	nop
80102689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 36 11 80       	push   $0x80113640
80102698:	e8 53 1f 00 00       	call   801045f0 <acquire>
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	eb b6                	jmp    80102658 <kfree+0x48>
801026a2:	83 ec 08             	sub    $0x8,%esp
801026a5:	50                   	push   %eax
801026a6:	68 22 78 10 80       	push   $0x80107822
801026ab:	e8 c0 e0 ff ff       	call   80100770 <cprintf>
801026b0:	83 c4 0c             	add    $0xc,%esp
801026b3:	68 00 00 40 00       	push   $0x400000
801026b8:	53                   	push   %ebx
801026b9:	68 2e 78 10 80       	push   $0x8010782e
801026be:	e8 ad e0 ff ff       	call   80100770 <cprintf>
801026c3:	c7 04 24 4a 78 10 80 	movl   $0x8010784a,(%esp)
801026ca:	e8 d1 dd ff ff       	call   801004a0 <panic>
801026cf:	90                   	nop

801026d0 <freerange>:
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
801026d5:	8b 45 08             	mov    0x8(%ebp),%eax
801026d8:	8b 75 0c             	mov    0xc(%ebp),%esi
801026db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801026e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ed:	39 de                	cmp    %ebx,%esi
801026ef:	72 23                	jb     80102714 <freerange+0x44>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026fe:	83 ec 0c             	sub    $0xc,%esp
80102701:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102707:	50                   	push   %eax
80102708:	e8 03 ff ff ff       	call   80102610 <kfree>
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	39 f3                	cmp    %esi,%ebx
80102712:	76 e4                	jbe    801026f8 <freerange+0x28>
80102714:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102717:	5b                   	pop    %ebx
80102718:	5e                   	pop    %esi
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <kinit1>:
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 50 78 10 80       	push   $0x80107850
80102730:	68 40 36 11 80       	push   $0x80113640
80102735:	e8 c6 1d 00 00       	call   80104500 <initlock>
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102747:	00 00 00 
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
80102760:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102766:	83 ec 0c             	sub    $0xc,%esp
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010276f:	50                   	push   %eax
80102770:	e8 9b fe ff ff       	call   80102610 <kfree>
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret    
80102783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <kinit2>:
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	8b 45 08             	mov    0x8(%ebp),%eax
80102798:	8b 75 0c             	mov    0xc(%ebp),%esi
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <kinit2+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027be:	83 ec 0c             	sub    $0xc,%esp
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027c7:	50                   	push   %eax
801027c8:	e8 43 fe ff ff       	call   80102610 <kfree>
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 de                	cmp    %ebx,%esi
801027d2:	73 e4                	jae    801027b8 <kinit2+0x28>
801027d4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801027db:	00 00 00 
801027de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e1:	5b                   	pop    %ebx
801027e2:	5e                   	pop    %esi
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <kalloc>:
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	53                   	push   %ebx
801027f4:	83 ec 04             	sub    $0x4,%esp
801027f7:	a1 74 36 11 80       	mov    0x80113674,%eax
801027fc:	85 c0                	test   %eax,%eax
801027fe:	75 30                	jne    80102830 <kalloc+0x40>
80102800:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
80102806:	85 db                	test   %ebx,%ebx
80102808:	74 1c                	je     80102826 <kalloc+0x36>
8010280a:	8b 13                	mov    (%ebx),%edx
8010280c:	89 15 78 36 11 80    	mov    %edx,0x80113678
80102812:	85 c0                	test   %eax,%eax
80102814:	74 10                	je     80102826 <kalloc+0x36>
80102816:	83 ec 0c             	sub    $0xc,%esp
80102819:	68 40 36 11 80       	push   $0x80113640
8010281e:	e8 ed 1e 00 00       	call   80104710 <release>
80102823:	83 c4 10             	add    $0x10,%esp
80102826:	89 d8                	mov    %ebx,%eax
80102828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010282b:	c9                   	leave  
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	68 40 36 11 80       	push   $0x80113640
80102838:	e8 b3 1d 00 00       	call   801045f0 <acquire>
8010283d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	a1 74 36 11 80       	mov    0x80113674,%eax
8010284b:	85 db                	test   %ebx,%ebx
8010284d:	75 bb                	jne    8010280a <kalloc+0x1a>
8010284f:	eb c1                	jmp    80102812 <kalloc+0x22>
80102851:	66 90                	xchg   %ax,%ax
80102853:	66 90                	xchg   %ax,%ax
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <kbdgetc>:
80102860:	ba 64 00 00 00       	mov    $0x64,%edx
80102865:	ec                   	in     (%dx),%al
80102866:	a8 01                	test   $0x1,%al
80102868:	0f 84 c2 00 00 00    	je     80102930 <kbdgetc+0xd0>
8010286e:	ba 60 00 00 00       	mov    $0x60,%edx
80102873:	ec                   	in     (%dx),%al
80102874:	0f b6 d0             	movzbl %al,%edx
80102877:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
8010287d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102883:	0f 84 7f 00 00 00    	je     80102908 <kbdgetc+0xa8>
80102889:	55                   	push   %ebp
8010288a:	89 e5                	mov    %esp,%ebp
8010288c:	53                   	push   %ebx
8010288d:	89 cb                	mov    %ecx,%ebx
8010288f:	83 e3 40             	and    $0x40,%ebx
80102892:	84 c0                	test   %al,%al
80102894:	78 4a                	js     801028e0 <kbdgetc+0x80>
80102896:	85 db                	test   %ebx,%ebx
80102898:	74 09                	je     801028a3 <kbdgetc+0x43>
8010289a:	83 c8 80             	or     $0xffffff80,%eax
8010289d:	83 e1 bf             	and    $0xffffffbf,%ecx
801028a0:	0f b6 d0             	movzbl %al,%edx
801028a3:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
801028aa:	09 c1                	or     %eax,%ecx
801028ac:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
801028b3:	31 c1                	xor    %eax,%ecx
801028b5:	89 c8                	mov    %ecx,%eax
801028b7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
801028bd:	83 e0 03             	and    $0x3,%eax
801028c0:	83 e1 08             	and    $0x8,%ecx
801028c3:	8b 04 85 60 78 10 80 	mov    -0x7fef87a0(,%eax,4),%eax
801028ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
801028ce:	74 31                	je     80102901 <kbdgetc+0xa1>
801028d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801028d3:	83 fa 19             	cmp    $0x19,%edx
801028d6:	77 40                	ja     80102918 <kbdgetc+0xb8>
801028d8:	83 e8 20             	sub    $0x20,%eax
801028db:	5b                   	pop    %ebx
801028dc:	5d                   	pop    %ebp
801028dd:	c3                   	ret    
801028de:	66 90                	xchg   %ax,%ax
801028e0:	83 e0 7f             	and    $0x7f,%eax
801028e3:	85 db                	test   %ebx,%ebx
801028e5:	0f 44 d0             	cmove  %eax,%edx
801028e8:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
801028ef:	83 c8 40             	or     $0x40,%eax
801028f2:	0f b6 c0             	movzbl %al,%eax
801028f5:	f7 d0                	not    %eax
801028f7:	21 c1                	and    %eax,%ecx
801028f9:	31 c0                	xor    %eax,%eax
801028fb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
80102901:	5b                   	pop    %ebx
80102902:	5d                   	pop    %ebp
80102903:	c3                   	ret    
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102908:	83 c9 40             	or     $0x40,%ecx
8010290b:	31 c0                	xor    %eax,%eax
8010290d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
80102913:	c3                   	ret    
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102918:	8d 48 bf             	lea    -0x41(%eax),%ecx
8010291b:	8d 50 20             	lea    0x20(%eax),%edx
8010291e:	5b                   	pop    %ebx
8010291f:	83 f9 1a             	cmp    $0x1a,%ecx
80102922:	0f 42 c2             	cmovb  %edx,%eax
80102925:	5d                   	pop    %ebp
80102926:	c3                   	ret    
80102927:	89 f6                	mov    %esi,%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102935:	c3                   	ret    
80102936:	8d 76 00             	lea    0x0(%esi),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <kbdintr>:
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	83 ec 14             	sub    $0x14,%esp
80102946:	68 60 28 10 80       	push   $0x80102860
8010294b:	e8 d0 df ff ff       	call   80100920 <consoleintr>
80102950:	83 c4 10             	add    $0x10,%esp
80102953:	c9                   	leave  
80102954:	c3                   	ret    
80102955:	66 90                	xchg   %ax,%ax
80102957:	66 90                	xchg   %ax,%ax
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <lapicinit>:
80102960:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102965:	55                   	push   %ebp
80102966:	89 e5                	mov    %esp,%ebp
80102968:	85 c0                	test   %eax,%eax
8010296a:	0f 84 c8 00 00 00    	je     80102a38 <lapicinit+0xd8>
80102970:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102977:	01 00 00 
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
8010297d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102984:	00 00 00 
80102987:	8b 50 20             	mov    0x20(%eax),%edx
8010298a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102991:	00 02 00 
80102994:	8b 50 20             	mov    0x20(%eax),%edx
80102997:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010299e:	96 98 00 
801029a1:	8b 50 20             	mov    0x20(%eax),%edx
801029a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029ab:	00 01 00 
801029ae:	8b 50 20             	mov    0x20(%eax),%edx
801029b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029b8:	00 01 00 
801029bb:	8b 50 20             	mov    0x20(%eax),%edx
801029be:	8b 50 30             	mov    0x30(%eax),%edx
801029c1:	c1 ea 10             	shr    $0x10,%edx
801029c4:	80 fa 03             	cmp    $0x3,%dl
801029c7:	77 77                	ja     80102a40 <lapicinit+0xe0>
801029c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029d0:	00 00 00 
801029d3:	8b 50 20             	mov    0x20(%eax),%edx
801029d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029dd:	00 00 00 
801029e0:	8b 50 20             	mov    0x20(%eax),%edx
801029e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029ea:	00 00 00 
801029ed:	8b 50 20             	mov    0x20(%eax),%edx
801029f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029f7:	00 00 00 
801029fa:	8b 50 20             	mov    0x20(%eax),%edx
801029fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a04:	00 00 00 
80102a07:	8b 50 20             	mov    0x20(%eax),%edx
80102a0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a11:	85 08 00 
80102a14:	8b 50 20             	mov    0x20(%eax),%edx
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102a20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a26:	80 e6 10             	and    $0x10,%dh
80102a29:	75 f5                	jne    80102a20 <lapicinit+0xc0>
80102a2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a32:	00 00 00 
80102a35:	8b 40 20             	mov    0x20(%eax),%eax
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a47:	00 01 00 
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
80102a4d:	e9 77 ff ff ff       	jmp    801029c9 <lapicinit+0x69>
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <lapicid>:
80102a60:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
80102a66:	55                   	push   %ebp
80102a67:	31 c0                	xor    %eax,%eax
80102a69:	89 e5                	mov    %esp,%ebp
80102a6b:	85 d2                	test   %edx,%edx
80102a6d:	74 06                	je     80102a75 <lapicid+0x15>
80102a6f:	8b 42 20             	mov    0x20(%edx),%eax
80102a72:	c1 e8 18             	shr    $0x18,%eax
80102a75:	5d                   	pop    %ebp
80102a76:	c3                   	ret    
80102a77:	89 f6                	mov    %esi,%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <lapiceoi>:
80102a80:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	74 0d                	je     80102a99 <lapiceoi+0x19>
80102a8c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a93:	00 00 00 
80102a96:	8b 40 20             	mov    0x20(%eax),%eax
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	90                   	nop
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <microdelay>:
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	5d                   	pop    %ebp
80102aa4:	c3                   	ret    
80102aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <lapicstartap>:
80102ab0:	55                   	push   %ebp
80102ab1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ab6:	ba 70 00 00 00       	mov    $0x70,%edx
80102abb:	89 e5                	mov    %esp,%ebp
80102abd:	53                   	push   %ebx
80102abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ac4:	ee                   	out    %al,(%dx)
80102ac5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aca:	ba 71 00 00 00       	mov    $0x71,%edx
80102acf:	ee                   	out    %al,(%dx)
80102ad0:	31 c0                	xor    %eax,%eax
80102ad2:	c1 e3 18             	shl    $0x18,%ebx
80102ad5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
80102adb:	89 c8                	mov    %ecx,%eax
80102add:	c1 e9 0c             	shr    $0xc,%ecx
80102ae0:	c1 e8 04             	shr    $0x4,%eax
80102ae3:	89 da                	mov    %ebx,%edx
80102ae5:	80 cd 06             	or     $0x6,%ch
80102ae8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
80102aee:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102af3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
80102af9:	8b 58 20             	mov    0x20(%eax),%ebx
80102afc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b03:	c5 00 00 
80102b06:	8b 58 20             	mov    0x20(%eax),%ebx
80102b09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b10:	85 00 00 
80102b13:	8b 58 20             	mov    0x20(%eax),%ebx
80102b16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
80102b1c:	8b 58 20             	mov    0x20(%eax),%ebx
80102b1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102b25:	8b 58 20             	mov    0x20(%eax),%ebx
80102b28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
80102b2e:	8b 50 20             	mov    0x20(%eax),%edx
80102b31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102b37:	8b 40 20             	mov    0x20(%eax),%eax
80102b3a:	5b                   	pop    %ebx
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi

80102b40 <cmostime>:
80102b40:	55                   	push   %ebp
80102b41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b46:	ba 70 00 00 00       	mov    $0x70,%edx
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	57                   	push   %edi
80102b4e:	56                   	push   %esi
80102b4f:	53                   	push   %ebx
80102b50:	83 ec 4c             	sub    $0x4c,%esp
80102b53:	ee                   	out    %al,(%dx)
80102b54:	ba 71 00 00 00       	mov    $0x71,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	83 e0 04             	and    $0x4,%eax
80102b5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
80102b68:	31 c0                	xor    %eax,%eax
80102b6a:	89 da                	mov    %ebx,%edx
80102b6c:	ee                   	out    %al,(%dx)
80102b6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b72:	89 ca                	mov    %ecx,%edx
80102b74:	ec                   	in     (%dx),%al
80102b75:	88 45 b7             	mov    %al,-0x49(%ebp)
80102b78:	89 da                	mov    %ebx,%edx
80102b7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b7f:	ee                   	out    %al,(%dx)
80102b80:	89 ca                	mov    %ecx,%edx
80102b82:	ec                   	in     (%dx),%al
80102b83:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	b8 04 00 00 00       	mov    $0x4,%eax
80102b8d:	ee                   	out    %al,(%dx)
80102b8e:	89 ca                	mov    %ecx,%edx
80102b90:	ec                   	in     (%dx),%al
80102b91:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102b94:	89 da                	mov    %ebx,%edx
80102b96:	b8 07 00 00 00       	mov    $0x7,%eax
80102b9b:	ee                   	out    %al,(%dx)
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ba9:	ee                   	out    %al,(%dx)
80102baa:	89 ca                	mov    %ecx,%edx
80102bac:	ec                   	in     (%dx),%al
80102bad:	89 c7                	mov    %eax,%edi
80102baf:	89 da                	mov    %ebx,%edx
80102bb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bb6:	ee                   	out    %al,(%dx)
80102bb7:	89 ca                	mov    %ecx,%edx
80102bb9:	ec                   	in     (%dx),%al
80102bba:	89 c6                	mov    %eax,%esi
80102bbc:	89 da                	mov    %ebx,%edx
80102bbe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bc3:	ee                   	out    %al,(%dx)
80102bc4:	89 ca                	mov    %ecx,%edx
80102bc6:	ec                   	in     (%dx),%al
80102bc7:	84 c0                	test   %al,%al
80102bc9:	78 9d                	js     80102b68 <cmostime+0x28>
80102bcb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bcf:	89 fa                	mov    %edi,%edx
80102bd1:	0f b6 fa             	movzbl %dl,%edi
80102bd4:	89 f2                	mov    %esi,%edx
80102bd6:	0f b6 f2             	movzbl %dl,%esi
80102bd9:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102bdc:	89 da                	mov    %ebx,%edx
80102bde:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102be1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102be4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102be8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102beb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bf2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bf6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bf9:	31 c0                	xor    %eax,%eax
80102bfb:	ee                   	out    %al,(%dx)
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
80102bff:	0f b6 c0             	movzbl %al,%eax
80102c02:	89 da                	mov    %ebx,%edx
80102c04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c07:	b8 02 00 00 00       	mov    $0x2,%eax
80102c0c:	ee                   	out    %al,(%dx)
80102c0d:	89 ca                	mov    %ecx,%edx
80102c0f:	ec                   	in     (%dx),%al
80102c10:	0f b6 c0             	movzbl %al,%eax
80102c13:	89 da                	mov    %ebx,%edx
80102c15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c18:	b8 04 00 00 00       	mov    $0x4,%eax
80102c1d:	ee                   	out    %al,(%dx)
80102c1e:	89 ca                	mov    %ecx,%edx
80102c20:	ec                   	in     (%dx),%al
80102c21:	0f b6 c0             	movzbl %al,%eax
80102c24:	89 da                	mov    %ebx,%edx
80102c26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c29:	b8 07 00 00 00       	mov    $0x7,%eax
80102c2e:	ee                   	out    %al,(%dx)
80102c2f:	89 ca                	mov    %ecx,%edx
80102c31:	ec                   	in     (%dx),%al
80102c32:	0f b6 c0             	movzbl %al,%eax
80102c35:	89 da                	mov    %ebx,%edx
80102c37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c3f:	ee                   	out    %al,(%dx)
80102c40:	89 ca                	mov    %ecx,%edx
80102c42:	ec                   	in     (%dx),%al
80102c43:	0f b6 c0             	movzbl %al,%eax
80102c46:	89 da                	mov    %ebx,%edx
80102c48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c50:	ee                   	out    %al,(%dx)
80102c51:	89 ca                	mov    %ecx,%edx
80102c53:	ec                   	in     (%dx),%al
80102c54:	0f b6 c0             	movzbl %al,%eax
80102c57:	83 ec 04             	sub    $0x4,%esp
80102c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102c5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c60:	6a 18                	push   $0x18
80102c62:	50                   	push   %eax
80102c63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c66:	50                   	push   %eax
80102c67:	e8 54 1b 00 00       	call   801047c0 <memcmp>
80102c6c:	83 c4 10             	add    $0x10,%esp
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	0f 85 f1 fe ff ff    	jne    80102b68 <cmostime+0x28>
80102c77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c7b:	75 78                	jne    80102cf5 <cmostime+0x1b5>
80102c7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c80:	89 c2                	mov    %eax,%edx
80102c82:	83 e0 0f             	and    $0xf,%eax
80102c85:	c1 ea 04             	shr    $0x4,%edx
80102c88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c94:	89 c2                	mov    %eax,%edx
80102c96:	83 e0 0f             	and    $0xf,%eax
80102c99:	c1 ea 04             	shr    $0x4,%edx
80102c9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca2:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ca5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca8:	89 c2                	mov    %eax,%edx
80102caa:	83 e0 0f             	and    $0xf,%eax
80102cad:	c1 ea 04             	shr    $0x4,%edx
80102cb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102cb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cbc:	89 c2                	mov    %eax,%edx
80102cbe:	83 e0 0f             	and    $0xf,%eax
80102cc1:	c1 ea 04             	shr    $0x4,%edx
80102cc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ccd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cd0:	89 c2                	mov    %eax,%edx
80102cd2:	83 e0 0f             	and    $0xf,%eax
80102cd5:	c1 ea 04             	shr    $0x4,%edx
80102cd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cde:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102ce1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ce4:	89 c2                	mov    %eax,%edx
80102ce6:	83 e0 0f             	and    $0xf,%eax
80102ce9:	c1 ea 04             	shr    $0x4,%edx
80102cec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf2:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102cf5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cfb:	89 06                	mov    %eax,(%esi)
80102cfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d00:	89 46 04             	mov    %eax,0x4(%esi)
80102d03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d06:	89 46 08             	mov    %eax,0x8(%esi)
80102d09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d12:	89 46 10             	mov    %eax,0x10(%esi)
80102d15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d18:	89 46 14             	mov    %eax,0x14(%esi)
80102d1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
80102d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d25:	5b                   	pop    %ebx
80102d26:	5e                   	pop    %esi
80102d27:	5f                   	pop    %edi
80102d28:	5d                   	pop    %ebp
80102d29:	c3                   	ret    
80102d2a:	66 90                	xchg   %ax,%ax
80102d2c:	66 90                	xchg   %ax,%ax
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <install_trans>:
80102d30:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102d36:	85 c9                	test   %ecx,%ecx
80102d38:	0f 8e 85 00 00 00    	jle    80102dc3 <install_trans+0x93>
80102d3e:	55                   	push   %ebp
80102d3f:	89 e5                	mov    %esp,%ebp
80102d41:	57                   	push   %edi
80102d42:	56                   	push   %esi
80102d43:	53                   	push   %ebx
80102d44:	31 db                	xor    %ebx,%ebx
80102d46:	83 ec 0c             	sub    $0xc,%esp
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d55:	83 ec 08             	sub    $0x8,%esp
80102d58:	01 d8                	add    %ebx,%eax
80102d5a:	83 c0 01             	add    $0x1,%eax
80102d5d:	50                   	push   %eax
80102d5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d64:	e8 27 d4 ff ff       	call   80100190 <bread>
80102d69:	89 c7                	mov    %eax,%edi
80102d6b:	58                   	pop    %eax
80102d6c:	5a                   	pop    %edx
80102d6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102d74:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d7a:	83 c3 01             	add    $0x1,%ebx
80102d7d:	e8 0e d4 ff ff       	call   80100190 <bread>
80102d82:	89 c6                	mov    %eax,%esi
80102d84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d87:	83 c4 0c             	add    $0xc,%esp
80102d8a:	68 00 02 00 00       	push   $0x200
80102d8f:	50                   	push   %eax
80102d90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d93:	50                   	push   %eax
80102d94:	e8 87 1a 00 00       	call   80104820 <memmove>
80102d99:	89 34 24             	mov    %esi,(%esp)
80102d9c:	e8 2f d4 ff ff       	call   801001d0 <bwrite>
80102da1:	89 3c 24             	mov    %edi,(%esp)
80102da4:	e8 67 d4 ff ff       	call   80100210 <brelse>
80102da9:	89 34 24             	mov    %esi,(%esp)
80102dac:	e8 5f d4 ff ff       	call   80100210 <brelse>
80102db1:	83 c4 10             	add    $0x10,%esp
80102db4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102dba:	7f 94                	jg     80102d50 <install_trans+0x20>
80102dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dbf:	5b                   	pop    %ebx
80102dc0:	5e                   	pop    %esi
80102dc1:	5f                   	pop    %edi
80102dc2:	5d                   	pop    %ebp
80102dc3:	f3 c3                	repz ret 
80102dc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dd0 <write_head>:
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 0c             	sub    $0xc,%esp
80102dd7:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ddd:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102de3:	e8 a8 d3 ff ff       	call   80100190 <bread>
80102de8:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dee:	83 c4 10             	add    $0x10,%esp
80102df1:	89 c3                	mov    %eax,%ebx
80102df3:	85 c9                	test   %ecx,%ecx
80102df5:	89 48 5c             	mov    %ecx,0x5c(%eax)
80102df8:	7e 1f                	jle    80102e19 <write_head+0x49>
80102dfa:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e01:	31 d2                	xor    %edx,%edx
80102e03:	90                   	nop
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e08:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e0e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e12:	83 c2 04             	add    $0x4,%edx
80102e15:	39 c2                	cmp    %eax,%edx
80102e17:	75 ef                	jne    80102e08 <write_head+0x38>
80102e19:	83 ec 0c             	sub    $0xc,%esp
80102e1c:	53                   	push   %ebx
80102e1d:	e8 ae d3 ff ff       	call   801001d0 <bwrite>
80102e22:	89 1c 24             	mov    %ebx,(%esp)
80102e25:	e8 e6 d3 ff ff       	call   80100210 <brelse>
80102e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2d:	c9                   	leave  
80102e2e:	c3                   	ret    
80102e2f:	90                   	nop

80102e30 <initlog>:
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 2c             	sub    $0x2c,%esp
80102e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e3a:	68 80 7a 10 80       	push   $0x80107a80
80102e3f:	68 80 36 11 80       	push   $0x80113680
80102e44:	e8 b7 16 00 00       	call   80104500 <initlock>
80102e49:	58                   	pop    %eax
80102e4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 bb e6 ff ff       	call   80101510 <readsb>
80102e55:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e5b:	59                   	pop    %ecx
80102e5c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
80102e62:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
80102e68:	a3 b4 36 11 80       	mov    %eax,0x801136b4
80102e6d:	5a                   	pop    %edx
80102e6e:	50                   	push   %eax
80102e6f:	53                   	push   %ebx
80102e70:	e8 1b d3 ff ff       	call   80100190 <bread>
80102e75:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	85 c9                	test   %ecx,%ecx
80102e7d:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
80102e83:	7e 1c                	jle    80102ea1 <initlog+0x71>
80102e85:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102e8c:	31 d2                	xor    %edx,%edx
80102e8e:	66 90                	xchg   %ax,%ax
80102e90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e94:	83 c2 04             	add    $0x4,%edx
80102e97:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
80102e9d:	39 da                	cmp    %ebx,%edx
80102e9f:	75 ef                	jne    80102e90 <initlog+0x60>
80102ea1:	83 ec 0c             	sub    $0xc,%esp
80102ea4:	50                   	push   %eax
80102ea5:	e8 66 d3 ff ff       	call   80100210 <brelse>
80102eaa:	e8 81 fe ff ff       	call   80102d30 <install_trans>
80102eaf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102eb6:	00 00 00 
80102eb9:	e8 12 ff ff ff       	call   80102dd0 <write_head>
80102ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec1:	c9                   	leave  
80102ec2:	c3                   	ret    
80102ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ed0 <begin_op>:
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 14             	sub    $0x14,%esp
80102ed6:	68 80 36 11 80       	push   $0x80113680
80102edb:	e8 10 17 00 00       	call   801045f0 <acquire>
80102ee0:	83 c4 10             	add    $0x10,%esp
80102ee3:	eb 18                	jmp    80102efd <begin_op+0x2d>
80102ee5:	8d 76 00             	lea    0x0(%esi),%esi
80102ee8:	83 ec 08             	sub    $0x8,%esp
80102eeb:	68 80 36 11 80       	push   $0x80113680
80102ef0:	68 80 36 11 80       	push   $0x80113680
80102ef5:	e8 96 11 00 00       	call   80104090 <sleep>
80102efa:	83 c4 10             	add    $0x10,%esp
80102efd:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f02:	85 c0                	test   %eax,%eax
80102f04:	75 e2                	jne    80102ee8 <begin_op+0x18>
80102f06:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f0b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f11:	83 c0 01             	add    $0x1,%eax
80102f14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f1a:	83 fa 1e             	cmp    $0x1e,%edx
80102f1d:	7f c9                	jg     80102ee8 <begin_op+0x18>
80102f1f:	83 ec 0c             	sub    $0xc,%esp
80102f22:	a3 bc 36 11 80       	mov    %eax,0x801136bc
80102f27:	68 80 36 11 80       	push   $0x80113680
80102f2c:	e8 df 17 00 00       	call   80104710 <release>
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    
80102f36:	8d 76 00             	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <end_op>:
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	57                   	push   %edi
80102f44:	56                   	push   %esi
80102f45:	53                   	push   %ebx
80102f46:	83 ec 18             	sub    $0x18,%esp
80102f49:	68 80 36 11 80       	push   $0x80113680
80102f4e:	e8 9d 16 00 00       	call   801045f0 <acquire>
80102f53:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f58:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102f5e:	83 c4 10             	add    $0x10,%esp
80102f61:	83 e8 01             	sub    $0x1,%eax
80102f64:	85 db                	test   %ebx,%ebx
80102f66:	a3 bc 36 11 80       	mov    %eax,0x801136bc
80102f6b:	0f 85 23 01 00 00    	jne    80103094 <end_op+0x154>
80102f71:	85 c0                	test   %eax,%eax
80102f73:	0f 85 f7 00 00 00    	jne    80103070 <end_op+0x130>
80102f79:	83 ec 0c             	sub    $0xc,%esp
80102f7c:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102f83:	00 00 00 
80102f86:	31 db                	xor    %ebx,%ebx
80102f88:	68 80 36 11 80       	push   $0x80113680
80102f8d:	e8 7e 17 00 00       	call   80104710 <release>
80102f92:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102f98:	83 c4 10             	add    $0x10,%esp
80102f9b:	85 c9                	test   %ecx,%ecx
80102f9d:	0f 8e 8a 00 00 00    	jle    8010302d <end_op+0xed>
80102fa3:	90                   	nop
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102fad:	83 ec 08             	sub    $0x8,%esp
80102fb0:	01 d8                	add    %ebx,%eax
80102fb2:	83 c0 01             	add    $0x1,%eax
80102fb5:	50                   	push   %eax
80102fb6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fbc:	e8 cf d1 ff ff       	call   80100190 <bread>
80102fc1:	89 c6                	mov    %eax,%esi
80102fc3:	58                   	pop    %eax
80102fc4:	5a                   	pop    %edx
80102fc5:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102fcc:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fd2:	83 c3 01             	add    $0x1,%ebx
80102fd5:	e8 b6 d1 ff ff       	call   80100190 <bread>
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fdf:	83 c4 0c             	add    $0xc,%esp
80102fe2:	68 00 02 00 00       	push   $0x200
80102fe7:	50                   	push   %eax
80102fe8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102feb:	50                   	push   %eax
80102fec:	e8 2f 18 00 00       	call   80104820 <memmove>
80102ff1:	89 34 24             	mov    %esi,(%esp)
80102ff4:	e8 d7 d1 ff ff       	call   801001d0 <bwrite>
80102ff9:	89 3c 24             	mov    %edi,(%esp)
80102ffc:	e8 0f d2 ff ff       	call   80100210 <brelse>
80103001:	89 34 24             	mov    %esi,(%esp)
80103004:	e8 07 d2 ff ff       	call   80100210 <brelse>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103012:	7c 94                	jl     80102fa8 <end_op+0x68>
80103014:	e8 b7 fd ff ff       	call   80102dd0 <write_head>
80103019:	e8 12 fd ff ff       	call   80102d30 <install_trans>
8010301e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103025:	00 00 00 
80103028:	e8 a3 fd ff ff       	call   80102dd0 <write_head>
8010302d:	83 ec 0c             	sub    $0xc,%esp
80103030:	68 80 36 11 80       	push   $0x80113680
80103035:	e8 b6 15 00 00       	call   801045f0 <acquire>
8010303a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103041:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103048:	00 00 00 
8010304b:	e8 00 12 00 00       	call   80104250 <wakeup>
80103050:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103057:	e8 b4 16 00 00       	call   80104710 <release>
8010305c:	83 c4 10             	add    $0x10,%esp
8010305f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103062:	5b                   	pop    %ebx
80103063:	5e                   	pop    %esi
80103064:	5f                   	pop    %edi
80103065:	5d                   	pop    %ebp
80103066:	c3                   	ret    
80103067:	89 f6                	mov    %esi,%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103070:	83 ec 0c             	sub    $0xc,%esp
80103073:	68 80 36 11 80       	push   $0x80113680
80103078:	e8 d3 11 00 00       	call   80104250 <wakeup>
8010307d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103084:	e8 87 16 00 00       	call   80104710 <release>
80103089:	83 c4 10             	add    $0x10,%esp
8010308c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308f:	5b                   	pop    %ebx
80103090:	5e                   	pop    %esi
80103091:	5f                   	pop    %edi
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    
80103094:	83 ec 0c             	sub    $0xc,%esp
80103097:	68 84 7a 10 80       	push   $0x80107a84
8010309c:	e8 ff d3 ff ff       	call   801004a0 <panic>
801030a1:	eb 0d                	jmp    801030b0 <log_write>
801030a3:	90                   	nop
801030a4:	90                   	nop
801030a5:	90                   	nop
801030a6:	90                   	nop
801030a7:	90                   	nop
801030a8:	90                   	nop
801030a9:	90                   	nop
801030aa:	90                   	nop
801030ab:	90                   	nop
801030ac:	90                   	nop
801030ad:	90                   	nop
801030ae:	90                   	nop
801030af:	90                   	nop

801030b0 <log_write>:
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	53                   	push   %ebx
801030b4:	83 ec 04             	sub    $0x4,%esp
801030b7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801030bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030c0:	83 fa 1d             	cmp    $0x1d,%edx
801030c3:	0f 8f 97 00 00 00    	jg     80103160 <log_write+0xb0>
801030c9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801030ce:	83 e8 01             	sub    $0x1,%eax
801030d1:	39 c2                	cmp    %eax,%edx
801030d3:	0f 8d 87 00 00 00    	jge    80103160 <log_write+0xb0>
801030d9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801030de:	85 c0                	test   %eax,%eax
801030e0:	0f 8e 87 00 00 00    	jle    8010316d <log_write+0xbd>
801030e6:	83 ec 0c             	sub    $0xc,%esp
801030e9:	68 80 36 11 80       	push   $0x80113680
801030ee:	e8 fd 14 00 00       	call   801045f0 <acquire>
801030f3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	83 fa 00             	cmp    $0x0,%edx
801030ff:	7e 50                	jle    80103151 <log_write+0xa1>
80103101:	8b 4b 08             	mov    0x8(%ebx),%ecx
80103104:	31 c0                	xor    %eax,%eax
80103106:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010310c:	75 0b                	jne    80103119 <log_write+0x69>
8010310e:	eb 38                	jmp    80103148 <log_write+0x98>
80103110:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103117:	74 2f                	je     80103148 <log_write+0x98>
80103119:	83 c0 01             	add    $0x1,%eax
8010311c:	39 d0                	cmp    %edx,%eax
8010311e:	75 f0                	jne    80103110 <log_write+0x60>
80103120:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
80103127:	83 c2 01             	add    $0x1,%edx
8010312a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80103130:	83 0b 04             	orl    $0x4,(%ebx)
80103133:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
8010313a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010313d:	c9                   	leave  
8010313e:	e9 cd 15 00 00       	jmp    80104710 <release>
80103143:	90                   	nop
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103148:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010314f:	eb df                	jmp    80103130 <log_write+0x80>
80103151:	8b 43 08             	mov    0x8(%ebx),%eax
80103154:	a3 cc 36 11 80       	mov    %eax,0x801136cc
80103159:	75 d5                	jne    80103130 <log_write+0x80>
8010315b:	eb ca                	jmp    80103127 <log_write+0x77>
8010315d:	8d 76 00             	lea    0x0(%esi),%esi
80103160:	83 ec 0c             	sub    $0xc,%esp
80103163:	68 93 7a 10 80       	push   $0x80107a93
80103168:	e8 33 d3 ff ff       	call   801004a0 <panic>
8010316d:	83 ec 0c             	sub    $0xc,%esp
80103170:	68 a9 7a 10 80       	push   $0x80107aa9
80103175:	e8 26 d3 ff ff       	call   801004a0 <panic>
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpmain>:
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	53                   	push   %ebx
80103184:	83 ec 04             	sub    $0x4,%esp
80103187:	e8 74 09 00 00       	call   80103b00 <cpuid>
8010318c:	89 c3                	mov    %eax,%ebx
8010318e:	e8 6d 09 00 00       	call   80103b00 <cpuid>
80103193:	83 ec 04             	sub    $0x4,%esp
80103196:	53                   	push   %ebx
80103197:	50                   	push   %eax
80103198:	68 c4 7a 10 80       	push   $0x80107ac4
8010319d:	e8 ce d5 ff ff       	call   80100770 <cprintf>
801031a2:	e8 a9 28 00 00       	call   80105a50 <idtinit>
801031a7:	e8 d4 08 00 00       	call   80103a80 <mycpu>
801031ac:	89 c2                	mov    %eax,%edx
801031ae:	b8 01 00 00 00       	mov    $0x1,%eax
801031b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
801031ba:	e8 f1 0b 00 00       	call   80103db0 <scheduler>
801031bf:	90                   	nop

801031c0 <mpenter>:
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	83 ec 08             	sub    $0x8,%esp
801031c6:	e8 e5 3a 00 00       	call   80106cb0 <switchkvm>
801031cb:	e8 50 3a 00 00       	call   80106c20 <seginit>
801031d0:	e8 8b f7 ff ff       	call   80102960 <lapicinit>
801031d5:	e8 a6 ff ff ff       	call   80103180 <mpmain>
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <main>:
801031e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031e4:	83 e4 f0             	and    $0xfffffff0,%esp
801031e7:	ff 71 fc             	pushl  -0x4(%ecx)
801031ea:	55                   	push   %ebp
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	53                   	push   %ebx
801031ee:	51                   	push   %ecx
801031ef:	83 ec 08             	sub    $0x8,%esp
801031f2:	68 00 00 40 80       	push   $0x80400000
801031f7:	68 a8 64 11 80       	push   $0x801164a8
801031fc:	e8 1f f5 ff ff       	call   80102720 <kinit1>
80103201:	e8 2a 41 00 00       	call   80107330 <kvmalloc>
80103206:	e8 75 01 00 00       	call   80103380 <mpinit>
8010320b:	e8 50 f7 ff ff       	call   80102960 <lapicinit>
80103210:	e8 0b 3a 00 00       	call   80106c20 <seginit>
80103215:	e8 46 03 00 00       	call   80103560 <picinit>
8010321a:	e8 01 f3 ff ff       	call   80102520 <ioapicinit>
8010321f:	e8 ac d8 ff ff       	call   80100ad0 <consoleinit>
80103224:	e8 57 2d 00 00       	call   80105f80 <uartinit>
80103229:	e8 32 08 00 00       	call   80103a60 <pinit>
8010322e:	e8 9d 27 00 00       	call   801059d0 <tvinit>
80103233:	e8 c8 ce ff ff       	call   80100100 <binit>
80103238:	e8 33 dc ff ff       	call   80100e70 <fileinit>
8010323d:	e8 be f0 ff ff       	call   80102300 <ideinit>
80103242:	83 c4 0c             	add    $0xc,%esp
80103245:	68 8a 00 00 00       	push   $0x8a
8010324a:	68 8c b4 10 80       	push   $0x8010b48c
8010324f:	68 00 70 00 80       	push   $0x80007000
80103254:	e8 c7 15 00 00       	call   80104820 <memmove>
80103259:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103260:	00 00 00 
80103263:	83 c4 10             	add    $0x10,%esp
80103266:	05 80 37 11 80       	add    $0x80113780,%eax
8010326b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103270:	76 71                	jbe    801032e3 <main+0x103>
80103272:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103277:	89 f6                	mov    %esi,%esi
80103279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103280:	e8 fb 07 00 00       	call   80103a80 <mycpu>
80103285:	39 d8                	cmp    %ebx,%eax
80103287:	74 41                	je     801032ca <main+0xea>
80103289:	e8 62 f5 ff ff       	call   801027f0 <kalloc>
8010328e:	05 00 10 00 00       	add    $0x1000,%eax
80103293:	c7 05 f8 6f 00 80 c0 	movl   $0x801031c0,0x80006ff8
8010329a:	31 10 80 
8010329d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032a4:	a0 10 00 
801032a7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
801032ac:	0f b6 03             	movzbl (%ebx),%eax
801032af:	83 ec 08             	sub    $0x8,%esp
801032b2:	68 00 70 00 00       	push   $0x7000
801032b7:	50                   	push   %eax
801032b8:	e8 f3 f7 ff ff       	call   80102ab0 <lapicstartap>
801032bd:	83 c4 10             	add    $0x10,%esp
801032c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032c6:	85 c0                	test   %eax,%eax
801032c8:	74 f6                	je     801032c0 <main+0xe0>
801032ca:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032d1:	00 00 00 
801032d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032da:	05 80 37 11 80       	add    $0x80113780,%eax
801032df:	39 c3                	cmp    %eax,%ebx
801032e1:	72 9d                	jb     80103280 <main+0xa0>
801032e3:	83 ec 08             	sub    $0x8,%esp
801032e6:	68 00 00 40 80       	push   $0x80400000
801032eb:	68 00 00 40 80       	push   $0x80400000
801032f0:	e8 9b f4 ff ff       	call   80102790 <kinit2>
801032f5:	e8 56 08 00 00       	call   80103b50 <userinit>
801032fa:	e8 81 fe ff ff       	call   80103180 <mpmain>
801032ff:	90                   	nop

80103300 <mpsearch1>:
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
8010330b:	53                   	push   %ebx
8010330c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
8010330f:	83 ec 0c             	sub    $0xc,%esp
80103312:	39 de                	cmp    %ebx,%esi
80103314:	72 10                	jb     80103326 <mpsearch1+0x26>
80103316:	eb 50                	jmp    80103368 <mpsearch1+0x68>
80103318:	90                   	nop
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103320:	39 fb                	cmp    %edi,%ebx
80103322:	89 fe                	mov    %edi,%esi
80103324:	76 42                	jbe    80103368 <mpsearch1+0x68>
80103326:	83 ec 04             	sub    $0x4,%esp
80103329:	8d 7e 10             	lea    0x10(%esi),%edi
8010332c:	6a 04                	push   $0x4
8010332e:	68 d8 7a 10 80       	push   $0x80107ad8
80103333:	56                   	push   %esi
80103334:	e8 87 14 00 00       	call   801047c0 <memcmp>
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	85 c0                	test   %eax,%eax
8010333e:	75 e0                	jne    80103320 <mpsearch1+0x20>
80103340:	89 f1                	mov    %esi,%ecx
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103348:	0f b6 11             	movzbl (%ecx),%edx
8010334b:	83 c1 01             	add    $0x1,%ecx
8010334e:	01 d0                	add    %edx,%eax
80103350:	39 f9                	cmp    %edi,%ecx
80103352:	75 f4                	jne    80103348 <mpsearch1+0x48>
80103354:	84 c0                	test   %al,%al
80103356:	75 c8                	jne    80103320 <mpsearch1+0x20>
80103358:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335b:	89 f0                	mov    %esi,%eax
8010335d:	5b                   	pop    %ebx
8010335e:	5e                   	pop    %esi
8010335f:	5f                   	pop    %edi
80103360:	5d                   	pop    %ebp
80103361:	c3                   	ret    
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103368:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336b:	31 f6                	xor    %esi,%esi
8010336d:	89 f0                	mov    %esi,%eax
8010336f:	5b                   	pop    %ebx
80103370:	5e                   	pop    %esi
80103371:	5f                   	pop    %edi
80103372:	5d                   	pop    %ebp
80103373:	c3                   	ret    
80103374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010337a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103380 <mpinit>:
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 1c             	sub    $0x1c,%esp
80103389:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103390:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103397:	c1 e0 08             	shl    $0x8,%eax
8010339a:	09 d0                	or     %edx,%eax
8010339c:	c1 e0 04             	shl    $0x4,%eax
8010339f:	85 c0                	test   %eax,%eax
801033a1:	75 1b                	jne    801033be <mpinit+0x3e>
801033a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033b1:	c1 e0 08             	shl    $0x8,%eax
801033b4:	09 d0                	or     %edx,%eax
801033b6:	c1 e0 0a             	shl    $0xa,%eax
801033b9:	2d 00 04 00 00       	sub    $0x400,%eax
801033be:	ba 00 04 00 00       	mov    $0x400,%edx
801033c3:	e8 38 ff ff ff       	call   80103300 <mpsearch1>
801033c8:	85 c0                	test   %eax,%eax
801033ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033cd:	0f 84 3d 01 00 00    	je     80103510 <mpinit+0x190>
801033d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033d6:	8b 58 04             	mov    0x4(%eax),%ebx
801033d9:	85 db                	test   %ebx,%ebx
801033db:	0f 84 4f 01 00 00    	je     80103530 <mpinit+0x1b0>
801033e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
801033e7:	83 ec 04             	sub    $0x4,%esp
801033ea:	6a 04                	push   $0x4
801033ec:	68 f5 7a 10 80       	push   $0x80107af5
801033f1:	56                   	push   %esi
801033f2:	e8 c9 13 00 00       	call   801047c0 <memcmp>
801033f7:	83 c4 10             	add    $0x10,%esp
801033fa:	85 c0                	test   %eax,%eax
801033fc:	0f 85 2e 01 00 00    	jne    80103530 <mpinit+0x1b0>
80103402:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103409:	3c 01                	cmp    $0x1,%al
8010340b:	0f 95 c2             	setne  %dl
8010340e:	3c 04                	cmp    $0x4,%al
80103410:	0f 95 c0             	setne  %al
80103413:	20 c2                	and    %al,%dl
80103415:	0f 85 15 01 00 00    	jne    80103530 <mpinit+0x1b0>
8010341b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
80103422:	66 85 ff             	test   %di,%di
80103425:	74 1a                	je     80103441 <mpinit+0xc1>
80103427:	89 f0                	mov    %esi,%eax
80103429:	01 f7                	add    %esi,%edi
8010342b:	31 d2                	xor    %edx,%edx
8010342d:	8d 76 00             	lea    0x0(%esi),%esi
80103430:	0f b6 08             	movzbl (%eax),%ecx
80103433:	83 c0 01             	add    $0x1,%eax
80103436:	01 ca                	add    %ecx,%edx
80103438:	39 c7                	cmp    %eax,%edi
8010343a:	75 f4                	jne    80103430 <mpinit+0xb0>
8010343c:	84 d2                	test   %dl,%dl
8010343e:	0f 95 c2             	setne  %dl
80103441:	85 f6                	test   %esi,%esi
80103443:	0f 84 e7 00 00 00    	je     80103530 <mpinit+0x1b0>
80103449:	84 d2                	test   %dl,%dl
8010344b:	0f 85 df 00 00 00    	jne    80103530 <mpinit+0x1b0>
80103451:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103457:	a3 7c 36 11 80       	mov    %eax,0x8011367c
8010345c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103463:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103469:	bb 01 00 00 00       	mov    $0x1,%ebx
8010346e:	01 d6                	add    %edx,%esi
80103470:	39 c6                	cmp    %eax,%esi
80103472:	76 23                	jbe    80103497 <mpinit+0x117>
80103474:	0f b6 10             	movzbl (%eax),%edx
80103477:	80 fa 04             	cmp    $0x4,%dl
8010347a:	0f 87 ca 00 00 00    	ja     8010354a <mpinit+0x1ca>
80103480:	ff 24 95 1c 7b 10 80 	jmp    *-0x7fef84e4(,%edx,4)
80103487:	89 f6                	mov    %esi,%esi
80103489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103490:	83 c0 08             	add    $0x8,%eax
80103493:	39 c6                	cmp    %eax,%esi
80103495:	77 dd                	ja     80103474 <mpinit+0xf4>
80103497:	85 db                	test   %ebx,%ebx
80103499:	0f 84 9e 00 00 00    	je     8010353d <mpinit+0x1bd>
8010349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034a6:	74 15                	je     801034bd <mpinit+0x13d>
801034a8:	b8 70 00 00 00       	mov    $0x70,%eax
801034ad:	ba 22 00 00 00       	mov    $0x22,%edx
801034b2:	ee                   	out    %al,(%dx)
801034b3:	ba 23 00 00 00       	mov    $0x23,%edx
801034b8:	ec                   	in     (%dx),%al
801034b9:	83 c8 01             	or     $0x1,%eax
801034bc:	ee                   	out    %al,(%dx)
801034bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c0:	5b                   	pop    %ebx
801034c1:	5e                   	pop    %esi
801034c2:	5f                   	pop    %edi
801034c3:	5d                   	pop    %ebp
801034c4:	c3                   	ret    
801034c5:	8d 76 00             	lea    0x0(%esi),%esi
801034c8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801034ce:	83 f9 07             	cmp    $0x7,%ecx
801034d1:	7f 19                	jg     801034ec <mpinit+0x16c>
801034d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034dd:	83 c1 01             	add    $0x1,%ecx
801034e0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
801034e6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
801034ec:	83 c0 14             	add    $0x14,%eax
801034ef:	e9 7c ff ff ff       	jmp    80103470 <mpinit+0xf0>
801034f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034fc:	83 c0 08             	add    $0x8,%eax
801034ff:	88 15 60 37 11 80    	mov    %dl,0x80113760
80103505:	e9 66 ff ff ff       	jmp    80103470 <mpinit+0xf0>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103510:	ba 00 00 01 00       	mov    $0x10000,%edx
80103515:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010351a:	e8 e1 fd ff ff       	call   80103300 <mpsearch1>
8010351f:	85 c0                	test   %eax,%eax
80103521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103524:	0f 85 a9 fe ff ff    	jne    801033d3 <mpinit+0x53>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	68 dd 7a 10 80       	push   $0x80107add
80103538:	e8 63 cf ff ff       	call   801004a0 <panic>
8010353d:	83 ec 0c             	sub    $0xc,%esp
80103540:	68 fc 7a 10 80       	push   $0x80107afc
80103545:	e8 56 cf ff ff       	call   801004a0 <panic>
8010354a:	31 db                	xor    %ebx,%ebx
8010354c:	e9 26 ff ff ff       	jmp    80103477 <mpinit+0xf7>
80103551:	66 90                	xchg   %ax,%ax
80103553:	66 90                	xchg   %ax,%ax
80103555:	66 90                	xchg   %ax,%ax
80103557:	66 90                	xchg   %ax,%ax
80103559:	66 90                	xchg   %ax,%ax
8010355b:	66 90                	xchg   %ax,%ax
8010355d:	66 90                	xchg   %ax,%ax
8010355f:	90                   	nop

80103560 <picinit>:
80103560:	55                   	push   %ebp
80103561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103566:	ba 21 00 00 00       	mov    $0x21,%edx
8010356b:	89 e5                	mov    %esp,%ebp
8010356d:	ee                   	out    %al,(%dx)
8010356e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103573:	ee                   	out    %al,(%dx)
80103574:	5d                   	pop    %ebp
80103575:	c3                   	ret    
80103576:	66 90                	xchg   %ax,%ax
80103578:	66 90                	xchg   %ax,%ax
8010357a:	66 90                	xchg   %ax,%ax
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <pipealloc>:
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	8b 75 08             	mov    0x8(%ebp),%esi
8010358c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010358f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103595:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010359b:	e8 f0 d8 ff ff       	call   80100e90 <filealloc>
801035a0:	85 c0                	test   %eax,%eax
801035a2:	89 06                	mov    %eax,(%esi)
801035a4:	0f 84 a8 00 00 00    	je     80103652 <pipealloc+0xd2>
801035aa:	e8 e1 d8 ff ff       	call   80100e90 <filealloc>
801035af:	85 c0                	test   %eax,%eax
801035b1:	89 03                	mov    %eax,(%ebx)
801035b3:	0f 84 87 00 00 00    	je     80103640 <pipealloc+0xc0>
801035b9:	e8 32 f2 ff ff       	call   801027f0 <kalloc>
801035be:	85 c0                	test   %eax,%eax
801035c0:	89 c7                	mov    %eax,%edi
801035c2:	0f 84 b0 00 00 00    	je     80103678 <pipealloc+0xf8>
801035c8:	83 ec 08             	sub    $0x8,%esp
801035cb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d2:	00 00 00 
801035d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035dc:	00 00 00 
801035df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035e6:	00 00 00 
801035e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035f0:	00 00 00 
801035f3:	68 30 7b 10 80       	push   $0x80107b30
801035f8:	50                   	push   %eax
801035f9:	e8 02 0f 00 00       	call   80104500 <initlock>
801035fe:	8b 06                	mov    (%esi),%eax
80103600:	83 c4 10             	add    $0x10,%esp
80103603:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103609:	8b 06                	mov    (%esi),%eax
8010360b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
8010360f:	8b 06                	mov    (%esi),%eax
80103611:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103615:	8b 06                	mov    (%esi),%eax
80103617:	89 78 0c             	mov    %edi,0xc(%eax)
8010361a:	8b 03                	mov    (%ebx),%eax
8010361c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103622:	8b 03                	mov    (%ebx),%eax
80103624:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103628:	8b 03                	mov    (%ebx),%eax
8010362a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
8010362e:	8b 03                	mov    (%ebx),%eax
80103630:	89 78 0c             	mov    %edi,0xc(%eax)
80103633:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103636:	31 c0                	xor    %eax,%eax
80103638:	5b                   	pop    %ebx
80103639:	5e                   	pop    %esi
8010363a:	5f                   	pop    %edi
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret    
8010363d:	8d 76 00             	lea    0x0(%esi),%esi
80103640:	8b 06                	mov    (%esi),%eax
80103642:	85 c0                	test   %eax,%eax
80103644:	74 1e                	je     80103664 <pipealloc+0xe4>
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	50                   	push   %eax
8010364a:	e8 01 d9 ff ff       	call   80100f50 <fileclose>
8010364f:	83 c4 10             	add    $0x10,%esp
80103652:	8b 03                	mov    (%ebx),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	74 0c                	je     80103664 <pipealloc+0xe4>
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	50                   	push   %eax
8010365c:	e8 ef d8 ff ff       	call   80100f50 <fileclose>
80103661:	83 c4 10             	add    $0x10,%esp
80103664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103678:	8b 06                	mov    (%esi),%eax
8010367a:	85 c0                	test   %eax,%eax
8010367c:	75 c8                	jne    80103646 <pipealloc+0xc6>
8010367e:	eb d2                	jmp    80103652 <pipealloc+0xd2>

80103680 <pipeclose>:
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103688:	8b 75 0c             	mov    0xc(%ebp),%esi
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	53                   	push   %ebx
8010368f:	e8 5c 0f 00 00       	call   801045f0 <acquire>
80103694:	83 c4 10             	add    $0x10,%esp
80103697:	85 f6                	test   %esi,%esi
80103699:	74 45                	je     801036e0 <pipeclose+0x60>
8010369b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036ab:	00 00 00 
801036ae:	50                   	push   %eax
801036af:	e8 9c 0b 00 00       	call   80104250 <wakeup>
801036b4:	83 c4 10             	add    $0x10,%esp
801036b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036bd:	85 d2                	test   %edx,%edx
801036bf:	75 0a                	jne    801036cb <pipeclose+0x4b>
801036c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	74 35                	je     80103700 <pipeclose+0x80>
801036cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d1:	5b                   	pop    %ebx
801036d2:	5e                   	pop    %esi
801036d3:	5d                   	pop    %ebp
801036d4:	e9 37 10 00 00       	jmp    80104710 <release>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036e6:	83 ec 0c             	sub    $0xc,%esp
801036e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036f0:	00 00 00 
801036f3:	50                   	push   %eax
801036f4:	e8 57 0b 00 00       	call   80104250 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb b9                	jmp    801036b7 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 07 10 00 00       	call   80104710 <release>
80103709:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010370c:	83 c4 10             	add    $0x10,%esp
8010370f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103712:	5b                   	pop    %ebx
80103713:	5e                   	pop    %esi
80103714:	5d                   	pop    %ebp
80103715:	e9 f6 ee ff ff       	jmp    80102610 <kfree>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103720 <pipewrite>:
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 28             	sub    $0x28,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010372c:	53                   	push   %ebx
8010372d:	e8 be 0e 00 00       	call   801045f0 <acquire>
80103732:	8b 45 10             	mov    0x10(%ebp),%eax
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 c0                	test   %eax,%eax
8010373a:	0f 8e b9 00 00 00    	jle    801037f9 <pipewrite+0xd9>
80103740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103743:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103749:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010374f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103755:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103758:	03 4d 10             	add    0x10(%ebp),%ecx
8010375b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010375e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103764:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010376a:	39 d0                	cmp    %edx,%eax
8010376c:	74 38                	je     801037a6 <pipewrite+0x86>
8010376e:	eb 59                	jmp    801037c9 <pipewrite+0xa9>
80103770:	e8 ab 03 00 00       	call   80103b20 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	75 34                	jne    801037b0 <pipewrite+0x90>
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	57                   	push   %edi
80103780:	e8 cb 0a 00 00       	call   80104250 <wakeup>
80103785:	58                   	pop    %eax
80103786:	5a                   	pop    %edx
80103787:	53                   	push   %ebx
80103788:	56                   	push   %esi
80103789:	e8 02 09 00 00       	call   80104090 <sleep>
8010378e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103794:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010379a:	83 c4 10             	add    $0x10,%esp
8010379d:	05 00 02 00 00       	add    $0x200,%eax
801037a2:	39 c2                	cmp    %eax,%edx
801037a4:	75 2a                	jne    801037d0 <pipewrite+0xb0>
801037a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ac:	85 c0                	test   %eax,%eax
801037ae:	75 c0                	jne    80103770 <pipewrite+0x50>
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	53                   	push   %ebx
801037b4:	e8 57 0f 00 00       	call   80104710 <release>
801037b9:	83 c4 10             	add    $0x10,%esp
801037bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	5b                   	pop    %ebx
801037c5:	5e                   	pop    %esi
801037c6:	5f                   	pop    %edi
801037c7:	5d                   	pop    %ebp
801037c8:	c3                   	ret    
801037c9:	89 c2                	mov    %eax,%edx
801037cb:	90                   	nop
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801037d3:	8d 42 01             	lea    0x1(%edx),%eax
801037d6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801037da:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037e0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037e6:	0f b6 09             	movzbl (%ecx),%ecx
801037e9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801037ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801037f0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801037f3:	0f 85 65 ff ff ff    	jne    8010375e <pipewrite+0x3e>
801037f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037ff:	83 ec 0c             	sub    $0xc,%esp
80103802:	50                   	push   %eax
80103803:	e8 48 0a 00 00       	call   80104250 <wakeup>
80103808:	89 1c 24             	mov    %ebx,(%esp)
8010380b:	e8 00 0f 00 00       	call   80104710 <release>
80103810:	83 c4 10             	add    $0x10,%esp
80103813:	8b 45 10             	mov    0x10(%ebp),%eax
80103816:	eb a9                	jmp    801037c1 <pipewrite+0xa1>
80103818:	90                   	nop
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103820 <piperead>:
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 18             	sub    $0x18,%esp
80103829:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010382c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010382f:	53                   	push   %ebx
80103830:	e8 bb 0d 00 00       	call   801045f0 <acquire>
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010383e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103844:	75 6a                	jne    801038b0 <piperead+0x90>
80103846:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010384c:	85 f6                	test   %esi,%esi
8010384e:	0f 84 cc 00 00 00    	je     80103920 <piperead+0x100>
80103854:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010385a:	eb 2d                	jmp    80103889 <piperead+0x69>
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	53                   	push   %ebx
80103864:	56                   	push   %esi
80103865:	e8 26 08 00 00       	call   80104090 <sleep>
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103873:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103879:	75 35                	jne    801038b0 <piperead+0x90>
8010387b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103881:	85 d2                	test   %edx,%edx
80103883:	0f 84 97 00 00 00    	je     80103920 <piperead+0x100>
80103889:	e8 92 02 00 00       	call   80103b20 <myproc>
8010388e:	8b 48 24             	mov    0x24(%eax),%ecx
80103891:	85 c9                	test   %ecx,%ecx
80103893:	74 cb                	je     80103860 <piperead+0x40>
80103895:	83 ec 0c             	sub    $0xc,%esp
80103898:	53                   	push   %ebx
80103899:	e8 72 0e 00 00       	call   80104710 <release>
8010389e:	83 c4 10             	add    $0x10,%esp
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5f                   	pop    %edi
801038ac:	5d                   	pop    %ebp
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
801038b0:	8b 45 10             	mov    0x10(%ebp),%eax
801038b3:	85 c0                	test   %eax,%eax
801038b5:	7e 69                	jle    80103920 <piperead+0x100>
801038b7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038bd:	31 c9                	xor    %ecx,%ecx
801038bf:	eb 15                	jmp    801038d6 <piperead+0xb6>
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ce:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801038d4:	74 5a                	je     80103930 <piperead+0x110>
801038d6:	8d 70 01             	lea    0x1(%eax),%esi
801038d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801038de:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801038e4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801038e9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
801038ec:	83 c1 01             	add    $0x1,%ecx
801038ef:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801038f2:	75 d4                	jne    801038c8 <piperead+0xa8>
801038f4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	50                   	push   %eax
801038fe:	e8 4d 09 00 00       	call   80104250 <wakeup>
80103903:	89 1c 24             	mov    %ebx,(%esp)
80103906:	e8 05 0e 00 00       	call   80104710 <release>
8010390b:	8b 45 10             	mov    0x10(%ebp),%eax
8010390e:	83 c4 10             	add    $0x10,%esp
80103911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103914:	5b                   	pop    %ebx
80103915:	5e                   	pop    %esi
80103916:	5f                   	pop    %edi
80103917:	5d                   	pop    %ebp
80103918:	c3                   	ret    
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103920:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103927:	eb cb                	jmp    801038f4 <piperead+0xd4>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103930:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103933:	eb bf                	jmp    801038f4 <piperead+0xd4>
80103935:	66 90                	xchg   %ax,%ax
80103937:	66 90                	xchg   %ax,%ax
80103939:	66 90                	xchg   %ax,%ax
8010393b:	66 90                	xchg   %ax,%ax
8010393d:	66 90                	xchg   %ax,%ax
8010393f:	90                   	nop

80103940 <allocproc>:
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103949:	83 ec 10             	sub    $0x10,%esp
8010394c:	68 20 3d 11 80       	push   $0x80113d20
80103951:	e8 9a 0c 00 00       	call   801045f0 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 10                	jmp    8010396b <allocproc+0x2b>
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103960:	83 c3 7c             	add    $0x7c,%ebx
80103963:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103969:	73 75                	jae    801039e0 <allocproc+0xa0>
8010396b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010396e:	85 c0                	test   %eax,%eax
80103970:	75 ee                	jne    80103960 <allocproc+0x20>
80103972:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
80103981:	8d 50 01             	lea    0x1(%eax),%edx
80103984:	89 43 10             	mov    %eax,0x10(%ebx)
80103987:	68 20 3d 11 80       	push   $0x80113d20
8010398c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103992:	e8 79 0d 00 00       	call   80104710 <release>
80103997:	e8 54 ee ff ff       	call   801027f0 <kalloc>
8010399c:	83 c4 10             	add    $0x10,%esp
8010399f:	85 c0                	test   %eax,%eax
801039a1:	89 43 08             	mov    %eax,0x8(%ebx)
801039a4:	74 53                	je     801039f9 <allocproc+0xb9>
801039a6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801039ac:	83 ec 04             	sub    $0x4,%esp
801039af:	05 9c 0f 00 00       	add    $0xf9c,%eax
801039b4:	89 53 18             	mov    %edx,0x18(%ebx)
801039b7:	c7 40 14 c2 59 10 80 	movl   $0x801059c2,0x14(%eax)
801039be:	89 43 1c             	mov    %eax,0x1c(%ebx)
801039c1:	6a 14                	push   $0x14
801039c3:	6a 00                	push   $0x0
801039c5:	50                   	push   %eax
801039c6:	e8 a5 0d 00 00       	call   80104770 <memset>
801039cb:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039ce:	83 c4 10             	add    $0x10,%esp
801039d1:	c7 40 10 10 3a 10 80 	movl   $0x80103a10,0x10(%eax)
801039d8:	89 d8                	mov    %ebx,%eax
801039da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039dd:	c9                   	leave  
801039de:	c3                   	ret    
801039df:	90                   	nop
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	31 db                	xor    %ebx,%ebx
801039e5:	68 20 3d 11 80       	push   $0x80113d20
801039ea:	e8 21 0d 00 00       	call   80104710 <release>
801039ef:	89 d8                	mov    %ebx,%eax
801039f1:	83 c4 10             	add    $0x10,%esp
801039f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f7:	c9                   	leave  
801039f8:	c3                   	ret    
801039f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103a00:	31 db                	xor    %ebx,%ebx
80103a02:	eb d4                	jmp    801039d8 <allocproc+0x98>
80103a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a10 <forkret>:
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 14             	sub    $0x14,%esp
80103a16:	68 20 3d 11 80       	push   $0x80113d20
80103a1b:	e8 f0 0c 00 00       	call   80104710 <release>
80103a20:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	85 c0                	test   %eax,%eax
80103a2a:	75 04                	jne    80103a30 <forkret+0x20>
80103a2c:	c9                   	leave  
80103a2d:	c3                   	ret    
80103a2e:	66 90                	xchg   %ax,%ax
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a3a:	00 00 00 
80103a3d:	6a 01                	push   $0x1
80103a3f:	e8 0c dd ff ff       	call   80101750 <iinit>
80103a44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a4b:	e8 e0 f3 ff ff       	call   80102e30 <initlog>
80103a50:	83 c4 10             	add    $0x10,%esp
80103a53:	c9                   	leave  
80103a54:	c3                   	ret    
80103a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <pinit>:
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 10             	sub    $0x10,%esp
80103a66:	68 35 7b 10 80       	push   $0x80107b35
80103a6b:	68 20 3d 11 80       	push   $0x80113d20
80103a70:	e8 8b 0a 00 00       	call   80104500 <initlock>
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	c9                   	leave  
80103a79:	c3                   	ret    
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a80 <mycpu>:
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	9c                   	pushf  
80103a86:	58                   	pop    %eax
80103a87:	f6 c4 02             	test   $0x2,%ah
80103a8a:	75 5e                	jne    80103aea <mycpu+0x6a>
80103a8c:	e8 cf ef ff ff       	call   80102a60 <lapicid>
80103a91:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103a97:	85 f6                	test   %esi,%esi
80103a99:	7e 42                	jle    80103add <mycpu+0x5d>
80103a9b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103aa2:	39 d0                	cmp    %edx,%eax
80103aa4:	74 30                	je     80103ad6 <mycpu+0x56>
80103aa6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103aab:	31 d2                	xor    %edx,%edx
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
80103ab0:	83 c2 01             	add    $0x1,%edx
80103ab3:	39 f2                	cmp    %esi,%edx
80103ab5:	74 26                	je     80103add <mycpu+0x5d>
80103ab7:	0f b6 19             	movzbl (%ecx),%ebx
80103aba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ac0:	39 c3                	cmp    %eax,%ebx
80103ac2:	75 ec                	jne    80103ab0 <mycpu+0x30>
80103ac4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103aca:	05 80 37 11 80       	add    $0x80113780,%eax
80103acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad2:	5b                   	pop    %ebx
80103ad3:	5e                   	pop    %esi
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
80103ad6:	b8 80 37 11 80       	mov    $0x80113780,%eax
80103adb:	eb f2                	jmp    80103acf <mycpu+0x4f>
80103add:	83 ec 0c             	sub    $0xc,%esp
80103ae0:	68 3c 7b 10 80       	push   $0x80107b3c
80103ae5:	e8 b6 c9 ff ff       	call   801004a0 <panic>
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 18 7c 10 80       	push   $0x80107c18
80103af2:	e8 a9 c9 ff ff       	call   801004a0 <panic>
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <cpuid>:
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
80103b06:	e8 75 ff ff ff       	call   80103a80 <mycpu>
80103b0b:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103b10:	c9                   	leave  
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
80103b1a:	c3                   	ret    
80103b1b:	90                   	nop
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b20 <myproc>:
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
80103b27:	e8 84 0a 00 00       	call   801045b0 <pushcli>
80103b2c:	e8 4f ff ff ff       	call   80103a80 <mycpu>
80103b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103b37:	e8 74 0b 00 00       	call   801046b0 <popcli>
80103b3c:	83 c4 04             	add    $0x4,%esp
80103b3f:	89 d8                	mov    %ebx,%eax
80103b41:	5b                   	pop    %ebx
80103b42:	5d                   	pop    %ebp
80103b43:	c3                   	ret    
80103b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b50 <userinit>:
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
80103b57:	e8 e4 fd ff ff       	call   80103940 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx
80103b5e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
80103b63:	e8 48 37 00 00       	call   801072b0 <setupkvm>
80103b68:	85 c0                	test   %eax,%eax
80103b6a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6d:	0f 84 bd 00 00 00    	je     80103c30 <userinit+0xe0>
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 60 b4 10 80       	push   $0x8010b460
80103b80:	50                   	push   %eax
80103b81:	e8 4a 32 00 00       	call   80106dd0 <inituvm>
80103b86:	83 c4 0c             	add    $0xc,%esp
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 18             	pushl  0x18(%ebx)
80103b96:	e8 d5 0b 00 00       	call   80104770 <memset>
80103b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
80103ba3:	b9 23 00 00 00       	mov    $0x23,%ecx
80103ba8:	83 c4 0c             	add    $0xc,%esp
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
80103baf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
80103bb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
80103bc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
80103bcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
80103be0:	8b 43 18             	mov    0x18(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
80103bea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 65 7b 10 80       	push   $0x80107b65
80103bf4:	50                   	push   %eax
80103bf5:	e8 56 0d 00 00       	call   80104950 <safestrcpy>
80103bfa:	c7 04 24 6e 7b 10 80 	movl   $0x80107b6e,(%esp)
80103c01:	e8 ea e5 ff ff       	call   801021f0 <namei>
80103c06:	89 43 68             	mov    %eax,0x68(%ebx)
80103c09:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c10:	e8 db 09 00 00       	call   801045f0 <acquire>
80103c15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80103c1c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c23:	e8 e8 0a 00 00       	call   80104710 <release>
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c2e:	c9                   	leave  
80103c2f:	c3                   	ret    
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 4c 7b 10 80       	push   $0x80107b4c
80103c38:	e8 63 c8 ff ff       	call   801004a0 <panic>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <growproc>:
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c48:	e8 63 09 00 00       	call   801045b0 <pushcli>
80103c4d:	e8 2e fe ff ff       	call   80103a80 <mycpu>
80103c52:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
80103c58:	e8 53 0a 00 00       	call   801046b0 <popcli>
80103c5d:	85 db                	test   %ebx,%ebx
80103c5f:	78 1f                	js     80103c80 <growproc+0x40>
80103c61:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103c67:	77 17                	ja     80103c80 <growproc+0x40>
80103c69:	03 1e                	add    (%esi),%ebx
80103c6b:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103c71:	77 0d                	ja     80103c80 <growproc+0x40>
80103c73:	89 1e                	mov    %ebx,(%esi)
80103c75:	31 c0                	xor    %eax,%eax
80103c77:	5b                   	pop    %ebx
80103c78:	5e                   	pop    %esi
80103c79:	5d                   	pop    %ebp
80103c7a:	c3                   	ret    
80103c7b:	90                   	nop
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c85:	eb f0                	jmp    80103c77 <growproc+0x37>
80103c87:	89 f6                	mov    %esi,%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <fork>:
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 1c             	sub    $0x1c,%esp
80103c99:	e8 12 09 00 00       	call   801045b0 <pushcli>
80103c9e:	e8 dd fd ff ff       	call   80103a80 <mycpu>
80103ca3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103ca9:	e8 02 0a 00 00       	call   801046b0 <popcli>
80103cae:	e8 8d fc ff ff       	call   80103940 <allocproc>
80103cb3:	85 c0                	test   %eax,%eax
80103cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cb8:	0f 84 b7 00 00 00    	je     80103d75 <fork+0xe5>
80103cbe:	83 ec 08             	sub    $0x8,%esp
80103cc1:	ff 33                	pushl  (%ebx)
80103cc3:	ff 73 04             	pushl  0x4(%ebx)
80103cc6:	89 c7                	mov    %eax,%edi
80103cc8:	e8 b3 36 00 00       	call   80107380 <copyuvm>
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	89 47 04             	mov    %eax,0x4(%edi)
80103cd5:	0f 84 a1 00 00 00    	je     80103d7c <fork+0xec>
80103cdb:	8b 03                	mov    (%ebx),%eax
80103cdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ce0:	89 01                	mov    %eax,(%ecx)
80103ce2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ce5:	89 c8                	mov    %ecx,%eax
80103ce7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cea:	8b 73 18             	mov    0x18(%ebx),%esi
80103ced:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103cf4:	31 f6                	xor    %esi,%esi
80103cf6:	8b 40 18             	mov    0x18(%eax),%eax
80103cf9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103d00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	74 13                	je     80103d1b <fork+0x8b>
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	50                   	push   %eax
80103d0c:	e8 ef d1 ff ff       	call   80100f00 <filedup>
80103d11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103d1b:	83 c6 01             	add    $0x1,%esi
80103d1e:	83 fe 10             	cmp    $0x10,%esi
80103d21:	75 dd                	jne    80103d00 <fork+0x70>
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	ff 73 68             	pushl  0x68(%ebx)
80103d29:	83 c3 6c             	add    $0x6c,%ebx
80103d2c:	e8 ef db ff ff       	call   80101920 <idup>
80103d31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103d34:	83 c4 0c             	add    $0xc,%esp
80103d37:	89 47 68             	mov    %eax,0x68(%edi)
80103d3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d3d:	6a 10                	push   $0x10
80103d3f:	53                   	push   %ebx
80103d40:	50                   	push   %eax
80103d41:	e8 0a 0c 00 00       	call   80104950 <safestrcpy>
80103d46:	8b 5f 10             	mov    0x10(%edi),%ebx
80103d49:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d50:	e8 9b 08 00 00       	call   801045f0 <acquire>
80103d55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80103d5c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d63:	e8 a8 09 00 00       	call   80104710 <release>
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d6e:	89 d8                	mov    %ebx,%eax
80103d70:	5b                   	pop    %ebx
80103d71:	5e                   	pop    %esi
80103d72:	5f                   	pop    %edi
80103d73:	5d                   	pop    %ebp
80103d74:	c3                   	ret    
80103d75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d7a:	eb ef                	jmp    80103d6b <fork+0xdb>
80103d7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	ff 73 08             	pushl  0x8(%ebx)
80103d85:	e8 86 e8 ff ff       	call   80102610 <kfree>
80103d8a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103d91:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103da0:	eb c9                	jmp    80103d6b <fork+0xdb>
80103da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <scheduler>:
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	e8 c2 fc ff ff       	call   80103a80 <mycpu>
80103dbe:	8d 78 04             	lea    0x4(%eax),%edi
80103dc1:	89 c6                	mov    %eax,%esi
80103dc3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dca:	00 00 00 
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
80103dd0:	fb                   	sti    
80103dd1:	83 ec 0c             	sub    $0xc,%esp
80103dd4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103dd9:	68 20 3d 11 80       	push   $0x80113d20
80103dde:	e8 0d 08 00 00       	call   801045f0 <acquire>
80103de3:	83 c4 10             	add    $0x10,%esp
80103de6:	8d 76 00             	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103df0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103df4:	75 33                	jne    80103e29 <scheduler+0x79>
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
80103dff:	53                   	push   %ebx
80103e00:	e8 bb 2e 00 00       	call   80106cc0 <switchuvm>
80103e05:	58                   	pop    %eax
80103e06:	5a                   	pop    %edx
80103e07:	ff 73 1c             	pushl  0x1c(%ebx)
80103e0a:	57                   	push   %edi
80103e0b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
80103e12:	e8 94 0b 00 00       	call   801049ab <swtch>
80103e17:	e8 94 2e 00 00       	call   80106cb0 <switchkvm>
80103e1c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e23:	00 00 00 
80103e26:	83 c4 10             	add    $0x10,%esp
80103e29:	83 c3 7c             	add    $0x7c,%ebx
80103e2c:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103e32:	72 bc                	jb     80103df0 <scheduler+0x40>
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 20 3d 11 80       	push   $0x80113d20
80103e3c:	e8 cf 08 00 00       	call   80104710 <release>
80103e41:	83 c4 10             	add    $0x10,%esp
80103e44:	eb 8a                	jmp    80103dd0 <scheduler+0x20>
80103e46:	8d 76 00             	lea    0x0(%esi),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <sched>:
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
80103e55:	e8 56 07 00 00       	call   801045b0 <pushcli>
80103e5a:	e8 21 fc ff ff       	call   80103a80 <mycpu>
80103e5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103e65:	e8 46 08 00 00       	call   801046b0 <popcli>
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	68 20 3d 11 80       	push   $0x80113d20
80103e72:	e8 f9 06 00 00       	call   80104570 <holding>
80103e77:	83 c4 10             	add    $0x10,%esp
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 4f                	je     80103ecd <sched+0x7d>
80103e7e:	e8 fd fb ff ff       	call   80103a80 <mycpu>
80103e83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e8a:	75 68                	jne    80103ef4 <sched+0xa4>
80103e8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e90:	74 55                	je     80103ee7 <sched+0x97>
80103e92:	9c                   	pushf  
80103e93:	58                   	pop    %eax
80103e94:	f6 c4 02             	test   $0x2,%ah
80103e97:	75 41                	jne    80103eda <sched+0x8a>
80103e99:	e8 e2 fb ff ff       	call   80103a80 <mycpu>
80103e9e:	83 c3 1c             	add    $0x1c,%ebx
80103ea1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
80103ea7:	e8 d4 fb ff ff       	call   80103a80 <mycpu>
80103eac:	83 ec 08             	sub    $0x8,%esp
80103eaf:	ff 70 04             	pushl  0x4(%eax)
80103eb2:	53                   	push   %ebx
80103eb3:	e8 f3 0a 00 00       	call   801049ab <swtch>
80103eb8:	e8 c3 fb ff ff       	call   80103a80 <mycpu>
80103ebd:	83 c4 10             	add    $0x10,%esp
80103ec0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
80103ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ec9:	5b                   	pop    %ebx
80103eca:	5e                   	pop    %esi
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	68 70 7b 10 80       	push   $0x80107b70
80103ed5:	e8 c6 c5 ff ff       	call   801004a0 <panic>
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 9c 7b 10 80       	push   $0x80107b9c
80103ee2:	e8 b9 c5 ff ff       	call   801004a0 <panic>
80103ee7:	83 ec 0c             	sub    $0xc,%esp
80103eea:	68 8e 7b 10 80       	push   $0x80107b8e
80103eef:	e8 ac c5 ff ff       	call   801004a0 <panic>
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 82 7b 10 80       	push   $0x80107b82
80103efc:	e8 9f c5 ff ff       	call   801004a0 <panic>
80103f01:	eb 0d                	jmp    80103f10 <exit>
80103f03:	90                   	nop
80103f04:	90                   	nop
80103f05:	90                   	nop
80103f06:	90                   	nop
80103f07:	90                   	nop
80103f08:	90                   	nop
80103f09:	90                   	nop
80103f0a:	90                   	nop
80103f0b:	90                   	nop
80103f0c:	90                   	nop
80103f0d:	90                   	nop
80103f0e:	90                   	nop
80103f0f:	90                   	nop

80103f10 <exit>:
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	e8 92 06 00 00       	call   801045b0 <pushcli>
80103f1e:	e8 5d fb ff ff       	call   80103a80 <mycpu>
80103f23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
80103f29:	e8 82 07 00 00       	call   801046b0 <popcli>
80103f2e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103f34:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f37:	8d 7e 68             	lea    0x68(%esi),%edi
80103f3a:	0f 84 e7 00 00 00    	je     80104027 <exit+0x117>
80103f40:	8b 03                	mov    (%ebx),%eax
80103f42:	85 c0                	test   %eax,%eax
80103f44:	74 12                	je     80103f58 <exit+0x48>
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	50                   	push   %eax
80103f4a:	e8 01 d0 ff ff       	call   80100f50 <fileclose>
80103f4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	83 c3 04             	add    $0x4,%ebx
80103f5b:	39 fb                	cmp    %edi,%ebx
80103f5d:	75 e1                	jne    80103f40 <exit+0x30>
80103f5f:	e8 6c ef ff ff       	call   80102ed0 <begin_op>
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	ff 76 68             	pushl  0x68(%esi)
80103f6a:	e8 11 db ff ff       	call   80101a80 <iput>
80103f6f:	e8 cc ef ff ff       	call   80102f40 <end_op>
80103f74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
80103f7b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f82:	e8 69 06 00 00       	call   801045f0 <acquire>
80103f87:	8b 56 14             	mov    0x14(%esi),%edx
80103f8a:	83 c4 10             	add    $0x10,%esp
80103f8d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f92:	eb 0e                	jmp    80103fa2 <exit+0x92>
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f98:	83 c0 7c             	add    $0x7c,%eax
80103f9b:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103fa0:	73 1c                	jae    80103fbe <exit+0xae>
80103fa2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fa6:	75 f0                	jne    80103f98 <exit+0x88>
80103fa8:	3b 50 20             	cmp    0x20(%eax),%edx
80103fab:	75 eb                	jne    80103f98 <exit+0x88>
80103fad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fb4:	83 c0 7c             	add    $0x7c,%eax
80103fb7:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103fbc:	72 e4                	jb     80103fa2 <exit+0x92>
80103fbe:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103fc4:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103fc9:	eb 10                	jmp    80103fdb <exit+0xcb>
80103fcb:	90                   	nop
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd0:	83 c2 7c             	add    $0x7c,%edx
80103fd3:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103fd9:	73 33                	jae    8010400e <exit+0xfe>
80103fdb:	39 72 14             	cmp    %esi,0x14(%edx)
80103fde:	75 f0                	jne    80103fd0 <exit+0xc0>
80103fe0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
80103fe4:	89 4a 14             	mov    %ecx,0x14(%edx)
80103fe7:	75 e7                	jne    80103fd0 <exit+0xc0>
80103fe9:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fee:	eb 0a                	jmp    80103ffa <exit+0xea>
80103ff0:	83 c0 7c             	add    $0x7c,%eax
80103ff3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103ff8:	73 d6                	jae    80103fd0 <exit+0xc0>
80103ffa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ffe:	75 f0                	jne    80103ff0 <exit+0xe0>
80104000:	3b 48 20             	cmp    0x20(%eax),%ecx
80104003:	75 eb                	jne    80103ff0 <exit+0xe0>
80104005:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010400c:	eb e2                	jmp    80103ff0 <exit+0xe0>
8010400e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
80104015:	e8 36 fe ff ff       	call   80103e50 <sched>
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 bd 7b 10 80       	push   $0x80107bbd
80104022:	e8 79 c4 ff ff       	call   801004a0 <panic>
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 b0 7b 10 80       	push   $0x80107bb0
8010402f:	e8 6c c4 ff ff       	call   801004a0 <panic>
80104034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010403a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104040 <yield>:
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	68 20 3d 11 80       	push   $0x80113d20
8010404c:	e8 9f 05 00 00       	call   801045f0 <acquire>
80104051:	e8 5a 05 00 00       	call   801045b0 <pushcli>
80104056:	e8 25 fa ff ff       	call   80103a80 <mycpu>
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80104061:	e8 4a 06 00 00       	call   801046b0 <popcli>
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
8010406d:	e8 de fd ff ff       	call   80103e50 <sched>
80104072:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104079:	e8 92 06 00 00       	call   80104710 <release>
8010407e:	83 c4 10             	add    $0x10,%esp
80104081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104084:	c9                   	leave  
80104085:	c3                   	ret    
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <sleep>:
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	8b 7d 08             	mov    0x8(%ebp),%edi
8010409c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010409f:	e8 0c 05 00 00       	call   801045b0 <pushcli>
801040a4:	e8 d7 f9 ff ff       	call   80103a80 <mycpu>
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
801040af:	e8 fc 05 00 00       	call   801046b0 <popcli>
801040b4:	85 db                	test   %ebx,%ebx
801040b6:	0f 84 87 00 00 00    	je     80104143 <sleep+0xb3>
801040bc:	85 f6                	test   %esi,%esi
801040be:	74 76                	je     80104136 <sleep+0xa6>
801040c0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801040c6:	74 50                	je     80104118 <sleep+0x88>
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 20 3d 11 80       	push   $0x80113d20
801040d0:	e8 1b 05 00 00       	call   801045f0 <acquire>
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 33 06 00 00       	call   80104710 <release>
801040dd:	89 7b 20             	mov    %edi,0x20(%ebx)
801040e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
801040e7:	e8 64 fd ff ff       	call   80103e50 <sched>
801040ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
801040f3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040fa:	e8 11 06 00 00       	call   80104710 <release>
801040ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104102:	83 c4 10             	add    $0x10,%esp
80104105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5f                   	pop    %edi
8010410b:	5d                   	pop    %ebp
8010410c:	e9 df 04 00 00       	jmp    801045f0 <acquire>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104118:	89 7b 20             	mov    %edi,0x20(%ebx)
8010411b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80104122:	e8 29 fd ff ff       	call   80103e50 <sched>
80104127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5f                   	pop    %edi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 cf 7b 10 80       	push   $0x80107bcf
8010413e:	e8 5d c3 ff ff       	call   801004a0 <panic>
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 c9 7b 10 80       	push   $0x80107bc9
8010414b:	e8 50 c3 ff ff       	call   801004a0 <panic>

80104150 <wait>:
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 0c             	sub    $0xc,%esp
80104159:	e8 52 04 00 00       	call   801045b0 <pushcli>
8010415e:	e8 1d f9 ff ff       	call   80103a80 <mycpu>
80104163:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
80104169:	e8 42 05 00 00       	call   801046b0 <popcli>
8010416e:	83 ec 0c             	sub    $0xc,%esp
80104171:	68 20 3d 11 80       	push   $0x80113d20
80104176:	e8 75 04 00 00       	call   801045f0 <acquire>
8010417b:	83 c4 10             	add    $0x10,%esp
8010417e:	31 c0                	xor    %eax,%eax
80104180:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104185:	eb 14                	jmp    8010419b <wait+0x4b>
80104187:	89 f6                	mov    %esi,%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104190:	83 c3 7c             	add    $0x7c,%ebx
80104193:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104199:	73 1b                	jae    801041b6 <wait+0x66>
8010419b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010419e:	75 f0                	jne    80104190 <wait+0x40>
801041a0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041a4:	74 32                	je     801041d8 <wait+0x88>
801041a6:	83 c3 7c             	add    $0x7c,%ebx
801041a9:	b8 01 00 00 00       	mov    $0x1,%eax
801041ae:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801041b4:	72 e5                	jb     8010419b <wait+0x4b>
801041b6:	85 c0                	test   %eax,%eax
801041b8:	74 7e                	je     80104238 <wait+0xe8>
801041ba:	8b 46 24             	mov    0x24(%esi),%eax
801041bd:	85 c0                	test   %eax,%eax
801041bf:	75 77                	jne    80104238 <wait+0xe8>
801041c1:	83 ec 08             	sub    $0x8,%esp
801041c4:	68 20 3d 11 80       	push   $0x80113d20
801041c9:	56                   	push   %esi
801041ca:	e8 c1 fe ff ff       	call   80104090 <sleep>
801041cf:	83 c4 10             	add    $0x10,%esp
801041d2:	eb aa                	jmp    8010417e <wait+0x2e>
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	ff 73 08             	pushl  0x8(%ebx)
801041de:	8b 73 10             	mov    0x10(%ebx),%esi
801041e1:	e8 2a e4 ff ff       	call   80102610 <kfree>
801041e6:	8b 7b 04             	mov    0x4(%ebx),%edi
801041e9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801041f7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
801041fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80104205:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
8010420c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80104210:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80104217:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010421e:	e8 ed 04 00 00       	call   80104710 <release>
80104223:	89 3c 24             	mov    %edi,(%esp)
80104226:	e8 05 30 00 00       	call   80107230 <freevm>
8010422b:	83 c4 10             	add    $0x10,%esp
8010422e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104231:	89 f0                	mov    %esi,%eax
80104233:	5b                   	pop    %ebx
80104234:	5e                   	pop    %esi
80104235:	5f                   	pop    %edi
80104236:	5d                   	pop    %ebp
80104237:	c3                   	ret    
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104240:	68 20 3d 11 80       	push   $0x80113d20
80104245:	e8 c6 04 00 00       	call   80104710 <release>
8010424a:	83 c4 10             	add    $0x10,%esp
8010424d:	eb df                	jmp    8010422e <wait+0xde>
8010424f:	90                   	nop

80104250 <wakeup>:
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010425a:	68 20 3d 11 80       	push   $0x80113d20
8010425f:	e8 8c 03 00 00       	call   801045f0 <acquire>
80104264:	83 c4 10             	add    $0x10,%esp
80104267:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010426c:	eb 0c                	jmp    8010427a <wakeup+0x2a>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	83 c0 7c             	add    $0x7c,%eax
80104273:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104278:	73 1c                	jae    80104296 <wakeup+0x46>
8010427a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010427e:	75 f0                	jne    80104270 <wakeup+0x20>
80104280:	3b 58 20             	cmp    0x20(%eax),%ebx
80104283:	75 eb                	jne    80104270 <wakeup+0x20>
80104285:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010428c:	83 c0 7c             	add    $0x7c,%eax
8010428f:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104294:	72 e4                	jb     8010427a <wakeup+0x2a>
80104296:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
8010429d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a0:	c9                   	leave  
801042a1:	e9 6a 04 00 00       	jmp    80104710 <release>
801042a6:	8d 76 00             	lea    0x0(%esi),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <kill>:
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 10             	sub    $0x10,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042ba:	68 20 3d 11 80       	push   $0x80113d20
801042bf:	e8 2c 03 00 00       	call   801045f0 <acquire>
801042c4:	83 c4 10             	add    $0x10,%esp
801042c7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042cc:	eb 0c                	jmp    801042da <kill+0x2a>
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	83 c0 7c             	add    $0x7c,%eax
801042d3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801042d8:	73 36                	jae    80104310 <kill+0x60>
801042da:	39 58 10             	cmp    %ebx,0x10(%eax)
801042dd:	75 f1                	jne    801042d0 <kill+0x20>
801042df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801042ea:	75 07                	jne    801042f3 <kill+0x43>
801042ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 20 3d 11 80       	push   $0x80113d20
801042fb:	e8 10 04 00 00       	call   80104710 <release>
80104300:	83 c4 10             	add    $0x10,%esp
80104303:	31 c0                	xor    %eax,%eax
80104305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104308:	c9                   	leave  
80104309:	c3                   	ret    
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 20 3d 11 80       	push   $0x80113d20
80104318:	e8 f3 03 00 00       	call   80104710 <release>
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104328:	c9                   	leave  
80104329:	c3                   	ret    
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <procdump>:
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104339:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010433e:	83 ec 3c             	sub    $0x3c,%esp
80104341:	eb 24                	jmp    80104367 <procdump+0x37>
80104343:	90                   	nop
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	68 a4 7f 10 80       	push   $0x80107fa4
80104350:	e8 1b c4 ff ff       	call   80100770 <cprintf>
80104355:	83 c4 10             	add    $0x10,%esp
80104358:	83 c3 7c             	add    $0x7c,%ebx
8010435b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104361:	0f 83 81 00 00 00    	jae    801043e8 <procdump+0xb8>
80104367:	8b 43 0c             	mov    0xc(%ebx),%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	74 ea                	je     80104358 <procdump+0x28>
8010436e:	83 f8 05             	cmp    $0x5,%eax
80104371:	ba e0 7b 10 80       	mov    $0x80107be0,%edx
80104376:	77 11                	ja     80104389 <procdump+0x59>
80104378:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
8010437f:	b8 e0 7b 10 80       	mov    $0x80107be0,%eax
80104384:	85 d2                	test   %edx,%edx
80104386:	0f 44 d0             	cmove  %eax,%edx
80104389:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010438c:	50                   	push   %eax
8010438d:	52                   	push   %edx
8010438e:	ff 73 10             	pushl  0x10(%ebx)
80104391:	68 e4 7b 10 80       	push   $0x80107be4
80104396:	e8 d5 c3 ff ff       	call   80100770 <cprintf>
8010439b:	83 c4 10             	add    $0x10,%esp
8010439e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801043a2:	75 a4                	jne    80104348 <procdump+0x18>
801043a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043a7:	83 ec 08             	sub    $0x8,%esp
801043aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043ad:	50                   	push   %eax
801043ae:	8b 43 1c             	mov    0x1c(%ebx),%eax
801043b1:	8b 40 0c             	mov    0xc(%eax),%eax
801043b4:	83 c0 08             	add    $0x8,%eax
801043b7:	50                   	push   %eax
801043b8:	e8 63 01 00 00       	call   80104520 <getcallerpcs>
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	8b 17                	mov    (%edi),%edx
801043c2:	85 d2                	test   %edx,%edx
801043c4:	74 82                	je     80104348 <procdump+0x18>
801043c6:	83 ec 08             	sub    $0x8,%esp
801043c9:	83 c7 04             	add    $0x4,%edi
801043cc:	52                   	push   %edx
801043cd:	68 e1 75 10 80       	push   $0x801075e1
801043d2:	e8 99 c3 ff ff       	call   80100770 <cprintf>
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	39 fe                	cmp    %edi,%esi
801043dc:	75 e2                	jne    801043c0 <procdump+0x90>
801043de:	e9 65 ff ff ff       	jmp    80104348 <procdump+0x18>
801043e3:	90                   	nop
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043eb:	5b                   	pop    %ebx
801043ec:	5e                   	pop    %esi
801043ed:	5f                   	pop    %edi
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <initsleeplock>:
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 0c             	sub    $0xc,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043fa:	68 58 7c 10 80       	push   $0x80107c58
801043ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104402:	50                   	push   %eax
80104403:	e8 f8 00 00 00       	call   80104500 <initlock>
80104408:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104411:	83 c4 10             	add    $0x10,%esp
80104414:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
8010441b:	89 43 38             	mov    %eax,0x38(%ebx)
8010441e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104421:	c9                   	leave  
80104422:	c3                   	ret    
80104423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104430 <acquiresleep>:
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	8d 73 04             	lea    0x4(%ebx),%esi
8010443e:	56                   	push   %esi
8010443f:	e8 ac 01 00 00       	call   801045f0 <acquire>
80104444:	8b 13                	mov    (%ebx),%edx
80104446:	83 c4 10             	add    $0x10,%esp
80104449:	85 d2                	test   %edx,%edx
8010444b:	74 16                	je     80104463 <acquiresleep+0x33>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
80104450:	83 ec 08             	sub    $0x8,%esp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	e8 36 fc ff ff       	call   80104090 <sleep>
8010445a:	8b 03                	mov    (%ebx),%eax
8010445c:	83 c4 10             	add    $0x10,%esp
8010445f:	85 c0                	test   %eax,%eax
80104461:	75 ed                	jne    80104450 <acquiresleep+0x20>
80104463:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80104469:	e8 b2 f6 ff ff       	call   80103b20 <myproc>
8010446e:	8b 40 10             	mov    0x10(%eax),%eax
80104471:	89 43 3c             	mov    %eax,0x3c(%ebx)
80104474:	89 75 08             	mov    %esi,0x8(%ebp)
80104477:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010447a:	5b                   	pop    %ebx
8010447b:	5e                   	pop    %esi
8010447c:	5d                   	pop    %ebp
8010447d:	e9 8e 02 00 00       	jmp    80104710 <release>
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <releasesleep>:
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	8d 73 04             	lea    0x4(%ebx),%esi
8010449e:	56                   	push   %esi
8010449f:	e8 4c 01 00 00       	call   801045f0 <acquire>
801044a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801044aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
801044b1:	89 1c 24             	mov    %ebx,(%esp)
801044b4:	e8 97 fd ff ff       	call   80104250 <wakeup>
801044b9:	89 75 08             	mov    %esi,0x8(%ebp)
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c2:	5b                   	pop    %ebx
801044c3:	5e                   	pop    %esi
801044c4:	5d                   	pop    %ebp
801044c5:	e9 46 02 00 00       	jmp    80104710 <release>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <holdingsleep>:
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	8b 75 08             	mov    0x8(%ebp),%esi
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	8d 5e 04             	lea    0x4(%esi),%ebx
801044de:	53                   	push   %ebx
801044df:	e8 0c 01 00 00       	call   801045f0 <acquire>
801044e4:	8b 36                	mov    (%esi),%esi
801044e6:	89 1c 24             	mov    %ebx,(%esp)
801044e9:	e8 22 02 00 00       	call   80104710 <release>
801044ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044f1:	89 f0                	mov    %esi,%eax
801044f3:	5b                   	pop    %ebx
801044f4:	5e                   	pop    %esi
801044f5:	5d                   	pop    %ebp
801044f6:	c3                   	ret    
801044f7:	66 90                	xchg   %ax,%ax
801044f9:	66 90                	xchg   %ax,%ax
801044fb:	66 90                	xchg   %ax,%ax
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
80104506:	8b 55 0c             	mov    0xc(%ebp),%edx
80104509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
80104512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <getcallerpcs>:
80104520:	55                   	push   %ebp
80104521:	31 d2                	xor    %edx,%edx
80104523:	89 e5                	mov    %esp,%ebp
80104525:	53                   	push   %ebx
80104526:	8b 45 08             	mov    0x8(%ebp),%eax
80104529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010452c:	83 e8 08             	sub    $0x8,%eax
8010452f:	90                   	nop
80104530:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104536:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010453c:	77 1a                	ja     80104558 <getcallerpcs+0x38>
8010453e:	8b 58 04             	mov    0x4(%eax),%ebx
80104541:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
80104544:	83 c2 01             	add    $0x1,%edx
80104547:	8b 00                	mov    (%eax),%eax
80104549:	83 fa 0a             	cmp    $0xa,%edx
8010454c:	75 e2                	jne    80104530 <getcallerpcs+0x10>
8010454e:	5b                   	pop    %ebx
8010454f:	5d                   	pop    %ebp
80104550:	c3                   	ret    
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104558:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010455b:	83 c1 28             	add    $0x28,%ecx
8010455e:	66 90                	xchg   %ax,%ax
80104560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104566:	83 c0 04             	add    $0x4,%eax
80104569:	39 c1                	cmp    %eax,%ecx
8010456b:	75 f3                	jne    80104560 <getcallerpcs+0x40>
8010456d:	5b                   	pop    %ebx
8010456e:	5d                   	pop    %ebp
8010456f:	c3                   	ret    

80104570 <holding>:
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 04             	sub    $0x4,%esp
80104577:	8b 55 08             	mov    0x8(%ebp),%edx
8010457a:	8b 02                	mov    (%edx),%eax
8010457c:	85 c0                	test   %eax,%eax
8010457e:	75 10                	jne    80104590 <holding+0x20>
80104580:	83 c4 04             	add    $0x4,%esp
80104583:	31 c0                	xor    %eax,%eax
80104585:	5b                   	pop    %ebx
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104590:	8b 5a 08             	mov    0x8(%edx),%ebx
80104593:	e8 e8 f4 ff ff       	call   80103a80 <mycpu>
80104598:	39 c3                	cmp    %eax,%ebx
8010459a:	0f 94 c0             	sete   %al
8010459d:	83 c4 04             	add    $0x4,%esp
801045a0:	0f b6 c0             	movzbl %al,%eax
801045a3:	5b                   	pop    %ebx
801045a4:	5d                   	pop    %ebp
801045a5:	c3                   	ret    
801045a6:	8d 76 00             	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <pushcli>:
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 04             	sub    $0x4,%esp
801045b7:	9c                   	pushf  
801045b8:	5b                   	pop    %ebx
801045b9:	fa                   	cli    
801045ba:	e8 c1 f4 ff ff       	call   80103a80 <mycpu>
801045bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045c5:	85 c0                	test   %eax,%eax
801045c7:	75 11                	jne    801045da <pushcli+0x2a>
801045c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045cf:	e8 ac f4 ff ff       	call   80103a80 <mycpu>
801045d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045da:	e8 a1 f4 ff ff       	call   80103a80 <mycpu>
801045df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
801045e6:	83 c4 04             	add    $0x4,%esp
801045e9:	5b                   	pop    %ebx
801045ea:	5d                   	pop    %ebp
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <acquire>:
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	e8 b6 ff ff ff       	call   801045b0 <pushcli>
801045fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045fd:	8b 03                	mov    (%ebx),%eax
801045ff:	85 c0                	test   %eax,%eax
80104601:	0f 85 81 00 00 00    	jne    80104688 <acquire+0x98>
80104607:	ba 01 00 00 00       	mov    $0x1,%edx
8010460c:	eb 05                	jmp    80104613 <acquire+0x23>
8010460e:	66 90                	xchg   %ax,%ax
80104610:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104613:	89 d0                	mov    %edx,%eax
80104615:	f0 87 03             	lock xchg %eax,(%ebx)
80104618:	85 c0                	test   %eax,%eax
8010461a:	75 f4                	jne    80104610 <acquire+0x20>
8010461c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104621:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104624:	e8 57 f4 ff ff       	call   80103a80 <mycpu>
80104629:	31 d2                	xor    %edx,%edx
8010462b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
8010462e:	89 43 08             	mov    %eax,0x8(%ebx)
80104631:	89 e8                	mov    %ebp,%eax
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104638:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010463e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104644:	77 1a                	ja     80104660 <acquire+0x70>
80104646:	8b 58 04             	mov    0x4(%eax),%ebx
80104649:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
8010464c:	83 c2 01             	add    $0x1,%edx
8010464f:	8b 00                	mov    (%eax),%eax
80104651:	83 fa 0a             	cmp    $0xa,%edx
80104654:	75 e2                	jne    80104638 <acquire+0x48>
80104656:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104659:	5b                   	pop    %ebx
8010465a:	5e                   	pop    %esi
8010465b:	5d                   	pop    %ebp
8010465c:	c3                   	ret    
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
80104660:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104663:	83 c1 28             	add    $0x28,%ecx
80104666:	8d 76 00             	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104676:	83 c0 04             	add    $0x4,%eax
80104679:	39 c8                	cmp    %ecx,%eax
8010467b:	75 f3                	jne    80104670 <acquire+0x80>
8010467d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104680:	5b                   	pop    %ebx
80104681:	5e                   	pop    %esi
80104682:	5d                   	pop    %ebp
80104683:	c3                   	ret    
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104688:	8b 73 08             	mov    0x8(%ebx),%esi
8010468b:	e8 f0 f3 ff ff       	call   80103a80 <mycpu>
80104690:	39 c6                	cmp    %eax,%esi
80104692:	0f 85 6f ff ff ff    	jne    80104607 <acquire+0x17>
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 63 7c 10 80       	push   $0x80107c63
801046a0:	e8 fb bd ff ff       	call   801004a0 <panic>
801046a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <popcli>:
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	83 ec 08             	sub    $0x8,%esp
801046b6:	9c                   	pushf  
801046b7:	58                   	pop    %eax
801046b8:	f6 c4 02             	test   $0x2,%ah
801046bb:	75 35                	jne    801046f2 <popcli+0x42>
801046bd:	e8 be f3 ff ff       	call   80103a80 <mycpu>
801046c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046c9:	78 34                	js     801046ff <popcli+0x4f>
801046cb:	e8 b0 f3 ff ff       	call   80103a80 <mycpu>
801046d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046d6:	85 d2                	test   %edx,%edx
801046d8:	74 06                	je     801046e0 <popcli+0x30>
801046da:	c9                   	leave  
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e0:	e8 9b f3 ff ff       	call   80103a80 <mycpu>
801046e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046eb:	85 c0                	test   %eax,%eax
801046ed:	74 eb                	je     801046da <popcli+0x2a>
801046ef:	fb                   	sti    
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	83 ec 0c             	sub    $0xc,%esp
801046f5:	68 6b 7c 10 80       	push   $0x80107c6b
801046fa:	e8 a1 bd ff ff       	call   801004a0 <panic>
801046ff:	83 ec 0c             	sub    $0xc,%esp
80104702:	68 82 7c 10 80       	push   $0x80107c82
80104707:	e8 94 bd ff ff       	call   801004a0 <panic>
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <release>:
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104718:	8b 03                	mov    (%ebx),%eax
8010471a:	85 c0                	test   %eax,%eax
8010471c:	74 0c                	je     8010472a <release+0x1a>
8010471e:	8b 73 08             	mov    0x8(%ebx),%esi
80104721:	e8 5a f3 ff ff       	call   80103a80 <mycpu>
80104726:	39 c6                	cmp    %eax,%esi
80104728:	74 16                	je     80104740 <release+0x30>
8010472a:	83 ec 0c             	sub    $0xc,%esp
8010472d:	68 89 7c 10 80       	push   $0x80107c89
80104732:	e8 69 bd ff ff       	call   801004a0 <panic>
80104737:	89 f6                	mov    %esi,%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104740:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104747:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
8010474e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104753:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010475c:	5b                   	pop    %ebx
8010475d:	5e                   	pop    %esi
8010475e:	5d                   	pop    %ebp
8010475f:	e9 4c ff ff ff       	jmp    801046b0 <popcli>
80104764:	66 90                	xchg   %ax,%ax
80104766:	66 90                	xchg   %ax,%ax
80104768:	66 90                	xchg   %ax,%ax
8010476a:	66 90                	xchg   %ax,%ax
8010476c:	66 90                	xchg   %ax,%ax
8010476e:	66 90                	xchg   %ax,%ax

80104770 <memset>:
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	53                   	push   %ebx
80104775:	8b 55 08             	mov    0x8(%ebp),%edx
80104778:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010477b:	f6 c2 03             	test   $0x3,%dl
8010477e:	75 05                	jne    80104785 <memset+0x15>
80104780:	f6 c1 03             	test   $0x3,%cl
80104783:	74 13                	je     80104798 <memset+0x28>
80104785:	89 d7                	mov    %edx,%edi
80104787:	8b 45 0c             	mov    0xc(%ebp),%eax
8010478a:	fc                   	cld    
8010478b:	f3 aa                	rep stos %al,%es:(%edi)
8010478d:	5b                   	pop    %ebx
8010478e:	89 d0                	mov    %edx,%eax
80104790:	5f                   	pop    %edi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	90                   	nop
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104798:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
8010479c:	c1 e9 02             	shr    $0x2,%ecx
8010479f:	89 f8                	mov    %edi,%eax
801047a1:	89 fb                	mov    %edi,%ebx
801047a3:	c1 e0 18             	shl    $0x18,%eax
801047a6:	c1 e3 10             	shl    $0x10,%ebx
801047a9:	09 d8                	or     %ebx,%eax
801047ab:	09 f8                	or     %edi,%eax
801047ad:	c1 e7 08             	shl    $0x8,%edi
801047b0:	09 f8                	or     %edi,%eax
801047b2:	89 d7                	mov    %edx,%edi
801047b4:	fc                   	cld    
801047b5:	f3 ab                	rep stos %eax,%es:(%edi)
801047b7:	5b                   	pop    %ebx
801047b8:	89 d0                	mov    %edx,%eax
801047ba:	5f                   	pop    %edi
801047bb:	5d                   	pop    %ebp
801047bc:	c3                   	ret    
801047bd:	8d 76 00             	lea    0x0(%esi),%esi

801047c0 <memcmp>:
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801047c9:	8b 75 08             	mov    0x8(%ebp),%esi
801047cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801047cf:	85 db                	test   %ebx,%ebx
801047d1:	74 29                	je     801047fc <memcmp+0x3c>
801047d3:	0f b6 16             	movzbl (%esi),%edx
801047d6:	0f b6 0f             	movzbl (%edi),%ecx
801047d9:	38 d1                	cmp    %dl,%cl
801047db:	75 2b                	jne    80104808 <memcmp+0x48>
801047dd:	b8 01 00 00 00       	mov    $0x1,%eax
801047e2:	eb 14                	jmp    801047f8 <memcmp+0x38>
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801047ec:	83 c0 01             	add    $0x1,%eax
801047ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047f4:	38 ca                	cmp    %cl,%dl
801047f6:	75 10                	jne    80104808 <memcmp+0x48>
801047f8:	39 d8                	cmp    %ebx,%eax
801047fa:	75 ec                	jne    801047e8 <memcmp+0x28>
801047fc:	5b                   	pop    %ebx
801047fd:	31 c0                	xor    %eax,%eax
801047ff:	5e                   	pop    %esi
80104800:	5f                   	pop    %edi
80104801:	5d                   	pop    %ebp
80104802:	c3                   	ret    
80104803:	90                   	nop
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104808:	0f b6 c2             	movzbl %dl,%eax
8010480b:	5b                   	pop    %ebx
8010480c:	29 c8                	sub    %ecx,%eax
8010480e:	5e                   	pop    %esi
8010480f:	5f                   	pop    %edi
80104810:	5d                   	pop    %ebp
80104811:	c3                   	ret    
80104812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <memmove>:
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 45 08             	mov    0x8(%ebp),%eax
80104828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010482b:	8b 75 10             	mov    0x10(%ebp),%esi
8010482e:	39 c3                	cmp    %eax,%ebx
80104830:	73 26                	jae    80104858 <memmove+0x38>
80104832:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104835:	39 c8                	cmp    %ecx,%eax
80104837:	73 1f                	jae    80104858 <memmove+0x38>
80104839:	85 f6                	test   %esi,%esi
8010483b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010483e:	74 0f                	je     8010484f <memmove+0x2f>
80104840:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104844:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104847:	83 ea 01             	sub    $0x1,%edx
8010484a:	83 fa ff             	cmp    $0xffffffff,%edx
8010484d:	75 f1                	jne    80104840 <memmove+0x20>
8010484f:	5b                   	pop    %ebx
80104850:	5e                   	pop    %esi
80104851:	5d                   	pop    %ebp
80104852:	c3                   	ret    
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104858:	31 d2                	xor    %edx,%edx
8010485a:	85 f6                	test   %esi,%esi
8010485c:	74 f1                	je     8010484f <memmove+0x2f>
8010485e:	66 90                	xchg   %ax,%ax
80104860:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104864:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104867:	83 c2 01             	add    $0x1,%edx
8010486a:	39 d6                	cmp    %edx,%esi
8010486c:	75 f2                	jne    80104860 <memmove+0x40>
8010486e:	5b                   	pop    %ebx
8010486f:	5e                   	pop    %esi
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret    
80104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <memcpy>:
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	5d                   	pop    %ebp
80104884:	eb 9a                	jmp    80104820 <memmove>
80104886:	8d 76 00             	lea    0x0(%esi),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <strncmp>:
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	8b 7d 10             	mov    0x10(%ebp),%edi
80104898:	53                   	push   %ebx
80104899:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010489c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010489f:	85 ff                	test   %edi,%edi
801048a1:	74 2f                	je     801048d2 <strncmp+0x42>
801048a3:	0f b6 01             	movzbl (%ecx),%eax
801048a6:	0f b6 1e             	movzbl (%esi),%ebx
801048a9:	84 c0                	test   %al,%al
801048ab:	74 37                	je     801048e4 <strncmp+0x54>
801048ad:	38 c3                	cmp    %al,%bl
801048af:	75 33                	jne    801048e4 <strncmp+0x54>
801048b1:	01 f7                	add    %esi,%edi
801048b3:	eb 13                	jmp    801048c8 <strncmp+0x38>
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
801048b8:	0f b6 01             	movzbl (%ecx),%eax
801048bb:	84 c0                	test   %al,%al
801048bd:	74 21                	je     801048e0 <strncmp+0x50>
801048bf:	0f b6 1a             	movzbl (%edx),%ebx
801048c2:	89 d6                	mov    %edx,%esi
801048c4:	38 d8                	cmp    %bl,%al
801048c6:	75 1c                	jne    801048e4 <strncmp+0x54>
801048c8:	8d 56 01             	lea    0x1(%esi),%edx
801048cb:	83 c1 01             	add    $0x1,%ecx
801048ce:	39 fa                	cmp    %edi,%edx
801048d0:	75 e6                	jne    801048b8 <strncmp+0x28>
801048d2:	5b                   	pop    %ebx
801048d3:	31 c0                	xor    %eax,%eax
801048d5:	5e                   	pop    %esi
801048d6:	5f                   	pop    %edi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
801048e4:	29 d8                	sub    %ebx,%eax
801048e6:	5b                   	pop    %ebx
801048e7:	5e                   	pop    %esi
801048e8:	5f                   	pop    %edi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	90                   	nop
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <strncpy>:
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 45 08             	mov    0x8(%ebp),%eax
801048f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048fe:	89 c2                	mov    %eax,%edx
80104900:	eb 19                	jmp    8010491b <strncpy+0x2b>
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104908:	83 c3 01             	add    $0x1,%ebx
8010490b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010490f:	83 c2 01             	add    $0x1,%edx
80104912:	84 c9                	test   %cl,%cl
80104914:	88 4a ff             	mov    %cl,-0x1(%edx)
80104917:	74 09                	je     80104922 <strncpy+0x32>
80104919:	89 f1                	mov    %esi,%ecx
8010491b:	85 c9                	test   %ecx,%ecx
8010491d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104920:	7f e6                	jg     80104908 <strncpy+0x18>
80104922:	31 c9                	xor    %ecx,%ecx
80104924:	85 f6                	test   %esi,%esi
80104926:	7e 17                	jle    8010493f <strncpy+0x4f>
80104928:	90                   	nop
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104930:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104934:	89 f3                	mov    %esi,%ebx
80104936:	83 c1 01             	add    $0x1,%ecx
80104939:	29 cb                	sub    %ecx,%ebx
8010493b:	85 db                	test   %ebx,%ebx
8010493d:	7f f1                	jg     80104930 <strncpy+0x40>
8010493f:	5b                   	pop    %ebx
80104940:	5e                   	pop    %esi
80104941:	5d                   	pop    %ebp
80104942:	c3                   	ret    
80104943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <safestrcpy>:
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104958:	8b 45 08             	mov    0x8(%ebp),%eax
8010495b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495e:	85 c9                	test   %ecx,%ecx
80104960:	7e 26                	jle    80104988 <safestrcpy+0x38>
80104962:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104966:	89 c1                	mov    %eax,%ecx
80104968:	eb 17                	jmp    80104981 <safestrcpy+0x31>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104970:	83 c2 01             	add    $0x1,%edx
80104973:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104977:	83 c1 01             	add    $0x1,%ecx
8010497a:	84 db                	test   %bl,%bl
8010497c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010497f:	74 04                	je     80104985 <safestrcpy+0x35>
80104981:	39 f2                	cmp    %esi,%edx
80104983:	75 eb                	jne    80104970 <safestrcpy+0x20>
80104985:	c6 01 00             	movb   $0x0,(%ecx)
80104988:	5b                   	pop    %ebx
80104989:	5e                   	pop    %esi
8010498a:	5d                   	pop    %ebp
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <strlen>:
80104990:	55                   	push   %ebp
80104991:	31 c0                	xor    %eax,%eax
80104993:	89 e5                	mov    %esp,%ebp
80104995:	8b 55 08             	mov    0x8(%ebp),%edx
80104998:	80 3a 00             	cmpb   $0x0,(%edx)
8010499b:	74 0c                	je     801049a9 <strlen+0x19>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	83 c0 01             	add    $0x1,%eax
801049a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049a7:	75 f7                	jne    801049a0 <strlen+0x10>
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    

801049ab <swtch>:
801049ab:	8b 44 24 04          	mov    0x4(%esp),%eax
801049af:	8b 54 24 08          	mov    0x8(%esp),%edx
801049b3:	55                   	push   %ebp
801049b4:	53                   	push   %ebx
801049b5:	56                   	push   %esi
801049b6:	57                   	push   %edi
801049b7:	89 20                	mov    %esp,(%eax)
801049b9:	89 d4                	mov    %edx,%esp
801049bb:	5f                   	pop    %edi
801049bc:	5e                   	pop    %esi
801049bd:	5b                   	pop    %ebx
801049be:	5d                   	pop    %ebp
801049bf:	c3                   	ret    

801049c0 <fetchint>:
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ca:	e8 51 f1 ff ff       	call   80103b20 <myproc>
801049cf:	8b 00                	mov    (%eax),%eax
801049d1:	39 d8                	cmp    %ebx,%eax
801049d3:	76 1b                	jbe    801049f0 <fetchint+0x30>
801049d5:	8d 53 04             	lea    0x4(%ebx),%edx
801049d8:	39 d0                	cmp    %edx,%eax
801049da:	72 14                	jb     801049f0 <fetchint+0x30>
801049dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049df:	8b 13                	mov    (%ebx),%edx
801049e1:	89 10                	mov    %edx,(%eax)
801049e3:	31 c0                	xor    %eax,%eax
801049e5:	83 c4 04             	add    $0x4,%esp
801049e8:	5b                   	pop    %ebx
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f5:	eb ee                	jmp    801049e5 <fetchint+0x25>
801049f7:	89 f6                	mov    %esi,%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a00 <fetchstr>:
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
80104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a0a:	e8 11 f1 ff ff       	call   80103b20 <myproc>
80104a0f:	39 18                	cmp    %ebx,(%eax)
80104a11:	76 29                	jbe    80104a3c <fetchstr+0x3c>
80104a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a16:	89 da                	mov    %ebx,%edx
80104a18:	89 19                	mov    %ebx,(%ecx)
80104a1a:	8b 00                	mov    (%eax),%eax
80104a1c:	39 c3                	cmp    %eax,%ebx
80104a1e:	73 1c                	jae    80104a3c <fetchstr+0x3c>
80104a20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a23:	75 10                	jne    80104a35 <fetchstr+0x35>
80104a25:	eb 39                	jmp    80104a60 <fetchstr+0x60>
80104a27:	89 f6                	mov    %esi,%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a30:	80 3a 00             	cmpb   $0x0,(%edx)
80104a33:	74 1b                	je     80104a50 <fetchstr+0x50>
80104a35:	83 c2 01             	add    $0x1,%edx
80104a38:	39 d0                	cmp    %edx,%eax
80104a3a:	77 f4                	ja     80104a30 <fetchstr+0x30>
80104a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a41:	83 c4 04             	add    $0x4,%esp
80104a44:	5b                   	pop    %ebx
80104a45:	5d                   	pop    %ebp
80104a46:	c3                   	ret    
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a50:	83 c4 04             	add    $0x4,%esp
80104a53:	89 d0                	mov    %edx,%eax
80104a55:	29 d8                	sub    %ebx,%eax
80104a57:	5b                   	pop    %ebx
80104a58:	5d                   	pop    %ebp
80104a59:	c3                   	ret    
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a60:	31 c0                	xor    %eax,%eax
80104a62:	eb dd                	jmp    80104a41 <fetchstr+0x41>
80104a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a70 <argint>:
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	e8 a6 f0 ff ff       	call   80103b20 <myproc>
80104a7a:	8b 40 18             	mov    0x18(%eax),%eax
80104a7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a80:	8b 40 44             	mov    0x44(%eax),%eax
80104a83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104a86:	e8 95 f0 ff ff       	call   80103b20 <myproc>
80104a8b:	8b 00                	mov    (%eax),%eax
80104a8d:	8d 73 04             	lea    0x4(%ebx),%esi
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	73 1c                	jae    80104ab0 <argint+0x40>
80104a94:	8d 53 08             	lea    0x8(%ebx),%edx
80104a97:	39 d0                	cmp    %edx,%eax
80104a99:	72 15                	jb     80104ab0 <argint+0x40>
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
80104aa3:	31 c0                	xor    %eax,%eax
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab5:	eb ee                	jmp    80104aa5 <argint+0x35>
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argptr>:
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	83 ec 10             	sub    $0x10,%esp
80104ac8:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104acb:	e8 50 f0 ff ff       	call   80103b20 <myproc>
80104ad0:	89 c6                	mov    %eax,%esi
80104ad2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ad5:	83 ec 08             	sub    $0x8,%esp
80104ad8:	50                   	push   %eax
80104ad9:	ff 75 08             	pushl  0x8(%ebp)
80104adc:	e8 8f ff ff ff       	call   80104a70 <argint>
80104ae1:	83 c4 10             	add    $0x10,%esp
80104ae4:	85 c0                	test   %eax,%eax
80104ae6:	78 28                	js     80104b10 <argptr+0x50>
80104ae8:	85 db                	test   %ebx,%ebx
80104aea:	78 24                	js     80104b10 <argptr+0x50>
80104aec:	8b 16                	mov    (%esi),%edx
80104aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af1:	39 c2                	cmp    %eax,%edx
80104af3:	76 1b                	jbe    80104b10 <argptr+0x50>
80104af5:	01 c3                	add    %eax,%ebx
80104af7:	39 da                	cmp    %ebx,%edx
80104af9:	72 15                	jb     80104b10 <argptr+0x50>
80104afb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104afe:	89 02                	mov    %eax,(%edx)
80104b00:	31 c0                	xor    %eax,%eax
80104b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret    
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb eb                	jmp    80104b02 <argptr+0x42>
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <argstr>:
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 20             	sub    $0x20,%esp
80104b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b29:	50                   	push   %eax
80104b2a:	ff 75 08             	pushl  0x8(%ebp)
80104b2d:	e8 3e ff ff ff       	call   80104a70 <argint>
80104b32:	83 c4 10             	add    $0x10,%esp
80104b35:	85 c0                	test   %eax,%eax
80104b37:	78 17                	js     80104b50 <argstr+0x30>
80104b39:	83 ec 08             	sub    $0x8,%esp
80104b3c:	ff 75 0c             	pushl  0xc(%ebp)
80104b3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b42:	e8 b9 fe ff ff       	call   80104a00 <fetchstr>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	c9                   	leave  
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <syscall>:
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
80104b67:	e8 b4 ef ff ff       	call   80103b20 <myproc>
80104b6c:	89 c3                	mov    %eax,%ebx
80104b6e:	8b 40 18             	mov    0x18(%eax),%eax
80104b71:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b77:	83 fa 16             	cmp    $0x16,%edx
80104b7a:	77 1c                	ja     80104b98 <syscall+0x38>
80104b7c:	8b 14 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%edx
80104b83:	85 d2                	test   %edx,%edx
80104b85:	74 11                	je     80104b98 <syscall+0x38>
80104b87:	ff d2                	call   *%edx
80104b89:	8b 53 18             	mov    0x18(%ebx),%edx
80104b8c:	89 42 1c             	mov    %eax,0x1c(%edx)
80104b8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b92:	c9                   	leave  
80104b93:	c3                   	ret    
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b98:	50                   	push   %eax
80104b99:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b9c:	50                   	push   %eax
80104b9d:	ff 73 10             	pushl  0x10(%ebx)
80104ba0:	68 91 7c 10 80       	push   $0x80107c91
80104ba5:	e8 c6 bb ff ff       	call   80100770 <cprintf>
80104baa:	8b 43 18             	mov    0x18(%ebx),%eax
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bba:	c9                   	leave  
80104bbb:	c3                   	ret    
80104bbc:	66 90                	xchg   %ax,%ax
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bc6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104bc9:	83 ec 44             	sub    $0x44,%esp
80104bcc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104bd2:	53                   	push   %ebx
80104bd3:	50                   	push   %eax
{
80104bd4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104bd7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bda:	e8 31 d6 ff ff       	call   80102210 <nameiparent>
80104bdf:	83 c4 10             	add    $0x10,%esp
80104be2:	85 c0                	test   %eax,%eax
80104be4:	0f 84 46 01 00 00    	je     80104d30 <create+0x170>
    return 0;
  ilock(dp);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	89 c6                	mov    %eax,%esi
80104bef:	50                   	push   %eax
80104bf0:	e8 5b cd ff ff       	call   80101950 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104bf5:	83 c4 0c             	add    $0xc,%esp
80104bf8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bfb:	50                   	push   %eax
80104bfc:	53                   	push   %ebx
80104bfd:	56                   	push   %esi
80104bfe:	e8 7d d2 ff ff       	call   80101e80 <dirlookup>
80104c03:	83 c4 10             	add    $0x10,%esp
80104c06:	89 c7                	mov    %eax,%edi
80104c08:	85 c0                	test   %eax,%eax
80104c0a:	74 54                	je     80104c60 <create+0xa0>
    iunlockput(dp);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	56                   	push   %esi
80104c10:	e8 cb cf ff ff       	call   80101be0 <iunlockput>
    ilock(ip);
80104c15:	89 3c 24             	mov    %edi,(%esp)
80104c18:	e8 33 cd ff ff       	call   80101950 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c25:	75 19                	jne    80104c40 <create+0x80>
80104c27:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c2c:	75 12                	jne    80104c40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c31:	89 f8                	mov    %edi,%eax
80104c33:	5b                   	pop    %ebx
80104c34:	5e                   	pop    %esi
80104c35:	5f                   	pop    %edi
80104c36:	5d                   	pop    %ebp
80104c37:	c3                   	ret    
80104c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
    iunlockput(ip);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	57                   	push   %edi
    return 0;
80104c44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c46:	e8 95 cf ff ff       	call   80101be0 <iunlockput>
    return 0;
80104c4b:	83 c4 10             	add    $0x10,%esp
}
80104c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c51:	89 f8                	mov    %edi,%eax
80104c53:	5b                   	pop    %ebx
80104c54:	5e                   	pop    %esi
80104c55:	5f                   	pop    %edi
80104c56:	5d                   	pop    %ebp
80104c57:	c3                   	ret    
80104c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c60:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c64:	83 ec 08             	sub    $0x8,%esp
80104c67:	50                   	push   %eax
80104c68:	ff 36                	pushl  (%esi)
80104c6a:	e8 71 cb ff ff       	call   801017e0 <ialloc>
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	89 c7                	mov    %eax,%edi
80104c74:	85 c0                	test   %eax,%eax
80104c76:	0f 84 cd 00 00 00    	je     80104d49 <create+0x189>
  ilock(ip);
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	50                   	push   %eax
80104c80:	e8 cb cc ff ff       	call   80101950 <ilock>
  ip->major = major;
80104c85:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c89:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c8d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c91:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c95:	b8 01 00 00 00       	mov    $0x1,%eax
80104c9a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c9e:	89 3c 24             	mov    %edi,(%esp)
80104ca1:	e8 fa cb ff ff       	call   801018a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ca6:	83 c4 10             	add    $0x10,%esp
80104ca9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104cae:	74 30                	je     80104ce0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104cb0:	83 ec 04             	sub    $0x4,%esp
80104cb3:	ff 77 04             	pushl  0x4(%edi)
80104cb6:	53                   	push   %ebx
80104cb7:	56                   	push   %esi
80104cb8:	e8 73 d4 ff ff       	call   80102130 <dirlink>
80104cbd:	83 c4 10             	add    $0x10,%esp
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 78                	js     80104d3c <create+0x17c>
  iunlockput(dp);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	56                   	push   %esi
80104cc8:	e8 13 cf ff ff       	call   80101be0 <iunlockput>
  return ip;
80104ccd:	83 c4 10             	add    $0x10,%esp
}
80104cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cd3:	89 f8                	mov    %edi,%eax
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5f                   	pop    %edi
80104cd8:	5d                   	pop    %ebp
80104cd9:	c3                   	ret    
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ce3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104ce8:	56                   	push   %esi
80104ce9:	e8 b2 cb ff ff       	call   801018a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cee:	83 c4 0c             	add    $0xc,%esp
80104cf1:	ff 77 04             	pushl  0x4(%edi)
80104cf4:	68 3c 7d 10 80       	push   $0x80107d3c
80104cf9:	57                   	push   %edi
80104cfa:	e8 31 d4 ff ff       	call   80102130 <dirlink>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	85 c0                	test   %eax,%eax
80104d04:	78 18                	js     80104d1e <create+0x15e>
80104d06:	83 ec 04             	sub    $0x4,%esp
80104d09:	ff 76 04             	pushl  0x4(%esi)
80104d0c:	68 3b 7d 10 80       	push   $0x80107d3b
80104d11:	57                   	push   %edi
80104d12:	e8 19 d4 ff ff       	call   80102130 <dirlink>
80104d17:	83 c4 10             	add    $0x10,%esp
80104d1a:	85 c0                	test   %eax,%eax
80104d1c:	79 92                	jns    80104cb0 <create+0xf0>
      panic("create dots");
80104d1e:	83 ec 0c             	sub    $0xc,%esp
80104d21:	68 2f 7d 10 80       	push   $0x80107d2f
80104d26:	e8 75 b7 ff ff       	call   801004a0 <panic>
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d33:	31 ff                	xor    %edi,%edi
}
80104d35:	5b                   	pop    %ebx
80104d36:	89 f8                	mov    %edi,%eax
80104d38:	5e                   	pop    %esi
80104d39:	5f                   	pop    %edi
80104d3a:	5d                   	pop    %ebp
80104d3b:	c3                   	ret    
    panic("create: dirlink");
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	68 3e 7d 10 80       	push   $0x80107d3e
80104d44:	e8 57 b7 ff ff       	call   801004a0 <panic>
    panic("create: ialloc");
80104d49:	83 ec 0c             	sub    $0xc,%esp
80104d4c:	68 20 7d 10 80       	push   $0x80107d20
80104d51:	e8 4a b7 ff ff       	call   801004a0 <panic>
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	89 d6                	mov    %edx,%esi
80104d66:	53                   	push   %ebx
80104d67:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d6c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d6f:	50                   	push   %eax
80104d70:	6a 00                	push   $0x0
80104d72:	e8 f9 fc ff ff       	call   80104a70 <argint>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	85 c0                	test   %eax,%eax
80104d7c:	78 2a                	js     80104da8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d82:	77 24                	ja     80104da8 <argfd.constprop.0+0x48>
80104d84:	e8 97 ed ff ff       	call   80103b20 <myproc>
80104d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d90:	85 c0                	test   %eax,%eax
80104d92:	74 14                	je     80104da8 <argfd.constprop.0+0x48>
  if(pfd)
80104d94:	85 db                	test   %ebx,%ebx
80104d96:	74 02                	je     80104d9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d98:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d9a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d9c:	31 c0                	xor    %eax,%eax
}
80104d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da1:	5b                   	pop    %ebx
80104da2:	5e                   	pop    %esi
80104da3:	5d                   	pop    %ebp
80104da4:	c3                   	ret    
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dad:	eb ef                	jmp    80104d9e <argfd.constprop.0+0x3e>
80104daf:	90                   	nop

80104db0 <sys_dup>:
{
80104db0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	56                   	push   %esi
80104db6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104db7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dbd:	e8 9e ff ff ff       	call   80104d60 <argfd.constprop.0>
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	78 1a                	js     80104de0 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104dc6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dc9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dcb:	e8 50 ed ff ff       	call   80103b20 <myproc>
    if(curproc->ofile[fd] == 0){
80104dd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104dd4:	85 d2                	test   %edx,%edx
80104dd6:	74 18                	je     80104df0 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104dd8:	83 c3 01             	add    $0x1,%ebx
80104ddb:	83 fb 10             	cmp    $0x10,%ebx
80104dde:	75 f0                	jne    80104dd0 <sys_dup+0x20>
}
80104de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104de3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104de8:	89 d8                	mov    %ebx,%eax
80104dea:	5b                   	pop    %ebx
80104deb:	5e                   	pop    %esi
80104dec:	5d                   	pop    %ebp
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104df0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104df4:	83 ec 0c             	sub    $0xc,%esp
80104df7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfa:	e8 01 c1 ff ff       	call   80100f00 <filedup>
  return fd;
80104dff:	83 c4 10             	add    $0x10,%esp
}
80104e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e05:	89 d8                	mov    %ebx,%eax
80104e07:	5b                   	pop    %ebx
80104e08:	5e                   	pop    %esi
80104e09:	5d                   	pop    %ebp
80104e0a:	c3                   	ret    
80104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop

80104e10 <sys_read>:
{
80104e10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e1b:	e8 40 ff ff ff       	call   80104d60 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 4c                	js     80104e70 <sys_read+0x60>
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e2a:	50                   	push   %eax
80104e2b:	6a 02                	push   $0x2
80104e2d:	e8 3e fc ff ff       	call   80104a70 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 37                	js     80104e70 <sys_read+0x60>
80104e39:	83 ec 04             	sub    $0x4,%esp
80104e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e42:	50                   	push   %eax
80104e43:	6a 01                	push   $0x1
80104e45:	e8 76 fc ff ff       	call   80104ac0 <argptr>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	78 1f                	js     80104e70 <sys_read+0x60>
  return fileread(f, p, n);
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	ff 75 f0             	pushl  -0x10(%ebp)
80104e57:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e5d:	e8 0e c2 ff ff       	call   80101070 <fileread>
80104e62:	83 c4 10             	add    $0x10,%esp
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax
80104e70:	c9                   	leave  
    return -1;
80104e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e76:	c3                   	ret    
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <sys_write>:
{
80104e80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e8b:	e8 d0 fe ff ff       	call   80104d60 <argfd.constprop.0>
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 4c                	js     80104ee0 <sys_write+0x60>
80104e94:	83 ec 08             	sub    $0x8,%esp
80104e97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e9a:	50                   	push   %eax
80104e9b:	6a 02                	push   $0x2
80104e9d:	e8 ce fb ff ff       	call   80104a70 <argint>
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 37                	js     80104ee0 <sys_write+0x60>
80104ea9:	83 ec 04             	sub    $0x4,%esp
80104eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eaf:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb2:	50                   	push   %eax
80104eb3:	6a 01                	push   $0x1
80104eb5:	e8 06 fc ff ff       	call   80104ac0 <argptr>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	85 c0                	test   %eax,%eax
80104ebf:	78 1f                	js     80104ee0 <sys_write+0x60>
  return filewrite(f, p, n);
80104ec1:	83 ec 04             	sub    $0x4,%esp
80104ec4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eca:	ff 75 ec             	pushl  -0x14(%ebp)
80104ecd:	e8 2e c2 ff ff       	call   80101100 <filewrite>
80104ed2:	83 c4 10             	add    $0x10,%esp
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax
80104ee0:	c9                   	leave  
    return -1;
80104ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ee6:	c3                   	ret    
80104ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <sys_close>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104ef6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ef9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104efc:	e8 5f fe ff ff       	call   80104d60 <argfd.constprop.0>
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 2b                	js     80104f30 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f05:	e8 16 ec ff ff       	call   80103b20 <myproc>
80104f0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f0d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f10:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f17:	00 
  fileclose(f);
80104f18:	ff 75 f4             	pushl  -0xc(%ebp)
80104f1b:	e8 30 c0 ff ff       	call   80100f50 <fileclose>
  return 0;
80104f20:	83 c4 10             	add    $0x10,%esp
80104f23:	31 c0                	xor    %eax,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax
80104f30:	c9                   	leave  
    return -1;
80104f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f36:	c3                   	ret    
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <sys_fstat>:
{
80104f40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f4b:	e8 10 fe ff ff       	call   80104d60 <argfd.constprop.0>
80104f50:	85 c0                	test   %eax,%eax
80104f52:	78 2c                	js     80104f80 <sys_fstat+0x40>
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5a:	6a 14                	push   $0x14
80104f5c:	50                   	push   %eax
80104f5d:	6a 01                	push   $0x1
80104f5f:	e8 5c fb ff ff       	call   80104ac0 <argptr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	78 15                	js     80104f80 <sys_fstat+0x40>
  return filestat(f, st);
80104f6b:	83 ec 08             	sub    $0x8,%esp
80104f6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f71:	ff 75 f0             	pushl  -0x10(%ebp)
80104f74:	e8 a7 c0 ff ff       	call   80101020 <filestat>
80104f79:	83 c4 10             	add    $0x10,%esp
}
80104f7c:	c9                   	leave  
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
80104f80:	c9                   	leave  
    return -1;
80104f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f86:	c3                   	ret    
80104f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <sys_link>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f98:	53                   	push   %ebx
80104f99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f9c:	50                   	push   %eax
80104f9d:	6a 00                	push   $0x0
80104f9f:	e8 7c fb ff ff       	call   80104b20 <argstr>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	0f 88 fb 00 00 00    	js     801050aa <sys_link+0x11a>
80104faf:	83 ec 08             	sub    $0x8,%esp
80104fb2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fb5:	50                   	push   %eax
80104fb6:	6a 01                	push   $0x1
80104fb8:	e8 63 fb ff ff       	call   80104b20 <argstr>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	0f 88 e2 00 00 00    	js     801050aa <sys_link+0x11a>
  begin_op();
80104fc8:	e8 03 df ff ff       	call   80102ed0 <begin_op>
  if((ip = namei(old)) == 0){
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fd3:	e8 18 d2 ff ff       	call   801021f0 <namei>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	89 c3                	mov    %eax,%ebx
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	0f 84 e4 00 00 00    	je     801050c9 <sys_link+0x139>
  ilock(ip);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	50                   	push   %eax
80104fe9:	e8 62 c9 ff ff       	call   80101950 <ilock>
  if(ip->type == T_DIR){
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff6:	0f 84 b5 00 00 00    	je     801050b1 <sys_link+0x121>
  iupdate(ip);
80104ffc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104fff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105004:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105007:	53                   	push   %ebx
80105008:	e8 93 c8 ff ff       	call   801018a0 <iupdate>
  iunlock(ip);
8010500d:	89 1c 24             	mov    %ebx,(%esp)
80105010:	e8 1b ca ff ff       	call   80101a30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105015:	58                   	pop    %eax
80105016:	5a                   	pop    %edx
80105017:	57                   	push   %edi
80105018:	ff 75 d0             	pushl  -0x30(%ebp)
8010501b:	e8 f0 d1 ff ff       	call   80102210 <nameiparent>
80105020:	83 c4 10             	add    $0x10,%esp
80105023:	89 c6                	mov    %eax,%esi
80105025:	85 c0                	test   %eax,%eax
80105027:	74 5b                	je     80105084 <sys_link+0xf4>
  ilock(dp);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 1e c9 ff ff       	call   80101950 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	8b 03                	mov    (%ebx),%eax
80105037:	39 06                	cmp    %eax,(%esi)
80105039:	75 3d                	jne    80105078 <sys_link+0xe8>
8010503b:	83 ec 04             	sub    $0x4,%esp
8010503e:	ff 73 04             	pushl  0x4(%ebx)
80105041:	57                   	push   %edi
80105042:	56                   	push   %esi
80105043:	e8 e8 d0 ff ff       	call   80102130 <dirlink>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	78 29                	js     80105078 <sys_link+0xe8>
  iunlockput(dp);
8010504f:	83 ec 0c             	sub    $0xc,%esp
80105052:	56                   	push   %esi
80105053:	e8 88 cb ff ff       	call   80101be0 <iunlockput>
  iput(ip);
80105058:	89 1c 24             	mov    %ebx,(%esp)
8010505b:	e8 20 ca ff ff       	call   80101a80 <iput>
  end_op();
80105060:	e8 db de ff ff       	call   80102f40 <end_op>
  return 0;
80105065:	83 c4 10             	add    $0x10,%esp
80105068:	31 c0                	xor    %eax,%eax
}
8010506a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5f                   	pop    %edi
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    
80105072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	56                   	push   %esi
8010507c:	e8 5f cb ff ff       	call   80101be0 <iunlockput>
    goto bad;
80105081:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	53                   	push   %ebx
80105088:	e8 c3 c8 ff ff       	call   80101950 <ilock>
  ip->nlink--;
8010508d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105092:	89 1c 24             	mov    %ebx,(%esp)
80105095:	e8 06 c8 ff ff       	call   801018a0 <iupdate>
  iunlockput(ip);
8010509a:	89 1c 24             	mov    %ebx,(%esp)
8010509d:	e8 3e cb ff ff       	call   80101be0 <iunlockput>
  end_op();
801050a2:	e8 99 de ff ff       	call   80102f40 <end_op>
  return -1;
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050af:	eb b9                	jmp    8010506a <sys_link+0xda>
    iunlockput(ip);
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	53                   	push   %ebx
801050b5:	e8 26 cb ff ff       	call   80101be0 <iunlockput>
    end_op();
801050ba:	e8 81 de ff ff       	call   80102f40 <end_op>
    return -1;
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c7:	eb a1                	jmp    8010506a <sys_link+0xda>
    end_op();
801050c9:	e8 72 de ff ff       	call   80102f40 <end_op>
    return -1;
801050ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d3:	eb 95                	jmp    8010506a <sys_link+0xda>
801050d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_unlink>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050e8:	53                   	push   %ebx
801050e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 2c fa ff ff       	call   80104b20 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 91 01 00 00    	js     80105290 <sys_unlink+0x1b0>
  begin_op();
801050ff:	e8 cc dd ff ff       	call   80102ed0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105104:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	53                   	push   %ebx
8010510b:	ff 75 c0             	pushl  -0x40(%ebp)
8010510e:	e8 fd d0 ff ff       	call   80102210 <nameiparent>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	89 c6                	mov    %eax,%esi
80105118:	85 c0                	test   %eax,%eax
8010511a:	0f 84 7a 01 00 00    	je     8010529a <sys_unlink+0x1ba>
  ilock(dp);
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	50                   	push   %eax
80105124:	e8 27 c8 ff ff       	call   80101950 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105129:	58                   	pop    %eax
8010512a:	5a                   	pop    %edx
8010512b:	68 3c 7d 10 80       	push   $0x80107d3c
80105130:	53                   	push   %ebx
80105131:	e8 2a cd ff ff       	call   80101e60 <namecmp>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	0f 84 0f 01 00 00    	je     80105250 <sys_unlink+0x170>
80105141:	83 ec 08             	sub    $0x8,%esp
80105144:	68 3b 7d 10 80       	push   $0x80107d3b
80105149:	53                   	push   %ebx
8010514a:	e8 11 cd ff ff       	call   80101e60 <namecmp>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 f6 00 00 00    	je     80105250 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010515a:	83 ec 04             	sub    $0x4,%esp
8010515d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105160:	50                   	push   %eax
80105161:	53                   	push   %ebx
80105162:	56                   	push   %esi
80105163:	e8 18 cd ff ff       	call   80101e80 <dirlookup>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	89 c3                	mov    %eax,%ebx
8010516d:	85 c0                	test   %eax,%eax
8010516f:	0f 84 db 00 00 00    	je     80105250 <sys_unlink+0x170>
  ilock(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	50                   	push   %eax
80105179:	e8 d2 c7 ff ff       	call   80101950 <ilock>
  if(ip->nlink < 1)
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105186:	0f 8e 37 01 00 00    	jle    801052c3 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010518c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105191:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105194:	74 6a                	je     80105200 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105196:	83 ec 04             	sub    $0x4,%esp
80105199:	6a 10                	push   $0x10
8010519b:	6a 00                	push   $0x0
8010519d:	57                   	push   %edi
8010519e:	e8 cd f5 ff ff       	call   80104770 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051a3:	6a 10                	push   $0x10
801051a5:	ff 75 c4             	pushl  -0x3c(%ebp)
801051a8:	57                   	push   %edi
801051a9:	56                   	push   %esi
801051aa:	e8 81 cb ff ff       	call   80101d30 <writei>
801051af:	83 c4 20             	add    $0x20,%esp
801051b2:	83 f8 10             	cmp    $0x10,%eax
801051b5:	0f 85 fb 00 00 00    	jne    801052b6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
801051bb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c0:	0f 84 aa 00 00 00    	je     80105270 <sys_unlink+0x190>
  iunlockput(dp);
801051c6:	83 ec 0c             	sub    $0xc,%esp
801051c9:	56                   	push   %esi
801051ca:	e8 11 ca ff ff       	call   80101be0 <iunlockput>
  ip->nlink--;
801051cf:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d4:	89 1c 24             	mov    %ebx,(%esp)
801051d7:	e8 c4 c6 ff ff       	call   801018a0 <iupdate>
  iunlockput(ip);
801051dc:	89 1c 24             	mov    %ebx,(%esp)
801051df:	e8 fc c9 ff ff       	call   80101be0 <iunlockput>
  end_op();
801051e4:	e8 57 dd ff ff       	call   80102f40 <end_op>
  return 0;
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	31 c0                	xor    %eax,%eax
}
801051ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f1:	5b                   	pop    %ebx
801051f2:	5e                   	pop    %esi
801051f3:	5f                   	pop    %edi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105200:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105204:	76 90                	jbe    80105196 <sys_unlink+0xb6>
80105206:	ba 20 00 00 00       	mov    $0x20,%edx
8010520b:	eb 0f                	jmp    8010521c <sys_unlink+0x13c>
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	83 c2 10             	add    $0x10,%edx
80105213:	39 53 58             	cmp    %edx,0x58(%ebx)
80105216:	0f 86 7a ff ff ff    	jbe    80105196 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010521c:	6a 10                	push   $0x10
8010521e:	52                   	push   %edx
8010521f:	57                   	push   %edi
80105220:	53                   	push   %ebx
80105221:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105224:	e8 07 ca ff ff       	call   80101c30 <readi>
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010522f:	83 f8 10             	cmp    $0x10,%eax
80105232:	75 75                	jne    801052a9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105234:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105239:	74 d5                	je     80105210 <sys_unlink+0x130>
    iunlockput(ip);
8010523b:	83 ec 0c             	sub    $0xc,%esp
8010523e:	53                   	push   %ebx
8010523f:	e8 9c c9 ff ff       	call   80101be0 <iunlockput>
    goto bad;
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	56                   	push   %esi
80105254:	e8 87 c9 ff ff       	call   80101be0 <iunlockput>
  end_op();
80105259:	e8 e2 dc ff ff       	call   80102f40 <end_op>
  return -1;
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105266:	eb 86                	jmp    801051ee <sys_unlink+0x10e>
80105268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
    iupdate(dp);
80105270:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105273:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105278:	56                   	push   %esi
80105279:	e8 22 c6 ff ff       	call   801018a0 <iupdate>
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	e9 40 ff ff ff       	jmp    801051c6 <sys_unlink+0xe6>
80105286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105295:	e9 54 ff ff ff       	jmp    801051ee <sys_unlink+0x10e>
    end_op();
8010529a:	e8 a1 dc ff ff       	call   80102f40 <end_op>
    return -1;
8010529f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a4:	e9 45 ff ff ff       	jmp    801051ee <sys_unlink+0x10e>
      panic("isdirempty: readi");
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 60 7d 10 80       	push   $0x80107d60
801052b1:	e8 ea b1 ff ff       	call   801004a0 <panic>
    panic("unlink: writei");
801052b6:	83 ec 0c             	sub    $0xc,%esp
801052b9:	68 72 7d 10 80       	push   $0x80107d72
801052be:	e8 dd b1 ff ff       	call   801004a0 <panic>
    panic("unlink: nlink < 1");
801052c3:	83 ec 0c             	sub    $0xc,%esp
801052c6:	68 4e 7d 10 80       	push   $0x80107d4e
801052cb:	e8 d0 b1 ff ff       	call   801004a0 <panic>

801052d0 <sys_open>:

int
sys_open(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	57                   	push   %edi
801052d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052d8:	53                   	push   %ebx
801052d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052dc:	50                   	push   %eax
801052dd:	6a 00                	push   $0x0
801052df:	e8 3c f8 ff ff       	call   80104b20 <argstr>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	0f 88 8e 00 00 00    	js     8010537d <sys_open+0xad>
801052ef:	83 ec 08             	sub    $0x8,%esp
801052f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052f5:	50                   	push   %eax
801052f6:	6a 01                	push   $0x1
801052f8:	e8 73 f7 ff ff       	call   80104a70 <argint>
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	85 c0                	test   %eax,%eax
80105302:	78 79                	js     8010537d <sys_open+0xad>
    return -1;

  begin_op();
80105304:	e8 c7 db ff ff       	call   80102ed0 <begin_op>

  if(omode & O_CREATE){
80105309:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010530d:	75 79                	jne    80105388 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	ff 75 e0             	pushl  -0x20(%ebp)
80105315:	e8 d6 ce ff ff       	call   801021f0 <namei>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	89 c6                	mov    %eax,%esi
8010531f:	85 c0                	test   %eax,%eax
80105321:	0f 84 7e 00 00 00    	je     801053a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	50                   	push   %eax
8010532b:	e8 20 c6 ff ff       	call   80101950 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105338:	0f 84 c2 00 00 00    	je     80105400 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010533e:	e8 4d bb ff ff       	call   80100e90 <filealloc>
80105343:	89 c7                	mov    %eax,%edi
80105345:	85 c0                	test   %eax,%eax
80105347:	74 23                	je     8010536c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105349:	e8 d2 e7 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010534e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 60                	je     801053b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105358:	83 c3 01             	add    $0x1,%ebx
8010535b:	83 fb 10             	cmp    $0x10,%ebx
8010535e:	75 f0                	jne    80105350 <sys_open+0x80>
    if(f)
      fileclose(f);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	57                   	push   %edi
80105364:	e8 e7 bb ff ff       	call   80100f50 <fileclose>
80105369:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	56                   	push   %esi
80105370:	e8 6b c8 ff ff       	call   80101be0 <iunlockput>
    end_op();
80105375:	e8 c6 db ff ff       	call   80102f40 <end_op>
    return -1;
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105382:	eb 6d                	jmp    801053f1 <sys_open+0x121>
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010538e:	31 c9                	xor    %ecx,%ecx
80105390:	ba 02 00 00 00       	mov    $0x2,%edx
80105395:	6a 00                	push   $0x0
80105397:	e8 24 f8 ff ff       	call   80104bc0 <create>
    if(ip == 0){
8010539c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010539f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053a1:	85 c0                	test   %eax,%eax
801053a3:	75 99                	jne    8010533e <sys_open+0x6e>
      end_op();
801053a5:	e8 96 db ff ff       	call   80102f40 <end_op>
      return -1;
801053aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053af:	eb 40                	jmp    801053f1 <sys_open+0x121>
801053b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053bf:	56                   	push   %esi
801053c0:	e8 6b c6 ff ff       	call   80101a30 <iunlock>
  end_op();
801053c5:	e8 76 db ff ff       	call   80102f40 <end_op>

  f->type = FD_INODE;
801053ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053e2:	f7 d0                	not    %eax
801053e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f4:	89 d8                	mov    %ebx,%eax
801053f6:	5b                   	pop    %ebx
801053f7:	5e                   	pop    %esi
801053f8:	5f                   	pop    %edi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105403:	85 c9                	test   %ecx,%ecx
80105405:	0f 84 33 ff ff ff    	je     8010533e <sys_open+0x6e>
8010540b:	e9 5c ff ff ff       	jmp    8010536c <sys_open+0x9c>

80105410 <sys_mkdir>:

int
sys_mkdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105416:	e8 b5 da ff ff       	call   80102ed0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010541b:	83 ec 08             	sub    $0x8,%esp
8010541e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105421:	50                   	push   %eax
80105422:	6a 00                	push   $0x0
80105424:	e8 f7 f6 ff ff       	call   80104b20 <argstr>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	78 30                	js     80105460 <sys_mkdir+0x50>
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	31 c9                	xor    %ecx,%ecx
80105438:	ba 01 00 00 00       	mov    $0x1,%edx
8010543d:	6a 00                	push   $0x0
8010543f:	e8 7c f7 ff ff       	call   80104bc0 <create>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	74 15                	je     80105460 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	50                   	push   %eax
8010544f:	e8 8c c7 ff ff       	call   80101be0 <iunlockput>
  end_op();
80105454:	e8 e7 da ff ff       	call   80102f40 <end_op>
  return 0;
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	31 c0                	xor    %eax,%eax
}
8010545e:	c9                   	leave  
8010545f:	c3                   	ret    
    end_op();
80105460:	e8 db da ff ff       	call   80102f40 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_mknod>:

int
sys_mknod(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105476:	e8 55 da ff ff       	call   80102ed0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010547b:	83 ec 08             	sub    $0x8,%esp
8010547e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	e8 97 f6 ff ff       	call   80104b20 <argstr>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 60                	js     801054f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 d2 f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 4b                	js     801054f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054a5:	83 ec 08             	sub    $0x8,%esp
801054a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ab:	50                   	push   %eax
801054ac:	6a 02                	push   $0x2
801054ae:	e8 bd f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 36                	js     801054f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054be:	83 ec 0c             	sub    $0xc,%esp
801054c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054c5:	ba 03 00 00 00       	mov    $0x3,%edx
801054ca:	50                   	push   %eax
801054cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054ce:	e8 ed f6 ff ff       	call   80104bc0 <create>
     argint(2, &minor) < 0 ||
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	74 16                	je     801054f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054da:	83 ec 0c             	sub    $0xc,%esp
801054dd:	50                   	push   %eax
801054de:	e8 fd c6 ff ff       	call   80101be0 <iunlockput>
  end_op();
801054e3:	e8 58 da ff ff       	call   80102f40 <end_op>
  return 0;
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	31 c0                	xor    %eax,%eax
}
801054ed:	c9                   	leave  
801054ee:	c3                   	ret    
801054ef:	90                   	nop
    end_op();
801054f0:	e8 4b da ff ff       	call   80102f40 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave  
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_chdir>:

int
sys_chdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105508:	e8 13 e6 ff ff       	call   80103b20 <myproc>
8010550d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010550f:	e8 bc d9 ff ff       	call   80102ed0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105514:	83 ec 08             	sub    $0x8,%esp
80105517:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551a:	50                   	push   %eax
8010551b:	6a 00                	push   $0x0
8010551d:	e8 fe f5 ff ff       	call   80104b20 <argstr>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 77                	js     801055a0 <sys_chdir+0xa0>
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	ff 75 f4             	pushl  -0xc(%ebp)
8010552f:	e8 bc cc ff ff       	call   801021f0 <namei>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	89 c3                	mov    %eax,%ebx
80105539:	85 c0                	test   %eax,%eax
8010553b:	74 63                	je     801055a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	50                   	push   %eax
80105541:	e8 0a c4 ff ff       	call   80101950 <ilock>
  if(ip->type != T_DIR){
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010554e:	75 30                	jne    80105580 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 d7 c4 ff ff       	call   80101a30 <iunlock>
  iput(curproc->cwd);
80105559:	58                   	pop    %eax
8010555a:	ff 76 68             	pushl  0x68(%esi)
8010555d:	e8 1e c5 ff ff       	call   80101a80 <iput>
  end_op();
80105562:	e8 d9 d9 ff ff       	call   80102f40 <end_op>
  curproc->cwd = ip;
80105567:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	31 c0                	xor    %eax,%eax
}
8010556f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5d                   	pop    %ebp
80105575:	c3                   	ret    
80105576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	53                   	push   %ebx
80105584:	e8 57 c6 ff ff       	call   80101be0 <iunlockput>
    end_op();
80105589:	e8 b2 d9 ff ff       	call   80102f40 <end_op>
    return -1;
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105596:	eb d7                	jmp    8010556f <sys_chdir+0x6f>
80105598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
    end_op();
801055a0:	e8 9b d9 ff ff       	call   80102f40 <end_op>
    return -1;
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	eb c3                	jmp    8010556f <sys_chdir+0x6f>
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_exec>:

int
sys_exec(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055bb:	53                   	push   %ebx
801055bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055c2:	50                   	push   %eax
801055c3:	6a 00                	push   $0x0
801055c5:	e8 56 f5 ff ff       	call   80104b20 <argstr>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 c0                	test   %eax,%eax
801055cf:	0f 88 87 00 00 00    	js     8010565c <sys_exec+0xac>
801055d5:	83 ec 08             	sub    $0x8,%esp
801055d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 01                	push   $0x1
801055e1:	e8 8a f4 ff ff       	call   80104a70 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 6f                	js     8010565c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055f8:	68 80 00 00 00       	push   $0x80
801055fd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105603:	6a 00                	push   $0x0
80105605:	50                   	push   %eax
80105606:	e8 65 f1 ff ff       	call   80104770 <memset>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105610:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105616:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010561d:	83 ec 08             	sub    $0x8,%esp
80105620:	57                   	push   %edi
80105621:	01 f0                	add    %esi,%eax
80105623:	50                   	push   %eax
80105624:	e8 97 f3 ff ff       	call   801049c0 <fetchint>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	85 c0                	test   %eax,%eax
8010562e:	78 2c                	js     8010565c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105630:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105636:	85 c0                	test   %eax,%eax
80105638:	74 36                	je     80105670 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010563a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105646:	52                   	push   %edx
80105647:	50                   	push   %eax
80105648:	e8 b3 f3 ff ff       	call   80104a00 <fetchstr>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	78 08                	js     8010565c <sys_exec+0xac>
  for(i=0;; i++){
80105654:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105657:	83 fb 20             	cmp    $0x20,%ebx
8010565a:	75 b4                	jne    80105610 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010565c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105664:	5b                   	pop    %ebx
80105665:	5e                   	pop    %esi
80105666:	5f                   	pop    %edi
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret    
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105679:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105680:	00 00 00 00 
  return exec(path, argv);
80105684:	50                   	push   %eax
80105685:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010568b:	e8 90 b4 ff ff       	call   80100b20 <exec>
80105690:	83 c4 10             	add    $0x10,%esp
}
80105693:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105696:	5b                   	pop    %ebx
80105697:	5e                   	pop    %esi
80105698:	5f                   	pop    %edi
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret    
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop

801056a0 <sys_pipe>:

int
sys_pipe(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056a8:	53                   	push   %ebx
801056a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056ac:	6a 08                	push   $0x8
801056ae:	50                   	push   %eax
801056af:	6a 00                	push   $0x0
801056b1:	e8 0a f4 ff ff       	call   80104ac0 <argptr>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	78 4a                	js     80105707 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056bd:	83 ec 08             	sub    $0x8,%esp
801056c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056c3:	50                   	push   %eax
801056c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056c7:	50                   	push   %eax
801056c8:	e8 b3 de ff ff       	call   80103580 <pipealloc>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 33                	js     80105707 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056d7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056d9:	e8 42 e4 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801056e0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056e4:	85 f6                	test   %esi,%esi
801056e6:	74 28                	je     80105710 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801056e8:	83 c3 01             	add    $0x1,%ebx
801056eb:	83 fb 10             	cmp    $0x10,%ebx
801056ee:	75 f0                	jne    801056e0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	ff 75 e0             	pushl  -0x20(%ebp)
801056f6:	e8 55 b8 ff ff       	call   80100f50 <fileclose>
    fileclose(wf);
801056fb:	58                   	pop    %eax
801056fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801056ff:	e8 4c b8 ff ff       	call   80100f50 <fileclose>
    return -1;
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570c:	eb 53                	jmp    80105761 <sys_pipe+0xc1>
8010570e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105710:	8d 73 08             	lea    0x8(%ebx),%esi
80105713:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105717:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010571a:	e8 01 e4 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010571f:	31 d2                	xor    %edx,%edx
80105721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105728:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010572c:	85 c9                	test   %ecx,%ecx
8010572e:	74 20                	je     80105750 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105730:	83 c2 01             	add    $0x1,%edx
80105733:	83 fa 10             	cmp    $0x10,%edx
80105736:	75 f0                	jne    80105728 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105738:	e8 e3 e3 ff ff       	call   80103b20 <myproc>
8010573d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105744:	00 
80105745:	eb a9                	jmp    801056f0 <sys_pipe+0x50>
80105747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105750:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105754:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105757:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105759:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010575c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010575f:	31 c0                	xor    %eax,%eax
}
80105761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105764:	5b                   	pop    %ebx
80105765:	5e                   	pop    %esi
80105766:	5f                   	pop    %edi
80105767:	5d                   	pop    %ebp
80105768:	c3                   	ret    
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_bstat>:
 */
int
sys_bstat(void)
{
	return numallocblocks;
}
80105770:	a1 5c b5 10 80       	mov    0x8010b55c,%eax
80105775:	c3                   	ret    
80105776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577d:	8d 76 00             	lea    0x0(%esi),%esi

80105780 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 14             	sub    $0x14,%esp
  uint addr;
  struct proc *curproc = myproc();
80105787:	e8 94 e3 ff ff       	call   80103b20 <myproc>
  struct sleeplock *loc = 0;
  pde_t *kpgdir= curproc -> pgdir;

  if(argint(0, (int*)&addr) < 0)
8010578c:	83 ec 08             	sub    $0x8,%esp
  pde_t *kpgdir= curproc -> pgdir;
8010578f:	8b 58 04             	mov    0x4(%eax),%ebx
  if(argint(0, (int*)&addr) < 0)
80105792:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105795:	50                   	push   %eax
80105796:	6a 00                	push   $0x0
80105798:	e8 d3 f2 ff ff       	call   80104a70 <argint>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 4c                	js     801057f0 <sys_swap+0x70>
    return -1;

  //cprintf("Addr = %x\n",addr);
  
  initsleeplock(loc,(char*)kpgdir);
801057a4:	83 ec 08             	sub    $0x8,%esp
801057a7:	53                   	push   %ebx
801057a8:	6a 00                	push   $0x0
801057aa:	e8 41 ec ff ff       	call   801043f0 <initsleeplock>
  // Findout the pte corresponding to the va
  acquiresleep(loc);
801057af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057b6:	e8 75 ec ff ff       	call   80104430 <acquiresleep>
  pte_t *ptentry = uva2pte(kpgdir, addr);
801057bb:	58                   	pop    %eax
801057bc:	5a                   	pop    %edx
801057bd:	ff 75 f4             	pushl  -0xc(%ebp)
801057c0:	53                   	push   %ebx
801057c1:	e8 2a 1d 00 00       	call   801074f0 <uva2pte>

  //cprintf("ptentry: %x\n",*ptentry);
  // Allocates disk block and swaps the pte
  swap_page_from_pte(ptentry);
801057c6:	89 04 24             	mov    %eax,(%esp)
801057c9:	e8 22 05 00 00       	call   80105cf0 <swap_page_from_pte>

// TLB invalidator, added by us. Reference: https://stackoverflow.com/questions/37752664/how-to-use-invlpg-on-x86-64-architecture
// and reference : https://courses.cs.washington.edu/courses/csep551/17wi/l02.pdf
static inline void 
invlpg(void *addr){
   asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
801057ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d1:	0f 01 38             	invlpg (%eax)

  // Invalidate the TLB 
  invlpg((void *)addr); 

  releasesleep(loc);
801057d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057db:	e8 b0 ec ff ff       	call   80104490 <releasesleep>
  return 0;
801057e0:	83 c4 10             	add    $0x10,%esp
801057e3:	31 c0                	xor    %eax,%eax
}
801057e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e8:	c9                   	leave  
801057e9:	c3                   	ret    
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f5:	eb ee                	jmp    801057e5 <sys_swap+0x65>
801057f7:	66 90                	xchg   %ax,%ax
801057f9:	66 90                	xchg   %ax,%ax
801057fb:	66 90                	xchg   %ax,%ax
801057fd:	66 90                	xchg   %ax,%ax
801057ff:	90                   	nop

80105800 <sys_fork>:
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	5d                   	pop    %ebp
80105804:	e9 87 e4 ff ff       	jmp    80103c90 <fork>
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_exit>:
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 08             	sub    $0x8,%esp
80105816:	e8 f5 e6 ff ff       	call   80103f10 <exit>
8010581b:	31 c0                	xor    %eax,%eax
8010581d:	c9                   	leave  
8010581e:	c3                   	ret    
8010581f:	90                   	nop

80105820 <sys_wait>:
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	5d                   	pop    %ebp
80105824:	e9 27 e9 ff ff       	jmp    80104150 <wait>
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_kill>:
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	83 ec 20             	sub    $0x20,%esp
80105836:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105839:	50                   	push   %eax
8010583a:	6a 00                	push   $0x0
8010583c:	e8 2f f2 ff ff       	call   80104a70 <argint>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	85 c0                	test   %eax,%eax
80105846:	78 18                	js     80105860 <sys_kill+0x30>
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 f4             	pushl  -0xc(%ebp)
8010584e:	e8 5d ea ff ff       	call   801042b0 <kill>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	c9                   	leave  
80105857:	c3                   	ret    
80105858:	90                   	nop
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105870 <sys_getpid>:
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 08             	sub    $0x8,%esp
80105876:	e8 a5 e2 ff ff       	call   80103b20 <myproc>
8010587b:	8b 40 10             	mov    0x10(%eax),%eax
8010587e:	c9                   	leave  
8010587f:	c3                   	ret    

80105880 <sys_sbrk>:
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
80105884:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105887:	83 ec 1c             	sub    $0x1c,%esp
8010588a:	50                   	push   %eax
8010588b:	6a 00                	push   $0x0
8010588d:	e8 de f1 ff ff       	call   80104a70 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	78 27                	js     801058c0 <sys_sbrk+0x40>
80105899:	e8 82 e2 ff ff       	call   80103b20 <myproc>
8010589e:	83 ec 0c             	sub    $0xc,%esp
801058a1:	8b 18                	mov    (%eax),%ebx
801058a3:	ff 75 f4             	pushl  -0xc(%ebp)
801058a6:	e8 95 e3 ff ff       	call   80103c40 <growproc>
801058ab:	83 c4 10             	add    $0x10,%esp
801058ae:	85 c0                	test   %eax,%eax
801058b0:	78 0e                	js     801058c0 <sys_sbrk+0x40>
801058b2:	89 d8                	mov    %ebx,%eax
801058b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058b7:	c9                   	leave  
801058b8:	c3                   	ret    
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c5:	eb eb                	jmp    801058b2 <sys_sbrk+0x32>
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058d0 <sys_sleep>:
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d7:	83 ec 1c             	sub    $0x1c,%esp
801058da:	50                   	push   %eax
801058db:	6a 00                	push   $0x0
801058dd:	e8 8e f1 ff ff       	call   80104a70 <argint>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	0f 88 8a 00 00 00    	js     80105977 <sys_sleep+0xa7>
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	68 60 5c 11 80       	push   $0x80115c60
801058f5:	e8 f6 ec ff ff       	call   801045f0 <acquire>
801058fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
80105906:	85 d2                	test   %edx,%edx
80105908:	75 27                	jne    80105931 <sys_sleep+0x61>
8010590a:	eb 54                	jmp    80105960 <sys_sleep+0x90>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	68 60 5c 11 80       	push   $0x80115c60
80105918:	68 a0 64 11 80       	push   $0x801164a0
8010591d:	e8 6e e7 ff ff       	call   80104090 <sleep>
80105922:	a1 a0 64 11 80       	mov    0x801164a0,%eax
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	29 d8                	sub    %ebx,%eax
8010592c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010592f:	73 2f                	jae    80105960 <sys_sleep+0x90>
80105931:	e8 ea e1 ff ff       	call   80103b20 <myproc>
80105936:	8b 40 24             	mov    0x24(%eax),%eax
80105939:	85 c0                	test   %eax,%eax
8010593b:	74 d3                	je     80105910 <sys_sleep+0x40>
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	68 60 5c 11 80       	push   $0x80115c60
80105945:	e8 c6 ed ff ff       	call   80104710 <release>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	68 60 5c 11 80       	push   $0x80115c60
80105968:	e8 a3 ed ff ff       	call   80104710 <release>
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	31 c0                	xor    %eax,%eax
80105972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105975:	c9                   	leave  
80105976:	c3                   	ret    
80105977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597c:	eb f4                	jmp    80105972 <sys_sleep+0xa2>
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_uptime>:
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	53                   	push   %ebx
80105984:	83 ec 10             	sub    $0x10,%esp
80105987:	68 60 5c 11 80       	push   $0x80115c60
8010598c:	e8 5f ec ff ff       	call   801045f0 <acquire>
80105991:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
80105997:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
8010599e:	e8 6d ed ff ff       	call   80104710 <release>
801059a3:	89 d8                	mov    %ebx,%eax
801059a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    

801059aa <alltraps>:
801059aa:	1e                   	push   %ds
801059ab:	06                   	push   %es
801059ac:	0f a0                	push   %fs
801059ae:	0f a8                	push   %gs
801059b0:	60                   	pusha  
801059b1:	66 b8 10 00          	mov    $0x10,%ax
801059b5:	8e d8                	mov    %eax,%ds
801059b7:	8e c0                	mov    %eax,%es
801059b9:	54                   	push   %esp
801059ba:	e8 c1 00 00 00       	call   80105a80 <trap>
801059bf:	83 c4 04             	add    $0x4,%esp

801059c2 <trapret>:
801059c2:	61                   	popa   
801059c3:	0f a9                	pop    %gs
801059c5:	0f a1                	pop    %fs
801059c7:	07                   	pop    %es
801059c8:	1f                   	pop    %ds
801059c9:	83 c4 08             	add    $0x8,%esp
801059cc:	cf                   	iret   
801059cd:	66 90                	xchg   %ax,%ax
801059cf:	90                   	nop

801059d0 <tvinit>:
801059d0:	55                   	push   %ebp
801059d1:	31 c0                	xor    %eax,%eax
801059d3:	89 e5                	mov    %esp,%ebp
801059d5:	83 ec 08             	sub    $0x8,%esp
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059e0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801059e7:	c7 04 c5 a2 5c 11 80 	movl   $0x8e000008,-0x7feea35e(,%eax,8)
801059ee:	08 00 00 8e 
801059f2:	66 89 14 c5 a0 5c 11 	mov    %dx,-0x7feea360(,%eax,8)
801059f9:	80 
801059fa:	c1 ea 10             	shr    $0x10,%edx
801059fd:	66 89 14 c5 a6 5c 11 	mov    %dx,-0x7feea35a(,%eax,8)
80105a04:	80 
80105a05:	83 c0 01             	add    $0x1,%eax
80105a08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a0d:	75 d1                	jne    801059e0 <tvinit+0x10>
80105a0f:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105a14:	83 ec 08             	sub    $0x8,%esp
80105a17:	c7 05 a2 5e 11 80 08 	movl   $0xef000008,0x80115ea2
80105a1e:	00 00 ef 
80105a21:	68 81 7d 10 80       	push   $0x80107d81
80105a26:	68 60 5c 11 80       	push   $0x80115c60
80105a2b:	66 a3 a0 5e 11 80    	mov    %ax,0x80115ea0
80105a31:	c1 e8 10             	shr    $0x10,%eax
80105a34:	66 a3 a6 5e 11 80    	mov    %ax,0x80115ea6
80105a3a:	e8 c1 ea ff ff       	call   80104500 <initlock>
80105a3f:	83 c4 10             	add    $0x10,%esp
80105a42:	c9                   	leave  
80105a43:	c3                   	ret    
80105a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a50 <idtinit>:
80105a50:	55                   	push   %ebp
80105a51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a56:	89 e5                	mov    %esp,%ebp
80105a58:	83 ec 10             	sub    $0x10,%esp
80105a5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80105a5f:	b8 a0 5c 11 80       	mov    $0x80115ca0,%eax
80105a64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105a68:	c1 e8 10             	shr    $0x10,%eax
80105a6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80105a6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a72:	0f 01 18             	lidtl  (%eax)
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a80 <trap>:
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
80105a85:	53                   	push   %ebx
80105a86:	83 ec 1c             	sub    $0x1c,%esp
80105a89:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a8c:	8b 47 30             	mov    0x30(%edi),%eax
80105a8f:	83 f8 40             	cmp    $0x40,%eax
80105a92:	0f 84 f0 00 00 00    	je     80105b88 <trap+0x108>
80105a98:	83 e8 0e             	sub    $0xe,%eax
80105a9b:	83 f8 31             	cmp    $0x31,%eax
80105a9e:	77 10                	ja     80105ab0 <trap+0x30>
80105aa0:	ff 24 85 28 7e 10 80 	jmp    *-0x7fef81d8(,%eax,4)
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ab0:	e8 6b e0 ff ff       	call   80103b20 <myproc>
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105aba:	0f 84 04 02 00 00    	je     80105cc4 <trap+0x244>
80105ac0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ac4:	0f 84 fa 01 00 00    	je     80105cc4 <trap+0x244>
80105aca:	0f 20 d1             	mov    %cr2,%ecx
80105acd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ad0:	e8 2b e0 ff ff       	call   80103b00 <cpuid>
80105ad5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ad8:	8b 47 34             	mov    0x34(%edi),%eax
80105adb:	8b 77 30             	mov    0x30(%edi),%esi
80105ade:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105ae1:	e8 3a e0 ff ff       	call   80103b20 <myproc>
80105ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ae9:	e8 32 e0 ff ff       	call   80103b20 <myproc>
80105aee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105af1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105af4:	51                   	push   %ecx
80105af5:	53                   	push   %ebx
80105af6:	52                   	push   %edx
80105af7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105afa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105afd:	56                   	push   %esi
80105afe:	83 c2 6c             	add    $0x6c,%edx
80105b01:	52                   	push   %edx
80105b02:	ff 70 10             	pushl  0x10(%eax)
80105b05:	68 e4 7d 10 80       	push   $0x80107de4
80105b0a:	e8 61 ac ff ff       	call   80100770 <cprintf>
80105b0f:	83 c4 20             	add    $0x20,%esp
80105b12:	e8 09 e0 ff ff       	call   80103b20 <myproc>
80105b17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105b1e:	66 90                	xchg   %ax,%ax
80105b20:	e8 fb df ff ff       	call   80103b20 <myproc>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	74 1d                	je     80105b46 <trap+0xc6>
80105b29:	e8 f2 df ff ff       	call   80103b20 <myproc>
80105b2e:	8b 50 24             	mov    0x24(%eax),%edx
80105b31:	85 d2                	test   %edx,%edx
80105b33:	74 11                	je     80105b46 <trap+0xc6>
80105b35:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b39:	83 e0 03             	and    $0x3,%eax
80105b3c:	66 83 f8 03          	cmp    $0x3,%ax
80105b40:	0f 84 3a 01 00 00    	je     80105c80 <trap+0x200>
80105b46:	e8 d5 df ff ff       	call   80103b20 <myproc>
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	74 0b                	je     80105b5a <trap+0xda>
80105b4f:	e8 cc df ff ff       	call   80103b20 <myproc>
80105b54:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b58:	74 66                	je     80105bc0 <trap+0x140>
80105b5a:	e8 c1 df ff ff       	call   80103b20 <myproc>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	74 19                	je     80105b7c <trap+0xfc>
80105b63:	e8 b8 df ff ff       	call   80103b20 <myproc>
80105b68:	8b 40 24             	mov    0x24(%eax),%eax
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	74 0d                	je     80105b7c <trap+0xfc>
80105b6f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b73:	83 e0 03             	and    $0x3,%eax
80105b76:	66 83 f8 03          	cmp    $0x3,%ax
80105b7a:	74 35                	je     80105bb1 <trap+0x131>
80105b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7f:	5b                   	pop    %ebx
80105b80:	5e                   	pop    %esi
80105b81:	5f                   	pop    %edi
80105b82:	5d                   	pop    %ebp
80105b83:	c3                   	ret    
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b88:	e8 93 df ff ff       	call   80103b20 <myproc>
80105b8d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b90:	85 db                	test   %ebx,%ebx
80105b92:	0f 85 d8 00 00 00    	jne    80105c70 <trap+0x1f0>
80105b98:	e8 83 df ff ff       	call   80103b20 <myproc>
80105b9d:	89 78 18             	mov    %edi,0x18(%eax)
80105ba0:	e8 bb ef ff ff       	call   80104b60 <syscall>
80105ba5:	e8 76 df ff ff       	call   80103b20 <myproc>
80105baa:	8b 48 24             	mov    0x24(%eax),%ecx
80105bad:	85 c9                	test   %ecx,%ecx
80105baf:	74 cb                	je     80105b7c <trap+0xfc>
80105bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb4:	5b                   	pop    %ebx
80105bb5:	5e                   	pop    %esi
80105bb6:	5f                   	pop    %edi
80105bb7:	5d                   	pop    %ebp
80105bb8:	e9 53 e3 ff ff       	jmp    80103f10 <exit>
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
80105bc0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105bc4:	75 94                	jne    80105b5a <trap+0xda>
80105bc6:	e8 75 e4 ff ff       	call   80104040 <yield>
80105bcb:	eb 8d                	jmp    80105b5a <trap+0xda>
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi
80105bd0:	e8 2b 02 00 00       	call   80105e00 <handle_pgfault>
80105bd5:	e9 46 ff ff ff       	jmp    80105b20 <trap+0xa0>
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105be0:	e8 1b df ff ff       	call   80103b00 <cpuid>
80105be5:	85 c0                	test   %eax,%eax
80105be7:	0f 84 a3 00 00 00    	je     80105c90 <trap+0x210>
80105bed:	e8 8e ce ff ff       	call   80102a80 <lapiceoi>
80105bf2:	e8 29 df ff ff       	call   80103b20 <myproc>
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	0f 85 2a ff ff ff    	jne    80105b29 <trap+0xa9>
80105bff:	e9 42 ff ff ff       	jmp    80105b46 <trap+0xc6>
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c08:	e8 33 cd ff ff       	call   80102940 <kbdintr>
80105c0d:	e8 6e ce ff ff       	call   80102a80 <lapiceoi>
80105c12:	e9 09 ff ff ff       	jmp    80105b20 <trap+0xa0>
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c20:	e8 4b 04 00 00       	call   80106070 <uartintr>
80105c25:	e8 56 ce ff ff       	call   80102a80 <lapiceoi>
80105c2a:	e9 f1 fe ff ff       	jmp    80105b20 <trap+0xa0>
80105c2f:	90                   	nop
80105c30:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105c34:	8b 77 38             	mov    0x38(%edi),%esi
80105c37:	e8 c4 de ff ff       	call   80103b00 <cpuid>
80105c3c:	56                   	push   %esi
80105c3d:	53                   	push   %ebx
80105c3e:	50                   	push   %eax
80105c3f:	68 8c 7d 10 80       	push   $0x80107d8c
80105c44:	e8 27 ab ff ff       	call   80100770 <cprintf>
80105c49:	e8 32 ce ff ff       	call   80102a80 <lapiceoi>
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	e9 ca fe ff ff       	jmp    80105b20 <trap+0xa0>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c60:	e8 1b c7 ff ff       	call   80102380 <ideintr>
80105c65:	eb 86                	jmp    80105bed <trap+0x16d>
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c70:	e8 9b e2 ff ff       	call   80103f10 <exit>
80105c75:	e9 1e ff ff ff       	jmp    80105b98 <trap+0x118>
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c80:	e8 8b e2 ff ff       	call   80103f10 <exit>
80105c85:	e9 bc fe ff ff       	jmp    80105b46 <trap+0xc6>
80105c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	68 60 5c 11 80       	push   $0x80115c60
80105c98:	e8 53 e9 ff ff       	call   801045f0 <acquire>
80105c9d:	c7 04 24 a0 64 11 80 	movl   $0x801164a0,(%esp)
80105ca4:	83 05 a0 64 11 80 01 	addl   $0x1,0x801164a0
80105cab:	e8 a0 e5 ff ff       	call   80104250 <wakeup>
80105cb0:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
80105cb7:	e8 54 ea ff ff       	call   80104710 <release>
80105cbc:	83 c4 10             	add    $0x10,%esp
80105cbf:	e9 29 ff ff ff       	jmp    80105bed <trap+0x16d>
80105cc4:	0f 20 d6             	mov    %cr2,%esi
80105cc7:	e8 34 de ff ff       	call   80103b00 <cpuid>
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	56                   	push   %esi
80105cd0:	53                   	push   %ebx
80105cd1:	50                   	push   %eax
80105cd2:	ff 77 30             	pushl  0x30(%edi)
80105cd5:	68 b0 7d 10 80       	push   $0x80107db0
80105cda:	e8 91 aa ff ff       	call   80100770 <cprintf>
80105cdf:	83 c4 14             	add    $0x14,%esp
80105ce2:	68 86 7d 10 80       	push   $0x80107d86
80105ce7:	e8 b4 a7 ff ff       	call   801004a0 <panic>
80105cec:	66 90                	xchg   %ax,%ax
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <swap_page_from_pte>:
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{	
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
80105cf6:	83 ec 18             	sub    $0x18,%esp
80105cf9:	8b 75 08             	mov    0x8(%ebp),%esi
	// Allocate a disk block to write

	uint block_addr = balloc_page(ROOTDEV);
80105cfc:	6a 01                	push   $0x1
80105cfe:	e8 cd b8 ff ff       	call   801015d0 <balloc_page>

	char *va = (char *)P2V(PTE_ADDR(*pte));
80105d03:	8b 3e                	mov    (%esi),%edi

	// cprintf("va: %x\n",va);

	// Writing the PTE into the disk block
	write_page_to_disk(ROOTDEV, va, block_addr);
80105d05:	83 c4 0c             	add    $0xc,%esp
80105d08:	50                   	push   %eax
	uint block_addr = balloc_page(ROOTDEV);
80105d09:	89 c3                	mov    %eax,%ebx
	char *va = (char *)P2V(PTE_ADDR(*pte));
80105d0b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi

	kfree(va);

	// Save the block id into PTE
	// Setting the swapped flag for the PTE
	uint Blk = block_addr << 12;
80105d11:	c1 e3 0c             	shl    $0xc,%ebx
	char *va = (char *)P2V(PTE_ADDR(*pte));
80105d14:	81 c7 00 00 00 80    	add    $0x80000000,%edi

	*pte = Blk;

	// cprintf("Bit before : %x\n", *pte & PTE_P);

	*pte = *pte | PTE_SWP;
80105d1a:	80 cf 02             	or     $0x2,%bh
	write_page_to_disk(ROOTDEV, va, block_addr);
80105d1d:	57                   	push   %edi
80105d1e:	6a 01                	push   $0x1
80105d20:	e8 7b a5 ff ff       	call   801002a0 <write_page_to_disk>
	kfree(va);
80105d25:	89 3c 24             	mov    %edi,(%esp)
80105d28:	e8 e3 c8 ff ff       	call   80102610 <kfree>
	*pte = *pte | PTE_SWP;
80105d2d:	89 1e                	mov    %ebx,(%esi)

	// cprintf("Bit after : %x\n", *pte & PTE_P);

	// numallocblocks++;

}
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d35:	5b                   	pop    %ebx
80105d36:	5e                   	pop    %esi
80105d37:	5f                   	pop    %edi
80105d38:	5d                   	pop    %ebp
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d40 <swap_page>:
/* Select a victim and swap the contents to the disk.
 */

int
swap_page(pde_t *pgdir)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 14             	sub    $0x14,%esp

	pte_t *victim = select_a_victim(pgdir);
80105d46:	ff 75 08             	pushl  0x8(%ebp)
80105d49:	e8 22 12 00 00       	call   80106f70 <select_a_victim>

	// cprintf("Victim: %x\n" ,victim);
	
	swap_page_from_pte(victim);
80105d4e:	89 04 24             	mov    %eax,(%esp)
80105d51:	e8 9a ff ff ff       	call   80105cf0 <swap_page_from_pte>

	return 1;
}
80105d56:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5b:	c9                   	leave  
80105d5c:	c3                   	ret    
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi

80105d60 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
80105d66:	83 ec 1c             	sub    $0x1c,%esp
80105d69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105d6c:	8b 75 08             	mov    0x8(%ebp),%esi
	struct proc *curproc = myproc();
80105d6f:	e8 ac dd ff ff       	call   80103b20 <myproc>
	uint blk = getswappedblk(pgdir,addr);
80105d74:	83 ec 08             	sub    $0x8,%esp
80105d77:	53                   	push   %ebx
80105d78:	56                   	push   %esi
	struct proc *curproc = myproc();
80105d79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint blk = getswappedblk(pgdir,addr);
80105d7c:	e8 4f 12 00 00       	call   80106fd0 <getswappedblk>

	allocuvm(pgdir,addr,addr+PGSIZE);
80105d81:	83 c4 0c             	add    $0xc,%esp
	uint blk = getswappedblk(pgdir,addr);
80105d84:	89 c7                	mov    %eax,%edi
	allocuvm(pgdir,addr,addr+PGSIZE);
80105d86:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80105d8c:	50                   	push   %eax
80105d8d:	53                   	push   %ebx
80105d8e:	56                   	push   %esi
80105d8f:	e8 8c 13 00 00       	call   80107120 <allocuvm>
	pte_t *ptentry = uva2pte(pgdir, addr);
80105d94:	58                   	pop    %eax
80105d95:	5a                   	pop    %edx
80105d96:	53                   	push   %ebx
80105d97:	56                   	push   %esi
80105d98:	e8 53 17 00 00       	call   801074f0 <uva2pte>

	switchuvm(curproc);
80105d9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	pte_t *ptentry = uva2pte(pgdir, addr);
80105da0:	89 c3                	mov    %eax,%ebx
	switchuvm(curproc);
80105da2:	89 14 24             	mov    %edx,(%esp)
80105da5:	e8 16 0f 00 00       	call   80106cc0 <switchuvm>

	// if blk was not -1, read_page_from_disk
	if ( blk != -1 )
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	83 ff ff             	cmp    $0xffffffff,%edi
80105db0:	75 0e                	jne    80105dc0 <map_address+0x60>
		
		char *pg = P2V(PTE_ADDR(*ptentry));
		read_page_from_disk(ROOTDEV,pg,blk);
		bfree_page(ROOTDEV,blk);
	}
}
80105db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db5:	5b                   	pop    %ebx
80105db6:	5e                   	pop    %esi
80105db7:	5f                   	pop    %edi
80105db8:	5d                   	pop    %ebp
80105db9:	c3                   	ret    
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		read_page_from_disk(ROOTDEV,pg,blk);
80105dc0:	83 ec 04             	sub    $0x4,%esp
80105dc3:	57                   	push   %edi
		char *pg = P2V(PTE_ADDR(*ptentry));
80105dc4:	8b 03                	mov    (%ebx),%eax
80105dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105dcb:	05 00 00 00 80       	add    $0x80000000,%eax
		read_page_from_disk(ROOTDEV,pg,blk);
80105dd0:	50                   	push   %eax
80105dd1:	6a 01                	push   $0x1
80105dd3:	e8 38 a5 ff ff       	call   80100310 <read_page_from_disk>
		bfree_page(ROOTDEV,blk);
80105dd8:	89 7d 0c             	mov    %edi,0xc(%ebp)
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
80105de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de8:	5b                   	pop    %ebx
80105de9:	5e                   	pop    %esi
80105dea:	5f                   	pop    %edi
80105deb:	5d                   	pop    %ebp
		bfree_page(ROOTDEV,blk);
80105dec:	e9 1f b9 ff ff       	jmp    80101710 <bfree_page>
80105df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop

80105e00 <handle_pgfault>:

/* page fault handler */
void
handle_pgfault()
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105e06:	e8 15 dd ff ff       	call   80103b20 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105e0b:	0f 20 d2             	mov    %cr2,%edx
	addr &= ~0xfff;

	map_address(curproc->pgdir, addr);
80105e0e:	83 ec 08             	sub    $0x8,%esp
	addr &= ~0xfff;
80105e11:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	map_address(curproc->pgdir, addr);
80105e17:	52                   	push   %edx
80105e18:	ff 70 04             	pushl  0x4(%eax)
80105e1b:	e8 40 ff ff ff       	call   80105d60 <map_address>

}
80105e20:	83 c4 10             	add    $0x10,%esp
80105e23:	c9                   	leave  
80105e24:	c3                   	ret    
80105e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <map_address2>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address2(pde_t *pgdir, uint addr)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	57                   	push   %edi
80105e34:	56                   	push   %esi
80105e35:	53                   	push   %ebx
80105e36:	83 ec 0c             	sub    $0xc,%esp
80105e39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105e3c:	8b 75 08             	mov    0x8(%ebp),%esi
	// Check if it was previously swapped and restore contents
	pde_t *pde;

	pde = &pgdir[PDX(addr)];
80105e3f:	89 d8                	mov    %ebx,%eax
80105e41:	c1 e8 16             	shr    $0x16,%eax
	pte_t *pgtab;
	pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105e44:	8b 14 86             	mov    (%esi,%eax,4),%edx
	pte_t *pte = &pgtab[PTX(addr)];
80105e47:	89 d8                	mov    %ebx,%eax
80105e49:	c1 e8 0a             	shr    $0xa,%eax
80105e4c:	25 fc 0f 00 00       	and    $0xffc,%eax
	pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105e51:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	pte_t *pte = &pgtab[PTX(addr)];
80105e57:	8d bc 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edi

	
	if (*pte & PTE_SWP)
80105e5e:	8b 07                	mov    (%edi),%eax
80105e60:	f6 c4 02             	test   $0x2,%ah
80105e63:	74 33                	je     80105e98 <map_address2+0x68>
	{
		uint block_addr = *pte >> 10;
80105e65:	c1 e8 0a             	shr    $0xa,%eax
80105e68:	89 c3                	mov    %eax,%ebx



		char * addr = kalloc();
80105e6a:	e8 81 c9 ff ff       	call   801027f0 <kalloc>
		if (addr == 0)
80105e6f:	85 c0                	test   %eax,%eax
80105e71:	74 6d                	je     80105ee0 <map_address2+0xb0>
		{
			swap_page(pgdir);
			addr = kalloc();
		}
		*pte = *addr | PTE_P;
80105e73:	0f b6 10             	movzbl (%eax),%edx
		// cprintf("got the swapped page!!");
		read_page_from_disk(ROOTDEV,addr,block_addr);
80105e76:	83 ec 04             	sub    $0x4,%esp
		*pte = *addr | PTE_P;
80105e79:	83 ca 01             	or     $0x1,%edx
80105e7c:	0f be d2             	movsbl %dl,%edx
80105e7f:	89 17                	mov    %edx,(%edi)
		read_page_from_disk(ROOTDEV,addr,block_addr);
80105e81:	53                   	push   %ebx
80105e82:	50                   	push   %eax
80105e83:	6a 01                	push   $0x1
80105e85:	e8 86 a4 ff ff       	call   80100310 <read_page_from_disk>
80105e8a:	83 c4 10             	add    $0x10,%esp
			// cprintf("Allocated again!!");
		}
	}
	

}
80105e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e90:	5b                   	pop    %ebx
80105e91:	5e                   	pop    %esi
80105e92:	5f                   	pop    %edi
80105e93:	5d                   	pop    %ebp
80105e94:	c3                   	ret    
80105e95:	8d 76 00             	lea    0x0(%esi),%esi
		if(allocuvm(pgdir,addr,addr + PGSIZE) == 0){
80105e98:	83 ec 04             	sub    $0x4,%esp
80105e9b:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
80105ea1:	57                   	push   %edi
80105ea2:	53                   	push   %ebx
80105ea3:	56                   	push   %esi
80105ea4:	e8 77 12 00 00       	call   80107120 <allocuvm>
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	85 c0                	test   %eax,%eax
80105eae:	75 dd                	jne    80105e8d <map_address2+0x5d>
	pte_t *victim = select_a_victim(pgdir);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	56                   	push   %esi
80105eb4:	e8 b7 10 00 00       	call   80106f70 <select_a_victim>
	swap_page_from_pte(victim);
80105eb9:	89 04 24             	mov    %eax,(%esp)
80105ebc:	e8 2f fe ff ff       	call   80105cf0 <swap_page_from_pte>
			allocuvm(pgdir,addr,addr + PGSIZE);
80105ec1:	83 c4 0c             	add    $0xc,%esp
80105ec4:	57                   	push   %edi
80105ec5:	53                   	push   %ebx
80105ec6:	56                   	push   %esi
80105ec7:	e8 54 12 00 00       	call   80107120 <allocuvm>
80105ecc:	83 c4 10             	add    $0x10,%esp
}
80105ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed2:	5b                   	pop    %ebx
80105ed3:	5e                   	pop    %esi
80105ed4:	5f                   	pop    %edi
80105ed5:	5d                   	pop    %ebp
80105ed6:	c3                   	ret    
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax
	pte_t *victim = select_a_victim(pgdir);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	56                   	push   %esi
80105ee4:	e8 87 10 00 00       	call   80106f70 <select_a_victim>
	swap_page_from_pte(victim);
80105ee9:	89 04 24             	mov    %eax,(%esp)
80105eec:	e8 ff fd ff ff       	call   80105cf0 <swap_page_from_pte>
			addr = kalloc();
80105ef1:	e8 fa c8 ff ff       	call   801027f0 <kalloc>
80105ef6:	83 c4 10             	add    $0x10,%esp
80105ef9:	e9 75 ff ff ff       	jmp    80105e73 <map_address2+0x43>
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <uartgetc>:
80105f00:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105f05:	55                   	push   %ebp
80105f06:	89 e5                	mov    %esp,%ebp
80105f08:	85 c0                	test   %eax,%eax
80105f0a:	74 1c                	je     80105f28 <uartgetc+0x28>
80105f0c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f11:	ec                   	in     (%dx),%al
80105f12:	a8 01                	test   $0x1,%al
80105f14:	74 12                	je     80105f28 <uartgetc+0x28>
80105f16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1b:	ec                   	in     (%dx),%al
80105f1c:	0f b6 c0             	movzbl %al,%eax
80105f1f:	5d                   	pop    %ebp
80105f20:	c3                   	ret    
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2d:	5d                   	pop    %ebp
80105f2e:	c3                   	ret    
80105f2f:	90                   	nop

80105f30 <uartputc.part.0>:
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	57                   	push   %edi
80105f34:	56                   	push   %esi
80105f35:	53                   	push   %ebx
80105f36:	89 c7                	mov    %eax,%edi
80105f38:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f42:	83 ec 0c             	sub    $0xc,%esp
80105f45:	eb 1b                	jmp    80105f62 <uartputc.part.0+0x32>
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	6a 0a                	push   $0xa
80105f55:	e8 46 cb ff ff       	call   80102aa0 <microdelay>
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	83 eb 01             	sub    $0x1,%ebx
80105f60:	74 07                	je     80105f69 <uartputc.part.0+0x39>
80105f62:	89 f2                	mov    %esi,%edx
80105f64:	ec                   	in     (%dx),%al
80105f65:	a8 20                	test   $0x20,%al
80105f67:	74 e7                	je     80105f50 <uartputc.part.0+0x20>
80105f69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f6e:	89 f8                	mov    %edi,%eax
80105f70:	ee                   	out    %al,(%dx)
80105f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f74:	5b                   	pop    %ebx
80105f75:	5e                   	pop    %esi
80105f76:	5f                   	pop    %edi
80105f77:	5d                   	pop    %ebp
80105f78:	c3                   	ret    
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <uartinit>:
80105f80:	55                   	push   %ebp
80105f81:	31 c9                	xor    %ecx,%ecx
80105f83:	89 c8                	mov    %ecx,%eax
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	57                   	push   %edi
80105f88:	56                   	push   %esi
80105f89:	53                   	push   %ebx
80105f8a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f8f:	89 da                	mov    %ebx,%edx
80105f91:	83 ec 0c             	sub    $0xc,%esp
80105f94:	ee                   	out    %al,(%dx)
80105f95:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f9f:	89 fa                	mov    %edi,%edx
80105fa1:	ee                   	out    %al,(%dx)
80105fa2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fa7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fac:	ee                   	out    %al,(%dx)
80105fad:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fb2:	89 c8                	mov    %ecx,%eax
80105fb4:	89 f2                	mov    %esi,%edx
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fbc:	89 fa                	mov    %edi,%edx
80105fbe:	ee                   	out    %al,(%dx)
80105fbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fc4:	89 c8                	mov    %ecx,%eax
80105fc6:	ee                   	out    %al,(%dx)
80105fc7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fcc:	89 f2                	mov    %esi,%edx
80105fce:	ee                   	out    %al,(%dx)
80105fcf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fd4:	ec                   	in     (%dx),%al
80105fd5:	3c ff                	cmp    $0xff,%al
80105fd7:	74 5a                	je     80106033 <uartinit+0xb3>
80105fd9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105fe0:	00 00 00 
80105fe3:	89 da                	mov    %ebx,%edx
80105fe5:	ec                   	in     (%dx),%al
80105fe6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105feb:	ec                   	in     (%dx),%al
80105fec:	83 ec 08             	sub    $0x8,%esp
80105fef:	bb f0 7e 10 80       	mov    $0x80107ef0,%ebx
80105ff4:	6a 00                	push   $0x0
80105ff6:	6a 04                	push   $0x4
80105ff8:	e8 d3 c5 ff ff       	call   801025d0 <ioapicenable>
80105ffd:	83 c4 10             	add    $0x10,%esp
80106000:	b8 78 00 00 00       	mov    $0x78,%eax
80106005:	eb 13                	jmp    8010601a <uartinit+0x9a>
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106010:	83 c3 01             	add    $0x1,%ebx
80106013:	0f be 03             	movsbl (%ebx),%eax
80106016:	84 c0                	test   %al,%al
80106018:	74 19                	je     80106033 <uartinit+0xb3>
8010601a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106020:	85 d2                	test   %edx,%edx
80106022:	74 ec                	je     80106010 <uartinit+0x90>
80106024:	83 c3 01             	add    $0x1,%ebx
80106027:	e8 04 ff ff ff       	call   80105f30 <uartputc.part.0>
8010602c:	0f be 03             	movsbl (%ebx),%eax
8010602f:	84 c0                	test   %al,%al
80106031:	75 e7                	jne    8010601a <uartinit+0x9a>
80106033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106036:	5b                   	pop    %ebx
80106037:	5e                   	pop    %esi
80106038:	5f                   	pop    %edi
80106039:	5d                   	pop    %ebp
8010603a:	c3                   	ret    
8010603b:	90                   	nop
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106040 <uartputc>:
80106040:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106046:	55                   	push   %ebp
80106047:	89 e5                	mov    %esp,%ebp
80106049:	85 d2                	test   %edx,%edx
8010604b:	8b 45 08             	mov    0x8(%ebp),%eax
8010604e:	74 10                	je     80106060 <uartputc+0x20>
80106050:	5d                   	pop    %ebp
80106051:	e9 da fe ff ff       	jmp    80105f30 <uartputc.part.0>
80106056:	8d 76 00             	lea    0x0(%esi),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106060:	5d                   	pop    %ebp
80106061:	c3                   	ret    
80106062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106070 <uartintr>:
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 14             	sub    $0x14,%esp
80106076:	68 00 5f 10 80       	push   $0x80105f00
8010607b:	e8 a0 a8 ff ff       	call   80100920 <consoleintr>
80106080:	83 c4 10             	add    $0x10,%esp
80106083:	c9                   	leave  
80106084:	c3                   	ret    

80106085 <vector0>:
80106085:	6a 00                	push   $0x0
80106087:	6a 00                	push   $0x0
80106089:	e9 1c f9 ff ff       	jmp    801059aa <alltraps>

8010608e <vector1>:
8010608e:	6a 00                	push   $0x0
80106090:	6a 01                	push   $0x1
80106092:	e9 13 f9 ff ff       	jmp    801059aa <alltraps>

80106097 <vector2>:
80106097:	6a 00                	push   $0x0
80106099:	6a 02                	push   $0x2
8010609b:	e9 0a f9 ff ff       	jmp    801059aa <alltraps>

801060a0 <vector3>:
801060a0:	6a 00                	push   $0x0
801060a2:	6a 03                	push   $0x3
801060a4:	e9 01 f9 ff ff       	jmp    801059aa <alltraps>

801060a9 <vector4>:
801060a9:	6a 00                	push   $0x0
801060ab:	6a 04                	push   $0x4
801060ad:	e9 f8 f8 ff ff       	jmp    801059aa <alltraps>

801060b2 <vector5>:
801060b2:	6a 00                	push   $0x0
801060b4:	6a 05                	push   $0x5
801060b6:	e9 ef f8 ff ff       	jmp    801059aa <alltraps>

801060bb <vector6>:
801060bb:	6a 00                	push   $0x0
801060bd:	6a 06                	push   $0x6
801060bf:	e9 e6 f8 ff ff       	jmp    801059aa <alltraps>

801060c4 <vector7>:
801060c4:	6a 00                	push   $0x0
801060c6:	6a 07                	push   $0x7
801060c8:	e9 dd f8 ff ff       	jmp    801059aa <alltraps>

801060cd <vector8>:
801060cd:	6a 08                	push   $0x8
801060cf:	e9 d6 f8 ff ff       	jmp    801059aa <alltraps>

801060d4 <vector9>:
801060d4:	6a 00                	push   $0x0
801060d6:	6a 09                	push   $0x9
801060d8:	e9 cd f8 ff ff       	jmp    801059aa <alltraps>

801060dd <vector10>:
801060dd:	6a 0a                	push   $0xa
801060df:	e9 c6 f8 ff ff       	jmp    801059aa <alltraps>

801060e4 <vector11>:
801060e4:	6a 0b                	push   $0xb
801060e6:	e9 bf f8 ff ff       	jmp    801059aa <alltraps>

801060eb <vector12>:
801060eb:	6a 0c                	push   $0xc
801060ed:	e9 b8 f8 ff ff       	jmp    801059aa <alltraps>

801060f2 <vector13>:
801060f2:	6a 0d                	push   $0xd
801060f4:	e9 b1 f8 ff ff       	jmp    801059aa <alltraps>

801060f9 <vector14>:
801060f9:	6a 0e                	push   $0xe
801060fb:	e9 aa f8 ff ff       	jmp    801059aa <alltraps>

80106100 <vector15>:
80106100:	6a 00                	push   $0x0
80106102:	6a 0f                	push   $0xf
80106104:	e9 a1 f8 ff ff       	jmp    801059aa <alltraps>

80106109 <vector16>:
80106109:	6a 00                	push   $0x0
8010610b:	6a 10                	push   $0x10
8010610d:	e9 98 f8 ff ff       	jmp    801059aa <alltraps>

80106112 <vector17>:
80106112:	6a 11                	push   $0x11
80106114:	e9 91 f8 ff ff       	jmp    801059aa <alltraps>

80106119 <vector18>:
80106119:	6a 00                	push   $0x0
8010611b:	6a 12                	push   $0x12
8010611d:	e9 88 f8 ff ff       	jmp    801059aa <alltraps>

80106122 <vector19>:
80106122:	6a 00                	push   $0x0
80106124:	6a 13                	push   $0x13
80106126:	e9 7f f8 ff ff       	jmp    801059aa <alltraps>

8010612b <vector20>:
8010612b:	6a 00                	push   $0x0
8010612d:	6a 14                	push   $0x14
8010612f:	e9 76 f8 ff ff       	jmp    801059aa <alltraps>

80106134 <vector21>:
80106134:	6a 00                	push   $0x0
80106136:	6a 15                	push   $0x15
80106138:	e9 6d f8 ff ff       	jmp    801059aa <alltraps>

8010613d <vector22>:
8010613d:	6a 00                	push   $0x0
8010613f:	6a 16                	push   $0x16
80106141:	e9 64 f8 ff ff       	jmp    801059aa <alltraps>

80106146 <vector23>:
80106146:	6a 00                	push   $0x0
80106148:	6a 17                	push   $0x17
8010614a:	e9 5b f8 ff ff       	jmp    801059aa <alltraps>

8010614f <vector24>:
8010614f:	6a 00                	push   $0x0
80106151:	6a 18                	push   $0x18
80106153:	e9 52 f8 ff ff       	jmp    801059aa <alltraps>

80106158 <vector25>:
80106158:	6a 00                	push   $0x0
8010615a:	6a 19                	push   $0x19
8010615c:	e9 49 f8 ff ff       	jmp    801059aa <alltraps>

80106161 <vector26>:
80106161:	6a 00                	push   $0x0
80106163:	6a 1a                	push   $0x1a
80106165:	e9 40 f8 ff ff       	jmp    801059aa <alltraps>

8010616a <vector27>:
8010616a:	6a 00                	push   $0x0
8010616c:	6a 1b                	push   $0x1b
8010616e:	e9 37 f8 ff ff       	jmp    801059aa <alltraps>

80106173 <vector28>:
80106173:	6a 00                	push   $0x0
80106175:	6a 1c                	push   $0x1c
80106177:	e9 2e f8 ff ff       	jmp    801059aa <alltraps>

8010617c <vector29>:
8010617c:	6a 00                	push   $0x0
8010617e:	6a 1d                	push   $0x1d
80106180:	e9 25 f8 ff ff       	jmp    801059aa <alltraps>

80106185 <vector30>:
80106185:	6a 00                	push   $0x0
80106187:	6a 1e                	push   $0x1e
80106189:	e9 1c f8 ff ff       	jmp    801059aa <alltraps>

8010618e <vector31>:
8010618e:	6a 00                	push   $0x0
80106190:	6a 1f                	push   $0x1f
80106192:	e9 13 f8 ff ff       	jmp    801059aa <alltraps>

80106197 <vector32>:
80106197:	6a 00                	push   $0x0
80106199:	6a 20                	push   $0x20
8010619b:	e9 0a f8 ff ff       	jmp    801059aa <alltraps>

801061a0 <vector33>:
801061a0:	6a 00                	push   $0x0
801061a2:	6a 21                	push   $0x21
801061a4:	e9 01 f8 ff ff       	jmp    801059aa <alltraps>

801061a9 <vector34>:
801061a9:	6a 00                	push   $0x0
801061ab:	6a 22                	push   $0x22
801061ad:	e9 f8 f7 ff ff       	jmp    801059aa <alltraps>

801061b2 <vector35>:
801061b2:	6a 00                	push   $0x0
801061b4:	6a 23                	push   $0x23
801061b6:	e9 ef f7 ff ff       	jmp    801059aa <alltraps>

801061bb <vector36>:
801061bb:	6a 00                	push   $0x0
801061bd:	6a 24                	push   $0x24
801061bf:	e9 e6 f7 ff ff       	jmp    801059aa <alltraps>

801061c4 <vector37>:
801061c4:	6a 00                	push   $0x0
801061c6:	6a 25                	push   $0x25
801061c8:	e9 dd f7 ff ff       	jmp    801059aa <alltraps>

801061cd <vector38>:
801061cd:	6a 00                	push   $0x0
801061cf:	6a 26                	push   $0x26
801061d1:	e9 d4 f7 ff ff       	jmp    801059aa <alltraps>

801061d6 <vector39>:
801061d6:	6a 00                	push   $0x0
801061d8:	6a 27                	push   $0x27
801061da:	e9 cb f7 ff ff       	jmp    801059aa <alltraps>

801061df <vector40>:
801061df:	6a 00                	push   $0x0
801061e1:	6a 28                	push   $0x28
801061e3:	e9 c2 f7 ff ff       	jmp    801059aa <alltraps>

801061e8 <vector41>:
801061e8:	6a 00                	push   $0x0
801061ea:	6a 29                	push   $0x29
801061ec:	e9 b9 f7 ff ff       	jmp    801059aa <alltraps>

801061f1 <vector42>:
801061f1:	6a 00                	push   $0x0
801061f3:	6a 2a                	push   $0x2a
801061f5:	e9 b0 f7 ff ff       	jmp    801059aa <alltraps>

801061fa <vector43>:
801061fa:	6a 00                	push   $0x0
801061fc:	6a 2b                	push   $0x2b
801061fe:	e9 a7 f7 ff ff       	jmp    801059aa <alltraps>

80106203 <vector44>:
80106203:	6a 00                	push   $0x0
80106205:	6a 2c                	push   $0x2c
80106207:	e9 9e f7 ff ff       	jmp    801059aa <alltraps>

8010620c <vector45>:
8010620c:	6a 00                	push   $0x0
8010620e:	6a 2d                	push   $0x2d
80106210:	e9 95 f7 ff ff       	jmp    801059aa <alltraps>

80106215 <vector46>:
80106215:	6a 00                	push   $0x0
80106217:	6a 2e                	push   $0x2e
80106219:	e9 8c f7 ff ff       	jmp    801059aa <alltraps>

8010621e <vector47>:
8010621e:	6a 00                	push   $0x0
80106220:	6a 2f                	push   $0x2f
80106222:	e9 83 f7 ff ff       	jmp    801059aa <alltraps>

80106227 <vector48>:
80106227:	6a 00                	push   $0x0
80106229:	6a 30                	push   $0x30
8010622b:	e9 7a f7 ff ff       	jmp    801059aa <alltraps>

80106230 <vector49>:
80106230:	6a 00                	push   $0x0
80106232:	6a 31                	push   $0x31
80106234:	e9 71 f7 ff ff       	jmp    801059aa <alltraps>

80106239 <vector50>:
80106239:	6a 00                	push   $0x0
8010623b:	6a 32                	push   $0x32
8010623d:	e9 68 f7 ff ff       	jmp    801059aa <alltraps>

80106242 <vector51>:
80106242:	6a 00                	push   $0x0
80106244:	6a 33                	push   $0x33
80106246:	e9 5f f7 ff ff       	jmp    801059aa <alltraps>

8010624b <vector52>:
8010624b:	6a 00                	push   $0x0
8010624d:	6a 34                	push   $0x34
8010624f:	e9 56 f7 ff ff       	jmp    801059aa <alltraps>

80106254 <vector53>:
80106254:	6a 00                	push   $0x0
80106256:	6a 35                	push   $0x35
80106258:	e9 4d f7 ff ff       	jmp    801059aa <alltraps>

8010625d <vector54>:
8010625d:	6a 00                	push   $0x0
8010625f:	6a 36                	push   $0x36
80106261:	e9 44 f7 ff ff       	jmp    801059aa <alltraps>

80106266 <vector55>:
80106266:	6a 00                	push   $0x0
80106268:	6a 37                	push   $0x37
8010626a:	e9 3b f7 ff ff       	jmp    801059aa <alltraps>

8010626f <vector56>:
8010626f:	6a 00                	push   $0x0
80106271:	6a 38                	push   $0x38
80106273:	e9 32 f7 ff ff       	jmp    801059aa <alltraps>

80106278 <vector57>:
80106278:	6a 00                	push   $0x0
8010627a:	6a 39                	push   $0x39
8010627c:	e9 29 f7 ff ff       	jmp    801059aa <alltraps>

80106281 <vector58>:
80106281:	6a 00                	push   $0x0
80106283:	6a 3a                	push   $0x3a
80106285:	e9 20 f7 ff ff       	jmp    801059aa <alltraps>

8010628a <vector59>:
8010628a:	6a 00                	push   $0x0
8010628c:	6a 3b                	push   $0x3b
8010628e:	e9 17 f7 ff ff       	jmp    801059aa <alltraps>

80106293 <vector60>:
80106293:	6a 00                	push   $0x0
80106295:	6a 3c                	push   $0x3c
80106297:	e9 0e f7 ff ff       	jmp    801059aa <alltraps>

8010629c <vector61>:
8010629c:	6a 00                	push   $0x0
8010629e:	6a 3d                	push   $0x3d
801062a0:	e9 05 f7 ff ff       	jmp    801059aa <alltraps>

801062a5 <vector62>:
801062a5:	6a 00                	push   $0x0
801062a7:	6a 3e                	push   $0x3e
801062a9:	e9 fc f6 ff ff       	jmp    801059aa <alltraps>

801062ae <vector63>:
801062ae:	6a 00                	push   $0x0
801062b0:	6a 3f                	push   $0x3f
801062b2:	e9 f3 f6 ff ff       	jmp    801059aa <alltraps>

801062b7 <vector64>:
801062b7:	6a 00                	push   $0x0
801062b9:	6a 40                	push   $0x40
801062bb:	e9 ea f6 ff ff       	jmp    801059aa <alltraps>

801062c0 <vector65>:
801062c0:	6a 00                	push   $0x0
801062c2:	6a 41                	push   $0x41
801062c4:	e9 e1 f6 ff ff       	jmp    801059aa <alltraps>

801062c9 <vector66>:
801062c9:	6a 00                	push   $0x0
801062cb:	6a 42                	push   $0x42
801062cd:	e9 d8 f6 ff ff       	jmp    801059aa <alltraps>

801062d2 <vector67>:
801062d2:	6a 00                	push   $0x0
801062d4:	6a 43                	push   $0x43
801062d6:	e9 cf f6 ff ff       	jmp    801059aa <alltraps>

801062db <vector68>:
801062db:	6a 00                	push   $0x0
801062dd:	6a 44                	push   $0x44
801062df:	e9 c6 f6 ff ff       	jmp    801059aa <alltraps>

801062e4 <vector69>:
801062e4:	6a 00                	push   $0x0
801062e6:	6a 45                	push   $0x45
801062e8:	e9 bd f6 ff ff       	jmp    801059aa <alltraps>

801062ed <vector70>:
801062ed:	6a 00                	push   $0x0
801062ef:	6a 46                	push   $0x46
801062f1:	e9 b4 f6 ff ff       	jmp    801059aa <alltraps>

801062f6 <vector71>:
801062f6:	6a 00                	push   $0x0
801062f8:	6a 47                	push   $0x47
801062fa:	e9 ab f6 ff ff       	jmp    801059aa <alltraps>

801062ff <vector72>:
801062ff:	6a 00                	push   $0x0
80106301:	6a 48                	push   $0x48
80106303:	e9 a2 f6 ff ff       	jmp    801059aa <alltraps>

80106308 <vector73>:
80106308:	6a 00                	push   $0x0
8010630a:	6a 49                	push   $0x49
8010630c:	e9 99 f6 ff ff       	jmp    801059aa <alltraps>

80106311 <vector74>:
80106311:	6a 00                	push   $0x0
80106313:	6a 4a                	push   $0x4a
80106315:	e9 90 f6 ff ff       	jmp    801059aa <alltraps>

8010631a <vector75>:
8010631a:	6a 00                	push   $0x0
8010631c:	6a 4b                	push   $0x4b
8010631e:	e9 87 f6 ff ff       	jmp    801059aa <alltraps>

80106323 <vector76>:
80106323:	6a 00                	push   $0x0
80106325:	6a 4c                	push   $0x4c
80106327:	e9 7e f6 ff ff       	jmp    801059aa <alltraps>

8010632c <vector77>:
8010632c:	6a 00                	push   $0x0
8010632e:	6a 4d                	push   $0x4d
80106330:	e9 75 f6 ff ff       	jmp    801059aa <alltraps>

80106335 <vector78>:
80106335:	6a 00                	push   $0x0
80106337:	6a 4e                	push   $0x4e
80106339:	e9 6c f6 ff ff       	jmp    801059aa <alltraps>

8010633e <vector79>:
8010633e:	6a 00                	push   $0x0
80106340:	6a 4f                	push   $0x4f
80106342:	e9 63 f6 ff ff       	jmp    801059aa <alltraps>

80106347 <vector80>:
80106347:	6a 00                	push   $0x0
80106349:	6a 50                	push   $0x50
8010634b:	e9 5a f6 ff ff       	jmp    801059aa <alltraps>

80106350 <vector81>:
80106350:	6a 00                	push   $0x0
80106352:	6a 51                	push   $0x51
80106354:	e9 51 f6 ff ff       	jmp    801059aa <alltraps>

80106359 <vector82>:
80106359:	6a 00                	push   $0x0
8010635b:	6a 52                	push   $0x52
8010635d:	e9 48 f6 ff ff       	jmp    801059aa <alltraps>

80106362 <vector83>:
80106362:	6a 00                	push   $0x0
80106364:	6a 53                	push   $0x53
80106366:	e9 3f f6 ff ff       	jmp    801059aa <alltraps>

8010636b <vector84>:
8010636b:	6a 00                	push   $0x0
8010636d:	6a 54                	push   $0x54
8010636f:	e9 36 f6 ff ff       	jmp    801059aa <alltraps>

80106374 <vector85>:
80106374:	6a 00                	push   $0x0
80106376:	6a 55                	push   $0x55
80106378:	e9 2d f6 ff ff       	jmp    801059aa <alltraps>

8010637d <vector86>:
8010637d:	6a 00                	push   $0x0
8010637f:	6a 56                	push   $0x56
80106381:	e9 24 f6 ff ff       	jmp    801059aa <alltraps>

80106386 <vector87>:
80106386:	6a 00                	push   $0x0
80106388:	6a 57                	push   $0x57
8010638a:	e9 1b f6 ff ff       	jmp    801059aa <alltraps>

8010638f <vector88>:
8010638f:	6a 00                	push   $0x0
80106391:	6a 58                	push   $0x58
80106393:	e9 12 f6 ff ff       	jmp    801059aa <alltraps>

80106398 <vector89>:
80106398:	6a 00                	push   $0x0
8010639a:	6a 59                	push   $0x59
8010639c:	e9 09 f6 ff ff       	jmp    801059aa <alltraps>

801063a1 <vector90>:
801063a1:	6a 00                	push   $0x0
801063a3:	6a 5a                	push   $0x5a
801063a5:	e9 00 f6 ff ff       	jmp    801059aa <alltraps>

801063aa <vector91>:
801063aa:	6a 00                	push   $0x0
801063ac:	6a 5b                	push   $0x5b
801063ae:	e9 f7 f5 ff ff       	jmp    801059aa <alltraps>

801063b3 <vector92>:
801063b3:	6a 00                	push   $0x0
801063b5:	6a 5c                	push   $0x5c
801063b7:	e9 ee f5 ff ff       	jmp    801059aa <alltraps>

801063bc <vector93>:
801063bc:	6a 00                	push   $0x0
801063be:	6a 5d                	push   $0x5d
801063c0:	e9 e5 f5 ff ff       	jmp    801059aa <alltraps>

801063c5 <vector94>:
801063c5:	6a 00                	push   $0x0
801063c7:	6a 5e                	push   $0x5e
801063c9:	e9 dc f5 ff ff       	jmp    801059aa <alltraps>

801063ce <vector95>:
801063ce:	6a 00                	push   $0x0
801063d0:	6a 5f                	push   $0x5f
801063d2:	e9 d3 f5 ff ff       	jmp    801059aa <alltraps>

801063d7 <vector96>:
801063d7:	6a 00                	push   $0x0
801063d9:	6a 60                	push   $0x60
801063db:	e9 ca f5 ff ff       	jmp    801059aa <alltraps>

801063e0 <vector97>:
801063e0:	6a 00                	push   $0x0
801063e2:	6a 61                	push   $0x61
801063e4:	e9 c1 f5 ff ff       	jmp    801059aa <alltraps>

801063e9 <vector98>:
801063e9:	6a 00                	push   $0x0
801063eb:	6a 62                	push   $0x62
801063ed:	e9 b8 f5 ff ff       	jmp    801059aa <alltraps>

801063f2 <vector99>:
801063f2:	6a 00                	push   $0x0
801063f4:	6a 63                	push   $0x63
801063f6:	e9 af f5 ff ff       	jmp    801059aa <alltraps>

801063fb <vector100>:
801063fb:	6a 00                	push   $0x0
801063fd:	6a 64                	push   $0x64
801063ff:	e9 a6 f5 ff ff       	jmp    801059aa <alltraps>

80106404 <vector101>:
80106404:	6a 00                	push   $0x0
80106406:	6a 65                	push   $0x65
80106408:	e9 9d f5 ff ff       	jmp    801059aa <alltraps>

8010640d <vector102>:
8010640d:	6a 00                	push   $0x0
8010640f:	6a 66                	push   $0x66
80106411:	e9 94 f5 ff ff       	jmp    801059aa <alltraps>

80106416 <vector103>:
80106416:	6a 00                	push   $0x0
80106418:	6a 67                	push   $0x67
8010641a:	e9 8b f5 ff ff       	jmp    801059aa <alltraps>

8010641f <vector104>:
8010641f:	6a 00                	push   $0x0
80106421:	6a 68                	push   $0x68
80106423:	e9 82 f5 ff ff       	jmp    801059aa <alltraps>

80106428 <vector105>:
80106428:	6a 00                	push   $0x0
8010642a:	6a 69                	push   $0x69
8010642c:	e9 79 f5 ff ff       	jmp    801059aa <alltraps>

80106431 <vector106>:
80106431:	6a 00                	push   $0x0
80106433:	6a 6a                	push   $0x6a
80106435:	e9 70 f5 ff ff       	jmp    801059aa <alltraps>

8010643a <vector107>:
8010643a:	6a 00                	push   $0x0
8010643c:	6a 6b                	push   $0x6b
8010643e:	e9 67 f5 ff ff       	jmp    801059aa <alltraps>

80106443 <vector108>:
80106443:	6a 00                	push   $0x0
80106445:	6a 6c                	push   $0x6c
80106447:	e9 5e f5 ff ff       	jmp    801059aa <alltraps>

8010644c <vector109>:
8010644c:	6a 00                	push   $0x0
8010644e:	6a 6d                	push   $0x6d
80106450:	e9 55 f5 ff ff       	jmp    801059aa <alltraps>

80106455 <vector110>:
80106455:	6a 00                	push   $0x0
80106457:	6a 6e                	push   $0x6e
80106459:	e9 4c f5 ff ff       	jmp    801059aa <alltraps>

8010645e <vector111>:
8010645e:	6a 00                	push   $0x0
80106460:	6a 6f                	push   $0x6f
80106462:	e9 43 f5 ff ff       	jmp    801059aa <alltraps>

80106467 <vector112>:
80106467:	6a 00                	push   $0x0
80106469:	6a 70                	push   $0x70
8010646b:	e9 3a f5 ff ff       	jmp    801059aa <alltraps>

80106470 <vector113>:
80106470:	6a 00                	push   $0x0
80106472:	6a 71                	push   $0x71
80106474:	e9 31 f5 ff ff       	jmp    801059aa <alltraps>

80106479 <vector114>:
80106479:	6a 00                	push   $0x0
8010647b:	6a 72                	push   $0x72
8010647d:	e9 28 f5 ff ff       	jmp    801059aa <alltraps>

80106482 <vector115>:
80106482:	6a 00                	push   $0x0
80106484:	6a 73                	push   $0x73
80106486:	e9 1f f5 ff ff       	jmp    801059aa <alltraps>

8010648b <vector116>:
8010648b:	6a 00                	push   $0x0
8010648d:	6a 74                	push   $0x74
8010648f:	e9 16 f5 ff ff       	jmp    801059aa <alltraps>

80106494 <vector117>:
80106494:	6a 00                	push   $0x0
80106496:	6a 75                	push   $0x75
80106498:	e9 0d f5 ff ff       	jmp    801059aa <alltraps>

8010649d <vector118>:
8010649d:	6a 00                	push   $0x0
8010649f:	6a 76                	push   $0x76
801064a1:	e9 04 f5 ff ff       	jmp    801059aa <alltraps>

801064a6 <vector119>:
801064a6:	6a 00                	push   $0x0
801064a8:	6a 77                	push   $0x77
801064aa:	e9 fb f4 ff ff       	jmp    801059aa <alltraps>

801064af <vector120>:
801064af:	6a 00                	push   $0x0
801064b1:	6a 78                	push   $0x78
801064b3:	e9 f2 f4 ff ff       	jmp    801059aa <alltraps>

801064b8 <vector121>:
801064b8:	6a 00                	push   $0x0
801064ba:	6a 79                	push   $0x79
801064bc:	e9 e9 f4 ff ff       	jmp    801059aa <alltraps>

801064c1 <vector122>:
801064c1:	6a 00                	push   $0x0
801064c3:	6a 7a                	push   $0x7a
801064c5:	e9 e0 f4 ff ff       	jmp    801059aa <alltraps>

801064ca <vector123>:
801064ca:	6a 00                	push   $0x0
801064cc:	6a 7b                	push   $0x7b
801064ce:	e9 d7 f4 ff ff       	jmp    801059aa <alltraps>

801064d3 <vector124>:
801064d3:	6a 00                	push   $0x0
801064d5:	6a 7c                	push   $0x7c
801064d7:	e9 ce f4 ff ff       	jmp    801059aa <alltraps>

801064dc <vector125>:
801064dc:	6a 00                	push   $0x0
801064de:	6a 7d                	push   $0x7d
801064e0:	e9 c5 f4 ff ff       	jmp    801059aa <alltraps>

801064e5 <vector126>:
801064e5:	6a 00                	push   $0x0
801064e7:	6a 7e                	push   $0x7e
801064e9:	e9 bc f4 ff ff       	jmp    801059aa <alltraps>

801064ee <vector127>:
801064ee:	6a 00                	push   $0x0
801064f0:	6a 7f                	push   $0x7f
801064f2:	e9 b3 f4 ff ff       	jmp    801059aa <alltraps>

801064f7 <vector128>:
801064f7:	6a 00                	push   $0x0
801064f9:	68 80 00 00 00       	push   $0x80
801064fe:	e9 a7 f4 ff ff       	jmp    801059aa <alltraps>

80106503 <vector129>:
80106503:	6a 00                	push   $0x0
80106505:	68 81 00 00 00       	push   $0x81
8010650a:	e9 9b f4 ff ff       	jmp    801059aa <alltraps>

8010650f <vector130>:
8010650f:	6a 00                	push   $0x0
80106511:	68 82 00 00 00       	push   $0x82
80106516:	e9 8f f4 ff ff       	jmp    801059aa <alltraps>

8010651b <vector131>:
8010651b:	6a 00                	push   $0x0
8010651d:	68 83 00 00 00       	push   $0x83
80106522:	e9 83 f4 ff ff       	jmp    801059aa <alltraps>

80106527 <vector132>:
80106527:	6a 00                	push   $0x0
80106529:	68 84 00 00 00       	push   $0x84
8010652e:	e9 77 f4 ff ff       	jmp    801059aa <alltraps>

80106533 <vector133>:
80106533:	6a 00                	push   $0x0
80106535:	68 85 00 00 00       	push   $0x85
8010653a:	e9 6b f4 ff ff       	jmp    801059aa <alltraps>

8010653f <vector134>:
8010653f:	6a 00                	push   $0x0
80106541:	68 86 00 00 00       	push   $0x86
80106546:	e9 5f f4 ff ff       	jmp    801059aa <alltraps>

8010654b <vector135>:
8010654b:	6a 00                	push   $0x0
8010654d:	68 87 00 00 00       	push   $0x87
80106552:	e9 53 f4 ff ff       	jmp    801059aa <alltraps>

80106557 <vector136>:
80106557:	6a 00                	push   $0x0
80106559:	68 88 00 00 00       	push   $0x88
8010655e:	e9 47 f4 ff ff       	jmp    801059aa <alltraps>

80106563 <vector137>:
80106563:	6a 00                	push   $0x0
80106565:	68 89 00 00 00       	push   $0x89
8010656a:	e9 3b f4 ff ff       	jmp    801059aa <alltraps>

8010656f <vector138>:
8010656f:	6a 00                	push   $0x0
80106571:	68 8a 00 00 00       	push   $0x8a
80106576:	e9 2f f4 ff ff       	jmp    801059aa <alltraps>

8010657b <vector139>:
8010657b:	6a 00                	push   $0x0
8010657d:	68 8b 00 00 00       	push   $0x8b
80106582:	e9 23 f4 ff ff       	jmp    801059aa <alltraps>

80106587 <vector140>:
80106587:	6a 00                	push   $0x0
80106589:	68 8c 00 00 00       	push   $0x8c
8010658e:	e9 17 f4 ff ff       	jmp    801059aa <alltraps>

80106593 <vector141>:
80106593:	6a 00                	push   $0x0
80106595:	68 8d 00 00 00       	push   $0x8d
8010659a:	e9 0b f4 ff ff       	jmp    801059aa <alltraps>

8010659f <vector142>:
8010659f:	6a 00                	push   $0x0
801065a1:	68 8e 00 00 00       	push   $0x8e
801065a6:	e9 ff f3 ff ff       	jmp    801059aa <alltraps>

801065ab <vector143>:
801065ab:	6a 00                	push   $0x0
801065ad:	68 8f 00 00 00       	push   $0x8f
801065b2:	e9 f3 f3 ff ff       	jmp    801059aa <alltraps>

801065b7 <vector144>:
801065b7:	6a 00                	push   $0x0
801065b9:	68 90 00 00 00       	push   $0x90
801065be:	e9 e7 f3 ff ff       	jmp    801059aa <alltraps>

801065c3 <vector145>:
801065c3:	6a 00                	push   $0x0
801065c5:	68 91 00 00 00       	push   $0x91
801065ca:	e9 db f3 ff ff       	jmp    801059aa <alltraps>

801065cf <vector146>:
801065cf:	6a 00                	push   $0x0
801065d1:	68 92 00 00 00       	push   $0x92
801065d6:	e9 cf f3 ff ff       	jmp    801059aa <alltraps>

801065db <vector147>:
801065db:	6a 00                	push   $0x0
801065dd:	68 93 00 00 00       	push   $0x93
801065e2:	e9 c3 f3 ff ff       	jmp    801059aa <alltraps>

801065e7 <vector148>:
801065e7:	6a 00                	push   $0x0
801065e9:	68 94 00 00 00       	push   $0x94
801065ee:	e9 b7 f3 ff ff       	jmp    801059aa <alltraps>

801065f3 <vector149>:
801065f3:	6a 00                	push   $0x0
801065f5:	68 95 00 00 00       	push   $0x95
801065fa:	e9 ab f3 ff ff       	jmp    801059aa <alltraps>

801065ff <vector150>:
801065ff:	6a 00                	push   $0x0
80106601:	68 96 00 00 00       	push   $0x96
80106606:	e9 9f f3 ff ff       	jmp    801059aa <alltraps>

8010660b <vector151>:
8010660b:	6a 00                	push   $0x0
8010660d:	68 97 00 00 00       	push   $0x97
80106612:	e9 93 f3 ff ff       	jmp    801059aa <alltraps>

80106617 <vector152>:
80106617:	6a 00                	push   $0x0
80106619:	68 98 00 00 00       	push   $0x98
8010661e:	e9 87 f3 ff ff       	jmp    801059aa <alltraps>

80106623 <vector153>:
80106623:	6a 00                	push   $0x0
80106625:	68 99 00 00 00       	push   $0x99
8010662a:	e9 7b f3 ff ff       	jmp    801059aa <alltraps>

8010662f <vector154>:
8010662f:	6a 00                	push   $0x0
80106631:	68 9a 00 00 00       	push   $0x9a
80106636:	e9 6f f3 ff ff       	jmp    801059aa <alltraps>

8010663b <vector155>:
8010663b:	6a 00                	push   $0x0
8010663d:	68 9b 00 00 00       	push   $0x9b
80106642:	e9 63 f3 ff ff       	jmp    801059aa <alltraps>

80106647 <vector156>:
80106647:	6a 00                	push   $0x0
80106649:	68 9c 00 00 00       	push   $0x9c
8010664e:	e9 57 f3 ff ff       	jmp    801059aa <alltraps>

80106653 <vector157>:
80106653:	6a 00                	push   $0x0
80106655:	68 9d 00 00 00       	push   $0x9d
8010665a:	e9 4b f3 ff ff       	jmp    801059aa <alltraps>

8010665f <vector158>:
8010665f:	6a 00                	push   $0x0
80106661:	68 9e 00 00 00       	push   $0x9e
80106666:	e9 3f f3 ff ff       	jmp    801059aa <alltraps>

8010666b <vector159>:
8010666b:	6a 00                	push   $0x0
8010666d:	68 9f 00 00 00       	push   $0x9f
80106672:	e9 33 f3 ff ff       	jmp    801059aa <alltraps>

80106677 <vector160>:
80106677:	6a 00                	push   $0x0
80106679:	68 a0 00 00 00       	push   $0xa0
8010667e:	e9 27 f3 ff ff       	jmp    801059aa <alltraps>

80106683 <vector161>:
80106683:	6a 00                	push   $0x0
80106685:	68 a1 00 00 00       	push   $0xa1
8010668a:	e9 1b f3 ff ff       	jmp    801059aa <alltraps>

8010668f <vector162>:
8010668f:	6a 00                	push   $0x0
80106691:	68 a2 00 00 00       	push   $0xa2
80106696:	e9 0f f3 ff ff       	jmp    801059aa <alltraps>

8010669b <vector163>:
8010669b:	6a 00                	push   $0x0
8010669d:	68 a3 00 00 00       	push   $0xa3
801066a2:	e9 03 f3 ff ff       	jmp    801059aa <alltraps>

801066a7 <vector164>:
801066a7:	6a 00                	push   $0x0
801066a9:	68 a4 00 00 00       	push   $0xa4
801066ae:	e9 f7 f2 ff ff       	jmp    801059aa <alltraps>

801066b3 <vector165>:
801066b3:	6a 00                	push   $0x0
801066b5:	68 a5 00 00 00       	push   $0xa5
801066ba:	e9 eb f2 ff ff       	jmp    801059aa <alltraps>

801066bf <vector166>:
801066bf:	6a 00                	push   $0x0
801066c1:	68 a6 00 00 00       	push   $0xa6
801066c6:	e9 df f2 ff ff       	jmp    801059aa <alltraps>

801066cb <vector167>:
801066cb:	6a 00                	push   $0x0
801066cd:	68 a7 00 00 00       	push   $0xa7
801066d2:	e9 d3 f2 ff ff       	jmp    801059aa <alltraps>

801066d7 <vector168>:
801066d7:	6a 00                	push   $0x0
801066d9:	68 a8 00 00 00       	push   $0xa8
801066de:	e9 c7 f2 ff ff       	jmp    801059aa <alltraps>

801066e3 <vector169>:
801066e3:	6a 00                	push   $0x0
801066e5:	68 a9 00 00 00       	push   $0xa9
801066ea:	e9 bb f2 ff ff       	jmp    801059aa <alltraps>

801066ef <vector170>:
801066ef:	6a 00                	push   $0x0
801066f1:	68 aa 00 00 00       	push   $0xaa
801066f6:	e9 af f2 ff ff       	jmp    801059aa <alltraps>

801066fb <vector171>:
801066fb:	6a 00                	push   $0x0
801066fd:	68 ab 00 00 00       	push   $0xab
80106702:	e9 a3 f2 ff ff       	jmp    801059aa <alltraps>

80106707 <vector172>:
80106707:	6a 00                	push   $0x0
80106709:	68 ac 00 00 00       	push   $0xac
8010670e:	e9 97 f2 ff ff       	jmp    801059aa <alltraps>

80106713 <vector173>:
80106713:	6a 00                	push   $0x0
80106715:	68 ad 00 00 00       	push   $0xad
8010671a:	e9 8b f2 ff ff       	jmp    801059aa <alltraps>

8010671f <vector174>:
8010671f:	6a 00                	push   $0x0
80106721:	68 ae 00 00 00       	push   $0xae
80106726:	e9 7f f2 ff ff       	jmp    801059aa <alltraps>

8010672b <vector175>:
8010672b:	6a 00                	push   $0x0
8010672d:	68 af 00 00 00       	push   $0xaf
80106732:	e9 73 f2 ff ff       	jmp    801059aa <alltraps>

80106737 <vector176>:
80106737:	6a 00                	push   $0x0
80106739:	68 b0 00 00 00       	push   $0xb0
8010673e:	e9 67 f2 ff ff       	jmp    801059aa <alltraps>

80106743 <vector177>:
80106743:	6a 00                	push   $0x0
80106745:	68 b1 00 00 00       	push   $0xb1
8010674a:	e9 5b f2 ff ff       	jmp    801059aa <alltraps>

8010674f <vector178>:
8010674f:	6a 00                	push   $0x0
80106751:	68 b2 00 00 00       	push   $0xb2
80106756:	e9 4f f2 ff ff       	jmp    801059aa <alltraps>

8010675b <vector179>:
8010675b:	6a 00                	push   $0x0
8010675d:	68 b3 00 00 00       	push   $0xb3
80106762:	e9 43 f2 ff ff       	jmp    801059aa <alltraps>

80106767 <vector180>:
80106767:	6a 00                	push   $0x0
80106769:	68 b4 00 00 00       	push   $0xb4
8010676e:	e9 37 f2 ff ff       	jmp    801059aa <alltraps>

80106773 <vector181>:
80106773:	6a 00                	push   $0x0
80106775:	68 b5 00 00 00       	push   $0xb5
8010677a:	e9 2b f2 ff ff       	jmp    801059aa <alltraps>

8010677f <vector182>:
8010677f:	6a 00                	push   $0x0
80106781:	68 b6 00 00 00       	push   $0xb6
80106786:	e9 1f f2 ff ff       	jmp    801059aa <alltraps>

8010678b <vector183>:
8010678b:	6a 00                	push   $0x0
8010678d:	68 b7 00 00 00       	push   $0xb7
80106792:	e9 13 f2 ff ff       	jmp    801059aa <alltraps>

80106797 <vector184>:
80106797:	6a 00                	push   $0x0
80106799:	68 b8 00 00 00       	push   $0xb8
8010679e:	e9 07 f2 ff ff       	jmp    801059aa <alltraps>

801067a3 <vector185>:
801067a3:	6a 00                	push   $0x0
801067a5:	68 b9 00 00 00       	push   $0xb9
801067aa:	e9 fb f1 ff ff       	jmp    801059aa <alltraps>

801067af <vector186>:
801067af:	6a 00                	push   $0x0
801067b1:	68 ba 00 00 00       	push   $0xba
801067b6:	e9 ef f1 ff ff       	jmp    801059aa <alltraps>

801067bb <vector187>:
801067bb:	6a 00                	push   $0x0
801067bd:	68 bb 00 00 00       	push   $0xbb
801067c2:	e9 e3 f1 ff ff       	jmp    801059aa <alltraps>

801067c7 <vector188>:
801067c7:	6a 00                	push   $0x0
801067c9:	68 bc 00 00 00       	push   $0xbc
801067ce:	e9 d7 f1 ff ff       	jmp    801059aa <alltraps>

801067d3 <vector189>:
801067d3:	6a 00                	push   $0x0
801067d5:	68 bd 00 00 00       	push   $0xbd
801067da:	e9 cb f1 ff ff       	jmp    801059aa <alltraps>

801067df <vector190>:
801067df:	6a 00                	push   $0x0
801067e1:	68 be 00 00 00       	push   $0xbe
801067e6:	e9 bf f1 ff ff       	jmp    801059aa <alltraps>

801067eb <vector191>:
801067eb:	6a 00                	push   $0x0
801067ed:	68 bf 00 00 00       	push   $0xbf
801067f2:	e9 b3 f1 ff ff       	jmp    801059aa <alltraps>

801067f7 <vector192>:
801067f7:	6a 00                	push   $0x0
801067f9:	68 c0 00 00 00       	push   $0xc0
801067fe:	e9 a7 f1 ff ff       	jmp    801059aa <alltraps>

80106803 <vector193>:
80106803:	6a 00                	push   $0x0
80106805:	68 c1 00 00 00       	push   $0xc1
8010680a:	e9 9b f1 ff ff       	jmp    801059aa <alltraps>

8010680f <vector194>:
8010680f:	6a 00                	push   $0x0
80106811:	68 c2 00 00 00       	push   $0xc2
80106816:	e9 8f f1 ff ff       	jmp    801059aa <alltraps>

8010681b <vector195>:
8010681b:	6a 00                	push   $0x0
8010681d:	68 c3 00 00 00       	push   $0xc3
80106822:	e9 83 f1 ff ff       	jmp    801059aa <alltraps>

80106827 <vector196>:
80106827:	6a 00                	push   $0x0
80106829:	68 c4 00 00 00       	push   $0xc4
8010682e:	e9 77 f1 ff ff       	jmp    801059aa <alltraps>

80106833 <vector197>:
80106833:	6a 00                	push   $0x0
80106835:	68 c5 00 00 00       	push   $0xc5
8010683a:	e9 6b f1 ff ff       	jmp    801059aa <alltraps>

8010683f <vector198>:
8010683f:	6a 00                	push   $0x0
80106841:	68 c6 00 00 00       	push   $0xc6
80106846:	e9 5f f1 ff ff       	jmp    801059aa <alltraps>

8010684b <vector199>:
8010684b:	6a 00                	push   $0x0
8010684d:	68 c7 00 00 00       	push   $0xc7
80106852:	e9 53 f1 ff ff       	jmp    801059aa <alltraps>

80106857 <vector200>:
80106857:	6a 00                	push   $0x0
80106859:	68 c8 00 00 00       	push   $0xc8
8010685e:	e9 47 f1 ff ff       	jmp    801059aa <alltraps>

80106863 <vector201>:
80106863:	6a 00                	push   $0x0
80106865:	68 c9 00 00 00       	push   $0xc9
8010686a:	e9 3b f1 ff ff       	jmp    801059aa <alltraps>

8010686f <vector202>:
8010686f:	6a 00                	push   $0x0
80106871:	68 ca 00 00 00       	push   $0xca
80106876:	e9 2f f1 ff ff       	jmp    801059aa <alltraps>

8010687b <vector203>:
8010687b:	6a 00                	push   $0x0
8010687d:	68 cb 00 00 00       	push   $0xcb
80106882:	e9 23 f1 ff ff       	jmp    801059aa <alltraps>

80106887 <vector204>:
80106887:	6a 00                	push   $0x0
80106889:	68 cc 00 00 00       	push   $0xcc
8010688e:	e9 17 f1 ff ff       	jmp    801059aa <alltraps>

80106893 <vector205>:
80106893:	6a 00                	push   $0x0
80106895:	68 cd 00 00 00       	push   $0xcd
8010689a:	e9 0b f1 ff ff       	jmp    801059aa <alltraps>

8010689f <vector206>:
8010689f:	6a 00                	push   $0x0
801068a1:	68 ce 00 00 00       	push   $0xce
801068a6:	e9 ff f0 ff ff       	jmp    801059aa <alltraps>

801068ab <vector207>:
801068ab:	6a 00                	push   $0x0
801068ad:	68 cf 00 00 00       	push   $0xcf
801068b2:	e9 f3 f0 ff ff       	jmp    801059aa <alltraps>

801068b7 <vector208>:
801068b7:	6a 00                	push   $0x0
801068b9:	68 d0 00 00 00       	push   $0xd0
801068be:	e9 e7 f0 ff ff       	jmp    801059aa <alltraps>

801068c3 <vector209>:
801068c3:	6a 00                	push   $0x0
801068c5:	68 d1 00 00 00       	push   $0xd1
801068ca:	e9 db f0 ff ff       	jmp    801059aa <alltraps>

801068cf <vector210>:
801068cf:	6a 00                	push   $0x0
801068d1:	68 d2 00 00 00       	push   $0xd2
801068d6:	e9 cf f0 ff ff       	jmp    801059aa <alltraps>

801068db <vector211>:
801068db:	6a 00                	push   $0x0
801068dd:	68 d3 00 00 00       	push   $0xd3
801068e2:	e9 c3 f0 ff ff       	jmp    801059aa <alltraps>

801068e7 <vector212>:
801068e7:	6a 00                	push   $0x0
801068e9:	68 d4 00 00 00       	push   $0xd4
801068ee:	e9 b7 f0 ff ff       	jmp    801059aa <alltraps>

801068f3 <vector213>:
801068f3:	6a 00                	push   $0x0
801068f5:	68 d5 00 00 00       	push   $0xd5
801068fa:	e9 ab f0 ff ff       	jmp    801059aa <alltraps>

801068ff <vector214>:
801068ff:	6a 00                	push   $0x0
80106901:	68 d6 00 00 00       	push   $0xd6
80106906:	e9 9f f0 ff ff       	jmp    801059aa <alltraps>

8010690b <vector215>:
8010690b:	6a 00                	push   $0x0
8010690d:	68 d7 00 00 00       	push   $0xd7
80106912:	e9 93 f0 ff ff       	jmp    801059aa <alltraps>

80106917 <vector216>:
80106917:	6a 00                	push   $0x0
80106919:	68 d8 00 00 00       	push   $0xd8
8010691e:	e9 87 f0 ff ff       	jmp    801059aa <alltraps>

80106923 <vector217>:
80106923:	6a 00                	push   $0x0
80106925:	68 d9 00 00 00       	push   $0xd9
8010692a:	e9 7b f0 ff ff       	jmp    801059aa <alltraps>

8010692f <vector218>:
8010692f:	6a 00                	push   $0x0
80106931:	68 da 00 00 00       	push   $0xda
80106936:	e9 6f f0 ff ff       	jmp    801059aa <alltraps>

8010693b <vector219>:
8010693b:	6a 00                	push   $0x0
8010693d:	68 db 00 00 00       	push   $0xdb
80106942:	e9 63 f0 ff ff       	jmp    801059aa <alltraps>

80106947 <vector220>:
80106947:	6a 00                	push   $0x0
80106949:	68 dc 00 00 00       	push   $0xdc
8010694e:	e9 57 f0 ff ff       	jmp    801059aa <alltraps>

80106953 <vector221>:
80106953:	6a 00                	push   $0x0
80106955:	68 dd 00 00 00       	push   $0xdd
8010695a:	e9 4b f0 ff ff       	jmp    801059aa <alltraps>

8010695f <vector222>:
8010695f:	6a 00                	push   $0x0
80106961:	68 de 00 00 00       	push   $0xde
80106966:	e9 3f f0 ff ff       	jmp    801059aa <alltraps>

8010696b <vector223>:
8010696b:	6a 00                	push   $0x0
8010696d:	68 df 00 00 00       	push   $0xdf
80106972:	e9 33 f0 ff ff       	jmp    801059aa <alltraps>

80106977 <vector224>:
80106977:	6a 00                	push   $0x0
80106979:	68 e0 00 00 00       	push   $0xe0
8010697e:	e9 27 f0 ff ff       	jmp    801059aa <alltraps>

80106983 <vector225>:
80106983:	6a 00                	push   $0x0
80106985:	68 e1 00 00 00       	push   $0xe1
8010698a:	e9 1b f0 ff ff       	jmp    801059aa <alltraps>

8010698f <vector226>:
8010698f:	6a 00                	push   $0x0
80106991:	68 e2 00 00 00       	push   $0xe2
80106996:	e9 0f f0 ff ff       	jmp    801059aa <alltraps>

8010699b <vector227>:
8010699b:	6a 00                	push   $0x0
8010699d:	68 e3 00 00 00       	push   $0xe3
801069a2:	e9 03 f0 ff ff       	jmp    801059aa <alltraps>

801069a7 <vector228>:
801069a7:	6a 00                	push   $0x0
801069a9:	68 e4 00 00 00       	push   $0xe4
801069ae:	e9 f7 ef ff ff       	jmp    801059aa <alltraps>

801069b3 <vector229>:
801069b3:	6a 00                	push   $0x0
801069b5:	68 e5 00 00 00       	push   $0xe5
801069ba:	e9 eb ef ff ff       	jmp    801059aa <alltraps>

801069bf <vector230>:
801069bf:	6a 00                	push   $0x0
801069c1:	68 e6 00 00 00       	push   $0xe6
801069c6:	e9 df ef ff ff       	jmp    801059aa <alltraps>

801069cb <vector231>:
801069cb:	6a 00                	push   $0x0
801069cd:	68 e7 00 00 00       	push   $0xe7
801069d2:	e9 d3 ef ff ff       	jmp    801059aa <alltraps>

801069d7 <vector232>:
801069d7:	6a 00                	push   $0x0
801069d9:	68 e8 00 00 00       	push   $0xe8
801069de:	e9 c7 ef ff ff       	jmp    801059aa <alltraps>

801069e3 <vector233>:
801069e3:	6a 00                	push   $0x0
801069e5:	68 e9 00 00 00       	push   $0xe9
801069ea:	e9 bb ef ff ff       	jmp    801059aa <alltraps>

801069ef <vector234>:
801069ef:	6a 00                	push   $0x0
801069f1:	68 ea 00 00 00       	push   $0xea
801069f6:	e9 af ef ff ff       	jmp    801059aa <alltraps>

801069fb <vector235>:
801069fb:	6a 00                	push   $0x0
801069fd:	68 eb 00 00 00       	push   $0xeb
80106a02:	e9 a3 ef ff ff       	jmp    801059aa <alltraps>

80106a07 <vector236>:
80106a07:	6a 00                	push   $0x0
80106a09:	68 ec 00 00 00       	push   $0xec
80106a0e:	e9 97 ef ff ff       	jmp    801059aa <alltraps>

80106a13 <vector237>:
80106a13:	6a 00                	push   $0x0
80106a15:	68 ed 00 00 00       	push   $0xed
80106a1a:	e9 8b ef ff ff       	jmp    801059aa <alltraps>

80106a1f <vector238>:
80106a1f:	6a 00                	push   $0x0
80106a21:	68 ee 00 00 00       	push   $0xee
80106a26:	e9 7f ef ff ff       	jmp    801059aa <alltraps>

80106a2b <vector239>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	68 ef 00 00 00       	push   $0xef
80106a32:	e9 73 ef ff ff       	jmp    801059aa <alltraps>

80106a37 <vector240>:
80106a37:	6a 00                	push   $0x0
80106a39:	68 f0 00 00 00       	push   $0xf0
80106a3e:	e9 67 ef ff ff       	jmp    801059aa <alltraps>

80106a43 <vector241>:
80106a43:	6a 00                	push   $0x0
80106a45:	68 f1 00 00 00       	push   $0xf1
80106a4a:	e9 5b ef ff ff       	jmp    801059aa <alltraps>

80106a4f <vector242>:
80106a4f:	6a 00                	push   $0x0
80106a51:	68 f2 00 00 00       	push   $0xf2
80106a56:	e9 4f ef ff ff       	jmp    801059aa <alltraps>

80106a5b <vector243>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	68 f3 00 00 00       	push   $0xf3
80106a62:	e9 43 ef ff ff       	jmp    801059aa <alltraps>

80106a67 <vector244>:
80106a67:	6a 00                	push   $0x0
80106a69:	68 f4 00 00 00       	push   $0xf4
80106a6e:	e9 37 ef ff ff       	jmp    801059aa <alltraps>

80106a73 <vector245>:
80106a73:	6a 00                	push   $0x0
80106a75:	68 f5 00 00 00       	push   $0xf5
80106a7a:	e9 2b ef ff ff       	jmp    801059aa <alltraps>

80106a7f <vector246>:
80106a7f:	6a 00                	push   $0x0
80106a81:	68 f6 00 00 00       	push   $0xf6
80106a86:	e9 1f ef ff ff       	jmp    801059aa <alltraps>

80106a8b <vector247>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	68 f7 00 00 00       	push   $0xf7
80106a92:	e9 13 ef ff ff       	jmp    801059aa <alltraps>

80106a97 <vector248>:
80106a97:	6a 00                	push   $0x0
80106a99:	68 f8 00 00 00       	push   $0xf8
80106a9e:	e9 07 ef ff ff       	jmp    801059aa <alltraps>

80106aa3 <vector249>:
80106aa3:	6a 00                	push   $0x0
80106aa5:	68 f9 00 00 00       	push   $0xf9
80106aaa:	e9 fb ee ff ff       	jmp    801059aa <alltraps>

80106aaf <vector250>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	68 fa 00 00 00       	push   $0xfa
80106ab6:	e9 ef ee ff ff       	jmp    801059aa <alltraps>

80106abb <vector251>:
80106abb:	6a 00                	push   $0x0
80106abd:	68 fb 00 00 00       	push   $0xfb
80106ac2:	e9 e3 ee ff ff       	jmp    801059aa <alltraps>

80106ac7 <vector252>:
80106ac7:	6a 00                	push   $0x0
80106ac9:	68 fc 00 00 00       	push   $0xfc
80106ace:	e9 d7 ee ff ff       	jmp    801059aa <alltraps>

80106ad3 <vector253>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	68 fd 00 00 00       	push   $0xfd
80106ada:	e9 cb ee ff ff       	jmp    801059aa <alltraps>

80106adf <vector254>:
80106adf:	6a 00                	push   $0x0
80106ae1:	68 fe 00 00 00       	push   $0xfe
80106ae6:	e9 bf ee ff ff       	jmp    801059aa <alltraps>

80106aeb <vector255>:
80106aeb:	6a 00                	push   $0x0
80106aed:	68 ff 00 00 00       	push   $0xff
80106af2:	e9 b3 ee ff ff       	jmp    801059aa <alltraps>
80106af7:	66 90                	xchg   %ax,%ax
80106af9:	66 90                	xchg   %ax,%ax
80106afb:	66 90                	xchg   %ax,%ax
80106afd:	66 90                	xchg   %ax,%ax
80106aff:	90                   	nop

80106b00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b07:	c1 ea 16             	shr    $0x16,%edx
{
80106b0a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106b0b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106b0e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b11:	8b 07                	mov    (%edi),%eax
80106b13:	a8 01                	test   $0x1,%al
80106b15:	74 29                	je     80106b40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b1c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx

    // cprintf("New Page allocated! \n");

    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b22:	c1 ee 0a             	shr    $0xa,%esi
}
80106b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b28:	89 f2                	mov    %esi,%edx
80106b2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b30:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b33:	5b                   	pop    %ebx
80106b34:	5e                   	pop    %esi
80106b35:	5f                   	pop    %edi
80106b36:	5d                   	pop    %ebp
80106b37:	c3                   	ret    
80106b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b40:	85 c9                	test   %ecx,%ecx
80106b42:	74 2c                	je     80106b70 <walkpgdir+0x70>
80106b44:	e8 a7 bc ff ff       	call   801027f0 <kalloc>
80106b49:	89 c3                	mov    %eax,%ebx
80106b4b:	85 c0                	test   %eax,%eax
80106b4d:	74 21                	je     80106b70 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b4f:	83 ec 04             	sub    $0x4,%esp
80106b52:	68 00 10 00 00       	push   $0x1000
80106b57:	6a 00                	push   $0x0
80106b59:	50                   	push   %eax
80106b5a:	e8 11 dc ff ff       	call   80104770 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b65:	83 c4 10             	add    $0x10,%esp
80106b68:	83 c8 07             	or     $0x7,%eax
80106b6b:	89 07                	mov    %eax,(%edi)
80106b6d:	eb b3                	jmp    80106b22 <walkpgdir+0x22>
80106b6f:	90                   	nop
}
80106b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b73:	31 c0                	xor    %eax,%eax
}
80106b75:	5b                   	pop    %ebx
80106b76:	5e                   	pop    %esi
80106b77:	5f                   	pop    %edi
80106b78:	5d                   	pop    %ebp
80106b79:	c3                   	ret    
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b85:	89 d6                	mov    %edx,%esi
{
80106b87:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b88:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106b8e:	83 ec 1c             	sub    $0x1c,%esp
80106b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b94:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b97:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ba0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ba3:	29 f7                	sub    %esi,%edi
80106ba5:	eb 23                	jmp    80106bca <mappages+0x4a>
80106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bae:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P){
80106bb0:	8b 10                	mov    (%eax),%edx
80106bb2:	f6 c2 01             	test   $0x1,%dl
80106bb5:	75 43                	jne    80106bfa <mappages+0x7a>
      cprintf("PTE Entry before panic : %x\n", *pte);
      panic("remap");

    }
    *pte = pa | perm | PTE_P;
80106bb7:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106bba:	83 cb 01             	or     $0x1,%ebx
80106bbd:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106bbf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106bc2:	74 2c                	je     80106bf0 <mappages+0x70>
      break;
    a += PGSIZE;
80106bc4:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bcd:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bd2:	89 f2                	mov    %esi,%edx
80106bd4:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106bd7:	e8 24 ff ff ff       	call   80106b00 <walkpgdir>
80106bdc:	85 c0                	test   %eax,%eax
80106bde:	75 d0                	jne    80106bb0 <mappages+0x30>
    pa += PGSIZE;
  }

  return 0;
}
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106be8:	5b                   	pop    %ebx
80106be9:	5e                   	pop    %esi
80106bea:	5f                   	pop    %edi
80106beb:	5d                   	pop    %ebp
80106bec:	c3                   	ret    
80106bed:	8d 76 00             	lea    0x0(%esi),%esi
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bf3:	31 c0                	xor    %eax,%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
      cprintf("PTE Entry before panic : %x\n", *pte);
80106bfa:	83 ec 08             	sub    $0x8,%esp
80106bfd:	52                   	push   %edx
80106bfe:	68 f8 7e 10 80       	push   $0x80107ef8
80106c03:	e8 68 9b ff ff       	call   80100770 <cprintf>
      panic("remap");
80106c08:	c7 04 24 15 7f 10 80 	movl   $0x80107f15,(%esp)
80106c0f:	e8 8c 98 ff ff       	call   801004a0 <panic>
80106c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop

80106c20 <seginit>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c26:	e8 d5 ce ff ff       	call   80103b00 <cpuid>
  pd[0] = size-1;
80106c2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c30:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c3a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106c41:	ff 00 00 
80106c44:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106c4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c4e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106c55:	ff 00 00 
80106c58:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106c5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c62:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106c69:	ff 00 00 
80106c6c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106c73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c76:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106c7d:	ff 00 00 
80106c80:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106c87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c8a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106c8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c93:	c1 e8 10             	shr    $0x10,%eax
80106c96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c9d:	0f 01 10             	lgdtl  (%eax)
}
80106ca0:	c9                   	leave  
80106ca1:	c3                   	ret    
80106ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cb0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cb0:	a1 a4 64 11 80       	mov    0x801164a4,%eax
80106cb5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cba:	0f 22 d8             	mov    %eax,%cr3
}
80106cbd:	c3                   	ret    
80106cbe:	66 90                	xchg   %ax,%ax

80106cc0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 1c             	sub    $0x1c,%esp
80106cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106ccc:	85 db                	test   %ebx,%ebx
80106cce:	0f 84 cb 00 00 00    	je     80106d9f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106cd4:	8b 43 08             	mov    0x8(%ebx),%eax
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	0f 84 da 00 00 00    	je     80106db9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106cdf:	8b 43 04             	mov    0x4(%ebx),%eax
80106ce2:	85 c0                	test   %eax,%eax
80106ce4:	0f 84 c2 00 00 00    	je     80106dac <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106cea:	e8 c1 d8 ff ff       	call   801045b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cef:	e8 8c cd ff ff       	call   80103a80 <mycpu>
80106cf4:	89 c6                	mov    %eax,%esi
80106cf6:	e8 85 cd ff ff       	call   80103a80 <mycpu>
80106cfb:	89 c7                	mov    %eax,%edi
80106cfd:	e8 7e cd ff ff       	call   80103a80 <mycpu>
80106d02:	83 c7 08             	add    $0x8,%edi
80106d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d08:	e8 73 cd ff ff       	call   80103a80 <mycpu>
80106d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d10:	ba 67 00 00 00       	mov    $0x67,%edx
80106d15:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d1c:	83 c0 08             	add    $0x8,%eax
80106d1f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d2b:	83 c1 08             	add    $0x8,%ecx
80106d2e:	c1 e8 18             	shr    $0x18,%eax
80106d31:	c1 e9 10             	shr    $0x10,%ecx
80106d34:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106d3a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d45:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d4c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106d51:	e8 2a cd ff ff       	call   80103a80 <mycpu>
80106d56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d5d:	e8 1e cd ff ff       	call   80103a80 <mycpu>
80106d62:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d66:	8b 73 08             	mov    0x8(%ebx),%esi
80106d69:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d6f:	e8 0c cd ff ff       	call   80103a80 <mycpu>
80106d74:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d77:	e8 04 cd ff ff       	call   80103a80 <mycpu>
80106d7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d80:	b8 28 00 00 00       	mov    $0x28,%eax
80106d85:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d88:	8b 43 04             	mov    0x4(%ebx),%eax
80106d8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d90:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d96:	5b                   	pop    %ebx
80106d97:	5e                   	pop    %esi
80106d98:	5f                   	pop    %edi
80106d99:	5d                   	pop    %ebp
  popcli();
80106d9a:	e9 11 d9 ff ff       	jmp    801046b0 <popcli>
    panic("switchuvm: no process");
80106d9f:	83 ec 0c             	sub    $0xc,%esp
80106da2:	68 1b 7f 10 80       	push   $0x80107f1b
80106da7:	e8 f4 96 ff ff       	call   801004a0 <panic>
    panic("switchuvm: no pgdir");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 46 7f 10 80       	push   $0x80107f46
80106db4:	e8 e7 96 ff ff       	call   801004a0 <panic>
    panic("switchuvm: no kstack");
80106db9:	83 ec 0c             	sub    $0xc,%esp
80106dbc:	68 31 7f 10 80       	push   $0x80107f31
80106dc1:	e8 da 96 ff ff       	call   801004a0 <panic>
80106dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dcd:	8d 76 00             	lea    0x0(%esi),%esi

80106dd0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddc:	8b 75 10             	mov    0x10(%ebp),%esi
80106ddf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106de5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106deb:	77 49                	ja     80106e36 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106ded:	e8 fe b9 ff ff       	call   801027f0 <kalloc>
  memset(mem, 0, PGSIZE);
80106df2:	83 ec 04             	sub    $0x4,%esp
80106df5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106dfc:	6a 00                	push   $0x0
80106dfe:	50                   	push   %eax
80106dff:	e8 6c d9 ff ff       	call   80104770 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e04:	58                   	pop    %eax
80106e05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e0b:	5a                   	pop    %edx
80106e0c:	6a 06                	push   $0x6
80106e0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e13:	31 d2                	xor    %edx,%edx
80106e15:	50                   	push   %eax
80106e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e19:	e8 62 fd ff ff       	call   80106b80 <mappages>
  memmove(mem, init, sz);
80106e1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e21:	83 c4 10             	add    $0x10,%esp
80106e24:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2d:	5b                   	pop    %ebx
80106e2e:	5e                   	pop    %esi
80106e2f:	5f                   	pop    %edi
80106e30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e31:	e9 ea d9 ff ff       	jmp    80104820 <memmove>
    panic("inituvm: more than a page");
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	68 5a 7f 10 80       	push   $0x80107f5a
80106e3e:	e8 5d 96 ff ff       	call   801004a0 <panic>
80106e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
80106e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e5c:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106e5f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e64:	0f 85 8d 00 00 00    	jne    80106ef7 <loaduvm+0xa7>
80106e6a:	01 f0                	add    %esi,%eax
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106e6c:	89 f3                	mov    %esi,%ebx
80106e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e71:	8b 45 14             	mov    0x14(%ebp),%eax
80106e74:	01 f0                	add    %esi,%eax
80106e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e79:	85 f6                	test   %esi,%esi
80106e7b:	75 11                	jne    80106e8e <loaduvm+0x3e>
80106e7d:	eb 61                	jmp    80106ee0 <loaduvm+0x90>
80106e7f:	90                   	nop
80106e80:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e86:	89 f0                	mov    %esi,%eax
80106e88:	29 d8                	sub    %ebx,%eax
80106e8a:	39 c6                	cmp    %eax,%esi
80106e8c:	76 52                	jbe    80106ee0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e91:	8b 45 08             	mov    0x8(%ebp),%eax
80106e94:	31 c9                	xor    %ecx,%ecx
80106e96:	29 da                	sub    %ebx,%edx
80106e98:	e8 63 fc ff ff       	call   80106b00 <walkpgdir>
80106e9d:	85 c0                	test   %eax,%eax
80106e9f:	74 49                	je     80106eea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ea1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ea3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ea6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106eab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106eb0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106eb6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eb9:	29 d9                	sub    %ebx,%ecx
80106ebb:	05 00 00 00 80       	add    $0x80000000,%eax
80106ec0:	57                   	push   %edi
80106ec1:	51                   	push   %ecx
80106ec2:	50                   	push   %eax
80106ec3:	ff 75 10             	pushl  0x10(%ebp)
80106ec6:	e8 65 ad ff ff       	call   80101c30 <readi>
80106ecb:	83 c4 10             	add    $0x10,%esp
80106ece:	39 f8                	cmp    %edi,%eax
80106ed0:	74 ae                	je     80106e80 <loaduvm+0x30>
      return -1;
  }
  return 0;
}
80106ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eda:	5b                   	pop    %ebx
80106edb:	5e                   	pop    %esi
80106edc:	5f                   	pop    %edi
80106edd:	5d                   	pop    %ebp
80106ede:	c3                   	ret    
80106edf:	90                   	nop
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	68 74 7f 10 80       	push   $0x80107f74
80106ef2:	e8 a9 95 ff ff       	call   801004a0 <panic>
    panic("loaduvm: addr must be page aligned");
80106ef7:	83 ec 0c             	sub    $0xc,%esp
80106efa:	68 f8 7f 10 80       	push   $0x80107ff8
80106eff:	e8 9c 95 ff ff       	call   801004a0 <panic>
80106f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop

80106f10 <clearaccessbit>:


// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{   
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
  uint i;
  int counter = 0;
80106f14:	31 ff                	xor    %edi,%edi
{   
80106f16:	56                   	push   %esi
80106f17:	53                   	push   %ebx


    // Looping until we find a valid page
    for (i = 0; i < KERNBASE ; i += PGSIZE){
80106f18:	31 db                	xor    %ebx,%ebx
{   
80106f1a:	83 ec 0c             	sub    $0xc,%esp
80106f1d:	8b 75 08             	mov    0x8(%ebp),%esi
80106f20:	eb 0e                	jmp    80106f30 <clearaccessbit+0x20>
80106f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (i = 0; i < KERNBASE ; i += PGSIZE){
80106f28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f2e:	78 2b                	js     80106f5b <clearaccessbit+0x4b>
// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
  return walkpgdir(pgdir, (void*)uva, 0);
80106f30:	31 c9                	xor    %ecx,%ecx
80106f32:	89 da                	mov    %ebx,%edx
80106f34:	89 f0                	mov    %esi,%eax
80106f36:	e8 c5 fb ff ff       	call   80106b00 <walkpgdir>
    if((ptentry!=0) && ((*ptentry & PTE_P)!=0) && ((*ptentry & PTE_SWP)==0) && ((*ptentry & PTE_U)!=0)){
80106f3b:	85 c0                	test   %eax,%eax
80106f3d:	74 e9                	je     80106f28 <clearaccessbit+0x18>
80106f3f:	8b 10                	mov    (%eax),%edx
80106f41:	89 d1                	mov    %edx,%ecx
80106f43:	81 e1 05 02 00 00    	and    $0x205,%ecx
80106f49:	83 f9 05             	cmp    $0x5,%ecx
80106f4c:	75 da                	jne    80106f28 <clearaccessbit+0x18>
      *ptentry = *ptentry & ~PTE_A;
80106f4e:	83 e2 df             	and    $0xffffffdf,%edx
      counter += 1;
80106f51:	83 c7 01             	add    $0x1,%edi
      *ptentry = *ptentry & ~PTE_A;
80106f54:	89 10                	mov    %edx,(%eax)
      if(counter > 20) {
80106f56:	83 ff 14             	cmp    $0x14,%edi
80106f59:	7e cd                	jle    80106f28 <clearaccessbit+0x18>
}
80106f5b:	83 c4 0c             	add    $0xc,%esp
80106f5e:	5b                   	pop    %ebx
80106f5f:	5e                   	pop    %esi
80106f60:	5f                   	pop    %edi
80106f61:	5d                   	pop    %ebp
80106f62:	c3                   	ret    
80106f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f70 <select_a_victim>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	56                   	push   %esi
80106f74:	53                   	push   %ebx
80106f75:	8b 75 08             	mov    0x8(%ebp),%esi
	  for (i = 0; i <KERNBASE; i += PGSIZE)
80106f78:	31 db                	xor    %ebx,%ebx
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return walkpgdir(pgdir, (void*)uva, 0);
80106f80:	31 c9                	xor    %ecx,%ecx
80106f82:	89 da                	mov    %ebx,%edx
80106f84:	89 f0                	mov    %esi,%eax
80106f86:	e8 75 fb ff ff       	call   80106b00 <walkpgdir>
        if((ptentry != 0)&& ((*ptentry & PTE_P)!=0) && ((*ptentry & PTE_SWP)==0) && ((*ptentry & PTE_A)==0) && ((*ptentry & PTE_U)!=0)){
80106f8b:	85 c0                	test   %eax,%eax
80106f8d:	74 0f                	je     80106f9e <select_a_victim+0x2e>
80106f8f:	8b 10                	mov    (%eax),%edx
80106f91:	89 d1                	mov    %edx,%ecx
80106f93:	81 e1 25 02 00 00    	and    $0x225,%ecx
80106f99:	83 f9 05             	cmp    $0x5,%ecx
80106f9c:	74 1a                	je     80106fb8 <select_a_victim+0x48>
	  for (i = 0; i <KERNBASE; i += PGSIZE)
80106f9e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fa4:	79 da                	jns    80106f80 <select_a_victim+0x10>
	      clearaccessbit(pgdir);
80106fa6:	83 ec 0c             	sub    $0xc,%esp
80106fa9:	56                   	push   %esi
80106faa:	e8 61 ff ff ff       	call   80106f10 <clearaccessbit>
80106faf:	83 c4 10             	add    $0x10,%esp
80106fb2:	eb c4                	jmp    80106f78 <select_a_victim+0x8>
80106fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          *ptentry = *ptentry | PTE_A;
80106fb8:	83 ca 20             	or     $0x20,%edx
80106fbb:	89 10                	mov    %edx,(%eax)
}
80106fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fc0:	5b                   	pop    %ebx
80106fc1:	5e                   	pop    %esi
80106fc2:	5d                   	pop    %ebp
80106fc3:	c3                   	ret    
80106fc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fcf:	90                   	nop

80106fd0 <getswappedblk>:
{ 
80106fd0:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80106fd1:	31 c9                	xor    %ecx,%ecx
{ 
80106fd3:	89 e5                	mov    %esp,%ebp
80106fd5:	83 ec 08             	sub    $0x8,%esp
  return walkpgdir(pgdir, (void*)uva, 0);
80106fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fde:	e8 1d fb ff ff       	call   80106b00 <walkpgdir>
  if((*ptentry & PTE_SWP)){
80106fe3:	8b 10                	mov    (%eax),%edx
80106fe5:	f6 c6 02             	test   $0x2,%dh
80106fe8:	74 16                	je     80107000 <getswappedblk+0x30>
    *ptentry = 0;
80106fea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    int value = *ptentry >> 12;
80106ff0:	c1 ea 0c             	shr    $0xc,%edx
}
80106ff3:	c9                   	leave  
80106ff4:	89 d0                	mov    %edx,%eax
80106ff6:	c3                   	ret    
80106ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ffe:	66 90                	xchg   %ax,%ax
  return -1;
80107000:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107005:	eb ec                	jmp    80106ff3 <getswappedblk+0x23>
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <deallocuvm.part.0>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	89 c6                	mov    %eax,%esi
80107017:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
80107018:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010701e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107024:	83 ec 1c             	sub    $0x1c,%esp
80107027:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010702a:	39 d3                	cmp    %edx,%ebx
8010702c:	73 60                	jae    8010708e <deallocuvm.part.0+0x7e>
8010702e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107031:	eb 32                	jmp    80107065 <deallocuvm.part.0+0x55>
80107033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107037:	90                   	nop
      if(pa == 0)
80107038:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010703d:	0f 84 94 00 00 00    	je     801070d7 <deallocuvm.part.0+0xc7>
      kfree(v);
80107043:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107046:	05 00 00 00 80       	add    $0x80000000,%eax
8010704b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107051:	50                   	push   %eax
80107052:	e8 b9 b5 ff ff       	call   80102610 <kfree>
      *pte = 0;
80107057:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010705d:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107060:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80107063:	76 29                	jbe    8010708e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107065:	31 c9                	xor    %ecx,%ecx
80107067:	89 da                	mov    %ebx,%edx
80107069:	89 f0                	mov    %esi,%eax
8010706b:	e8 90 fa ff ff       	call   80106b00 <walkpgdir>
80107070:	89 c7                	mov    %eax,%edi
    if(!pte)
80107072:	85 c0                	test   %eax,%eax
80107074:	74 2a                	je     801070a0 <deallocuvm.part.0+0x90>
    else if((*pte & PTE_P) != 0 ){
80107076:	8b 00                	mov    (%eax),%eax
80107078:	a8 01                	test   $0x1,%al
8010707a:	75 bc                	jne    80107038 <deallocuvm.part.0+0x28>
    else if ((*pte & PTE_SWP) != 0){
8010707c:	8d 8b 00 10 00 00    	lea    0x1000(%ebx),%ecx
80107082:	f6 c4 02             	test   $0x2,%ah
80107085:	75 29                	jne    801070b0 <deallocuvm.part.0+0xa0>
80107087:	89 cb                	mov    %ecx,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107089:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010708c:	77 d7                	ja     80107065 <deallocuvm.part.0+0x55>
}
8010708e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107094:	5b                   	pop    %ebx
80107095:	5e                   	pop    %esi
80107096:	5f                   	pop    %edi
80107097:	5d                   	pop    %ebp
80107098:	c3                   	ret    
80107099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070a0:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801070a6:	81 c3 00 00 40 00    	add    $0x400000,%ebx
801070ac:	eb b2                	jmp    80107060 <deallocuvm.part.0+0x50>
801070ae:	66 90                	xchg   %ax,%ax
      uint BLK = getswappedblk(pgdir,a);
801070b0:	83 ec 08             	sub    $0x8,%esp
801070b3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801070b6:	53                   	push   %ebx
801070b7:	56                   	push   %esi
801070b8:	e8 13 ff ff ff       	call   80106fd0 <getswappedblk>
      bfree_page(ROOTDEV,BLK);
801070bd:	5a                   	pop    %edx
801070be:	59                   	pop    %ecx
801070bf:	50                   	push   %eax
801070c0:	6a 01                	push   $0x1
801070c2:	e8 49 a6 ff ff       	call   80101710 <bfree_page>
      *pte = 0;
801070c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801070ca:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801070d0:	83 c4 10             	add    $0x10,%esp
801070d3:	89 cb                	mov    %ecx,%ebx
801070d5:	eb 89                	jmp    80107060 <deallocuvm.part.0+0x50>
        panic("kfree");
801070d7:	83 ec 0c             	sub    $0xc,%esp
801070da:	68 4a 78 10 80       	push   $0x8010784a
801070df:	e8 bc 93 ff ff       	call   801004a0 <panic>
801070e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop

801070f0 <deallocuvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070fc:	39 d1                	cmp    %edx,%ecx
801070fe:	73 10                	jae    80107110 <deallocuvm+0x20>
}
80107100:	5d                   	pop    %ebp
80107101:	e9 0a ff ff ff       	jmp    80107010 <deallocuvm.part.0>
80107106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710d:	8d 76 00             	lea    0x0(%esi),%esi
80107110:	89 d0                	mov    %edx,%eax
80107112:	5d                   	pop    %ebp
80107113:	c3                   	ret    
80107114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <allocuvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107129:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010712c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010712f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107132:	85 c0                	test   %eax,%eax
80107134:	0f 88 a6 00 00 00    	js     801071e0 <allocuvm+0xc0>
  if(newsz < oldsz)
8010713a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010713d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107140:	0f 82 8a 00 00 00    	jb     801071d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107146:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010714c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107152:	39 75 10             	cmp    %esi,0x10(%ebp)
80107155:	77 44                	ja     8010719b <allocuvm+0x7b>
80107157:	eb 7a                	jmp    801071d3 <allocuvm+0xb3>
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
80107163:	68 00 10 00 00       	push   $0x1000
80107168:	6a 00                	push   $0x0
8010716a:	53                   	push   %ebx
8010716b:	e8 00 d6 ff ff       	call   80104770 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem),PTE_W|PTE_U) < 0){
80107170:	58                   	pop    %eax
80107171:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107177:	5a                   	pop    %edx
80107178:	6a 06                	push   $0x6
8010717a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010717f:	89 f2                	mov    %esi,%edx
80107181:	50                   	push   %eax
80107182:	89 f8                	mov    %edi,%eax
80107184:	e8 f7 f9 ff ff       	call   80106b80 <mappages>
80107189:	83 c4 10             	add    $0x10,%esp
8010718c:	85 c0                	test   %eax,%eax
8010718e:	78 68                	js     801071f8 <allocuvm+0xd8>
  for(; a < newsz; a += PGSIZE){
80107190:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107196:	39 75 10             	cmp    %esi,0x10(%ebp)
80107199:	76 38                	jbe    801071d3 <allocuvm+0xb3>
    mem = kalloc();
8010719b:	e8 50 b6 ff ff       	call   801027f0 <kalloc>
801071a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071a2:	85 c0                	test   %eax,%eax
801071a4:	75 ba                	jne    80107160 <allocuvm+0x40>
      swap_page(pgdir);
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	57                   	push   %edi
801071aa:	e8 91 eb ff ff       	call   80105d40 <swap_page>
      mem = kalloc();
801071af:	e8 3c b6 ff ff       	call   801027f0 <kalloc>
      if (mem == 0)
801071b4:	83 c4 10             	add    $0x10,%esp
      mem = kalloc();
801071b7:	89 c3                	mov    %eax,%ebx
      if (mem == 0)
801071b9:	85 c0                	test   %eax,%eax
801071bb:	75 a3                	jne    80107160 <allocuvm+0x40>
        panic("2nd kalloc failed \n");
801071bd:	83 ec 0c             	sub    $0xc,%esp
801071c0:	68 92 7f 10 80       	push   $0x80107f92
801071c5:	e8 d6 92 ff ff       	call   801004a0 <panic>
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
801071d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801071d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d9:	5b                   	pop    %ebx
801071da:	5e                   	pop    %esi
801071db:	5f                   	pop    %edi
801071dc:	5d                   	pop    %ebp
801071dd:	c3                   	ret    
801071de:	66 90                	xchg   %ax,%ax
    return 0;
801071e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ed:	5b                   	pop    %ebx
801071ee:	5e                   	pop    %esi
801071ef:	5f                   	pop    %edi
801071f0:	5d                   	pop    %ebp
801071f1:	c3                   	ret    
801071f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(newsz >= oldsz)
801071f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801071fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801071fe:	74 0c                	je     8010720c <allocuvm+0xec>
80107200:	8b 55 10             	mov    0x10(%ebp),%edx
80107203:	89 c1                	mov    %eax,%ecx
80107205:	89 f8                	mov    %edi,%eax
80107207:	e8 04 fe ff ff       	call   80107010 <deallocuvm.part.0>
      kfree(mem);
8010720c:	83 ec 0c             	sub    $0xc,%esp
8010720f:	53                   	push   %ebx
80107210:	e8 fb b3 ff ff       	call   80102610 <kfree>
      return 0;
80107215:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010721c:	83 c4 10             	add    $0x10,%esp
}
8010721f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107222:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <freevm>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
8010723c:	85 f6                	test   %esi,%esi
8010723e:	74 59                	je     80107299 <freevm+0x69>
  if(newsz >= oldsz)
80107240:	31 c9                	xor    %ecx,%ecx
80107242:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107247:	89 f0                	mov    %esi,%eax
80107249:	89 f3                	mov    %esi,%ebx
8010724b:	e8 c0 fd ff ff       	call   80107010 <deallocuvm.part.0>
  for(i = 0; i < NPDENTRIES; i++){
80107250:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107256:	eb 0f                	jmp    80107267 <freevm+0x37>
80107258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725f:	90                   	nop
80107260:	83 c3 04             	add    $0x4,%ebx
80107263:	39 df                	cmp    %ebx,%edi
80107265:	74 23                	je     8010728a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107267:	8b 03                	mov    (%ebx),%eax
80107269:	a8 01                	test   $0x1,%al
8010726b:	74 f3                	je     80107260 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010726d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107272:	83 ec 0c             	sub    $0xc,%esp
80107275:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107278:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010727d:	50                   	push   %eax
8010727e:	e8 8d b3 ff ff       	call   80102610 <kfree>
80107283:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107286:	39 df                	cmp    %ebx,%edi
80107288:	75 dd                	jne    80107267 <freevm+0x37>
  kfree((char*)pgdir);
8010728a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010728d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107290:	5b                   	pop    %ebx
80107291:	5e                   	pop    %esi
80107292:	5f                   	pop    %edi
80107293:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107294:	e9 77 b3 ff ff       	jmp    80102610 <kfree>
    panic("freevm: no pgdir");
80107299:	83 ec 0c             	sub    $0xc,%esp
8010729c:	68 a6 7f 10 80       	push   $0x80107fa6
801072a1:	e8 fa 91 ff ff       	call   801004a0 <panic>
801072a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ad:	8d 76 00             	lea    0x0(%esi),%esi

801072b0 <setupkvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	56                   	push   %esi
801072b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072b5:	e8 36 b5 ff ff       	call   801027f0 <kalloc>
801072ba:	89 c6                	mov    %eax,%esi
801072bc:	85 c0                	test   %eax,%eax
801072be:	74 42                	je     80107302 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801072c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801072c8:	68 00 10 00 00       	push   $0x1000
801072cd:	6a 00                	push   $0x0
801072cf:	50                   	push   %eax
801072d0:	e8 9b d4 ff ff       	call   80104770 <memset>
801072d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072db:	83 ec 08             	sub    $0x8,%esp
801072de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072e1:	ff 73 0c             	pushl  0xc(%ebx)
801072e4:	8b 13                	mov    (%ebx),%edx
801072e6:	50                   	push   %eax
801072e7:	29 c1                	sub    %eax,%ecx
801072e9:	89 f0                	mov    %esi,%eax
801072eb:	e8 90 f8 ff ff       	call   80106b80 <mappages>
801072f0:	83 c4 10             	add    $0x10,%esp
801072f3:	85 c0                	test   %eax,%eax
801072f5:	78 19                	js     80107310 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072f7:	83 c3 10             	add    $0x10,%ebx
801072fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107300:	75 d6                	jne    801072d8 <setupkvm+0x28>
}
80107302:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107305:	89 f0                	mov    %esi,%eax
80107307:	5b                   	pop    %ebx
80107308:	5e                   	pop    %esi
80107309:	5d                   	pop    %ebp
8010730a:	c3                   	ret    
8010730b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010730f:	90                   	nop
      freevm(pgdir);
80107310:	83 ec 0c             	sub    $0xc,%esp
80107313:	56                   	push   %esi
      return 0;
80107314:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107316:	e8 15 ff ff ff       	call   80107230 <freevm>
      return 0;
8010731b:	83 c4 10             	add    $0x10,%esp
}
8010731e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107321:	89 f0                	mov    %esi,%eax
80107323:	5b                   	pop    %ebx
80107324:	5e                   	pop    %esi
80107325:	5d                   	pop    %ebp
80107326:	c3                   	ret    
80107327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732e:	66 90                	xchg   %ax,%ax

80107330 <kvmalloc>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107336:	e8 75 ff ff ff       	call   801072b0 <setupkvm>
8010733b:	a3 a4 64 11 80       	mov    %eax,0x801164a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107340:	05 00 00 00 80       	add    $0x80000000,%eax
80107345:	0f 22 d8             	mov    %eax,%cr3
}
80107348:	c9                   	leave  
80107349:	c3                   	ret    
8010734a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107350 <clearpteu>:
{
80107350:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107351:	31 c9                	xor    %ecx,%ecx
{
80107353:	89 e5                	mov    %esp,%ebp
80107355:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107358:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735b:	8b 45 08             	mov    0x8(%ebp),%eax
8010735e:	e8 9d f7 ff ff       	call   80106b00 <walkpgdir>
  if(pte == 0)
80107363:	85 c0                	test   %eax,%eax
80107365:	74 05                	je     8010736c <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107367:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010736a:	c9                   	leave  
8010736b:	c3                   	ret    
    panic("clearpteu");
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	68 b7 7f 10 80       	push   $0x80107fb7
80107374:	e8 27 91 ff ff       	call   801004a0 <panic>
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107380 <copyuvm>:
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
80107389:	e8 22 ff ff ff       	call   801072b0 <setupkvm>
8010738e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107391:	85 c0                	test   %eax,%eax
80107393:	0f 84 e9 00 00 00    	je     80107482 <copyuvm+0x102>
  for(i = 0; i < sz; i += PGSIZE){
80107399:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010739c:	85 c9                	test   %ecx,%ecx
8010739e:	0f 84 de 00 00 00    	je     80107482 <copyuvm+0x102>
801073a4:	31 f6                	xor    %esi,%esi
801073a6:	eb 6b                	jmp    80107413 <copyuvm+0x93>
801073a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop
    if((mem = kalloc()) == 0){
801073b0:	e8 3b b4 ff ff       	call   801027f0 <kalloc>
    pa = PTE_ADDR(*pte);
801073b5:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801073b7:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801073bd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0){
801073c3:	89 c2                	mov    %eax,%edx
801073c5:	85 c0                	test   %eax,%eax
801073c7:	0f 84 83 00 00 00    	je     80107450 <copyuvm+0xd0>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073cd:	83 ec 04             	sub    $0x4,%esp
801073d0:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073d9:	68 00 10 00 00       	push   $0x1000
801073de:	57                   	push   %edi
801073df:	52                   	push   %edx
801073e0:	e8 3b d4 ff ff       	call   80104820 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073e5:	58                   	pop    %eax
801073e6:	5a                   	pop    %edx
801073e7:	53                   	push   %ebx
801073e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ee:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073f3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801073f9:	52                   	push   %edx
801073fa:	89 f2                	mov    %esi,%edx
801073fc:	e8 7f f7 ff ff       	call   80106b80 <mappages>
80107401:	83 c4 10             	add    $0x10,%esp
80107404:	85 c0                	test   %eax,%eax
80107406:	78 65                	js     8010746d <copyuvm+0xed>
  for(i = 0; i < sz; i += PGSIZE){
80107408:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010740e:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107411:	76 6f                	jbe    80107482 <copyuvm+0x102>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107413:	8b 45 08             	mov    0x8(%ebp),%eax
80107416:	31 c9                	xor    %ecx,%ecx
80107418:	89 f2                	mov    %esi,%edx
8010741a:	e8 e1 f6 ff ff       	call   80106b00 <walkpgdir>
8010741f:	89 c7                	mov    %eax,%edi
80107421:	85 c0                	test   %eax,%eax
80107423:	74 68                	je     8010748d <copyuvm+0x10d>
    if(!(*pte & PTE_P) && !(*pte & PTE_SWP))
80107425:	8b 18                	mov    (%eax),%ebx
80107427:	f7 c3 01 02 00 00    	test   $0x201,%ebx
8010742d:	74 6b                	je     8010749a <copyuvm+0x11a>
    if (*pte & PTE_SWP) {
8010742f:	f6 c7 02             	test   $0x2,%bh
80107432:	0f 84 78 ff ff ff    	je     801073b0 <copyuvm+0x30>
  		map_address(pgdir,i);
80107438:	83 ec 08             	sub    $0x8,%esp
8010743b:	56                   	push   %esi
8010743c:	ff 75 08             	pushl  0x8(%ebp)
8010743f:	e8 1c e9 ff ff       	call   80105d60 <map_address>
80107444:	8b 1f                	mov    (%edi),%ebx
80107446:	83 c4 10             	add    $0x10,%esp
80107449:	e9 62 ff ff ff       	jmp    801073b0 <copyuvm+0x30>
8010744e:	66 90                	xchg   %ax,%ax
      swap_page(pgdir);
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	ff 75 08             	pushl  0x8(%ebp)
80107456:	e8 e5 e8 ff ff       	call   80105d40 <swap_page>
  	  mem = kalloc();
8010745b:	e8 90 b3 ff ff       	call   801027f0 <kalloc>
  	  if (mem == 0) {
80107460:	83 c4 10             	add    $0x10,%esp
  	  mem = kalloc();
80107463:	89 c2                	mov    %eax,%edx
  	  if (mem == 0) {
80107465:	85 c0                	test   %eax,%eax
80107467:	0f 85 60 ff ff ff    	jne    801073cd <copyuvm+0x4d>
  freevm(d);
8010746d:	83 ec 0c             	sub    $0xc,%esp
80107470:	ff 75 e0             	pushl  -0x20(%ebp)
80107473:	e8 b8 fd ff ff       	call   80107230 <freevm>
  return 0;
80107478:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010747f:	83 c4 10             	add    $0x10,%esp
}
80107482:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107488:	5b                   	pop    %ebx
80107489:	5e                   	pop    %esi
8010748a:	5f                   	pop    %edi
8010748b:	5d                   	pop    %ebp
8010748c:	c3                   	ret    
      panic("copyuvm: pte should exist");
8010748d:	83 ec 0c             	sub    $0xc,%esp
80107490:	68 c1 7f 10 80       	push   $0x80107fc1
80107495:	e8 06 90 ff ff       	call   801004a0 <panic>
      panic("copyuvm: page not present");
8010749a:	83 ec 0c             	sub    $0xc,%esp
8010749d:	68 db 7f 10 80       	push   $0x80107fdb
801074a2:	e8 f9 8f ff ff       	call   801004a0 <panic>
801074a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ae:	66 90                	xchg   %ax,%ax

801074b0 <uva2ka>:
{
801074b0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801074b1:	31 c9                	xor    %ecx,%ecx
{
801074b3:	89 e5                	mov    %esp,%ebp
801074b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074bb:	8b 45 08             	mov    0x8(%ebp),%eax
801074be:	e8 3d f6 ff ff       	call   80106b00 <walkpgdir>
  if((*pte & PTE_P) == 0)
801074c3:	8b 00                	mov    (%eax),%eax
}
801074c5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801074c6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801074cd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074d0:	05 00 00 00 80       	add    $0x80000000,%eax
801074d5:	83 fa 05             	cmp    $0x5,%edx
801074d8:	ba 00 00 00 00       	mov    $0x0,%edx
801074dd:	0f 45 c2             	cmovne %edx,%eax
}
801074e0:	c3                   	ret    
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop

801074f0 <uva2pte>:
{
801074f0:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074f1:	31 c9                	xor    %ecx,%ecx
{
801074f3:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801074f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801074fb:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074fc:	e9 ff f5 ff ff       	jmp    80106b00 <walkpgdir>
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750f:	90                   	nop

80107510 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 0c             	sub    $0xc,%esp
80107519:	8b 75 14             	mov    0x14(%ebp),%esi
8010751c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010751f:	85 f6                	test   %esi,%esi
80107521:	75 38                	jne    8010755b <copyout+0x4b>
80107523:	eb 6b                	jmp    80107590 <copyout+0x80>
80107525:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107528:	8b 55 0c             	mov    0xc(%ebp),%edx
8010752b:	89 fb                	mov    %edi,%ebx
8010752d:	29 d3                	sub    %edx,%ebx
8010752f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107535:	39 f3                	cmp    %esi,%ebx
80107537:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010753a:	29 fa                	sub    %edi,%edx
8010753c:	83 ec 04             	sub    $0x4,%esp
8010753f:	01 c2                	add    %eax,%edx
80107541:	53                   	push   %ebx
80107542:	ff 75 10             	pushl  0x10(%ebp)
80107545:	52                   	push   %edx
80107546:	e8 d5 d2 ff ff       	call   80104820 <memmove>
    len -= n;
    buf += n;
8010754b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010754e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107554:	83 c4 10             	add    $0x10,%esp
80107557:	29 de                	sub    %ebx,%esi
80107559:	74 35                	je     80107590 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
8010755b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010755d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107560:	89 55 0c             	mov    %edx,0xc(%ebp)
80107563:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107569:	57                   	push   %edi
8010756a:	ff 75 08             	pushl  0x8(%ebp)
8010756d:	e8 3e ff ff ff       	call   801074b0 <uva2ka>
    if(pa0 == 0)
80107572:	83 c4 10             	add    $0x10,%esp
80107575:	85 c0                	test   %eax,%eax
80107577:	75 af                	jne    80107528 <copyout+0x18>
  }
  return 0;
}
80107579:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010757c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107581:	5b                   	pop    %ebx
80107582:	5e                   	pop    %esi
80107583:	5f                   	pop    %edi
80107584:	5d                   	pop    %ebp
80107585:	c3                   	ret    
80107586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758d:	8d 76 00             	lea    0x0(%esi),%esi
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107593:	31 c0                	xor    %eax,%eax
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    

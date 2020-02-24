
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
8010002d:	b8 04 2b 10 80       	mov    $0x80102b04,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 60 67 10 80       	push   $0x80106760
80100040:	68 c0 b5 10 80       	push   $0x8010b5c0
80100045:	e8 06 3e 00 00       	call   80103e50 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100051:	fc 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010005b:	fc 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
80100061:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100066:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
8010006b:	eb 05                	jmp    80100072 <binit+0x3e>
8010006d:	8d 76 00             	lea    0x0(%esi),%esi
80100070:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100072:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100075:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010007c:	83 ec 08             	sub    $0x8,%esp
8010007f:	68 67 67 10 80       	push   $0x80106767
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 b3 3c 00 00       	call   80103d40 <initsleeplock>
    bcache.head.next->prev = b;
8010008d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100092:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100095:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009b:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a1:	89 d8                	mov    %ebx,%eax
801000a3:	83 c4 10             	add    $0x10,%esp
801000a6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000ac:	75 c2                	jne    80100070 <binit+0x3c>
  }
}
801000ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	90                   	nop

801000b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	57                   	push   %edi
801000b8:	56                   	push   %esi
801000b9:	53                   	push   %ebx
801000ba:	83 ec 18             	sub    $0x18,%esp
801000bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000c3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c8:	e8 c3 3e 00 00       	call   80103f90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cd:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000d3:	83 c4 10             	add    $0x10,%esp
801000d6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000dc:	75 0d                	jne    801000eb <bread+0x37>
801000de:	eb 1c                	jmp    801000fc <bread+0x48>
801000e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000e3:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000e9:	74 11                	je     801000fc <bread+0x48>
    if(b->dev == dev && b->blockno == blockno){
801000eb:	3b 7b 04             	cmp    0x4(%ebx),%edi
801000ee:	75 f0                	jne    801000e0 <bread+0x2c>
801000f0:	3b 73 08             	cmp    0x8(%ebx),%esi
801000f3:	75 eb                	jne    801000e0 <bread+0x2c>
      b->refcnt++;
801000f5:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
801000f8:	eb 3c                	jmp    80100136 <bread+0x82>
801000fa:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000fc:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100102:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100108:	75 0d                	jne    80100117 <bread+0x63>
8010010a:	eb 6c                	jmp    80100178 <bread+0xc4>
8010010c:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010010f:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100115:	74 61                	je     80100178 <bread+0xc4>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100117:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010011a:	85 c0                	test   %eax,%eax
8010011c:	75 ee                	jne    8010010c <bread+0x58>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 e9                	jne    8010010c <bread+0x58>
      b->dev = dev;
80100123:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	83 ec 0c             	sub    $0xc,%esp
80100139:	68 c0 b5 10 80       	push   $0x8010b5c0
8010013e:	e8 e5 3e 00 00       	call   80104028 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 26 3c 00 00       	call   80103d74 <acquiresleep>
      return b;
8010014e:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100151:	f6 03 02             	testb  $0x2,(%ebx)
80100154:	74 0a                	je     80100160 <bread+0xac>
    iderw(b);
  }
  return b;
}
80100156:	89 d8                	mov    %ebx,%eax
80100158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010015b:	5b                   	pop    %ebx
8010015c:	5e                   	pop    %esi
8010015d:	5f                   	pop    %edi
8010015e:	5d                   	pop    %ebp
8010015f:	c3                   	ret    
    iderw(b);
80100160:	83 ec 0c             	sub    $0xc,%esp
80100163:	53                   	push   %ebx
80100164:	e8 8f 1d 00 00       	call   80101ef8 <iderw>
80100169:	83 c4 10             	add    $0x10,%esp
}
8010016c:	89 d8                	mov    %ebx,%eax
8010016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100171:	5b                   	pop    %ebx
80100172:	5e                   	pop    %esi
80100173:	5f                   	pop    %edi
80100174:	5d                   	pop    %ebp
80100175:	c3                   	ret    
80100176:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	68 6e 67 10 80       	push   $0x8010676e
80100180:	e8 bb 01 00 00       	call   80100340 <panic>
80100185:	8d 76 00             	lea    0x0(%esi),%esi

80100188 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100188:	55                   	push   %ebp
80100189:	89 e5                	mov    %esp,%ebp
8010018b:	53                   	push   %ebx
8010018c:	83 ec 10             	sub    $0x10,%esp
8010018f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100192:	8d 43 0c             	lea    0xc(%ebx),%eax
80100195:	50                   	push   %eax
80100196:	e8 69 3c 00 00       	call   80103e04 <holdingsleep>
8010019b:	83 c4 10             	add    $0x10,%esp
8010019e:	85 c0                	test   %eax,%eax
801001a0:	74 0f                	je     801001b1 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a2:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001ab:	c9                   	leave  
  iderw(b);
801001ac:	e9 47 1d 00 00       	jmp    80101ef8 <iderw>
    panic("bwrite");
801001b1:	83 ec 0c             	sub    $0xc,%esp
801001b4:	68 7f 67 10 80       	push   $0x8010677f
801001b9:	e8 82 01 00 00       	call   80100340 <panic>
801001be:	66 90                	xchg   %ax,%ax

801001c0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	56                   	push   %esi
801001c4:	53                   	push   %ebx
801001c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cb:	83 ec 0c             	sub    $0xc,%esp
801001ce:	56                   	push   %esi
801001cf:	e8 30 3c 00 00       	call   80103e04 <holdingsleep>
801001d4:	83 c4 10             	add    $0x10,%esp
801001d7:	85 c0                	test   %eax,%eax
801001d9:	74 64                	je     8010023f <brelse+0x7f>
    panic("brelse");

  releasesleep(&b->lock);
801001db:	83 ec 0c             	sub    $0xc,%esp
801001de:	56                   	push   %esi
801001df:	e8 e4 3b 00 00       	call   80103dc8 <releasesleep>

  acquire(&bcache.lock);
801001e4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801001eb:	e8 a0 3d 00 00       	call   80103f90 <acquire>
  b->refcnt--;
801001f0:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f3:	48                   	dec    %eax
801001f4:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	75 2f                	jne    8010022d <brelse+0x6d>
    // no one is waiting for it.
    b->next->prev = b->prev;
801001fe:	8b 43 54             	mov    0x54(%ebx),%eax
80100201:	8b 53 50             	mov    0x50(%ebx),%edx
80100204:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100207:	8b 43 50             	mov    0x50(%ebx),%eax
8010020a:	8b 53 54             	mov    0x54(%ebx),%edx
8010020d:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100210:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100215:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100218:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
8010021f:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100224:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100227:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010022d:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100234:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100237:	5b                   	pop    %ebx
80100238:	5e                   	pop    %esi
80100239:	5d                   	pop    %ebp
  release(&bcache.lock);
8010023a:	e9 e9 3d 00 00       	jmp    80104028 <release>
    panic("brelse");
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	68 86 67 10 80       	push   $0x80106786
80100247:	e8 f4 00 00 00       	call   80100340 <panic>

8010024c <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
8010024c:	55                   	push   %ebp
8010024d:	89 e5                	mov    %esp,%ebp
8010024f:	57                   	push   %edi
80100250:	56                   	push   %esi
80100251:	53                   	push   %ebx
80100252:	83 ec 18             	sub    $0x18,%esp
80100255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100258:	ff 75 08             	pushl  0x8(%ebp)
8010025b:	e8 d0 13 00 00       	call   80101630 <iunlock>
  target = n;
80100260:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
80100262:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100269:	e8 22 3d 00 00       	call   80103f90 <acquire>
  while(n > 0){
8010026e:	83 c4 10             	add    $0x10,%esp
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100271:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100274:	01 df                	add    %ebx,%edi
  while(n > 0){
80100276:	85 db                	test   %ebx,%ebx
80100278:	0f 8e 91 00 00 00    	jle    8010030f <consoleread+0xc3>
    while(input.r == input.w){
8010027e:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100283:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100289:	74 27                	je     801002b2 <consoleread+0x66>
8010028b:	eb 57                	jmp    801002e4 <consoleread+0x98>
8010028d:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
80100290:	83 ec 08             	sub    $0x8,%esp
80100293:	68 20 a5 10 80       	push   $0x8010a520
80100298:	68 a0 ff 10 80       	push   $0x8010ffa0
8010029d:	e8 f6 35 00 00       	call   80103898 <sleep>
    while(input.r == input.w){
801002a2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a7:	83 c4 10             	add    $0x10,%esp
801002aa:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b0:	75 32                	jne    801002e4 <consoleread+0x98>
      if(myproc()->killed){
801002b2:	e8 ad 30 00 00       	call   80103364 <myproc>
801002b7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ba:	85 c9                	test   %ecx,%ecx
801002bc:	74 d2                	je     80100290 <consoleread+0x44>
        release(&cons.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 20 a5 10 80       	push   $0x8010a520
801002c6:	e8 5d 3d 00 00       	call   80104028 <release>
        ilock(ip);
801002cb:	5a                   	pop    %edx
801002cc:	ff 75 08             	pushl  0x8(%ebp)
801002cf:	e8 94 12 00 00       	call   80101568 <ilock>
        return -1;
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002df:	5b                   	pop    %ebx
801002e0:	5e                   	pop    %esi
801002e1:	5f                   	pop    %edi
801002e2:	5d                   	pop    %ebp
801002e3:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002e4:	8d 50 01             	lea    0x1(%eax),%edx
801002e7:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002ed:	89 c2                	mov    %eax,%edx
801002ef:	83 e2 7f             	and    $0x7f,%edx
801002f2:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
801002f9:	80 f9 04             	cmp    $0x4,%cl
801002fc:	74 36                	je     80100334 <consoleread+0xe8>
    *dst++ = c;
801002fe:	89 d8                	mov    %ebx,%eax
80100300:	f7 d8                	neg    %eax
80100302:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    --n;
80100305:	4b                   	dec    %ebx
    if(c == '\n')
80100306:	83 f9 0a             	cmp    $0xa,%ecx
80100309:	0f 85 67 ff ff ff    	jne    80100276 <consoleread+0x2a>
  release(&cons.lock);
8010030f:	83 ec 0c             	sub    $0xc,%esp
80100312:	68 20 a5 10 80       	push   $0x8010a520
80100317:	e8 0c 3d 00 00       	call   80104028 <release>
  ilock(ip);
8010031c:	58                   	pop    %eax
8010031d:	ff 75 08             	pushl  0x8(%ebp)
80100320:	e8 43 12 00 00       	call   80101568 <ilock>
  return target - n;
80100325:	89 f0                	mov    %esi,%eax
80100327:	29 d8                	sub    %ebx,%eax
80100329:	83 c4 10             	add    $0x10,%esp
}
8010032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret    
      if(n < target){
80100334:	39 f3                	cmp    %esi,%ebx
80100336:	73 d7                	jae    8010030f <consoleread+0xc3>
        input.r--;
80100338:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010033d:	eb d0                	jmp    8010030f <consoleread+0xc3>
8010033f:	90                   	nop

80100340 <panic>:
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	56                   	push   %esi
80100344:	53                   	push   %ebx
80100345:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100348:	fa                   	cli    
  cons.locking = 0;
80100349:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100350:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100353:	e8 10 21 00 00       	call   80102468 <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 8d 67 10 80       	push   $0x8010678d
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
80100366:	58                   	pop    %eax
80100367:	ff 75 08             	pushl  0x8(%ebp)
8010036a:	e8 b1 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
8010036f:	c7 04 24 db 70 10 80 	movl   $0x801070db,(%esp)
80100376:	e8 a5 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
8010037b:	5a                   	pop    %edx
8010037c:	59                   	pop    %ecx
8010037d:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100380:	53                   	push   %ebx
80100381:	8d 45 08             	lea    0x8(%ebp),%eax
80100384:	50                   	push   %eax
80100385:	e8 e2 3a 00 00       	call   80103e6c <getcallerpcs>
  for(i=0; i<10; i++)
8010038a:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010038d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100390:	83 ec 08             	sub    $0x8,%esp
80100393:	ff 33                	pushl  (%ebx)
80100395:	68 a1 67 10 80       	push   $0x801067a1
8010039a:	e8 81 02 00 00       	call   80100620 <cprintf>
8010039f:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
801003a2:	83 c4 10             	add    $0x10,%esp
801003a5:	39 f3                	cmp    %esi,%ebx
801003a7:	75 e7                	jne    80100390 <panic+0x50>
  panicked = 1; // freeze other CPU
801003a9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003b0:	00 00 00 
    ;
801003b3:	eb fe                	jmp    801003b3 <panic+0x73>
801003b5:	8d 76 00             	lea    0x0(%esi),%esi

801003b8 <consputc.part.0>:
consputc(int c)
801003b8:	55                   	push   %ebp
801003b9:	89 e5                	mov    %esp,%ebp
801003bb:	57                   	push   %edi
801003bc:	56                   	push   %esi
801003bd:	53                   	push   %ebx
801003be:	83 ec 1c             	sub    $0x1c,%esp
801003c1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003c3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003c8:	0f 84 ce 00 00 00    	je     8010049c <consputc.part.0+0xe4>
    uartputc(c);
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	50                   	push   %eax
801003d2:	e8 6d 50 00 00       	call   80105444 <uartputc>
801003d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003da:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003df:	b0 0e                	mov    $0xe,%al
801003e1:	89 ca                	mov    %ecx,%edx
801003e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e4:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003e9:	89 da                	mov    %ebx,%edx
801003eb:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003ec:	0f b6 f8             	movzbl %al,%edi
801003ef:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f2:	b0 0f                	mov    $0xf,%al
801003f4:	89 ca                	mov    %ecx,%edx
801003f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f7:	89 da                	mov    %ebx,%edx
801003f9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003fa:	0f b6 c8             	movzbl %al,%ecx
801003fd:	09 f9                	or     %edi,%ecx
  if(c == '\n')
801003ff:	83 fe 0a             	cmp    $0xa,%esi
80100402:	0f 84 84 00 00 00    	je     8010048c <consputc.part.0+0xd4>
  else if(c == BACKSPACE){
80100408:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010040e:	74 6c                	je     8010047c <consputc.part.0+0xc4>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100410:	8d 59 01             	lea    0x1(%ecx),%ebx
80100413:	89 f0                	mov    %esi,%eax
80100415:	0f b6 f0             	movzbl %al,%esi
80100418:	81 ce 00 07 00 00    	or     $0x700,%esi
8010041e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100425:	80 
  if(pos < 0 || pos > 25*80)
80100426:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010042c:	0f 8f ee 00 00 00    	jg     80100520 <consputc.part.0+0x168>
  if((pos/80) >= 24){  // Scroll up.
80100432:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100438:	0f 8f 8a 00 00 00    	jg     801004c8 <consputc.part.0+0x110>
8010043e:	0f b6 c7             	movzbl %bh,%eax
80100441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100444:	89 de                	mov    %ebx,%esi
80100446:	01 db                	add    %ebx,%ebx
80100448:	8d bb 00 80 0b 80    	lea    -0x7ff48000(%ebx),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044e:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100453:	b0 0e                	mov    $0xe,%al
80100455:	89 da                	mov    %ebx,%edx
80100457:	ee                   	out    %al,(%dx)
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	8a 45 e4             	mov    -0x1c(%ebp),%al
80100460:	89 ca                	mov    %ecx,%edx
80100462:	ee                   	out    %al,(%dx)
80100463:	b0 0f                	mov    $0xf,%al
80100465:	89 da                	mov    %ebx,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 f0                	mov    %esi,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 07 20 07       	movw   $0x720,(%edi)
}
80100472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100475:	5b                   	pop    %ebx
80100476:	5e                   	pop    %esi
80100477:	5f                   	pop    %edi
80100478:	5d                   	pop    %ebp
80100479:	c3                   	ret    
8010047a:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
8010047c:	85 c9                	test   %ecx,%ecx
8010047e:	0f 84 8c 00 00 00    	je     80100510 <consputc.part.0+0x158>
80100484:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100487:	eb 9d                	jmp    80100426 <consputc.part.0+0x6e>
80100489:	8d 76 00             	lea    0x0(%esi),%esi
    pos += 80 - pos%80;
8010048c:	bb 50 00 00 00       	mov    $0x50,%ebx
80100491:	89 c8                	mov    %ecx,%eax
80100493:	99                   	cltd   
80100494:	f7 fb                	idiv   %ebx
80100496:	29 d3                	sub    %edx,%ebx
80100498:	01 cb                	add    %ecx,%ebx
8010049a:	eb 8a                	jmp    80100426 <consputc.part.0+0x6e>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010049c:	83 ec 0c             	sub    $0xc,%esp
8010049f:	6a 08                	push   $0x8
801004a1:	e8 9e 4f 00 00       	call   80105444 <uartputc>
801004a6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004ad:	e8 92 4f 00 00       	call   80105444 <uartputc>
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 86 4f 00 00       	call   80105444 <uartputc>
801004be:	83 c4 10             	add    $0x10,%esp
801004c1:	e9 14 ff ff ff       	jmp    801003da <consputc.part.0+0x22>
801004c6:	66 90                	xchg   %ax,%ax
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004c8:	50                   	push   %eax
801004c9:	68 60 0e 00 00       	push   $0xe60
801004ce:	68 a0 80 0b 80       	push   $0x800b80a0
801004d3:	68 00 80 0b 80       	push   $0x800b8000
801004d8:	e8 17 3c 00 00       	call   801040f4 <memmove>
    pos -= 80;
801004dd:	8d 73 b0             	lea    -0x50(%ebx),%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e0:	8d 84 1b 60 ff ff ff 	lea    -0xa0(%ebx,%ebx,1),%eax
801004e7:	8d b8 00 80 0b 80    	lea    -0x7ff48000(%eax),%edi
801004ed:	83 c4 0c             	add    $0xc,%esp
801004f0:	b8 80 07 00 00       	mov    $0x780,%eax
801004f5:	29 f0                	sub    %esi,%eax
801004f7:	01 c0                	add    %eax,%eax
801004f9:	50                   	push   %eax
801004fa:	6a 00                	push   $0x0
801004fc:	57                   	push   %edi
801004fd:	e8 6e 3b 00 00       	call   80104070 <memset>
80100502:	83 c4 10             	add    $0x10,%esp
80100505:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
80100509:	e9 40 ff ff ff       	jmp    8010044e <consputc.part.0+0x96>
8010050e:	66 90                	xchg   %ax,%ax
80100510:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80100515:	31 f6                	xor    %esi,%esi
80100517:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010051b:	e9 2e ff ff ff       	jmp    8010044e <consputc.part.0+0x96>
    panic("pos under/overflow");
80100520:	83 ec 0c             	sub    $0xc,%esp
80100523:	68 a5 67 10 80       	push   $0x801067a5
80100528:	e8 13 fe ff ff       	call   80100340 <panic>
8010052d:	8d 76 00             	lea    0x0(%esi),%esi

80100530 <printint>:
{
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	57                   	push   %edi
80100534:	56                   	push   %esi
80100535:	53                   	push   %ebx
80100536:	83 ec 2c             	sub    $0x2c,%esp
80100539:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010053c:	85 c9                	test   %ecx,%ecx
8010053e:	74 04                	je     80100544 <printint+0x14>
80100540:	85 c0                	test   %eax,%eax
80100542:	78 5e                	js     801005a2 <printint+0x72>
    x = xx;
80100544:	89 c1                	mov    %eax,%ecx
80100546:	31 db                	xor    %ebx,%ebx
  i = 0;
80100548:	31 ff                	xor    %edi,%edi
    buf[i++] = digits[x % base];
8010054a:	89 c8                	mov    %ecx,%eax
8010054c:	31 d2                	xor    %edx,%edx
8010054e:	f7 75 d4             	divl   -0x2c(%ebp)
80100551:	89 fe                	mov    %edi,%esi
80100553:	8d 7f 01             	lea    0x1(%edi),%edi
80100556:	8a 92 d0 67 10 80    	mov    -0x7fef9830(%edx),%dl
8010055c:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
80100560:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  }while((x /= base) != 0);
80100563:	89 c1                	mov    %eax,%ecx
80100565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100568:	39 45 d0             	cmp    %eax,-0x30(%ebp)
8010056b:	73 dd                	jae    8010054a <printint+0x1a>
  if(sign)
8010056d:	85 db                	test   %ebx,%ebx
8010056f:	74 09                	je     8010057a <printint+0x4a>
    buf[i++] = '-';
80100571:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
80100576:	89 fe                	mov    %edi,%esi
    buf[i++] = '-';
80100578:	b2 2d                	mov    $0x2d,%dl
8010057a:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010057e:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100581:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100587:	85 d2                	test   %edx,%edx
80100589:	74 05                	je     80100590 <printint+0x60>
  asm volatile("cli");
8010058b:	fa                   	cli    
      ;
8010058c:	eb fe                	jmp    8010058c <printint+0x5c>
8010058e:	66 90                	xchg   %ax,%ax
80100590:	e8 23 fe ff ff       	call   801003b8 <consputc.part.0>
  while(--i >= 0)
80100595:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100598:	39 c3                	cmp    %eax,%ebx
8010059a:	74 0e                	je     801005aa <printint+0x7a>
8010059c:	0f be 03             	movsbl (%ebx),%eax
8010059f:	4b                   	dec    %ebx
801005a0:	eb df                	jmp    80100581 <printint+0x51>
801005a2:	89 cb                	mov    %ecx,%ebx
    x = -xx;
801005a4:	f7 d8                	neg    %eax
801005a6:	89 c1                	mov    %eax,%ecx
801005a8:	eb 9e                	jmp    80100548 <printint+0x18>
}
801005aa:	83 c4 2c             	add    $0x2c,%esp
801005ad:	5b                   	pop    %ebx
801005ae:	5e                   	pop    %esi
801005af:	5f                   	pop    %edi
801005b0:	5d                   	pop    %ebp
801005b1:	c3                   	ret    
801005b2:	66 90                	xchg   %ax,%ax

801005b4 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b4:	55                   	push   %ebp
801005b5:	89 e5                	mov    %esp,%ebp
801005b7:	57                   	push   %edi
801005b8:	56                   	push   %esi
801005b9:	53                   	push   %ebx
801005ba:	83 ec 18             	sub    $0x18,%esp
801005bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
801005c0:	ff 75 08             	pushl  0x8(%ebp)
801005c3:	e8 68 10 00 00       	call   80101630 <iunlock>
  acquire(&cons.lock);
801005c8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005cf:	e8 bc 39 00 00       	call   80103f90 <acquire>
  for(i = 0; i < n; i++)
801005d4:	83 c4 10             	add    $0x10,%esp
801005d7:	85 ff                	test   %edi,%edi
801005d9:	7e 22                	jle    801005fd <consolewrite+0x49>
801005db:	8b 75 0c             	mov    0xc(%ebp),%esi
801005de:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
  if(panicked){
801005e1:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801005e7:	85 d2                	test   %edx,%edx
801005e9:	74 05                	je     801005f0 <consolewrite+0x3c>
801005eb:	fa                   	cli    
      ;
801005ec:	eb fe                	jmp    801005ec <consolewrite+0x38>
801005ee:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
801005f0:	0f b6 06             	movzbl (%esi),%eax
801005f3:	e8 c0 fd ff ff       	call   801003b8 <consputc.part.0>
801005f8:	46                   	inc    %esi
  for(i = 0; i < n; i++)
801005f9:	39 f3                	cmp    %esi,%ebx
801005fb:	75 e4                	jne    801005e1 <consolewrite+0x2d>
  release(&cons.lock);
801005fd:	83 ec 0c             	sub    $0xc,%esp
80100600:	68 20 a5 10 80       	push   $0x8010a520
80100605:	e8 1e 3a 00 00       	call   80104028 <release>
  ilock(ip);
8010060a:	58                   	pop    %eax
8010060b:	ff 75 08             	pushl  0x8(%ebp)
8010060e:	e8 55 0f 00 00       	call   80101568 <ilock>

  return n;
}
80100613:	89 f8                	mov    %edi,%eax
80100615:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100618:	5b                   	pop    %ebx
80100619:	5e                   	pop    %esi
8010061a:	5f                   	pop    %edi
8010061b:	5d                   	pop    %ebp
8010061c:	c3                   	ret    
8010061d:	8d 76 00             	lea    0x0(%esi),%esi

80100620 <cprintf>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100629:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010062e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100631:	85 c0                	test   %eax,%eax
80100633:	0f 85 dc 00 00 00    	jne    80100715 <cprintf+0xf5>
  if (fmt == 0)
80100639:	8b 75 08             	mov    0x8(%ebp),%esi
8010063c:	85 f6                	test   %esi,%esi
8010063e:	0f 84 49 01 00 00    	je     8010078d <cprintf+0x16d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100644:	0f b6 06             	movzbl (%esi),%eax
80100647:	85 c0                	test   %eax,%eax
80100649:	74 35                	je     80100680 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
8010064b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(c != '%'){
80100655:	83 f8 25             	cmp    $0x25,%eax
80100658:	74 3a                	je     80100694 <cprintf+0x74>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	74 09                	je     8010066d <cprintf+0x4d>
80100664:	fa                   	cli    
      ;
80100665:	eb fe                	jmp    80100665 <cprintf+0x45>
80100667:	90                   	nop
80100668:	b8 25 00 00 00       	mov    $0x25,%eax
8010066d:	e8 46 fd ff ff       	call   801003b8 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100672:	ff 45 e4             	incl   -0x1c(%ebp)
80100675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100678:	0f b6 04 06          	movzbl (%esi,%eax,1),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	75 d5                	jne    80100655 <cprintf+0x35>
  if(locking)
80100680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100683:	85 c0                	test   %eax,%eax
80100685:	0f 85 ed 00 00 00    	jne    80100778 <cprintf+0x158>
}
8010068b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010068e:	5b                   	pop    %ebx
8010068f:	5e                   	pop    %esi
80100690:	5f                   	pop    %edi
80100691:	5d                   	pop    %ebp
80100692:	c3                   	ret    
80100693:	90                   	nop
    c = fmt[++i] & 0xff;
80100694:	ff 45 e4             	incl   -0x1c(%ebp)
80100697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010069a:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
    if(c == 0)
8010069e:	85 ff                	test   %edi,%edi
801006a0:	74 de                	je     80100680 <cprintf+0x60>
    switch(c){
801006a2:	83 ff 70             	cmp    $0x70,%edi
801006a5:	74 56                	je     801006fd <cprintf+0xdd>
801006a7:	7f 2a                	jg     801006d3 <cprintf+0xb3>
801006a9:	83 ff 25             	cmp    $0x25,%edi
801006ac:	0f 84 8c 00 00 00    	je     8010073e <cprintf+0x11e>
801006b2:	83 ff 64             	cmp    $0x64,%edi
801006b5:	0f 85 95 00 00 00    	jne    80100750 <cprintf+0x130>
      printint(*argp++, 10, 1);
801006bb:	8d 7b 04             	lea    0x4(%ebx),%edi
801006be:	b9 01 00 00 00       	mov    $0x1,%ecx
801006c3:	ba 0a 00 00 00       	mov    $0xa,%edx
801006c8:	8b 03                	mov    (%ebx),%eax
801006ca:	e8 61 fe ff ff       	call   80100530 <printint>
801006cf:	89 fb                	mov    %edi,%ebx
      break;
801006d1:	eb 9f                	jmp    80100672 <cprintf+0x52>
    switch(c){
801006d3:	83 ff 73             	cmp    $0x73,%edi
801006d6:	75 20                	jne    801006f8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801006d8:	8d 7b 04             	lea    0x4(%ebx),%edi
801006db:	8b 1b                	mov    (%ebx),%ebx
801006dd:	85 db                	test   %ebx,%ebx
801006df:	75 4f                	jne    80100730 <cprintf+0x110>
        s = "(null)";
801006e1:	bb b8 67 10 80       	mov    $0x801067b8,%ebx
      for(; *s; s++)
801006e6:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
801006eb:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801006f1:	85 d2                	test   %edx,%edx
801006f3:	74 35                	je     8010072a <cprintf+0x10a>
801006f5:	fa                   	cli    
      ;
801006f6:	eb fe                	jmp    801006f6 <cprintf+0xd6>
    switch(c){
801006f8:	83 ff 78             	cmp    $0x78,%edi
801006fb:	75 53                	jne    80100750 <cprintf+0x130>
      printint(*argp++, 16, 0);
801006fd:	8d 7b 04             	lea    0x4(%ebx),%edi
80100700:	31 c9                	xor    %ecx,%ecx
80100702:	ba 10 00 00 00       	mov    $0x10,%edx
80100707:	8b 03                	mov    (%ebx),%eax
80100709:	e8 22 fe ff ff       	call   80100530 <printint>
8010070e:	89 fb                	mov    %edi,%ebx
      break;
80100710:	e9 5d ff ff ff       	jmp    80100672 <cprintf+0x52>
    acquire(&cons.lock);
80100715:	83 ec 0c             	sub    $0xc,%esp
80100718:	68 20 a5 10 80       	push   $0x8010a520
8010071d:	e8 6e 38 00 00       	call   80103f90 <acquire>
80100722:	83 c4 10             	add    $0x10,%esp
80100725:	e9 0f ff ff ff       	jmp    80100639 <cprintf+0x19>
8010072a:	e8 89 fc ff ff       	call   801003b8 <consputc.part.0>
      for(; *s; s++)
8010072f:	43                   	inc    %ebx
80100730:	0f be 03             	movsbl (%ebx),%eax
80100733:	84 c0                	test   %al,%al
80100735:	75 b4                	jne    801006eb <cprintf+0xcb>
      if((s = (char*)*argp++) == 0)
80100737:	89 fb                	mov    %edi,%ebx
80100739:	e9 34 ff ff ff       	jmp    80100672 <cprintf+0x52>
  if(panicked){
8010073e:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
80100744:	85 ff                	test   %edi,%edi
80100746:	0f 84 1c ff ff ff    	je     80100668 <cprintf+0x48>
8010074c:	fa                   	cli    
      ;
8010074d:	eb fe                	jmp    8010074d <cprintf+0x12d>
8010074f:	90                   	nop
  if(panicked){
80100750:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	74 06                	je     80100760 <cprintf+0x140>
8010075a:	fa                   	cli    
      ;
8010075b:	eb fe                	jmp    8010075b <cprintf+0x13b>
8010075d:	8d 76 00             	lea    0x0(%esi),%esi
80100760:	b8 25 00 00 00       	mov    $0x25,%eax
80100765:	e8 4e fc ff ff       	call   801003b8 <consputc.part.0>
  if(panicked){
8010076a:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100770:	85 d2                	test   %edx,%edx
80100772:	74 28                	je     8010079c <cprintf+0x17c>
80100774:	fa                   	cli    
      ;
80100775:	eb fe                	jmp    80100775 <cprintf+0x155>
80100777:	90                   	nop
    release(&cons.lock);
80100778:	83 ec 0c             	sub    $0xc,%esp
8010077b:	68 20 a5 10 80       	push   $0x8010a520
80100780:	e8 a3 38 00 00       	call   80104028 <release>
80100785:	83 c4 10             	add    $0x10,%esp
}
80100788:	e9 fe fe ff ff       	jmp    8010068b <cprintf+0x6b>
    panic("null fmt");
8010078d:	83 ec 0c             	sub    $0xc,%esp
80100790:	68 bf 67 10 80       	push   $0x801067bf
80100795:	e8 a6 fb ff ff       	call   80100340 <panic>
8010079a:	66 90                	xchg   %ax,%ax
8010079c:	89 f8                	mov    %edi,%eax
8010079e:	e8 15 fc ff ff       	call   801003b8 <consputc.part.0>
801007a3:	e9 ca fe ff ff       	jmp    80100672 <cprintf+0x52>

801007a8 <consoleintr>:
{
801007a8:	55                   	push   %ebp
801007a9:	89 e5                	mov    %esp,%ebp
801007ab:	57                   	push   %edi
801007ac:	56                   	push   %esi
801007ad:	53                   	push   %ebx
801007ae:	83 ec 18             	sub    $0x18,%esp
801007b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801007b4:	68 20 a5 10 80       	push   $0x8010a520
801007b9:	e8 d2 37 00 00       	call   80103f90 <acquire>
  while((c = getc()) >= 0){
801007be:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801007c1:	31 f6                	xor    %esi,%esi
  while((c = getc()) >= 0){
801007c3:	eb 17                	jmp    801007dc <consoleintr+0x34>
    switch(c){
801007c5:	83 fb 08             	cmp    $0x8,%ebx
801007c8:	0f 84 02 01 00 00    	je     801008d0 <consoleintr+0x128>
801007ce:	83 fb 10             	cmp    $0x10,%ebx
801007d1:	0f 85 1d 01 00 00    	jne    801008f4 <consoleintr+0x14c>
801007d7:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801007dc:	ff d7                	call   *%edi
801007de:	89 c3                	mov    %eax,%ebx
801007e0:	85 c0                	test   %eax,%eax
801007e2:	0f 88 2b 01 00 00    	js     80100913 <consoleintr+0x16b>
    switch(c){
801007e8:	83 fb 15             	cmp    $0x15,%ebx
801007eb:	0f 84 8b 00 00 00    	je     8010087c <consoleintr+0xd4>
801007f1:	7e d2                	jle    801007c5 <consoleintr+0x1d>
801007f3:	83 fb 7f             	cmp    $0x7f,%ebx
801007f6:	0f 84 d4 00 00 00    	je     801008d0 <consoleintr+0x128>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007fc:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100801:	89 c2                	mov    %eax,%edx
80100803:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100809:	83 fa 7f             	cmp    $0x7f,%edx
8010080c:	77 ce                	ja     801007dc <consoleintr+0x34>
        c = (c == '\r') ? '\n' : c;
8010080e:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100814:	8d 48 01             	lea    0x1(%eax),%ecx
80100817:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
8010081a:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100820:	83 fb 0d             	cmp    $0xd,%ebx
80100823:	0f 84 06 01 00 00    	je     8010092f <consoleintr+0x187>
        input.buf[input.e++ % INPUT_BUF] = c;
80100829:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
8010082f:	85 d2                	test   %edx,%edx
80100831:	0f 85 03 01 00 00    	jne    8010093a <consoleintr+0x192>
80100837:	89 d8                	mov    %ebx,%eax
80100839:	e8 7a fb ff ff       	call   801003b8 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010083e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100843:	83 fb 0a             	cmp    $0xa,%ebx
80100846:	74 19                	je     80100861 <consoleintr+0xb9>
80100848:	83 fb 04             	cmp    $0x4,%ebx
8010084b:	74 14                	je     80100861 <consoleintr+0xb9>
8010084d:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100853:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
80100859:	39 c2                	cmp    %eax,%edx
8010085b:	0f 85 7b ff ff ff    	jne    801007dc <consoleintr+0x34>
          input.w = input.e;
80100861:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100866:	83 ec 0c             	sub    $0xc,%esp
80100869:	68 a0 ff 10 80       	push   $0x8010ffa0
8010086e:	e8 d1 31 00 00       	call   80103a44 <wakeup>
80100873:	83 c4 10             	add    $0x10,%esp
80100876:	e9 61 ff ff ff       	jmp    801007dc <consoleintr+0x34>
8010087b:	90                   	nop
      while(input.e != input.w &&
8010087c:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100881:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100887:	0f 84 4f ff ff ff    	je     801007dc <consoleintr+0x34>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010088d:	48                   	dec    %eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100893:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010089a:	0f 84 3c ff ff ff    	je     801007dc <consoleintr+0x34>
        input.e--;
801008a0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008a5:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008ab:	85 d2                	test   %edx,%edx
801008ad:	74 05                	je     801008b4 <consoleintr+0x10c>
801008af:	fa                   	cli    
      ;
801008b0:	eb fe                	jmp    801008b0 <consoleintr+0x108>
801008b2:	66 90                	xchg   %ax,%ax
801008b4:	b8 00 01 00 00       	mov    $0x100,%eax
801008b9:	e8 fa fa ff ff       	call   801003b8 <consputc.part.0>
      while(input.e != input.w &&
801008be:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c3:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008c9:	75 c2                	jne    8010088d <consoleintr+0xe5>
801008cb:	e9 0c ff ff ff       	jmp    801007dc <consoleintr+0x34>
      if(input.e != input.w){
801008d0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008d5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008db:	0f 84 fb fe ff ff    	je     801007dc <consoleintr+0x34>
        input.e--;
801008e1:	48                   	dec    %eax
801008e2:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008e7:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801008ec:	85 c0                	test   %eax,%eax
801008ee:	74 14                	je     80100904 <consoleintr+0x15c>
801008f0:	fa                   	cli    
      ;
801008f1:	eb fe                	jmp    801008f1 <consoleintr+0x149>
801008f3:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008f4:	85 db                	test   %ebx,%ebx
801008f6:	0f 84 e0 fe ff ff    	je     801007dc <consoleintr+0x34>
801008fc:	e9 fb fe ff ff       	jmp    801007fc <consoleintr+0x54>
80100901:	8d 76 00             	lea    0x0(%esi),%esi
80100904:	b8 00 01 00 00       	mov    $0x100,%eax
80100909:	e8 aa fa ff ff       	call   801003b8 <consputc.part.0>
8010090e:	e9 c9 fe ff ff       	jmp    801007dc <consoleintr+0x34>
  release(&cons.lock);
80100913:	83 ec 0c             	sub    $0xc,%esp
80100916:	68 20 a5 10 80       	push   $0x8010a520
8010091b:	e8 08 37 00 00       	call   80104028 <release>
  if(doprocdump) {
80100920:	83 c4 10             	add    $0x10,%esp
80100923:	85 f6                	test   %esi,%esi
80100925:	75 19                	jne    80100940 <consoleintr+0x198>
}
80100927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010092a:	5b                   	pop    %ebx
8010092b:	5e                   	pop    %esi
8010092c:	5f                   	pop    %edi
8010092d:	5d                   	pop    %ebp
8010092e:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
8010092f:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
80100936:	85 d2                	test   %edx,%edx
80100938:	74 12                	je     8010094c <consoleintr+0x1a4>
8010093a:	fa                   	cli    
      ;
8010093b:	eb fe                	jmp    8010093b <consoleintr+0x193>
8010093d:	8d 76 00             	lea    0x0(%esi),%esi
}
80100940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100943:	5b                   	pop    %ebx
80100944:	5e                   	pop    %esi
80100945:	5f                   	pop    %edi
80100946:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100947:	e9 c8 31 00 00       	jmp    80103b14 <procdump>
8010094c:	b8 0a 00 00 00       	mov    $0xa,%eax
80100951:	e8 62 fa ff ff       	call   801003b8 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100956:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095b:	e9 01 ff ff ff       	jmp    80100861 <consoleintr+0xb9>

80100960 <consoleinit>:

void
consoleinit(void)
{
80100960:	55                   	push   %ebp
80100961:	89 e5                	mov    %esp,%ebp
80100963:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100966:	68 c8 67 10 80       	push   $0x801067c8
8010096b:	68 20 a5 10 80       	push   $0x8010a520
80100970:	e8 db 34 00 00       	call   80103e50 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100975:	c7 05 6c 09 11 80 b4 	movl   $0x801005b4,0x8011096c
8010097c:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097f:	c7 05 68 09 11 80 4c 	movl   $0x8010024c,0x80110968
80100986:	02 10 80 
  cons.locking = 1;
80100989:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100990:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100993:	58                   	pop    %eax
80100994:	5a                   	pop    %edx
80100995:	6a 00                	push   $0x0
80100997:	6a 01                	push   $0x1
80100999:	e8 de 16 00 00       	call   8010207c <ioapicenable>
}
8010099e:	83 c4 10             	add    $0x10,%esp
801009a1:	c9                   	leave  
801009a2:	c3                   	ret    
801009a3:	90                   	nop

801009a4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a4:	55                   	push   %ebp
801009a5:	89 e5                	mov    %esp,%ebp
801009a7:	57                   	push   %edi
801009a8:	56                   	push   %esi
801009a9:	53                   	push   %ebx
801009aa:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009b0:	e8 af 29 00 00       	call   80103364 <myproc>
801009b5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801009bb:	e8 88 1e 00 00       	call   80102848 <begin_op>

  if((ip = namei(path)) == 0){
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	ff 75 08             	pushl  0x8(%ebp)
801009c6:	e8 51 13 00 00       	call   80101d1c <namei>
801009cb:	83 c4 10             	add    $0x10,%esp
801009ce:	85 c0                	test   %eax,%eax
801009d0:	0f 84 da 02 00 00    	je     80100cb0 <exec+0x30c>
801009d6:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d8:	83 ec 0c             	sub    $0xc,%esp
801009db:	50                   	push   %eax
801009dc:	e8 87 0b 00 00       	call   80101568 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009e1:	6a 34                	push   $0x34
801009e3:	6a 00                	push   $0x0
801009e5:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009eb:	50                   	push   %eax
801009ec:	53                   	push   %ebx
801009ed:	e8 1a 0e 00 00       	call   8010180c <readi>
801009f2:	83 c4 20             	add    $0x20,%esp
801009f5:	83 f8 34             	cmp    $0x34,%eax
801009f8:	74 1e                	je     80100a18 <exec+0x74>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801009fa:	83 ec 0c             	sub    $0xc,%esp
801009fd:	53                   	push   %ebx
801009fe:	e8 bd 0d 00 00       	call   801017c0 <iunlockput>
    end_op();
80100a03:	e8 a8 1e 00 00       	call   801028b0 <end_op>
80100a08:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a13:	5b                   	pop    %ebx
80100a14:	5e                   	pop    %esi
80100a15:	5f                   	pop    %edi
80100a16:	5d                   	pop    %ebp
80100a17:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a18:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a1f:	45 4c 46 
80100a22:	75 d6                	jne    801009fa <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a24:	e8 cb 5a 00 00       	call   801064f4 <setupkvm>
80100a29:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a2f:	85 c0                	test   %eax,%eax
80100a31:	74 c7                	je     801009fa <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a33:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a39:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	0f 84 86 02 00 00    	je     80100ccf <exec+0x32b>
80100a49:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80100a50:	00 00 00 
80100a53:	e9 84 00 00 00       	jmp    80100adc <exec+0x138>
    if(ph.type != ELF_PROG_LOAD)
80100a58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a5f:	75 61                	jne    80100ac2 <exec+0x11e>
    if(ph.memsz < ph.filesz)
80100a61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a6d:	0f 82 85 00 00 00    	jb     80100af8 <exec+0x154>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a79:	72 7d                	jb     80100af8 <exec+0x154>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a7b:	51                   	push   %ecx
80100a7c:	50                   	push   %eax
80100a7d:	57                   	push   %edi
80100a7e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a84:	e8 b7 58 00 00       	call   80106340 <allocuvm>
80100a89:	89 c7                	mov    %eax,%edi
80100a8b:	83 c4 10             	add    $0x10,%esp
80100a8e:	85 c0                	test   %eax,%eax
80100a90:	74 66                	je     80100af8 <exec+0x154>
    if(ph.vaddr % PGSIZE != 0)
80100a92:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a98:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a9d:	75 59                	jne    80100af8 <exec+0x154>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100aa8:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100aae:	53                   	push   %ebx
80100aaf:	50                   	push   %eax
80100ab0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ab6:	e8 c9 57 00 00       	call   80106284 <loaduvm>
80100abb:	83 c4 20             	add    $0x20,%esp
80100abe:	85 c0                	test   %eax,%eax
80100ac0:	78 36                	js     80100af8 <exec+0x154>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ac2:	ff 85 f4 fe ff ff    	incl   -0x10c(%ebp)
80100ac8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ace:	83 c6 20             	add    $0x20,%esi
80100ad1:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ad8:	39 c8                	cmp    %ecx,%eax
80100ada:	7e 34                	jle    80100b10 <exec+0x16c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100adc:	6a 20                	push   $0x20
80100ade:	56                   	push   %esi
80100adf:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ae5:	50                   	push   %eax
80100ae6:	53                   	push   %ebx
80100ae7:	e8 20 0d 00 00       	call   8010180c <readi>
80100aec:	83 c4 10             	add    $0x10,%esp
80100aef:	83 f8 20             	cmp    $0x20,%eax
80100af2:	0f 84 60 ff ff ff    	je     80100a58 <exec+0xb4>
    freevm(pgdir);
80100af8:	83 ec 0c             	sub    $0xc,%esp
80100afb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b01:	e8 7e 59 00 00       	call   80106484 <freevm>
  if(ip){
80100b06:	83 c4 10             	add    $0x10,%esp
80100b09:	e9 ec fe ff ff       	jmp    801009fa <exec+0x56>
80100b0e:	66 90                	xchg   %ax,%ax
80100b10:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b16:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b1c:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b22:	83 ec 0c             	sub    $0xc,%esp
80100b25:	53                   	push   %ebx
80100b26:	e8 95 0c 00 00       	call   801017c0 <iunlockput>
  end_op();
80100b2b:	e8 80 1d 00 00       	call   801028b0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b30:	83 c4 0c             	add    $0xc,%esp
80100b33:	56                   	push   %esi
80100b34:	57                   	push   %edi
80100b35:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b3b:	56                   	push   %esi
80100b3c:	e8 ff 57 00 00       	call   80106340 <allocuvm>
80100b41:	89 c7                	mov    %eax,%edi
80100b43:	83 c4 10             	add    $0x10,%esp
80100b46:	85 c0                	test   %eax,%eax
80100b48:	0f 84 8a 00 00 00    	je     80100bd8 <exec+0x234>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b4e:	83 ec 08             	sub    $0x8,%esp
80100b51:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b57:	50                   	push   %eax
80100b58:	56                   	push   %esi
80100b59:	e8 26 5a 00 00       	call   80106584 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b61:	8b 00                	mov    (%eax),%eax
80100b63:	83 c4 10             	add    $0x10,%esp
80100b66:	89 fb                	mov    %edi,%ebx
80100b68:	31 f6                	xor    %esi,%esi
80100b6a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100b70:	85 c0                	test   %eax,%eax
80100b72:	0f 84 81 00 00 00    	je     80100bf9 <exec+0x255>
80100b78:	89 bd f4 fe ff ff    	mov    %edi,-0x10c(%ebp)
80100b7e:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100b84:	eb 1f                	jmp    80100ba5 <exec+0x201>
80100b86:	66 90                	xchg   %ax,%ax
    ustack[3+argc] = sp;
80100b88:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100b8e:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b95:	46                   	inc    %esi
80100b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b99:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b9c:	85 c0                	test   %eax,%eax
80100b9e:	74 53                	je     80100bf3 <exec+0x24f>
    if(argc >= MAXARG)
80100ba0:	83 fe 20             	cmp    $0x20,%esi
80100ba3:	74 33                	je     80100bd8 <exec+0x234>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	50                   	push   %eax
80100ba9:	e8 4a 36 00 00       	call   801041f8 <strlen>
80100bae:	f7 d0                	not    %eax
80100bb0:	01 c3                	add    %eax,%ebx
80100bb2:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bb5:	5a                   	pop    %edx
80100bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb9:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bbc:	e8 37 36 00 00       	call   801041f8 <strlen>
80100bc1:	40                   	inc    %eax
80100bc2:	50                   	push   %eax
80100bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bc6:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bc9:	53                   	push   %ebx
80100bca:	57                   	push   %edi
80100bcb:	e8 f4 5a 00 00       	call   801066c4 <copyout>
80100bd0:	83 c4 20             	add    $0x20,%esp
80100bd3:	85 c0                	test   %eax,%eax
80100bd5:	79 b1                	jns    80100b88 <exec+0x1e4>
80100bd7:	90                   	nop
    freevm(pgdir);
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be1:	e8 9e 58 00 00       	call   80106484 <freevm>
80100be6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bee:	e9 1d fe ff ff       	jmp    80100a10 <exec+0x6c>
80100bf3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
  ustack[3+argc] = 0;
80100bf9:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c00:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c04:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c0b:	ff ff ff 
  ustack[1] = argc;
80100c0e:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c14:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c1b:	89 d9                	mov    %ebx,%ecx
80100c1d:	29 c1                	sub    %eax,%ecx
80100c1f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c25:	83 c0 0c             	add    $0xc,%eax
80100c28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c2a:	50                   	push   %eax
80100c2b:	52                   	push   %edx
80100c2c:	53                   	push   %ebx
80100c2d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c33:	e8 8c 5a 00 00       	call   801066c4 <copyout>
80100c38:	83 c4 10             	add    $0x10,%esp
80100c3b:	85 c0                	test   %eax,%eax
80100c3d:	78 99                	js     80100bd8 <exec+0x234>
  for(last=s=path; *s; s++)
80100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c42:	8a 00                	mov    (%eax),%al
80100c44:	8b 55 08             	mov    0x8(%ebp),%edx
80100c47:	84 c0                	test   %al,%al
80100c49:	74 12                	je     80100c5d <exec+0x2b9>
80100c4b:	89 d1                	mov    %edx,%ecx
80100c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
80100c50:	41                   	inc    %ecx
80100c51:	3c 2f                	cmp    $0x2f,%al
80100c53:	75 02                	jne    80100c57 <exec+0x2b3>
80100c55:	89 ca                	mov    %ecx,%edx
  for(last=s=path; *s; s++)
80100c57:	8a 01                	mov    (%ecx),%al
80100c59:	84 c0                	test   %al,%al
80100c5b:	75 f3                	jne    80100c50 <exec+0x2ac>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c5d:	50                   	push   %eax
80100c5e:	6a 10                	push   $0x10
80100c60:	52                   	push   %edx
80100c61:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c67:	89 f0                	mov    %esi,%eax
80100c69:	83 c0 6c             	add    $0x6c,%eax
80100c6c:	50                   	push   %eax
80100c6d:	e8 52 35 00 00       	call   801041c4 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c72:	89 f0                	mov    %esi,%eax
80100c74:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->pgdir = pgdir;
80100c77:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c7d:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100c80:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c82:	89 c7                	mov    %eax,%edi
80100c84:	8b 40 18             	mov    0x18(%eax),%eax
80100c87:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c8d:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c90:	8b 47 18             	mov    0x18(%edi),%eax
80100c93:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100c96:	89 3c 24             	mov    %edi,(%esp)
80100c99:	e8 76 54 00 00       	call   80106114 <switchuvm>
  freevm(oldpgdir);
80100c9e:	89 34 24             	mov    %esi,(%esp)
80100ca1:	e8 de 57 00 00       	call   80106484 <freevm>
  return 0;
80100ca6:	83 c4 10             	add    $0x10,%esp
80100ca9:	31 c0                	xor    %eax,%eax
80100cab:	e9 60 fd ff ff       	jmp    80100a10 <exec+0x6c>
    end_op();
80100cb0:	e8 fb 1b 00 00       	call   801028b0 <end_op>
    cprintf("exec: fail\n");
80100cb5:	83 ec 0c             	sub    $0xc,%esp
80100cb8:	68 e1 67 10 80       	push   $0x801067e1
80100cbd:	e8 5e f9 ff ff       	call   80100620 <cprintf>
    return -1;
80100cc2:	83 c4 10             	add    $0x10,%esp
80100cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cca:	e9 41 fd ff ff       	jmp    80100a10 <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ccf:	be 00 20 00 00       	mov    $0x2000,%esi
80100cd4:	e9 49 fe ff ff       	jmp    80100b22 <exec+0x17e>
80100cd9:	66 90                	xchg   %ax,%ax
80100cdb:	90                   	nop

80100cdc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100cdc:	55                   	push   %ebp
80100cdd:	89 e5                	mov    %esp,%ebp
80100cdf:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ce2:	68 ed 67 10 80       	push   $0x801067ed
80100ce7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cec:	e8 5f 31 00 00       	call   80103e50 <initlock>
}
80100cf1:	83 c4 10             	add    $0x10,%esp
80100cf4:	c9                   	leave  
80100cf5:	c3                   	ret    
80100cf6:	66 90                	xchg   %ax,%ax

80100cf8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100cf8:	55                   	push   %ebp
80100cf9:	89 e5                	mov    %esp,%ebp
80100cfb:	83 ec 24             	sub    $0x24,%esp
  struct file *f;

  acquire(&ftable.lock);
80100cfe:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d03:	e8 88 32 00 00       	call   80103f90 <acquire>
80100d08:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d0b:	b8 f4 ff 10 80       	mov    $0x8010fff4,%eax
80100d10:	eb 0c                	jmp    80100d1e <filealloc+0x26>
80100d12:	66 90                	xchg   %ax,%ax
80100d14:	83 c0 18             	add    $0x18,%eax
80100d17:	3d 54 09 11 80       	cmp    $0x80110954,%eax
80100d1c:	74 26                	je     80100d44 <filealloc+0x4c>
    if(f->ref == 0){
80100d1e:	8b 50 04             	mov    0x4(%eax),%edx
80100d21:	85 d2                	test   %edx,%edx
80100d23:	75 ef                	jne    80100d14 <filealloc+0x1c>
      f->ref = 1;
80100d25:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
80100d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      release(&ftable.lock);
80100d2f:	83 ec 0c             	sub    $0xc,%esp
80100d32:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d37:	e8 ec 32 00 00       	call   80104028 <release>
      return f;
80100d3c:	83 c4 10             	add    $0x10,%esp
80100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d42:	c9                   	leave  
80100d43:	c3                   	ret    
  release(&ftable.lock);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d4c:	e8 d7 32 00 00       	call   80104028 <release>
  return 0;
80100d51:	83 c4 10             	add    $0x10,%esp
80100d54:	31 c0                	xor    %eax,%eax
}
80100d56:	c9                   	leave  
80100d57:	c3                   	ret    

80100d58 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d58:	55                   	push   %ebp
80100d59:	89 e5                	mov    %esp,%ebp
80100d5b:	53                   	push   %ebx
80100d5c:	83 ec 10             	sub    $0x10,%esp
80100d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d62:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d67:	e8 24 32 00 00       	call   80103f90 <acquire>
  if(f->ref < 1)
80100d6c:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	85 c0                	test   %eax,%eax
80100d74:	7e 18                	jle    80100d8e <filedup+0x36>
    panic("filedup");
  f->ref++;
80100d76:	40                   	inc    %eax
80100d77:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d7a:	83 ec 0c             	sub    $0xc,%esp
80100d7d:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d82:	e8 a1 32 00 00       	call   80104028 <release>
  return f;
}
80100d87:	89 d8                	mov    %ebx,%eax
80100d89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d8c:	c9                   	leave  
80100d8d:	c3                   	ret    
    panic("filedup");
80100d8e:	83 ec 0c             	sub    $0xc,%esp
80100d91:	68 f4 67 10 80       	push   $0x801067f4
80100d96:	e8 a5 f5 ff ff       	call   80100340 <panic>
80100d9b:	90                   	nop

80100d9c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d9c:	55                   	push   %ebp
80100d9d:	89 e5                	mov    %esp,%ebp
80100d9f:	57                   	push   %edi
80100da0:	56                   	push   %esi
80100da1:	53                   	push   %ebx
80100da2:	83 ec 28             	sub    $0x28,%esp
80100da5:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100da8:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dad:	e8 de 31 00 00       	call   80103f90 <acquire>
  if(f->ref < 1)
80100db2:	8b 57 04             	mov    0x4(%edi),%edx
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	85 d2                	test   %edx,%edx
80100dba:	0f 8e 8d 00 00 00    	jle    80100e4d <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100dc0:	4a                   	dec    %edx
80100dc1:	89 57 04             	mov    %edx,0x4(%edi)
80100dc4:	75 3a                	jne    80100e00 <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100dc6:	8b 1f                	mov    (%edi),%ebx
80100dc8:	8a 47 09             	mov    0x9(%edi),%al
80100dcb:	88 45 e7             	mov    %al,-0x19(%ebp)
80100dce:	8b 77 0c             	mov    0xc(%edi),%esi
80100dd1:	8b 47 10             	mov    0x10(%edi),%eax
80100dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100dd7:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100ddd:	83 ec 0c             	sub    $0xc,%esp
80100de0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de5:	e8 3e 32 00 00       	call   80104028 <release>

  if(ff.type == FD_PIPE)
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	83 fb 01             	cmp    $0x1,%ebx
80100df0:	74 42                	je     80100e34 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100df2:	83 fb 02             	cmp    $0x2,%ebx
80100df5:	74 1d                	je     80100e14 <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dfa:	5b                   	pop    %ebx
80100dfb:	5e                   	pop    %esi
80100dfc:	5f                   	pop    %edi
80100dfd:	5d                   	pop    %ebp
80100dfe:	c3                   	ret    
80100dff:	90                   	nop
    release(&ftable.lock);
80100e00:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e0a:	5b                   	pop    %ebx
80100e0b:	5e                   	pop    %esi
80100e0c:	5f                   	pop    %edi
80100e0d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e0e:	e9 15 32 00 00       	jmp    80104028 <release>
80100e13:	90                   	nop
    begin_op();
80100e14:	e8 2f 1a 00 00       	call   80102848 <begin_op>
    iput(ff.ip);
80100e19:	83 ec 0c             	sub    $0xc,%esp
80100e1c:	ff 75 e0             	pushl  -0x20(%ebp)
80100e1f:	e8 50 08 00 00       	call   80101674 <iput>
    end_op();
80100e24:	83 c4 10             	add    $0x10,%esp
}
80100e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e2a:	5b                   	pop    %ebx
80100e2b:	5e                   	pop    %esi
80100e2c:	5f                   	pop    %edi
80100e2d:	5d                   	pop    %ebp
    end_op();
80100e2e:	e9 7d 1a 00 00       	jmp    801028b0 <end_op>
80100e33:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100e34:	83 ec 08             	sub    $0x8,%esp
80100e37:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e3b:	50                   	push   %eax
80100e3c:	56                   	push   %esi
80100e3d:	e8 fa 20 00 00       	call   80102f3c <pipeclose>
80100e42:	83 c4 10             	add    $0x10,%esp
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp
80100e4c:	c3                   	ret    
    panic("fileclose");
80100e4d:	83 ec 0c             	sub    $0xc,%esp
80100e50:	68 fc 67 10 80       	push   $0x801067fc
80100e55:	e8 e6 f4 ff ff       	call   80100340 <panic>
80100e5a:	66 90                	xchg   %ax,%ax

80100e5c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e5c:	55                   	push   %ebp
80100e5d:	89 e5                	mov    %esp,%ebp
80100e5f:	53                   	push   %ebx
80100e60:	53                   	push   %ebx
80100e61:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e64:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e67:	75 2b                	jne    80100e94 <filestat+0x38>
    ilock(f->ip);
80100e69:	83 ec 0c             	sub    $0xc,%esp
80100e6c:	ff 73 10             	pushl  0x10(%ebx)
80100e6f:	e8 f4 06 00 00       	call   80101568 <ilock>
    stati(f->ip, st);
80100e74:	58                   	pop    %eax
80100e75:	5a                   	pop    %edx
80100e76:	ff 75 0c             	pushl  0xc(%ebp)
80100e79:	ff 73 10             	pushl  0x10(%ebx)
80100e7c:	e8 5f 09 00 00       	call   801017e0 <stati>
    iunlock(f->ip);
80100e81:	59                   	pop    %ecx
80100e82:	ff 73 10             	pushl  0x10(%ebx)
80100e85:	e8 a6 07 00 00       	call   80101630 <iunlock>
    return 0;
80100e8a:	83 c4 10             	add    $0x10,%esp
80100e8d:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e92:	c9                   	leave  
80100e93:	c3                   	ret    
  return -1;
80100e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9c:	c9                   	leave  
80100e9d:	c3                   	ret    
80100e9e:	66 90                	xchg   %ax,%ax

80100ea0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	57                   	push   %edi
80100ea4:	56                   	push   %esi
80100ea5:	53                   	push   %ebx
80100ea6:	83 ec 1c             	sub    $0x1c,%esp
80100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100eac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100eaf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100eb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100eb6:	74 60                	je     80100f18 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100eb8:	8b 03                	mov    (%ebx),%eax
80100eba:	83 f8 01             	cmp    $0x1,%eax
80100ebd:	74 45                	je     80100f04 <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ebf:	83 f8 02             	cmp    $0x2,%eax
80100ec2:	75 5b                	jne    80100f1f <fileread+0x7f>
    ilock(f->ip);
80100ec4:	83 ec 0c             	sub    $0xc,%esp
80100ec7:	ff 73 10             	pushl  0x10(%ebx)
80100eca:	e8 99 06 00 00       	call   80101568 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ecf:	57                   	push   %edi
80100ed0:	ff 73 14             	pushl  0x14(%ebx)
80100ed3:	56                   	push   %esi
80100ed4:	ff 73 10             	pushl  0x10(%ebx)
80100ed7:	e8 30 09 00 00       	call   8010180c <readi>
80100edc:	83 c4 20             	add    $0x20,%esp
80100edf:	85 c0                	test   %eax,%eax
80100ee1:	7e 03                	jle    80100ee6 <fileread+0x46>
      f->off += r;
80100ee3:	01 43 14             	add    %eax,0x14(%ebx)
80100ee6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	ff 73 10             	pushl  0x10(%ebx)
80100eef:	e8 3c 07 00 00       	call   80101630 <iunlock>
    return r;
80100ef4:	83 c4 10             	add    $0x10,%esp
80100ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100efd:	5b                   	pop    %ebx
80100efe:	5e                   	pop    %esi
80100eff:	5f                   	pop    %edi
80100f00:	5d                   	pop    %ebp
80100f01:	c3                   	ret    
80100f02:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
80100f04:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f07:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f0d:	5b                   	pop    %ebx
80100f0e:	5e                   	pop    %esi
80100f0f:	5f                   	pop    %edi
80100f10:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f11:	e9 ae 21 00 00       	jmp    801030c4 <piperead>
80100f16:	66 90                	xchg   %ax,%ax
    return -1;
80100f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1d:	eb db                	jmp    80100efa <fileread+0x5a>
  panic("fileread");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 06 68 10 80       	push   $0x80106806
80100f27:	e8 14 f4 ff ff       	call   80100340 <panic>

80100f2c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f2c:	55                   	push   %ebp
80100f2d:	89 e5                	mov    %esp,%ebp
80100f2f:	57                   	push   %edi
80100f30:	56                   	push   %esi
80100f31:	53                   	push   %ebx
80100f32:	83 ec 1c             	sub    $0x1c,%esp
80100f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f3e:	8b 45 10             	mov    0x10(%ebp),%eax
80100f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100f44:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100f48:	0f 84 ae 00 00 00    	je     80100ffc <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100f4e:	8b 03                	mov    (%ebx),%eax
80100f50:	83 f8 01             	cmp    $0x1,%eax
80100f53:	0f 84 c2 00 00 00    	je     8010101b <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f59:	83 f8 02             	cmp    $0x2,%eax
80100f5c:	0f 85 cb 00 00 00    	jne    8010102d <filewrite+0x101>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100f62:	31 ff                	xor    %edi,%edi
    while(i < n){
80100f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f67:	85 c0                	test   %eax,%eax
80100f69:	7f 2c                	jg     80100f97 <filewrite+0x6b>
80100f6b:	e9 9c 00 00 00       	jmp    8010100c <filewrite+0xe0>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f70:	01 43 14             	add    %eax,0x14(%ebx)
80100f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	ff 73 10             	pushl  0x10(%ebx)
80100f7c:	e8 af 06 00 00       	call   80101630 <iunlock>
      end_op();
80100f81:	e8 2a 19 00 00       	call   801028b0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f8c:	39 c6                	cmp    %eax,%esi
80100f8e:	75 5f                	jne    80100fef <filewrite+0xc3>
        panic("short filewrite");
      i += r;
80100f90:	01 f7                	add    %esi,%edi
    while(i < n){
80100f92:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100f95:	7e 75                	jle    8010100c <filewrite+0xe0>
      if(n1 > max)
80100f97:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100f9a:	29 fe                	sub    %edi,%esi
80100f9c:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80100fa2:	7e 05                	jle    80100fa9 <filewrite+0x7d>
80100fa4:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80100fa9:	e8 9a 18 00 00       	call   80102848 <begin_op>
      ilock(f->ip);
80100fae:	83 ec 0c             	sub    $0xc,%esp
80100fb1:	ff 73 10             	pushl  0x10(%ebx)
80100fb4:	e8 af 05 00 00       	call   80101568 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100fb9:	56                   	push   %esi
80100fba:	ff 73 14             	pushl  0x14(%ebx)
80100fbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fc0:	01 f8                	add    %edi,%eax
80100fc2:	50                   	push   %eax
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 39 09 00 00       	call   80101904 <writei>
80100fcb:	83 c4 20             	add    $0x20,%esp
80100fce:	85 c0                	test   %eax,%eax
80100fd0:	7f 9e                	jg     80100f70 <filewrite+0x44>
80100fd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      iunlock(f->ip);
80100fd5:	83 ec 0c             	sub    $0xc,%esp
80100fd8:	ff 73 10             	pushl  0x10(%ebx)
80100fdb:	e8 50 06 00 00       	call   80101630 <iunlock>
      end_op();
80100fe0:	e8 cb 18 00 00       	call   801028b0 <end_op>
      if(r < 0)
80100fe5:	83 c4 10             	add    $0x10,%esp
80100fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100feb:	85 c0                	test   %eax,%eax
80100fed:	75 0d                	jne    80100ffc <filewrite+0xd0>
        panic("short filewrite");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 0f 68 10 80       	push   $0x8010680f
80100ff7:	e8 44 f3 ff ff       	call   80100340 <panic>
    }
    return i == n ? n : -1;
80100ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret    
80101009:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
8010100c:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010100f:	75 eb                	jne    80100ffc <filewrite+0xd0>
80101011:	89 f8                	mov    %edi,%eax
}
80101013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101016:	5b                   	pop    %ebx
80101017:	5e                   	pop    %esi
80101018:	5f                   	pop    %edi
80101019:	5d                   	pop    %ebp
8010101a:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010101b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010101e:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101028:	e9 a7 1f 00 00       	jmp    80102fd4 <pipewrite>
  panic("filewrite");
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 15 68 10 80       	push   $0x80106815
80101035:	e8 06 f3 ff ff       	call   80100340 <panic>
8010103a:	66 90                	xchg   %ax,%ax

8010103c <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010103c:	55                   	push   %ebp
8010103d:	89 e5                	mov    %esp,%ebp
8010103f:	57                   	push   %edi
80101040:	56                   	push   %esi
80101041:	53                   	push   %ebx
80101042:	83 ec 1c             	sub    $0x1c,%esp
80101045:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101048:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
8010104e:	85 c9                	test   %ecx,%ecx
80101050:	74 7e                	je     801010d0 <balloc+0x94>
80101052:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101059:	83 ec 08             	sub    $0x8,%esp
8010105c:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010105f:	89 f0                	mov    %esi,%eax
80101061:	c1 f8 0c             	sar    $0xc,%eax
80101064:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010106a:	50                   	push   %eax
8010106b:	ff 75 d8             	pushl  -0x28(%ebp)
8010106e:	e8 41 f0 ff ff       	call   801000b4 <bread>
80101073:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101075:	a1 c0 09 11 80       	mov    0x801109c0,%eax
8010107a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010107d:	83 c4 10             	add    $0x10,%esp
80101080:	31 c0                	xor    %eax,%eax
80101082:	eb 29                	jmp    801010ad <balloc+0x71>
      m = 1 << (bi % 8);
80101084:	89 c1                	mov    %eax,%ecx
80101086:	83 e1 07             	and    $0x7,%ecx
80101089:	bf 01 00 00 00       	mov    $0x1,%edi
8010108e:	d3 e7                	shl    %cl,%edi
80101090:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101093:	89 c1                	mov    %eax,%ecx
80101095:	c1 f9 03             	sar    $0x3,%ecx
80101098:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
8010109d:	89 fa                	mov    %edi,%edx
8010109f:	85 7d e4             	test   %edi,-0x1c(%ebp)
801010a2:	74 3c                	je     801010e0 <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010a4:	40                   	inc    %eax
801010a5:	46                   	inc    %esi
801010a6:	3d 00 10 00 00       	cmp    $0x1000,%eax
801010ab:	74 05                	je     801010b2 <balloc+0x76>
801010ad:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801010b0:	77 d2                	ja     80101084 <balloc+0x48>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801010b2:	83 ec 0c             	sub    $0xc,%esp
801010b5:	53                   	push   %ebx
801010b6:	e8 05 f1 ff ff       	call   801001c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010bb:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801010c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801010ce:	77 89                	ja     80101059 <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801010d0:	83 ec 0c             	sub    $0xc,%esp
801010d3:	68 1f 68 10 80       	push   $0x8010681f
801010d8:	e8 63 f2 ff ff       	call   80100340 <panic>
801010dd:	8d 76 00             	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801010e0:	0b 55 e4             	or     -0x1c(%ebp),%edx
801010e3:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
801010e7:	83 ec 0c             	sub    $0xc,%esp
801010ea:	53                   	push   %ebx
801010eb:	e8 14 19 00 00       	call   80102a04 <log_write>
        brelse(bp);
801010f0:	89 1c 24             	mov    %ebx,(%esp)
801010f3:	e8 c8 f0 ff ff       	call   801001c0 <brelse>
  bp = bread(dev, bno);
801010f8:	58                   	pop    %eax
801010f9:	5a                   	pop    %edx
801010fa:	56                   	push   %esi
801010fb:	ff 75 d8             	pushl  -0x28(%ebp)
801010fe:	e8 b1 ef ff ff       	call   801000b4 <bread>
80101103:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101105:	83 c4 0c             	add    $0xc,%esp
80101108:	68 00 02 00 00       	push   $0x200
8010110d:	6a 00                	push   $0x0
8010110f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101112:	50                   	push   %eax
80101113:	e8 58 2f 00 00       	call   80104070 <memset>
  log_write(bp);
80101118:	89 1c 24             	mov    %ebx,(%esp)
8010111b:	e8 e4 18 00 00       	call   80102a04 <log_write>
  brelse(bp);
80101120:	89 1c 24             	mov    %ebx,(%esp)
80101123:	e8 98 f0 ff ff       	call   801001c0 <brelse>
}
80101128:	89 f0                	mov    %esi,%eax
8010112a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010112d:	5b                   	pop    %ebx
8010112e:	5e                   	pop    %esi
8010112f:	5f                   	pop    %edi
80101130:	5d                   	pop    %ebp
80101131:	c3                   	ret    
80101132:	66 90                	xchg   %ax,%ax

80101134 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101134:	55                   	push   %ebp
80101135:	89 e5                	mov    %esp,%ebp
80101137:	57                   	push   %edi
80101138:	56                   	push   %esi
80101139:	53                   	push   %ebx
8010113a:	83 ec 28             	sub    $0x28,%esp
8010113d:	89 c6                	mov    %eax,%esi
8010113f:	89 d7                	mov    %edx,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101141:	68 e0 09 11 80       	push   $0x801109e0
80101146:	e8 45 2e 00 00       	call   80103f90 <acquire>
8010114b:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010114e:	31 c0                	xor    %eax,%eax
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101150:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
80101155:	eb 13                	jmp    8010116a <iget+0x36>
80101157:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101158:	39 33                	cmp    %esi,(%ebx)
8010115a:	74 68                	je     801011c4 <iget+0x90>
8010115c:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101162:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101168:	73 22                	jae    8010118c <iget+0x58>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010116a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010116d:	85 c9                	test   %ecx,%ecx
8010116f:	7f e7                	jg     80101158 <iget+0x24>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101171:	85 c0                	test   %eax,%eax
80101173:	75 e7                	jne    8010115c <iget+0x28>
80101175:	89 da                	mov    %ebx,%edx
80101177:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010117d:	85 c9                	test   %ecx,%ecx
8010117f:	75 66                	jne    801011e7 <iget+0xb3>
80101181:	89 d0                	mov    %edx,%eax
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101183:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101189:	72 df                	jb     8010116a <iget+0x36>
8010118b:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010118c:	85 c0                	test   %eax,%eax
8010118e:	74 6f                	je     801011ff <iget+0xcb>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101190:	89 30                	mov    %esi,(%eax)
  ip->inum = inum;
80101192:	89 78 04             	mov    %edi,0x4(%eax)
  ip->ref = 1;
80101195:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
8010119c:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
801011a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  release(&icache.lock);
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 e0 09 11 80       	push   $0x801109e0
801011ae:	e8 75 2e 00 00       	call   80104028 <release>

  return ip;
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801011b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bc:	5b                   	pop    %ebx
801011bd:	5e                   	pop    %esi
801011be:	5f                   	pop    %edi
801011bf:	5d                   	pop    %ebp
801011c0:	c3                   	ret    
801011c1:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011c4:	39 7b 04             	cmp    %edi,0x4(%ebx)
801011c7:	75 93                	jne    8010115c <iget+0x28>
      ip->ref++;
801011c9:	41                   	inc    %ecx
801011ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801011cd:	83 ec 0c             	sub    $0xc,%esp
801011d0:	68 e0 09 11 80       	push   $0x801109e0
801011d5:	e8 4e 2e 00 00       	call   80104028 <release>
      return ip;
801011da:	83 c4 10             	add    $0x10,%esp
801011dd:	89 d8                	mov    %ebx,%eax
}
801011df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e2:	5b                   	pop    %ebx
801011e3:	5e                   	pop    %esi
801011e4:	5f                   	pop    %edi
801011e5:	5d                   	pop    %ebp
801011e6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011e7:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011ed:	73 10                	jae    801011ff <iget+0xcb>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011ef:	8b 4b 08             	mov    0x8(%ebx),%ecx
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 8f 5e ff ff ff    	jg     80101158 <iget+0x24>
801011fa:	e9 76 ff ff ff       	jmp    80101175 <iget+0x41>
    panic("iget: no inodes");
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	68 35 68 10 80       	push   $0x80106835
80101207:	e8 34 f1 ff ff       	call   80100340 <panic>

8010120c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010120c:	55                   	push   %ebp
8010120d:	89 e5                	mov    %esp,%ebp
8010120f:	57                   	push   %edi
80101210:	56                   	push   %esi
80101211:	53                   	push   %ebx
80101212:	83 ec 1c             	sub    $0x1c,%esp
80101215:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101217:	83 fa 0b             	cmp    $0xb,%edx
8010121a:	0f 86 80 00 00 00    	jbe    801012a0 <bmap+0x94>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101220:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101223:	83 fb 7f             	cmp    $0x7f,%ebx
80101226:	0f 87 90 00 00 00    	ja     801012bc <bmap+0xb0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010122c:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101232:	8b 16                	mov    (%esi),%edx
80101234:	85 c0                	test   %eax,%eax
80101236:	74 54                	je     8010128c <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101238:	83 ec 08             	sub    $0x8,%esp
8010123b:	50                   	push   %eax
8010123c:	52                   	push   %edx
8010123d:	e8 72 ee ff ff       	call   801000b4 <bread>
80101242:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101244:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
80101248:	8b 03                	mov    (%ebx),%eax
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	85 c0                	test   %eax,%eax
8010124f:	74 1b                	je     8010126c <bmap+0x60>
80101251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101254:	83 ec 0c             	sub    $0xc,%esp
80101257:	57                   	push   %edi
80101258:	e8 63 ef ff ff       	call   801001c0 <brelse>
    return addr;
8010125d:	83 c4 10             	add    $0x10,%esp
80101260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
80101263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101266:	5b                   	pop    %ebx
80101267:	5e                   	pop    %esi
80101268:	5f                   	pop    %edi
80101269:	5d                   	pop    %ebp
8010126a:	c3                   	ret    
8010126b:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
8010126c:	8b 06                	mov    (%esi),%eax
8010126e:	e8 c9 fd ff ff       	call   8010103c <balloc>
80101273:	89 03                	mov    %eax,(%ebx)
80101275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	57                   	push   %edi
8010127c:	e8 83 17 00 00       	call   80102a04 <log_write>
80101281:	83 c4 10             	add    $0x10,%esp
80101284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101287:	eb c8                	jmp    80101251 <bmap+0x45>
80101289:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010128c:	89 d0                	mov    %edx,%eax
8010128e:	e8 a9 fd ff ff       	call   8010103c <balloc>
80101293:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101299:	8b 16                	mov    (%esi),%edx
8010129b:	eb 9b                	jmp    80101238 <bmap+0x2c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
    if((addr = ip->addrs[bn]) == 0)
801012a0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801012a3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012a6:	85 c0                	test   %eax,%eax
801012a8:	75 b9                	jne    80101263 <bmap+0x57>
      ip->addrs[bn] = addr = balloc(ip->dev);
801012aa:	8b 06                	mov    (%esi),%eax
801012ac:	e8 8b fd ff ff       	call   8010103c <balloc>
801012b1:	89 43 5c             	mov    %eax,0x5c(%ebx)
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b7:	5b                   	pop    %ebx
801012b8:	5e                   	pop    %esi
801012b9:	5f                   	pop    %edi
801012ba:	5d                   	pop    %ebp
801012bb:	c3                   	ret    
  panic("bmap: out of range");
801012bc:	83 ec 0c             	sub    $0xc,%esp
801012bf:	68 45 68 10 80       	push   $0x80106845
801012c4:	e8 77 f0 ff ff       	call   80100340 <panic>
801012c9:	8d 76 00             	lea    0x0(%esi),%esi

801012cc <readsb>:
{
801012cc:	55                   	push   %ebp
801012cd:	89 e5                	mov    %esp,%ebp
801012cf:	56                   	push   %esi
801012d0:	53                   	push   %ebx
801012d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	6a 01                	push   $0x1
801012d9:	ff 75 08             	pushl  0x8(%ebp)
801012dc:	e8 d3 ed ff ff       	call   801000b4 <bread>
801012e1:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012e3:	83 c4 0c             	add    $0xc,%esp
801012e6:	6a 1c                	push   $0x1c
801012e8:	8d 40 5c             	lea    0x5c(%eax),%eax
801012eb:	50                   	push   %eax
801012ec:	56                   	push   %esi
801012ed:	e8 02 2e 00 00       	call   801040f4 <memmove>
  brelse(bp);
801012f2:	83 c4 10             	add    $0x10,%esp
801012f5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801012f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012fb:	5b                   	pop    %ebx
801012fc:	5e                   	pop    %esi
801012fd:	5d                   	pop    %ebp
  brelse(bp);
801012fe:	e9 bd ee ff ff       	jmp    801001c0 <brelse>
80101303:	90                   	nop

80101304 <bfree>:
{
80101304:	55                   	push   %ebp
80101305:	89 e5                	mov    %esp,%ebp
80101307:	56                   	push   %esi
80101308:	53                   	push   %ebx
80101309:	89 c6                	mov    %eax,%esi
8010130b:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
8010130d:	83 ec 08             	sub    $0x8,%esp
80101310:	68 c0 09 11 80       	push   $0x801109c0
80101315:	50                   	push   %eax
80101316:	e8 b1 ff ff ff       	call   801012cc <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010131b:	58                   	pop    %eax
8010131c:	5a                   	pop    %edx
8010131d:	89 d8                	mov    %ebx,%eax
8010131f:	c1 e8 0c             	shr    $0xc,%eax
80101322:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101328:	50                   	push   %eax
80101329:	56                   	push   %esi
8010132a:	e8 85 ed ff ff       	call   801000b4 <bread>
  m = 1 << (bi % 8);
8010132f:	89 d9                	mov    %ebx,%ecx
80101331:	83 e1 07             	and    $0x7,%ecx
80101334:	ba 01 00 00 00       	mov    $0x1,%edx
80101339:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
8010133b:	c1 fb 03             	sar    $0x3,%ebx
8010133e:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101344:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101349:	83 c4 10             	add    $0x10,%esp
8010134c:	85 d1                	test   %edx,%ecx
8010134e:	74 25                	je     80101375 <bfree+0x71>
80101350:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101352:	f7 d2                	not    %edx
80101354:	21 ca                	and    %ecx,%edx
80101356:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010135a:	83 ec 0c             	sub    $0xc,%esp
8010135d:	50                   	push   %eax
8010135e:	e8 a1 16 00 00       	call   80102a04 <log_write>
  brelse(bp);
80101363:	89 34 24             	mov    %esi,(%esp)
80101366:	e8 55 ee ff ff       	call   801001c0 <brelse>
}
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101371:	5b                   	pop    %ebx
80101372:	5e                   	pop    %esi
80101373:	5d                   	pop    %ebp
80101374:	c3                   	ret    
    panic("freeing free block");
80101375:	83 ec 0c             	sub    $0xc,%esp
80101378:	68 58 68 10 80       	push   $0x80106858
8010137d:	e8 be ef ff ff       	call   80100340 <panic>
80101382:	66 90                	xchg   %ax,%ax

80101384 <iinit>:
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	53                   	push   %ebx
80101388:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010138b:	68 6b 68 10 80       	push   $0x8010686b
80101390:	68 e0 09 11 80       	push   $0x801109e0
80101395:	e8 b6 2a 00 00       	call   80103e50 <initlock>
  for(i = 0; i < NINODE; i++) {
8010139a:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010139f:	83 c4 10             	add    $0x10,%esp
801013a2:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801013a4:	83 ec 08             	sub    $0x8,%esp
801013a7:	68 72 68 10 80       	push   $0x80106872
801013ac:	53                   	push   %ebx
801013ad:	e8 8e 29 00 00       	call   80103d40 <initsleeplock>
801013b2:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(i = 0; i < NINODE; i++) {
801013b8:	83 c4 10             	add    $0x10,%esp
801013bb:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801013c1:	75 e1                	jne    801013a4 <iinit+0x20>
  readsb(dev, &sb);
801013c3:	83 ec 08             	sub    $0x8,%esp
801013c6:	68 c0 09 11 80       	push   $0x801109c0
801013cb:	ff 75 08             	pushl  0x8(%ebp)
801013ce:	e8 f9 fe ff ff       	call   801012cc <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801013d3:	ff 35 d8 09 11 80    	pushl  0x801109d8
801013d9:	ff 35 d4 09 11 80    	pushl  0x801109d4
801013df:	ff 35 d0 09 11 80    	pushl  0x801109d0
801013e5:	ff 35 cc 09 11 80    	pushl  0x801109cc
801013eb:	ff 35 c8 09 11 80    	pushl  0x801109c8
801013f1:	ff 35 c4 09 11 80    	pushl  0x801109c4
801013f7:	ff 35 c0 09 11 80    	pushl  0x801109c0
801013fd:	68 d8 68 10 80       	push   $0x801068d8
80101402:	e8 19 f2 ff ff       	call   80100620 <cprintf>
}
80101407:	83 c4 30             	add    $0x30,%esp
8010140a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010140d:	c9                   	leave  
8010140e:	c3                   	ret    
8010140f:	90                   	nop

80101410 <ialloc>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	83 ec 1c             	sub    $0x1c,%esp
80101419:	8b 75 08             	mov    0x8(%ebp),%esi
8010141c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010141f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101422:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80101429:	0f 86 84 00 00 00    	jbe    801014b3 <ialloc+0xa3>
8010142f:	bf 01 00 00 00       	mov    $0x1,%edi
80101434:	eb 17                	jmp    8010144d <ialloc+0x3d>
80101436:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101438:	83 ec 0c             	sub    $0xc,%esp
8010143b:	53                   	push   %ebx
8010143c:	e8 7f ed ff ff       	call   801001c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101441:	47                   	inc    %edi
80101442:	83 c4 10             	add    $0x10,%esp
80101445:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
8010144b:	73 66                	jae    801014b3 <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
8010144d:	83 ec 08             	sub    $0x8,%esp
80101450:	89 f8                	mov    %edi,%eax
80101452:	c1 e8 03             	shr    $0x3,%eax
80101455:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010145b:	50                   	push   %eax
8010145c:	56                   	push   %esi
8010145d:	e8 52 ec ff ff       	call   801000b4 <bread>
80101462:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101464:	89 f8                	mov    %edi,%eax
80101466:	83 e0 07             	and    $0x7,%eax
80101469:	c1 e0 06             	shl    $0x6,%eax
8010146c:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101470:	83 c4 10             	add    $0x10,%esp
80101473:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101477:	75 bf                	jne    80101438 <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
80101479:	50                   	push   %eax
8010147a:	6a 40                	push   $0x40
8010147c:	6a 00                	push   $0x0
8010147e:	51                   	push   %ecx
8010147f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101482:	e8 e9 2b 00 00       	call   80104070 <memset>
      dip->type = type;
80101487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010148a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010148d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	e8 6c 15 00 00       	call   80102a04 <log_write>
      brelse(bp);
80101498:	89 1c 24             	mov    %ebx,(%esp)
8010149b:	e8 20 ed ff ff       	call   801001c0 <brelse>
      return iget(dev, inum);
801014a0:	83 c4 10             	add    $0x10,%esp
801014a3:	89 fa                	mov    %edi,%edx
801014a5:	89 f0                	mov    %esi,%eax
}
801014a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014aa:	5b                   	pop    %ebx
801014ab:	5e                   	pop    %esi
801014ac:	5f                   	pop    %edi
801014ad:	5d                   	pop    %ebp
      return iget(dev, inum);
801014ae:	e9 81 fc ff ff       	jmp    80101134 <iget>
  panic("ialloc: no inodes");
801014b3:	83 ec 0c             	sub    $0xc,%esp
801014b6:	68 78 68 10 80       	push   $0x80106878
801014bb:	e8 80 ee ff ff       	call   80100340 <panic>

801014c0 <iupdate>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014c8:	83 ec 08             	sub    $0x8,%esp
801014cb:	8b 43 04             	mov    0x4(%ebx),%eax
801014ce:	c1 e8 03             	shr    $0x3,%eax
801014d1:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801014d7:	50                   	push   %eax
801014d8:	ff 33                	pushl  (%ebx)
801014da:	e8 d5 eb ff ff       	call   801000b4 <bread>
801014df:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801014e1:	8b 43 04             	mov    0x4(%ebx),%eax
801014e4:	83 e0 07             	and    $0x7,%eax
801014e7:	c1 e0 06             	shl    $0x6,%eax
801014ea:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014ee:	8b 53 50             	mov    0x50(%ebx),%edx
801014f1:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014f4:	66 8b 53 52          	mov    0x52(%ebx),%dx
801014f8:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014fc:	8b 53 54             	mov    0x54(%ebx),%edx
801014ff:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101503:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101507:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010150b:	8b 53 58             	mov    0x58(%ebx),%edx
8010150e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101511:	83 c4 0c             	add    $0xc,%esp
80101514:	6a 34                	push   $0x34
80101516:	83 c3 5c             	add    $0x5c,%ebx
80101519:	53                   	push   %ebx
8010151a:	83 c0 0c             	add    $0xc,%eax
8010151d:	50                   	push   %eax
8010151e:	e8 d1 2b 00 00       	call   801040f4 <memmove>
  log_write(bp);
80101523:	89 34 24             	mov    %esi,(%esp)
80101526:	e8 d9 14 00 00       	call   80102a04 <log_write>
  brelse(bp);
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101531:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101534:	5b                   	pop    %ebx
80101535:	5e                   	pop    %esi
80101536:	5d                   	pop    %ebp
  brelse(bp);
80101537:	e9 84 ec ff ff       	jmp    801001c0 <brelse>

8010153c <idup>:
{
8010153c:	55                   	push   %ebp
8010153d:	89 e5                	mov    %esp,%ebp
8010153f:	53                   	push   %ebx
80101540:	83 ec 10             	sub    $0x10,%esp
80101543:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101546:	68 e0 09 11 80       	push   $0x801109e0
8010154b:	e8 40 2a 00 00       	call   80103f90 <acquire>
  ip->ref++;
80101550:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101553:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010155a:	e8 c9 2a 00 00       	call   80104028 <release>
}
8010155f:	89 d8                	mov    %ebx,%eax
80101561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101564:	c9                   	leave  
80101565:	c3                   	ret    
80101566:	66 90                	xchg   %ax,%ax

80101568 <ilock>:
{
80101568:	55                   	push   %ebp
80101569:	89 e5                	mov    %esp,%ebp
8010156b:	56                   	push   %esi
8010156c:	53                   	push   %ebx
8010156d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101570:	85 db                	test   %ebx,%ebx
80101572:	0f 84 a9 00 00 00    	je     80101621 <ilock+0xb9>
80101578:	8b 53 08             	mov    0x8(%ebx),%edx
8010157b:	85 d2                	test   %edx,%edx
8010157d:	0f 8e 9e 00 00 00    	jle    80101621 <ilock+0xb9>
  acquiresleep(&ip->lock);
80101583:	83 ec 0c             	sub    $0xc,%esp
80101586:	8d 43 0c             	lea    0xc(%ebx),%eax
80101589:	50                   	push   %eax
8010158a:	e8 e5 27 00 00       	call   80103d74 <acquiresleep>
  if(ip->valid == 0){
8010158f:	83 c4 10             	add    $0x10,%esp
80101592:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101595:	85 c0                	test   %eax,%eax
80101597:	74 07                	je     801015a0 <ilock+0x38>
}
80101599:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159c:	5b                   	pop    %ebx
8010159d:	5e                   	pop    %esi
8010159e:	5d                   	pop    %ebp
8010159f:	c3                   	ret    
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	8b 43 04             	mov    0x4(%ebx),%eax
801015a6:	c1 e8 03             	shr    $0x3,%eax
801015a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015af:	50                   	push   %eax
801015b0:	ff 33                	pushl  (%ebx)
801015b2:	e8 fd ea ff ff       	call   801000b4 <bread>
801015b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015b9:	8b 43 04             	mov    0x4(%ebx),%eax
801015bc:	83 e0 07             	and    $0x7,%eax
801015bf:	c1 e0 06             	shl    $0x6,%eax
801015c2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015c6:	8b 10                	mov    (%eax),%edx
801015c8:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015cc:	66 8b 50 02          	mov    0x2(%eax),%dx
801015d0:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015d4:	8b 50 04             	mov    0x4(%eax),%edx
801015d7:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015db:	66 8b 50 06          	mov    0x6(%eax),%dx
801015df:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015e3:	8b 50 08             	mov    0x8(%eax),%edx
801015e6:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015e9:	83 c4 0c             	add    $0xc,%esp
801015ec:	6a 34                	push   $0x34
801015ee:	83 c0 0c             	add    $0xc,%eax
801015f1:	50                   	push   %eax
801015f2:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015f5:	50                   	push   %eax
801015f6:	e8 f9 2a 00 00       	call   801040f4 <memmove>
    brelse(bp);
801015fb:	89 34 24             	mov    %esi,(%esp)
801015fe:	e8 bd eb ff ff       	call   801001c0 <brelse>
    ip->valid = 1;
80101603:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010160a:	83 c4 10             	add    $0x10,%esp
8010160d:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101612:	75 85                	jne    80101599 <ilock+0x31>
      panic("ilock: no type");
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	68 90 68 10 80       	push   $0x80106890
8010161c:	e8 1f ed ff ff       	call   80100340 <panic>
    panic("ilock");
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	68 8a 68 10 80       	push   $0x8010688a
80101629:	e8 12 ed ff ff       	call   80100340 <panic>
8010162e:	66 90                	xchg   %ax,%ax

80101630 <iunlock>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101638:	85 db                	test   %ebx,%ebx
8010163a:	74 28                	je     80101664 <iunlock+0x34>
8010163c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	56                   	push   %esi
80101643:	e8 bc 27 00 00       	call   80103e04 <holdingsleep>
80101648:	83 c4 10             	add    $0x10,%esp
8010164b:	85 c0                	test   %eax,%eax
8010164d:	74 15                	je     80101664 <iunlock+0x34>
8010164f:	8b 43 08             	mov    0x8(%ebx),%eax
80101652:	85 c0                	test   %eax,%eax
80101654:	7e 0e                	jle    80101664 <iunlock+0x34>
  releasesleep(&ip->lock);
80101656:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101659:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165c:	5b                   	pop    %ebx
8010165d:	5e                   	pop    %esi
8010165e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010165f:	e9 64 27 00 00       	jmp    80103dc8 <releasesleep>
    panic("iunlock");
80101664:	83 ec 0c             	sub    $0xc,%esp
80101667:	68 9f 68 10 80       	push   $0x8010689f
8010166c:	e8 cf ec ff ff       	call   80100340 <panic>
80101671:	8d 76 00             	lea    0x0(%esi),%esi

80101674 <iput>:
{
80101674:	55                   	push   %ebp
80101675:	89 e5                	mov    %esp,%ebp
80101677:	57                   	push   %edi
80101678:	56                   	push   %esi
80101679:	53                   	push   %ebx
8010167a:	83 ec 28             	sub    $0x28,%esp
8010167d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101680:	8d 73 0c             	lea    0xc(%ebx),%esi
80101683:	56                   	push   %esi
80101684:	e8 eb 26 00 00       	call   80103d74 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101689:	83 c4 10             	add    $0x10,%esp
8010168c:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010168f:	85 c0                	test   %eax,%eax
80101691:	74 07                	je     8010169a <iput+0x26>
80101693:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101698:	74 2e                	je     801016c8 <iput+0x54>
  releasesleep(&ip->lock);
8010169a:	83 ec 0c             	sub    $0xc,%esp
8010169d:	56                   	push   %esi
8010169e:	e8 25 27 00 00       	call   80103dc8 <releasesleep>
  acquire(&icache.lock);
801016a3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016aa:	e8 e1 28 00 00       	call   80103f90 <acquire>
  ip->ref--;
801016af:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801016bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016bf:	5b                   	pop    %ebx
801016c0:	5e                   	pop    %esi
801016c1:	5f                   	pop    %edi
801016c2:	5d                   	pop    %ebp
  release(&icache.lock);
801016c3:	e9 60 29 00 00       	jmp    80104028 <release>
    acquire(&icache.lock);
801016c8:	83 ec 0c             	sub    $0xc,%esp
801016cb:	68 e0 09 11 80       	push   $0x801109e0
801016d0:	e8 bb 28 00 00       	call   80103f90 <acquire>
    int r = ip->ref;
801016d5:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016df:	e8 44 29 00 00       	call   80104028 <release>
    if(r == 1){
801016e4:	83 c4 10             	add    $0x10,%esp
801016e7:	4f                   	dec    %edi
801016e8:	75 b0                	jne    8010169a <iput+0x26>
801016ea:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801016ed:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801016f3:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801016f6:	89 fe                	mov    %edi,%esi
801016f8:	89 c7                	mov    %eax,%edi
801016fa:	eb 07                	jmp    80101703 <iput+0x8f>
801016fc:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801016ff:	39 fe                	cmp    %edi,%esi
80101701:	74 15                	je     80101718 <iput+0xa4>
    if(ip->addrs[i]){
80101703:	8b 16                	mov    (%esi),%edx
80101705:	85 d2                	test   %edx,%edx
80101707:	74 f3                	je     801016fc <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
80101709:	8b 03                	mov    (%ebx),%eax
8010170b:	e8 f4 fb ff ff       	call   80101304 <bfree>
      ip->addrs[i] = 0;
80101710:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101716:	eb e4                	jmp    801016fc <iput+0x88>
80101718:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
8010171b:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101721:	85 c0                	test   %eax,%eax
80101723:	75 2f                	jne    80101754 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101725:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010172c:	83 ec 0c             	sub    $0xc,%esp
8010172f:	53                   	push   %ebx
80101730:	e8 8b fd ff ff       	call   801014c0 <iupdate>
      ip->type = 0;
80101735:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
8010173b:	89 1c 24             	mov    %ebx,(%esp)
8010173e:	e8 7d fd ff ff       	call   801014c0 <iupdate>
      ip->valid = 0;
80101743:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	e9 48 ff ff ff       	jmp    8010169a <iput+0x26>
80101752:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101754:	83 ec 08             	sub    $0x8,%esp
80101757:	50                   	push   %eax
80101758:	ff 33                	pushl  (%ebx)
8010175a:	e8 55 e9 ff ff       	call   801000b4 <bread>
8010175f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101762:	8d 78 5c             	lea    0x5c(%eax),%edi
80101765:	05 5c 02 00 00       	add    $0x25c,%eax
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101770:	89 fe                	mov    %edi,%esi
80101772:	89 c7                	mov    %eax,%edi
80101774:	eb 09                	jmp    8010177f <iput+0x10b>
80101776:	66 90                	xchg   %ax,%ax
80101778:	83 c6 04             	add    $0x4,%esi
8010177b:	39 f7                	cmp    %esi,%edi
8010177d:	74 11                	je     80101790 <iput+0x11c>
      if(a[j])
8010177f:	8b 16                	mov    (%esi),%edx
80101781:	85 d2                	test   %edx,%edx
80101783:	74 f3                	je     80101778 <iput+0x104>
        bfree(ip->dev, a[j]);
80101785:	8b 03                	mov    (%ebx),%eax
80101787:	e8 78 fb ff ff       	call   80101304 <bfree>
8010178c:	eb ea                	jmp    80101778 <iput+0x104>
8010178e:	66 90                	xchg   %ax,%ax
80101790:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101793:	83 ec 0c             	sub    $0xc,%esp
80101796:	ff 75 e4             	pushl  -0x1c(%ebp)
80101799:	e8 22 ea ff ff       	call   801001c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010179e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801017a4:	8b 03                	mov    (%ebx),%eax
801017a6:	e8 59 fb ff ff       	call   80101304 <bfree>
    ip->addrs[NDIRECT] = 0;
801017ab:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801017b2:	00 00 00 
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	e9 68 ff ff ff       	jmp    80101725 <iput+0xb1>
801017bd:	8d 76 00             	lea    0x0(%esi),%esi

801017c0 <iunlockput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017ca:	53                   	push   %ebx
801017cb:	e8 60 fe ff ff       	call   80101630 <iunlock>
  iput(ip);
801017d0:	83 c4 10             	add    $0x10,%esp
801017d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017d9:	c9                   	leave  
  iput(ip);
801017da:	e9 95 fe ff ff       	jmp    80101674 <iput>
801017df:	90                   	nop

801017e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	8b 55 08             	mov    0x8(%ebp),%edx
801017e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017e9:	8b 0a                	mov    (%edx),%ecx
801017eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801017f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017f4:	8b 4a 50             	mov    0x50(%edx),%ecx
801017f7:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017fa:	66 8b 4a 56          	mov    0x56(%edx),%cx
801017fe:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101802:	8b 52 58             	mov    0x58(%edx),%edx
80101805:	89 50 10             	mov    %edx,0x10(%eax)
}
80101808:	5d                   	pop    %ebp
80101809:	c3                   	ret    
8010180a:	66 90                	xchg   %ax,%ax

8010180c <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010180c:	55                   	push   %ebp
8010180d:	89 e5                	mov    %esp,%ebp
8010180f:	57                   	push   %edi
80101810:	56                   	push   %esi
80101811:	53                   	push   %ebx
80101812:	83 ec 1c             	sub    $0x1c,%esp
80101815:	8b 7d 08             	mov    0x8(%ebp),%edi
80101818:	8b 45 0c             	mov    0xc(%ebp),%eax
8010181b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010181e:	8b 45 10             	mov    0x10(%ebp),%eax
80101821:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101824:	8b 45 14             	mov    0x14(%ebp),%eax
80101827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010182a:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
8010182f:	0f 84 a3 00 00 00    	je     801018d8 <readi+0xcc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101835:	8b 47 58             	mov    0x58(%edi),%eax
80101838:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010183b:	39 c3                	cmp    %eax,%ebx
8010183d:	0f 87 b9 00 00 00    	ja     801018fc <readi+0xf0>
80101843:	89 da                	mov    %ebx,%edx
80101845:	31 c9                	xor    %ecx,%ecx
80101847:	03 55 e4             	add    -0x1c(%ebp),%edx
8010184a:	0f 92 c1             	setb   %cl
8010184d:	89 ce                	mov    %ecx,%esi
8010184f:	0f 82 a7 00 00 00    	jb     801018fc <readi+0xf0>
    return -1;
  if(off + n > ip->size)
80101855:	39 d0                	cmp    %edx,%eax
80101857:	72 77                	jb     801018d0 <readi+0xc4>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101859:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 65                	je     801018c5 <readi+0xb9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101860:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101863:	89 da                	mov    %ebx,%edx
80101865:	c1 ea 09             	shr    $0x9,%edx
80101868:	89 f8                	mov    %edi,%eax
8010186a:	e8 9d f9 ff ff       	call   8010120c <bmap>
8010186f:	83 ec 08             	sub    $0x8,%esp
80101872:	50                   	push   %eax
80101873:	ff 37                	pushl  (%edi)
80101875:	e8 3a e8 ff ff       	call   801000b4 <bread>
8010187a:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
8010187c:	89 d8                	mov    %ebx,%eax
8010187e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101883:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101886:	29 f1                	sub    %esi,%ecx
80101888:	bb 00 02 00 00       	mov    $0x200,%ebx
8010188d:	29 c3                	sub    %eax,%ebx
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	39 cb                	cmp    %ecx,%ebx
80101894:	76 02                	jbe    80101898 <readi+0x8c>
80101896:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101898:	51                   	push   %ecx
80101899:	53                   	push   %ebx
8010189a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
8010189e:	89 55 d8             	mov    %edx,-0x28(%ebp)
801018a1:	50                   	push   %eax
801018a2:	ff 75 dc             	pushl  -0x24(%ebp)
801018a5:	e8 4a 28 00 00       	call   801040f4 <memmove>
    brelse(bp);
801018aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
801018ad:	89 14 24             	mov    %edx,(%esp)
801018b0:	e8 0b e9 ff ff       	call   801001c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018b5:	01 de                	add    %ebx,%esi
801018b7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801018ba:	01 5d dc             	add    %ebx,-0x24(%ebp)
801018bd:	83 c4 10             	add    $0x10,%esp
801018c0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801018c3:	77 9b                	ja     80101860 <readi+0x54>
  }
  return n;
801018c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801018c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018cb:	5b                   	pop    %ebx
801018cc:	5e                   	pop    %esi
801018cd:	5f                   	pop    %edi
801018ce:	5d                   	pop    %ebp
801018cf:	c3                   	ret    
    n = ip->size - off;
801018d0:	29 d8                	sub    %ebx,%eax
801018d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018d5:	eb 82                	jmp    80101859 <readi+0x4d>
801018d7:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018d8:	0f bf 47 52          	movswl 0x52(%edi),%eax
801018dc:	66 83 f8 09          	cmp    $0x9,%ax
801018e0:	77 1a                	ja     801018fc <readi+0xf0>
801018e2:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801018e9:	85 c0                	test   %eax,%eax
801018eb:	74 0f                	je     801018fc <readi+0xf0>
    return devsw[ip->major].read(ip, dst, n);
801018ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f0:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801018f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f6:	5b                   	pop    %ebx
801018f7:	5e                   	pop    %esi
801018f8:	5f                   	pop    %edi
801018f9:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801018fa:	ff e0                	jmp    *%eax
      return -1;
801018fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101901:	eb c5                	jmp    801018c8 <readi+0xbc>
80101903:	90                   	nop

80101904 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101904:	55                   	push   %ebp
80101905:	89 e5                	mov    %esp,%ebp
80101907:	57                   	push   %edi
80101908:	56                   	push   %esi
80101909:	53                   	push   %ebx
8010190a:	83 ec 1c             	sub    $0x1c,%esp
8010190d:	8b 45 08             	mov    0x8(%ebp),%eax
80101910:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101913:	8b 75 0c             	mov    0xc(%ebp),%esi
80101916:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101919:	8b 75 10             	mov    0x10(%ebp),%esi
8010191c:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010191f:	8b 75 14             	mov    0x14(%ebp),%esi
80101922:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101925:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010192a:	0f 84 b0 00 00 00    	je     801019e0 <writei+0xdc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101930:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101933:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101936:	39 46 58             	cmp    %eax,0x58(%esi)
80101939:	0f 82 dc 00 00 00    	jb     80101a1b <writei+0x117>
8010193f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101942:	31 c9                	xor    %ecx,%ecx
80101944:	01 d0                	add    %edx,%eax
80101946:	0f 92 c1             	setb   %cl
80101949:	89 ce                	mov    %ecx,%esi
8010194b:	0f 82 ca 00 00 00    	jb     80101a1b <writei+0x117>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101951:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101956:	0f 87 bf 00 00 00    	ja     80101a1b <writei+0x117>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010195c:	85 d2                	test   %edx,%edx
8010195e:	74 75                	je     801019d5 <writei+0xd1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101960:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101963:	89 da                	mov    %ebx,%edx
80101965:	c1 ea 09             	shr    $0x9,%edx
80101968:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010196b:	89 f8                	mov    %edi,%eax
8010196d:	e8 9a f8 ff ff       	call   8010120c <bmap>
80101972:	83 ec 08             	sub    $0x8,%esp
80101975:	50                   	push   %eax
80101976:	ff 37                	pushl  (%edi)
80101978:	e8 37 e7 ff ff       	call   801000b4 <bread>
8010197d:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
8010197f:	89 d8                	mov    %ebx,%eax
80101981:	25 ff 01 00 00       	and    $0x1ff,%eax
80101986:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101989:	29 f1                	sub    %esi,%ecx
8010198b:	bb 00 02 00 00       	mov    $0x200,%ebx
80101990:	29 c3                	sub    %eax,%ebx
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	39 cb                	cmp    %ecx,%ebx
80101997:	76 02                	jbe    8010199b <writei+0x97>
80101999:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010199b:	52                   	push   %edx
8010199c:	53                   	push   %ebx
8010199d:	ff 75 dc             	pushl  -0x24(%ebp)
801019a0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
801019a4:	50                   	push   %eax
801019a5:	e8 4a 27 00 00       	call   801040f4 <memmove>
    log_write(bp);
801019aa:	89 3c 24             	mov    %edi,(%esp)
801019ad:	e8 52 10 00 00       	call   80102a04 <log_write>
    brelse(bp);
801019b2:	89 3c 24             	mov    %edi,(%esp)
801019b5:	e8 06 e8 ff ff       	call   801001c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019ba:	01 de                	add    %ebx,%esi
801019bc:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019bf:	01 5d dc             	add    %ebx,-0x24(%ebp)
801019c2:	83 c4 10             	add    $0x10,%esp
801019c5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801019c8:	77 96                	ja     80101960 <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
801019ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
801019d0:	3b 70 58             	cmp    0x58(%eax),%esi
801019d3:	77 2f                	ja     80101a04 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801019d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019db:	5b                   	pop    %ebx
801019dc:	5e                   	pop    %esi
801019dd:	5f                   	pop    %edi
801019de:	5d                   	pop    %ebp
801019df:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019e0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019e4:	66 83 f8 09          	cmp    $0x9,%ax
801019e8:	77 31                	ja     80101a1b <writei+0x117>
801019ea:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801019f1:	85 c0                	test   %eax,%eax
801019f3:	74 26                	je     80101a1b <writei+0x117>
    return devsw[ip->major].write(ip, src, n);
801019f5:	89 75 10             	mov    %esi,0x10(%ebp)
}
801019f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019fb:	5b                   	pop    %ebx
801019fc:	5e                   	pop    %esi
801019fd:	5f                   	pop    %edi
801019fe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801019ff:	ff e0                	jmp    *%eax
80101a01:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
80101a04:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a07:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101a0a:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a0d:	83 ec 0c             	sub    $0xc,%esp
80101a10:	50                   	push   %eax
80101a11:	e8 aa fa ff ff       	call   801014c0 <iupdate>
80101a16:	83 c4 10             	add    $0x10,%esp
80101a19:	eb ba                	jmp    801019d5 <writei+0xd1>
      return -1;
80101a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a20:	eb b6                	jmp    801019d8 <writei+0xd4>
80101a22:	66 90                	xchg   %ax,%ax

80101a24 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a2a:	6a 0e                	push   $0xe
80101a2c:	ff 75 0c             	pushl  0xc(%ebp)
80101a2f:	ff 75 08             	pushl  0x8(%ebp)
80101a32:	e8 0d 27 00 00       	call   80104144 <strncmp>
}
80101a37:	c9                   	leave  
80101a38:	c3                   	ret    
80101a39:	8d 76 00             	lea    0x0(%esi),%esi

80101a3c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101a3c:	55                   	push   %ebp
80101a3d:	89 e5                	mov    %esp,%ebp
80101a3f:	57                   	push   %edi
80101a40:	56                   	push   %esi
80101a41:	53                   	push   %ebx
80101a42:	83 ec 1c             	sub    $0x1c,%esp
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101a48:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101a4d:	75 7d                	jne    80101acc <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a4f:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101a52:	85 c9                	test   %ecx,%ecx
80101a54:	74 3d                	je     80101a93 <dirlookup+0x57>
80101a56:	31 ff                	xor    %edi,%edi
80101a58:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101a5b:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a5c:	6a 10                	push   $0x10
80101a5e:	57                   	push   %edi
80101a5f:	56                   	push   %esi
80101a60:	53                   	push   %ebx
80101a61:	e8 a6 fd ff ff       	call   8010180c <readi>
80101a66:	83 c4 10             	add    $0x10,%esp
80101a69:	83 f8 10             	cmp    $0x10,%eax
80101a6c:	75 51                	jne    80101abf <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101a6e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a73:	74 16                	je     80101a8b <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101a75:	52                   	push   %edx
80101a76:	6a 0e                	push   $0xe
80101a78:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a7b:	50                   	push   %eax
80101a7c:	ff 75 0c             	pushl  0xc(%ebp)
80101a7f:	e8 c0 26 00 00       	call   80104144 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101a84:	83 c4 10             	add    $0x10,%esp
80101a87:	85 c0                	test   %eax,%eax
80101a89:	74 15                	je     80101aa0 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a8b:	83 c7 10             	add    $0x10,%edi
80101a8e:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101a91:	72 c9                	jb     80101a5c <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a93:	31 c0                	xor    %eax,%eax
}
80101a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5f                   	pop    %edi
80101a9b:	5d                   	pop    %ebp
80101a9c:	c3                   	ret    
80101a9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101aa0:	8b 45 10             	mov    0x10(%ebp),%eax
80101aa3:	85 c0                	test   %eax,%eax
80101aa5:	74 05                	je     80101aac <dirlookup+0x70>
        *poff = off;
80101aa7:	8b 45 10             	mov    0x10(%ebp),%eax
80101aaa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101aac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ab0:	8b 03                	mov    (%ebx),%eax
80101ab2:	e8 7d f6 ff ff       	call   80101134 <iget>
}
80101ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aba:	5b                   	pop    %ebx
80101abb:	5e                   	pop    %esi
80101abc:	5f                   	pop    %edi
80101abd:	5d                   	pop    %ebp
80101abe:	c3                   	ret    
      panic("dirlookup read");
80101abf:	83 ec 0c             	sub    $0xc,%esp
80101ac2:	68 b9 68 10 80       	push   $0x801068b9
80101ac7:	e8 74 e8 ff ff       	call   80100340 <panic>
    panic("dirlookup not DIR");
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	68 a7 68 10 80       	push   $0x801068a7
80101ad4:	e8 67 e8 ff ff       	call   80100340 <panic>
80101ad9:	8d 76 00             	lea    0x0(%esi),%esi

80101adc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101adc:	55                   	push   %ebp
80101add:	89 e5                	mov    %esp,%ebp
80101adf:	57                   	push   %edi
80101ae0:	56                   	push   %esi
80101ae1:	53                   	push   %ebx
80101ae2:	83 ec 1c             	sub    $0x1c,%esp
80101ae5:	89 c3                	mov    %eax,%ebx
80101ae7:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101aea:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101aed:	80 38 2f             	cmpb   $0x2f,(%eax)
80101af0:	0f 84 36 01 00 00    	je     80101c2c <namex+0x150>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101af6:	e8 69 18 00 00       	call   80103364 <myproc>
80101afb:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101afe:	83 ec 0c             	sub    $0xc,%esp
80101b01:	68 e0 09 11 80       	push   $0x801109e0
80101b06:	e8 85 24 00 00       	call   80103f90 <acquire>
  ip->ref++;
80101b0b:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101b0e:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101b15:	e8 0e 25 00 00       	call   80104028 <release>
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	89 df                	mov    %ebx,%edi
80101b1f:	eb 04                	jmp    80101b25 <namex+0x49>
80101b21:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101b24:	47                   	inc    %edi
  while(*path == '/')
80101b25:	8a 07                	mov    (%edi),%al
80101b27:	3c 2f                	cmp    $0x2f,%al
80101b29:	74 f9                	je     80101b24 <namex+0x48>
  if(*path == 0)
80101b2b:	84 c0                	test   %al,%al
80101b2d:	0f 84 b9 00 00 00    	je     80101bec <namex+0x110>
  while(*path != '/' && *path != 0)
80101b33:	8a 07                	mov    (%edi),%al
80101b35:	89 fb                	mov    %edi,%ebx
80101b37:	3c 2f                	cmp    $0x2f,%al
80101b39:	75 0c                	jne    80101b47 <namex+0x6b>
80101b3b:	e9 e0 00 00 00       	jmp    80101c20 <namex+0x144>
    path++;
80101b40:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80101b41:	8a 03                	mov    (%ebx),%al
80101b43:	3c 2f                	cmp    $0x2f,%al
80101b45:	74 04                	je     80101b4b <namex+0x6f>
80101b47:	84 c0                	test   %al,%al
80101b49:	75 f5                	jne    80101b40 <namex+0x64>
  len = path - s;
80101b4b:	89 d8                	mov    %ebx,%eax
80101b4d:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101b4f:	83 f8 0d             	cmp    $0xd,%eax
80101b52:	7e 74                	jle    80101bc8 <namex+0xec>
    memmove(name, s, DIRSIZ);
80101b54:	51                   	push   %ecx
80101b55:	6a 0e                	push   $0xe
80101b57:	57                   	push   %edi
80101b58:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b5b:	e8 94 25 00 00       	call   801040f4 <memmove>
80101b60:	83 c4 10             	add    $0x10,%esp
80101b63:	89 df                	mov    %ebx,%edi
  while(*path == '/')
80101b65:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b68:	75 08                	jne    80101b72 <namex+0x96>
80101b6a:	66 90                	xchg   %ax,%ax
    path++;
80101b6c:	47                   	inc    %edi
  while(*path == '/')
80101b6d:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101b70:	74 fa                	je     80101b6c <namex+0x90>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101b72:	83 ec 0c             	sub    $0xc,%esp
80101b75:	56                   	push   %esi
80101b76:	e8 ed f9 ff ff       	call   80101568 <ilock>
    if(ip->type != T_DIR){
80101b7b:	83 c4 10             	add    $0x10,%esp
80101b7e:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b83:	75 7b                	jne    80101c00 <namex+0x124>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b88:	85 c0                	test   %eax,%eax
80101b8a:	74 09                	je     80101b95 <namex+0xb9>
80101b8c:	80 3f 00             	cmpb   $0x0,(%edi)
80101b8f:	0f 84 af 00 00 00    	je     80101c44 <namex+0x168>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101b95:	50                   	push   %eax
80101b96:	6a 00                	push   $0x0
80101b98:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b9b:	56                   	push   %esi
80101b9c:	e8 9b fe ff ff       	call   80101a3c <dirlookup>
80101ba1:	89 c3                	mov    %eax,%ebx
80101ba3:	83 c4 10             	add    $0x10,%esp
80101ba6:	85 c0                	test   %eax,%eax
80101ba8:	74 56                	je     80101c00 <namex+0x124>
  iunlock(ip);
80101baa:	83 ec 0c             	sub    $0xc,%esp
80101bad:	56                   	push   %esi
80101bae:	e8 7d fa ff ff       	call   80101630 <iunlock>
  iput(ip);
80101bb3:	89 34 24             	mov    %esi,(%esp)
80101bb6:	e8 b9 fa ff ff       	call   80101674 <iput>
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101bc0:	e9 60 ff ff ff       	jmp    80101b25 <namex+0x49>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101bcb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101bce:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101bd1:	52                   	push   %edx
80101bd2:	50                   	push   %eax
80101bd3:	57                   	push   %edi
80101bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bd7:	e8 18 25 00 00       	call   801040f4 <memmove>
    name[len] = 0;
80101bdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101bdf:	c6 00 00             	movb   $0x0,(%eax)
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	89 df                	mov    %ebx,%edi
80101be7:	e9 79 ff ff ff       	jmp    80101b65 <namex+0x89>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101bec:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bef:	85 db                	test   %ebx,%ebx
80101bf1:	75 69                	jne    80101c5c <namex+0x180>
    iput(ip);
    return 0;
  }
  return ip;
}
80101bf3:	89 f0                	mov    %esi,%eax
80101bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf8:	5b                   	pop    %ebx
80101bf9:	5e                   	pop    %esi
80101bfa:	5f                   	pop    %edi
80101bfb:	5d                   	pop    %ebp
80101bfc:	c3                   	ret    
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlock(ip);
80101c00:	83 ec 0c             	sub    $0xc,%esp
80101c03:	56                   	push   %esi
80101c04:	e8 27 fa ff ff       	call   80101630 <iunlock>
  iput(ip);
80101c09:	89 34 24             	mov    %esi,(%esp)
80101c0c:	e8 63 fa ff ff       	call   80101674 <iput>
      return 0;
80101c11:	83 c4 10             	add    $0x10,%esp
80101c14:	31 f6                	xor    %esi,%esi
}
80101c16:	89 f0                	mov    %esi,%eax
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c23:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101c26:	31 c0                	xor    %eax,%eax
80101c28:	eb a7                	jmp    80101bd1 <namex+0xf5>
80101c2a:	66 90                	xchg   %ax,%ax
    ip = iget(ROOTDEV, ROOTINO);
80101c2c:	ba 01 00 00 00       	mov    $0x1,%edx
80101c31:	b8 01 00 00 00       	mov    $0x1,%eax
80101c36:	e8 f9 f4 ff ff       	call   80101134 <iget>
80101c3b:	89 c6                	mov    %eax,%esi
80101c3d:	89 df                	mov    %ebx,%edi
80101c3f:	e9 e1 fe ff ff       	jmp    80101b25 <namex+0x49>
      iunlock(ip);
80101c44:	83 ec 0c             	sub    $0xc,%esp
80101c47:	56                   	push   %esi
80101c48:	e8 e3 f9 ff ff       	call   80101630 <iunlock>
      return ip;
80101c4d:	83 c4 10             	add    $0x10,%esp
}
80101c50:	89 f0                	mov    %esi,%eax
80101c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c55:	5b                   	pop    %ebx
80101c56:	5e                   	pop    %esi
80101c57:	5f                   	pop    %edi
80101c58:	5d                   	pop    %ebp
80101c59:	c3                   	ret    
80101c5a:	66 90                	xchg   %ax,%ax
    iput(ip);
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	56                   	push   %esi
80101c60:	e8 0f fa ff ff       	call   80101674 <iput>
    return 0;
80101c65:	83 c4 10             	add    $0x10,%esp
80101c68:	31 f6                	xor    %esi,%esi
80101c6a:	eb 87                	jmp    80101bf3 <namex+0x117>

80101c6c <dirlink>:
{
80101c6c:	55                   	push   %ebp
80101c6d:	89 e5                	mov    %esp,%ebp
80101c6f:	57                   	push   %edi
80101c70:	56                   	push   %esi
80101c71:	53                   	push   %ebx
80101c72:	83 ec 20             	sub    $0x20,%esp
80101c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c78:	6a 00                	push   $0x0
80101c7a:	ff 75 0c             	pushl  0xc(%ebp)
80101c7d:	53                   	push   %ebx
80101c7e:	e8 b9 fd ff ff       	call   80101a3c <dirlookup>
80101c83:	83 c4 10             	add    $0x10,%esp
80101c86:	85 c0                	test   %eax,%eax
80101c88:	75 65                	jne    80101cef <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c8a:	8b 7b 58             	mov    0x58(%ebx),%edi
80101c8d:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c90:	85 ff                	test   %edi,%edi
80101c92:	74 29                	je     80101cbd <dirlink+0x51>
80101c94:	31 ff                	xor    %edi,%edi
80101c96:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c99:	eb 09                	jmp    80101ca4 <dirlink+0x38>
80101c9b:	90                   	nop
80101c9c:	83 c7 10             	add    $0x10,%edi
80101c9f:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ca2:	73 19                	jae    80101cbd <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ca4:	6a 10                	push   $0x10
80101ca6:	57                   	push   %edi
80101ca7:	56                   	push   %esi
80101ca8:	53                   	push   %ebx
80101ca9:	e8 5e fb ff ff       	call   8010180c <readi>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	83 f8 10             	cmp    $0x10,%eax
80101cb4:	75 4c                	jne    80101d02 <dirlink+0x96>
    if(de.inum == 0)
80101cb6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cbb:	75 df                	jne    80101c9c <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101cbd:	50                   	push   %eax
80101cbe:	6a 0e                	push   $0xe
80101cc0:	ff 75 0c             	pushl  0xc(%ebp)
80101cc3:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cc6:	50                   	push   %eax
80101cc7:	e8 b4 24 00 00       	call   80104180 <strncpy>
  de.inum = inum;
80101ccc:	8b 45 10             	mov    0x10(%ebp),%eax
80101ccf:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cd3:	6a 10                	push   $0x10
80101cd5:	57                   	push   %edi
80101cd6:	56                   	push   %esi
80101cd7:	53                   	push   %ebx
80101cd8:	e8 27 fc ff ff       	call   80101904 <writei>
80101cdd:	83 c4 20             	add    $0x20,%esp
80101ce0:	83 f8 10             	cmp    $0x10,%eax
80101ce3:	75 2a                	jne    80101d0f <dirlink+0xa3>
  return 0;
80101ce5:	31 c0                	xor    %eax,%eax
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	5b                   	pop    %ebx
80101ceb:	5e                   	pop    %esi
80101cec:	5f                   	pop    %edi
80101ced:	5d                   	pop    %ebp
80101cee:	c3                   	ret    
    iput(ip);
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	50                   	push   %eax
80101cf3:	e8 7c f9 ff ff       	call   80101674 <iput>
    return -1;
80101cf8:	83 c4 10             	add    $0x10,%esp
80101cfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d00:	eb e5                	jmp    80101ce7 <dirlink+0x7b>
      panic("dirlink read");
80101d02:	83 ec 0c             	sub    $0xc,%esp
80101d05:	68 c8 68 10 80       	push   $0x801068c8
80101d0a:	e8 31 e6 ff ff       	call   80100340 <panic>
    panic("dirlink");
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	68 c2 6e 10 80       	push   $0x80106ec2
80101d17:	e8 24 e6 ff ff       	call   80100340 <panic>

80101d1c <namei>:

struct inode*
namei(char *path)
{
80101d1c:	55                   	push   %ebp
80101d1d:	89 e5                	mov    %esp,%ebp
80101d1f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101d22:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101d25:	31 d2                	xor    %edx,%edx
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	e8 ad fd ff ff       	call   80101adc <namex>
}
80101d2f:	c9                   	leave  
80101d30:	c3                   	ret    
80101d31:	8d 76 00             	lea    0x0(%esi),%esi

80101d34 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d34:	55                   	push   %ebp
80101d35:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d3a:	ba 01 00 00 00       	mov    $0x1,%edx
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101d42:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101d43:	e9 94 fd ff ff       	jmp    80101adc <namex>

80101d48 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d48:	55                   	push   %ebp
80101d49:	89 e5                	mov    %esp,%ebp
80101d4b:	57                   	push   %edi
80101d4c:	56                   	push   %esi
80101d4d:	53                   	push   %ebx
80101d4e:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101d51:	85 c0                	test   %eax,%eax
80101d53:	0f 84 99 00 00 00    	je     80101df2 <idestart+0xaa>
80101d59:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d5b:	8b 70 08             	mov    0x8(%eax),%esi
80101d5e:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101d64:	77 7f                	ja     80101de5 <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d66:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101d6b:	90                   	nop
80101d6c:	89 ca                	mov    %ecx,%edx
80101d6e:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d6f:	83 e0 c0             	and    $0xffffffc0,%eax
80101d72:	3c 40                	cmp    $0x40,%al
80101d74:	75 f6                	jne    80101d6c <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d76:	31 ff                	xor    %edi,%edi
80101d78:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d7d:	89 f8                	mov    %edi,%eax
80101d7f:	ee                   	out    %al,(%dx)
80101d80:	b0 01                	mov    $0x1,%al
80101d82:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d87:	ee                   	out    %al,(%dx)
80101d88:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d8d:	89 f0                	mov    %esi,%eax
80101d8f:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d90:	89 f0                	mov    %esi,%eax
80101d92:	c1 f8 08             	sar    $0x8,%eax
80101d95:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d9a:	ee                   	out    %al,(%dx)
80101d9b:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101da0:	89 f8                	mov    %edi,%eax
80101da2:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101da3:	8a 43 04             	mov    0x4(%ebx),%al
80101da6:	c1 e0 04             	shl    $0x4,%eax
80101da9:	83 e0 10             	and    $0x10,%eax
80101dac:	83 c8 e0             	or     $0xffffffe0,%eax
80101daf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101db4:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101db5:	f6 03 04             	testb  $0x4,(%ebx)
80101db8:	75 0e                	jne    80101dc8 <idestart+0x80>
80101dba:	b0 20                	mov    $0x20,%al
80101dbc:	89 ca                	mov    %ecx,%edx
80101dbe:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	5b                   	pop    %ebx
80101dc3:	5e                   	pop    %esi
80101dc4:	5f                   	pop    %edi
80101dc5:	5d                   	pop    %ebp
80101dc6:	c3                   	ret    
80101dc7:	90                   	nop
80101dc8:	b0 30                	mov    $0x30,%al
80101dca:	89 ca                	mov    %ecx,%edx
80101dcc:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101dcd:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80101dd0:	b9 80 00 00 00       	mov    $0x80,%ecx
80101dd5:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101dda:	fc                   	cld    
80101ddb:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de0:	5b                   	pop    %ebx
80101de1:	5e                   	pop    %esi
80101de2:	5f                   	pop    %edi
80101de3:	5d                   	pop    %ebp
80101de4:	c3                   	ret    
    panic("incorrect blockno");
80101de5:	83 ec 0c             	sub    $0xc,%esp
80101de8:	68 34 69 10 80       	push   $0x80106934
80101ded:	e8 4e e5 ff ff       	call   80100340 <panic>
    panic("idestart");
80101df2:	83 ec 0c             	sub    $0xc,%esp
80101df5:	68 2b 69 10 80       	push   $0x8010692b
80101dfa:	e8 41 e5 ff ff       	call   80100340 <panic>
80101dff:	90                   	nop

80101e00 <ideinit>:
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101e06:	68 46 69 10 80       	push   $0x80106946
80101e0b:	68 80 a5 10 80       	push   $0x8010a580
80101e10:	e8 3b 20 00 00       	call   80103e50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101e15:	58                   	pop    %eax
80101e16:	5a                   	pop    %edx
80101e17:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101e1c:	48                   	dec    %eax
80101e1d:	50                   	push   %eax
80101e1e:	6a 0e                	push   $0xe
80101e20:	e8 57 02 00 00       	call   8010207c <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e25:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e28:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e2d:	8d 76 00             	lea    0x0(%esi),%esi
80101e30:	ec                   	in     (%dx),%al
80101e31:	83 e0 c0             	and    $0xffffffc0,%eax
80101e34:	3c 40                	cmp    $0x40,%al
80101e36:	75 f8                	jne    80101e30 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e38:	b0 f0                	mov    $0xf0,%al
80101e3a:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e3f:	ee                   	out    %al,(%dx)
80101e40:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e45:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e4a:	eb 03                	jmp    80101e4f <ideinit+0x4f>
  for(i=0; i<1000; i++){
80101e4c:	49                   	dec    %ecx
80101e4d:	74 0f                	je     80101e5e <ideinit+0x5e>
80101e4f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e50:	84 c0                	test   %al,%al
80101e52:	74 f8                	je     80101e4c <ideinit+0x4c>
      havedisk1 = 1;
80101e54:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101e5b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e5e:	b0 e0                	mov    $0xe0,%al
80101e60:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e65:	ee                   	out    %al,(%dx)
}
80101e66:	c9                   	leave  
80101e67:	c3                   	ret    

80101e68 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e68:	55                   	push   %ebp
80101e69:	89 e5                	mov    %esp,%ebp
80101e6b:	57                   	push   %edi
80101e6c:	56                   	push   %esi
80101e6d:	53                   	push   %ebx
80101e6e:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e71:	68 80 a5 10 80       	push   $0x8010a580
80101e76:	e8 15 21 00 00       	call   80103f90 <acquire>

  if((b = idequeue) == 0){
80101e7b:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	85 db                	test   %ebx,%ebx
80101e86:	74 5b                	je     80101ee3 <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e88:	8b 43 58             	mov    0x58(%ebx),%eax
80101e8b:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e90:	8b 33                	mov    (%ebx),%esi
80101e92:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101e98:	75 27                	jne    80101ec1 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e9a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e9f:	90                   	nop
80101ea0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ea1:	88 c1                	mov    %al,%cl
80101ea3:	83 e1 c0             	and    $0xffffffc0,%ecx
80101ea6:	80 f9 40             	cmp    $0x40,%cl
80101ea9:	75 f5                	jne    80101ea0 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101eab:	a8 21                	test   $0x21,%al
80101ead:	75 12                	jne    80101ec1 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
80101eaf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101eb2:	b9 80 00 00 00       	mov    $0x80,%ecx
80101eb7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ebc:	fc                   	cld    
80101ebd:	f3 6d                	rep insl (%dx),%es:(%edi)
80101ebf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101ec1:	83 e6 fb             	and    $0xfffffffb,%esi
80101ec4:	83 ce 02             	or     $0x2,%esi
80101ec7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80101ec9:	83 ec 0c             	sub    $0xc,%esp
80101ecc:	53                   	push   %ebx
80101ecd:	e8 72 1b 00 00       	call   80103a44 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101ed2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	85 c0                	test   %eax,%eax
80101edc:	74 05                	je     80101ee3 <ideintr+0x7b>
    idestart(idequeue);
80101ede:	e8 65 fe ff ff       	call   80101d48 <idestart>
    release(&idelock);
80101ee3:	83 ec 0c             	sub    $0xc,%esp
80101ee6:	68 80 a5 10 80       	push   $0x8010a580
80101eeb:	e8 38 21 00 00       	call   80104028 <release>

  release(&idelock);
}
80101ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef3:	5b                   	pop    %ebx
80101ef4:	5e                   	pop    %esi
80101ef5:	5f                   	pop    %edi
80101ef6:	5d                   	pop    %ebp
80101ef7:	c3                   	ret    

80101ef8 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101ef8:	55                   	push   %ebp
80101ef9:	89 e5                	mov    %esp,%ebp
80101efb:	53                   	push   %ebx
80101efc:	83 ec 10             	sub    $0x10,%esp
80101eff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101f02:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f05:	50                   	push   %eax
80101f06:	e8 f9 1e 00 00       	call   80103e04 <holdingsleep>
80101f0b:	83 c4 10             	add    $0x10,%esp
80101f0e:	85 c0                	test   %eax,%eax
80101f10:	0f 84 b7 00 00 00    	je     80101fcd <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f16:	8b 03                	mov    (%ebx),%eax
80101f18:	83 e0 06             	and    $0x6,%eax
80101f1b:	83 f8 02             	cmp    $0x2,%eax
80101f1e:	0f 84 9c 00 00 00    	je     80101fc0 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f24:	8b 53 04             	mov    0x4(%ebx),%edx
80101f27:	85 d2                	test   %edx,%edx
80101f29:	74 09                	je     80101f34 <iderw+0x3c>
80101f2b:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80101f30:	85 c0                	test   %eax,%eax
80101f32:	74 7f                	je     80101fb3 <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	68 80 a5 10 80       	push   $0x8010a580
80101f3c:	e8 4f 20 00 00       	call   80103f90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f41:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f48:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101f4d:	83 c4 10             	add    $0x10,%esp
80101f50:	85 c0                	test   %eax,%eax
80101f52:	74 58                	je     80101fac <iderw+0xb4>
    ;
80101f54:	89 c2                	mov    %eax,%edx
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f56:	8b 40 58             	mov    0x58(%eax),%eax
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	75 f7                	jne    80101f54 <iderw+0x5c>
80101f5d:	83 c2 58             	add    $0x58,%edx
  *pp = b;
80101f60:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f62:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f68:	74 36                	je     80101fa0 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f6a:	8b 03                	mov    (%ebx),%eax
80101f6c:	83 e0 06             	and    $0x6,%eax
80101f6f:	83 f8 02             	cmp    $0x2,%eax
80101f72:	74 1b                	je     80101f8f <iderw+0x97>
    sleep(b, &idelock);
80101f74:	83 ec 08             	sub    $0x8,%esp
80101f77:	68 80 a5 10 80       	push   $0x8010a580
80101f7c:	53                   	push   %ebx
80101f7d:	e8 16 19 00 00       	call   80103898 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f82:	8b 03                	mov    (%ebx),%eax
80101f84:	83 e0 06             	and    $0x6,%eax
80101f87:	83 c4 10             	add    $0x10,%esp
80101f8a:	83 f8 02             	cmp    $0x2,%eax
80101f8d:	75 e5                	jne    80101f74 <iderw+0x7c>
  }


  release(&idelock);
80101f8f:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80101f96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f99:	c9                   	leave  
  release(&idelock);
80101f9a:	e9 89 20 00 00       	jmp    80104028 <release>
80101f9f:	90                   	nop
    idestart(b);
80101fa0:	89 d8                	mov    %ebx,%eax
80101fa2:	e8 a1 fd ff ff       	call   80101d48 <idestart>
80101fa7:	eb c1                	jmp    80101f6a <iderw+0x72>
80101fa9:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fac:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101fb1:	eb ad                	jmp    80101f60 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	68 75 69 10 80       	push   $0x80106975
80101fbb:	e8 80 e3 ff ff       	call   80100340 <panic>
    panic("iderw: nothing to do");
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	68 60 69 10 80       	push   $0x80106960
80101fc8:	e8 73 e3 ff ff       	call   80100340 <panic>
    panic("iderw: buf not locked");
80101fcd:	83 ec 0c             	sub    $0xc,%esp
80101fd0:	68 4a 69 10 80       	push   $0x8010694a
80101fd5:	e8 66 e3 ff ff       	call   80100340 <panic>
80101fda:	66 90                	xchg   %ax,%ax

80101fdc <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fdc:	55                   	push   %ebp
80101fdd:	89 e5                	mov    %esp,%ebp
80101fdf:	56                   	push   %esi
80101fe0:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fe1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101fe8:	00 c0 fe 
  ioapic->reg = reg;
80101feb:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101ff2:	00 00 00 
  return ioapic->data;
80101ff5:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101ffb:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ffe:	c1 ee 10             	shr    $0x10,%esi
80102001:	89 f0                	mov    %esi,%eax
80102003:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
80102006:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010200c:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102012:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102015:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  id = ioapicread(REG_ID) >> 24;
8010201c:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
8010201f:	39 c2                	cmp    %eax,%edx
80102021:	74 16                	je     80102039 <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102023:	83 ec 0c             	sub    $0xc,%esp
80102026:	68 94 69 10 80       	push   $0x80106994
8010202b:	e8 f0 e5 ff ff       	call   80100620 <cprintf>
80102030:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102036:	83 c4 10             	add    $0x10,%esp
80102039:	83 c6 21             	add    $0x21,%esi
{
8010203c:	ba 10 00 00 00       	mov    $0x10,%edx
80102041:	b8 20 00 00 00       	mov    $0x20,%eax
80102046:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102048:	89 c3                	mov    %eax,%ebx
8010204a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->reg = reg;
80102050:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102052:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102058:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
8010205b:	8d 5a 01             	lea    0x1(%edx),%ebx
8010205e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102060:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102066:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
8010206d:	40                   	inc    %eax
8010206e:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
80102071:	39 f0                	cmp    %esi,%eax
80102073:	75 d3                	jne    80102048 <ioapicinit+0x6c>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102075:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102078:	5b                   	pop    %ebx
80102079:	5e                   	pop    %esi
8010207a:	5d                   	pop    %ebp
8010207b:	c3                   	ret    

8010207c <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010207c:	55                   	push   %ebp
8010207d:	89 e5                	mov    %esp,%ebp
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102082:	8d 50 20             	lea    0x20(%eax),%edx
80102085:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102089:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010208f:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102091:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102097:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010209a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010209d:	c1 e2 18             	shl    $0x18,%edx
801020a0:	40                   	inc    %eax
  ioapic->reg = reg;
801020a1:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801020a3:	a1 34 26 11 80       	mov    0x80112634,%eax
801020a8:	89 50 10             	mov    %edx,0x10(%eax)
}
801020ab:	5d                   	pop    %ebp
801020ac:	c3                   	ret    
801020ad:	66 90                	xchg   %ax,%ax
801020af:	90                   	nop

801020b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	53                   	push   %ebx
801020b4:	53                   	push   %ebx
801020b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020b8:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801020be:	75 70                	jne    80102130 <kfree+0x80>
801020c0:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801020c6:	72 68                	jb     80102130 <kfree+0x80>
801020c8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801020ce:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801020d3:	77 5b                	ja     80102130 <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801020d5:	52                   	push   %edx
801020d6:	68 00 10 00 00       	push   $0x1000
801020db:	6a 01                	push   $0x1
801020dd:	53                   	push   %ebx
801020de:	e8 8d 1f 00 00       	call   80104070 <memset>

  if(kmem.use_lock)
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801020ec:	85 c9                	test   %ecx,%ecx
801020ee:	75 1c                	jne    8010210c <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020f0:	a1 78 26 11 80       	mov    0x80112678,%eax
801020f5:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020f7:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801020fd:	a1 74 26 11 80       	mov    0x80112674,%eax
80102102:	85 c0                	test   %eax,%eax
80102104:	75 1a                	jne    80102120 <kfree+0x70>
    release(&kmem.lock);
}
80102106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102109:	c9                   	leave  
8010210a:	c3                   	ret    
8010210b:	90                   	nop
    acquire(&kmem.lock);
8010210c:	83 ec 0c             	sub    $0xc,%esp
8010210f:	68 40 26 11 80       	push   $0x80112640
80102114:	e8 77 1e 00 00       	call   80103f90 <acquire>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	eb d2                	jmp    801020f0 <kfree+0x40>
8010211e:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102120:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102127:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010212a:	c9                   	leave  
    release(&kmem.lock);
8010212b:	e9 f8 1e 00 00       	jmp    80104028 <release>
    panic("kfree");
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 c6 69 10 80       	push   $0x801069c6
80102138:	e8 03 e2 ff ff       	call   80100340 <panic>
8010213d:	8d 76 00             	lea    0x0(%esi),%esi

80102140 <freerange>:
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	56                   	push   %esi
80102144:	53                   	push   %ebx
80102145:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102148:	8b 45 08             	mov    0x8(%ebp),%eax
8010214b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102151:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102157:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010215d:	39 de                	cmp    %ebx,%esi
8010215f:	72 1f                	jb     80102180 <freerange+0x40>
80102161:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102164:	83 ec 0c             	sub    $0xc,%esp
80102167:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010216d:	50                   	push   %eax
8010216e:	e8 3d ff ff ff       	call   801020b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102173:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	39 f3                	cmp    %esi,%ebx
8010217e:	76 e4                	jbe    80102164 <freerange+0x24>
}
80102180:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5d                   	pop    %ebp
80102186:	c3                   	ret    
80102187:	90                   	nop

80102188 <kinit1>:
{
80102188:	55                   	push   %ebp
80102189:	89 e5                	mov    %esp,%ebp
8010218b:	56                   	push   %esi
8010218c:	53                   	push   %ebx
8010218d:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102190:	83 ec 08             	sub    $0x8,%esp
80102193:	68 cc 69 10 80       	push   $0x801069cc
80102198:	68 40 26 11 80       	push   $0x80112640
8010219d:	e8 ae 1c 00 00       	call   80103e50 <initlock>
  kmem.use_lock = 0;
801021a2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801021a9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801021ac:	8b 45 08             	mov    0x8(%ebp),%eax
801021af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801021b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021c1:	83 c4 10             	add    $0x10,%esp
801021c4:	39 de                	cmp    %ebx,%esi
801021c6:	72 1c                	jb     801021e4 <kinit1+0x5c>
    kfree(p);
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801021d1:	50                   	push   %eax
801021d2:	e8 d9 fe ff ff       	call   801020b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021dd:	83 c4 10             	add    $0x10,%esp
801021e0:	39 de                	cmp    %ebx,%esi
801021e2:	73 e4                	jae    801021c8 <kinit1+0x40>
}
801021e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021e7:	5b                   	pop    %ebx
801021e8:	5e                   	pop    %esi
801021e9:	5d                   	pop    %ebp
801021ea:	c3                   	ret    
801021eb:	90                   	nop

801021ec <kinit2>:
{
801021ec:	55                   	push   %ebp
801021ed:	89 e5                	mov    %esp,%ebp
801021ef:	56                   	push   %esi
801021f0:	53                   	push   %ebx
801021f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801021f4:	8b 45 08             	mov    0x8(%ebp),%eax
801021f7:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801021fd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102203:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102209:	39 de                	cmp    %ebx,%esi
8010220b:	72 1f                	jb     8010222c <kinit2+0x40>
8010220d:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102210:	83 ec 0c             	sub    $0xc,%esp
80102213:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102219:	50                   	push   %eax
8010221a:	e8 91 fe ff ff       	call   801020b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010221f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102225:	83 c4 10             	add    $0x10,%esp
80102228:	39 de                	cmp    %ebx,%esi
8010222a:	73 e4                	jae    80102210 <kinit2+0x24>
  kmem.use_lock = 1;
8010222c:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102233:	00 00 00 
}
80102236:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102239:	5b                   	pop    %ebx
8010223a:	5e                   	pop    %esi
8010223b:	5d                   	pop    %ebp
8010223c:	c3                   	ret    
8010223d:	8d 76 00             	lea    0x0(%esi),%esi

80102240 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102240:	a1 74 26 11 80       	mov    0x80112674,%eax
80102245:	85 c0                	test   %eax,%eax
80102247:	75 17                	jne    80102260 <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102249:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010224e:	85 c0                	test   %eax,%eax
80102250:	74 0a                	je     8010225c <kalloc+0x1c>
    kmem.freelist = r->next;
80102252:	8b 10                	mov    (%eax),%edx
80102254:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010225a:	c3                   	ret    
8010225b:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
8010225c:	c3                   	ret    
8010225d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102266:	68 40 26 11 80       	push   $0x80112640
8010226b:	e8 20 1d 00 00       	call   80103f90 <acquire>
  r = kmem.freelist;
80102270:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102275:	83 c4 10             	add    $0x10,%esp
80102278:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010227e:	85 c0                	test   %eax,%eax
80102280:	74 08                	je     8010228a <kalloc+0x4a>
    kmem.freelist = r->next;
80102282:	8b 08                	mov    (%eax),%ecx
80102284:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
8010228a:	85 d2                	test   %edx,%edx
8010228c:	74 16                	je     801022a4 <kalloc+0x64>
8010228e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
80102291:	83 ec 0c             	sub    $0xc,%esp
80102294:	68 40 26 11 80       	push   $0x80112640
80102299:	e8 8a 1d 00 00       	call   80104028 <release>
8010229e:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801022a4:	c9                   	leave  
801022a5:	c3                   	ret    
801022a6:	66 90                	xchg   %ax,%ax

801022a8 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a8:	ba 64 00 00 00       	mov    $0x64,%edx
801022ad:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801022ae:	a8 01                	test   $0x1,%al
801022b0:	0f 84 ae 00 00 00    	je     80102364 <kbdgetc+0xbc>
{
801022b6:	55                   	push   %ebp
801022b7:	89 e5                	mov    %esp,%ebp
801022b9:	53                   	push   %ebx
801022ba:	ba 60 00 00 00       	mov    $0x60,%edx
801022bf:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801022c0:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
801022c3:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
801022c9:	3c e0                	cmp    $0xe0,%al
801022cb:	74 5b                	je     80102328 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801022cd:	89 d1                	mov    %edx,%ecx
801022cf:	83 e1 40             	and    $0x40,%ecx
801022d2:	84 c0                	test   %al,%al
801022d4:	78 62                	js     80102338 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801022d6:	85 c9                	test   %ecx,%ecx
801022d8:	74 09                	je     801022e3 <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801022da:	83 c8 80             	or     $0xffffff80,%eax
801022dd:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
801022e0:	83 e2 bf             	and    $0xffffffbf,%edx
  }

  shift |= shiftcode[data];
801022e3:	0f b6 8b 00 6b 10 80 	movzbl -0x7fef9500(%ebx),%ecx
801022ea:	09 d1                	or     %edx,%ecx
  shift ^= togglecode[data];
801022ec:	0f b6 83 00 6a 10 80 	movzbl -0x7fef9600(%ebx),%eax
801022f3:	31 c1                	xor    %eax,%ecx
801022f5:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801022fb:	89 c8                	mov    %ecx,%eax
801022fd:	83 e0 03             	and    $0x3,%eax
80102300:	8b 04 85 e0 69 10 80 	mov    -0x7fef9620(,%eax,4),%eax
80102307:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
8010230b:	83 e1 08             	and    $0x8,%ecx
8010230e:	74 13                	je     80102323 <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
80102310:	8d 50 9f             	lea    -0x61(%eax),%edx
80102313:	83 fa 19             	cmp    $0x19,%edx
80102316:	76 44                	jbe    8010235c <kbdgetc+0xb4>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102318:	8d 50 bf             	lea    -0x41(%eax),%edx
8010231b:	83 fa 19             	cmp    $0x19,%edx
8010231e:	77 03                	ja     80102323 <kbdgetc+0x7b>
      c += 'a' - 'A';
80102320:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
80102323:	5b                   	pop    %ebx
80102324:	5d                   	pop    %ebp
80102325:	c3                   	ret    
80102326:	66 90                	xchg   %ax,%ax
    shift |= E0ESC;
80102328:	83 ca 40             	or     $0x40,%edx
8010232b:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
    return 0;
80102331:	31 c0                	xor    %eax,%eax
}
80102333:	5b                   	pop    %ebx
80102334:	5d                   	pop    %ebp
80102335:	c3                   	ret    
80102336:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102338:	85 c9                	test   %ecx,%ecx
8010233a:	75 05                	jne    80102341 <kbdgetc+0x99>
8010233c:	89 c3                	mov    %eax,%ebx
8010233e:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102341:	8a 8b 00 6b 10 80    	mov    -0x7fef9500(%ebx),%cl
80102347:	83 c9 40             	or     $0x40,%ecx
8010234a:	0f b6 c9             	movzbl %cl,%ecx
8010234d:	f7 d1                	not    %ecx
8010234f:	21 d1                	and    %edx,%ecx
80102351:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102357:	31 c0                	xor    %eax,%eax
}
80102359:	5b                   	pop    %ebx
8010235a:	5d                   	pop    %ebp
8010235b:	c3                   	ret    
      c += 'A' - 'a';
8010235c:	83 e8 20             	sub    $0x20,%eax
}
8010235f:	5b                   	pop    %ebx
80102360:	5d                   	pop    %ebp
80102361:	c3                   	ret    
80102362:	66 90                	xchg   %ax,%ax
    return -1;
80102364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102369:	c3                   	ret    
8010236a:	66 90                	xchg   %ax,%ax

8010236c <kbdintr>:

void
kbdintr(void)
{
8010236c:	55                   	push   %ebp
8010236d:	89 e5                	mov    %esp,%ebp
8010236f:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102372:	68 a8 22 10 80       	push   $0x801022a8
80102377:	e8 2c e4 ff ff       	call   801007a8 <consoleintr>
}
8010237c:	83 c4 10             	add    $0x10,%esp
8010237f:	c9                   	leave  
80102380:	c3                   	ret    
80102381:	66 90                	xchg   %ax,%ax
80102383:	90                   	nop

80102384 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102384:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102389:	85 c0                	test   %eax,%eax
8010238b:	0f 84 c3 00 00 00    	je     80102454 <lapicinit+0xd0>
  lapic[index] = value;
80102391:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102398:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010239b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010239e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801023a5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023ab:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801023b2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801023b5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023b8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801023bf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801023c2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023c5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801023cc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023cf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023d2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801023d9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023dc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023df:	8b 50 30             	mov    0x30(%eax),%edx
801023e2:	c1 ea 10             	shr    $0x10,%edx
801023e5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801023eb:	75 6b                	jne    80102458 <lapicinit+0xd4>
  lapic[index] = value;
801023ed:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801023f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023fa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102401:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102404:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102407:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010240e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102411:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102414:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010241b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010241e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102421:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102428:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010242b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010242e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102435:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102438:	8b 50 20             	mov    0x20(%eax),%edx
8010243b:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
8010243c:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102442:	80 e6 10             	and    $0x10,%dh
80102445:	75 f5                	jne    8010243c <lapicinit+0xb8>
  lapic[index] = value;
80102447:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010244e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102451:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102454:	c3                   	ret    
80102455:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
80102458:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010245f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102462:	8b 50 20             	mov    0x20(%eax),%edx
}
80102465:	eb 86                	jmp    801023ed <lapicinit+0x69>
80102467:	90                   	nop

80102468 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102468:	a1 7c 26 11 80       	mov    0x8011267c,%eax
8010246d:	85 c0                	test   %eax,%eax
8010246f:	74 07                	je     80102478 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102471:	8b 40 20             	mov    0x20(%eax),%eax
80102474:	c1 e8 18             	shr    $0x18,%eax
80102477:	c3                   	ret    
    return 0;
80102478:	31 c0                	xor    %eax,%eax
}
8010247a:	c3                   	ret    
8010247b:	90                   	nop

8010247c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
8010247c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102481:	85 c0                	test   %eax,%eax
80102483:	74 0d                	je     80102492 <lapiceoi+0x16>
  lapic[index] = value;
80102485:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010248c:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010248f:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102492:	c3                   	ret    
80102493:	90                   	nop

80102494 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102494:	c3                   	ret    
80102495:	8d 76 00             	lea    0x0(%esi),%esi

80102498 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102498:	55                   	push   %ebp
80102499:	89 e5                	mov    %esp,%ebp
8010249b:	53                   	push   %ebx
8010249c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010249f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024a2:	b0 0f                	mov    $0xf,%al
801024a4:	ba 70 00 00 00       	mov    $0x70,%edx
801024a9:	ee                   	out    %al,(%dx)
801024aa:	b0 0a                	mov    $0xa,%al
801024ac:	ba 71 00 00 00       	mov    $0x71,%edx
801024b1:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801024b2:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024b9:	00 00 
  wrv[1] = addr >> 4;
801024bb:	89 c8                	mov    %ecx,%eax
801024bd:	c1 e8 04             	shr    $0x4,%eax
801024c0:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801024c6:	a1 7c 26 11 80       	mov    0x8011267c,%eax

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801024cb:	c1 e3 18             	shl    $0x18,%ebx
801024ce:	89 da                	mov    %ebx,%edx
  lapic[index] = value;
801024d0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024d9:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801024e0:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024e6:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801024ed:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024f0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024f3:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024f9:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801024fc:	c1 e9 0c             	shr    $0xc,%ecx
801024ff:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
80102502:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102508:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010250b:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102511:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102514:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010251a:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010251d:	5b                   	pop    %ebx
8010251e:	5d                   	pop    %ebp
8010251f:	c3                   	ret    

80102520 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	57                   	push   %edi
80102524:	56                   	push   %esi
80102525:	53                   	push   %ebx
80102526:	83 ec 4c             	sub    $0x4c,%esp
80102529:	b0 0b                	mov    $0xb,%al
8010252b:	ba 70 00 00 00       	mov    $0x70,%edx
80102530:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102531:	ba 71 00 00 00       	mov    $0x71,%edx
80102536:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102537:	83 e0 04             	and    $0x4,%eax
8010253a:	88 45 b2             	mov    %al,-0x4e(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010253d:	be 70 00 00 00       	mov    $0x70,%esi
80102542:	66 90                	xchg   %ax,%ax
80102544:	31 c0                	xor    %eax,%eax
80102546:	89 f2                	mov    %esi,%edx
80102548:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102549:	bb 71 00 00 00       	mov    $0x71,%ebx
8010254e:	89 da                	mov    %ebx,%edx
80102550:	ec                   	in     (%dx),%al
80102551:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102554:	bf 02 00 00 00       	mov    $0x2,%edi
80102559:	89 f8                	mov    %edi,%eax
8010255b:	89 f2                	mov    %esi,%edx
8010255d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010255e:	89 da                	mov    %ebx,%edx
80102560:	ec                   	in     (%dx),%al
80102561:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102564:	b0 04                	mov    $0x4,%al
80102566:	89 f2                	mov    %esi,%edx
80102568:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102569:	89 da                	mov    %ebx,%edx
8010256b:	ec                   	in     (%dx),%al
8010256c:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010256f:	b0 07                	mov    $0x7,%al
80102571:	89 f2                	mov    %esi,%edx
80102573:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102574:	89 da                	mov    %ebx,%edx
80102576:	ec                   	in     (%dx),%al
80102577:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010257a:	b0 08                	mov    $0x8,%al
8010257c:	89 f2                	mov    %esi,%edx
8010257e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010257f:	89 da                	mov    %ebx,%edx
80102581:	ec                   	in     (%dx),%al
80102582:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102585:	b0 09                	mov    $0x9,%al
80102587:	89 f2                	mov    %esi,%edx
80102589:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010258a:	89 da                	mov    %ebx,%edx
8010258c:	ec                   	in     (%dx),%al
8010258d:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102590:	b0 0a                	mov    $0xa,%al
80102592:	89 f2                	mov    %esi,%edx
80102594:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102595:	89 da                	mov    %ebx,%edx
80102597:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102598:	84 c0                	test   %al,%al
8010259a:	78 a8                	js     80102544 <cmostime+0x24>
  return inb(CMOS_RETURN);
8010259c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801025a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
801025a3:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801025a7:	89 45 bc             	mov    %eax,-0x44(%ebp)
801025aa:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801025ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
801025b1:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801025b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801025b8:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
801025bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
801025bf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c2:	31 c0                	xor    %eax,%eax
801025c4:	89 f2                	mov    %esi,%edx
801025c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c7:	89 da                	mov    %ebx,%edx
801025c9:	ec                   	in     (%dx),%al
801025ca:	0f b6 c0             	movzbl %al,%eax
801025cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d0:	89 f8                	mov    %edi,%eax
801025d2:	89 f2                	mov    %esi,%edx
801025d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d5:	89 da                	mov    %ebx,%edx
801025d7:	ec                   	in     (%dx),%al
801025d8:	0f b6 c0             	movzbl %al,%eax
801025db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025de:	b0 04                	mov    $0x4,%al
801025e0:	89 f2                	mov    %esi,%edx
801025e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e3:	89 da                	mov    %ebx,%edx
801025e5:	ec                   	in     (%dx),%al
801025e6:	0f b6 c0             	movzbl %al,%eax
801025e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ec:	b0 07                	mov    $0x7,%al
801025ee:	89 f2                	mov    %esi,%edx
801025f0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f1:	89 da                	mov    %ebx,%edx
801025f3:	ec                   	in     (%dx),%al
801025f4:	0f b6 c0             	movzbl %al,%eax
801025f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025fa:	b0 08                	mov    $0x8,%al
801025fc:	89 f2                	mov    %esi,%edx
801025fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ff:	89 da                	mov    %ebx,%edx
80102601:	ec                   	in     (%dx),%al
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102608:	b0 09                	mov    $0x9,%al
8010260a:	89 f2                	mov    %esi,%edx
8010260c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260d:	89 da                	mov    %ebx,%edx
8010260f:	ec                   	in     (%dx),%al
80102610:	0f b6 c0             	movzbl %al,%eax
80102613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102616:	50                   	push   %eax
80102617:	6a 18                	push   $0x18
80102619:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010261c:	50                   	push   %eax
8010261d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102620:	50                   	push   %eax
80102621:	e8 96 1a 00 00       	call   801040bc <memcmp>
80102626:	83 c4 10             	add    $0x10,%esp
80102629:	85 c0                	test   %eax,%eax
8010262b:	0f 85 13 ff ff ff    	jne    80102544 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
80102631:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102635:	75 7e                	jne    801026b5 <cmostime+0x195>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102637:	8b 55 b8             	mov    -0x48(%ebp),%edx
8010263a:	89 d0                	mov    %edx,%eax
8010263c:	c1 e8 04             	shr    $0x4,%eax
8010263f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102642:	01 c0                	add    %eax,%eax
80102644:	83 e2 0f             	and    $0xf,%edx
80102647:	01 d0                	add    %edx,%eax
80102649:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010264c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010264f:	89 d0                	mov    %edx,%eax
80102651:	c1 e8 04             	shr    $0x4,%eax
80102654:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102657:	01 c0                	add    %eax,%eax
80102659:	83 e2 0f             	and    $0xf,%edx
8010265c:	01 d0                	add    %edx,%eax
8010265e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102661:	8b 55 c0             	mov    -0x40(%ebp),%edx
80102664:	89 d0                	mov    %edx,%eax
80102666:	c1 e8 04             	shr    $0x4,%eax
80102669:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010266c:	01 c0                	add    %eax,%eax
8010266e:	83 e2 0f             	and    $0xf,%edx
80102671:	01 d0                	add    %edx,%eax
80102673:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102676:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80102679:	89 d0                	mov    %edx,%eax
8010267b:	c1 e8 04             	shr    $0x4,%eax
8010267e:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102681:	01 c0                	add    %eax,%eax
80102683:	83 e2 0f             	and    $0xf,%edx
80102686:	01 d0                	add    %edx,%eax
80102688:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010268b:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010268e:	89 d0                	mov    %edx,%eax
80102690:	c1 e8 04             	shr    $0x4,%eax
80102693:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102696:	01 c0                	add    %eax,%eax
80102698:	83 e2 0f             	and    $0xf,%edx
8010269b:	01 d0                	add    %edx,%eax
8010269d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801026a0:	8b 55 cc             	mov    -0x34(%ebp),%edx
801026a3:	89 d0                	mov    %edx,%eax
801026a5:	c1 e8 04             	shr    $0x4,%eax
801026a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
801026ab:	01 c0                	add    %eax,%eax
801026ad:	83 e2 0f             	and    $0xf,%edx
801026b0:	01 d0                	add    %edx,%eax
801026b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801026b5:	b9 06 00 00 00       	mov    $0x6,%ecx
801026ba:	8b 7d 08             	mov    0x8(%ebp),%edi
801026bd:	8d 75 b8             	lea    -0x48(%ebp),%esi
801026c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801026c2:	8b 45 08             	mov    0x8(%ebp),%eax
801026c5:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
801026cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5f                   	pop    %edi
801026d2:	5d                   	pop    %ebp
801026d3:	c3                   	ret    

801026d4 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026d4:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801026da:	85 c9                	test   %ecx,%ecx
801026dc:	7e 7e                	jle    8010275c <install_trans+0x88>
{
801026de:	55                   	push   %ebp
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	57                   	push   %edi
801026e2:	56                   	push   %esi
801026e3:	53                   	push   %ebx
801026e4:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801026e7:	31 f6                	xor    %esi,%esi
801026e9:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801026ec:	83 ec 08             	sub    $0x8,%esp
801026ef:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801026f4:	01 f0                	add    %esi,%eax
801026f6:	40                   	inc    %eax
801026f7:	50                   	push   %eax
801026f8:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026fe:	e8 b1 d9 ff ff       	call   801000b4 <bread>
80102703:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102705:	58                   	pop    %eax
80102706:	5a                   	pop    %edx
80102707:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
8010270e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102714:	e8 9b d9 ff ff       	call   801000b4 <bread>
80102719:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010271b:	83 c4 0c             	add    $0xc,%esp
8010271e:	68 00 02 00 00       	push   $0x200
80102723:	8d 47 5c             	lea    0x5c(%edi),%eax
80102726:	50                   	push   %eax
80102727:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010272a:	50                   	push   %eax
8010272b:	e8 c4 19 00 00       	call   801040f4 <memmove>
    bwrite(dbuf);  // write dst to disk
80102730:	89 1c 24             	mov    %ebx,(%esp)
80102733:	e8 50 da ff ff       	call   80100188 <bwrite>
    brelse(lbuf);
80102738:	89 3c 24             	mov    %edi,(%esp)
8010273b:	e8 80 da ff ff       	call   801001c0 <brelse>
    brelse(dbuf);
80102740:	89 1c 24             	mov    %ebx,(%esp)
80102743:	e8 78 da ff ff       	call   801001c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102748:	46                   	inc    %esi
80102749:	83 c4 10             	add    $0x10,%esp
8010274c:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102752:	7f 98                	jg     801026ec <install_trans+0x18>
  }
}
80102754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102757:	5b                   	pop    %ebx
80102758:	5e                   	pop    %esi
80102759:	5f                   	pop    %edi
8010275a:	5d                   	pop    %ebp
8010275b:	c3                   	ret    
8010275c:	c3                   	ret    
8010275d:	8d 76 00             	lea    0x0(%esi),%esi

80102760 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102767:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010276d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102773:	e8 3c d9 ff ff       	call   801000b4 <bread>
80102778:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010277a:	a1 c8 26 11 80       	mov    0x801126c8,%eax
8010277f:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102782:	83 c4 10             	add    $0x10,%esp
80102785:	85 c0                	test   %eax,%eax
80102787:	7e 13                	jle    8010279c <write_head+0x3c>
80102789:	31 d2                	xor    %edx,%edx
8010278b:	90                   	nop
    hb->block[i] = log.lh.block[i];
8010278c:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102793:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102797:	42                   	inc    %edx
80102798:	39 d0                	cmp    %edx,%eax
8010279a:	75 f0                	jne    8010278c <write_head+0x2c>
  }
  bwrite(buf);
8010279c:	83 ec 0c             	sub    $0xc,%esp
8010279f:	53                   	push   %ebx
801027a0:	e8 e3 d9 ff ff       	call   80100188 <bwrite>
  brelse(buf);
801027a5:	89 1c 24             	mov    %ebx,(%esp)
801027a8:	e8 13 da ff ff       	call   801001c0 <brelse>
}
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi

801027b8 <initlog>:
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	53                   	push   %ebx
801027bc:	83 ec 2c             	sub    $0x2c,%esp
801027bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027c2:	68 00 6c 10 80       	push   $0x80106c00
801027c7:	68 80 26 11 80       	push   $0x80112680
801027cc:	e8 7f 16 00 00       	call   80103e50 <initlock>
  readsb(dev, &sb);
801027d1:	58                   	pop    %eax
801027d2:	5a                   	pop    %edx
801027d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027d6:	50                   	push   %eax
801027d7:	53                   	push   %ebx
801027d8:	e8 ef ea ff ff       	call   801012cc <readsb>
  log.start = sb.logstart;
801027dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027e0:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801027e8:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.dev = dev;
801027ee:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
801027f4:	59                   	pop    %ecx
801027f5:	5a                   	pop    %edx
801027f6:	50                   	push   %eax
801027f7:	53                   	push   %ebx
801027f8:	e8 b7 d8 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
801027fd:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102800:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102806:	83 c4 10             	add    $0x10,%esp
80102809:	85 c9                	test   %ecx,%ecx
8010280b:	7e 13                	jle    80102820 <initlog+0x68>
8010280d:	31 d2                	xor    %edx,%edx
8010280f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102810:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102814:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010281b:	42                   	inc    %edx
8010281c:	39 d1                	cmp    %edx,%ecx
8010281e:	75 f0                	jne    80102810 <initlog+0x58>
  brelse(buf);
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	50                   	push   %eax
80102824:	e8 97 d9 ff ff       	call   801001c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102829:	e8 a6 fe ff ff       	call   801026d4 <install_trans>
  log.lh.n = 0;
8010282e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102835:	00 00 00 
  write_head(); // clear the log
80102838:	e8 23 ff ff ff       	call   80102760 <write_head>
}
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102843:	c9                   	leave  
80102844:	c3                   	ret    
80102845:	8d 76 00             	lea    0x0(%esi),%esi

80102848 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102848:	55                   	push   %ebp
80102849:	89 e5                	mov    %esp,%ebp
8010284b:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010284e:	68 80 26 11 80       	push   $0x80112680
80102853:	e8 38 17 00 00       	call   80103f90 <acquire>
80102858:	83 c4 10             	add    $0x10,%esp
8010285b:	eb 18                	jmp    80102875 <begin_op+0x2d>
8010285d:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 80 26 11 80       	push   $0x80112680
80102868:	68 80 26 11 80       	push   $0x80112680
8010286d:	e8 26 10 00 00       	call   80103898 <sleep>
80102872:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102875:	a1 c0 26 11 80       	mov    0x801126c0,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	75 e2                	jne    80102860 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010287e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102883:	8d 50 01             	lea    0x1(%eax),%edx
80102886:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
8010288a:	01 c0                	add    %eax,%eax
8010288c:	03 05 c8 26 11 80    	add    0x801126c8,%eax
80102892:	83 f8 1e             	cmp    $0x1e,%eax
80102895:	7f c9                	jg     80102860 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102897:	89 15 bc 26 11 80    	mov    %edx,0x801126bc
      release(&log.lock);
8010289d:	83 ec 0c             	sub    $0xc,%esp
801028a0:	68 80 26 11 80       	push   $0x80112680
801028a5:	e8 7e 17 00 00       	call   80104028 <release>
      break;
    }
  }
}
801028aa:	83 c4 10             	add    $0x10,%esp
801028ad:	c9                   	leave  
801028ae:	c3                   	ret    
801028af:	90                   	nop

801028b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	57                   	push   %edi
801028b4:	56                   	push   %esi
801028b5:	53                   	push   %ebx
801028b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801028b9:	68 80 26 11 80       	push   $0x80112680
801028be:	e8 cd 16 00 00       	call   80103f90 <acquire>
  log.outstanding -= 1;
801028c3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801028c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
801028cb:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
801028d1:	83 c4 10             	add    $0x10,%esp
801028d4:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
801028da:	85 f6                	test   %esi,%esi
801028dc:	0f 85 12 01 00 00    	jne    801029f4 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
801028e2:	85 db                	test   %ebx,%ebx
801028e4:	0f 85 e6 00 00 00    	jne    801029d0 <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
801028ea:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
801028f1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801028f4:	83 ec 0c             	sub    $0xc,%esp
801028f7:	68 80 26 11 80       	push   $0x80112680
801028fc:	e8 27 17 00 00       	call   80104028 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102901:	83 c4 10             	add    $0x10,%esp
80102904:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
8010290a:	85 c9                	test   %ecx,%ecx
8010290c:	7f 3a                	jg     80102948 <end_op+0x98>
    acquire(&log.lock);
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	68 80 26 11 80       	push   $0x80112680
80102916:	e8 75 16 00 00       	call   80103f90 <acquire>
    log.committing = 0;
8010291b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102922:	00 00 00 
    wakeup(&log);
80102925:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010292c:	e8 13 11 00 00       	call   80103a44 <wakeup>
    release(&log.lock);
80102931:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102938:	e8 eb 16 00 00       	call   80104028 <release>
8010293d:	83 c4 10             	add    $0x10,%esp
}
80102940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102948:	83 ec 08             	sub    $0x8,%esp
8010294b:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102950:	01 d8                	add    %ebx,%eax
80102952:	40                   	inc    %eax
80102953:	50                   	push   %eax
80102954:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010295a:	e8 55 d7 ff ff       	call   801000b4 <bread>
8010295f:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102961:	58                   	pop    %eax
80102962:	5a                   	pop    %edx
80102963:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
8010296a:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102970:	e8 3f d7 ff ff       	call   801000b4 <bread>
80102975:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102977:	83 c4 0c             	add    $0xc,%esp
8010297a:	68 00 02 00 00       	push   $0x200
8010297f:	8d 40 5c             	lea    0x5c(%eax),%eax
80102982:	50                   	push   %eax
80102983:	8d 46 5c             	lea    0x5c(%esi),%eax
80102986:	50                   	push   %eax
80102987:	e8 68 17 00 00       	call   801040f4 <memmove>
    bwrite(to);  // write the log
8010298c:	89 34 24             	mov    %esi,(%esp)
8010298f:	e8 f4 d7 ff ff       	call   80100188 <bwrite>
    brelse(from);
80102994:	89 3c 24             	mov    %edi,(%esp)
80102997:	e8 24 d8 ff ff       	call   801001c0 <brelse>
    brelse(to);
8010299c:	89 34 24             	mov    %esi,(%esp)
8010299f:	e8 1c d8 ff ff       	call   801001c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029a4:	43                   	inc    %ebx
801029a5:	83 c4 10             	add    $0x10,%esp
801029a8:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
801029ae:	7c 98                	jl     80102948 <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801029b0:	e8 ab fd ff ff       	call   80102760 <write_head>
    install_trans(); // Now install writes to home locations
801029b5:	e8 1a fd ff ff       	call   801026d4 <install_trans>
    log.lh.n = 0;
801029ba:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801029c1:	00 00 00 
    write_head();    // Erase the transaction from the log
801029c4:	e8 97 fd ff ff       	call   80102760 <write_head>
801029c9:	e9 40 ff ff ff       	jmp    8010290e <end_op+0x5e>
801029ce:	66 90                	xchg   %ax,%ax
    wakeup(&log);
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	68 80 26 11 80       	push   $0x80112680
801029d8:	e8 67 10 00 00       	call   80103a44 <wakeup>
  release(&log.lock);
801029dd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801029e4:	e8 3f 16 00 00       	call   80104028 <release>
801029e9:	83 c4 10             	add    $0x10,%esp
}
801029ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
    panic("log.committing");
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	68 04 6c 10 80       	push   $0x80106c04
801029fc:	e8 3f d9 ff ff       	call   80100340 <panic>
80102a01:	8d 76 00             	lea    0x0(%esi),%esi

80102a04 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102a04:	55                   	push   %ebp
80102a05:	89 e5                	mov    %esp,%ebp
80102a07:	53                   	push   %ebx
80102a08:	52                   	push   %edx
80102a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a0c:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102a12:	83 fa 1d             	cmp    $0x1d,%edx
80102a15:	7f 79                	jg     80102a90 <log_write+0x8c>
80102a17:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102a1c:	48                   	dec    %eax
80102a1d:	39 c2                	cmp    %eax,%edx
80102a1f:	7d 6f                	jge    80102a90 <log_write+0x8c>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a21:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102a26:	85 c0                	test   %eax,%eax
80102a28:	7e 73                	jle    80102a9d <log_write+0x99>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a2a:	83 ec 0c             	sub    $0xc,%esp
80102a2d:	68 80 26 11 80       	push   $0x80112680
80102a32:	e8 59 15 00 00       	call   80103f90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a37:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102a3d:	83 c4 10             	add    $0x10,%esp
80102a40:	85 d2                	test   %edx,%edx
80102a42:	7e 40                	jle    80102a84 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a44:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a47:	31 c0                	xor    %eax,%eax
80102a49:	eb 06                	jmp    80102a51 <log_write+0x4d>
80102a4b:	90                   	nop
80102a4c:	40                   	inc    %eax
80102a4d:	39 c2                	cmp    %eax,%edx
80102a4f:	74 23                	je     80102a74 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a51:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102a58:	75 f2                	jne    80102a4c <log_write+0x48>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a5a:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a61:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a64:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6e:	c9                   	leave  
  release(&log.lock);
80102a6f:	e9 b4 15 00 00       	jmp    80104028 <release>
  log.lh.block[i] = b->blockno;
80102a74:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102a7b:	42                   	inc    %edx
80102a7c:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102a82:	eb dd                	jmp    80102a61 <log_write+0x5d>
  log.lh.block[i] = b->blockno;
80102a84:	8b 43 08             	mov    0x8(%ebx),%eax
80102a87:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102a8c:	75 d3                	jne    80102a61 <log_write+0x5d>
80102a8e:	eb eb                	jmp    80102a7b <log_write+0x77>
    panic("too big a transaction");
80102a90:	83 ec 0c             	sub    $0xc,%esp
80102a93:	68 13 6c 10 80       	push   $0x80106c13
80102a98:	e8 a3 d8 ff ff       	call   80100340 <panic>
    panic("log_write outside of trans");
80102a9d:	83 ec 0c             	sub    $0xc,%esp
80102aa0:	68 29 6c 10 80       	push   $0x80106c29
80102aa5:	e8 96 d8 ff ff       	call   80100340 <panic>
80102aaa:	66 90                	xchg   %ax,%ax

80102aac <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102aac:	55                   	push   %ebp
80102aad:	89 e5                	mov    %esp,%ebp
80102aaf:	53                   	push   %ebx
80102ab0:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ab1:	e8 7a 08 00 00       	call   80103330 <cpuid>
80102ab6:	89 c3                	mov    %eax,%ebx
80102ab8:	e8 73 08 00 00       	call   80103330 <cpuid>
80102abd:	52                   	push   %edx
80102abe:	53                   	push   %ebx
80102abf:	50                   	push   %eax
80102ac0:	68 44 6c 10 80       	push   $0x80106c44
80102ac5:	e8 56 db ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102aca:	e8 05 26 00 00       	call   801050d4 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102acf:	e8 f8 07 00 00       	call   801032cc <mycpu>
80102ad4:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ad6:	b8 01 00 00 00       	mov    $0x1,%eax
80102adb:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ae2:	e8 09 0b 00 00       	call   801035f0 <scheduler>
80102ae7:	90                   	nop

80102ae8 <mpenter>:
{
80102ae8:	55                   	push   %ebp
80102ae9:	89 e5                	mov    %esp,%ebp
80102aeb:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102aee:	e8 11 36 00 00       	call   80106104 <switchkvm>
  seginit();
80102af3:	e8 88 35 00 00       	call   80106080 <seginit>
  lapicinit();
80102af8:	e8 87 f8 ff ff       	call   80102384 <lapicinit>
  mpmain();
80102afd:	e8 aa ff ff ff       	call   80102aac <mpmain>
80102b02:	66 90                	xchg   %ax,%ax

80102b04 <main>:
{
80102b04:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b08:	83 e4 f0             	and    $0xfffffff0,%esp
80102b0b:	ff 71 fc             	pushl  -0x4(%ecx)
80102b0e:	55                   	push   %ebp
80102b0f:	89 e5                	mov    %esp,%ebp
80102b11:	53                   	push   %ebx
80102b12:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b13:	83 ec 08             	sub    $0x8,%esp
80102b16:	68 00 00 40 80       	push   $0x80400000
80102b1b:	68 a8 54 11 80       	push   $0x801154a8
80102b20:	e8 63 f6 ff ff       	call   80102188 <kinit1>
  kvmalloc();      // kernel page table
80102b25:	e8 3e 3a 00 00       	call   80106568 <kvmalloc>
  mpinit();        // detect other processors
80102b2a:	e8 61 01 00 00       	call   80102c90 <mpinit>
  lapicinit();     // interrupt controller
80102b2f:	e8 50 f8 ff ff       	call   80102384 <lapicinit>
  seginit();       // segment descriptors
80102b34:	e8 47 35 00 00       	call   80106080 <seginit>
  picinit();       // disable pic
80102b39:	e8 f2 02 00 00       	call   80102e30 <picinit>
  ioapicinit();    // another interrupt controller
80102b3e:	e8 99 f4 ff ff       	call   80101fdc <ioapicinit>
  consoleinit();   // console hardware
80102b43:	e8 18 de ff ff       	call   80100960 <consoleinit>
  uartinit();      // serial port
80102b48:	e8 53 28 00 00       	call   801053a0 <uartinit>
  pinit();         // process table
80102b4d:	e8 5e 07 00 00       	call   801032b0 <pinit>
  tvinit();        // trap vectors
80102b52:	e8 11 25 00 00       	call   80105068 <tvinit>
  binit();         // buffer cache
80102b57:	e8 d8 d4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102b5c:	e8 7b e1 ff ff       	call   80100cdc <fileinit>
  ideinit();       // disk 
80102b61:	e8 9a f2 ff ff       	call   80101e00 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102b66:	83 c4 0c             	add    $0xc,%esp
80102b69:	68 8a 00 00 00       	push   $0x8a
80102b6e:	68 8c a4 10 80       	push   $0x8010a48c
80102b73:	68 00 70 00 80       	push   $0x80007000
80102b78:	e8 77 15 00 00       	call   801040f4 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b7d:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102b83:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102b86:	01 c0                	add    %eax,%eax
80102b88:	01 d0                	add    %edx,%eax
80102b8a:	c1 e0 04             	shl    $0x4,%eax
80102b8d:	05 80 27 11 80       	add    $0x80112780,%eax
80102b92:	83 c4 10             	add    $0x10,%esp
80102b95:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102b9a:	76 74                	jbe    80102c10 <main+0x10c>
80102b9c:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102ba1:	eb 20                	jmp    80102bc3 <main+0xbf>
80102ba3:	90                   	nop
80102ba4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102baa:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102bb0:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102bb3:	01 c0                	add    %eax,%eax
80102bb5:	01 d0                	add    %edx,%eax
80102bb7:	c1 e0 04             	shl    $0x4,%eax
80102bba:	05 80 27 11 80       	add    $0x80112780,%eax
80102bbf:	39 c3                	cmp    %eax,%ebx
80102bc1:	73 4d                	jae    80102c10 <main+0x10c>
    if(c == mycpu())  // We've started already.
80102bc3:	e8 04 07 00 00       	call   801032cc <mycpu>
80102bc8:	39 c3                	cmp    %eax,%ebx
80102bca:	74 d8                	je     80102ba4 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102bcc:	e8 6f f6 ff ff       	call   80102240 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102bd1:	05 00 10 00 00       	add    $0x1000,%eax
80102bd6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102bdb:	c7 05 f8 6f 00 80 e8 	movl   $0x80102ae8,0x80006ff8
80102be2:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102be5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102bec:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102bef:	83 ec 08             	sub    $0x8,%esp
80102bf2:	68 00 70 00 00       	push   $0x7000
80102bf7:	0f b6 03             	movzbl (%ebx),%eax
80102bfa:	50                   	push   %eax
80102bfb:	e8 98 f8 ff ff       	call   80102498 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102c00:	83 c4 10             	add    $0x10,%esp
80102c03:	90                   	nop
80102c04:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102c0a:	85 c0                	test   %eax,%eax
80102c0c:	74 f6                	je     80102c04 <main+0x100>
80102c0e:	eb 94                	jmp    80102ba4 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102c10:	83 ec 08             	sub    $0x8,%esp
80102c13:	68 00 00 00 8e       	push   $0x8e000000
80102c18:	68 00 00 40 80       	push   $0x80400000
80102c1d:	e8 ca f5 ff ff       	call   801021ec <kinit2>
  userinit();      // first user process
80102c22:	e8 61 07 00 00       	call   80103388 <userinit>
  mpmain();        // finish this processor's setup
80102c27:	e8 80 fe ff ff       	call   80102aac <mpmain>

80102c2c <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c2c:	55                   	push   %ebp
80102c2d:	89 e5                	mov    %esp,%ebp
80102c2f:	57                   	push   %edi
80102c30:	56                   	push   %esi
80102c31:	53                   	push   %ebx
80102c32:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c35:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102c3b:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102c42:	39 de                	cmp    %ebx,%esi
80102c44:	72 0b                	jb     80102c51 <mpsearch1+0x25>
80102c46:	eb 3c                	jmp    80102c84 <mpsearch1+0x58>
80102c48:	8d 7e 10             	lea    0x10(%esi),%edi
80102c4b:	89 fe                	mov    %edi,%esi
80102c4d:	39 fb                	cmp    %edi,%ebx
80102c4f:	76 33                	jbe    80102c84 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c51:	50                   	push   %eax
80102c52:	6a 04                	push   $0x4
80102c54:	68 58 6c 10 80       	push   $0x80106c58
80102c59:	56                   	push   %esi
80102c5a:	e8 5d 14 00 00       	call   801040bc <memcmp>
80102c5f:	83 c4 10             	add    $0x10,%esp
80102c62:	85 c0                	test   %eax,%eax
80102c64:	75 e2                	jne    80102c48 <mpsearch1+0x1c>
80102c66:	89 f2                	mov    %esi,%edx
80102c68:	8d 7e 10             	lea    0x10(%esi),%edi
80102c6b:	90                   	nop
    sum += addr[i];
80102c6c:	0f b6 0a             	movzbl (%edx),%ecx
80102c6f:	01 c8                	add    %ecx,%eax
80102c71:	42                   	inc    %edx
  for(i=0; i<len; i++)
80102c72:	39 fa                	cmp    %edi,%edx
80102c74:	75 f6                	jne    80102c6c <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c76:	84 c0                	test   %al,%al
80102c78:	75 d1                	jne    80102c4b <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102c7a:	89 f0                	mov    %esi,%eax
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
  return 0;
80102c84:	31 f6                	xor    %esi,%esi
}
80102c86:	89 f0                	mov    %esi,%eax
80102c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8b:	5b                   	pop    %ebx
80102c8c:	5e                   	pop    %esi
80102c8d:	5f                   	pop    %edi
80102c8e:	5d                   	pop    %ebp
80102c8f:	c3                   	ret    

80102c90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ca0:	c1 e0 08             	shl    $0x8,%eax
80102ca3:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102caa:	09 d0                	or     %edx,%eax
80102cac:	c1 e0 04             	shl    $0x4,%eax
80102caf:	75 1b                	jne    80102ccc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cb1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102cb8:	c1 e0 08             	shl    $0x8,%eax
80102cbb:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cc2:	09 d0                	or     %edx,%eax
80102cc4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cc7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102ccc:	ba 00 04 00 00       	mov    $0x400,%edx
80102cd1:	e8 56 ff ff ff       	call   80102c2c <mpsearch1>
80102cd6:	89 c3                	mov    %eax,%ebx
80102cd8:	85 c0                	test   %eax,%eax
80102cda:	0f 84 18 01 00 00    	je     80102df8 <mpinit+0x168>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ce0:	8b 73 04             	mov    0x4(%ebx),%esi
80102ce3:	85 f6                	test   %esi,%esi
80102ce5:	0f 84 29 01 00 00    	je     80102e14 <mpinit+0x184>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ceb:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102cf1:	50                   	push   %eax
80102cf2:	6a 04                	push   $0x4
80102cf4:	68 5d 6c 10 80       	push   $0x80106c5d
80102cf9:	57                   	push   %edi
80102cfa:	e8 bd 13 00 00       	call   801040bc <memcmp>
80102cff:	83 c4 10             	add    $0x10,%esp
80102d02:	85 c0                	test   %eax,%eax
80102d04:	0f 85 0a 01 00 00    	jne    80102e14 <mpinit+0x184>
  if(conf->version != 1 && conf->version != 4)
80102d0a:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102d10:	3c 01                	cmp    $0x1,%al
80102d12:	74 08                	je     80102d1c <mpinit+0x8c>
80102d14:	3c 04                	cmp    $0x4,%al
80102d16:	0f 85 f8 00 00 00    	jne    80102e14 <mpinit+0x184>
  if(sum((uchar*)conf, conf->length) != 0)
80102d1c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102d23:	66 85 d2             	test   %dx,%dx
80102d26:	74 1f                	je     80102d47 <mpinit+0xb7>
80102d28:	89 f8                	mov    %edi,%eax
80102d2a:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
80102d2d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  sum = 0;
80102d30:	31 d2                	xor    %edx,%edx
80102d32:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80102d34:	0f b6 08             	movzbl (%eax),%ecx
80102d37:	01 ca                	add    %ecx,%edx
80102d39:	40                   	inc    %eax
  for(i=0; i<len; i++)
80102d3a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80102d3d:	75 f5                	jne    80102d34 <mpinit+0xa4>
  if(sum((uchar*)conf, conf->length) != 0)
80102d3f:	84 d2                	test   %dl,%dl
80102d41:	0f 85 cd 00 00 00    	jne    80102e14 <mpinit+0x184>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d47:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80102d4d:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d52:	8d 96 2c 00 00 80    	lea    -0x7fffffd4(%esi),%edx
80102d58:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
80102d5f:	01 c7                	add    %eax,%edi
  ismp = 1;
80102d61:	b9 01 00 00 00       	mov    $0x1,%ecx
80102d66:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102d69:	8d 76 00             	lea    0x0(%esi),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d6c:	39 d7                	cmp    %edx,%edi
80102d6e:	76 13                	jbe    80102d83 <mpinit+0xf3>
    switch(*p){
80102d70:	8a 02                	mov    (%edx),%al
80102d72:	3c 02                	cmp    $0x2,%al
80102d74:	74 46                	je     80102dbc <mpinit+0x12c>
80102d76:	77 38                	ja     80102db0 <mpinit+0x120>
80102d78:	84 c0                	test   %al,%al
80102d7a:	74 50                	je     80102dcc <mpinit+0x13c>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d7c:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d7f:	39 d7                	cmp    %edx,%edi
80102d81:	77 ed                	ja     80102d70 <mpinit+0xe0>
80102d83:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d86:	85 c9                	test   %ecx,%ecx
80102d88:	0f 84 93 00 00 00    	je     80102e21 <mpinit+0x191>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d8e:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80102d92:	74 12                	je     80102da6 <mpinit+0x116>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d94:	b0 70                	mov    $0x70,%al
80102d96:	ba 22 00 00 00       	mov    $0x22,%edx
80102d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9c:	ba 23 00 00 00       	mov    $0x23,%edx
80102da1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102da2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da5:	ee                   	out    %al,(%dx)
  }
}
80102da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da9:	5b                   	pop    %ebx
80102daa:	5e                   	pop    %esi
80102dab:	5f                   	pop    %edi
80102dac:	5d                   	pop    %ebp
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax
    switch(*p){
80102db0:	83 e8 03             	sub    $0x3,%eax
80102db3:	3c 01                	cmp    $0x1,%al
80102db5:	76 c5                	jbe    80102d7c <mpinit+0xec>
80102db7:	31 c9                	xor    %ecx,%ecx
80102db9:	eb b1                	jmp    80102d6c <mpinit+0xdc>
80102dbb:	90                   	nop
      ioapicid = ioapic->apicno;
80102dbc:	8a 42 01             	mov    0x1(%edx),%al
80102dbf:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102dc4:	83 c2 08             	add    $0x8,%edx
      continue;
80102dc7:	eb a3                	jmp    80102d6c <mpinit+0xdc>
80102dc9:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80102dcc:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102dd1:	83 f8 07             	cmp    $0x7,%eax
80102dd4:	7f 19                	jg     80102def <mpinit+0x15f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102dd6:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102dd9:	01 f6                	add    %esi,%esi
80102ddb:	01 c6                	add    %eax,%esi
80102ddd:	c1 e6 04             	shl    $0x4,%esi
80102de0:	8a 5a 01             	mov    0x1(%edx),%bl
80102de3:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102de9:	40                   	inc    %eax
80102dea:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102def:	83 c2 14             	add    $0x14,%edx
      continue;
80102df2:	e9 75 ff ff ff       	jmp    80102d6c <mpinit+0xdc>
80102df7:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80102df8:	ba 00 00 01 00       	mov    $0x10000,%edx
80102dfd:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102e02:	e8 25 fe ff ff       	call   80102c2c <mpsearch1>
80102e07:	89 c3                	mov    %eax,%ebx
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102e09:	85 c0                	test   %eax,%eax
80102e0b:	0f 85 cf fe ff ff    	jne    80102ce0 <mpinit+0x50>
80102e11:	8d 76 00             	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 62 6c 10 80       	push   $0x80106c62
80102e1c:	e8 1f d5 ff ff       	call   80100340 <panic>
    panic("Didn't find a suitable machine");
80102e21:	83 ec 0c             	sub    $0xc,%esp
80102e24:	68 7c 6c 10 80       	push   $0x80106c7c
80102e29:	e8 12 d5 ff ff       	call   80100340 <panic>
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <picinit>:
80102e30:	b0 ff                	mov    $0xff,%al
80102e32:	ba 21 00 00 00       	mov    $0x21,%edx
80102e37:	ee                   	out    %al,(%dx)
80102e38:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e3d:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e3e:	c3                   	ret    
80102e3f:	90                   	nop

80102e40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e4f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e55:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e5b:	e8 98 de ff ff       	call   80100cf8 <filealloc>
80102e60:	89 03                	mov    %eax,(%ebx)
80102e62:	85 c0                	test   %eax,%eax
80102e64:	0f 84 a8 00 00 00    	je     80102f12 <pipealloc+0xd2>
80102e6a:	e8 89 de ff ff       	call   80100cf8 <filealloc>
80102e6f:	89 06                	mov    %eax,(%esi)
80102e71:	85 c0                	test   %eax,%eax
80102e73:	0f 84 87 00 00 00    	je     80102f00 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e79:	e8 c2 f3 ff ff       	call   80102240 <kalloc>
80102e7e:	89 c7                	mov    %eax,%edi
80102e80:	85 c0                	test   %eax,%eax
80102e82:	0f 84 ac 00 00 00    	je     80102f34 <pipealloc+0xf4>
    goto bad;
  p->readopen = 1;
80102e88:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e8f:	00 00 00 
  p->writeopen = 1;
80102e92:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e99:	00 00 00 
  p->nwrite = 0;
80102e9c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102ea3:	00 00 00 
  p->nread = 0;
80102ea6:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ead:	00 00 00 
  initlock(&p->lock, "pipe");
80102eb0:	83 ec 08             	sub    $0x8,%esp
80102eb3:	68 9b 6c 10 80       	push   $0x80106c9b
80102eb8:	50                   	push   %eax
80102eb9:	e8 92 0f 00 00       	call   80103e50 <initlock>
  (*f0)->type = FD_PIPE;
80102ebe:	8b 03                	mov    (%ebx),%eax
80102ec0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102ec6:	8b 03                	mov    (%ebx),%eax
80102ec8:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102ecc:	8b 03                	mov    (%ebx),%eax
80102ece:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102ed2:	8b 03                	mov    (%ebx),%eax
80102ed4:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ed7:	8b 06                	mov    (%esi),%eax
80102ed9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102edf:	8b 06                	mov    (%esi),%eax
80102ee1:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102ee5:	8b 06                	mov    (%esi),%eax
80102ee7:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102eeb:	8b 06                	mov    (%esi),%eax
80102eed:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80102ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef8:	5b                   	pop    %ebx
80102ef9:	5e                   	pop    %esi
80102efa:	5f                   	pop    %edi
80102efb:	5d                   	pop    %ebp
80102efc:	c3                   	ret    
80102efd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80102f00:	8b 03                	mov    (%ebx),%eax
80102f02:	85 c0                	test   %eax,%eax
80102f04:	74 1e                	je     80102f24 <pipealloc+0xe4>
    fileclose(*f0);
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	50                   	push   %eax
80102f0a:	e8 8d de ff ff       	call   80100d9c <fileclose>
80102f0f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f12:	8b 06                	mov    (%esi),%eax
80102f14:	85 c0                	test   %eax,%eax
80102f16:	74 0c                	je     80102f24 <pipealloc+0xe4>
    fileclose(*f1);
80102f18:	83 ec 0c             	sub    $0xc,%esp
80102f1b:	50                   	push   %eax
80102f1c:	e8 7b de ff ff       	call   80100d9c <fileclose>
80102f21:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2c:	5b                   	pop    %ebx
80102f2d:	5e                   	pop    %esi
80102f2e:	5f                   	pop    %edi
80102f2f:	5d                   	pop    %ebp
80102f30:	c3                   	ret    
80102f31:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80102f34:	8b 03                	mov    (%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	75 cc                	jne    80102f06 <pipealloc+0xc6>
80102f3a:	eb d6                	jmp    80102f12 <pipealloc+0xd2>

80102f3c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f3c:	55                   	push   %ebp
80102f3d:	89 e5                	mov    %esp,%ebp
80102f3f:	56                   	push   %esi
80102f40:	53                   	push   %ebx
80102f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f44:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80102f47:	83 ec 0c             	sub    $0xc,%esp
80102f4a:	53                   	push   %ebx
80102f4b:	e8 40 10 00 00       	call   80103f90 <acquire>
  if(writable){
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	85 f6                	test   %esi,%esi
80102f55:	74 41                	je     80102f98 <pipeclose+0x5c>
    p->writeopen = 0;
80102f57:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f5e:	00 00 00 
    wakeup(&p->nread);
80102f61:	83 ec 0c             	sub    $0xc,%esp
80102f64:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f6a:	50                   	push   %eax
80102f6b:	e8 d4 0a 00 00       	call   80103a44 <wakeup>
80102f70:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f73:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80102f79:	85 d2                	test   %edx,%edx
80102f7b:	75 0a                	jne    80102f87 <pipeclose+0x4b>
80102f7d:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80102f83:	85 c0                	test   %eax,%eax
80102f85:	74 31                	je     80102fb8 <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f8d:	5b                   	pop    %ebx
80102f8e:	5e                   	pop    %esi
80102f8f:	5d                   	pop    %ebp
    release(&p->lock);
80102f90:	e9 93 10 00 00       	jmp    80104028 <release>
80102f95:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
80102f98:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f9f:	00 00 00 
    wakeup(&p->nwrite);
80102fa2:	83 ec 0c             	sub    $0xc,%esp
80102fa5:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fab:	50                   	push   %eax
80102fac:	e8 93 0a 00 00       	call   80103a44 <wakeup>
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	eb bd                	jmp    80102f73 <pipeclose+0x37>
80102fb6:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80102fb8:	83 ec 0c             	sub    $0xc,%esp
80102fbb:	53                   	push   %ebx
80102fbc:	e8 67 10 00 00       	call   80104028 <release>
    kfree((char*)p);
80102fc1:	83 c4 10             	add    $0x10,%esp
80102fc4:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fca:	5b                   	pop    %ebx
80102fcb:	5e                   	pop    %esi
80102fcc:	5d                   	pop    %ebp
    kfree((char*)p);
80102fcd:	e9 de f0 ff ff       	jmp    801020b0 <kfree>
80102fd2:	66 90                	xchg   %ax,%ax

80102fd4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102fd4:	55                   	push   %ebp
80102fd5:	89 e5                	mov    %esp,%ebp
80102fd7:	57                   	push   %edi
80102fd8:	56                   	push   %esi
80102fd9:	53                   	push   %ebx
80102fda:	83 ec 28             	sub    $0x28,%esp
80102fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fe0:	53                   	push   %ebx
80102fe1:	e8 aa 0f 00 00       	call   80103f90 <acquire>
  for(i = 0; i < n; i++){
80102fe6:	83 c4 10             	add    $0x10,%esp
80102fe9:	8b 45 10             	mov    0x10(%ebp),%eax
80102fec:	85 c0                	test   %eax,%eax
80102fee:	0f 8e b1 00 00 00    	jle    801030a5 <pipewrite+0xd1>
80102ff4:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ffd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103000:	03 4d 10             	add    0x10(%ebp),%ecx
80103003:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103006:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010300c:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103012:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103018:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010301e:	39 d0                	cmp    %edx,%eax
80103020:	74 38                	je     8010305a <pipewrite+0x86>
80103022:	eb 59                	jmp    8010307d <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103024:	e8 3b 03 00 00       	call   80103364 <myproc>
80103029:	8b 48 24             	mov    0x24(%eax),%ecx
8010302c:	85 c9                	test   %ecx,%ecx
8010302e:	75 34                	jne    80103064 <pipewrite+0x90>
      wakeup(&p->nread);
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	57                   	push   %edi
80103034:	e8 0b 0a 00 00       	call   80103a44 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103039:	58                   	pop    %eax
8010303a:	5a                   	pop    %edx
8010303b:	53                   	push   %ebx
8010303c:	56                   	push   %esi
8010303d:	e8 56 08 00 00       	call   80103898 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103042:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103048:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010304e:	05 00 02 00 00       	add    $0x200,%eax
80103053:	83 c4 10             	add    $0x10,%esp
80103056:	39 c2                	cmp    %eax,%edx
80103058:	75 26                	jne    80103080 <pipewrite+0xac>
      if(p->readopen == 0 || myproc()->killed){
8010305a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103060:	85 c0                	test   %eax,%eax
80103062:	75 c0                	jne    80103024 <pipewrite+0x50>
        release(&p->lock);
80103064:	83 ec 0c             	sub    $0xc,%esp
80103067:	53                   	push   %ebx
80103068:	e8 bb 0f 00 00       	call   80104028 <release>
        return -1;
8010306d:	83 c4 10             	add    $0x10,%esp
80103070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103075:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103078:	5b                   	pop    %ebx
80103079:	5e                   	pop    %esi
8010307a:	5f                   	pop    %edi
8010307b:	5d                   	pop    %ebp
8010307c:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010307d:	89 c2                	mov    %eax,%edx
8010307f:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103080:	8d 42 01             	lea    0x1(%edx),%eax
80103083:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103089:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010308c:	8a 0e                	mov    (%esi),%cl
8010308e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103094:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103098:	46                   	inc    %esi
80103099:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < n; i++){
8010309c:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010309f:	0f 85 67 ff ff ff    	jne    8010300c <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801030a5:	83 ec 0c             	sub    $0xc,%esp
801030a8:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030ae:	50                   	push   %eax
801030af:	e8 90 09 00 00       	call   80103a44 <wakeup>
  release(&p->lock);
801030b4:	89 1c 24             	mov    %ebx,(%esp)
801030b7:	e8 6c 0f 00 00       	call   80104028 <release>
  return n;
801030bc:	83 c4 10             	add    $0x10,%esp
801030bf:	8b 45 10             	mov    0x10(%ebp),%eax
801030c2:	eb b1                	jmp    80103075 <pipewrite+0xa1>

801030c4 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030c4:	55                   	push   %ebp
801030c5:	89 e5                	mov    %esp,%ebp
801030c7:	57                   	push   %edi
801030c8:	56                   	push   %esi
801030c9:	53                   	push   %ebx
801030ca:	83 ec 18             	sub    $0x18,%esp
801030cd:	8b 75 08             	mov    0x8(%ebp),%esi
801030d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801030d3:	56                   	push   %esi
801030d4:	e8 b7 0e 00 00       	call   80103f90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801030e2:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801030e8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801030ee:	74 2f                	je     8010311f <piperead+0x5b>
801030f0:	eb 37                	jmp    80103129 <piperead+0x65>
801030f2:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801030f4:	e8 6b 02 00 00       	call   80103364 <myproc>
801030f9:	8b 48 24             	mov    0x24(%eax),%ecx
801030fc:	85 c9                	test   %ecx,%ecx
801030fe:	0f 85 80 00 00 00    	jne    80103184 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103104:	83 ec 08             	sub    $0x8,%esp
80103107:	56                   	push   %esi
80103108:	53                   	push   %ebx
80103109:	e8 8a 07 00 00       	call   80103898 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010310e:	83 c4 10             	add    $0x10,%esp
80103111:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103117:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
8010311d:	75 0a                	jne    80103129 <piperead+0x65>
8010311f:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103125:	85 c0                	test   %eax,%eax
80103127:	75 cb                	jne    801030f4 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103129:	31 db                	xor    %ebx,%ebx
8010312b:	8b 55 10             	mov    0x10(%ebp),%edx
8010312e:	85 d2                	test   %edx,%edx
80103130:	7f 1d                	jg     8010314f <piperead+0x8b>
80103132:	eb 29                	jmp    8010315d <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103134:	8d 48 01             	lea    0x1(%eax),%ecx
80103137:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010313d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103142:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
80103146:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103149:	43                   	inc    %ebx
8010314a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010314d:	74 0e                	je     8010315d <piperead+0x99>
    if(p->nread == p->nwrite)
8010314f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103155:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010315b:	75 d7                	jne    80103134 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010315d:	83 ec 0c             	sub    $0xc,%esp
80103160:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103166:	50                   	push   %eax
80103167:	e8 d8 08 00 00       	call   80103a44 <wakeup>
  release(&p->lock);
8010316c:	89 34 24             	mov    %esi,(%esp)
8010316f:	e8 b4 0e 00 00       	call   80104028 <release>
  return i;
80103174:	83 c4 10             	add    $0x10,%esp
}
80103177:	89 d8                	mov    %ebx,%eax
80103179:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317c:	5b                   	pop    %ebx
8010317d:	5e                   	pop    %esi
8010317e:	5f                   	pop    %edi
8010317f:	5d                   	pop    %ebp
80103180:	c3                   	ret    
80103181:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
80103184:	83 ec 0c             	sub    $0xc,%esp
80103187:	56                   	push   %esi
80103188:	e8 9b 0e 00 00       	call   80104028 <release>
      return -1;
8010318d:	83 c4 10             	add    $0x10,%esp
80103190:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80103195:	89 d8                	mov    %ebx,%eax
80103197:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010319a:	5b                   	pop    %ebx
8010319b:	5e                   	pop    %esi
8010319c:	5f                   	pop    %edi
8010319d:	5d                   	pop    %ebp
8010319e:	c3                   	ret    
8010319f:	90                   	nop

801031a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	53                   	push   %ebx
801031a4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801031a7:	68 20 2d 11 80       	push   $0x80112d20
801031ac:	e8 df 0d 00 00       	call   80103f90 <acquire>
801031b1:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801031b9:	eb 0c                	jmp    801031c7 <allocproc+0x27>
801031bb:	90                   	nop
801031bc:	83 c3 7c             	add    $0x7c,%ebx
801031bf:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801031c5:	74 75                	je     8010323c <allocproc+0x9c>
    if(p->state == UNUSED)
801031c7:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801031ca:	85 c9                	test   %ecx,%ecx
801031cc:	75 ee                	jne    801031bc <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801031ce:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031d5:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801031da:	8d 50 01             	lea    0x1(%eax),%edx
801031dd:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801031e3:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	68 20 2d 11 80       	push   $0x80112d20
801031ee:	e8 35 0e 00 00       	call   80104028 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801031f3:	e8 48 f0 ff ff       	call   80102240 <kalloc>
801031f8:	89 43 08             	mov    %eax,0x8(%ebx)
801031fb:	83 c4 10             	add    $0x10,%esp
801031fe:	85 c0                	test   %eax,%eax
80103200:	74 53                	je     80103255 <allocproc+0xb5>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103202:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103208:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010320b:	c7 80 b0 0f 00 00 5b 	movl   $0x8010505b,0xfb0(%eax)
80103212:	50 10 80 

  sp -= sizeof *p->context;
80103215:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010321a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010321d:	52                   	push   %edx
8010321e:	6a 14                	push   $0x14
80103220:	6a 00                	push   $0x0
80103222:	50                   	push   %eax
80103223:	e8 48 0e 00 00       	call   80104070 <memset>
  p->context->eip = (uint)forkret;
80103228:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010322b:	c7 40 10 68 32 10 80 	movl   $0x80103268,0x10(%eax)

  return p;
80103232:	83 c4 10             	add    $0x10,%esp
}
80103235:	89 d8                	mov    %ebx,%eax
80103237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010323a:	c9                   	leave  
8010323b:	c3                   	ret    
  release(&ptable.lock);
8010323c:	83 ec 0c             	sub    $0xc,%esp
8010323f:	68 20 2d 11 80       	push   $0x80112d20
80103244:	e8 df 0d 00 00       	call   80104028 <release>
  return 0;
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	31 db                	xor    %ebx,%ebx
}
8010324e:	89 d8                	mov    %ebx,%eax
80103250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103253:	c9                   	leave  
80103254:	c3                   	ret    
    p->state = UNUSED;
80103255:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010325c:	31 db                	xor    %ebx,%ebx
}
8010325e:	89 d8                	mov    %ebx,%eax
80103260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103263:	c9                   	leave  
80103264:	c3                   	ret    
80103265:	8d 76 00             	lea    0x0(%esi),%esi

80103268 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103268:	55                   	push   %ebp
80103269:	89 e5                	mov    %esp,%ebp
8010326b:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010326e:	68 20 2d 11 80       	push   $0x80112d20
80103273:	e8 b0 0d 00 00       	call   80104028 <release>

  if (first) {
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103280:	85 c0                	test   %eax,%eax
80103282:	75 04                	jne    80103288 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103284:	c9                   	leave  
80103285:	c3                   	ret    
80103286:	66 90                	xchg   %ax,%ax
    first = 0;
80103288:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010328f:	00 00 00 
    iinit(ROOTDEV);
80103292:	83 ec 0c             	sub    $0xc,%esp
80103295:	6a 01                	push   $0x1
80103297:	e8 e8 e0 ff ff       	call   80101384 <iinit>
    initlog(ROOTDEV);
8010329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801032a3:	e8 10 f5 ff ff       	call   801027b8 <initlog>
}
801032a8:	83 c4 10             	add    $0x10,%esp
801032ab:	c9                   	leave  
801032ac:	c3                   	ret    
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

801032b0 <pinit>:
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801032b6:	68 a0 6c 10 80       	push   $0x80106ca0
801032bb:	68 20 2d 11 80       	push   $0x80112d20
801032c0:	e8 8b 0b 00 00       	call   80103e50 <initlock>
}
801032c5:	83 c4 10             	add    $0x10,%esp
801032c8:	c9                   	leave  
801032c9:	c3                   	ret    
801032ca:	66 90                	xchg   %ax,%ax

801032cc <mycpu>:
{
801032cc:	55                   	push   %ebp
801032cd:	89 e5                	mov    %esp,%ebp
801032cf:	56                   	push   %esi
801032d0:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032d1:	9c                   	pushf  
801032d2:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032d3:	f6 c4 02             	test   $0x2,%ah
801032d6:	75 48                	jne    80103320 <mycpu+0x54>
  apicid = lapicid();
801032d8:	e8 8b f1 ff ff       	call   80102468 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032dd:	8b 1d 00 2d 11 80    	mov    0x80112d00,%ebx
801032e3:	85 db                	test   %ebx,%ebx
801032e5:	7e 2c                	jle    80103313 <mycpu+0x47>
801032e7:	31 c9                	xor    %ecx,%ecx
801032e9:	eb 06                	jmp    801032f1 <mycpu+0x25>
801032eb:	90                   	nop
801032ec:	41                   	inc    %ecx
801032ed:	39 d9                	cmp    %ebx,%ecx
801032ef:	74 22                	je     80103313 <mycpu+0x47>
    if (cpus[i].apicid == apicid)
801032f1:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801032f4:	01 d2                	add    %edx,%edx
801032f6:	01 ca                	add    %ecx,%edx
801032f8:	c1 e2 04             	shl    $0x4,%edx
801032fb:	0f b6 b2 80 27 11 80 	movzbl -0x7feed880(%edx),%esi
80103302:	39 c6                	cmp    %eax,%esi
80103304:	75 e6                	jne    801032ec <mycpu+0x20>
      return &cpus[i];
80103306:	8d 82 80 27 11 80    	lea    -0x7feed880(%edx),%eax
}
8010330c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010330f:	5b                   	pop    %ebx
80103310:	5e                   	pop    %esi
80103311:	5d                   	pop    %ebp
80103312:	c3                   	ret    
  panic("unknown apicid\n");
80103313:	83 ec 0c             	sub    $0xc,%esp
80103316:	68 a7 6c 10 80       	push   $0x80106ca7
8010331b:	e8 20 d0 ff ff       	call   80100340 <panic>
    panic("mycpu called with interrupts enabled\n");
80103320:	83 ec 0c             	sub    $0xc,%esp
80103323:	68 98 6d 10 80       	push   $0x80106d98
80103328:	e8 13 d0 ff ff       	call   80100340 <panic>
8010332d:	8d 76 00             	lea    0x0(%esi),%esi

80103330 <cpuid>:
cpuid() {
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103336:	e8 91 ff ff ff       	call   801032cc <mycpu>
8010333b:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103340:	c1 f8 04             	sar    $0x4,%eax
80103343:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103346:	89 ca                	mov    %ecx,%edx
80103348:	c1 e2 05             	shl    $0x5,%edx
8010334b:	29 ca                	sub    %ecx,%edx
8010334d:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103350:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103353:	89 ca                	mov    %ecx,%edx
80103355:	c1 e2 0f             	shl    $0xf,%edx
80103358:	29 ca                	sub    %ecx,%edx
8010335a:	8d 04 90             	lea    (%eax,%edx,4),%eax
8010335d:	f7 d8                	neg    %eax
}
8010335f:	c9                   	leave  
80103360:	c3                   	ret    
80103361:	8d 76 00             	lea    0x0(%esi),%esi

80103364 <myproc>:
myproc(void) {
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 18             	sub    $0x18,%esp
  pushcli();
8010336a:	e8 45 0b 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
8010336f:	e8 58 ff ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103374:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010337a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010337d:	e8 7a 0b 00 00       	call   80103efc <popcli>
}
80103382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103385:	c9                   	leave  
80103386:	c3                   	ret    
80103387:	90                   	nop

80103388 <userinit>:
{
80103388:	55                   	push   %ebp
80103389:	89 e5                	mov    %esp,%ebp
8010338b:	53                   	push   %ebx
8010338c:	51                   	push   %ecx
  p = allocproc();
8010338d:	e8 0e fe ff ff       	call   801031a0 <allocproc>
80103392:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103394:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103399:	e8 56 31 00 00       	call   801064f4 <setupkvm>
8010339e:	89 43 04             	mov    %eax,0x4(%ebx)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 84 b3 00 00 00    	je     8010345c <userinit+0xd4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801033a9:	52                   	push   %edx
801033aa:	68 2c 00 00 00       	push   $0x2c
801033af:	68 60 a4 10 80       	push   $0x8010a460
801033b4:	50                   	push   %eax
801033b5:	e8 56 2e 00 00       	call   80106210 <inituvm>
  p->sz = PGSIZE;
801033ba:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801033c0:	83 c4 0c             	add    $0xc,%esp
801033c3:	6a 4c                	push   $0x4c
801033c5:	6a 00                	push   $0x0
801033c7:	ff 73 18             	pushl  0x18(%ebx)
801033ca:	e8 a1 0c 00 00       	call   80104070 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033cf:	8b 43 18             	mov    0x18(%ebx),%eax
801033d2:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033d8:	8b 43 18             	mov    0x18(%ebx),%eax
801033db:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033e1:	8b 43 18             	mov    0x18(%ebx),%eax
801033e4:	8b 50 2c             	mov    0x2c(%eax),%edx
801033e7:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033eb:	8b 43 18             	mov    0x18(%ebx),%eax
801033ee:	8b 50 2c             	mov    0x2c(%eax),%edx
801033f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033f5:	8b 43 18             	mov    0x18(%ebx),%eax
801033f8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103402:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103409:	8b 43 18             	mov    0x18(%ebx),%eax
8010340c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103413:	83 c4 0c             	add    $0xc,%esp
80103416:	6a 10                	push   $0x10
80103418:	68 d0 6c 10 80       	push   $0x80106cd0
8010341d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103420:	50                   	push   %eax
80103421:	e8 9e 0d 00 00       	call   801041c4 <safestrcpy>
  p->cwd = namei("/");
80103426:	c7 04 24 d9 6c 10 80 	movl   $0x80106cd9,(%esp)
8010342d:	e8 ea e8 ff ff       	call   80101d1c <namei>
80103432:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103435:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010343c:	e8 4f 0b 00 00       	call   80103f90 <acquire>
  p->state = RUNNABLE;
80103441:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103448:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010344f:	e8 d4 0b 00 00       	call   80104028 <release>
}
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010345a:	c9                   	leave  
8010345b:	c3                   	ret    
    panic("userinit: out of memory?");
8010345c:	83 ec 0c             	sub    $0xc,%esp
8010345f:	68 b7 6c 10 80       	push   $0x80106cb7
80103464:	e8 d7 ce ff ff       	call   80100340 <panic>
80103469:	8d 76 00             	lea    0x0(%esi),%esi

8010346c <growproc>:
{
8010346c:	55                   	push   %ebp
8010346d:	89 e5                	mov    %esp,%ebp
8010346f:	56                   	push   %esi
80103470:	53                   	push   %ebx
80103471:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103474:	e8 3b 0a 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
80103479:	e8 4e fe ff ff       	call   801032cc <mycpu>
  p = c->proc;
8010347e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103484:	e8 73 0a 00 00       	call   80103efc <popcli>
  sz = curproc->sz;
80103489:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010348b:	85 f6                	test   %esi,%esi
8010348d:	7f 19                	jg     801034a8 <growproc+0x3c>
  } else if(n < 0){
8010348f:	75 33                	jne    801034c4 <growproc+0x58>
  curproc->sz = sz;
80103491:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103493:	83 ec 0c             	sub    $0xc,%esp
80103496:	53                   	push   %ebx
80103497:	e8 78 2c 00 00       	call   80106114 <switchuvm>
  return 0;
8010349c:	83 c4 10             	add    $0x10,%esp
8010349f:	31 c0                	xor    %eax,%eax
}
801034a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5d                   	pop    %ebp
801034a7:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034a8:	51                   	push   %ecx
801034a9:	01 c6                	add    %eax,%esi
801034ab:	56                   	push   %esi
801034ac:	50                   	push   %eax
801034ad:	ff 73 04             	pushl  0x4(%ebx)
801034b0:	e8 8b 2e 00 00       	call   80106340 <allocuvm>
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	85 c0                	test   %eax,%eax
801034ba:	75 d5                	jne    80103491 <growproc+0x25>
      return -1;
801034bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034c1:	eb de                	jmp    801034a1 <growproc+0x35>
801034c3:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034c4:	52                   	push   %edx
801034c5:	01 c6                	add    %eax,%esi
801034c7:	56                   	push   %esi
801034c8:	50                   	push   %eax
801034c9:	ff 73 04             	pushl  0x4(%ebx)
801034cc:	e8 97 2f 00 00       	call   80106468 <deallocuvm>
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	85 c0                	test   %eax,%eax
801034d6:	75 b9                	jne    80103491 <growproc+0x25>
801034d8:	eb e2                	jmp    801034bc <growproc+0x50>
801034da:	66 90                	xchg   %ax,%ax

801034dc <fork>:
{
801034dc:	55                   	push   %ebp
801034dd:	89 e5                	mov    %esp,%ebp
801034df:	57                   	push   %edi
801034e0:	56                   	push   %esi
801034e1:	53                   	push   %ebx
801034e2:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801034e5:	e8 ca 09 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
801034ea:	e8 dd fd ff ff       	call   801032cc <mycpu>
  p = c->proc;
801034ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801034f5:	e8 02 0a 00 00       	call   80103efc <popcli>
  if((np = allocproc()) == 0){
801034fa:	e8 a1 fc ff ff       	call   801031a0 <allocproc>
801034ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103502:	85 c0                	test   %eax,%eax
80103504:	0f 84 b9 00 00 00    	je     801035c3 <fork+0xe7>
8010350a:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010350c:	83 ec 08             	sub    $0x8,%esp
8010350f:	ff 33                	pushl  (%ebx)
80103511:	ff 73 04             	pushl  0x4(%ebx)
80103514:	e8 97 30 00 00       	call   801065b0 <copyuvm>
80103519:	89 47 04             	mov    %eax,0x4(%edi)
8010351c:	83 c4 10             	add    $0x10,%esp
8010351f:	85 c0                	test   %eax,%eax
80103521:	0f 84 a3 00 00 00    	je     801035ca <fork+0xee>
  np->sz = curproc->sz;
80103527:	8b 03                	mov    (%ebx),%eax
80103529:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010352c:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010352e:	89 c8                	mov    %ecx,%eax
80103530:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103533:	8b 73 18             	mov    0x18(%ebx),%esi
80103536:	8b 79 18             	mov    0x18(%ecx),%edi
80103539:	b9 13 00 00 00       	mov    $0x13,%ecx
8010353e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103540:	8b 40 18             	mov    0x18(%eax),%eax
80103543:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010354a:	31 f6                	xor    %esi,%esi
    if(curproc->ofile[i])
8010354c:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103550:	85 c0                	test   %eax,%eax
80103552:	74 13                	je     80103567 <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103554:	83 ec 0c             	sub    $0xc,%esp
80103557:	50                   	push   %eax
80103558:	e8 fb d7 ff ff       	call   80100d58 <filedup>
8010355d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103560:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103564:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103567:	46                   	inc    %esi
80103568:	83 fe 10             	cmp    $0x10,%esi
8010356b:	75 df                	jne    8010354c <fork+0x70>
  np->cwd = idup(curproc->cwd);
8010356d:	83 ec 0c             	sub    $0xc,%esp
80103570:	ff 73 68             	pushl  0x68(%ebx)
80103573:	e8 c4 df ff ff       	call   8010153c <idup>
80103578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010357b:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010357e:	83 c4 0c             	add    $0xc,%esp
80103581:	6a 10                	push   $0x10
80103583:	83 c3 6c             	add    $0x6c,%ebx
80103586:	53                   	push   %ebx
80103587:	8d 47 6c             	lea    0x6c(%edi),%eax
8010358a:	50                   	push   %eax
8010358b:	e8 34 0c 00 00       	call   801041c4 <safestrcpy>
  pid = np->pid;
80103590:	8b 47 10             	mov    0x10(%edi),%eax
80103593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
80103596:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010359d:	e8 ee 09 00 00       	call   80103f90 <acquire>
  np->state = RUNNABLE;
801035a2:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801035a9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035b0:	e8 73 0a 00 00       	call   80104028 <release>
  return pid;
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801035bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035be:	5b                   	pop    %ebx
801035bf:	5e                   	pop    %esi
801035c0:	5f                   	pop    %edi
801035c1:	5d                   	pop    %ebp
801035c2:	c3                   	ret    
    return -1;
801035c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c8:	eb f1                	jmp    801035bb <fork+0xdf>
    kfree(np->kstack);
801035ca:	83 ec 0c             	sub    $0xc,%esp
801035cd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035d0:	ff 73 08             	pushl  0x8(%ebx)
801035d3:	e8 d8 ea ff ff       	call   801020b0 <kfree>
    np->kstack = 0;
801035d8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801035df:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801035e6:	83 c4 10             	add    $0x10,%esp
801035e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035ee:	eb cb                	jmp    801035bb <fork+0xdf>

801035f0 <scheduler>:
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801035f9:	e8 ce fc ff ff       	call   801032cc <mycpu>
801035fe:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103600:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103607:	00 00 00 
8010360a:	8d 78 04             	lea    0x4(%eax),%edi
8010360d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103610:	fb                   	sti    
    acquire(&ptable.lock);
80103611:	83 ec 0c             	sub    $0xc,%esp
80103614:	68 20 2d 11 80       	push   $0x80112d20
80103619:	e8 72 09 00 00       	call   80103f90 <acquire>
8010361e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103621:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103626:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103628:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010362c:	75 33                	jne    80103661 <scheduler+0x71>
      c->proc = p;
8010362e:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	53                   	push   %ebx
80103638:	e8 d7 2a 00 00       	call   80106114 <switchuvm>
      p->state = RUNNING;
8010363d:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103644:	58                   	pop    %eax
80103645:	5a                   	pop    %edx
80103646:	ff 73 1c             	pushl  0x1c(%ebx)
80103649:	57                   	push   %edi
8010364a:	e8 c2 0b 00 00       	call   80104211 <swtch>
      switchkvm();
8010364f:	e8 b0 2a 00 00       	call   80106104 <switchkvm>
      c->proc = 0;
80103654:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010365b:	00 00 00 
8010365e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103661:	83 c3 7c             	add    $0x7c,%ebx
80103664:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010366a:	75 bc                	jne    80103628 <scheduler+0x38>
    release(&ptable.lock);
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 20 2d 11 80       	push   $0x80112d20
80103674:	e8 af 09 00 00       	call   80104028 <release>
    sti();
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	eb 92                	jmp    80103610 <scheduler+0x20>
8010367e:	66 90                	xchg   %ax,%ax

80103680 <sched>:
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
  pushcli();
80103685:	e8 2a 08 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
8010368a:	e8 3d fc ff ff       	call   801032cc <mycpu>
  p = c->proc;
8010368f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103695:	e8 62 08 00 00       	call   80103efc <popcli>
  if(!holding(&ptable.lock))
8010369a:	83 ec 0c             	sub    $0xc,%esp
8010369d:	68 20 2d 11 80       	push   $0x80112d20
801036a2:	e8 ad 08 00 00       	call   80103f54 <holding>
801036a7:	83 c4 10             	add    $0x10,%esp
801036aa:	85 c0                	test   %eax,%eax
801036ac:	74 4f                	je     801036fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801036ae:	e8 19 fc ff ff       	call   801032cc <mycpu>
801036b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801036ba:	75 68                	jne    80103724 <sched+0xa4>
  if(p->state == RUNNING)
801036bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801036c0:	74 55                	je     80103717 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c2:	9c                   	pushf  
801036c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036c4:	f6 c4 02             	test   $0x2,%ah
801036c7:	75 41                	jne    8010370a <sched+0x8a>
  intena = mycpu()->intena;
801036c9:	e8 fe fb ff ff       	call   801032cc <mycpu>
801036ce:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036d4:	e8 f3 fb ff ff       	call   801032cc <mycpu>
801036d9:	83 ec 08             	sub    $0x8,%esp
801036dc:	ff 70 04             	pushl  0x4(%eax)
801036df:	83 c3 1c             	add    $0x1c,%ebx
801036e2:	53                   	push   %ebx
801036e3:	e8 29 0b 00 00       	call   80104211 <swtch>
  mycpu()->intena = intena;
801036e8:	e8 df fb ff ff       	call   801032cc <mycpu>
801036ed:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036f3:	83 c4 10             	add    $0x10,%esp
801036f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f9:	5b                   	pop    %ebx
801036fa:	5e                   	pop    %esi
801036fb:	5d                   	pop    %ebp
801036fc:	c3                   	ret    
    panic("sched ptable.lock");
801036fd:	83 ec 0c             	sub    $0xc,%esp
80103700:	68 db 6c 10 80       	push   $0x80106cdb
80103705:	e8 36 cc ff ff       	call   80100340 <panic>
    panic("sched interruptible");
8010370a:	83 ec 0c             	sub    $0xc,%esp
8010370d:	68 07 6d 10 80       	push   $0x80106d07
80103712:	e8 29 cc ff ff       	call   80100340 <panic>
    panic("sched running");
80103717:	83 ec 0c             	sub    $0xc,%esp
8010371a:	68 f9 6c 10 80       	push   $0x80106cf9
8010371f:	e8 1c cc ff ff       	call   80100340 <panic>
    panic("sched locks");
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 ed 6c 10 80       	push   $0x80106ced
8010372c:	e8 0f cc ff ff       	call   80100340 <panic>
80103731:	8d 76 00             	lea    0x0(%esi),%esi

80103734 <exit>:
{
80103734:	55                   	push   %ebp
80103735:	89 e5                	mov    %esp,%ebp
80103737:	57                   	push   %edi
80103738:	56                   	push   %esi
80103739:	53                   	push   %ebx
8010373a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010373d:	e8 72 07 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
80103742:	e8 85 fb ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103747:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010374d:	e8 aa 07 00 00       	call   80103efc <popcli>
  if(curproc == initproc)
80103752:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103758:	0f 84 e5 00 00 00    	je     80103843 <exit+0x10f>
8010375e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103761:	8d 7e 68             	lea    0x68(%esi),%edi
    if(curproc->ofile[fd]){
80103764:	8b 03                	mov    (%ebx),%eax
80103766:	85 c0                	test   %eax,%eax
80103768:	74 12                	je     8010377c <exit+0x48>
      fileclose(curproc->ofile[fd]);
8010376a:	83 ec 0c             	sub    $0xc,%esp
8010376d:	50                   	push   %eax
8010376e:	e8 29 d6 ff ff       	call   80100d9c <fileclose>
      curproc->ofile[fd] = 0;
80103773:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010377f:	39 df                	cmp    %ebx,%edi
80103781:	75 e1                	jne    80103764 <exit+0x30>
  begin_op();
80103783:	e8 c0 f0 ff ff       	call   80102848 <begin_op>
  iput(curproc->cwd);
80103788:	83 ec 0c             	sub    $0xc,%esp
8010378b:	ff 76 68             	pushl  0x68(%esi)
8010378e:	e8 e1 de ff ff       	call   80101674 <iput>
  end_op();
80103793:	e8 18 f1 ff ff       	call   801028b0 <end_op>
  curproc->cwd = 0;
80103798:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010379f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037a6:	e8 e5 07 00 00       	call   80103f90 <acquire>
  wakeup1(curproc->parent);
801037ab:	8b 56 14             	mov    0x14(%esi),%edx
801037ae:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801037b6:	eb 0a                	jmp    801037c2 <exit+0x8e>
801037b8:	83 c0 7c             	add    $0x7c,%eax
801037bb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801037c0:	74 1c                	je     801037de <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
801037c2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801037c6:	75 f0                	jne    801037b8 <exit+0x84>
801037c8:	3b 50 20             	cmp    0x20(%eax),%edx
801037cb:	75 eb                	jne    801037b8 <exit+0x84>
      p->state = RUNNABLE;
801037cd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	83 c0 7c             	add    $0x7c,%eax
801037d7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801037dc:	75 e4                	jne    801037c2 <exit+0x8e>
      p->parent = initproc;
801037de:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037e4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801037e9:	eb 0c                	jmp    801037f7 <exit+0xc3>
801037eb:	90                   	nop
801037ec:	83 c2 7c             	add    $0x7c,%edx
801037ef:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
801037f5:	74 33                	je     8010382a <exit+0xf6>
    if(p->parent == curproc){
801037f7:	39 72 14             	cmp    %esi,0x14(%edx)
801037fa:	75 f0                	jne    801037ec <exit+0xb8>
      p->parent = initproc;
801037fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801037ff:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
80103803:	75 e7                	jne    801037ec <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103805:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010380a:	eb 0a                	jmp    80103816 <exit+0xe2>
8010380c:	83 c0 7c             	add    $0x7c,%eax
8010380f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103814:	74 d6                	je     801037ec <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103816:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010381a:	75 f0                	jne    8010380c <exit+0xd8>
8010381c:	3b 48 20             	cmp    0x20(%eax),%ecx
8010381f:	75 eb                	jne    8010380c <exit+0xd8>
      p->state = RUNNABLE;
80103821:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103828:	eb e2                	jmp    8010380c <exit+0xd8>
  curproc->state = ZOMBIE;
8010382a:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103831:	e8 4a fe ff ff       	call   80103680 <sched>
  panic("zombie exit");
80103836:	83 ec 0c             	sub    $0xc,%esp
80103839:	68 28 6d 10 80       	push   $0x80106d28
8010383e:	e8 fd ca ff ff       	call   80100340 <panic>
    panic("init exiting");
80103843:	83 ec 0c             	sub    $0xc,%esp
80103846:	68 1b 6d 10 80       	push   $0x80106d1b
8010384b:	e8 f0 ca ff ff       	call   80100340 <panic>

80103850 <yield>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103857:	68 20 2d 11 80       	push   $0x80112d20
8010385c:	e8 2f 07 00 00       	call   80103f90 <acquire>
  pushcli();
80103861:	e8 4e 06 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
80103866:	e8 61 fa ff ff       	call   801032cc <mycpu>
  p = c->proc;
8010386b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103871:	e8 86 06 00 00       	call   80103efc <popcli>
  myproc()->state = RUNNABLE;
80103876:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010387d:	e8 fe fd ff ff       	call   80103680 <sched>
  release(&ptable.lock);
80103882:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103889:	e8 9a 07 00 00       	call   80104028 <release>
}
8010388e:	83 c4 10             	add    $0x10,%esp
80103891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103894:	c9                   	leave  
80103895:	c3                   	ret    
80103896:	66 90                	xchg   %ax,%ax

80103898 <sleep>:
{
80103898:	55                   	push   %ebp
80103899:	89 e5                	mov    %esp,%ebp
8010389b:	57                   	push   %edi
8010389c:	56                   	push   %esi
8010389d:	53                   	push   %ebx
8010389e:	83 ec 0c             	sub    $0xc,%esp
801038a1:	8b 7d 08             	mov    0x8(%ebp),%edi
801038a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801038a7:	e8 08 06 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
801038ac:	e8 1b fa ff ff       	call   801032cc <mycpu>
  p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038b7:	e8 40 06 00 00       	call   80103efc <popcli>
  if(p == 0)
801038bc:	85 db                	test   %ebx,%ebx
801038be:	0f 84 83 00 00 00    	je     80103947 <sleep+0xaf>
  if(lk == 0)
801038c4:	85 f6                	test   %esi,%esi
801038c6:	74 72                	je     8010393a <sleep+0xa2>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801038c8:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801038ce:	74 4c                	je     8010391c <sleep+0x84>
    acquire(&ptable.lock);  //DOC: sleeplock1
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	68 20 2d 11 80       	push   $0x80112d20
801038d8:	e8 b3 06 00 00       	call   80103f90 <acquire>
    release(lk);
801038dd:	89 34 24             	mov    %esi,(%esp)
801038e0:	e8 43 07 00 00       	call   80104028 <release>
  p->chan = chan;
801038e5:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801038e8:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801038ef:	e8 8c fd ff ff       	call   80103680 <sched>
  p->chan = 0;
801038f4:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801038fb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103902:	e8 21 07 00 00       	call   80104028 <release>
    acquire(lk);
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010390d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103910:	5b                   	pop    %ebx
80103911:	5e                   	pop    %esi
80103912:	5f                   	pop    %edi
80103913:	5d                   	pop    %ebp
    acquire(lk);
80103914:	e9 77 06 00 00       	jmp    80103f90 <acquire>
80103919:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
8010391c:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010391f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103926:	e8 55 fd ff ff       	call   80103680 <sched>
  p->chan = 0;
8010392b:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103932:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103935:	5b                   	pop    %ebx
80103936:	5e                   	pop    %esi
80103937:	5f                   	pop    %edi
80103938:	5d                   	pop    %ebp
80103939:	c3                   	ret    
    panic("sleep without lk");
8010393a:	83 ec 0c             	sub    $0xc,%esp
8010393d:	68 3a 6d 10 80       	push   $0x80106d3a
80103942:	e8 f9 c9 ff ff       	call   80100340 <panic>
    panic("sleep");
80103947:	83 ec 0c             	sub    $0xc,%esp
8010394a:	68 34 6d 10 80       	push   $0x80106d34
8010394f:	e8 ec c9 ff ff       	call   80100340 <panic>

80103954 <wait>:
{
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	56                   	push   %esi
80103958:	53                   	push   %ebx
80103959:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010395c:	e8 53 05 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
80103961:	e8 66 f9 ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103966:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010396c:	e8 8b 05 00 00       	call   80103efc <popcli>
  acquire(&ptable.lock);
80103971:	83 ec 0c             	sub    $0xc,%esp
80103974:	68 20 2d 11 80       	push   $0x80112d20
80103979:	e8 12 06 00 00       	call   80103f90 <acquire>
8010397e:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103981:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103983:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103988:	eb 0d                	jmp    80103997 <wait+0x43>
8010398a:	66 90                	xchg   %ax,%ax
8010398c:	83 c3 7c             	add    $0x7c,%ebx
8010398f:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103995:	74 1b                	je     801039b2 <wait+0x5e>
      if(p->parent != curproc)
80103997:	39 73 14             	cmp    %esi,0x14(%ebx)
8010399a:	75 f0                	jne    8010398c <wait+0x38>
      if(p->state == ZOMBIE){
8010399c:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801039a0:	74 2e                	je     801039d0 <wait+0x7c>
      havekids = 1;
801039a2:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a7:	83 c3 7c             	add    $0x7c,%ebx
801039aa:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801039b0:	75 e5                	jne    80103997 <wait+0x43>
    if(!havekids || curproc->killed){
801039b2:	85 c0                	test   %eax,%eax
801039b4:	74 74                	je     80103a2a <wait+0xd6>
801039b6:	8b 46 24             	mov    0x24(%esi),%eax
801039b9:	85 c0                	test   %eax,%eax
801039bb:	75 6d                	jne    80103a2a <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801039bd:	83 ec 08             	sub    $0x8,%esp
801039c0:	68 20 2d 11 80       	push   $0x80112d20
801039c5:	56                   	push   %esi
801039c6:	e8 cd fe ff ff       	call   80103898 <sleep>
    havekids = 0;
801039cb:	83 c4 10             	add    $0x10,%esp
801039ce:	eb b1                	jmp    80103981 <wait+0x2d>
        pid = p->pid;
801039d0:	8b 43 10             	mov    0x10(%ebx),%eax
801039d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
801039d6:	83 ec 0c             	sub    $0xc,%esp
801039d9:	ff 73 08             	pushl  0x8(%ebx)
801039dc:	e8 cf e6 ff ff       	call   801020b0 <kfree>
        p->kstack = 0;
801039e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801039e8:	5a                   	pop    %edx
801039e9:	ff 73 04             	pushl  0x4(%ebx)
801039ec:	e8 93 2a 00 00       	call   80106484 <freevm>
        p->pid = 0;
801039f1:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801039f8:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801039ff:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103a03:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103a0a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103a11:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a18:	e8 0b 06 00 00       	call   80104028 <release>
        return pid;
80103a1d:	83 c4 10             	add    $0x10,%esp
80103a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a26:	5b                   	pop    %ebx
80103a27:	5e                   	pop    %esi
80103a28:	5d                   	pop    %ebp
80103a29:	c3                   	ret    
      release(&ptable.lock);
80103a2a:	83 ec 0c             	sub    $0xc,%esp
80103a2d:	68 20 2d 11 80       	push   $0x80112d20
80103a32:	e8 f1 05 00 00       	call   80104028 <release>
      return -1;
80103a37:	83 c4 10             	add    $0x10,%esp
80103a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a3f:	eb e2                	jmp    80103a23 <wait+0xcf>
80103a41:	8d 76 00             	lea    0x0(%esi),%esi

80103a44 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	53                   	push   %ebx
80103a48:	83 ec 10             	sub    $0x10,%esp
80103a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103a4e:	68 20 2d 11 80       	push   $0x80112d20
80103a53:	e8 38 05 00 00       	call   80103f90 <acquire>
80103a58:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a5b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103a60:	eb 0c                	jmp    80103a6e <wakeup+0x2a>
80103a62:	66 90                	xchg   %ax,%ax
80103a64:	83 c0 7c             	add    $0x7c,%eax
80103a67:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103a6c:	74 1c                	je     80103a8a <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103a6e:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a72:	75 f0                	jne    80103a64 <wakeup+0x20>
80103a74:	3b 58 20             	cmp    0x20(%eax),%ebx
80103a77:	75 eb                	jne    80103a64 <wakeup+0x20>
      p->state = RUNNABLE;
80103a79:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a80:	83 c0 7c             	add    $0x7c,%eax
80103a83:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103a88:	75 e4                	jne    80103a6e <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103a8a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103a91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a94:	c9                   	leave  
  release(&ptable.lock);
80103a95:	e9 8e 05 00 00       	jmp    80104028 <release>
80103a9a:	66 90                	xchg   %ax,%ax

80103a9c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103a9c:	55                   	push   %ebp
80103a9d:	89 e5                	mov    %esp,%ebp
80103a9f:	53                   	push   %ebx
80103aa0:	83 ec 10             	sub    $0x10,%esp
80103aa3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103aa6:	68 20 2d 11 80       	push   $0x80112d20
80103aab:	e8 e0 04 00 00       	call   80103f90 <acquire>
80103ab0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ab8:	eb 0c                	jmp    80103ac6 <kill+0x2a>
80103aba:	66 90                	xchg   %ax,%ax
80103abc:	83 c0 7c             	add    $0x7c,%eax
80103abf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ac4:	74 32                	je     80103af8 <kill+0x5c>
    if(p->pid == pid){
80103ac6:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ac9:	75 f1                	jne    80103abc <kill+0x20>
      p->killed = 1;
80103acb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ad2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ad6:	75 07                	jne    80103adf <kill+0x43>
        p->state = RUNNABLE;
80103ad8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	68 20 2d 11 80       	push   $0x80112d20
80103ae7:	e8 3c 05 00 00       	call   80104028 <release>
      return 0;
80103aec:	83 c4 10             	add    $0x10,%esp
80103aef:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af4:	c9                   	leave  
80103af5:	c3                   	ret    
80103af6:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	68 20 2d 11 80       	push   $0x80112d20
80103b00:	e8 23 05 00 00       	call   80104028 <release>
  return -1;
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b10:	c9                   	leave  
80103b11:	c3                   	ret    
80103b12:	66 90                	xchg   %ax,%ax

80103b14 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103b14:	55                   	push   %ebp
80103b15:	89 e5                	mov    %esp,%ebp
80103b17:	57                   	push   %edi
80103b18:	56                   	push   %esi
80103b19:	53                   	push   %ebx
80103b1a:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103b22:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103b25:	eb 3f                	jmp    80103b66 <procdump+0x52>
80103b27:	90                   	nop
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b28:	8b 04 85 c0 6d 10 80 	mov    -0x7fef9240(,%eax,4),%eax
80103b2f:	85 c0                	test   %eax,%eax
80103b31:	74 3f                	je     80103b72 <procdump+0x5e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103b33:	53                   	push   %ebx
80103b34:	50                   	push   %eax
80103b35:	ff 73 a4             	pushl  -0x5c(%ebx)
80103b38:	68 4f 6d 10 80       	push   $0x80106d4f
80103b3d:	e8 de ca ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103b42:	83 c4 10             	add    $0x10,%esp
80103b45:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103b49:	74 31                	je     80103b7c <procdump+0x68>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103b4b:	83 ec 0c             	sub    $0xc,%esp
80103b4e:	68 db 70 10 80       	push   $0x801070db
80103b53:	e8 c8 ca ff ff       	call   80100620 <cprintf>
80103b58:	83 c4 10             	add    $0x10,%esp
80103b5b:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b5e:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103b64:	74 52                	je     80103bb8 <procdump+0xa4>
    if(p->state == UNUSED)
80103b66:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103b69:	85 c0                	test   %eax,%eax
80103b6b:	74 ee                	je     80103b5b <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b6d:	83 f8 05             	cmp    $0x5,%eax
80103b70:	76 b6                	jbe    80103b28 <procdump+0x14>
      state = "???";
80103b72:	b8 4b 6d 10 80       	mov    $0x80106d4b,%eax
80103b77:	eb ba                	jmp    80103b33 <procdump+0x1f>
80103b79:	8d 76 00             	lea    0x0(%esi),%esi
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103b7c:	83 ec 08             	sub    $0x8,%esp
80103b7f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103b82:	50                   	push   %eax
80103b83:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103b86:	8b 40 0c             	mov    0xc(%eax),%eax
80103b89:	83 c0 08             	add    $0x8,%eax
80103b8c:	50                   	push   %eax
80103b8d:	e8 da 02 00 00       	call   80103e6c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b92:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	8b 17                	mov    (%edi),%edx
80103b9a:	85 d2                	test   %edx,%edx
80103b9c:	74 ad                	je     80103b4b <procdump+0x37>
        cprintf(" %p", pc[i]);
80103b9e:	83 ec 08             	sub    $0x8,%esp
80103ba1:	52                   	push   %edx
80103ba2:	68 a1 67 10 80       	push   $0x801067a1
80103ba7:	e8 74 ca ff ff       	call   80100620 <cprintf>
80103bac:	83 c7 04             	add    $0x4,%edi
      for(i=0; i<10 && pc[i] != 0; i++)
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	39 fe                	cmp    %edi,%esi
80103bb4:	75 e2                	jne    80103b98 <procdump+0x84>
80103bb6:	eb 93                	jmp    80103b4b <procdump+0x37>
  }
}
80103bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bbb:	5b                   	pop    %ebx
80103bbc:	5e                   	pop    %esi
80103bbd:	5f                   	pop    %edi
80103bbe:	5d                   	pop    %ebp
80103bbf:	c3                   	ret    

80103bc0 <clone>:

// cs202 lab2
// create a process using the parent's address space
int clone(void*(func)(void*), void *stack, int size, void *arg) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103bc9:	e8 e6 02 00 00       	call   80103eb4 <pushcli>
  c = mycpu();
80103bce:	e8 f9 f6 ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103bd3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103bd9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  popcli();
80103bdc:	e8 1b 03 00 00       	call   80103efc <popcli>
  int i, pid;
  struct proc *np;
  struct proc *currproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103be1:	e8 ba f5 ff ff       	call   801031a0 <allocproc>
80103be6:	85 c0                	test   %eax,%eax
80103be8:	0f 84 33 01 00 00    	je     80103d21 <clone+0x161>
    return -1;
  }

  if ((uint)stack % PGSIZE != 0 || stack == 0)
80103bee:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80103bf5:	0f 85 26 01 00 00    	jne    80103d21 <clone+0x161>
80103bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bfe:	85 d2                	test   %edx,%edx
80103c00:	0f 84 1b 01 00 00    	je     80103d21 <clone+0x161>
80103c06:	89 c3                	mov    %eax,%ebx
    return -1;

  // step 1: share the same address space with parent
  np->state = UNUSED;
80103c08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  np->sz = currproc->sz;
80103c0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103c12:	8b 02                	mov    (%edx),%eax
80103c14:	89 03                	mov    %eax,(%ebx)
  np->parent = currproc;
80103c16:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *currproc->tf;
80103c19:	8b 72 18             	mov    0x18(%edx),%esi
80103c1c:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c21:	8b 7b 18             	mov    0x18(%ebx),%edi
80103c24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->pgdir = currproc->pgdir;
80103c26:	8b 42 04             	mov    0x4(%edx),%eax
80103c29:	89 43 04             	mov    %eax,0x4(%ebx)

  np->tf->eip = (uint)func; // set instruction pointer
80103c2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103c32:	89 48 38             	mov    %ecx,0x38(%eax)
  np->tf->eax = 0;          // clear %eax so that fork returns 0 in the child.
80103c35:	8b 43 18             	mov    0x18(%ebx),%eax
80103c38:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  // step 2: use the same file descriptor
  for (i = 0; i < NOFILE; i++)
80103c3f:	31 f6                	xor    %esi,%esi
80103c41:	89 d7                	mov    %edx,%edi
80103c43:	90                   	nop
    if (currproc->ofile[i])
80103c44:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	74 10                	je     80103c5c <clone+0x9c>
      np->ofile[i] = filedup(currproc->ofile[i]);
80103c4c:	83 ec 0c             	sub    $0xc,%esp
80103c4f:	50                   	push   %eax
80103c50:	e8 03 d1 ff ff       	call   80100d58 <filedup>
80103c55:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103c59:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NOFILE; i++)
80103c5c:	46                   	inc    %esi
80103c5d:	83 fe 10             	cmp    $0x10,%esi
80103c60:	75 e2                	jne    80103c44 <clone+0x84>
  np->cwd = idup(currproc->cwd);
80103c62:	83 ec 0c             	sub    $0xc,%esp
80103c65:	ff 77 68             	pushl  0x68(%edi)
80103c68:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80103c6b:	e8 cc d8 ff ff       	call   8010153c <idup>
80103c70:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, currproc->name, sizeof(currproc->name));
80103c73:	83 c4 0c             	add    $0xc,%esp
80103c76:	6a 10                	push   $0x10
80103c78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103c7b:	8d 42 6c             	lea    0x6c(%edx),%eax
80103c7e:	50                   	push   %eax
80103c7f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c82:	50                   	push   %eax
80103c83:	e8 3c 05 00 00       	call   801041c4 <safestrcpy>

  acquire(&ptable.lock);
80103c88:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c8f:	e8 fc 02 00 00       	call   80103f90 <acquire>
  uint ustack[2];
  ustack[0] = 0xffffffff;  // fake return PC
80103c94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  ustack[1] = (uint)arg;
80103c9b:	8b 45 14             	mov    0x14(%ebp),%eax
80103c9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  // test
  np->tf->esp = (uint)(stack+PGSIZE - 4); //put esp to right spot on stack
80103ca1:	8b 4b 18             	mov    0x18(%ebx),%ecx
80103ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca7:	05 fc 0f 00 00       	add    $0xffc,%eax
80103cac:	89 41 44             	mov    %eax,0x44(%ecx)
  *((uint*)(np->tf->esp)) = (uint)arg; //arg to function
80103caf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb2:	8b 40 44             	mov    0x44(%eax),%eax
80103cb5:	8b 4d 14             	mov    0x14(%ebp),%ecx
80103cb8:	89 08                	mov    %ecx,(%eax)
  *((uint*)(np->tf->esp) - 4) = 0xFFFFFFFF; //return to nowhere
80103cba:	8b 43 18             	mov    0x18(%ebx),%eax
80103cbd:	8b 40 44             	mov    0x44(%eax),%eax
80103cc0:	c7 40 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%eax)
  np->tf->esp =(np->tf->esp) - 4;
80103cc7:	8b 43 18             	mov    0x18(%ebx),%eax
80103cca:	83 68 44 04          	subl   $0x4,0x44(%eax)
  if (copyout(np->pgdir, np->tf->esp, ustack, size) < 0) {
80103cce:	ff 75 10             	pushl  0x10(%ebp)
80103cd1:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cd4:	50                   	push   %eax
80103cd5:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd8:	ff 70 44             	pushl  0x44(%eax)
80103cdb:	ff 73 04             	pushl  0x4(%ebx)
80103cde:	e8 e1 29 00 00       	call   801066c4 <copyout>
80103ce3:	83 c4 20             	add    $0x20,%esp
80103ce6:	85 c0                	test   %eax,%eax
80103ce8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103ceb:	78 3b                	js     80103d28 <clone+0x168>
    cprintf("Stack copy failed.\n");
    return -1;
  }

  np->state = RUNNABLE;
80103ced:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  //   cprintf("Stack copy failed.\n");
  //   return -1;
  // }

  // np->tf->esp = sp;
  np->tf->ebp = currproc->tf->esp;  // set base pointer
80103cf4:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf7:	8b 52 18             	mov    0x18(%edx),%edx
80103cfa:	8b 52 44             	mov    0x44(%edx),%edx
80103cfd:	89 50 08             	mov    %edx,0x8(%eax)

  pid = np->pid;
80103d00:	8b 43 10             	mov    0x10(%ebx),%eax
80103d03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  release(&ptable.lock);
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	68 20 2d 11 80       	push   $0x80112d20
80103d0e:	e8 15 03 00 00       	call   80104028 <release>

  return pid;
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80103d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d1c:	5b                   	pop    %ebx
80103d1d:	5e                   	pop    %esi
80103d1e:	5f                   	pop    %edi
80103d1f:	5d                   	pop    %ebp
80103d20:	c3                   	ret    
    return -1;
80103d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d26:	eb f1                	jmp    80103d19 <clone+0x159>
    cprintf("Stack copy failed.\n");
80103d28:	83 ec 0c             	sub    $0xc,%esp
80103d2b:	68 58 6d 10 80       	push   $0x80106d58
80103d30:	e8 eb c8 ff ff       	call   80100620 <cprintf>
    return -1;
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d3d:	eb da                	jmp    80103d19 <clone+0x159>
80103d3f:	90                   	nop

80103d40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103d4a:	68 d8 6d 10 80       	push   $0x80106dd8
80103d4f:	8d 43 04             	lea    0x4(%ebx),%eax
80103d52:	50                   	push   %eax
80103d53:	e8 f8 00 00 00       	call   80103e50 <initlock>
  lk->name = name;
80103d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103d5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103d64:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d71:	c9                   	leave  
80103d72:	c3                   	ret    
80103d73:	90                   	nop

80103d74 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103d74:	55                   	push   %ebp
80103d75:	89 e5                	mov    %esp,%ebp
80103d77:	56                   	push   %esi
80103d78:	53                   	push   %ebx
80103d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103d7c:	8d 73 04             	lea    0x4(%ebx),%esi
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	56                   	push   %esi
80103d83:	e8 08 02 00 00       	call   80103f90 <acquire>
  while (lk->locked) {
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	8b 13                	mov    (%ebx),%edx
80103d8d:	85 d2                	test   %edx,%edx
80103d8f:	74 16                	je     80103da7 <acquiresleep+0x33>
80103d91:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103d94:	83 ec 08             	sub    $0x8,%esp
80103d97:	56                   	push   %esi
80103d98:	53                   	push   %ebx
80103d99:	e8 fa fa ff ff       	call   80103898 <sleep>
  while (lk->locked) {
80103d9e:	83 c4 10             	add    $0x10,%esp
80103da1:	8b 03                	mov    (%ebx),%eax
80103da3:	85 c0                	test   %eax,%eax
80103da5:	75 ed                	jne    80103d94 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103da7:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103dad:	e8 b2 f5 ff ff       	call   80103364 <myproc>
80103db2:	8b 40 10             	mov    0x10(%eax),%eax
80103db5:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103db8:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103dbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dbe:	5b                   	pop    %ebx
80103dbf:	5e                   	pop    %esi
80103dc0:	5d                   	pop    %ebp
  release(&lk->lk);
80103dc1:	e9 62 02 00 00       	jmp    80104028 <release>
80103dc6:	66 90                	xchg   %ax,%ax

80103dc8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103dc8:	55                   	push   %ebp
80103dc9:	89 e5                	mov    %esp,%ebp
80103dcb:	56                   	push   %esi
80103dcc:	53                   	push   %ebx
80103dcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103dd0:	8d 73 04             	lea    0x4(%ebx),%esi
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	56                   	push   %esi
80103dd7:	e8 b4 01 00 00       	call   80103f90 <acquire>
  lk->locked = 0;
80103ddc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103de2:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103de9:	89 1c 24             	mov    %ebx,(%esp)
80103dec:	e8 53 fc ff ff       	call   80103a44 <wakeup>
  release(&lk->lk);
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103df7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dfa:	5b                   	pop    %ebx
80103dfb:	5e                   	pop    %esi
80103dfc:	5d                   	pop    %ebp
  release(&lk->lk);
80103dfd:	e9 26 02 00 00       	jmp    80104028 <release>
80103e02:	66 90                	xchg   %ax,%ax

80103e04 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	56                   	push   %esi
80103e08:	53                   	push   %ebx
80103e09:	83 ec 1c             	sub    $0x1c,%esp
80103e0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103e0f:	8d 73 04             	lea    0x4(%ebx),%esi
80103e12:	56                   	push   %esi
80103e13:	e8 78 01 00 00       	call   80103f90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103e18:	83 c4 10             	add    $0x10,%esp
80103e1b:	8b 03                	mov    (%ebx),%eax
80103e1d:	85 c0                	test   %eax,%eax
80103e1f:	75 1b                	jne    80103e3c <holdingsleep+0x38>
80103e21:	31 c0                	xor    %eax,%eax
80103e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	56                   	push   %esi
80103e2a:	e8 f9 01 00 00       	call   80104028 <release>
  return r;
}
80103e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e35:	5b                   	pop    %ebx
80103e36:	5e                   	pop    %esi
80103e37:	5d                   	pop    %ebp
80103e38:	c3                   	ret    
80103e39:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80103e3c:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103e3f:	e8 20 f5 ff ff       	call   80103364 <myproc>
80103e44:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e47:	0f 94 c0             	sete   %al
80103e4a:	0f b6 c0             	movzbl %al,%eax
80103e4d:	eb d4                	jmp    80103e23 <holdingsleep+0x1f>
80103e4f:	90                   	nop

80103e50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103e56:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e59:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103e69:	5d                   	pop    %ebp
80103e6a:	c3                   	ret    
80103e6b:	90                   	nop

80103e6c <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103e6c:	55                   	push   %ebp
80103e6d:	89 e5                	mov    %esp,%ebp
80103e6f:	53                   	push   %ebx
80103e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103e73:	8b 45 08             	mov    0x8(%ebp),%eax
80103e76:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80103e79:	31 d2                	xor    %edx,%edx
80103e7b:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103e7c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80103e82:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103e88:	77 12                	ja     80103e9c <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103e8a:	8b 58 04             	mov    0x4(%eax),%ebx
80103e8d:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103e90:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80103e92:	42                   	inc    %edx
80103e93:	83 fa 0a             	cmp    $0xa,%edx
80103e96:	75 e4                	jne    80103e7c <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103e98:	5b                   	pop    %ebx
80103e99:	5d                   	pop    %ebp
80103e9a:	c3                   	ret    
80103e9b:	90                   	nop
80103e9c:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80103e9f:	8d 51 28             	lea    0x28(%ecx),%edx
80103ea2:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80103ea4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103eaa:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80103ead:	39 d0                	cmp    %edx,%eax
80103eaf:	75 f3                	jne    80103ea4 <getcallerpcs+0x38>
}
80103eb1:	5b                   	pop    %ebx
80103eb2:	5d                   	pop    %ebp
80103eb3:	c3                   	ret    

80103eb4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	53                   	push   %ebx
80103eb8:	52                   	push   %edx
80103eb9:	9c                   	pushf  
80103eba:	5b                   	pop    %ebx
  asm volatile("cli");
80103ebb:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103ebc:	e8 0b f4 ff ff       	call   801032cc <mycpu>
80103ec1:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103ec7:	85 c9                	test   %ecx,%ecx
80103ec9:	74 11                	je     80103edc <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103ecb:	e8 fc f3 ff ff       	call   801032cc <mycpu>
80103ed0:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103ed6:	58                   	pop    %eax
80103ed7:	5b                   	pop    %ebx
80103ed8:	5d                   	pop    %ebp
80103ed9:	c3                   	ret    
80103eda:	66 90                	xchg   %ax,%ax
    mycpu()->intena = eflags & FL_IF;
80103edc:	e8 eb f3 ff ff       	call   801032cc <mycpu>
80103ee1:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103ee7:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80103eed:	e8 da f3 ff ff       	call   801032cc <mycpu>
80103ef2:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103ef8:	58                   	pop    %eax
80103ef9:	5b                   	pop    %ebx
80103efa:	5d                   	pop    %ebp
80103efb:	c3                   	ret    

80103efc <popcli>:

void
popcli(void)
{
80103efc:	55                   	push   %ebp
80103efd:	89 e5                	mov    %esp,%ebp
80103eff:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f02:	9c                   	pushf  
80103f03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f04:	f6 c4 02             	test   $0x2,%ah
80103f07:	75 31                	jne    80103f3a <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103f09:	e8 be f3 ff ff       	call   801032cc <mycpu>
80103f0e:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80103f14:	78 31                	js     80103f47 <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f16:	e8 b1 f3 ff ff       	call   801032cc <mycpu>
80103f1b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80103f21:	85 d2                	test   %edx,%edx
80103f23:	74 03                	je     80103f28 <popcli+0x2c>
    sti();
}
80103f25:	c9                   	leave  
80103f26:	c3                   	ret    
80103f27:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f28:	e8 9f f3 ff ff       	call   801032cc <mycpu>
80103f2d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103f33:	85 c0                	test   %eax,%eax
80103f35:	74 ee                	je     80103f25 <popcli+0x29>
  asm volatile("sti");
80103f37:	fb                   	sti    
}
80103f38:	c9                   	leave  
80103f39:	c3                   	ret    
    panic("popcli - interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 e3 6d 10 80       	push   $0x80106de3
80103f42:	e8 f9 c3 ff ff       	call   80100340 <panic>
    panic("popcli");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 fa 6d 10 80       	push   $0x80106dfa
80103f4f:	e8 ec c3 ff ff       	call   80100340 <panic>

80103f54 <holding>:
{
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	53                   	push   %ebx
80103f58:	83 ec 14             	sub    $0x14,%esp
80103f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103f5e:	e8 51 ff ff ff       	call   80103eb4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103f63:	8b 03                	mov    (%ebx),%eax
80103f65:	85 c0                	test   %eax,%eax
80103f67:	75 13                	jne    80103f7c <holding+0x28>
80103f69:	31 c0                	xor    %eax,%eax
80103f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80103f6e:	e8 89 ff ff ff       	call   80103efc <popcli>
}
80103f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f76:	83 c4 14             	add    $0x14,%esp
80103f79:	5b                   	pop    %ebx
80103f7a:	5d                   	pop    %ebp
80103f7b:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103f7c:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103f7f:	e8 48 f3 ff ff       	call   801032cc <mycpu>
80103f84:	39 c3                	cmp    %eax,%ebx
80103f86:	0f 94 c0             	sete   %al
80103f89:	0f b6 c0             	movzbl %al,%eax
80103f8c:	eb dd                	jmp    80103f6b <holding+0x17>
80103f8e:	66 90                	xchg   %ax,%ax

80103f90 <acquire>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80103f95:	e8 1a ff ff ff       	call   80103eb4 <pushcli>
  if(holding(lk))
80103f9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f9d:	83 ec 0c             	sub    $0xc,%esp
80103fa0:	53                   	push   %ebx
80103fa1:	e8 ae ff ff ff       	call   80103f54 <holding>
80103fa6:	83 c4 10             	add    $0x10,%esp
80103fa9:	85 c0                	test   %eax,%eax
80103fab:	75 6b                	jne    80104018 <acquire+0x88>
80103fad:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80103faf:	ba 01 00 00 00       	mov    $0x1,%edx
80103fb4:	eb 05                	jmp    80103fbb <acquire+0x2b>
80103fb6:	66 90                	xchg   %ax,%ax
80103fb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fbb:	89 d0                	mov    %edx,%eax
80103fbd:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80103fc0:	85 c0                	test   %eax,%eax
80103fc2:	75 f4                	jne    80103fb8 <acquire+0x28>
  __sync_synchronize();
80103fc4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fcc:	e8 fb f2 ff ff       	call   801032cc <mycpu>
80103fd1:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80103fd4:	89 e8                	mov    %ebp,%eax
80103fd6:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103fd8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103fde:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103fe4:	77 16                	ja     80103ffc <acquire+0x6c>
    pcs[i] = ebp[1];     // saved %eip
80103fe6:	8b 50 04             	mov    0x4(%eax),%edx
80103fe9:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103fed:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80103fef:	46                   	inc    %esi
80103ff0:	83 fe 0a             	cmp    $0xa,%esi
80103ff3:	75 e3                	jne    80103fd8 <acquire+0x48>
}
80103ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff8:	5b                   	pop    %ebx
80103ff9:	5e                   	pop    %esi
80103ffa:	5d                   	pop    %ebp
80103ffb:	c3                   	ret    
80103ffc:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104000:	83 c3 34             	add    $0x34,%ebx
80104003:	90                   	nop
    pcs[i] = 0;
80104004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010400a:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
8010400d:	39 d8                	cmp    %ebx,%eax
8010400f:	75 f3                	jne    80104004 <acquire+0x74>
}
80104011:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104014:	5b                   	pop    %ebx
80104015:	5e                   	pop    %esi
80104016:	5d                   	pop    %ebp
80104017:	c3                   	ret    
    panic("acquire");
80104018:	83 ec 0c             	sub    $0xc,%esp
8010401b:	68 01 6e 10 80       	push   $0x80106e01
80104020:	e8 1b c3 ff ff       	call   80100340 <panic>
80104025:	8d 76 00             	lea    0x0(%esi),%esi

80104028 <release>:
{
80104028:	55                   	push   %ebp
80104029:	89 e5                	mov    %esp,%ebp
8010402b:	53                   	push   %ebx
8010402c:	83 ec 10             	sub    $0x10,%esp
8010402f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104032:	53                   	push   %ebx
80104033:	e8 1c ff ff ff       	call   80103f54 <holding>
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	85 c0                	test   %eax,%eax
8010403d:	74 22                	je     80104061 <release+0x39>
  lk->pcs[0] = 0;
8010403f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104046:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010404d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104052:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010405b:	c9                   	leave  
  popcli();
8010405c:	e9 9b fe ff ff       	jmp    80103efc <popcli>
    panic("release");
80104061:	83 ec 0c             	sub    $0xc,%esp
80104064:	68 09 6e 10 80       	push   $0x80106e09
80104069:	e8 d2 c2 ff ff       	call   80100340 <panic>
8010406e:	66 90                	xchg   %ax,%ax

80104070 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	53                   	push   %ebx
80104075:	8b 55 08             	mov    0x8(%ebp),%edx
80104078:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010407b:	89 d0                	mov    %edx,%eax
8010407d:	09 c8                	or     %ecx,%eax
8010407f:	a8 03                	test   $0x3,%al
80104081:	75 29                	jne    801040ac <memset+0x3c>
    c &= 0xFF;
80104083:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104087:	c1 e9 02             	shr    $0x2,%ecx
8010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408d:	c1 e0 18             	shl    $0x18,%eax
80104090:	89 fb                	mov    %edi,%ebx
80104092:	c1 e3 10             	shl    $0x10,%ebx
80104095:	09 d8                	or     %ebx,%eax
80104097:	09 f8                	or     %edi,%eax
80104099:	c1 e7 08             	shl    $0x8,%edi
8010409c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010409e:	89 d7                	mov    %edx,%edi
801040a0:	fc                   	cld    
801040a1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801040a3:	89 d0                	mov    %edx,%eax
801040a5:	5b                   	pop    %ebx
801040a6:	5f                   	pop    %edi
801040a7:	5d                   	pop    %ebp
801040a8:	c3                   	ret    
801040a9:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801040ac:	89 d7                	mov    %edx,%edi
801040ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b1:	fc                   	cld    
801040b2:	f3 aa                	rep stos %al,%es:(%edi)
801040b4:	89 d0                	mov    %edx,%eax
801040b6:	5b                   	pop    %ebx
801040b7:	5f                   	pop    %edi
801040b8:	5d                   	pop    %ebp
801040b9:	c3                   	ret    
801040ba:	66 90                	xchg   %ax,%ax

801040bc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801040bc:	55                   	push   %ebp
801040bd:	89 e5                	mov    %esp,%ebp
801040bf:	56                   	push   %esi
801040c0:	53                   	push   %ebx
801040c1:	8b 55 08             	mov    0x8(%ebp),%edx
801040c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c7:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801040ca:	85 f6                	test   %esi,%esi
801040cc:	74 1e                	je     801040ec <memcmp+0x30>
801040ce:	01 c6                	add    %eax,%esi
801040d0:	eb 08                	jmp    801040da <memcmp+0x1e>
801040d2:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801040d4:	42                   	inc    %edx
801040d5:	40                   	inc    %eax
  while(n-- > 0){
801040d6:	39 f0                	cmp    %esi,%eax
801040d8:	74 12                	je     801040ec <memcmp+0x30>
    if(*s1 != *s2)
801040da:	8a 0a                	mov    (%edx),%cl
801040dc:	0f b6 18             	movzbl (%eax),%ebx
801040df:	38 d9                	cmp    %bl,%cl
801040e1:	74 f1                	je     801040d4 <memcmp+0x18>
      return *s1 - *s2;
801040e3:	0f b6 c1             	movzbl %cl,%eax
801040e6:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801040e8:	5b                   	pop    %ebx
801040e9:	5e                   	pop    %esi
801040ea:	5d                   	pop    %ebp
801040eb:	c3                   	ret    
  return 0;
801040ec:	31 c0                	xor    %eax,%eax
}
801040ee:	5b                   	pop    %ebx
801040ef:	5e                   	pop    %esi
801040f0:	5d                   	pop    %ebp
801040f1:	c3                   	ret    
801040f2:	66 90                	xchg   %ax,%ax

801040f4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	57                   	push   %edi
801040f8:	56                   	push   %esi
801040f9:	8b 55 08             	mov    0x8(%ebp),%edx
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801040ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104102:	39 d6                	cmp    %edx,%esi
80104104:	73 07                	jae    8010410d <memmove+0x19>
80104106:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104109:	39 fa                	cmp    %edi,%edx
8010410b:	72 17                	jb     80104124 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010410d:	85 c9                	test   %ecx,%ecx
8010410f:	74 0c                	je     8010411d <memmove+0x29>
80104111:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104114:	89 d7                	mov    %edx,%edi
80104116:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104118:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104119:	39 f0                	cmp    %esi,%eax
8010411b:	75 fb                	jne    80104118 <memmove+0x24>

  return dst;
}
8010411d:	89 d0                	mov    %edx,%eax
8010411f:	5e                   	pop    %esi
80104120:	5f                   	pop    %edi
80104121:	5d                   	pop    %ebp
80104122:	c3                   	ret    
80104123:	90                   	nop
80104124:	8d 41 ff             	lea    -0x1(%ecx),%eax
    while(n-- > 0)
80104127:	85 c9                	test   %ecx,%ecx
80104129:	74 f2                	je     8010411d <memmove+0x29>
8010412b:	90                   	nop
      *--d = *--s;
8010412c:	8a 0c 06             	mov    (%esi,%eax,1),%cl
8010412f:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104132:	48                   	dec    %eax
80104133:	83 f8 ff             	cmp    $0xffffffff,%eax
80104136:	75 f4                	jne    8010412c <memmove+0x38>
}
80104138:	89 d0                	mov    %edx,%eax
8010413a:	5e                   	pop    %esi
8010413b:	5f                   	pop    %edi
8010413c:	5d                   	pop    %ebp
8010413d:	c3                   	ret    
8010413e:	66 90                	xchg   %ax,%ax

80104140 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104140:	eb b2                	jmp    801040f4 <memmove>
80104142:	66 90                	xchg   %ax,%ax

80104144 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	56                   	push   %esi
80104148:	53                   	push   %ebx
80104149:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010414c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010414f:	8b 75 10             	mov    0x10(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104152:	85 f6                	test   %esi,%esi
80104154:	74 22                	je     80104178 <strncmp+0x34>
80104156:	01 c6                	add    %eax,%esi
80104158:	eb 0c                	jmp    80104166 <strncmp+0x22>
8010415a:	66 90                	xchg   %ax,%ax
8010415c:	38 ca                	cmp    %cl,%dl
8010415e:	75 0f                	jne    8010416f <strncmp+0x2b>
    n--, p++, q++;
80104160:	43                   	inc    %ebx
80104161:	40                   	inc    %eax
  while(n > 0 && *p && *p == *q)
80104162:	39 f0                	cmp    %esi,%eax
80104164:	74 12                	je     80104178 <strncmp+0x34>
80104166:	8a 13                	mov    (%ebx),%dl
80104168:	0f b6 08             	movzbl (%eax),%ecx
8010416b:	84 d2                	test   %dl,%dl
8010416d:	75 ed                	jne    8010415c <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010416f:	0f b6 c2             	movzbl %dl,%eax
80104172:	29 c8                	sub    %ecx,%eax
}
80104174:	5b                   	pop    %ebx
80104175:	5e                   	pop    %esi
80104176:	5d                   	pop    %ebp
80104177:	c3                   	ret    
    return 0;
80104178:	31 c0                	xor    %eax,%eax
}
8010417a:	5b                   	pop    %ebx
8010417b:	5e                   	pop    %esi
8010417c:	5d                   	pop    %ebp
8010417d:	c3                   	ret    
8010417e:	66 90                	xchg   %ax,%ax

80104180 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104188:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010418b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010418e:	eb 0c                	jmp    8010419c <strncpy+0x1c>
80104190:	43                   	inc    %ebx
80104191:	41                   	inc    %ecx
80104192:	8a 43 ff             	mov    -0x1(%ebx),%al
80104195:	88 41 ff             	mov    %al,-0x1(%ecx)
80104198:	84 c0                	test   %al,%al
8010419a:	74 07                	je     801041a3 <strncpy+0x23>
    ;
8010419c:	89 d6                	mov    %edx,%esi
  while(n-- > 0 && (*s++ = *t++) != 0)
8010419e:	4a                   	dec    %edx
8010419f:	85 f6                	test   %esi,%esi
801041a1:	7f ed                	jg     80104190 <strncpy+0x10>
  while(n-- > 0)
801041a3:	89 cb                	mov    %ecx,%ebx
801041a5:	85 d2                	test   %edx,%edx
801041a7:	7e 14                	jle    801041bd <strncpy+0x3d>
801041a9:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
801041ac:	43                   	inc    %ebx
801041ad:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
801041b1:	89 da                	mov    %ebx,%edx
801041b3:	f7 d2                	not    %edx
801041b5:	01 ca                	add    %ecx,%edx
801041b7:	01 f2                	add    %esi,%edx
  while(n-- > 0)
801041b9:	85 d2                	test   %edx,%edx
801041bb:	7f ef                	jg     801041ac <strncpy+0x2c>
  return os;
}
801041bd:	8b 45 08             	mov    0x8(%ebp),%eax
801041c0:	5b                   	pop    %ebx
801041c1:	5e                   	pop    %esi
801041c2:	5d                   	pop    %ebp
801041c3:	c3                   	ret    

801041c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	56                   	push   %esi
801041c8:	53                   	push   %ebx
801041c9:	8b 45 08             	mov    0x8(%ebp),%eax
801041cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801041cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
801041d2:	85 c9                	test   %ecx,%ecx
801041d4:	7e 1d                	jle    801041f3 <safestrcpy+0x2f>
801041d6:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801041da:	89 c1                	mov    %eax,%ecx
801041dc:	eb 0e                	jmp    801041ec <safestrcpy+0x28>
801041de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801041e0:	42                   	inc    %edx
801041e1:	41                   	inc    %ecx
801041e2:	8a 5a ff             	mov    -0x1(%edx),%bl
801041e5:	88 59 ff             	mov    %bl,-0x1(%ecx)
801041e8:	84 db                	test   %bl,%bl
801041ea:	74 04                	je     801041f0 <safestrcpy+0x2c>
801041ec:	39 f2                	cmp    %esi,%edx
801041ee:	75 f0                	jne    801041e0 <safestrcpy+0x1c>
    ;
  *s = 0;
801041f0:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801041f3:	5b                   	pop    %ebx
801041f4:	5e                   	pop    %esi
801041f5:	5d                   	pop    %ebp
801041f6:	c3                   	ret    
801041f7:	90                   	nop

801041f8 <strlen>:

int
strlen(const char *s)
{
801041f8:	55                   	push   %ebp
801041f9:	89 e5                	mov    %esp,%ebp
801041fb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801041fe:	31 c0                	xor    %eax,%eax
80104200:	80 3a 00             	cmpb   $0x0,(%edx)
80104203:	74 0a                	je     8010420f <strlen+0x17>
80104205:	8d 76 00             	lea    0x0(%esi),%esi
80104208:	40                   	inc    %eax
80104209:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010420d:	75 f9                	jne    80104208 <strlen+0x10>
    ;
  return n;
}
8010420f:	5d                   	pop    %ebp
80104210:	c3                   	ret    

80104211 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104211:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104215:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104219:	55                   	push   %ebp
  pushl %ebx
8010421a:	53                   	push   %ebx
  pushl %esi
8010421b:	56                   	push   %esi
  pushl %edi
8010421c:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010421d:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010421f:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104221:	5f                   	pop    %edi
  popl %esi
80104222:	5e                   	pop    %esi
  popl %ebx
80104223:	5b                   	pop    %ebx
  popl %ebp
80104224:	5d                   	pop    %ebp
  ret
80104225:	c3                   	ret    
80104226:	66 90                	xchg   %ax,%ax

80104228 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104228:	55                   	push   %ebp
80104229:	89 e5                	mov    %esp,%ebp
8010422b:	53                   	push   %ebx
8010422c:	51                   	push   %ecx
8010422d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104230:	e8 2f f1 ff ff       	call   80103364 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104235:	8b 00                	mov    (%eax),%eax
80104237:	39 d8                	cmp    %ebx,%eax
80104239:	76 15                	jbe    80104250 <fetchint+0x28>
8010423b:	8d 53 04             	lea    0x4(%ebx),%edx
8010423e:	39 d0                	cmp    %edx,%eax
80104240:	72 0e                	jb     80104250 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104242:	8b 13                	mov    (%ebx),%edx
80104244:	8b 45 0c             	mov    0xc(%ebp),%eax
80104247:	89 10                	mov    %edx,(%eax)
  return 0;
80104249:	31 c0                	xor    %eax,%eax
}
8010424b:	5a                   	pop    %edx
8010424c:	5b                   	pop    %ebx
8010424d:	5d                   	pop    %ebp
8010424e:	c3                   	ret    
8010424f:	90                   	nop
    return -1;
80104250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104255:	eb f4                	jmp    8010424b <fetchint+0x23>
80104257:	90                   	nop

80104258 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104258:	55                   	push   %ebp
80104259:	89 e5                	mov    %esp,%ebp
8010425b:	53                   	push   %ebx
8010425c:	51                   	push   %ecx
8010425d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104260:	e8 ff f0 ff ff       	call   80103364 <myproc>

  if(addr >= curproc->sz)
80104265:	39 18                	cmp    %ebx,(%eax)
80104267:	76 1f                	jbe    80104288 <fetchstr+0x30>
    return -1;
  *pp = (char*)addr;
80104269:	8b 55 0c             	mov    0xc(%ebp),%edx
8010426c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010426e:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104270:	39 d3                	cmp    %edx,%ebx
80104272:	73 14                	jae    80104288 <fetchstr+0x30>
80104274:	89 d8                	mov    %ebx,%eax
80104276:	eb 05                	jmp    8010427d <fetchstr+0x25>
80104278:	40                   	inc    %eax
80104279:	39 c2                	cmp    %eax,%edx
8010427b:	76 0b                	jbe    80104288 <fetchstr+0x30>
    if(*s == 0)
8010427d:	80 38 00             	cmpb   $0x0,(%eax)
80104280:	75 f6                	jne    80104278 <fetchstr+0x20>
      return s - *pp;
80104282:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104284:	5a                   	pop    %edx
80104285:	5b                   	pop    %ebx
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
    return -1;
80104288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010428d:	5a                   	pop    %edx
8010428e:	5b                   	pop    %ebx
8010428f:	5d                   	pop    %ebp
80104290:	c3                   	ret    
80104291:	8d 76 00             	lea    0x0(%esi),%esi

80104294 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104294:	55                   	push   %ebp
80104295:	89 e5                	mov    %esp,%ebp
80104297:	56                   	push   %esi
80104298:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104299:	e8 c6 f0 ff ff       	call   80103364 <myproc>
8010429e:	8b 40 18             	mov    0x18(%eax),%eax
801042a1:	8b 40 44             	mov    0x44(%eax),%eax
801042a4:	8b 55 08             	mov    0x8(%ebp),%edx
801042a7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801042aa:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801042ad:	e8 b2 f0 ff ff       	call   80103364 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801042b2:	8b 00                	mov    (%eax),%eax
801042b4:	39 c6                	cmp    %eax,%esi
801042b6:	73 18                	jae    801042d0 <argint+0x3c>
801042b8:	8d 53 08             	lea    0x8(%ebx),%edx
801042bb:	39 d0                	cmp    %edx,%eax
801042bd:	72 11                	jb     801042d0 <argint+0x3c>
  *ip = *(int*)(addr);
801042bf:	8b 53 04             	mov    0x4(%ebx),%edx
801042c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801042c5:	89 10                	mov    %edx,(%eax)
  return 0;
801042c7:	31 c0                	xor    %eax,%eax
}
801042c9:	5b                   	pop    %ebx
801042ca:	5e                   	pop    %esi
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801042d5:	eb f2                	jmp    801042c9 <argint+0x35>
801042d7:	90                   	nop

801042d8 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801042d8:	55                   	push   %ebp
801042d9:	89 e5                	mov    %esp,%ebp
801042db:	56                   	push   %esi
801042dc:	53                   	push   %ebx
801042dd:	83 ec 10             	sub    $0x10,%esp
801042e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801042e3:	e8 7c f0 ff ff       	call   80103364 <myproc>
801042e8:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801042ea:	83 ec 08             	sub    $0x8,%esp
801042ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801042f0:	50                   	push   %eax
801042f1:	ff 75 08             	pushl  0x8(%ebp)
801042f4:	e8 9b ff ff ff       	call   80104294 <argint>
801042f9:	83 c4 10             	add    $0x10,%esp
801042fc:	85 c0                	test   %eax,%eax
801042fe:	78 24                	js     80104324 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104300:	85 db                	test   %ebx,%ebx
80104302:	78 20                	js     80104324 <argptr+0x4c>
80104304:	8b 16                	mov    (%esi),%edx
80104306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104309:	39 c2                	cmp    %eax,%edx
8010430b:	76 17                	jbe    80104324 <argptr+0x4c>
8010430d:	01 c3                	add    %eax,%ebx
8010430f:	39 da                	cmp    %ebx,%edx
80104311:	72 11                	jb     80104324 <argptr+0x4c>
    return -1;
  *pp = (char*)i;
80104313:	8b 55 0c             	mov    0xc(%ebp),%edx
80104316:	89 02                	mov    %eax,(%edx)
  return 0;
80104318:	31 c0                	xor    %eax,%eax
}
8010431a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010431d:	5b                   	pop    %ebx
8010431e:	5e                   	pop    %esi
8010431f:	5d                   	pop    %ebp
80104320:	c3                   	ret    
80104321:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104329:	eb ef                	jmp    8010431a <argptr+0x42>
8010432b:	90                   	nop

8010432c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010432c:	55                   	push   %ebp
8010432d:	89 e5                	mov    %esp,%ebp
8010432f:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104332:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104335:	50                   	push   %eax
80104336:	ff 75 08             	pushl  0x8(%ebp)
80104339:	e8 56 ff ff ff       	call   80104294 <argint>
8010433e:	83 c4 10             	add    $0x10,%esp
80104341:	85 c0                	test   %eax,%eax
80104343:	78 13                	js     80104358 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104345:	83 ec 08             	sub    $0x8,%esp
80104348:	ff 75 0c             	pushl  0xc(%ebp)
8010434b:	ff 75 f4             	pushl  -0xc(%ebp)
8010434e:	e8 05 ff ff ff       	call   80104258 <fetchstr>
80104353:	83 c4 10             	add    $0x10,%esp
}
80104356:	c9                   	leave  
80104357:	c3                   	ret    
    return -1;
80104358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010435d:	c9                   	leave  
8010435e:	c3                   	ret    
8010435f:	90                   	nop

80104360 <syscall>:
[SYS_clone]   sys_clone,
};

void
syscall(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
80104365:	e8 fa ef ff ff       	call   80103364 <myproc>
8010436a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010436c:	8b 40 18             	mov    0x18(%eax),%eax
8010436f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104372:	8d 50 ff             	lea    -0x1(%eax),%edx
80104375:	83 fa 15             	cmp    $0x15,%edx
80104378:	77 1a                	ja     80104394 <syscall+0x34>
8010437a:	8b 14 85 40 6e 10 80 	mov    -0x7fef91c0(,%eax,4),%edx
80104381:	85 d2                	test   %edx,%edx
80104383:	74 0f                	je     80104394 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104385:	ff d2                	call   *%edx
80104387:	8b 53 18             	mov    0x18(%ebx),%edx
8010438a:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010438d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104390:	c9                   	leave  
80104391:	c3                   	ret    
80104392:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104394:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104395:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104398:	50                   	push   %eax
80104399:	ff 73 10             	pushl  0x10(%ebx)
8010439c:	68 11 6e 10 80       	push   $0x80106e11
801043a1:	e8 7a c2 ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
801043a6:	8b 43 18             	mov    0x18(%ebx),%eax
801043a9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801043b0:	83 c4 10             	add    $0x10,%esp
}
801043b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b6:	c9                   	leave  
801043b7:	c3                   	ret    

801043b8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801043b8:	55                   	push   %ebp
801043b9:	89 e5                	mov    %esp,%ebp
801043bb:	57                   	push   %edi
801043bc:	56                   	push   %esi
801043bd:	53                   	push   %ebx
801043be:	83 ec 44             	sub    $0x44,%esp
801043c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801043c4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801043c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043ca:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801043cd:	8d 7d da             	lea    -0x26(%ebp),%edi
801043d0:	57                   	push   %edi
801043d1:	50                   	push   %eax
801043d2:	e8 5d d9 ff ff       	call   80101d34 <nameiparent>
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	85 c0                	test   %eax,%eax
801043dc:	0f 84 22 01 00 00    	je     80104504 <create+0x14c>
801043e2:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	50                   	push   %eax
801043e8:	e8 7b d1 ff ff       	call   80101568 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801043ed:	83 c4 0c             	add    $0xc,%esp
801043f0:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801043f3:	50                   	push   %eax
801043f4:	57                   	push   %edi
801043f5:	53                   	push   %ebx
801043f6:	e8 41 d6 ff ff       	call   80101a3c <dirlookup>
801043fb:	89 c6                	mov    %eax,%esi
801043fd:	83 c4 10             	add    $0x10,%esp
80104400:	85 c0                	test   %eax,%eax
80104402:	74 44                	je     80104448 <create+0x90>
    iunlockput(dp);
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	53                   	push   %ebx
80104408:	e8 b3 d3 ff ff       	call   801017c0 <iunlockput>
    ilock(ip);
8010440d:	89 34 24             	mov    %esi,(%esp)
80104410:	e8 53 d1 ff ff       	call   80101568 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010441d:	75 11                	jne    80104430 <create+0x78>
8010441f:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104424:	75 0a                	jne    80104430 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104426:	89 f0                	mov    %esi,%eax
80104428:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010442b:	5b                   	pop    %ebx
8010442c:	5e                   	pop    %esi
8010442d:	5f                   	pop    %edi
8010442e:	5d                   	pop    %ebp
8010442f:	c3                   	ret    
    iunlockput(ip);
80104430:	83 ec 0c             	sub    $0xc,%esp
80104433:	56                   	push   %esi
80104434:	e8 87 d3 ff ff       	call   801017c0 <iunlockput>
    return 0;
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	31 f6                	xor    %esi,%esi
}
8010443e:	89 f0                	mov    %esi,%eax
80104440:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104443:	5b                   	pop    %ebx
80104444:	5e                   	pop    %esi
80104445:	5f                   	pop    %edi
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104448:	83 ec 08             	sub    $0x8,%esp
8010444b:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
8010444f:	50                   	push   %eax
80104450:	ff 33                	pushl  (%ebx)
80104452:	e8 b9 cf ff ff       	call   80101410 <ialloc>
80104457:	89 c6                	mov    %eax,%esi
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	85 c0                	test   %eax,%eax
8010445e:	0f 84 b9 00 00 00    	je     8010451d <create+0x165>
  ilock(ip);
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	50                   	push   %eax
80104468:	e8 fb d0 ff ff       	call   80101568 <ilock>
  ip->major = major;
8010446d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104470:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104474:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104477:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
8010447b:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104481:	89 34 24             	mov    %esi,(%esp)
80104484:	e8 37 d0 ff ff       	call   801014c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104489:	83 c4 10             	add    $0x10,%esp
8010448c:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104491:	74 29                	je     801044bc <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
80104493:	50                   	push   %eax
80104494:	ff 76 04             	pushl  0x4(%esi)
80104497:	57                   	push   %edi
80104498:	53                   	push   %ebx
80104499:	e8 ce d7 ff ff       	call   80101c6c <dirlink>
8010449e:	83 c4 10             	add    $0x10,%esp
801044a1:	85 c0                	test   %eax,%eax
801044a3:	78 6b                	js     80104510 <create+0x158>
  iunlockput(dp);
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	53                   	push   %ebx
801044a9:	e8 12 d3 ff ff       	call   801017c0 <iunlockput>
  return ip;
801044ae:	83 c4 10             	add    $0x10,%esp
}
801044b1:	89 f0                	mov    %esi,%eax
801044b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044b6:	5b                   	pop    %ebx
801044b7:	5e                   	pop    %esi
801044b8:	5f                   	pop    %edi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	90                   	nop
    dp->nlink++;  // for ".."
801044bc:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	53                   	push   %ebx
801044c4:	e8 f7 cf ff ff       	call   801014c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801044c9:	83 c4 0c             	add    $0xc,%esp
801044cc:	ff 76 04             	pushl  0x4(%esi)
801044cf:	68 b8 6e 10 80       	push   $0x80106eb8
801044d4:	56                   	push   %esi
801044d5:	e8 92 d7 ff ff       	call   80101c6c <dirlink>
801044da:	83 c4 10             	add    $0x10,%esp
801044dd:	85 c0                	test   %eax,%eax
801044df:	78 16                	js     801044f7 <create+0x13f>
801044e1:	52                   	push   %edx
801044e2:	ff 73 04             	pushl  0x4(%ebx)
801044e5:	68 b7 6e 10 80       	push   $0x80106eb7
801044ea:	56                   	push   %esi
801044eb:	e8 7c d7 ff ff       	call   80101c6c <dirlink>
801044f0:	83 c4 10             	add    $0x10,%esp
801044f3:	85 c0                	test   %eax,%eax
801044f5:	79 9c                	jns    80104493 <create+0xdb>
      panic("create dots");
801044f7:	83 ec 0c             	sub    $0xc,%esp
801044fa:	68 ab 6e 10 80       	push   $0x80106eab
801044ff:	e8 3c be ff ff       	call   80100340 <panic>
    return 0;
80104504:	31 f6                	xor    %esi,%esi
}
80104506:	89 f0                	mov    %esi,%eax
80104508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450b:	5b                   	pop    %ebx
8010450c:	5e                   	pop    %esi
8010450d:	5f                   	pop    %edi
8010450e:	5d                   	pop    %ebp
8010450f:	c3                   	ret    
    panic("create: dirlink");
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	68 ba 6e 10 80       	push   $0x80106eba
80104518:	e8 23 be ff ff       	call   80100340 <panic>
    panic("create: ialloc");
8010451d:	83 ec 0c             	sub    $0xc,%esp
80104520:	68 9c 6e 10 80       	push   $0x80106e9c
80104525:	e8 16 be ff ff       	call   80100340 <panic>
8010452a:	66 90                	xchg   %ax,%ax

8010452c <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
8010452c:	55                   	push   %ebp
8010452d:	89 e5                	mov    %esp,%ebp
8010452f:	56                   	push   %esi
80104530:	53                   	push   %ebx
80104531:	83 ec 18             	sub    $0x18,%esp
80104534:	89 c3                	mov    %eax,%ebx
80104536:	89 d6                	mov    %edx,%esi
  if(argint(n, &fd) < 0)
80104538:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010453b:	50                   	push   %eax
8010453c:	6a 00                	push   $0x0
8010453e:	e8 51 fd ff ff       	call   80104294 <argint>
80104543:	83 c4 10             	add    $0x10,%esp
80104546:	85 c0                	test   %eax,%eax
80104548:	78 2a                	js     80104574 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010454a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010454e:	77 24                	ja     80104574 <argfd.constprop.0+0x48>
80104550:	e8 0f ee ff ff       	call   80103364 <myproc>
80104555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104558:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010455c:	85 c0                	test   %eax,%eax
8010455e:	74 14                	je     80104574 <argfd.constprop.0+0x48>
  if(pfd)
80104560:	85 db                	test   %ebx,%ebx
80104562:	74 02                	je     80104566 <argfd.constprop.0+0x3a>
    *pfd = fd;
80104564:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104566:	89 06                	mov    %eax,(%esi)
  return 0;
80104568:	31 c0                	xor    %eax,%eax
}
8010456a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456d:	5b                   	pop    %ebx
8010456e:	5e                   	pop    %esi
8010456f:	5d                   	pop    %ebp
80104570:	c3                   	ret    
80104571:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104579:	eb ef                	jmp    8010456a <argfd.constprop.0+0x3e>
8010457b:	90                   	nop

8010457c <sys_dup>:
{
8010457c:	55                   	push   %ebp
8010457d:	89 e5                	mov    %esp,%ebp
8010457f:	56                   	push   %esi
80104580:	53                   	push   %ebx
80104581:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104584:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104587:	31 c0                	xor    %eax,%eax
80104589:	e8 9e ff ff ff       	call   8010452c <argfd.constprop.0>
8010458e:	85 c0                	test   %eax,%eax
80104590:	78 18                	js     801045aa <sys_dup+0x2e>
  if((fd=fdalloc(f)) < 0)
80104592:	8b 75 f4             	mov    -0xc(%ebp),%esi
  struct proc *curproc = myproc();
80104595:	e8 ca ed ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010459a:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
8010459c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801045a0:	85 d2                	test   %edx,%edx
801045a2:	74 14                	je     801045b8 <sys_dup+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
801045a4:	43                   	inc    %ebx
801045a5:	83 fb 10             	cmp    $0x10,%ebx
801045a8:	75 f2                	jne    8010459c <sys_dup+0x20>
    return -1;
801045aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801045af:	89 d8                	mov    %ebx,%eax
801045b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b4:	5b                   	pop    %ebx
801045b5:	5e                   	pop    %esi
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
      curproc->ofile[fd] = f;
801045b8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	ff 75 f4             	pushl  -0xc(%ebp)
801045c2:	e8 91 c7 ff ff       	call   80100d58 <filedup>
  return fd;
801045c7:	83 c4 10             	add    $0x10,%esp
}
801045ca:	89 d8                	mov    %ebx,%eax
801045cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045cf:	5b                   	pop    %ebx
801045d0:	5e                   	pop    %esi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret    
801045d3:	90                   	nop

801045d4 <sys_read>:
{
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801045da:	8d 55 ec             	lea    -0x14(%ebp),%edx
801045dd:	31 c0                	xor    %eax,%eax
801045df:	e8 48 ff ff ff       	call   8010452c <argfd.constprop.0>
801045e4:	85 c0                	test   %eax,%eax
801045e6:	78 40                	js     80104628 <sys_read+0x54>
801045e8:	83 ec 08             	sub    $0x8,%esp
801045eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045ee:	50                   	push   %eax
801045ef:	6a 02                	push   $0x2
801045f1:	e8 9e fc ff ff       	call   80104294 <argint>
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	85 c0                	test   %eax,%eax
801045fb:	78 2b                	js     80104628 <sys_read+0x54>
801045fd:	52                   	push   %edx
801045fe:	ff 75 f0             	pushl  -0x10(%ebp)
80104601:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104604:	50                   	push   %eax
80104605:	6a 01                	push   $0x1
80104607:	e8 cc fc ff ff       	call   801042d8 <argptr>
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	78 15                	js     80104628 <sys_read+0x54>
  return fileread(f, p, n);
80104613:	50                   	push   %eax
80104614:	ff 75 f0             	pushl  -0x10(%ebp)
80104617:	ff 75 f4             	pushl  -0xc(%ebp)
8010461a:	ff 75 ec             	pushl  -0x14(%ebp)
8010461d:	e8 7e c8 ff ff       	call   80100ea0 <fileread>
80104622:	83 c4 10             	add    $0x10,%esp
}
80104625:	c9                   	leave  
80104626:	c3                   	ret    
80104627:	90                   	nop
    return -1;
80104628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010462d:	c9                   	leave  
8010462e:	c3                   	ret    
8010462f:	90                   	nop

80104630 <sys_write>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104636:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104639:	31 c0                	xor    %eax,%eax
8010463b:	e8 ec fe ff ff       	call   8010452c <argfd.constprop.0>
80104640:	85 c0                	test   %eax,%eax
80104642:	78 40                	js     80104684 <sys_write+0x54>
80104644:	83 ec 08             	sub    $0x8,%esp
80104647:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010464a:	50                   	push   %eax
8010464b:	6a 02                	push   $0x2
8010464d:	e8 42 fc ff ff       	call   80104294 <argint>
80104652:	83 c4 10             	add    $0x10,%esp
80104655:	85 c0                	test   %eax,%eax
80104657:	78 2b                	js     80104684 <sys_write+0x54>
80104659:	52                   	push   %edx
8010465a:	ff 75 f0             	pushl  -0x10(%ebp)
8010465d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104660:	50                   	push   %eax
80104661:	6a 01                	push   $0x1
80104663:	e8 70 fc ff ff       	call   801042d8 <argptr>
80104668:	83 c4 10             	add    $0x10,%esp
8010466b:	85 c0                	test   %eax,%eax
8010466d:	78 15                	js     80104684 <sys_write+0x54>
  return filewrite(f, p, n);
8010466f:	50                   	push   %eax
80104670:	ff 75 f0             	pushl  -0x10(%ebp)
80104673:	ff 75 f4             	pushl  -0xc(%ebp)
80104676:	ff 75 ec             	pushl  -0x14(%ebp)
80104679:	e8 ae c8 ff ff       	call   80100f2c <filewrite>
8010467e:	83 c4 10             	add    $0x10,%esp
}
80104681:	c9                   	leave  
80104682:	c3                   	ret    
80104683:	90                   	nop
    return -1;
80104684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104689:	c9                   	leave  
8010468a:	c3                   	ret    
8010468b:	90                   	nop

8010468c <sys_close>:
{
8010468c:	55                   	push   %ebp
8010468d:	89 e5                	mov    %esp,%ebp
8010468f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104692:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104695:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104698:	e8 8f fe ff ff       	call   8010452c <argfd.constprop.0>
8010469d:	85 c0                	test   %eax,%eax
8010469f:	78 23                	js     801046c4 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801046a1:	e8 be ec ff ff       	call   80103364 <myproc>
801046a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046a9:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801046b0:	00 
  fileclose(f);
801046b1:	83 ec 0c             	sub    $0xc,%esp
801046b4:	ff 75 f4             	pushl  -0xc(%ebp)
801046b7:	e8 e0 c6 ff ff       	call   80100d9c <fileclose>
  return 0;
801046bc:	83 c4 10             	add    $0x10,%esp
801046bf:	31 c0                	xor    %eax,%eax
}
801046c1:	c9                   	leave  
801046c2:	c3                   	ret    
801046c3:	90                   	nop
    return -1;
801046c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046c9:	c9                   	leave  
801046ca:	c3                   	ret    
801046cb:	90                   	nop

801046cc <sys_fstat>:
{
801046cc:	55                   	push   %ebp
801046cd:	89 e5                	mov    %esp,%ebp
801046cf:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801046d2:	8d 55 f0             	lea    -0x10(%ebp),%edx
801046d5:	31 c0                	xor    %eax,%eax
801046d7:	e8 50 fe ff ff       	call   8010452c <argfd.constprop.0>
801046dc:	85 c0                	test   %eax,%eax
801046de:	78 28                	js     80104708 <sys_fstat+0x3c>
801046e0:	50                   	push   %eax
801046e1:	6a 14                	push   $0x14
801046e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046e6:	50                   	push   %eax
801046e7:	6a 01                	push   $0x1
801046e9:	e8 ea fb ff ff       	call   801042d8 <argptr>
801046ee:	83 c4 10             	add    $0x10,%esp
801046f1:	85 c0                	test   %eax,%eax
801046f3:	78 13                	js     80104708 <sys_fstat+0x3c>
  return filestat(f, st);
801046f5:	83 ec 08             	sub    $0x8,%esp
801046f8:	ff 75 f4             	pushl  -0xc(%ebp)
801046fb:	ff 75 f0             	pushl  -0x10(%ebp)
801046fe:	e8 59 c7 ff ff       	call   80100e5c <filestat>
80104703:	83 c4 10             	add    $0x10,%esp
}
80104706:	c9                   	leave  
80104707:	c3                   	ret    
    return -1;
80104708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010470d:	c9                   	leave  
8010470e:	c3                   	ret    
8010470f:	90                   	nop

80104710 <sys_link>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104719:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010471c:	50                   	push   %eax
8010471d:	6a 00                	push   $0x0
8010471f:	e8 08 fc ff ff       	call   8010432c <argstr>
80104724:	83 c4 10             	add    $0x10,%esp
80104727:	85 c0                	test   %eax,%eax
80104729:	0f 88 f2 00 00 00    	js     80104821 <sys_link+0x111>
8010472f:	83 ec 08             	sub    $0x8,%esp
80104732:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104735:	50                   	push   %eax
80104736:	6a 01                	push   $0x1
80104738:	e8 ef fb ff ff       	call   8010432c <argstr>
8010473d:	83 c4 10             	add    $0x10,%esp
80104740:	85 c0                	test   %eax,%eax
80104742:	0f 88 d9 00 00 00    	js     80104821 <sys_link+0x111>
  begin_op();
80104748:	e8 fb e0 ff ff       	call   80102848 <begin_op>
  if((ip = namei(old)) == 0){
8010474d:	83 ec 0c             	sub    $0xc,%esp
80104750:	ff 75 d4             	pushl  -0x2c(%ebp)
80104753:	e8 c4 d5 ff ff       	call   80101d1c <namei>
80104758:	89 c3                	mov    %eax,%ebx
8010475a:	83 c4 10             	add    $0x10,%esp
8010475d:	85 c0                	test   %eax,%eax
8010475f:	0f 84 db 00 00 00    	je     80104840 <sys_link+0x130>
  ilock(ip);
80104765:	83 ec 0c             	sub    $0xc,%esp
80104768:	50                   	push   %eax
80104769:	e8 fa cd ff ff       	call   80101568 <ilock>
  if(ip->type == T_DIR){
8010476e:	83 c4 10             	add    $0x10,%esp
80104771:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104776:	0f 84 ac 00 00 00    	je     80104828 <sys_link+0x118>
  ip->nlink++;
8010477c:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104780:	83 ec 0c             	sub    $0xc,%esp
80104783:	53                   	push   %ebx
80104784:	e8 37 cd ff ff       	call   801014c0 <iupdate>
  iunlock(ip);
80104789:	89 1c 24             	mov    %ebx,(%esp)
8010478c:	e8 9f ce ff ff       	call   80101630 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104791:	5a                   	pop    %edx
80104792:	59                   	pop    %ecx
80104793:	8d 7d da             	lea    -0x26(%ebp),%edi
80104796:	57                   	push   %edi
80104797:	ff 75 d0             	pushl  -0x30(%ebp)
8010479a:	e8 95 d5 ff ff       	call   80101d34 <nameiparent>
8010479f:	89 c6                	mov    %eax,%esi
801047a1:	83 c4 10             	add    $0x10,%esp
801047a4:	85 c0                	test   %eax,%eax
801047a6:	74 54                	je     801047fc <sys_link+0xec>
  ilock(dp);
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	50                   	push   %eax
801047ac:	e8 b7 cd ff ff       	call   80101568 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801047b1:	83 c4 10             	add    $0x10,%esp
801047b4:	8b 03                	mov    (%ebx),%eax
801047b6:	39 06                	cmp    %eax,(%esi)
801047b8:	75 36                	jne    801047f0 <sys_link+0xe0>
801047ba:	50                   	push   %eax
801047bb:	ff 73 04             	pushl  0x4(%ebx)
801047be:	57                   	push   %edi
801047bf:	56                   	push   %esi
801047c0:	e8 a7 d4 ff ff       	call   80101c6c <dirlink>
801047c5:	83 c4 10             	add    $0x10,%esp
801047c8:	85 c0                	test   %eax,%eax
801047ca:	78 24                	js     801047f0 <sys_link+0xe0>
  iunlockput(dp);
801047cc:	83 ec 0c             	sub    $0xc,%esp
801047cf:	56                   	push   %esi
801047d0:	e8 eb cf ff ff       	call   801017c0 <iunlockput>
  iput(ip);
801047d5:	89 1c 24             	mov    %ebx,(%esp)
801047d8:	e8 97 ce ff ff       	call   80101674 <iput>
  end_op();
801047dd:	e8 ce e0 ff ff       	call   801028b0 <end_op>
  return 0;
801047e2:	83 c4 10             	add    $0x10,%esp
801047e5:	31 c0                	xor    %eax,%eax
}
801047e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ea:	5b                   	pop    %ebx
801047eb:	5e                   	pop    %esi
801047ec:	5f                   	pop    %edi
801047ed:	5d                   	pop    %ebp
801047ee:	c3                   	ret    
801047ef:	90                   	nop
    iunlockput(dp);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	56                   	push   %esi
801047f4:	e8 c7 cf ff ff       	call   801017c0 <iunlockput>
    goto bad;
801047f9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801047fc:	83 ec 0c             	sub    $0xc,%esp
801047ff:	53                   	push   %ebx
80104800:	e8 63 cd ff ff       	call   80101568 <ilock>
  ip->nlink--;
80104805:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104809:	89 1c 24             	mov    %ebx,(%esp)
8010480c:	e8 af cc ff ff       	call   801014c0 <iupdate>
  iunlockput(ip);
80104811:	89 1c 24             	mov    %ebx,(%esp)
80104814:	e8 a7 cf ff ff       	call   801017c0 <iunlockput>
  end_op();
80104819:	e8 92 e0 ff ff       	call   801028b0 <end_op>
  return -1;
8010481e:	83 c4 10             	add    $0x10,%esp
80104821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104826:	eb bf                	jmp    801047e7 <sys_link+0xd7>
    iunlockput(ip);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	53                   	push   %ebx
8010482c:	e8 8f cf ff ff       	call   801017c0 <iunlockput>
    end_op();
80104831:	e8 7a e0 ff ff       	call   801028b0 <end_op>
    return -1;
80104836:	83 c4 10             	add    $0x10,%esp
80104839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010483e:	eb a7                	jmp    801047e7 <sys_link+0xd7>
    end_op();
80104840:	e8 6b e0 ff ff       	call   801028b0 <end_op>
    return -1;
80104845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484a:	eb 9b                	jmp    801047e7 <sys_link+0xd7>

8010484c <sys_unlink>:
{
8010484c:	55                   	push   %ebp
8010484d:	89 e5                	mov    %esp,%ebp
8010484f:	57                   	push   %edi
80104850:	56                   	push   %esi
80104851:	53                   	push   %ebx
80104852:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104855:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104858:	50                   	push   %eax
80104859:	6a 00                	push   $0x0
8010485b:	e8 cc fa ff ff       	call   8010432c <argstr>
80104860:	83 c4 10             	add    $0x10,%esp
80104863:	85 c0                	test   %eax,%eax
80104865:	0f 88 69 01 00 00    	js     801049d4 <sys_unlink+0x188>
  begin_op();
8010486b:	e8 d8 df ff ff       	call   80102848 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104876:	53                   	push   %ebx
80104877:	ff 75 c0             	pushl  -0x40(%ebp)
8010487a:	e8 b5 d4 ff ff       	call   80101d34 <nameiparent>
8010487f:	89 c6                	mov    %eax,%esi
80104881:	83 c4 10             	add    $0x10,%esp
80104884:	85 c0                	test   %eax,%eax
80104886:	0f 84 52 01 00 00    	je     801049de <sys_unlink+0x192>
  ilock(dp);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	50                   	push   %eax
80104890:	e8 d3 cc ff ff       	call   80101568 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104895:	59                   	pop    %ecx
80104896:	5f                   	pop    %edi
80104897:	68 b8 6e 10 80       	push   $0x80106eb8
8010489c:	53                   	push   %ebx
8010489d:	e8 82 d1 ff ff       	call   80101a24 <namecmp>
801048a2:	83 c4 10             	add    $0x10,%esp
801048a5:	85 c0                	test   %eax,%eax
801048a7:	0f 84 f7 00 00 00    	je     801049a4 <sys_unlink+0x158>
801048ad:	83 ec 08             	sub    $0x8,%esp
801048b0:	68 b7 6e 10 80       	push   $0x80106eb7
801048b5:	53                   	push   %ebx
801048b6:	e8 69 d1 ff ff       	call   80101a24 <namecmp>
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	85 c0                	test   %eax,%eax
801048c0:	0f 84 de 00 00 00    	je     801049a4 <sys_unlink+0x158>
  if((ip = dirlookup(dp, name, &off)) == 0)
801048c6:	52                   	push   %edx
801048c7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801048ca:	50                   	push   %eax
801048cb:	53                   	push   %ebx
801048cc:	56                   	push   %esi
801048cd:	e8 6a d1 ff ff       	call   80101a3c <dirlookup>
801048d2:	89 c3                	mov    %eax,%ebx
801048d4:	83 c4 10             	add    $0x10,%esp
801048d7:	85 c0                	test   %eax,%eax
801048d9:	0f 84 c5 00 00 00    	je     801049a4 <sys_unlink+0x158>
  ilock(ip);
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	50                   	push   %eax
801048e3:	e8 80 cc ff ff       	call   80101568 <ilock>
  if(ip->nlink < 1)
801048e8:	83 c4 10             	add    $0x10,%esp
801048eb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801048f0:	0f 8e 11 01 00 00    	jle    80104a07 <sys_unlink+0x1bb>
  if(ip->type == T_DIR && !isdirempty(ip)){
801048f6:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801048fb:	74 63                	je     80104960 <sys_unlink+0x114>
801048fd:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104900:	50                   	push   %eax
80104901:	6a 10                	push   $0x10
80104903:	6a 00                	push   $0x0
80104905:	57                   	push   %edi
80104906:	e8 65 f7 ff ff       	call   80104070 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010490b:	6a 10                	push   $0x10
8010490d:	ff 75 c4             	pushl  -0x3c(%ebp)
80104910:	57                   	push   %edi
80104911:	56                   	push   %esi
80104912:	e8 ed cf ff ff       	call   80101904 <writei>
80104917:	83 c4 20             	add    $0x20,%esp
8010491a:	83 f8 10             	cmp    $0x10,%eax
8010491d:	0f 85 d7 00 00 00    	jne    801049fa <sys_unlink+0x1ae>
  if(ip->type == T_DIR){
80104923:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104928:	0f 84 8e 00 00 00    	je     801049bc <sys_unlink+0x170>
  iunlockput(dp);
8010492e:	83 ec 0c             	sub    $0xc,%esp
80104931:	56                   	push   %esi
80104932:	e8 89 ce ff ff       	call   801017c0 <iunlockput>
  ip->nlink--;
80104937:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
8010493b:	89 1c 24             	mov    %ebx,(%esp)
8010493e:	e8 7d cb ff ff       	call   801014c0 <iupdate>
  iunlockput(ip);
80104943:	89 1c 24             	mov    %ebx,(%esp)
80104946:	e8 75 ce ff ff       	call   801017c0 <iunlockput>
  end_op();
8010494b:	e8 60 df ff ff       	call   801028b0 <end_op>
  return 0;
80104950:	83 c4 10             	add    $0x10,%esp
80104953:	31 c0                	xor    %eax,%eax
}
80104955:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104958:	5b                   	pop    %ebx
80104959:	5e                   	pop    %esi
8010495a:	5f                   	pop    %edi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104960:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104964:	76 97                	jbe    801048fd <sys_unlink+0xb1>
80104966:	ba 20 00 00 00       	mov    $0x20,%edx
8010496b:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010496e:	eb 08                	jmp    80104978 <sys_unlink+0x12c>
80104970:	83 c2 10             	add    $0x10,%edx
80104973:	39 53 58             	cmp    %edx,0x58(%ebx)
80104976:	76 88                	jbe    80104900 <sys_unlink+0xb4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104978:	6a 10                	push   $0x10
8010497a:	52                   	push   %edx
8010497b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
8010497e:	57                   	push   %edi
8010497f:	53                   	push   %ebx
80104980:	e8 87 ce ff ff       	call   8010180c <readi>
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	83 f8 10             	cmp    $0x10,%eax
8010498b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010498e:	75 5d                	jne    801049ed <sys_unlink+0x1a1>
    if(de.inum != 0)
80104990:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104995:	74 d9                	je     80104970 <sys_unlink+0x124>
    iunlockput(ip);
80104997:	83 ec 0c             	sub    $0xc,%esp
8010499a:	53                   	push   %ebx
8010499b:	e8 20 ce ff ff       	call   801017c0 <iunlockput>
    goto bad;
801049a0:	83 c4 10             	add    $0x10,%esp
801049a3:	90                   	nop
  iunlockput(dp);
801049a4:	83 ec 0c             	sub    $0xc,%esp
801049a7:	56                   	push   %esi
801049a8:	e8 13 ce ff ff       	call   801017c0 <iunlockput>
  end_op();
801049ad:	e8 fe de ff ff       	call   801028b0 <end_op>
  return -1;
801049b2:	83 c4 10             	add    $0x10,%esp
801049b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ba:	eb 99                	jmp    80104955 <sys_unlink+0x109>
    dp->nlink--;
801049bc:	66 ff 4e 56          	decw   0x56(%esi)
    iupdate(dp);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	56                   	push   %esi
801049c4:	e8 f7 ca ff ff       	call   801014c0 <iupdate>
801049c9:	83 c4 10             	add    $0x10,%esp
801049cc:	e9 5d ff ff ff       	jmp    8010492e <sys_unlink+0xe2>
801049d1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d9:	e9 77 ff ff ff       	jmp    80104955 <sys_unlink+0x109>
    end_op();
801049de:	e8 cd de ff ff       	call   801028b0 <end_op>
    return -1;
801049e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e8:	e9 68 ff ff ff       	jmp    80104955 <sys_unlink+0x109>
      panic("isdirempty: readi");
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	68 dc 6e 10 80       	push   $0x80106edc
801049f5:	e8 46 b9 ff ff       	call   80100340 <panic>
    panic("unlink: writei");
801049fa:	83 ec 0c             	sub    $0xc,%esp
801049fd:	68 ee 6e 10 80       	push   $0x80106eee
80104a02:	e8 39 b9 ff ff       	call   80100340 <panic>
    panic("unlink: nlink < 1");
80104a07:	83 ec 0c             	sub    $0xc,%esp
80104a0a:	68 ca 6e 10 80       	push   $0x80106eca
80104a0f:	e8 2c b9 ff ff       	call   80100340 <panic>

80104a14 <sys_open>:

int
sys_open(void)
{
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	56                   	push   %esi
80104a18:	53                   	push   %ebx
80104a19:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104a1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a1f:	50                   	push   %eax
80104a20:	6a 00                	push   $0x0
80104a22:	e8 05 f9 ff ff       	call   8010432c <argstr>
80104a27:	83 c4 10             	add    $0x10,%esp
80104a2a:	85 c0                	test   %eax,%eax
80104a2c:	0f 88 8d 00 00 00    	js     80104abf <sys_open+0xab>
80104a32:	83 ec 08             	sub    $0x8,%esp
80104a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a38:	50                   	push   %eax
80104a39:	6a 01                	push   $0x1
80104a3b:	e8 54 f8 ff ff       	call   80104294 <argint>
80104a40:	83 c4 10             	add    $0x10,%esp
80104a43:	85 c0                	test   %eax,%eax
80104a45:	78 78                	js     80104abf <sys_open+0xab>
    return -1;

  begin_op();
80104a47:	e8 fc dd ff ff       	call   80102848 <begin_op>

  if(omode & O_CREATE){
80104a4c:	f6 45 f5 02          	testb  $0x2,-0xb(%ebp)
80104a50:	75 76                	jne    80104ac8 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	ff 75 f0             	pushl  -0x10(%ebp)
80104a58:	e8 bf d2 ff ff       	call   80101d1c <namei>
80104a5d:	89 c3                	mov    %eax,%ebx
80104a5f:	83 c4 10             	add    $0x10,%esp
80104a62:	85 c0                	test   %eax,%eax
80104a64:	74 7f                	je     80104ae5 <sys_open+0xd1>
      end_op();
      return -1;
    }
    ilock(ip);
80104a66:	83 ec 0c             	sub    $0xc,%esp
80104a69:	50                   	push   %eax
80104a6a:	e8 f9 ca ff ff       	call   80101568 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a77:	0f 84 bf 00 00 00    	je     80104b3c <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104a7d:	e8 76 c2 ff ff       	call   80100cf8 <filealloc>
80104a82:	89 c6                	mov    %eax,%esi
80104a84:	85 c0                	test   %eax,%eax
80104a86:	74 26                	je     80104aae <sys_open+0x9a>
  struct proc *curproc = myproc();
80104a88:	e8 d7 e8 ff ff       	call   80103364 <myproc>
80104a8d:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80104a8f:	31 c0                	xor    %eax,%eax
80104a91:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104a94:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80104a98:	85 c9                	test   %ecx,%ecx
80104a9a:	74 58                	je     80104af4 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80104a9c:	40                   	inc    %eax
80104a9d:	83 f8 10             	cmp    $0x10,%eax
80104aa0:	75 f2                	jne    80104a94 <sys_open+0x80>
    if(f)
      fileclose(f);
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	56                   	push   %esi
80104aa6:	e8 f1 c2 ff ff       	call   80100d9c <fileclose>
80104aab:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	53                   	push   %ebx
80104ab2:	e8 09 cd ff ff       	call   801017c0 <iunlockput>
    end_op();
80104ab7:	e8 f4 dd ff ff       	call   801028b0 <end_op>
    return -1;
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac4:	eb 6d                	jmp    80104b33 <sys_open+0x11f>
80104ac6:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104ac8:	83 ec 0c             	sub    $0xc,%esp
80104acb:	6a 00                	push   $0x0
80104acd:	31 c9                	xor    %ecx,%ecx
80104acf:	ba 02 00 00 00       	mov    $0x2,%edx
80104ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad7:	e8 dc f8 ff ff       	call   801043b8 <create>
80104adc:	89 c3                	mov    %eax,%ebx
    if(ip == 0){
80104ade:	83 c4 10             	add    $0x10,%esp
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	75 98                	jne    80104a7d <sys_open+0x69>
      end_op();
80104ae5:	e8 c6 dd ff ff       	call   801028b0 <end_op>
      return -1;
80104aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aef:	eb 42                	jmp    80104b33 <sys_open+0x11f>
80104af1:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104af4:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
80104af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  iunlock(ip);
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	53                   	push   %ebx
80104aff:	e8 2c cb ff ff       	call   80101630 <iunlock>
  end_op();
80104b04:	e8 a7 dd ff ff       	call   801028b0 <end_op>

  f->type = FD_INODE;
80104b09:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
80104b0f:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
80104b12:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104b19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104b1c:	89 ca                	mov    %ecx,%edx
80104b1e:	f7 d2                	not    %edx
80104b20:	83 e2 01             	and    $0x1,%edx
80104b23:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104b26:	83 c4 10             	add    $0x10,%esp
80104b29:	83 e1 03             	and    $0x3,%ecx
80104b2c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
80104b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80104b33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b36:	5b                   	pop    %ebx
80104b37:	5e                   	pop    %esi
80104b38:	5d                   	pop    %ebp
80104b39:	c3                   	ret    
80104b3a:	66 90                	xchg   %ax,%ax
    if(ip->type == T_DIR && omode != O_RDONLY){
80104b3c:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104b3f:	85 f6                	test   %esi,%esi
80104b41:	0f 84 36 ff ff ff    	je     80104a7d <sys_open+0x69>
80104b47:	e9 62 ff ff ff       	jmp    80104aae <sys_open+0x9a>

80104b4c <sys_mkdir>:

int
sys_mkdir(void)
{
80104b4c:	55                   	push   %ebp
80104b4d:	89 e5                	mov    %esp,%ebp
80104b4f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104b52:	e8 f1 dc ff ff       	call   80102848 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104b57:	83 ec 08             	sub    $0x8,%esp
80104b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5d:	50                   	push   %eax
80104b5e:	6a 00                	push   $0x0
80104b60:	e8 c7 f7 ff ff       	call   8010432c <argstr>
80104b65:	83 c4 10             	add    $0x10,%esp
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	78 30                	js     80104b9c <sys_mkdir+0x50>
80104b6c:	83 ec 0c             	sub    $0xc,%esp
80104b6f:	6a 00                	push   $0x0
80104b71:	31 c9                	xor    %ecx,%ecx
80104b73:	ba 01 00 00 00       	mov    $0x1,%edx
80104b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7b:	e8 38 f8 ff ff       	call   801043b8 <create>
80104b80:	83 c4 10             	add    $0x10,%esp
80104b83:	85 c0                	test   %eax,%eax
80104b85:	74 15                	je     80104b9c <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104b87:	83 ec 0c             	sub    $0xc,%esp
80104b8a:	50                   	push   %eax
80104b8b:	e8 30 cc ff ff       	call   801017c0 <iunlockput>
  end_op();
80104b90:	e8 1b dd ff ff       	call   801028b0 <end_op>
  return 0;
80104b95:	83 c4 10             	add    $0x10,%esp
80104b98:	31 c0                	xor    %eax,%eax
}
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    
    end_op();
80104b9c:	e8 0f dd ff ff       	call   801028b0 <end_op>
    return -1;
80104ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ba6:	c9                   	leave  
80104ba7:	c3                   	ret    

80104ba8 <sys_mknod>:

int
sys_mknod(void)
{
80104ba8:	55                   	push   %ebp
80104ba9:	89 e5                	mov    %esp,%ebp
80104bab:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104bae:	e8 95 dc ff ff       	call   80102848 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104bb3:	83 ec 08             	sub    $0x8,%esp
80104bb6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104bb9:	50                   	push   %eax
80104bba:	6a 00                	push   $0x0
80104bbc:	e8 6b f7 ff ff       	call   8010432c <argstr>
80104bc1:	83 c4 10             	add    $0x10,%esp
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	78 60                	js     80104c28 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104bc8:	83 ec 08             	sub    $0x8,%esp
80104bcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bce:	50                   	push   %eax
80104bcf:	6a 01                	push   $0x1
80104bd1:	e8 be f6 ff ff       	call   80104294 <argint>
  if((argstr(0, &path)) < 0 ||
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	78 4b                	js     80104c28 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104bdd:	83 ec 08             	sub    $0x8,%esp
80104be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104be3:	50                   	push   %eax
80104be4:	6a 02                	push   $0x2
80104be6:	e8 a9 f6 ff ff       	call   80104294 <argint>
     argint(1, &major) < 0 ||
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	85 c0                	test   %eax,%eax
80104bf0:	78 36                	js     80104c28 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104bf2:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104bf6:	83 ec 0c             	sub    $0xc,%esp
80104bf9:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104bfd:	50                   	push   %eax
80104bfe:	ba 03 00 00 00       	mov    $0x3,%edx
80104c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c06:	e8 ad f7 ff ff       	call   801043b8 <create>
     argint(2, &minor) < 0 ||
80104c0b:	83 c4 10             	add    $0x10,%esp
80104c0e:	85 c0                	test   %eax,%eax
80104c10:	74 16                	je     80104c28 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	50                   	push   %eax
80104c16:	e8 a5 cb ff ff       	call   801017c0 <iunlockput>
  end_op();
80104c1b:	e8 90 dc ff ff       	call   801028b0 <end_op>
  return 0;
80104c20:	83 c4 10             	add    $0x10,%esp
80104c23:	31 c0                	xor    %eax,%eax
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	90                   	nop
    end_op();
80104c28:	e8 83 dc ff ff       	call   801028b0 <end_op>
    return -1;
80104c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    

80104c34 <sys_chdir>:

int
sys_chdir(void)
{
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
80104c39:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104c3c:	e8 23 e7 ff ff       	call   80103364 <myproc>
80104c41:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104c43:	e8 00 dc ff ff       	call   80102848 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104c48:	83 ec 08             	sub    $0x8,%esp
80104c4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c4e:	50                   	push   %eax
80104c4f:	6a 00                	push   $0x0
80104c51:	e8 d6 f6 ff ff       	call   8010432c <argstr>
80104c56:	83 c4 10             	add    $0x10,%esp
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	78 67                	js     80104cc4 <sys_chdir+0x90>
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	ff 75 f4             	pushl  -0xc(%ebp)
80104c63:	e8 b4 d0 ff ff       	call   80101d1c <namei>
80104c68:	89 c3                	mov    %eax,%ebx
80104c6a:	83 c4 10             	add    $0x10,%esp
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	74 53                	je     80104cc4 <sys_chdir+0x90>
    end_op();
    return -1;
  }
  ilock(ip);
80104c71:	83 ec 0c             	sub    $0xc,%esp
80104c74:	50                   	push   %eax
80104c75:	e8 ee c8 ff ff       	call   80101568 <ilock>
  if(ip->type != T_DIR){
80104c7a:	83 c4 10             	add    $0x10,%esp
80104c7d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c82:	75 28                	jne    80104cac <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	53                   	push   %ebx
80104c88:	e8 a3 c9 ff ff       	call   80101630 <iunlock>
  iput(curproc->cwd);
80104c8d:	58                   	pop    %eax
80104c8e:	ff 76 68             	pushl  0x68(%esi)
80104c91:	e8 de c9 ff ff       	call   80101674 <iput>
  end_op();
80104c96:	e8 15 dc ff ff       	call   801028b0 <end_op>
  curproc->cwd = ip;
80104c9b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	31 c0                	xor    %eax,%eax
}
80104ca3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca6:	5b                   	pop    %ebx
80104ca7:	5e                   	pop    %esi
80104ca8:	5d                   	pop    %ebp
80104ca9:	c3                   	ret    
80104caa:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	53                   	push   %ebx
80104cb0:	e8 0b cb ff ff       	call   801017c0 <iunlockput>
    end_op();
80104cb5:	e8 f6 db ff ff       	call   801028b0 <end_op>
    return -1;
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc2:	eb df                	jmp    80104ca3 <sys_chdir+0x6f>
    end_op();
80104cc4:	e8 e7 db ff ff       	call   801028b0 <end_op>
    return -1;
80104cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cce:	eb d3                	jmp    80104ca3 <sys_chdir+0x6f>

80104cd0 <sys_exec>:

int
sys_exec(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104cdc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104ce2:	50                   	push   %eax
80104ce3:	6a 00                	push   $0x0
80104ce5:	e8 42 f6 ff ff       	call   8010432c <argstr>
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	85 c0                	test   %eax,%eax
80104cef:	78 79                	js     80104d6a <sys_exec+0x9a>
80104cf1:	83 ec 08             	sub    $0x8,%esp
80104cf4:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104cfa:	50                   	push   %eax
80104cfb:	6a 01                	push   $0x1
80104cfd:	e8 92 f5 ff ff       	call   80104294 <argint>
80104d02:	83 c4 10             	add    $0x10,%esp
80104d05:	85 c0                	test   %eax,%eax
80104d07:	78 61                	js     80104d6a <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104d09:	50                   	push   %eax
80104d0a:	68 80 00 00 00       	push   $0x80
80104d0f:	6a 00                	push   $0x0
80104d11:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80104d17:	57                   	push   %edi
80104d18:	e8 53 f3 ff ff       	call   80104070 <memset>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
80104d22:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104d2d:	50                   	push   %eax
80104d2e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104d34:	01 d8                	add    %ebx,%eax
80104d36:	50                   	push   %eax
80104d37:	e8 ec f4 ff ff       	call   80104228 <fetchint>
80104d3c:	83 c4 10             	add    $0x10,%esp
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	78 27                	js     80104d6a <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
80104d43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104d49:	85 c0                	test   %eax,%eax
80104d4b:	74 2b                	je     80104d78 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104d4d:	83 ec 08             	sub    $0x8,%esp
80104d50:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80104d53:	52                   	push   %edx
80104d54:	50                   	push   %eax
80104d55:	e8 fe f4 ff ff       	call   80104258 <fetchstr>
80104d5a:	83 c4 10             	add    $0x10,%esp
80104d5d:	85 c0                	test   %eax,%eax
80104d5f:	78 09                	js     80104d6a <sys_exec+0x9a>
  for(i=0;; i++){
80104d61:	46                   	inc    %esi
    if(i >= NELEM(argv))
80104d62:	83 c3 04             	add    $0x4,%ebx
80104d65:	83 fe 20             	cmp    $0x20,%esi
80104d68:	75 ba                	jne    80104d24 <sys_exec+0x54>
    return -1;
80104d6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d72:	5b                   	pop    %ebx
80104d73:	5e                   	pop    %esi
80104d74:	5f                   	pop    %edi
80104d75:	5d                   	pop    %ebp
80104d76:	c3                   	ret    
80104d77:	90                   	nop
      argv[i] = 0;
80104d78:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
80104d7f:	00 00 00 00 
  return exec(path, argv);
80104d83:	83 ec 08             	sub    $0x8,%esp
80104d86:	57                   	push   %edi
80104d87:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80104d8d:	e8 12 bc ff ff       	call   801009a4 <exec>
80104d92:	83 c4 10             	add    $0x10,%esp
}
80104d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d98:	5b                   	pop    %ebx
80104d99:	5e                   	pop    %esi
80104d9a:	5f                   	pop    %edi
80104d9b:	5d                   	pop    %ebp
80104d9c:	c3                   	ret    
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi

80104da0 <sys_pipe>:

int
sys_pipe(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
80104da6:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104da9:	6a 08                	push   $0x8
80104dab:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104dae:	50                   	push   %eax
80104daf:	6a 00                	push   $0x0
80104db1:	e8 22 f5 ff ff       	call   801042d8 <argptr>
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	85 c0                	test   %eax,%eax
80104dbb:	78 48                	js     80104e05 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104dbd:	83 ec 08             	sub    $0x8,%esp
80104dc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104dc3:	50                   	push   %eax
80104dc4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dc7:	50                   	push   %eax
80104dc8:	e8 73 e0 ff ff       	call   80102e40 <pipealloc>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	78 31                	js     80104e05 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104dd4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80104dd7:	e8 88 e5 ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ddc:	31 db                	xor    %ebx,%ebx
80104dde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104de0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80104de4:	85 f6                	test   %esi,%esi
80104de6:	74 24                	je     80104e0c <sys_pipe+0x6c>
  for(fd = 0; fd < NOFILE; fd++){
80104de8:	43                   	inc    %ebx
80104de9:	83 fb 10             	cmp    $0x10,%ebx
80104dec:	75 f2                	jne    80104de0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80104dee:	83 ec 0c             	sub    $0xc,%esp
80104df1:	ff 75 e0             	pushl  -0x20(%ebp)
80104df4:	e8 a3 bf ff ff       	call   80100d9c <fileclose>
    fileclose(wf);
80104df9:	58                   	pop    %eax
80104dfa:	ff 75 e4             	pushl  -0x1c(%ebp)
80104dfd:	e8 9a bf ff ff       	call   80100d9c <fileclose>
    return -1;
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0a:	eb 45                	jmp    80104e51 <sys_pipe+0xb1>
      curproc->ofile[fd] = f;
80104e0c:	8d 73 08             	lea    0x8(%ebx),%esi
80104e0f:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104e13:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80104e16:	e8 49 e5 ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e1b:	31 d2                	xor    %edx,%edx
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104e20:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104e24:	85 c9                	test   %ecx,%ecx
80104e26:	74 18                	je     80104e40 <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
80104e28:	42                   	inc    %edx
80104e29:	83 fa 10             	cmp    $0x10,%edx
80104e2c:	75 f2                	jne    80104e20 <sys_pipe+0x80>
      myproc()->ofile[fd0] = 0;
80104e2e:	e8 31 e5 ff ff       	call   80103364 <myproc>
80104e33:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80104e3a:	00 
80104e3b:	eb b1                	jmp    80104dee <sys_pipe+0x4e>
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e40:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80104e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104e47:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80104e49:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104e4c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80104e4f:	31 c0                	xor    %eax,%eax
}
80104e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e54:	5b                   	pop    %ebx
80104e55:	5e                   	pop    %esi
80104e56:	5f                   	pop    %edi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret    
80104e59:	66 90                	xchg   %ax,%ax
80104e5b:	90                   	nop

80104e5c <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80104e5c:	e9 7b e6 ff ff       	jmp    801034dc <fork>
80104e61:	8d 76 00             	lea    0x0(%esi),%esi

80104e64 <sys_exit>:
}

int
sys_exit(void)
{
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	83 ec 08             	sub    $0x8,%esp
  exit();
80104e6a:	e8 c5 e8 ff ff       	call   80103734 <exit>
  return 0;  // not reached
}
80104e6f:	31 c0                	xor    %eax,%eax
80104e71:	c9                   	leave  
80104e72:	c3                   	ret    
80104e73:	90                   	nop

80104e74 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80104e74:	e9 db ea ff ff       	jmp    80103954 <wait>
80104e79:	8d 76 00             	lea    0x0(%esi),%esi

80104e7c <sys_kill>:
}

int
sys_kill(void)
{
80104e7c:	55                   	push   %ebp
80104e7d:	89 e5                	mov    %esp,%ebp
80104e7f:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104e82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e85:	50                   	push   %eax
80104e86:	6a 00                	push   $0x0
80104e88:	e8 07 f4 ff ff       	call   80104294 <argint>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 10                	js     80104ea4 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9a:	e8 fd eb ff ff       	call   80103a9c <kill>
80104e9f:	83 c4 10             	add    $0x10,%esp
}
80104ea2:	c9                   	leave  
80104ea3:	c3                   	ret    
    return -1;
80104ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea9:	c9                   	leave  
80104eaa:	c3                   	ret    
80104eab:	90                   	nop

80104eac <sys_getpid>:

int
sys_getpid(void)
{
80104eac:	55                   	push   %ebp
80104ead:	89 e5                	mov    %esp,%ebp
80104eaf:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104eb2:	e8 ad e4 ff ff       	call   80103364 <myproc>
80104eb7:	8b 40 10             	mov    0x10(%eax),%eax
}
80104eba:	c9                   	leave  
80104ebb:	c3                   	ret    

80104ebc <sys_sbrk>:

int
sys_sbrk(void)
{
80104ebc:	55                   	push   %ebp
80104ebd:	89 e5                	mov    %esp,%ebp
80104ebf:	53                   	push   %ebx
80104ec0:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104ec3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ec6:	50                   	push   %eax
80104ec7:	6a 00                	push   $0x0
80104ec9:	e8 c6 f3 ff ff       	call   80104294 <argint>
80104ece:	83 c4 10             	add    $0x10,%esp
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 23                	js     80104ef8 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80104ed5:	e8 8a e4 ff ff       	call   80103364 <myproc>
80104eda:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ee2:	e8 85 e5 ff ff       	call   8010346c <growproc>
80104ee7:	83 c4 10             	add    $0x10,%esp
80104eea:	85 c0                	test   %eax,%eax
80104eec:	78 0a                	js     80104ef8 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80104eee:	89 d8                	mov    %ebx,%eax
80104ef0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef3:	c9                   	leave  
80104ef4:	c3                   	ret    
80104ef5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ef8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104efd:	eb ef                	jmp    80104eee <sys_sbrk+0x32>
80104eff:	90                   	nop

80104f00 <sys_sleep>:

int
sys_sleep(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	53                   	push   %ebx
80104f04:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104f07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f0a:	50                   	push   %eax
80104f0b:	6a 00                	push   $0x0
80104f0d:	e8 82 f3 ff ff       	call   80104294 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 7e                	js     80104f97 <sys_sleep+0x97>
    return -1;
  acquire(&tickslock);
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 60 4c 11 80       	push   $0x80114c60
80104f21:	e8 6a f0 ff ff       	call   80103f90 <acquire>
  ticks0 = ticks;
80104f26:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80104f2c:	83 c4 10             	add    $0x10,%esp
80104f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f32:	85 d2                	test   %edx,%edx
80104f34:	75 23                	jne    80104f59 <sys_sleep+0x59>
80104f36:	eb 48                	jmp    80104f80 <sys_sleep+0x80>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104f38:	83 ec 08             	sub    $0x8,%esp
80104f3b:	68 60 4c 11 80       	push   $0x80114c60
80104f40:	68 a0 54 11 80       	push   $0x801154a0
80104f45:	e8 4e e9 ff ff       	call   80103898 <sleep>
  while(ticks - ticks0 < n){
80104f4a:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80104f4f:	29 d8                	sub    %ebx,%eax
80104f51:	83 c4 10             	add    $0x10,%esp
80104f54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104f57:	73 27                	jae    80104f80 <sys_sleep+0x80>
    if(myproc()->killed){
80104f59:	e8 06 e4 ff ff       	call   80103364 <myproc>
80104f5e:	8b 40 24             	mov    0x24(%eax),%eax
80104f61:	85 c0                	test   %eax,%eax
80104f63:	74 d3                	je     80104f38 <sys_sleep+0x38>
      release(&tickslock);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	68 60 4c 11 80       	push   $0x80114c60
80104f6d:	e8 b6 f0 ff ff       	call   80104028 <release>
      return -1;
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80104f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f7d:	c9                   	leave  
80104f7e:	c3                   	ret    
80104f7f:	90                   	nop
  release(&tickslock);
80104f80:	83 ec 0c             	sub    $0xc,%esp
80104f83:	68 60 4c 11 80       	push   $0x80114c60
80104f88:	e8 9b f0 ff ff       	call   80104028 <release>
  return 0;
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	31 c0                	xor    %eax,%eax
}
80104f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    
    return -1;
80104f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9c:	eb f4                	jmp    80104f92 <sys_sleep+0x92>
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	83 ec 24             	sub    $0x24,%esp
  uint xticks;

  acquire(&tickslock);
80104fa6:	68 60 4c 11 80       	push   $0x80114c60
80104fab:	e8 e0 ef ff ff       	call   80103f90 <acquire>
  xticks = ticks;
80104fb0:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80104fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80104fb8:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80104fbf:	e8 64 f0 ff ff       	call   80104028 <release>
  return xticks;
}
80104fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc7:	c9                   	leave  
80104fc8:	c3                   	ret    
80104fc9:	8d 76 00             	lea    0x0(%esi),%esi

80104fcc <sys_clone>:

int sys_clone(void) {
80104fcc:	55                   	push   %ebp
80104fcd:	89 e5                	mov    %esp,%ebp
80104fcf:	83 ec 1c             	sub    $0x1c,%esp
  void *func;
  void *stack;
  int size;
  void *arg;

  if (argptr(0, (char**)(&func), sizeof(void*)) < 0) return -1;
80104fd2:	6a 04                	push   $0x4
80104fd4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104fd7:	50                   	push   %eax
80104fd8:	6a 00                	push   $0x0
80104fda:	e8 f9 f2 ff ff       	call   801042d8 <argptr>
80104fdf:	83 c4 10             	add    $0x10,%esp
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	78 56                	js     8010503c <sys_clone+0x70>
  if (argptr(1, (char**)(&stack), sizeof(void*)) < 0) return -1;
80104fe6:	52                   	push   %edx
80104fe7:	6a 04                	push   $0x4
80104fe9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104fec:	50                   	push   %eax
80104fed:	6a 01                	push   $0x1
80104fef:	e8 e4 f2 ff ff       	call   801042d8 <argptr>
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	78 41                	js     8010503c <sys_clone+0x70>
  if (argint(2, &size) < 0) return -1;
80104ffb:	83 ec 08             	sub    $0x8,%esp
80104ffe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105001:	50                   	push   %eax
80105002:	6a 02                	push   $0x2
80105004:	e8 8b f2 ff ff       	call   80104294 <argint>
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	85 c0                	test   %eax,%eax
8010500e:	78 2c                	js     8010503c <sys_clone+0x70>
  if (argptr(3, (char**)(&arg), sizeof(void*)) < 0) return -1;
80105010:	50                   	push   %eax
80105011:	6a 04                	push   $0x4
80105013:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105016:	50                   	push   %eax
80105017:	6a 03                	push   $0x3
80105019:	e8 ba f2 ff ff       	call   801042d8 <argptr>
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	85 c0                	test   %eax,%eax
80105023:	78 17                	js     8010503c <sys_clone+0x70>

  return clone((void*)(func), (void*)stack, size, (void*)arg);
80105025:	ff 75 f4             	pushl  -0xc(%ebp)
80105028:	ff 75 f0             	pushl  -0x10(%ebp)
8010502b:	ff 75 ec             	pushl  -0x14(%ebp)
8010502e:	ff 75 e8             	pushl  -0x18(%ebp)
80105031:	e8 8a eb ff ff       	call   80103bc0 <clone>
80105036:	83 c4 10             	add    $0x10,%esp
80105039:	c9                   	leave  
8010503a:	c3                   	ret    
8010503b:	90                   	nop
  if (argptr(0, (char**)(&func), sizeof(void*)) < 0) return -1;
8010503c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105041:	c9                   	leave  
80105042:	c3                   	ret    

80105043 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105043:	1e                   	push   %ds
  pushl %es
80105044:	06                   	push   %es
  pushl %fs
80105045:	0f a0                	push   %fs
  pushl %gs
80105047:	0f a8                	push   %gs
  pushal
80105049:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010504a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010504e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105050:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105052:	54                   	push   %esp
  call trap
80105053:	e8 a0 00 00 00       	call   801050f8 <trap>
  addl $4, %esp
80105058:	83 c4 04             	add    $0x4,%esp

8010505b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010505b:	61                   	popa   
  popl %gs
8010505c:	0f a9                	pop    %gs
  popl %fs
8010505e:	0f a1                	pop    %fs
  popl %es
80105060:	07                   	pop    %es
  popl %ds
80105061:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105062:	83 c4 08             	add    $0x8,%esp
  iret
80105065:	cf                   	iret   
80105066:	66 90                	xchg   %ax,%ax

80105068 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105068:	55                   	push   %ebp
80105069:	89 e5                	mov    %esp,%ebp
8010506b:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010506e:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105070:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105077:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
8010507e:	80 
8010507f:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
80105086:	08 00 00 8e 
8010508a:	c1 ea 10             	shr    $0x10,%edx
8010508d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105094:	80 
  for(i = 0; i < 256; i++)
80105095:	40                   	inc    %eax
80105096:	3d 00 01 00 00       	cmp    $0x100,%eax
8010509b:	75 d3                	jne    80105070 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010509d:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801050a2:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801050a8:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801050af:	00 00 ef 
801050b2:	c1 e8 10             	shr    $0x10,%eax
801050b5:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
801050bb:	83 ec 08             	sub    $0x8,%esp
801050be:	68 fd 6e 10 80       	push   $0x80106efd
801050c3:	68 60 4c 11 80       	push   $0x80114c60
801050c8:	e8 83 ed ff ff       	call   80103e50 <initlock>
}
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	c9                   	leave  
801050d1:	c3                   	ret    
801050d2:	66 90                	xchg   %ax,%ax

801050d4 <idtinit>:

void
idtinit(void)
{
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801050da:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801050e0:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801050e5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801050e9:	c1 e8 10             	shr    $0x10,%eax
801050ec:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801050f0:	8d 45 fa             	lea    -0x6(%ebp),%eax
801050f3:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801050f6:	c9                   	leave  
801050f7:	c3                   	ret    

801050f8 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801050f8:	55                   	push   %ebp
801050f9:	89 e5                	mov    %esp,%ebp
801050fb:	57                   	push   %edi
801050fc:	56                   	push   %esi
801050fd:	53                   	push   %ebx
801050fe:	83 ec 1c             	sub    $0x1c,%esp
80105101:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105104:	8b 43 30             	mov    0x30(%ebx),%eax
80105107:	83 f8 40             	cmp    $0x40,%eax
8010510a:	0f 84 b4 01 00 00    	je     801052c4 <trap+0x1cc>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105110:	83 e8 20             	sub    $0x20,%eax
80105113:	83 f8 1f             	cmp    $0x1f,%eax
80105116:	77 07                	ja     8010511f <trap+0x27>
80105118:	ff 24 85 a4 6f 10 80 	jmp    *-0x7fef905c(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010511f:	e8 40 e2 ff ff       	call   80103364 <myproc>
80105124:	8b 7b 38             	mov    0x38(%ebx),%edi
80105127:	85 c0                	test   %eax,%eax
80105129:	0f 84 e0 01 00 00    	je     8010530f <trap+0x217>
8010512f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105133:	0f 84 d6 01 00 00    	je     8010530f <trap+0x217>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105139:	0f 20 d1             	mov    %cr2,%ecx
8010513c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010513f:	e8 ec e1 ff ff       	call   80103330 <cpuid>
80105144:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105147:	8b 43 34             	mov    0x34(%ebx),%eax
8010514a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010514d:	8b 73 30             	mov    0x30(%ebx),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105150:	e8 0f e2 ff ff       	call   80103364 <myproc>
80105155:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105158:	e8 07 e2 ff ff       	call   80103364 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010515d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105160:	51                   	push   %ecx
80105161:	57                   	push   %edi
80105162:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105165:	52                   	push   %edx
80105166:	ff 75 e4             	pushl  -0x1c(%ebp)
80105169:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010516a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010516d:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105170:	56                   	push   %esi
80105171:	ff 70 10             	pushl  0x10(%eax)
80105174:	68 60 6f 10 80       	push   $0x80106f60
80105179:	e8 a2 b4 ff ff       	call   80100620 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010517e:	83 c4 20             	add    $0x20,%esp
80105181:	e8 de e1 ff ff       	call   80103364 <myproc>
80105186:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010518d:	e8 d2 e1 ff ff       	call   80103364 <myproc>
80105192:	85 c0                	test   %eax,%eax
80105194:	74 1c                	je     801051b2 <trap+0xba>
80105196:	e8 c9 e1 ff ff       	call   80103364 <myproc>
8010519b:	8b 50 24             	mov    0x24(%eax),%edx
8010519e:	85 d2                	test   %edx,%edx
801051a0:	74 10                	je     801051b2 <trap+0xba>
801051a2:	8b 43 3c             	mov    0x3c(%ebx),%eax
801051a5:	83 e0 03             	and    $0x3,%eax
801051a8:	66 83 f8 03          	cmp    $0x3,%ax
801051ac:	0f 84 4a 01 00 00    	je     801052fc <trap+0x204>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801051b2:	e8 ad e1 ff ff       	call   80103364 <myproc>
801051b7:	85 c0                	test   %eax,%eax
801051b9:	74 0f                	je     801051ca <trap+0xd2>
801051bb:	e8 a4 e1 ff ff       	call   80103364 <myproc>
801051c0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801051c4:	0f 84 e6 00 00 00    	je     801052b0 <trap+0x1b8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801051ca:	e8 95 e1 ff ff       	call   80103364 <myproc>
801051cf:	85 c0                	test   %eax,%eax
801051d1:	74 1c                	je     801051ef <trap+0xf7>
801051d3:	e8 8c e1 ff ff       	call   80103364 <myproc>
801051d8:	8b 40 24             	mov    0x24(%eax),%eax
801051db:	85 c0                	test   %eax,%eax
801051dd:	74 10                	je     801051ef <trap+0xf7>
801051df:	8b 43 3c             	mov    0x3c(%ebx),%eax
801051e2:	83 e0 03             	and    $0x3,%eax
801051e5:	66 83 f8 03          	cmp    $0x3,%ax
801051e9:	0f 84 fe 00 00 00    	je     801052ed <trap+0x1f5>
    exit();
}
801051ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5f                   	pop    %edi
801051f5:	5d                   	pop    %ebp
801051f6:	c3                   	ret    
    ideintr();
801051f7:	e8 6c cc ff ff       	call   80101e68 <ideintr>
    lapiceoi();
801051fc:	e8 7b d2 ff ff       	call   8010247c <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105201:	e8 5e e1 ff ff       	call   80103364 <myproc>
80105206:	85 c0                	test   %eax,%eax
80105208:	75 8c                	jne    80105196 <trap+0x9e>
8010520a:	eb a6                	jmp    801051b2 <trap+0xba>
    if(cpuid() == 0){
8010520c:	e8 1f e1 ff ff       	call   80103330 <cpuid>
80105211:	85 c0                	test   %eax,%eax
80105213:	75 e7                	jne    801051fc <trap+0x104>
      acquire(&tickslock);
80105215:	83 ec 0c             	sub    $0xc,%esp
80105218:	68 60 4c 11 80       	push   $0x80114c60
8010521d:	e8 6e ed ff ff       	call   80103f90 <acquire>
      ticks++;
80105222:	ff 05 a0 54 11 80    	incl   0x801154a0
      wakeup(&ticks);
80105228:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010522f:	e8 10 e8 ff ff       	call   80103a44 <wakeup>
      release(&tickslock);
80105234:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010523b:	e8 e8 ed ff ff       	call   80104028 <release>
80105240:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105243:	eb b7                	jmp    801051fc <trap+0x104>
    kbdintr();
80105245:	e8 22 d1 ff ff       	call   8010236c <kbdintr>
    lapiceoi();
8010524a:	e8 2d d2 ff ff       	call   8010247c <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010524f:	e8 10 e1 ff ff       	call   80103364 <myproc>
80105254:	85 c0                	test   %eax,%eax
80105256:	0f 85 3a ff ff ff    	jne    80105196 <trap+0x9e>
8010525c:	e9 51 ff ff ff       	jmp    801051b2 <trap+0xba>
    uartintr();
80105261:	e8 fa 01 00 00       	call   80105460 <uartintr>
    lapiceoi();
80105266:	e8 11 d2 ff ff       	call   8010247c <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010526b:	e8 f4 e0 ff ff       	call   80103364 <myproc>
80105270:	85 c0                	test   %eax,%eax
80105272:	0f 85 1e ff ff ff    	jne    80105196 <trap+0x9e>
80105278:	e9 35 ff ff ff       	jmp    801051b2 <trap+0xba>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010527d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105280:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105284:	e8 a7 e0 ff ff       	call   80103330 <cpuid>
80105289:	57                   	push   %edi
8010528a:	56                   	push   %esi
8010528b:	50                   	push   %eax
8010528c:	68 08 6f 10 80       	push   $0x80106f08
80105291:	e8 8a b3 ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105296:	e8 e1 d1 ff ff       	call   8010247c <lapiceoi>
    break;
8010529b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010529e:	e8 c1 e0 ff ff       	call   80103364 <myproc>
801052a3:	85 c0                	test   %eax,%eax
801052a5:	0f 85 eb fe ff ff    	jne    80105196 <trap+0x9e>
801052ab:	e9 02 ff ff ff       	jmp    801051b2 <trap+0xba>
  if(myproc() && myproc()->state == RUNNING &&
801052b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801052b4:	0f 85 10 ff ff ff    	jne    801051ca <trap+0xd2>
    yield();
801052ba:	e8 91 e5 ff ff       	call   80103850 <yield>
801052bf:	e9 06 ff ff ff       	jmp    801051ca <trap+0xd2>
    if(myproc()->killed)
801052c4:	e8 9b e0 ff ff       	call   80103364 <myproc>
801052c9:	8b 70 24             	mov    0x24(%eax),%esi
801052cc:	85 f6                	test   %esi,%esi
801052ce:	75 38                	jne    80105308 <trap+0x210>
    myproc()->tf = tf;
801052d0:	e8 8f e0 ff ff       	call   80103364 <myproc>
801052d5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801052d8:	e8 83 f0 ff ff       	call   80104360 <syscall>
    if(myproc()->killed)
801052dd:	e8 82 e0 ff ff       	call   80103364 <myproc>
801052e2:	8b 48 24             	mov    0x24(%eax),%ecx
801052e5:	85 c9                	test   %ecx,%ecx
801052e7:	0f 84 02 ff ff ff    	je     801051ef <trap+0xf7>
}
801052ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f0:	5b                   	pop    %ebx
801052f1:	5e                   	pop    %esi
801052f2:	5f                   	pop    %edi
801052f3:	5d                   	pop    %ebp
      exit();
801052f4:	e9 3b e4 ff ff       	jmp    80103734 <exit>
801052f9:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801052fc:	e8 33 e4 ff ff       	call   80103734 <exit>
80105301:	e9 ac fe ff ff       	jmp    801051b2 <trap+0xba>
80105306:	66 90                	xchg   %ax,%ax
      exit();
80105308:	e8 27 e4 ff ff       	call   80103734 <exit>
8010530d:	eb c1                	jmp    801052d0 <trap+0x1d8>
8010530f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105312:	e8 19 e0 ff ff       	call   80103330 <cpuid>
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	56                   	push   %esi
8010531b:	57                   	push   %edi
8010531c:	50                   	push   %eax
8010531d:	ff 73 30             	pushl  0x30(%ebx)
80105320:	68 2c 6f 10 80       	push   $0x80106f2c
80105325:	e8 f6 b2 ff ff       	call   80100620 <cprintf>
      panic("trap");
8010532a:	83 c4 14             	add    $0x14,%esp
8010532d:	68 02 6f 10 80       	push   $0x80106f02
80105332:	e8 09 b0 ff ff       	call   80100340 <panic>
80105337:	90                   	nop

80105338 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105338:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
8010533d:	85 c0                	test   %eax,%eax
8010533f:	74 17                	je     80105358 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105341:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105346:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105347:	a8 01                	test   $0x1,%al
80105349:	74 0d                	je     80105358 <uartgetc+0x20>
8010534b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105350:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105351:	0f b6 c0             	movzbl %al,%eax
80105354:	c3                   	ret    
80105355:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax

80105360 <uartputc.part.0>:
uartputc(int c)
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
80105366:	83 ec 0c             	sub    $0xc,%esp
80105369:	89 c7                	mov    %eax,%edi
8010536b:	bb 80 00 00 00       	mov    $0x80,%ebx
80105370:	be fd 03 00 00       	mov    $0x3fd,%esi
80105375:	eb 11                	jmp    80105388 <uartputc.part.0+0x28>
80105377:	90                   	nop
    microdelay(10);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	6a 0a                	push   $0xa
8010537d:	e8 12 d1 ff ff       	call   80102494 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	4b                   	dec    %ebx
80105386:	74 07                	je     8010538f <uartputc.part.0+0x2f>
80105388:	89 f2                	mov    %esi,%edx
8010538a:	ec                   	in     (%dx),%al
8010538b:	a8 20                	test   $0x20,%al
8010538d:	74 e9                	je     80105378 <uartputc.part.0+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010538f:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105394:	89 f8                	mov    %edi,%eax
80105396:	ee                   	out    %al,(%dx)
}
80105397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010539a:	5b                   	pop    %ebx
8010539b:	5e                   	pop    %esi
8010539c:	5f                   	pop    %edi
8010539d:	5d                   	pop    %ebp
8010539e:	c3                   	ret    
8010539f:	90                   	nop

801053a0 <uartinit>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
801053a6:	83 ec 1c             	sub    $0x1c,%esp
801053a9:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801053ae:	31 c0                	xor    %eax,%eax
801053b0:	89 da                	mov    %ebx,%edx
801053b2:	ee                   	out    %al,(%dx)
801053b3:	bf fb 03 00 00       	mov    $0x3fb,%edi
801053b8:	b0 80                	mov    $0x80,%al
801053ba:	89 fa                	mov    %edi,%edx
801053bc:	ee                   	out    %al,(%dx)
801053bd:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
801053c2:	b0 0c                	mov    $0xc,%al
801053c4:	89 ca                	mov    %ecx,%edx
801053c6:	ee                   	out    %al,(%dx)
801053c7:	be f9 03 00 00       	mov    $0x3f9,%esi
801053cc:	31 c0                	xor    %eax,%eax
801053ce:	89 f2                	mov    %esi,%edx
801053d0:	ee                   	out    %al,(%dx)
801053d1:	b0 03                	mov    $0x3,%al
801053d3:	89 fa                	mov    %edi,%edx
801053d5:	ee                   	out    %al,(%dx)
801053d6:	ba fc 03 00 00       	mov    $0x3fc,%edx
801053db:	31 c0                	xor    %eax,%eax
801053dd:	ee                   	out    %al,(%dx)
801053de:	b0 01                	mov    $0x1,%al
801053e0:	89 f2                	mov    %esi,%edx
801053e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801053e3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801053e8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801053e9:	fe c0                	inc    %al
801053eb:	74 4f                	je     8010543c <uartinit+0x9c>
  uart = 1;
801053ed:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801053f4:	00 00 00 
801053f7:	89 da                	mov    %ebx,%edx
801053f9:	ec                   	in     (%dx),%al
801053fa:	89 ca                	mov    %ecx,%edx
801053fc:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801053fd:	83 ec 08             	sub    $0x8,%esp
80105400:	6a 00                	push   $0x0
80105402:	6a 04                	push   $0x4
80105404:	e8 73 cc ff ff       	call   8010207c <ioapicenable>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	b2 76                	mov    $0x76,%dl
  for(p="xv6...\n"; *p; p++)
8010540e:	bb 24 70 10 80       	mov    $0x80107024,%ebx
80105413:	b8 78 00 00 00       	mov    $0x78,%eax
80105418:	eb 08                	jmp    80105422 <uartinit+0x82>
8010541a:	66 90                	xchg   %ax,%ax
8010541c:	0f be c2             	movsbl %dl,%eax
8010541f:	8a 53 01             	mov    0x1(%ebx),%dl
  if(!uart)
80105422:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
80105428:	85 c9                	test   %ecx,%ecx
8010542a:	74 0b                	je     80105437 <uartinit+0x97>
8010542c:	88 55 e7             	mov    %dl,-0x19(%ebp)
8010542f:	e8 2c ff ff ff       	call   80105360 <uartputc.part.0>
80105434:	8a 55 e7             	mov    -0x19(%ebp),%dl
  for(p="xv6...\n"; *p; p++)
80105437:	43                   	inc    %ebx
80105438:	84 d2                	test   %dl,%dl
8010543a:	75 e0                	jne    8010541c <uartinit+0x7c>
}
8010543c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010543f:	5b                   	pop    %ebx
80105440:	5e                   	pop    %esi
80105441:	5f                   	pop    %edi
80105442:	5d                   	pop    %ebp
80105443:	c3                   	ret    

80105444 <uartputc>:
{
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010544a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105450:	85 d2                	test   %edx,%edx
80105452:	74 08                	je     8010545c <uartputc+0x18>
}
80105454:	5d                   	pop    %ebp
80105455:	e9 06 ff ff ff       	jmp    80105360 <uartputc.part.0>
8010545a:	66 90                	xchg   %ax,%ax
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax

80105460 <uartintr>:

void
uartintr(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105466:	68 38 53 10 80       	push   $0x80105338
8010546b:	e8 38 b3 ff ff       	call   801007a8 <consoleintr>
}
80105470:	83 c4 10             	add    $0x10,%esp
80105473:	c9                   	leave  
80105474:	c3                   	ret    

80105475 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105475:	6a 00                	push   $0x0
  pushl $0
80105477:	6a 00                	push   $0x0
  jmp alltraps
80105479:	e9 c5 fb ff ff       	jmp    80105043 <alltraps>

8010547e <vector1>:
.globl vector1
vector1:
  pushl $0
8010547e:	6a 00                	push   $0x0
  pushl $1
80105480:	6a 01                	push   $0x1
  jmp alltraps
80105482:	e9 bc fb ff ff       	jmp    80105043 <alltraps>

80105487 <vector2>:
.globl vector2
vector2:
  pushl $0
80105487:	6a 00                	push   $0x0
  pushl $2
80105489:	6a 02                	push   $0x2
  jmp alltraps
8010548b:	e9 b3 fb ff ff       	jmp    80105043 <alltraps>

80105490 <vector3>:
.globl vector3
vector3:
  pushl $0
80105490:	6a 00                	push   $0x0
  pushl $3
80105492:	6a 03                	push   $0x3
  jmp alltraps
80105494:	e9 aa fb ff ff       	jmp    80105043 <alltraps>

80105499 <vector4>:
.globl vector4
vector4:
  pushl $0
80105499:	6a 00                	push   $0x0
  pushl $4
8010549b:	6a 04                	push   $0x4
  jmp alltraps
8010549d:	e9 a1 fb ff ff       	jmp    80105043 <alltraps>

801054a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801054a2:	6a 00                	push   $0x0
  pushl $5
801054a4:	6a 05                	push   $0x5
  jmp alltraps
801054a6:	e9 98 fb ff ff       	jmp    80105043 <alltraps>

801054ab <vector6>:
.globl vector6
vector6:
  pushl $0
801054ab:	6a 00                	push   $0x0
  pushl $6
801054ad:	6a 06                	push   $0x6
  jmp alltraps
801054af:	e9 8f fb ff ff       	jmp    80105043 <alltraps>

801054b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801054b4:	6a 00                	push   $0x0
  pushl $7
801054b6:	6a 07                	push   $0x7
  jmp alltraps
801054b8:	e9 86 fb ff ff       	jmp    80105043 <alltraps>

801054bd <vector8>:
.globl vector8
vector8:
  pushl $8
801054bd:	6a 08                	push   $0x8
  jmp alltraps
801054bf:	e9 7f fb ff ff       	jmp    80105043 <alltraps>

801054c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801054c4:	6a 00                	push   $0x0
  pushl $9
801054c6:	6a 09                	push   $0x9
  jmp alltraps
801054c8:	e9 76 fb ff ff       	jmp    80105043 <alltraps>

801054cd <vector10>:
.globl vector10
vector10:
  pushl $10
801054cd:	6a 0a                	push   $0xa
  jmp alltraps
801054cf:	e9 6f fb ff ff       	jmp    80105043 <alltraps>

801054d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801054d4:	6a 0b                	push   $0xb
  jmp alltraps
801054d6:	e9 68 fb ff ff       	jmp    80105043 <alltraps>

801054db <vector12>:
.globl vector12
vector12:
  pushl $12
801054db:	6a 0c                	push   $0xc
  jmp alltraps
801054dd:	e9 61 fb ff ff       	jmp    80105043 <alltraps>

801054e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801054e2:	6a 0d                	push   $0xd
  jmp alltraps
801054e4:	e9 5a fb ff ff       	jmp    80105043 <alltraps>

801054e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801054e9:	6a 0e                	push   $0xe
  jmp alltraps
801054eb:	e9 53 fb ff ff       	jmp    80105043 <alltraps>

801054f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801054f0:	6a 00                	push   $0x0
  pushl $15
801054f2:	6a 0f                	push   $0xf
  jmp alltraps
801054f4:	e9 4a fb ff ff       	jmp    80105043 <alltraps>

801054f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801054f9:	6a 00                	push   $0x0
  pushl $16
801054fb:	6a 10                	push   $0x10
  jmp alltraps
801054fd:	e9 41 fb ff ff       	jmp    80105043 <alltraps>

80105502 <vector17>:
.globl vector17
vector17:
  pushl $17
80105502:	6a 11                	push   $0x11
  jmp alltraps
80105504:	e9 3a fb ff ff       	jmp    80105043 <alltraps>

80105509 <vector18>:
.globl vector18
vector18:
  pushl $0
80105509:	6a 00                	push   $0x0
  pushl $18
8010550b:	6a 12                	push   $0x12
  jmp alltraps
8010550d:	e9 31 fb ff ff       	jmp    80105043 <alltraps>

80105512 <vector19>:
.globl vector19
vector19:
  pushl $0
80105512:	6a 00                	push   $0x0
  pushl $19
80105514:	6a 13                	push   $0x13
  jmp alltraps
80105516:	e9 28 fb ff ff       	jmp    80105043 <alltraps>

8010551b <vector20>:
.globl vector20
vector20:
  pushl $0
8010551b:	6a 00                	push   $0x0
  pushl $20
8010551d:	6a 14                	push   $0x14
  jmp alltraps
8010551f:	e9 1f fb ff ff       	jmp    80105043 <alltraps>

80105524 <vector21>:
.globl vector21
vector21:
  pushl $0
80105524:	6a 00                	push   $0x0
  pushl $21
80105526:	6a 15                	push   $0x15
  jmp alltraps
80105528:	e9 16 fb ff ff       	jmp    80105043 <alltraps>

8010552d <vector22>:
.globl vector22
vector22:
  pushl $0
8010552d:	6a 00                	push   $0x0
  pushl $22
8010552f:	6a 16                	push   $0x16
  jmp alltraps
80105531:	e9 0d fb ff ff       	jmp    80105043 <alltraps>

80105536 <vector23>:
.globl vector23
vector23:
  pushl $0
80105536:	6a 00                	push   $0x0
  pushl $23
80105538:	6a 17                	push   $0x17
  jmp alltraps
8010553a:	e9 04 fb ff ff       	jmp    80105043 <alltraps>

8010553f <vector24>:
.globl vector24
vector24:
  pushl $0
8010553f:	6a 00                	push   $0x0
  pushl $24
80105541:	6a 18                	push   $0x18
  jmp alltraps
80105543:	e9 fb fa ff ff       	jmp    80105043 <alltraps>

80105548 <vector25>:
.globl vector25
vector25:
  pushl $0
80105548:	6a 00                	push   $0x0
  pushl $25
8010554a:	6a 19                	push   $0x19
  jmp alltraps
8010554c:	e9 f2 fa ff ff       	jmp    80105043 <alltraps>

80105551 <vector26>:
.globl vector26
vector26:
  pushl $0
80105551:	6a 00                	push   $0x0
  pushl $26
80105553:	6a 1a                	push   $0x1a
  jmp alltraps
80105555:	e9 e9 fa ff ff       	jmp    80105043 <alltraps>

8010555a <vector27>:
.globl vector27
vector27:
  pushl $0
8010555a:	6a 00                	push   $0x0
  pushl $27
8010555c:	6a 1b                	push   $0x1b
  jmp alltraps
8010555e:	e9 e0 fa ff ff       	jmp    80105043 <alltraps>

80105563 <vector28>:
.globl vector28
vector28:
  pushl $0
80105563:	6a 00                	push   $0x0
  pushl $28
80105565:	6a 1c                	push   $0x1c
  jmp alltraps
80105567:	e9 d7 fa ff ff       	jmp    80105043 <alltraps>

8010556c <vector29>:
.globl vector29
vector29:
  pushl $0
8010556c:	6a 00                	push   $0x0
  pushl $29
8010556e:	6a 1d                	push   $0x1d
  jmp alltraps
80105570:	e9 ce fa ff ff       	jmp    80105043 <alltraps>

80105575 <vector30>:
.globl vector30
vector30:
  pushl $0
80105575:	6a 00                	push   $0x0
  pushl $30
80105577:	6a 1e                	push   $0x1e
  jmp alltraps
80105579:	e9 c5 fa ff ff       	jmp    80105043 <alltraps>

8010557e <vector31>:
.globl vector31
vector31:
  pushl $0
8010557e:	6a 00                	push   $0x0
  pushl $31
80105580:	6a 1f                	push   $0x1f
  jmp alltraps
80105582:	e9 bc fa ff ff       	jmp    80105043 <alltraps>

80105587 <vector32>:
.globl vector32
vector32:
  pushl $0
80105587:	6a 00                	push   $0x0
  pushl $32
80105589:	6a 20                	push   $0x20
  jmp alltraps
8010558b:	e9 b3 fa ff ff       	jmp    80105043 <alltraps>

80105590 <vector33>:
.globl vector33
vector33:
  pushl $0
80105590:	6a 00                	push   $0x0
  pushl $33
80105592:	6a 21                	push   $0x21
  jmp alltraps
80105594:	e9 aa fa ff ff       	jmp    80105043 <alltraps>

80105599 <vector34>:
.globl vector34
vector34:
  pushl $0
80105599:	6a 00                	push   $0x0
  pushl $34
8010559b:	6a 22                	push   $0x22
  jmp alltraps
8010559d:	e9 a1 fa ff ff       	jmp    80105043 <alltraps>

801055a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801055a2:	6a 00                	push   $0x0
  pushl $35
801055a4:	6a 23                	push   $0x23
  jmp alltraps
801055a6:	e9 98 fa ff ff       	jmp    80105043 <alltraps>

801055ab <vector36>:
.globl vector36
vector36:
  pushl $0
801055ab:	6a 00                	push   $0x0
  pushl $36
801055ad:	6a 24                	push   $0x24
  jmp alltraps
801055af:	e9 8f fa ff ff       	jmp    80105043 <alltraps>

801055b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801055b4:	6a 00                	push   $0x0
  pushl $37
801055b6:	6a 25                	push   $0x25
  jmp alltraps
801055b8:	e9 86 fa ff ff       	jmp    80105043 <alltraps>

801055bd <vector38>:
.globl vector38
vector38:
  pushl $0
801055bd:	6a 00                	push   $0x0
  pushl $38
801055bf:	6a 26                	push   $0x26
  jmp alltraps
801055c1:	e9 7d fa ff ff       	jmp    80105043 <alltraps>

801055c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801055c6:	6a 00                	push   $0x0
  pushl $39
801055c8:	6a 27                	push   $0x27
  jmp alltraps
801055ca:	e9 74 fa ff ff       	jmp    80105043 <alltraps>

801055cf <vector40>:
.globl vector40
vector40:
  pushl $0
801055cf:	6a 00                	push   $0x0
  pushl $40
801055d1:	6a 28                	push   $0x28
  jmp alltraps
801055d3:	e9 6b fa ff ff       	jmp    80105043 <alltraps>

801055d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801055d8:	6a 00                	push   $0x0
  pushl $41
801055da:	6a 29                	push   $0x29
  jmp alltraps
801055dc:	e9 62 fa ff ff       	jmp    80105043 <alltraps>

801055e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801055e1:	6a 00                	push   $0x0
  pushl $42
801055e3:	6a 2a                	push   $0x2a
  jmp alltraps
801055e5:	e9 59 fa ff ff       	jmp    80105043 <alltraps>

801055ea <vector43>:
.globl vector43
vector43:
  pushl $0
801055ea:	6a 00                	push   $0x0
  pushl $43
801055ec:	6a 2b                	push   $0x2b
  jmp alltraps
801055ee:	e9 50 fa ff ff       	jmp    80105043 <alltraps>

801055f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801055f3:	6a 00                	push   $0x0
  pushl $44
801055f5:	6a 2c                	push   $0x2c
  jmp alltraps
801055f7:	e9 47 fa ff ff       	jmp    80105043 <alltraps>

801055fc <vector45>:
.globl vector45
vector45:
  pushl $0
801055fc:	6a 00                	push   $0x0
  pushl $45
801055fe:	6a 2d                	push   $0x2d
  jmp alltraps
80105600:	e9 3e fa ff ff       	jmp    80105043 <alltraps>

80105605 <vector46>:
.globl vector46
vector46:
  pushl $0
80105605:	6a 00                	push   $0x0
  pushl $46
80105607:	6a 2e                	push   $0x2e
  jmp alltraps
80105609:	e9 35 fa ff ff       	jmp    80105043 <alltraps>

8010560e <vector47>:
.globl vector47
vector47:
  pushl $0
8010560e:	6a 00                	push   $0x0
  pushl $47
80105610:	6a 2f                	push   $0x2f
  jmp alltraps
80105612:	e9 2c fa ff ff       	jmp    80105043 <alltraps>

80105617 <vector48>:
.globl vector48
vector48:
  pushl $0
80105617:	6a 00                	push   $0x0
  pushl $48
80105619:	6a 30                	push   $0x30
  jmp alltraps
8010561b:	e9 23 fa ff ff       	jmp    80105043 <alltraps>

80105620 <vector49>:
.globl vector49
vector49:
  pushl $0
80105620:	6a 00                	push   $0x0
  pushl $49
80105622:	6a 31                	push   $0x31
  jmp alltraps
80105624:	e9 1a fa ff ff       	jmp    80105043 <alltraps>

80105629 <vector50>:
.globl vector50
vector50:
  pushl $0
80105629:	6a 00                	push   $0x0
  pushl $50
8010562b:	6a 32                	push   $0x32
  jmp alltraps
8010562d:	e9 11 fa ff ff       	jmp    80105043 <alltraps>

80105632 <vector51>:
.globl vector51
vector51:
  pushl $0
80105632:	6a 00                	push   $0x0
  pushl $51
80105634:	6a 33                	push   $0x33
  jmp alltraps
80105636:	e9 08 fa ff ff       	jmp    80105043 <alltraps>

8010563b <vector52>:
.globl vector52
vector52:
  pushl $0
8010563b:	6a 00                	push   $0x0
  pushl $52
8010563d:	6a 34                	push   $0x34
  jmp alltraps
8010563f:	e9 ff f9 ff ff       	jmp    80105043 <alltraps>

80105644 <vector53>:
.globl vector53
vector53:
  pushl $0
80105644:	6a 00                	push   $0x0
  pushl $53
80105646:	6a 35                	push   $0x35
  jmp alltraps
80105648:	e9 f6 f9 ff ff       	jmp    80105043 <alltraps>

8010564d <vector54>:
.globl vector54
vector54:
  pushl $0
8010564d:	6a 00                	push   $0x0
  pushl $54
8010564f:	6a 36                	push   $0x36
  jmp alltraps
80105651:	e9 ed f9 ff ff       	jmp    80105043 <alltraps>

80105656 <vector55>:
.globl vector55
vector55:
  pushl $0
80105656:	6a 00                	push   $0x0
  pushl $55
80105658:	6a 37                	push   $0x37
  jmp alltraps
8010565a:	e9 e4 f9 ff ff       	jmp    80105043 <alltraps>

8010565f <vector56>:
.globl vector56
vector56:
  pushl $0
8010565f:	6a 00                	push   $0x0
  pushl $56
80105661:	6a 38                	push   $0x38
  jmp alltraps
80105663:	e9 db f9 ff ff       	jmp    80105043 <alltraps>

80105668 <vector57>:
.globl vector57
vector57:
  pushl $0
80105668:	6a 00                	push   $0x0
  pushl $57
8010566a:	6a 39                	push   $0x39
  jmp alltraps
8010566c:	e9 d2 f9 ff ff       	jmp    80105043 <alltraps>

80105671 <vector58>:
.globl vector58
vector58:
  pushl $0
80105671:	6a 00                	push   $0x0
  pushl $58
80105673:	6a 3a                	push   $0x3a
  jmp alltraps
80105675:	e9 c9 f9 ff ff       	jmp    80105043 <alltraps>

8010567a <vector59>:
.globl vector59
vector59:
  pushl $0
8010567a:	6a 00                	push   $0x0
  pushl $59
8010567c:	6a 3b                	push   $0x3b
  jmp alltraps
8010567e:	e9 c0 f9 ff ff       	jmp    80105043 <alltraps>

80105683 <vector60>:
.globl vector60
vector60:
  pushl $0
80105683:	6a 00                	push   $0x0
  pushl $60
80105685:	6a 3c                	push   $0x3c
  jmp alltraps
80105687:	e9 b7 f9 ff ff       	jmp    80105043 <alltraps>

8010568c <vector61>:
.globl vector61
vector61:
  pushl $0
8010568c:	6a 00                	push   $0x0
  pushl $61
8010568e:	6a 3d                	push   $0x3d
  jmp alltraps
80105690:	e9 ae f9 ff ff       	jmp    80105043 <alltraps>

80105695 <vector62>:
.globl vector62
vector62:
  pushl $0
80105695:	6a 00                	push   $0x0
  pushl $62
80105697:	6a 3e                	push   $0x3e
  jmp alltraps
80105699:	e9 a5 f9 ff ff       	jmp    80105043 <alltraps>

8010569e <vector63>:
.globl vector63
vector63:
  pushl $0
8010569e:	6a 00                	push   $0x0
  pushl $63
801056a0:	6a 3f                	push   $0x3f
  jmp alltraps
801056a2:	e9 9c f9 ff ff       	jmp    80105043 <alltraps>

801056a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801056a7:	6a 00                	push   $0x0
  pushl $64
801056a9:	6a 40                	push   $0x40
  jmp alltraps
801056ab:	e9 93 f9 ff ff       	jmp    80105043 <alltraps>

801056b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801056b0:	6a 00                	push   $0x0
  pushl $65
801056b2:	6a 41                	push   $0x41
  jmp alltraps
801056b4:	e9 8a f9 ff ff       	jmp    80105043 <alltraps>

801056b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801056b9:	6a 00                	push   $0x0
  pushl $66
801056bb:	6a 42                	push   $0x42
  jmp alltraps
801056bd:	e9 81 f9 ff ff       	jmp    80105043 <alltraps>

801056c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801056c2:	6a 00                	push   $0x0
  pushl $67
801056c4:	6a 43                	push   $0x43
  jmp alltraps
801056c6:	e9 78 f9 ff ff       	jmp    80105043 <alltraps>

801056cb <vector68>:
.globl vector68
vector68:
  pushl $0
801056cb:	6a 00                	push   $0x0
  pushl $68
801056cd:	6a 44                	push   $0x44
  jmp alltraps
801056cf:	e9 6f f9 ff ff       	jmp    80105043 <alltraps>

801056d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801056d4:	6a 00                	push   $0x0
  pushl $69
801056d6:	6a 45                	push   $0x45
  jmp alltraps
801056d8:	e9 66 f9 ff ff       	jmp    80105043 <alltraps>

801056dd <vector70>:
.globl vector70
vector70:
  pushl $0
801056dd:	6a 00                	push   $0x0
  pushl $70
801056df:	6a 46                	push   $0x46
  jmp alltraps
801056e1:	e9 5d f9 ff ff       	jmp    80105043 <alltraps>

801056e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801056e6:	6a 00                	push   $0x0
  pushl $71
801056e8:	6a 47                	push   $0x47
  jmp alltraps
801056ea:	e9 54 f9 ff ff       	jmp    80105043 <alltraps>

801056ef <vector72>:
.globl vector72
vector72:
  pushl $0
801056ef:	6a 00                	push   $0x0
  pushl $72
801056f1:	6a 48                	push   $0x48
  jmp alltraps
801056f3:	e9 4b f9 ff ff       	jmp    80105043 <alltraps>

801056f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801056f8:	6a 00                	push   $0x0
  pushl $73
801056fa:	6a 49                	push   $0x49
  jmp alltraps
801056fc:	e9 42 f9 ff ff       	jmp    80105043 <alltraps>

80105701 <vector74>:
.globl vector74
vector74:
  pushl $0
80105701:	6a 00                	push   $0x0
  pushl $74
80105703:	6a 4a                	push   $0x4a
  jmp alltraps
80105705:	e9 39 f9 ff ff       	jmp    80105043 <alltraps>

8010570a <vector75>:
.globl vector75
vector75:
  pushl $0
8010570a:	6a 00                	push   $0x0
  pushl $75
8010570c:	6a 4b                	push   $0x4b
  jmp alltraps
8010570e:	e9 30 f9 ff ff       	jmp    80105043 <alltraps>

80105713 <vector76>:
.globl vector76
vector76:
  pushl $0
80105713:	6a 00                	push   $0x0
  pushl $76
80105715:	6a 4c                	push   $0x4c
  jmp alltraps
80105717:	e9 27 f9 ff ff       	jmp    80105043 <alltraps>

8010571c <vector77>:
.globl vector77
vector77:
  pushl $0
8010571c:	6a 00                	push   $0x0
  pushl $77
8010571e:	6a 4d                	push   $0x4d
  jmp alltraps
80105720:	e9 1e f9 ff ff       	jmp    80105043 <alltraps>

80105725 <vector78>:
.globl vector78
vector78:
  pushl $0
80105725:	6a 00                	push   $0x0
  pushl $78
80105727:	6a 4e                	push   $0x4e
  jmp alltraps
80105729:	e9 15 f9 ff ff       	jmp    80105043 <alltraps>

8010572e <vector79>:
.globl vector79
vector79:
  pushl $0
8010572e:	6a 00                	push   $0x0
  pushl $79
80105730:	6a 4f                	push   $0x4f
  jmp alltraps
80105732:	e9 0c f9 ff ff       	jmp    80105043 <alltraps>

80105737 <vector80>:
.globl vector80
vector80:
  pushl $0
80105737:	6a 00                	push   $0x0
  pushl $80
80105739:	6a 50                	push   $0x50
  jmp alltraps
8010573b:	e9 03 f9 ff ff       	jmp    80105043 <alltraps>

80105740 <vector81>:
.globl vector81
vector81:
  pushl $0
80105740:	6a 00                	push   $0x0
  pushl $81
80105742:	6a 51                	push   $0x51
  jmp alltraps
80105744:	e9 fa f8 ff ff       	jmp    80105043 <alltraps>

80105749 <vector82>:
.globl vector82
vector82:
  pushl $0
80105749:	6a 00                	push   $0x0
  pushl $82
8010574b:	6a 52                	push   $0x52
  jmp alltraps
8010574d:	e9 f1 f8 ff ff       	jmp    80105043 <alltraps>

80105752 <vector83>:
.globl vector83
vector83:
  pushl $0
80105752:	6a 00                	push   $0x0
  pushl $83
80105754:	6a 53                	push   $0x53
  jmp alltraps
80105756:	e9 e8 f8 ff ff       	jmp    80105043 <alltraps>

8010575b <vector84>:
.globl vector84
vector84:
  pushl $0
8010575b:	6a 00                	push   $0x0
  pushl $84
8010575d:	6a 54                	push   $0x54
  jmp alltraps
8010575f:	e9 df f8 ff ff       	jmp    80105043 <alltraps>

80105764 <vector85>:
.globl vector85
vector85:
  pushl $0
80105764:	6a 00                	push   $0x0
  pushl $85
80105766:	6a 55                	push   $0x55
  jmp alltraps
80105768:	e9 d6 f8 ff ff       	jmp    80105043 <alltraps>

8010576d <vector86>:
.globl vector86
vector86:
  pushl $0
8010576d:	6a 00                	push   $0x0
  pushl $86
8010576f:	6a 56                	push   $0x56
  jmp alltraps
80105771:	e9 cd f8 ff ff       	jmp    80105043 <alltraps>

80105776 <vector87>:
.globl vector87
vector87:
  pushl $0
80105776:	6a 00                	push   $0x0
  pushl $87
80105778:	6a 57                	push   $0x57
  jmp alltraps
8010577a:	e9 c4 f8 ff ff       	jmp    80105043 <alltraps>

8010577f <vector88>:
.globl vector88
vector88:
  pushl $0
8010577f:	6a 00                	push   $0x0
  pushl $88
80105781:	6a 58                	push   $0x58
  jmp alltraps
80105783:	e9 bb f8 ff ff       	jmp    80105043 <alltraps>

80105788 <vector89>:
.globl vector89
vector89:
  pushl $0
80105788:	6a 00                	push   $0x0
  pushl $89
8010578a:	6a 59                	push   $0x59
  jmp alltraps
8010578c:	e9 b2 f8 ff ff       	jmp    80105043 <alltraps>

80105791 <vector90>:
.globl vector90
vector90:
  pushl $0
80105791:	6a 00                	push   $0x0
  pushl $90
80105793:	6a 5a                	push   $0x5a
  jmp alltraps
80105795:	e9 a9 f8 ff ff       	jmp    80105043 <alltraps>

8010579a <vector91>:
.globl vector91
vector91:
  pushl $0
8010579a:	6a 00                	push   $0x0
  pushl $91
8010579c:	6a 5b                	push   $0x5b
  jmp alltraps
8010579e:	e9 a0 f8 ff ff       	jmp    80105043 <alltraps>

801057a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801057a3:	6a 00                	push   $0x0
  pushl $92
801057a5:	6a 5c                	push   $0x5c
  jmp alltraps
801057a7:	e9 97 f8 ff ff       	jmp    80105043 <alltraps>

801057ac <vector93>:
.globl vector93
vector93:
  pushl $0
801057ac:	6a 00                	push   $0x0
  pushl $93
801057ae:	6a 5d                	push   $0x5d
  jmp alltraps
801057b0:	e9 8e f8 ff ff       	jmp    80105043 <alltraps>

801057b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801057b5:	6a 00                	push   $0x0
  pushl $94
801057b7:	6a 5e                	push   $0x5e
  jmp alltraps
801057b9:	e9 85 f8 ff ff       	jmp    80105043 <alltraps>

801057be <vector95>:
.globl vector95
vector95:
  pushl $0
801057be:	6a 00                	push   $0x0
  pushl $95
801057c0:	6a 5f                	push   $0x5f
  jmp alltraps
801057c2:	e9 7c f8 ff ff       	jmp    80105043 <alltraps>

801057c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801057c7:	6a 00                	push   $0x0
  pushl $96
801057c9:	6a 60                	push   $0x60
  jmp alltraps
801057cb:	e9 73 f8 ff ff       	jmp    80105043 <alltraps>

801057d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801057d0:	6a 00                	push   $0x0
  pushl $97
801057d2:	6a 61                	push   $0x61
  jmp alltraps
801057d4:	e9 6a f8 ff ff       	jmp    80105043 <alltraps>

801057d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801057d9:	6a 00                	push   $0x0
  pushl $98
801057db:	6a 62                	push   $0x62
  jmp alltraps
801057dd:	e9 61 f8 ff ff       	jmp    80105043 <alltraps>

801057e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801057e2:	6a 00                	push   $0x0
  pushl $99
801057e4:	6a 63                	push   $0x63
  jmp alltraps
801057e6:	e9 58 f8 ff ff       	jmp    80105043 <alltraps>

801057eb <vector100>:
.globl vector100
vector100:
  pushl $0
801057eb:	6a 00                	push   $0x0
  pushl $100
801057ed:	6a 64                	push   $0x64
  jmp alltraps
801057ef:	e9 4f f8 ff ff       	jmp    80105043 <alltraps>

801057f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801057f4:	6a 00                	push   $0x0
  pushl $101
801057f6:	6a 65                	push   $0x65
  jmp alltraps
801057f8:	e9 46 f8 ff ff       	jmp    80105043 <alltraps>

801057fd <vector102>:
.globl vector102
vector102:
  pushl $0
801057fd:	6a 00                	push   $0x0
  pushl $102
801057ff:	6a 66                	push   $0x66
  jmp alltraps
80105801:	e9 3d f8 ff ff       	jmp    80105043 <alltraps>

80105806 <vector103>:
.globl vector103
vector103:
  pushl $0
80105806:	6a 00                	push   $0x0
  pushl $103
80105808:	6a 67                	push   $0x67
  jmp alltraps
8010580a:	e9 34 f8 ff ff       	jmp    80105043 <alltraps>

8010580f <vector104>:
.globl vector104
vector104:
  pushl $0
8010580f:	6a 00                	push   $0x0
  pushl $104
80105811:	6a 68                	push   $0x68
  jmp alltraps
80105813:	e9 2b f8 ff ff       	jmp    80105043 <alltraps>

80105818 <vector105>:
.globl vector105
vector105:
  pushl $0
80105818:	6a 00                	push   $0x0
  pushl $105
8010581a:	6a 69                	push   $0x69
  jmp alltraps
8010581c:	e9 22 f8 ff ff       	jmp    80105043 <alltraps>

80105821 <vector106>:
.globl vector106
vector106:
  pushl $0
80105821:	6a 00                	push   $0x0
  pushl $106
80105823:	6a 6a                	push   $0x6a
  jmp alltraps
80105825:	e9 19 f8 ff ff       	jmp    80105043 <alltraps>

8010582a <vector107>:
.globl vector107
vector107:
  pushl $0
8010582a:	6a 00                	push   $0x0
  pushl $107
8010582c:	6a 6b                	push   $0x6b
  jmp alltraps
8010582e:	e9 10 f8 ff ff       	jmp    80105043 <alltraps>

80105833 <vector108>:
.globl vector108
vector108:
  pushl $0
80105833:	6a 00                	push   $0x0
  pushl $108
80105835:	6a 6c                	push   $0x6c
  jmp alltraps
80105837:	e9 07 f8 ff ff       	jmp    80105043 <alltraps>

8010583c <vector109>:
.globl vector109
vector109:
  pushl $0
8010583c:	6a 00                	push   $0x0
  pushl $109
8010583e:	6a 6d                	push   $0x6d
  jmp alltraps
80105840:	e9 fe f7 ff ff       	jmp    80105043 <alltraps>

80105845 <vector110>:
.globl vector110
vector110:
  pushl $0
80105845:	6a 00                	push   $0x0
  pushl $110
80105847:	6a 6e                	push   $0x6e
  jmp alltraps
80105849:	e9 f5 f7 ff ff       	jmp    80105043 <alltraps>

8010584e <vector111>:
.globl vector111
vector111:
  pushl $0
8010584e:	6a 00                	push   $0x0
  pushl $111
80105850:	6a 6f                	push   $0x6f
  jmp alltraps
80105852:	e9 ec f7 ff ff       	jmp    80105043 <alltraps>

80105857 <vector112>:
.globl vector112
vector112:
  pushl $0
80105857:	6a 00                	push   $0x0
  pushl $112
80105859:	6a 70                	push   $0x70
  jmp alltraps
8010585b:	e9 e3 f7 ff ff       	jmp    80105043 <alltraps>

80105860 <vector113>:
.globl vector113
vector113:
  pushl $0
80105860:	6a 00                	push   $0x0
  pushl $113
80105862:	6a 71                	push   $0x71
  jmp alltraps
80105864:	e9 da f7 ff ff       	jmp    80105043 <alltraps>

80105869 <vector114>:
.globl vector114
vector114:
  pushl $0
80105869:	6a 00                	push   $0x0
  pushl $114
8010586b:	6a 72                	push   $0x72
  jmp alltraps
8010586d:	e9 d1 f7 ff ff       	jmp    80105043 <alltraps>

80105872 <vector115>:
.globl vector115
vector115:
  pushl $0
80105872:	6a 00                	push   $0x0
  pushl $115
80105874:	6a 73                	push   $0x73
  jmp alltraps
80105876:	e9 c8 f7 ff ff       	jmp    80105043 <alltraps>

8010587b <vector116>:
.globl vector116
vector116:
  pushl $0
8010587b:	6a 00                	push   $0x0
  pushl $116
8010587d:	6a 74                	push   $0x74
  jmp alltraps
8010587f:	e9 bf f7 ff ff       	jmp    80105043 <alltraps>

80105884 <vector117>:
.globl vector117
vector117:
  pushl $0
80105884:	6a 00                	push   $0x0
  pushl $117
80105886:	6a 75                	push   $0x75
  jmp alltraps
80105888:	e9 b6 f7 ff ff       	jmp    80105043 <alltraps>

8010588d <vector118>:
.globl vector118
vector118:
  pushl $0
8010588d:	6a 00                	push   $0x0
  pushl $118
8010588f:	6a 76                	push   $0x76
  jmp alltraps
80105891:	e9 ad f7 ff ff       	jmp    80105043 <alltraps>

80105896 <vector119>:
.globl vector119
vector119:
  pushl $0
80105896:	6a 00                	push   $0x0
  pushl $119
80105898:	6a 77                	push   $0x77
  jmp alltraps
8010589a:	e9 a4 f7 ff ff       	jmp    80105043 <alltraps>

8010589f <vector120>:
.globl vector120
vector120:
  pushl $0
8010589f:	6a 00                	push   $0x0
  pushl $120
801058a1:	6a 78                	push   $0x78
  jmp alltraps
801058a3:	e9 9b f7 ff ff       	jmp    80105043 <alltraps>

801058a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801058a8:	6a 00                	push   $0x0
  pushl $121
801058aa:	6a 79                	push   $0x79
  jmp alltraps
801058ac:	e9 92 f7 ff ff       	jmp    80105043 <alltraps>

801058b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801058b1:	6a 00                	push   $0x0
  pushl $122
801058b3:	6a 7a                	push   $0x7a
  jmp alltraps
801058b5:	e9 89 f7 ff ff       	jmp    80105043 <alltraps>

801058ba <vector123>:
.globl vector123
vector123:
  pushl $0
801058ba:	6a 00                	push   $0x0
  pushl $123
801058bc:	6a 7b                	push   $0x7b
  jmp alltraps
801058be:	e9 80 f7 ff ff       	jmp    80105043 <alltraps>

801058c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801058c3:	6a 00                	push   $0x0
  pushl $124
801058c5:	6a 7c                	push   $0x7c
  jmp alltraps
801058c7:	e9 77 f7 ff ff       	jmp    80105043 <alltraps>

801058cc <vector125>:
.globl vector125
vector125:
  pushl $0
801058cc:	6a 00                	push   $0x0
  pushl $125
801058ce:	6a 7d                	push   $0x7d
  jmp alltraps
801058d0:	e9 6e f7 ff ff       	jmp    80105043 <alltraps>

801058d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801058d5:	6a 00                	push   $0x0
  pushl $126
801058d7:	6a 7e                	push   $0x7e
  jmp alltraps
801058d9:	e9 65 f7 ff ff       	jmp    80105043 <alltraps>

801058de <vector127>:
.globl vector127
vector127:
  pushl $0
801058de:	6a 00                	push   $0x0
  pushl $127
801058e0:	6a 7f                	push   $0x7f
  jmp alltraps
801058e2:	e9 5c f7 ff ff       	jmp    80105043 <alltraps>

801058e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801058e7:	6a 00                	push   $0x0
  pushl $128
801058e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801058ee:	e9 50 f7 ff ff       	jmp    80105043 <alltraps>

801058f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $129
801058f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801058fa:	e9 44 f7 ff ff       	jmp    80105043 <alltraps>

801058ff <vector130>:
.globl vector130
vector130:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $130
80105901:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105906:	e9 38 f7 ff ff       	jmp    80105043 <alltraps>

8010590b <vector131>:
.globl vector131
vector131:
  pushl $0
8010590b:	6a 00                	push   $0x0
  pushl $131
8010590d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105912:	e9 2c f7 ff ff       	jmp    80105043 <alltraps>

80105917 <vector132>:
.globl vector132
vector132:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $132
80105919:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010591e:	e9 20 f7 ff ff       	jmp    80105043 <alltraps>

80105923 <vector133>:
.globl vector133
vector133:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $133
80105925:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010592a:	e9 14 f7 ff ff       	jmp    80105043 <alltraps>

8010592f <vector134>:
.globl vector134
vector134:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $134
80105931:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105936:	e9 08 f7 ff ff       	jmp    80105043 <alltraps>

8010593b <vector135>:
.globl vector135
vector135:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $135
8010593d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105942:	e9 fc f6 ff ff       	jmp    80105043 <alltraps>

80105947 <vector136>:
.globl vector136
vector136:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $136
80105949:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010594e:	e9 f0 f6 ff ff       	jmp    80105043 <alltraps>

80105953 <vector137>:
.globl vector137
vector137:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $137
80105955:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010595a:	e9 e4 f6 ff ff       	jmp    80105043 <alltraps>

8010595f <vector138>:
.globl vector138
vector138:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $138
80105961:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105966:	e9 d8 f6 ff ff       	jmp    80105043 <alltraps>

8010596b <vector139>:
.globl vector139
vector139:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $139
8010596d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105972:	e9 cc f6 ff ff       	jmp    80105043 <alltraps>

80105977 <vector140>:
.globl vector140
vector140:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $140
80105979:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010597e:	e9 c0 f6 ff ff       	jmp    80105043 <alltraps>

80105983 <vector141>:
.globl vector141
vector141:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $141
80105985:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010598a:	e9 b4 f6 ff ff       	jmp    80105043 <alltraps>

8010598f <vector142>:
.globl vector142
vector142:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $142
80105991:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105996:	e9 a8 f6 ff ff       	jmp    80105043 <alltraps>

8010599b <vector143>:
.globl vector143
vector143:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $143
8010599d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801059a2:	e9 9c f6 ff ff       	jmp    80105043 <alltraps>

801059a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $144
801059a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801059ae:	e9 90 f6 ff ff       	jmp    80105043 <alltraps>

801059b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $145
801059b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801059ba:	e9 84 f6 ff ff       	jmp    80105043 <alltraps>

801059bf <vector146>:
.globl vector146
vector146:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $146
801059c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801059c6:	e9 78 f6 ff ff       	jmp    80105043 <alltraps>

801059cb <vector147>:
.globl vector147
vector147:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $147
801059cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801059d2:	e9 6c f6 ff ff       	jmp    80105043 <alltraps>

801059d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $148
801059d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801059de:	e9 60 f6 ff ff       	jmp    80105043 <alltraps>

801059e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $149
801059e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801059ea:	e9 54 f6 ff ff       	jmp    80105043 <alltraps>

801059ef <vector150>:
.globl vector150
vector150:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $150
801059f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801059f6:	e9 48 f6 ff ff       	jmp    80105043 <alltraps>

801059fb <vector151>:
.globl vector151
vector151:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $151
801059fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105a02:	e9 3c f6 ff ff       	jmp    80105043 <alltraps>

80105a07 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $152
80105a09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a0e:	e9 30 f6 ff ff       	jmp    80105043 <alltraps>

80105a13 <vector153>:
.globl vector153
vector153:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $153
80105a15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a1a:	e9 24 f6 ff ff       	jmp    80105043 <alltraps>

80105a1f <vector154>:
.globl vector154
vector154:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $154
80105a21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a26:	e9 18 f6 ff ff       	jmp    80105043 <alltraps>

80105a2b <vector155>:
.globl vector155
vector155:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $155
80105a2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105a32:	e9 0c f6 ff ff       	jmp    80105043 <alltraps>

80105a37 <vector156>:
.globl vector156
vector156:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $156
80105a39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105a3e:	e9 00 f6 ff ff       	jmp    80105043 <alltraps>

80105a43 <vector157>:
.globl vector157
vector157:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $157
80105a45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105a4a:	e9 f4 f5 ff ff       	jmp    80105043 <alltraps>

80105a4f <vector158>:
.globl vector158
vector158:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $158
80105a51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105a56:	e9 e8 f5 ff ff       	jmp    80105043 <alltraps>

80105a5b <vector159>:
.globl vector159
vector159:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $159
80105a5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105a62:	e9 dc f5 ff ff       	jmp    80105043 <alltraps>

80105a67 <vector160>:
.globl vector160
vector160:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $160
80105a69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105a6e:	e9 d0 f5 ff ff       	jmp    80105043 <alltraps>

80105a73 <vector161>:
.globl vector161
vector161:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $161
80105a75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105a7a:	e9 c4 f5 ff ff       	jmp    80105043 <alltraps>

80105a7f <vector162>:
.globl vector162
vector162:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $162
80105a81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105a86:	e9 b8 f5 ff ff       	jmp    80105043 <alltraps>

80105a8b <vector163>:
.globl vector163
vector163:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $163
80105a8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105a92:	e9 ac f5 ff ff       	jmp    80105043 <alltraps>

80105a97 <vector164>:
.globl vector164
vector164:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $164
80105a99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105a9e:	e9 a0 f5 ff ff       	jmp    80105043 <alltraps>

80105aa3 <vector165>:
.globl vector165
vector165:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $165
80105aa5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105aaa:	e9 94 f5 ff ff       	jmp    80105043 <alltraps>

80105aaf <vector166>:
.globl vector166
vector166:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $166
80105ab1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ab6:	e9 88 f5 ff ff       	jmp    80105043 <alltraps>

80105abb <vector167>:
.globl vector167
vector167:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $167
80105abd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ac2:	e9 7c f5 ff ff       	jmp    80105043 <alltraps>

80105ac7 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $168
80105ac9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ace:	e9 70 f5 ff ff       	jmp    80105043 <alltraps>

80105ad3 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $169
80105ad5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ada:	e9 64 f5 ff ff       	jmp    80105043 <alltraps>

80105adf <vector170>:
.globl vector170
vector170:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $170
80105ae1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ae6:	e9 58 f5 ff ff       	jmp    80105043 <alltraps>

80105aeb <vector171>:
.globl vector171
vector171:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $171
80105aed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105af2:	e9 4c f5 ff ff       	jmp    80105043 <alltraps>

80105af7 <vector172>:
.globl vector172
vector172:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $172
80105af9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105afe:	e9 40 f5 ff ff       	jmp    80105043 <alltraps>

80105b03 <vector173>:
.globl vector173
vector173:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $173
80105b05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b0a:	e9 34 f5 ff ff       	jmp    80105043 <alltraps>

80105b0f <vector174>:
.globl vector174
vector174:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $174
80105b11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b16:	e9 28 f5 ff ff       	jmp    80105043 <alltraps>

80105b1b <vector175>:
.globl vector175
vector175:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $175
80105b1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b22:	e9 1c f5 ff ff       	jmp    80105043 <alltraps>

80105b27 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $176
80105b29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b2e:	e9 10 f5 ff ff       	jmp    80105043 <alltraps>

80105b33 <vector177>:
.globl vector177
vector177:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $177
80105b35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105b3a:	e9 04 f5 ff ff       	jmp    80105043 <alltraps>

80105b3f <vector178>:
.globl vector178
vector178:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $178
80105b41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105b46:	e9 f8 f4 ff ff       	jmp    80105043 <alltraps>

80105b4b <vector179>:
.globl vector179
vector179:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $179
80105b4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105b52:	e9 ec f4 ff ff       	jmp    80105043 <alltraps>

80105b57 <vector180>:
.globl vector180
vector180:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $180
80105b59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105b5e:	e9 e0 f4 ff ff       	jmp    80105043 <alltraps>

80105b63 <vector181>:
.globl vector181
vector181:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $181
80105b65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105b6a:	e9 d4 f4 ff ff       	jmp    80105043 <alltraps>

80105b6f <vector182>:
.globl vector182
vector182:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $182
80105b71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105b76:	e9 c8 f4 ff ff       	jmp    80105043 <alltraps>

80105b7b <vector183>:
.globl vector183
vector183:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $183
80105b7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105b82:	e9 bc f4 ff ff       	jmp    80105043 <alltraps>

80105b87 <vector184>:
.globl vector184
vector184:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $184
80105b89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105b8e:	e9 b0 f4 ff ff       	jmp    80105043 <alltraps>

80105b93 <vector185>:
.globl vector185
vector185:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $185
80105b95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105b9a:	e9 a4 f4 ff ff       	jmp    80105043 <alltraps>

80105b9f <vector186>:
.globl vector186
vector186:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $186
80105ba1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105ba6:	e9 98 f4 ff ff       	jmp    80105043 <alltraps>

80105bab <vector187>:
.globl vector187
vector187:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $187
80105bad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105bb2:	e9 8c f4 ff ff       	jmp    80105043 <alltraps>

80105bb7 <vector188>:
.globl vector188
vector188:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $188
80105bb9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105bbe:	e9 80 f4 ff ff       	jmp    80105043 <alltraps>

80105bc3 <vector189>:
.globl vector189
vector189:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $189
80105bc5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105bca:	e9 74 f4 ff ff       	jmp    80105043 <alltraps>

80105bcf <vector190>:
.globl vector190
vector190:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $190
80105bd1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105bd6:	e9 68 f4 ff ff       	jmp    80105043 <alltraps>

80105bdb <vector191>:
.globl vector191
vector191:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $191
80105bdd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105be2:	e9 5c f4 ff ff       	jmp    80105043 <alltraps>

80105be7 <vector192>:
.globl vector192
vector192:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $192
80105be9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105bee:	e9 50 f4 ff ff       	jmp    80105043 <alltraps>

80105bf3 <vector193>:
.globl vector193
vector193:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $193
80105bf5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105bfa:	e9 44 f4 ff ff       	jmp    80105043 <alltraps>

80105bff <vector194>:
.globl vector194
vector194:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $194
80105c01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c06:	e9 38 f4 ff ff       	jmp    80105043 <alltraps>

80105c0b <vector195>:
.globl vector195
vector195:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $195
80105c0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c12:	e9 2c f4 ff ff       	jmp    80105043 <alltraps>

80105c17 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $196
80105c19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c1e:	e9 20 f4 ff ff       	jmp    80105043 <alltraps>

80105c23 <vector197>:
.globl vector197
vector197:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $197
80105c25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c2a:	e9 14 f4 ff ff       	jmp    80105043 <alltraps>

80105c2f <vector198>:
.globl vector198
vector198:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $198
80105c31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105c36:	e9 08 f4 ff ff       	jmp    80105043 <alltraps>

80105c3b <vector199>:
.globl vector199
vector199:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $199
80105c3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105c42:	e9 fc f3 ff ff       	jmp    80105043 <alltraps>

80105c47 <vector200>:
.globl vector200
vector200:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $200
80105c49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105c4e:	e9 f0 f3 ff ff       	jmp    80105043 <alltraps>

80105c53 <vector201>:
.globl vector201
vector201:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $201
80105c55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105c5a:	e9 e4 f3 ff ff       	jmp    80105043 <alltraps>

80105c5f <vector202>:
.globl vector202
vector202:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $202
80105c61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105c66:	e9 d8 f3 ff ff       	jmp    80105043 <alltraps>

80105c6b <vector203>:
.globl vector203
vector203:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $203
80105c6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105c72:	e9 cc f3 ff ff       	jmp    80105043 <alltraps>

80105c77 <vector204>:
.globl vector204
vector204:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $204
80105c79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105c7e:	e9 c0 f3 ff ff       	jmp    80105043 <alltraps>

80105c83 <vector205>:
.globl vector205
vector205:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $205
80105c85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105c8a:	e9 b4 f3 ff ff       	jmp    80105043 <alltraps>

80105c8f <vector206>:
.globl vector206
vector206:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $206
80105c91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105c96:	e9 a8 f3 ff ff       	jmp    80105043 <alltraps>

80105c9b <vector207>:
.globl vector207
vector207:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $207
80105c9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105ca2:	e9 9c f3 ff ff       	jmp    80105043 <alltraps>

80105ca7 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $208
80105ca9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105cae:	e9 90 f3 ff ff       	jmp    80105043 <alltraps>

80105cb3 <vector209>:
.globl vector209
vector209:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $209
80105cb5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105cba:	e9 84 f3 ff ff       	jmp    80105043 <alltraps>

80105cbf <vector210>:
.globl vector210
vector210:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $210
80105cc1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105cc6:	e9 78 f3 ff ff       	jmp    80105043 <alltraps>

80105ccb <vector211>:
.globl vector211
vector211:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $211
80105ccd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105cd2:	e9 6c f3 ff ff       	jmp    80105043 <alltraps>

80105cd7 <vector212>:
.globl vector212
vector212:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $212
80105cd9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105cde:	e9 60 f3 ff ff       	jmp    80105043 <alltraps>

80105ce3 <vector213>:
.globl vector213
vector213:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $213
80105ce5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105cea:	e9 54 f3 ff ff       	jmp    80105043 <alltraps>

80105cef <vector214>:
.globl vector214
vector214:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $214
80105cf1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105cf6:	e9 48 f3 ff ff       	jmp    80105043 <alltraps>

80105cfb <vector215>:
.globl vector215
vector215:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $215
80105cfd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105d02:	e9 3c f3 ff ff       	jmp    80105043 <alltraps>

80105d07 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $216
80105d09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d0e:	e9 30 f3 ff ff       	jmp    80105043 <alltraps>

80105d13 <vector217>:
.globl vector217
vector217:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $217
80105d15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d1a:	e9 24 f3 ff ff       	jmp    80105043 <alltraps>

80105d1f <vector218>:
.globl vector218
vector218:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $218
80105d21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d26:	e9 18 f3 ff ff       	jmp    80105043 <alltraps>

80105d2b <vector219>:
.globl vector219
vector219:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $219
80105d2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105d32:	e9 0c f3 ff ff       	jmp    80105043 <alltraps>

80105d37 <vector220>:
.globl vector220
vector220:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $220
80105d39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105d3e:	e9 00 f3 ff ff       	jmp    80105043 <alltraps>

80105d43 <vector221>:
.globl vector221
vector221:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $221
80105d45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105d4a:	e9 f4 f2 ff ff       	jmp    80105043 <alltraps>

80105d4f <vector222>:
.globl vector222
vector222:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $222
80105d51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105d56:	e9 e8 f2 ff ff       	jmp    80105043 <alltraps>

80105d5b <vector223>:
.globl vector223
vector223:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $223
80105d5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105d62:	e9 dc f2 ff ff       	jmp    80105043 <alltraps>

80105d67 <vector224>:
.globl vector224
vector224:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $224
80105d69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105d6e:	e9 d0 f2 ff ff       	jmp    80105043 <alltraps>

80105d73 <vector225>:
.globl vector225
vector225:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $225
80105d75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105d7a:	e9 c4 f2 ff ff       	jmp    80105043 <alltraps>

80105d7f <vector226>:
.globl vector226
vector226:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $226
80105d81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105d86:	e9 b8 f2 ff ff       	jmp    80105043 <alltraps>

80105d8b <vector227>:
.globl vector227
vector227:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $227
80105d8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105d92:	e9 ac f2 ff ff       	jmp    80105043 <alltraps>

80105d97 <vector228>:
.globl vector228
vector228:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $228
80105d99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105d9e:	e9 a0 f2 ff ff       	jmp    80105043 <alltraps>

80105da3 <vector229>:
.globl vector229
vector229:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $229
80105da5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105daa:	e9 94 f2 ff ff       	jmp    80105043 <alltraps>

80105daf <vector230>:
.globl vector230
vector230:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $230
80105db1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105db6:	e9 88 f2 ff ff       	jmp    80105043 <alltraps>

80105dbb <vector231>:
.globl vector231
vector231:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $231
80105dbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105dc2:	e9 7c f2 ff ff       	jmp    80105043 <alltraps>

80105dc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $232
80105dc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105dce:	e9 70 f2 ff ff       	jmp    80105043 <alltraps>

80105dd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $233
80105dd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105dda:	e9 64 f2 ff ff       	jmp    80105043 <alltraps>

80105ddf <vector234>:
.globl vector234
vector234:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $234
80105de1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105de6:	e9 58 f2 ff ff       	jmp    80105043 <alltraps>

80105deb <vector235>:
.globl vector235
vector235:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $235
80105ded:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105df2:	e9 4c f2 ff ff       	jmp    80105043 <alltraps>

80105df7 <vector236>:
.globl vector236
vector236:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $236
80105df9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105dfe:	e9 40 f2 ff ff       	jmp    80105043 <alltraps>

80105e03 <vector237>:
.globl vector237
vector237:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $237
80105e05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e0a:	e9 34 f2 ff ff       	jmp    80105043 <alltraps>

80105e0f <vector238>:
.globl vector238
vector238:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $238
80105e11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e16:	e9 28 f2 ff ff       	jmp    80105043 <alltraps>

80105e1b <vector239>:
.globl vector239
vector239:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $239
80105e1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e22:	e9 1c f2 ff ff       	jmp    80105043 <alltraps>

80105e27 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $240
80105e29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e2e:	e9 10 f2 ff ff       	jmp    80105043 <alltraps>

80105e33 <vector241>:
.globl vector241
vector241:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $241
80105e35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105e3a:	e9 04 f2 ff ff       	jmp    80105043 <alltraps>

80105e3f <vector242>:
.globl vector242
vector242:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $242
80105e41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105e46:	e9 f8 f1 ff ff       	jmp    80105043 <alltraps>

80105e4b <vector243>:
.globl vector243
vector243:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $243
80105e4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105e52:	e9 ec f1 ff ff       	jmp    80105043 <alltraps>

80105e57 <vector244>:
.globl vector244
vector244:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $244
80105e59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105e5e:	e9 e0 f1 ff ff       	jmp    80105043 <alltraps>

80105e63 <vector245>:
.globl vector245
vector245:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $245
80105e65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105e6a:	e9 d4 f1 ff ff       	jmp    80105043 <alltraps>

80105e6f <vector246>:
.globl vector246
vector246:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $246
80105e71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105e76:	e9 c8 f1 ff ff       	jmp    80105043 <alltraps>

80105e7b <vector247>:
.globl vector247
vector247:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $247
80105e7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105e82:	e9 bc f1 ff ff       	jmp    80105043 <alltraps>

80105e87 <vector248>:
.globl vector248
vector248:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $248
80105e89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105e8e:	e9 b0 f1 ff ff       	jmp    80105043 <alltraps>

80105e93 <vector249>:
.globl vector249
vector249:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $249
80105e95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105e9a:	e9 a4 f1 ff ff       	jmp    80105043 <alltraps>

80105e9f <vector250>:
.globl vector250
vector250:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $250
80105ea1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105ea6:	e9 98 f1 ff ff       	jmp    80105043 <alltraps>

80105eab <vector251>:
.globl vector251
vector251:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $251
80105ead:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105eb2:	e9 8c f1 ff ff       	jmp    80105043 <alltraps>

80105eb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $252
80105eb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105ebe:	e9 80 f1 ff ff       	jmp    80105043 <alltraps>

80105ec3 <vector253>:
.globl vector253
vector253:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $253
80105ec5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105eca:	e9 74 f1 ff ff       	jmp    80105043 <alltraps>

80105ecf <vector254>:
.globl vector254
vector254:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $254
80105ed1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ed6:	e9 68 f1 ff ff       	jmp    80105043 <alltraps>

80105edb <vector255>:
.globl vector255
vector255:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $255
80105edd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105ee2:	e9 5c f1 ff ff       	jmp    80105043 <alltraps>
80105ee7:	90                   	nop

80105ee8 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105ee8:	55                   	push   %ebp
80105ee9:	89 e5                	mov    %esp,%ebp
80105eeb:	57                   	push   %edi
80105eec:	56                   	push   %esi
80105eed:	53                   	push   %ebx
80105eee:	83 ec 0c             	sub    $0xc,%esp
80105ef1:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105ef3:	c1 ea 16             	shr    $0x16,%edx
80105ef6:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105ef9:	8b 1f                	mov    (%edi),%ebx
80105efb:	f6 c3 01             	test   $0x1,%bl
80105efe:	74 20                	je     80105f20 <walkpgdir+0x38>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105f00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105f06:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105f0c:	89 f0                	mov    %esi,%eax
80105f0e:	c1 e8 0a             	shr    $0xa,%eax
80105f11:	25 fc 0f 00 00       	and    $0xffc,%eax
80105f16:	01 d8                	add    %ebx,%eax
}
80105f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f1b:	5b                   	pop    %ebx
80105f1c:	5e                   	pop    %esi
80105f1d:	5f                   	pop    %edi
80105f1e:	5d                   	pop    %ebp
80105f1f:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105f20:	85 c9                	test   %ecx,%ecx
80105f22:	74 2c                	je     80105f50 <walkpgdir+0x68>
80105f24:	e8 17 c3 ff ff       	call   80102240 <kalloc>
80105f29:	89 c3                	mov    %eax,%ebx
80105f2b:	85 c0                	test   %eax,%eax
80105f2d:	74 21                	je     80105f50 <walkpgdir+0x68>
    memset(pgtab, 0, PGSIZE);
80105f2f:	50                   	push   %eax
80105f30:	68 00 10 00 00       	push   $0x1000
80105f35:	6a 00                	push   $0x0
80105f37:	53                   	push   %ebx
80105f38:	e8 33 e1 ff ff       	call   80104070 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105f3d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105f43:	83 c8 07             	or     $0x7,%eax
80105f46:	89 07                	mov    %eax,(%edi)
80105f48:	83 c4 10             	add    $0x10,%esp
80105f4b:	eb bf                	jmp    80105f0c <walkpgdir+0x24>
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
80105f50:	31 c0                	xor    %eax,%eax
}
80105f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f55:	5b                   	pop    %ebx
80105f56:	5e                   	pop    %esi
80105f57:	5f                   	pop    %edi
80105f58:	5d                   	pop    %ebp
80105f59:	c3                   	ret    
80105f5a:	66 90                	xchg   %ax,%ax

80105f5c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105f5c:	55                   	push   %ebp
80105f5d:	89 e5                	mov    %esp,%ebp
80105f5f:	57                   	push   %edi
80105f60:	56                   	push   %esi
80105f61:	53                   	push   %ebx
80105f62:	83 ec 1c             	sub    $0x1c,%esp
80105f65:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105f67:	89 d6                	mov    %edx,%esi
80105f69:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105f6f:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80105f73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105f78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80105f7e:	29 f0                	sub    %esi,%eax
80105f80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f83:	eb 1b                	jmp    80105fa0 <mappages+0x44>
80105f85:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80105f88:	f6 00 01             	testb  $0x1,(%eax)
80105f8b:	75 45                	jne    80105fd2 <mappages+0x76>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105f8d:	0b 5d 0c             	or     0xc(%ebp),%ebx
80105f90:	83 cb 01             	or     $0x1,%ebx
80105f93:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80105f95:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80105f98:	74 2e                	je     80105fc8 <mappages+0x6c>
      break;
    a += PGSIZE;
80105f9a:	81 c6 00 10 00 00    	add    $0x1000,%esi
    pa += PGSIZE;
80105fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa3:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105fa6:	b9 01 00 00 00       	mov    $0x1,%ecx
80105fab:	89 f2                	mov    %esi,%edx
80105fad:	89 f8                	mov    %edi,%eax
80105faf:	e8 34 ff ff ff       	call   80105ee8 <walkpgdir>
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	75 d0                	jne    80105f88 <mappages+0x2c>
      return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc0:	5b                   	pop    %ebx
80105fc1:	5e                   	pop    %esi
80105fc2:	5f                   	pop    %edi
80105fc3:	5d                   	pop    %ebp
80105fc4:	c3                   	ret    
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80105fc8:	31 c0                	xor    %eax,%eax
}
80105fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fcd:	5b                   	pop    %ebx
80105fce:	5e                   	pop    %esi
80105fcf:	5f                   	pop    %edi
80105fd0:	5d                   	pop    %ebp
80105fd1:	c3                   	ret    
      panic("remap");
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	68 2c 70 10 80       	push   $0x8010702c
80105fda:	e8 61 a3 ff ff       	call   80100340 <panic>
80105fdf:	90                   	nop

80105fe0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	57                   	push   %edi
80105fe4:	56                   	push   %esi
80105fe5:	53                   	push   %ebx
80105fe6:	83 ec 1c             	sub    $0x1c,%esp
80105fe9:	89 c6                	mov    %eax,%esi
80105feb:	89 d3                	mov    %edx,%ebx
80105fed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80105ff0:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80105ff6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; a  < oldsz; a += PGSIZE){
80105ffc:	39 da                	cmp    %ebx,%edx
80105ffe:	73 53                	jae    80106053 <deallocuvm.part.0+0x73>
80106000:	89 d7                	mov    %edx,%edi
80106002:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106005:	eb 0c                	jmp    80106013 <deallocuvm.part.0+0x33>
80106007:	90                   	nop
80106008:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010600e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106011:	76 40                	jbe    80106053 <deallocuvm.part.0+0x73>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106013:	31 c9                	xor    %ecx,%ecx
80106015:	89 fa                	mov    %edi,%edx
80106017:	89 f0                	mov    %esi,%eax
80106019:	e8 ca fe ff ff       	call   80105ee8 <walkpgdir>
8010601e:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106020:	85 c0                	test   %eax,%eax
80106022:	74 3c                	je     80106060 <deallocuvm.part.0+0x80>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106024:	8b 00                	mov    (%eax),%eax
80106026:	a8 01                	test   $0x1,%al
80106028:	74 de                	je     80106008 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010602a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010602f:	74 3f                	je     80106070 <deallocuvm.part.0+0x90>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106031:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106034:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106039:	50                   	push   %eax
8010603a:	e8 71 c0 ff ff       	call   801020b0 <kfree>
      *pte = 0;
8010603f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106045:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010604b:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
8010604e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106051:	77 c0                	ja     80106013 <deallocuvm.part.0+0x33>
    }
  }
  return newsz;
}
80106053:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106059:	5b                   	pop    %ebx
8010605a:	5e                   	pop    %esi
8010605b:	5f                   	pop    %edi
8010605c:	5d                   	pop    %ebp
8010605d:	c3                   	ret    
8010605e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106060:	89 fa                	mov    %edi,%edx
80106062:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106068:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010606e:	eb 9e                	jmp    8010600e <deallocuvm.part.0+0x2e>
        panic("kfree");
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	68 c6 69 10 80       	push   $0x801069c6
80106078:	e8 c3 a2 ff ff       	call   80100340 <panic>
8010607d:	8d 76 00             	lea    0x0(%esi),%esi

80106080 <seginit>:
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106086:	e8 a5 d2 ff ff       	call   80103330 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010608b:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010608e:	01 d2                	add    %edx,%edx
80106090:	01 d0                	add    %edx,%eax
80106092:	c1 e0 04             	shl    $0x4,%eax
80106095:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
8010609c:	ff 00 00 
8010609f:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801060a6:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801060a9:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801060b0:	ff 00 00 
801060b3:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801060ba:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801060bd:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801060c4:	ff 00 00 
801060c7:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801060ce:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801060d1:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801060d8:	ff 00 00 
801060db:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801060e2:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801060e5:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
801060ea:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801060f0:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801060f4:	c1 e8 10             	shr    $0x10,%eax
801060f7:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801060fb:	8d 45 f2             	lea    -0xe(%ebp),%eax
801060fe:	0f 01 10             	lgdtl  (%eax)
}
80106101:	c9                   	leave  
80106102:	c3                   	ret    
80106103:	90                   	nop

80106104 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106104:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106109:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010610e:	0f 22 d8             	mov    %eax,%cr3
}
80106111:	c3                   	ret    
80106112:	66 90                	xchg   %ax,%ax

80106114 <switchuvm>:
{
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	57                   	push   %edi
80106118:	56                   	push   %esi
80106119:	53                   	push   %ebx
8010611a:	83 ec 1c             	sub    $0x1c,%esp
8010611d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106120:	85 f6                	test   %esi,%esi
80106122:	0f 84 bf 00 00 00    	je     801061e7 <switchuvm+0xd3>
  if(p->kstack == 0)
80106128:	8b 56 08             	mov    0x8(%esi),%edx
8010612b:	85 d2                	test   %edx,%edx
8010612d:	0f 84 ce 00 00 00    	je     80106201 <switchuvm+0xed>
  if(p->pgdir == 0)
80106133:	8b 46 04             	mov    0x4(%esi),%eax
80106136:	85 c0                	test   %eax,%eax
80106138:	0f 84 b6 00 00 00    	je     801061f4 <switchuvm+0xe0>
  pushcli();
8010613e:	e8 71 dd ff ff       	call   80103eb4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106143:	e8 84 d1 ff ff       	call   801032cc <mycpu>
80106148:	89 c3                	mov    %eax,%ebx
8010614a:	e8 7d d1 ff ff       	call   801032cc <mycpu>
8010614f:	89 c7                	mov    %eax,%edi
80106151:	e8 76 d1 ff ff       	call   801032cc <mycpu>
80106156:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106159:	e8 6e d1 ff ff       	call   801032cc <mycpu>
8010615e:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106165:	67 00 
80106167:	83 c7 08             	add    $0x8,%edi
8010616a:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106171:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106174:	83 c1 08             	add    $0x8,%ecx
80106177:	c1 e9 10             	shr    $0x10,%ecx
8010617a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106180:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
80106187:	99 40 
80106189:	83 c0 08             	add    $0x8,%eax
8010618c:	c1 e8 18             	shr    $0x18,%eax
8010618f:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
80106195:	e8 32 d1 ff ff       	call   801032cc <mycpu>
8010619a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801061a1:	e8 26 d1 ff ff       	call   801032cc <mycpu>
801061a6:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801061ac:	8b 5e 08             	mov    0x8(%esi),%ebx
801061af:	e8 18 d1 ff ff       	call   801032cc <mycpu>
801061b4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061ba:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801061bd:	e8 0a d1 ff ff       	call   801032cc <mycpu>
801061c2:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801061c8:	b8 28 00 00 00       	mov    $0x28,%eax
801061cd:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801061d0:	8b 46 04             	mov    0x4(%esi),%eax
801061d3:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801061d8:	0f 22 d8             	mov    %eax,%cr3
}
801061db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061de:	5b                   	pop    %ebx
801061df:	5e                   	pop    %esi
801061e0:	5f                   	pop    %edi
801061e1:	5d                   	pop    %ebp
  popcli();
801061e2:	e9 15 dd ff ff       	jmp    80103efc <popcli>
    panic("switchuvm: no process");
801061e7:	83 ec 0c             	sub    $0xc,%esp
801061ea:	68 32 70 10 80       	push   $0x80107032
801061ef:	e8 4c a1 ff ff       	call   80100340 <panic>
    panic("switchuvm: no pgdir");
801061f4:	83 ec 0c             	sub    $0xc,%esp
801061f7:	68 5d 70 10 80       	push   $0x8010705d
801061fc:	e8 3f a1 ff ff       	call   80100340 <panic>
    panic("switchuvm: no kstack");
80106201:	83 ec 0c             	sub    $0xc,%esp
80106204:	68 48 70 10 80       	push   $0x80107048
80106209:	e8 32 a1 ff ff       	call   80100340 <panic>
8010620e:	66 90                	xchg   %ax,%ax

80106210 <inituvm>:
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	57                   	push   %edi
80106214:	56                   	push   %esi
80106215:	53                   	push   %ebx
80106216:	83 ec 1c             	sub    $0x1c,%esp
80106219:	8b 45 08             	mov    0x8(%ebp),%eax
8010621c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010621f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106222:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106225:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010622b:	77 47                	ja     80106274 <inituvm+0x64>
  mem = kalloc();
8010622d:	e8 0e c0 ff ff       	call   80102240 <kalloc>
80106232:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106234:	50                   	push   %eax
80106235:	68 00 10 00 00       	push   $0x1000
8010623a:	6a 00                	push   $0x0
8010623c:	53                   	push   %ebx
8010623d:	e8 2e de ff ff       	call   80104070 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106242:	5a                   	pop    %edx
80106243:	59                   	pop    %ecx
80106244:	6a 06                	push   $0x6
80106246:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010624c:	50                   	push   %eax
8010624d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106252:	31 d2                	xor    %edx,%edx
80106254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106257:	e8 00 fd ff ff       	call   80105f5c <mappages>
  memmove(mem, init, sz);
8010625c:	83 c4 10             	add    $0x10,%esp
8010625f:	89 75 10             	mov    %esi,0x10(%ebp)
80106262:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106265:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010626b:	5b                   	pop    %ebx
8010626c:	5e                   	pop    %esi
8010626d:	5f                   	pop    %edi
8010626e:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010626f:	e9 80 de ff ff       	jmp    801040f4 <memmove>
    panic("inituvm: more than a page");
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	68 71 70 10 80       	push   $0x80107071
8010627c:	e8 bf a0 ff ff       	call   80100340 <panic>
80106281:	8d 76 00             	lea    0x0(%esi),%esi

80106284 <loaduvm>:
{
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	57                   	push   %edi
80106288:	56                   	push   %esi
80106289:	53                   	push   %ebx
8010628a:	83 ec 1c             	sub    $0x1c,%esp
8010628d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106290:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106293:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106298:	0f 85 94 00 00 00    	jne    80106332 <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
8010629e:	85 f6                	test   %esi,%esi
801062a0:	74 6a                	je     8010630c <loaduvm+0x88>
801062a2:	89 f3                	mov    %esi,%ebx
801062a4:	01 f0                	add    %esi,%eax
801062a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801062a9:	8b 45 14             	mov    0x14(%ebp),%eax
801062ac:	01 f0                	add    %esi,%eax
801062ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062b1:	eb 2d                	jmp    801062e0 <loaduvm+0x5c>
801062b3:	90                   	nop
    if(sz - i < PGSIZE)
801062b4:	89 df                	mov    %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801062b6:	57                   	push   %edi
801062b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801062ba:	29 d9                	sub    %ebx,%ecx
801062bc:	51                   	push   %ecx
801062bd:	05 00 00 00 80       	add    $0x80000000,%eax
801062c2:	50                   	push   %eax
801062c3:	ff 75 10             	pushl  0x10(%ebp)
801062c6:	e8 41 b5 ff ff       	call   8010180c <readi>
801062cb:	83 c4 10             	add    $0x10,%esp
801062ce:	39 f8                	cmp    %edi,%eax
801062d0:	75 46                	jne    80106318 <loaduvm+0x94>
801062d2:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(i = 0; i < sz; i += PGSIZE){
801062d8:	89 f0                	mov    %esi,%eax
801062da:	29 d8                	sub    %ebx,%eax
801062dc:	39 c6                	cmp    %eax,%esi
801062de:	76 2c                	jbe    8010630c <loaduvm+0x88>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801062e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801062e3:	29 da                	sub    %ebx,%edx
801062e5:	31 c9                	xor    %ecx,%ecx
801062e7:	8b 45 08             	mov    0x8(%ebp),%eax
801062ea:	e8 f9 fb ff ff       	call   80105ee8 <walkpgdir>
801062ef:	85 c0                	test   %eax,%eax
801062f1:	74 32                	je     80106325 <loaduvm+0xa1>
    pa = PTE_ADDR(*pte);
801062f3:	8b 00                	mov    (%eax),%eax
801062f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801062fa:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106300:	76 b2                	jbe    801062b4 <loaduvm+0x30>
      n = PGSIZE;
80106302:	bf 00 10 00 00       	mov    $0x1000,%edi
80106307:	eb ad                	jmp    801062b6 <loaduvm+0x32>
80106309:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
8010630c:	31 c0                	xor    %eax,%eax
}
8010630e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106311:	5b                   	pop    %ebx
80106312:	5e                   	pop    %esi
80106313:	5f                   	pop    %edi
80106314:	5d                   	pop    %ebp
80106315:	c3                   	ret    
80106316:	66 90                	xchg   %ax,%ax
      return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010631d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106320:	5b                   	pop    %ebx
80106321:	5e                   	pop    %esi
80106322:	5f                   	pop    %edi
80106323:	5d                   	pop    %ebp
80106324:	c3                   	ret    
      panic("loaduvm: address should exist");
80106325:	83 ec 0c             	sub    $0xc,%esp
80106328:	68 8b 70 10 80       	push   $0x8010708b
8010632d:	e8 0e a0 ff ff       	call   80100340 <panic>
    panic("loaduvm: addr must be page aligned");
80106332:	83 ec 0c             	sub    $0xc,%esp
80106335:	68 2c 71 10 80       	push   $0x8010712c
8010633a:	e8 01 a0 ff ff       	call   80100340 <panic>
8010633f:	90                   	nop

80106340 <allocuvm>:
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	57                   	push   %edi
80106344:	56                   	push   %esi
80106345:	53                   	push   %ebx
80106346:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106349:	8b 7d 10             	mov    0x10(%ebp),%edi
8010634c:	85 ff                	test   %edi,%edi
8010634e:	0f 88 b8 00 00 00    	js     8010640c <allocuvm+0xcc>
  if(newsz < oldsz)
80106354:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106357:	0f 82 9f 00 00 00    	jb     801063fc <allocuvm+0xbc>
  a = PGROUNDUP(oldsz);
8010635d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106360:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106366:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010636c:	39 75 10             	cmp    %esi,0x10(%ebp)
8010636f:	0f 86 8a 00 00 00    	jbe    801063ff <allocuvm+0xbf>
80106375:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106378:	8b 7d 10             	mov    0x10(%ebp),%edi
8010637b:	eb 40                	jmp    801063bd <allocuvm+0x7d>
8010637d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106380:	50                   	push   %eax
80106381:	68 00 10 00 00       	push   $0x1000
80106386:	6a 00                	push   $0x0
80106388:	53                   	push   %ebx
80106389:	e8 e2 dc ff ff       	call   80104070 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010638e:	5a                   	pop    %edx
8010638f:	59                   	pop    %ecx
80106390:	6a 06                	push   $0x6
80106392:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106398:	50                   	push   %eax
80106399:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010639e:	89 f2                	mov    %esi,%edx
801063a0:	8b 45 08             	mov    0x8(%ebp),%eax
801063a3:	e8 b4 fb ff ff       	call   80105f5c <mappages>
801063a8:	83 c4 10             	add    $0x10,%esp
801063ab:	85 c0                	test   %eax,%eax
801063ad:	78 69                	js     80106418 <allocuvm+0xd8>
  for(; a < newsz; a += PGSIZE){
801063af:	81 c6 00 10 00 00    	add    $0x1000,%esi
801063b5:	39 f7                	cmp    %esi,%edi
801063b7:	0f 86 9b 00 00 00    	jbe    80106458 <allocuvm+0x118>
    mem = kalloc();
801063bd:	e8 7e be ff ff       	call   80102240 <kalloc>
801063c2:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801063c4:	85 c0                	test   %eax,%eax
801063c6:	75 b8                	jne    80106380 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	68 a9 70 10 80       	push   $0x801070a9
801063d0:	e8 4b a2 ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
801063d5:	83 c4 10             	add    $0x10,%esp
801063d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801063db:	39 45 10             	cmp    %eax,0x10(%ebp)
801063de:	74 2c                	je     8010640c <allocuvm+0xcc>
801063e0:	89 c1                	mov    %eax,%ecx
801063e2:	8b 55 10             	mov    0x10(%ebp),%edx
801063e5:	8b 45 08             	mov    0x8(%ebp),%eax
801063e8:	e8 f3 fb ff ff       	call   80105fe0 <deallocuvm.part.0>
      return 0;
801063ed:	31 ff                	xor    %edi,%edi
}
801063ef:	89 f8                	mov    %edi,%eax
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801063fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801063ff:	89 f8                	mov    %edi,%eax
80106401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    
80106409:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
8010640c:	31 ff                	xor    %edi,%edi
}
8010640e:	89 f8                	mov    %edi,%eax
80106410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106413:	5b                   	pop    %ebx
80106414:	5e                   	pop    %esi
80106415:	5f                   	pop    %edi
80106416:	5d                   	pop    %ebp
80106417:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	68 c1 70 10 80       	push   $0x801070c1
80106420:	e8 fb a1 ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	8b 45 0c             	mov    0xc(%ebp),%eax
8010642b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010642e:	74 0d                	je     8010643d <allocuvm+0xfd>
80106430:	89 c1                	mov    %eax,%ecx
80106432:	8b 55 10             	mov    0x10(%ebp),%edx
80106435:	8b 45 08             	mov    0x8(%ebp),%eax
80106438:	e8 a3 fb ff ff       	call   80105fe0 <deallocuvm.part.0>
      kfree(mem);
8010643d:	83 ec 0c             	sub    $0xc,%esp
80106440:	53                   	push   %ebx
80106441:	e8 6a bc ff ff       	call   801020b0 <kfree>
      return 0;
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	31 ff                	xor    %edi,%edi
}
8010644b:	89 f8                	mov    %edi,%eax
8010644d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106450:	5b                   	pop    %ebx
80106451:	5e                   	pop    %esi
80106452:	5f                   	pop    %edi
80106453:	5d                   	pop    %ebp
80106454:	c3                   	ret    
80106455:	8d 76 00             	lea    0x0(%esi),%esi
80106458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010645b:	89 f8                	mov    %edi,%eax
8010645d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106460:	5b                   	pop    %ebx
80106461:	5e                   	pop    %esi
80106462:	5f                   	pop    %edi
80106463:	5d                   	pop    %ebp
80106464:	c3                   	ret    
80106465:	8d 76 00             	lea    0x0(%esi),%esi

80106468 <deallocuvm>:
{
80106468:	55                   	push   %ebp
80106469:	89 e5                	mov    %esp,%ebp
8010646b:	8b 45 08             	mov    0x8(%ebp),%eax
8010646e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106471:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
80106474:	39 d1                	cmp    %edx,%ecx
80106476:	73 08                	jae    80106480 <deallocuvm+0x18>
}
80106478:	5d                   	pop    %ebp
80106479:	e9 62 fb ff ff       	jmp    80105fe0 <deallocuvm.part.0>
8010647e:	66 90                	xchg   %ax,%ax
80106480:	89 d0                	mov    %edx,%eax
80106482:	5d                   	pop    %ebp
80106483:	c3                   	ret    

80106484 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	57                   	push   %edi
80106488:	56                   	push   %esi
80106489:	53                   	push   %ebx
8010648a:	83 ec 0c             	sub    $0xc,%esp
8010648d:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80106490:	85 ff                	test   %edi,%edi
80106492:	74 51                	je     801064e5 <freevm+0x61>
  if(newsz >= oldsz)
80106494:	31 c9                	xor    %ecx,%ecx
80106496:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010649b:	89 f8                	mov    %edi,%eax
8010649d:	e8 3e fb ff ff       	call   80105fe0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
801064a2:	89 fb                	mov    %edi,%ebx
801064a4:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
801064aa:	eb 07                	jmp    801064b3 <freevm+0x2f>
801064ac:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801064af:	39 de                	cmp    %ebx,%esi
801064b1:	74 23                	je     801064d6 <freevm+0x52>
    if(pgdir[i] & PTE_P){
801064b3:	8b 03                	mov    (%ebx),%eax
801064b5:	a8 01                	test   $0x1,%al
801064b7:	74 f3                	je     801064ac <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801064b9:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801064bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064c1:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801064c6:	50                   	push   %eax
801064c7:	e8 e4 bb ff ff       	call   801020b0 <kfree>
801064cc:	83 c4 10             	add    $0x10,%esp
801064cf:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801064d2:	39 de                	cmp    %ebx,%esi
801064d4:	75 dd                	jne    801064b3 <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
801064d6:	89 7d 08             	mov    %edi,0x8(%ebp)
}
801064d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064dc:	5b                   	pop    %ebx
801064dd:	5e                   	pop    %esi
801064de:	5f                   	pop    %edi
801064df:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801064e0:	e9 cb bb ff ff       	jmp    801020b0 <kfree>
    panic("freevm: no pgdir");
801064e5:	83 ec 0c             	sub    $0xc,%esp
801064e8:	68 dd 70 10 80       	push   $0x801070dd
801064ed:	e8 4e 9e ff ff       	call   80100340 <panic>
801064f2:	66 90                	xchg   %ax,%ax

801064f4 <setupkvm>:
{
801064f4:	55                   	push   %ebp
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	56                   	push   %esi
801064f8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801064f9:	e8 42 bd ff ff       	call   80102240 <kalloc>
801064fe:	89 c6                	mov    %eax,%esi
80106500:	85 c0                	test   %eax,%eax
80106502:	74 40                	je     80106544 <setupkvm+0x50>
  memset(pgdir, 0, PGSIZE);
80106504:	50                   	push   %eax
80106505:	68 00 10 00 00       	push   $0x1000
8010650a:	6a 00                	push   $0x0
8010650c:	56                   	push   %esi
8010650d:	e8 5e db ff ff       	call   80104070 <memset>
80106512:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106515:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010651a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010651d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106520:	29 c1                	sub    %eax,%ecx
80106522:	83 ec 08             	sub    $0x8,%esp
80106525:	ff 73 0c             	pushl  0xc(%ebx)
80106528:	50                   	push   %eax
80106529:	8b 13                	mov    (%ebx),%edx
8010652b:	89 f0                	mov    %esi,%eax
8010652d:	e8 2a fa ff ff       	call   80105f5c <mappages>
80106532:	83 c4 10             	add    $0x10,%esp
80106535:	85 c0                	test   %eax,%eax
80106537:	78 17                	js     80106550 <setupkvm+0x5c>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106539:	83 c3 10             	add    $0x10,%ebx
8010653c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106542:	75 d6                	jne    8010651a <setupkvm+0x26>
}
80106544:	89 f0                	mov    %esi,%eax
80106546:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106549:	5b                   	pop    %ebx
8010654a:	5e                   	pop    %esi
8010654b:	5d                   	pop    %ebp
8010654c:	c3                   	ret    
8010654d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106550:	83 ec 0c             	sub    $0xc,%esp
80106553:	56                   	push   %esi
80106554:	e8 2b ff ff ff       	call   80106484 <freevm>
      return 0;
80106559:	83 c4 10             	add    $0x10,%esp
8010655c:	31 f6                	xor    %esi,%esi
}
8010655e:	89 f0                	mov    %esi,%eax
80106560:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106563:	5b                   	pop    %ebx
80106564:	5e                   	pop    %esi
80106565:	5d                   	pop    %ebp
80106566:	c3                   	ret    
80106567:	90                   	nop

80106568 <kvmalloc>:
{
80106568:	55                   	push   %ebp
80106569:	89 e5                	mov    %esp,%ebp
8010656b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010656e:	e8 81 ff ff ff       	call   801064f4 <setupkvm>
80106573:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106578:	05 00 00 00 80       	add    $0x80000000,%eax
8010657d:	0f 22 d8             	mov    %eax,%cr3
}
80106580:	c9                   	leave  
80106581:	c3                   	ret    
80106582:	66 90                	xchg   %ax,%ax

80106584 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010658a:	31 c9                	xor    %ecx,%ecx
8010658c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010658f:	8b 45 08             	mov    0x8(%ebp),%eax
80106592:	e8 51 f9 ff ff       	call   80105ee8 <walkpgdir>
  if(pte == 0)
80106597:	85 c0                	test   %eax,%eax
80106599:	74 05                	je     801065a0 <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010659b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010659e:	c9                   	leave  
8010659f:	c3                   	ret    
    panic("clearpteu");
801065a0:	83 ec 0c             	sub    $0xc,%esp
801065a3:	68 ee 70 10 80       	push   $0x801070ee
801065a8:	e8 93 9d ff ff       	call   80100340 <panic>
801065ad:	8d 76 00             	lea    0x0(%esi),%esi

801065b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	57                   	push   %edi
801065b4:	56                   	push   %esi
801065b5:	53                   	push   %ebx
801065b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801065b9:	e8 36 ff ff ff       	call   801064f4 <setupkvm>
801065be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801065c1:	85 c0                	test   %eax,%eax
801065c3:	0f 84 96 00 00 00    	je     8010665f <copyuvm+0xaf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801065c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801065cc:	85 db                	test   %ebx,%ebx
801065ce:	0f 84 8b 00 00 00    	je     8010665f <copyuvm+0xaf>
801065d4:	31 ff                	xor    %edi,%edi
801065d6:	eb 40                	jmp    80106618 <copyuvm+0x68>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801065d8:	50                   	push   %eax
801065d9:	68 00 10 00 00       	push   $0x1000
801065de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065e1:	05 00 00 00 80       	add    $0x80000000,%eax
801065e6:	50                   	push   %eax
801065e7:	56                   	push   %esi
801065e8:	e8 07 db ff ff       	call   801040f4 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801065ed:	5a                   	pop    %edx
801065ee:	59                   	pop    %ecx
801065ef:	53                   	push   %ebx
801065f0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801065f6:	50                   	push   %eax
801065f7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801065fc:	89 fa                	mov    %edi,%edx
801065fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106601:	e8 56 f9 ff ff       	call   80105f5c <mappages>
80106606:	83 c4 10             	add    $0x10,%esp
80106609:	85 c0                	test   %eax,%eax
8010660b:	78 5f                	js     8010666c <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
8010660d:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106613:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106616:	76 47                	jbe    8010665f <copyuvm+0xaf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106618:	31 c9                	xor    %ecx,%ecx
8010661a:	89 fa                	mov    %edi,%edx
8010661c:	8b 45 08             	mov    0x8(%ebp),%eax
8010661f:	e8 c4 f8 ff ff       	call   80105ee8 <walkpgdir>
80106624:	85 c0                	test   %eax,%eax
80106626:	74 5f                	je     80106687 <copyuvm+0xd7>
    if(!(*pte & PTE_P))
80106628:	8b 18                	mov    (%eax),%ebx
8010662a:	f6 c3 01             	test   $0x1,%bl
8010662d:	74 4b                	je     8010667a <copyuvm+0xca>
    pa = PTE_ADDR(*pte);
8010662f:	89 d8                	mov    %ebx,%eax
80106631:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106639:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
8010663f:	e8 fc bb ff ff       	call   80102240 <kalloc>
80106644:	89 c6                	mov    %eax,%esi
80106646:	85 c0                	test   %eax,%eax
80106648:	75 8e                	jne    801065d8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
8010664a:	83 ec 0c             	sub    $0xc,%esp
8010664d:	ff 75 e0             	pushl  -0x20(%ebp)
80106650:	e8 2f fe ff ff       	call   80106484 <freevm>
  return 0;
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010665f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106662:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106665:	5b                   	pop    %ebx
80106666:	5e                   	pop    %esi
80106667:	5f                   	pop    %edi
80106668:	5d                   	pop    %ebp
80106669:	c3                   	ret    
8010666a:	66 90                	xchg   %ax,%ax
      kfree(mem);
8010666c:	83 ec 0c             	sub    $0xc,%esp
8010666f:	56                   	push   %esi
80106670:	e8 3b ba ff ff       	call   801020b0 <kfree>
      goto bad;
80106675:	83 c4 10             	add    $0x10,%esp
80106678:	eb d0                	jmp    8010664a <copyuvm+0x9a>
      panic("copyuvm: page not present");
8010667a:	83 ec 0c             	sub    $0xc,%esp
8010667d:	68 12 71 10 80       	push   $0x80107112
80106682:	e8 b9 9c ff ff       	call   80100340 <panic>
      panic("copyuvm: pte should exist");
80106687:	83 ec 0c             	sub    $0xc,%esp
8010668a:	68 f8 70 10 80       	push   $0x801070f8
8010668f:	e8 ac 9c ff ff       	call   80100340 <panic>

80106694 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106694:	55                   	push   %ebp
80106695:	89 e5                	mov    %esp,%ebp
80106697:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010669a:	31 c9                	xor    %ecx,%ecx
8010669c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010669f:	8b 45 08             	mov    0x8(%ebp),%eax
801066a2:	e8 41 f8 ff ff       	call   80105ee8 <walkpgdir>
  if((*pte & PTE_P) == 0)
801066a7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801066a9:	89 c2                	mov    %eax,%edx
801066ab:	83 e2 05             	and    $0x5,%edx
801066ae:	83 fa 05             	cmp    $0x5,%edx
801066b1:	75 0d                	jne    801066c0 <uva2ka+0x2c>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801066b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066b8:	05 00 00 00 80       	add    $0x80000000,%eax
}
801066bd:	c9                   	leave  
801066be:	c3                   	ret    
801066bf:	90                   	nop
    return 0;
801066c0:	31 c0                	xor    %eax,%eax
}
801066c2:	c9                   	leave  
801066c3:	c3                   	ret    

801066c4 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801066c4:	55                   	push   %ebp
801066c5:	89 e5                	mov    %esp,%ebp
801066c7:	57                   	push   %edi
801066c8:	56                   	push   %esi
801066c9:	53                   	push   %ebx
801066ca:	83 ec 0c             	sub    $0xc,%esp
801066cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801066d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
801066d3:	85 c9                	test   %ecx,%ecx
801066d5:	74 65                	je     8010673c <copyout+0x78>
801066d7:	89 fb                	mov    %edi,%ebx
801066d9:	eb 37                	jmp    80106712 <copyout+0x4e>
801066db:	90                   	nop
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801066dc:	89 f2                	mov    %esi,%edx
801066de:	2b 55 0c             	sub    0xc(%ebp),%edx
    if(n > len)
801066e1:	8d ba 00 10 00 00    	lea    0x1000(%edx),%edi
801066e7:	3b 7d 14             	cmp    0x14(%ebp),%edi
801066ea:	76 03                	jbe    801066ef <copyout+0x2b>
801066ec:	8b 7d 14             	mov    0x14(%ebp),%edi
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801066ef:	52                   	push   %edx
801066f0:	57                   	push   %edi
801066f1:	53                   	push   %ebx
801066f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801066f5:	29 f1                	sub    %esi,%ecx
801066f7:	01 c8                	add    %ecx,%eax
801066f9:	50                   	push   %eax
801066fa:	e8 f5 d9 ff ff       	call   801040f4 <memmove>
    len -= n;
    buf += n;
801066ff:	01 fb                	add    %edi,%ebx
    va = va0 + PGSIZE;
80106701:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106707:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	29 7d 14             	sub    %edi,0x14(%ebp)
80106710:	74 2a                	je     8010673c <copyout+0x78>
    va0 = (uint)PGROUNDDOWN(va);
80106712:	8b 75 0c             	mov    0xc(%ebp),%esi
80106715:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010671b:	83 ec 08             	sub    $0x8,%esp
8010671e:	56                   	push   %esi
8010671f:	ff 75 08             	pushl  0x8(%ebp)
80106722:	e8 6d ff ff ff       	call   80106694 <uva2ka>
    if(pa0 == 0)
80106727:	83 c4 10             	add    $0x10,%esp
8010672a:	85 c0                	test   %eax,%eax
8010672c:	75 ae                	jne    801066dc <copyout+0x18>
      return -1;
8010672e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106733:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106736:	5b                   	pop    %ebx
80106737:	5e                   	pop    %esi
80106738:	5f                   	pop    %edi
80106739:	5d                   	pop    %ebp
8010673a:	c3                   	ret    
8010673b:	90                   	nop
  return 0;
8010673c:	31 c0                	xor    %eax,%eax
}
8010673e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106741:	5b                   	pop    %ebx
80106742:	5e                   	pop    %esi
80106743:	5f                   	pop    %edi
80106744:	5d                   	pop    %ebp
80106745:	c3                   	ret    

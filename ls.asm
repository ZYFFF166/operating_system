
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 20                	jle    3d <main+0x3d>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 33                	pushl  (%ebx)
  29:	e8 b2 00 00 00       	call   e0 <ls>
  2e:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
  31:	83 c4 10             	add    $0x10,%esp
  34:	39 f3                	cmp    %esi,%ebx
  36:	75 ec                	jne    24 <main+0x24>
  exit();
  38:	e8 f9 04 00 00       	call   536 <exit>
    ls(".");
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	68 bc 09 00 00       	push   $0x9bc
  45:	e8 96 00 00 00       	call   e0 <ls>
    exit();
  4a:	e8 e7 04 00 00       	call   536 <exit>
  4f:	90                   	nop

00000050 <fmtname>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	56                   	push   %esi
  5c:	e8 e7 02 00 00       	call   348 <strlen>
  61:	83 c4 10             	add    $0x10,%esp
  64:	01 f0                	add    %esi,%eax
  66:	89 c3                	mov    %eax,%ebx
  68:	73 0b                	jae    75 <fmtname+0x25>
  6a:	eb 0e                	jmp    7a <fmtname+0x2a>
  6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  6f:	39 c6                	cmp    %eax,%esi
  71:	77 08                	ja     7b <fmtname+0x2b>
  73:	89 c3                	mov    %eax,%ebx
  75:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  78:	75 f2                	jne    6c <fmtname+0x1c>
  7a:	43                   	inc    %ebx
  if(strlen(p) >= DIRSIZ)
  7b:	83 ec 0c             	sub    $0xc,%esp
  7e:	53                   	push   %ebx
  7f:	e8 c4 02 00 00       	call   348 <strlen>
  84:	83 c4 10             	add    $0x10,%esp
  87:	83 f8 0d             	cmp    $0xd,%eax
  8a:	77 4a                	ja     d6 <fmtname+0x86>
  memmove(buf, p, strlen(p));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 b3 02 00 00       	call   348 <strlen>
  95:	83 c4 0c             	add    $0xc,%esp
  98:	50                   	push   %eax
  99:	53                   	push   %ebx
  9a:	68 78 0d 00 00       	push   $0xd78
  9f:	e8 d8 03 00 00       	call   47c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  a4:	89 1c 24             	mov    %ebx,(%esp)
  a7:	e8 9c 02 00 00       	call   348 <strlen>
  ac:	89 c6                	mov    %eax,%esi
  ae:	89 1c 24             	mov    %ebx,(%esp)
  b1:	e8 92 02 00 00       	call   348 <strlen>
  b6:	83 c4 0c             	add    $0xc,%esp
  b9:	ba 0e 00 00 00       	mov    $0xe,%edx
  be:	29 f2                	sub    %esi,%edx
  c0:	52                   	push   %edx
  c1:	6a 20                	push   $0x20
  c3:	05 78 0d 00 00       	add    $0xd78,%eax
  c8:	50                   	push   %eax
  c9:	e8 a2 02 00 00       	call   370 <memset>
  return buf;
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	bb 78 0d 00 00       	mov    $0xd78,%ebx
}
  d6:	89 d8                	mov    %ebx,%eax
  d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  db:	5b                   	pop    %ebx
  dc:	5e                   	pop    %esi
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop

000000e0 <ls>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	81 ec 64 02 00 00    	sub    $0x264,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
  ef:	6a 00                	push   $0x0
  f1:	57                   	push   %edi
  f2:	e8 7f 04 00 00       	call   576 <open>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	0f 88 82 01 00 00    	js     284 <ls+0x1a4>
 102:	89 c3                	mov    %eax,%ebx
  if(fstat(fd, &st) < 0){
 104:	83 ec 08             	sub    $0x8,%esp
 107:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 10d:	56                   	push   %esi
 10e:	50                   	push   %eax
 10f:	e8 7a 04 00 00       	call   58e <fstat>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	0f 88 99 01 00 00    	js     2b8 <ls+0x1d8>
  switch(st.type){
 11f:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 125:	66 83 f8 01          	cmp    $0x1,%ax
 129:	74 59                	je     184 <ls+0xa4>
 12b:	66 83 f8 02          	cmp    $0x2,%ax
 12f:	74 17                	je     148 <ls+0x68>
  close(fd);
 131:	83 ec 0c             	sub    $0xc,%esp
 134:	53                   	push   %ebx
 135:	e8 24 04 00 00       	call   55e <close>
 13a:	83 c4 10             	add    $0x10,%esp
}
 13d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 148:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 14e:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 154:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 15a:	83 ec 0c             	sub    $0xc,%esp
 15d:	57                   	push   %edi
 15e:	e8 ed fe ff ff       	call   50 <fmtname>
 163:	59                   	pop    %ecx
 164:	5f                   	pop    %edi
 165:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 16b:	52                   	push   %edx
 16c:	56                   	push   %esi
 16d:	6a 02                	push   $0x2
 16f:	50                   	push   %eax
 170:	68 9c 09 00 00       	push   $0x99c
 175:	6a 01                	push   $0x1
 177:	e8 ec 04 00 00       	call   668 <printf>
    break;
 17c:	83 c4 20             	add    $0x20,%esp
 17f:	eb b0                	jmp    131 <ls+0x51>
 181:	8d 76 00             	lea    0x0(%esi),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	57                   	push   %edi
 188:	e8 bb 01 00 00       	call   348 <strlen>
 18d:	83 c0 10             	add    $0x10,%eax
 190:	83 c4 10             	add    $0x10,%esp
 193:	3d 00 02 00 00       	cmp    $0x200,%eax
 198:	0f 87 02 01 00 00    	ja     2a0 <ls+0x1c0>
    strcpy(buf, path);
 19e:	83 ec 08             	sub    $0x8,%esp
 1a1:	57                   	push   %edi
 1a2:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1a8:	57                   	push   %edi
 1a9:	e8 46 01 00 00       	call   2f4 <strcpy>
    p = buf+strlen(buf);
 1ae:	89 3c 24             	mov    %edi,(%esp)
 1b1:	e8 92 01 00 00       	call   348 <strlen>
 1b6:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
 1b9:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1bf:	8d 44 07 01          	lea    0x1(%edi,%eax,1),%eax
 1c3:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1c9:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	90                   	nop
 1d0:	50                   	push   %eax
 1d1:	6a 10                	push   $0x10
 1d3:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1d9:	50                   	push   %eax
 1da:	53                   	push   %ebx
 1db:	e8 6e 03 00 00       	call   54e <read>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	83 f8 10             	cmp    $0x10,%eax
 1e6:	0f 85 45 ff ff ff    	jne    131 <ls+0x51>
      if(de.inum == 0)
 1ec:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1f3:	00 
 1f4:	74 da                	je     1d0 <ls+0xf0>
      memmove(p, de.name, DIRSIZ);
 1f6:	50                   	push   %eax
 1f7:	6a 0e                	push   $0xe
 1f9:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 1ff:	50                   	push   %eax
 200:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 206:	e8 71 02 00 00       	call   47c <memmove>
      p[DIRSIZ] = 0;
 20b:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 211:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 215:	58                   	pop    %eax
 216:	5a                   	pop    %edx
 217:	56                   	push   %esi
 218:	57                   	push   %edi
 219:	e8 e2 01 00 00       	call   400 <stat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	85 c0                	test   %eax,%eax
 223:	0f 88 b3 00 00 00    	js     2dc <ls+0x1fc>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 229:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 22f:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 235:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 23b:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 241:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 248:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	57                   	push   %edi
 252:	e8 f9 fd ff ff       	call   50 <fmtname>
 257:	5a                   	pop    %edx
 258:	59                   	pop    %ecx
 259:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 25f:	51                   	push   %ecx
 260:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 266:	52                   	push   %edx
 267:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 26d:	50                   	push   %eax
 26e:	68 9c 09 00 00       	push   $0x99c
 273:	6a 01                	push   $0x1
 275:	e8 ee 03 00 00       	call   668 <printf>
 27a:	83 c4 20             	add    $0x20,%esp
 27d:	e9 4e ff ff ff       	jmp    1d0 <ls+0xf0>
 282:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 284:	50                   	push   %eax
 285:	57                   	push   %edi
 286:	68 74 09 00 00       	push   $0x974
 28b:	6a 02                	push   $0x2
 28d:	e8 d6 03 00 00       	call   668 <printf>
    return;
 292:	83 c4 10             	add    $0x10,%esp
}
 295:	8d 65 f4             	lea    -0xc(%ebp),%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "ls: path too long\n");
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	68 a9 09 00 00       	push   $0x9a9
 2a8:	6a 01                	push   $0x1
 2aa:	e8 b9 03 00 00       	call   668 <printf>
      break;
 2af:	83 c4 10             	add    $0x10,%esp
 2b2:	e9 7a fe ff ff       	jmp    131 <ls+0x51>
 2b7:	90                   	nop
    printf(2, "ls: cannot stat %s\n", path);
 2b8:	50                   	push   %eax
 2b9:	57                   	push   %edi
 2ba:	68 88 09 00 00       	push   $0x988
 2bf:	6a 02                	push   $0x2
 2c1:	e8 a2 03 00 00       	call   668 <printf>
    close(fd);
 2c6:	89 1c 24             	mov    %ebx,(%esp)
 2c9:	e8 90 02 00 00       	call   55e <close>
    return;
 2ce:	83 c4 10             	add    $0x10,%esp
}
 2d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d4:	5b                   	pop    %ebx
 2d5:	5e                   	pop    %esi
 2d6:	5f                   	pop    %edi
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 2dc:	50                   	push   %eax
 2dd:	57                   	push   %edi
 2de:	68 88 09 00 00       	push   $0x988
 2e3:	6a 01                	push   $0x1
 2e5:	e8 7e 03 00 00       	call   668 <printf>
        continue;
 2ea:	83 c4 10             	add    $0x10,%esp
 2ed:	e9 de fe ff ff       	jmp    1d0 <ls+0xf0>
 2f2:	66 90                	xchg   %ax,%ax

000002f4 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fe:	31 c0                	xor    %eax,%eax
 300:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 303:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 306:	40                   	inc    %eax
 307:	84 d2                	test   %dl,%dl
 309:	75 f5                	jne    300 <strcpy+0xc>
    ;
  return os;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	5b                   	pop    %ebx
 30e:	5d                   	pop    %ebp
 30f:	c3                   	ret    

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 5d 08             	mov    0x8(%ebp),%ebx
 317:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 31a:	0f b6 03             	movzbl (%ebx),%eax
 31d:	0f b6 0a             	movzbl (%edx),%ecx
 320:	84 c0                	test   %al,%al
 322:	75 10                	jne    334 <strcmp+0x24>
 324:	eb 1a                	jmp    340 <strcmp+0x30>
 326:	66 90                	xchg   %ax,%ax
    p++, q++;
 328:	43                   	inc    %ebx
 329:	42                   	inc    %edx
  while(*p && *p == *q)
 32a:	0f b6 03             	movzbl (%ebx),%eax
 32d:	0f b6 0a             	movzbl (%edx),%ecx
 330:	84 c0                	test   %al,%al
 332:	74 0c                	je     340 <strcmp+0x30>
 334:	38 c8                	cmp    %cl,%al
 336:	74 f0                	je     328 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 338:	29 c8                	sub    %ecx,%eax
}
 33a:	5b                   	pop    %ebx
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
 340:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 342:	29 c8                	sub    %ecx,%eax
}
 344:	5b                   	pop    %ebx
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	90                   	nop

00000348 <strlen>:

uint
strlen(const char *s)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 34e:	80 3a 00             	cmpb   $0x0,(%edx)
 351:	74 15                	je     368 <strlen+0x20>
 353:	31 c0                	xor    %eax,%eax
 355:	8d 76 00             	lea    0x0(%esi),%esi
 358:	40                   	inc    %eax
 359:	89 c1                	mov    %eax,%ecx
 35b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 35f:	75 f7                	jne    358 <strlen+0x10>
    ;
  return n;
}
 361:	89 c8                	mov    %ecx,%eax
 363:	5d                   	pop    %ebp
 364:	c3                   	ret    
 365:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 368:	31 c9                	xor    %ecx,%ecx
}
 36a:	89 c8                	mov    %ecx,%eax
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    
 36e:	66 90                	xchg   %ax,%ax

00000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 374:	8b 7d 08             	mov    0x8(%ebp),%edi
 377:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	fc                   	cld    
 37e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	5f                   	pop    %edi
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    
 386:	66 90                	xchg   %ax,%ax

00000388 <strchr>:

char*
strchr(const char *s, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 391:	8a 10                	mov    (%eax),%dl
 393:	84 d2                	test   %dl,%dl
 395:	75 0c                	jne    3a3 <strchr+0x1b>
 397:	eb 13                	jmp    3ac <strchr+0x24>
 399:	8d 76 00             	lea    0x0(%esi),%esi
 39c:	40                   	inc    %eax
 39d:	8a 10                	mov    (%eax),%dl
 39f:	84 d2                	test   %dl,%dl
 3a1:	74 09                	je     3ac <strchr+0x24>
    if(*s == c)
 3a3:	38 d1                	cmp    %dl,%cl
 3a5:	75 f5                	jne    39c <strchr+0x14>
      return (char*)s;
  return 0;
}
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3ac:	31 c0                	xor    %eax,%eax
}
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b9:	8b 75 08             	mov    0x8(%ebp),%esi
 3bc:	bb 01 00 00 00       	mov    $0x1,%ebx
 3c1:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 3c3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c6:	eb 20                	jmp    3e8 <gets+0x38>
    cc = read(0, &c, 1);
 3c8:	50                   	push   %eax
 3c9:	6a 01                	push   $0x1
 3cb:	57                   	push   %edi
 3cc:	6a 00                	push   $0x0
 3ce:	e8 7b 01 00 00       	call   54e <read>
    if(cc < 1)
 3d3:	83 c4 10             	add    $0x10,%esp
 3d6:	85 c0                	test   %eax,%eax
 3d8:	7e 16                	jle    3f0 <gets+0x40>
      break;
    buf[i++] = c;
 3da:	8a 45 e7             	mov    -0x19(%ebp),%al
 3dd:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 3df:	46                   	inc    %esi
 3e0:	3c 0a                	cmp    $0xa,%al
 3e2:	74 0c                	je     3f0 <gets+0x40>
 3e4:	3c 0d                	cmp    $0xd,%al
 3e6:	74 08                	je     3f0 <gets+0x40>
  for(i=0; i+1 < max; ){
 3e8:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 3eb:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3ee:	7f d8                	jg     3c8 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 3f0:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5f                   	pop    %edi
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    
 3fe:	66 90                	xchg   %ax,%ax

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	pushl  0x8(%ebp)
 40d:	e8 64 01 00 00       	call   576 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
 419:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 41b:	83 ec 08             	sub    $0x8,%esp
 41e:	ff 75 0c             	pushl  0xc(%ebp)
 421:	50                   	push   %eax
 422:	e8 67 01 00 00       	call   58e <fstat>
 427:	89 c6                	mov    %eax,%esi
  close(fd);
 429:	89 1c 24             	mov    %ebx,(%esp)
 42c:	e8 2d 01 00 00       	call   55e <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	89 f0                	mov    %esi,%eax
 436:	8d 65 f8             	lea    -0x8(%ebp),%esp
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	90                   	nop

00000448 <atoi>:

int
atoi(const char *s)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	53                   	push   %ebx
 44c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44f:	0f be 01             	movsbl (%ecx),%eax
 452:	8d 50 d0             	lea    -0x30(%eax),%edx
 455:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 458:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 45d:	77 16                	ja     475 <atoi+0x2d>
 45f:	90                   	nop
    n = n*10 + *s++ - '0';
 460:	41                   	inc    %ecx
 461:	8d 14 92             	lea    (%edx,%edx,4),%edx
 464:	01 d2                	add    %edx,%edx
 466:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 46a:	0f be 01             	movsbl (%ecx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x18>
  return n;
}
 475:	89 d0                	mov    %edx,%eax
 477:	5b                   	pop    %ebx
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    
 47a:	66 90                	xchg   %ax,%ax

0000047c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	57                   	push   %edi
 480:	56                   	push   %esi
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	8b 75 0c             	mov    0xc(%ebp),%esi
 487:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48a:	85 d2                	test   %edx,%edx
 48c:	7e 0b                	jle    499 <memmove+0x1d>
 48e:	01 c2                	add    %eax,%edx
  dst = vdst;
 490:	89 c7                	mov    %eax,%edi
 492:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 494:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 495:	39 fa                	cmp    %edi,%edx
 497:	75 fb                	jne    494 <memmove+0x18>
  return vdst;
}
 499:	5e                   	pop    %esi
 49a:	5f                   	pop    %edi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    
 49d:	8d 76 00             	lea    0x0(%esi),%esi

000004a0 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 4ac:	5d                   	pop    %ebp
 4ad:	c3                   	ret    
 4ae:	66 90                	xchg   %ax,%ax

000004b0 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 4b6:	b9 01 00 00 00       	mov    $0x1,%ecx
 4bb:	90                   	nop
 4bc:	89 c8                	mov    %ecx,%eax
 4be:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 4c1:	85 c0                	test   %eax,%eax
 4c3:	75 f7                	jne    4bc <lock_acquire+0xc>
}
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    
 4c7:	90                   	nop

000004c8 <lock_release>:

void lock_release(lock_t *lock) {
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	8b 55 08             	mov    0x8(%ebp),%edx
 4ce:	31 c0                	xor    %eax,%eax
 4d0:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 4d3:	5d                   	pop    %ebp
 4d4:	c3                   	ret    
 4d5:	8d 76 00             	lea    0x0(%esi),%esi

000004d8 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 4de:	68 00 20 00 00       	push   $0x2000
 4e3:	e8 94 03 00 00       	call   87c <malloc>

  if((uint)stack % PGSIZE)
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	89 c2                	mov    %eax,%edx
 4ed:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 4f3:	74 07                	je     4fc <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 4f5:	29 d0                	sub    %edx,%eax
 4f7:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 4fc:	ff 75 0c             	pushl  0xc(%ebp)
 4ff:	6a 08                	push   $0x8
 501:	50                   	push   %eax
 502:	ff 75 08             	pushl  0x8(%ebp)
 505:	e8 cc 00 00 00       	call   5d6 <clone>

  if (tid < 0) {
 50a:	83 c4 10             	add    $0x10,%esp
 50d:	85 c0                	test   %eax,%eax
 50f:	78 07                	js     518 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 511:	31 c0                	xor    %eax,%eax
 513:	c9                   	leave  
 514:	c3                   	ret    
 515:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 518:	83 ec 08             	sub    $0x8,%esp
 51b:	68 be 09 00 00       	push   $0x9be
 520:	6a 01                	push   $0x1
 522:	e8 41 01 00 00       	call   668 <printf>
      return 0;
 527:	83 c4 10             	add    $0x10,%esp
}
 52a:	31 c0                	xor    %eax,%eax
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52e:	b8 01 00 00 00       	mov    $0x1,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <exit>:
SYSCALL(exit)
 536:	b8 02 00 00 00       	mov    $0x2,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <wait>:
SYSCALL(wait)
 53e:	b8 03 00 00 00       	mov    $0x3,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <pipe>:
SYSCALL(pipe)
 546:	b8 04 00 00 00       	mov    $0x4,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <read>:
SYSCALL(read)
 54e:	b8 05 00 00 00       	mov    $0x5,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <write>:
SYSCALL(write)
 556:	b8 10 00 00 00       	mov    $0x10,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <close>:
SYSCALL(close)
 55e:	b8 15 00 00 00       	mov    $0x15,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <kill>:
SYSCALL(kill)
 566:	b8 06 00 00 00       	mov    $0x6,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <exec>:
SYSCALL(exec)
 56e:	b8 07 00 00 00       	mov    $0x7,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <open>:
SYSCALL(open)
 576:	b8 0f 00 00 00       	mov    $0xf,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <mknod>:
SYSCALL(mknod)
 57e:	b8 11 00 00 00       	mov    $0x11,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <unlink>:
SYSCALL(unlink)
 586:	b8 12 00 00 00       	mov    $0x12,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <fstat>:
SYSCALL(fstat)
 58e:	b8 08 00 00 00       	mov    $0x8,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <link>:
SYSCALL(link)
 596:	b8 13 00 00 00       	mov    $0x13,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <mkdir>:
SYSCALL(mkdir)
 59e:	b8 14 00 00 00       	mov    $0x14,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <chdir>:
SYSCALL(chdir)
 5a6:	b8 09 00 00 00       	mov    $0x9,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <dup>:
SYSCALL(dup)
 5ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <getpid>:
SYSCALL(getpid)
 5b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <sbrk>:
SYSCALL(sbrk)
 5be:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <sleep>:
SYSCALL(sleep)
 5c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <uptime>:
SYSCALL(uptime)
 5ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <clone>:
 5d6:	b8 16 00 00 00       	mov    $0x16,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    
 5de:	66 90                	xchg   %ax,%ax

000005e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 3c             	sub    $0x3c,%esp
 5e9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 5ec:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5ef:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 5f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5f4:	85 db                	test   %ebx,%ebx
 5f6:	74 04                	je     5fc <printint+0x1c>
 5f8:	85 d2                	test   %edx,%edx
 5fa:	78 68                	js     664 <printint+0x84>
  neg = 0;
 5fc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 603:	31 ff                	xor    %edi,%edi
 605:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 608:	89 c8                	mov    %ecx,%eax
 60a:	31 d2                	xor    %edx,%edx
 60c:	f7 75 c4             	divl   -0x3c(%ebp)
 60f:	89 fb                	mov    %edi,%ebx
 611:	8d 7f 01             	lea    0x1(%edi),%edi
 614:	8a 92 d8 09 00 00    	mov    0x9d8(%edx),%dl
 61a:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 61e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 621:	89 c1                	mov    %eax,%ecx
 623:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 626:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 629:	76 dd                	jbe    608 <printint+0x28>
  if(neg)
 62b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 62e:	85 c9                	test   %ecx,%ecx
 630:	74 09                	je     63b <printint+0x5b>
    buf[i++] = '-';
 632:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 637:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 639:	b2 2d                	mov    $0x2d,%dl
 63b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 63f:	8b 7d bc             	mov    -0x44(%ebp),%edi
 642:	eb 03                	jmp    647 <printint+0x67>
 644:	8a 13                	mov    (%ebx),%dl
 646:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 647:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 64a:	50                   	push   %eax
 64b:	6a 01                	push   $0x1
 64d:	56                   	push   %esi
 64e:	57                   	push   %edi
 64f:	e8 02 ff ff ff       	call   556 <write>
  while(--i >= 0)
 654:	83 c4 10             	add    $0x10,%esp
 657:	39 de                	cmp    %ebx,%esi
 659:	75 e9                	jne    644 <printint+0x64>
}
 65b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65e:	5b                   	pop    %ebx
 65f:	5e                   	pop    %esi
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
 663:	90                   	nop
    x = -xx;
 664:	f7 d9                	neg    %ecx
 666:	eb 9b                	jmp    603 <printint+0x23>

00000668 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	57                   	push   %edi
 66c:	56                   	push   %esi
 66d:	53                   	push   %ebx
 66e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 671:	8b 75 0c             	mov    0xc(%ebp),%esi
 674:	8a 1e                	mov    (%esi),%bl
 676:	84 db                	test   %bl,%bl
 678:	0f 84 a3 00 00 00    	je     721 <printf+0xb9>
 67e:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 67f:	8d 45 10             	lea    0x10(%ebp),%eax
 682:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 685:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 687:	8d 7d e7             	lea    -0x19(%ebp),%edi
 68a:	eb 29                	jmp    6b5 <printf+0x4d>
 68c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 68f:	83 f8 25             	cmp    $0x25,%eax
 692:	0f 84 94 00 00 00    	je     72c <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 698:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 69b:	50                   	push   %eax
 69c:	6a 01                	push   $0x1
 69e:	57                   	push   %edi
 69f:	ff 75 08             	pushl  0x8(%ebp)
 6a2:	e8 af fe ff ff       	call   556 <write>
        putc(fd, c);
 6a7:	83 c4 10             	add    $0x10,%esp
 6aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6ad:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 6ae:	8a 5e ff             	mov    -0x1(%esi),%bl
 6b1:	84 db                	test   %bl,%bl
 6b3:	74 6c                	je     721 <printf+0xb9>
    c = fmt[i] & 0xff;
 6b5:	0f be cb             	movsbl %bl,%ecx
 6b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6bb:	85 d2                	test   %edx,%edx
 6bd:	74 cd                	je     68c <printf+0x24>
      }
    } else if(state == '%'){
 6bf:	83 fa 25             	cmp    $0x25,%edx
 6c2:	75 e9                	jne    6ad <printf+0x45>
      if(c == 'd'){
 6c4:	83 f8 64             	cmp    $0x64,%eax
 6c7:	0f 84 97 00 00 00    	je     764 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6cd:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6d3:	83 f9 70             	cmp    $0x70,%ecx
 6d6:	74 60                	je     738 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6d8:	83 f8 73             	cmp    $0x73,%eax
 6db:	0f 84 8f 00 00 00    	je     770 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e1:	83 f8 63             	cmp    $0x63,%eax
 6e4:	0f 84 d6 00 00 00    	je     7c0 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6ea:	83 f8 25             	cmp    $0x25,%eax
 6ed:	0f 84 c1 00 00 00    	je     7b4 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 6f7:	50                   	push   %eax
 6f8:	6a 01                	push   $0x1
 6fa:	57                   	push   %edi
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 53 fe ff ff       	call   556 <write>
        putc(fd, c);
 703:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 706:	83 c4 0c             	add    $0xc,%esp
 709:	6a 01                	push   $0x1
 70b:	57                   	push   %edi
 70c:	ff 75 08             	pushl  0x8(%ebp)
 70f:	e8 42 fe ff ff       	call   556 <write>
        putc(fd, c);
 714:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 717:	31 d2                	xor    %edx,%edx
 719:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 71a:	8a 5e ff             	mov    -0x1(%esi),%bl
 71d:	84 db                	test   %bl,%bl
 71f:	75 94                	jne    6b5 <printf+0x4d>
    }
  }
}
 721:	8d 65 f4             	lea    -0xc(%ebp),%esp
 724:	5b                   	pop    %ebx
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
 729:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 72c:	ba 25 00 00 00       	mov    $0x25,%edx
 731:	e9 77 ff ff ff       	jmp    6ad <printf+0x45>
 736:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 738:	83 ec 0c             	sub    $0xc,%esp
 73b:	6a 00                	push   $0x0
 73d:	b9 10 00 00 00       	mov    $0x10,%ecx
 742:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 745:	8b 13                	mov    (%ebx),%edx
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	e8 91 fe ff ff       	call   5e0 <printint>
        ap++;
 74f:	89 d8                	mov    %ebx,%eax
 751:	83 c0 04             	add    $0x4,%eax
 754:	89 45 d0             	mov    %eax,-0x30(%ebp)
 757:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75a:	31 d2                	xor    %edx,%edx
        ap++;
 75c:	e9 4c ff ff ff       	jmp    6ad <printf+0x45>
 761:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 764:	83 ec 0c             	sub    $0xc,%esp
 767:	6a 01                	push   $0x1
 769:	b9 0a 00 00 00       	mov    $0xa,%ecx
 76e:	eb d2                	jmp    742 <printf+0xda>
        s = (char*)*ap;
 770:	8b 45 d0             	mov    -0x30(%ebp),%eax
 773:	8b 18                	mov    (%eax),%ebx
        ap++;
 775:	83 c0 04             	add    $0x4,%eax
 778:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 77b:	85 db                	test   %ebx,%ebx
 77d:	74 65                	je     7e4 <printf+0x17c>
        while(*s != 0){
 77f:	8a 03                	mov    (%ebx),%al
 781:	84 c0                	test   %al,%al
 783:	74 70                	je     7f5 <printf+0x18d>
 785:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 788:	89 de                	mov    %ebx,%esi
 78a:	8b 5d 08             	mov    0x8(%ebp),%ebx
 78d:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 790:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 793:	50                   	push   %eax
 794:	6a 01                	push   $0x1
 796:	57                   	push   %edi
 797:	53                   	push   %ebx
 798:	e8 b9 fd ff ff       	call   556 <write>
          s++;
 79d:	46                   	inc    %esi
        while(*s != 0){
 79e:	8a 06                	mov    (%esi),%al
 7a0:	83 c4 10             	add    $0x10,%esp
 7a3:	84 c0                	test   %al,%al
 7a5:	75 e9                	jne    790 <printf+0x128>
 7a7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7aa:	31 d2                	xor    %edx,%edx
 7ac:	e9 fc fe ff ff       	jmp    6ad <printf+0x45>
 7b1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7b4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7b7:	52                   	push   %edx
 7b8:	e9 4c ff ff ff       	jmp    709 <printf+0xa1>
 7bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 7c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7c3:	8b 03                	mov    (%ebx),%eax
 7c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7c8:	51                   	push   %ecx
 7c9:	6a 01                	push   $0x1
 7cb:	57                   	push   %edi
 7cc:	ff 75 08             	pushl  0x8(%ebp)
 7cf:	e8 82 fd ff ff       	call   556 <write>
        ap++;
 7d4:	83 c3 04             	add    $0x4,%ebx
 7d7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7da:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7dd:	31 d2                	xor    %edx,%edx
 7df:	e9 c9 fe ff ff       	jmp    6ad <printf+0x45>
          s = "(null)";
 7e4:	bb ce 09 00 00       	mov    $0x9ce,%ebx
        while(*s != 0){
 7e9:	b0 28                	mov    $0x28,%al
 7eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ee:	89 de                	mov    %ebx,%esi
 7f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7f3:	eb 9b                	jmp    790 <printf+0x128>
      state = 0;
 7f5:	31 d2                	xor    %edx,%edx
 7f7:	e9 b1 fe ff ff       	jmp    6ad <printf+0x45>

000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	55                   	push   %ebp
 7fd:	89 e5                	mov    %esp,%ebp
 7ff:	57                   	push   %edi
 800:	56                   	push   %esi
 801:	53                   	push   %ebx
 802:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 805:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	a1 88 0d 00 00       	mov    0xd88,%eax
 80d:	8b 10                	mov    (%eax),%edx
 80f:	39 c8                	cmp    %ecx,%eax
 811:	73 11                	jae    824 <free+0x28>
 813:	90                   	nop
 814:	39 d1                	cmp    %edx,%ecx
 816:	72 14                	jb     82c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	39 d0                	cmp    %edx,%eax
 81a:	73 10                	jae    82c <free+0x30>
{
 81c:	89 d0                	mov    %edx,%eax
 81e:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	39 c8                	cmp    %ecx,%eax
 822:	72 f0                	jb     814 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	39 d0                	cmp    %edx,%eax
 826:	72 f4                	jb     81c <free+0x20>
 828:	39 d1                	cmp    %edx,%ecx
 82a:	73 f0                	jae    81c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 82c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 82f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 832:	39 fa                	cmp    %edi,%edx
 834:	74 1a                	je     850 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 836:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 839:	8b 50 04             	mov    0x4(%eax),%edx
 83c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 83f:	39 f1                	cmp    %esi,%ecx
 841:	74 24                	je     867 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 843:	89 08                	mov    %ecx,(%eax)
  freep = p;
 845:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 84a:	5b                   	pop    %ebx
 84b:	5e                   	pop    %esi
 84c:	5f                   	pop    %edi
 84d:	5d                   	pop    %ebp
 84e:	c3                   	ret    
 84f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 850:	03 72 04             	add    0x4(%edx),%esi
 853:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	8b 10                	mov    (%eax),%edx
 858:	8b 12                	mov    (%edx),%edx
 85a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 85d:	8b 50 04             	mov    0x4(%eax),%edx
 860:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 863:	39 f1                	cmp    %esi,%ecx
 865:	75 dc                	jne    843 <free+0x47>
    p->s.size += bp->s.size;
 867:	03 53 fc             	add    -0x4(%ebx),%edx
 86a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 870:	89 10                	mov    %edx,(%eax)
  freep = p;
 872:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 877:	5b                   	pop    %ebx
 878:	5e                   	pop    %esi
 879:	5f                   	pop    %edi
 87a:	5d                   	pop    %ebp
 87b:	c3                   	ret    

0000087c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87c:	55                   	push   %ebp
 87d:	89 e5                	mov    %esp,%ebp
 87f:	57                   	push   %edi
 880:	56                   	push   %esi
 881:	53                   	push   %ebx
 882:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	8d 70 07             	lea    0x7(%eax),%esi
 88b:	c1 ee 03             	shr    $0x3,%esi
 88e:	46                   	inc    %esi
  if((prevp = freep) == 0){
 88f:	8b 3d 88 0d 00 00    	mov    0xd88,%edi
 895:	85 ff                	test   %edi,%edi
 897:	0f 84 a3 00 00 00    	je     940 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89d:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 89f:	8b 48 04             	mov    0x4(%eax),%ecx
 8a2:	39 f1                	cmp    %esi,%ecx
 8a4:	73 67                	jae    90d <malloc+0x91>
 8a6:	89 f3                	mov    %esi,%ebx
 8a8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8ae:	0f 82 80 00 00 00    	jb     934 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 8b4:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8be:	eb 11                	jmp    8d1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c5:	39 f1                	cmp    %esi,%ecx
 8c7:	73 4b                	jae    914 <malloc+0x98>
 8c9:	8b 3d 88 0d 00 00    	mov    0xd88,%edi
 8cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d1:	39 c7                	cmp    %eax,%edi
 8d3:	75 eb                	jne    8c0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8db:	e8 de fc ff ff       	call   5be <sbrk>
  if(p == (char*)-1)
 8e0:	83 c4 10             	add    $0x10,%esp
 8e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e6:	74 1b                	je     903 <malloc+0x87>
  hp->s.size = nu;
 8e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	83 c0 08             	add    $0x8,%eax
 8f1:	50                   	push   %eax
 8f2:	e8 05 ff ff ff       	call   7fc <free>
  return freep;
 8f7:	a1 88 0d 00 00       	mov    0xd88,%eax
      if((p = morecore(nunits)) == 0)
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	85 c0                	test   %eax,%eax
 901:	75 bd                	jne    8c0 <malloc+0x44>
        return 0;
 903:	31 c0                	xor    %eax,%eax
  }
}
 905:	8d 65 f4             	lea    -0xc(%ebp),%esp
 908:	5b                   	pop    %ebx
 909:	5e                   	pop    %esi
 90a:	5f                   	pop    %edi
 90b:	5d                   	pop    %ebp
 90c:	c3                   	ret    
    if(p->s.size >= nunits){
 90d:	89 c2                	mov    %eax,%edx
 90f:	89 f8                	mov    %edi,%eax
 911:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 914:	39 ce                	cmp    %ecx,%esi
 916:	74 54                	je     96c <malloc+0xf0>
        p->s.size -= nunits;
 918:	29 f1                	sub    %esi,%ecx
 91a:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 91d:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 920:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 923:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 928:	8d 42 08             	lea    0x8(%edx),%eax
}
 92b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 92e:	5b                   	pop    %ebx
 92f:	5e                   	pop    %esi
 930:	5f                   	pop    %edi
 931:	5d                   	pop    %ebp
 932:	c3                   	ret    
 933:	90                   	nop
 934:	bb 00 10 00 00       	mov    $0x1000,%ebx
 939:	e9 76 ff ff ff       	jmp    8b4 <malloc+0x38>
 93e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 88 0d 00 00 8c 	movl   $0xd8c,0xd88
 947:	0d 00 00 
 94a:	c7 05 8c 0d 00 00 8c 	movl   $0xd8c,0xd8c
 951:	0d 00 00 
    base.s.size = 0;
 954:	c7 05 90 0d 00 00 00 	movl   $0x0,0xd90
 95b:	00 00 00 
 95e:	bf 8c 0d 00 00       	mov    $0xd8c,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 963:	89 f8                	mov    %edi,%eax
 965:	e9 3c ff ff ff       	jmp    8a6 <malloc+0x2a>
 96a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 96c:	8b 0a                	mov    (%edx),%ecx
 96e:	89 08                	mov    %ecx,(%eax)
 970:	eb b1                	jmp    923 <malloc+0xa7>

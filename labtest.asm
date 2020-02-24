
_labtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }

    exit();
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 28             	sub    $0x28,%esp
  13:	8b 19                	mov    (%ecx),%ebx
  15:	8b 71 04             	mov    0x4(%ecx),%esi
    lock_init(&lock);
  18:	68 34 0c 00 00       	push   $0xc34
  1d:	e8 0a 03 00 00       	call   32c <lock_init>

    if (argc != 3) {
  22:	83 c4 10             	add    $0x10,%esp
  25:	83 fb 03             	cmp    $0x3,%ebx
  28:	0f 84 87 00 00 00    	je     b5 <main+0xb5>
        thread_num = 4;
  2e:	c7 05 3c 0c 00 00 04 	movl   $0x4,0xc3c
  35:	00 00 00 
        pass_round = 6;
  38:	c7 05 20 0c 00 00 06 	movl   $0x6,0xc20
  3f:	00 00 00 
        printf(1, "# Default thread number: 4, pass round: 6\n");
  42:	51                   	push   %ecx
  43:	51                   	push   %ecx
  44:	68 48 08 00 00       	push   $0x848
  49:	6a 01                	push   $0x1
  4b:	e8 a4 04 00 00       	call   4f4 <printf>
  50:	83 c4 10             	add    $0x10,%esp
        thread_num = atoi(argv[1]);
        pass_round = atoi(argv[2]);
    }

    int i;
    uint arg = 0;
  53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for (i = 0; i < thread_num; i++) {  // i is tid
  5a:	a1 3c 0c 00 00       	mov    0xc3c,%eax
  5f:	85 c0                	test   %eax,%eax
  61:	7e 2e                	jle    91 <main+0x91>
  63:	31 db                	xor    %ebx,%ebx
  65:	8d 75 e4             	lea    -0x1c(%ebp),%esi
        arg = i + 1;
  68:	43                   	inc    %ebx
  69:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
        thread_create((void*)player, (void*)&arg);
  6c:	83 ec 08             	sub    $0x8,%esp
  6f:	56                   	push   %esi
  70:	68 dc 00 00 00       	push   $0xdc
  75:	e8 ea 02 00 00       	call   364 <thread_create>
        sleep(10);
  7a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  81:	e8 cc 03 00 00       	call   452 <sleep>
    for (i = 0; i < thread_num; i++) {  // i is tid
  86:	83 c4 10             	add    $0x10,%esp
  89:	3b 1d 3c 0c 00 00    	cmp    0xc3c,%ebx
  8f:	7c d7                	jl     68 <main+0x68>
    }
    sleep(40);
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	6a 28                	push   $0x28
  96:	e8 b7 03 00 00       	call   452 <sleep>
    
    // FIXME:
    printf(1, "# Simulation of Frisbee game has finished, %d rounds were played in total!\n", pass_round);
  9b:	83 c4 0c             	add    $0xc,%esp
  9e:	ff 35 20 0c 00 00    	pushl  0xc20
  a4:	68 74 08 00 00       	push   $0x874
  a9:	6a 01                	push   $0x1
  ab:	e8 44 04 00 00       	call   4f4 <printf>
    exit();
  b0:	e8 0d 03 00 00       	call   3c2 <exit>
        thread_num = atoi(argv[1]);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	ff 76 04             	pushl  0x4(%esi)
  bb:	e8 14 02 00 00       	call   2d4 <atoi>
  c0:	a3 3c 0c 00 00       	mov    %eax,0xc3c
        pass_round = atoi(argv[2]);
  c5:	5a                   	pop    %edx
  c6:	ff 76 08             	pushl  0x8(%esi)
  c9:	e8 06 02 00 00       	call   2d4 <atoi>
  ce:	a3 20 0c 00 00       	mov    %eax,0xc20
  d3:	83 c4 10             	add    $0x10,%esp
  d6:	e9 78 ff ff ff       	jmp    53 <main+0x53>
  db:	90                   	nop

000000dc <player>:
void player(void* arg) {
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	57                   	push   %edi
  e0:	56                   	push   %esi
  e1:	53                   	push   %ebx
  e2:	83 ec 0c             	sub    $0xc,%esp
    int tid = *(int*)arg;
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	8b 30                	mov    (%eax),%esi
    int pass_num = (tid <= pass_round % thread_num) ? (pass_round / thread_num + 1) : (pass_round / thread_num);
  ea:	a1 20 0c 00 00       	mov    0xc20,%eax
  ef:	99                   	cltd   
  f0:	f7 3d 3c 0c 00 00    	idivl  0xc3c
  f6:	89 c7                	mov    %eax,%edi
  f8:	39 f2                	cmp    %esi,%edx
  fa:	7c 01                	jl     fd <player+0x21>
  fc:	47                   	inc    %edi
    for (i = 0; i < pass_num; i++) {
  fd:	31 db                	xor    %ebx,%ebx
  ff:	85 ff                	test   %edi,%edi
 101:	7e 78                	jle    17b <player+0x9f>
 103:	90                   	nop
        if (thrower != tid) {
 104:	39 35 38 0c 00 00    	cmp    %esi,0xc38
 10a:	74 5d                	je     169 <player+0x8d>
            lock_acquire(&lock);
 10c:	83 ec 0c             	sub    $0xc,%esp
 10f:	68 34 0c 00 00       	push   $0xc34
 114:	e8 23 02 00 00       	call   33c <lock_acquire>
            pass_no++;
 119:	a1 24 0c 00 00       	mov    0xc24,%eax
 11e:	40                   	inc    %eax
 11f:	a3 24 0c 00 00       	mov    %eax,0xc24
            printf(1, "# Pass number no: %d | ", pass_no);
 124:	83 c4 0c             	add    $0xc,%esp
 127:	50                   	push   %eax
 128:	68 00 08 00 00       	push   $0x800
 12d:	6a 01                	push   $0x1
 12f:	e8 c0 03 00 00       	call   4f4 <printf>
            printf(1, "Thread %d is passing the token to thread %d\n", thrower, tid);
 134:	56                   	push   %esi
 135:	ff 35 38 0c 00 00    	pushl  0xc38
 13b:	68 18 08 00 00       	push   $0x818
 140:	6a 01                	push   $0x1
 142:	e8 ad 03 00 00       	call   4f4 <printf>
            thrower = tid;
 147:	89 35 38 0c 00 00    	mov    %esi,0xc38
            lock_release(&lock);
 14d:	83 c4 14             	add    $0x14,%esp
 150:	68 34 0c 00 00       	push   $0xc34
 155:	e8 fa 01 00 00       	call   354 <lock_release>
            sleep(20);
 15a:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 161:	e8 ec 02 00 00       	call   452 <sleep>
 166:	83 c4 10             	add    $0x10,%esp
        sleep(20);
 169:	83 ec 0c             	sub    $0xc,%esp
 16c:	6a 14                	push   $0x14
 16e:	e8 df 02 00 00       	call   452 <sleep>
    for (i = 0; i < pass_num; i++) {
 173:	43                   	inc    %ebx
 174:	83 c4 10             	add    $0x10,%esp
 177:	39 df                	cmp    %ebx,%edi
 179:	75 89                	jne    104 <player+0x28>
    exit();
 17b:	e8 42 02 00 00       	call   3c2 <exit>

00000180 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 4d 08             	mov    0x8(%ebp),%ecx
 187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18a:	31 c0                	xor    %eax,%eax
 18c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 18f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 192:	40                   	inc    %eax
 193:	84 d2                	test   %dl,%dl
 195:	75 f5                	jne    18c <strcpy+0xc>
    ;
  return os;
}
 197:	89 c8                	mov    %ecx,%eax
 199:	5b                   	pop    %ebx
 19a:	5d                   	pop    %ebp
 19b:	c3                   	ret    

0000019c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	53                   	push   %ebx
 1a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1a6:	0f b6 03             	movzbl (%ebx),%eax
 1a9:	0f b6 0a             	movzbl (%edx),%ecx
 1ac:	84 c0                	test   %al,%al
 1ae:	75 10                	jne    1c0 <strcmp+0x24>
 1b0:	eb 1a                	jmp    1cc <strcmp+0x30>
 1b2:	66 90                	xchg   %ax,%ax
    p++, q++;
 1b4:	43                   	inc    %ebx
 1b5:	42                   	inc    %edx
  while(*p && *p == *q)
 1b6:	0f b6 03             	movzbl (%ebx),%eax
 1b9:	0f b6 0a             	movzbl (%edx),%ecx
 1bc:	84 c0                	test   %al,%al
 1be:	74 0c                	je     1cc <strcmp+0x30>
 1c0:	38 c8                	cmp    %cl,%al
 1c2:	74 f0                	je     1b4 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1c4:	29 c8                	sub    %ecx,%eax
}
 1c6:	5b                   	pop    %ebx
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    
 1c9:	8d 76 00             	lea    0x0(%esi),%esi
 1cc:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1ce:	29 c8                	sub    %ecx,%eax
}
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	90                   	nop

000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1da:	80 3a 00             	cmpb   $0x0,(%edx)
 1dd:	74 15                	je     1f4 <strlen+0x20>
 1df:	31 c0                	xor    %eax,%eax
 1e1:	8d 76 00             	lea    0x0(%esi),%esi
 1e4:	40                   	inc    %eax
 1e5:	89 c1                	mov    %eax,%ecx
 1e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1eb:	75 f7                	jne    1e4 <strlen+0x10>
    ;
  return n;
}
 1ed:	89 c8                	mov    %ecx,%eax
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1f4:	31 c9                	xor    %ecx,%ecx
}
 1f6:	89 c8                	mov    %ecx,%eax
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	66 90                	xchg   %ax,%ax

000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 200:	8b 7d 08             	mov    0x8(%ebp),%edi
 203:	8b 4d 10             	mov    0x10(%ebp),%ecx
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	fc                   	cld    
 20a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	5f                   	pop    %edi
 210:	5d                   	pop    %ebp
 211:	c3                   	ret    
 212:	66 90                	xchg   %ax,%ax

00000214 <strchr>:

char*
strchr(const char *s, char c)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 21d:	8a 10                	mov    (%eax),%dl
 21f:	84 d2                	test   %dl,%dl
 221:	75 0c                	jne    22f <strchr+0x1b>
 223:	eb 13                	jmp    238 <strchr+0x24>
 225:	8d 76 00             	lea    0x0(%esi),%esi
 228:	40                   	inc    %eax
 229:	8a 10                	mov    (%eax),%dl
 22b:	84 d2                	test   %dl,%dl
 22d:	74 09                	je     238 <strchr+0x24>
    if(*s == c)
 22f:	38 d1                	cmp    %dl,%cl
 231:	75 f5                	jne    228 <strchr+0x14>
      return (char*)s;
  return 0;
}
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 238:	31 c0                	xor    %eax,%eax
}
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    

0000023c <gets>:

char*
gets(char *buf, int max)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	57                   	push   %edi
 240:	56                   	push   %esi
 241:	53                   	push   %ebx
 242:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 245:	8b 75 08             	mov    0x8(%ebp),%esi
 248:	bb 01 00 00 00       	mov    $0x1,%ebx
 24d:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 24f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 252:	eb 20                	jmp    274 <gets+0x38>
    cc = read(0, &c, 1);
 254:	50                   	push   %eax
 255:	6a 01                	push   $0x1
 257:	57                   	push   %edi
 258:	6a 00                	push   $0x0
 25a:	e8 7b 01 00 00       	call   3da <read>
    if(cc < 1)
 25f:	83 c4 10             	add    $0x10,%esp
 262:	85 c0                	test   %eax,%eax
 264:	7e 16                	jle    27c <gets+0x40>
      break;
    buf[i++] = c;
 266:	8a 45 e7             	mov    -0x19(%ebp),%al
 269:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 26b:	46                   	inc    %esi
 26c:	3c 0a                	cmp    $0xa,%al
 26e:	74 0c                	je     27c <gets+0x40>
 270:	3c 0d                	cmp    $0xd,%al
 272:	74 08                	je     27c <gets+0x40>
  for(i=0; i+1 < max; ){
 274:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 277:	39 45 0c             	cmp    %eax,0xc(%ebp)
 27a:	7f d8                	jg     254 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 27c:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	8d 65 f4             	lea    -0xc(%ebp),%esp
 285:	5b                   	pop    %ebx
 286:	5e                   	pop    %esi
 287:	5f                   	pop    %edi
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	66 90                	xchg   %ax,%ax

0000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	56                   	push   %esi
 290:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 291:	83 ec 08             	sub    $0x8,%esp
 294:	6a 00                	push   $0x0
 296:	ff 75 08             	pushl  0x8(%ebp)
 299:	e8 64 01 00 00       	call   402 <open>
  if(fd < 0)
 29e:	83 c4 10             	add    $0x10,%esp
 2a1:	85 c0                	test   %eax,%eax
 2a3:	78 27                	js     2cc <stat+0x40>
 2a5:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2a7:	83 ec 08             	sub    $0x8,%esp
 2aa:	ff 75 0c             	pushl  0xc(%ebp)
 2ad:	50                   	push   %eax
 2ae:	e8 67 01 00 00       	call   41a <fstat>
 2b3:	89 c6                	mov    %eax,%esi
  close(fd);
 2b5:	89 1c 24             	mov    %ebx,(%esp)
 2b8:	e8 2d 01 00 00       	call   3ea <close>
  return r;
 2bd:	83 c4 10             	add    $0x10,%esp
}
 2c0:	89 f0                	mov    %esi,%eax
 2c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    
 2c9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2cc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d1:	eb ed                	jmp    2c0 <stat+0x34>
 2d3:	90                   	nop

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	53                   	push   %ebx
 2d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2db:	0f be 01             	movsbl (%ecx),%eax
 2de:	8d 50 d0             	lea    -0x30(%eax),%edx
 2e1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2e4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2e9:	77 16                	ja     301 <atoi+0x2d>
 2eb:	90                   	nop
    n = n*10 + *s++ - '0';
 2ec:	41                   	inc    %ecx
 2ed:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2f0:	01 d2                	add    %edx,%edx
 2f2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2f6:	0f be 01             	movsbl (%ecx),%eax
 2f9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2fc:	80 fb 09             	cmp    $0x9,%bl
 2ff:	76 eb                	jbe    2ec <atoi+0x18>
  return n;
}
 301:	89 d0                	mov    %edx,%eax
 303:	5b                   	pop    %ebx
 304:	5d                   	pop    %ebp
 305:	c3                   	ret    
 306:	66 90                	xchg   %ax,%ax

00000308 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	57                   	push   %edi
 30c:	56                   	push   %esi
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8b 75 0c             	mov    0xc(%ebp),%esi
 313:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 316:	85 d2                	test   %edx,%edx
 318:	7e 0b                	jle    325 <memmove+0x1d>
 31a:	01 c2                	add    %eax,%edx
  dst = vdst;
 31c:	89 c7                	mov    %eax,%edi
 31e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 320:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 321:	39 fa                	cmp    %edi,%edx
 323:	75 fb                	jne    320 <memmove+0x18>
  return vdst;
}
 325:	5e                   	pop    %esi
 326:	5f                   	pop    %edi
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    
 329:	8d 76 00             	lea    0x0(%esi),%esi

0000032c <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	66 90                	xchg   %ax,%ax

0000033c <lock_acquire>:

void lock_acquire(lock_t *lock) {
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 342:	b9 01 00 00 00       	mov    $0x1,%ecx
 347:	90                   	nop
 348:	89 c8                	mov    %ecx,%eax
 34a:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 34d:	85 c0                	test   %eax,%eax
 34f:	75 f7                	jne    348 <lock_acquire+0xc>
}
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	90                   	nop

00000354 <lock_release>:

void lock_release(lock_t *lock) {
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	8b 55 08             	mov    0x8(%ebp),%edx
 35a:	31 c0                	xor    %eax,%eax
 35c:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	8d 76 00             	lea    0x0(%esi),%esi

00000364 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 36a:	68 00 20 00 00       	push   $0x2000
 36f:	e8 94 03 00 00       	call   708 <malloc>

  if((uint)stack % PGSIZE)
 374:	83 c4 10             	add    $0x10,%esp
 377:	89 c2                	mov    %eax,%edx
 379:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 37f:	74 07                	je     388 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 381:	29 d0                	sub    %edx,%eax
 383:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 388:	ff 75 0c             	pushl  0xc(%ebp)
 38b:	6a 08                	push   $0x8
 38d:	50                   	push   %eax
 38e:	ff 75 08             	pushl  0x8(%ebp)
 391:	e8 cc 00 00 00       	call   462 <clone>

  if (tid < 0) {
 396:	83 c4 10             	add    $0x10,%esp
 399:	85 c0                	test   %eax,%eax
 39b:	78 07                	js     3a4 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 39d:	31 c0                	xor    %eax,%eax
 39f:	c9                   	leave  
 3a0:	c3                   	ret    
 3a1:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 3a4:	83 ec 08             	sub    $0x8,%esp
 3a7:	68 c0 08 00 00       	push   $0x8c0
 3ac:	6a 01                	push   $0x1
 3ae:	e8 41 01 00 00       	call   4f4 <printf>
      return 0;
 3b3:	83 c4 10             	add    $0x10,%esp
}
 3b6:	31 c0                	xor    %eax,%eax
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ba:	b8 01 00 00 00       	mov    $0x1,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <exit>:
SYSCALL(exit)
 3c2:	b8 02 00 00 00       	mov    $0x2,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <wait>:
SYSCALL(wait)
 3ca:	b8 03 00 00 00       	mov    $0x3,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <pipe>:
SYSCALL(pipe)
 3d2:	b8 04 00 00 00       	mov    $0x4,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <read>:
SYSCALL(read)
 3da:	b8 05 00 00 00       	mov    $0x5,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <write>:
SYSCALL(write)
 3e2:	b8 10 00 00 00       	mov    $0x10,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <close>:
SYSCALL(close)
 3ea:	b8 15 00 00 00       	mov    $0x15,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <kill>:
SYSCALL(kill)
 3f2:	b8 06 00 00 00       	mov    $0x6,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <exec>:
SYSCALL(exec)
 3fa:	b8 07 00 00 00       	mov    $0x7,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <open>:
SYSCALL(open)
 402:	b8 0f 00 00 00       	mov    $0xf,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <mknod>:
SYSCALL(mknod)
 40a:	b8 11 00 00 00       	mov    $0x11,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <unlink>:
SYSCALL(unlink)
 412:	b8 12 00 00 00       	mov    $0x12,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <fstat>:
SYSCALL(fstat)
 41a:	b8 08 00 00 00       	mov    $0x8,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <link>:
SYSCALL(link)
 422:	b8 13 00 00 00       	mov    $0x13,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <mkdir>:
SYSCALL(mkdir)
 42a:	b8 14 00 00 00       	mov    $0x14,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <chdir>:
SYSCALL(chdir)
 432:	b8 09 00 00 00       	mov    $0x9,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <dup>:
SYSCALL(dup)
 43a:	b8 0a 00 00 00       	mov    $0xa,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <getpid>:
SYSCALL(getpid)
 442:	b8 0b 00 00 00       	mov    $0xb,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sbrk>:
SYSCALL(sbrk)
 44a:	b8 0c 00 00 00       	mov    $0xc,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <sleep>:
SYSCALL(sleep)
 452:	b8 0d 00 00 00       	mov    $0xd,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <uptime>:
SYSCALL(uptime)
 45a:	b8 0e 00 00 00       	mov    $0xe,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <clone>:
 462:	b8 16 00 00 00       	mov    $0x16,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    
 46a:	66 90                	xchg   %ax,%ax

0000046c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	57                   	push   %edi
 470:	56                   	push   %esi
 471:	53                   	push   %ebx
 472:	83 ec 3c             	sub    $0x3c,%esp
 475:	89 45 bc             	mov    %eax,-0x44(%ebp)
 478:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 47b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 47d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 480:	85 db                	test   %ebx,%ebx
 482:	74 04                	je     488 <printint+0x1c>
 484:	85 d2                	test   %edx,%edx
 486:	78 68                	js     4f0 <printint+0x84>
  neg = 0;
 488:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 48f:	31 ff                	xor    %edi,%edi
 491:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 494:	89 c8                	mov    %ecx,%eax
 496:	31 d2                	xor    %edx,%edx
 498:	f7 75 c4             	divl   -0x3c(%ebp)
 49b:	89 fb                	mov    %edi,%ebx
 49d:	8d 7f 01             	lea    0x1(%edi),%edi
 4a0:	8a 92 d8 08 00 00    	mov    0x8d8(%edx),%dl
 4a6:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 4aa:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 4ad:	89 c1                	mov    %eax,%ecx
 4af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4b2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 4b5:	76 dd                	jbe    494 <printint+0x28>
  if(neg)
 4b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4ba:	85 c9                	test   %ecx,%ecx
 4bc:	74 09                	je     4c7 <printint+0x5b>
    buf[i++] = '-';
 4be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 4c3:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 4c5:	b2 2d                	mov    $0x2d,%dl
 4c7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 4cb:	8b 7d bc             	mov    -0x44(%ebp),%edi
 4ce:	eb 03                	jmp    4d3 <printint+0x67>
 4d0:	8a 13                	mov    (%ebx),%dl
 4d2:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 4d3:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 4d6:	50                   	push   %eax
 4d7:	6a 01                	push   $0x1
 4d9:	56                   	push   %esi
 4da:	57                   	push   %edi
 4db:	e8 02 ff ff ff       	call   3e2 <write>
  while(--i >= 0)
 4e0:	83 c4 10             	add    $0x10,%esp
 4e3:	39 de                	cmp    %ebx,%esi
 4e5:	75 e9                	jne    4d0 <printint+0x64>
}
 4e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ea:	5b                   	pop    %ebx
 4eb:	5e                   	pop    %esi
 4ec:	5f                   	pop    %edi
 4ed:	5d                   	pop    %ebp
 4ee:	c3                   	ret    
 4ef:	90                   	nop
    x = -xx;
 4f0:	f7 d9                	neg    %ecx
 4f2:	eb 9b                	jmp    48f <printint+0x23>

000004f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	56                   	push   %esi
 4f9:	53                   	push   %ebx
 4fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 500:	8a 1e                	mov    (%esi),%bl
 502:	84 db                	test   %bl,%bl
 504:	0f 84 a3 00 00 00    	je     5ad <printf+0xb9>
 50a:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 50b:	8d 45 10             	lea    0x10(%ebp),%eax
 50e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 511:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 513:	8d 7d e7             	lea    -0x19(%ebp),%edi
 516:	eb 29                	jmp    541 <printf+0x4d>
 518:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 51b:	83 f8 25             	cmp    $0x25,%eax
 51e:	0f 84 94 00 00 00    	je     5b8 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 524:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 527:	50                   	push   %eax
 528:	6a 01                	push   $0x1
 52a:	57                   	push   %edi
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 af fe ff ff       	call   3e2 <write>
        putc(fd, c);
 533:	83 c4 10             	add    $0x10,%esp
 536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 539:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 53a:	8a 5e ff             	mov    -0x1(%esi),%bl
 53d:	84 db                	test   %bl,%bl
 53f:	74 6c                	je     5ad <printf+0xb9>
    c = fmt[i] & 0xff;
 541:	0f be cb             	movsbl %bl,%ecx
 544:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 547:	85 d2                	test   %edx,%edx
 549:	74 cd                	je     518 <printf+0x24>
      }
    } else if(state == '%'){
 54b:	83 fa 25             	cmp    $0x25,%edx
 54e:	75 e9                	jne    539 <printf+0x45>
      if(c == 'd'){
 550:	83 f8 64             	cmp    $0x64,%eax
 553:	0f 84 97 00 00 00    	je     5f0 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 559:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 55f:	83 f9 70             	cmp    $0x70,%ecx
 562:	74 60                	je     5c4 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 564:	83 f8 73             	cmp    $0x73,%eax
 567:	0f 84 8f 00 00 00    	je     5fc <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56d:	83 f8 63             	cmp    $0x63,%eax
 570:	0f 84 d6 00 00 00    	je     64c <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 576:	83 f8 25             	cmp    $0x25,%eax
 579:	0f 84 c1 00 00 00    	je     640 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 583:	50                   	push   %eax
 584:	6a 01                	push   $0x1
 586:	57                   	push   %edi
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 53 fe ff ff       	call   3e2 <write>
        putc(fd, c);
 58f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 592:	83 c4 0c             	add    $0xc,%esp
 595:	6a 01                	push   $0x1
 597:	57                   	push   %edi
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 42 fe ff ff       	call   3e2 <write>
        putc(fd, c);
 5a0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a3:	31 d2                	xor    %edx,%edx
 5a5:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 5a6:	8a 5e ff             	mov    -0x1(%esi),%bl
 5a9:	84 db                	test   %bl,%bl
 5ab:	75 94                	jne    541 <printf+0x4d>
    }
  }
}
 5ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5f                   	pop    %edi
 5b3:	5d                   	pop    %ebp
 5b4:	c3                   	ret    
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 5b8:	ba 25 00 00 00       	mov    $0x25,%edx
 5bd:	e9 77 ff ff ff       	jmp    539 <printf+0x45>
 5c2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5c4:	83 ec 0c             	sub    $0xc,%esp
 5c7:	6a 00                	push   $0x0
 5c9:	b9 10 00 00 00       	mov    $0x10,%ecx
 5ce:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5d1:	8b 13                	mov    (%ebx),%edx
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	e8 91 fe ff ff       	call   46c <printint>
        ap++;
 5db:	89 d8                	mov    %ebx,%eax
 5dd:	83 c0 04             	add    $0x4,%eax
 5e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5e3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e6:	31 d2                	xor    %edx,%edx
        ap++;
 5e8:	e9 4c ff ff ff       	jmp    539 <printf+0x45>
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	6a 01                	push   $0x1
 5f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5fa:	eb d2                	jmp    5ce <printf+0xda>
        s = (char*)*ap;
 5fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5ff:	8b 18                	mov    (%eax),%ebx
        ap++;
 601:	83 c0 04             	add    $0x4,%eax
 604:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 607:	85 db                	test   %ebx,%ebx
 609:	74 65                	je     670 <printf+0x17c>
        while(*s != 0){
 60b:	8a 03                	mov    (%ebx),%al
 60d:	84 c0                	test   %al,%al
 60f:	74 70                	je     681 <printf+0x18d>
 611:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 614:	89 de                	mov    %ebx,%esi
 616:	8b 5d 08             	mov    0x8(%ebp),%ebx
 619:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 61c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 61f:	50                   	push   %eax
 620:	6a 01                	push   $0x1
 622:	57                   	push   %edi
 623:	53                   	push   %ebx
 624:	e8 b9 fd ff ff       	call   3e2 <write>
          s++;
 629:	46                   	inc    %esi
        while(*s != 0){
 62a:	8a 06                	mov    (%esi),%al
 62c:	83 c4 10             	add    $0x10,%esp
 62f:	84 c0                	test   %al,%al
 631:	75 e9                	jne    61c <printf+0x128>
 633:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 636:	31 d2                	xor    %edx,%edx
 638:	e9 fc fe ff ff       	jmp    539 <printf+0x45>
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 640:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 643:	52                   	push   %edx
 644:	e9 4c ff ff ff       	jmp    595 <printf+0xa1>
 649:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 64c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 64f:	8b 03                	mov    (%ebx),%eax
 651:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 654:	51                   	push   %ecx
 655:	6a 01                	push   $0x1
 657:	57                   	push   %edi
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 82 fd ff ff       	call   3e2 <write>
        ap++;
 660:	83 c3 04             	add    $0x4,%ebx
 663:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 666:	83 c4 10             	add    $0x10,%esp
      state = 0;
 669:	31 d2                	xor    %edx,%edx
 66b:	e9 c9 fe ff ff       	jmp    539 <printf+0x45>
          s = "(null)";
 670:	bb d0 08 00 00       	mov    $0x8d0,%ebx
        while(*s != 0){
 675:	b0 28                	mov    $0x28,%al
 677:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 67a:	89 de                	mov    %ebx,%esi
 67c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 67f:	eb 9b                	jmp    61c <printf+0x128>
      state = 0;
 681:	31 d2                	xor    %edx,%edx
 683:	e9 b1 fe ff ff       	jmp    539 <printf+0x45>

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	57                   	push   %edi
 68c:	56                   	push   %esi
 68d:	53                   	push   %ebx
 68e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 691:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	a1 28 0c 00 00       	mov    0xc28,%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	39 c8                	cmp    %ecx,%eax
 69d:	73 11                	jae    6b0 <free+0x28>
 69f:	90                   	nop
 6a0:	39 d1                	cmp    %edx,%ecx
 6a2:	72 14                	jb     6b8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	39 d0                	cmp    %edx,%eax
 6a6:	73 10                	jae    6b8 <free+0x30>
{
 6a8:	89 d0                	mov    %edx,%eax
 6aa:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	39 c8                	cmp    %ecx,%eax
 6ae:	72 f0                	jb     6a0 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 f4                	jb     6a8 <free+0x20>
 6b4:	39 d1                	cmp    %edx,%ecx
 6b6:	73 f0                	jae    6a8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6be:	39 fa                	cmp    %edi,%edx
 6c0:	74 1a                	je     6dc <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6cb:	39 f1                	cmp    %esi,%ecx
 6cd:	74 24                	je     6f3 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6d1:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 6d6:	5b                   	pop    %ebx
 6d7:	5e                   	pop    %esi
 6d8:	5f                   	pop    %edi
 6d9:	5d                   	pop    %ebp
 6da:	c3                   	ret    
 6db:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6dc:	03 72 04             	add    0x4(%edx),%esi
 6df:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 12                	mov    (%edx),%edx
 6e6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6e9:	8b 50 04             	mov    0x4(%eax),%edx
 6ec:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ef:	39 f1                	cmp    %esi,%ecx
 6f1:	75 dc                	jne    6cf <free+0x47>
    p->s.size += bp->s.size;
 6f3:	03 53 fc             	add    -0x4(%ebx),%edx
 6f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6fc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fe:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 703:	5b                   	pop    %ebx
 704:	5e                   	pop    %esi
 705:	5f                   	pop    %edi
 706:	5d                   	pop    %ebp
 707:	c3                   	ret    

00000708 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 708:	55                   	push   %ebp
 709:	89 e5                	mov    %esp,%ebp
 70b:	57                   	push   %edi
 70c:	56                   	push   %esi
 70d:	53                   	push   %ebx
 70e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	8d 70 07             	lea    0x7(%eax),%esi
 717:	c1 ee 03             	shr    $0x3,%esi
 71a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 71b:	8b 3d 28 0c 00 00    	mov    0xc28,%edi
 721:	85 ff                	test   %edi,%edi
 723:	0f 84 a3 00 00 00    	je     7cc <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 729:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 72b:	8b 48 04             	mov    0x4(%eax),%ecx
 72e:	39 f1                	cmp    %esi,%ecx
 730:	73 67                	jae    799 <malloc+0x91>
 732:	89 f3                	mov    %esi,%ebx
 734:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 73a:	0f 82 80 00 00 00    	jb     7c0 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 740:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 74a:	eb 11                	jmp    75d <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74c:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 74e:	8b 4a 04             	mov    0x4(%edx),%ecx
 751:	39 f1                	cmp    %esi,%ecx
 753:	73 4b                	jae    7a0 <malloc+0x98>
 755:	8b 3d 28 0c 00 00    	mov    0xc28,%edi
 75b:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 75d:	39 c7                	cmp    %eax,%edi
 75f:	75 eb                	jne    74c <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 761:	83 ec 0c             	sub    $0xc,%esp
 764:	ff 75 e4             	pushl  -0x1c(%ebp)
 767:	e8 de fc ff ff       	call   44a <sbrk>
  if(p == (char*)-1)
 76c:	83 c4 10             	add    $0x10,%esp
 76f:	83 f8 ff             	cmp    $0xffffffff,%eax
 772:	74 1b                	je     78f <malloc+0x87>
  hp->s.size = nu;
 774:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 777:	83 ec 0c             	sub    $0xc,%esp
 77a:	83 c0 08             	add    $0x8,%eax
 77d:	50                   	push   %eax
 77e:	e8 05 ff ff ff       	call   688 <free>
  return freep;
 783:	a1 28 0c 00 00       	mov    0xc28,%eax
      if((p = morecore(nunits)) == 0)
 788:	83 c4 10             	add    $0x10,%esp
 78b:	85 c0                	test   %eax,%eax
 78d:	75 bd                	jne    74c <malloc+0x44>
        return 0;
 78f:	31 c0                	xor    %eax,%eax
  }
}
 791:	8d 65 f4             	lea    -0xc(%ebp),%esp
 794:	5b                   	pop    %ebx
 795:	5e                   	pop    %esi
 796:	5f                   	pop    %edi
 797:	5d                   	pop    %ebp
 798:	c3                   	ret    
    if(p->s.size >= nunits){
 799:	89 c2                	mov    %eax,%edx
 79b:	89 f8                	mov    %edi,%eax
 79d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7a0:	39 ce                	cmp    %ecx,%esi
 7a2:	74 54                	je     7f8 <malloc+0xf0>
        p->s.size -= nunits;
 7a4:	29 f1                	sub    %esi,%ecx
 7a6:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 7a9:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 7ac:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 7af:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 7b4:	8d 42 08             	lea    0x8(%edx),%eax
}
 7b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ba:	5b                   	pop    %ebx
 7bb:	5e                   	pop    %esi
 7bc:	5f                   	pop    %edi
 7bd:	5d                   	pop    %ebp
 7be:	c3                   	ret    
 7bf:	90                   	nop
 7c0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7c5:	e9 76 ff ff ff       	jmp    740 <malloc+0x38>
 7ca:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 7cc:	c7 05 28 0c 00 00 2c 	movl   $0xc2c,0xc28
 7d3:	0c 00 00 
 7d6:	c7 05 2c 0c 00 00 2c 	movl   $0xc2c,0xc2c
 7dd:	0c 00 00 
    base.s.size = 0;
 7e0:	c7 05 30 0c 00 00 00 	movl   $0x0,0xc30
 7e7:	00 00 00 
 7ea:	bf 2c 0c 00 00       	mov    $0xc2c,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	89 f8                	mov    %edi,%eax
 7f1:	e9 3c ff ff ff       	jmp    732 <malloc+0x2a>
 7f6:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 7f8:	8b 0a                	mov    (%edx),%ecx
 7fa:	89 08                	mov    %ecx,(%eax)
 7fc:	eb b1                	jmp    7af <malloc+0xa7>

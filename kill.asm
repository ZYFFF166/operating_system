
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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
  1b:	7e 28                	jle    45 <main+0x45>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 33                	pushl  (%ebx)
  29:	e8 7e 01 00 00       	call   1ac <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 94 02 00 00       	call   2ca <kill>
  36:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
  39:	83 c4 10             	add    $0x10,%esp
  3c:	39 f3                	cmp    %esi,%ebx
  3e:	75 e4                	jne    24 <main+0x24>
  exit();
  40:	e8 55 02 00 00       	call   29a <exit>
    printf(2, "usage: kill pid...\n");
  45:	50                   	push   %eax
  46:	50                   	push   %eax
  47:	68 d8 06 00 00       	push   $0x6d8
  4c:	6a 02                	push   $0x2
  4e:	e8 79 03 00 00       	call   3cc <printf>
    exit();
  53:	e8 42 02 00 00       	call   29a <exit>

00000058 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	31 c0                	xor    %eax,%eax
  64:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  67:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6a:	40                   	inc    %eax
  6b:	84 d2                	test   %dl,%dl
  6d:	75 f5                	jne    64 <strcpy+0xc>
    ;
  return os;
}
  6f:	89 c8                	mov    %ecx,%eax
  71:	5b                   	pop    %ebx
  72:	5d                   	pop    %ebp
  73:	c3                   	ret    

00000074 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	53                   	push   %ebx
  78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7e:	0f b6 03             	movzbl (%ebx),%eax
  81:	0f b6 0a             	movzbl (%edx),%ecx
  84:	84 c0                	test   %al,%al
  86:	75 10                	jne    98 <strcmp+0x24>
  88:	eb 1a                	jmp    a4 <strcmp+0x30>
  8a:	66 90                	xchg   %ax,%ax
    p++, q++;
  8c:	43                   	inc    %ebx
  8d:	42                   	inc    %edx
  while(*p && *p == *q)
  8e:	0f b6 03             	movzbl (%ebx),%eax
  91:	0f b6 0a             	movzbl (%edx),%ecx
  94:	84 c0                	test   %al,%al
  96:	74 0c                	je     a4 <strcmp+0x30>
  98:	38 c8                	cmp    %cl,%al
  9a:	74 f0                	je     8c <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  9c:	29 c8                	sub    %ecx,%eax
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	8d 76 00             	lea    0x0(%esi),%esi
  a4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  a6:	29 c8                	sub    %ecx,%eax
}
  a8:	5b                   	pop    %ebx
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    
  ab:	90                   	nop

000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b2:	80 3a 00             	cmpb   $0x0,(%edx)
  b5:	74 15                	je     cc <strlen+0x20>
  b7:	31 c0                	xor    %eax,%eax
  b9:	8d 76 00             	lea    0x0(%esi),%esi
  bc:	40                   	inc    %eax
  bd:	89 c1                	mov    %eax,%ecx
  bf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c3:	75 f7                	jne    bc <strlen+0x10>
    ;
  return n;
}
  c5:	89 c8                	mov    %ecx,%eax
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  cc:	31 c9                	xor    %ecx,%ecx
}
  ce:	89 c8                	mov    %ecx,%eax
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    
  d2:	66 90                	xchg   %ax,%ax

000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	fc                   	cld    
  e2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    
  ea:	66 90                	xchg   %ax,%ax

000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f5:	8a 10                	mov    (%eax),%dl
  f7:	84 d2                	test   %dl,%dl
  f9:	75 0c                	jne    107 <strchr+0x1b>
  fb:	eb 13                	jmp    110 <strchr+0x24>
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	40                   	inc    %eax
 101:	8a 10                	mov    (%eax),%dl
 103:	84 d2                	test   %dl,%dl
 105:	74 09                	je     110 <strchr+0x24>
    if(*s == c)
 107:	38 d1                	cmp    %dl,%cl
 109:	75 f5                	jne    100 <strchr+0x14>
      return (char*)s;
  return 0;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <gets>:

char*
gets(char *buf, int max)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11d:	8b 75 08             	mov    0x8(%ebp),%esi
 120:	bb 01 00 00 00       	mov    $0x1,%ebx
 125:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 127:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12a:	eb 20                	jmp    14c <gets+0x38>
    cc = read(0, &c, 1);
 12c:	50                   	push   %eax
 12d:	6a 01                	push   $0x1
 12f:	57                   	push   %edi
 130:	6a 00                	push   $0x0
 132:	e8 7b 01 00 00       	call   2b2 <read>
    if(cc < 1)
 137:	83 c4 10             	add    $0x10,%esp
 13a:	85 c0                	test   %eax,%eax
 13c:	7e 16                	jle    154 <gets+0x40>
      break;
    buf[i++] = c;
 13e:	8a 45 e7             	mov    -0x19(%ebp),%al
 141:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 143:	46                   	inc    %esi
 144:	3c 0a                	cmp    $0xa,%al
 146:	74 0c                	je     154 <gets+0x40>
 148:	3c 0d                	cmp    $0xd,%al
 14a:	74 08                	je     154 <gets+0x40>
  for(i=0; i+1 < max; ){
 14c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 14f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 152:	7f d8                	jg     12c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 154:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15d:	5b                   	pop    %ebx
 15e:	5e                   	pop    %esi
 15f:	5f                   	pop    %edi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    
 162:	66 90                	xchg   %ax,%ax

00000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	56                   	push   %esi
 168:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	6a 00                	push   $0x0
 16e:	ff 75 08             	pushl  0x8(%ebp)
 171:	e8 64 01 00 00       	call   2da <open>
  if(fd < 0)
 176:	83 c4 10             	add    $0x10,%esp
 179:	85 c0                	test   %eax,%eax
 17b:	78 27                	js     1a4 <stat+0x40>
 17d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	ff 75 0c             	pushl  0xc(%ebp)
 185:	50                   	push   %eax
 186:	e8 67 01 00 00       	call   2f2 <fstat>
 18b:	89 c6                	mov    %eax,%esi
  close(fd);
 18d:	89 1c 24             	mov    %ebx,(%esp)
 190:	e8 2d 01 00 00       	call   2c2 <close>
  return r;
 195:	83 c4 10             	add    $0x10,%esp
}
 198:	89 f0                	mov    %esi,%eax
 19a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
 1a1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1a4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a9:	eb ed                	jmp    198 <stat+0x34>
 1ab:	90                   	nop

000001ac <atoi>:

int
atoi(const char *s)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	53                   	push   %ebx
 1b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b3:	0f be 01             	movsbl (%ecx),%eax
 1b6:	8d 50 d0             	lea    -0x30(%eax),%edx
 1b9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1bc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c1:	77 16                	ja     1d9 <atoi+0x2d>
 1c3:	90                   	nop
    n = n*10 + *s++ - '0';
 1c4:	41                   	inc    %ecx
 1c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1c8:	01 d2                	add    %edx,%edx
 1ca:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1ce:	0f be 01             	movsbl (%ecx),%eax
 1d1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d4:	80 fb 09             	cmp    $0x9,%bl
 1d7:	76 eb                	jbe    1c4 <atoi+0x18>
  return n;
}
 1d9:	89 d0                	mov    %edx,%eax
 1db:	5b                   	pop    %ebx
 1dc:	5d                   	pop    %ebp
 1dd:	c3                   	ret    
 1de:	66 90                	xchg   %ax,%ax

000001e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8b 75 0c             	mov    0xc(%ebp),%esi
 1eb:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ee:	85 d2                	test   %edx,%edx
 1f0:	7e 0b                	jle    1fd <memmove+0x1d>
 1f2:	01 c2                	add    %eax,%edx
  dst = vdst;
 1f4:	89 c7                	mov    %eax,%edi
 1f6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1f9:	39 fa                	cmp    %edi,%edx
 1fb:	75 fb                	jne    1f8 <memmove+0x18>
  return vdst;
}
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	8d 76 00             	lea    0x0(%esi),%esi

00000204 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 210:	5d                   	pop    %ebp
 211:	c3                   	ret    
 212:	66 90                	xchg   %ax,%ax

00000214 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 21a:	b9 01 00 00 00       	mov    $0x1,%ecx
 21f:	90                   	nop
 220:	89 c8                	mov    %ecx,%eax
 222:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 225:	85 c0                	test   %eax,%eax
 227:	75 f7                	jne    220 <lock_acquire+0xc>
}
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    
 22b:	90                   	nop

0000022c <lock_release>:

void lock_release(lock_t *lock) {
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	8b 55 08             	mov    0x8(%ebp),%edx
 232:	31 c0                	xor    %eax,%eax
 234:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    
 239:	8d 76 00             	lea    0x0(%esi),%esi

0000023c <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 242:	68 00 20 00 00       	push   $0x2000
 247:	e8 94 03 00 00       	call   5e0 <malloc>

  if((uint)stack % PGSIZE)
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	89 c2                	mov    %eax,%edx
 251:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 257:	74 07                	je     260 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 259:	29 d0                	sub    %edx,%eax
 25b:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 260:	ff 75 0c             	pushl  0xc(%ebp)
 263:	6a 08                	push   $0x8
 265:	50                   	push   %eax
 266:	ff 75 08             	pushl  0x8(%ebp)
 269:	e8 cc 00 00 00       	call   33a <clone>

  if (tid < 0) {
 26e:	83 c4 10             	add    $0x10,%esp
 271:	85 c0                	test   %eax,%eax
 273:	78 07                	js     27c <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 275:	31 c0                	xor    %eax,%eax
 277:	c9                   	leave  
 278:	c3                   	ret    
 279:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 27c:	83 ec 08             	sub    $0x8,%esp
 27f:	68 ec 06 00 00       	push   $0x6ec
 284:	6a 01                	push   $0x1
 286:	e8 41 01 00 00       	call   3cc <printf>
      return 0;
 28b:	83 c4 10             	add    $0x10,%esp
}
 28e:	31 c0                	xor    %eax,%eax
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 292:	b8 01 00 00 00       	mov    $0x1,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <exit>:
SYSCALL(exit)
 29a:	b8 02 00 00 00       	mov    $0x2,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <wait>:
SYSCALL(wait)
 2a2:	b8 03 00 00 00       	mov    $0x3,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <pipe>:
SYSCALL(pipe)
 2aa:	b8 04 00 00 00       	mov    $0x4,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <read>:
SYSCALL(read)
 2b2:	b8 05 00 00 00       	mov    $0x5,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <write>:
SYSCALL(write)
 2ba:	b8 10 00 00 00       	mov    $0x10,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <close>:
SYSCALL(close)
 2c2:	b8 15 00 00 00       	mov    $0x15,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <kill>:
SYSCALL(kill)
 2ca:	b8 06 00 00 00       	mov    $0x6,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exec>:
SYSCALL(exec)
 2d2:	b8 07 00 00 00       	mov    $0x7,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <open>:
SYSCALL(open)
 2da:	b8 0f 00 00 00       	mov    $0xf,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <mknod>:
SYSCALL(mknod)
 2e2:	b8 11 00 00 00       	mov    $0x11,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <unlink>:
SYSCALL(unlink)
 2ea:	b8 12 00 00 00       	mov    $0x12,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <fstat>:
SYSCALL(fstat)
 2f2:	b8 08 00 00 00       	mov    $0x8,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <link>:
SYSCALL(link)
 2fa:	b8 13 00 00 00       	mov    $0x13,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mkdir>:
SYSCALL(mkdir)
 302:	b8 14 00 00 00       	mov    $0x14,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <chdir>:
SYSCALL(chdir)
 30a:	b8 09 00 00 00       	mov    $0x9,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <dup>:
SYSCALL(dup)
 312:	b8 0a 00 00 00       	mov    $0xa,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <getpid>:
SYSCALL(getpid)
 31a:	b8 0b 00 00 00       	mov    $0xb,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <sbrk>:
SYSCALL(sbrk)
 322:	b8 0c 00 00 00       	mov    $0xc,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sleep>:
SYSCALL(sleep)
 32a:	b8 0d 00 00 00       	mov    $0xd,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <uptime>:
SYSCALL(uptime)
 332:	b8 0e 00 00 00       	mov    $0xe,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <clone>:
 33a:	b8 16 00 00 00       	mov    $0x16,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    
 342:	66 90                	xchg   %ax,%ax

00000344 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
 349:	53                   	push   %ebx
 34a:	83 ec 3c             	sub    $0x3c,%esp
 34d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 350:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 353:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 355:	8b 5d 08             	mov    0x8(%ebp),%ebx
 358:	85 db                	test   %ebx,%ebx
 35a:	74 04                	je     360 <printint+0x1c>
 35c:	85 d2                	test   %edx,%edx
 35e:	78 68                	js     3c8 <printint+0x84>
  neg = 0;
 360:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 367:	31 ff                	xor    %edi,%edi
 369:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 36c:	89 c8                	mov    %ecx,%eax
 36e:	31 d2                	xor    %edx,%edx
 370:	f7 75 c4             	divl   -0x3c(%ebp)
 373:	89 fb                	mov    %edi,%ebx
 375:	8d 7f 01             	lea    0x1(%edi),%edi
 378:	8a 92 04 07 00 00    	mov    0x704(%edx),%dl
 37e:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 382:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 385:	89 c1                	mov    %eax,%ecx
 387:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 38a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 38d:	76 dd                	jbe    36c <printint+0x28>
  if(neg)
 38f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 392:	85 c9                	test   %ecx,%ecx
 394:	74 09                	je     39f <printint+0x5b>
    buf[i++] = '-';
 396:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 39b:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 39d:	b2 2d                	mov    $0x2d,%dl
 39f:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3a3:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3a6:	eb 03                	jmp    3ab <printint+0x67>
 3a8:	8a 13                	mov    (%ebx),%dl
 3aa:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3ab:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3ae:	50                   	push   %eax
 3af:	6a 01                	push   $0x1
 3b1:	56                   	push   %esi
 3b2:	57                   	push   %edi
 3b3:	e8 02 ff ff ff       	call   2ba <write>
  while(--i >= 0)
 3b8:	83 c4 10             	add    $0x10,%esp
 3bb:	39 de                	cmp    %ebx,%esi
 3bd:	75 e9                	jne    3a8 <printint+0x64>
}
 3bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c2:	5b                   	pop    %ebx
 3c3:	5e                   	pop    %esi
 3c4:	5f                   	pop    %edi
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	90                   	nop
    x = -xx;
 3c8:	f7 d9                	neg    %ecx
 3ca:	eb 9b                	jmp    367 <printint+0x23>

000003cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	57                   	push   %edi
 3d0:	56                   	push   %esi
 3d1:	53                   	push   %ebx
 3d2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d5:	8b 75 0c             	mov    0xc(%ebp),%esi
 3d8:	8a 1e                	mov    (%esi),%bl
 3da:	84 db                	test   %bl,%bl
 3dc:	0f 84 a3 00 00 00    	je     485 <printf+0xb9>
 3e2:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3e3:	8d 45 10             	lea    0x10(%ebp),%eax
 3e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 3e9:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 3eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3ee:	eb 29                	jmp    419 <printf+0x4d>
 3f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3f3:	83 f8 25             	cmp    $0x25,%eax
 3f6:	0f 84 94 00 00 00    	je     490 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 3fc:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3ff:	50                   	push   %eax
 400:	6a 01                	push   $0x1
 402:	57                   	push   %edi
 403:	ff 75 08             	pushl  0x8(%ebp)
 406:	e8 af fe ff ff       	call   2ba <write>
        putc(fd, c);
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 411:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 412:	8a 5e ff             	mov    -0x1(%esi),%bl
 415:	84 db                	test   %bl,%bl
 417:	74 6c                	je     485 <printf+0xb9>
    c = fmt[i] & 0xff;
 419:	0f be cb             	movsbl %bl,%ecx
 41c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 41f:	85 d2                	test   %edx,%edx
 421:	74 cd                	je     3f0 <printf+0x24>
      }
    } else if(state == '%'){
 423:	83 fa 25             	cmp    $0x25,%edx
 426:	75 e9                	jne    411 <printf+0x45>
      if(c == 'd'){
 428:	83 f8 64             	cmp    $0x64,%eax
 42b:	0f 84 97 00 00 00    	je     4c8 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 431:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 437:	83 f9 70             	cmp    $0x70,%ecx
 43a:	74 60                	je     49c <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43c:	83 f8 73             	cmp    $0x73,%eax
 43f:	0f 84 8f 00 00 00    	je     4d4 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 445:	83 f8 63             	cmp    $0x63,%eax
 448:	0f 84 d6 00 00 00    	je     524 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44e:	83 f8 25             	cmp    $0x25,%eax
 451:	0f 84 c1 00 00 00    	je     518 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 457:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 45b:	50                   	push   %eax
 45c:	6a 01                	push   $0x1
 45e:	57                   	push   %edi
 45f:	ff 75 08             	pushl  0x8(%ebp)
 462:	e8 53 fe ff ff       	call   2ba <write>
        putc(fd, c);
 467:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 46a:	83 c4 0c             	add    $0xc,%esp
 46d:	6a 01                	push   $0x1
 46f:	57                   	push   %edi
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 42 fe ff ff       	call   2ba <write>
        putc(fd, c);
 478:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 47b:	31 d2                	xor    %edx,%edx
 47d:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 47e:	8a 5e ff             	mov    -0x1(%esi),%bl
 481:	84 db                	test   %bl,%bl
 483:	75 94                	jne    419 <printf+0x4d>
    }
  }
}
 485:	8d 65 f4             	lea    -0xc(%ebp),%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
 48d:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 490:	ba 25 00 00 00       	mov    $0x25,%edx
 495:	e9 77 ff ff ff       	jmp    411 <printf+0x45>
 49a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 49c:	83 ec 0c             	sub    $0xc,%esp
 49f:	6a 00                	push   $0x0
 4a1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4a9:	8b 13                	mov    (%ebx),%edx
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	e8 91 fe ff ff       	call   344 <printint>
        ap++;
 4b3:	89 d8                	mov    %ebx,%eax
 4b5:	83 c0 04             	add    $0x4,%eax
 4b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4bb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4be:	31 d2                	xor    %edx,%edx
        ap++;
 4c0:	e9 4c ff ff ff       	jmp    411 <printf+0x45>
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4c8:	83 ec 0c             	sub    $0xc,%esp
 4cb:	6a 01                	push   $0x1
 4cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d2:	eb d2                	jmp    4a6 <printf+0xda>
        s = (char*)*ap;
 4d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4d7:	8b 18                	mov    (%eax),%ebx
        ap++;
 4d9:	83 c0 04             	add    $0x4,%eax
 4dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4df:	85 db                	test   %ebx,%ebx
 4e1:	74 65                	je     548 <printf+0x17c>
        while(*s != 0){
 4e3:	8a 03                	mov    (%ebx),%al
 4e5:	84 c0                	test   %al,%al
 4e7:	74 70                	je     559 <printf+0x18d>
 4e9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4ec:	89 de                	mov    %ebx,%esi
 4ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4f1:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 4f4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4f7:	50                   	push   %eax
 4f8:	6a 01                	push   $0x1
 4fa:	57                   	push   %edi
 4fb:	53                   	push   %ebx
 4fc:	e8 b9 fd ff ff       	call   2ba <write>
          s++;
 501:	46                   	inc    %esi
        while(*s != 0){
 502:	8a 06                	mov    (%esi),%al
 504:	83 c4 10             	add    $0x10,%esp
 507:	84 c0                	test   %al,%al
 509:	75 e9                	jne    4f4 <printf+0x128>
 50b:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 50e:	31 d2                	xor    %edx,%edx
 510:	e9 fc fe ff ff       	jmp    411 <printf+0x45>
 515:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 518:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 51b:	52                   	push   %edx
 51c:	e9 4c ff ff ff       	jmp    46d <printf+0xa1>
 521:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 524:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 527:	8b 03                	mov    (%ebx),%eax
 529:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 52c:	51                   	push   %ecx
 52d:	6a 01                	push   $0x1
 52f:	57                   	push   %edi
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 82 fd ff ff       	call   2ba <write>
        ap++;
 538:	83 c3 04             	add    $0x4,%ebx
 53b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 53e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 541:	31 d2                	xor    %edx,%edx
 543:	e9 c9 fe ff ff       	jmp    411 <printf+0x45>
          s = "(null)";
 548:	bb fc 06 00 00       	mov    $0x6fc,%ebx
        while(*s != 0){
 54d:	b0 28                	mov    $0x28,%al
 54f:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 552:	89 de                	mov    %ebx,%esi
 554:	8b 5d 08             	mov    0x8(%ebp),%ebx
 557:	eb 9b                	jmp    4f4 <printf+0x128>
      state = 0;
 559:	31 d2                	xor    %edx,%edx
 55b:	e9 b1 fe ff ff       	jmp    411 <printf+0x45>

00000560 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 569:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56c:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 571:	8b 10                	mov    (%eax),%edx
 573:	39 c8                	cmp    %ecx,%eax
 575:	73 11                	jae    588 <free+0x28>
 577:	90                   	nop
 578:	39 d1                	cmp    %edx,%ecx
 57a:	72 14                	jb     590 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57c:	39 d0                	cmp    %edx,%eax
 57e:	73 10                	jae    590 <free+0x30>
{
 580:	89 d0                	mov    %edx,%eax
 582:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 584:	39 c8                	cmp    %ecx,%eax
 586:	72 f0                	jb     578 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 588:	39 d0                	cmp    %edx,%eax
 58a:	72 f4                	jb     580 <free+0x20>
 58c:	39 d1                	cmp    %edx,%ecx
 58e:	73 f0                	jae    580 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 590:	8b 73 fc             	mov    -0x4(%ebx),%esi
 593:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 596:	39 fa                	cmp    %edi,%edx
 598:	74 1a                	je     5b4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 59d:	8b 50 04             	mov    0x4(%eax),%edx
 5a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a3:	39 f1                	cmp    %esi,%ecx
 5a5:	74 24                	je     5cb <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a9:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 5ae:	5b                   	pop    %ebx
 5af:	5e                   	pop    %esi
 5b0:	5f                   	pop    %edi
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    
 5b3:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5b4:	03 72 04             	add    0x4(%edx),%esi
 5b7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ba:	8b 10                	mov    (%eax),%edx
 5bc:	8b 12                	mov    (%edx),%edx
 5be:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c1:	8b 50 04             	mov    0x4(%eax),%edx
 5c4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c7:	39 f1                	cmp    %esi,%ecx
 5c9:	75 dc                	jne    5a7 <free+0x47>
    p->s.size += bp->s.size;
 5cb:	03 53 fc             	add    -0x4(%ebx),%edx
 5ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d4:	89 10                	mov    %edx,(%eax)
  freep = p;
 5d6:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 5db:	5b                   	pop    %ebx
 5dc:	5e                   	pop    %esi
 5dd:	5f                   	pop    %edi
 5de:	5d                   	pop    %ebp
 5df:	c3                   	ret    

000005e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	8d 70 07             	lea    0x7(%eax),%esi
 5ef:	c1 ee 03             	shr    $0x3,%esi
 5f2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5f3:	8b 3d 2c 0a 00 00    	mov    0xa2c,%edi
 5f9:	85 ff                	test   %edi,%edi
 5fb:	0f 84 a3 00 00 00    	je     6a4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 601:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 603:	8b 48 04             	mov    0x4(%eax),%ecx
 606:	39 f1                	cmp    %esi,%ecx
 608:	73 67                	jae    671 <malloc+0x91>
 60a:	89 f3                	mov    %esi,%ebx
 60c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 612:	0f 82 80 00 00 00    	jb     698 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 618:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 61f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 622:	eb 11                	jmp    635 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 624:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 626:	8b 4a 04             	mov    0x4(%edx),%ecx
 629:	39 f1                	cmp    %esi,%ecx
 62b:	73 4b                	jae    678 <malloc+0x98>
 62d:	8b 3d 2c 0a 00 00    	mov    0xa2c,%edi
 633:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 635:	39 c7                	cmp    %eax,%edi
 637:	75 eb                	jne    624 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 639:	83 ec 0c             	sub    $0xc,%esp
 63c:	ff 75 e4             	pushl  -0x1c(%ebp)
 63f:	e8 de fc ff ff       	call   322 <sbrk>
  if(p == (char*)-1)
 644:	83 c4 10             	add    $0x10,%esp
 647:	83 f8 ff             	cmp    $0xffffffff,%eax
 64a:	74 1b                	je     667 <malloc+0x87>
  hp->s.size = nu;
 64c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 64f:	83 ec 0c             	sub    $0xc,%esp
 652:	83 c0 08             	add    $0x8,%eax
 655:	50                   	push   %eax
 656:	e8 05 ff ff ff       	call   560 <free>
  return freep;
 65b:	a1 2c 0a 00 00       	mov    0xa2c,%eax
      if((p = morecore(nunits)) == 0)
 660:	83 c4 10             	add    $0x10,%esp
 663:	85 c0                	test   %eax,%eax
 665:	75 bd                	jne    624 <malloc+0x44>
        return 0;
 667:	31 c0                	xor    %eax,%eax
  }
}
 669:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66c:	5b                   	pop    %ebx
 66d:	5e                   	pop    %esi
 66e:	5f                   	pop    %edi
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret    
    if(p->s.size >= nunits){
 671:	89 c2                	mov    %eax,%edx
 673:	89 f8                	mov    %edi,%eax
 675:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 678:	39 ce                	cmp    %ecx,%esi
 67a:	74 54                	je     6d0 <malloc+0xf0>
        p->s.size -= nunits;
 67c:	29 f1                	sub    %esi,%ecx
 67e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 681:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 684:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 687:	a3 2c 0a 00 00       	mov    %eax,0xa2c
      return (void*)(p + 1);
 68c:	8d 42 08             	lea    0x8(%edx),%eax
}
 68f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 692:	5b                   	pop    %ebx
 693:	5e                   	pop    %esi
 694:	5f                   	pop    %edi
 695:	5d                   	pop    %ebp
 696:	c3                   	ret    
 697:	90                   	nop
 698:	bb 00 10 00 00       	mov    $0x1000,%ebx
 69d:	e9 76 ff ff ff       	jmp    618 <malloc+0x38>
 6a2:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6a4:	c7 05 2c 0a 00 00 30 	movl   $0xa30,0xa2c
 6ab:	0a 00 00 
 6ae:	c7 05 30 0a 00 00 30 	movl   $0xa30,0xa30
 6b5:	0a 00 00 
    base.s.size = 0;
 6b8:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 6bf:	00 00 00 
 6c2:	bf 30 0a 00 00       	mov    $0xa30,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c7:	89 f8                	mov    %edi,%eax
 6c9:	e9 3c ff ff ff       	jmp    60a <malloc+0x2a>
 6ce:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6d0:	8b 0a                	mov    (%edx),%ecx
 6d2:	89 08                	mov    %ecx,(%eax)
 6d4:	eb b1                	jmp    687 <malloc+0xa7>

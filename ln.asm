
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 13                	je     2a <main+0x2a>
    printf(2, "Usage: ln old new\n");
  17:	52                   	push   %edx
  18:	52                   	push   %edx
  19:	68 dc 06 00 00       	push   $0x6dc
  1e:	6a 02                	push   $0x2
  20:	e8 ab 03 00 00       	call   3d0 <printf>
    exit();
  25:	e8 74 02 00 00       	call   29e <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2a:	50                   	push   %eax
  2b:	50                   	push   %eax
  2c:	ff 73 08             	pushl  0x8(%ebx)
  2f:	ff 73 04             	pushl  0x4(%ebx)
  32:	e8 c7 02 00 00       	call   2fe <link>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 05                	js     43 <main+0x43>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3e:	e8 5b 02 00 00       	call   29e <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  43:	ff 73 08             	pushl  0x8(%ebx)
  46:	ff 73 04             	pushl  0x4(%ebx)
  49:	68 ef 06 00 00       	push   $0x6ef
  4e:	6a 02                	push   $0x2
  50:	e8 7b 03 00 00       	call   3d0 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e4                	jmp    3e <main+0x3e>
  5a:	66 90                	xchg   %ax,%ax

0000005c <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	31 c0                	xor    %eax,%eax
  68:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  6b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6e:	40                   	inc    %eax
  6f:	84 d2                	test   %dl,%dl
  71:	75 f5                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  73:	89 c8                	mov    %ecx,%eax
  75:	5b                   	pop    %ebx
  76:	5d                   	pop    %ebp
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  82:	0f b6 03             	movzbl (%ebx),%eax
  85:	0f b6 0a             	movzbl (%edx),%ecx
  88:	84 c0                	test   %al,%al
  8a:	75 10                	jne    9c <strcmp+0x24>
  8c:	eb 1a                	jmp    a8 <strcmp+0x30>
  8e:	66 90                	xchg   %ax,%ax
    p++, q++;
  90:	43                   	inc    %ebx
  91:	42                   	inc    %edx
  while(*p && *p == *q)
  92:	0f b6 03             	movzbl (%ebx),%eax
  95:	0f b6 0a             	movzbl (%edx),%ecx
  98:	84 c0                	test   %al,%al
  9a:	74 0c                	je     a8 <strcmp+0x30>
  9c:	38 c8                	cmp    %cl,%al
  9e:	74 f0                	je     90 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  a0:	29 c8                	sub    %ecx,%eax
}
  a2:	5b                   	pop    %ebx
  a3:	5d                   	pop    %ebp
  a4:	c3                   	ret    
  a5:	8d 76 00             	lea    0x0(%esi),%esi
  a8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  aa:	29 c8                	sub    %ecx,%eax
}
  ac:	5b                   	pop    %ebx
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    
  af:	90                   	nop

000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b6:	80 3a 00             	cmpb   $0x0,(%edx)
  b9:	74 15                	je     d0 <strlen+0x20>
  bb:	31 c0                	xor    %eax,%eax
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	40                   	inc    %eax
  c1:	89 c1                	mov    %eax,%ecx
  c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c7:	75 f7                	jne    c0 <strlen+0x10>
    ;
  return n;
}
  c9:	89 c8                	mov    %ecx,%eax
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  d0:	31 c9                	xor    %ecx,%ecx
}
  d2:	89 c8                	mov    %ecx,%eax
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    
  d6:	66 90                	xchg   %ax,%ax

000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	fc                   	cld    
  e6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	5f                   	pop    %edi
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f9:	8a 10                	mov    (%eax),%dl
  fb:	84 d2                	test   %dl,%dl
  fd:	75 0c                	jne    10b <strchr+0x1b>
  ff:	eb 13                	jmp    114 <strchr+0x24>
 101:	8d 76 00             	lea    0x0(%esi),%esi
 104:	40                   	inc    %eax
 105:	8a 10                	mov    (%eax),%dl
 107:	84 d2                	test   %dl,%dl
 109:	74 09                	je     114 <strchr+0x24>
    if(*s == c)
 10b:	38 d1                	cmp    %dl,%cl
 10d:	75 f5                	jne    104 <strchr+0x14>
      return (char*)s;
  return 0;
}
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
 111:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 114:	31 c0                	xor    %eax,%eax
}
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    

00000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	56                   	push   %esi
 11d:	53                   	push   %ebx
 11e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 121:	8b 75 08             	mov    0x8(%ebp),%esi
 124:	bb 01 00 00 00       	mov    $0x1,%ebx
 129:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 12b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12e:	eb 20                	jmp    150 <gets+0x38>
    cc = read(0, &c, 1);
 130:	50                   	push   %eax
 131:	6a 01                	push   $0x1
 133:	57                   	push   %edi
 134:	6a 00                	push   $0x0
 136:	e8 7b 01 00 00       	call   2b6 <read>
    if(cc < 1)
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	85 c0                	test   %eax,%eax
 140:	7e 16                	jle    158 <gets+0x40>
      break;
    buf[i++] = c;
 142:	8a 45 e7             	mov    -0x19(%ebp),%al
 145:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 147:	46                   	inc    %esi
 148:	3c 0a                	cmp    $0xa,%al
 14a:	74 0c                	je     158 <gets+0x40>
 14c:	3c 0d                	cmp    $0xd,%al
 14e:	74 08                	je     158 <gets+0x40>
  for(i=0; i+1 < max; ){
 150:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 153:	39 45 0c             	cmp    %eax,0xc(%ebp)
 156:	7f d8                	jg     130 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 158:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	66 90                	xchg   %ax,%ax

00000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	56                   	push   %esi
 16c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16d:	83 ec 08             	sub    $0x8,%esp
 170:	6a 00                	push   $0x0
 172:	ff 75 08             	pushl  0x8(%ebp)
 175:	e8 64 01 00 00       	call   2de <open>
  if(fd < 0)
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	85 c0                	test   %eax,%eax
 17f:	78 27                	js     1a8 <stat+0x40>
 181:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 183:	83 ec 08             	sub    $0x8,%esp
 186:	ff 75 0c             	pushl  0xc(%ebp)
 189:	50                   	push   %eax
 18a:	e8 67 01 00 00       	call   2f6 <fstat>
 18f:	89 c6                	mov    %eax,%esi
  close(fd);
 191:	89 1c 24             	mov    %ebx,(%esp)
 194:	e8 2d 01 00 00       	call   2c6 <close>
  return r;
 199:	83 c4 10             	add    $0x10,%esp
}
 19c:	89 f0                	mov    %esi,%eax
 19e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a1:	5b                   	pop    %ebx
 1a2:	5e                   	pop    %esi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ad:	eb ed                	jmp    19c <stat+0x34>
 1af:	90                   	nop

000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b7:	0f be 01             	movsbl (%ecx),%eax
 1ba:	8d 50 d0             	lea    -0x30(%eax),%edx
 1bd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1c0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c5:	77 16                	ja     1dd <atoi+0x2d>
 1c7:	90                   	nop
    n = n*10 + *s++ - '0';
 1c8:	41                   	inc    %ecx
 1c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1cc:	01 d2                	add    %edx,%edx
 1ce:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1d2:	0f be 01             	movsbl (%ecx),%eax
 1d5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d8:	80 fb 09             	cmp    $0x9,%bl
 1db:	76 eb                	jbe    1c8 <atoi+0x18>
  return n;
}
 1dd:	89 d0                	mov    %edx,%eax
 1df:	5b                   	pop    %ebx
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    
 1e2:	66 90                	xchg   %ax,%ax

000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	56                   	push   %esi
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	85 d2                	test   %edx,%edx
 1f4:	7e 0b                	jle    201 <memmove+0x1d>
 1f6:	01 c2                	add    %eax,%edx
  dst = vdst;
 1f8:	89 c7                	mov    %eax,%edi
 1fa:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1fc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1fd:	39 fa                	cmp    %edi,%edx
 1ff:	75 fb                	jne    1fc <memmove+0x18>
  return vdst;
}
 201:	5e                   	pop    %esi
 202:	5f                   	pop    %edi
 203:	5d                   	pop    %ebp
 204:	c3                   	ret    
 205:	8d 76 00             	lea    0x0(%esi),%esi

00000208 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    
 216:	66 90                	xchg   %ax,%ax

00000218 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 21e:	b9 01 00 00 00       	mov    $0x1,%ecx
 223:	90                   	nop
 224:	89 c8                	mov    %ecx,%eax
 226:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 229:	85 c0                	test   %eax,%eax
 22b:	75 f7                	jne    224 <lock_acquire+0xc>
}
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop

00000230 <lock_release>:

void lock_release(lock_t *lock) {
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 55 08             	mov    0x8(%ebp),%edx
 236:	31 c0                	xor    %eax,%eax
 238:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 246:	68 00 20 00 00       	push   $0x2000
 24b:	e8 94 03 00 00       	call   5e4 <malloc>

  if((uint)stack % PGSIZE)
 250:	83 c4 10             	add    $0x10,%esp
 253:	89 c2                	mov    %eax,%edx
 255:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 25b:	74 07                	je     264 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 25d:	29 d0                	sub    %edx,%eax
 25f:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 264:	ff 75 0c             	pushl  0xc(%ebp)
 267:	6a 08                	push   $0x8
 269:	50                   	push   %eax
 26a:	ff 75 08             	pushl  0x8(%ebp)
 26d:	e8 cc 00 00 00       	call   33e <clone>

  if (tid < 0) {
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 07                	js     280 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 279:	31 c0                	xor    %eax,%eax
 27b:	c9                   	leave  
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 280:	83 ec 08             	sub    $0x8,%esp
 283:	68 03 07 00 00       	push   $0x703
 288:	6a 01                	push   $0x1
 28a:	e8 41 01 00 00       	call   3d0 <printf>
      return 0;
 28f:	83 c4 10             	add    $0x10,%esp
}
 292:	31 c0                	xor    %eax,%eax
 294:	c9                   	leave  
 295:	c3                   	ret    

00000296 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 296:	b8 01 00 00 00       	mov    $0x1,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <exit>:
SYSCALL(exit)
 29e:	b8 02 00 00 00       	mov    $0x2,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <wait>:
SYSCALL(wait)
 2a6:	b8 03 00 00 00       	mov    $0x3,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <pipe>:
SYSCALL(pipe)
 2ae:	b8 04 00 00 00       	mov    $0x4,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <read>:
SYSCALL(read)
 2b6:	b8 05 00 00 00       	mov    $0x5,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <write>:
SYSCALL(write)
 2be:	b8 10 00 00 00       	mov    $0x10,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <close>:
SYSCALL(close)
 2c6:	b8 15 00 00 00       	mov    $0x15,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <kill>:
SYSCALL(kill)
 2ce:	b8 06 00 00 00       	mov    $0x6,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <exec>:
SYSCALL(exec)
 2d6:	b8 07 00 00 00       	mov    $0x7,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <open>:
SYSCALL(open)
 2de:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <mknod>:
SYSCALL(mknod)
 2e6:	b8 11 00 00 00       	mov    $0x11,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <unlink>:
SYSCALL(unlink)
 2ee:	b8 12 00 00 00       	mov    $0x12,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <fstat>:
SYSCALL(fstat)
 2f6:	b8 08 00 00 00       	mov    $0x8,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <link>:
SYSCALL(link)
 2fe:	b8 13 00 00 00       	mov    $0x13,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <mkdir>:
SYSCALL(mkdir)
 306:	b8 14 00 00 00       	mov    $0x14,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <chdir>:
SYSCALL(chdir)
 30e:	b8 09 00 00 00       	mov    $0x9,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <dup>:
SYSCALL(dup)
 316:	b8 0a 00 00 00       	mov    $0xa,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <getpid>:
SYSCALL(getpid)
 31e:	b8 0b 00 00 00       	mov    $0xb,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <sbrk>:
SYSCALL(sbrk)
 326:	b8 0c 00 00 00       	mov    $0xc,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <sleep>:
SYSCALL(sleep)
 32e:	b8 0d 00 00 00       	mov    $0xd,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <uptime>:
SYSCALL(uptime)
 336:	b8 0e 00 00 00       	mov    $0xe,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <clone>:
 33e:	b8 16 00 00 00       	mov    $0x16,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    
 346:	66 90                	xchg   %ax,%ax

00000348 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
 34e:	83 ec 3c             	sub    $0x3c,%esp
 351:	89 45 bc             	mov    %eax,-0x44(%ebp)
 354:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 357:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 359:	8b 5d 08             	mov    0x8(%ebp),%ebx
 35c:	85 db                	test   %ebx,%ebx
 35e:	74 04                	je     364 <printint+0x1c>
 360:	85 d2                	test   %edx,%edx
 362:	78 68                	js     3cc <printint+0x84>
  neg = 0;
 364:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 36b:	31 ff                	xor    %edi,%edi
 36d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 370:	89 c8                	mov    %ecx,%eax
 372:	31 d2                	xor    %edx,%edx
 374:	f7 75 c4             	divl   -0x3c(%ebp)
 377:	89 fb                	mov    %edi,%ebx
 379:	8d 7f 01             	lea    0x1(%edi),%edi
 37c:	8a 92 1c 07 00 00    	mov    0x71c(%edx),%dl
 382:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 386:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 389:	89 c1                	mov    %eax,%ecx
 38b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 38e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 391:	76 dd                	jbe    370 <printint+0x28>
  if(neg)
 393:	8b 4d 08             	mov    0x8(%ebp),%ecx
 396:	85 c9                	test   %ecx,%ecx
 398:	74 09                	je     3a3 <printint+0x5b>
    buf[i++] = '-';
 39a:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 39f:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3a1:	b2 2d                	mov    $0x2d,%dl
 3a3:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3a7:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3aa:	eb 03                	jmp    3af <printint+0x67>
 3ac:	8a 13                	mov    (%ebx),%dl
 3ae:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3af:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3b2:	50                   	push   %eax
 3b3:	6a 01                	push   $0x1
 3b5:	56                   	push   %esi
 3b6:	57                   	push   %edi
 3b7:	e8 02 ff ff ff       	call   2be <write>
  while(--i >= 0)
 3bc:	83 c4 10             	add    $0x10,%esp
 3bf:	39 de                	cmp    %ebx,%esi
 3c1:	75 e9                	jne    3ac <printint+0x64>
}
 3c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c6:	5b                   	pop    %ebx
 3c7:	5e                   	pop    %esi
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    
 3cb:	90                   	nop
    x = -xx;
 3cc:	f7 d9                	neg    %ecx
 3ce:	eb 9b                	jmp    36b <printint+0x23>

000003d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3dc:	8a 1e                	mov    (%esi),%bl
 3de:	84 db                	test   %bl,%bl
 3e0:	0f 84 a3 00 00 00    	je     489 <printf+0xb9>
 3e6:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3e7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 3ed:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 3ef:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3f2:	eb 29                	jmp    41d <printf+0x4d>
 3f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3f7:	83 f8 25             	cmp    $0x25,%eax
 3fa:	0f 84 94 00 00 00    	je     494 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 400:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 403:	50                   	push   %eax
 404:	6a 01                	push   $0x1
 406:	57                   	push   %edi
 407:	ff 75 08             	pushl  0x8(%ebp)
 40a:	e8 af fe ff ff       	call   2be <write>
        putc(fd, c);
 40f:	83 c4 10             	add    $0x10,%esp
 412:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 415:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 416:	8a 5e ff             	mov    -0x1(%esi),%bl
 419:	84 db                	test   %bl,%bl
 41b:	74 6c                	je     489 <printf+0xb9>
    c = fmt[i] & 0xff;
 41d:	0f be cb             	movsbl %bl,%ecx
 420:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 423:	85 d2                	test   %edx,%edx
 425:	74 cd                	je     3f4 <printf+0x24>
      }
    } else if(state == '%'){
 427:	83 fa 25             	cmp    $0x25,%edx
 42a:	75 e9                	jne    415 <printf+0x45>
      if(c == 'd'){
 42c:	83 f8 64             	cmp    $0x64,%eax
 42f:	0f 84 97 00 00 00    	je     4cc <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 435:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 43b:	83 f9 70             	cmp    $0x70,%ecx
 43e:	74 60                	je     4a0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 440:	83 f8 73             	cmp    $0x73,%eax
 443:	0f 84 8f 00 00 00    	je     4d8 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 449:	83 f8 63             	cmp    $0x63,%eax
 44c:	0f 84 d6 00 00 00    	je     528 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 452:	83 f8 25             	cmp    $0x25,%eax
 455:	0f 84 c1 00 00 00    	je     51c <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 45b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 45f:	50                   	push   %eax
 460:	6a 01                	push   $0x1
 462:	57                   	push   %edi
 463:	ff 75 08             	pushl  0x8(%ebp)
 466:	e8 53 fe ff ff       	call   2be <write>
        putc(fd, c);
 46b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 46e:	83 c4 0c             	add    $0xc,%esp
 471:	6a 01                	push   $0x1
 473:	57                   	push   %edi
 474:	ff 75 08             	pushl  0x8(%ebp)
 477:	e8 42 fe ff ff       	call   2be <write>
        putc(fd, c);
 47c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 47f:	31 d2                	xor    %edx,%edx
 481:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 482:	8a 5e ff             	mov    -0x1(%esi),%bl
 485:	84 db                	test   %bl,%bl
 487:	75 94                	jne    41d <printf+0x4d>
    }
  }
}
 489:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48c:	5b                   	pop    %ebx
 48d:	5e                   	pop    %esi
 48e:	5f                   	pop    %edi
 48f:	5d                   	pop    %ebp
 490:	c3                   	ret    
 491:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 494:	ba 25 00 00 00       	mov    $0x25,%edx
 499:	e9 77 ff ff ff       	jmp    415 <printf+0x45>
 49e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4a0:	83 ec 0c             	sub    $0xc,%esp
 4a3:	6a 00                	push   $0x0
 4a5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4ad:	8b 13                	mov    (%ebx),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	e8 91 fe ff ff       	call   348 <printint>
        ap++;
 4b7:	89 d8                	mov    %ebx,%eax
 4b9:	83 c0 04             	add    $0x4,%eax
 4bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c2:	31 d2                	xor    %edx,%edx
        ap++;
 4c4:	e9 4c ff ff ff       	jmp    415 <printf+0x45>
 4c9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4cc:	83 ec 0c             	sub    $0xc,%esp
 4cf:	6a 01                	push   $0x1
 4d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d6:	eb d2                	jmp    4aa <printf+0xda>
        s = (char*)*ap;
 4d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4db:	8b 18                	mov    (%eax),%ebx
        ap++;
 4dd:	83 c0 04             	add    $0x4,%eax
 4e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4e3:	85 db                	test   %ebx,%ebx
 4e5:	74 65                	je     54c <printf+0x17c>
        while(*s != 0){
 4e7:	8a 03                	mov    (%ebx),%al
 4e9:	84 c0                	test   %al,%al
 4eb:	74 70                	je     55d <printf+0x18d>
 4ed:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4f0:	89 de                	mov    %ebx,%esi
 4f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 4f8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4fb:	50                   	push   %eax
 4fc:	6a 01                	push   $0x1
 4fe:	57                   	push   %edi
 4ff:	53                   	push   %ebx
 500:	e8 b9 fd ff ff       	call   2be <write>
          s++;
 505:	46                   	inc    %esi
        while(*s != 0){
 506:	8a 06                	mov    (%esi),%al
 508:	83 c4 10             	add    $0x10,%esp
 50b:	84 c0                	test   %al,%al
 50d:	75 e9                	jne    4f8 <printf+0x128>
 50f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 512:	31 d2                	xor    %edx,%edx
 514:	e9 fc fe ff ff       	jmp    415 <printf+0x45>
 519:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 51c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 51f:	52                   	push   %edx
 520:	e9 4c ff ff ff       	jmp    471 <printf+0xa1>
 525:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 528:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 52b:	8b 03                	mov    (%ebx),%eax
 52d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 530:	51                   	push   %ecx
 531:	6a 01                	push   $0x1
 533:	57                   	push   %edi
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 82 fd ff ff       	call   2be <write>
        ap++;
 53c:	83 c3 04             	add    $0x4,%ebx
 53f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 542:	83 c4 10             	add    $0x10,%esp
      state = 0;
 545:	31 d2                	xor    %edx,%edx
 547:	e9 c9 fe ff ff       	jmp    415 <printf+0x45>
          s = "(null)";
 54c:	bb 13 07 00 00       	mov    $0x713,%ebx
        while(*s != 0){
 551:	b0 28                	mov    $0x28,%al
 553:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 556:	89 de                	mov    %ebx,%esi
 558:	8b 5d 08             	mov    0x8(%ebp),%ebx
 55b:	eb 9b                	jmp    4f8 <printf+0x128>
      state = 0;
 55d:	31 d2                	xor    %edx,%edx
 55f:	e9 b1 fe ff ff       	jmp    415 <printf+0x45>

00000564 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	53                   	push   %ebx
 56a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 56d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 570:	a1 40 0a 00 00       	mov    0xa40,%eax
 575:	8b 10                	mov    (%eax),%edx
 577:	39 c8                	cmp    %ecx,%eax
 579:	73 11                	jae    58c <free+0x28>
 57b:	90                   	nop
 57c:	39 d1                	cmp    %edx,%ecx
 57e:	72 14                	jb     594 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 580:	39 d0                	cmp    %edx,%eax
 582:	73 10                	jae    594 <free+0x30>
{
 584:	89 d0                	mov    %edx,%eax
 586:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 588:	39 c8                	cmp    %ecx,%eax
 58a:	72 f0                	jb     57c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	39 d0                	cmp    %edx,%eax
 58e:	72 f4                	jb     584 <free+0x20>
 590:	39 d1                	cmp    %edx,%ecx
 592:	73 f0                	jae    584 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 594:	8b 73 fc             	mov    -0x4(%ebx),%esi
 597:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59a:	39 fa                	cmp    %edi,%edx
 59c:	74 1a                	je     5b8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a1:	8b 50 04             	mov    0x4(%eax),%edx
 5a4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a7:	39 f1                	cmp    %esi,%ecx
 5a9:	74 24                	je     5cf <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ab:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ad:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 5b2:	5b                   	pop    %ebx
 5b3:	5e                   	pop    %esi
 5b4:	5f                   	pop    %edi
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5b8:	03 72 04             	add    0x4(%edx),%esi
 5bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5be:	8b 10                	mov    (%eax),%edx
 5c0:	8b 12                	mov    (%edx),%edx
 5c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c5:	8b 50 04             	mov    0x4(%eax),%edx
 5c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5cb:	39 f1                	cmp    %esi,%ecx
 5cd:	75 dc                	jne    5ab <free+0x47>
    p->s.size += bp->s.size;
 5cf:	03 53 fc             	add    -0x4(%ebx),%edx
 5d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d8:	89 10                	mov    %edx,(%eax)
  freep = p;
 5da:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    

000005e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	57                   	push   %edi
 5e8:	56                   	push   %esi
 5e9:	53                   	push   %ebx
 5ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	8d 70 07             	lea    0x7(%eax),%esi
 5f3:	c1 ee 03             	shr    $0x3,%esi
 5f6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5f7:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
 5fd:	85 ff                	test   %edi,%edi
 5ff:	0f 84 a3 00 00 00    	je     6a8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 605:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 607:	8b 48 04             	mov    0x4(%eax),%ecx
 60a:	39 f1                	cmp    %esi,%ecx
 60c:	73 67                	jae    675 <malloc+0x91>
 60e:	89 f3                	mov    %esi,%ebx
 610:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 616:	0f 82 80 00 00 00    	jb     69c <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 61c:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 623:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 626:	eb 11                	jmp    639 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 628:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 62a:	8b 4a 04             	mov    0x4(%edx),%ecx
 62d:	39 f1                	cmp    %esi,%ecx
 62f:	73 4b                	jae    67c <malloc+0x98>
 631:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
 637:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 639:	39 c7                	cmp    %eax,%edi
 63b:	75 eb                	jne    628 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 63d:	83 ec 0c             	sub    $0xc,%esp
 640:	ff 75 e4             	pushl  -0x1c(%ebp)
 643:	e8 de fc ff ff       	call   326 <sbrk>
  if(p == (char*)-1)
 648:	83 c4 10             	add    $0x10,%esp
 64b:	83 f8 ff             	cmp    $0xffffffff,%eax
 64e:	74 1b                	je     66b <malloc+0x87>
  hp->s.size = nu;
 650:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	83 c0 08             	add    $0x8,%eax
 659:	50                   	push   %eax
 65a:	e8 05 ff ff ff       	call   564 <free>
  return freep;
 65f:	a1 40 0a 00 00       	mov    0xa40,%eax
      if((p = morecore(nunits)) == 0)
 664:	83 c4 10             	add    $0x10,%esp
 667:	85 c0                	test   %eax,%eax
 669:	75 bd                	jne    628 <malloc+0x44>
        return 0;
 66b:	31 c0                	xor    %eax,%eax
  }
}
 66d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 670:	5b                   	pop    %ebx
 671:	5e                   	pop    %esi
 672:	5f                   	pop    %edi
 673:	5d                   	pop    %ebp
 674:	c3                   	ret    
    if(p->s.size >= nunits){
 675:	89 c2                	mov    %eax,%edx
 677:	89 f8                	mov    %edi,%eax
 679:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 67c:	39 ce                	cmp    %ecx,%esi
 67e:	74 54                	je     6d4 <malloc+0xf0>
        p->s.size -= nunits;
 680:	29 f1                	sub    %esi,%ecx
 682:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 685:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 688:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 68b:	a3 40 0a 00 00       	mov    %eax,0xa40
      return (void*)(p + 1);
 690:	8d 42 08             	lea    0x8(%edx),%eax
}
 693:	8d 65 f4             	lea    -0xc(%ebp),%esp
 696:	5b                   	pop    %ebx
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
 69b:	90                   	nop
 69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a1:	e9 76 ff ff ff       	jmp    61c <malloc+0x38>
 6a6:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6a8:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 6af:	0a 00 00 
 6b2:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 6b9:	0a 00 00 
    base.s.size = 0;
 6bc:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 6c3:	00 00 00 
 6c6:	bf 44 0a 00 00       	mov    $0xa44,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6cb:	89 f8                	mov    %edi,%eax
 6cd:	e9 3c ff ff ff       	jmp    60e <malloc+0x2a>
 6d2:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6d4:	8b 0a                	mov    (%edx),%ecx
 6d6:	89 08                	mov    %ecx,(%eax)
 6d8:	eb b1                	jmp    68b <malloc+0xa7>

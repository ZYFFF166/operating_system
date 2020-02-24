
_echo:     file format elf32-i386


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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  for(i = 1; i < argc; i++)
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 47                	jle    64 <main+0x64>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 04             	add    $0x4,%ebx
  26:	8b 43 fc             	mov    -0x4(%ebx),%eax
  29:	39 f3                	cmp    %esi,%ebx
  2b:	74 22                	je     4f <main+0x4f>
  2d:	8d 76 00             	lea    0x0(%esi),%esi
  30:	68 ec 06 00 00       	push   $0x6ec
  35:	50                   	push   %eax
  36:	68 ee 06 00 00       	push   $0x6ee
  3b:	6a 01                	push   $0x1
  3d:	e8 9e 03 00 00       	call   3e0 <printf>
  42:	83 c4 10             	add    $0x10,%esp
  45:	83 c3 04             	add    $0x4,%ebx
  48:	8b 43 fc             	mov    -0x4(%ebx),%eax
  4b:	39 f3                	cmp    %esi,%ebx
  4d:	75 e1                	jne    30 <main+0x30>
  4f:	68 01 07 00 00       	push   $0x701
  54:	50                   	push   %eax
  55:	68 ee 06 00 00       	push   $0x6ee
  5a:	6a 01                	push   $0x1
  5c:	e8 7f 03 00 00       	call   3e0 <printf>
  61:	83 c4 10             	add    $0x10,%esp
  exit();
  64:	e8 45 02 00 00       	call   2ae <exit>
  69:	66 90                	xchg   %ax,%ax
  6b:	90                   	nop

0000006c <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	53                   	push   %ebx
  70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	31 c0                	xor    %eax,%eax
  78:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  7b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  7e:	40                   	inc    %eax
  7f:	84 d2                	test   %dl,%dl
  81:	75 f5                	jne    78 <strcpy+0xc>
    ;
  return os;
}
  83:	89 c8                	mov    %ecx,%eax
  85:	5b                   	pop    %ebx
  86:	5d                   	pop    %ebp
  87:	c3                   	ret    

00000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	53                   	push   %ebx
  8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  92:	0f b6 03             	movzbl (%ebx),%eax
  95:	0f b6 0a             	movzbl (%edx),%ecx
  98:	84 c0                	test   %al,%al
  9a:	75 10                	jne    ac <strcmp+0x24>
  9c:	eb 1a                	jmp    b8 <strcmp+0x30>
  9e:	66 90                	xchg   %ax,%ax
    p++, q++;
  a0:	43                   	inc    %ebx
  a1:	42                   	inc    %edx
  while(*p && *p == *q)
  a2:	0f b6 03             	movzbl (%ebx),%eax
  a5:	0f b6 0a             	movzbl (%edx),%ecx
  a8:	84 c0                	test   %al,%al
  aa:	74 0c                	je     b8 <strcmp+0x30>
  ac:	38 c8                	cmp    %cl,%al
  ae:	74 f0                	je     a0 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b0:	29 c8                	sub    %ecx,%eax
}
  b2:	5b                   	pop    %ebx
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    
  b5:	8d 76 00             	lea    0x0(%esi),%esi
  b8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  ba:	29 c8                	sub    %ecx,%eax
}
  bc:	5b                   	pop    %ebx
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
  bf:	90                   	nop

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	40                   	inc    %eax
  d1:	89 c1                	mov    %eax,%ecx
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	75 f7                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  d9:	89 c8                	mov    %ecx,%eax
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	89 c8                	mov    %ecx,%eax
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    
  e6:	66 90                	xchg   %ax,%ax

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	fc                   	cld    
  f6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	5f                   	pop    %edi
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    
  fe:	66 90                	xchg   %ax,%ax

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 109:	8a 10                	mov    (%eax),%dl
 10b:	84 d2                	test   %dl,%dl
 10d:	75 0c                	jne    11b <strchr+0x1b>
 10f:	eb 13                	jmp    124 <strchr+0x24>
 111:	8d 76 00             	lea    0x0(%esi),%esi
 114:	40                   	inc    %eax
 115:	8a 10                	mov    (%eax),%dl
 117:	84 d2                	test   %dl,%dl
 119:	74 09                	je     124 <strchr+0x24>
    if(*s == c)
 11b:	38 d1                	cmp    %dl,%cl
 11d:	75 f5                	jne    114 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 124:	31 c0                	xor    %eax,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	57                   	push   %edi
 12c:	56                   	push   %esi
 12d:	53                   	push   %ebx
 12e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 131:	8b 75 08             	mov    0x8(%ebp),%esi
 134:	bb 01 00 00 00       	mov    $0x1,%ebx
 139:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 13b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 13e:	eb 20                	jmp    160 <gets+0x38>
    cc = read(0, &c, 1);
 140:	50                   	push   %eax
 141:	6a 01                	push   $0x1
 143:	57                   	push   %edi
 144:	6a 00                	push   $0x0
 146:	e8 7b 01 00 00       	call   2c6 <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 16                	jle    168 <gets+0x40>
      break;
    buf[i++] = c;
 152:	8a 45 e7             	mov    -0x19(%ebp),%al
 155:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 157:	46                   	inc    %esi
 158:	3c 0a                	cmp    $0xa,%al
 15a:	74 0c                	je     168 <gets+0x40>
 15c:	3c 0d                	cmp    $0xd,%al
 15e:	74 08                	je     168 <gets+0x40>
  for(i=0; i+1 < max; ){
 160:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 163:	39 45 0c             	cmp    %eax,0xc(%ebp)
 166:	7f d8                	jg     140 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 168:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 171:	5b                   	pop    %ebx
 172:	5e                   	pop    %esi
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    
 176:	66 90                	xchg   %ax,%ax

00000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	56                   	push   %esi
 17c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17d:	83 ec 08             	sub    $0x8,%esp
 180:	6a 00                	push   $0x0
 182:	ff 75 08             	pushl  0x8(%ebp)
 185:	e8 64 01 00 00       	call   2ee <open>
  if(fd < 0)
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 27                	js     1b8 <stat+0x40>
 191:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 193:	83 ec 08             	sub    $0x8,%esp
 196:	ff 75 0c             	pushl  0xc(%ebp)
 199:	50                   	push   %eax
 19a:	e8 67 01 00 00       	call   306 <fstat>
 19f:	89 c6                	mov    %eax,%esi
  close(fd);
 1a1:	89 1c 24             	mov    %ebx,(%esp)
 1a4:	e8 2d 01 00 00       	call   2d6 <close>
  return r;
 1a9:	83 c4 10             	add    $0x10,%esp
}
 1ac:	89 f0                	mov    %esi,%eax
 1ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b1:	5b                   	pop    %ebx
 1b2:	5e                   	pop    %esi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bd:	eb ed                	jmp    1ac <stat+0x34>
 1bf:	90                   	nop

000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f be 01             	movsbl (%ecx),%eax
 1ca:	8d 50 d0             	lea    -0x30(%eax),%edx
 1cd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d5:	77 16                	ja     1ed <atoi+0x2d>
 1d7:	90                   	nop
    n = n*10 + *s++ - '0';
 1d8:	41                   	inc    %ecx
 1d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1dc:	01 d2                	add    %edx,%edx
 1de:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1e2:	0f be 01             	movsbl (%ecx),%eax
 1e5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e8:	80 fb 09             	cmp    $0x9,%bl
 1eb:	76 eb                	jbe    1d8 <atoi+0x18>
  return n;
}
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	5b                   	pop    %ebx
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    
 1f2:	66 90                	xchg   %ax,%ax

000001f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	56                   	push   %esi
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	85 d2                	test   %edx,%edx
 204:	7e 0b                	jle    211 <memmove+0x1d>
 206:	01 c2                	add    %eax,%edx
  dst = vdst;
 208:	89 c7                	mov    %eax,%edi
 20a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 20c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 20d:	39 fa                	cmp    %edi,%edx
 20f:	75 fb                	jne    20c <memmove+0x18>
  return vdst;
}
 211:	5e                   	pop    %esi
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d 76 00             	lea    0x0(%esi),%esi

00000218 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 224:	5d                   	pop    %ebp
 225:	c3                   	ret    
 226:	66 90                	xchg   %ax,%ax

00000228 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 22e:	b9 01 00 00 00       	mov    $0x1,%ecx
 233:	90                   	nop
 234:	89 c8                	mov    %ecx,%eax
 236:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 239:	85 c0                	test   %eax,%eax
 23b:	75 f7                	jne    234 <lock_acquire+0xc>
}
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
 23f:	90                   	nop

00000240 <lock_release>:

void lock_release(lock_t *lock) {
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
 246:	31 c0                	xor    %eax,%eax
 248:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi

00000250 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 256:	68 00 20 00 00       	push   $0x2000
 25b:	e8 94 03 00 00       	call   5f4 <malloc>

  if((uint)stack % PGSIZE)
 260:	83 c4 10             	add    $0x10,%esp
 263:	89 c2                	mov    %eax,%edx
 265:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 26b:	74 07                	je     274 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 26d:	29 d0                	sub    %edx,%eax
 26f:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 274:	ff 75 0c             	pushl  0xc(%ebp)
 277:	6a 08                	push   $0x8
 279:	50                   	push   %eax
 27a:	ff 75 08             	pushl  0x8(%ebp)
 27d:	e8 cc 00 00 00       	call   34e <clone>

  if (tid < 0) {
 282:	83 c4 10             	add    $0x10,%esp
 285:	85 c0                	test   %eax,%eax
 287:	78 07                	js     290 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 289:	31 c0                	xor    %eax,%eax
 28b:	c9                   	leave  
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 f3 06 00 00       	push   $0x6f3
 298:	6a 01                	push   $0x1
 29a:	e8 41 01 00 00       	call   3e0 <printf>
      return 0;
 29f:	83 c4 10             	add    $0x10,%esp
}
 2a2:	31 c0                	xor    %eax,%eax
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a6:	b8 01 00 00 00       	mov    $0x1,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <exit>:
SYSCALL(exit)
 2ae:	b8 02 00 00 00       	mov    $0x2,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <wait>:
SYSCALL(wait)
 2b6:	b8 03 00 00 00       	mov    $0x3,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <pipe>:
SYSCALL(pipe)
 2be:	b8 04 00 00 00       	mov    $0x4,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <read>:
SYSCALL(read)
 2c6:	b8 05 00 00 00       	mov    $0x5,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <write>:
SYSCALL(write)
 2ce:	b8 10 00 00 00       	mov    $0x10,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <close>:
SYSCALL(close)
 2d6:	b8 15 00 00 00       	mov    $0x15,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <kill>:
SYSCALL(kill)
 2de:	b8 06 00 00 00       	mov    $0x6,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <exec>:
SYSCALL(exec)
 2e6:	b8 07 00 00 00       	mov    $0x7,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <open>:
SYSCALL(open)
 2ee:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <mknod>:
SYSCALL(mknod)
 2f6:	b8 11 00 00 00       	mov    $0x11,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <unlink>:
SYSCALL(unlink)
 2fe:	b8 12 00 00 00       	mov    $0x12,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <fstat>:
SYSCALL(fstat)
 306:	b8 08 00 00 00       	mov    $0x8,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <link>:
SYSCALL(link)
 30e:	b8 13 00 00 00       	mov    $0x13,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <mkdir>:
SYSCALL(mkdir)
 316:	b8 14 00 00 00       	mov    $0x14,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <chdir>:
SYSCALL(chdir)
 31e:	b8 09 00 00 00       	mov    $0x9,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <dup>:
SYSCALL(dup)
 326:	b8 0a 00 00 00       	mov    $0xa,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <getpid>:
SYSCALL(getpid)
 32e:	b8 0b 00 00 00       	mov    $0xb,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <sbrk>:
SYSCALL(sbrk)
 336:	b8 0c 00 00 00       	mov    $0xc,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <sleep>:
SYSCALL(sleep)
 33e:	b8 0d 00 00 00       	mov    $0xd,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <uptime>:
SYSCALL(uptime)
 346:	b8 0e 00 00 00       	mov    $0xe,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <clone>:
 34e:	b8 16 00 00 00       	mov    $0x16,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    
 356:	66 90                	xchg   %ax,%ax

00000358 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 3c             	sub    $0x3c,%esp
 361:	89 45 bc             	mov    %eax,-0x44(%ebp)
 364:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 367:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 369:	8b 5d 08             	mov    0x8(%ebp),%ebx
 36c:	85 db                	test   %ebx,%ebx
 36e:	74 04                	je     374 <printint+0x1c>
 370:	85 d2                	test   %edx,%edx
 372:	78 68                	js     3dc <printint+0x84>
  neg = 0;
 374:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37b:	31 ff                	xor    %edi,%edi
 37d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 380:	89 c8                	mov    %ecx,%eax
 382:	31 d2                	xor    %edx,%edx
 384:	f7 75 c4             	divl   -0x3c(%ebp)
 387:	89 fb                	mov    %edi,%ebx
 389:	8d 7f 01             	lea    0x1(%edi),%edi
 38c:	8a 92 0c 07 00 00    	mov    0x70c(%edx),%dl
 392:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 396:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 399:	89 c1                	mov    %eax,%ecx
 39b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 39e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 3a1:	76 dd                	jbe    380 <printint+0x28>
  if(neg)
 3a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a6:	85 c9                	test   %ecx,%ecx
 3a8:	74 09                	je     3b3 <printint+0x5b>
    buf[i++] = '-';
 3aa:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 3af:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3b1:	b2 2d                	mov    $0x2d,%dl
 3b3:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3b7:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3ba:	eb 03                	jmp    3bf <printint+0x67>
 3bc:	8a 13                	mov    (%ebx),%dl
 3be:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3bf:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3c2:	50                   	push   %eax
 3c3:	6a 01                	push   $0x1
 3c5:	56                   	push   %esi
 3c6:	57                   	push   %edi
 3c7:	e8 02 ff ff ff       	call   2ce <write>
  while(--i >= 0)
 3cc:	83 c4 10             	add    $0x10,%esp
 3cf:	39 de                	cmp    %ebx,%esi
 3d1:	75 e9                	jne    3bc <printint+0x64>
}
 3d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    
 3db:	90                   	nop
    x = -xx;
 3dc:	f7 d9                	neg    %ecx
 3de:	eb 9b                	jmp    37b <printint+0x23>

000003e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3ec:	8a 1e                	mov    (%esi),%bl
 3ee:	84 db                	test   %bl,%bl
 3f0:	0f 84 a3 00 00 00    	je     499 <printf+0xb9>
 3f6:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3f7:	8d 45 10             	lea    0x10(%ebp),%eax
 3fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 3fd:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 3ff:	8d 7d e7             	lea    -0x19(%ebp),%edi
 402:	eb 29                	jmp    42d <printf+0x4d>
 404:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 407:	83 f8 25             	cmp    $0x25,%eax
 40a:	0f 84 94 00 00 00    	je     4a4 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 410:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 413:	50                   	push   %eax
 414:	6a 01                	push   $0x1
 416:	57                   	push   %edi
 417:	ff 75 08             	pushl  0x8(%ebp)
 41a:	e8 af fe ff ff       	call   2ce <write>
        putc(fd, c);
 41f:	83 c4 10             	add    $0x10,%esp
 422:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 425:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 426:	8a 5e ff             	mov    -0x1(%esi),%bl
 429:	84 db                	test   %bl,%bl
 42b:	74 6c                	je     499 <printf+0xb9>
    c = fmt[i] & 0xff;
 42d:	0f be cb             	movsbl %bl,%ecx
 430:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 433:	85 d2                	test   %edx,%edx
 435:	74 cd                	je     404 <printf+0x24>
      }
    } else if(state == '%'){
 437:	83 fa 25             	cmp    $0x25,%edx
 43a:	75 e9                	jne    425 <printf+0x45>
      if(c == 'd'){
 43c:	83 f8 64             	cmp    $0x64,%eax
 43f:	0f 84 97 00 00 00    	je     4dc <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 445:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 44b:	83 f9 70             	cmp    $0x70,%ecx
 44e:	74 60                	je     4b0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 450:	83 f8 73             	cmp    $0x73,%eax
 453:	0f 84 8f 00 00 00    	je     4e8 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 459:	83 f8 63             	cmp    $0x63,%eax
 45c:	0f 84 d6 00 00 00    	je     538 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 462:	83 f8 25             	cmp    $0x25,%eax
 465:	0f 84 c1 00 00 00    	je     52c <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 46b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 46f:	50                   	push   %eax
 470:	6a 01                	push   $0x1
 472:	57                   	push   %edi
 473:	ff 75 08             	pushl  0x8(%ebp)
 476:	e8 53 fe ff ff       	call   2ce <write>
        putc(fd, c);
 47b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 47e:	83 c4 0c             	add    $0xc,%esp
 481:	6a 01                	push   $0x1
 483:	57                   	push   %edi
 484:	ff 75 08             	pushl  0x8(%ebp)
 487:	e8 42 fe ff ff       	call   2ce <write>
        putc(fd, c);
 48c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 48f:	31 d2                	xor    %edx,%edx
 491:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 492:	8a 5e ff             	mov    -0x1(%esi),%bl
 495:	84 db                	test   %bl,%bl
 497:	75 94                	jne    42d <printf+0x4d>
    }
  }
}
 499:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49c:	5b                   	pop    %ebx
 49d:	5e                   	pop    %esi
 49e:	5f                   	pop    %edi
 49f:	5d                   	pop    %ebp
 4a0:	c3                   	ret    
 4a1:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 4a4:	ba 25 00 00 00       	mov    $0x25,%edx
 4a9:	e9 77 ff ff ff       	jmp    425 <printf+0x45>
 4ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4b0:	83 ec 0c             	sub    $0xc,%esp
 4b3:	6a 00                	push   $0x0
 4b5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4bd:	8b 13                	mov    (%ebx),%edx
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	e8 91 fe ff ff       	call   358 <printint>
        ap++;
 4c7:	89 d8                	mov    %ebx,%eax
 4c9:	83 c0 04             	add    $0x4,%eax
 4cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4cf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d2:	31 d2                	xor    %edx,%edx
        ap++;
 4d4:	e9 4c ff ff ff       	jmp    425 <printf+0x45>
 4d9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4dc:	83 ec 0c             	sub    $0xc,%esp
 4df:	6a 01                	push   $0x1
 4e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e6:	eb d2                	jmp    4ba <printf+0xda>
        s = (char*)*ap;
 4e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4eb:	8b 18                	mov    (%eax),%ebx
        ap++;
 4ed:	83 c0 04             	add    $0x4,%eax
 4f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4f3:	85 db                	test   %ebx,%ebx
 4f5:	74 65                	je     55c <printf+0x17c>
        while(*s != 0){
 4f7:	8a 03                	mov    (%ebx),%al
 4f9:	84 c0                	test   %al,%al
 4fb:	74 70                	je     56d <printf+0x18d>
 4fd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 500:	89 de                	mov    %ebx,%esi
 502:	8b 5d 08             	mov    0x8(%ebp),%ebx
 505:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 508:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 50b:	50                   	push   %eax
 50c:	6a 01                	push   $0x1
 50e:	57                   	push   %edi
 50f:	53                   	push   %ebx
 510:	e8 b9 fd ff ff       	call   2ce <write>
          s++;
 515:	46                   	inc    %esi
        while(*s != 0){
 516:	8a 06                	mov    (%esi),%al
 518:	83 c4 10             	add    $0x10,%esp
 51b:	84 c0                	test   %al,%al
 51d:	75 e9                	jne    508 <printf+0x128>
 51f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 522:	31 d2                	xor    %edx,%edx
 524:	e9 fc fe ff ff       	jmp    425 <printf+0x45>
 529:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 52c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 52f:	52                   	push   %edx
 530:	e9 4c ff ff ff       	jmp    481 <printf+0xa1>
 535:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 538:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53b:	8b 03                	mov    (%ebx),%eax
 53d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 540:	51                   	push   %ecx
 541:	6a 01                	push   $0x1
 543:	57                   	push   %edi
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 82 fd ff ff       	call   2ce <write>
        ap++;
 54c:	83 c3 04             	add    $0x4,%ebx
 54f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 552:	83 c4 10             	add    $0x10,%esp
      state = 0;
 555:	31 d2                	xor    %edx,%edx
 557:	e9 c9 fe ff ff       	jmp    425 <printf+0x45>
          s = "(null)";
 55c:	bb 03 07 00 00       	mov    $0x703,%ebx
        while(*s != 0){
 561:	b0 28                	mov    $0x28,%al
 563:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 566:	89 de                	mov    %ebx,%esi
 568:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56b:	eb 9b                	jmp    508 <printf+0x128>
      state = 0;
 56d:	31 d2                	xor    %edx,%edx
 56f:	e9 b1 fe ff ff       	jmp    425 <printf+0x45>

00000574 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	57                   	push   %edi
 578:	56                   	push   %esi
 579:	53                   	push   %ebx
 57a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 57d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 580:	a1 34 0a 00 00       	mov    0xa34,%eax
 585:	8b 10                	mov    (%eax),%edx
 587:	39 c8                	cmp    %ecx,%eax
 589:	73 11                	jae    59c <free+0x28>
 58b:	90                   	nop
 58c:	39 d1                	cmp    %edx,%ecx
 58e:	72 14                	jb     5a4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 d0                	cmp    %edx,%eax
 592:	73 10                	jae    5a4 <free+0x30>
{
 594:	89 d0                	mov    %edx,%eax
 596:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 598:	39 c8                	cmp    %ecx,%eax
 59a:	72 f0                	jb     58c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59c:	39 d0                	cmp    %edx,%eax
 59e:	72 f4                	jb     594 <free+0x20>
 5a0:	39 d1                	cmp    %edx,%ecx
 5a2:	73 f0                	jae    594 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5aa:	39 fa                	cmp    %edi,%edx
 5ac:	74 1a                	je     5c8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ae:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b1:	8b 50 04             	mov    0x4(%eax),%edx
 5b4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b7:	39 f1                	cmp    %esi,%ecx
 5b9:	74 24                	je     5df <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5bb:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5bd:	a3 34 0a 00 00       	mov    %eax,0xa34
}
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5c8:	03 72 04             	add    0x4(%edx),%esi
 5cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ce:	8b 10                	mov    (%eax),%edx
 5d0:	8b 12                	mov    (%edx),%edx
 5d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d5:	8b 50 04             	mov    0x4(%eax),%edx
 5d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5db:	39 f1                	cmp    %esi,%ecx
 5dd:	75 dc                	jne    5bb <free+0x47>
    p->s.size += bp->s.size;
 5df:	03 53 fc             	add    -0x4(%ebx),%edx
 5e2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5e5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 5ea:	a3 34 0a 00 00       	mov    %eax,0xa34
}
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    

000005f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	56                   	push   %esi
 5f9:	53                   	push   %ebx
 5fa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	8d 70 07             	lea    0x7(%eax),%esi
 603:	c1 ee 03             	shr    $0x3,%esi
 606:	46                   	inc    %esi
  if((prevp = freep) == 0){
 607:	8b 3d 34 0a 00 00    	mov    0xa34,%edi
 60d:	85 ff                	test   %edi,%edi
 60f:	0f 84 a3 00 00 00    	je     6b8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 615:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 617:	8b 48 04             	mov    0x4(%eax),%ecx
 61a:	39 f1                	cmp    %esi,%ecx
 61c:	73 67                	jae    685 <malloc+0x91>
 61e:	89 f3                	mov    %esi,%ebx
 620:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 626:	0f 82 80 00 00 00    	jb     6ac <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 62c:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 633:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 636:	eb 11                	jmp    649 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 638:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 63a:	8b 4a 04             	mov    0x4(%edx),%ecx
 63d:	39 f1                	cmp    %esi,%ecx
 63f:	73 4b                	jae    68c <malloc+0x98>
 641:	8b 3d 34 0a 00 00    	mov    0xa34,%edi
 647:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 649:	39 c7                	cmp    %eax,%edi
 64b:	75 eb                	jne    638 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 64d:	83 ec 0c             	sub    $0xc,%esp
 650:	ff 75 e4             	pushl  -0x1c(%ebp)
 653:	e8 de fc ff ff       	call   336 <sbrk>
  if(p == (char*)-1)
 658:	83 c4 10             	add    $0x10,%esp
 65b:	83 f8 ff             	cmp    $0xffffffff,%eax
 65e:	74 1b                	je     67b <malloc+0x87>
  hp->s.size = nu;
 660:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	83 c0 08             	add    $0x8,%eax
 669:	50                   	push   %eax
 66a:	e8 05 ff ff ff       	call   574 <free>
  return freep;
 66f:	a1 34 0a 00 00       	mov    0xa34,%eax
      if((p = morecore(nunits)) == 0)
 674:	83 c4 10             	add    $0x10,%esp
 677:	85 c0                	test   %eax,%eax
 679:	75 bd                	jne    638 <malloc+0x44>
        return 0;
 67b:	31 c0                	xor    %eax,%eax
  }
}
 67d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 680:	5b                   	pop    %ebx
 681:	5e                   	pop    %esi
 682:	5f                   	pop    %edi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    
    if(p->s.size >= nunits){
 685:	89 c2                	mov    %eax,%edx
 687:	89 f8                	mov    %edi,%eax
 689:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 68c:	39 ce                	cmp    %ecx,%esi
 68e:	74 54                	je     6e4 <malloc+0xf0>
        p->s.size -= nunits;
 690:	29 f1                	sub    %esi,%ecx
 692:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 695:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 698:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 69b:	a3 34 0a 00 00       	mov    %eax,0xa34
      return (void*)(p + 1);
 6a0:	8d 42 08             	lea    0x8(%edx),%eax
}
 6a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a6:	5b                   	pop    %ebx
 6a7:	5e                   	pop    %esi
 6a8:	5f                   	pop    %edi
 6a9:	5d                   	pop    %ebp
 6aa:	c3                   	ret    
 6ab:	90                   	nop
 6ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b1:	e9 76 ff ff ff       	jmp    62c <malloc+0x38>
 6b6:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6b8:	c7 05 34 0a 00 00 38 	movl   $0xa38,0xa34
 6bf:	0a 00 00 
 6c2:	c7 05 38 0a 00 00 38 	movl   $0xa38,0xa38
 6c9:	0a 00 00 
    base.s.size = 0;
 6cc:	c7 05 3c 0a 00 00 00 	movl   $0x0,0xa3c
 6d3:	00 00 00 
 6d6:	bf 38 0a 00 00       	mov    $0xa38,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6db:	89 f8                	mov    %edi,%eax
 6dd:	e9 3c ff ff ff       	jmp    61e <malloc+0x2a>
 6e2:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6e4:	8b 0a                	mov    (%edx),%ecx
 6e6:	89 08                	mov    %ecx,(%eax)
 6e8:	eb b1                	jmp    69b <malloc+0xa7>

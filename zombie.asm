
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	50                   	push   %eax
  if(fork() > 0)
   f:	e8 52 02 00 00       	call   266 <fork>
  14:	85 c0                	test   %eax,%eax
  16:	7e 0d                	jle    25 <main+0x25>
    sleep(5);  // Let child exit before parent.
  18:	83 ec 0c             	sub    $0xc,%esp
  1b:	6a 05                	push   $0x5
  1d:	e8 dc 02 00 00       	call   2fe <sleep>
  22:	83 c4 10             	add    $0x10,%esp
  exit();
  25:	e8 44 02 00 00       	call   26e <exit>
  2a:	66 90                	xchg   %ax,%ax

0000002c <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	53                   	push   %ebx
  30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	31 c0                	xor    %eax,%eax
  38:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  3b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  3e:	40                   	inc    %eax
  3f:	84 d2                	test   %dl,%dl
  41:	75 f5                	jne    38 <strcpy+0xc>
    ;
  return os;
}
  43:	89 c8                	mov    %ecx,%eax
  45:	5b                   	pop    %ebx
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	53                   	push   %ebx
  4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  52:	0f b6 03             	movzbl (%ebx),%eax
  55:	0f b6 0a             	movzbl (%edx),%ecx
  58:	84 c0                	test   %al,%al
  5a:	75 10                	jne    6c <strcmp+0x24>
  5c:	eb 1a                	jmp    78 <strcmp+0x30>
  5e:	66 90                	xchg   %ax,%ax
    p++, q++;
  60:	43                   	inc    %ebx
  61:	42                   	inc    %edx
  while(*p && *p == *q)
  62:	0f b6 03             	movzbl (%ebx),%eax
  65:	0f b6 0a             	movzbl (%edx),%ecx
  68:	84 c0                	test   %al,%al
  6a:	74 0c                	je     78 <strcmp+0x30>
  6c:	38 c8                	cmp    %cl,%al
  6e:	74 f0                	je     60 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  70:	29 c8                	sub    %ecx,%eax
}
  72:	5b                   	pop    %ebx
  73:	5d                   	pop    %ebp
  74:	c3                   	ret    
  75:	8d 76 00             	lea    0x0(%esi),%esi
  78:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  7a:	29 c8                	sub    %ecx,%eax
}
  7c:	5b                   	pop    %ebx
  7d:	5d                   	pop    %ebp
  7e:	c3                   	ret    
  7f:	90                   	nop

00000080 <strlen>:

uint
strlen(const char *s)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  86:	80 3a 00             	cmpb   $0x0,(%edx)
  89:	74 15                	je     a0 <strlen+0x20>
  8b:	31 c0                	xor    %eax,%eax
  8d:	8d 76 00             	lea    0x0(%esi),%esi
  90:	40                   	inc    %eax
  91:	89 c1                	mov    %eax,%ecx
  93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  97:	75 f7                	jne    90 <strlen+0x10>
    ;
  return n;
}
  99:	89 c8                	mov    %ecx,%eax
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  a0:	31 c9                	xor    %ecx,%ecx
}
  a2:	89 c8                	mov    %ecx,%eax
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    
  a6:	66 90                	xchg   %ax,%ax

000000a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	fc                   	cld    
  b6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	5f                   	pop    %edi
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    
  be:	66 90                	xchg   %ax,%ax

000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  c9:	8a 10                	mov    (%eax),%dl
  cb:	84 d2                	test   %dl,%dl
  cd:	75 0c                	jne    db <strchr+0x1b>
  cf:	eb 13                	jmp    e4 <strchr+0x24>
  d1:	8d 76 00             	lea    0x0(%esi),%esi
  d4:	40                   	inc    %eax
  d5:	8a 10                	mov    (%eax),%dl
  d7:	84 d2                	test   %dl,%dl
  d9:	74 09                	je     e4 <strchr+0x24>
    if(*s == c)
  db:	38 d1                	cmp    %dl,%cl
  dd:	75 f5                	jne    d4 <strchr+0x14>
      return (char*)s;
  return 0;
}
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  e4:	31 c0                	xor    %eax,%eax
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
  ec:	56                   	push   %esi
  ed:	53                   	push   %ebx
  ee:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f1:	8b 75 08             	mov    0x8(%ebp),%esi
  f4:	bb 01 00 00 00       	mov    $0x1,%ebx
  f9:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
  fb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  fe:	eb 20                	jmp    120 <gets+0x38>
    cc = read(0, &c, 1);
 100:	50                   	push   %eax
 101:	6a 01                	push   $0x1
 103:	57                   	push   %edi
 104:	6a 00                	push   $0x0
 106:	e8 7b 01 00 00       	call   286 <read>
    if(cc < 1)
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	85 c0                	test   %eax,%eax
 110:	7e 16                	jle    128 <gets+0x40>
      break;
    buf[i++] = c;
 112:	8a 45 e7             	mov    -0x19(%ebp),%al
 115:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 117:	46                   	inc    %esi
 118:	3c 0a                	cmp    $0xa,%al
 11a:	74 0c                	je     128 <gets+0x40>
 11c:	3c 0d                	cmp    $0xd,%al
 11e:	74 08                	je     128 <gets+0x40>
  for(i=0; i+1 < max; ){
 120:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 123:	39 45 0c             	cmp    %eax,0xc(%ebp)
 126:	7f d8                	jg     100 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 128:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 131:	5b                   	pop    %ebx
 132:	5e                   	pop    %esi
 133:	5f                   	pop    %edi
 134:	5d                   	pop    %ebp
 135:	c3                   	ret    
 136:	66 90                	xchg   %ax,%ax

00000138 <stat>:

int
stat(const char *n, struct stat *st)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	56                   	push   %esi
 13c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	6a 00                	push   $0x0
 142:	ff 75 08             	pushl  0x8(%ebp)
 145:	e8 64 01 00 00       	call   2ae <open>
  if(fd < 0)
 14a:	83 c4 10             	add    $0x10,%esp
 14d:	85 c0                	test   %eax,%eax
 14f:	78 27                	js     178 <stat+0x40>
 151:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 153:	83 ec 08             	sub    $0x8,%esp
 156:	ff 75 0c             	pushl  0xc(%ebp)
 159:	50                   	push   %eax
 15a:	e8 67 01 00 00       	call   2c6 <fstat>
 15f:	89 c6                	mov    %eax,%esi
  close(fd);
 161:	89 1c 24             	mov    %ebx,(%esp)
 164:	e8 2d 01 00 00       	call   296 <close>
  return r;
 169:	83 c4 10             	add    $0x10,%esp
}
 16c:	89 f0                	mov    %esi,%eax
 16e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 171:	5b                   	pop    %ebx
 172:	5e                   	pop    %esi
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    
 175:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 178:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17d:	eb ed                	jmp    16c <stat+0x34>
 17f:	90                   	nop

00000180 <atoi>:

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 187:	0f be 01             	movsbl (%ecx),%eax
 18a:	8d 50 d0             	lea    -0x30(%eax),%edx
 18d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 190:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 195:	77 16                	ja     1ad <atoi+0x2d>
 197:	90                   	nop
    n = n*10 + *s++ - '0';
 198:	41                   	inc    %ecx
 199:	8d 14 92             	lea    (%edx,%edx,4),%edx
 19c:	01 d2                	add    %edx,%edx
 19e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1a2:	0f be 01             	movsbl (%ecx),%eax
 1a5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a8:	80 fb 09             	cmp    $0x9,%bl
 1ab:	76 eb                	jbe    198 <atoi+0x18>
  return n;
}
 1ad:	89 d0                	mov    %edx,%eax
 1af:	5b                   	pop    %ebx
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    
 1b2:	66 90                	xchg   %ax,%ax

000001b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	8b 75 0c             	mov    0xc(%ebp),%esi
 1bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1c2:	85 d2                	test   %edx,%edx
 1c4:	7e 0b                	jle    1d1 <memmove+0x1d>
 1c6:	01 c2                	add    %eax,%edx
  dst = vdst;
 1c8:	89 c7                	mov    %eax,%edi
 1ca:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1cc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1cd:	39 fa                	cmp    %edi,%edx
 1cf:	75 fb                	jne    1cc <memmove+0x18>
  return vdst;
}
 1d1:	5e                   	pop    %esi
 1d2:	5f                   	pop    %edi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 76 00             	lea    0x0(%esi),%esi

000001d8 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    
 1e6:	66 90                	xchg   %ax,%ax

000001e8 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 1ee:	b9 01 00 00 00       	mov    $0x1,%ecx
 1f3:	90                   	nop
 1f4:	89 c8                	mov    %ecx,%eax
 1f6:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 1f9:	85 c0                	test   %eax,%eax
 1fb:	75 f7                	jne    1f4 <lock_acquire+0xc>
}
 1fd:	5d                   	pop    %ebp
 1fe:	c3                   	ret    
 1ff:	90                   	nop

00000200 <lock_release>:

void lock_release(lock_t *lock) {
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	31 c0                	xor    %eax,%eax
 208:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    
 20d:	8d 76 00             	lea    0x0(%esi),%esi

00000210 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 216:	68 00 20 00 00       	push   $0x2000
 21b:	e8 94 03 00 00       	call   5b4 <malloc>

  if((uint)stack % PGSIZE)
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 c2                	mov    %eax,%edx
 225:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 22b:	74 07                	je     234 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 22d:	29 d0                	sub    %edx,%eax
 22f:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 234:	ff 75 0c             	pushl  0xc(%ebp)
 237:	6a 08                	push   $0x8
 239:	50                   	push   %eax
 23a:	ff 75 08             	pushl  0x8(%ebp)
 23d:	e8 cc 00 00 00       	call   30e <clone>

  if (tid < 0) {
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 07                	js     250 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 249:	31 c0                	xor    %eax,%eax
 24b:	c9                   	leave  
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 250:	83 ec 08             	sub    $0x8,%esp
 253:	68 ac 06 00 00       	push   $0x6ac
 258:	6a 01                	push   $0x1
 25a:	e8 41 01 00 00       	call   3a0 <printf>
      return 0;
 25f:	83 c4 10             	add    $0x10,%esp
}
 262:	31 c0                	xor    %eax,%eax
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 266:	b8 01 00 00 00       	mov    $0x1,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <exit>:
SYSCALL(exit)
 26e:	b8 02 00 00 00       	mov    $0x2,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <wait>:
SYSCALL(wait)
 276:	b8 03 00 00 00       	mov    $0x3,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <pipe>:
SYSCALL(pipe)
 27e:	b8 04 00 00 00       	mov    $0x4,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <read>:
SYSCALL(read)
 286:	b8 05 00 00 00       	mov    $0x5,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <write>:
SYSCALL(write)
 28e:	b8 10 00 00 00       	mov    $0x10,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <close>:
SYSCALL(close)
 296:	b8 15 00 00 00       	mov    $0x15,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <kill>:
SYSCALL(kill)
 29e:	b8 06 00 00 00       	mov    $0x6,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <exec>:
SYSCALL(exec)
 2a6:	b8 07 00 00 00       	mov    $0x7,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <open>:
SYSCALL(open)
 2ae:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <mknod>:
SYSCALL(mknod)
 2b6:	b8 11 00 00 00       	mov    $0x11,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <unlink>:
SYSCALL(unlink)
 2be:	b8 12 00 00 00       	mov    $0x12,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <fstat>:
SYSCALL(fstat)
 2c6:	b8 08 00 00 00       	mov    $0x8,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <link>:
SYSCALL(link)
 2ce:	b8 13 00 00 00       	mov    $0x13,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <mkdir>:
SYSCALL(mkdir)
 2d6:	b8 14 00 00 00       	mov    $0x14,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <chdir>:
SYSCALL(chdir)
 2de:	b8 09 00 00 00       	mov    $0x9,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <dup>:
SYSCALL(dup)
 2e6:	b8 0a 00 00 00       	mov    $0xa,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <getpid>:
SYSCALL(getpid)
 2ee:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <sbrk>:
SYSCALL(sbrk)
 2f6:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <sleep>:
SYSCALL(sleep)
 2fe:	b8 0d 00 00 00       	mov    $0xd,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <uptime>:
SYSCALL(uptime)
 306:	b8 0e 00 00 00       	mov    $0xe,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <clone>:
 30e:	b8 16 00 00 00       	mov    $0x16,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    
 316:	66 90                	xchg   %ax,%ax

00000318 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	57                   	push   %edi
 31c:	56                   	push   %esi
 31d:	53                   	push   %ebx
 31e:	83 ec 3c             	sub    $0x3c,%esp
 321:	89 45 bc             	mov    %eax,-0x44(%ebp)
 324:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 327:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 329:	8b 5d 08             	mov    0x8(%ebp),%ebx
 32c:	85 db                	test   %ebx,%ebx
 32e:	74 04                	je     334 <printint+0x1c>
 330:	85 d2                	test   %edx,%edx
 332:	78 68                	js     39c <printint+0x84>
  neg = 0;
 334:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 33b:	31 ff                	xor    %edi,%edi
 33d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 340:	89 c8                	mov    %ecx,%eax
 342:	31 d2                	xor    %edx,%edx
 344:	f7 75 c4             	divl   -0x3c(%ebp)
 347:	89 fb                	mov    %edi,%ebx
 349:	8d 7f 01             	lea    0x1(%edi),%edi
 34c:	8a 92 c4 06 00 00    	mov    0x6c4(%edx),%dl
 352:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 356:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 359:	89 c1                	mov    %eax,%ecx
 35b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 35e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 361:	76 dd                	jbe    340 <printint+0x28>
  if(neg)
 363:	8b 4d 08             	mov    0x8(%ebp),%ecx
 366:	85 c9                	test   %ecx,%ecx
 368:	74 09                	je     373 <printint+0x5b>
    buf[i++] = '-';
 36a:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 36f:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 371:	b2 2d                	mov    $0x2d,%dl
 373:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 377:	8b 7d bc             	mov    -0x44(%ebp),%edi
 37a:	eb 03                	jmp    37f <printint+0x67>
 37c:	8a 13                	mov    (%ebx),%dl
 37e:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 37f:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 382:	50                   	push   %eax
 383:	6a 01                	push   $0x1
 385:	56                   	push   %esi
 386:	57                   	push   %edi
 387:	e8 02 ff ff ff       	call   28e <write>
  while(--i >= 0)
 38c:	83 c4 10             	add    $0x10,%esp
 38f:	39 de                	cmp    %ebx,%esi
 391:	75 e9                	jne    37c <printint+0x64>
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	90                   	nop
    x = -xx;
 39c:	f7 d9                	neg    %ecx
 39e:	eb 9b                	jmp    33b <printint+0x23>

000003a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3ac:	8a 1e                	mov    (%esi),%bl
 3ae:	84 db                	test   %bl,%bl
 3b0:	0f 84 a3 00 00 00    	je     459 <printf+0xb9>
 3b6:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3b7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 3bd:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 3bf:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3c2:	eb 29                	jmp    3ed <printf+0x4d>
 3c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3c7:	83 f8 25             	cmp    $0x25,%eax
 3ca:	0f 84 94 00 00 00    	je     464 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 3d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3d3:	50                   	push   %eax
 3d4:	6a 01                	push   $0x1
 3d6:	57                   	push   %edi
 3d7:	ff 75 08             	pushl  0x8(%ebp)
 3da:	e8 af fe ff ff       	call   28e <write>
        putc(fd, c);
 3df:	83 c4 10             	add    $0x10,%esp
 3e2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3e5:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 3e6:	8a 5e ff             	mov    -0x1(%esi),%bl
 3e9:	84 db                	test   %bl,%bl
 3eb:	74 6c                	je     459 <printf+0xb9>
    c = fmt[i] & 0xff;
 3ed:	0f be cb             	movsbl %bl,%ecx
 3f0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3f3:	85 d2                	test   %edx,%edx
 3f5:	74 cd                	je     3c4 <printf+0x24>
      }
    } else if(state == '%'){
 3f7:	83 fa 25             	cmp    $0x25,%edx
 3fa:	75 e9                	jne    3e5 <printf+0x45>
      if(c == 'd'){
 3fc:	83 f8 64             	cmp    $0x64,%eax
 3ff:	0f 84 97 00 00 00    	je     49c <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 405:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 40b:	83 f9 70             	cmp    $0x70,%ecx
 40e:	74 60                	je     470 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 410:	83 f8 73             	cmp    $0x73,%eax
 413:	0f 84 8f 00 00 00    	je     4a8 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 419:	83 f8 63             	cmp    $0x63,%eax
 41c:	0f 84 d6 00 00 00    	je     4f8 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 422:	83 f8 25             	cmp    $0x25,%eax
 425:	0f 84 c1 00 00 00    	je     4ec <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 42b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 42f:	50                   	push   %eax
 430:	6a 01                	push   $0x1
 432:	57                   	push   %edi
 433:	ff 75 08             	pushl  0x8(%ebp)
 436:	e8 53 fe ff ff       	call   28e <write>
        putc(fd, c);
 43b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 43e:	83 c4 0c             	add    $0xc,%esp
 441:	6a 01                	push   $0x1
 443:	57                   	push   %edi
 444:	ff 75 08             	pushl  0x8(%ebp)
 447:	e8 42 fe ff ff       	call   28e <write>
        putc(fd, c);
 44c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 44f:	31 d2                	xor    %edx,%edx
 451:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 452:	8a 5e ff             	mov    -0x1(%esi),%bl
 455:	84 db                	test   %bl,%bl
 457:	75 94                	jne    3ed <printf+0x4d>
    }
  }
}
 459:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45c:	5b                   	pop    %ebx
 45d:	5e                   	pop    %esi
 45e:	5f                   	pop    %edi
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 464:	ba 25 00 00 00       	mov    $0x25,%edx
 469:	e9 77 ff ff ff       	jmp    3e5 <printf+0x45>
 46e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 470:	83 ec 0c             	sub    $0xc,%esp
 473:	6a 00                	push   $0x0
 475:	b9 10 00 00 00       	mov    $0x10,%ecx
 47a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 47d:	8b 13                	mov    (%ebx),%edx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	e8 91 fe ff ff       	call   318 <printint>
        ap++;
 487:	89 d8                	mov    %ebx,%eax
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 48f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 492:	31 d2                	xor    %edx,%edx
        ap++;
 494:	e9 4c ff ff ff       	jmp    3e5 <printf+0x45>
 499:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 49c:	83 ec 0c             	sub    $0xc,%esp
 49f:	6a 01                	push   $0x1
 4a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4a6:	eb d2                	jmp    47a <printf+0xda>
        s = (char*)*ap;
 4a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4ab:	8b 18                	mov    (%eax),%ebx
        ap++;
 4ad:	83 c0 04             	add    $0x4,%eax
 4b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4b3:	85 db                	test   %ebx,%ebx
 4b5:	74 65                	je     51c <printf+0x17c>
        while(*s != 0){
 4b7:	8a 03                	mov    (%ebx),%al
 4b9:	84 c0                	test   %al,%al
 4bb:	74 70                	je     52d <printf+0x18d>
 4bd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4c0:	89 de                	mov    %ebx,%esi
 4c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 4c8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	50                   	push   %eax
 4cc:	6a 01                	push   $0x1
 4ce:	57                   	push   %edi
 4cf:	53                   	push   %ebx
 4d0:	e8 b9 fd ff ff       	call   28e <write>
          s++;
 4d5:	46                   	inc    %esi
        while(*s != 0){
 4d6:	8a 06                	mov    (%esi),%al
 4d8:	83 c4 10             	add    $0x10,%esp
 4db:	84 c0                	test   %al,%al
 4dd:	75 e9                	jne    4c8 <printf+0x128>
 4df:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	e9 fc fe ff ff       	jmp    3e5 <printf+0x45>
 4e9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 4ec:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4ef:	52                   	push   %edx
 4f0:	e9 4c ff ff ff       	jmp    441 <printf+0xa1>
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4f8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4fb:	8b 03                	mov    (%ebx),%eax
 4fd:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 500:	51                   	push   %ecx
 501:	6a 01                	push   $0x1
 503:	57                   	push   %edi
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 82 fd ff ff       	call   28e <write>
        ap++;
 50c:	83 c3 04             	add    $0x4,%ebx
 50f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 512:	83 c4 10             	add    $0x10,%esp
      state = 0;
 515:	31 d2                	xor    %edx,%edx
 517:	e9 c9 fe ff ff       	jmp    3e5 <printf+0x45>
          s = "(null)";
 51c:	bb bc 06 00 00       	mov    $0x6bc,%ebx
        while(*s != 0){
 521:	b0 28                	mov    $0x28,%al
 523:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 526:	89 de                	mov    %ebx,%esi
 528:	8b 5d 08             	mov    0x8(%ebp),%ebx
 52b:	eb 9b                	jmp    4c8 <printf+0x128>
      state = 0;
 52d:	31 d2                	xor    %edx,%edx
 52f:	e9 b1 fe ff ff       	jmp    3e5 <printf+0x45>

00000534 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	57                   	push   %edi
 538:	56                   	push   %esi
 539:	53                   	push   %ebx
 53a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 53d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 540:	a1 e4 09 00 00       	mov    0x9e4,%eax
 545:	8b 10                	mov    (%eax),%edx
 547:	39 c8                	cmp    %ecx,%eax
 549:	73 11                	jae    55c <free+0x28>
 54b:	90                   	nop
 54c:	39 d1                	cmp    %edx,%ecx
 54e:	72 14                	jb     564 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 550:	39 d0                	cmp    %edx,%eax
 552:	73 10                	jae    564 <free+0x30>
{
 554:	89 d0                	mov    %edx,%eax
 556:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 558:	39 c8                	cmp    %ecx,%eax
 55a:	72 f0                	jb     54c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55c:	39 d0                	cmp    %edx,%eax
 55e:	72 f4                	jb     554 <free+0x20>
 560:	39 d1                	cmp    %edx,%ecx
 562:	73 f0                	jae    554 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 564:	8b 73 fc             	mov    -0x4(%ebx),%esi
 567:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56a:	39 fa                	cmp    %edi,%edx
 56c:	74 1a                	je     588 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 56e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 571:	8b 50 04             	mov    0x4(%eax),%edx
 574:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 577:	39 f1                	cmp    %esi,%ecx
 579:	74 24                	je     59f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 57b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 57d:	a3 e4 09 00 00       	mov    %eax,0x9e4
}
 582:	5b                   	pop    %ebx
 583:	5e                   	pop    %esi
 584:	5f                   	pop    %edi
 585:	5d                   	pop    %ebp
 586:	c3                   	ret    
 587:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 588:	03 72 04             	add    0x4(%edx),%esi
 58b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 58e:	8b 10                	mov    (%eax),%edx
 590:	8b 12                	mov    (%edx),%edx
 592:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 595:	8b 50 04             	mov    0x4(%eax),%edx
 598:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 59b:	39 f1                	cmp    %esi,%ecx
 59d:	75 dc                	jne    57b <free+0x47>
    p->s.size += bp->s.size;
 59f:	03 53 fc             	add    -0x4(%ebx),%edx
 5a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5a5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5a8:	89 10                	mov    %edx,(%eax)
  freep = p;
 5aa:	a3 e4 09 00 00       	mov    %eax,0x9e4
}
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    

000005b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	8d 70 07             	lea    0x7(%eax),%esi
 5c3:	c1 ee 03             	shr    $0x3,%esi
 5c6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5c7:	8b 3d e4 09 00 00    	mov    0x9e4,%edi
 5cd:	85 ff                	test   %edi,%edi
 5cf:	0f 84 a3 00 00 00    	je     678 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d5:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 5d7:	8b 48 04             	mov    0x4(%eax),%ecx
 5da:	39 f1                	cmp    %esi,%ecx
 5dc:	73 67                	jae    645 <malloc+0x91>
 5de:	89 f3                	mov    %esi,%ebx
 5e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 5e6:	0f 82 80 00 00 00    	jb     66c <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 5ec:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 5f3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 5f6:	eb 11                	jmp    609 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f8:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5fa:	8b 4a 04             	mov    0x4(%edx),%ecx
 5fd:	39 f1                	cmp    %esi,%ecx
 5ff:	73 4b                	jae    64c <malloc+0x98>
 601:	8b 3d e4 09 00 00    	mov    0x9e4,%edi
 607:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 609:	39 c7                	cmp    %eax,%edi
 60b:	75 eb                	jne    5f8 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 60d:	83 ec 0c             	sub    $0xc,%esp
 610:	ff 75 e4             	pushl  -0x1c(%ebp)
 613:	e8 de fc ff ff       	call   2f6 <sbrk>
  if(p == (char*)-1)
 618:	83 c4 10             	add    $0x10,%esp
 61b:	83 f8 ff             	cmp    $0xffffffff,%eax
 61e:	74 1b                	je     63b <malloc+0x87>
  hp->s.size = nu;
 620:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	83 c0 08             	add    $0x8,%eax
 629:	50                   	push   %eax
 62a:	e8 05 ff ff ff       	call   534 <free>
  return freep;
 62f:	a1 e4 09 00 00       	mov    0x9e4,%eax
      if((p = morecore(nunits)) == 0)
 634:	83 c4 10             	add    $0x10,%esp
 637:	85 c0                	test   %eax,%eax
 639:	75 bd                	jne    5f8 <malloc+0x44>
        return 0;
 63b:	31 c0                	xor    %eax,%eax
  }
}
 63d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 640:	5b                   	pop    %ebx
 641:	5e                   	pop    %esi
 642:	5f                   	pop    %edi
 643:	5d                   	pop    %ebp
 644:	c3                   	ret    
    if(p->s.size >= nunits){
 645:	89 c2                	mov    %eax,%edx
 647:	89 f8                	mov    %edi,%eax
 649:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 64c:	39 ce                	cmp    %ecx,%esi
 64e:	74 54                	je     6a4 <malloc+0xf0>
        p->s.size -= nunits;
 650:	29 f1                	sub    %esi,%ecx
 652:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 655:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 658:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 65b:	a3 e4 09 00 00       	mov    %eax,0x9e4
      return (void*)(p + 1);
 660:	8d 42 08             	lea    0x8(%edx),%eax
}
 663:	8d 65 f4             	lea    -0xc(%ebp),%esp
 666:	5b                   	pop    %ebx
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
 66b:	90                   	nop
 66c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 671:	e9 76 ff ff ff       	jmp    5ec <malloc+0x38>
 676:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 678:	c7 05 e4 09 00 00 e8 	movl   $0x9e8,0x9e4
 67f:	09 00 00 
 682:	c7 05 e8 09 00 00 e8 	movl   $0x9e8,0x9e8
 689:	09 00 00 
    base.s.size = 0;
 68c:	c7 05 ec 09 00 00 00 	movl   $0x0,0x9ec
 693:	00 00 00 
 696:	bf e8 09 00 00       	mov    $0x9e8,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69b:	89 f8                	mov    %edi,%eax
 69d:	e9 3c ff ff ff       	jmp    5de <malloc+0x2a>
 6a2:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6a4:	8b 0a                	mov    (%edx),%ecx
 6a6:	89 08                	mov    %ecx,(%eax)
 6a8:	eb b1                	jmp    65b <malloc+0xa7>

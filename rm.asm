
_rm:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 3c                	jle    5a <main+0x5a>
  1e:	83 c3 04             	add    $0x4,%ebx
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bf 01 00 00 00       	mov    $0x1,%edi
  26:	66 90                	xchg   %ax,%ax
    if(unlink(argv[i]) < 0){
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	e8 d0 02 00 00       	call   302 <unlink>
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	78 0d                	js     46 <main+0x46>
  for(i = 1; i < argc; i++){
  39:	47                   	inc    %edi
  3a:	83 c3 04             	add    $0x4,%ebx
  3d:	39 fe                	cmp    %edi,%esi
  3f:	75 e7                	jne    28 <main+0x28>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  41:	e8 6c 02 00 00       	call   2b2 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  46:	50                   	push   %eax
  47:	ff 33                	pushl  (%ebx)
  49:	68 04 07 00 00       	push   $0x704
  4e:	6a 02                	push   $0x2
  50:	e8 8f 03 00 00       	call   3e4 <printf>
      break;
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e7                	jmp    41 <main+0x41>
    printf(2, "Usage: rm files...\n");
  5a:	52                   	push   %edx
  5b:	52                   	push   %edx
  5c:	68 f0 06 00 00       	push   $0x6f0
  61:	6a 02                	push   $0x2
  63:	e8 7c 03 00 00       	call   3e4 <printf>
    exit();
  68:	e8 45 02 00 00       	call   2b2 <exit>
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	31 c0                	xor    %eax,%eax
  7c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  7f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  82:	40                   	inc    %eax
  83:	84 d2                	test   %dl,%dl
  85:	75 f5                	jne    7c <strcpy+0xc>
    ;
  return os;
}
  87:	89 c8                	mov    %ecx,%eax
  89:	5b                   	pop    %ebx
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	53                   	push   %ebx
  90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 03             	movzbl (%ebx),%eax
  99:	0f b6 0a             	movzbl (%edx),%ecx
  9c:	84 c0                	test   %al,%al
  9e:	75 10                	jne    b0 <strcmp+0x24>
  a0:	eb 1a                	jmp    bc <strcmp+0x30>
  a2:	66 90                	xchg   %ax,%ax
    p++, q++;
  a4:	43                   	inc    %ebx
  a5:	42                   	inc    %edx
  while(*p && *p == *q)
  a6:	0f b6 03             	movzbl (%ebx),%eax
  a9:	0f b6 0a             	movzbl (%edx),%ecx
  ac:	84 c0                	test   %al,%al
  ae:	74 0c                	je     bc <strcmp+0x30>
  b0:	38 c8                	cmp    %cl,%al
  b2:	74 f0                	je     a4 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b4:	29 c8                	sub    %ecx,%eax
}
  b6:	5b                   	pop    %ebx
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    
  b9:	8d 76 00             	lea    0x0(%esi),%esi
  bc:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  be:	29 c8                	sub    %ecx,%eax
}
  c0:	5b                   	pop    %ebx
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    
  c3:	90                   	nop

000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ca:	80 3a 00             	cmpb   $0x0,(%edx)
  cd:	74 15                	je     e4 <strlen+0x20>
  cf:	31 c0                	xor    %eax,%eax
  d1:	8d 76 00             	lea    0x0(%esi),%esi
  d4:	40                   	inc    %eax
  d5:	89 c1                	mov    %eax,%ecx
  d7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  db:	75 f7                	jne    d4 <strlen+0x10>
    ;
  return n;
}
  dd:	89 c8                	mov    %ecx,%eax
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e4:	31 c9                	xor    %ecx,%ecx
}
  e6:	89 c8                	mov    %ecx,%eax
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    
  ea:	66 90                	xchg   %ax,%ax

000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	fc                   	cld    
  fa:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    
 102:	66 90                	xchg   %ax,%ax

00000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 10d:	8a 10                	mov    (%eax),%dl
 10f:	84 d2                	test   %dl,%dl
 111:	75 0c                	jne    11f <strchr+0x1b>
 113:	eb 13                	jmp    128 <strchr+0x24>
 115:	8d 76 00             	lea    0x0(%esi),%esi
 118:	40                   	inc    %eax
 119:	8a 10                	mov    (%eax),%dl
 11b:	84 d2                	test   %dl,%dl
 11d:	74 09                	je     128 <strchr+0x24>
    if(*s == c)
 11f:	38 d1                	cmp    %dl,%cl
 121:	75 f5                	jne    118 <strchr+0x14>
      return (char*)s;
  return 0;
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    
 125:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 128:	31 c0                	xor    %eax,%eax
}
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	8b 75 08             	mov    0x8(%ebp),%esi
 138:	bb 01 00 00 00       	mov    $0x1,%ebx
 13d:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 13f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 142:	eb 20                	jmp    164 <gets+0x38>
    cc = read(0, &c, 1);
 144:	50                   	push   %eax
 145:	6a 01                	push   $0x1
 147:	57                   	push   %edi
 148:	6a 00                	push   $0x0
 14a:	e8 7b 01 00 00       	call   2ca <read>
    if(cc < 1)
 14f:	83 c4 10             	add    $0x10,%esp
 152:	85 c0                	test   %eax,%eax
 154:	7e 16                	jle    16c <gets+0x40>
      break;
    buf[i++] = c;
 156:	8a 45 e7             	mov    -0x19(%ebp),%al
 159:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 15b:	46                   	inc    %esi
 15c:	3c 0a                	cmp    $0xa,%al
 15e:	74 0c                	je     16c <gets+0x40>
 160:	3c 0d                	cmp    $0xd,%al
 162:	74 08                	je     16c <gets+0x40>
  for(i=0; i+1 < max; ){
 164:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 167:	39 45 0c             	cmp    %eax,0xc(%ebp)
 16a:	7f d8                	jg     144 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 16c:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    
 17a:	66 90                	xchg   %ax,%ax

0000017c <stat>:

int
stat(const char *n, struct stat *st)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 181:	83 ec 08             	sub    $0x8,%esp
 184:	6a 00                	push   $0x0
 186:	ff 75 08             	pushl  0x8(%ebp)
 189:	e8 64 01 00 00       	call   2f2 <open>
  if(fd < 0)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	85 c0                	test   %eax,%eax
 193:	78 27                	js     1bc <stat+0x40>
 195:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	ff 75 0c             	pushl  0xc(%ebp)
 19d:	50                   	push   %eax
 19e:	e8 67 01 00 00       	call   30a <fstat>
 1a3:	89 c6                	mov    %eax,%esi
  close(fd);
 1a5:	89 1c 24             	mov    %ebx,(%esp)
 1a8:	e8 2d 01 00 00       	call   2da <close>
  return r;
 1ad:	83 c4 10             	add    $0x10,%esp
}
 1b0:	89 f0                	mov    %esi,%eax
 1b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b5:	5b                   	pop    %ebx
 1b6:	5e                   	pop    %esi
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1bc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c1:	eb ed                	jmp    1b0 <stat+0x34>
 1c3:	90                   	nop

000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	53                   	push   %ebx
 1c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cb:	0f be 01             	movsbl (%ecx),%eax
 1ce:	8d 50 d0             	lea    -0x30(%eax),%edx
 1d1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d9:	77 16                	ja     1f1 <atoi+0x2d>
 1db:	90                   	nop
    n = n*10 + *s++ - '0';
 1dc:	41                   	inc    %ecx
 1dd:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1e0:	01 d2                	add    %edx,%edx
 1e2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1e6:	0f be 01             	movsbl (%ecx),%eax
 1e9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ec:	80 fb 09             	cmp    $0x9,%bl
 1ef:	76 eb                	jbe    1dc <atoi+0x18>
  return n;
}
 1f1:	89 d0                	mov    %edx,%eax
 1f3:	5b                   	pop    %ebx
 1f4:	5d                   	pop    %ebp
 1f5:	c3                   	ret    
 1f6:	66 90                	xchg   %ax,%ax

000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	57                   	push   %edi
 1fc:	56                   	push   %esi
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8b 75 0c             	mov    0xc(%ebp),%esi
 203:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 206:	85 d2                	test   %edx,%edx
 208:	7e 0b                	jle    215 <memmove+0x1d>
 20a:	01 c2                	add    %eax,%edx
  dst = vdst;
 20c:	89 c7                	mov    %eax,%edi
 20e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 210:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 211:	39 fa                	cmp    %edi,%edx
 213:	75 fb                	jne    210 <memmove+0x18>
  return vdst;
}
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
 219:	8d 76 00             	lea    0x0(%esi),%esi

0000021c <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    
 22a:	66 90                	xchg   %ax,%ax

0000022c <lock_acquire>:

void lock_acquire(lock_t *lock) {
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 232:	b9 01 00 00 00       	mov    $0x1,%ecx
 237:	90                   	nop
 238:	89 c8                	mov    %ecx,%eax
 23a:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 23d:	85 c0                	test   %eax,%eax
 23f:	75 f7                	jne    238 <lock_acquire+0xc>
}
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	90                   	nop

00000244 <lock_release>:

void lock_release(lock_t *lock) {
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	8b 55 08             	mov    0x8(%ebp),%edx
 24a:	31 c0                	xor    %eax,%eax
 24c:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d 76 00             	lea    0x0(%esi),%esi

00000254 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 25a:	68 00 20 00 00       	push   $0x2000
 25f:	e8 94 03 00 00       	call   5f8 <malloc>

  if((uint)stack % PGSIZE)
 264:	83 c4 10             	add    $0x10,%esp
 267:	89 c2                	mov    %eax,%edx
 269:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 26f:	74 07                	je     278 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 271:	29 d0                	sub    %edx,%eax
 273:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 278:	ff 75 0c             	pushl  0xc(%ebp)
 27b:	6a 08                	push   $0x8
 27d:	50                   	push   %eax
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 cc 00 00 00       	call   352 <clone>

  if (tid < 0) {
 286:	83 c4 10             	add    $0x10,%esp
 289:	85 c0                	test   %eax,%eax
 28b:	78 07                	js     294 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 28d:	31 c0                	xor    %eax,%eax
 28f:	c9                   	leave  
 290:	c3                   	ret    
 291:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 294:	83 ec 08             	sub    $0x8,%esp
 297:	68 1d 07 00 00       	push   $0x71d
 29c:	6a 01                	push   $0x1
 29e:	e8 41 01 00 00       	call   3e4 <printf>
      return 0;
 2a3:	83 c4 10             	add    $0x10,%esp
}
 2a6:	31 c0                	xor    %eax,%eax
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
SYSCALL(exit)
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
SYSCALL(wait)
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
SYSCALL(pipe)
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
SYSCALL(read)
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
SYSCALL(write)
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
SYSCALL(close)
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
SYSCALL(kill)
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
SYSCALL(exec)
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
SYSCALL(open)
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
SYSCALL(mknod)
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
SYSCALL(unlink)
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
SYSCALL(fstat)
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
SYSCALL(link)
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
SYSCALL(mkdir)
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
SYSCALL(chdir)
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
SYSCALL(dup)
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
SYSCALL(getpid)
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <clone>:
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    
 35a:	66 90                	xchg   %ax,%ax

0000035c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 3c             	sub    $0x3c,%esp
 365:	89 45 bc             	mov    %eax,-0x44(%ebp)
 368:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 36b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 36d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 370:	85 db                	test   %ebx,%ebx
 372:	74 04                	je     378 <printint+0x1c>
 374:	85 d2                	test   %edx,%edx
 376:	78 68                	js     3e0 <printint+0x84>
  neg = 0;
 378:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37f:	31 ff                	xor    %edi,%edi
 381:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 384:	89 c8                	mov    %ecx,%eax
 386:	31 d2                	xor    %edx,%edx
 388:	f7 75 c4             	divl   -0x3c(%ebp)
 38b:	89 fb                	mov    %edi,%ebx
 38d:	8d 7f 01             	lea    0x1(%edi),%edi
 390:	8a 92 34 07 00 00    	mov    0x734(%edx),%dl
 396:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 39a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 3a5:	76 dd                	jbe    384 <printint+0x28>
  if(neg)
 3a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3aa:	85 c9                	test   %ecx,%ecx
 3ac:	74 09                	je     3b7 <printint+0x5b>
    buf[i++] = '-';
 3ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 3b3:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3b5:	b2 2d                	mov    $0x2d,%dl
 3b7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3bb:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3be:	eb 03                	jmp    3c3 <printint+0x67>
 3c0:	8a 13                	mov    (%ebx),%dl
 3c2:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3c3:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3c6:	50                   	push   %eax
 3c7:	6a 01                	push   $0x1
 3c9:	56                   	push   %esi
 3ca:	57                   	push   %edi
 3cb:	e8 02 ff ff ff       	call   2d2 <write>
  while(--i >= 0)
 3d0:	83 c4 10             	add    $0x10,%esp
 3d3:	39 de                	cmp    %ebx,%esi
 3d5:	75 e9                	jne    3c0 <printint+0x64>
}
 3d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3da:	5b                   	pop    %ebx
 3db:	5e                   	pop    %esi
 3dc:	5f                   	pop    %edi
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop
    x = -xx;
 3e0:	f7 d9                	neg    %ecx
 3e2:	eb 9b                	jmp    37f <printint+0x23>

000003e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 3f0:	8a 1e                	mov    (%esi),%bl
 3f2:	84 db                	test   %bl,%bl
 3f4:	0f 84 a3 00 00 00    	je     49d <printf+0xb9>
 3fa:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3fb:	8d 45 10             	lea    0x10(%ebp),%eax
 3fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 401:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 403:	8d 7d e7             	lea    -0x19(%ebp),%edi
 406:	eb 29                	jmp    431 <printf+0x4d>
 408:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 40b:	83 f8 25             	cmp    $0x25,%eax
 40e:	0f 84 94 00 00 00    	je     4a8 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 414:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 417:	50                   	push   %eax
 418:	6a 01                	push   $0x1
 41a:	57                   	push   %edi
 41b:	ff 75 08             	pushl  0x8(%ebp)
 41e:	e8 af fe ff ff       	call   2d2 <write>
        putc(fd, c);
 423:	83 c4 10             	add    $0x10,%esp
 426:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 429:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 42a:	8a 5e ff             	mov    -0x1(%esi),%bl
 42d:	84 db                	test   %bl,%bl
 42f:	74 6c                	je     49d <printf+0xb9>
    c = fmt[i] & 0xff;
 431:	0f be cb             	movsbl %bl,%ecx
 434:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 437:	85 d2                	test   %edx,%edx
 439:	74 cd                	je     408 <printf+0x24>
      }
    } else if(state == '%'){
 43b:	83 fa 25             	cmp    $0x25,%edx
 43e:	75 e9                	jne    429 <printf+0x45>
      if(c == 'd'){
 440:	83 f8 64             	cmp    $0x64,%eax
 443:	0f 84 97 00 00 00    	je     4e0 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 449:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 44f:	83 f9 70             	cmp    $0x70,%ecx
 452:	74 60                	je     4b4 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 454:	83 f8 73             	cmp    $0x73,%eax
 457:	0f 84 8f 00 00 00    	je     4ec <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 45d:	83 f8 63             	cmp    $0x63,%eax
 460:	0f 84 d6 00 00 00    	je     53c <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 466:	83 f8 25             	cmp    $0x25,%eax
 469:	0f 84 c1 00 00 00    	je     530 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 46f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 473:	50                   	push   %eax
 474:	6a 01                	push   $0x1
 476:	57                   	push   %edi
 477:	ff 75 08             	pushl  0x8(%ebp)
 47a:	e8 53 fe ff ff       	call   2d2 <write>
        putc(fd, c);
 47f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 482:	83 c4 0c             	add    $0xc,%esp
 485:	6a 01                	push   $0x1
 487:	57                   	push   %edi
 488:	ff 75 08             	pushl  0x8(%ebp)
 48b:	e8 42 fe ff ff       	call   2d2 <write>
        putc(fd, c);
 490:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 493:	31 d2                	xor    %edx,%edx
 495:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 496:	8a 5e ff             	mov    -0x1(%esi),%bl
 499:	84 db                	test   %bl,%bl
 49b:	75 94                	jne    431 <printf+0x4d>
    }
  }
}
 49d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 4a8:	ba 25 00 00 00       	mov    $0x25,%edx
 4ad:	e9 77 ff ff ff       	jmp    429 <printf+0x45>
 4b2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4b4:	83 ec 0c             	sub    $0xc,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4be:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4c1:	8b 13                	mov    (%ebx),%edx
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	e8 91 fe ff ff       	call   35c <printint>
        ap++;
 4cb:	89 d8                	mov    %ebx,%eax
 4cd:	83 c0 04             	add    $0x4,%eax
 4d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d6:	31 d2                	xor    %edx,%edx
        ap++;
 4d8:	e9 4c ff ff ff       	jmp    429 <printf+0x45>
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	6a 01                	push   $0x1
 4e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4ea:	eb d2                	jmp    4be <printf+0xda>
        s = (char*)*ap;
 4ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4ef:	8b 18                	mov    (%eax),%ebx
        ap++;
 4f1:	83 c0 04             	add    $0x4,%eax
 4f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4f7:	85 db                	test   %ebx,%ebx
 4f9:	74 65                	je     560 <printf+0x17c>
        while(*s != 0){
 4fb:	8a 03                	mov    (%ebx),%al
 4fd:	84 c0                	test   %al,%al
 4ff:	74 70                	je     571 <printf+0x18d>
 501:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 504:	89 de                	mov    %ebx,%esi
 506:	8b 5d 08             	mov    0x8(%ebp),%ebx
 509:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 50c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 50f:	50                   	push   %eax
 510:	6a 01                	push   $0x1
 512:	57                   	push   %edi
 513:	53                   	push   %ebx
 514:	e8 b9 fd ff ff       	call   2d2 <write>
          s++;
 519:	46                   	inc    %esi
        while(*s != 0){
 51a:	8a 06                	mov    (%esi),%al
 51c:	83 c4 10             	add    $0x10,%esp
 51f:	84 c0                	test   %al,%al
 521:	75 e9                	jne    50c <printf+0x128>
 523:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 526:	31 d2                	xor    %edx,%edx
 528:	e9 fc fe ff ff       	jmp    429 <printf+0x45>
 52d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 530:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 533:	52                   	push   %edx
 534:	e9 4c ff ff ff       	jmp    485 <printf+0xa1>
 539:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 53c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53f:	8b 03                	mov    (%ebx),%eax
 541:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 544:	51                   	push   %ecx
 545:	6a 01                	push   $0x1
 547:	57                   	push   %edi
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 82 fd ff ff       	call   2d2 <write>
        ap++;
 550:	83 c3 04             	add    $0x4,%ebx
 553:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 556:	83 c4 10             	add    $0x10,%esp
      state = 0;
 559:	31 d2                	xor    %edx,%edx
 55b:	e9 c9 fe ff ff       	jmp    429 <printf+0x45>
          s = "(null)";
 560:	bb 2d 07 00 00       	mov    $0x72d,%ebx
        while(*s != 0){
 565:	b0 28                	mov    $0x28,%al
 567:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 56a:	89 de                	mov    %ebx,%esi
 56c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56f:	eb 9b                	jmp    50c <printf+0x128>
      state = 0;
 571:	31 d2                	xor    %edx,%edx
 573:	e9 b1 fe ff ff       	jmp    429 <printf+0x45>

00000578 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	57                   	push   %edi
 57c:	56                   	push   %esi
 57d:	53                   	push   %ebx
 57e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 581:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 584:	a1 60 0a 00 00       	mov    0xa60,%eax
 589:	8b 10                	mov    (%eax),%edx
 58b:	39 c8                	cmp    %ecx,%eax
 58d:	73 11                	jae    5a0 <free+0x28>
 58f:	90                   	nop
 590:	39 d1                	cmp    %edx,%ecx
 592:	72 14                	jb     5a8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	39 d0                	cmp    %edx,%eax
 596:	73 10                	jae    5a8 <free+0x30>
{
 598:	89 d0                	mov    %edx,%eax
 59a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59c:	39 c8                	cmp    %ecx,%eax
 59e:	72 f0                	jb     590 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a0:	39 d0                	cmp    %edx,%eax
 5a2:	72 f4                	jb     598 <free+0x20>
 5a4:	39 d1                	cmp    %edx,%ecx
 5a6:	73 f0                	jae    598 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ae:	39 fa                	cmp    %edi,%edx
 5b0:	74 1a                	je     5cc <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b5:	8b 50 04             	mov    0x4(%eax),%edx
 5b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5bb:	39 f1                	cmp    %esi,%ecx
 5bd:	74 24                	je     5e3 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5c1:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 5c6:	5b                   	pop    %ebx
 5c7:	5e                   	pop    %esi
 5c8:	5f                   	pop    %edi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret    
 5cb:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5cc:	03 72 04             	add    0x4(%edx),%esi
 5cf:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d2:	8b 10                	mov    (%eax),%edx
 5d4:	8b 12                	mov    (%edx),%edx
 5d6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d9:	8b 50 04             	mov    0x4(%eax),%edx
 5dc:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5df:	39 f1                	cmp    %esi,%ecx
 5e1:	75 dc                	jne    5bf <free+0x47>
    p->s.size += bp->s.size;
 5e3:	03 53 fc             	add    -0x4(%ebx),%edx
 5e6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5e9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ec:	89 10                	mov    %edx,(%eax)
  freep = p;
 5ee:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret    

000005f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	57                   	push   %edi
 5fc:	56                   	push   %esi
 5fd:	53                   	push   %ebx
 5fe:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	8d 70 07             	lea    0x7(%eax),%esi
 607:	c1 ee 03             	shr    $0x3,%esi
 60a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 60b:	8b 3d 60 0a 00 00    	mov    0xa60,%edi
 611:	85 ff                	test   %edi,%edi
 613:	0f 84 a3 00 00 00    	je     6bc <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 619:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 61b:	8b 48 04             	mov    0x4(%eax),%ecx
 61e:	39 f1                	cmp    %esi,%ecx
 620:	73 67                	jae    689 <malloc+0x91>
 622:	89 f3                	mov    %esi,%ebx
 624:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 62a:	0f 82 80 00 00 00    	jb     6b0 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 630:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 637:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 63a:	eb 11                	jmp    64d <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63c:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 63e:	8b 4a 04             	mov    0x4(%edx),%ecx
 641:	39 f1                	cmp    %esi,%ecx
 643:	73 4b                	jae    690 <malloc+0x98>
 645:	8b 3d 60 0a 00 00    	mov    0xa60,%edi
 64b:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 64d:	39 c7                	cmp    %eax,%edi
 64f:	75 eb                	jne    63c <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 651:	83 ec 0c             	sub    $0xc,%esp
 654:	ff 75 e4             	pushl  -0x1c(%ebp)
 657:	e8 de fc ff ff       	call   33a <sbrk>
  if(p == (char*)-1)
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	83 f8 ff             	cmp    $0xffffffff,%eax
 662:	74 1b                	je     67f <malloc+0x87>
  hp->s.size = nu;
 664:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 667:	83 ec 0c             	sub    $0xc,%esp
 66a:	83 c0 08             	add    $0x8,%eax
 66d:	50                   	push   %eax
 66e:	e8 05 ff ff ff       	call   578 <free>
  return freep;
 673:	a1 60 0a 00 00       	mov    0xa60,%eax
      if((p = morecore(nunits)) == 0)
 678:	83 c4 10             	add    $0x10,%esp
 67b:	85 c0                	test   %eax,%eax
 67d:	75 bd                	jne    63c <malloc+0x44>
        return 0;
 67f:	31 c0                	xor    %eax,%eax
  }
}
 681:	8d 65 f4             	lea    -0xc(%ebp),%esp
 684:	5b                   	pop    %ebx
 685:	5e                   	pop    %esi
 686:	5f                   	pop    %edi
 687:	5d                   	pop    %ebp
 688:	c3                   	ret    
    if(p->s.size >= nunits){
 689:	89 c2                	mov    %eax,%edx
 68b:	89 f8                	mov    %edi,%eax
 68d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 690:	39 ce                	cmp    %ecx,%esi
 692:	74 54                	je     6e8 <malloc+0xf0>
        p->s.size -= nunits;
 694:	29 f1                	sub    %esi,%ecx
 696:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 699:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 69c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 69f:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 6a4:	8d 42 08             	lea    0x8(%edx),%eax
}
 6a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6aa:	5b                   	pop    %ebx
 6ab:	5e                   	pop    %esi
 6ac:	5f                   	pop    %edi
 6ad:	5d                   	pop    %ebp
 6ae:	c3                   	ret    
 6af:	90                   	nop
 6b0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b5:	e9 76 ff ff ff       	jmp    630 <malloc+0x38>
 6ba:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6bc:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6c3:	0a 00 00 
 6c6:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6cd:	0a 00 00 
    base.s.size = 0;
 6d0:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6d7:	00 00 00 
 6da:	bf 64 0a 00 00       	mov    $0xa64,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6df:	89 f8                	mov    %edi,%eax
 6e1:	e9 3c ff ff ff       	jmp    622 <malloc+0x2a>
 6e6:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6e8:	8b 0a                	mov    (%edx),%ecx
 6ea:	89 08                	mov    %ecx,(%eax)
 6ec:	eb b1                	jmp    69f <malloc+0xa7>

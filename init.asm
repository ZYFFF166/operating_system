
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 64 07 00 00       	push   $0x764
  19:	e8 48 03 00 00       	call   366 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 93 00 00 00    	js     bc <main+0xbc>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 6b 03 00 00       	call   39e <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 5f 03 00 00       	call   39e <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 6c 07 00 00       	push   $0x76c
  4c:	6a 01                	push   $0x1
  4e:	e8 05 04 00 00       	call   458 <printf>
    pid = fork();
  53:	e8 c6 02 00 00       	call   31e <fork>
  58:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	78 24                	js     85 <main+0x85>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  61:	74 35                	je     98 <main+0x98>
  63:	90                   	nop
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  64:	e8 c5 02 00 00       	call   32e <wait>
  69:	85 c0                	test   %eax,%eax
  6b:	78 d7                	js     44 <main+0x44>
  6d:	39 c3                	cmp    %eax,%ebx
  6f:	74 d3                	je     44 <main+0x44>
      printf(1, "zombie!\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 ab 07 00 00       	push   $0x7ab
  79:	6a 01                	push   $0x1
  7b:	e8 d8 03 00 00       	call   458 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb df                	jmp    64 <main+0x64>
      printf(1, "init: fork failed\n");
  85:	53                   	push   %ebx
  86:	53                   	push   %ebx
  87:	68 7f 07 00 00       	push   $0x77f
  8c:	6a 01                	push   $0x1
  8e:	e8 c5 03 00 00       	call   458 <printf>
      exit();
  93:	e8 8e 02 00 00       	call   326 <exit>
      exec("sh", argv);
  98:	50                   	push   %eax
  99:	50                   	push   %eax
  9a:	68 f0 0a 00 00       	push   $0xaf0
  9f:	68 92 07 00 00       	push   $0x792
  a4:	e8 b5 02 00 00       	call   35e <exec>
      printf(1, "init: exec sh failed\n");
  a9:	5a                   	pop    %edx
  aa:	59                   	pop    %ecx
  ab:	68 95 07 00 00       	push   $0x795
  b0:	6a 01                	push   $0x1
  b2:	e8 a1 03 00 00       	call   458 <printf>
      exit();
  b7:	e8 6a 02 00 00       	call   326 <exit>
    mknod("console", 1, 1);
  bc:	50                   	push   %eax
  bd:	6a 01                	push   $0x1
  bf:	6a 01                	push   $0x1
  c1:	68 64 07 00 00       	push   $0x764
  c6:	e8 a3 02 00 00       	call   36e <mknod>
    open("console", O_RDWR);
  cb:	58                   	pop    %eax
  cc:	5a                   	pop    %edx
  cd:	6a 02                	push   $0x2
  cf:	68 64 07 00 00       	push   $0x764
  d4:	e8 8d 02 00 00       	call   366 <open>
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	e9 48 ff ff ff       	jmp    29 <main+0x29>
  e1:	66 90                	xchg   %ax,%ax
  e3:	90                   	nop

000000e4 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	53                   	push   %ebx
  e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	31 c0                	xor    %eax,%eax
  f0:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  f3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f6:	40                   	inc    %eax
  f7:	84 d2                	test   %dl,%dl
  f9:	75 f5                	jne    f0 <strcpy+0xc>
    ;
  return os;
}
  fb:	89 c8                	mov    %ecx,%eax
  fd:	5b                   	pop    %ebx
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 5d 08             	mov    0x8(%ebp),%ebx
 107:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10a:	0f b6 03             	movzbl (%ebx),%eax
 10d:	0f b6 0a             	movzbl (%edx),%ecx
 110:	84 c0                	test   %al,%al
 112:	75 10                	jne    124 <strcmp+0x24>
 114:	eb 1a                	jmp    130 <strcmp+0x30>
 116:	66 90                	xchg   %ax,%ax
    p++, q++;
 118:	43                   	inc    %ebx
 119:	42                   	inc    %edx
  while(*p && *p == *q)
 11a:	0f b6 03             	movzbl (%ebx),%eax
 11d:	0f b6 0a             	movzbl (%edx),%ecx
 120:	84 c0                	test   %al,%al
 122:	74 0c                	je     130 <strcmp+0x30>
 124:	38 c8                	cmp    %cl,%al
 126:	74 f0                	je     118 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 128:	29 c8                	sub    %ecx,%eax
}
 12a:	5b                   	pop    %ebx
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 132:	29 c8                	sub    %ecx,%eax
}
 134:	5b                   	pop    %ebx
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	90                   	nop

00000138 <strlen>:

uint
strlen(const char *s)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 13e:	80 3a 00             	cmpb   $0x0,(%edx)
 141:	74 15                	je     158 <strlen+0x20>
 143:	31 c0                	xor    %eax,%eax
 145:	8d 76 00             	lea    0x0(%esi),%esi
 148:	40                   	inc    %eax
 149:	89 c1                	mov    %eax,%ecx
 14b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 14f:	75 f7                	jne    148 <strlen+0x10>
    ;
  return n;
}
 151:	89 c8                	mov    %ecx,%eax
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    
 155:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 158:	31 c9                	xor    %ecx,%ecx
}
 15a:	89 c8                	mov    %ecx,%eax
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    
 15e:	66 90                	xchg   %ax,%ax

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 164:	8b 7d 08             	mov    0x8(%ebp),%edi
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	fc                   	cld    
 16e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    
 176:	66 90                	xchg   %ax,%ax

00000178 <strchr>:

char*
strchr(const char *s, char c)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 181:	8a 10                	mov    (%eax),%dl
 183:	84 d2                	test   %dl,%dl
 185:	75 0c                	jne    193 <strchr+0x1b>
 187:	eb 13                	jmp    19c <strchr+0x24>
 189:	8d 76 00             	lea    0x0(%esi),%esi
 18c:	40                   	inc    %eax
 18d:	8a 10                	mov    (%eax),%dl
 18f:	84 d2                	test   %dl,%dl
 191:	74 09                	je     19c <strchr+0x24>
    if(*s == c)
 193:	38 d1                	cmp    %dl,%cl
 195:	75 f5                	jne    18c <strchr+0x14>
      return (char*)s;
  return 0;
}
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 19c:	31 c0                	xor    %eax,%eax
}
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret    

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
 1a6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a9:	8b 75 08             	mov    0x8(%ebp),%esi
 1ac:	bb 01 00 00 00       	mov    $0x1,%ebx
 1b1:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 1b3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1b6:	eb 20                	jmp    1d8 <gets+0x38>
    cc = read(0, &c, 1);
 1b8:	50                   	push   %eax
 1b9:	6a 01                	push   $0x1
 1bb:	57                   	push   %edi
 1bc:	6a 00                	push   $0x0
 1be:	e8 7b 01 00 00       	call   33e <read>
    if(cc < 1)
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
 1c8:	7e 16                	jle    1e0 <gets+0x40>
      break;
    buf[i++] = c;
 1ca:	8a 45 e7             	mov    -0x19(%ebp),%al
 1cd:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 1cf:	46                   	inc    %esi
 1d0:	3c 0a                	cmp    $0xa,%al
 1d2:	74 0c                	je     1e0 <gets+0x40>
 1d4:	3c 0d                	cmp    $0xd,%al
 1d6:	74 08                	je     1e0 <gets+0x40>
  for(i=0; i+1 < max; ){
 1d8:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 1db:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1de:	7f d8                	jg     1b8 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 1e0:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5f                   	pop    %edi
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 64 01 00 00       	call   366 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
 209:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20b:	83 ec 08             	sub    $0x8,%esp
 20e:	ff 75 0c             	pushl  0xc(%ebp)
 211:	50                   	push   %eax
 212:	e8 67 01 00 00       	call   37e <fstat>
 217:	89 c6                	mov    %eax,%esi
  close(fd);
 219:	89 1c 24             	mov    %ebx,(%esp)
 21c:	e8 2d 01 00 00       	call   34e <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	89 f0                	mov    %esi,%eax
 226:	8d 65 f8             	lea    -0x8(%ebp),%esp
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	90                   	nop

00000238 <atoi>:

int
atoi(const char *s)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	53                   	push   %ebx
 23c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23f:	0f be 01             	movsbl (%ecx),%eax
 242:	8d 50 d0             	lea    -0x30(%eax),%edx
 245:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 248:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 24d:	77 16                	ja     265 <atoi+0x2d>
 24f:	90                   	nop
    n = n*10 + *s++ - '0';
 250:	41                   	inc    %ecx
 251:	8d 14 92             	lea    (%edx,%edx,4),%edx
 254:	01 d2                	add    %edx,%edx
 256:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 25a:	0f be 01             	movsbl (%ecx),%eax
 25d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 260:	80 fb 09             	cmp    $0x9,%bl
 263:	76 eb                	jbe    250 <atoi+0x18>
  return n;
}
 265:	89 d0                	mov    %edx,%eax
 267:	5b                   	pop    %ebx
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    
 26a:	66 90                	xchg   %ax,%ax

0000026c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	57                   	push   %edi
 270:	56                   	push   %esi
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	8b 75 0c             	mov    0xc(%ebp),%esi
 277:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27a:	85 d2                	test   %edx,%edx
 27c:	7e 0b                	jle    289 <memmove+0x1d>
 27e:	01 c2                	add    %eax,%edx
  dst = vdst;
 280:	89 c7                	mov    %eax,%edi
 282:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 284:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 285:	39 fa                	cmp    %edi,%edx
 287:	75 fb                	jne    284 <memmove+0x18>
  return vdst;
}
 289:	5e                   	pop    %esi
 28a:	5f                   	pop    %edi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 29c:	5d                   	pop    %ebp
 29d:	c3                   	ret    
 29e:	66 90                	xchg   %ax,%ax

000002a0 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 2a6:	b9 01 00 00 00       	mov    $0x1,%ecx
 2ab:	90                   	nop
 2ac:	89 c8                	mov    %ecx,%eax
 2ae:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 2b1:	85 c0                	test   %eax,%eax
 2b3:	75 f7                	jne    2ac <lock_acquire+0xc>
}
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	90                   	nop

000002b8 <lock_release>:

void lock_release(lock_t *lock) {
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	8b 55 08             	mov    0x8(%ebp),%edx
 2be:	31 c0                	xor    %eax,%eax
 2c0:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 2c3:	5d                   	pop    %ebp
 2c4:	c3                   	ret    
 2c5:	8d 76 00             	lea    0x0(%esi),%esi

000002c8 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 2ce:	68 00 20 00 00       	push   $0x2000
 2d3:	e8 94 03 00 00       	call   66c <malloc>

  if((uint)stack % PGSIZE)
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	89 c2                	mov    %eax,%edx
 2dd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 2e3:	74 07                	je     2ec <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 2e5:	29 d0                	sub    %edx,%eax
 2e7:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 2ec:	ff 75 0c             	pushl  0xc(%ebp)
 2ef:	6a 08                	push   $0x8
 2f1:	50                   	push   %eax
 2f2:	ff 75 08             	pushl  0x8(%ebp)
 2f5:	e8 cc 00 00 00       	call   3c6 <clone>

  if (tid < 0) {
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	85 c0                	test   %eax,%eax
 2ff:	78 07                	js     308 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 301:	31 c0                	xor    %eax,%eax
 303:	c9                   	leave  
 304:	c3                   	ret    
 305:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 308:	83 ec 08             	sub    $0x8,%esp
 30b:	68 b4 07 00 00       	push   $0x7b4
 310:	6a 01                	push   $0x1
 312:	e8 41 01 00 00       	call   458 <printf>
      return 0;
 317:	83 c4 10             	add    $0x10,%esp
}
 31a:	31 c0                	xor    %eax,%eax
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31e:	b8 01 00 00 00       	mov    $0x1,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <exit>:
SYSCALL(exit)
 326:	b8 02 00 00 00       	mov    $0x2,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <wait>:
SYSCALL(wait)
 32e:	b8 03 00 00 00       	mov    $0x3,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <pipe>:
SYSCALL(pipe)
 336:	b8 04 00 00 00       	mov    $0x4,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <read>:
SYSCALL(read)
 33e:	b8 05 00 00 00       	mov    $0x5,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <write>:
SYSCALL(write)
 346:	b8 10 00 00 00       	mov    $0x10,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <close>:
SYSCALL(close)
 34e:	b8 15 00 00 00       	mov    $0x15,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <kill>:
SYSCALL(kill)
 356:	b8 06 00 00 00       	mov    $0x6,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <exec>:
SYSCALL(exec)
 35e:	b8 07 00 00 00       	mov    $0x7,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <open>:
SYSCALL(open)
 366:	b8 0f 00 00 00       	mov    $0xf,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <mknod>:
SYSCALL(mknod)
 36e:	b8 11 00 00 00       	mov    $0x11,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <unlink>:
SYSCALL(unlink)
 376:	b8 12 00 00 00       	mov    $0x12,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <fstat>:
SYSCALL(fstat)
 37e:	b8 08 00 00 00       	mov    $0x8,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <link>:
SYSCALL(link)
 386:	b8 13 00 00 00       	mov    $0x13,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <mkdir>:
SYSCALL(mkdir)
 38e:	b8 14 00 00 00       	mov    $0x14,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <chdir>:
SYSCALL(chdir)
 396:	b8 09 00 00 00       	mov    $0x9,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <dup>:
SYSCALL(dup)
 39e:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <getpid>:
SYSCALL(getpid)
 3a6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <sbrk>:
SYSCALL(sbrk)
 3ae:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <sleep>:
SYSCALL(sleep)
 3b6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <uptime>:
SYSCALL(uptime)
 3be:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <clone>:
 3c6:	b8 16 00 00 00       	mov    $0x16,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 3c             	sub    $0x3c,%esp
 3d9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 3dc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3df:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 3e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3e4:	85 db                	test   %ebx,%ebx
 3e6:	74 04                	je     3ec <printint+0x1c>
 3e8:	85 d2                	test   %edx,%edx
 3ea:	78 68                	js     454 <printint+0x84>
  neg = 0;
 3ec:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f3:	31 ff                	xor    %edi,%edi
 3f5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3f8:	89 c8                	mov    %ecx,%eax
 3fa:	31 d2                	xor    %edx,%edx
 3fc:	f7 75 c4             	divl   -0x3c(%ebp)
 3ff:	89 fb                	mov    %edi,%ebx
 401:	8d 7f 01             	lea    0x1(%edi),%edi
 404:	8a 92 cc 07 00 00    	mov    0x7cc(%edx),%dl
 40a:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 40e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 411:	89 c1                	mov    %eax,%ecx
 413:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 416:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 419:	76 dd                	jbe    3f8 <printint+0x28>
  if(neg)
 41b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 41e:	85 c9                	test   %ecx,%ecx
 420:	74 09                	je     42b <printint+0x5b>
    buf[i++] = '-';
 422:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 427:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 429:	b2 2d                	mov    $0x2d,%dl
 42b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 42f:	8b 7d bc             	mov    -0x44(%ebp),%edi
 432:	eb 03                	jmp    437 <printint+0x67>
 434:	8a 13                	mov    (%ebx),%dl
 436:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 437:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 43a:	50                   	push   %eax
 43b:	6a 01                	push   $0x1
 43d:	56                   	push   %esi
 43e:	57                   	push   %edi
 43f:	e8 02 ff ff ff       	call   346 <write>
  while(--i >= 0)
 444:	83 c4 10             	add    $0x10,%esp
 447:	39 de                	cmp    %ebx,%esi
 449:	75 e9                	jne    434 <printint+0x64>
}
 44b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44e:	5b                   	pop    %ebx
 44f:	5e                   	pop    %esi
 450:	5f                   	pop    %edi
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	90                   	nop
    x = -xx;
 454:	f7 d9                	neg    %ecx
 456:	eb 9b                	jmp    3f3 <printint+0x23>

00000458 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	57                   	push   %edi
 45c:	56                   	push   %esi
 45d:	53                   	push   %ebx
 45e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 461:	8b 75 0c             	mov    0xc(%ebp),%esi
 464:	8a 1e                	mov    (%esi),%bl
 466:	84 db                	test   %bl,%bl
 468:	0f 84 a3 00 00 00    	je     511 <printf+0xb9>
 46e:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 46f:	8d 45 10             	lea    0x10(%ebp),%eax
 472:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 475:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 477:	8d 7d e7             	lea    -0x19(%ebp),%edi
 47a:	eb 29                	jmp    4a5 <printf+0x4d>
 47c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 47f:	83 f8 25             	cmp    $0x25,%eax
 482:	0f 84 94 00 00 00    	je     51c <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 488:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 48b:	50                   	push   %eax
 48c:	6a 01                	push   $0x1
 48e:	57                   	push   %edi
 48f:	ff 75 08             	pushl  0x8(%ebp)
 492:	e8 af fe ff ff       	call   346 <write>
        putc(fd, c);
 497:	83 c4 10             	add    $0x10,%esp
 49a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 49d:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 49e:	8a 5e ff             	mov    -0x1(%esi),%bl
 4a1:	84 db                	test   %bl,%bl
 4a3:	74 6c                	je     511 <printf+0xb9>
    c = fmt[i] & 0xff;
 4a5:	0f be cb             	movsbl %bl,%ecx
 4a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4ab:	85 d2                	test   %edx,%edx
 4ad:	74 cd                	je     47c <printf+0x24>
      }
    } else if(state == '%'){
 4af:	83 fa 25             	cmp    $0x25,%edx
 4b2:	75 e9                	jne    49d <printf+0x45>
      if(c == 'd'){
 4b4:	83 f8 64             	cmp    $0x64,%eax
 4b7:	0f 84 97 00 00 00    	je     554 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4bd:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4c3:	83 f9 70             	cmp    $0x70,%ecx
 4c6:	74 60                	je     528 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c8:	83 f8 73             	cmp    $0x73,%eax
 4cb:	0f 84 8f 00 00 00    	je     560 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d1:	83 f8 63             	cmp    $0x63,%eax
 4d4:	0f 84 d6 00 00 00    	je     5b0 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4da:	83 f8 25             	cmp    $0x25,%eax
 4dd:	0f 84 c1 00 00 00    	je     5a4 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4e3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4e7:	50                   	push   %eax
 4e8:	6a 01                	push   $0x1
 4ea:	57                   	push   %edi
 4eb:	ff 75 08             	pushl  0x8(%ebp)
 4ee:	e8 53 fe ff ff       	call   346 <write>
        putc(fd, c);
 4f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4f6:	83 c4 0c             	add    $0xc,%esp
 4f9:	6a 01                	push   $0x1
 4fb:	57                   	push   %edi
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 42 fe ff ff       	call   346 <write>
        putc(fd, c);
 504:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 507:	31 d2                	xor    %edx,%edx
 509:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 50a:	8a 5e ff             	mov    -0x1(%esi),%bl
 50d:	84 db                	test   %bl,%bl
 50f:	75 94                	jne    4a5 <printf+0x4d>
    }
  }
}
 511:	8d 65 f4             	lea    -0xc(%ebp),%esp
 514:	5b                   	pop    %ebx
 515:	5e                   	pop    %esi
 516:	5f                   	pop    %edi
 517:	5d                   	pop    %ebp
 518:	c3                   	ret    
 519:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 51c:	ba 25 00 00 00       	mov    $0x25,%edx
 521:	e9 77 ff ff ff       	jmp    49d <printf+0x45>
 526:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	6a 00                	push   $0x0
 52d:	b9 10 00 00 00       	mov    $0x10,%ecx
 532:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 535:	8b 13                	mov    (%ebx),%edx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	e8 91 fe ff ff       	call   3d0 <printint>
        ap++;
 53f:	89 d8                	mov    %ebx,%eax
 541:	83 c0 04             	add    $0x4,%eax
 544:	89 45 d0             	mov    %eax,-0x30(%ebp)
 547:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54a:	31 d2                	xor    %edx,%edx
        ap++;
 54c:	e9 4c ff ff ff       	jmp    49d <printf+0x45>
 551:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 554:	83 ec 0c             	sub    $0xc,%esp
 557:	6a 01                	push   $0x1
 559:	b9 0a 00 00 00       	mov    $0xa,%ecx
 55e:	eb d2                	jmp    532 <printf+0xda>
        s = (char*)*ap;
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	8b 18                	mov    (%eax),%ebx
        ap++;
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 56b:	85 db                	test   %ebx,%ebx
 56d:	74 65                	je     5d4 <printf+0x17c>
        while(*s != 0){
 56f:	8a 03                	mov    (%ebx),%al
 571:	84 c0                	test   %al,%al
 573:	74 70                	je     5e5 <printf+0x18d>
 575:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 578:	89 de                	mov    %ebx,%esi
 57a:	8b 5d 08             	mov    0x8(%ebp),%ebx
 57d:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 580:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 583:	50                   	push   %eax
 584:	6a 01                	push   $0x1
 586:	57                   	push   %edi
 587:	53                   	push   %ebx
 588:	e8 b9 fd ff ff       	call   346 <write>
          s++;
 58d:	46                   	inc    %esi
        while(*s != 0){
 58e:	8a 06                	mov    (%esi),%al
 590:	83 c4 10             	add    $0x10,%esp
 593:	84 c0                	test   %al,%al
 595:	75 e9                	jne    580 <printf+0x128>
 597:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 59a:	31 d2                	xor    %edx,%edx
 59c:	e9 fc fe ff ff       	jmp    49d <printf+0x45>
 5a1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5a4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5a7:	52                   	push   %edx
 5a8:	e9 4c ff ff ff       	jmp    4f9 <printf+0xa1>
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5b3:	8b 03                	mov    (%ebx),%eax
 5b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b8:	51                   	push   %ecx
 5b9:	6a 01                	push   $0x1
 5bb:	57                   	push   %edi
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 82 fd ff ff       	call   346 <write>
        ap++;
 5c4:	83 c3 04             	add    $0x4,%ebx
 5c7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cd:	31 d2                	xor    %edx,%edx
 5cf:	e9 c9 fe ff ff       	jmp    49d <printf+0x45>
          s = "(null)";
 5d4:	bb c4 07 00 00       	mov    $0x7c4,%ebx
        while(*s != 0){
 5d9:	b0 28                	mov    $0x28,%al
 5db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5de:	89 de                	mov    %ebx,%esi
 5e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e3:	eb 9b                	jmp    580 <printf+0x128>
      state = 0;
 5e5:	31 d2                	xor    %edx,%edx
 5e7:	e9 b1 fe ff ff       	jmp    49d <printf+0x45>

000005ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	57                   	push   %edi
 5f0:	56                   	push   %esi
 5f1:	53                   	push   %ebx
 5f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	a1 f8 0a 00 00       	mov    0xaf8,%eax
 5fd:	8b 10                	mov    (%eax),%edx
 5ff:	39 c8                	cmp    %ecx,%eax
 601:	73 11                	jae    614 <free+0x28>
 603:	90                   	nop
 604:	39 d1                	cmp    %edx,%ecx
 606:	72 14                	jb     61c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	39 d0                	cmp    %edx,%eax
 60a:	73 10                	jae    61c <free+0x30>
{
 60c:	89 d0                	mov    %edx,%eax
 60e:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 610:	39 c8                	cmp    %ecx,%eax
 612:	72 f0                	jb     604 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	39 d0                	cmp    %edx,%eax
 616:	72 f4                	jb     60c <free+0x20>
 618:	39 d1                	cmp    %edx,%ecx
 61a:	73 f0                	jae    60c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 61f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 622:	39 fa                	cmp    %edi,%edx
 624:	74 1a                	je     640 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 626:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 629:	8b 50 04             	mov    0x4(%eax),%edx
 62c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62f:	39 f1                	cmp    %esi,%ecx
 631:	74 24                	je     657 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 633:	89 08                	mov    %ecx,(%eax)
  freep = p;
 635:	a3 f8 0a 00 00       	mov    %eax,0xaf8
}
 63a:	5b                   	pop    %ebx
 63b:	5e                   	pop    %esi
 63c:	5f                   	pop    %edi
 63d:	5d                   	pop    %ebp
 63e:	c3                   	ret    
 63f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 dc                	jne    633 <free+0x47>
    p->s.size += bp->s.size;
 657:	03 53 fc             	add    -0x4(%ebx),%edx
 65a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 660:	89 10                	mov    %edx,(%eax)
  freep = p;
 662:	a3 f8 0a 00 00       	mov    %eax,0xaf8
}
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    

0000066c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	57                   	push   %edi
 670:	56                   	push   %esi
 671:	53                   	push   %ebx
 672:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	8d 70 07             	lea    0x7(%eax),%esi
 67b:	c1 ee 03             	shr    $0x3,%esi
 67e:	46                   	inc    %esi
  if((prevp = freep) == 0){
 67f:	8b 3d f8 0a 00 00    	mov    0xaf8,%edi
 685:	85 ff                	test   %edi,%edi
 687:	0f 84 a3 00 00 00    	je     730 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68d:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 68f:	8b 48 04             	mov    0x4(%eax),%ecx
 692:	39 f1                	cmp    %esi,%ecx
 694:	73 67                	jae    6fd <malloc+0x91>
 696:	89 f3                	mov    %esi,%ebx
 698:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 69e:	0f 82 80 00 00 00    	jb     724 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 6a4:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6ae:	eb 11                	jmp    6c1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6b5:	39 f1                	cmp    %esi,%ecx
 6b7:	73 4b                	jae    704 <malloc+0x98>
 6b9:	8b 3d f8 0a 00 00    	mov    0xaf8,%edi
 6bf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c1:	39 c7                	cmp    %eax,%edi
 6c3:	75 eb                	jne    6b0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 6c5:	83 ec 0c             	sub    $0xc,%esp
 6c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6cb:	e8 de fc ff ff       	call   3ae <sbrk>
  if(p == (char*)-1)
 6d0:	83 c4 10             	add    $0x10,%esp
 6d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d6:	74 1b                	je     6f3 <malloc+0x87>
  hp->s.size = nu;
 6d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	83 c0 08             	add    $0x8,%eax
 6e1:	50                   	push   %eax
 6e2:	e8 05 ff ff ff       	call   5ec <free>
  return freep;
 6e7:	a1 f8 0a 00 00       	mov    0xaf8,%eax
      if((p = morecore(nunits)) == 0)
 6ec:	83 c4 10             	add    $0x10,%esp
 6ef:	85 c0                	test   %eax,%eax
 6f1:	75 bd                	jne    6b0 <malloc+0x44>
        return 0;
 6f3:	31 c0                	xor    %eax,%eax
  }
}
 6f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f8:	5b                   	pop    %ebx
 6f9:	5e                   	pop    %esi
 6fa:	5f                   	pop    %edi
 6fb:	5d                   	pop    %ebp
 6fc:	c3                   	ret    
    if(p->s.size >= nunits){
 6fd:	89 c2                	mov    %eax,%edx
 6ff:	89 f8                	mov    %edi,%eax
 701:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 704:	39 ce                	cmp    %ecx,%esi
 706:	74 54                	je     75c <malloc+0xf0>
        p->s.size -= nunits;
 708:	29 f1                	sub    %esi,%ecx
 70a:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 70d:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 710:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 713:	a3 f8 0a 00 00       	mov    %eax,0xaf8
      return (void*)(p + 1);
 718:	8d 42 08             	lea    0x8(%edx),%eax
}
 71b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71e:	5b                   	pop    %ebx
 71f:	5e                   	pop    %esi
 720:	5f                   	pop    %edi
 721:	5d                   	pop    %ebp
 722:	c3                   	ret    
 723:	90                   	nop
 724:	bb 00 10 00 00       	mov    $0x1000,%ebx
 729:	e9 76 ff ff ff       	jmp    6a4 <malloc+0x38>
 72e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 730:	c7 05 f8 0a 00 00 fc 	movl   $0xafc,0xaf8
 737:	0a 00 00 
 73a:	c7 05 fc 0a 00 00 fc 	movl   $0xafc,0xafc
 741:	0a 00 00 
    base.s.size = 0;
 744:	c7 05 00 0b 00 00 00 	movl   $0x0,0xb00
 74b:	00 00 00 
 74e:	bf fc 0a 00 00       	mov    $0xafc,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 753:	89 f8                	mov    %edi,%eax
 755:	e9 3c ff ff ff       	jmp    696 <malloc+0x2a>
 75a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 75c:	8b 0a                	mov    (%edx),%ecx
 75e:	89 08                	mov    %ecx,(%eax)
 760:	eb b1                	jmp    713 <malloc+0xa7>

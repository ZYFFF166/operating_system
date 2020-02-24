
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 2d 00 00 00       	call   38 <forktest>
  exit();
   b:	e8 52 03 00 00       	call   362 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 10             	sub    $0x10,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	53                   	push   %ebx
  1b:	e8 54 01 00 00       	call   174 <strlen>
  20:	83 c4 0c             	add    $0xc,%esp
  23:	50                   	push   %eax
  24:	53                   	push   %ebx
  25:	ff 75 08             	pushl  0x8(%ebp)
  28:	e8 55 03 00 00       	call   382 <write>
}
  2d:	83 c4 10             	add    $0x10,%esp
  30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  33:	c9                   	leave  
  34:	c3                   	ret    
  35:	8d 76 00             	lea    0x0(%esi),%esi

00000038 <forktest>:
{
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	53                   	push   %ebx
  3c:	83 ec 10             	sub    $0x10,%esp
  write(fd, s, strlen(s));
  3f:	68 84 05 00 00       	push   $0x584
  44:	e8 2b 01 00 00       	call   174 <strlen>
  49:	83 c4 0c             	add    $0xc,%esp
  4c:	50                   	push   %eax
  4d:	68 84 05 00 00       	push   $0x584
  52:	6a 01                	push   $0x1
  54:	e8 29 03 00 00       	call   382 <write>
  59:	83 c4 10             	add    $0x10,%esp
  for(n=0; n<N; n++){
  5c:	31 db                	xor    %ebx,%ebx
  5e:	eb 0f                	jmp    6f <forktest+0x37>
    if(pid == 0)
  60:	74 50                	je     b2 <forktest+0x7a>
  for(n=0; n<N; n++){
  62:	43                   	inc    %ebx
  63:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  69:	0f 84 8c 00 00 00    	je     fb <forktest+0xc3>
    pid = fork();
  6f:	e8 e6 02 00 00       	call   35a <fork>
    if(pid < 0)
  74:	85 c0                	test   %eax,%eax
  76:	79 e8                	jns    60 <forktest+0x28>
  for(; n > 0; n--){
  78:	85 db                	test   %ebx,%ebx
  7a:	74 0c                	je     88 <forktest+0x50>
    if(wait() < 0){
  7c:	e8 e9 02 00 00       	call   36a <wait>
  81:	85 c0                	test   %eax,%eax
  83:	78 32                	js     b7 <forktest+0x7f>
  for(; n > 0; n--){
  85:	4b                   	dec    %ebx
  86:	75 f4                	jne    7c <forktest+0x44>
  if(wait() != -1){
  88:	e8 dd 02 00 00       	call   36a <wait>
  8d:	40                   	inc    %eax
  8e:	75 49                	jne    d9 <forktest+0xa1>
  write(fd, s, strlen(s));
  90:	83 ec 0c             	sub    $0xc,%esp
  93:	68 b6 05 00 00       	push   $0x5b6
  98:	e8 d7 00 00 00       	call   174 <strlen>
  9d:	83 c4 0c             	add    $0xc,%esp
  a0:	50                   	push   %eax
  a1:	68 b6 05 00 00       	push   $0x5b6
  a6:	6a 01                	push   $0x1
  a8:	e8 d5 02 00 00       	call   382 <write>
}
  ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b0:	c9                   	leave  
  b1:	c3                   	ret    
      exit();
  b2:	e8 ab 02 00 00       	call   362 <exit>
  write(fd, s, strlen(s));
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	68 8f 05 00 00       	push   $0x58f
  bf:	e8 b0 00 00 00       	call   174 <strlen>
  c4:	83 c4 0c             	add    $0xc,%esp
  c7:	50                   	push   %eax
  c8:	68 8f 05 00 00       	push   $0x58f
  cd:	6a 01                	push   $0x1
  cf:	e8 ae 02 00 00       	call   382 <write>
      exit();
  d4:	e8 89 02 00 00       	call   362 <exit>
  write(fd, s, strlen(s));
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	68 a3 05 00 00       	push   $0x5a3
  e1:	e8 8e 00 00 00       	call   174 <strlen>
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	50                   	push   %eax
  ea:	68 a3 05 00 00       	push   $0x5a3
  ef:	6a 01                	push   $0x1
  f1:	e8 8c 02 00 00       	call   382 <write>
    exit();
  f6:	e8 67 02 00 00       	call   362 <exit>
  write(fd, s, strlen(s));
  fb:	83 ec 0c             	sub    $0xc,%esp
  fe:	68 c4 05 00 00       	push   $0x5c4
 103:	e8 6c 00 00 00       	call   174 <strlen>
 108:	83 c4 0c             	add    $0xc,%esp
 10b:	50                   	push   %eax
 10c:	68 c4 05 00 00       	push   $0x5c4
 111:	6a 01                	push   $0x1
 113:	e8 6a 02 00 00       	call   382 <write>
    exit();
 118:	e8 45 02 00 00       	call   362 <exit>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 4d 08             	mov    0x8(%ebp),%ecx
 127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	31 c0                	xor    %eax,%eax
 12c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 12f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 132:	40                   	inc    %eax
 133:	84 d2                	test   %dl,%dl
 135:	75 f5                	jne    12c <strcpy+0xc>
    ;
  return os;
}
 137:	89 c8                	mov    %ecx,%eax
 139:	5b                   	pop    %ebx
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	53                   	push   %ebx
 140:	8b 5d 08             	mov    0x8(%ebp),%ebx
 143:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 146:	0f b6 03             	movzbl (%ebx),%eax
 149:	0f b6 0a             	movzbl (%edx),%ecx
 14c:	84 c0                	test   %al,%al
 14e:	75 10                	jne    160 <strcmp+0x24>
 150:	eb 1a                	jmp    16c <strcmp+0x30>
 152:	66 90                	xchg   %ax,%ax
    p++, q++;
 154:	43                   	inc    %ebx
 155:	42                   	inc    %edx
  while(*p && *p == *q)
 156:	0f b6 03             	movzbl (%ebx),%eax
 159:	0f b6 0a             	movzbl (%edx),%ecx
 15c:	84 c0                	test   %al,%al
 15e:	74 0c                	je     16c <strcmp+0x30>
 160:	38 c8                	cmp    %cl,%al
 162:	74 f0                	je     154 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 164:	29 c8                	sub    %ecx,%eax
}
 166:	5b                   	pop    %ebx
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d 76 00             	lea    0x0(%esi),%esi
 16c:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 16e:	29 c8                	sub    %ecx,%eax
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	90                   	nop

00000174 <strlen>:

uint
strlen(const char *s)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 17a:	80 3a 00             	cmpb   $0x0,(%edx)
 17d:	74 15                	je     194 <strlen+0x20>
 17f:	31 c0                	xor    %eax,%eax
 181:	8d 76 00             	lea    0x0(%esi),%esi
 184:	40                   	inc    %eax
 185:	89 c1                	mov    %eax,%ecx
 187:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 18b:	75 f7                	jne    184 <strlen+0x10>
    ;
  return n;
}
 18d:	89 c8                	mov    %ecx,%eax
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 194:	31 c9                	xor    %ecx,%ecx
}
 196:	89 c8                	mov    %ecx,%eax
 198:	5d                   	pop    %ebp
 199:	c3                   	ret    
 19a:	66 90                	xchg   %ax,%ax

0000019c <memset>:

void*
memset(void *dst, int c, uint n)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a0:	8b 7d 08             	mov    0x8(%ebp),%edi
 1a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	fc                   	cld    
 1aa:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	5f                   	pop    %edi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    
 1b2:	66 90                	xchg   %ax,%ax

000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1bd:	8a 10                	mov    (%eax),%dl
 1bf:	84 d2                	test   %dl,%dl
 1c1:	75 0c                	jne    1cf <strchr+0x1b>
 1c3:	eb 13                	jmp    1d8 <strchr+0x24>
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
 1c8:	40                   	inc    %eax
 1c9:	8a 10                	mov    (%eax),%dl
 1cb:	84 d2                	test   %dl,%dl
 1cd:	74 09                	je     1d8 <strchr+0x24>
    if(*s == c)
 1cf:	38 d1                	cmp    %dl,%cl
 1d1:	75 f5                	jne    1c8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1d8:	31 c0                	xor    %eax,%eax
}
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    

000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	57                   	push   %edi
 1e0:	56                   	push   %esi
 1e1:	53                   	push   %ebx
 1e2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	8b 75 08             	mov    0x8(%ebp),%esi
 1e8:	bb 01 00 00 00       	mov    $0x1,%ebx
 1ed:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 1ef:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1f2:	eb 20                	jmp    214 <gets+0x38>
    cc = read(0, &c, 1);
 1f4:	50                   	push   %eax
 1f5:	6a 01                	push   $0x1
 1f7:	57                   	push   %edi
 1f8:	6a 00                	push   $0x0
 1fa:	e8 7b 01 00 00       	call   37a <read>
    if(cc < 1)
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	85 c0                	test   %eax,%eax
 204:	7e 16                	jle    21c <gets+0x40>
      break;
    buf[i++] = c;
 206:	8a 45 e7             	mov    -0x19(%ebp),%al
 209:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 20b:	46                   	inc    %esi
 20c:	3c 0a                	cmp    $0xa,%al
 20e:	74 0c                	je     21c <gets+0x40>
 210:	3c 0d                	cmp    $0xd,%al
 212:	74 08                	je     21c <gets+0x40>
  for(i=0; i+1 < max; ){
 214:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 217:	39 45 0c             	cmp    %eax,0xc(%ebp)
 21a:	7f d8                	jg     1f4 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 21c:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	8d 65 f4             	lea    -0xc(%ebp),%esp
 225:	5b                   	pop    %ebx
 226:	5e                   	pop    %esi
 227:	5f                   	pop    %edi
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    
 22a:	66 90                	xchg   %ax,%ax

0000022c <stat>:

int
stat(const char *n, struct stat *st)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	56                   	push   %esi
 230:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 231:	83 ec 08             	sub    $0x8,%esp
 234:	6a 00                	push   $0x0
 236:	ff 75 08             	pushl  0x8(%ebp)
 239:	e8 64 01 00 00       	call   3a2 <open>
  if(fd < 0)
 23e:	83 c4 10             	add    $0x10,%esp
 241:	85 c0                	test   %eax,%eax
 243:	78 27                	js     26c <stat+0x40>
 245:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 247:	83 ec 08             	sub    $0x8,%esp
 24a:	ff 75 0c             	pushl  0xc(%ebp)
 24d:	50                   	push   %eax
 24e:	e8 67 01 00 00       	call   3ba <fstat>
 253:	89 c6                	mov    %eax,%esi
  close(fd);
 255:	89 1c 24             	mov    %ebx,(%esp)
 258:	e8 2d 01 00 00       	call   38a <close>
  return r;
 25d:	83 c4 10             	add    $0x10,%esp
}
 260:	89 f0                	mov    %esi,%eax
 262:	8d 65 f8             	lea    -0x8(%ebp),%esp
 265:	5b                   	pop    %ebx
 266:	5e                   	pop    %esi
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 26c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 271:	eb ed                	jmp    260 <stat+0x34>
 273:	90                   	nop

00000274 <atoi>:

int
atoi(const char *s)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	53                   	push   %ebx
 278:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27b:	0f be 01             	movsbl (%ecx),%eax
 27e:	8d 50 d0             	lea    -0x30(%eax),%edx
 281:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 284:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 289:	77 16                	ja     2a1 <atoi+0x2d>
 28b:	90                   	nop
    n = n*10 + *s++ - '0';
 28c:	41                   	inc    %ecx
 28d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 290:	01 d2                	add    %edx,%edx
 292:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 296:	0f be 01             	movsbl (%ecx),%eax
 299:	8d 58 d0             	lea    -0x30(%eax),%ebx
 29c:	80 fb 09             	cmp    $0x9,%bl
 29f:	76 eb                	jbe    28c <atoi+0x18>
  return n;
}
 2a1:	89 d0                	mov    %edx,%eax
 2a3:	5b                   	pop    %ebx
 2a4:	5d                   	pop    %ebp
 2a5:	c3                   	ret    
 2a6:	66 90                	xchg   %ax,%ax

000002a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	57                   	push   %edi
 2ac:	56                   	push   %esi
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	8b 75 0c             	mov    0xc(%ebp),%esi
 2b3:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b6:	85 d2                	test   %edx,%edx
 2b8:	7e 0b                	jle    2c5 <memmove+0x1d>
 2ba:	01 c2                	add    %eax,%edx
  dst = vdst;
 2bc:	89 c7                	mov    %eax,%edi
 2be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2c1:	39 fa                	cmp    %edi,%edx
 2c3:	75 fb                	jne    2c0 <memmove+0x18>
  return vdst;
}
 2c5:	5e                   	pop    %esi
 2c6:	5f                   	pop    %edi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    
 2c9:	8d 76 00             	lea    0x0(%esi),%esi

000002cc <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    
 2da:	66 90                	xchg   %ax,%ax

000002dc <lock_acquire>:

void lock_acquire(lock_t *lock) {
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 2e2:	b9 01 00 00 00       	mov    $0x1,%ecx
 2e7:	90                   	nop
 2e8:	89 c8                	mov    %ecx,%eax
 2ea:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 2ed:	85 c0                	test   %eax,%eax
 2ef:	75 f7                	jne    2e8 <lock_acquire+0xc>
}
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	90                   	nop

000002f4 <lock_release>:

void lock_release(lock_t *lock) {
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	8b 55 08             	mov    0x8(%ebp),%edx
 2fa:	31 c0                	xor    %eax,%eax
 2fc:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d 76 00             	lea    0x0(%esi),%esi

00000304 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 30a:	68 00 20 00 00       	push   $0x2000
 30f:	e8 78 01 00 00       	call   48c <malloc>

  if((uint)stack % PGSIZE)
 314:	83 c4 10             	add    $0x10,%esp
 317:	89 c2                	mov    %eax,%edx
 319:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 31f:	74 07                	je     328 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 321:	29 d0                	sub    %edx,%eax
 323:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 328:	ff 75 0c             	pushl  0xc(%ebp)
 32b:	6a 08                	push   $0x8
 32d:	50                   	push   %eax
 32e:	ff 75 08             	pushl  0x8(%ebp)
 331:	e8 cc 00 00 00       	call   402 <clone>

  if (tid < 0) {
 336:	83 c4 10             	add    $0x10,%esp
 339:	85 c0                	test   %eax,%eax
 33b:	78 07                	js     344 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 33d:	31 c0                	xor    %eax,%eax
 33f:	c9                   	leave  
 340:	c3                   	ret    
 341:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 344:	83 ec 08             	sub    $0x8,%esp
 347:	68 e4 05 00 00       	push   $0x5e4
 34c:	6a 01                	push   $0x1
 34e:	e8 bd fc ff ff       	call   10 <printf>
      return 0;
 353:	83 c4 10             	add    $0x10,%esp
}
 356:	31 c0                	xor    %eax,%eax
 358:	c9                   	leave  
 359:	c3                   	ret    

0000035a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35a:	b8 01 00 00 00       	mov    $0x1,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <exit>:
SYSCALL(exit)
 362:	b8 02 00 00 00       	mov    $0x2,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <wait>:
SYSCALL(wait)
 36a:	b8 03 00 00 00       	mov    $0x3,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <pipe>:
SYSCALL(pipe)
 372:	b8 04 00 00 00       	mov    $0x4,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <read>:
SYSCALL(read)
 37a:	b8 05 00 00 00       	mov    $0x5,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <write>:
SYSCALL(write)
 382:	b8 10 00 00 00       	mov    $0x10,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <close>:
SYSCALL(close)
 38a:	b8 15 00 00 00       	mov    $0x15,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <kill>:
SYSCALL(kill)
 392:	b8 06 00 00 00       	mov    $0x6,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <exec>:
SYSCALL(exec)
 39a:	b8 07 00 00 00       	mov    $0x7,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <open>:
SYSCALL(open)
 3a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mknod>:
SYSCALL(mknod)
 3aa:	b8 11 00 00 00       	mov    $0x11,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <unlink>:
SYSCALL(unlink)
 3b2:	b8 12 00 00 00       	mov    $0x12,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <fstat>:
SYSCALL(fstat)
 3ba:	b8 08 00 00 00       	mov    $0x8,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <link>:
SYSCALL(link)
 3c2:	b8 13 00 00 00       	mov    $0x13,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mkdir>:
SYSCALL(mkdir)
 3ca:	b8 14 00 00 00       	mov    $0x14,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <chdir>:
SYSCALL(chdir)
 3d2:	b8 09 00 00 00       	mov    $0x9,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <dup>:
SYSCALL(dup)
 3da:	b8 0a 00 00 00       	mov    $0xa,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <getpid>:
SYSCALL(getpid)
 3e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <sbrk>:
SYSCALL(sbrk)
 3ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <sleep>:
SYSCALL(sleep)
 3f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <uptime>:
SYSCALL(uptime)
 3fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <clone>:
 402:	b8 16 00 00 00       	mov    $0x16,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    
 40a:	66 90                	xchg   %ax,%ax

0000040c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	57                   	push   %edi
 410:	56                   	push   %esi
 411:	53                   	push   %ebx
 412:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 415:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 418:	a1 e4 08 00 00       	mov    0x8e4,%eax
 41d:	8b 10                	mov    (%eax),%edx
 41f:	39 c8                	cmp    %ecx,%eax
 421:	73 11                	jae    434 <free+0x28>
 423:	90                   	nop
 424:	39 d1                	cmp    %edx,%ecx
 426:	72 14                	jb     43c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 428:	39 d0                	cmp    %edx,%eax
 42a:	73 10                	jae    43c <free+0x30>
{
 42c:	89 d0                	mov    %edx,%eax
 42e:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 430:	39 c8                	cmp    %ecx,%eax
 432:	72 f0                	jb     424 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 434:	39 d0                	cmp    %edx,%eax
 436:	72 f4                	jb     42c <free+0x20>
 438:	39 d1                	cmp    %edx,%ecx
 43a:	73 f0                	jae    42c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 43c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 43f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 442:	39 fa                	cmp    %edi,%edx
 444:	74 1a                	je     460 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 446:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 449:	8b 50 04             	mov    0x4(%eax),%edx
 44c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 44f:	39 f1                	cmp    %esi,%ecx
 451:	74 24                	je     477 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 453:	89 08                	mov    %ecx,(%eax)
  freep = p;
 455:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5f                   	pop    %edi
 45d:	5d                   	pop    %ebp
 45e:	c3                   	ret    
 45f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 460:	03 72 04             	add    0x4(%edx),%esi
 463:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 466:	8b 10                	mov    (%eax),%edx
 468:	8b 12                	mov    (%edx),%edx
 46a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 46d:	8b 50 04             	mov    0x4(%eax),%edx
 470:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 473:	39 f1                	cmp    %esi,%ecx
 475:	75 dc                	jne    453 <free+0x47>
    p->s.size += bp->s.size;
 477:	03 53 fc             	add    -0x4(%ebx),%edx
 47a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 47d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 480:	89 10                	mov    %edx,(%eax)
  freep = p;
 482:	a3 e4 08 00 00       	mov    %eax,0x8e4
}
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    

0000048c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	57                   	push   %edi
 490:	56                   	push   %esi
 491:	53                   	push   %ebx
 492:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	8d 70 07             	lea    0x7(%eax),%esi
 49b:	c1 ee 03             	shr    $0x3,%esi
 49e:	46                   	inc    %esi
  if((prevp = freep) == 0){
 49f:	8b 3d e4 08 00 00    	mov    0x8e4,%edi
 4a5:	85 ff                	test   %edi,%edi
 4a7:	0f 84 a3 00 00 00    	je     550 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 4ad:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 4af:	8b 48 04             	mov    0x4(%eax),%ecx
 4b2:	39 f1                	cmp    %esi,%ecx
 4b4:	73 67                	jae    51d <malloc+0x91>
 4b6:	89 f3                	mov    %esi,%ebx
 4b8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 4be:	0f 82 80 00 00 00    	jb     544 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 4c4:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 4cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 4ce:	eb 11                	jmp    4e1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 4d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 4d2:	8b 4a 04             	mov    0x4(%edx),%ecx
 4d5:	39 f1                	cmp    %esi,%ecx
 4d7:	73 4b                	jae    524 <malloc+0x98>
 4d9:	8b 3d e4 08 00 00    	mov    0x8e4,%edi
 4df:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 4e1:	39 c7                	cmp    %eax,%edi
 4e3:	75 eb                	jne    4d0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 4e5:	83 ec 0c             	sub    $0xc,%esp
 4e8:	ff 75 e4             	pushl  -0x1c(%ebp)
 4eb:	e8 fa fe ff ff       	call   3ea <sbrk>
  if(p == (char*)-1)
 4f0:	83 c4 10             	add    $0x10,%esp
 4f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 4f6:	74 1b                	je     513 <malloc+0x87>
  hp->s.size = nu;
 4f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 4fb:	83 ec 0c             	sub    $0xc,%esp
 4fe:	83 c0 08             	add    $0x8,%eax
 501:	50                   	push   %eax
 502:	e8 05 ff ff ff       	call   40c <free>
  return freep;
 507:	a1 e4 08 00 00       	mov    0x8e4,%eax
      if((p = morecore(nunits)) == 0)
 50c:	83 c4 10             	add    $0x10,%esp
 50f:	85 c0                	test   %eax,%eax
 511:	75 bd                	jne    4d0 <malloc+0x44>
        return 0;
 513:	31 c0                	xor    %eax,%eax
  }
}
 515:	8d 65 f4             	lea    -0xc(%ebp),%esp
 518:	5b                   	pop    %ebx
 519:	5e                   	pop    %esi
 51a:	5f                   	pop    %edi
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    
    if(p->s.size >= nunits){
 51d:	89 c2                	mov    %eax,%edx
 51f:	89 f8                	mov    %edi,%eax
 521:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 524:	39 ce                	cmp    %ecx,%esi
 526:	74 54                	je     57c <malloc+0xf0>
        p->s.size -= nunits;
 528:	29 f1                	sub    %esi,%ecx
 52a:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 52d:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 530:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 533:	a3 e4 08 00 00       	mov    %eax,0x8e4
      return (void*)(p + 1);
 538:	8d 42 08             	lea    0x8(%edx),%eax
}
 53b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53e:	5b                   	pop    %ebx
 53f:	5e                   	pop    %esi
 540:	5f                   	pop    %edi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
 543:	90                   	nop
 544:	bb 00 10 00 00       	mov    $0x1000,%ebx
 549:	e9 76 ff ff ff       	jmp    4c4 <malloc+0x38>
 54e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 550:	c7 05 e4 08 00 00 e8 	movl   $0x8e8,0x8e4
 557:	08 00 00 
 55a:	c7 05 e8 08 00 00 e8 	movl   $0x8e8,0x8e8
 561:	08 00 00 
    base.s.size = 0;
 564:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 56b:	00 00 00 
 56e:	bf e8 08 00 00       	mov    $0x8e8,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 573:	89 f8                	mov    %edi,%eax
 575:	e9 3c ff ff ff       	jmp    4b6 <malloc+0x2a>
 57a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 57c:	8b 0a                	mov    (%edx),%ecx
 57e:	89 08                	mov    %ecx,(%eax)
 580:	eb b1                	jmp    533 <malloc+0xa7>

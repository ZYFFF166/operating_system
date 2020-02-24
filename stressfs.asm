
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	be b3 07 00 00       	mov    $0x7b3,%esi
  1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  21:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  29:	68 90 07 00 00       	push   $0x790
  2e:	6a 01                	push   $0x1
  30:	e8 4f 04 00 00       	call   484 <printf>
  memset(data, 'a', sizeof(data));
  35:	83 c4 0c             	add    $0xc,%esp
  38:	68 00 02 00 00       	push   $0x200
  3d:	6a 61                	push   $0x61
  3f:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  45:	56                   	push   %esi
  46:	e8 41 01 00 00       	call   18c <memset>
  4b:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  4e:	31 db                	xor    %ebx,%ebx
    if(fork() > 0)
  50:	e8 f5 02 00 00       	call   34a <fork>
  55:	85 c0                	test   %eax,%eax
  57:	0f 8f a9 00 00 00    	jg     106 <main+0x106>
  for(i = 0; i < 4; i++)
  5d:	43                   	inc    %ebx
  5e:	83 fb 04             	cmp    $0x4,%ebx
  61:	75 ed                	jne    50 <main+0x50>
  63:	bf 04 00 00 00       	mov    $0x4,%edi
      break;

  printf(1, "write %d\n", i);
  68:	50                   	push   %eax
  69:	53                   	push   %ebx
  6a:	68 a3 07 00 00       	push   $0x7a3
  6f:	6a 01                	push   $0x1
  71:	e8 0e 04 00 00       	call   484 <printf>

  path[8] += i;
  76:	89 f8                	mov    %edi,%eax
  78:	00 85 e6 fd ff ff    	add    %al,-0x21a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7e:	58                   	pop    %eax
  7f:	5a                   	pop    %edx
  80:	68 02 02 00 00       	push   $0x202
  85:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  8b:	50                   	push   %eax
  8c:	e8 01 03 00 00       	call   392 <open>
  91:	89 c7                	mov    %eax,%edi
  93:	83 c4 10             	add    $0x10,%esp
  96:	bb 14 00 00 00       	mov    $0x14,%ebx
  9b:	90                   	nop
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9c:	50                   	push   %eax
  9d:	68 00 02 00 00       	push   $0x200
  a2:	56                   	push   %esi
  a3:	57                   	push   %edi
  a4:	e8 c9 02 00 00       	call   372 <write>
  for(i = 0; i < 20; i++)
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	4b                   	dec    %ebx
  ad:	75 ed                	jne    9c <main+0x9c>
  close(fd);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	57                   	push   %edi
  b3:	e8 c2 02 00 00       	call   37a <close>

  printf(1, "read\n");
  b8:	5a                   	pop    %edx
  b9:	59                   	pop    %ecx
  ba:	68 ad 07 00 00       	push   $0x7ad
  bf:	6a 01                	push   $0x1
  c1:	e8 be 03 00 00       	call   484 <printf>

  fd = open(path, O_RDONLY);
  c6:	5b                   	pop    %ebx
  c7:	5f                   	pop    %edi
  c8:	6a 00                	push   $0x0
  ca:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  d0:	50                   	push   %eax
  d1:	e8 bc 02 00 00       	call   392 <open>
  d6:	89 c7                	mov    %eax,%edi
  d8:	83 c4 10             	add    $0x10,%esp
  db:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e0:	50                   	push   %eax
  e1:	68 00 02 00 00       	push   $0x200
  e6:	56                   	push   %esi
  e7:	57                   	push   %edi
  e8:	e8 7d 02 00 00       	call   36a <read>
  for (i = 0; i < 20; i++)
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	4b                   	dec    %ebx
  f1:	75 ed                	jne    e0 <main+0xe0>
  close(fd);
  f3:	83 ec 0c             	sub    $0xc,%esp
  f6:	57                   	push   %edi
  f7:	e8 7e 02 00 00       	call   37a <close>

  wait();
  fc:	e8 59 02 00 00       	call   35a <wait>

  exit();
 101:	e8 4c 02 00 00       	call   352 <exit>
 106:	89 df                	mov    %ebx,%edi
 108:	e9 5b ff ff ff       	jmp    68 <main+0x68>
 10d:	66 90                	xchg   %ax,%ax
 10f:	90                   	nop

00000110 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	31 c0                	xor    %eax,%eax
 11c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 11f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 122:	40                   	inc    %eax
 123:	84 d2                	test   %dl,%dl
 125:	75 f5                	jne    11c <strcpy+0xc>
    ;
  return os;
}
 127:	89 c8                	mov    %ecx,%eax
 129:	5b                   	pop    %ebx
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	53                   	push   %ebx
 130:	8b 5d 08             	mov    0x8(%ebp),%ebx
 133:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 136:	0f b6 03             	movzbl (%ebx),%eax
 139:	0f b6 0a             	movzbl (%edx),%ecx
 13c:	84 c0                	test   %al,%al
 13e:	75 10                	jne    150 <strcmp+0x24>
 140:	eb 1a                	jmp    15c <strcmp+0x30>
 142:	66 90                	xchg   %ax,%ax
    p++, q++;
 144:	43                   	inc    %ebx
 145:	42                   	inc    %edx
  while(*p && *p == *q)
 146:	0f b6 03             	movzbl (%ebx),%eax
 149:	0f b6 0a             	movzbl (%edx),%ecx
 14c:	84 c0                	test   %al,%al
 14e:	74 0c                	je     15c <strcmp+0x30>
 150:	38 c8                	cmp    %cl,%al
 152:	74 f0                	je     144 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 154:	29 c8                	sub    %ecx,%eax
}
 156:	5b                   	pop    %ebx
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d 76 00             	lea    0x0(%esi),%esi
 15c:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 15e:	29 c8                	sub    %ecx,%eax
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop

00000164 <strlen>:

uint
strlen(const char *s)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 16a:	80 3a 00             	cmpb   $0x0,(%edx)
 16d:	74 15                	je     184 <strlen+0x20>
 16f:	31 c0                	xor    %eax,%eax
 171:	8d 76 00             	lea    0x0(%esi),%esi
 174:	40                   	inc    %eax
 175:	89 c1                	mov    %eax,%ecx
 177:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 17b:	75 f7                	jne    174 <strlen+0x10>
    ;
  return n;
}
 17d:	89 c8                	mov    %ecx,%eax
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 184:	31 c9                	xor    %ecx,%ecx
}
 186:	89 c8                	mov    %ecx,%eax
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    
 18a:	66 90                	xchg   %ax,%ax

0000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 190:	8b 7d 08             	mov    0x8(%ebp),%edi
 193:	8b 4d 10             	mov    0x10(%ebp),%ecx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	fc                   	cld    
 19a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	5f                   	pop    %edi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    
 1a2:	66 90                	xchg   %ax,%ax

000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ad:	8a 10                	mov    (%eax),%dl
 1af:	84 d2                	test   %dl,%dl
 1b1:	75 0c                	jne    1bf <strchr+0x1b>
 1b3:	eb 13                	jmp    1c8 <strchr+0x24>
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
 1b8:	40                   	inc    %eax
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 09                	je     1c8 <strchr+0x24>
    if(*s == c)
 1bf:	38 d1                	cmp    %dl,%cl
 1c1:	75 f5                	jne    1b8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1c8:	31 c0                	xor    %eax,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	8b 75 08             	mov    0x8(%ebp),%esi
 1d8:	bb 01 00 00 00       	mov    $0x1,%ebx
 1dd:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 1df:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e2:	eb 20                	jmp    204 <gets+0x38>
    cc = read(0, &c, 1);
 1e4:	50                   	push   %eax
 1e5:	6a 01                	push   $0x1
 1e7:	57                   	push   %edi
 1e8:	6a 00                	push   $0x0
 1ea:	e8 7b 01 00 00       	call   36a <read>
    if(cc < 1)
 1ef:	83 c4 10             	add    $0x10,%esp
 1f2:	85 c0                	test   %eax,%eax
 1f4:	7e 16                	jle    20c <gets+0x40>
      break;
    buf[i++] = c;
 1f6:	8a 45 e7             	mov    -0x19(%ebp),%al
 1f9:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 1fb:	46                   	inc    %esi
 1fc:	3c 0a                	cmp    $0xa,%al
 1fe:	74 0c                	je     20c <gets+0x40>
 200:	3c 0d                	cmp    $0xd,%al
 202:	74 08                	je     20c <gets+0x40>
  for(i=0; i+1 < max; ){
 204:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 207:	39 45 0c             	cmp    %eax,0xc(%ebp)
 20a:	7f d8                	jg     1e4 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 20c:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	8d 65 f4             	lea    -0xc(%ebp),%esp
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5f                   	pop    %edi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    
 21a:	66 90                	xchg   %ax,%ax

0000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	56                   	push   %esi
 220:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 221:	83 ec 08             	sub    $0x8,%esp
 224:	6a 00                	push   $0x0
 226:	ff 75 08             	pushl  0x8(%ebp)
 229:	e8 64 01 00 00       	call   392 <open>
  if(fd < 0)
 22e:	83 c4 10             	add    $0x10,%esp
 231:	85 c0                	test   %eax,%eax
 233:	78 27                	js     25c <stat+0x40>
 235:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 237:	83 ec 08             	sub    $0x8,%esp
 23a:	ff 75 0c             	pushl  0xc(%ebp)
 23d:	50                   	push   %eax
 23e:	e8 67 01 00 00       	call   3aa <fstat>
 243:	89 c6                	mov    %eax,%esi
  close(fd);
 245:	89 1c 24             	mov    %ebx,(%esp)
 248:	e8 2d 01 00 00       	call   37a <close>
  return r;
 24d:	83 c4 10             	add    $0x10,%esp
}
 250:	89 f0                	mov    %esi,%eax
 252:	8d 65 f8             	lea    -0x8(%ebp),%esp
 255:	5b                   	pop    %ebx
 256:	5e                   	pop    %esi
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    
 259:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 25c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 261:	eb ed                	jmp    250 <stat+0x34>
 263:	90                   	nop

00000264 <atoi>:

int
atoi(const char *s)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	53                   	push   %ebx
 268:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	0f be 01             	movsbl (%ecx),%eax
 26e:	8d 50 d0             	lea    -0x30(%eax),%edx
 271:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 274:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 279:	77 16                	ja     291 <atoi+0x2d>
 27b:	90                   	nop
    n = n*10 + *s++ - '0';
 27c:	41                   	inc    %ecx
 27d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 280:	01 d2                	add    %edx,%edx
 282:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 286:	0f be 01             	movsbl (%ecx),%eax
 289:	8d 58 d0             	lea    -0x30(%eax),%ebx
 28c:	80 fb 09             	cmp    $0x9,%bl
 28f:	76 eb                	jbe    27c <atoi+0x18>
  return n;
}
 291:	89 d0                	mov    %edx,%eax
 293:	5b                   	pop    %ebx
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    
 296:	66 90                	xchg   %ax,%ax

00000298 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	57                   	push   %edi
 29c:	56                   	push   %esi
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	8b 75 0c             	mov    0xc(%ebp),%esi
 2a3:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a6:	85 d2                	test   %edx,%edx
 2a8:	7e 0b                	jle    2b5 <memmove+0x1d>
 2aa:	01 c2                	add    %eax,%edx
  dst = vdst;
 2ac:	89 c7                	mov    %eax,%edi
 2ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 fa                	cmp    %edi,%edx
 2b3:	75 fb                	jne    2b0 <memmove+0x18>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	5f                   	pop    %edi
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    
 2b9:	8d 76 00             	lea    0x0(%esi),%esi

000002bc <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	66 90                	xchg   %ax,%ax

000002cc <lock_acquire>:

void lock_acquire(lock_t *lock) {
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 2d2:	b9 01 00 00 00       	mov    $0x1,%ecx
 2d7:	90                   	nop
 2d8:	89 c8                	mov    %ecx,%eax
 2da:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 2dd:	85 c0                	test   %eax,%eax
 2df:	75 f7                	jne    2d8 <lock_acquire+0xc>
}
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    
 2e3:	90                   	nop

000002e4 <lock_release>:

void lock_release(lock_t *lock) {
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ea:	31 c0                	xor    %eax,%eax
 2ec:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d 76 00             	lea    0x0(%esi),%esi

000002f4 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 2fa:	68 00 20 00 00       	push   $0x2000
 2ff:	e8 94 03 00 00       	call   698 <malloc>

  if((uint)stack % PGSIZE)
 304:	83 c4 10             	add    $0x10,%esp
 307:	89 c2                	mov    %eax,%edx
 309:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 30f:	74 07                	je     318 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 311:	29 d0                	sub    %edx,%eax
 313:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 318:	ff 75 0c             	pushl  0xc(%ebp)
 31b:	6a 08                	push   $0x8
 31d:	50                   	push   %eax
 31e:	ff 75 08             	pushl  0x8(%ebp)
 321:	e8 cc 00 00 00       	call   3f2 <clone>

  if (tid < 0) {
 326:	83 c4 10             	add    $0x10,%esp
 329:	85 c0                	test   %eax,%eax
 32b:	78 07                	js     334 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 32d:	31 c0                	xor    %eax,%eax
 32f:	c9                   	leave  
 330:	c3                   	ret    
 331:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 334:	83 ec 08             	sub    $0x8,%esp
 337:	68 bd 07 00 00       	push   $0x7bd
 33c:	6a 01                	push   $0x1
 33e:	e8 41 01 00 00       	call   484 <printf>
      return 0;
 343:	83 c4 10             	add    $0x10,%esp
}
 346:	31 c0                	xor    %eax,%eax
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34a:	b8 01 00 00 00       	mov    $0x1,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <exit>:
SYSCALL(exit)
 352:	b8 02 00 00 00       	mov    $0x2,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <wait>:
SYSCALL(wait)
 35a:	b8 03 00 00 00       	mov    $0x3,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <pipe>:
SYSCALL(pipe)
 362:	b8 04 00 00 00       	mov    $0x4,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <read>:
SYSCALL(read)
 36a:	b8 05 00 00 00       	mov    $0x5,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <write>:
SYSCALL(write)
 372:	b8 10 00 00 00       	mov    $0x10,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <close>:
SYSCALL(close)
 37a:	b8 15 00 00 00       	mov    $0x15,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <kill>:
SYSCALL(kill)
 382:	b8 06 00 00 00       	mov    $0x6,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exec>:
SYSCALL(exec)
 38a:	b8 07 00 00 00       	mov    $0x7,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <open>:
SYSCALL(open)
 392:	b8 0f 00 00 00       	mov    $0xf,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mknod>:
SYSCALL(mknod)
 39a:	b8 11 00 00 00       	mov    $0x11,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <unlink>:
SYSCALL(unlink)
 3a2:	b8 12 00 00 00       	mov    $0x12,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <fstat>:
SYSCALL(fstat)
 3aa:	b8 08 00 00 00       	mov    $0x8,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <link>:
SYSCALL(link)
 3b2:	b8 13 00 00 00       	mov    $0x13,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mkdir>:
SYSCALL(mkdir)
 3ba:	b8 14 00 00 00       	mov    $0x14,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <chdir>:
SYSCALL(chdir)
 3c2:	b8 09 00 00 00       	mov    $0x9,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <dup>:
SYSCALL(dup)
 3ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <getpid>:
SYSCALL(getpid)
 3d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sbrk>:
SYSCALL(sbrk)
 3da:	b8 0c 00 00 00       	mov    $0xc,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sleep>:
SYSCALL(sleep)
 3e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <uptime>:
SYSCALL(uptime)
 3ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <clone>:
 3f2:	b8 16 00 00 00       	mov    $0x16,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    
 3fa:	66 90                	xchg   %ax,%ax

000003fc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	57                   	push   %edi
 400:	56                   	push   %esi
 401:	53                   	push   %ebx
 402:	83 ec 3c             	sub    $0x3c,%esp
 405:	89 45 bc             	mov    %eax,-0x44(%ebp)
 408:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 40b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 40d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 410:	85 db                	test   %ebx,%ebx
 412:	74 04                	je     418 <printint+0x1c>
 414:	85 d2                	test   %edx,%edx
 416:	78 68                	js     480 <printint+0x84>
  neg = 0;
 418:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 41f:	31 ff                	xor    %edi,%edi
 421:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 424:	89 c8                	mov    %ecx,%eax
 426:	31 d2                	xor    %edx,%edx
 428:	f7 75 c4             	divl   -0x3c(%ebp)
 42b:	89 fb                	mov    %edi,%ebx
 42d:	8d 7f 01             	lea    0x1(%edi),%edi
 430:	8a 92 d4 07 00 00    	mov    0x7d4(%edx),%dl
 436:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 43a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 43d:	89 c1                	mov    %eax,%ecx
 43f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 442:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 445:	76 dd                	jbe    424 <printint+0x28>
  if(neg)
 447:	8b 4d 08             	mov    0x8(%ebp),%ecx
 44a:	85 c9                	test   %ecx,%ecx
 44c:	74 09                	je     457 <printint+0x5b>
    buf[i++] = '-';
 44e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 453:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 455:	b2 2d                	mov    $0x2d,%dl
 457:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 45b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 45e:	eb 03                	jmp    463 <printint+0x67>
 460:	8a 13                	mov    (%ebx),%dl
 462:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 463:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 466:	50                   	push   %eax
 467:	6a 01                	push   $0x1
 469:	56                   	push   %esi
 46a:	57                   	push   %edi
 46b:	e8 02 ff ff ff       	call   372 <write>
  while(--i >= 0)
 470:	83 c4 10             	add    $0x10,%esp
 473:	39 de                	cmp    %ebx,%esi
 475:	75 e9                	jne    460 <printint+0x64>
}
 477:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47a:	5b                   	pop    %ebx
 47b:	5e                   	pop    %esi
 47c:	5f                   	pop    %edi
 47d:	5d                   	pop    %ebp
 47e:	c3                   	ret    
 47f:	90                   	nop
    x = -xx;
 480:	f7 d9                	neg    %ecx
 482:	eb 9b                	jmp    41f <printint+0x23>

00000484 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	57                   	push   %edi
 488:	56                   	push   %esi
 489:	53                   	push   %ebx
 48a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48d:	8b 75 0c             	mov    0xc(%ebp),%esi
 490:	8a 1e                	mov    (%esi),%bl
 492:	84 db                	test   %bl,%bl
 494:	0f 84 a3 00 00 00    	je     53d <printf+0xb9>
 49a:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 49b:	8d 45 10             	lea    0x10(%ebp),%eax
 49e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 4a1:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 4a3:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4a6:	eb 29                	jmp    4d1 <printf+0x4d>
 4a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4ab:	83 f8 25             	cmp    $0x25,%eax
 4ae:	0f 84 94 00 00 00    	je     548 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 4b4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4b7:	50                   	push   %eax
 4b8:	6a 01                	push   $0x1
 4ba:	57                   	push   %edi
 4bb:	ff 75 08             	pushl  0x8(%ebp)
 4be:	e8 af fe ff ff       	call   372 <write>
        putc(fd, c);
 4c3:	83 c4 10             	add    $0x10,%esp
 4c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4c9:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 4ca:	8a 5e ff             	mov    -0x1(%esi),%bl
 4cd:	84 db                	test   %bl,%bl
 4cf:	74 6c                	je     53d <printf+0xb9>
    c = fmt[i] & 0xff;
 4d1:	0f be cb             	movsbl %bl,%ecx
 4d4:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d7:	85 d2                	test   %edx,%edx
 4d9:	74 cd                	je     4a8 <printf+0x24>
      }
    } else if(state == '%'){
 4db:	83 fa 25             	cmp    $0x25,%edx
 4de:	75 e9                	jne    4c9 <printf+0x45>
      if(c == 'd'){
 4e0:	83 f8 64             	cmp    $0x64,%eax
 4e3:	0f 84 97 00 00 00    	je     580 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e9:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ef:	83 f9 70             	cmp    $0x70,%ecx
 4f2:	74 60                	je     554 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f4:	83 f8 73             	cmp    $0x73,%eax
 4f7:	0f 84 8f 00 00 00    	je     58c <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fd:	83 f8 63             	cmp    $0x63,%eax
 500:	0f 84 d6 00 00 00    	je     5dc <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 506:	83 f8 25             	cmp    $0x25,%eax
 509:	0f 84 c1 00 00 00    	je     5d0 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 50f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 513:	50                   	push   %eax
 514:	6a 01                	push   $0x1
 516:	57                   	push   %edi
 517:	ff 75 08             	pushl  0x8(%ebp)
 51a:	e8 53 fe ff ff       	call   372 <write>
        putc(fd, c);
 51f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 522:	83 c4 0c             	add    $0xc,%esp
 525:	6a 01                	push   $0x1
 527:	57                   	push   %edi
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 42 fe ff ff       	call   372 <write>
        putc(fd, c);
 530:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 533:	31 d2                	xor    %edx,%edx
 535:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 536:	8a 5e ff             	mov    -0x1(%esi),%bl
 539:	84 db                	test   %bl,%bl
 53b:	75 94                	jne    4d1 <printf+0x4d>
    }
  }
}
 53d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 540:	5b                   	pop    %ebx
 541:	5e                   	pop    %esi
 542:	5f                   	pop    %edi
 543:	5d                   	pop    %ebp
 544:	c3                   	ret    
 545:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 548:	ba 25 00 00 00       	mov    $0x25,%edx
 54d:	e9 77 ff ff ff       	jmp    4c9 <printf+0x45>
 552:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 554:	83 ec 0c             	sub    $0xc,%esp
 557:	6a 00                	push   $0x0
 559:	b9 10 00 00 00       	mov    $0x10,%ecx
 55e:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 561:	8b 13                	mov    (%ebx),%edx
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	e8 91 fe ff ff       	call   3fc <printint>
        ap++;
 56b:	89 d8                	mov    %ebx,%eax
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d0             	mov    %eax,-0x30(%ebp)
 573:	83 c4 10             	add    $0x10,%esp
      state = 0;
 576:	31 d2                	xor    %edx,%edx
        ap++;
 578:	e9 4c ff ff ff       	jmp    4c9 <printf+0x45>
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	6a 01                	push   $0x1
 585:	b9 0a 00 00 00       	mov    $0xa,%ecx
 58a:	eb d2                	jmp    55e <printf+0xda>
        s = (char*)*ap;
 58c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 58f:	8b 18                	mov    (%eax),%ebx
        ap++;
 591:	83 c0 04             	add    $0x4,%eax
 594:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 597:	85 db                	test   %ebx,%ebx
 599:	74 65                	je     600 <printf+0x17c>
        while(*s != 0){
 59b:	8a 03                	mov    (%ebx),%al
 59d:	84 c0                	test   %al,%al
 59f:	74 70                	je     611 <printf+0x18d>
 5a1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5a4:	89 de                	mov    %ebx,%esi
 5a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5a9:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 5ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5af:	50                   	push   %eax
 5b0:	6a 01                	push   $0x1
 5b2:	57                   	push   %edi
 5b3:	53                   	push   %ebx
 5b4:	e8 b9 fd ff ff       	call   372 <write>
          s++;
 5b9:	46                   	inc    %esi
        while(*s != 0){
 5ba:	8a 06                	mov    (%esi),%al
 5bc:	83 c4 10             	add    $0x10,%esp
 5bf:	84 c0                	test   %al,%al
 5c1:	75 e9                	jne    5ac <printf+0x128>
 5c3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5c6:	31 d2                	xor    %edx,%edx
 5c8:	e9 fc fe ff ff       	jmp    4c9 <printf+0x45>
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d3:	52                   	push   %edx
 5d4:	e9 4c ff ff ff       	jmp    525 <printf+0xa1>
 5d9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5dc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5df:	8b 03                	mov    (%ebx),%eax
 5e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e4:	51                   	push   %ecx
 5e5:	6a 01                	push   $0x1
 5e7:	57                   	push   %edi
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 82 fd ff ff       	call   372 <write>
        ap++;
 5f0:	83 c3 04             	add    $0x4,%ebx
 5f3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5f6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5f9:	31 d2                	xor    %edx,%edx
 5fb:	e9 c9 fe ff ff       	jmp    4c9 <printf+0x45>
          s = "(null)";
 600:	bb cd 07 00 00       	mov    $0x7cd,%ebx
        while(*s != 0){
 605:	b0 28                	mov    $0x28,%al
 607:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 60a:	89 de                	mov    %ebx,%esi
 60c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 60f:	eb 9b                	jmp    5ac <printf+0x128>
      state = 0;
 611:	31 d2                	xor    %edx,%edx
 613:	e9 b1 fe ff ff       	jmp    4c9 <printf+0x45>

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	57                   	push   %edi
 61c:	56                   	push   %esi
 61d:	53                   	push   %ebx
 61e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 621:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	a1 00 0b 00 00       	mov    0xb00,%eax
 629:	8b 10                	mov    (%eax),%edx
 62b:	39 c8                	cmp    %ecx,%eax
 62d:	73 11                	jae    640 <free+0x28>
 62f:	90                   	nop
 630:	39 d1                	cmp    %edx,%ecx
 632:	72 14                	jb     648 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	39 d0                	cmp    %edx,%eax
 636:	73 10                	jae    648 <free+0x30>
{
 638:	89 d0                	mov    %edx,%eax
 63a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	39 c8                	cmp    %ecx,%eax
 63e:	72 f0                	jb     630 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	39 d0                	cmp    %edx,%eax
 642:	72 f4                	jb     638 <free+0x20>
 644:	39 d1                	cmp    %edx,%ecx
 646:	73 f0                	jae    638 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 73 fc             	mov    -0x4(%ebx),%esi
 64b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64e:	39 fa                	cmp    %edi,%edx
 650:	74 1a                	je     66c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 652:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 65b:	39 f1                	cmp    %esi,%ecx
 65d:	74 24                	je     683 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 65f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 661:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 666:	5b                   	pop    %ebx
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
 66b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 66c:	03 72 04             	add    0x4(%edx),%esi
 66f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 672:	8b 10                	mov    (%eax),%edx
 674:	8b 12                	mov    (%edx),%edx
 676:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 67f:	39 f1                	cmp    %esi,%ecx
 681:	75 dc                	jne    65f <free+0x47>
    p->s.size += bp->s.size;
 683:	03 53 fc             	add    -0x4(%ebx),%edx
 686:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 689:	8b 53 f8             	mov    -0x8(%ebx),%edx
 68c:	89 10                	mov    %edx,(%eax)
  freep = p;
 68e:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 693:	5b                   	pop    %ebx
 694:	5e                   	pop    %esi
 695:	5f                   	pop    %edi
 696:	5d                   	pop    %ebp
 697:	c3                   	ret    

00000698 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	57                   	push   %edi
 69c:	56                   	push   %esi
 69d:	53                   	push   %ebx
 69e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	8d 70 07             	lea    0x7(%eax),%esi
 6a7:	c1 ee 03             	shr    $0x3,%esi
 6aa:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6ab:	8b 3d 00 0b 00 00    	mov    0xb00,%edi
 6b1:	85 ff                	test   %edi,%edi
 6b3:	0f 84 a3 00 00 00    	je     75c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b9:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6bb:	8b 48 04             	mov    0x4(%eax),%ecx
 6be:	39 f1                	cmp    %esi,%ecx
 6c0:	73 67                	jae    729 <malloc+0x91>
 6c2:	89 f3                	mov    %esi,%ebx
 6c4:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6ca:	0f 82 80 00 00 00    	jb     750 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 6d0:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6da:	eb 11                	jmp    6ed <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6dc:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6de:	8b 4a 04             	mov    0x4(%edx),%ecx
 6e1:	39 f1                	cmp    %esi,%ecx
 6e3:	73 4b                	jae    730 <malloc+0x98>
 6e5:	8b 3d 00 0b 00 00    	mov    0xb00,%edi
 6eb:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6ed:	39 c7                	cmp    %eax,%edi
 6ef:	75 eb                	jne    6dc <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	ff 75 e4             	pushl  -0x1c(%ebp)
 6f7:	e8 de fc ff ff       	call   3da <sbrk>
  if(p == (char*)-1)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 702:	74 1b                	je     71f <malloc+0x87>
  hp->s.size = nu;
 704:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 707:	83 ec 0c             	sub    $0xc,%esp
 70a:	83 c0 08             	add    $0x8,%eax
 70d:	50                   	push   %eax
 70e:	e8 05 ff ff ff       	call   618 <free>
  return freep;
 713:	a1 00 0b 00 00       	mov    0xb00,%eax
      if((p = morecore(nunits)) == 0)
 718:	83 c4 10             	add    $0x10,%esp
 71b:	85 c0                	test   %eax,%eax
 71d:	75 bd                	jne    6dc <malloc+0x44>
        return 0;
 71f:	31 c0                	xor    %eax,%eax
  }
}
 721:	8d 65 f4             	lea    -0xc(%ebp),%esp
 724:	5b                   	pop    %ebx
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
    if(p->s.size >= nunits){
 729:	89 c2                	mov    %eax,%edx
 72b:	89 f8                	mov    %edi,%eax
 72d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 730:	39 ce                	cmp    %ecx,%esi
 732:	74 54                	je     788 <malloc+0xf0>
        p->s.size -= nunits;
 734:	29 f1                	sub    %esi,%ecx
 736:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 739:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 73c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 73f:	a3 00 0b 00 00       	mov    %eax,0xb00
      return (void*)(p + 1);
 744:	8d 42 08             	lea    0x8(%edx),%eax
}
 747:	8d 65 f4             	lea    -0xc(%ebp),%esp
 74a:	5b                   	pop    %ebx
 74b:	5e                   	pop    %esi
 74c:	5f                   	pop    %edi
 74d:	5d                   	pop    %ebp
 74e:	c3                   	ret    
 74f:	90                   	nop
 750:	bb 00 10 00 00       	mov    $0x1000,%ebx
 755:	e9 76 ff ff ff       	jmp    6d0 <malloc+0x38>
 75a:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 75c:	c7 05 00 0b 00 00 04 	movl   $0xb04,0xb00
 763:	0b 00 00 
 766:	c7 05 04 0b 00 00 04 	movl   $0xb04,0xb04
 76d:	0b 00 00 
    base.s.size = 0;
 770:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 777:	00 00 00 
 77a:	bf 04 0b 00 00       	mov    $0xb04,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77f:	89 f8                	mov    %edi,%eax
 781:	e9 3c ff ff ff       	jmp    6c2 <malloc+0x2a>
 786:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 788:	8b 0a                	mov    (%edx),%ecx
 78a:	89 08                	mov    %ecx,(%eax)
 78c:	eb b1                	jmp    73f <malloc+0xa7>

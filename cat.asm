
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 54                	jle    73 <main+0x73>
  1f:	83 c3 04             	add    $0x4,%ebx
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	pushl  (%ebx)
  2f:	e8 3e 03 00 00       	call   372 <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 22                	js     5f <main+0x5f>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	50                   	push   %eax
  41:	e8 3e 00 00 00       	call   84 <cat>
    close(fd);
  46:	89 3c 24             	mov    %edi,(%esp)
  49:	e8 0c 03 00 00       	call   35a <close>
  for(i = 1; i < argc; i++){
  4e:	46                   	inc    %esi
  4f:	83 c3 04             	add    $0x4,%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  58:	75 ce                	jne    28 <main+0x28>
  }
  exit();
  5a:	e8 d3 02 00 00       	call   332 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5f:	50                   	push   %eax
  60:	ff 33                	pushl  (%ebx)
  62:	68 93 07 00 00       	push   $0x793
  67:	6a 01                	push   $0x1
  69:	e8 f6 03 00 00       	call   464 <printf>
      exit();
  6e:	e8 bf 02 00 00       	call   332 <exit>
    cat(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 07 00 00 00       	call   84 <cat>
    exit();
  7d:	e8 b0 02 00 00       	call   332 <exit>
  82:	66 90                	xchg   %ax,%ax

00000084 <cat>:
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	56                   	push   %esi
  88:	53                   	push   %ebx
  89:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  8c:	eb 17                	jmp    a5 <cat+0x21>
  8e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  90:	51                   	push   %ecx
  91:	53                   	push   %ebx
  92:	68 40 0b 00 00       	push   $0xb40
  97:	6a 01                	push   $0x1
  99:	e8 b4 02 00 00       	call   352 <write>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	39 d8                	cmp    %ebx,%eax
  a3:	75 23                	jne    c8 <cat+0x44>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  a5:	52                   	push   %edx
  a6:	68 00 02 00 00       	push   $0x200
  ab:	68 40 0b 00 00       	push   $0xb40
  b0:	56                   	push   %esi
  b1:	e8 94 02 00 00       	call   34a <read>
  b6:	89 c3                	mov    %eax,%ebx
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	85 c0                	test   %eax,%eax
  bd:	7f d1                	jg     90 <cat+0xc>
  if(n < 0){
  bf:	75 1b                	jne    dc <cat+0x58>
}
  c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
      printf(1, "cat: write error\n");
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	68 70 07 00 00       	push   $0x770
  d0:	6a 01                	push   $0x1
  d2:	e8 8d 03 00 00       	call   464 <printf>
      exit();
  d7:	e8 56 02 00 00       	call   332 <exit>
    printf(1, "cat: read error\n");
  dc:	50                   	push   %eax
  dd:	50                   	push   %eax
  de:	68 82 07 00 00       	push   $0x782
  e3:	6a 01                	push   $0x1
  e5:	e8 7a 03 00 00       	call   464 <printf>
    exit();
  ea:	e8 43 02 00 00       	call   332 <exit>
  ef:	90                   	nop

000000f0 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	31 c0                	xor    %eax,%eax
  fc:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 102:	40                   	inc    %eax
 103:	84 d2                	test   %dl,%dl
 105:	75 f5                	jne    fc <strcpy+0xc>
    ;
  return os;
}
 107:	89 c8                	mov    %ecx,%eax
 109:	5b                   	pop    %ebx
 10a:	5d                   	pop    %ebp
 10b:	c3                   	ret    

0000010c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	53                   	push   %ebx
 110:	8b 5d 08             	mov    0x8(%ebp),%ebx
 113:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 116:	0f b6 03             	movzbl (%ebx),%eax
 119:	0f b6 0a             	movzbl (%edx),%ecx
 11c:	84 c0                	test   %al,%al
 11e:	75 10                	jne    130 <strcmp+0x24>
 120:	eb 1a                	jmp    13c <strcmp+0x30>
 122:	66 90                	xchg   %ax,%ax
    p++, q++;
 124:	43                   	inc    %ebx
 125:	42                   	inc    %edx
  while(*p && *p == *q)
 126:	0f b6 03             	movzbl (%ebx),%eax
 129:	0f b6 0a             	movzbl (%edx),%ecx
 12c:	84 c0                	test   %al,%al
 12e:	74 0c                	je     13c <strcmp+0x30>
 130:	38 c8                	cmp    %cl,%al
 132:	74 f0                	je     124 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 134:	29 c8                	sub    %ecx,%eax
}
 136:	5b                   	pop    %ebx
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    
 139:	8d 76 00             	lea    0x0(%esi),%esi
 13c:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 13e:	29 c8                	sub    %ecx,%eax
}
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	90                   	nop

00000144 <strlen>:

uint
strlen(const char *s)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 14a:	80 3a 00             	cmpb   $0x0,(%edx)
 14d:	74 15                	je     164 <strlen+0x20>
 14f:	31 c0                	xor    %eax,%eax
 151:	8d 76 00             	lea    0x0(%esi),%esi
 154:	40                   	inc    %eax
 155:	89 c1                	mov    %eax,%ecx
 157:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 15b:	75 f7                	jne    154 <strlen+0x10>
    ;
  return n;
}
 15d:	89 c8                	mov    %ecx,%eax
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 164:	31 c9                	xor    %ecx,%ecx
}
 166:	89 c8                	mov    %ecx,%eax
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    
 16a:	66 90                	xchg   %ax,%ax

0000016c <memset>:

void*
memset(void *dst, int c, uint n)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 170:	8b 7d 08             	mov    0x8(%ebp),%edi
 173:	8b 4d 10             	mov    0x10(%ebp),%ecx
 176:	8b 45 0c             	mov    0xc(%ebp),%eax
 179:	fc                   	cld    
 17a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    
 182:	66 90                	xchg   %ax,%ax

00000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 18d:	8a 10                	mov    (%eax),%dl
 18f:	84 d2                	test   %dl,%dl
 191:	75 0c                	jne    19f <strchr+0x1b>
 193:	eb 13                	jmp    1a8 <strchr+0x24>
 195:	8d 76 00             	lea    0x0(%esi),%esi
 198:	40                   	inc    %eax
 199:	8a 10                	mov    (%eax),%dl
 19b:	84 d2                	test   %dl,%dl
 19d:	74 09                	je     1a8 <strchr+0x24>
    if(*s == c)
 19f:	38 d1                	cmp    %dl,%cl
 1a1:	75 f5                	jne    198 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1a8:	31 c0                	xor    %eax,%eax
}
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    

000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	56                   	push   %esi
 1b1:	53                   	push   %ebx
 1b2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	8b 75 08             	mov    0x8(%ebp),%esi
 1b8:	bb 01 00 00 00       	mov    $0x1,%ebx
 1bd:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 1bf:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c2:	eb 20                	jmp    1e4 <gets+0x38>
    cc = read(0, &c, 1);
 1c4:	50                   	push   %eax
 1c5:	6a 01                	push   $0x1
 1c7:	57                   	push   %edi
 1c8:	6a 00                	push   $0x0
 1ca:	e8 7b 01 00 00       	call   34a <read>
    if(cc < 1)
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	85 c0                	test   %eax,%eax
 1d4:	7e 16                	jle    1ec <gets+0x40>
      break;
    buf[i++] = c;
 1d6:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d9:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 1db:	46                   	inc    %esi
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 0c                	je     1ec <gets+0x40>
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 08                	je     1ec <gets+0x40>
  for(i=0; i+1 < max; ){
 1e4:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 1e7:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ea:	7f d8                	jg     1c4 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 1ec:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f5:	5b                   	pop    %ebx
 1f6:	5e                   	pop    %esi
 1f7:	5f                   	pop    %edi
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	66 90                	xchg   %ax,%ax

000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	56                   	push   %esi
 200:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	6a 00                	push   $0x0
 206:	ff 75 08             	pushl  0x8(%ebp)
 209:	e8 64 01 00 00       	call   372 <open>
  if(fd < 0)
 20e:	83 c4 10             	add    $0x10,%esp
 211:	85 c0                	test   %eax,%eax
 213:	78 27                	js     23c <stat+0x40>
 215:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	ff 75 0c             	pushl  0xc(%ebp)
 21d:	50                   	push   %eax
 21e:	e8 67 01 00 00       	call   38a <fstat>
 223:	89 c6                	mov    %eax,%esi
  close(fd);
 225:	89 1c 24             	mov    %ebx,(%esp)
 228:	e8 2d 01 00 00       	call   35a <close>
  return r;
 22d:	83 c4 10             	add    $0x10,%esp
}
 230:	89 f0                	mov    %esi,%eax
 232:	8d 65 f8             	lea    -0x8(%ebp),%esp
 235:	5b                   	pop    %ebx
 236:	5e                   	pop    %esi
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    
 239:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 23c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 241:	eb ed                	jmp    230 <stat+0x34>
 243:	90                   	nop

00000244 <atoi>:

int
atoi(const char *s)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	53                   	push   %ebx
 248:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24b:	0f be 01             	movsbl (%ecx),%eax
 24e:	8d 50 d0             	lea    -0x30(%eax),%edx
 251:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 254:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 259:	77 16                	ja     271 <atoi+0x2d>
 25b:	90                   	nop
    n = n*10 + *s++ - '0';
 25c:	41                   	inc    %ecx
 25d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 260:	01 d2                	add    %edx,%edx
 262:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 266:	0f be 01             	movsbl (%ecx),%eax
 269:	8d 58 d0             	lea    -0x30(%eax),%ebx
 26c:	80 fb 09             	cmp    $0x9,%bl
 26f:	76 eb                	jbe    25c <atoi+0x18>
  return n;
}
 271:	89 d0                	mov    %edx,%eax
 273:	5b                   	pop    %ebx
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    
 276:	66 90                	xchg   %ax,%ax

00000278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	57                   	push   %edi
 27c:	56                   	push   %esi
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	8b 75 0c             	mov    0xc(%ebp),%esi
 283:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 286:	85 d2                	test   %edx,%edx
 288:	7e 0b                	jle    295 <memmove+0x1d>
 28a:	01 c2                	add    %eax,%edx
  dst = vdst;
 28c:	89 c7                	mov    %eax,%edi
 28e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 290:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 291:	39 fa                	cmp    %edi,%edx
 293:	75 fb                	jne    290 <memmove+0x18>
  return vdst;
}
 295:	5e                   	pop    %esi
 296:	5f                   	pop    %edi
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    
 299:	8d 76 00             	lea    0x0(%esi),%esi

0000029c <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    
 2aa:	66 90                	xchg   %ax,%ax

000002ac <lock_acquire>:

void lock_acquire(lock_t *lock) {
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 2b2:	b9 01 00 00 00       	mov    $0x1,%ecx
 2b7:	90                   	nop
 2b8:	89 c8                	mov    %ecx,%eax
 2ba:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 2bd:	85 c0                	test   %eax,%eax
 2bf:	75 f7                	jne    2b8 <lock_acquire+0xc>
}
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	90                   	nop

000002c4 <lock_release>:

void lock_release(lock_t *lock) {
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ca:	31 c0                	xor    %eax,%eax
 2cc:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    
 2d1:	8d 76 00             	lea    0x0(%esi),%esi

000002d4 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 2da:	68 00 20 00 00       	push   $0x2000
 2df:	e8 94 03 00 00       	call   678 <malloc>

  if((uint)stack % PGSIZE)
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	89 c2                	mov    %eax,%edx
 2e9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 2ef:	74 07                	je     2f8 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 2f1:	29 d0                	sub    %edx,%eax
 2f3:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 2f8:	ff 75 0c             	pushl  0xc(%ebp)
 2fb:	6a 08                	push   $0x8
 2fd:	50                   	push   %eax
 2fe:	ff 75 08             	pushl  0x8(%ebp)
 301:	e8 cc 00 00 00       	call   3d2 <clone>

  if (tid < 0) {
 306:	83 c4 10             	add    $0x10,%esp
 309:	85 c0                	test   %eax,%eax
 30b:	78 07                	js     314 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 30d:	31 c0                	xor    %eax,%eax
 30f:	c9                   	leave  
 310:	c3                   	ret    
 311:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 314:	83 ec 08             	sub    $0x8,%esp
 317:	68 a8 07 00 00       	push   $0x7a8
 31c:	6a 01                	push   $0x1
 31e:	e8 41 01 00 00       	call   464 <printf>
      return 0;
 323:	83 c4 10             	add    $0x10,%esp
}
 326:	31 c0                	xor    %eax,%eax
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32a:	b8 01 00 00 00       	mov    $0x1,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <exit>:
SYSCALL(exit)
 332:	b8 02 00 00 00       	mov    $0x2,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <wait>:
SYSCALL(wait)
 33a:	b8 03 00 00 00       	mov    $0x3,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <pipe>:
SYSCALL(pipe)
 342:	b8 04 00 00 00       	mov    $0x4,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <read>:
SYSCALL(read)
 34a:	b8 05 00 00 00       	mov    $0x5,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <write>:
SYSCALL(write)
 352:	b8 10 00 00 00       	mov    $0x10,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <close>:
SYSCALL(close)
 35a:	b8 15 00 00 00       	mov    $0x15,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <kill>:
SYSCALL(kill)
 362:	b8 06 00 00 00       	mov    $0x6,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <exec>:
SYSCALL(exec)
 36a:	b8 07 00 00 00       	mov    $0x7,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <open>:
SYSCALL(open)
 372:	b8 0f 00 00 00       	mov    $0xf,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mknod>:
SYSCALL(mknod)
 37a:	b8 11 00 00 00       	mov    $0x11,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <unlink>:
SYSCALL(unlink)
 382:	b8 12 00 00 00       	mov    $0x12,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <fstat>:
SYSCALL(fstat)
 38a:	b8 08 00 00 00       	mov    $0x8,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <link>:
SYSCALL(link)
 392:	b8 13 00 00 00       	mov    $0x13,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mkdir>:
SYSCALL(mkdir)
 39a:	b8 14 00 00 00       	mov    $0x14,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <chdir>:
SYSCALL(chdir)
 3a2:	b8 09 00 00 00       	mov    $0x9,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <dup>:
SYSCALL(dup)
 3aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getpid>:
SYSCALL(getpid)
 3b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sbrk>:
SYSCALL(sbrk)
 3ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sleep>:
SYSCALL(sleep)
 3c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <uptime>:
SYSCALL(uptime)
 3ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <clone>:
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    
 3da:	66 90                	xchg   %ax,%ax

000003dc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	57                   	push   %edi
 3e0:	56                   	push   %esi
 3e1:	53                   	push   %ebx
 3e2:	83 ec 3c             	sub    $0x3c,%esp
 3e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 3e8:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3eb:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 3ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3f0:	85 db                	test   %ebx,%ebx
 3f2:	74 04                	je     3f8 <printint+0x1c>
 3f4:	85 d2                	test   %edx,%edx
 3f6:	78 68                	js     460 <printint+0x84>
  neg = 0;
 3f8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ff:	31 ff                	xor    %edi,%edi
 401:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 404:	89 c8                	mov    %ecx,%eax
 406:	31 d2                	xor    %edx,%edx
 408:	f7 75 c4             	divl   -0x3c(%ebp)
 40b:	89 fb                	mov    %edi,%ebx
 40d:	8d 7f 01             	lea    0x1(%edi),%edi
 410:	8a 92 c0 07 00 00    	mov    0x7c0(%edx),%dl
 416:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 41a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 41d:	89 c1                	mov    %eax,%ecx
 41f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 422:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 425:	76 dd                	jbe    404 <printint+0x28>
  if(neg)
 427:	8b 4d 08             	mov    0x8(%ebp),%ecx
 42a:	85 c9                	test   %ecx,%ecx
 42c:	74 09                	je     437 <printint+0x5b>
    buf[i++] = '-';
 42e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 433:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 435:	b2 2d                	mov    $0x2d,%dl
 437:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 43b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 43e:	eb 03                	jmp    443 <printint+0x67>
 440:	8a 13                	mov    (%ebx),%dl
 442:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 443:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 446:	50                   	push   %eax
 447:	6a 01                	push   $0x1
 449:	56                   	push   %esi
 44a:	57                   	push   %edi
 44b:	e8 02 ff ff ff       	call   352 <write>
  while(--i >= 0)
 450:	83 c4 10             	add    $0x10,%esp
 453:	39 de                	cmp    %ebx,%esi
 455:	75 e9                	jne    440 <printint+0x64>
}
 457:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5f                   	pop    %edi
 45d:	5d                   	pop    %ebp
 45e:	c3                   	ret    
 45f:	90                   	nop
    x = -xx;
 460:	f7 d9                	neg    %ecx
 462:	eb 9b                	jmp    3ff <printint+0x23>

00000464 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	57                   	push   %edi
 468:	56                   	push   %esi
 469:	53                   	push   %ebx
 46a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46d:	8b 75 0c             	mov    0xc(%ebp),%esi
 470:	8a 1e                	mov    (%esi),%bl
 472:	84 db                	test   %bl,%bl
 474:	0f 84 a3 00 00 00    	je     51d <printf+0xb9>
 47a:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 47b:	8d 45 10             	lea    0x10(%ebp),%eax
 47e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 481:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 483:	8d 7d e7             	lea    -0x19(%ebp),%edi
 486:	eb 29                	jmp    4b1 <printf+0x4d>
 488:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 48b:	83 f8 25             	cmp    $0x25,%eax
 48e:	0f 84 94 00 00 00    	je     528 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 494:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 497:	50                   	push   %eax
 498:	6a 01                	push   $0x1
 49a:	57                   	push   %edi
 49b:	ff 75 08             	pushl  0x8(%ebp)
 49e:	e8 af fe ff ff       	call   352 <write>
        putc(fd, c);
 4a3:	83 c4 10             	add    $0x10,%esp
 4a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a9:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 4aa:	8a 5e ff             	mov    -0x1(%esi),%bl
 4ad:	84 db                	test   %bl,%bl
 4af:	74 6c                	je     51d <printf+0xb9>
    c = fmt[i] & 0xff;
 4b1:	0f be cb             	movsbl %bl,%ecx
 4b4:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4b7:	85 d2                	test   %edx,%edx
 4b9:	74 cd                	je     488 <printf+0x24>
      }
    } else if(state == '%'){
 4bb:	83 fa 25             	cmp    $0x25,%edx
 4be:	75 e9                	jne    4a9 <printf+0x45>
      if(c == 'd'){
 4c0:	83 f8 64             	cmp    $0x64,%eax
 4c3:	0f 84 97 00 00 00    	je     560 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c9:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4cf:	83 f9 70             	cmp    $0x70,%ecx
 4d2:	74 60                	je     534 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d4:	83 f8 73             	cmp    $0x73,%eax
 4d7:	0f 84 8f 00 00 00    	je     56c <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4dd:	83 f8 63             	cmp    $0x63,%eax
 4e0:	0f 84 d6 00 00 00    	je     5bc <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e6:	83 f8 25             	cmp    $0x25,%eax
 4e9:	0f 84 c1 00 00 00    	je     5b0 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4f3:	50                   	push   %eax
 4f4:	6a 01                	push   $0x1
 4f6:	57                   	push   %edi
 4f7:	ff 75 08             	pushl  0x8(%ebp)
 4fa:	e8 53 fe ff ff       	call   352 <write>
        putc(fd, c);
 4ff:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 502:	83 c4 0c             	add    $0xc,%esp
 505:	6a 01                	push   $0x1
 507:	57                   	push   %edi
 508:	ff 75 08             	pushl  0x8(%ebp)
 50b:	e8 42 fe ff ff       	call   352 <write>
        putc(fd, c);
 510:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 513:	31 d2                	xor    %edx,%edx
 515:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 516:	8a 5e ff             	mov    -0x1(%esi),%bl
 519:	84 db                	test   %bl,%bl
 51b:	75 94                	jne    4b1 <printf+0x4d>
    }
  }
}
 51d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 520:	5b                   	pop    %ebx
 521:	5e                   	pop    %esi
 522:	5f                   	pop    %edi
 523:	5d                   	pop    %ebp
 524:	c3                   	ret    
 525:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 528:	ba 25 00 00 00       	mov    $0x25,%edx
 52d:	e9 77 ff ff ff       	jmp    4a9 <printf+0x45>
 532:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 534:	83 ec 0c             	sub    $0xc,%esp
 537:	6a 00                	push   $0x0
 539:	b9 10 00 00 00       	mov    $0x10,%ecx
 53e:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 541:	8b 13                	mov    (%ebx),%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 91 fe ff ff       	call   3dc <printint>
        ap++;
 54b:	89 d8                	mov    %ebx,%eax
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d0             	mov    %eax,-0x30(%ebp)
 553:	83 c4 10             	add    $0x10,%esp
      state = 0;
 556:	31 d2                	xor    %edx,%edx
        ap++;
 558:	e9 4c ff ff ff       	jmp    4a9 <printf+0x45>
 55d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 560:	83 ec 0c             	sub    $0xc,%esp
 563:	6a 01                	push   $0x1
 565:	b9 0a 00 00 00       	mov    $0xa,%ecx
 56a:	eb d2                	jmp    53e <printf+0xda>
        s = (char*)*ap;
 56c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 56f:	8b 18                	mov    (%eax),%ebx
        ap++;
 571:	83 c0 04             	add    $0x4,%eax
 574:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 577:	85 db                	test   %ebx,%ebx
 579:	74 65                	je     5e0 <printf+0x17c>
        while(*s != 0){
 57b:	8a 03                	mov    (%ebx),%al
 57d:	84 c0                	test   %al,%al
 57f:	74 70                	je     5f1 <printf+0x18d>
 581:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 584:	89 de                	mov    %ebx,%esi
 586:	8b 5d 08             	mov    0x8(%ebp),%ebx
 589:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 58c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58f:	50                   	push   %eax
 590:	6a 01                	push   $0x1
 592:	57                   	push   %edi
 593:	53                   	push   %ebx
 594:	e8 b9 fd ff ff       	call   352 <write>
          s++;
 599:	46                   	inc    %esi
        while(*s != 0){
 59a:	8a 06                	mov    (%esi),%al
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	84 c0                	test   %al,%al
 5a1:	75 e9                	jne    58c <printf+0x128>
 5a3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5a6:	31 d2                	xor    %edx,%edx
 5a8:	e9 fc fe ff ff       	jmp    4a9 <printf+0x45>
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5b3:	52                   	push   %edx
 5b4:	e9 4c ff ff ff       	jmp    505 <printf+0xa1>
 5b9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5bc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5bf:	8b 03                	mov    (%ebx),%eax
 5c1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5c4:	51                   	push   %ecx
 5c5:	6a 01                	push   $0x1
 5c7:	57                   	push   %edi
 5c8:	ff 75 08             	pushl  0x8(%ebp)
 5cb:	e8 82 fd ff ff       	call   352 <write>
        ap++;
 5d0:	83 c3 04             	add    $0x4,%ebx
 5d3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d9:	31 d2                	xor    %edx,%edx
 5db:	e9 c9 fe ff ff       	jmp    4a9 <printf+0x45>
          s = "(null)";
 5e0:	bb b8 07 00 00       	mov    $0x7b8,%ebx
        while(*s != 0){
 5e5:	b0 28                	mov    $0x28,%al
 5e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ea:	89 de                	mov    %ebx,%esi
 5ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ef:	eb 9b                	jmp    58c <printf+0x128>
      state = 0;
 5f1:	31 d2                	xor    %edx,%edx
 5f3:	e9 b1 fe ff ff       	jmp    4a9 <printf+0x45>

000005f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	57                   	push   %edi
 5fc:	56                   	push   %esi
 5fd:	53                   	push   %ebx
 5fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 601:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 604:	a1 20 0b 00 00       	mov    0xb20,%eax
 609:	8b 10                	mov    (%eax),%edx
 60b:	39 c8                	cmp    %ecx,%eax
 60d:	73 11                	jae    620 <free+0x28>
 60f:	90                   	nop
 610:	39 d1                	cmp    %edx,%ecx
 612:	72 14                	jb     628 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	39 d0                	cmp    %edx,%eax
 616:	73 10                	jae    628 <free+0x30>
{
 618:	89 d0                	mov    %edx,%eax
 61a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	39 c8                	cmp    %ecx,%eax
 61e:	72 f0                	jb     610 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 f4                	jb     618 <free+0x20>
 624:	39 d1                	cmp    %edx,%ecx
 626:	73 f0                	jae    618 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 fa                	cmp    %edi,%edx
 630:	74 1a                	je     64c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 632:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63b:	39 f1                	cmp    %esi,%ecx
 63d:	74 24                	je     663 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 641:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 646:	5b                   	pop    %ebx
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 64c:	03 72 04             	add    0x4(%edx),%esi
 64f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 652:	8b 10                	mov    (%eax),%edx
 654:	8b 12                	mov    (%edx),%edx
 656:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 659:	8b 50 04             	mov    0x4(%eax),%edx
 65c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 65f:	39 f1                	cmp    %esi,%ecx
 661:	75 dc                	jne    63f <free+0x47>
    p->s.size += bp->s.size;
 663:	03 53 fc             	add    -0x4(%ebx),%edx
 666:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 669:	8b 53 f8             	mov    -0x8(%ebx),%edx
 66c:	89 10                	mov    %edx,(%eax)
  freep = p;
 66e:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    

00000678 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	57                   	push   %edi
 67c:	56                   	push   %esi
 67d:	53                   	push   %ebx
 67e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	8d 70 07             	lea    0x7(%eax),%esi
 687:	c1 ee 03             	shr    $0x3,%esi
 68a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 68b:	8b 3d 20 0b 00 00    	mov    0xb20,%edi
 691:	85 ff                	test   %edi,%edi
 693:	0f 84 a3 00 00 00    	je     73c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 699:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 69b:	8b 48 04             	mov    0x4(%eax),%ecx
 69e:	39 f1                	cmp    %esi,%ecx
 6a0:	73 67                	jae    709 <malloc+0x91>
 6a2:	89 f3                	mov    %esi,%ebx
 6a4:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6aa:	0f 82 80 00 00 00    	jb     730 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 6b0:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6b7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6ba:	eb 11                	jmp    6cd <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6bc:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6be:	8b 4a 04             	mov    0x4(%edx),%ecx
 6c1:	39 f1                	cmp    %esi,%ecx
 6c3:	73 4b                	jae    710 <malloc+0x98>
 6c5:	8b 3d 20 0b 00 00    	mov    0xb20,%edi
 6cb:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6cd:	39 c7                	cmp    %eax,%edi
 6cf:	75 eb                	jne    6bc <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 6d1:	83 ec 0c             	sub    $0xc,%esp
 6d4:	ff 75 e4             	pushl  -0x1c(%ebp)
 6d7:	e8 de fc ff ff       	call   3ba <sbrk>
  if(p == (char*)-1)
 6dc:	83 c4 10             	add    $0x10,%esp
 6df:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e2:	74 1b                	je     6ff <malloc+0x87>
  hp->s.size = nu;
 6e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	50                   	push   %eax
 6ee:	e8 05 ff ff ff       	call   5f8 <free>
  return freep;
 6f3:	a1 20 0b 00 00       	mov    0xb20,%eax
      if((p = morecore(nunits)) == 0)
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	85 c0                	test   %eax,%eax
 6fd:	75 bd                	jne    6bc <malloc+0x44>
        return 0;
 6ff:	31 c0                	xor    %eax,%eax
  }
}
 701:	8d 65 f4             	lea    -0xc(%ebp),%esp
 704:	5b                   	pop    %ebx
 705:	5e                   	pop    %esi
 706:	5f                   	pop    %edi
 707:	5d                   	pop    %ebp
 708:	c3                   	ret    
    if(p->s.size >= nunits){
 709:	89 c2                	mov    %eax,%edx
 70b:	89 f8                	mov    %edi,%eax
 70d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 710:	39 ce                	cmp    %ecx,%esi
 712:	74 54                	je     768 <malloc+0xf0>
        p->s.size -= nunits;
 714:	29 f1                	sub    %esi,%ecx
 716:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 719:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 71c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 71f:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 724:	8d 42 08             	lea    0x8(%edx),%eax
}
 727:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72a:	5b                   	pop    %ebx
 72b:	5e                   	pop    %esi
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret    
 72f:	90                   	nop
 730:	bb 00 10 00 00       	mov    $0x1000,%ebx
 735:	e9 76 ff ff ff       	jmp    6b0 <malloc+0x38>
 73a:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 73c:	c7 05 20 0b 00 00 24 	movl   $0xb24,0xb20
 743:	0b 00 00 
 746:	c7 05 24 0b 00 00 24 	movl   $0xb24,0xb24
 74d:	0b 00 00 
    base.s.size = 0;
 750:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 757:	00 00 00 
 75a:	bf 24 0b 00 00       	mov    $0xb24,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75f:	89 f8                	mov    %edi,%eax
 761:	e9 3c ff ff ff       	jmp    6a2 <malloc+0x2a>
 766:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 768:	8b 0a                	mov    (%edx),%ecx
 76a:	89 08                	mov    %ecx,(%eax)
 76c:	eb b1                	jmp    71f <malloc+0xa7>

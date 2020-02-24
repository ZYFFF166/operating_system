
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
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
  1d:	7e 56                	jle    75 <main+0x75>
  1f:	83 c3 04             	add    $0x4,%ebx
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	pushl  (%ebx)
  2f:	e8 96 03 00 00       	call   3ca <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 24                	js     61 <main+0x61>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	ff 33                	pushl  (%ebx)
  42:	50                   	push   %eax
  43:	e8 40 00 00 00       	call   88 <wc>
    close(fd);
  48:	89 3c 24             	mov    %edi,(%esp)
  4b:	e8 62 03 00 00       	call   3b2 <close>
  for(i = 1; i < argc; i++){
  50:	46                   	inc    %esi
  51:	83 c3 04             	add    $0x4,%ebx
  54:	83 c4 10             	add    $0x10,%esp
  57:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  5a:	75 cc                	jne    28 <main+0x28>
  }
  exit();
  5c:	e8 29 03 00 00       	call   38a <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  61:	50                   	push   %eax
  62:	ff 33                	pushl  (%ebx)
  64:	68 eb 07 00 00       	push   $0x7eb
  69:	6a 01                	push   $0x1
  6b:	e8 4c 04 00 00       	call   4bc <printf>
      exit();
  70:	e8 15 03 00 00       	call   38a <exit>
    wc(0, "");
  75:	52                   	push   %edx
  76:	52                   	push   %edx
  77:	68 0e 08 00 00       	push   $0x80e
  7c:	6a 00                	push   $0x0
  7e:	e8 05 00 00 00       	call   88 <wc>
    exit();
  83:	e8 02 03 00 00       	call   38a <exit>

00000088 <wc>:
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	57                   	push   %edi
  8c:	56                   	push   %esi
  8d:	53                   	push   %ebx
  8e:	83 ec 1c             	sub    $0x1c,%esp
  inword = 0;
  91:	31 f6                	xor    %esi,%esi
  l = w = c = 0;
  93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  a8:	52                   	push   %edx
  a9:	68 00 02 00 00       	push   $0x200
  ae:	68 a0 0b 00 00       	push   $0xba0
  b3:	ff 75 08             	pushl  0x8(%ebp)
  b6:	e8 e7 02 00 00       	call   3a2 <read>
  bb:	89 c3                	mov    %eax,%ebx
  bd:	83 c4 10             	add    $0x10,%esp
  c0:	85 c0                	test   %eax,%eax
  c2:	7e 48                	jle    10c <wc+0x84>
    for(i=0; i<n; i++){
  c4:	31 ff                	xor    %edi,%edi
  c6:	eb 07                	jmp    cf <wc+0x47>
        inword = 0;
  c8:	31 f6                	xor    %esi,%esi
    for(i=0; i<n; i++){
  ca:	47                   	inc    %edi
  cb:	39 fb                	cmp    %edi,%ebx
  cd:	74 35                	je     104 <wc+0x7c>
      if(buf[i] == '\n')
  cf:	0f be 87 a0 0b 00 00 	movsbl 0xba0(%edi),%eax
  d6:	3c 0a                	cmp    $0xa,%al
  d8:	75 03                	jne    dd <wc+0x55>
        l++;
  da:	ff 45 e4             	incl   -0x1c(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	50                   	push   %eax
  e1:	68 c8 07 00 00       	push   $0x7c8
  e6:	e8 f1 00 00 00       	call   1dc <strchr>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	85 c0                	test   %eax,%eax
  f0:	75 d6                	jne    c8 <wc+0x40>
      else if(!inword){
  f2:	85 f6                	test   %esi,%esi
  f4:	75 d4                	jne    ca <wc+0x42>
        w++;
  f6:	ff 45 e0             	incl   -0x20(%ebp)
        inword = 1;
  f9:	be 01 00 00 00       	mov    $0x1,%esi
    for(i=0; i<n; i++){
  fe:	47                   	inc    %edi
  ff:	39 fb                	cmp    %edi,%ebx
 101:	75 cc                	jne    cf <wc+0x47>
 103:	90                   	nop
 104:	01 5d dc             	add    %ebx,-0x24(%ebp)
 107:	eb 9f                	jmp    a8 <wc+0x20>
 109:	8d 76 00             	lea    0x0(%esi),%esi
  if(n < 0){
 10c:	75 26                	jne    134 <wc+0xac>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	ff 75 0c             	pushl  0xc(%ebp)
 114:	ff 75 dc             	pushl  -0x24(%ebp)
 117:	ff 75 e0             	pushl  -0x20(%ebp)
 11a:	ff 75 e4             	pushl  -0x1c(%ebp)
 11d:	68 de 07 00 00       	push   $0x7de
 122:	6a 01                	push   $0x1
 124:	e8 93 03 00 00       	call   4bc <printf>
}
 129:	83 c4 20             	add    $0x20,%esp
 12c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 12f:	5b                   	pop    %ebx
 130:	5e                   	pop    %esi
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
    printf(1, "wc: read error\n");
 134:	50                   	push   %eax
 135:	50                   	push   %eax
 136:	68 ce 07 00 00       	push   $0x7ce
 13b:	6a 01                	push   $0x1
 13d:	e8 7a 03 00 00       	call   4bc <printf>
    exit();
 142:	e8 43 02 00 00       	call   38a <exit>
 147:	90                   	nop

00000148 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	53                   	push   %ebx
 14c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 152:	31 c0                	xor    %eax,%eax
 154:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 157:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 15a:	40                   	inc    %eax
 15b:	84 d2                	test   %dl,%dl
 15d:	75 f5                	jne    154 <strcpy+0xc>
    ;
  return os;
}
 15f:	89 c8                	mov    %ecx,%eax
 161:	5b                   	pop    %ebx
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	53                   	push   %ebx
 168:	8b 5d 08             	mov    0x8(%ebp),%ebx
 16b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16e:	0f b6 03             	movzbl (%ebx),%eax
 171:	0f b6 0a             	movzbl (%edx),%ecx
 174:	84 c0                	test   %al,%al
 176:	75 10                	jne    188 <strcmp+0x24>
 178:	eb 1a                	jmp    194 <strcmp+0x30>
 17a:	66 90                	xchg   %ax,%ax
    p++, q++;
 17c:	43                   	inc    %ebx
 17d:	42                   	inc    %edx
  while(*p && *p == *q)
 17e:	0f b6 03             	movzbl (%ebx),%eax
 181:	0f b6 0a             	movzbl (%edx),%ecx
 184:	84 c0                	test   %al,%al
 186:	74 0c                	je     194 <strcmp+0x30>
 188:	38 c8                	cmp    %cl,%al
 18a:	74 f0                	je     17c <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 18c:	29 c8                	sub    %ecx,%eax
}
 18e:	5b                   	pop    %ebx
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi
 194:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 196:	29 c8                	sub    %ecx,%eax
}
 198:	5b                   	pop    %ebx
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
 19b:	90                   	nop

0000019c <strlen>:

uint
strlen(const char *s)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1a2:	80 3a 00             	cmpb   $0x0,(%edx)
 1a5:	74 15                	je     1bc <strlen+0x20>
 1a7:	31 c0                	xor    %eax,%eax
 1a9:	8d 76 00             	lea    0x0(%esi),%esi
 1ac:	40                   	inc    %eax
 1ad:	89 c1                	mov    %eax,%ecx
 1af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1b3:	75 f7                	jne    1ac <strlen+0x10>
    ;
  return n;
}
 1b5:	89 c8                	mov    %ecx,%eax
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1bc:	31 c9                	xor    %ecx,%ecx
}
 1be:	89 c8                	mov    %ecx,%eax
 1c0:	5d                   	pop    %ebp
 1c1:	c3                   	ret    
 1c2:	66 90                	xchg   %ax,%ax

000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c8:	8b 7d 08             	mov    0x8(%ebp),%edi
 1cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	5f                   	pop    %edi
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    
 1da:	66 90                	xchg   %ax,%ax

000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1e5:	8a 10                	mov    (%eax),%dl
 1e7:	84 d2                	test   %dl,%dl
 1e9:	75 0c                	jne    1f7 <strchr+0x1b>
 1eb:	eb 13                	jmp    200 <strchr+0x24>
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	40                   	inc    %eax
 1f1:	8a 10                	mov    (%eax),%dl
 1f3:	84 d2                	test   %dl,%dl
 1f5:	74 09                	je     200 <strchr+0x24>
    if(*s == c)
 1f7:	38 d1                	cmp    %dl,%cl
 1f9:	75 f5                	jne    1f0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    

00000204 <gets>:

char*
gets(char *buf, int max)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	56                   	push   %esi
 209:	53                   	push   %ebx
 20a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	8b 75 08             	mov    0x8(%ebp),%esi
 210:	bb 01 00 00 00       	mov    $0x1,%ebx
 215:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 217:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 21a:	eb 20                	jmp    23c <gets+0x38>
    cc = read(0, &c, 1);
 21c:	50                   	push   %eax
 21d:	6a 01                	push   $0x1
 21f:	57                   	push   %edi
 220:	6a 00                	push   $0x0
 222:	e8 7b 01 00 00       	call   3a2 <read>
    if(cc < 1)
 227:	83 c4 10             	add    $0x10,%esp
 22a:	85 c0                	test   %eax,%eax
 22c:	7e 16                	jle    244 <gets+0x40>
      break;
    buf[i++] = c;
 22e:	8a 45 e7             	mov    -0x19(%ebp),%al
 231:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 233:	46                   	inc    %esi
 234:	3c 0a                	cmp    $0xa,%al
 236:	74 0c                	je     244 <gets+0x40>
 238:	3c 0d                	cmp    $0xd,%al
 23a:	74 08                	je     244 <gets+0x40>
  for(i=0; i+1 < max; ){
 23c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 23f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 242:	7f d8                	jg     21c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 244:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24d:	5b                   	pop    %ebx
 24e:	5e                   	pop    %esi
 24f:	5f                   	pop    %edi
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    
 252:	66 90                	xchg   %ax,%ax

00000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	56                   	push   %esi
 258:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	6a 00                	push   $0x0
 25e:	ff 75 08             	pushl  0x8(%ebp)
 261:	e8 64 01 00 00       	call   3ca <open>
  if(fd < 0)
 266:	83 c4 10             	add    $0x10,%esp
 269:	85 c0                	test   %eax,%eax
 26b:	78 27                	js     294 <stat+0x40>
 26d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	ff 75 0c             	pushl  0xc(%ebp)
 275:	50                   	push   %eax
 276:	e8 67 01 00 00       	call   3e2 <fstat>
 27b:	89 c6                	mov    %eax,%esi
  close(fd);
 27d:	89 1c 24             	mov    %ebx,(%esp)
 280:	e8 2d 01 00 00       	call   3b2 <close>
  return r;
 285:	83 c4 10             	add    $0x10,%esp
}
 288:	89 f0                	mov    %esi,%eax
 28a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28d:	5b                   	pop    %ebx
 28e:	5e                   	pop    %esi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 294:	be ff ff ff ff       	mov    $0xffffffff,%esi
 299:	eb ed                	jmp    288 <stat+0x34>
 29b:	90                   	nop

0000029c <atoi>:

int
atoi(const char *s)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	53                   	push   %ebx
 2a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a3:	0f be 01             	movsbl (%ecx),%eax
 2a6:	8d 50 d0             	lea    -0x30(%eax),%edx
 2a9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2ac:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2b1:	77 16                	ja     2c9 <atoi+0x2d>
 2b3:	90                   	nop
    n = n*10 + *s++ - '0';
 2b4:	41                   	inc    %ecx
 2b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2b8:	01 d2                	add    %edx,%edx
 2ba:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2be:	0f be 01             	movsbl (%ecx),%eax
 2c1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2c4:	80 fb 09             	cmp    $0x9,%bl
 2c7:	76 eb                	jbe    2b4 <atoi+0x18>
  return n;
}
 2c9:	89 d0                	mov    %edx,%eax
 2cb:	5b                   	pop    %ebx
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    
 2ce:	66 90                	xchg   %ax,%ax

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8b 75 0c             	mov    0xc(%ebp),%esi
 2db:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 d2                	test   %edx,%edx
 2e0:	7e 0b                	jle    2ed <memmove+0x1d>
 2e2:	01 c2                	add    %eax,%edx
  dst = vdst;
 2e4:	89 c7                	mov    %eax,%edi
 2e6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e9:	39 fa                	cmp    %edi,%edx
 2eb:	75 fb                	jne    2e8 <memmove+0x18>
  return vdst;
}
 2ed:	5e                   	pop    %esi
 2ee:	5f                   	pop    %edi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d 76 00             	lea    0x0(%esi),%esi

000002f4 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    
 302:	66 90                	xchg   %ax,%ax

00000304 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 30a:	b9 01 00 00 00       	mov    $0x1,%ecx
 30f:	90                   	nop
 310:	89 c8                	mov    %ecx,%eax
 312:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 315:	85 c0                	test   %eax,%eax
 317:	75 f7                	jne    310 <lock_acquire+0xc>
}
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    
 31b:	90                   	nop

0000031c <lock_release>:

void lock_release(lock_t *lock) {
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	8b 55 08             	mov    0x8(%ebp),%edx
 322:	31 c0                	xor    %eax,%eax
 324:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    
 329:	8d 76 00             	lea    0x0(%esi),%esi

0000032c <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 332:	68 00 20 00 00       	push   $0x2000
 337:	e8 94 03 00 00       	call   6d0 <malloc>

  if((uint)stack % PGSIZE)
 33c:	83 c4 10             	add    $0x10,%esp
 33f:	89 c2                	mov    %eax,%edx
 341:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 347:	74 07                	je     350 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 349:	29 d0                	sub    %edx,%eax
 34b:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 350:	ff 75 0c             	pushl  0xc(%ebp)
 353:	6a 08                	push   $0x8
 355:	50                   	push   %eax
 356:	ff 75 08             	pushl  0x8(%ebp)
 359:	e8 cc 00 00 00       	call   42a <clone>

  if (tid < 0) {
 35e:	83 c4 10             	add    $0x10,%esp
 361:	85 c0                	test   %eax,%eax
 363:	78 07                	js     36c <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 365:	31 c0                	xor    %eax,%eax
 367:	c9                   	leave  
 368:	c3                   	ret    
 369:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 36c:	83 ec 08             	sub    $0x8,%esp
 36f:	68 ff 07 00 00       	push   $0x7ff
 374:	6a 01                	push   $0x1
 376:	e8 41 01 00 00       	call   4bc <printf>
      return 0;
 37b:	83 c4 10             	add    $0x10,%esp
}
 37e:	31 c0                	xor    %eax,%eax
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 382:	b8 01 00 00 00       	mov    $0x1,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exit>:
SYSCALL(exit)
 38a:	b8 02 00 00 00       	mov    $0x2,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <wait>:
SYSCALL(wait)
 392:	b8 03 00 00 00       	mov    $0x3,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <pipe>:
SYSCALL(pipe)
 39a:	b8 04 00 00 00       	mov    $0x4,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <read>:
SYSCALL(read)
 3a2:	b8 05 00 00 00       	mov    $0x5,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <write>:
SYSCALL(write)
 3aa:	b8 10 00 00 00       	mov    $0x10,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <close>:
SYSCALL(close)
 3b2:	b8 15 00 00 00       	mov    $0x15,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <kill>:
SYSCALL(kill)
 3ba:	b8 06 00 00 00       	mov    $0x6,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <exec>:
SYSCALL(exec)
 3c2:	b8 07 00 00 00       	mov    $0x7,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <open>:
SYSCALL(open)
 3ca:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <mknod>:
SYSCALL(mknod)
 3d2:	b8 11 00 00 00       	mov    $0x11,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <unlink>:
SYSCALL(unlink)
 3da:	b8 12 00 00 00       	mov    $0x12,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <fstat>:
SYSCALL(fstat)
 3e2:	b8 08 00 00 00       	mov    $0x8,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <link>:
SYSCALL(link)
 3ea:	b8 13 00 00 00       	mov    $0x13,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <mkdir>:
SYSCALL(mkdir)
 3f2:	b8 14 00 00 00       	mov    $0x14,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <chdir>:
SYSCALL(chdir)
 3fa:	b8 09 00 00 00       	mov    $0x9,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <dup>:
SYSCALL(dup)
 402:	b8 0a 00 00 00       	mov    $0xa,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <getpid>:
SYSCALL(getpid)
 40a:	b8 0b 00 00 00       	mov    $0xb,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sbrk>:
SYSCALL(sbrk)
 412:	b8 0c 00 00 00       	mov    $0xc,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <sleep>:
SYSCALL(sleep)
 41a:	b8 0d 00 00 00       	mov    $0xd,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <uptime>:
SYSCALL(uptime)
 422:	b8 0e 00 00 00       	mov    $0xe,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <clone>:
 42a:	b8 16 00 00 00       	mov    $0x16,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    
 432:	66 90                	xchg   %ax,%ax

00000434 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	56                   	push   %esi
 439:	53                   	push   %ebx
 43a:	83 ec 3c             	sub    $0x3c,%esp
 43d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 440:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 443:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 445:	8b 5d 08             	mov    0x8(%ebp),%ebx
 448:	85 db                	test   %ebx,%ebx
 44a:	74 04                	je     450 <printint+0x1c>
 44c:	85 d2                	test   %edx,%edx
 44e:	78 68                	js     4b8 <printint+0x84>
  neg = 0;
 450:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 457:	31 ff                	xor    %edi,%edi
 459:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 45c:	89 c8                	mov    %ecx,%eax
 45e:	31 d2                	xor    %edx,%edx
 460:	f7 75 c4             	divl   -0x3c(%ebp)
 463:	89 fb                	mov    %edi,%ebx
 465:	8d 7f 01             	lea    0x1(%edi),%edi
 468:	8a 92 18 08 00 00    	mov    0x818(%edx),%dl
 46e:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 472:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 475:	89 c1                	mov    %eax,%ecx
 477:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 47a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 47d:	76 dd                	jbe    45c <printint+0x28>
  if(neg)
 47f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 482:	85 c9                	test   %ecx,%ecx
 484:	74 09                	je     48f <printint+0x5b>
    buf[i++] = '-';
 486:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 48b:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 48d:	b2 2d                	mov    $0x2d,%dl
 48f:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 493:	8b 7d bc             	mov    -0x44(%ebp),%edi
 496:	eb 03                	jmp    49b <printint+0x67>
 498:	8a 13                	mov    (%ebx),%dl
 49a:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 49b:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 49e:	50                   	push   %eax
 49f:	6a 01                	push   $0x1
 4a1:	56                   	push   %esi
 4a2:	57                   	push   %edi
 4a3:	e8 02 ff ff ff       	call   3aa <write>
  while(--i >= 0)
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	39 de                	cmp    %ebx,%esi
 4ad:	75 e9                	jne    498 <printint+0x64>
}
 4af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b2:	5b                   	pop    %ebx
 4b3:	5e                   	pop    %esi
 4b4:	5f                   	pop    %edi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    
 4b7:	90                   	nop
    x = -xx;
 4b8:	f7 d9                	neg    %ecx
 4ba:	eb 9b                	jmp    457 <printint+0x23>

000004bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	53                   	push   %ebx
 4c2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c5:	8b 75 0c             	mov    0xc(%ebp),%esi
 4c8:	8a 1e                	mov    (%esi),%bl
 4ca:	84 db                	test   %bl,%bl
 4cc:	0f 84 a3 00 00 00    	je     575 <printf+0xb9>
 4d2:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 4d3:	8d 45 10             	lea    0x10(%ebp),%eax
 4d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 4d9:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 4db:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4de:	eb 29                	jmp    509 <printf+0x4d>
 4e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4e3:	83 f8 25             	cmp    $0x25,%eax
 4e6:	0f 84 94 00 00 00    	je     580 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 4ec:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4ef:	50                   	push   %eax
 4f0:	6a 01                	push   $0x1
 4f2:	57                   	push   %edi
 4f3:	ff 75 08             	pushl  0x8(%ebp)
 4f6:	e8 af fe ff ff       	call   3aa <write>
        putc(fd, c);
 4fb:	83 c4 10             	add    $0x10,%esp
 4fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 501:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 502:	8a 5e ff             	mov    -0x1(%esi),%bl
 505:	84 db                	test   %bl,%bl
 507:	74 6c                	je     575 <printf+0xb9>
    c = fmt[i] & 0xff;
 509:	0f be cb             	movsbl %bl,%ecx
 50c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 50f:	85 d2                	test   %edx,%edx
 511:	74 cd                	je     4e0 <printf+0x24>
      }
    } else if(state == '%'){
 513:	83 fa 25             	cmp    $0x25,%edx
 516:	75 e9                	jne    501 <printf+0x45>
      if(c == 'd'){
 518:	83 f8 64             	cmp    $0x64,%eax
 51b:	0f 84 97 00 00 00    	je     5b8 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 521:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 527:	83 f9 70             	cmp    $0x70,%ecx
 52a:	74 60                	je     58c <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 52c:	83 f8 73             	cmp    $0x73,%eax
 52f:	0f 84 8f 00 00 00    	je     5c4 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 535:	83 f8 63             	cmp    $0x63,%eax
 538:	0f 84 d6 00 00 00    	je     614 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 53e:	83 f8 25             	cmp    $0x25,%eax
 541:	0f 84 c1 00 00 00    	je     608 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 547:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 54b:	50                   	push   %eax
 54c:	6a 01                	push   $0x1
 54e:	57                   	push   %edi
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 53 fe ff ff       	call   3aa <write>
        putc(fd, c);
 557:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 55a:	83 c4 0c             	add    $0xc,%esp
 55d:	6a 01                	push   $0x1
 55f:	57                   	push   %edi
 560:	ff 75 08             	pushl  0x8(%ebp)
 563:	e8 42 fe ff ff       	call   3aa <write>
        putc(fd, c);
 568:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 56b:	31 d2                	xor    %edx,%edx
 56d:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 56e:	8a 5e ff             	mov    -0x1(%esi),%bl
 571:	84 db                	test   %bl,%bl
 573:	75 94                	jne    509 <printf+0x4d>
    }
  }
}
 575:	8d 65 f4             	lea    -0xc(%ebp),%esp
 578:	5b                   	pop    %ebx
 579:	5e                   	pop    %esi
 57a:	5f                   	pop    %edi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 580:	ba 25 00 00 00       	mov    $0x25,%edx
 585:	e9 77 ff ff ff       	jmp    501 <printf+0x45>
 58a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 58c:	83 ec 0c             	sub    $0xc,%esp
 58f:	6a 00                	push   $0x0
 591:	b9 10 00 00 00       	mov    $0x10,%ecx
 596:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 599:	8b 13                	mov    (%ebx),%edx
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	e8 91 fe ff ff       	call   434 <printint>
        ap++;
 5a3:	89 d8                	mov    %ebx,%eax
 5a5:	83 c0 04             	add    $0x4,%eax
 5a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5ab:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ae:	31 d2                	xor    %edx,%edx
        ap++;
 5b0:	e9 4c ff ff ff       	jmp    501 <printf+0x45>
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5b8:	83 ec 0c             	sub    $0xc,%esp
 5bb:	6a 01                	push   $0x1
 5bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c2:	eb d2                	jmp    596 <printf+0xda>
        s = (char*)*ap;
 5c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5c7:	8b 18                	mov    (%eax),%ebx
        ap++;
 5c9:	83 c0 04             	add    $0x4,%eax
 5cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5cf:	85 db                	test   %ebx,%ebx
 5d1:	74 65                	je     638 <printf+0x17c>
        while(*s != 0){
 5d3:	8a 03                	mov    (%ebx),%al
 5d5:	84 c0                	test   %al,%al
 5d7:	74 70                	je     649 <printf+0x18d>
 5d9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5dc:	89 de                	mov    %ebx,%esi
 5de:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e1:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 5e4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e7:	50                   	push   %eax
 5e8:	6a 01                	push   $0x1
 5ea:	57                   	push   %edi
 5eb:	53                   	push   %ebx
 5ec:	e8 b9 fd ff ff       	call   3aa <write>
          s++;
 5f1:	46                   	inc    %esi
        while(*s != 0){
 5f2:	8a 06                	mov    (%esi),%al
 5f4:	83 c4 10             	add    $0x10,%esp
 5f7:	84 c0                	test   %al,%al
 5f9:	75 e9                	jne    5e4 <printf+0x128>
 5fb:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5fe:	31 d2                	xor    %edx,%edx
 600:	e9 fc fe ff ff       	jmp    501 <printf+0x45>
 605:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 608:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 60b:	52                   	push   %edx
 60c:	e9 4c ff ff ff       	jmp    55d <printf+0xa1>
 611:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 614:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 617:	8b 03                	mov    (%ebx),%eax
 619:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 61c:	51                   	push   %ecx
 61d:	6a 01                	push   $0x1
 61f:	57                   	push   %edi
 620:	ff 75 08             	pushl  0x8(%ebp)
 623:	e8 82 fd ff ff       	call   3aa <write>
        ap++;
 628:	83 c3 04             	add    $0x4,%ebx
 62b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 62e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 631:	31 d2                	xor    %edx,%edx
 633:	e9 c9 fe ff ff       	jmp    501 <printf+0x45>
          s = "(null)";
 638:	bb 0f 08 00 00       	mov    $0x80f,%ebx
        while(*s != 0){
 63d:	b0 28                	mov    $0x28,%al
 63f:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 642:	89 de                	mov    %ebx,%esi
 644:	8b 5d 08             	mov    0x8(%ebp),%ebx
 647:	eb 9b                	jmp    5e4 <printf+0x128>
      state = 0;
 649:	31 d2                	xor    %edx,%edx
 64b:	e9 b1 fe ff ff       	jmp    501 <printf+0x45>

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 659:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	a1 80 0b 00 00       	mov    0xb80,%eax
 661:	8b 10                	mov    (%eax),%edx
 663:	39 c8                	cmp    %ecx,%eax
 665:	73 11                	jae    678 <free+0x28>
 667:	90                   	nop
 668:	39 d1                	cmp    %edx,%ecx
 66a:	72 14                	jb     680 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	39 d0                	cmp    %edx,%eax
 66e:	73 10                	jae    680 <free+0x30>
{
 670:	89 d0                	mov    %edx,%eax
 672:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	39 c8                	cmp    %ecx,%eax
 676:	72 f0                	jb     668 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	39 d0                	cmp    %edx,%eax
 67a:	72 f4                	jb     670 <free+0x20>
 67c:	39 d1                	cmp    %edx,%ecx
 67e:	73 f0                	jae    670 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 686:	39 fa                	cmp    %edi,%edx
 688:	74 1a                	je     6a4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 68a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 693:	39 f1                	cmp    %esi,%ecx
 695:	74 24                	je     6bb <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 697:	89 08                	mov    %ecx,(%eax)
  freep = p;
 699:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 69e:	5b                   	pop    %ebx
 69f:	5e                   	pop    %esi
 6a0:	5f                   	pop    %edi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
 6a3:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6a4:	03 72 04             	add    0x4(%edx),%esi
 6a7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 12                	mov    (%edx),%edx
 6ae:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6b1:	8b 50 04             	mov    0x4(%eax),%edx
 6b4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b7:	39 f1                	cmp    %esi,%ecx
 6b9:	75 dc                	jne    697 <free+0x47>
    p->s.size += bp->s.size;
 6bb:	03 53 fc             	add    -0x4(%ebx),%edx
 6be:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c6:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 6cb:	5b                   	pop    %ebx
 6cc:	5e                   	pop    %esi
 6cd:	5f                   	pop    %edi
 6ce:	5d                   	pop    %ebp
 6cf:	c3                   	ret    

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	8d 70 07             	lea    0x7(%eax),%esi
 6df:	c1 ee 03             	shr    $0x3,%esi
 6e2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6e3:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
 6e9:	85 ff                	test   %edi,%edi
 6eb:	0f 84 a3 00 00 00    	je     794 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6f3:	8b 48 04             	mov    0x4(%eax),%ecx
 6f6:	39 f1                	cmp    %esi,%ecx
 6f8:	73 67                	jae    761 <malloc+0x91>
 6fa:	89 f3                	mov    %esi,%ebx
 6fc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 702:	0f 82 80 00 00 00    	jb     788 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 708:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 70f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 712:	eb 11                	jmp    725 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 714:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 716:	8b 4a 04             	mov    0x4(%edx),%ecx
 719:	39 f1                	cmp    %esi,%ecx
 71b:	73 4b                	jae    768 <malloc+0x98>
 71d:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
 723:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 725:	39 c7                	cmp    %eax,%edi
 727:	75 eb                	jne    714 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 729:	83 ec 0c             	sub    $0xc,%esp
 72c:	ff 75 e4             	pushl  -0x1c(%ebp)
 72f:	e8 de fc ff ff       	call   412 <sbrk>
  if(p == (char*)-1)
 734:	83 c4 10             	add    $0x10,%esp
 737:	83 f8 ff             	cmp    $0xffffffff,%eax
 73a:	74 1b                	je     757 <malloc+0x87>
  hp->s.size = nu;
 73c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	83 c0 08             	add    $0x8,%eax
 745:	50                   	push   %eax
 746:	e8 05 ff ff ff       	call   650 <free>
  return freep;
 74b:	a1 80 0b 00 00       	mov    0xb80,%eax
      if((p = morecore(nunits)) == 0)
 750:	83 c4 10             	add    $0x10,%esp
 753:	85 c0                	test   %eax,%eax
 755:	75 bd                	jne    714 <malloc+0x44>
        return 0;
 757:	31 c0                	xor    %eax,%eax
  }
}
 759:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75c:	5b                   	pop    %ebx
 75d:	5e                   	pop    %esi
 75e:	5f                   	pop    %edi
 75f:	5d                   	pop    %ebp
 760:	c3                   	ret    
    if(p->s.size >= nunits){
 761:	89 c2                	mov    %eax,%edx
 763:	89 f8                	mov    %edi,%eax
 765:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 768:	39 ce                	cmp    %ecx,%esi
 76a:	74 54                	je     7c0 <malloc+0xf0>
        p->s.size -= nunits;
 76c:	29 f1                	sub    %esi,%ecx
 76e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 771:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 774:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 777:	a3 80 0b 00 00       	mov    %eax,0xb80
      return (void*)(p + 1);
 77c:	8d 42 08             	lea    0x8(%edx),%eax
}
 77f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 782:	5b                   	pop    %ebx
 783:	5e                   	pop    %esi
 784:	5f                   	pop    %edi
 785:	5d                   	pop    %ebp
 786:	c3                   	ret    
 787:	90                   	nop
 788:	bb 00 10 00 00       	mov    $0x1000,%ebx
 78d:	e9 76 ff ff ff       	jmp    708 <malloc+0x38>
 792:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 794:	c7 05 80 0b 00 00 84 	movl   $0xb84,0xb80
 79b:	0b 00 00 
 79e:	c7 05 84 0b 00 00 84 	movl   $0xb84,0xb84
 7a5:	0b 00 00 
    base.s.size = 0;
 7a8:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 7af:	00 00 00 
 7b2:	bf 84 0b 00 00       	mov    $0xb84,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	89 f8                	mov    %edi,%eax
 7b9:	e9 3c ff ff ff       	jmp    6fa <malloc+0x2a>
 7be:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 0a                	mov    (%edx),%ecx
 7c2:	89 08                	mov    %ecx,(%eax)
 7c4:	eb b1                	jmp    777 <malloc+0xa7>


_grep:     file format elf32-i386


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
  16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 65                	jle    84 <main+0x84>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  1f:	8b 7b 04             	mov    0x4(%ebx),%edi

  if(argc <= 2){
  22:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  26:	74 6f                	je     97 <main+0x97>
  28:	83 c3 08             	add    $0x8,%ebx
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  30:	eb 26                	jmp    58 <main+0x58>
  32:	66 90                	xchg   %ax,%ax
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  34:	83 ec 08             	sub    $0x8,%esp
  37:	50                   	push   %eax
  38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  3b:	57                   	push   %edi
  3c:	e8 83 01 00 00       	call   1c4 <grep>
    close(fd);
  41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 c6 04 00 00       	call   512 <close>
  for(i = 2; i < argc; i++){
  4c:	46                   	inc    %esi
  4d:	83 c3 04             	add    $0x4,%ebx
  50:	83 c4 10             	add    $0x10,%esp
  53:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  56:	7e 27                	jle    7f <main+0x7f>
    if((fd = open(argv[i], 0)) < 0){
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 00                	push   $0x0
  5d:	ff 33                	pushl  (%ebx)
  5f:	e8 c6 04 00 00       	call   52a <open>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	79 c9                	jns    34 <main+0x34>
      printf(1, "grep: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	pushl  (%ebx)
  6e:	68 48 09 00 00       	push   $0x948
  73:	6a 01                	push   $0x1
  75:	e8 a2 05 00 00       	call   61c <printf>
      exit();
  7a:	e8 6b 04 00 00       	call   4ea <exit>
  }
  exit();
  7f:	e8 66 04 00 00       	call   4ea <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  84:	51                   	push   %ecx
  85:	51                   	push   %ecx
  86:	68 28 09 00 00       	push   $0x928
  8b:	6a 02                	push   $0x2
  8d:	e8 8a 05 00 00       	call   61c <printf>
    exit();
  92:	e8 53 04 00 00       	call   4ea <exit>
    grep(pattern, 0);
  97:	52                   	push   %edx
  98:	52                   	push   %edx
  99:	6a 00                	push   $0x0
  9b:	57                   	push   %edi
  9c:	e8 23 01 00 00       	call   1c4 <grep>
    exit();
  a1:	e8 44 04 00 00       	call   4ea <exit>
  a6:	66 90                	xchg   %ax,%ax

000000a8 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	56                   	push   %esi
  ad:	53                   	push   %ebx
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  b7:	8b 7d 10             	mov    0x10(%ebp),%edi
  ba:	66 90                	xchg   %ax,%ax
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  bc:	83 ec 08             	sub    $0x8,%esp
  bf:	57                   	push   %edi
  c0:	56                   	push   %esi
  c1:	e8 32 00 00 00       	call   f8 <matchhere>
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	85 c0                	test   %eax,%eax
  cb:	75 1b                	jne    e8 <matchstar+0x40>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  cd:	0f be 17             	movsbl (%edi),%edx
  d0:	84 d2                	test   %dl,%dl
  d2:	74 0a                	je     de <matchstar+0x36>
  d4:	47                   	inc    %edi
  d5:	39 da                	cmp    %ebx,%edx
  d7:	74 e3                	je     bc <matchstar+0x14>
  d9:	83 fb 2e             	cmp    $0x2e,%ebx
  dc:	74 de                	je     bc <matchstar+0x14>
  return 0;
}
  de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  e1:	5b                   	pop    %ebx
  e2:	5e                   	pop    %esi
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    
  e6:	66 90                	xchg   %ax,%ax
      return 1;
  e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  f0:	5b                   	pop    %ebx
  f1:	5e                   	pop    %esi
  f2:	5f                   	pop    %edi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 76 00             	lea    0x0(%esi),%esi

000000f8 <matchhere>:
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	56                   	push   %esi
  fc:	53                   	push   %ebx
  fd:	8b 55 08             	mov    0x8(%ebp),%edx
 100:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '\0')
 103:	0f be 0a             	movsbl (%edx),%ecx
 106:	84 c9                	test   %cl,%cl
 108:	75 18                	jne    122 <matchhere+0x2a>
 10a:	eb 44                	jmp    150 <matchhere+0x58>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 10c:	84 db                	test   %bl,%bl
 10e:	74 34                	je     144 <matchhere+0x4c>
 110:	80 f9 2e             	cmp    $0x2e,%cl
 113:	74 04                	je     119 <matchhere+0x21>
 115:	38 d9                	cmp    %bl,%cl
 117:	75 2b                	jne    144 <matchhere+0x4c>
    return matchhere(re+1, text+1);
 119:	46                   	inc    %esi
 11a:	42                   	inc    %edx
  if(re[0] == '\0')
 11b:	84 c0                	test   %al,%al
 11d:	74 31                	je     150 <matchhere+0x58>
{
 11f:	0f be c8             	movsbl %al,%ecx
  if(re[1] == '*')
 122:	8a 42 01             	mov    0x1(%edx),%al
 125:	3c 2a                	cmp    $0x2a,%al
 127:	74 33                	je     15c <matchhere+0x64>
  if(re[0] == '$' && re[1] == '\0')
 129:	8a 1e                	mov    (%esi),%bl
 12b:	80 f9 24             	cmp    $0x24,%cl
 12e:	75 dc                	jne    10c <matchhere+0x14>
 130:	84 c0                	test   %al,%al
 132:	74 3e                	je     172 <matchhere+0x7a>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 134:	84 db                	test   %bl,%bl
 136:	74 0c                	je     144 <matchhere+0x4c>
 138:	80 fb 24             	cmp    $0x24,%bl
 13b:	75 07                	jne    144 <matchhere+0x4c>
    return matchhere(re+1, text+1);
 13d:	46                   	inc    %esi
 13e:	42                   	inc    %edx
  if(re[0] == '\0')
 13f:	eb de                	jmp    11f <matchhere+0x27>
 141:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 144:	31 c0                	xor    %eax,%eax
}
 146:	8d 65 f8             	lea    -0x8(%ebp),%esp
 149:	5b                   	pop    %ebx
 14a:	5e                   	pop    %esi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
 14d:	8d 76 00             	lea    0x0(%esi),%esi
    return 1;
 150:	b8 01 00 00 00       	mov    $0x1,%eax
}
 155:	8d 65 f8             	lea    -0x8(%ebp),%esp
 158:	5b                   	pop    %ebx
 159:	5e                   	pop    %esi
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    
    return matchstar(re[0], re+2, text);
 15c:	50                   	push   %eax
 15d:	56                   	push   %esi
 15e:	83 c2 02             	add    $0x2,%edx
 161:	52                   	push   %edx
 162:	51                   	push   %ecx
 163:	e8 40 ff ff ff       	call   a8 <matchstar>
 168:	83 c4 10             	add    $0x10,%esp
}
 16b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 16e:	5b                   	pop    %ebx
 16f:	5e                   	pop    %esi
 170:	5d                   	pop    %ebp
 171:	c3                   	ret    
    return *text == '\0';
 172:	31 c0                	xor    %eax,%eax
 174:	84 db                	test   %bl,%bl
 176:	0f 94 c0             	sete   %al
 179:	eb cb                	jmp    146 <matchhere+0x4e>
 17b:	90                   	nop

0000017c <match>:
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
 181:	8b 5d 08             	mov    0x8(%ebp),%ebx
 184:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 187:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 18a:	75 0b                	jne    197 <match+0x1b>
 18c:	eb 26                	jmp    1b4 <match+0x38>
 18e:	66 90                	xchg   %ax,%ax
  }while(*text++ != '\0');
 190:	46                   	inc    %esi
 191:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 195:	74 16                	je     1ad <match+0x31>
    if(matchhere(re, text))
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	56                   	push   %esi
 19b:	53                   	push   %ebx
 19c:	e8 57 ff ff ff       	call   f8 <matchhere>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	85 c0                	test   %eax,%eax
 1a6:	74 e8                	je     190 <match+0x14>
      return 1;
 1a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
    return matchhere(re+1, text);
 1b4:	43                   	inc    %ebx
 1b5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 1b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1be:	e9 35 ff ff ff       	jmp    f8 <matchhere>
 1c3:	90                   	nop

000001c4 <grep>:
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	56                   	push   %esi
 1c9:	53                   	push   %ebx
 1ca:	83 ec 1c             	sub    $0x1c,%esp
 1cd:	8b 75 08             	mov    0x8(%ebp),%esi
  m = 0;
 1d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1d7:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1d8:	50                   	push   %eax
 1d9:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 1de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 1e1:	29 c8                	sub    %ecx,%eax
 1e3:	50                   	push   %eax
 1e4:	8d 81 c0 0d 00 00    	lea    0xdc0(%ecx),%eax
 1ea:	50                   	push   %eax
 1eb:	ff 75 0c             	pushl  0xc(%ebp)
 1ee:	e8 0f 03 00 00       	call   502 <read>
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	0f 8e a2 00 00 00    	jle    2a0 <grep+0xdc>
    m += n;
 1fe:	01 45 e4             	add    %eax,-0x1c(%ebp)
 201:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    buf[m] = '\0';
 204:	c6 81 c0 0d 00 00 00 	movb   $0x0,0xdc0(%ecx)
    p = buf;
 20b:	bb c0 0d 00 00       	mov    $0xdc0,%ebx
    while((q = strchr(p, '\n')) != 0){
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 0a                	push   $0xa
 215:	53                   	push   %ebx
 216:	e8 21 01 00 00       	call   33c <strchr>
 21b:	89 c7                	mov    %eax,%edi
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	74 3c                	je     260 <grep+0x9c>
      *q = 0;
 224:	c6 07 00             	movb   $0x0,(%edi)
      if(match(pattern, p)){
 227:	83 ec 08             	sub    $0x8,%esp
 22a:	53                   	push   %ebx
 22b:	56                   	push   %esi
 22c:	e8 4b ff ff ff       	call   17c <match>
 231:	83 c4 10             	add    $0x10,%esp
 234:	8d 57 01             	lea    0x1(%edi),%edx
 237:	85 c0                	test   %eax,%eax
 239:	75 05                	jne    240 <grep+0x7c>
      p = q+1;
 23b:	89 d3                	mov    %edx,%ebx
 23d:	eb d1                	jmp    210 <grep+0x4c>
 23f:	90                   	nop
        *q = '\n';
 240:	c6 07 0a             	movb   $0xa,(%edi)
        write(1, p, q+1 - p);
 243:	51                   	push   %ecx
 244:	89 d0                	mov    %edx,%eax
 246:	89 55 e0             	mov    %edx,-0x20(%ebp)
 249:	29 d8                	sub    %ebx,%eax
 24b:	50                   	push   %eax
 24c:	53                   	push   %ebx
 24d:	6a 01                	push   $0x1
 24f:	e8 b6 02 00 00       	call   50a <write>
 254:	83 c4 10             	add    $0x10,%esp
 257:	8b 55 e0             	mov    -0x20(%ebp),%edx
      p = q+1;
 25a:	89 d3                	mov    %edx,%ebx
 25c:	eb b2                	jmp    210 <grep+0x4c>
 25e:	66 90                	xchg   %ax,%ax
    if(p == buf)
 260:	81 fb c0 0d 00 00    	cmp    $0xdc0,%ebx
 266:	74 2c                	je     294 <grep+0xd0>
    if(m > 0){
 268:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 26b:	85 c9                	test   %ecx,%ecx
 26d:	0f 8e 65 ff ff ff    	jle    1d8 <grep+0x14>
      m -= p - buf;
 273:	89 d8                	mov    %ebx,%eax
 275:	2d c0 0d 00 00       	sub    $0xdc0,%eax
 27a:	29 c1                	sub    %eax,%ecx
 27c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 27f:	52                   	push   %edx
 280:	51                   	push   %ecx
 281:	53                   	push   %ebx
 282:	68 c0 0d 00 00       	push   $0xdc0
 287:	e8 a4 01 00 00       	call   430 <memmove>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	e9 44 ff ff ff       	jmp    1d8 <grep+0x14>
      m = 0;
 294:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 29b:	e9 38 ff ff ff       	jmp    1d8 <grep+0x14>
}
 2a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
 2a5:	5f                   	pop    %edi
 2a6:	5d                   	pop    %ebp
 2a7:	c3                   	ret    

000002a8 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	53                   	push   %ebx
 2ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b2:	31 c0                	xor    %eax,%eax
 2b4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 2b7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2ba:	40                   	inc    %eax
 2bb:	84 d2                	test   %dl,%dl
 2bd:	75 f5                	jne    2b4 <strcpy+0xc>
    ;
  return os;
}
 2bf:	89 c8                	mov    %ecx,%eax
 2c1:	5b                   	pop    %ebx
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    

000002c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	53                   	push   %ebx
 2c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2ce:	0f b6 03             	movzbl (%ebx),%eax
 2d1:	0f b6 0a             	movzbl (%edx),%ecx
 2d4:	84 c0                	test   %al,%al
 2d6:	75 10                	jne    2e8 <strcmp+0x24>
 2d8:	eb 1a                	jmp    2f4 <strcmp+0x30>
 2da:	66 90                	xchg   %ax,%ax
    p++, q++;
 2dc:	43                   	inc    %ebx
 2dd:	42                   	inc    %edx
  while(*p && *p == *q)
 2de:	0f b6 03             	movzbl (%ebx),%eax
 2e1:	0f b6 0a             	movzbl (%edx),%ecx
 2e4:	84 c0                	test   %al,%al
 2e6:	74 0c                	je     2f4 <strcmp+0x30>
 2e8:	38 c8                	cmp    %cl,%al
 2ea:	74 f0                	je     2dc <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2ec:	29 c8                	sub    %ecx,%eax
}
 2ee:	5b                   	pop    %ebx
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d 76 00             	lea    0x0(%esi),%esi
 2f4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2f6:	29 c8                	sub    %ecx,%eax
}
 2f8:	5b                   	pop    %ebx
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	90                   	nop

000002fc <strlen>:

uint
strlen(const char *s)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 302:	80 3a 00             	cmpb   $0x0,(%edx)
 305:	74 15                	je     31c <strlen+0x20>
 307:	31 c0                	xor    %eax,%eax
 309:	8d 76 00             	lea    0x0(%esi),%esi
 30c:	40                   	inc    %eax
 30d:	89 c1                	mov    %eax,%ecx
 30f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 313:	75 f7                	jne    30c <strlen+0x10>
    ;
  return n;
}
 315:	89 c8                	mov    %ecx,%eax
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 31c:	31 c9                	xor    %ecx,%ecx
}
 31e:	89 c8                	mov    %ecx,%eax
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    
 322:	66 90                	xchg   %ax,%ax

00000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 328:	8b 7d 08             	mov    0x8(%ebp),%edi
 32b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	fc                   	cld    
 332:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	5f                   	pop    %edi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	66 90                	xchg   %ax,%ax

0000033c <strchr>:

char*
strchr(const char *s, char c)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 345:	8a 10                	mov    (%eax),%dl
 347:	84 d2                	test   %dl,%dl
 349:	75 0c                	jne    357 <strchr+0x1b>
 34b:	eb 13                	jmp    360 <strchr+0x24>
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	40                   	inc    %eax
 351:	8a 10                	mov    (%eax),%dl
 353:	84 d2                	test   %dl,%dl
 355:	74 09                	je     360 <strchr+0x24>
    if(*s == c)
 357:	38 d1                	cmp    %dl,%cl
 359:	75 f5                	jne    350 <strchr+0x14>
      return (char*)s;
  return 0;
}
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 360:	31 c0                	xor    %eax,%eax
}
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    

00000364 <gets>:

char*
gets(char *buf, int max)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36d:	8b 75 08             	mov    0x8(%ebp),%esi
 370:	bb 01 00 00 00       	mov    $0x1,%ebx
 375:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 377:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 37a:	eb 20                	jmp    39c <gets+0x38>
    cc = read(0, &c, 1);
 37c:	50                   	push   %eax
 37d:	6a 01                	push   $0x1
 37f:	57                   	push   %edi
 380:	6a 00                	push   $0x0
 382:	e8 7b 01 00 00       	call   502 <read>
    if(cc < 1)
 387:	83 c4 10             	add    $0x10,%esp
 38a:	85 c0                	test   %eax,%eax
 38c:	7e 16                	jle    3a4 <gets+0x40>
      break;
    buf[i++] = c;
 38e:	8a 45 e7             	mov    -0x19(%ebp),%al
 391:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 393:	46                   	inc    %esi
 394:	3c 0a                	cmp    $0xa,%al
 396:	74 0c                	je     3a4 <gets+0x40>
 398:	3c 0d                	cmp    $0xd,%al
 39a:	74 08                	je     3a4 <gets+0x40>
  for(i=0; i+1 < max; ){
 39c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 39f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3a2:	7f d8                	jg     37c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 3a4:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5f                   	pop    %edi
 3b0:	5d                   	pop    %ebp
 3b1:	c3                   	ret    
 3b2:	66 90                	xchg   %ax,%ax

000003b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	6a 00                	push   $0x0
 3be:	ff 75 08             	pushl  0x8(%ebp)
 3c1:	e8 64 01 00 00       	call   52a <open>
  if(fd < 0)
 3c6:	83 c4 10             	add    $0x10,%esp
 3c9:	85 c0                	test   %eax,%eax
 3cb:	78 27                	js     3f4 <stat+0x40>
 3cd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3cf:	83 ec 08             	sub    $0x8,%esp
 3d2:	ff 75 0c             	pushl  0xc(%ebp)
 3d5:	50                   	push   %eax
 3d6:	e8 67 01 00 00       	call   542 <fstat>
 3db:	89 c6                	mov    %eax,%esi
  close(fd);
 3dd:	89 1c 24             	mov    %ebx,(%esp)
 3e0:	e8 2d 01 00 00       	call   512 <close>
  return r;
 3e5:	83 c4 10             	add    $0x10,%esp
}
 3e8:	89 f0                	mov    %esi,%eax
 3ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3f4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3f9:	eb ed                	jmp    3e8 <stat+0x34>
 3fb:	90                   	nop

000003fc <atoi>:

int
atoi(const char *s)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	53                   	push   %ebx
 400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 403:	0f be 01             	movsbl (%ecx),%eax
 406:	8d 50 d0             	lea    -0x30(%eax),%edx
 409:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 411:	77 16                	ja     429 <atoi+0x2d>
 413:	90                   	nop
    n = n*10 + *s++ - '0';
 414:	41                   	inc    %ecx
 415:	8d 14 92             	lea    (%edx,%edx,4),%edx
 418:	01 d2                	add    %edx,%edx
 41a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 41e:	0f be 01             	movsbl (%ecx),%eax
 421:	8d 58 d0             	lea    -0x30(%eax),%ebx
 424:	80 fb 09             	cmp    $0x9,%bl
 427:	76 eb                	jbe    414 <atoi+0x18>
  return n;
}
 429:	89 d0                	mov    %edx,%eax
 42b:	5b                   	pop    %ebx
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    
 42e:	66 90                	xchg   %ax,%ax

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	8b 75 0c             	mov    0xc(%ebp),%esi
 43b:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43e:	85 d2                	test   %edx,%edx
 440:	7e 0b                	jle    44d <memmove+0x1d>
 442:	01 c2                	add    %eax,%edx
  dst = vdst;
 444:	89 c7                	mov    %eax,%edi
 446:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 448:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 449:	39 fa                	cmp    %edi,%edx
 44b:	75 fb                	jne    448 <memmove+0x18>
  return vdst;
}
 44d:	5e                   	pop    %esi
 44e:	5f                   	pop    %edi
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret    
 451:	8d 76 00             	lea    0x0(%esi),%esi

00000454 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 460:	5d                   	pop    %ebp
 461:	c3                   	ret    
 462:	66 90                	xchg   %ax,%ax

00000464 <lock_acquire>:

void lock_acquire(lock_t *lock) {
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 46a:	b9 01 00 00 00       	mov    $0x1,%ecx
 46f:	90                   	nop
 470:	89 c8                	mov    %ecx,%eax
 472:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
 475:	85 c0                	test   %eax,%eax
 477:	75 f7                	jne    470 <lock_acquire+0xc>
}
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    
 47b:	90                   	nop

0000047c <lock_release>:

void lock_release(lock_t *lock) {
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	8b 55 08             	mov    0x8(%ebp),%edx
 482:	31 c0                	xor    %eax,%eax
 484:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
 487:	5d                   	pop    %ebp
 488:	c3                   	ret    
 489:	8d 76 00             	lea    0x0(%esi),%esi

0000048c <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
 492:	68 00 20 00 00       	push   $0x2000
 497:	e8 94 03 00 00       	call   830 <malloc>

  if((uint)stack % PGSIZE)
 49c:	83 c4 10             	add    $0x10,%esp
 49f:	89 c2                	mov    %eax,%edx
 4a1:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 4a7:	74 07                	je     4b0 <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 4a9:	29 d0                	sub    %edx,%eax
 4ab:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
 4b0:	ff 75 0c             	pushl  0xc(%ebp)
 4b3:	6a 08                	push   $0x8
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 cc 00 00 00       	call   58a <clone>

  if (tid < 0) {
 4be:	83 c4 10             	add    $0x10,%esp
 4c1:	85 c0                	test   %eax,%eax
 4c3:	78 07                	js     4cc <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
 4c5:	31 c0                	xor    %eax,%eax
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    
 4c9:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
 4cc:	83 ec 08             	sub    $0x8,%esp
 4cf:	68 5e 09 00 00       	push   $0x95e
 4d4:	6a 01                	push   $0x1
 4d6:	e8 41 01 00 00       	call   61c <printf>
      return 0;
 4db:	83 c4 10             	add    $0x10,%esp
}
 4de:	31 c0                	xor    %eax,%eax
 4e0:	c9                   	leave  
 4e1:	c3                   	ret    

000004e2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e2:	b8 01 00 00 00       	mov    $0x1,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <exit>:
SYSCALL(exit)
 4ea:	b8 02 00 00 00       	mov    $0x2,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <wait>:
SYSCALL(wait)
 4f2:	b8 03 00 00 00       	mov    $0x3,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <pipe>:
SYSCALL(pipe)
 4fa:	b8 04 00 00 00       	mov    $0x4,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <read>:
SYSCALL(read)
 502:	b8 05 00 00 00       	mov    $0x5,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <write>:
SYSCALL(write)
 50a:	b8 10 00 00 00       	mov    $0x10,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <close>:
SYSCALL(close)
 512:	b8 15 00 00 00       	mov    $0x15,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <kill>:
SYSCALL(kill)
 51a:	b8 06 00 00 00       	mov    $0x6,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <exec>:
SYSCALL(exec)
 522:	b8 07 00 00 00       	mov    $0x7,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <open>:
SYSCALL(open)
 52a:	b8 0f 00 00 00       	mov    $0xf,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <mknod>:
SYSCALL(mknod)
 532:	b8 11 00 00 00       	mov    $0x11,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <unlink>:
SYSCALL(unlink)
 53a:	b8 12 00 00 00       	mov    $0x12,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <fstat>:
SYSCALL(fstat)
 542:	b8 08 00 00 00       	mov    $0x8,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <link>:
SYSCALL(link)
 54a:	b8 13 00 00 00       	mov    $0x13,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <mkdir>:
SYSCALL(mkdir)
 552:	b8 14 00 00 00       	mov    $0x14,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <chdir>:
SYSCALL(chdir)
 55a:	b8 09 00 00 00       	mov    $0x9,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <dup>:
SYSCALL(dup)
 562:	b8 0a 00 00 00       	mov    $0xa,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <getpid>:
SYSCALL(getpid)
 56a:	b8 0b 00 00 00       	mov    $0xb,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <sbrk>:
SYSCALL(sbrk)
 572:	b8 0c 00 00 00       	mov    $0xc,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <sleep>:
SYSCALL(sleep)
 57a:	b8 0d 00 00 00       	mov    $0xd,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <uptime>:
SYSCALL(uptime)
 582:	b8 0e 00 00 00       	mov    $0xe,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <clone>:
 58a:	b8 16 00 00 00       	mov    $0x16,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    
 592:	66 90                	xchg   %ax,%ax

00000594 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 3c             	sub    $0x3c,%esp
 59d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 5a0:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5a3:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 5a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5a8:	85 db                	test   %ebx,%ebx
 5aa:	74 04                	je     5b0 <printint+0x1c>
 5ac:	85 d2                	test   %edx,%edx
 5ae:	78 68                	js     618 <printint+0x84>
  neg = 0;
 5b0:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5b7:	31 ff                	xor    %edi,%edi
 5b9:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 5bc:	89 c8                	mov    %ecx,%eax
 5be:	31 d2                	xor    %edx,%edx
 5c0:	f7 75 c4             	divl   -0x3c(%ebp)
 5c3:	89 fb                	mov    %edi,%ebx
 5c5:	8d 7f 01             	lea    0x1(%edi),%edi
 5c8:	8a 92 78 09 00 00    	mov    0x978(%edx),%dl
 5ce:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
 5d2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
 5d5:	89 c1                	mov    %eax,%ecx
 5d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5da:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 5dd:	76 dd                	jbe    5bc <printint+0x28>
  if(neg)
 5df:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5e2:	85 c9                	test   %ecx,%ecx
 5e4:	74 09                	je     5ef <printint+0x5b>
    buf[i++] = '-';
 5e6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 5eb:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 5ed:	b2 2d                	mov    $0x2d,%dl
 5ef:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 5f3:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5f6:	eb 03                	jmp    5fb <printint+0x67>
 5f8:	8a 13                	mov    (%ebx),%dl
 5fa:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 5fb:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 5fe:	50                   	push   %eax
 5ff:	6a 01                	push   $0x1
 601:	56                   	push   %esi
 602:	57                   	push   %edi
 603:	e8 02 ff ff ff       	call   50a <write>
  while(--i >= 0)
 608:	83 c4 10             	add    $0x10,%esp
 60b:	39 de                	cmp    %ebx,%esi
 60d:	75 e9                	jne    5f8 <printint+0x64>
}
 60f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 612:	5b                   	pop    %ebx
 613:	5e                   	pop    %esi
 614:	5f                   	pop    %edi
 615:	5d                   	pop    %ebp
 616:	c3                   	ret    
 617:	90                   	nop
    x = -xx;
 618:	f7 d9                	neg    %ecx
 61a:	eb 9b                	jmp    5b7 <printint+0x23>

0000061c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	57                   	push   %edi
 620:	56                   	push   %esi
 621:	53                   	push   %ebx
 622:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 625:	8b 75 0c             	mov    0xc(%ebp),%esi
 628:	8a 1e                	mov    (%esi),%bl
 62a:	84 db                	test   %bl,%bl
 62c:	0f 84 a3 00 00 00    	je     6d5 <printf+0xb9>
 632:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 633:	8d 45 10             	lea    0x10(%ebp),%eax
 636:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 639:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 63b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 63e:	eb 29                	jmp    669 <printf+0x4d>
 640:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 643:	83 f8 25             	cmp    $0x25,%eax
 646:	0f 84 94 00 00 00    	je     6e0 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 64c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 64f:	50                   	push   %eax
 650:	6a 01                	push   $0x1
 652:	57                   	push   %edi
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 af fe ff ff       	call   50a <write>
        putc(fd, c);
 65b:	83 c4 10             	add    $0x10,%esp
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 661:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 662:	8a 5e ff             	mov    -0x1(%esi),%bl
 665:	84 db                	test   %bl,%bl
 667:	74 6c                	je     6d5 <printf+0xb9>
    c = fmt[i] & 0xff;
 669:	0f be cb             	movsbl %bl,%ecx
 66c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 66f:	85 d2                	test   %edx,%edx
 671:	74 cd                	je     640 <printf+0x24>
      }
    } else if(state == '%'){
 673:	83 fa 25             	cmp    $0x25,%edx
 676:	75 e9                	jne    661 <printf+0x45>
      if(c == 'd'){
 678:	83 f8 64             	cmp    $0x64,%eax
 67b:	0f 84 97 00 00 00    	je     718 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 681:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 687:	83 f9 70             	cmp    $0x70,%ecx
 68a:	74 60                	je     6ec <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 68c:	83 f8 73             	cmp    $0x73,%eax
 68f:	0f 84 8f 00 00 00    	je     724 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 695:	83 f8 63             	cmp    $0x63,%eax
 698:	0f 84 d6 00 00 00    	je     774 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 69e:	83 f8 25             	cmp    $0x25,%eax
 6a1:	0f 84 c1 00 00 00    	je     768 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 6ab:	50                   	push   %eax
 6ac:	6a 01                	push   $0x1
 6ae:	57                   	push   %edi
 6af:	ff 75 08             	pushl  0x8(%ebp)
 6b2:	e8 53 fe ff ff       	call   50a <write>
        putc(fd, c);
 6b7:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6ba:	83 c4 0c             	add    $0xc,%esp
 6bd:	6a 01                	push   $0x1
 6bf:	57                   	push   %edi
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 42 fe ff ff       	call   50a <write>
        putc(fd, c);
 6c8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6cb:	31 d2                	xor    %edx,%edx
 6cd:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 6ce:	8a 5e ff             	mov    -0x1(%esi),%bl
 6d1:	84 db                	test   %bl,%bl
 6d3:	75 94                	jne    669 <printf+0x4d>
    }
  }
}
 6d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5f                   	pop    %edi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 6e0:	ba 25 00 00 00       	mov    $0x25,%edx
 6e5:	e9 77 ff ff ff       	jmp    661 <printf+0x45>
 6ea:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6ec:	83 ec 0c             	sub    $0xc,%esp
 6ef:	6a 00                	push   $0x0
 6f1:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6f9:	8b 13                	mov    (%ebx),%edx
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	e8 91 fe ff ff       	call   594 <printint>
        ap++;
 703:	89 d8                	mov    %ebx,%eax
 705:	83 c0 04             	add    $0x4,%eax
 708:	89 45 d0             	mov    %eax,-0x30(%ebp)
 70b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70e:	31 d2                	xor    %edx,%edx
        ap++;
 710:	e9 4c ff ff ff       	jmp    661 <printf+0x45>
 715:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	6a 01                	push   $0x1
 71d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 722:	eb d2                	jmp    6f6 <printf+0xda>
        s = (char*)*ap;
 724:	8b 45 d0             	mov    -0x30(%ebp),%eax
 727:	8b 18                	mov    (%eax),%ebx
        ap++;
 729:	83 c0 04             	add    $0x4,%eax
 72c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 72f:	85 db                	test   %ebx,%ebx
 731:	74 65                	je     798 <printf+0x17c>
        while(*s != 0){
 733:	8a 03                	mov    (%ebx),%al
 735:	84 c0                	test   %al,%al
 737:	74 70                	je     7a9 <printf+0x18d>
 739:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 73c:	89 de                	mov    %ebx,%esi
 73e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 741:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 744:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 747:	50                   	push   %eax
 748:	6a 01                	push   $0x1
 74a:	57                   	push   %edi
 74b:	53                   	push   %ebx
 74c:	e8 b9 fd ff ff       	call   50a <write>
          s++;
 751:	46                   	inc    %esi
        while(*s != 0){
 752:	8a 06                	mov    (%esi),%al
 754:	83 c4 10             	add    $0x10,%esp
 757:	84 c0                	test   %al,%al
 759:	75 e9                	jne    744 <printf+0x128>
 75b:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 75e:	31 d2                	xor    %edx,%edx
 760:	e9 fc fe ff ff       	jmp    661 <printf+0x45>
 765:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 768:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 76b:	52                   	push   %edx
 76c:	e9 4c ff ff ff       	jmp    6bd <printf+0xa1>
 771:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 774:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 777:	8b 03                	mov    (%ebx),%eax
 779:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 77c:	51                   	push   %ecx
 77d:	6a 01                	push   $0x1
 77f:	57                   	push   %edi
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 82 fd ff ff       	call   50a <write>
        ap++;
 788:	83 c3 04             	add    $0x4,%ebx
 78b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 78e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 791:	31 d2                	xor    %edx,%edx
 793:	e9 c9 fe ff ff       	jmp    661 <printf+0x45>
          s = "(null)";
 798:	bb 6e 09 00 00       	mov    $0x96e,%ebx
        while(*s != 0){
 79d:	b0 28                	mov    $0x28,%al
 79f:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7a2:	89 de                	mov    %ebx,%esi
 7a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a7:	eb 9b                	jmp    744 <printf+0x128>
      state = 0;
 7a9:	31 d2                	xor    %edx,%edx
 7ab:	e9 b1 fe ff ff       	jmp    661 <printf+0x45>

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	a1 a0 0d 00 00       	mov    0xda0,%eax
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	39 c8                	cmp    %ecx,%eax
 7c5:	73 11                	jae    7d8 <free+0x28>
 7c7:	90                   	nop
 7c8:	39 d1                	cmp    %edx,%ecx
 7ca:	72 14                	jb     7e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	39 d0                	cmp    %edx,%eax
 7ce:	73 10                	jae    7e0 <free+0x30>
{
 7d0:	89 d0                	mov    %edx,%eax
 7d2:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	39 c8                	cmp    %ecx,%eax
 7d6:	72 f0                	jb     7c8 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	39 d0                	cmp    %edx,%eax
 7da:	72 f4                	jb     7d0 <free+0x20>
 7dc:	39 d1                	cmp    %edx,%ecx
 7de:	73 f0                	jae    7d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7e6:	39 fa                	cmp    %edi,%edx
 7e8:	74 1a                	je     804 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ed:	8b 50 04             	mov    0x4(%eax),%edx
 7f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f3:	39 f1                	cmp    %esi,%ecx
 7f5:	74 24                	je     81b <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7f7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7f9:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 7fe:	5b                   	pop    %ebx
 7ff:	5e                   	pop    %esi
 800:	5f                   	pop    %edi
 801:	5d                   	pop    %ebp
 802:	c3                   	ret    
 803:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 804:	03 72 04             	add    0x4(%edx),%esi
 807:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 12                	mov    (%edx),%edx
 80e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 811:	8b 50 04             	mov    0x4(%eax),%edx
 814:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 817:	39 f1                	cmp    %esi,%ecx
 819:	75 dc                	jne    7f7 <free+0x47>
    p->s.size += bp->s.size;
 81b:	03 53 fc             	add    -0x4(%ebx),%edx
 81e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 821:	8b 53 f8             	mov    -0x8(%ebx),%edx
 824:	89 10                	mov    %edx,(%eax)
  freep = p;
 826:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 82b:	5b                   	pop    %ebx
 82c:	5e                   	pop    %esi
 82d:	5f                   	pop    %edi
 82e:	5d                   	pop    %ebp
 82f:	c3                   	ret    

00000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 839:	8b 45 08             	mov    0x8(%ebp),%eax
 83c:	8d 70 07             	lea    0x7(%eax),%esi
 83f:	c1 ee 03             	shr    $0x3,%esi
 842:	46                   	inc    %esi
  if((prevp = freep) == 0){
 843:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 849:	85 ff                	test   %edi,%edi
 84b:	0f 84 a3 00 00 00    	je     8f4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 851:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 853:	8b 48 04             	mov    0x4(%eax),%ecx
 856:	39 f1                	cmp    %esi,%ecx
 858:	73 67                	jae    8c1 <malloc+0x91>
 85a:	89 f3                	mov    %esi,%ebx
 85c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 862:	0f 82 80 00 00 00    	jb     8e8 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 868:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 86f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 872:	eb 11                	jmp    885 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 876:	8b 4a 04             	mov    0x4(%edx),%ecx
 879:	39 f1                	cmp    %esi,%ecx
 87b:	73 4b                	jae    8c8 <malloc+0x98>
 87d:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 883:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 885:	39 c7                	cmp    %eax,%edi
 887:	75 eb                	jne    874 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 889:	83 ec 0c             	sub    $0xc,%esp
 88c:	ff 75 e4             	pushl  -0x1c(%ebp)
 88f:	e8 de fc ff ff       	call   572 <sbrk>
  if(p == (char*)-1)
 894:	83 c4 10             	add    $0x10,%esp
 897:	83 f8 ff             	cmp    $0xffffffff,%eax
 89a:	74 1b                	je     8b7 <malloc+0x87>
  hp->s.size = nu;
 89c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	83 c0 08             	add    $0x8,%eax
 8a5:	50                   	push   %eax
 8a6:	e8 05 ff ff ff       	call   7b0 <free>
  return freep;
 8ab:	a1 a0 0d 00 00       	mov    0xda0,%eax
      if((p = morecore(nunits)) == 0)
 8b0:	83 c4 10             	add    $0x10,%esp
 8b3:	85 c0                	test   %eax,%eax
 8b5:	75 bd                	jne    874 <malloc+0x44>
        return 0;
 8b7:	31 c0                	xor    %eax,%eax
  }
}
 8b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8bc:	5b                   	pop    %ebx
 8bd:	5e                   	pop    %esi
 8be:	5f                   	pop    %edi
 8bf:	5d                   	pop    %ebp
 8c0:	c3                   	ret    
    if(p->s.size >= nunits){
 8c1:	89 c2                	mov    %eax,%edx
 8c3:	89 f8                	mov    %edi,%eax
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8c8:	39 ce                	cmp    %ecx,%esi
 8ca:	74 54                	je     920 <malloc+0xf0>
        p->s.size -= nunits;
 8cc:	29 f1                	sub    %esi,%ecx
 8ce:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8d1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8d4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8d7:	a3 a0 0d 00 00       	mov    %eax,0xda0
      return (void*)(p + 1);
 8dc:	8d 42 08             	lea    0x8(%edx),%eax
}
 8df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8e2:	5b                   	pop    %ebx
 8e3:	5e                   	pop    %esi
 8e4:	5f                   	pop    %edi
 8e5:	5d                   	pop    %ebp
 8e6:	c3                   	ret    
 8e7:	90                   	nop
 8e8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ed:	e9 76 ff ff ff       	jmp    868 <malloc+0x38>
 8f2:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8f4:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 8fb:	0d 00 00 
 8fe:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 905:	0d 00 00 
    base.s.size = 0;
 908:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 90f:	00 00 00 
 912:	bf a4 0d 00 00       	mov    $0xda4,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 917:	89 f8                	mov    %edi,%eax
 919:	e9 3c ff ff ff       	jmp    85a <malloc+0x2a>
 91e:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 920:	8b 0a                	mov    (%edx),%ecx
 922:	89 08                	mov    %ecx,(%eax)
 924:	eb b1                	jmp    8d7 <malloc+0xa7>

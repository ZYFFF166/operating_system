
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	52                   	push   %edx
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
       f:	eb 0c                	jmp    1d <main+0x1d>
      11:	8d 76 00             	lea    0x0(%esi),%esi
    if(fd >= 3){
      14:	83 f8 02             	cmp    $0x2,%eax
      17:	0f 8f af 00 00 00    	jg     cc <main+0xcc>
  while((fd = open("console", O_RDWR)) >= 0){
      1d:	83 ec 08             	sub    $0x8,%esp
      20:	6a 02                	push   $0x2
      22:	68 15 11 00 00       	push   $0x1115
      27:	e8 4a 0c 00 00       	call   c76 <open>
      2c:	83 c4 10             	add    $0x10,%esp
      2f:	85 c0                	test   %eax,%eax
      31:	79 e1                	jns    14 <main+0x14>
      33:	eb 2a                	jmp    5f <main+0x5f>
      35:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      38:	80 3d e2 17 00 00 20 	cmpb   $0x20,0x17e2
      3f:	74 4d                	je     8e <main+0x8e>
      41:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      44:	e8 e5 0b 00 00       	call   c2e <fork>
  if(pid == -1)
      49:	83 f8 ff             	cmp    $0xffffffff,%eax
      4c:	0f 84 9d 00 00 00    	je     ef <main+0xef>
    if(fork1() == 0)
      52:	85 c0                	test   %eax,%eax
      54:	0f 84 80 00 00 00    	je     da <main+0xda>
    wait();
      5a:	e8 df 0b 00 00       	call   c3e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      5f:	83 ec 08             	sub    $0x8,%esp
      62:	6a 64                	push   $0x64
      64:	68 e0 17 00 00       	push   $0x17e0
      69:	e8 8e 00 00 00       	call   fc <getcmd>
      6e:	83 c4 10             	add    $0x10,%esp
      71:	85 c0                	test   %eax,%eax
      73:	78 14                	js     89 <main+0x89>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      75:	80 3d e0 17 00 00 63 	cmpb   $0x63,0x17e0
      7c:	75 c6                	jne    44 <main+0x44>
      7e:	80 3d e1 17 00 00 64 	cmpb   $0x64,0x17e1
      85:	75 bd                	jne    44 <main+0x44>
      87:	eb af                	jmp    38 <main+0x38>
  exit();
      89:	e8 a8 0b 00 00       	call   c36 <exit>
      buf[strlen(buf)-1] = 0;  // chop \n
      8e:	83 ec 0c             	sub    $0xc,%esp
      91:	68 e0 17 00 00       	push   $0x17e0
      96:	e8 ad 09 00 00       	call   a48 <strlen>
      9b:	c6 80 df 17 00 00 00 	movb   $0x0,0x17df(%eax)
      if(chdir(buf+3) < 0)
      a2:	c7 04 24 e3 17 00 00 	movl   $0x17e3,(%esp)
      a9:	e8 f8 0b 00 00       	call   ca6 <chdir>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 aa                	jns    5f <main+0x5f>
        printf(2, "cannot cd %s\n", buf+3);
      b5:	50                   	push   %eax
      b6:	68 e3 17 00 00       	push   $0x17e3
      bb:	68 1d 11 00 00       	push   $0x111d
      c0:	6a 02                	push   $0x2
      c2:	e8 a1 0c 00 00       	call   d68 <printf>
      c7:	83 c4 10             	add    $0x10,%esp
      ca:	eb 93                	jmp    5f <main+0x5f>
      close(fd);
      cc:	83 ec 0c             	sub    $0xc,%esp
      cf:	50                   	push   %eax
      d0:	e8 89 0b 00 00       	call   c5e <close>
      break;
      d5:	83 c4 10             	add    $0x10,%esp
      d8:	eb 85                	jmp    5f <main+0x5f>
      runcmd(parsecmd(buf));
      da:	83 ec 0c             	sub    $0xc,%esp
      dd:	68 e0 17 00 00       	push   $0x17e0
      e2:	e8 a1 08 00 00       	call   988 <parsecmd>
      e7:	89 04 24             	mov    %eax,(%esp)
      ea:	e8 6d 00 00 00       	call   15c <runcmd>
    panic("fork");
      ef:	83 ec 0c             	sub    $0xc,%esp
      f2:	68 9e 10 00 00       	push   $0x109e
      f7:	e8 44 00 00 00       	call   140 <panic>

000000fc <getcmd>:
{
      fc:	55                   	push   %ebp
      fd:	89 e5                	mov    %esp,%ebp
      ff:	56                   	push   %esi
     100:	53                   	push   %ebx
     101:	8b 5d 08             	mov    0x8(%ebp),%ebx
     104:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     107:	83 ec 08             	sub    $0x8,%esp
     10a:	68 74 10 00 00       	push   $0x1074
     10f:	6a 02                	push   $0x2
     111:	e8 52 0c 00 00       	call   d68 <printf>
  memset(buf, 0, nbuf);
     116:	83 c4 0c             	add    $0xc,%esp
     119:	56                   	push   %esi
     11a:	6a 00                	push   $0x0
     11c:	53                   	push   %ebx
     11d:	e8 4e 09 00 00       	call   a70 <memset>
  gets(buf, nbuf);
     122:	58                   	pop    %eax
     123:	5a                   	pop    %edx
     124:	56                   	push   %esi
     125:	53                   	push   %ebx
     126:	e8 85 09 00 00       	call   ab0 <gets>
  if(buf[0] == 0) // EOF
     12b:	83 c4 10             	add    $0x10,%esp
     12e:	31 c0                	xor    %eax,%eax
     130:	80 3b 00             	cmpb   $0x0,(%ebx)
     133:	0f 94 c0             	sete   %al
     136:	f7 d8                	neg    %eax
}
     138:	8d 65 f8             	lea    -0x8(%ebp),%esp
     13b:	5b                   	pop    %ebx
     13c:	5e                   	pop    %esi
     13d:	5d                   	pop    %ebp
     13e:	c3                   	ret    
     13f:	90                   	nop

00000140 <panic>:
{
     140:	55                   	push   %ebp
     141:	89 e5                	mov    %esp,%ebp
     143:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     146:	ff 75 08             	pushl  0x8(%ebp)
     149:	68 11 11 00 00       	push   $0x1111
     14e:	6a 02                	push   $0x2
     150:	e8 13 0c 00 00       	call   d68 <printf>
  exit();
     155:	e8 dc 0a 00 00       	call   c36 <exit>
     15a:	66 90                	xchg   %ax,%ax

0000015c <runcmd>:
{
     15c:	55                   	push   %ebp
     15d:	89 e5                	mov    %esp,%ebp
     15f:	53                   	push   %ebx
     160:	83 ec 14             	sub    $0x14,%esp
     163:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     166:	85 db                	test   %ebx,%ebx
     168:	74 76                	je     1e0 <runcmd+0x84>
  switch(cmd->type){
     16a:	83 3b 05             	cmpl   $0x5,(%ebx)
     16d:	0f 87 fc 00 00 00    	ja     26f <runcmd+0x113>
     173:	8b 03                	mov    (%ebx),%eax
     175:	ff 24 85 2c 11 00 00 	jmp    *0x112c(,%eax,4)
    if(pipe(p) < 0)
     17c:	83 ec 0c             	sub    $0xc,%esp
     17f:	8d 45 f0             	lea    -0x10(%ebp),%eax
     182:	50                   	push   %eax
     183:	e8 be 0a 00 00       	call   c46 <pipe>
     188:	83 c4 10             	add    $0x10,%esp
     18b:	85 c0                	test   %eax,%eax
     18d:	0f 88 fe 00 00 00    	js     291 <runcmd+0x135>
  pid = fork();
     193:	e8 96 0a 00 00       	call   c2e <fork>
  if(pid == -1)
     198:	83 f8 ff             	cmp    $0xffffffff,%eax
     19b:	0f 84 59 01 00 00    	je     2fa <runcmd+0x19e>
    if(fork1() == 0){
     1a1:	85 c0                	test   %eax,%eax
     1a3:	0f 84 f5 00 00 00    	je     29e <runcmd+0x142>
  pid = fork();
     1a9:	e8 80 0a 00 00       	call   c2e <fork>
  if(pid == -1)
     1ae:	83 f8 ff             	cmp    $0xffffffff,%eax
     1b1:	0f 84 43 01 00 00    	je     2fa <runcmd+0x19e>
    if(fork1() == 0){
     1b7:	85 c0                	test   %eax,%eax
     1b9:	0f 84 0d 01 00 00    	je     2cc <runcmd+0x170>
    close(p[0]);
     1bf:	83 ec 0c             	sub    $0xc,%esp
     1c2:	ff 75 f0             	pushl  -0x10(%ebp)
     1c5:	e8 94 0a 00 00       	call   c5e <close>
    close(p[1]);
     1ca:	58                   	pop    %eax
     1cb:	ff 75 f4             	pushl  -0xc(%ebp)
     1ce:	e8 8b 0a 00 00       	call   c5e <close>
    wait();
     1d3:	e8 66 0a 00 00       	call   c3e <wait>
    wait();
     1d8:	e8 61 0a 00 00       	call   c3e <wait>
    break;
     1dd:	83 c4 10             	add    $0x10,%esp
    exit();
     1e0:	e8 51 0a 00 00       	call   c36 <exit>
  pid = fork();
     1e5:	e8 44 0a 00 00       	call   c2e <fork>
  if(pid == -1)
     1ea:	83 f8 ff             	cmp    $0xffffffff,%eax
     1ed:	0f 84 07 01 00 00    	je     2fa <runcmd+0x19e>
    if(fork1() == 0)
     1f3:	85 c0                	test   %eax,%eax
     1f5:	75 e9                	jne    1e0 <runcmd+0x84>
     1f7:	eb 6b                	jmp    264 <runcmd+0x108>
    if(ecmd->argv[0] == 0)
     1f9:	8b 43 04             	mov    0x4(%ebx),%eax
     1fc:	85 c0                	test   %eax,%eax
     1fe:	74 e0                	je     1e0 <runcmd+0x84>
    exec(ecmd->argv[0], ecmd->argv);
     200:	51                   	push   %ecx
     201:	51                   	push   %ecx
     202:	8d 53 04             	lea    0x4(%ebx),%edx
     205:	52                   	push   %edx
     206:	50                   	push   %eax
     207:	e8 62 0a 00 00       	call   c6e <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     20c:	83 c4 0c             	add    $0xc,%esp
     20f:	ff 73 04             	pushl  0x4(%ebx)
     212:	68 7e 10 00 00       	push   $0x107e
     217:	6a 02                	push   $0x2
     219:	e8 4a 0b 00 00       	call   d68 <printf>
    break;
     21e:	83 c4 10             	add    $0x10,%esp
     221:	eb bd                	jmp    1e0 <runcmd+0x84>
  pid = fork();
     223:	e8 06 0a 00 00       	call   c2e <fork>
  if(pid == -1)
     228:	83 f8 ff             	cmp    $0xffffffff,%eax
     22b:	0f 84 c9 00 00 00    	je     2fa <runcmd+0x19e>
    if(fork1() == 0)
     231:	85 c0                	test   %eax,%eax
     233:	74 2f                	je     264 <runcmd+0x108>
    wait();
     235:	e8 04 0a 00 00       	call   c3e <wait>
    runcmd(lcmd->right);
     23a:	83 ec 0c             	sub    $0xc,%esp
     23d:	ff 73 08             	pushl  0x8(%ebx)
     240:	e8 17 ff ff ff       	call   15c <runcmd>
    close(rcmd->fd);
     245:	83 ec 0c             	sub    $0xc,%esp
     248:	ff 73 14             	pushl  0x14(%ebx)
     24b:	e8 0e 0a 00 00       	call   c5e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     250:	58                   	pop    %eax
     251:	5a                   	pop    %edx
     252:	ff 73 10             	pushl  0x10(%ebx)
     255:	ff 73 08             	pushl  0x8(%ebx)
     258:	e8 19 0a 00 00       	call   c76 <open>
     25d:	83 c4 10             	add    $0x10,%esp
     260:	85 c0                	test   %eax,%eax
     262:	78 18                	js     27c <runcmd+0x120>
      runcmd(bcmd->cmd);
     264:	83 ec 0c             	sub    $0xc,%esp
     267:	ff 73 04             	pushl  0x4(%ebx)
     26a:	e8 ed fe ff ff       	call   15c <runcmd>
    panic("runcmd");
     26f:	83 ec 0c             	sub    $0xc,%esp
     272:	68 77 10 00 00       	push   $0x1077
     277:	e8 c4 fe ff ff       	call   140 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     27c:	51                   	push   %ecx
     27d:	ff 73 08             	pushl  0x8(%ebx)
     280:	68 8e 10 00 00       	push   $0x108e
     285:	6a 02                	push   $0x2
     287:	e8 dc 0a 00 00       	call   d68 <printf>
      exit();
     28c:	e8 a5 09 00 00       	call   c36 <exit>
      panic("pipe");
     291:	83 ec 0c             	sub    $0xc,%esp
     294:	68 a3 10 00 00       	push   $0x10a3
     299:	e8 a2 fe ff ff       	call   140 <panic>
      close(1);
     29e:	83 ec 0c             	sub    $0xc,%esp
     2a1:	6a 01                	push   $0x1
     2a3:	e8 b6 09 00 00       	call   c5e <close>
      dup(p[1]);
     2a8:	58                   	pop    %eax
     2a9:	ff 75 f4             	pushl  -0xc(%ebp)
     2ac:	e8 fd 09 00 00       	call   cae <dup>
      close(p[0]);
     2b1:	58                   	pop    %eax
     2b2:	ff 75 f0             	pushl  -0x10(%ebp)
     2b5:	e8 a4 09 00 00       	call   c5e <close>
      close(p[1]);
     2ba:	58                   	pop    %eax
     2bb:	ff 75 f4             	pushl  -0xc(%ebp)
     2be:	e8 9b 09 00 00       	call   c5e <close>
      runcmd(pcmd->left);
     2c3:	5a                   	pop    %edx
     2c4:	ff 73 04             	pushl  0x4(%ebx)
     2c7:	e8 90 fe ff ff       	call   15c <runcmd>
      close(0);
     2cc:	83 ec 0c             	sub    $0xc,%esp
     2cf:	6a 00                	push   $0x0
     2d1:	e8 88 09 00 00       	call   c5e <close>
      dup(p[0]);
     2d6:	5a                   	pop    %edx
     2d7:	ff 75 f0             	pushl  -0x10(%ebp)
     2da:	e8 cf 09 00 00       	call   cae <dup>
      close(p[0]);
     2df:	59                   	pop    %ecx
     2e0:	ff 75 f0             	pushl  -0x10(%ebp)
     2e3:	e8 76 09 00 00       	call   c5e <close>
      close(p[1]);
     2e8:	58                   	pop    %eax
     2e9:	ff 75 f4             	pushl  -0xc(%ebp)
     2ec:	e8 6d 09 00 00       	call   c5e <close>
      runcmd(pcmd->right);
     2f1:	58                   	pop    %eax
     2f2:	ff 73 08             	pushl  0x8(%ebx)
     2f5:	e8 62 fe ff ff       	call   15c <runcmd>
    panic("fork");
     2fa:	83 ec 0c             	sub    $0xc,%esp
     2fd:	68 9e 10 00 00       	push   $0x109e
     302:	e8 39 fe ff ff       	call   140 <panic>
     307:	90                   	nop

00000308 <fork1>:
{
     308:	55                   	push   %ebp
     309:	89 e5                	mov    %esp,%ebp
     30b:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     30e:	e8 1b 09 00 00       	call   c2e <fork>
  if(pid == -1)
     313:	83 f8 ff             	cmp    $0xffffffff,%eax
     316:	74 02                	je     31a <fork1+0x12>
  return pid;
}
     318:	c9                   	leave  
     319:	c3                   	ret    
    panic("fork");
     31a:	83 ec 0c             	sub    $0xc,%esp
     31d:	68 9e 10 00 00       	push   $0x109e
     322:	e8 19 fe ff ff       	call   140 <panic>
     327:	90                   	nop

00000328 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     328:	55                   	push   %ebp
     329:	89 e5                	mov    %esp,%ebp
     32b:	53                   	push   %ebx
     32c:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32f:	6a 54                	push   $0x54
     331:	e8 46 0c 00 00       	call   f7c <malloc>
     336:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     338:	83 c4 0c             	add    $0xc,%esp
     33b:	6a 54                	push   $0x54
     33d:	6a 00                	push   $0x0
     33f:	50                   	push   %eax
     340:	e8 2b 07 00 00       	call   a70 <memset>
  cmd->type = EXEC;
     345:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     34b:	89 d8                	mov    %ebx,%eax
     34d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     350:	c9                   	leave  
     351:	c3                   	ret    
     352:	66 90                	xchg   %ax,%ax

00000354 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     354:	55                   	push   %ebp
     355:	89 e5                	mov    %esp,%ebp
     357:	53                   	push   %ebx
     358:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     35b:	6a 18                	push   $0x18
     35d:	e8 1a 0c 00 00       	call   f7c <malloc>
     362:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     364:	83 c4 0c             	add    $0xc,%esp
     367:	6a 18                	push   $0x18
     369:	6a 00                	push   $0x0
     36b:	50                   	push   %eax
     36c:	e8 ff 06 00 00       	call   a70 <memset>
  cmd->type = REDIR;
     371:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     37d:	8b 45 0c             	mov    0xc(%ebp),%eax
     380:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     383:	8b 45 10             	mov    0x10(%ebp),%eax
     386:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     389:	8b 45 14             	mov    0x14(%ebp),%eax
     38c:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     38f:	8b 45 18             	mov    0x18(%ebp),%eax
     392:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     395:	89 d8                	mov    %ebx,%eax
     397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     39a:	c9                   	leave  
     39b:	c3                   	ret    

0000039c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     39c:	55                   	push   %ebp
     39d:	89 e5                	mov    %esp,%ebp
     39f:	53                   	push   %ebx
     3a0:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a3:	6a 0c                	push   $0xc
     3a5:	e8 d2 0b 00 00       	call   f7c <malloc>
     3aa:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3ac:	83 c4 0c             	add    $0xc,%esp
     3af:	6a 0c                	push   $0xc
     3b1:	6a 00                	push   $0x0
     3b3:	50                   	push   %eax
     3b4:	e8 b7 06 00 00       	call   a70 <memset>
  cmd->type = PIPE;
     3b9:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3bf:	8b 45 08             	mov    0x8(%ebp),%eax
     3c2:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     3c8:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3cb:	89 d8                	mov    %ebx,%eax
     3cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3d0:	c9                   	leave  
     3d1:	c3                   	ret    
     3d2:	66 90                	xchg   %ax,%ax

000003d4 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     3d4:	55                   	push   %ebp
     3d5:	89 e5                	mov    %esp,%ebp
     3d7:	53                   	push   %ebx
     3d8:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3db:	6a 0c                	push   $0xc
     3dd:	e8 9a 0b 00 00       	call   f7c <malloc>
     3e2:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e4:	83 c4 0c             	add    $0xc,%esp
     3e7:	6a 0c                	push   $0xc
     3e9:	6a 00                	push   $0x0
     3eb:	50                   	push   %eax
     3ec:	e8 7f 06 00 00       	call   a70 <memset>
  cmd->type = LIST;
     3f1:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     3f7:	8b 45 08             	mov    0x8(%ebp),%eax
     3fa:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
     400:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     403:	89 d8                	mov    %ebx,%eax
     405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     408:	c9                   	leave  
     409:	c3                   	ret    
     40a:	66 90                	xchg   %ax,%ax

0000040c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     40c:	55                   	push   %ebp
     40d:	89 e5                	mov    %esp,%ebp
     40f:	53                   	push   %ebx
     410:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     413:	6a 08                	push   $0x8
     415:	e8 62 0b 00 00       	call   f7c <malloc>
     41a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     41c:	83 c4 0c             	add    $0xc,%esp
     41f:	6a 08                	push   $0x8
     421:	6a 00                	push   $0x0
     423:	50                   	push   %eax
     424:	e8 47 06 00 00       	call   a70 <memset>
  cmd->type = BACK;
     429:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     42f:	8b 45 08             	mov    0x8(%ebp),%eax
     432:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     435:	89 d8                	mov    %ebx,%eax
     437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     43a:	c9                   	leave  
     43b:	c3                   	ret    

0000043c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     43c:	55                   	push   %ebp
     43d:	89 e5                	mov    %esp,%ebp
     43f:	57                   	push   %edi
     440:	56                   	push   %esi
     441:	53                   	push   %ebx
     442:	83 ec 0c             	sub    $0xc,%esp
     445:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     448:	8b 75 10             	mov    0x10(%ebp),%esi
  char *s;
  int ret;

  s = *ps;
     44b:	8b 45 08             	mov    0x8(%ebp),%eax
     44e:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     450:	39 df                	cmp    %ebx,%edi
     452:	72 09                	jb     45d <gettoken+0x21>
     454:	eb 1f                	jmp    475 <gettoken+0x39>
     456:	66 90                	xchg   %ax,%ax
    s++;
     458:	47                   	inc    %edi
  while(s < es && strchr(whitespace, *s))
     459:	39 fb                	cmp    %edi,%ebx
     45b:	74 18                	je     475 <gettoken+0x39>
     45d:	83 ec 08             	sub    $0x8,%esp
     460:	0f be 07             	movsbl (%edi),%eax
     463:	50                   	push   %eax
     464:	68 c4 17 00 00       	push   $0x17c4
     469:	e8 1a 06 00 00       	call   a88 <strchr>
     46e:	83 c4 10             	add    $0x10,%esp
     471:	85 c0                	test   %eax,%eax
     473:	75 e3                	jne    458 <gettoken+0x1c>
  if(q)
     475:	85 f6                	test   %esi,%esi
     477:	74 02                	je     47b <gettoken+0x3f>
    *q = s;
     479:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     47b:	0f be 07             	movsbl (%edi),%eax
  switch(*s){
     47e:	3c 3c                	cmp    $0x3c,%al
     480:	0f 8f ba 00 00 00    	jg     540 <gettoken+0x104>
     486:	3c 3a                	cmp    $0x3a,%al
     488:	0f 8f a6 00 00 00    	jg     534 <gettoken+0xf8>
     48e:	84 c0                	test   %al,%al
     490:	75 42                	jne    4d4 <gettoken+0x98>
     492:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     494:	8b 55 14             	mov    0x14(%ebp),%edx
     497:	85 d2                	test   %edx,%edx
     499:	74 05                	je     4a0 <gettoken+0x64>
    *eq = s;
     49b:	8b 45 14             	mov    0x14(%ebp),%eax
     49e:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4a0:	39 df                	cmp    %ebx,%edi
     4a2:	72 09                	jb     4ad <gettoken+0x71>
     4a4:	eb 1f                	jmp    4c5 <gettoken+0x89>
     4a6:	66 90                	xchg   %ax,%ax
    s++;
     4a8:	47                   	inc    %edi
  while(s < es && strchr(whitespace, *s))
     4a9:	39 fb                	cmp    %edi,%ebx
     4ab:	74 18                	je     4c5 <gettoken+0x89>
     4ad:	83 ec 08             	sub    $0x8,%esp
     4b0:	0f be 07             	movsbl (%edi),%eax
     4b3:	50                   	push   %eax
     4b4:	68 c4 17 00 00       	push   $0x17c4
     4b9:	e8 ca 05 00 00       	call   a88 <strchr>
     4be:	83 c4 10             	add    $0x10,%esp
     4c1:	85 c0                	test   %eax,%eax
     4c3:	75 e3                	jne    4a8 <gettoken+0x6c>
  *ps = s;
     4c5:	8b 45 08             	mov    0x8(%ebp),%eax
     4c8:	89 38                	mov    %edi,(%eax)
  return ret;
}
     4ca:	89 f0                	mov    %esi,%eax
     4cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4cf:	5b                   	pop    %ebx
     4d0:	5e                   	pop    %esi
     4d1:	5f                   	pop    %edi
     4d2:	5d                   	pop    %ebp
     4d3:	c3                   	ret    
  switch(*s){
     4d4:	79 52                	jns    528 <gettoken+0xec>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d6:	39 fb                	cmp    %edi,%ebx
     4d8:	77 2e                	ja     508 <gettoken+0xcc>
  if(eq)
     4da:	be 61 00 00 00       	mov    $0x61,%esi
     4df:	8b 45 14             	mov    0x14(%ebp),%eax
     4e2:	85 c0                	test   %eax,%eax
     4e4:	75 b5                	jne    49b <gettoken+0x5f>
     4e6:	eb dd                	jmp    4c5 <gettoken+0x89>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4e8:	83 ec 08             	sub    $0x8,%esp
     4eb:	0f be 07             	movsbl (%edi),%eax
     4ee:	50                   	push   %eax
     4ef:	68 bc 17 00 00       	push   $0x17bc
     4f4:	e8 8f 05 00 00       	call   a88 <strchr>
     4f9:	83 c4 10             	add    $0x10,%esp
     4fc:	85 c0                	test   %eax,%eax
     4fe:	75 1d                	jne    51d <gettoken+0xe1>
      s++;
     500:	47                   	inc    %edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     501:	39 fb                	cmp    %edi,%ebx
     503:	74 d5                	je     4da <gettoken+0x9e>
     505:	0f be 07             	movsbl (%edi),%eax
     508:	83 ec 08             	sub    $0x8,%esp
     50b:	50                   	push   %eax
     50c:	68 c4 17 00 00       	push   $0x17c4
     511:	e8 72 05 00 00       	call   a88 <strchr>
     516:	83 c4 10             	add    $0x10,%esp
     519:	85 c0                	test   %eax,%eax
     51b:	74 cb                	je     4e8 <gettoken+0xac>
    ret = 'a';
     51d:	be 61 00 00 00       	mov    $0x61,%esi
     522:	e9 6d ff ff ff       	jmp    494 <gettoken+0x58>
     527:	90                   	nop
  switch(*s){
     528:	3c 26                	cmp    $0x26,%al
     52a:	74 08                	je     534 <gettoken+0xf8>
     52c:	8d 48 d8             	lea    -0x28(%eax),%ecx
     52f:	80 f9 01             	cmp    $0x1,%cl
     532:	77 a2                	ja     4d6 <gettoken+0x9a>
  ret = *s;
     534:	0f be f0             	movsbl %al,%esi
    s++;
     537:	47                   	inc    %edi
    break;
     538:	e9 57 ff ff ff       	jmp    494 <gettoken+0x58>
     53d:	8d 76 00             	lea    0x0(%esi),%esi
  switch(*s){
     540:	3c 3e                	cmp    $0x3e,%al
     542:	75 18                	jne    55c <gettoken+0x120>
    s++;
     544:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     547:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
     54b:	74 18                	je     565 <gettoken+0x129>
    s++;
     54d:	89 c7                	mov    %eax,%edi
     54f:	be 3e 00 00 00       	mov    $0x3e,%esi
     554:	e9 3b ff ff ff       	jmp    494 <gettoken+0x58>
     559:	8d 76 00             	lea    0x0(%esi),%esi
  switch(*s){
     55c:	3c 7c                	cmp    $0x7c,%al
     55e:	74 d4                	je     534 <gettoken+0xf8>
     560:	e9 71 ff ff ff       	jmp    4d6 <gettoken+0x9a>
      s++;
     565:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     568:	be 2b 00 00 00       	mov    $0x2b,%esi
     56d:	e9 22 ff ff ff       	jmp    494 <gettoken+0x58>
     572:	66 90                	xchg   %ax,%ax

00000574 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     574:	55                   	push   %ebp
     575:	89 e5                	mov    %esp,%ebp
     577:	57                   	push   %edi
     578:	56                   	push   %esi
     579:	53                   	push   %ebx
     57a:	83 ec 0c             	sub    $0xc,%esp
     57d:	8b 7d 08             	mov    0x8(%ebp),%edi
     580:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     583:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     585:	39 f3                	cmp    %esi,%ebx
     587:	72 08                	jb     591 <peek+0x1d>
     589:	eb 1e                	jmp    5a9 <peek+0x35>
     58b:	90                   	nop
    s++;
     58c:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
     58d:	39 de                	cmp    %ebx,%esi
     58f:	74 18                	je     5a9 <peek+0x35>
     591:	83 ec 08             	sub    $0x8,%esp
     594:	0f be 03             	movsbl (%ebx),%eax
     597:	50                   	push   %eax
     598:	68 c4 17 00 00       	push   $0x17c4
     59d:	e8 e6 04 00 00       	call   a88 <strchr>
     5a2:	83 c4 10             	add    $0x10,%esp
     5a5:	85 c0                	test   %eax,%eax
     5a7:	75 e3                	jne    58c <peek+0x18>
  *ps = s;
     5a9:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     5ab:	0f be 03             	movsbl (%ebx),%eax
     5ae:	84 c0                	test   %al,%al
     5b0:	75 0a                	jne    5bc <peek+0x48>
     5b2:	31 c0                	xor    %eax,%eax
}
     5b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5b7:	5b                   	pop    %ebx
     5b8:	5e                   	pop    %esi
     5b9:	5f                   	pop    %edi
     5ba:	5d                   	pop    %ebp
     5bb:	c3                   	ret    
  return *s && strchr(toks, *s);
     5bc:	83 ec 08             	sub    $0x8,%esp
     5bf:	50                   	push   %eax
     5c0:	ff 75 10             	pushl  0x10(%ebp)
     5c3:	e8 c0 04 00 00       	call   a88 <strchr>
     5c8:	83 c4 10             	add    $0x10,%esp
     5cb:	85 c0                	test   %eax,%eax
     5cd:	0f 95 c0             	setne  %al
     5d0:	0f b6 c0             	movzbl %al,%eax
}
     5d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5d6:	5b                   	pop    %ebx
     5d7:	5e                   	pop    %esi
     5d8:	5f                   	pop    %edi
     5d9:	5d                   	pop    %ebp
     5da:	c3                   	ret    
     5db:	90                   	nop

000005dc <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     5dc:	55                   	push   %ebp
     5dd:	89 e5                	mov    %esp,%ebp
     5df:	57                   	push   %edi
     5e0:	56                   	push   %esi
     5e1:	53                   	push   %ebx
     5e2:	83 ec 1c             	sub    $0x1c,%esp
     5e5:	8b 75 0c             	mov    0xc(%ebp),%esi
     5e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5eb:	90                   	nop
     5ec:	50                   	push   %eax
     5ed:	68 c5 10 00 00       	push   $0x10c5
     5f2:	53                   	push   %ebx
     5f3:	56                   	push   %esi
     5f4:	e8 7b ff ff ff       	call   574 <peek>
     5f9:	83 c4 10             	add    $0x10,%esp
     5fc:	85 c0                	test   %eax,%eax
     5fe:	74 60                	je     660 <parseredirs+0x84>
    tok = gettoken(ps, es, 0, 0);
     600:	6a 00                	push   $0x0
     602:	6a 00                	push   $0x0
     604:	53                   	push   %ebx
     605:	56                   	push   %esi
     606:	e8 31 fe ff ff       	call   43c <gettoken>
     60b:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     60d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     610:	50                   	push   %eax
     611:	8d 45 e0             	lea    -0x20(%ebp),%eax
     614:	50                   	push   %eax
     615:	53                   	push   %ebx
     616:	56                   	push   %esi
     617:	e8 20 fe ff ff       	call   43c <gettoken>
     61c:	83 c4 20             	add    $0x20,%esp
     61f:	83 f8 61             	cmp    $0x61,%eax
     622:	75 47                	jne    66b <parseredirs+0x8f>
      panic("missing file for redirection");
    switch(tok){
     624:	83 ff 3c             	cmp    $0x3c,%edi
     627:	74 2b                	je     654 <parseredirs+0x78>
     629:	83 ff 3e             	cmp    $0x3e,%edi
     62c:	74 05                	je     633 <parseredirs+0x57>
     62e:	83 ff 2b             	cmp    $0x2b,%edi
     631:	75 b9                	jne    5ec <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     633:	83 ec 0c             	sub    $0xc,%esp
     636:	6a 01                	push   $0x1
     638:	68 01 02 00 00       	push   $0x201
     63d:	ff 75 e4             	pushl  -0x1c(%ebp)
     640:	ff 75 e0             	pushl  -0x20(%ebp)
     643:	ff 75 08             	pushl  0x8(%ebp)
     646:	e8 09 fd ff ff       	call   354 <redircmd>
     64b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     64e:	83 c4 20             	add    $0x20,%esp
     651:	eb 99                	jmp    5ec <parseredirs+0x10>
     653:	90                   	nop
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     654:	83 ec 0c             	sub    $0xc,%esp
     657:	6a 00                	push   $0x0
     659:	6a 00                	push   $0x0
     65b:	eb e0                	jmp    63d <parseredirs+0x61>
     65d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  return cmd;
}
     660:	8b 45 08             	mov    0x8(%ebp),%eax
     663:	8d 65 f4             	lea    -0xc(%ebp),%esp
     666:	5b                   	pop    %ebx
     667:	5e                   	pop    %esi
     668:	5f                   	pop    %edi
     669:	5d                   	pop    %ebp
     66a:	c3                   	ret    
      panic("missing file for redirection");
     66b:	83 ec 0c             	sub    $0xc,%esp
     66e:	68 a8 10 00 00       	push   $0x10a8
     673:	e8 c8 fa ff ff       	call   140 <panic>

00000678 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     678:	55                   	push   %ebp
     679:	89 e5                	mov    %esp,%ebp
     67b:	57                   	push   %edi
     67c:	56                   	push   %esi
     67d:	53                   	push   %ebx
     67e:	83 ec 30             	sub    $0x30,%esp
     681:	8b 75 08             	mov    0x8(%ebp),%esi
     684:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     687:	68 c8 10 00 00       	push   $0x10c8
     68c:	57                   	push   %edi
     68d:	56                   	push   %esi
     68e:	e8 e1 fe ff ff       	call   574 <peek>
     693:	83 c4 10             	add    $0x10,%esp
     696:	85 c0                	test   %eax,%eax
     698:	0f 85 82 00 00 00    	jne    720 <parseexec+0xa8>
     69e:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     6a0:	e8 83 fc ff ff       	call   328 <execcmd>
     6a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6a8:	51                   	push   %ecx
     6a9:	57                   	push   %edi
     6aa:	56                   	push   %esi
     6ab:	50                   	push   %eax
     6ac:	e8 2b ff ff ff       	call   5dc <parseredirs>
     6b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     6b4:	83 c4 10             	add    $0x10,%esp
     6b7:	eb 14                	jmp    6cd <parseexec+0x55>
     6b9:	8d 76 00             	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     6bc:	52                   	push   %edx
     6bd:	57                   	push   %edi
     6be:	56                   	push   %esi
     6bf:	ff 75 d4             	pushl  -0x2c(%ebp)
     6c2:	e8 15 ff ff ff       	call   5dc <parseredirs>
     6c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     6ca:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
     6cd:	50                   	push   %eax
     6ce:	68 df 10 00 00       	push   $0x10df
     6d3:	57                   	push   %edi
     6d4:	56                   	push   %esi
     6d5:	e8 9a fe ff ff       	call   574 <peek>
     6da:	83 c4 10             	add    $0x10,%esp
     6dd:	85 c0                	test   %eax,%eax
     6df:	75 5b                	jne    73c <parseexec+0xc4>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     6e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     6e4:	50                   	push   %eax
     6e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
     6e8:	50                   	push   %eax
     6e9:	57                   	push   %edi
     6ea:	56                   	push   %esi
     6eb:	e8 4c fd ff ff       	call   43c <gettoken>
     6f0:	83 c4 10             	add    $0x10,%esp
     6f3:	85 c0                	test   %eax,%eax
     6f5:	74 45                	je     73c <parseexec+0xc4>
    if(tok != 'a')
     6f7:	83 f8 61             	cmp    $0x61,%eax
     6fa:	75 5f                	jne    75b <parseexec+0xe3>
    cmd->argv[argc] = q;
     6fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
     6ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
     702:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     709:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     70d:	43                   	inc    %ebx
    if(argc >= MAXARGS)
     70e:	83 fb 0a             	cmp    $0xa,%ebx
     711:	75 a9                	jne    6bc <parseexec+0x44>
      panic("too many args");
     713:	83 ec 0c             	sub    $0xc,%esp
     716:	68 d1 10 00 00       	push   $0x10d1
     71b:	e8 20 fa ff ff       	call   140 <panic>
    return parseblock(ps, es);
     720:	83 ec 08             	sub    $0x8,%esp
     723:	57                   	push   %edi
     724:	56                   	push   %esi
     725:	e8 3a 01 00 00       	call   864 <parseblock>
     72a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     72d:	83 c4 10             	add    $0x10,%esp
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     733:	8d 65 f4             	lea    -0xc(%ebp),%esp
     736:	5b                   	pop    %ebx
     737:	5e                   	pop    %esi
     738:	5f                   	pop    %edi
     739:	5d                   	pop    %ebp
     73a:	c3                   	ret    
     73b:	90                   	nop
  cmd->argv[argc] = 0;
     73c:	8b 45 d0             	mov    -0x30(%ebp),%eax
     73f:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     749:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     753:	8d 65 f4             	lea    -0xc(%ebp),%esp
     756:	5b                   	pop    %ebx
     757:	5e                   	pop    %esi
     758:	5f                   	pop    %edi
     759:	5d                   	pop    %ebp
     75a:	c3                   	ret    
      panic("syntax");
     75b:	83 ec 0c             	sub    $0xc,%esp
     75e:	68 ca 10 00 00       	push   $0x10ca
     763:	e8 d8 f9 ff ff       	call   140 <panic>

00000768 <parsepipe>:
{
     768:	55                   	push   %ebp
     769:	89 e5                	mov    %esp,%ebp
     76b:	57                   	push   %edi
     76c:	56                   	push   %esi
     76d:	53                   	push   %ebx
     76e:	83 ec 14             	sub    $0x14,%esp
     771:	8b 75 08             	mov    0x8(%ebp),%esi
     774:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     777:	57                   	push   %edi
     778:	56                   	push   %esi
     779:	e8 fa fe ff ff       	call   678 <parseexec>
     77e:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     780:	83 c4 0c             	add    $0xc,%esp
     783:	68 e4 10 00 00       	push   $0x10e4
     788:	57                   	push   %edi
     789:	56                   	push   %esi
     78a:	e8 e5 fd ff ff       	call   574 <peek>
     78f:	83 c4 10             	add    $0x10,%esp
     792:	85 c0                	test   %eax,%eax
     794:	75 0a                	jne    7a0 <parsepipe+0x38>
}
     796:	89 d8                	mov    %ebx,%eax
     798:	8d 65 f4             	lea    -0xc(%ebp),%esp
     79b:	5b                   	pop    %ebx
     79c:	5e                   	pop    %esi
     79d:	5f                   	pop    %edi
     79e:	5d                   	pop    %ebp
     79f:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     7a0:	6a 00                	push   $0x0
     7a2:	6a 00                	push   $0x0
     7a4:	57                   	push   %edi
     7a5:	56                   	push   %esi
     7a6:	e8 91 fc ff ff       	call   43c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7ab:	58                   	pop    %eax
     7ac:	5a                   	pop    %edx
     7ad:	57                   	push   %edi
     7ae:	56                   	push   %esi
     7af:	e8 b4 ff ff ff       	call   768 <parsepipe>
     7b4:	83 c4 10             	add    $0x10,%esp
     7b7:	89 45 0c             	mov    %eax,0xc(%ebp)
     7ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     7bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7c0:	5b                   	pop    %ebx
     7c1:	5e                   	pop    %esi
     7c2:	5f                   	pop    %edi
     7c3:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7c4:	e9 d3 fb ff ff       	jmp    39c <pipecmd>
     7c9:	8d 76 00             	lea    0x0(%esi),%esi

000007cc <parseline>:
{
     7cc:	55                   	push   %ebp
     7cd:	89 e5                	mov    %esp,%ebp
     7cf:	57                   	push   %edi
     7d0:	56                   	push   %esi
     7d1:	53                   	push   %ebx
     7d2:	83 ec 14             	sub    $0x14,%esp
     7d5:	8b 75 08             	mov    0x8(%ebp),%esi
     7d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     7db:	57                   	push   %edi
     7dc:	56                   	push   %esi
     7dd:	e8 86 ff ff ff       	call   768 <parsepipe>
     7e2:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     7e4:	83 c4 10             	add    $0x10,%esp
     7e7:	eb 1b                	jmp    804 <parseline+0x38>
     7e9:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     7ec:	6a 00                	push   $0x0
     7ee:	6a 00                	push   $0x0
     7f0:	57                   	push   %edi
     7f1:	56                   	push   %esi
     7f2:	e8 45 fc ff ff       	call   43c <gettoken>
    cmd = backcmd(cmd);
     7f7:	89 1c 24             	mov    %ebx,(%esp)
     7fa:	e8 0d fc ff ff       	call   40c <backcmd>
     7ff:	89 c3                	mov    %eax,%ebx
     801:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
     804:	50                   	push   %eax
     805:	68 e6 10 00 00       	push   $0x10e6
     80a:	57                   	push   %edi
     80b:	56                   	push   %esi
     80c:	e8 63 fd ff ff       	call   574 <peek>
     811:	83 c4 10             	add    $0x10,%esp
     814:	85 c0                	test   %eax,%eax
     816:	75 d4                	jne    7ec <parseline+0x20>
  if(peek(ps, es, ";")){
     818:	51                   	push   %ecx
     819:	68 e2 10 00 00       	push   $0x10e2
     81e:	57                   	push   %edi
     81f:	56                   	push   %esi
     820:	e8 4f fd ff ff       	call   574 <peek>
     825:	83 c4 10             	add    $0x10,%esp
     828:	85 c0                	test   %eax,%eax
     82a:	75 0c                	jne    838 <parseline+0x6c>
}
     82c:	89 d8                	mov    %ebx,%eax
     82e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     831:	5b                   	pop    %ebx
     832:	5e                   	pop    %esi
     833:	5f                   	pop    %edi
     834:	5d                   	pop    %ebp
     835:	c3                   	ret    
     836:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     838:	6a 00                	push   $0x0
     83a:	6a 00                	push   $0x0
     83c:	57                   	push   %edi
     83d:	56                   	push   %esi
     83e:	e8 f9 fb ff ff       	call   43c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     843:	58                   	pop    %eax
     844:	5a                   	pop    %edx
     845:	57                   	push   %edi
     846:	56                   	push   %esi
     847:	e8 80 ff ff ff       	call   7cc <parseline>
     84c:	83 c4 10             	add    $0x10,%esp
     84f:	89 45 0c             	mov    %eax,0xc(%ebp)
     852:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     855:	8d 65 f4             	lea    -0xc(%ebp),%esp
     858:	5b                   	pop    %ebx
     859:	5e                   	pop    %esi
     85a:	5f                   	pop    %edi
     85b:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     85c:	e9 73 fb ff ff       	jmp    3d4 <listcmd>
     861:	8d 76 00             	lea    0x0(%esi),%esi

00000864 <parseblock>:
{
     864:	55                   	push   %ebp
     865:	89 e5                	mov    %esp,%ebp
     867:	57                   	push   %edi
     868:	56                   	push   %esi
     869:	53                   	push   %ebx
     86a:	83 ec 10             	sub    $0x10,%esp
     86d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     870:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     873:	68 c8 10 00 00       	push   $0x10c8
     878:	56                   	push   %esi
     879:	53                   	push   %ebx
     87a:	e8 f5 fc ff ff       	call   574 <peek>
     87f:	83 c4 10             	add    $0x10,%esp
     882:	85 c0                	test   %eax,%eax
     884:	74 4a                	je     8d0 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     886:	6a 00                	push   $0x0
     888:	6a 00                	push   $0x0
     88a:	56                   	push   %esi
     88b:	53                   	push   %ebx
     88c:	e8 ab fb ff ff       	call   43c <gettoken>
  cmd = parseline(ps, es);
     891:	58                   	pop    %eax
     892:	5a                   	pop    %edx
     893:	56                   	push   %esi
     894:	53                   	push   %ebx
     895:	e8 32 ff ff ff       	call   7cc <parseline>
     89a:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     89c:	83 c4 0c             	add    $0xc,%esp
     89f:	68 04 11 00 00       	push   $0x1104
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
     8a6:	e8 c9 fc ff ff       	call   574 <peek>
     8ab:	83 c4 10             	add    $0x10,%esp
     8ae:	85 c0                	test   %eax,%eax
     8b0:	74 2b                	je     8dd <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     8b2:	6a 00                	push   $0x0
     8b4:	6a 00                	push   $0x0
     8b6:	56                   	push   %esi
     8b7:	53                   	push   %ebx
     8b8:	e8 7f fb ff ff       	call   43c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     8bd:	83 c4 0c             	add    $0xc,%esp
     8c0:	56                   	push   %esi
     8c1:	53                   	push   %ebx
     8c2:	57                   	push   %edi
     8c3:	e8 14 fd ff ff       	call   5dc <parseredirs>
}
     8c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8cb:	5b                   	pop    %ebx
     8cc:	5e                   	pop    %esi
     8cd:	5f                   	pop    %edi
     8ce:	5d                   	pop    %ebp
     8cf:	c3                   	ret    
    panic("parseblock");
     8d0:	83 ec 0c             	sub    $0xc,%esp
     8d3:	68 e8 10 00 00       	push   $0x10e8
     8d8:	e8 63 f8 ff ff       	call   140 <panic>
    panic("syntax - missing )");
     8dd:	83 ec 0c             	sub    $0xc,%esp
     8e0:	68 f3 10 00 00       	push   $0x10f3
     8e5:	e8 56 f8 ff ff       	call   140 <panic>
     8ea:	66 90                	xchg   %ax,%ax

000008ec <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     8ec:	55                   	push   %ebp
     8ed:	89 e5                	mov    %esp,%ebp
     8ef:	53                   	push   %ebx
     8f0:	53                   	push   %ebx
     8f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     8f4:	85 db                	test   %ebx,%ebx
     8f6:	0f 84 88 00 00 00    	je     984 <nulterminate+0x98>
    return 0;

  switch(cmd->type){
     8fc:	83 3b 05             	cmpl   $0x5,(%ebx)
     8ff:	77 5f                	ja     960 <nulterminate+0x74>
     901:	8b 03                	mov    (%ebx),%eax
     903:	ff 24 85 44 11 00 00 	jmp    *0x1144(,%eax,4)
     90a:	66 90                	xchg   %ax,%ax
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     90c:	83 ec 0c             	sub    $0xc,%esp
     90f:	ff 73 04             	pushl  0x4(%ebx)
     912:	e8 d5 ff ff ff       	call   8ec <nulterminate>
    nulterminate(lcmd->right);
     917:	58                   	pop    %eax
     918:	ff 73 08             	pushl  0x8(%ebx)
     91b:	e8 cc ff ff ff       	call   8ec <nulterminate>
    break;
     920:	83 c4 10             	add    $0x10,%esp
     923:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     928:	c9                   	leave  
     929:	c3                   	ret    
     92a:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     92c:	83 ec 0c             	sub    $0xc,%esp
     92f:	ff 73 04             	pushl  0x4(%ebx)
     932:	e8 b5 ff ff ff       	call   8ec <nulterminate>
    break;
     937:	83 c4 10             	add    $0x10,%esp
     93a:	89 d8                	mov    %ebx,%eax
}
     93c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     93f:	c9                   	leave  
     940:	c3                   	ret    
     941:	8d 76 00             	lea    0x0(%esi),%esi
     944:	8d 43 08             	lea    0x8(%ebx),%eax
    for(i=0; ecmd->argv[i]; i++)
     947:	8b 4b 04             	mov    0x4(%ebx),%ecx
     94a:	85 c9                	test   %ecx,%ecx
     94c:	74 12                	je     960 <nulterminate+0x74>
     94e:	66 90                	xchg   %ax,%ax
      *ecmd->eargv[i] = 0;
     950:	8b 50 24             	mov    0x24(%eax),%edx
     953:	c6 02 00             	movb   $0x0,(%edx)
     956:	83 c0 04             	add    $0x4,%eax
    for(i=0; ecmd->argv[i]; i++)
     959:	8b 50 fc             	mov    -0x4(%eax),%edx
     95c:	85 d2                	test   %edx,%edx
     95e:	75 f0                	jne    950 <nulterminate+0x64>
  switch(cmd->type){
     960:	89 d8                	mov    %ebx,%eax
}
     962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     965:	c9                   	leave  
     966:	c3                   	ret    
     967:	90                   	nop
    nulterminate(rcmd->cmd);
     968:	83 ec 0c             	sub    $0xc,%esp
     96b:	ff 73 04             	pushl  0x4(%ebx)
     96e:	e8 79 ff ff ff       	call   8ec <nulterminate>
    *rcmd->efile = 0;
     973:	8b 43 0c             	mov    0xc(%ebx),%eax
     976:	c6 00 00             	movb   $0x0,(%eax)
    break;
     979:	83 c4 10             	add    $0x10,%esp
     97c:	89 d8                	mov    %ebx,%eax
}
     97e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     981:	c9                   	leave  
     982:	c3                   	ret    
     983:	90                   	nop
    return 0;
     984:	31 c0                	xor    %eax,%eax
     986:	eb 9d                	jmp    925 <nulterminate+0x39>

00000988 <parsecmd>:
{
     988:	55                   	push   %ebp
     989:	89 e5                	mov    %esp,%ebp
     98b:	56                   	push   %esi
     98c:	53                   	push   %ebx
  es = s + strlen(s);
     98d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     990:	83 ec 0c             	sub    $0xc,%esp
     993:	53                   	push   %ebx
     994:	e8 af 00 00 00       	call   a48 <strlen>
     999:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     99b:	59                   	pop    %ecx
     99c:	5e                   	pop    %esi
     99d:	53                   	push   %ebx
     99e:	8d 45 08             	lea    0x8(%ebp),%eax
     9a1:	50                   	push   %eax
     9a2:	e8 25 fe ff ff       	call   7cc <parseline>
     9a7:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     9a9:	83 c4 0c             	add    $0xc,%esp
     9ac:	68 6b 11 00 00       	push   $0x116b
     9b1:	53                   	push   %ebx
     9b2:	8d 45 08             	lea    0x8(%ebp),%eax
     9b5:	50                   	push   %eax
     9b6:	e8 b9 fb ff ff       	call   574 <peek>
  if(s != es){
     9bb:	8b 45 08             	mov    0x8(%ebp),%eax
     9be:	83 c4 10             	add    $0x10,%esp
     9c1:	39 d8                	cmp    %ebx,%eax
     9c3:	75 12                	jne    9d7 <parsecmd+0x4f>
  nulterminate(cmd);
     9c5:	83 ec 0c             	sub    $0xc,%esp
     9c8:	56                   	push   %esi
     9c9:	e8 1e ff ff ff       	call   8ec <nulterminate>
}
     9ce:	89 f0                	mov    %esi,%eax
     9d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9d3:	5b                   	pop    %ebx
     9d4:	5e                   	pop    %esi
     9d5:	5d                   	pop    %ebp
     9d6:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     9d7:	52                   	push   %edx
     9d8:	50                   	push   %eax
     9d9:	68 06 11 00 00       	push   $0x1106
     9de:	6a 02                	push   $0x2
     9e0:	e8 83 03 00 00       	call   d68 <printf>
    panic("syntax");
     9e5:	c7 04 24 ca 10 00 00 	movl   $0x10ca,(%esp)
     9ec:	e8 4f f7 ff ff       	call   140 <panic>
     9f1:	66 90                	xchg   %ax,%ax
     9f3:	90                   	nop

000009f4 <strcpy>:
#include "fs.h"
#define PGSIZE 4096

char*
strcpy(char *s, const char *t)
{
     9f4:	55                   	push   %ebp
     9f5:	89 e5                	mov    %esp,%ebp
     9f7:	53                   	push   %ebx
     9f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
     9fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9fe:	31 c0                	xor    %eax,%eax
     a00:	8a 14 03             	mov    (%ebx,%eax,1),%dl
     a03:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     a06:	40                   	inc    %eax
     a07:	84 d2                	test   %dl,%dl
     a09:	75 f5                	jne    a00 <strcpy+0xc>
    ;
  return os;
}
     a0b:	89 c8                	mov    %ecx,%eax
     a0d:	5b                   	pop    %ebx
     a0e:	5d                   	pop    %ebp
     a0f:	c3                   	ret    

00000a10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	53                   	push   %ebx
     a14:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     a1a:	0f b6 03             	movzbl (%ebx),%eax
     a1d:	0f b6 0a             	movzbl (%edx),%ecx
     a20:	84 c0                	test   %al,%al
     a22:	75 10                	jne    a34 <strcmp+0x24>
     a24:	eb 1a                	jmp    a40 <strcmp+0x30>
     a26:	66 90                	xchg   %ax,%ax
    p++, q++;
     a28:	43                   	inc    %ebx
     a29:	42                   	inc    %edx
  while(*p && *p == *q)
     a2a:	0f b6 03             	movzbl (%ebx),%eax
     a2d:	0f b6 0a             	movzbl (%edx),%ecx
     a30:	84 c0                	test   %al,%al
     a32:	74 0c                	je     a40 <strcmp+0x30>
     a34:	38 c8                	cmp    %cl,%al
     a36:	74 f0                	je     a28 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     a38:	29 c8                	sub    %ecx,%eax
}
     a3a:	5b                   	pop    %ebx
     a3b:	5d                   	pop    %ebp
     a3c:	c3                   	ret    
     a3d:	8d 76 00             	lea    0x0(%esi),%esi
     a40:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     a42:	29 c8                	sub    %ecx,%eax
}
     a44:	5b                   	pop    %ebx
     a45:	5d                   	pop    %ebp
     a46:	c3                   	ret    
     a47:	90                   	nop

00000a48 <strlen>:

uint
strlen(const char *s)
{
     a48:	55                   	push   %ebp
     a49:	89 e5                	mov    %esp,%ebp
     a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     a4e:	80 3a 00             	cmpb   $0x0,(%edx)
     a51:	74 15                	je     a68 <strlen+0x20>
     a53:	31 c0                	xor    %eax,%eax
     a55:	8d 76 00             	lea    0x0(%esi),%esi
     a58:	40                   	inc    %eax
     a59:	89 c1                	mov    %eax,%ecx
     a5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     a5f:	75 f7                	jne    a58 <strlen+0x10>
    ;
  return n;
}
     a61:	89 c8                	mov    %ecx,%eax
     a63:	5d                   	pop    %ebp
     a64:	c3                   	ret    
     a65:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     a68:	31 c9                	xor    %ecx,%ecx
}
     a6a:	89 c8                	mov    %ecx,%eax
     a6c:	5d                   	pop    %ebp
     a6d:	c3                   	ret    
     a6e:	66 90                	xchg   %ax,%ax

00000a70 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a70:	55                   	push   %ebp
     a71:	89 e5                	mov    %esp,%ebp
     a73:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a74:	8b 7d 08             	mov    0x8(%ebp),%edi
     a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7d:	fc                   	cld    
     a7e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     a80:	8b 45 08             	mov    0x8(%ebp),%eax
     a83:	5f                   	pop    %edi
     a84:	5d                   	pop    %ebp
     a85:	c3                   	ret    
     a86:	66 90                	xchg   %ax,%ax

00000a88 <strchr>:

char*
strchr(const char *s, char c)
{
     a88:	55                   	push   %ebp
     a89:	89 e5                	mov    %esp,%ebp
     a8b:	8b 45 08             	mov    0x8(%ebp),%eax
     a8e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
     a91:	8a 10                	mov    (%eax),%dl
     a93:	84 d2                	test   %dl,%dl
     a95:	75 0c                	jne    aa3 <strchr+0x1b>
     a97:	eb 13                	jmp    aac <strchr+0x24>
     a99:	8d 76 00             	lea    0x0(%esi),%esi
     a9c:	40                   	inc    %eax
     a9d:	8a 10                	mov    (%eax),%dl
     a9f:	84 d2                	test   %dl,%dl
     aa1:	74 09                	je     aac <strchr+0x24>
    if(*s == c)
     aa3:	38 d1                	cmp    %dl,%cl
     aa5:	75 f5                	jne    a9c <strchr+0x14>
      return (char*)s;
  return 0;
}
     aa7:	5d                   	pop    %ebp
     aa8:	c3                   	ret    
     aa9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
     aac:	31 c0                	xor    %eax,%eax
}
     aae:	5d                   	pop    %ebp
     aaf:	c3                   	ret    

00000ab0 <gets>:

char*
gets(char *buf, int max)
{
     ab0:	55                   	push   %ebp
     ab1:	89 e5                	mov    %esp,%ebp
     ab3:	57                   	push   %edi
     ab4:	56                   	push   %esi
     ab5:	53                   	push   %ebx
     ab6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ab9:	8b 75 08             	mov    0x8(%ebp),%esi
     abc:	bb 01 00 00 00       	mov    $0x1,%ebx
     ac1:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
     ac3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
     ac6:	eb 20                	jmp    ae8 <gets+0x38>
    cc = read(0, &c, 1);
     ac8:	50                   	push   %eax
     ac9:	6a 01                	push   $0x1
     acb:	57                   	push   %edi
     acc:	6a 00                	push   $0x0
     ace:	e8 7b 01 00 00       	call   c4e <read>
    if(cc < 1)
     ad3:	83 c4 10             	add    $0x10,%esp
     ad6:	85 c0                	test   %eax,%eax
     ad8:	7e 16                	jle    af0 <gets+0x40>
      break;
    buf[i++] = c;
     ada:	8a 45 e7             	mov    -0x19(%ebp),%al
     add:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
     adf:	46                   	inc    %esi
     ae0:	3c 0a                	cmp    $0xa,%al
     ae2:	74 0c                	je     af0 <gets+0x40>
     ae4:	3c 0d                	cmp    $0xd,%al
     ae6:	74 08                	je     af0 <gets+0x40>
  for(i=0; i+1 < max; ){
     ae8:	8d 04 33             	lea    (%ebx,%esi,1),%eax
     aeb:	39 45 0c             	cmp    %eax,0xc(%ebp)
     aee:	7f d8                	jg     ac8 <gets+0x18>
      break;
  }
  buf[i] = '\0';
     af0:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
     af3:	8b 45 08             	mov    0x8(%ebp),%eax
     af6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     af9:	5b                   	pop    %ebx
     afa:	5e                   	pop    %esi
     afb:	5f                   	pop    %edi
     afc:	5d                   	pop    %ebp
     afd:	c3                   	ret    
     afe:	66 90                	xchg   %ax,%ax

00000b00 <stat>:

int
stat(const char *n, struct stat *st)
{
     b00:	55                   	push   %ebp
     b01:	89 e5                	mov    %esp,%ebp
     b03:	56                   	push   %esi
     b04:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b05:	83 ec 08             	sub    $0x8,%esp
     b08:	6a 00                	push   $0x0
     b0a:	ff 75 08             	pushl  0x8(%ebp)
     b0d:	e8 64 01 00 00       	call   c76 <open>
  if(fd < 0)
     b12:	83 c4 10             	add    $0x10,%esp
     b15:	85 c0                	test   %eax,%eax
     b17:	78 27                	js     b40 <stat+0x40>
     b19:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     b1b:	83 ec 08             	sub    $0x8,%esp
     b1e:	ff 75 0c             	pushl  0xc(%ebp)
     b21:	50                   	push   %eax
     b22:	e8 67 01 00 00       	call   c8e <fstat>
     b27:	89 c6                	mov    %eax,%esi
  close(fd);
     b29:	89 1c 24             	mov    %ebx,(%esp)
     b2c:	e8 2d 01 00 00       	call   c5e <close>
  return r;
     b31:	83 c4 10             	add    $0x10,%esp
}
     b34:	89 f0                	mov    %esi,%eax
     b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b39:	5b                   	pop    %ebx
     b3a:	5e                   	pop    %esi
     b3b:	5d                   	pop    %ebp
     b3c:	c3                   	ret    
     b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     b40:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b45:	eb ed                	jmp    b34 <stat+0x34>
     b47:	90                   	nop

00000b48 <atoi>:

int
atoi(const char *s)
{
     b48:	55                   	push   %ebp
     b49:	89 e5                	mov    %esp,%ebp
     b4b:	53                   	push   %ebx
     b4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b4f:	0f be 01             	movsbl (%ecx),%eax
     b52:	8d 50 d0             	lea    -0x30(%eax),%edx
     b55:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
     b58:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
     b5d:	77 16                	ja     b75 <atoi+0x2d>
     b5f:	90                   	nop
    n = n*10 + *s++ - '0';
     b60:	41                   	inc    %ecx
     b61:	8d 14 92             	lea    (%edx,%edx,4),%edx
     b64:	01 d2                	add    %edx,%edx
     b66:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
     b6a:	0f be 01             	movsbl (%ecx),%eax
     b6d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     b70:	80 fb 09             	cmp    $0x9,%bl
     b73:	76 eb                	jbe    b60 <atoi+0x18>
  return n;
}
     b75:	89 d0                	mov    %edx,%eax
     b77:	5b                   	pop    %ebx
     b78:	5d                   	pop    %ebp
     b79:	c3                   	ret    
     b7a:	66 90                	xchg   %ax,%ax

00000b7c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b7c:	55                   	push   %ebp
     b7d:	89 e5                	mov    %esp,%ebp
     b7f:	57                   	push   %edi
     b80:	56                   	push   %esi
     b81:	8b 45 08             	mov    0x8(%ebp),%eax
     b84:	8b 75 0c             	mov    0xc(%ebp),%esi
     b87:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     b8a:	85 d2                	test   %edx,%edx
     b8c:	7e 0b                	jle    b99 <memmove+0x1d>
     b8e:	01 c2                	add    %eax,%edx
  dst = vdst;
     b90:	89 c7                	mov    %eax,%edi
     b92:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     b94:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     b95:	39 fa                	cmp    %edi,%edx
     b97:	75 fb                	jne    b94 <memmove+0x18>
  return vdst;
}
     b99:	5e                   	pop    %esi
     b9a:	5f                   	pop    %edi
     b9b:	5d                   	pop    %ebp
     b9c:	c3                   	ret    
     b9d:	8d 76 00             	lea    0x0(%esi),%esi

00000ba0 <lock_init>:

// thread library
void lock_init(lock_t *lock) {
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
  lock->locked = 0;
     ba3:	8b 45 08             	mov    0x8(%ebp),%eax
     ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
     bac:	5d                   	pop    %ebp
     bad:	c3                   	ret    
     bae:	66 90                	xchg   %ax,%ax

00000bb0 <lock_acquire>:

void lock_acquire(lock_t *lock) {
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
     bb6:	b9 01 00 00 00       	mov    $0x1,%ecx
     bbb:	90                   	nop
     bbc:	89 c8                	mov    %ecx,%eax
     bbe:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&(lock->locked), 1) != 0);
     bc1:	85 c0                	test   %eax,%eax
     bc3:	75 f7                	jne    bbc <lock_acquire+0xc>
}
     bc5:	5d                   	pop    %ebp
     bc6:	c3                   	ret    
     bc7:	90                   	nop

00000bc8 <lock_release>:

void lock_release(lock_t *lock) {
     bc8:	55                   	push   %ebp
     bc9:	89 e5                	mov    %esp,%ebp
     bcb:	8b 55 08             	mov    0x8(%ebp),%edx
     bce:	31 c0                	xor    %eax,%eax
     bd0:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&(lock->locked), 0);
}
     bd3:	5d                   	pop    %ebp
     bd4:	c3                   	ret    
     bd5:	8d 76 00             	lea    0x0(%esi),%esi

00000bd8 <thread_create>:

void *thread_create(void*(start_routine)(void*), void *arg) {
     bd8:	55                   	push   %ebp
     bd9:	89 e5                	mov    %esp,%ebp
     bdb:	83 ec 14             	sub    $0x14,%esp
  void *stack = malloc(2 * PGSIZE);
     bde:	68 00 20 00 00       	push   $0x2000
     be3:	e8 94 03 00 00       	call   f7c <malloc>

  if((uint)stack % PGSIZE)
     be8:	83 c4 10             	add    $0x10,%esp
     beb:	89 c2                	mov    %eax,%edx
     bed:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
     bf3:	74 07                	je     bfc <thread_create+0x24>
		stack = stack + (PGSIZE - (uint)stack % PGSIZE);
     bf5:	29 d0                	sub    %edx,%eax
     bf7:	05 00 10 00 00       	add    $0x1000,%eax
  
  int size = 8;
  int tid = clone(start_routine, stack, size, arg);
     bfc:	ff 75 0c             	pushl  0xc(%ebp)
     bff:	6a 08                	push   $0x8
     c01:	50                   	push   %eax
     c02:	ff 75 08             	pushl  0x8(%ebp)
     c05:	e8 cc 00 00 00       	call   cd6 <clone>

  if (tid < 0) {
     c0a:	83 c4 10             	add    $0x10,%esp
     c0d:	85 c0                	test   %eax,%eax
     c0f:	78 07                	js     c18 <thread_create+0x40>
      printf(1, "# Clone failed\n");
      return 0;
  }

  return 0;
}
     c11:	31 c0                	xor    %eax,%eax
     c13:	c9                   	leave  
     c14:	c3                   	ret    
     c15:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "# Clone failed\n");
     c18:	83 ec 08             	sub    $0x8,%esp
     c1b:	68 5c 11 00 00       	push   $0x115c
     c20:	6a 01                	push   $0x1
     c22:	e8 41 01 00 00       	call   d68 <printf>
      return 0;
     c27:	83 c4 10             	add    $0x10,%esp
}
     c2a:	31 c0                	xor    %eax,%eax
     c2c:	c9                   	leave  
     c2d:	c3                   	ret    

00000c2e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c2e:	b8 01 00 00 00       	mov    $0x1,%eax
     c33:	cd 40                	int    $0x40
     c35:	c3                   	ret    

00000c36 <exit>:
SYSCALL(exit)
     c36:	b8 02 00 00 00       	mov    $0x2,%eax
     c3b:	cd 40                	int    $0x40
     c3d:	c3                   	ret    

00000c3e <wait>:
SYSCALL(wait)
     c3e:	b8 03 00 00 00       	mov    $0x3,%eax
     c43:	cd 40                	int    $0x40
     c45:	c3                   	ret    

00000c46 <pipe>:
SYSCALL(pipe)
     c46:	b8 04 00 00 00       	mov    $0x4,%eax
     c4b:	cd 40                	int    $0x40
     c4d:	c3                   	ret    

00000c4e <read>:
SYSCALL(read)
     c4e:	b8 05 00 00 00       	mov    $0x5,%eax
     c53:	cd 40                	int    $0x40
     c55:	c3                   	ret    

00000c56 <write>:
SYSCALL(write)
     c56:	b8 10 00 00 00       	mov    $0x10,%eax
     c5b:	cd 40                	int    $0x40
     c5d:	c3                   	ret    

00000c5e <close>:
SYSCALL(close)
     c5e:	b8 15 00 00 00       	mov    $0x15,%eax
     c63:	cd 40                	int    $0x40
     c65:	c3                   	ret    

00000c66 <kill>:
SYSCALL(kill)
     c66:	b8 06 00 00 00       	mov    $0x6,%eax
     c6b:	cd 40                	int    $0x40
     c6d:	c3                   	ret    

00000c6e <exec>:
SYSCALL(exec)
     c6e:	b8 07 00 00 00       	mov    $0x7,%eax
     c73:	cd 40                	int    $0x40
     c75:	c3                   	ret    

00000c76 <open>:
SYSCALL(open)
     c76:	b8 0f 00 00 00       	mov    $0xf,%eax
     c7b:	cd 40                	int    $0x40
     c7d:	c3                   	ret    

00000c7e <mknod>:
SYSCALL(mknod)
     c7e:	b8 11 00 00 00       	mov    $0x11,%eax
     c83:	cd 40                	int    $0x40
     c85:	c3                   	ret    

00000c86 <unlink>:
SYSCALL(unlink)
     c86:	b8 12 00 00 00       	mov    $0x12,%eax
     c8b:	cd 40                	int    $0x40
     c8d:	c3                   	ret    

00000c8e <fstat>:
SYSCALL(fstat)
     c8e:	b8 08 00 00 00       	mov    $0x8,%eax
     c93:	cd 40                	int    $0x40
     c95:	c3                   	ret    

00000c96 <link>:
SYSCALL(link)
     c96:	b8 13 00 00 00       	mov    $0x13,%eax
     c9b:	cd 40                	int    $0x40
     c9d:	c3                   	ret    

00000c9e <mkdir>:
SYSCALL(mkdir)
     c9e:	b8 14 00 00 00       	mov    $0x14,%eax
     ca3:	cd 40                	int    $0x40
     ca5:	c3                   	ret    

00000ca6 <chdir>:
SYSCALL(chdir)
     ca6:	b8 09 00 00 00       	mov    $0x9,%eax
     cab:	cd 40                	int    $0x40
     cad:	c3                   	ret    

00000cae <dup>:
SYSCALL(dup)
     cae:	b8 0a 00 00 00       	mov    $0xa,%eax
     cb3:	cd 40                	int    $0x40
     cb5:	c3                   	ret    

00000cb6 <getpid>:
SYSCALL(getpid)
     cb6:	b8 0b 00 00 00       	mov    $0xb,%eax
     cbb:	cd 40                	int    $0x40
     cbd:	c3                   	ret    

00000cbe <sbrk>:
SYSCALL(sbrk)
     cbe:	b8 0c 00 00 00       	mov    $0xc,%eax
     cc3:	cd 40                	int    $0x40
     cc5:	c3                   	ret    

00000cc6 <sleep>:
SYSCALL(sleep)
     cc6:	b8 0d 00 00 00       	mov    $0xd,%eax
     ccb:	cd 40                	int    $0x40
     ccd:	c3                   	ret    

00000cce <uptime>:
SYSCALL(uptime)
     cce:	b8 0e 00 00 00       	mov    $0xe,%eax
     cd3:	cd 40                	int    $0x40
     cd5:	c3                   	ret    

00000cd6 <clone>:
     cd6:	b8 16 00 00 00       	mov    $0x16,%eax
     cdb:	cd 40                	int    $0x40
     cdd:	c3                   	ret    
     cde:	66 90                	xchg   %ax,%ax

00000ce0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	57                   	push   %edi
     ce4:	56                   	push   %esi
     ce5:	53                   	push   %ebx
     ce6:	83 ec 3c             	sub    $0x3c,%esp
     ce9:	89 45 bc             	mov    %eax,-0x44(%ebp)
     cec:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     cef:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
     cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
     cf4:	85 db                	test   %ebx,%ebx
     cf6:	74 04                	je     cfc <printint+0x1c>
     cf8:	85 d2                	test   %edx,%edx
     cfa:	78 68                	js     d64 <printint+0x84>
  neg = 0;
     cfc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     d03:	31 ff                	xor    %edi,%edi
     d05:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
     d08:	89 c8                	mov    %ecx,%eax
     d0a:	31 d2                	xor    %edx,%edx
     d0c:	f7 75 c4             	divl   -0x3c(%ebp)
     d0f:	89 fb                	mov    %edi,%ebx
     d11:	8d 7f 01             	lea    0x1(%edi),%edi
     d14:	8a 92 74 11 00 00    	mov    0x1174(%edx),%dl
     d1a:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
     d1e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  }while((x /= base) != 0);
     d21:	89 c1                	mov    %eax,%ecx
     d23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     d26:	3b 45 c0             	cmp    -0x40(%ebp),%eax
     d29:	76 dd                	jbe    d08 <printint+0x28>
  if(neg)
     d2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d2e:	85 c9                	test   %ecx,%ecx
     d30:	74 09                	je     d3b <printint+0x5b>
    buf[i++] = '-';
     d32:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
     d37:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
     d39:	b2 2d                	mov    $0x2d,%dl
     d3b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
     d3f:	8b 7d bc             	mov    -0x44(%ebp),%edi
     d42:	eb 03                	jmp    d47 <printint+0x67>
     d44:	8a 13                	mov    (%ebx),%dl
     d46:	4b                   	dec    %ebx

  while(--i >= 0)
    putc(fd, buf[i]);
     d47:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
     d4a:	50                   	push   %eax
     d4b:	6a 01                	push   $0x1
     d4d:	56                   	push   %esi
     d4e:	57                   	push   %edi
     d4f:	e8 02 ff ff ff       	call   c56 <write>
  while(--i >= 0)
     d54:	83 c4 10             	add    $0x10,%esp
     d57:	39 de                	cmp    %ebx,%esi
     d59:	75 e9                	jne    d44 <printint+0x64>
}
     d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d5e:	5b                   	pop    %ebx
     d5f:	5e                   	pop    %esi
     d60:	5f                   	pop    %edi
     d61:	5d                   	pop    %ebp
     d62:	c3                   	ret    
     d63:	90                   	nop
    x = -xx;
     d64:	f7 d9                	neg    %ecx
     d66:	eb 9b                	jmp    d03 <printint+0x23>

00000d68 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     d68:	55                   	push   %ebp
     d69:	89 e5                	mov    %esp,%ebp
     d6b:	57                   	push   %edi
     d6c:	56                   	push   %esi
     d6d:	53                   	push   %ebx
     d6e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d71:	8b 75 0c             	mov    0xc(%ebp),%esi
     d74:	8a 1e                	mov    (%esi),%bl
     d76:	84 db                	test   %bl,%bl
     d78:	0f 84 a3 00 00 00    	je     e21 <printf+0xb9>
     d7e:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
     d7f:	8d 45 10             	lea    0x10(%ebp),%eax
     d82:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
     d85:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
     d87:	8d 7d e7             	lea    -0x19(%ebp),%edi
     d8a:	eb 29                	jmp    db5 <printf+0x4d>
     d8c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     d8f:	83 f8 25             	cmp    $0x25,%eax
     d92:	0f 84 94 00 00 00    	je     e2c <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
     d98:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     d9b:	50                   	push   %eax
     d9c:	6a 01                	push   $0x1
     d9e:	57                   	push   %edi
     d9f:	ff 75 08             	pushl  0x8(%ebp)
     da2:	e8 af fe ff ff       	call   c56 <write>
        putc(fd, c);
     da7:	83 c4 10             	add    $0x10,%esp
     daa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     dad:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
     dae:	8a 5e ff             	mov    -0x1(%esi),%bl
     db1:	84 db                	test   %bl,%bl
     db3:	74 6c                	je     e21 <printf+0xb9>
    c = fmt[i] & 0xff;
     db5:	0f be cb             	movsbl %bl,%ecx
     db8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     dbb:	85 d2                	test   %edx,%edx
     dbd:	74 cd                	je     d8c <printf+0x24>
      }
    } else if(state == '%'){
     dbf:	83 fa 25             	cmp    $0x25,%edx
     dc2:	75 e9                	jne    dad <printf+0x45>
      if(c == 'd'){
     dc4:	83 f8 64             	cmp    $0x64,%eax
     dc7:	0f 84 97 00 00 00    	je     e64 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     dcd:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     dd3:	83 f9 70             	cmp    $0x70,%ecx
     dd6:	74 60                	je     e38 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     dd8:	83 f8 73             	cmp    $0x73,%eax
     ddb:	0f 84 8f 00 00 00    	je     e70 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     de1:	83 f8 63             	cmp    $0x63,%eax
     de4:	0f 84 d6 00 00 00    	je     ec0 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     dea:	83 f8 25             	cmp    $0x25,%eax
     ded:	0f 84 c1 00 00 00    	je     eb4 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     df3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
     df7:	50                   	push   %eax
     df8:	6a 01                	push   $0x1
     dfa:	57                   	push   %edi
     dfb:	ff 75 08             	pushl  0x8(%ebp)
     dfe:	e8 53 fe ff ff       	call   c56 <write>
        putc(fd, c);
     e03:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     e06:	83 c4 0c             	add    $0xc,%esp
     e09:	6a 01                	push   $0x1
     e0b:	57                   	push   %edi
     e0c:	ff 75 08             	pushl  0x8(%ebp)
     e0f:	e8 42 fe ff ff       	call   c56 <write>
        putc(fd, c);
     e14:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     e17:	31 d2                	xor    %edx,%edx
     e19:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
     e1a:	8a 5e ff             	mov    -0x1(%esi),%bl
     e1d:	84 db                	test   %bl,%bl
     e1f:	75 94                	jne    db5 <printf+0x4d>
    }
  }
}
     e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e24:	5b                   	pop    %ebx
     e25:	5e                   	pop    %esi
     e26:	5f                   	pop    %edi
     e27:	5d                   	pop    %ebp
     e28:	c3                   	ret    
     e29:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
     e2c:	ba 25 00 00 00       	mov    $0x25,%edx
     e31:	e9 77 ff ff ff       	jmp    dad <printf+0x45>
     e36:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
     e38:	83 ec 0c             	sub    $0xc,%esp
     e3b:	6a 00                	push   $0x0
     e3d:	b9 10 00 00 00       	mov    $0x10,%ecx
     e42:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     e45:	8b 13                	mov    (%ebx),%edx
     e47:	8b 45 08             	mov    0x8(%ebp),%eax
     e4a:	e8 91 fe ff ff       	call   ce0 <printint>
        ap++;
     e4f:	89 d8                	mov    %ebx,%eax
     e51:	83 c0 04             	add    $0x4,%eax
     e54:	89 45 d0             	mov    %eax,-0x30(%ebp)
     e57:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e5a:	31 d2                	xor    %edx,%edx
        ap++;
     e5c:	e9 4c ff ff ff       	jmp    dad <printf+0x45>
     e61:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
     e64:	83 ec 0c             	sub    $0xc,%esp
     e67:	6a 01                	push   $0x1
     e69:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e6e:	eb d2                	jmp    e42 <printf+0xda>
        s = (char*)*ap;
     e70:	8b 45 d0             	mov    -0x30(%ebp),%eax
     e73:	8b 18                	mov    (%eax),%ebx
        ap++;
     e75:	83 c0 04             	add    $0x4,%eax
     e78:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     e7b:	85 db                	test   %ebx,%ebx
     e7d:	74 65                	je     ee4 <printf+0x17c>
        while(*s != 0){
     e7f:	8a 03                	mov    (%ebx),%al
     e81:	84 c0                	test   %al,%al
     e83:	74 70                	je     ef5 <printf+0x18d>
     e85:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     e88:	89 de                	mov    %ebx,%esi
     e8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
     e8d:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
     e90:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     e93:	50                   	push   %eax
     e94:	6a 01                	push   $0x1
     e96:	57                   	push   %edi
     e97:	53                   	push   %ebx
     e98:	e8 b9 fd ff ff       	call   c56 <write>
          s++;
     e9d:	46                   	inc    %esi
        while(*s != 0){
     e9e:	8a 06                	mov    (%esi),%al
     ea0:	83 c4 10             	add    $0x10,%esp
     ea3:	84 c0                	test   %al,%al
     ea5:	75 e9                	jne    e90 <printf+0x128>
     ea7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
     eaa:	31 d2                	xor    %edx,%edx
     eac:	e9 fc fe ff ff       	jmp    dad <printf+0x45>
     eb1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
     eb4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     eb7:	52                   	push   %edx
     eb8:	e9 4c ff ff ff       	jmp    e09 <printf+0xa1>
     ebd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
     ec0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     ec3:	8b 03                	mov    (%ebx),%eax
     ec5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     ec8:	51                   	push   %ecx
     ec9:	6a 01                	push   $0x1
     ecb:	57                   	push   %edi
     ecc:	ff 75 08             	pushl  0x8(%ebp)
     ecf:	e8 82 fd ff ff       	call   c56 <write>
        ap++;
     ed4:	83 c3 04             	add    $0x4,%ebx
     ed7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     eda:	83 c4 10             	add    $0x10,%esp
      state = 0;
     edd:	31 d2                	xor    %edx,%edx
     edf:	e9 c9 fe ff ff       	jmp    dad <printf+0x45>
          s = "(null)";
     ee4:	bb 6c 11 00 00       	mov    $0x116c,%ebx
        while(*s != 0){
     ee9:	b0 28                	mov    $0x28,%al
     eeb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     eee:	89 de                	mov    %ebx,%esi
     ef0:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ef3:	eb 9b                	jmp    e90 <printf+0x128>
      state = 0;
     ef5:	31 d2                	xor    %edx,%edx
     ef7:	e9 b1 fe ff ff       	jmp    dad <printf+0x45>

00000efc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     efc:	55                   	push   %ebp
     efd:	89 e5                	mov    %esp,%ebp
     eff:	57                   	push   %edi
     f00:	56                   	push   %esi
     f01:	53                   	push   %ebx
     f02:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f05:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f08:	a1 44 18 00 00       	mov    0x1844,%eax
     f0d:	8b 10                	mov    (%eax),%edx
     f0f:	39 c8                	cmp    %ecx,%eax
     f11:	73 11                	jae    f24 <free+0x28>
     f13:	90                   	nop
     f14:	39 d1                	cmp    %edx,%ecx
     f16:	72 14                	jb     f2c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f18:	39 d0                	cmp    %edx,%eax
     f1a:	73 10                	jae    f2c <free+0x30>
{
     f1c:	89 d0                	mov    %edx,%eax
     f1e:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f20:	39 c8                	cmp    %ecx,%eax
     f22:	72 f0                	jb     f14 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f24:	39 d0                	cmp    %edx,%eax
     f26:	72 f4                	jb     f1c <free+0x20>
     f28:	39 d1                	cmp    %edx,%ecx
     f2a:	73 f0                	jae    f1c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f2c:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f2f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f32:	39 fa                	cmp    %edi,%edx
     f34:	74 1a                	je     f50 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f36:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f39:	8b 50 04             	mov    0x4(%eax),%edx
     f3c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f3f:	39 f1                	cmp    %esi,%ecx
     f41:	74 24                	je     f67 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f43:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f45:	a3 44 18 00 00       	mov    %eax,0x1844
}
     f4a:	5b                   	pop    %ebx
     f4b:	5e                   	pop    %esi
     f4c:	5f                   	pop    %edi
     f4d:	5d                   	pop    %ebp
     f4e:	c3                   	ret    
     f4f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
     f50:	03 72 04             	add    0x4(%edx),%esi
     f53:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f56:	8b 10                	mov    (%eax),%edx
     f58:	8b 12                	mov    (%edx),%edx
     f5a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f5d:	8b 50 04             	mov    0x4(%eax),%edx
     f60:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f63:	39 f1                	cmp    %esi,%ecx
     f65:	75 dc                	jne    f43 <free+0x47>
    p->s.size += bp->s.size;
     f67:	03 53 fc             	add    -0x4(%ebx),%edx
     f6a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f6d:	8b 53 f8             	mov    -0x8(%ebx),%edx
     f70:	89 10                	mov    %edx,(%eax)
  freep = p;
     f72:	a3 44 18 00 00       	mov    %eax,0x1844
}
     f77:	5b                   	pop    %ebx
     f78:	5e                   	pop    %esi
     f79:	5f                   	pop    %edi
     f7a:	5d                   	pop    %ebp
     f7b:	c3                   	ret    

00000f7c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f7c:	55                   	push   %ebp
     f7d:	89 e5                	mov    %esp,%ebp
     f7f:	57                   	push   %edi
     f80:	56                   	push   %esi
     f81:	53                   	push   %ebx
     f82:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f85:	8b 45 08             	mov    0x8(%ebp),%eax
     f88:	8d 70 07             	lea    0x7(%eax),%esi
     f8b:	c1 ee 03             	shr    $0x3,%esi
     f8e:	46                   	inc    %esi
  if((prevp = freep) == 0){
     f8f:	8b 3d 44 18 00 00    	mov    0x1844,%edi
     f95:	85 ff                	test   %edi,%edi
     f97:	0f 84 a3 00 00 00    	je     1040 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f9d:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
     f9f:	8b 48 04             	mov    0x4(%eax),%ecx
     fa2:	39 f1                	cmp    %esi,%ecx
     fa4:	73 67                	jae    100d <malloc+0x91>
     fa6:	89 f3                	mov    %esi,%ebx
     fa8:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
     fae:	0f 82 80 00 00 00    	jb     1034 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
     fb4:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
     fbb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
     fbe:	eb 11                	jmp    fd1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fc0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
     fc2:	8b 4a 04             	mov    0x4(%edx),%ecx
     fc5:	39 f1                	cmp    %esi,%ecx
     fc7:	73 4b                	jae    1014 <malloc+0x98>
     fc9:	8b 3d 44 18 00 00    	mov    0x1844,%edi
     fcf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fd1:	39 c7                	cmp    %eax,%edi
     fd3:	75 eb                	jne    fc0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
     fd5:	83 ec 0c             	sub    $0xc,%esp
     fd8:	ff 75 e4             	pushl  -0x1c(%ebp)
     fdb:	e8 de fc ff ff       	call   cbe <sbrk>
  if(p == (char*)-1)
     fe0:	83 c4 10             	add    $0x10,%esp
     fe3:	83 f8 ff             	cmp    $0xffffffff,%eax
     fe6:	74 1b                	je     1003 <malloc+0x87>
  hp->s.size = nu;
     fe8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     feb:	83 ec 0c             	sub    $0xc,%esp
     fee:	83 c0 08             	add    $0x8,%eax
     ff1:	50                   	push   %eax
     ff2:	e8 05 ff ff ff       	call   efc <free>
  return freep;
     ff7:	a1 44 18 00 00       	mov    0x1844,%eax
      if((p = morecore(nunits)) == 0)
     ffc:	83 c4 10             	add    $0x10,%esp
     fff:	85 c0                	test   %eax,%eax
    1001:	75 bd                	jne    fc0 <malloc+0x44>
        return 0;
    1003:	31 c0                	xor    %eax,%eax
  }
}
    1005:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1008:	5b                   	pop    %ebx
    1009:	5e                   	pop    %esi
    100a:	5f                   	pop    %edi
    100b:	5d                   	pop    %ebp
    100c:	c3                   	ret    
    if(p->s.size >= nunits){
    100d:	89 c2                	mov    %eax,%edx
    100f:	89 f8                	mov    %edi,%eax
    1011:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1014:	39 ce                	cmp    %ecx,%esi
    1016:	74 54                	je     106c <malloc+0xf0>
        p->s.size -= nunits;
    1018:	29 f1                	sub    %esi,%ecx
    101a:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    101d:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1020:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1023:	a3 44 18 00 00       	mov    %eax,0x1844
      return (void*)(p + 1);
    1028:	8d 42 08             	lea    0x8(%edx),%eax
}
    102b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    102e:	5b                   	pop    %ebx
    102f:	5e                   	pop    %esi
    1030:	5f                   	pop    %edi
    1031:	5d                   	pop    %ebp
    1032:	c3                   	ret    
    1033:	90                   	nop
    1034:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1039:	e9 76 ff ff ff       	jmp    fb4 <malloc+0x38>
    103e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1040:	c7 05 44 18 00 00 48 	movl   $0x1848,0x1844
    1047:	18 00 00 
    104a:	c7 05 48 18 00 00 48 	movl   $0x1848,0x1848
    1051:	18 00 00 
    base.s.size = 0;
    1054:	c7 05 4c 18 00 00 00 	movl   $0x0,0x184c
    105b:	00 00 00 
    105e:	bf 48 18 00 00       	mov    $0x1848,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1063:	89 f8                	mov    %edi,%eax
    1065:	e9 3c ff ff ff       	jmp    fa6 <malloc+0x2a>
    106a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
    106c:	8b 0a                	mov    (%edx),%ecx
    106e:	89 08                	mov    %ecx,(%eax)
    1070:	eb b1                	jmp    1023 <malloc+0xa7>

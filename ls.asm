
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  11:	bb 01 00 00 00       	mov    $0x1,%ebx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	pushl  (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
  exit();
  3d:	e8 50 05 00 00       	call   592 <exit>
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 58 0a 00 00       	push   $0xa58
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 3e 05 00 00       	call   592 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 4f 03 00 00       	call   3c0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 28 03 00 00       	call   3c0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 17 03 00 00       	call   3c0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 6c 0d 00 00       	push   $0xd6c
  b3:	e8 a8 04 00 00       	call   560 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 00 03 00 00       	call   3c0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb 6c 0d 00 00       	mov    $0xd6c,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 f1 02 00 00       	call   3c0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 6c 0d 00 00       	add    $0xd6c,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 09 03 00 00       	call   3f0 <memset>
  return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 bb 04 00 00       	call   5d2 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 9e 01 00 00    	js     2c0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 122:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 b6 04 00 00       	call   5ea <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 c1 01 00 00    	js     300 <ls+0x200>
  switch(st.type){
 13f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	74 54                	je     1a0 <ls+0xa0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	75 37                	jne    189 <ls+0x89>
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 15b:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 161:	57                   	push   %edi
 162:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 168:	e8 f3 fe ff ff       	call   60 <fmtname>
 16d:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 173:	59                   	pop    %ecx
 174:	5f                   	pop    %edi
 175:	52                   	push   %edx
 176:	56                   	push   %esi
 177:	6a 02                	push   $0x2
 179:	50                   	push   %eax
 17a:	68 38 0a 00 00       	push   $0xa38
 17f:	6a 01                	push   $0x1
 181:	e8 6a 05 00 00       	call   6f0 <printf>
    break;
 186:	83 c4 20             	add    $0x20,%esp
  close(fd);
 189:	83 ec 0c             	sub    $0xc,%esp
 18c:	53                   	push   %ebx
 18d:	e8 28 04 00 00       	call   5ba <close>
 192:	83 c4 10             	add    $0x10,%esp
}
 195:	8d 65 f4             	lea    -0xc(%ebp),%esp
 198:	5b                   	pop    %ebx
 199:	5e                   	pop    %esi
 19a:	5f                   	pop    %edi
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a0:	83 ec 0c             	sub    $0xc,%esp
 1a3:	57                   	push   %edi
 1a4:	e8 17 02 00 00       	call   3c0 <strlen>
 1a9:	83 c0 10             	add    $0x10,%eax
 1ac:	83 c4 10             	add    $0x10,%esp
 1af:	3d 00 02 00 00       	cmp    $0x200,%eax
 1b4:	0f 87 26 01 00 00    	ja     2e0 <ls+0x1e0>
    strcpy(buf, path);
 1ba:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	57                   	push   %edi
 1c4:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1ca:	50                   	push   %eax
 1cb:	e8 70 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1d0:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 e2 01 00 00       	call   3c0 <strlen>
 1de:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e4:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    *p++ = '/';
 1ea:	8d 84 05 e9 fd ff ff 	lea    -0x217(%ebp,%eax,1),%eax
    p = buf+strlen(buf);
 1f1:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1f7:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1fd:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 10                	push   $0x10
 205:	57                   	push   %edi
 206:	53                   	push   %ebx
 207:	e8 9e 03 00 00       	call   5aa <read>
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	83 f8 10             	cmp    $0x10,%eax
 212:	0f 85 71 ff ff ff    	jne    189 <ls+0x89>
      if(de.inum == 0)
 218:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 21f:	00 
 220:	74 de                	je     200 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 222:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	6a 0e                	push   $0xe
 22d:	50                   	push   %eax
 22e:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 234:	e8 27 03 00 00       	call   560 <memmove>
      p[DIRSIZ] = 0;
 239:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 23f:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 243:	58                   	pop    %eax
 244:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 24a:	5a                   	pop    %edx
 24b:	56                   	push   %esi
 24c:	50                   	push   %eax
 24d:	e8 7e 02 00 00       	call   4d0 <stat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	0f 88 c3 00 00 00    	js     320 <ls+0x220>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25d:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 263:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 26a:	83 ec 0c             	sub    $0xc,%esp
 26d:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 273:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 279:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 27f:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 285:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 28b:	51                   	push   %ecx
 28c:	e8 cf fd ff ff       	call   60 <fmtname>
 291:	5a                   	pop    %edx
 292:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 298:	59                   	pop    %ecx
 299:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 29f:	51                   	push   %ecx
 2a0:	52                   	push   %edx
 2a1:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2a7:	50                   	push   %eax
 2a8:	68 38 0a 00 00       	push   $0xa38
 2ad:	6a 01                	push   $0x1
 2af:	e8 3c 04 00 00       	call   6f0 <printf>
 2b4:	83 c4 20             	add    $0x20,%esp
 2b7:	e9 44 ff ff ff       	jmp    200 <ls+0x100>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	57                   	push   %edi
 2c4:	68 10 0a 00 00       	push   $0xa10
 2c9:	6a 02                	push   $0x2
 2cb:	e8 20 04 00 00       	call   6f0 <printf>
    return;
 2d0:	83 c4 10             	add    $0x10,%esp
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "ls: path too long\n");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 45 0a 00 00       	push   $0xa45
 2e8:	6a 01                	push   $0x1
 2ea:	e8 01 04 00 00       	call   6f0 <printf>
      break;
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	e9 92 fe ff ff       	jmp    189 <ls+0x89>
 2f7:	89 f6                	mov    %esi,%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "ls: cannot stat %s\n", path);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	57                   	push   %edi
 304:	68 24 0a 00 00       	push   $0xa24
 309:	6a 02                	push   $0x2
 30b:	e8 e0 03 00 00       	call   6f0 <printf>
    close(fd);
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	e8 a2 02 00 00       	call   5ba <close>
    return;
 318:	83 c4 10             	add    $0x10,%esp
 31b:	e9 75 fe ff ff       	jmp    195 <ls+0x95>
        printf(1, "ls: cannot stat %s\n", buf);
 320:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 326:	83 ec 04             	sub    $0x4,%esp
 329:	50                   	push   %eax
 32a:	68 24 0a 00 00       	push   $0xa24
 32f:	6a 01                	push   $0x1
 331:	e8 ba 03 00 00       	call   6f0 <printf>
        continue;
 336:	83 c4 10             	add    $0x10,%esp
 339:	e9 c2 fe ff ff       	jmp    200 <ls+0x100>
 33e:	66 90                	xchg   %ax,%ax

00000340 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 34a:	89 c2                	mov    %eax,%edx
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 350:	83 c1 01             	add    $0x1,%ecx
 353:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 357:	83 c2 01             	add    $0x1,%edx
 35a:	84 db                	test   %bl,%bl
 35c:	88 5a ff             	mov    %bl,-0x1(%edx)
 35f:	75 ef                	jne    350 <strcpy+0x10>
    ;
  return os;
}
 361:	5b                   	pop    %ebx
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
 364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 36a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 37a:	0f b6 02             	movzbl (%edx),%eax
 37d:	0f b6 19             	movzbl (%ecx),%ebx
 380:	84 c0                	test   %al,%al
 382:	75 1c                	jne    3a0 <strcmp+0x30>
 384:	eb 2a                	jmp    3b0 <strcmp+0x40>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 390:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 393:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 396:	83 c1 01             	add    $0x1,%ecx
 399:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 39c:	84 c0                	test   %al,%al
 39e:	74 10                	je     3b0 <strcmp+0x40>
 3a0:	38 d8                	cmp    %bl,%al
 3a2:	74 ec                	je     390 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3a4:	29 d8                	sub    %ebx,%eax
}
 3a6:	5b                   	pop    %ebx
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3b2:	29 d8                	sub    %ebx,%eax
}
 3b4:	5b                   	pop    %ebx
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3c6:	80 39 00             	cmpb   $0x0,(%ecx)
 3c9:	74 15                	je     3e0 <strlen+0x20>
 3cb:	31 d2                	xor    %edx,%edx
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	83 c2 01             	add    $0x1,%edx
 3d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	75 f5                	jne    3d0 <strlen+0x10>
    ;
  return n;
}
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3e0:	31 c0                	xor    %eax,%eax
}
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 d7                	mov    %edx,%edi
 3ff:	fc                   	cld    
 400:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 402:	89 d0                	mov    %edx,%eax
 404:	5f                   	pop    %edi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <strchr>:

char*
strchr(const char *s, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 41a:	0f b6 10             	movzbl (%eax),%edx
 41d:	84 d2                	test   %dl,%dl
 41f:	74 1d                	je     43e <strchr+0x2e>
    if(*s == c)
 421:	38 d3                	cmp    %dl,%bl
 423:	89 d9                	mov    %ebx,%ecx
 425:	75 0d                	jne    434 <strchr+0x24>
 427:	eb 17                	jmp    440 <strchr+0x30>
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 430:	38 ca                	cmp    %cl,%dl
 432:	74 0c                	je     440 <strchr+0x30>
  for(; *s; s++)
 434:	83 c0 01             	add    $0x1,%eax
 437:	0f b6 10             	movzbl (%eax),%edx
 43a:	84 d2                	test   %dl,%dl
 43c:	75 f2                	jne    430 <strchr+0x20>
      return (char*)s;
  return 0;
 43e:	31 c0                	xor    %eax,%eax
}
 440:	5b                   	pop    %ebx
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    
 443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <gets>:

char*
gets(char *buf, int max)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 456:	31 f6                	xor    %esi,%esi
 458:	89 f3                	mov    %esi,%ebx
{
 45a:	83 ec 1c             	sub    $0x1c,%esp
 45d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 460:	eb 2f                	jmp    491 <gets+0x41>
 462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 468:	8d 45 e7             	lea    -0x19(%ebp),%eax
 46b:	83 ec 04             	sub    $0x4,%esp
 46e:	6a 01                	push   $0x1
 470:	50                   	push   %eax
 471:	6a 00                	push   $0x0
 473:	e8 32 01 00 00       	call   5aa <read>
    if(cc < 1)
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	7e 1c                	jle    49b <gets+0x4b>
      break;
    buf[i++] = c;
 47f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 483:	83 c7 01             	add    $0x1,%edi
 486:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 489:	3c 0a                	cmp    $0xa,%al
 48b:	74 23                	je     4b0 <gets+0x60>
 48d:	3c 0d                	cmp    $0xd,%al
 48f:	74 1f                	je     4b0 <gets+0x60>
  for(i=0; i+1 < max; ){
 491:	83 c3 01             	add    $0x1,%ebx
 494:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 497:	89 fe                	mov    %edi,%esi
 499:	7c cd                	jl     468 <gets+0x18>
 49b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    
 4ab:	90                   	nop
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b0:	8b 75 08             	mov    0x8(%ebp),%esi
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	01 de                	add    %ebx,%esi
 4b8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 4bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c0:	5b                   	pop    %ebx
 4c1:	5e                   	pop    %esi
 4c2:	5f                   	pop    %edi
 4c3:	5d                   	pop    %ebp
 4c4:	c3                   	ret    
 4c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <stat>:

int
stat(char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 f0 00 00 00       	call   5d2 <open>
  if(fd < 0)
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	pushl  0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 f3 00 00 00       	call   5ea <fstat>
  close(fd);
 4f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4fa:	89 c6                	mov    %eax,%esi
  close(fd);
 4fc:	e8 b9 00 00 00       	call   5ba <close>
  return r;
 501:	83 c4 10             	add    $0x10,%esp
}
 504:	8d 65 f8             	lea    -0x8(%ebp),%esp
 507:	89 f0                	mov    %esi,%eax
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
 515:	eb ed                	jmp    504 <stat+0x34>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <atoi>:

int
atoi(const char *s)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 527:	0f be 11             	movsbl (%ecx),%edx
 52a:	8d 42 d0             	lea    -0x30(%edx),%eax
 52d:	3c 09                	cmp    $0x9,%al
  n = 0;
 52f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 534:	77 1f                	ja     555 <atoi+0x35>
 536:	8d 76 00             	lea    0x0(%esi),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 540:	8d 04 80             	lea    (%eax,%eax,4),%eax
 543:	83 c1 01             	add    $0x1,%ecx
 546:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 54a:	0f be 11             	movsbl (%ecx),%edx
 54d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
  return n;
}
 555:	5b                   	pop    %ebx
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 5d 10             	mov    0x10(%ebp),%ebx
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56e:	85 db                	test   %ebx,%ebx
 570:	7e 14                	jle    586 <memmove+0x26>
 572:	31 d2                	xor    %edx,%edx
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 578:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 57c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 57f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 582:	39 d3                	cmp    %edx,%ebx
 584:	75 f2                	jne    578 <memmove+0x18>
  return vdst;
}
 586:	5b                   	pop    %ebx
 587:	5e                   	pop    %esi
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    

0000058a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58a:	b8 01 00 00 00       	mov    $0x1,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <exit>:
SYSCALL(exit)
 592:	b8 02 00 00 00       	mov    $0x2,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <wait>:
SYSCALL(wait)
 59a:	b8 03 00 00 00       	mov    $0x3,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <pipe>:
SYSCALL(pipe)
 5a2:	b8 04 00 00 00       	mov    $0x4,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <read>:
SYSCALL(read)
 5aa:	b8 05 00 00 00       	mov    $0x5,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <write>:
SYSCALL(write)
 5b2:	b8 10 00 00 00       	mov    $0x10,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <close>:
SYSCALL(close)
 5ba:	b8 15 00 00 00       	mov    $0x15,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <kill>:
SYSCALL(kill)
 5c2:	b8 06 00 00 00       	mov    $0x6,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <exec>:
SYSCALL(exec)
 5ca:	b8 07 00 00 00       	mov    $0x7,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <open>:
SYSCALL(open)
 5d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mknod>:
SYSCALL(mknod)
 5da:	b8 11 00 00 00       	mov    $0x11,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <unlink>:
SYSCALL(unlink)
 5e2:	b8 12 00 00 00       	mov    $0x12,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <fstat>:
SYSCALL(fstat)
 5ea:	b8 08 00 00 00       	mov    $0x8,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <link>:
SYSCALL(link)
 5f2:	b8 13 00 00 00       	mov    $0x13,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mkdir>:
SYSCALL(mkdir)
 5fa:	b8 14 00 00 00       	mov    $0x14,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <chdir>:
SYSCALL(chdir)
 602:	b8 09 00 00 00       	mov    $0x9,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <dup>:
SYSCALL(dup)
 60a:	b8 0a 00 00 00       	mov    $0xa,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <getpid>:
SYSCALL(getpid)
 612:	b8 0b 00 00 00       	mov    $0xb,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <sbrk>:
SYSCALL(sbrk)
 61a:	b8 0c 00 00 00       	mov    $0xc,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <sleep>:
SYSCALL(sleep)
 622:	b8 0d 00 00 00       	mov    $0xd,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <uptime>:
SYSCALL(uptime)
 62a:	b8 0e 00 00 00       	mov    $0xe,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <bstat>:
SYSCALL(bstat)
 632:	b8 16 00 00 00       	mov    $0x16,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <swap>:
SYSCALL(swap)
 63a:	b8 17 00 00 00       	mov    $0x17,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    
 642:	66 90                	xchg   %ax,%ax
 644:	66 90                	xchg   %ax,%ax
 646:	66 90                	xchg   %ax,%ax
 648:	66 90                	xchg   %ax,%ax
 64a:	66 90                	xchg   %ax,%ax
 64c:	66 90                	xchg   %ax,%ax
 64e:	66 90                	xchg   %ax,%ax

00000650 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	89 c6                	mov    %eax,%esi
 658:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 65e:	85 db                	test   %ebx,%ebx
 660:	74 7e                	je     6e0 <printint+0x90>
 662:	89 d0                	mov    %edx,%eax
 664:	c1 e8 1f             	shr    $0x1f,%eax
 667:	84 c0                	test   %al,%al
 669:	74 75                	je     6e0 <printint+0x90>
    neg = 1;
    x = -xx;
 66b:	89 d0                	mov    %edx,%eax
    neg = 1;
 66d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 674:	f7 d8                	neg    %eax
 676:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 679:	31 ff                	xor    %edi,%edi
 67b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 67e:	89 ce                	mov    %ecx,%esi
 680:	eb 08                	jmp    68a <printint+0x3a>
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 688:	89 cf                	mov    %ecx,%edi
 68a:	31 d2                	xor    %edx,%edx
 68c:	8d 4f 01             	lea    0x1(%edi),%ecx
 68f:	f7 f6                	div    %esi
 691:	0f b6 92 64 0a 00 00 	movzbl 0xa64(%edx),%edx
  }while((x /= base) != 0);
 698:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 69a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 69d:	75 e9                	jne    688 <printint+0x38>
  if(neg)
 69f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6a2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6a5:	85 c0                	test   %eax,%eax
 6a7:	74 08                	je     6b1 <printint+0x61>
    buf[i++] = '-';
 6a9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 6ae:	8d 4f 02             	lea    0x2(%edi),%ecx
 6b1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 6b5:	8d 76 00             	lea    0x0(%esi),%esi
 6b8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 6bb:	83 ec 04             	sub    $0x4,%esp
 6be:	83 ef 01             	sub    $0x1,%edi
 6c1:	6a 01                	push   $0x1
 6c3:	53                   	push   %ebx
 6c4:	56                   	push   %esi
 6c5:	88 45 d7             	mov    %al,-0x29(%ebp)
 6c8:	e8 e5 fe ff ff       	call   5b2 <write>

  while(--i >= 0)
 6cd:	83 c4 10             	add    $0x10,%esp
 6d0:	39 df                	cmp    %ebx,%edi
 6d2:	75 e4                	jne    6b8 <printint+0x68>
    putc(fd, buf[i]);
}
 6d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d7:	5b                   	pop    %ebx
 6d8:	5e                   	pop    %esi
 6d9:	5f                   	pop    %edi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = xx;
 6e0:	89 d0                	mov    %edx,%eax
  neg = 0;
 6e2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6e9:	eb 8b                	jmp    676 <printint+0x26>
 6eb:	90                   	nop
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f6:	8d 45 10             	lea    0x10(%ebp),%eax
{
 6f9:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 6fc:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 6ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 702:	89 45 d0             	mov    %eax,-0x30(%ebp)
 705:	0f b6 1e             	movzbl (%esi),%ebx
 708:	83 c6 01             	add    $0x1,%esi
 70b:	84 db                	test   %bl,%bl
 70d:	0f 84 b0 00 00 00    	je     7c3 <printf+0xd3>
 713:	31 d2                	xor    %edx,%edx
 715:	eb 39                	jmp    750 <printf+0x60>
 717:	89 f6                	mov    %esi,%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 720:	83 f8 25             	cmp    $0x25,%eax
 723:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 726:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 72b:	74 18                	je     745 <printf+0x55>
  write(fd, &c, 1);
 72d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 730:	83 ec 04             	sub    $0x4,%esp
 733:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 736:	6a 01                	push   $0x1
 738:	50                   	push   %eax
 739:	57                   	push   %edi
 73a:	e8 73 fe ff ff       	call   5b2 <write>
 73f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 742:	83 c4 10             	add    $0x10,%esp
 745:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 748:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 74c:	84 db                	test   %bl,%bl
 74e:	74 73                	je     7c3 <printf+0xd3>
    if(state == 0){
 750:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 752:	0f be cb             	movsbl %bl,%ecx
 755:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 758:	74 c6                	je     720 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75a:	83 fa 25             	cmp    $0x25,%edx
 75d:	75 e6                	jne    745 <printf+0x55>
      if(c == 'd'){
 75f:	83 f8 64             	cmp    $0x64,%eax
 762:	0f 84 f8 00 00 00    	je     860 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 768:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 76e:	83 f9 70             	cmp    $0x70,%ecx
 771:	74 5d                	je     7d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 773:	83 f8 73             	cmp    $0x73,%eax
 776:	0f 84 84 00 00 00    	je     800 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77c:	83 f8 63             	cmp    $0x63,%eax
 77f:	0f 84 ea 00 00 00    	je     86f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 785:	83 f8 25             	cmp    $0x25,%eax
 788:	0f 84 c2 00 00 00    	je     850 <printf+0x160>
  write(fd, &c, 1);
 78e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 791:	83 ec 04             	sub    $0x4,%esp
 794:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 798:	6a 01                	push   $0x1
 79a:	50                   	push   %eax
 79b:	57                   	push   %edi
 79c:	e8 11 fe ff ff       	call   5b2 <write>
 7a1:	83 c4 0c             	add    $0xc,%esp
 7a4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7a7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7aa:	6a 01                	push   $0x1
 7ac:	50                   	push   %eax
 7ad:	57                   	push   %edi
 7ae:	83 c6 01             	add    $0x1,%esi
 7b1:	e8 fc fd ff ff       	call   5b2 <write>
  for(i = 0; fmt[i]; i++){
 7b6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 7ba:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7bd:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7bf:	84 db                	test   %bl,%bl
 7c1:	75 8d                	jne    750 <printf+0x60>
    }
  }
}
 7c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7c6:	5b                   	pop    %ebx
 7c7:	5e                   	pop    %esi
 7c8:	5f                   	pop    %edi
 7c9:	5d                   	pop    %ebp
 7ca:	c3                   	ret    
 7cb:	90                   	nop
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7d8:	6a 00                	push   $0x0
 7da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7dd:	89 f8                	mov    %edi,%eax
 7df:	8b 13                	mov    (%ebx),%edx
 7e1:	e8 6a fe ff ff       	call   650 <printint>
        ap++;
 7e6:	89 d8                	mov    %ebx,%eax
 7e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7eb:	31 d2                	xor    %edx,%edx
        ap++;
 7ed:	83 c0 04             	add    $0x4,%eax
 7f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7f3:	e9 4d ff ff ff       	jmp    745 <printf+0x55>
 7f8:	90                   	nop
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 800:	8b 45 d0             	mov    -0x30(%ebp),%eax
 803:	8b 18                	mov    (%eax),%ebx
        ap++;
 805:	83 c0 04             	add    $0x4,%eax
 808:	89 45 d0             	mov    %eax,-0x30(%ebp)
          s = "(null)";
 80b:	b8 5a 0a 00 00       	mov    $0xa5a,%eax
 810:	85 db                	test   %ebx,%ebx
 812:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 815:	0f b6 03             	movzbl (%ebx),%eax
 818:	84 c0                	test   %al,%al
 81a:	74 23                	je     83f <printf+0x14f>
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 820:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 823:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 826:	83 ec 04             	sub    $0x4,%esp
 829:	6a 01                	push   $0x1
          s++;
 82b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 82e:	50                   	push   %eax
 82f:	57                   	push   %edi
 830:	e8 7d fd ff ff       	call   5b2 <write>
        while(*s != 0){
 835:	0f b6 03             	movzbl (%ebx),%eax
 838:	83 c4 10             	add    $0x10,%esp
 83b:	84 c0                	test   %al,%al
 83d:	75 e1                	jne    820 <printf+0x130>
      state = 0;
 83f:	31 d2                	xor    %edx,%edx
 841:	e9 ff fe ff ff       	jmp    745 <printf+0x55>
 846:	8d 76 00             	lea    0x0(%esi),%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 850:	83 ec 04             	sub    $0x4,%esp
 853:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 856:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 859:	6a 01                	push   $0x1
 85b:	e9 4c ff ff ff       	jmp    7ac <printf+0xbc>
        printint(fd, *ap, 10, 1);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 0a 00 00 00       	mov    $0xa,%ecx
 868:	6a 01                	push   $0x1
 86a:	e9 6b ff ff ff       	jmp    7da <printf+0xea>
 86f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 872:	83 ec 04             	sub    $0x4,%esp
 875:	8b 03                	mov    (%ebx),%eax
 877:	6a 01                	push   $0x1
 879:	88 45 e4             	mov    %al,-0x1c(%ebp)
 87c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 87f:	50                   	push   %eax
 880:	57                   	push   %edi
 881:	e8 2c fd ff ff       	call   5b2 <write>
 886:	e9 5b ff ff ff       	jmp    7e6 <printf+0xf6>
 88b:	66 90                	xchg   %ax,%ax
 88d:	66 90                	xchg   %ax,%ax
 88f:	90                   	nop

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	a1 7c 0d 00 00       	mov    0xd7c,%eax
{
 896:	89 e5                	mov    %esp,%ebp
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	53                   	push   %ebx
 89b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8a0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a3:	39 c8                	cmp    %ecx,%eax
 8a5:	73 19                	jae    8c0 <free+0x30>
 8a7:	89 f6                	mov    %esi,%esi
 8a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 8b0:	39 d1                	cmp    %edx,%ecx
 8b2:	72 1c                	jb     8d0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	39 d0                	cmp    %edx,%eax
 8b6:	73 18                	jae    8d0 <free+0x40>
{
 8b8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	72 f0                	jb     8b0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	39 d0                	cmp    %edx,%eax
 8c2:	72 f4                	jb     8b8 <free+0x28>
 8c4:	39 d1                	cmp    %edx,%ecx
 8c6:	73 f0                	jae    8b8 <free+0x28>
 8c8:	90                   	nop
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8d6:	39 d7                	cmp    %edx,%edi
 8d8:	74 19                	je     8f3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8dd:	8b 50 04             	mov    0x4(%eax),%edx
 8e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8e3:	39 f1                	cmp    %esi,%ecx
 8e5:	74 23                	je     90a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8e7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8e9:	a3 7c 0d 00 00       	mov    %eax,0xd7c
}
 8ee:	5b                   	pop    %ebx
 8ef:	5e                   	pop    %esi
 8f0:	5f                   	pop    %edi
 8f1:	5d                   	pop    %ebp
 8f2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 8f3:	03 72 04             	add    0x4(%edx),%esi
 8f6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f9:	8b 10                	mov    (%eax),%edx
 8fb:	8b 12                	mov    (%edx),%edx
 8fd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 900:	8b 50 04             	mov    0x4(%eax),%edx
 903:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 906:	39 f1                	cmp    %esi,%ecx
 908:	75 dd                	jne    8e7 <free+0x57>
    p->s.size += bp->s.size;
 90a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 90d:	a3 7c 0d 00 00       	mov    %eax,0xd7c
    p->s.size += bp->s.size;
 912:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 915:	8b 53 f8             	mov    -0x8(%ebx),%edx
 918:	89 10                	mov    %edx,(%eax)
}
 91a:	5b                   	pop    %ebx
 91b:	5e                   	pop    %esi
 91c:	5f                   	pop    %edi
 91d:	5d                   	pop    %ebp
 91e:	c3                   	ret    
 91f:	90                   	nop

00000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	57                   	push   %edi
 924:	56                   	push   %esi
 925:	53                   	push   %ebx
 926:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 92c:	8b 15 7c 0d 00 00    	mov    0xd7c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 932:	8d 78 07             	lea    0x7(%eax),%edi
 935:	c1 ef 03             	shr    $0x3,%edi
 938:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 93b:	85 d2                	test   %edx,%edx
 93d:	0f 84 a3 00 00 00    	je     9e6 <malloc+0xc6>
 943:	8b 02                	mov    (%edx),%eax
 945:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 948:	39 cf                	cmp    %ecx,%edi
 94a:	76 74                	jbe    9c0 <malloc+0xa0>
 94c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 952:	be 00 10 00 00       	mov    $0x1000,%esi
 957:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 95e:	0f 43 f7             	cmovae %edi,%esi
 961:	ba 00 80 00 00       	mov    $0x8000,%edx
 966:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 96c:	0f 46 da             	cmovbe %edx,%ebx
 96f:	eb 10                	jmp    981 <malloc+0x61>
 971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 978:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 97a:	8b 48 04             	mov    0x4(%eax),%ecx
 97d:	39 cf                	cmp    %ecx,%edi
 97f:	76 3f                	jbe    9c0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 981:	39 05 7c 0d 00 00    	cmp    %eax,0xd7c
 987:	89 c2                	mov    %eax,%edx
 989:	75 ed                	jne    978 <malloc+0x58>
  p = sbrk(nu * sizeof(Header));
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	53                   	push   %ebx
 98f:	e8 86 fc ff ff       	call   61a <sbrk>
  if(p == (char*)-1)
 994:	83 c4 10             	add    $0x10,%esp
 997:	83 f8 ff             	cmp    $0xffffffff,%eax
 99a:	74 1c                	je     9b8 <malloc+0x98>
  hp->s.size = nu;
 99c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 99f:	83 ec 0c             	sub    $0xc,%esp
 9a2:	83 c0 08             	add    $0x8,%eax
 9a5:	50                   	push   %eax
 9a6:	e8 e5 fe ff ff       	call   890 <free>
  return freep;
 9ab:	8b 15 7c 0d 00 00    	mov    0xd7c,%edx
      if((p = morecore(nunits)) == 0)
 9b1:	83 c4 10             	add    $0x10,%esp
 9b4:	85 d2                	test   %edx,%edx
 9b6:	75 c0                	jne    978 <malloc+0x58>
        return 0;
 9b8:	31 c0                	xor    %eax,%eax
 9ba:	eb 1c                	jmp    9d8 <malloc+0xb8>
 9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9c0:	39 cf                	cmp    %ecx,%edi
 9c2:	74 1c                	je     9e0 <malloc+0xc0>
        p->s.size -= nunits;
 9c4:	29 f9                	sub    %edi,%ecx
 9c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9cc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9cf:	89 15 7c 0d 00 00    	mov    %edx,0xd7c
      return (void*)(p + 1);
 9d5:	83 c0 08             	add    $0x8,%eax
  }
}
 9d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9db:	5b                   	pop    %ebx
 9dc:	5e                   	pop    %esi
 9dd:	5f                   	pop    %edi
 9de:	5d                   	pop    %ebp
 9df:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 9e0:	8b 08                	mov    (%eax),%ecx
 9e2:	89 0a                	mov    %ecx,(%edx)
 9e4:	eb e9                	jmp    9cf <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 9e6:	c7 05 7c 0d 00 00 80 	movl   $0xd80,0xd7c
 9ed:	0d 00 00 
 9f0:	c7 05 80 0d 00 00 80 	movl   $0xd80,0xd80
 9f7:	0d 00 00 
    base.s.size = 0;
 9fa:	b8 80 0d 00 00       	mov    $0xd80,%eax
 9ff:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 a06:	00 00 00 
 a09:	e9 3e ff ff ff       	jmp    94c <malloc+0x2c>

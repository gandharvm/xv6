
_memtest2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "memtest starting\n");
  11:	68 63 08 00 00       	push   $0x863
  16:	6a 01                	push   $0x1
  18:	e8 e3 04 00 00       	call   500 <printf>
	mem();
  1d:	e8 0e 00 00 00       	call   30 <mem>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <mem>:
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	56                   	push   %esi
  35:	53                   	push   %ebx
  36:	83 ec 14             	sub    $0x14,%esp
	printf(1, "mem test\n");
  39:	68 20 08 00 00       	push   $0x820
  3e:	6a 01                	push   $0x1
  40:	e8 bb 04 00 00       	call   500 <printf>
	m1 = malloc(4096);
  45:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  4c:	e8 df 06 00 00       	call   730 <malloc>
	if (m1 == 0)
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	74 30                	je     88 <mem+0x58>
  58:	89 c6                	mov    %eax,%esi
  5a:	89 c3                	mov    %eax,%ebx
  5c:	31 ff                	xor    %edi,%edi
  5e:	eb 14                	jmp    74 <mem+0x44>
		((int*)m1)[2] = count++;
  60:	8d 57 01             	lea    0x1(%edi),%edx
		*(char**)m1 = m2;
  63:	89 03                	mov    %eax,(%ebx)
		((int*)m1)[2] = count++;
  65:	89 7b 08             	mov    %edi,0x8(%ebx)
  68:	89 c3                	mov    %eax,%ebx
	while (cur < TOTAL_MEMORY) {
  6a:	81 fa 40 01 00 00    	cmp    $0x140,%edx
  70:	74 2a                	je     9c <mem+0x6c>
  72:	89 d7                	mov    %edx,%edi
		m2 = malloc(4096);
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	68 00 10 00 00       	push   $0x1000
  7c:	e8 af 06 00 00       	call   730 <malloc>
		if (m2 == 0)
  81:	83 c4 10             	add    $0x10,%esp
  84:	85 c0                	test   %eax,%eax
  86:	75 d8                	jne    60 <mem+0x30>
	printf(1, "test failed!\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 55 08 00 00       	push   $0x855
  90:	6a 01                	push   $0x1
  92:	e8 69 04 00 00       	call   500 <printf>
	exit();
  97:	e8 06 03 00 00       	call   3a2 <exit>
	((int*)m1)[2] = count;
  9c:	c7 40 08 40 01 00 00 	movl   $0x140,0x8(%eax)
		if (((int*)m1)[2] != count)
  a3:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
  a7:	75 df                	jne    88 <mem+0x58>
  a9:	89 f7                	mov    %esi,%edi
  ab:	31 c0                	xor    %eax,%eax
  ad:	eb 08                	jmp    b7 <mem+0x87>
  af:	90                   	nop
  b0:	8b 47 08             	mov    0x8(%edi),%eax
  b3:	39 d8                	cmp    %ebx,%eax
  b5:	75 d1                	jne    88 <mem+0x58>
		count++;
  b7:	8d 58 01             	lea    0x1(%eax),%ebx
		printf(1,"%d\n", count);
  ba:	83 ec 04             	sub    $0x4,%esp
		m1 = *(char**)m1;
  bd:	8b 3f                	mov    (%edi),%edi
		printf(1,"%d\n", count);
  bf:	53                   	push   %ebx
  c0:	68 51 08 00 00       	push   $0x851
  c5:	6a 01                	push   $0x1
  c7:	e8 34 04 00 00       	call   500 <printf>
	while (count != total_count) {
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	81 fb 40 01 00 00    	cmp    $0x140,%ebx
  d5:	75 d9                	jne    b0 <mem+0x80>
	if (swap(start) != 0)
  d7:	83 ec 0c             	sub    $0xc,%esp
  da:	56                   	push   %esi
  db:	e8 6a 03 00 00       	call   44a <swap>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	85 c0                	test   %eax,%eax
  e5:	75 3e                	jne    125 <mem+0xf5>
	pid = fork();
  e7:	e8 ae 02 00 00       	call   39a <fork>
	if (pid == 0){
  ec:	85 c0                	test   %eax,%eax
  ee:	74 2b                	je     11b <mem+0xeb>
	else if (pid < 0)
  f0:	78 4b                	js     13d <mem+0x10d>
		wait();
  f2:	e8 b3 02 00 00       	call   3aa <wait>
	printf(1, "mem ok %d\n", bstat());
  f7:	e8 46 03 00 00       	call   442 <bstat>
  fc:	52                   	push   %edx
  fd:	50                   	push   %eax
  fe:	68 4a 08 00 00       	push   $0x84a
 103:	6a 01                	push   $0x1
 105:	e8 f6 03 00 00       	call   500 <printf>
	exit();
 10a:	e8 93 02 00 00       	call   3a2 <exit>
			count++;
 10f:	83 c0 01             	add    $0x1,%eax
			m1 = *(char**)m1;
 112:	8b 36                	mov    (%esi),%esi
		while (count != total_count) {
 114:	3d 40 01 00 00       	cmp    $0x140,%eax
 119:	74 1d                	je     138 <mem+0x108>
			if (((int*)m1)[2] != count)
 11b:	3b 46 08             	cmp    0x8(%esi),%eax
 11e:	74 ef                	je     10f <mem+0xdf>
 120:	e9 63 ff ff ff       	jmp    88 <mem+0x58>
		printf(1, "failed to swap %p\n", start);
 125:	53                   	push   %ebx
 126:	56                   	push   %esi
 127:	68 2a 08 00 00       	push   $0x82a
 12c:	6a 01                	push   $0x1
 12e:	e8 cd 03 00 00       	call   500 <printf>
 133:	83 c4 10             	add    $0x10,%esp
 136:	eb af                	jmp    e7 <mem+0xb7>
		exit();
 138:	e8 65 02 00 00       	call   3a2 <exit>
		printf(1, "fork failed\n");
 13d:	51                   	push   %ecx
 13e:	51                   	push   %ecx
 13f:	68 3d 08 00 00       	push   $0x83d
 144:	6a 01                	push   $0x1
 146:	e8 b5 03 00 00       	call   500 <printf>
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	eb a7                	jmp    f7 <mem+0xc7>

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	89 c2                	mov    %eax,%edx
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 160:	83 c1 01             	add    $0x1,%ecx
 163:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 167:	83 c2 01             	add    $0x1,%edx
 16a:	84 db                	test   %bl,%bl
 16c:	88 5a ff             	mov    %bl,-0x1(%edx)
 16f:	75 ef                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 171:	5b                   	pop    %ebx
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 17a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 55 08             	mov    0x8(%ebp),%edx
 187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 18a:	0f b6 02             	movzbl (%edx),%eax
 18d:	0f b6 19             	movzbl (%ecx),%ebx
 190:	84 c0                	test   %al,%al
 192:	75 1c                	jne    1b0 <strcmp+0x30>
 194:	eb 2a                	jmp    1c0 <strcmp+0x40>
 196:	8d 76 00             	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1a0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1a6:	83 c1 01             	add    $0x1,%ecx
 1a9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1ac:	84 c0                	test   %al,%al
 1ae:	74 10                	je     1c0 <strcmp+0x40>
 1b0:	38 d8                	cmp    %bl,%al
 1b2:	74 ec                	je     1a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1b4:	29 d8                	sub    %ebx,%eax
}
 1b6:	5b                   	pop    %ebx
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1c2:	29 d8                	sub    %ebx,%eax
}
 1c4:	5b                   	pop    %ebx
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	89 f6                	mov    %esi,%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strlen>:

uint
strlen(char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1d6:	80 39 00             	cmpb   $0x0,(%ecx)
 1d9:	74 15                	je     1f0 <strlen+0x20>
 1db:	31 d2                	xor    %edx,%edx
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1e7:	89 d0                	mov    %edx,%eax
 1e9:	75 f5                	jne    1e0 <strlen+0x10>
    ;
  return n;
}
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1f0:	31 c0                	xor    %eax,%eax
}
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    
 1f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 207:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 d7                	mov    %edx,%edi
 20f:	fc                   	cld    
 210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 212:	89 d0                	mov    %edx,%eax
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	84 d2                	test   %dl,%dl
 22f:	74 1d                	je     24e <strchr+0x2e>
    if(*s == c)
 231:	38 d3                	cmp    %dl,%bl
 233:	89 d9                	mov    %ebx,%ecx
 235:	75 0d                	jne    244 <strchr+0x24>
 237:	eb 17                	jmp    250 <strchr+0x30>
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 240:	38 ca                	cmp    %cl,%dl
 242:	74 0c                	je     250 <strchr+0x30>
  for(; *s; s++)
 244:	83 c0 01             	add    $0x1,%eax
 247:	0f b6 10             	movzbl (%eax),%edx
 24a:	84 d2                	test   %dl,%dl
 24c:	75 f2                	jne    240 <strchr+0x20>
      return (char*)s;
  return 0;
 24e:	31 c0                	xor    %eax,%eax
}
 250:	5b                   	pop    %ebx
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <gets>:

char*
gets(char *buf, int max)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
 265:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	31 f6                	xor    %esi,%esi
 268:	89 f3                	mov    %esi,%ebx
{
 26a:	83 ec 1c             	sub    $0x1c,%esp
 26d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 270:	eb 2f                	jmp    2a1 <gets+0x41>
 272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 278:	8d 45 e7             	lea    -0x19(%ebp),%eax
 27b:	83 ec 04             	sub    $0x4,%esp
 27e:	6a 01                	push   $0x1
 280:	50                   	push   %eax
 281:	6a 00                	push   $0x0
 283:	e8 32 01 00 00       	call   3ba <read>
    if(cc < 1)
 288:	83 c4 10             	add    $0x10,%esp
 28b:	85 c0                	test   %eax,%eax
 28d:	7e 1c                	jle    2ab <gets+0x4b>
      break;
    buf[i++] = c;
 28f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 293:	83 c7 01             	add    $0x1,%edi
 296:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 23                	je     2c0 <gets+0x60>
 29d:	3c 0d                	cmp    $0xd,%al
 29f:	74 1f                	je     2c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2a1:	83 c3 01             	add    $0x1,%ebx
 2a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a7:	89 fe                	mov    %edi,%esi
 2a9:	7c cd                	jl     278 <gets+0x18>
 2ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b6:	5b                   	pop    %ebx
 2b7:	5e                   	pop    %esi
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    
 2bb:	90                   	nop
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c0:	8b 75 08             	mov    0x8(%ebp),%esi
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	01 de                	add    %ebx,%esi
 2c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 2cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d0:	5b                   	pop    %ebx
 2d1:	5e                   	pop    %esi
 2d2:	5f                   	pop    %edi
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret    
 2d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <stat>:

int
stat(char *n, struct stat *st)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	6a 00                	push   $0x0
 2ea:	ff 75 08             	pushl  0x8(%ebp)
 2ed:	e8 f0 00 00 00       	call   3e2 <open>
  if(fd < 0)
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	78 27                	js     320 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	ff 75 0c             	pushl  0xc(%ebp)
 2ff:	89 c3                	mov    %eax,%ebx
 301:	50                   	push   %eax
 302:	e8 f3 00 00 00       	call   3fa <fstat>
  close(fd);
 307:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 30a:	89 c6                	mov    %eax,%esi
  close(fd);
 30c:	e8 b9 00 00 00       	call   3ca <close>
  return r;
 311:	83 c4 10             	add    $0x10,%esp
}
 314:	8d 65 f8             	lea    -0x8(%ebp),%esp
 317:	89 f0                	mov    %esi,%eax
 319:	5b                   	pop    %ebx
 31a:	5e                   	pop    %esi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 320:	be ff ff ff ff       	mov    $0xffffffff,%esi
 325:	eb ed                	jmp    314 <stat+0x34>
 327:	89 f6                	mov    %esi,%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 337:	0f be 11             	movsbl (%ecx),%edx
 33a:	8d 42 d0             	lea    -0x30(%edx),%eax
 33d:	3c 09                	cmp    $0x9,%al
  n = 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 344:	77 1f                	ja     365 <atoi+0x35>
 346:	8d 76 00             	lea    0x0(%esi),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 350:	8d 04 80             	lea    (%eax,%eax,4),%eax
 353:	83 c1 01             	add    $0x1,%ecx
 356:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 35a:	0f be 11             	movsbl (%ecx),%edx
 35d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 360:	80 fb 09             	cmp    $0x9,%bl
 363:	76 eb                	jbe    350 <atoi+0x20>
  return n;
}
 365:	5b                   	pop    %ebx
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    
 368:	90                   	nop
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000370 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
 375:	8b 5d 10             	mov    0x10(%ebp),%ebx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37e:	85 db                	test   %ebx,%ebx
 380:	7e 14                	jle    396 <memmove+0x26>
 382:	31 d2                	xor    %edx,%edx
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 388:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 38c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 38f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 392:	39 d3                	cmp    %edx,%ebx
 394:	75 f2                	jne    388 <memmove+0x18>
  return vdst;
}
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5d                   	pop    %ebp
 399:	c3                   	ret    

0000039a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39a:	b8 01 00 00 00       	mov    $0x1,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <exit>:
SYSCALL(exit)
 3a2:	b8 02 00 00 00       	mov    $0x2,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <wait>:
SYSCALL(wait)
 3aa:	b8 03 00 00 00       	mov    $0x3,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <pipe>:
SYSCALL(pipe)
 3b2:	b8 04 00 00 00       	mov    $0x4,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <read>:
SYSCALL(read)
 3ba:	b8 05 00 00 00       	mov    $0x5,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <write>:
SYSCALL(write)
 3c2:	b8 10 00 00 00       	mov    $0x10,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <close>:
SYSCALL(close)
 3ca:	b8 15 00 00 00       	mov    $0x15,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <kill>:
SYSCALL(kill)
 3d2:	b8 06 00 00 00       	mov    $0x6,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <exec>:
SYSCALL(exec)
 3da:	b8 07 00 00 00       	mov    $0x7,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <open>:
SYSCALL(open)
 3e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mknod>:
SYSCALL(mknod)
 3ea:	b8 11 00 00 00       	mov    $0x11,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <unlink>:
SYSCALL(unlink)
 3f2:	b8 12 00 00 00       	mov    $0x12,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <fstat>:
SYSCALL(fstat)
 3fa:	b8 08 00 00 00       	mov    $0x8,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <link>:
SYSCALL(link)
 402:	b8 13 00 00 00       	mov    $0x13,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <mkdir>:
SYSCALL(mkdir)
 40a:	b8 14 00 00 00       	mov    $0x14,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <chdir>:
SYSCALL(chdir)
 412:	b8 09 00 00 00       	mov    $0x9,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <dup>:
SYSCALL(dup)
 41a:	b8 0a 00 00 00       	mov    $0xa,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <getpid>:
SYSCALL(getpid)
 422:	b8 0b 00 00 00       	mov    $0xb,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <sbrk>:
SYSCALL(sbrk)
 42a:	b8 0c 00 00 00       	mov    $0xc,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <sleep>:
SYSCALL(sleep)
 432:	b8 0d 00 00 00       	mov    $0xd,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <uptime>:
SYSCALL(uptime)
 43a:	b8 0e 00 00 00       	mov    $0xe,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <bstat>:
SYSCALL(bstat)
 442:	b8 16 00 00 00       	mov    $0x16,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <swap>:
SYSCALL(swap)
 44a:	b8 17 00 00 00       	mov    $0x17,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    
 452:	66 90                	xchg   %ax,%ax
 454:	66 90                	xchg   %ax,%ax
 456:	66 90                	xchg   %ax,%ax
 458:	66 90                	xchg   %ax,%ax
 45a:	66 90                	xchg   %ax,%ax
 45c:	66 90                	xchg   %ax,%ax
 45e:	66 90                	xchg   %ax,%ax

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	89 c6                	mov    %eax,%esi
 468:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 46e:	85 db                	test   %ebx,%ebx
 470:	74 7e                	je     4f0 <printint+0x90>
 472:	89 d0                	mov    %edx,%eax
 474:	c1 e8 1f             	shr    $0x1f,%eax
 477:	84 c0                	test   %al,%al
 479:	74 75                	je     4f0 <printint+0x90>
    neg = 1;
    x = -xx;
 47b:	89 d0                	mov    %edx,%eax
    neg = 1;
 47d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 484:	f7 d8                	neg    %eax
 486:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 489:	31 ff                	xor    %edi,%edi
 48b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 48e:	89 ce                	mov    %ecx,%esi
 490:	eb 08                	jmp    49a <printint+0x3a>
 492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 498:	89 cf                	mov    %ecx,%edi
 49a:	31 d2                	xor    %edx,%edx
 49c:	8d 4f 01             	lea    0x1(%edi),%ecx
 49f:	f7 f6                	div    %esi
 4a1:	0f b6 92 94 08 00 00 	movzbl 0x894(%edx),%edx
  }while((x /= base) != 0);
 4a8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4aa:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 4ad:	75 e9                	jne    498 <printint+0x38>
  if(neg)
 4af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4b2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 4b5:	85 c0                	test   %eax,%eax
 4b7:	74 08                	je     4c1 <printint+0x61>
    buf[i++] = '-';
 4b9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 4be:	8d 4f 02             	lea    0x2(%edi),%ecx
 4c1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
 4c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	83 ef 01             	sub    $0x1,%edi
 4d1:	6a 01                	push   $0x1
 4d3:	53                   	push   %ebx
 4d4:	56                   	push   %esi
 4d5:	88 45 d7             	mov    %al,-0x29(%ebp)
 4d8:	e8 e5 fe ff ff       	call   3c2 <write>

  while(--i >= 0)
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	39 df                	cmp    %ebx,%edi
 4e2:	75 e4                	jne    4c8 <printint+0x68>
    putc(fd, buf[i]);
}
 4e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e7:	5b                   	pop    %ebx
 4e8:	5e                   	pop    %esi
 4e9:	5f                   	pop    %edi
 4ea:	5d                   	pop    %ebp
 4eb:	c3                   	ret    
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = xx;
 4f0:	89 d0                	mov    %edx,%eax
  neg = 0;
 4f2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4f9:	eb 8b                	jmp    486 <printint+0x26>
 4fb:	90                   	nop
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 506:	8d 45 10             	lea    0x10(%ebp),%eax
{
 509:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 50c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 50f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 512:	89 45 d0             	mov    %eax,-0x30(%ebp)
 515:	0f b6 1e             	movzbl (%esi),%ebx
 518:	83 c6 01             	add    $0x1,%esi
 51b:	84 db                	test   %bl,%bl
 51d:	0f 84 b0 00 00 00    	je     5d3 <printf+0xd3>
 523:	31 d2                	xor    %edx,%edx
 525:	eb 39                	jmp    560 <printf+0x60>
 527:	89 f6                	mov    %esi,%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 530:	83 f8 25             	cmp    $0x25,%eax
 533:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 536:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 53b:	74 18                	je     555 <printf+0x55>
  write(fd, &c, 1);
 53d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 540:	83 ec 04             	sub    $0x4,%esp
 543:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 546:	6a 01                	push   $0x1
 548:	50                   	push   %eax
 549:	57                   	push   %edi
 54a:	e8 73 fe ff ff       	call   3c2 <write>
 54f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 552:	83 c4 10             	add    $0x10,%esp
 555:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 558:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 55c:	84 db                	test   %bl,%bl
 55e:	74 73                	je     5d3 <printf+0xd3>
    if(state == 0){
 560:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 562:	0f be cb             	movsbl %bl,%ecx
 565:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 568:	74 c6                	je     530 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56a:	83 fa 25             	cmp    $0x25,%edx
 56d:	75 e6                	jne    555 <printf+0x55>
      if(c == 'd'){
 56f:	83 f8 64             	cmp    $0x64,%eax
 572:	0f 84 f8 00 00 00    	je     670 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 578:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 57e:	83 f9 70             	cmp    $0x70,%ecx
 581:	74 5d                	je     5e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 583:	83 f8 73             	cmp    $0x73,%eax
 586:	0f 84 84 00 00 00    	je     610 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58c:	83 f8 63             	cmp    $0x63,%eax
 58f:	0f 84 ea 00 00 00    	je     67f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 595:	83 f8 25             	cmp    $0x25,%eax
 598:	0f 84 c2 00 00 00    	je     660 <printf+0x160>
  write(fd, &c, 1);
 59e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5a1:	83 ec 04             	sub    $0x4,%esp
 5a4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5a8:	6a 01                	push   $0x1
 5aa:	50                   	push   %eax
 5ab:	57                   	push   %edi
 5ac:	e8 11 fe ff ff       	call   3c2 <write>
 5b1:	83 c4 0c             	add    $0xc,%esp
 5b4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5b7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5ba:	6a 01                	push   $0x1
 5bc:	50                   	push   %eax
 5bd:	57                   	push   %edi
 5be:	83 c6 01             	add    $0x1,%esi
 5c1:	e8 fc fd ff ff       	call   3c2 <write>
  for(i = 0; fmt[i]; i++){
 5c6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 5ca:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cd:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5cf:	84 db                	test   %bl,%bl
 5d1:	75 8d                	jne    560 <printf+0x60>
    }
  }
}
 5d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    
 5db:	90                   	nop
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5e8:	6a 00                	push   $0x0
 5ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ed:	89 f8                	mov    %edi,%eax
 5ef:	8b 13                	mov    (%ebx),%edx
 5f1:	e8 6a fe ff ff       	call   460 <printint>
        ap++;
 5f6:	89 d8                	mov    %ebx,%eax
 5f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fb:	31 d2                	xor    %edx,%edx
        ap++;
 5fd:	83 c0 04             	add    $0x4,%eax
 600:	89 45 d0             	mov    %eax,-0x30(%ebp)
 603:	e9 4d ff ff ff       	jmp    555 <printf+0x55>
 608:	90                   	nop
 609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 610:	8b 45 d0             	mov    -0x30(%ebp),%eax
 613:	8b 18                	mov    (%eax),%ebx
        ap++;
 615:	83 c0 04             	add    $0x4,%eax
 618:	89 45 d0             	mov    %eax,-0x30(%ebp)
          s = "(null)";
 61b:	b8 8b 08 00 00       	mov    $0x88b,%eax
 620:	85 db                	test   %ebx,%ebx
 622:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 625:	0f b6 03             	movzbl (%ebx),%eax
 628:	84 c0                	test   %al,%al
 62a:	74 23                	je     64f <printf+0x14f>
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 630:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 633:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 636:	83 ec 04             	sub    $0x4,%esp
 639:	6a 01                	push   $0x1
          s++;
 63b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 63e:	50                   	push   %eax
 63f:	57                   	push   %edi
 640:	e8 7d fd ff ff       	call   3c2 <write>
        while(*s != 0){
 645:	0f b6 03             	movzbl (%ebx),%eax
 648:	83 c4 10             	add    $0x10,%esp
 64b:	84 c0                	test   %al,%al
 64d:	75 e1                	jne    630 <printf+0x130>
      state = 0;
 64f:	31 d2                	xor    %edx,%edx
 651:	e9 ff fe ff ff       	jmp    555 <printf+0x55>
 656:	8d 76 00             	lea    0x0(%esi),%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 666:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 669:	6a 01                	push   $0x1
 66b:	e9 4c ff ff ff       	jmp    5bc <printf+0xbc>
        printint(fd, *ap, 10, 1);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 0a 00 00 00       	mov    $0xa,%ecx
 678:	6a 01                	push   $0x1
 67a:	e9 6b ff ff ff       	jmp    5ea <printf+0xea>
 67f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 682:	83 ec 04             	sub    $0x4,%esp
 685:	8b 03                	mov    (%ebx),%eax
 687:	6a 01                	push   $0x1
 689:	88 45 e4             	mov    %al,-0x1c(%ebp)
 68c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 68f:	50                   	push   %eax
 690:	57                   	push   %edi
 691:	e8 2c fd ff ff       	call   3c2 <write>
 696:	e9 5b ff ff ff       	jmp    5f6 <printf+0xf6>
 69b:	66 90                	xchg   %ax,%ax
 69d:	66 90                	xchg   %ax,%ax
 69f:	90                   	nop

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 60 0b 00 00       	mov    0xb60,%eax
{
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	57                   	push   %edi
 6a9:	56                   	push   %esi
 6aa:	53                   	push   %ebx
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ae:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 6b0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b3:	39 c8                	cmp    %ecx,%eax
 6b5:	73 19                	jae    6d0 <free+0x30>
 6b7:	89 f6                	mov    %esi,%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 6c0:	39 d1                	cmp    %edx,%ecx
 6c2:	72 1c                	jb     6e0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	39 d0                	cmp    %edx,%eax
 6c6:	73 18                	jae    6e0 <free+0x40>
{
 6c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	72 f0                	jb     6c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	39 d0                	cmp    %edx,%eax
 6d2:	72 f4                	jb     6c8 <free+0x28>
 6d4:	39 d1                	cmp    %edx,%ecx
 6d6:	73 f0                	jae    6c8 <free+0x28>
 6d8:	90                   	nop
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6e6:	39 d7                	cmp    %edx,%edi
 6e8:	74 19                	je     703 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ed:	8b 50 04             	mov    0x4(%eax),%edx
 6f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6f3:	39 f1                	cmp    %esi,%ecx
 6f5:	74 23                	je     71a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6f7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6f9:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 6fe:	5b                   	pop    %ebx
 6ff:	5e                   	pop    %esi
 700:	5f                   	pop    %edi
 701:	5d                   	pop    %ebp
 702:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 703:	03 72 04             	add    0x4(%edx),%esi
 706:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 709:	8b 10                	mov    (%eax),%edx
 70b:	8b 12                	mov    (%edx),%edx
 70d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 710:	8b 50 04             	mov    0x4(%eax),%edx
 713:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 716:	39 f1                	cmp    %esi,%ecx
 718:	75 dd                	jne    6f7 <free+0x57>
    p->s.size += bp->s.size;
 71a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 71d:	a3 60 0b 00 00       	mov    %eax,0xb60
    p->s.size += bp->s.size;
 722:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 725:	8b 53 f8             	mov    -0x8(%ebx),%edx
 728:	89 10                	mov    %edx,(%eax)
}
 72a:	5b                   	pop    %ebx
 72b:	5e                   	pop    %esi
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret    
 72f:	90                   	nop

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 73c:	8b 15 60 0b 00 00    	mov    0xb60,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 742:	8d 78 07             	lea    0x7(%eax),%edi
 745:	c1 ef 03             	shr    $0x3,%edi
 748:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 74b:	85 d2                	test   %edx,%edx
 74d:	0f 84 a3 00 00 00    	je     7f6 <malloc+0xc6>
 753:	8b 02                	mov    (%edx),%eax
 755:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 758:	39 cf                	cmp    %ecx,%edi
 75a:	76 74                	jbe    7d0 <malloc+0xa0>
 75c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 762:	be 00 10 00 00       	mov    $0x1000,%esi
 767:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 76e:	0f 43 f7             	cmovae %edi,%esi
 771:	ba 00 80 00 00       	mov    $0x8000,%edx
 776:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 77c:	0f 46 da             	cmovbe %edx,%ebx
 77f:	eb 10                	jmp    791 <malloc+0x61>
 781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 78a:	8b 48 04             	mov    0x4(%eax),%ecx
 78d:	39 cf                	cmp    %ecx,%edi
 78f:	76 3f                	jbe    7d0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 791:	39 05 60 0b 00 00    	cmp    %eax,0xb60
 797:	89 c2                	mov    %eax,%edx
 799:	75 ed                	jne    788 <malloc+0x58>
  p = sbrk(nu * sizeof(Header));
 79b:	83 ec 0c             	sub    $0xc,%esp
 79e:	53                   	push   %ebx
 79f:	e8 86 fc ff ff       	call   42a <sbrk>
  if(p == (char*)-1)
 7a4:	83 c4 10             	add    $0x10,%esp
 7a7:	83 f8 ff             	cmp    $0xffffffff,%eax
 7aa:	74 1c                	je     7c8 <malloc+0x98>
  hp->s.size = nu;
 7ac:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 7af:	83 ec 0c             	sub    $0xc,%esp
 7b2:	83 c0 08             	add    $0x8,%eax
 7b5:	50                   	push   %eax
 7b6:	e8 e5 fe ff ff       	call   6a0 <free>
  return freep;
 7bb:	8b 15 60 0b 00 00    	mov    0xb60,%edx
      if((p = morecore(nunits)) == 0)
 7c1:	83 c4 10             	add    $0x10,%esp
 7c4:	85 d2                	test   %edx,%edx
 7c6:	75 c0                	jne    788 <malloc+0x58>
        return 0;
 7c8:	31 c0                	xor    %eax,%eax
 7ca:	eb 1c                	jmp    7e8 <malloc+0xb8>
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7d0:	39 cf                	cmp    %ecx,%edi
 7d2:	74 1c                	je     7f0 <malloc+0xc0>
        p->s.size -= nunits;
 7d4:	29 f9                	sub    %edi,%ecx
 7d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7dc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7df:	89 15 60 0b 00 00    	mov    %edx,0xb60
      return (void*)(p + 1);
 7e5:	83 c0 08             	add    $0x8,%eax
  }
}
 7e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 08                	mov    (%eax),%ecx
 7f2:	89 0a                	mov    %ecx,(%edx)
 7f4:	eb e9                	jmp    7df <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 7f6:	c7 05 60 0b 00 00 64 	movl   $0xb64,0xb60
 7fd:	0b 00 00 
 800:	c7 05 64 0b 00 00 64 	movl   $0xb64,0xb64
 807:	0b 00 00 
    base.s.size = 0;
 80a:	b8 64 0b 00 00       	mov    $0xb64,%eax
 80f:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 816:	00 00 00 
 819:	e9 3e ff ff ff       	jmp    75c <malloc+0x2c>

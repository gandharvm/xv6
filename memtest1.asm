
_memtest1:     file format elf32-i386


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
  11:	68 d3 07 00 00       	push   $0x7d3
  16:	6a 01                	push   $0x1
  18:	e8 73 04 00 00       	call   490 <printf>
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
  39:	68 b0 07 00 00       	push   $0x7b0
  3e:	6a 01                	push   $0x1
  40:	e8 4b 04 00 00       	call   490 <printf>
	m1 = malloc(4096);
  45:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  4c:	e8 6f 06 00 00       	call   6c0 <malloc>
	if (m1 == 0)
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	74 30                	je     88 <mem+0x58>
  58:	89 c6                	mov    %eax,%esi
  5a:	89 c3                	mov    %eax,%ebx
	uint count = 0;
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
  6a:	81 fa 60 02 00 00    	cmp    $0x260,%edx
  70:	74 2a                	je     9c <mem+0x6c>
  72:	89 d7                	mov    %edx,%edi
		m2 = malloc(4096);
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	68 00 10 00 00       	push   $0x1000
  7c:	e8 3f 06 00 00       	call   6c0 <malloc>
		if (m2 == 0)
  81:	83 c4 10             	add    $0x10,%esp
  84:	85 c0                	test   %eax,%eax
  86:	75 d8                	jne    60 <mem+0x30>
	printf(1, "test failed!\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 c5 07 00 00       	push   $0x7c5
  90:	6a 01                	push   $0x1
  92:	e8 f9 03 00 00       	call   490 <printf>
	exit();
  97:	e8 96 02 00 00       	call   332 <exit>
	((int*)m1)[2] = count;
  9c:	c7 40 08 60 02 00 00 	movl   $0x260,0x8(%eax)
		if (((int*)m1)[2] != count)
  a3:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
  a7:	75 df                	jne    88 <mem+0x58>
	count = 0;
  a9:	31 c0                	xor    %eax,%eax
  ab:	eb 05                	jmp    b2 <mem+0x82>
		if (((int*)m1)[2] != count)
  ad:	39 46 08             	cmp    %eax,0x8(%esi)
  b0:	75 d6                	jne    88 <mem+0x58>
		count++;
  b2:	83 c0 01             	add    $0x1,%eax
		m1 = *(char**)m1;
  b5:	8b 36                	mov    (%esi),%esi
	while (count != total_count) {
  b7:	3d 60 02 00 00       	cmp    $0x260,%eax
  bc:	75 ef                	jne    ad <mem+0x7d>
	printf(1, "mem ok %d\n", bstat());
  be:	e8 0f 03 00 00       	call   3d2 <bstat>
  c3:	52                   	push   %edx
  c4:	50                   	push   %eax
  c5:	68 ba 07 00 00       	push   $0x7ba
  ca:	6a 01                	push   $0x1
  cc:	e8 bf 03 00 00       	call   490 <printf>
	exit();
  d1:	e8 5c 02 00 00       	call   332 <exit>
  d6:	66 90                	xchg   %ax,%ax
  d8:	66 90                	xchg   %ax,%ax
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 c2                	mov    %eax,%edx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f0:	83 c1 01             	add    $0x1,%ecx
  f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f7:	83 c2 01             	add    $0x1,%edx
  fa:	84 db                	test   %bl,%bl
  fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  ff:	75 ef                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
 101:	5b                   	pop    %ebx
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	0f b6 19             	movzbl (%ecx),%ebx
 120:	84 c0                	test   %al,%al
 122:	75 1c                	jne    140 <strcmp+0x30>
 124:	eb 2a                	jmp    150 <strcmp+0x40>
 126:	8d 76 00             	lea    0x0(%esi),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 130:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 133:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 136:	83 c1 01             	add    $0x1,%ecx
 139:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 13c:	84 c0                	test   %al,%al
 13e:	74 10                	je     150 <strcmp+0x40>
 140:	38 d8                	cmp    %bl,%al
 142:	74 ec                	je     130 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 144:	29 d8                	sub    %ebx,%eax
}
 146:	5b                   	pop    %ebx
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 152:	29 d8                	sub    %ebx,%eax
}
 154:	5b                   	pop    %ebx
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 d2                	xor    %edx,%edx
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c2 01             	add    $0x1,%edx
 173:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 177:	89 d0                	mov    %edx,%eax
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	5f                   	pop    %edi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	89 f6                	mov    %esi,%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	74 1d                	je     1de <strchr+0x2e>
    if(*s == c)
 1c1:	38 d3                	cmp    %dl,%bl
 1c3:	89 d9                	mov    %ebx,%ecx
 1c5:	75 0d                	jne    1d4 <strchr+0x24>
 1c7:	eb 17                	jmp    1e0 <strchr+0x30>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	38 ca                	cmp    %cl,%dl
 1d2:	74 0c                	je     1e0 <strchr+0x30>
  for(; *s; s++)
 1d4:	83 c0 01             	add    $0x1,%eax
 1d7:	0f b6 10             	movzbl (%eax),%edx
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strchr+0x20>
      return (char*)s;
  return 0;
 1de:	31 c0                	xor    %eax,%eax
}
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	31 f6                	xor    %esi,%esi
 1f8:	89 f3                	mov    %esi,%ebx
{
 1fa:	83 ec 1c             	sub    $0x1c,%esp
 1fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 200:	eb 2f                	jmp    231 <gets+0x41>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 208:	8d 45 e7             	lea    -0x19(%ebp),%eax
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	6a 01                	push   $0x1
 210:	50                   	push   %eax
 211:	6a 00                	push   $0x0
 213:	e8 32 01 00 00       	call   34a <read>
    if(cc < 1)
 218:	83 c4 10             	add    $0x10,%esp
 21b:	85 c0                	test   %eax,%eax
 21d:	7e 1c                	jle    23b <gets+0x4b>
      break;
    buf[i++] = c;
 21f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 223:	83 c7 01             	add    $0x1,%edi
 226:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 229:	3c 0a                	cmp    $0xa,%al
 22b:	74 23                	je     250 <gets+0x60>
 22d:	3c 0d                	cmp    $0xd,%al
 22f:	74 1f                	je     250 <gets+0x60>
  for(i=0; i+1 < max; ){
 231:	83 c3 01             	add    $0x1,%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	89 fe                	mov    %edi,%esi
 239:	7c cd                	jl     208 <gets+0x18>
 23b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 240:	c6 03 00             	movb   $0x0,(%ebx)
}
 243:	8d 65 f4             	lea    -0xc(%ebp),%esp
 246:	5b                   	pop    %ebx
 247:	5e                   	pop    %esi
 248:	5f                   	pop    %edi
 249:	5d                   	pop    %ebp
 24a:	c3                   	ret    
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	8b 75 08             	mov    0x8(%ebp),%esi
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 de                	add    %ebx,%esi
 258:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 25a:	c6 03 00             	movb   $0x0,(%ebx)
}
 25d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5f                   	pop    %edi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    
 265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <stat>:

int
stat(char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 275:	83 ec 08             	sub    $0x8,%esp
 278:	6a 00                	push   $0x0
 27a:	ff 75 08             	pushl  0x8(%ebp)
 27d:	e8 f0 00 00 00       	call   372 <open>
  if(fd < 0)
 282:	83 c4 10             	add    $0x10,%esp
 285:	85 c0                	test   %eax,%eax
 287:	78 27                	js     2b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	ff 75 0c             	pushl  0xc(%ebp)
 28f:	89 c3                	mov    %eax,%ebx
 291:	50                   	push   %eax
 292:	e8 f3 00 00 00       	call   38a <fstat>
  close(fd);
 297:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 29a:	89 c6                	mov    %eax,%esi
  close(fd);
 29c:	e8 b9 00 00 00       	call   35a <close>
  return r;
 2a1:	83 c4 10             	add    $0x10,%esp
}
 2a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a7:	89 f0                	mov    %esi,%eax
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b5:	eb ed                	jmp    2a4 <stat+0x34>
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	0f be 11             	movsbl (%ecx),%edx
 2ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 2cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2d4:	77 1f                	ja     2f5 <atoi+0x35>
 2d6:	8d 76 00             	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2e3:	83 c1 01             	add    $0x1,%ecx
 2e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ea:	0f be 11             	movsbl (%ecx),%edx
 2ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2f0:	80 fb 09             	cmp    $0x9,%bl
 2f3:	76 eb                	jbe    2e0 <atoi+0x20>
  return n;
}
 2f5:	5b                   	pop    %ebx
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    
 2f8:	90                   	nop
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
 305:	8b 5d 10             	mov    0x10(%ebp),%ebx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 db                	test   %ebx,%ebx
 310:	7e 14                	jle    326 <memmove+0x26>
 312:	31 d2                	xor    %edx,%edx
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 318:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 31c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 31f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 322:	39 d3                	cmp    %edx,%ebx
 324:	75 f2                	jne    318 <memmove+0x18>
  return vdst;
}
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5d                   	pop    %ebp
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

000003d2 <bstat>:
SYSCALL(bstat)
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <swap>:
SYSCALL(swap)
 3da:	b8 17 00 00 00       	mov    $0x17,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    
 3e2:	66 90                	xchg   %ax,%ax
 3e4:	66 90                	xchg   %ax,%ax
 3e6:	66 90                	xchg   %ax,%ax
 3e8:	66 90                	xchg   %ax,%ax
 3ea:	66 90                	xchg   %ax,%ax
 3ec:	66 90                	xchg   %ax,%ax
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	89 c6                	mov    %eax,%esi
 3f8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3fe:	85 db                	test   %ebx,%ebx
 400:	74 7e                	je     480 <printint+0x90>
 402:	89 d0                	mov    %edx,%eax
 404:	c1 e8 1f             	shr    $0x1f,%eax
 407:	84 c0                	test   %al,%al
 409:	74 75                	je     480 <printint+0x90>
    neg = 1;
    x = -xx;
 40b:	89 d0                	mov    %edx,%eax
    neg = 1;
 40d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 414:	f7 d8                	neg    %eax
 416:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 419:	31 ff                	xor    %edi,%edi
 41b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 41e:	89 ce                	mov    %ecx,%esi
 420:	eb 08                	jmp    42a <printint+0x3a>
 422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 428:	89 cf                	mov    %ecx,%edi
 42a:	31 d2                	xor    %edx,%edx
 42c:	8d 4f 01             	lea    0x1(%edi),%ecx
 42f:	f7 f6                	div    %esi
 431:	0f b6 92 04 08 00 00 	movzbl 0x804(%edx),%edx
  }while((x /= base) != 0);
 438:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 43a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 43d:	75 e9                	jne    428 <printint+0x38>
  if(neg)
 43f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 442:	8b 75 c0             	mov    -0x40(%ebp),%esi
 445:	85 c0                	test   %eax,%eax
 447:	74 08                	je     451 <printint+0x61>
    buf[i++] = '-';
 449:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 44e:	8d 4f 02             	lea    0x2(%edi),%ecx
 451:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 455:	8d 76 00             	lea    0x0(%esi),%esi
 458:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	83 ef 01             	sub    $0x1,%edi
 461:	6a 01                	push   $0x1
 463:	53                   	push   %ebx
 464:	56                   	push   %esi
 465:	88 45 d7             	mov    %al,-0x29(%ebp)
 468:	e8 e5 fe ff ff       	call   352 <write>

  while(--i >= 0)
 46d:	83 c4 10             	add    $0x10,%esp
 470:	39 df                	cmp    %ebx,%edi
 472:	75 e4                	jne    458 <printint+0x68>
    putc(fd, buf[i]);
}
 474:	8d 65 f4             	lea    -0xc(%ebp),%esp
 477:	5b                   	pop    %ebx
 478:	5e                   	pop    %esi
 479:	5f                   	pop    %edi
 47a:	5d                   	pop    %ebp
 47b:	c3                   	ret    
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = xx;
 480:	89 d0                	mov    %edx,%eax
  neg = 0;
 482:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 489:	eb 8b                	jmp    416 <printint+0x26>
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 496:	8d 45 10             	lea    0x10(%ebp),%eax
{
 499:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 49c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 49f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 4a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4a5:	0f b6 1e             	movzbl (%esi),%ebx
 4a8:	83 c6 01             	add    $0x1,%esi
 4ab:	84 db                	test   %bl,%bl
 4ad:	0f 84 b0 00 00 00    	je     563 <printf+0xd3>
 4b3:	31 d2                	xor    %edx,%edx
 4b5:	eb 39                	jmp    4f0 <printf+0x60>
 4b7:	89 f6                	mov    %esi,%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c0:	83 f8 25             	cmp    $0x25,%eax
 4c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4c6:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4cb:	74 18                	je     4e5 <printf+0x55>
  write(fd, &c, 1);
 4cd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4d6:	6a 01                	push   $0x1
 4d8:	50                   	push   %eax
 4d9:	57                   	push   %edi
 4da:	e8 73 fe ff ff       	call   352 <write>
 4df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4e8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ec:	84 db                	test   %bl,%bl
 4ee:	74 73                	je     563 <printf+0xd3>
    if(state == 0){
 4f0:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4f2:	0f be cb             	movsbl %bl,%ecx
 4f5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4f8:	74 c6                	je     4c0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fa:	83 fa 25             	cmp    $0x25,%edx
 4fd:	75 e6                	jne    4e5 <printf+0x55>
      if(c == 'd'){
 4ff:	83 f8 64             	cmp    $0x64,%eax
 502:	0f 84 f8 00 00 00    	je     600 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 508:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 50e:	83 f9 70             	cmp    $0x70,%ecx
 511:	74 5d                	je     570 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 513:	83 f8 73             	cmp    $0x73,%eax
 516:	0f 84 84 00 00 00    	je     5a0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51c:	83 f8 63             	cmp    $0x63,%eax
 51f:	0f 84 ea 00 00 00    	je     60f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 525:	83 f8 25             	cmp    $0x25,%eax
 528:	0f 84 c2 00 00 00    	je     5f0 <printf+0x160>
  write(fd, &c, 1);
 52e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 531:	83 ec 04             	sub    $0x4,%esp
 534:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 538:	6a 01                	push   $0x1
 53a:	50                   	push   %eax
 53b:	57                   	push   %edi
 53c:	e8 11 fe ff ff       	call   352 <write>
 541:	83 c4 0c             	add    $0xc,%esp
 544:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 547:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 54a:	6a 01                	push   $0x1
 54c:	50                   	push   %eax
 54d:	57                   	push   %edi
 54e:	83 c6 01             	add    $0x1,%esi
 551:	e8 fc fd ff ff       	call   352 <write>
  for(i = 0; fmt[i]; i++){
 556:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 55a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 55d:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 55f:	84 db                	test   %bl,%bl
 561:	75 8d                	jne    4f0 <printf+0x60>
    }
  }
}
 563:	8d 65 f4             	lea    -0xc(%ebp),%esp
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    
 56b:	90                   	nop
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
 578:	6a 00                	push   $0x0
 57a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 57d:	89 f8                	mov    %edi,%eax
 57f:	8b 13                	mov    (%ebx),%edx
 581:	e8 6a fe ff ff       	call   3f0 <printint>
        ap++;
 586:	89 d8                	mov    %ebx,%eax
 588:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58b:	31 d2                	xor    %edx,%edx
        ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 d0             	mov    %eax,-0x30(%ebp)
 593:	e9 4d ff ff ff       	jmp    4e5 <printf+0x55>
 598:	90                   	nop
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5a5:	83 c0 04             	add    $0x4,%eax
 5a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
          s = "(null)";
 5ab:	b8 fb 07 00 00       	mov    $0x7fb,%eax
 5b0:	85 db                	test   %ebx,%ebx
 5b2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 5b5:	0f b6 03             	movzbl (%ebx),%eax
 5b8:	84 c0                	test   %al,%al
 5ba:	74 23                	je     5df <printf+0x14f>
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c0:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5c3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5c6:	83 ec 04             	sub    $0x4,%esp
 5c9:	6a 01                	push   $0x1
          s++;
 5cb:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5ce:	50                   	push   %eax
 5cf:	57                   	push   %edi
 5d0:	e8 7d fd ff ff       	call   352 <write>
        while(*s != 0){
 5d5:	0f b6 03             	movzbl (%ebx),%eax
 5d8:	83 c4 10             	add    $0x10,%esp
 5db:	84 c0                	test   %al,%al
 5dd:	75 e1                	jne    5c0 <printf+0x130>
      state = 0;
 5df:	31 d2                	xor    %edx,%edx
 5e1:	e9 ff fe ff ff       	jmp    4e5 <printf+0x55>
 5e6:	8d 76 00             	lea    0x0(%esi),%esi
 5e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5f9:	6a 01                	push   $0x1
 5fb:	e9 4c ff ff ff       	jmp    54c <printf+0xbc>
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	e9 6b ff ff ff       	jmp    57a <printf+0xea>
 60f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 612:	83 ec 04             	sub    $0x4,%esp
 615:	8b 03                	mov    (%ebx),%eax
 617:	6a 01                	push   $0x1
 619:	88 45 e4             	mov    %al,-0x1c(%ebp)
 61c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 61f:	50                   	push   %eax
 620:	57                   	push   %edi
 621:	e8 2c fd ff ff       	call   352 <write>
 626:	e9 5b ff ff ff       	jmp    586 <printf+0xf6>
 62b:	66 90                	xchg   %ax,%ax
 62d:	66 90                	xchg   %ax,%ax
 62f:	90                   	nop

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 e0 0a 00 00       	mov    0xae0,%eax
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 640:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	39 c8                	cmp    %ecx,%eax
 645:	73 19                	jae    660 <free+0x30>
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 650:	39 d1                	cmp    %edx,%ecx
 652:	72 1c                	jb     670 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	39 d0                	cmp    %edx,%eax
 656:	73 18                	jae    670 <free+0x40>
{
 658:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65e:	72 f0                	jb     650 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 f4                	jb     658 <free+0x28>
 664:	39 d1                	cmp    %edx,%ecx
 666:	73 f0                	jae    658 <free+0x28>
 668:	90                   	nop
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 73 fc             	mov    -0x4(%ebx),%esi
 673:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 676:	39 d7                	cmp    %edx,%edi
 678:	74 19                	je     693 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 67a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 683:	39 f1                	cmp    %esi,%ecx
 685:	74 23                	je     6aa <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 687:	89 08                	mov    %ecx,(%eax)
  freep = p;
 689:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 693:	03 72 04             	add    0x4(%edx),%esi
 696:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 12                	mov    (%edx),%edx
 69d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a6:	39 f1                	cmp    %esi,%ecx
 6a8:	75 dd                	jne    687 <free+0x57>
    p->s.size += bp->s.size;
 6aa:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ad:	a3 e0 0a 00 00       	mov    %eax,0xae0
    p->s.size += bp->s.size;
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b8:	89 10                	mov    %edx,(%eax)
}
 6ba:	5b                   	pop    %ebx
 6bb:	5e                   	pop    %esi
 6bc:	5f                   	pop    %edi
 6bd:	5d                   	pop    %ebp
 6be:	c3                   	ret    
 6bf:	90                   	nop

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 15 e0 0a 00 00    	mov    0xae0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 78 07             	lea    0x7(%eax),%edi
 6d5:	c1 ef 03             	shr    $0x3,%edi
 6d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6db:	85 d2                	test   %edx,%edx
 6dd:	0f 84 a3 00 00 00    	je     786 <malloc+0xc6>
 6e3:	8b 02                	mov    (%edx),%eax
 6e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6e8:	39 cf                	cmp    %ecx,%edi
 6ea:	76 74                	jbe    760 <malloc+0xa0>
 6ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6f2:	be 00 10 00 00       	mov    $0x1000,%esi
 6f7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 6fe:	0f 43 f7             	cmovae %edi,%esi
 701:	ba 00 80 00 00       	mov    $0x8000,%edx
 706:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 70c:	0f 46 da             	cmovbe %edx,%ebx
 70f:	eb 10                	jmp    721 <malloc+0x61>
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 718:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 cf                	cmp    %ecx,%edi
 71f:	76 3f                	jbe    760 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	39 05 e0 0a 00 00    	cmp    %eax,0xae0
 727:	89 c2                	mov    %eax,%edx
 729:	75 ed                	jne    718 <malloc+0x58>
  p = sbrk(nu * sizeof(Header));
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	53                   	push   %ebx
 72f:	e8 86 fc ff ff       	call   3ba <sbrk>
  if(p == (char*)-1)
 734:	83 c4 10             	add    $0x10,%esp
 737:	83 f8 ff             	cmp    $0xffffffff,%eax
 73a:	74 1c                	je     758 <malloc+0x98>
  hp->s.size = nu;
 73c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	83 c0 08             	add    $0x8,%eax
 745:	50                   	push   %eax
 746:	e8 e5 fe ff ff       	call   630 <free>
  return freep;
 74b:	8b 15 e0 0a 00 00    	mov    0xae0,%edx
      if((p = morecore(nunits)) == 0)
 751:	83 c4 10             	add    $0x10,%esp
 754:	85 d2                	test   %edx,%edx
 756:	75 c0                	jne    718 <malloc+0x58>
        return 0;
 758:	31 c0                	xor    %eax,%eax
 75a:	eb 1c                	jmp    778 <malloc+0xb8>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 760:	39 cf                	cmp    %ecx,%edi
 762:	74 1c                	je     780 <malloc+0xc0>
        p->s.size -= nunits;
 764:	29 f9                	sub    %edi,%ecx
 766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 76c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 76f:	89 15 e0 0a 00 00    	mov    %edx,0xae0
      return (void*)(p + 1);
 775:	83 c0 08             	add    $0x8,%eax
  }
}
 778:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77b:	5b                   	pop    %ebx
 77c:	5e                   	pop    %esi
 77d:	5f                   	pop    %edi
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb e9                	jmp    76f <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 786:	c7 05 e0 0a 00 00 e4 	movl   $0xae4,0xae0
 78d:	0a 00 00 
 790:	c7 05 e4 0a 00 00 e4 	movl   $0xae4,0xae4
 797:	0a 00 00 
    base.s.size = 0;
 79a:	b8 e4 0a 00 00       	mov    $0xae4,%eax
 79f:	c7 05 e8 0a 00 00 00 	movl   $0x0,0xae8
 7a6:	00 00 00 
 7a9:	e9 3e ff ff ff       	jmp    6ec <malloc+0x2c>

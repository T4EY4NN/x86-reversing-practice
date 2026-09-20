
my_memset_O0:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .plt.sec:

Disassembly of section .text:

0000000000401156 <my_memset>:
  401156:	f3 0f 1e fa          	endbr64 
  40115a:	55                   	push   rbp
  40115b:	48 89 e5             	mov    rbp,rsp
  40115e:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  401162:	89 75 e4             	mov    DWORD PTR [rbp-0x1c],esi
  401165:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  401169:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  40116d:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  401171:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  401178:	00 
  401179:	eb 15                	jmp    401190 <my_memset+0x3a>
  40117b:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  40117f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  401183:	48 01 d0             	add    rax,rdx
  401186:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
  401189:	88 10                	mov    BYTE PTR [rax],dl
  40118b:	48 83 45 f0 01       	add    QWORD PTR [rbp-0x10],0x1
  401190:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  401194:	48 3b 45 d8          	cmp    rax,QWORD PTR [rbp-0x28]
  401198:	72 e1                	jb     40117b <my_memset+0x25>
  40119a:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  40119e:	5d                   	pop    rbp
  40119f:	c3                   	ret    

Disassembly of section .fini:

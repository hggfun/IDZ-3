	.file	"main.c"
	.intel_syntax noprefix
	.text
	.comm	file1,8,8
	.comm	file2,8,8
	.section	.rodata
.LC0:
	.string	"r"
.LC1:
	.string	"%d"
.LC3:
	.string	"w"
.LC4:
	.string	"%.8f\n"
.LC5:
	.string	"Time: %.1f"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 64
	mov	DWORD PTR -52[rbp], edi
	mov	QWORD PTR -64[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	edi, 0
	call	time@PLT
	mov	QWORD PTR -24[rbp], rax
	cmp	DWORD PTR -52[rbp], 3
	jne	.L2
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC0[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR file1[rip], rax
	mov	rax, QWORD PTR file1[rip]
	mov	rdi, rax
	call	fgetc@PLT
	sub	eax, 48
	mov	DWORD PTR -40[rbp], eax
	jmp	.L3
.L2:
	lea	rax, -40[rbp]
	mov	rsi, rax
	lea	rdi, .LC1[rip]
	mov	eax, 0
	call	__isoc99_scanf@PLT
.L3:
	mov	eax, DWORD PTR -40[rbp]
	test	eax, eax
	jne	.L4
	call	rand@PLT
	movsx	rdx, eax
	imul	rdx, rdx, -1840700269
	shr	rdx, 32
	add	edx, eax
	mov	ecx, edx
	sar	ecx, 2
	cdq
	sub	ecx, edx
	mov	edx, ecx
	mov	ecx, edx
	sal	ecx, 3
	sub	ecx, edx
	sub	eax, ecx
	mov	edx, eax
	lea	eax, 6[rdx]
	mov	DWORD PTR -40[rbp], eax
.L4:
	mov	eax, DWORD PTR -40[rbp]
	cmp	eax, 5
	jg	.L5
	mov	DWORD PTR -40[rbp], 6
	jmp	.L6
.L5:
	mov	eax, DWORD PTR -40[rbp]
	cmp	eax, 12
	jle	.L6
	mov	DWORD PTR -40[rbp], 12
.L6:
	pxor	xmm0, xmm0
	movsd	QWORD PTR -32[rbp], xmm0
	mov	DWORD PTR -36[rbp], 0
	jmp	.L7
.L8:
	mov	eax, DWORD PTR -36[rbp]
	mov	edi, eax
	mov	eax, 0
	call	antifactorial@PLT
	movsd	xmm1, QWORD PTR -32[rbp]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -32[rbp], xmm0
	add	DWORD PTR -36[rbp], 1
.L7:
	mov	eax, DWORD PTR -40[rbp]
	cmp	DWORD PTR -36[rbp], eax
	jl	.L8
	mov	edi, 0
	call	time@PLT
	mov	QWORD PTR -16[rbp], rax
	cmp	DWORD PTR -52[rbp], 3
	jne	.L9
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC3[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR file2[rip], rax
	mov	rax, QWORD PTR file2[rip]
	mov	rdx, QWORD PTR -32[rbp]
	movq	xmm0, rdx
	lea	rsi, .LC4[rip]
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	difftime@PLT
	mov	rax, QWORD PTR file2[rip]
	lea	rsi, .LC5[rip]
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	jmp	.L10
.L9:
	mov	rax, QWORD PTR -32[rbp]
	movq	xmm0, rax
	lea	rdi, .LC4[rip]
	mov	eax, 1
	call	printf@PLT
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	difftime@PLT
	lea	rdi, .LC5[rip]
	mov	eax, 1
	call	printf@PLT
.L10:
	mov	eax, 0
	mov	rsi, QWORD PTR -8[rbp]
	xor	rsi, QWORD PTR fs:40
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits

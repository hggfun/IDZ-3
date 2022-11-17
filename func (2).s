	.file	"func.c"
	.intel_syntax noprefix
	.text
	.globl	antifactorial
	.type	antifactorial, @function
antifactorial:
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR -36[rbp], edi
	mov	DWORD PTR -24[rbp], 1
	mov	DWORD PTR -20[rbp], 1
	jmp	.L2
.L3:
	mov	eax, DWORD PTR -24[rbp]
	imul	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -24[rbp], eax
	add	DWORD PTR -20[rbp], 1
.L2:
	mov	eax, DWORD PTR -20[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jle	.L3
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -16[rbp], xmm0
	cvtsi2sd	xmm1, DWORD PTR -24[rbp]
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
	pop	rbp
	ret
	.size	antifactorial, .-antifactorial
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits

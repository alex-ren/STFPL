	.file	"scratch.ll"
	.text
	.globl	id
	.align	16, 0x90
	.type	id,@function
id:                                     # @id
# BB#0:                                 # %entry
	movl	%edi, -4(%rsp)
	movl	%edi, -12(%rsp)
	movl	%edi, -8(%rsp)
	movl	-8(%rsp), %eax
	ret
.Ltmp0:
	.size	id, .Ltmp0-id

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, -28(%rbp)
	movq	%rsi, -40(%rbp)
	movl	$10, -52(%rbp)
	movb	$1, %bl
	jmp	.LBB1_2
	.align	16, 0x90
.LBB1_1:                                # %bb
                                        #   in Loop: Header=BB1_2 Depth=1
	movl	$7, %edi
	callq	id
	movl	%eax, %esi
	leaq	15(,%rsi,4), %r14
	andq	$-16, %r14
	movq	%rsp, %r15
	movq	%r15, %rax
	subq	%r14, %rax
	movq	%rax, %rsp
	movl	%esi, (%rax)
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
	movq	%rsp, %rax
	leaq	-16(%rax), %rcx
	movq	%rcx, %rsp
	movl	$9, -16(%rax)
	movl	$.L.str, %edi
	movl	$9, %esi
	xorb	%al, %al
	callq	printf
	negq	%r14
	movl	(%r15,%r14), %esi
	movl	$.L.str, %edi
	xorb	%al, %al
	callq	printf
.LBB1_2:                                # %bb1
                                        # =>This Inner Loop Header: Depth=1
	testb	%bl, %bl
	jne	.LBB1_1
# BB#3:                                 # %return
	movl	$3, %eax
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp1:
	.size	main, .Ltmp1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	 "d is %ld\n"
	.size	.L.str, 10


	.section	.note.GNU-stack,"",@progbits

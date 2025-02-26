# PSn00bSDK dynamic linker
# (C) 2021 spicyjpeg - MPL licensed
#
# This function is called by the lazy loader stubs generated by GCC in the
# .plt/.MIPS.stubs section when attempting to call a GOT entry whose address
# hasn't yet been resolved. The generated stubs conform to the MIPS ABI and
# uses the following registers:
# - $t7 = address the resolved function should return to (i.e. $ra of the
#   caller that triggered the stub)
# - $t8 = index of the function in the .dynsym symbol table
# - $t9 = _dl_resolve_wrapper itself's address

.set		noreorder
.section	.text

.global	_dl_resolve_wrapper
.type	_dl_resolve_wrapper, @function
_dl_resolve_wrapper:
	# Push the registers we're going to use onto the stack.
	addiu $sp, -16
	sw    $a0,  0($sp)
	sw    $a1,  4($sp)
	sw    $v0,  8($sp)
	sw    $t7, 12($sp) # (will be restored directly to $ra)

	# Figure out where the DLL's struct is. dlinit() places a pointer to the
	# struct in the second GOT entry, so it's just a matter of indexing the GOT
	# using $gp. Then call _dl_resolve_helper with the struct and $t8 as
	# arguments, and store the return value into $t0.
	lw    $a0, -0x7fec($gp) # (DLL *) sizeof(uint32_t) - 0x7ff0 [see dll.ld]
	move  $a1, $t8

	jal   _dl_resolve_helper
	addiu $sp, -8
	addiu $sp, 8

	move  $t0, $v0

	# Restore registers from the stack and tail-call the function at the
	# address returned by the resolver. This will cause the resolved function
	# to run and return directly to the code that called the stub.
	lw    $a0,  0($sp)
	lw    $a1,  4($sp)
	lw    $v0,  8($sp)
	lw    $ra, 12($sp)
	addiu $sp, 16

	jr    $t0
	nop

.section	.data

.global	_dl_credits
.type	_dl_credits, @object
_dl_credits:
	.asciiz "psxetc runtime dynamic linker by spicyjpeg\n"

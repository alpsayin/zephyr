
/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#include <zephyr/toolchain.h>

// import
GTEXT(_start)
// export
GTEXT(__start)

	.globl _reset
	.section .vectors.reset, "ax"
	.balign 4
	.ent _reset
	.type _reset, @function
_reset:
__start:
	brai    _start
	.end _reset

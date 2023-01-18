
/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


	.text
	.globl	microblaze_disable_icache
	.ent	microblaze_disable_icache
	.balign 4
microblaze_disable_icache:
#if CONFIG_MICROBLAZE_USE_MSR_INSTR == 1
	rtsd	r15, 8
	msrclr  r0, 0x20
#else /*CONFIG_MICROBLAZE_USE_MSR_INSTR == 1*/
	#Read the MSR register
	mfs	r8, rmsr
	#Clear the icache enable bit
	andi	r8, r8, ~(0x20)
	#Save the MSR register
	mts	rmsr, r8
	#Return
	rtsd	r15, 8
	nop
#endif
	.end	microblaze_disable_icache

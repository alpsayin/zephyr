
/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */



	.text
	.globl	microblaze_enable_interrupts
	.ent	microblaze_enable_interrupts
	.balign 4
microblaze_enable_interrupts:
#if CONFIG_MICROBLAZE_USE_MSR_INSTR == 1
	rtsd	r15, 8
	msrset  r0, 0x2
	nop
#else /*CONFIG_MICROBLAZE_USE_MSR_INSTR == 1*/
	#Read the MSR register
	mfs	r12, rmsr
	#Set the interrupt enable bit
	ori	r12, r12, 0x2
	#Save the MSR register
	mts	rmsr, r12
	#Return
	rtsd	r15, 8
	nop
#endif /*CONFIG_MICROBLAZE_USE_MSR_INSTR == 1*/
	.end	microblaze_enable_interrupts

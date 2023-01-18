
/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#define MICROBLAZE_MSR_DCACHE_ENABLE        0x00000080
#define MICROBLAZE_MSR_INTR_ENABLE          0x00000002

#ifndef CONFIG_MICROBLAZE_DCACHE_LINE_LEN
#define CONFIG_MICROBLAZE_DCACHE_LINE_LEN   1
#endif

	.text
	.globl	microblaze_flush_dcache
	.ent	microblaze_flush_dcache
	.balign 4

microblaze_flush_dcache:
#if defined(CONFIG_MICROBLAZE_USE_DCACHE) && defined(CONFIG_MICROBLAZE_ALLOW_DCACHE_WR)
	/* Align to cache line */
	addik 	r5, r0, CONFIG_MICROBLAZE_DCACHE_BASEADDR \
		& (-(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN))
	/* Compute end */
	addik	r6, r5, CONFIG_MICROBLAZE_DCACHE_BYTE_SIZE \
		& (-(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN))

L_start:
	/* Flush the Cache */
	wdc.flush r5, r0

	/* Are we at the end? */
	cmpu	r18, r5, r6
	blei	r18, L_done

	/* Branch to the beginning of the loop */
	brid	L_start
	/* Increment the address by 4 (delay slot) */
	addik	r5, r5, (CONFIG_MICROBLAZE_DCACHE_LINE_LEN * 4)
L_done:
#endif
	/* Return */
	rtsd	r15, 8
	nop
	.end	microblaze_flush_dcache

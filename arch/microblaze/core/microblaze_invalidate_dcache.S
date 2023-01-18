
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

#ifndef CONFIG_DCACHE_USE_WRITEBACK_SUPPORTED
#define MB_VERSION_LT_v720
#endif

	.text
	.globl	microblaze_invalidate_dcache
	.ent	microblaze_invalidate_dcache
	.balign 4

microblaze_invalidate_dcache:
#if defined(CONFIG_MICROBLAZE_USE_DCACHE) && defined(CONFIG_MICROBLAZE_ALLOW_DCACHE_WR)

#ifdef MB_VERSION_LT_v720
	/* Disable Dcache and interrupts before invalidating */
	mfs	r9, rmsr
	andi	r10, r9, ~(MICROBLAZE_MSR_DCACHE_ENABLE | MICROBLAZE_MSR_INTR_ENABLE)
	mts	rmsr, r10
#endif
	addik 	r5, r0, CONFIG_MICROBLAZE_DCACHE_BASEADDR \
		& (-(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN))
	/* Compute end */
	addik	r6, r5, CONFIG_MICROBLAZE_DCACHE_BYTE_SIZE \
		& (-(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN))

L_start:
	/* Invalidate the Cache */
	wdc	r5, r0

	/* Are we at the end? */
	cmpu	r18, r5, r6
	blei	r18, L_done

	/* Branch to the beginning of the loop */
	brid	L_start
	/* Increment the address by 4 (delay slot) */
	addik	r5, r5, (CONFIG_MICROBLAZE_DCACHE_LINE_LEN * 4)
L_done:
	/* Return */
	rtsd	r15, 8
#ifdef MB_VERSION_LT_v720
	/* restore MSR only for MB version < v7.20 */
	mts	rmsr, r9
#else
	nop
#endif

#else
	/* Return */
	rtsd	r15, 8
	nop
#endif
	.end	microblaze_invalidate_dcache

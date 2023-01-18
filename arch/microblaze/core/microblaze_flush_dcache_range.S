
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
#define MB_HAS_WRITEBACK_SET 0
#else
#define MB_HAS_WRITEBACK_SET CONFIG_MICROBLAZE_DCACHE_USE_WRITEBACK
#endif

	.text
	.globl	microblaze_flush_dcache_range
	.ent	microblaze_flush_dcache_range
	.balign 4

microblaze_flush_dcache_range:
#if defined(CONFIG_MICROBLAZE_USE_DCACHE) && defined(CONFIG_MICROBLAZE_ALLOW_DCACHE_WR)

/* Disable Dcache and interrupts before invalidating */
#ifdef MB_VERSION_LT_v720
	mfs	r9, rmsr
	andi	r10, r9, ~(MICROBLAZE_MSR_DCACHE_ENABLE | MICROBLAZE_MSR_INTR_ENABLE)
	mts	rmsr, r10
#endif
	/* Skip loop if size is zero */
	beqi    r6, L_done

	/* Compute end address */
	add	r6, r5, r6
	addik   r6, r6, -1

	/* Align end down to cache line */
	andi    r6, r6, -(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN)
	/* Align start down to cache line */
	andi    r5, r5, -(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN)

/* Use a different scheme for MB version < v7.20 or when caches are write-through */
#if MB_HAS_WRITEBACK_SET == 0

L_start:
	/* Are we at the end? */
	cmpu	r18, r5, r6
	blti	r18, L_done

	/* Invalidate the cache line */
	wdc     r5, r0

	/* Branch to the beginning of the loop */
	brid	L_start
	/* Increment the address by 4 (delay slot) */
	addik	r5, r5, (CONFIG_MICROBLAZE_DCACHE_LINE_LEN * 4)
#else
	rsubk   r6, r5, r6
	/* r6 will now contain (count of bytes - (4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN)) */

L_start:
	/* Flush the cache line */
	wdc.flush r5, r6
	bneid   r6, L_start
	addik   r6, r6, -(CONFIG_MICROBLAZE_DCACHE_LINE_LEN * 4)
#endif

L_done:
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
	.end	microblaze_flush_dcache_range


/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#define CACHEABLE_REGION_SIZE \
		(CONFIG_MICROBLAZE_DCACHE_HIGHADDR - CONFIG_MICROBLAZE_DCACHE_BASEADDR)

	.text
	.globl	microblaze_flush_cache_ext
	.ent	microblaze_flush_cache_ext
	.balign 4

microblaze_flush_cache_ext:

#if ((CONFIG_MICROBLAZE_INTERCONNECT==3) && (CONFIG_MICROBLAZE_USE_DCACHE==1))
	addik	r5, r0, CONFIG_MICROBLAZE_DCACHE_BASEADDR \
		& (-(4 * CONFIG_MICROBLAZE_DCACHE_LINE_LEN))

	addik	r6, r0, CACHEABLE_REGION_SIZE-(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)
	andi	r6, r6, -(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)

Loop_start:
	wdc.ext.flush r5, r6
#if defined (__arch64__)
	addlik	r6, r6,-(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)
	beagei r6, Loop_start
#else
	bgtid	r6,Loop_start
	addik	r6, r6,-(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)
#endif
#endif
	rtsd	r15, 8
	nop
	.end	microblaze_flush_cache_ext

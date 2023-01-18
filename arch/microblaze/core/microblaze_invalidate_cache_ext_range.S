
/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


	.text
	.globl	microblaze_invalidate_cache_ext_range
	.ent	microblaze_invalidate_cache_ext_range
	.balign 4

microblaze_invalidate_cache_ext_range:
#if ((CONFIG_MICROBLAZE_INTERCONNECT==3) && (CONFIG_MICROBLAZE_USE_DCACHE==1))
	beqi	r6, Loop_done

	add	r6, r5, r6
	addik	r6, r6, -1

	andi	r6, r6, -(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)
	andi	r5, r5, -(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)

	rsubk	r6, r5, r6

Loop_start:
	wdc.ext.clear r5, r6
	bneid	r6, Loop_start
	addik	r6, r6, -(4 * CONFIG_MICROBLAZE_EXT_CACHE_LINE_LEN)

Loop_done:
#endif
	rtsd	r15, 8
	nop

	.end	microblaze_invalidate_cache_ext_range

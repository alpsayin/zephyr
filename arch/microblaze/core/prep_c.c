/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */



#include <zephyr/arch/cpu.h>
#include <zephyr/cache.h>
#include <zephyr/irq.h>

#include <kernel_internal.h>

/**
 *
 * @brief Prepare to and run C code
 *
 * This routine prepares for the execution of and runs C code.
 *
 * @return N/A
 */

void _PrepC(void)
{
	microblaze_disable_interrupts();

#if defined(CONFIG_CACHE_MANAGEMENT)
#if defined(CONFIG_ICACHE)
	cache_instr_enable();
#endif
#if defined(CONFIG_DCACHE)
	cache_data_enable();
#endif
#endif

	z_bss_zero();

	z_cstart();
	CODE_UNREACHABLE;
}

/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#include <errno.h>

#include <zephyr/arch/cpu.h>
#include <zephyr/cache.h>
#include <zephyr/kernel.h>

#include <microblaze/mb_interface.h>

void arch_dcache_enable(void)
{
	microblaze_enable_dcache();
}

void arch_dcache_disable(void)
{
	microblaze_disable_dcache();
}

void arch_icache_enable(void)
{
	microblaze_enable_icache();
}

void arch_icache_disable(void)
{
	microblaze_disable_icache();
}

int arch_dcache_all(int op)
{
	if (op & K_CACHE_WB) {
		microblaze_flush_cache_ext();
#if (CONFIG_MICROBLAZE_DCACHE_USE_WRITEBACK == 1)
		microblaze_flush_dcache();
#else
		microblaze_invalidate_dcache();
#endif /* CONFIG_MICROBLAZE_DCACHE_USE_WRITEBACK */
	}
	if (op & K_CACHE_INVD) {
		microblaze_invalidate_cache_ext();
		microblaze_invalidate_dcache();
	}
	return 0;
}

int arch_dcache_range(void *addr, size_t size, int op)
{
	if (op & K_CACHE_WB) {
		microblaze_flush_cache_ext_range(addr, size);
#if (CONFIG_MICROBLAZE_DCACHE_USE_WRITEBACK == 1)
		microblaze_flush_dcache_range((addr), (size));
#else
		microblaze_invalidate_dcache_range((addr), (size));
#endif /* CONFIG_MICROBLAZE_DCACHE_USE_WRITEBACK */
	}
	if (op & K_CACHE_INVD) {
		microblaze_invalidate_cache_ext_range(addr, size);
		microblaze_invalidate_dcache_range(addr, size);
	}
	return 0;
}

int arch_icache_all(int op)
{
	if (op & K_CACHE_WB) {
		return -ENOTSUP;
	}
	if (op & K_CACHE_INVD) {
		microblaze_invalidate_cache_ext();
		microblaze_invalidate_icache();
	}
	return 0;
}

int arch_icache_range(void *addr, size_t size, int op)
{
	if (op & K_CACHE_WB) {
		return -ENOTSUP;
	}
	if (op & K_CACHE_INVD) {
		microblaze_invalidate_cache_ext_range(addr, size);
		microblaze_invalidate_icache_range(addr, size);
	}
	return 0;
}

size_t arch_dcache_line_size_get(void)
{
	return CONFIG_MICROBLAZE_DCACHE_BYTE_SIZE / CONFIG_MICROBLAZE_DCACHE_LINE_LEN;
}

size_t arch_icache_line_size_get(void)
{
	return CONFIG_MICROBLAZE_ICACHE_BYTE_SIZE / CONFIG_MICROBLAZE_ICACHE_LINE_LEN;
}

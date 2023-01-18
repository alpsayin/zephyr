# Copyright 2022 Advanced Micro Devices, Inc. (AMD)
# SPDX-License-Identifier: Apache-2.0


zephyr_library()

zephyr_library_sources(
	cache.c
	cpu_idle.c
	crt0.S
	exception.S
	fatal.c
	irq_manage.c
	isr.S
	emulate_isr.S
	microblaze_disable_exceptions.S
	microblaze_disable_dcache.S
	microblaze_disable_icache.S
	microblaze_disable_interrupts.S
	microblaze_enable_exceptions.S
	microblaze_enable_interrupts.S
	microblaze_enable_dcache.S
	microblaze_enable_icache.S
	microblaze_flush_cache_ext.S
	microblaze_flush_cache_ext_range.S
	microblaze_flush_dcache.S
	microblaze_flush_dcache_range.S
	microblaze_invalidate_cache_ext.S
	microblaze_invalidate_cache_ext_range.S
	microblaze_invalidate_dcache.S
	microblaze_invalidate_dcache_range.S
	microblaze_invalidate_icache.S
	microblaze_invalidate_icache_range.S
	prep_c.c
	reboot.c
	reset.S
	swap.S
	thread.c
)

zephyr_library_sources_ifdef(CONFIG_IRQ_OFFLOAD irq_offload.c)

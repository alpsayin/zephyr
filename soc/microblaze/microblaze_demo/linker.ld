/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#include <layout.h>

_BRAM0_LOC = _LAYOUT_BRAM0_LOC;
_BRAM0_SIZE = _LAYOUT_BRAM0_SIZE;
_BRAM1_LOC = _LAYOUT_BRAM1_LOC;
_BRAM1_SIZE = _LAYOUT_BRAM1_SIZE;
_DDR_LOC = _LAYOUT_DDR_LOC;
_DDR_SIZE = _LAYOUT_DDR_SIZE;

MEMORY
{
	app_ram (RX) : ORIGIN = _DDR_LOC, LENGTH = _DDR_SIZE

	boot_ram (W) : ORIGIN = _BRAM0_LOC, LENGTH = _BRAM0_SIZE
	boot_rom (RX) : ORIGIN = _BRAM1_LOC, LENGTH = _BRAM1_SIZE

	/* Used by and documented in include/linker/intlist.ld */
	IDT_LIST  (wx)      : ORIGIN = 0xFFFFF7FF, LENGTH = 2K
}

#include <zephyr/arch/microblaze/linker.ld>

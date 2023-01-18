# Copyright 2022 Advanced Micro Devices, Inc. (AMD)
# SPDX-License-Identifier: Apache-2.0


# Set output binary format
set_property(GLOBAL PROPERTY PROPERTY_OUTPUT_FORMAT elf32-microblaze)

add_subdirectory(core)
zephyr_include_directories(include)

if(DEFINED CONFIG_BIG_ENDIAN)
	set(extended_objdump_endianness "-EB")
else()
	set(extended_objdump_endianness "-EL")
endif()

if(DEFINED CONFIG_GENERATE_EXTENDED_DISASSEMBLY)
	set_property(GLOBAL APPEND PROPERTY extra_post_build_commands
		COMMAND $<TARGET_PROPERTY:bintools,disassembly_command>
		${extended_objdump_endianness}
		"-hSst"
		${disassembly_type}
		$<TARGET_PROPERTY:bintools,disassembly_flag_infile>${KERNEL_ELF_NAME}
		$<TARGET_PROPERTY:bintools,disassembly_flag_outfile>extended_${KERNEL_LST_NAME}
		$<TARGET_PROPERTY:bintools,disassembly_flag_final>
	)
endif()

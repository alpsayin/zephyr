
# Copyright 2022 Advanced Micro Devices, Inc. (AMD)
# SPDX-License-Identifier: Apache-2.0


set(SUPPORTED_EMU_PLATFORMS qemu)
set(QEMU_ARCH xilinx-microblazeel)

set(QEMU_CPU_TYPE_${ARCH} microblaze)

set(QEMU_FLAGS_${ARCH}
	-machine microblaze-fdt
	-nographic
	-hw-dtb ${ZEPHYR_BASE}/boards/${ARCH}/${BOARD}/board-microblaze-zephyr-demo.dtb
	# TODO: introduce a feature flags for debug flags
	# -D mb.log   # if you enable anything from below, you probably want this too.
	# -d int      # show interrupts/exceptions in short format
	# -d in_asm   # show target assembly code for each compiled TB
	# -d exec     # show trace before each executed TB (lots of logs)
	# --trace "memory_region_ops_*"
	# --trace "exec_tb*"
)

if(DEFINED ENV{DEBUGSERVER_LISTEN_PORT})
	set(DEBUGSERVER_LISTEN_PORT $ENV{DEBUGSERVER_LISTEN_PORT})
else()
	set(DEBUGSERVER_LISTEN_PORT 1234)
endif()
message(STATUS "Using " ${DEBUGSERVER_LISTEN_PORT} " for debugserver_qemu listen port")

set(QEMU_GDB_FLAGS
		tcp:127.0.0.1:${DEBUGSERVER_LISTEN_PORT}
)

set(QEMU_KERNEL_OPTION
	-kernel \$<TARGET_FILE:\${logical_target_for_zephyr_elf}>
)

board_set_debugger_ifnset(qemu)

add_custom_target(debug_qemu
		COMMAND
		${CROSS_COMPILE}gdb
		-ex \"target extended-remote 127.0.0.1:${DEBUGSERVER_LISTEN_PORT}\"
		-ex \"set disassemble-next-line on\"
		${APPLICATION_BINARY_DIR}/zephyr/${KERNEL_ELF_NAME}
		USES_TERMINAL
)

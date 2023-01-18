/*
 * Copyright (c) 2022 Advanced Micro Devices, Inc. (AMD)
 *
 * SPDX-License-Identifier: Apache-2.0
 */


#ifndef ZEPHYR_ARCH_MICROBLAZE_INCLUDE_XPARAM_HELPER_H_
#define ZEPHYR_ARCH_MICROBLAZE_INCLUDE_XPARAM_HELPER_H_

#define GET_BASEADDR(dev) (dev##_BASEADDR)
#define GET_HIGHADDR(dev) (dev##_HIGHADDR)
#define GET_SIZE(dev)	  (GET_HIGHADDR(dev) - GET_BASEADDR(dev) + 1)
#define GET_RANGE(dev)	  GET_BASEADDR(dev) GET_SIZE(dev)

#endif /* ZEPHYR_ARCH_MICROBLAZE_INCLUDE_XPARAM_HELPER_H_ */

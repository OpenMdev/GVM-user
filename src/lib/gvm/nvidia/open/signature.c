/*
 * Copyright (C) 2666680 Ontario Inc.
 *
 * SPDX-License-Identifier: GPL-2.0+
 *
 */
#include <gvm/nvidia/open/signature.h>

#include <ctrl/ctrla081.h>

#include <string.h>

// HARDCODED SIGNATURE
static const char SIGN[128] = {
0x12, 0x57, 0xc7, 0xf4, 0x5a, 0x14, 0x60, 0xba, 0x66, 0xaf, 0x59, 0xe5, 0x20, 0x5b, 0x7c, 0x4a,
0x0a, 0x16, 0x8f, 0xac, 0xd8, 0x52, 0xa2, 0x45, 0xb5, 0xf1, 0x64, 0xc7, 0xfd, 0x40, 0x1d, 0x2c,
0xa9, 0x58, 0x7d, 0x57, 0x39, 0xa2, 0x8f, 0x34, 0x7a, 0x3e, 0x5b, 0xfb, 0x47, 0x08, 0x30, 0x1b,
0xbd, 0x25, 0x86, 0xeb, 0x27, 0x7d, 0x56, 0x11, 0x7c, 0x1f, 0xba, 0xc9, 0xa2, 0x78, 0xbc, 0xd0,
0x1f, 0xe4, 0x5e, 0xd9, 0x3e, 0x29, 0xba, 0x97, 0xd6, 0xf8, 0xeb, 0xff, 0x9a, 0x95, 0xa4, 0x53,
0x95, 0xc1, 0xbe, 0x47, 0x8f, 0xad, 0xff, 0x84, 0xd2, 0xa8, 0xe2, 0xfc, 0x4f, 0x34, 0x29, 0x84,
0x4b, 0x21, 0x0b, 0xe2, 0x72, 0x17, 0xe6, 0x91, 0xf2, 0xbb, 0x0f, 0xd1, 0x51, 0x52, 0x38, 0x67,
0x73, 0x5a, 0x75, 0x95, 0x4c, 0x85, 0x93, 0x06, 0x49, 0x26, 0x9a, 0xea, 0x59, 0x61, 0xb8, 0xcb
};

void nvidia_open_create_signature(NVA081_CTRL_VGPU_INFO *info)
{
    if (info != NULL)
        memcpy(info->vgpuSignature, SIGN, 128);
}
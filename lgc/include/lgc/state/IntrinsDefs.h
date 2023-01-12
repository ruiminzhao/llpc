/*
 ***********************************************************************************************************************
 *
 *  Copyright (c) 2017-2022 Advanced Micro Devices, Inc. All Rights Reserved.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *
 **********************************************************************************************************************/
/**
 ***********************************************************************************************************************
 * @file  IntrinsDefs.h
 * @brief LLPC header file: contains various definitions used by LLPC AMDGPU-backend intrinsics.
 ***********************************************************************************************************************
 */
#pragma once

#include <stdint.h>

namespace lgc {

// Limits
static const unsigned MaxTessPatchVertices = (1 << 6) - 1;

static const unsigned MaxGeometryInvocations = (1 << 7) - 1;
static const unsigned MaxGeometryOutputVertices = (1 << 11) - 1;

static const unsigned MaxComputeWorkgroupSize = (1 << 16) - 1;

// Messages that can be generated by using s_sendmsg
static const unsigned HsTessFactor = 2; // HS Tessellation factor is all zero or one
static const unsigned GsDone = 3;       // GS wave is done
static const unsigned GsAllocReq = 9;   // GS requests that parameter cache space be allocated
static const unsigned GsCut = 0x12;     // [3:0] = 2 (GS), [5:4] = 1 (cut)
static const unsigned GsEmit = 0x22;    // [3:0] = 2 (GS), [5:4] = 2 (emit)

static const unsigned GsCutStreaM0 = 0x12;  // [3:0] = 2 (GS), [5:4] = 1 (cut), [9:8] = 0 (stream0)
static const unsigned GsCutStreaM1 = 0x112; // [3:0] = 2 (GS), [5:4] = 1 (cut), [9:8] = 1 (stream1)
static const unsigned GsCutStreaM2 = 0x212; // [3:0] = 2 (GS), [5:4] = 1 (cut), [9:8] = 2 (stream2)
static const unsigned GsCutStreaM3 = 0x312; // [3:0] = 2 (GS), [5:4] = 1 (cut), [9:8] = 3 (stream3)

static const unsigned GsEmitStreaM0 = 0x22;  // [3:0] = 2 (GS), [5:4] = 2 (emit), [9:8] = 0 (stream0)
static const unsigned GsEmitStreaM1 = 0x122; // [3:0] = 2 (GS), [5:4] = 2 (emit), [9:8] = 1 (stream1)
static const unsigned GsEmitStreaM2 = 0x222; // [3:0] = 2 (GS), [5:4] = 2 (emit), [9:8] = 2 (stream2)
static const unsigned GsEmitStreaM3 = 0x322; // [3:0] = 2 (GS), [5:4] = 2 (emit), [9:8] = 3 (stream3)

static const unsigned GsEmitCutStreamIdShift = 0x8;  // Shift of STREAM_ID of the message GS_EMIT/GS_CUT
static const unsigned GsEmitCutStreamIdMask = 0x300; // Mask of STREAM_ID of the message GS_EMIT/GS_CUT

static const unsigned GetRealTime = 0x83; // [7] = 1, [6:0] = 3

// Enumerates address spaces valid for AMD GPU (similar to LLVM header AMDGPU.h)
enum AddrSpace {
  ADDR_SPACE_FLAT = 0,               // Flat memory
  ADDR_SPACE_GLOBAL = 1,             // Global memory
  ADDR_SPACE_REGION = 2,             // GDS memory
  ADDR_SPACE_LOCAL = 3,              // Local memory
  ADDR_SPACE_CONST = 4,              // Constant memory
  ADDR_SPACE_PRIVATE = 5,            // Private memory
  ADDR_SPACE_CONST_32BIT = 6,        // Constant 32-bit memory
  ADDR_SPACE_BUFFER_FAT_POINTER = 7, // Buffer fat-pointer memory
  ADDR_SPACE_MAX = ADDR_SPACE_BUFFER_FAT_POINTER
};

// Enumerates the target for "export" instruction.
enum ExportTarget {
  EXP_TARGET_MRT_0 = 0,       // MRT 0..7
  EXP_TARGET_Z = 8,           // Z
  EXP_TARGET_PS_NULL = 9,     // Null pixel shader export (no data)
  EXP_TARGET_POS_0 = 12,      // Position 0
  EXP_TARGET_POS_1 = 13,      // Position 1
  EXP_TARGET_POS_2 = 14,      // Position 2
  EXP_TARGET_POS_3 = 15,      // Position 3
  EXP_TARGET_POS_4 = 16,      // Position 4
  EXP_TARGET_PRIM = 20,       // NGG primitive data (connectivity data)
  EXP_TARGET_DUAL_SRC_0 = 21, // Dual source blend left
  EXP_TARGET_DUAL_SRC_1 = 22, // Dual source blend right
  EXP_TARGET_PARAM_0 = 32,    // Param 0
                              // Param 1..30
  EXP_TARGET_PARAM_31 = 63,   // Param 31
};

// Enumerates shader export format used for "export" instruction.
enum ExportFormat {
  EXP_FORMAT_ZERO = 0,         // ZERO
  EXP_FORMAT_32_R = 1,         // 32_R
  EXP_FORMAT_32_GR = 2,        // 32_GR
  EXP_FORMAT_32_AR = 3,        // 32_AR
  EXP_FORMAT_FP16_ABGR = 4,    // FP16_ABGR
  EXP_FORMAT_UNORM16_ABGR = 5, // UNORM16_ABGR
  EXP_FORMAT_SNORM16_ABGR = 6, // SNORM16_ABGR
  EXP_FORMAT_UINT16_ABGR = 7,  // UINT16_ABGR
  EXP_FORMAT_SINT16_ABGR = 8,  // SINT16_ABGR
  EXP_FORMAT_32_ABGR = 9,      // 32_ABGR
};

// Enumerates data format of data in CB.
enum ColorDataFormat {
  COLOR_DATA_FORMAT_INVALID = 0,         // Invalid
  COLOR_DATA_FORMAT_8 = 1,               // 8
  COLOR_DATA_FORMAT_16 = 2,              // 16
  COLOR_DATA_FORMAT_8_8 = 3,             // 8_8
  COLOR_DATA_FORMAT_32 = 4,              // 32
  COLOR_DATA_FORMAT_16_16 = 5,           // 16_16
  COLOR_DATA_FORMAT_10_11_11 = 6,        // 10_11_11
  COLOR_DATA_FORMAT_11_11_10 = 7,        // 11_11_10
  COLOR_DATA_FORMAT_10_10_10_2 = 8,      // 10_10_10_2
  COLOR_DATA_FORMAT_2_10_10_10 = 9,      // 2_10_10_10
  COLOR_DATA_FORMAT_8_8_8_8 = 10,        // 8_8_8_8
  COLOR_DATA_FORMAT_32_32 = 11,          // 32_32
  COLOR_DATA_FORMAT_16_16_16_16 = 12,    // 16_16_16_16
  COLOR_DATA_FORMAT_32_32_32_32 = 14,    // 32_32_32_32
  COLOR_DATA_FORMAT_5_6_5 = 16,          // 5_6_5
  COLOR_DATA_FORMAT_1_5_5_5 = 17,        // 1_5_5_5
  COLOR_DATA_FORMAT_5_5_5_1 = 18,        // 5_5_5_1
  COLOR_DATA_FORMAT_4_4_4_4 = 19,        // 4_4_4_4
  COLOR_DATA_FORMAT_8_24 = 20,           // 8_24
  COLOR_DATA_FORMAT_24_8 = 21,           // 24_8
  COLOR_DATA_FORMAT_X24_8_32_FLOAT = 22, // X24_8_32_FLOAT
  COLOR_DATA_FORMAT_2_10_10_10_6E4 = 31, // 2_10_10_10_6E4
};

// Enumerates numeric format of data in CB.
enum ColorNumFormat {
  COLOR_NUM_FORMAT_UNORM = 0,   // UNORM
  COLOR_NUM_FORMAT_SNORM = 1,   // SNORM
  COLOR_NUM_FORMAT_USCALED = 2, // USCALED
  COLOR_NUM_FORMAT_SSCALED = 3, // SSCALED
  COLOR_NUM_FORMAT_UINT = 4,    // UINT
  COLOR_NUM_FORMAT_SINT = 5,    // SINT
  COLOR_NUM_FORMAT_SRGB = 6,    // SRGB
  COLOR_NUM_FORMAT_FLOAT = 7,   // FLOAT
};

// Enumerates CB component swap mode.
enum ColorSwap {
  COLOR_SWAP_STD = 0,     // STD
  COLOR_SWAP_ALT = 1,     // ALT
  COLOR_SWAP_STD_REV = 2, // STD_REV
  COLOR_SWAP_ALT_REV = 3, // ALT_REV
};

// Enumerates parameter values used in "flat" interpolation (v_interp_mov).
enum InterpParam {
  INTERP_PARAM_P10 = 0, // P10
  INTERP_PARAM_P20 = 1, // P20
  INTERP_PARAM_P0 = 2,  // P0
};

// Enumerates data parallel control (dpp_ctrl) values.
enum class DppCtrl : unsigned {
  DppQuadPerm0000 = 0x000,
  DppQuadPerm1111 = 0x055,
  DppQuadPerm2222 = 0x0AA,
  DppQuadPerm3333 = 0x0FF,
  DppQuadPerm1032 = 0x0B1,
  DppQuadPerm2301 = 0x04E,
  DppQuadPerm0123 = 0x0E4,
  DppQuadPerm3210 = 0x01B,
  DppRowSl1 = 0x101,
  DppRowSl2 = 0x102,
  DppRowSl3 = 0x103,
  DppRowSl4 = 0x104,
  DppRowSl5 = 0x105,
  DppRowSl6 = 0x106,
  DppRowSl7 = 0x107,
  DppRowSl8 = 0x108,
  DppRowSl9 = 0x109,
  DppRowSl10 = 0x10A,
  DppRowSl11 = 0x10B,
  DppRowSl12 = 0x10C,
  DppRowSl13 = 0x10D,
  DppRowSl14 = 0x10E,
  DppRowSl15 = 0x10F,
  DppRowSr1 = 0x111,
  DppRowSr2 = 0x112,
  DppRowSr3 = 0x113,
  DppRowSr4 = 0x114,
  DppRowSr5 = 0x115,
  DppRowSr6 = 0x116,
  DppRowSr7 = 0x117,
  DppRowSr8 = 0x118,
  DppRowSr9 = 0x119,
  DppRowSr10 = 0x11A,
  DppRowSr11 = 0x11B,
  DppRowSr12 = 0x11C,
  DppRowSr13 = 0x11D,
  DppRowSr14 = 0x11E,
  DppRowSr15 = 0x11F,
  DppRowRr1 = 0x121,
  DppRowRr2 = 0x122,
  DppRowRr3 = 0x123,
  DppRowRr4 = 0x124,
  DppRowRr5 = 0x125,
  DppRowRr6 = 0x126,
  DppRowRr7 = 0x127,
  DppRowRr8 = 0x128,
  DppRowRr9 = 0x129,
  DppRowRr10 = 0x12A,
  DppRowRr11 = 0x12B,
  DppRowRr12 = 0x12C,
  DppRowRr13 = 0x12D,
  DppRowRr14 = 0x12E,
  DppRowRr15 = 0x12F,

  // WfSl and WfSr are not available on GFX10+.
  DppWfSl1 = 0x130,
  DppWfSr1 = 0x138,

  DppRowMirror = 0x140,
  DppRowHalfMirror = 0x141,

  // RowBcast modes are not available on GFX10+.
  DppRowBcast15 = 0x142,
  DppRowBcast31 = 0x143,

  // RowXmask and RowShare modes are only available on GFX10+.
  DppRowShare0 = 0x150,
  DppRowShare1 = 0x151,
  DppRowShare2 = 0x152,
  DppRowShare3 = 0x153,
  DppRowShare4 = 0x154,
  DppRowShare5 = 0x155,
  DppRowShare6 = 0x156,
  DppRowShare7 = 0x157,
  DppRowShare8 = 0x158,
  DppRowShare9 = 0x159,
  DppRowShare10 = 0x15A,
  DppRowShare11 = 0x15B,
  DppRowShare12 = 0x15C,
  DppRowShare13 = 0x15D,
  DppRowShare14 = 0x15E,
  DppRowShare15 = 0x15F,
  DppRowXmask0 = 0x160,
  DppRowXmask1 = 0x161,
  DppRowXmask2 = 0x162,
  DppRowXmask3 = 0x163,
  DppRowXmask4 = 0x164,
  DppRowXmask5 = 0x165,
  DppRowXmask6 = 0x166,
  DppRowXmask7 = 0x167,
  DppRowXmask8 = 0x168,
  DppRowXmask9 = 0x169,
  DppRowXmask10 = 0x16A,
  DppRowXmask11 = 0x16B,
  DppRowXmask12 = 0x16C,
  DppRowXmask13 = 0x16D,
  DppRowXmask14 = 0x16E,
  DppRowXmask15 = 0x16F,
};

// Enumerates data format of data in memory buffer.
enum BufDataFmt {
  BUF_DATA_FORMAT_INVALID = 0,      // Invalid
  BUF_DATA_FORMAT_8 = 1,            // 8
  BUF_DATA_FORMAT_16 = 2,           // 16
  BUF_DATA_FORMAT_8_8 = 3,          // 8_8
  BUF_DATA_FORMAT_32 = 4,           // 32
  BUF_DATA_FORMAT_16_16 = 5,        // 16_16
  BUF_DATA_FORMAT_10_11_11 = 6,     // 10_11_11
  BUF_DATA_FORMAT_11_11_10 = 7,     // 11_11_10
  BUF_DATA_FORMAT_10_10_10_2 = 8,   // 10_10_10_2
  BUF_DATA_FORMAT_2_10_10_10 = 9,   // 2_10_10_10
  BUF_DATA_FORMAT_8_8_8_8 = 10,     // 8_8_8_8
  BUF_DATA_FORMAT_32_32 = 11,       // 32_32
  BUF_DATA_FORMAT_16_16_16_16 = 12, // 16_16_16_16
  BUF_DATA_FORMAT_32_32_32 = 13,    // 32_32_32
  BUF_DATA_FORMAT_32_32_32_32 = 14, // 32_32_32_32
};

// Enumerates numeric format of data in memory buffer.
enum BufNumFmt {
  BUF_NUM_FORMAT_UNORM = 0,     // Unorm
  BUF_NUM_FORMAT_SNORM = 1,     // Snorm
  BUF_NUM_FORMAT_USCALED = 2,   // Uscaled
  BUF_NUM_FORMAT_SSCALED = 3,   // Sscaled
  BUF_NUM_FORMAT_UINT = 4,      // Uint
  BUF_NUM_FORMAT_SINT = 5,      // Sint
  BUF_NUM_FORMAT_SNORM_OGL = 6, // Snorm_ogl
  BUF_NUM_FORMAT_FLOAT = 7,     // Float
};

// Enumerates float round modes.
enum FloatRoundMode {
  FP_ROUND_TO_NEAREST_EVEN = 0, // RTE
  FP_ROUND_TO_POSITIVE_INF = 1, // RTP
  FP_ROUND_TO_NEGATIVE_INF = 2, // RTN
  FP_ROUND_TO_ZERO = 3,         // RTZ
};

// Enumerates float denormal modes.
enum FloatDenormMode {
  FP_DENORM_FLUSH_IN_OUT = 0, // Flush input/output denormals
  FP_DENORM_FLUSH_OUT = 1,    // Allow input denormals and flush output denormals
  FP_DENORM_FLUSH_IN = 2,     // Flush input denormals and allow output denormals
  FP_DENORM_FLUSH_NONE = 3,   // Allow input/output denormals
};

// Represents float modes for 16-bit/64-bit and 32-bit floating-point types.
union FloatMode {
  struct {
    unsigned fp32RoundMode : 2;      // FP32 round mode
    unsigned fp16fp64RoundMode : 2;  // FP16/FP64 round mode
    unsigned fp32DenormMode : 2;     // FP32 denormal mode
    unsigned fp16fp64DenormMode : 2; // FP16/FP64 denormal mode
  } bits;

  unsigned u32All;
};

enum BufFormat {
  BUF_FORMAT_INVALID = 0x00000000,
  BUF_FORMAT_8_UNORM = 0x00000001,
  BUF_FORMAT_8_SNORM = 0x00000002,
  BUF_FORMAT_8_USCALED = 0x00000003,
  BUF_FORMAT_8_SSCALED = 0x00000004,
  BUF_FORMAT_8_UINT = 0x00000005,
  BUF_FORMAT_8_SINT = 0x00000006,
  BUF_FORMAT_16_UNORM = 0x00000007,
  BUF_FORMAT_16_SNORM = 0x00000008,
  BUF_FORMAT_16_USCALED = 0x00000009,
  BUF_FORMAT_16_SSCALED = 0x0000000A,
  BUF_FORMAT_16_UINT = 0x0000000B,
  BUF_FORMAT_16_SINT = 0x0000000C,
  BUF_FORMAT_16_FLOAT = 0x0000000D,
  BUF_FORMAT_8_8_UNORM = 0x0000000E,
  BUF_FORMAT_8_8_SNORM = 0x0000000F,
  BUF_FORMAT_8_8_USCALED = 0x00000010,
  BUF_FORMAT_8_8_SSCALED = 0x00000011,
  BUF_FORMAT_8_8_UINT = 0x00000012,
  BUF_FORMAT_8_8_SINT = 0x00000013,
  BUF_FORMAT_32_UINT = 0x00000014,
  BUF_FORMAT_32_SINT = 0x00000015,
  BUF_FORMAT_32_FLOAT = 0x00000016,
  BUF_FORMAT_16_16_UNORM = 0x00000017,
  BUF_FORMAT_16_16_SNORM = 0x00000018,
  BUF_FORMAT_16_16_USCALED = 0x00000019,
  BUF_FORMAT_16_16_SSCALED = 0x0000001A,
  BUF_FORMAT_16_16_UINT = 0x0000001B,
  BUF_FORMAT_16_16_SINT = 0x0000001C,
  BUF_FORMAT_16_16_FLOAT = 0x0000001D,

  BUF_FORMAT_10_11_11_UNORM_GFX10 = 0x0000001E,
  BUF_FORMAT_10_11_11_SNORM_GFX10 = 0x0000001F,
  BUF_FORMAT_10_11_11_USCALED_GFX10 = 0x00000020,
  BUF_FORMAT_10_11_11_SSCALED_GFX10 = 0x00000021,
  BUF_FORMAT_10_11_11_UINT_GFX10 = 0x00000022,
  BUF_FORMAT_10_11_11_SINT_GFX10 = 0x00000023,
  BUF_FORMAT_10_11_11_FLOAT_GFX10 = 0x00000024,
  BUF_FORMAT_11_11_10_UNORM_GFX10 = 0x00000025,
  BUF_FORMAT_11_11_10_SNORM_GFX10 = 0x00000026,
  BUF_FORMAT_11_11_10_USCALED_GFX10 = 0x00000027,
  BUF_FORMAT_11_11_10_SSCALED_GFX10 = 0x00000028,
  BUF_FORMAT_11_11_10_UINT_GFX10 = 0x00000029,
  BUF_FORMAT_11_11_10_SINT_GFX10 = 0x0000002A,
  BUF_FORMAT_11_11_10_FLOAT_GFX10 = 0x0000002B,
  BUF_FORMAT_10_10_10_2_UNORM_GFX10 = 0x0000002C,
  BUF_FORMAT_10_10_10_2_SNORM_GFX10 = 0x0000002D,
  BUF_FORMAT_10_10_10_2_USCALED_GFX10 = 0x0000002E,
  BUF_FORMAT_10_10_10_2_SSCALED_GFX10 = 0x0000002F,
  BUF_FORMAT_10_10_10_2_UINT_GFX10 = 0x00000030,
  BUF_FORMAT_10_10_10_2_SINT_GFX10 = 0x00000031,
  BUF_FORMAT_2_10_10_10_UNORM_GFX10 = 0x00000032,
  BUF_FORMAT_2_10_10_10_SNORM_GFX10 = 0x00000033,
  BUF_FORMAT_2_10_10_10_USCALED_GFX10 = 0x00000034,
  BUF_FORMAT_2_10_10_10_SSCALED_GFX10 = 0x00000035,
  BUF_FORMAT_2_10_10_10_UINT_GFX10 = 0x00000036,
  BUF_FORMAT_2_10_10_10_SINT_GFX10 = 0x00000037,
  BUF_FORMAT_8_8_8_8_UNORM_GFX10 = 0x00000038,
  BUF_FORMAT_8_8_8_8_SNORM_GFX10 = 0x00000039,
  BUF_FORMAT_8_8_8_8_USCALED_GFX10 = 0x0000003A,
  BUF_FORMAT_8_8_8_8_SSCALED_GFX10 = 0x0000003B,
  BUF_FORMAT_8_8_8_8_UINT_GFX10 = 0x0000003C,
  BUF_FORMAT_8_8_8_8_SINT_GFX10 = 0x0000003D,
  BUF_FORMAT_32_32_UINT_GFX10 = 0x0000003E,
  BUF_FORMAT_32_32_SINT_GFX10 = 0x0000003F,
  BUF_FORMAT_32_32_FLOAT_GFX10 = 0x00000040,
  BUF_FORMAT_16_16_16_16_UNORM_GFX10 = 0x00000041,
  BUF_FORMAT_16_16_16_16_SNORM_GFX10 = 0x00000042,
  BUF_FORMAT_16_16_16_16_USCALED_GFX10 = 0x00000043,
  BUF_FORMAT_16_16_16_16_SSCALED_GFX10 = 0x00000044,
  BUF_FORMAT_16_16_16_16_UINT_GFX10 = 0x00000045,
  BUF_FORMAT_16_16_16_16_SINT_GFX10 = 0x00000046,
  BUF_FORMAT_16_16_16_16_FLOAT_GFX10 = 0x00000047,
  BUF_FORMAT_32_32_32_UINT_GFX10 = 0x00000048,
  BUF_FORMAT_32_32_32_SINT_GFX10 = 0x00000049,
  BUF_FORMAT_32_32_32_FLOAT_GFX10 = 0x0000004A,
  BUF_FORMAT_32_32_32_32_UINT_GFX10 = 0x0000004B,
  BUF_FORMAT_32_32_32_32_SINT_GFX10 = 0x0000004C,
  BUF_FORMAT_32_32_32_32_FLOAT_GFX10 = 0x0000004D,

  BUF_FORMAT_10_11_11_FLOAT_GFX11 = 0x0000001E,
  BUF_FORMAT_11_11_10_FLOAT_GFX11 = 0x0000001F,
  BUF_FORMAT_10_10_10_2_UNORM_GFX11 = 0x00000020,
  BUF_FORMAT_10_10_10_2_SNORM_GFX11 = 0x00000021,
  BUF_FORMAT_10_10_10_2_UINT_GFX11 = 0x00000022,
  BUF_FORMAT_10_10_10_2_SINT_GFX11 = 0x00000023,
  BUF_FORMAT_2_10_10_10_UNORM_GFX11 = 0x00000024,
  BUF_FORMAT_2_10_10_10_SNORM_GFX11 = 0x00000025,
  BUF_FORMAT_2_10_10_10_USCALED_GFX11 = 0x00000026,
  BUF_FORMAT_2_10_10_10_SSCALED_GFX11 = 0x00000027,
  BUF_FORMAT_2_10_10_10_UINT_GFX11 = 0x00000028,
  BUF_FORMAT_2_10_10_10_SINT_GFX11 = 0x00000029,
  BUF_FORMAT_8_8_8_8_UNORM_GFX11 = 0x0000002A,
  BUF_FORMAT_8_8_8_8_SNORM_GFX11 = 0x0000002B,
  BUF_FORMAT_8_8_8_8_USCALED_GFX11 = 0x0000002C,
  BUF_FORMAT_8_8_8_8_SSCALED_GFX11 = 0x0000002D,
  BUF_FORMAT_8_8_8_8_UINT_GFX11 = 0x0000002E,
  BUF_FORMAT_8_8_8_8_SINT_GFX11 = 0x0000002F,
  BUF_FORMAT_32_32_UINT_GFX11 = 0x00000030,
  BUF_FORMAT_32_32_SINT_GFX11 = 0x00000031,
  BUF_FORMAT_32_32_FLOAT_GFX11 = 0x00000032,
  BUF_FORMAT_16_16_16_16_UNORM_GFX11 = 0x00000033,
  BUF_FORMAT_16_16_16_16_SNORM_GFX11 = 0x00000034,
  BUF_FORMAT_16_16_16_16_USCALED_GFX11 = 0x00000035,
  BUF_FORMAT_16_16_16_16_SSCALED_GFX11 = 0x00000036,
  BUF_FORMAT_16_16_16_16_UINT_GFX11 = 0x00000037,
  BUF_FORMAT_16_16_16_16_SINT_GFX11 = 0x00000038,
  BUF_FORMAT_16_16_16_16_FLOAT_GFX11 = 0x00000039,
  BUF_FORMAT_32_32_32_UINT_GFX11 = 0x0000003A,
  BUF_FORMAT_32_32_32_SINT_GFX11 = 0x0000003B,
  BUF_FORMAT_32_32_32_FLOAT_GFX11 = 0x0000003C,
  BUF_FORMAT_32_32_32_32_UINT_GFX11 = 0x0000003D,
  BUF_FORMAT_32_32_32_32_SINT_GFX11 = 0x0000003E,
  BUF_FORMAT_32_32_32_32_FLOAT_GFX11 = 0x0000003F,
};

// Enumerates destination selection of data in memory buffer.
enum BufDstSel {
  BUF_DST_SEL_0 = 0, // SEL_0 (0.0)
  BUF_DST_SEL_1 = 1, // SEL_1 (1.0)
  BUF_DST_SEL_X = 4, // SEL_X (X)
  BUF_DST_SEL_Y = 5, // SEL_Y (Y)
  BUF_DST_SEL_Z = 6, // SEL_Z (Z)
  BUF_DST_SEL_W = 7, // SEL_W (W)
};

// Bits in mask supplied to v_cmp_class
enum CmpClass {
  SignalingNaN = 1,
  QuietNaN = 2,
  NegativeInfinity = 4,
  NegativeNormal = 8,
  NegativeSubnormal = 0x10,
  NegativeZero = 0x20,
  PositiveZero = 0x40,
  PositiveSubnormal = 0x80,
  PositiveNormal = 0x100,
  PositiveInfinity = 0x200
};

// Represents register fields of SPI_PS_INPUT_ADDR.
union SpiPsInputAddr {
  struct {
    unsigned perspSampleEna : 1;
    unsigned perspCenterEna : 1;
    unsigned perspCentroidEna : 1;
    unsigned perspPullModelEna : 1;
    unsigned linearSampleEna : 1;
    unsigned linearCenterEna : 1;
    unsigned linearCentroidEna : 1;
    unsigned lineStippleTexEna : 1;
    unsigned posXFloatEna : 1;
    unsigned posYFloatEna : 1;
    unsigned posZFloatEna : 1;
    unsigned posWFloatEna : 1;
    unsigned frontFaceEna : 1;
    unsigned ancillaryEna : 1;
    unsigned sampleCoverageEna : 1;
    unsigned posFixedPtEna : 1;
    unsigned : 16;
  } bits;

  unsigned u32All;
};

// Represents the first dword of buffer descriptor SQ_BUF_RSRC_WORD0.
union SqBufRsrcWord0 {
  struct {
    unsigned baseAddress : 32;
  } bits;

  unsigned u32All;
};

// Represents the second dword of buffer descriptor SQ_BUF_RSRC_WORD1.
union SqBufRsrcWord1 {
  struct {
    unsigned baseAddressHi : 16;
    unsigned stride : 14;
    unsigned cacheSwizzle : 1;
    unsigned swizzleEnable : 1;
  } bits;

  struct {
    unsigned : 30;
    unsigned swizzleEnable : 2;
  } gfx11;

  unsigned u32All;
};

// Represents the third dword of buffer descriptor SQ_BUF_RSRC_WORD2.
union SqBufRsrcWord2 {
  struct {
    unsigned numRecords : 32;
  } bits;

  unsigned u32All;
};

// Represents the forth dword of buffer descriptor SQ_BUF_RSRC_WORD3.
union SqBufRsrcWord3 {
  struct {
    unsigned dstSelX : 3;
    unsigned dstSelY : 3;
    unsigned dstSelZ : 3;
    unsigned dstSelW : 3;
    unsigned : 9;
    unsigned indexStride : 2;
    unsigned addTidEnable : 1;
    unsigned : 6;
    unsigned type : 2;
  } bits;

  struct {
    unsigned : 12;
    unsigned numFormat : 3;
    unsigned dataFormat : 4;
    unsigned elementSize : 2;
    unsigned : 3;
    unsigned atc : 1;
    unsigned hashEnable : 1;
    unsigned heap : 1;
    unsigned mtype : 3;
    unsigned : 2;
  } gfx6;

  struct {
    unsigned : 12;
    unsigned format : 7;
    unsigned : 5;
    unsigned resourceLevel : 1;
    unsigned : 3;
    unsigned oobSelect : 2;
    unsigned : 2;
  } gfx10;

  struct {
    unsigned : 12;
    unsigned format : 6;
    unsigned : 10;
    unsigned oobSelect : 2;
    unsigned : 2;
  } gfx11;

  unsigned u32All;
};

// Represent register fields of PA_SU_SC_MODE_CNTL
union PaSuScModeCntl {
  struct {
    unsigned cullFront : 1;
    unsigned cullBack : 1;
    unsigned face : 1;
    unsigned polyMode : 2;
    unsigned polymodeFrontPtype : 3;
    unsigned polymodeBackPtype : 3;
    unsigned polyOffsetFrontEnable : 1;
    unsigned polyOffsetBackEnable : 1;
    unsigned polyOffsetParaEnable : 1;
    unsigned : 2;
    unsigned vtxWindowOffsetEnable : 1;
    unsigned : 2;
    unsigned provokingVtxLast : 1;
    unsigned perspCorrDis : 1;
    unsigned multiPrimIbEna : 1;
    unsigned : 10;
  } bits;

  struct {
    unsigned : 22;
    unsigned rightTriangleAlternateGradientRef : 1;
    unsigned newQuadDecomposition : 1;
    unsigned : 8;
  } gfx9;

  unsigned u32All;
};

// Represent register fields of PA_CL_CLIP_CNTL
union PaClClipCntl {
  struct {
    unsigned ucpEna0 : 1;
    unsigned ucpEna1 : 1;
    unsigned ucpEna2 : 1;
    unsigned ucpEna3 : 1;
    unsigned ucpEna4 : 1;
    unsigned ucpEna5 : 1;
    unsigned : 7;
    unsigned psUcpYScaleNeg : 1;
    unsigned psUcpMode : 2;
    unsigned clipDisable : 1;
    unsigned ucpCullOnlyEna : 1;
    unsigned boundaryEdgeFlagEna : 1;
    unsigned dxClipSpaceDef : 1;
    unsigned disClipErrDetect : 1;
    unsigned vtxKillOr : 1;
    unsigned dxRasterizationKill : 1;
    unsigned : 1;
    unsigned dxLinearAttrClipEna : 1;
    unsigned vteVportProvokeDisable : 1;
    unsigned zclipNearDisable : 1;
    unsigned zclipFarDisable : 1;
    unsigned : 4;
  } bits;

  unsigned u32All;
};

// Represent register fields PA_CL_VTE_CNTL
union PaClVteCntl {
  struct {
    unsigned vportXScaleEna : 1;
    unsigned vportXOffsetEna : 1;
    unsigned vportYScaleEna : 1;
    unsigned vportYOffsetEna : 1;
    unsigned vportZScaleEna : 1;
    unsigned vportZOffsetEna : 1;
    unsigned : 2;
    unsigned vtxXyFmt : 1;
    unsigned vtxZFmt : 1;
    unsigned vtxW0Fmt : 1;
    unsigned perfcounterRef : 1;
    unsigned : 20;
  } bits;

  unsigned u32All;
};

// Enumerates how to render front-facing polygons
enum PolyModeType {
  POLY_MODE_POINTS = 0,
  POLY_MODE_LINES = 1,
  POLY_MODE_TRIANGLES = 2,
};

// Represents the coherent flag used in buffer intrinsics
union CoherentFlag {
  struct {
    unsigned glc : 1; // Global level coherence
    unsigned slc : 1; // System level coherence
    unsigned dlc : 1; // Device level coherence
    unsigned swz : 1; // Swizzled buffer
    unsigned : 28;
  } bits;

  unsigned u32All;
};

// Represents the combine format used in tbuffer intrinsics
union CombineFormat {
  struct {
    unsigned dfmt : 4; // Data format
    unsigned nfmt : 3; // Numeric format
    unsigned : 25;
  } bits;

  unsigned u32All;
};

// Count of user SGPRs used in copy shader
static const unsigned CopyShaderUserSgprCount = 4;

// User SGPR index for the stream info in copy shader
static const unsigned CopyShaderUserSgprIdxStreamInfo = 4;

// User SGPR index for the stream-out write index in copy shader
static const unsigned CopyShaderUserSgprIdxWriteIndex = 5;

// User SGPR index for the stream offsets in copy shader
static const unsigned CopyShaderUserSgprIdxStreamOffset = 6;

// Start offset of currently-processed vertex in GS-VS ring buffer
static const unsigned CopyShaderUserSgprIdxVertexOffset = 10;

} // namespace lgc

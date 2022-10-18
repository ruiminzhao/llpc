/*
 ***********************************************************************************************************************
 *
 *  Copyright (c) 2020-2022 Advanced Micro Devices, Inc. All Rights Reserved.
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
 * @file  llpcSpirvLowerRayQueryPostInline.h
 * @brief LLPC header file: contains declaration of Llpc::SpirvLowerRayQueryPostInline
 ***********************************************************************************************************************
 */
#pragma once

#include "llpcSpirvLower.h"
#include "llvm/IR/PassManager.h"

namespace Llpc {

// Represents the pass of SPIR-V lowering ray query post inline.
class SpirvLowerRayQueryPostInline : public SpirvLower, public llvm::PassInfoMixin<SpirvLowerRayQueryPostInline> {
public:
  llvm::PreservedAnalyses run(llvm::Module &module, llvm::ModuleAnalysisManager &analysisManager);
  virtual bool runImpl(llvm::Module &module);

  static llvm::StringRef name() { return "Lower SPIR-V RayQueryPostInline operations"; }
};

// Represents the pass of SPIR-V lowering ray query post inline.
class LegacySpirvLowerRayQueryPostInline : public llvm::ModulePass {
public:
  LegacySpirvLowerRayQueryPostInline();
  virtual bool runOnModule(llvm::Module &module);

  static char ID; // ID of this pass

private:
  LegacySpirvLowerRayQueryPostInline(const LegacySpirvLowerRayQueryPostInline &) = delete;
  LegacySpirvLowerRayQueryPostInline &operator=(const LegacySpirvLowerRayQueryPostInline &) = delete;

  SpirvLowerRayQueryPostInline Impl;
};

} // namespace Llpc

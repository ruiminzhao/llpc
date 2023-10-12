; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs --version 3
; RUN: opt --verify-each -passes='dxil-cont-lgc-rt-op-converter,lint,lower-raytracing-pipeline,lint,remove-types-metadata' -S %s 2>%t.stderr | FileCheck -check-prefix=LOWERRAYTRACINGPIPELINE %s
; RUN: count 0 < %t.stderr

; Check that using unnamed types works well with generating intrinsic names

target datalayout = "e-m:e-p:64:32-p20:32:32-p21:32:32-i1:32-i8:8-i16:32-i32:32-i64:32-f16:32-f32:32-f64:32-v16:32-v32:32-v48:32-v64:32-v80:32-v96:32-v112:32-v128:32-v144:32-v160:32-v176:32-v192:32-v208:32-v224:32-v240:32-v256:32-n8:16:32"

; struct.DispatchSystemData
%0 = type { <3 x i32> }
; struct.TraversalData
%1 = type { %2, %struct.HitData, <3 x float>, <3 x float>, float, i64 }
; struct.SystemData
%2 = type { %0 }
; struct.AnyHitTraversalData
%3 = type { %1, %struct.HitData }
%dx.types.Handle = type { i8* }
%struct.HitData = type { <3 x float>, <3 x float>, float, i32 }
%struct.BuiltInTriangleIntersectionAttributes = type { <2 x float> }
%struct.RayPayload = type { <4 x float> }
%dx.types.ResourceProperties = type { i32, i32 }
%struct.RaytracingAccelerationStructure = type { i32 }
%"class.RWTexture2D<vector<float, 4> >" = type { <4 x float> }

@"\01?Scene@@3URaytracingAccelerationStructure@@A" = external constant %dx.types.Handle, align 4
@"\01?RenderTarget@@3V?$RWTexture2D@V?$vector@M$03@@@@A" = external constant %dx.types.Handle, align 4

declare i32 @_cont_GetContinuationStackAddr() #0

declare %0 @_cont_SetupRayGen() #0

declare %0 @_AmdAwaitTraversal(i64, %1) #0

declare %0 @_AmdAwaitShader(i64, %0) #0

declare %3 @_AmdAwaitAnyHit(i64, %3, float, i32) #0

declare !types !17 %struct.HitData @_cont_GetCandidateState(%3*) #0

declare !types !19 %struct.HitData @_cont_GetCommittedState(%2*) #0

declare !types !21 %struct.BuiltInTriangleIntersectionAttributes @_cont_GetTriangleHitAttributes(%2*) #0

declare !types !22 void @_cont_SetTriangleHitAttributes(%2*, %struct.BuiltInTriangleIntersectionAttributes) #0

declare !types !23 i32 @_cont_GetLocalRootIndex(%0*)

declare !types !25 i1 @_cont_IsEndSearch(%1*) #0

declare !types !27 i32 @_cont_HitKind(%2*) #0

; Function Attrs: nounwind
declare i64 @_AmdGetResumePointAddr() #1

; Function Attrs: nounwind
declare !types !28 void @_AmdRestoreSystemData(%0*) #1

; Function Attrs: nounwind
declare !types !29 void @_AmdRestoreSystemDataAnyHit(%3*) #1

; Function Attrs: nounwind
declare !types !28 void @_cont_AcceptHitAndEndSearch(%0* nocapture readnone) #1

; Function Attrs: nounwind
declare !types !29 void @_cont_AcceptHit(%3* nocapture readnone) #1

; Function Attrs: nounwind
declare !types !28 void @_cont_IgnoreHit(%0* nocapture readnone) #1

; Function Attrs: nounwind
declare !types !29 void @_AmdAcceptHitAttributes(%3* nocapture readnone) #1

define void @_cont_TraceRay(%0* %data, i64 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, float %6, float %7, float %8, float %9, float %10, float %11, float %12, float %13) #0 !types !30 {
  %dis_data = load %0, %0* %data, align 4
  %sys_data = insertvalue %2 undef, %0 %dis_data, 0
  %trav_data = insertvalue %1 undef, %2 %sys_data, 0
  %addr = call i64 @_AmdGetResumePointAddr() #3
  %trav_data2 = insertvalue %1 %trav_data, i64 %addr, 5
  %newdata = call %0 @_AmdAwaitTraversal(i64 4, %1 %trav_data2)
  store %0 %newdata, %0* %data, align 4
  call void @_AmdRestoreSystemData(%0* %data)
  ret void
}

define void @_cont_CallShader(%0* %data, i32 %0) #0 !types !31 {
  %dis_data = load %0, %0* %data, align 4
  %newdata = call %0 @_AmdAwaitShader(i64 2, %0 %dis_data)
  store %0 %newdata, %0* %data, align 4
  call void @_AmdRestoreSystemData(%0* %data)
  ret void
}

define i1 @_cont_ReportHit(%3* %data, float %t, i32 %hitKind) #0 !types !32 {
  %origTPtr = getelementptr inbounds %3, %3* %data, i32 0, i32 0, i32 4
  %origT = load float, float* %origTPtr, align 4
  %isNoHit = fcmp fast uge float %t, %origT
  br i1 %isNoHit, label %isEnd, label %callAHit

callAHit:                                         ; preds = %0
  %trav_data = load %3, %3* %data, align 4
  %newdata = call %3 @_AmdAwaitAnyHit(i64 3, %3 %trav_data, float %t, i32 %hitKind)
  store %3 %newdata, %3* %data, align 4
  call void @_AmdRestoreSystemDataAnyHit(%3* %data)
  ret i1 true

isEnd:                                            ; preds = %0
  ; Call AcceptHitAttributes, just to simulate it
  call void @_AmdAcceptHitAttributes(%3* %data)
  ret i1 false
}

define <3 x i32> @_cont_DispatchRaysIndex3(%0* %data) !types !33 {
  %resPtr.1 = getelementptr %0, %0* %data, i32 0, i32 0, i32 0
  %res.1 = load i32, i32* %resPtr.1, align 4
  %resPtr.2 = getelementptr %0, %0* %data, i32 0, i32 0, i32 1
  %res.2 = load i32, i32* %resPtr.2, align 4
  %resPtr.3 = getelementptr %0, %0* %data, i32 0, i32 0, i32 2
  %res.3 = load i32, i32* %resPtr.3, align 4
  %val.0 = insertelement <3 x i32> undef, i32 %res.1, i32 0
  %val.1 = insertelement <3 x i32> %val.0, i32 %res.2, i32 1
  %val.2 = insertelement <3 x i32> %val.1, i32 %res.3, i32 2
  ret <3 x i32> %val.2
}

define <3 x float> @_cont_ObjectRayOrigin3(%0* nocapture readnone %data, %struct.HitData* %hitData) !types !34 {
  %resPtr.1 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 0, i32 0
  %res.1 = load float, float* %resPtr.1, align 4
  %resPtr.2 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 0, i32 1
  %res.2 = load float, float* %resPtr.2, align 4
  %resPtr.3 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 0, i32 2
  %res.3 = load float, float* %resPtr.3, align 4
  %val.0 = insertelement <3 x float> undef, float %res.1, i32 0
  %val.1 = insertelement <3 x float> %val.0, float %res.2, i32 1
  %val.2 = insertelement <3 x float> %val.1, float %res.3, i32 2
  ret <3 x float> %val.2
}

define <3 x float> @_cont_ObjectRayDirection3(%0* nocapture readnone %data, %struct.HitData* %hitData) !types !34 {
  %resPtr.1 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 1, i32 0
  %res.1 = load float, float* %resPtr.1, align 4
  %resPtr.2 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 1, i32 1
  %res.2 = load float, float* %resPtr.2, align 4
  %resPtr.3 = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 1, i32 2
  %res.3 = load float, float* %resPtr.3, align 4
  %val.0 = insertelement <3 x float> undef, float %res.1, i32 0
  %val.1 = insertelement <3 x float> %val.0, float %res.2, i32 1
  %val.2 = insertelement <3 x float> %val.1, float %res.3, i32 2
  ret <3 x float> %val.2
}

define float @_cont_RayTCurrent(%0* nocapture readnone %data, %struct.HitData* %hitData) !types !36 {
  %resPtr = getelementptr %struct.HitData, %struct.HitData* %hitData, i32 0, i32 2
  %res = load float, float* %resPtr, align 4
  ret float %res
}

; Function Attrs: nounwind
define void @MyRayGen() #2 {
  %1 = load %dx.types.Handle, %dx.types.Handle* @"\01?Scene@@3URaytracingAccelerationStructure@@A", align 4
  %2 = load %dx.types.Handle, %dx.types.Handle* @"\01?RenderTarget@@3V?$RWTexture2D@V?$vector@M$03@@@@A", align 4
  %3 = alloca %struct.RayPayload, align 4
  %4 = bitcast %struct.RayPayload* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %4) #1
  %5 = getelementptr inbounds %struct.RayPayload, %struct.RayPayload* %3, i32 0, i32 0
  store <4 x float> zeroinitializer, <4 x float>* %5, align 4, !tbaa !37
  %6 = call %dx.types.Handle @dx.op.createHandleForLib.dx.types.Handle(i32 160, %dx.types.Handle %1)
  %7 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %6, %dx.types.ResourceProperties { i32 16, i32 0 })
  call void @dx.op.traceRay.struct.RayPayload(i32 157, %dx.types.Handle %7, i32 16, i32 -1, i32 0, i32 1, i32 0, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0x3F50624DE0000000, float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+04, %struct.RayPayload* nonnull %3)
  %8 = load <4 x float>, <4 x float>* %5, align 4, !tbaa !37
  %9 = call i32 @dx.op.dispatchRaysIndex.i32(i32 145, i8 0)
  %10 = call i32 @dx.op.dispatchRaysIndex.i32(i32 145, i8 1)
  %11 = call %dx.types.Handle @dx.op.createHandleForLib.dx.types.Handle(i32 160, %dx.types.Handle %2)
  %12 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %11, %dx.types.ResourceProperties { i32 4098, i32 1033 })
  %13 = extractelement <4 x float> %8, i64 0
  %14 = extractelement <4 x float> %8, i64 1
  %15 = extractelement <4 x float> %8, i64 2
  %16 = extractelement <4 x float> %8, i64 3
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %12, i32 %9, i32 %10, i32 undef, float %13, float %14, float %15, float %16, i8 15)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %4) #1
  ret void
}

; Function Attrs: nounwind
define void @MyClosestHit(%struct.RayPayload* noalias nocapture %payload, %struct.BuiltInTriangleIntersectionAttributes* nocapture readonly %attr) #2 !types !40 {
  %1 = getelementptr inbounds %struct.BuiltInTriangleIntersectionAttributes, %struct.BuiltInTriangleIntersectionAttributes* %attr, i32 0, i32 0
  %2 = load <2 x float>, <2 x float>* %1, align 4
  %3 = extractelement <2 x float> %2, i32 0
  %4 = fsub fast float 1.000000e+00, %3
  %5 = extractelement <2 x float> %2, i32 1
  %6 = fsub fast float %4, %5
  %7 = insertelement <4 x float> undef, float %6, i64 0
  %8 = insertelement <4 x float> %7, float %3, i64 1
  %9 = insertelement <4 x float> %8, float %5, i64 2
  %10 = insertelement <4 x float> %9, float 1.000000e+00, i64 3
  %11 = getelementptr inbounds %struct.RayPayload, %struct.RayPayload* %payload, i32 0, i32 0
  store <4 x float> %10, <4 x float>* %11, align 4
  ret void
}

; Function Attrs: nounwind
declare !types !43 void @dx.op.traceRay.struct.RayPayload(i32, %dx.types.Handle, i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, %struct.RayPayload*) #1

; Function Attrs: nounwind
declare void @dx.op.textureStore.f32(i32, %dx.types.Handle, i32, i32, i32, float, float, float, float, i8) #1

; Function Attrs: nounwind memory(none)
declare i32 @dx.op.dispatchRaysIndex.i32(i32, i8) #3

; Function Attrs: nounwind memory(none)
declare float @dx.op.objectRayDirection.f32(i32, i8) #3

; Function Attrs: nounwind memory(none)
declare float @dx.op.objectRayOrigin.f32(i32, i8) #3

; Function Attrs: nounwind memory(read)
declare float @dx.op.rayTCurrent.f32(i32) #4

declare void @dx.op.acceptHitAndEndSearch(i32) #0

declare void @dx.op.ignoreHit(i32) #0

; Function Attrs: nounwind
declare !types !44 i1 @dx.op.reportHit.struct.BuiltInTriangleIntersectionAttributes(i32, float, i32, %struct.BuiltInTriangleIntersectionAttributes*) #1

; Function Attrs: nounwind memory(none)
declare %dx.types.Handle @dx.op.annotateHandle(i32, %dx.types.Handle, %dx.types.ResourceProperties) #3

; Function Attrs: nounwind memory(read)
declare %dx.types.Handle @dx.op.createHandleForLib.dx.types.Handle(i32, %dx.types.Handle) #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !types !45 void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !types !45 void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #5

attributes #0 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="0" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="0" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind memory(none) }
attributes #4 = { nounwind memory(read) }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.ident = !{!0}
!dx.version = !{!1}
!dx.valver = !{!1}
!dx.shaderModel = !{!2}
!dx.resources = !{!3}
!dx.typeAnnotations = !{}
!dx.entryPoints = !{!10, !12, !15}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
!1 = !{i32 1, i32 6}
!2 = !{!"lib", i32 6, i32 6}
!3 = !{!4, !7, null, null}
!4 = !{!5}
!5 = !{i32 0, %struct.RaytracingAccelerationStructure* bitcast (%dx.types.Handle* @"\01?Scene@@3URaytracingAccelerationStructure@@A" to %struct.RaytracingAccelerationStructure*), !"Scene", i32 0, i32 0, i32 1, i32 16, i32 0, !6}
!6 = !{i32 0, i32 4}
!7 = !{!8}
!8 = !{i32 0, %"class.RWTexture2D<vector<float, 4> >"* bitcast (%dx.types.Handle* @"\01?RenderTarget@@3V?$RWTexture2D@V?$vector@M$03@@@@A" to %"class.RWTexture2D<vector<float, 4> >"*), !"RenderTarget", i32 0, i32 0, i32 1, i32 2, i1 false, i1 false, i1 false, !9}
!9 = !{i32 0, i32 9}
!10 = !{null, !"", null, !3, !11}
!11 = !{i32 0, i64 65536}
!12 = !{void (%struct.RayPayload*, %struct.BuiltInTriangleIntersectionAttributes*)* @MyClosestHit, !"MyClosestHit", null, null, !13}
!13 = !{i32 8, i32 10, i32 6, i32 16, i32 7, i32 8, i32 5, !14}
!14 = !{i32 0}
!15 = !{void ()* @MyRayGen, !"MyRayGen", null, null, !16}
!16 = !{i32 8, i32 7, i32 5, !14}
!17 = !{!"function", %struct.HitData poison, !18}
!18 = !{i32 0, %3 poison}
!19 = !{!"function", %struct.HitData poison, !20}
!20 = !{i32 0, %2 poison}
!21 = !{!"function", %struct.BuiltInTriangleIntersectionAttributes poison, !20}
!22 = !{!"function", !"void", !20, %struct.BuiltInTriangleIntersectionAttributes poison}
!23 = !{!"function", i32 poison, !24}
!24 = !{i32 0, %0 poison}
!25 = !{!"function", i1 poison, !26}
!26 = !{i32 0, %1 poison}
!27 = !{!"function", i32 poison, !20}
!28 = !{!"function", !"void", !24}
!29 = !{!"function", !"void", !18}
!30 = !{!"function", !"void", !24, i64 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, float poison, float poison, float poison, float poison, float poison, float poison, float poison, float poison}
!31 = !{!"function", !"void", !24, i32 poison}
!32 = !{!"function", i1 poison, !18, float poison, i32 poison}
!33 = !{!"function", <3 x i32> poison, !24}
!34 = !{!"function", <3 x float> poison, !24, !35}
!35 = !{i32 0, %struct.HitData poison}
!36 = !{!"function", float poison, !24, !35}
!37 = !{!38, !38, i64 0}
!38 = !{!"omnipotent char", !39, i64 0}
!39 = !{!"Simple C/C++ TBAA"}
!40 = !{!"function", !"void", !41, !42}
!41 = !{i32 0, %struct.RayPayload poison}
!42 = !{i32 0, %struct.BuiltInTriangleIntersectionAttributes poison}
!43 = !{!"function", !"void", i32 poison, %dx.types.Handle poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, float poison, float poison, float poison, float poison, float poison, float poison, float poison, float poison, !41}
!44 = !{!"function", i1 poison, i32 poison, float poison, i32 poison, !42}
!45 = !{!"function", !"void", i64 poison, !46}
!46 = !{i32 0, i8 poison}
; LOWERRAYTRACINGPIPELINE-LABEL: define void @_cont_TraceRay.struct.RayPayload.attr_max_32_bytes(
; LOWERRAYTRACINGPIPELINE-SAME: ptr [[DATA:%.*]], i64 [[TMP0:%.*]], i32 [[TMP1:%.*]], i32 [[TMP2:%.*]], i32 [[TMP3:%.*]], i32 [[TMP4:%.*]], i32 [[TMP5:%.*]], float [[TMP6:%.*]], float [[TMP7:%.*]], float [[TMP8:%.*]], float [[TMP9:%.*]], float [[TMP10:%.*]], float [[TMP11:%.*]], float [[TMP12:%.*]], float [[TMP13:%.*]], ptr [[TMP14:%.*]]) #[[ATTR0:[0-9]+]] {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[DIS_DATA:%.*]] = load [[TMP0]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYS_DATA:%.*]] = insertvalue [[TMP2]] undef, [[TMP0]] [[DIS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA:%.*]] = insertvalue [[TMP1]] undef, [[TMP2]] [[SYS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[ADDR:%.*]] = call i64 @_AmdGetResumePointAddr() #[[ATTR3:[0-9]+]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA2:%.*]] = insertvalue [[TMP1]] [[TRAV_DATA]], i64 [[ADDR]], 5
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP16:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD:%.*]], ptr [[TMP14]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP17:%.*]] = getelementptr i32, ptr [[TMP16]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP18:%.*]] = getelementptr i32, ptr [[TMP17]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP19:%.*]] = load i32, ptr [[TMP18]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP19]], ptr @PAYLOAD, align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP20:%.*]] = getelementptr i32, ptr [[TMP16]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP21:%.*]] = getelementptr i32, ptr [[TMP20]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP22:%.*]] = load i32, ptr [[TMP21]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP22]], ptr getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_0_CALLER_OUT:%.*]], ptr @PAYLOAD, i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP23:%.*]] = getelementptr i32, ptr [[TMP20]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP24:%.*]] = load i32, ptr [[TMP23]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP24]], ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_0_CALLER_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 8), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP25:%.*]] = getelementptr i32, ptr [[TMP20]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP26:%.*]] = load i32, ptr [[TMP25]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP26]], ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_0_CALLER_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 9), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP27:%.*]] = call ptr inttoptr (i64 4 to ptr)([[TMP1]] [[TRAV_DATA2]]), !continuation.registercount !20, !continuation.returnedRegistercount !20
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP28:%.*]] = call [[TMP0]] @await.(ptr [[TMP27]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP29:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], ptr [[TMP14]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP30:%.*]] = getelementptr i32, ptr [[TMP29]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP31:%.*]] = getelementptr i32, ptr [[TMP30]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP32:%.*]] = load i32, ptr @PAYLOAD, align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP32]], ptr [[TMP31]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP33:%.*]] = getelementptr i32, ptr [[TMP29]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP34:%.*]] = getelementptr i32, ptr [[TMP33]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP35:%.*]] = load i32, ptr getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT:%.*]], ptr @PAYLOAD, i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP35]], ptr [[TMP34]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP36:%.*]] = getelementptr i32, ptr [[TMP33]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP37:%.*]] = load i32, ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 8), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP37]], ptr [[TMP36]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP38:%.*]] = getelementptr i32, ptr [[TMP33]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP39:%.*]] = load i32, ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 9), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP39]], ptr [[TMP38]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP0]] [[TMP28]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_AmdRestoreSystemData(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    ret void
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define void @_cont_TraceRay(
; LOWERRAYTRACINGPIPELINE-SAME: ptr [[DATA:%.*]], i64 [[TMP0:%.*]], i32 [[TMP1:%.*]], i32 [[TMP2:%.*]], i32 [[TMP3:%.*]], i32 [[TMP4:%.*]], i32 [[TMP5:%.*]], float [[TMP6:%.*]], float [[TMP7:%.*]], float [[TMP8:%.*]], float [[TMP9:%.*]], float [[TMP10:%.*]], float [[TMP11:%.*]], float [[TMP12:%.*]], float [[TMP13:%.*]]) #[[ATTR0]] {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[DIS_DATA:%.*]] = load [[TMP0]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYS_DATA:%.*]] = insertvalue [[TMP2]] undef, [[TMP0]] [[DIS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA:%.*]] = insertvalue [[TMP1]] undef, [[TMP2]] [[SYS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[ADDR:%.*]] = call i64 @_AmdGetResumePointAddr() #[[ATTR3]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA2:%.*]] = insertvalue [[TMP1]] [[TRAV_DATA]], i64 [[ADDR]], 5
; LOWERRAYTRACINGPIPELINE-NEXT:    [[NEWDATA:%.*]] = call [[TMP0]] @_AmdAwaitTraversal(i64 4, [[TMP1]] [[TRAV_DATA2]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP0]] [[NEWDATA]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_AmdRestoreSystemData(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    ret void
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define void @_cont_CallShader(
; LOWERRAYTRACINGPIPELINE-SAME: ptr [[DATA:%.*]], i32 [[TMP0:%.*]]) #[[ATTR0]] {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[DIS_DATA:%.*]] = load [[TMP0]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[NEWDATA:%.*]] = call [[TMP0]] @_AmdAwaitShader(i64 2, [[TMP0]] [[DIS_DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP0]] [[NEWDATA]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_AmdRestoreSystemData(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    ret void
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define i1 @_cont_ReportHit(
; LOWERRAYTRACINGPIPELINE-SAME: ptr [[DATA:%.*]], float [[T:%.*]], i32 [[HITKIND:%.*]]) #[[ATTR0]] {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[ORIGTPTR:%.*]] = getelementptr inbounds [[TMP3:%.*]], ptr [[DATA]], i32 0, i32 0, i32 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[ORIGT:%.*]] = load float, ptr [[ORIGTPTR]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[ISNOHIT:%.*]] = fcmp fast uge float [[T]], [[ORIGT]]
; LOWERRAYTRACINGPIPELINE-NEXT:    br i1 [[ISNOHIT]], label [[ISEND:%.*]], label [[CALLAHIT:%.*]]
; LOWERRAYTRACINGPIPELINE:       callAHit:
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA:%.*]] = load [[TMP3]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[NEWDATA:%.*]] = call [[TMP3]] @_AmdAwaitAnyHit(i64 3, [[TMP3]] [[TRAV_DATA]], float [[T]], i32 [[HITKIND]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP3]] [[NEWDATA]], ptr [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[TMP3]], ptr [[DATA]], i32 0, i32 0, i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[TMP1]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_AmdRestoreSystemDataAnyHit(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    ret i1 true
; LOWERRAYTRACINGPIPELINE:       isEnd:
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_AmdAcceptHitAttributes(ptr [[DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    ret i1 false
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define <3 x i32> @_cont_DispatchRaysIndex3(
; LOWERRAYTRACINGPIPELINE-SAME: ptr [[DATA:%.*]]) {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_1:%.*]] = getelementptr [[TMP0:%.*]], ptr [[DATA]], i32 0, i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_1:%.*]] = load i32, ptr [[RESPTR_1]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_2:%.*]] = getelementptr [[TMP0]], ptr [[DATA]], i32 0, i32 0, i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_2:%.*]] = load i32, ptr [[RESPTR_2]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_3:%.*]] = getelementptr [[TMP0]], ptr [[DATA]], i32 0, i32 0, i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_3:%.*]] = load i32, ptr [[RESPTR_3]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_0:%.*]] = insertelement <3 x i32> undef, i32 [[RES_1]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_1:%.*]] = insertelement <3 x i32> [[VAL_0]], i32 [[RES_2]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_2:%.*]] = insertelement <3 x i32> [[VAL_1]], i32 [[RES_3]], i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    ret <3 x i32> [[VAL_2]]
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define <3 x float> @_cont_ObjectRayOrigin3(
; LOWERRAYTRACINGPIPELINE-SAME: ptr nocapture readnone [[DATA:%.*]], ptr [[HITDATA:%.*]]) {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_1:%.*]] = getelementptr [[STRUCT_HITDATA:%.*]], ptr [[HITDATA]], i32 0, i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_1:%.*]] = load float, ptr [[RESPTR_1]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_2:%.*]] = getelementptr [[STRUCT_HITDATA]], ptr [[HITDATA]], i32 0, i32 0, i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_2:%.*]] = load float, ptr [[RESPTR_2]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_3:%.*]] = getelementptr [[STRUCT_HITDATA]], ptr [[HITDATA]], i32 0, i32 0, i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_3:%.*]] = load float, ptr [[RESPTR_3]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_0:%.*]] = insertelement <3 x float> undef, float [[RES_1]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_1:%.*]] = insertelement <3 x float> [[VAL_0]], float [[RES_2]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_2:%.*]] = insertelement <3 x float> [[VAL_1]], float [[RES_3]], i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    ret <3 x float> [[VAL_2]]
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define <3 x float> @_cont_ObjectRayDirection3(
; LOWERRAYTRACINGPIPELINE-SAME: ptr nocapture readnone [[DATA:%.*]], ptr [[HITDATA:%.*]]) {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_1:%.*]] = getelementptr [[STRUCT_HITDATA:%.*]], ptr [[HITDATA]], i32 0, i32 1, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_1:%.*]] = load float, ptr [[RESPTR_1]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_2:%.*]] = getelementptr [[STRUCT_HITDATA]], ptr [[HITDATA]], i32 0, i32 1, i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_2:%.*]] = load float, ptr [[RESPTR_2]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR_3:%.*]] = getelementptr [[STRUCT_HITDATA]], ptr [[HITDATA]], i32 0, i32 1, i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES_3:%.*]] = load float, ptr [[RESPTR_3]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_0:%.*]] = insertelement <3 x float> undef, float [[RES_1]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_1:%.*]] = insertelement <3 x float> [[VAL_0]], float [[RES_2]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[VAL_2:%.*]] = insertelement <3 x float> [[VAL_1]], float [[RES_3]], i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    ret <3 x float> [[VAL_2]]
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define float @_cont_RayTCurrent(
; LOWERRAYTRACINGPIPELINE-SAME: ptr nocapture readnone [[DATA:%.*]], ptr [[HITDATA:%.*]]) {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RESPTR:%.*]] = getelementptr [[STRUCT_HITDATA:%.*]], ptr [[HITDATA]], i32 0, i32 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[RES:%.*]] = load float, ptr [[RESPTR]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    ret float [[RES]]
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define void @MyRayGen(
; LOWERRAYTRACINGPIPELINE-SAME: ) #[[ATTR2:[0-9]+]] !continuation.registercount !15 !continuation !21 !continuation.entry !22 {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYSTEM_DATA_ALLOCA:%.*]] = alloca [[TMP0:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP1:%.*]] = call [[TMP0]] @continuations.getSystemData.s_s_0()
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP0]] [[TMP1]], ptr [[SYSTEM_DATA_ALLOCA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[SYSTEM_DATA_ALLOCA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP2:%.*]] = load [[DX_TYPES_HANDLE:%.*]], ptr @"\01?Scene@@3URaytracingAccelerationStructure@@A", align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP3:%.*]] = load [[DX_TYPES_HANDLE]], ptr @"\01?RenderTarget@@3V?$RWTexture2D@V?$vector@M$03@@@@A", align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP4:%.*]] = alloca [[STRUCT_RAYPAYLOAD:%.*]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP5:%.*]] = bitcast ptr [[TMP4]] to ptr
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr [[TMP5]]) #[[ATTR1:[0-9]+]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], ptr [[TMP4]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    store <4 x float> zeroinitializer, ptr [[TMP6]], align 4, !tbaa [[TBAA23:![0-9]+]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP7:%.*]] = call [[DX_TYPES_HANDLE]] @dx.op.createHandleForLib.dx.types.Handle(i32 160, [[DX_TYPES_HANDLE]] [[TMP2]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP8:%.*]] = call [[DX_TYPES_HANDLE]] @dx.op.annotateHandle(i32 216, [[DX_TYPES_HANDLE]] [[TMP7]], [[DX_TYPES_RESOURCEPROPERTIES:%.*]] { i32 16, i32 0 })
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP9:%.*]] = call i64 @amd.dx.getAccelStructAddr([[DX_TYPES_HANDLE]] [[TMP8]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @_cont_TraceRay.struct.RayPayload.attr_max_32_bytes(ptr [[SYSTEM_DATA_ALLOCA]], i64 [[TMP9]], i32 16, i32 -1, i32 0, i32 1, i32 0, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0x3F50624DE0000000, float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+04, ptr [[TMP4]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP10:%.*]] = load <4 x float>, ptr [[TMP6]], align 4, !tbaa [[TBAA23]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP11:%.*]] = call <3 x i32> @lgc.rt.dispatch.rays.index()
; LOWERRAYTRACINGPIPELINE-NEXT:    [[EXTRACT:%.*]] = extractelement <3 x i32> [[TMP11]], i8 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP12:%.*]] = call <3 x i32> @lgc.rt.dispatch.rays.index()
; LOWERRAYTRACINGPIPELINE-NEXT:    [[EXTRACT1:%.*]] = extractelement <3 x i32> [[TMP12]], i8 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP13:%.*]] = call [[DX_TYPES_HANDLE]] @dx.op.createHandleForLib.dx.types.Handle(i32 160, [[DX_TYPES_HANDLE]] [[TMP3]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP14:%.*]] = call [[DX_TYPES_HANDLE]] @dx.op.annotateHandle(i32 216, [[DX_TYPES_HANDLE]] [[TMP13]], [[DX_TYPES_RESOURCEPROPERTIES]] { i32 4098, i32 1033 })
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP15:%.*]] = extractelement <4 x float> [[TMP10]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP16:%.*]] = extractelement <4 x float> [[TMP10]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP17:%.*]] = extractelement <4 x float> [[TMP10]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP18:%.*]] = extractelement <4 x float> [[TMP10]], i64 3
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @dx.op.textureStore.f32(i32 67, [[DX_TYPES_HANDLE]] [[TMP14]], i32 [[EXTRACT]], i32 [[EXTRACT1]], i32 undef, float [[TMP15]], float [[TMP16]], float [[TMP17]], float [[TMP18]], i8 15)
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr [[TMP5]]) #[[ATTR1]]
; LOWERRAYTRACINGPIPELINE-NEXT:    ret void
;
;
; LOWERRAYTRACINGPIPELINE-LABEL: define %0 @MyClosestHit(
; LOWERRAYTRACINGPIPELINE-SAME: [[TMP2:%.*]] [[TMP0:%.*]]) #[[ATTR2]] !continuation.registercount !20 !continuation !26 {
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP2]] = alloca [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYSTEM_DATA_ALLOCA:%.*]] = alloca [[TMP2]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP3:%.*]] = alloca [[STRUCT_RAYPAYLOAD:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[HITATTRS:%.*]] = alloca [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP4:%.*]] = call [[TMP2]] @continuations.getSystemData.s_s()
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[TMP2]] [[TMP4]], ptr [[SYSTEM_DATA_ALLOCA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[TMP2]], ptr [[SYSTEM_DATA_ALLOCA]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(ptr [[TMP5]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], ptr [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP7:%.*]] = getelementptr i32, ptr [[TMP6]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP8:%.*]] = getelementptr i32, ptr [[TMP7]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP9:%.*]] = load i32, ptr @PAYLOAD, align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP9]], ptr [[TMP8]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP10:%.*]] = getelementptr i32, ptr [[TMP6]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP11:%.*]] = getelementptr i32, ptr [[TMP10]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP12:%.*]] = load i32, ptr getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_3_CLOSESTHIT_IN_PAYLOAD_ATTR_0_I32S:%.*]], ptr @PAYLOAD, i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP12]], ptr [[TMP11]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP13:%.*]] = getelementptr i32, ptr [[TMP10]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP14:%.*]] = load i32, ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_3_CLOSESTHIT_IN_PAYLOAD_ATTR_0_I32S]], ptr @PAYLOAD, i32 0, i32 0, i64 8), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP14]], ptr [[TMP13]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP15:%.*]] = getelementptr i32, ptr [[TMP10]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP16:%.*]] = load i32, ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_3_CLOSESTHIT_IN_PAYLOAD_ATTR_0_I32S]], ptr @PAYLOAD, i32 0, i32 0, i64 9), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP16]], ptr [[TMP15]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @PAYLOAD)
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP17:%.*]] = call [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]] @_cont_GetTriangleHitAttributes(ptr [[SYSTEM_DATA_ALLOCA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]] [[TMP17]], ptr [[TMP2]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP18:%.*]] = getelementptr inbounds i32, ptr [[HITATTRS]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i32, ptr [[TMP2]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP20:%.*]] = load i32, ptr [[TMP19]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP20]], ptr [[TMP18]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i32, ptr [[HITATTRS]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, ptr [[TMP2]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP23:%.*]] = load i32, ptr [[TMP22]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP23]], ptr [[TMP21]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP24:%.*]] = getelementptr inbounds [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]], ptr [[HITATTRS]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP25:%.*]] = load <2 x float>, ptr [[TMP24]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP26:%.*]] = extractelement <2 x float> [[TMP25]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP27:%.*]] = fsub fast float 1.000000e+00, [[TMP26]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP28:%.*]] = extractelement <2 x float> [[TMP25]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP29:%.*]] = fsub fast float [[TMP27]], [[TMP28]]
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP30:%.*]] = insertelement <4 x float> undef, float [[TMP29]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP31:%.*]] = insertelement <4 x float> [[TMP30]], float [[TMP26]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP32:%.*]] = insertelement <4 x float> [[TMP31]], float [[TMP28]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP33:%.*]] = insertelement <4 x float> [[TMP32]], float 1.000000e+00, i64 3
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP34:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], ptr [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    store <4 x float> [[TMP33]], ptr [[TMP34]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    call void (...) @registerbuffer.setpointerbarrier(ptr @PAYLOAD)
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP35:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], ptr [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP36:%.*]] = getelementptr i32, ptr [[TMP35]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP37:%.*]] = getelementptr i32, ptr [[TMP36]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP38:%.*]] = load i32, ptr [[TMP37]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP38]], ptr @PAYLOAD, align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP39:%.*]] = getelementptr i32, ptr [[TMP35]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP40:%.*]] = getelementptr i32, ptr [[TMP39]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP41:%.*]] = load i32, ptr [[TMP40]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP41]], ptr getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT:%.*]], ptr @PAYLOAD, i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP42:%.*]] = getelementptr i32, ptr [[TMP39]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP43:%.*]] = load i32, ptr [[TMP42]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP43]], ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 8), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP44:%.*]] = getelementptr i32, ptr [[TMP39]], i64 2
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP45:%.*]] = load i32, ptr [[TMP44]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP45]], ptr getelementptr ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT]], ptr @PAYLOAD, i32 0, i32 0, i64 9), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP46:%.*]] = getelementptr inbounds [[TMP2]], ptr [[SYSTEM_DATA_ALLOCA]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP47:%.*]] = load [[TMP0]], ptr [[TMP46]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    ret [[TMP0]] [[TMP47]], !continuation.registercount !20
;

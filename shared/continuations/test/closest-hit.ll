; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt --opaque-pointers=0 --enforce-pointer-metadata=1 --verify-each -passes='add-types-metadata,dxil-cont-intrinsic-prepare,lint,dxil-cont-lgc-rt-op-converter,lint,lower-raytracing-pipeline,lint,remove-types-metadata' -S %s 2>%t0.stderr | FileCheck -check-prefix=LOWERRAYTRACINGPIPELINE %s
; RUN: count 0 < %t0.stderr

target datalayout = "e-m:e-p:64:32-p20:32:32-p21:32:32-i1:32-i8:8-i16:32-i32:32-i64:32-f16:32-f32:32-f64:32-v16:32-v32:32-v48:32-v64:32-v80:32-v96:32-v112:32-v128:32-v144:32-v160:32-v176:32-v192:32-v208:32-v224:32-v240:32-v256:32-n8:16:32"

%struct.HitData = type { float, i32 }
%struct.DispatchSystemData = type { <3 x i32> }
%struct.SystemData = type { %struct.DispatchSystemData }
%struct.TraversalData = type { %struct.SystemData, %struct.HitData, <3 x float>, <3 x float>, float }
%struct.AnyHitTraversalData = type { %struct.TraversalData, %struct.HitData }

declare i64 @_cont_GetTraversalAddr() #4
declare i32 @_cont_GetContinuationStackAddr() #4
declare %struct.BuiltInTriangleIntersectionAttributes @_cont_GetTriangleHitAttributes(%struct.SystemData*) #4
declare void @_cont_SetTriangleHitAttributes(%struct.SystemData*, %struct.BuiltInTriangleIntersectionAttributes) #4
declare i1 @_cont_IsEndSearch(%struct.TraversalData*) #4
declare %struct.DispatchSystemData @_cont_Traversal(%struct.TraversalData) #4
declare %struct.DispatchSystemData @_cont_SetupRayGen() #4
declare %struct.AnyHitTraversalData @_AmdAwaitAnyHit(i64, %struct.AnyHitTraversalData, float, i32) #4
declare %struct.HitData @_cont_GetCandidateState(%struct.AnyHitTraversalData*) #4
declare %struct.HitData @_cont_GetCommittedState(%struct.SystemData*) #4

define i32 @_cont_GetLocalRootIndex(%struct.DispatchSystemData* %data) #4 {
; LOWERRAYTRACINGPIPELINE-LABEL: @_cont_GetLocalRootIndex(
; LOWERRAYTRACINGPIPELINE-NEXT:    ret i32 5
;
  ret i32 5
}

define void @_cont_TraceRay(%struct.DispatchSystemData* %data, i64, i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float) #4 {
; LOWERRAYTRACINGPIPELINE-LABEL: @_cont_TraceRay(
; LOWERRAYTRACINGPIPELINE-NEXT:    [[DIS_DATA:%.*]] = load [[STRUCT_DISPATCHSYSTEMDATA:%.*]], %struct.DispatchSystemData* [[DATA:%.*]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYS_DATA:%.*]] = insertvalue [[STRUCT_SYSTEMDATA:%.*]] undef, [[STRUCT_DISPATCHSYSTEMDATA]] [[DIS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA:%.*]] = insertvalue [[STRUCT_TRAVERSALDATA:%.*]] undef, [[STRUCT_SYSTEMDATA]] [[SYS_DATA]], 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP15:%.*]] = call [[STRUCT_DISPATCHSYSTEMDATA]] @_cont_Traversal([[STRUCT_TRAVERSALDATA]] [[TRAV_DATA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[STRUCT_DISPATCHSYSTEMDATA]] [[TMP15]], %struct.DispatchSystemData* [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    ret void
;
  %dis_data = load %struct.DispatchSystemData, %struct.DispatchSystemData* %data
  %sys_data = insertvalue %struct.SystemData undef, %struct.DispatchSystemData %dis_data, 0
  %trav_data = insertvalue %struct.TraversalData undef, %struct.SystemData %sys_data, 0
  %newdata = call %struct.DispatchSystemData @_cont_Traversal(%struct.TraversalData %trav_data)
  store %struct.DispatchSystemData %newdata, %struct.DispatchSystemData* %data
  ret void
}

define i1 @_cont_ReportHit(%struct.AnyHitTraversalData* %data, float %t, i32 %hitKind) #4 {
; LOWERRAYTRACINGPIPELINE-LABEL: @_cont_ReportHit(
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TRAV_DATA:%.*]] = load [[STRUCT_ANYHITTRAVERSALDATA:%.*]], %struct.AnyHitTraversalData* [[DATA:%.*]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP1:%.*]] = call [[STRUCT_ANYHITTRAVERSALDATA]] @_AmdAwaitAnyHit(i64 3, [[STRUCT_ANYHITTRAVERSALDATA]] [[TRAV_DATA]], float [[T:%.*]], i32 [[HITKIND:%.*]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[STRUCT_ANYHITTRAVERSALDATA]] [[TMP1]], %struct.AnyHitTraversalData* [[DATA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    ret i1 true
;
  %trav_data = load %struct.AnyHitTraversalData, %struct.AnyHitTraversalData* %data
  %newdata = call %struct.AnyHitTraversalData @_AmdAwaitAnyHit(i64 3, %struct.AnyHitTraversalData %trav_data, float %t, i32 %hitKind)
  store %struct.AnyHitTraversalData %newdata, %struct.AnyHitTraversalData* %data
  ret i1 1
}

; Function Attrs: nounwind readnone
declare i32 @_cont_DispatchRaysIndex(%struct.DispatchSystemData* nocapture readnone %data, i32 %i) #2
declare i32 @_cont_DispatchRaysDimensions(%struct.DispatchSystemData* nocapture readnone %data, i32 %i) #2
declare float @_cont_WorldRayOrigin(%struct.DispatchSystemData* nocapture readnone %data, i32 %i) #2
declare float @_cont_WorldRayDirection(%struct.DispatchSystemData* nocapture readnone %data, i32 %i) #2
declare float @_cont_RayTMin(%struct.DispatchSystemData* nocapture readnone %data) #2
declare float @_cont_RayTCurrent(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*) #1
declare i32 @_cont_RayFlags(%struct.DispatchSystemData* nocapture readnone %data) #2
declare i32 @_cont_InstanceIndex(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*) #2
declare i32 @_cont_InstanceID(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*) #2
declare i32 @_cont_PrimitiveIndex(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*) #2
declare float @_cont_ObjectRayOrigin(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*, i32 %i) #2
declare float @_cont_ObjectRayDirection(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*, i32 %i) #2
declare float @_cont_ObjectToWorld(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*, i32 %x, i32 %y) #2
declare float @_cont_WorldToObject(%struct.DispatchSystemData* nocapture readnone %data, %struct.HitData*, i32 %x, i32 %y) #2
declare i32 @_cont_HitKind(%struct.SystemData* nocapture readnone %data, %struct.HitData*) #2

%dx.types.Handle = type { i8* }
%struct.RayPayload = type { <2 x float> }
%struct.BuiltInTriangleIntersectionAttributes = type { <2 x float> }

; Function Attrs: nounwind
define void @ClosestHit(%struct.RayPayload* noalias nocapture %payload, %struct.BuiltInTriangleIntersectionAttributes* nocapture readonly %attr) #0 {
; LOWERRAYTRACINGPIPELINE-LABEL: @ClosestHit(
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP2:%.*]] = alloca [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[SYSTEM_DATA_ALLOCA:%.*]] = alloca [[STRUCT_SYSTEMDATA:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP3:%.*]] = alloca [[STRUCT_RAYPAYLOAD:%.*]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[HITATTRS:%.*]] = alloca [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]], align 8
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP4:%.*]] = call [[STRUCT_SYSTEMDATA]] @continuations.getSystemData.s_struct.SystemDatas()
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[STRUCT_SYSTEMDATA]] [[TMP4]], %struct.SystemData* [[SYSTEM_DATA_ALLOCA]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT_SYSTEMDATA]], %struct.SystemData* [[SYSTEM_DATA_ALLOCA]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[LOCAL_ROOT_INDEX:%.*]] = call i32 @_cont_GetLocalRootIndex(%struct.DispatchSystemData* [[TMP5]])
; LOWERRAYTRACINGPIPELINE-NEXT:    call void @amd.dx.setLocalRootIndex(i32 [[LOCAL_ROOT_INDEX]])
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], %struct.RayPayload* [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP7:%.*]] = bitcast <2 x float>* [[TMP6]] to i32*
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP8:%.*]] = getelementptr i32, i32* [[TMP7]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP9:%.*]] = getelementptr i32, i32* [[TMP8]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP10:%.*]] = load i32, i32* getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_3_CLOSESTHIT_IN_PAYLOAD_ATTR_0_I32S:%.*]], %struct.RayPayload.attr_max_8_i32s.layout_3_closesthit_in.payload_attr_0_i32s* bitcast ([30 x i32]* @PAYLOAD to %struct.RayPayload.attr_max_8_i32s.layout_3_closesthit_in.payload_attr_0_i32s*), i32 0, i32 0, i32 0), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP10]], i32* [[TMP9]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[TMP7]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP12:%.*]] = getelementptr i32, i32* [[TMP11]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP13:%.*]] = load i32, i32* getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_3_CLOSESTHIT_IN_PAYLOAD_ATTR_0_I32S]], %struct.RayPayload.attr_max_8_i32s.layout_3_closesthit_in.payload_attr_0_i32s* bitcast ([30 x i32]* @PAYLOAD to %struct.RayPayload.attr_max_8_i32s.layout_3_closesthit_in.payload_attr_0_i32s*), i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP13]], i32* [[TMP12]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    call void (...) @registerbuffer.setpointerbarrier([30 x i32]* @PAYLOAD)
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP14:%.*]] = bitcast %struct.BuiltInTriangleIntersectionAttributes* [[TMP2]] to i32*
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP15:%.*]] = call [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]] @_cont_GetTriangleHitAttributes(%struct.SystemData* [[SYSTEM_DATA_ALLOCA]])
; LOWERRAYTRACINGPIPELINE-NEXT:    store [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]] [[TMP15]], %struct.BuiltInTriangleIntersectionAttributes* [[TMP2]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP16:%.*]] = bitcast %struct.BuiltInTriangleIntersectionAttributes* [[HITATTRS]] to i32*
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP18:%.*]] = getelementptr inbounds i32, i32* [[TMP14]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP19:%.*]] = load i32, i32* [[TMP18]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP19]], i32* [[TMP17]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP20:%.*]] = getelementptr inbounds i32, i32* [[TMP16]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i32, i32* [[TMP14]], i64 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP22:%.*]] = load i32, i32* [[TMP21]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP22]], i32* [[TMP20]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[PTR:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], %struct.RayPayload* [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[BARYPTR:%.*]] = getelementptr inbounds [[STRUCT_BUILTINTRIANGLEINTERSECTIONATTRIBUTES]], %struct.BuiltInTriangleIntersectionAttributes* [[HITATTRS]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[BARY:%.*]] = load <2 x float>, <2 x float>* [[BARYPTR]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store <2 x float> [[BARY]], <2 x float>* [[PTR]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    call void (...) @registerbuffer.setpointerbarrier([30 x i32]* @PAYLOAD)
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP23:%.*]] = getelementptr inbounds [[STRUCT_RAYPAYLOAD]], %struct.RayPayload* [[TMP3]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP24:%.*]] = bitcast <2 x float>* [[TMP23]] to i32*
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP25:%.*]] = getelementptr i32, i32* [[TMP24]], i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP26:%.*]] = getelementptr i32, i32* [[TMP25]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP27]], i32* getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT:%.*]], %struct.RayPayload.attr_max_8_i32s.layout_5_closesthit_out* bitcast ([30 x i32]* @PAYLOAD to %struct.RayPayload.attr_max_8_i32s.layout_5_closesthit_out*), i32 0, i32 0, i32 0), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP28:%.*]] = getelementptr i32, i32* [[TMP24]], i32 1
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP29:%.*]] = getelementptr i32, i32* [[TMP28]], i64 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP30:%.*]] = load i32, i32* [[TMP29]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    store i32 [[TMP30]], i32* getelementptr inbounds ([[STRUCT_RAYPAYLOAD_ATTR_MAX_8_I32S_LAYOUT_5_CLOSESTHIT_OUT]], %struct.RayPayload.attr_max_8_i32s.layout_5_closesthit_out* bitcast ([30 x i32]* @PAYLOAD to %struct.RayPayload.attr_max_8_i32s.layout_5_closesthit_out*), i32 0, i32 0, i32 7), align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP31:%.*]] = getelementptr inbounds [[STRUCT_SYSTEMDATA]], %struct.SystemData* [[SYSTEM_DATA_ALLOCA]], i32 0, i32 0
; LOWERRAYTRACINGPIPELINE-NEXT:    [[TMP32:%.*]] = load [[STRUCT_DISPATCHSYSTEMDATA:%.*]], %struct.DispatchSystemData* [[TMP31]], align 4
; LOWERRAYTRACINGPIPELINE-NEXT:    ret [[STRUCT_DISPATCHSYSTEMDATA]] [[TMP32]], !continuation.registercount !13
;
  %ptr = getelementptr inbounds %struct.RayPayload, %struct.RayPayload* %payload, i32 0, i32 0
  %baryPtr = getelementptr inbounds %struct.BuiltInTriangleIntersectionAttributes, %struct.BuiltInTriangleIntersectionAttributes* %attr, i32 0, i32 0
  %bary = load <2 x float>, <2 x float>* %baryPtr
  store <2 x float> %bary, <2 x float>* %ptr
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="0" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind readnone }
attributes #4 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="0" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.ident = !{!0}
!dx.version = !{!1}
!dx.valver = !{!1}
!dx.shaderModel = !{!2}
!dx.resources = !{!3}
!dx.typeAnnotations = !{}
!dx.entryPoints = !{!18, !23}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
!1 = !{i32 1, i32 6}
!2 = !{!"lib", i32 6, i32 6}
!3 = !{null, null, null, null}
!18 = !{null, !"", null, !3, !19}
!19 = !{i32 0, i64 65536}
!22 = !{i32 0}
!23 = !{void (%struct.RayPayload*, %struct.BuiltInTriangleIntersectionAttributes*)* @ClosestHit, !"ClosestHit", null, null, !24}
!24 = !{i32 8, i32 10, i32 5, !22}

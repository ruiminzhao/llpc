// NOTE: Assertions have been autogenerated by tool/update_llpc_test_checks.py UTC_ARGS: --function-signature --check-globals
// RUN: amdllpc -o - -gfxip 10.1 -emit-lgc %s | FileCheck -check-prefixes=CHECK %s
#version 450

struct S {
    vec4 a;
    int b;
};
layout(points) in;

layout(points, max_vertices = 1) out;
layout(xfb_buffer = 0, xfb_offset = 0, xfb_stride = 16, location = 0) out Block
{
    S s;
} block[2][3];

void main(void)
{
    EmitVertex();
    EndPrimitive();
}
// CHECK-LABEL: define {{[^@]+}}@lgc.shader.GS.main
// CHECK-SAME: () local_unnamed_addr #[[ATTR0:[0-9]+]] !spirv.ExecutionModel !7 !lgc.xfb.state !8 !lgc.shaderstage !9 {
// CHECK-NEXT:  .entry:
// CHECK-NEXT:    call void (...) @lgc.create.emit.vertex(i32 0)
// CHECK-NEXT:    call void (...) @lgc.create.end.primitive(i32 0)
// CHECK-NEXT:    ret void
//
//.
// CHECK: attributes #[[ATTR0]] = { nounwind }
//.
// CHECK: [[META0:![0-9]+]] = !{i32 0, i32 0, i32 1, i32 1}
// CHECK: [[META1:![0-9]+]] = !{!"Vulkan"}
// CHECK: [[META2:![0-9]+]] = !{i32 1}
// CHECK: [[META5:![0-9]+]] = !{i32 0, i32 3}
// CHECK: [[META7:![0-9]+]] = !{i32 3}
// CHECK: [[META8:![0-9]+]] = !{i32 0, i32 16, i32 0, i32 16, i32 0, i32 16, i32 -1, i32 0}
// CHECK: [[META9:![0-9]+]] = !{i32 4}
//.

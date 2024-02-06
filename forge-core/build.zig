const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    // const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    const forge_core_module = b.createModule(.{ .source_file = .{ .path = "src/forge.zig" } });

    try b.modules.put(b.dupe("forge"), forge_core_module);
}

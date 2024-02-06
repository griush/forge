const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const forge_core = b.dependency("forge", .{});

    const exe = b.addExecutable(.{
        .name = "forge-runtime",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.addModule("forge", forge_core.module("forge"));

    b.installArtifact(exe);
}

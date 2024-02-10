const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const forge_mod = b.addModule("forge", .{  .root_source_file = .{ .path = "src/forge.zig" }, });
    const forge_lib = b.addStaticLibrary(.{
        .name = "forge",
        .root_source_file = .{ .path = "src/forge.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    b.installArtifact(forge_lib);
    forge_mod.linkLibrary(forge_lib);    
}

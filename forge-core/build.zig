const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const glfw_dep = b.dependency("glfw", .{
        .target = target,
        .optimize = optimize,
    });

    const forge_mod = b.addModule("forge", .{
        .root_source_file = .{ .path = "src/forge.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    forge_mod.linkLibrary(glfw_dep.artifact("glfw"));
    @import("glfw").addPaths(forge_mod);

    if (target.result.os.tag == .windows) {
        forge_mod.linkSystemLibrary("gdi32", .{});
        forge_mod.linkSystemLibrary("user32", .{});
        forge_mod.linkSystemLibrary("shell32", .{});
    } else if (target.result.os.tag == .macos) {
        // Nothing for now, macos not supported
    } else {
        // If not windows and not macos must be linux
    }
}

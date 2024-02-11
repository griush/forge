const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const forge_mod = b.addModule("forge", .{ 
        .root_source_file = .{ .path = "src/forge.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    forge_mod.addIncludePath(.{ .path = "dependencies/GLFW/include/"});
    forge_mod.addLibraryPath(.{ .path = "dependencies/GLFW/lib-mingw-w64/"});

    if (target.result.os.tag == .windows) {
        forge_mod.linkSystemLibrary("gdi32", .{});
        forge_mod.linkSystemLibrary("user32", .{});
        forge_mod.linkSystemLibrary("shell32", .{});
    }

    forge_mod.linkSystemLibrary("glfw3", .{
        .preferred_link_mode = .Static,
    });

    forge_mod.linkSystemLibrary("opengl32", .{
        .preferred_link_mode = .Static,
    });
}

const std = @import("std");
const fs = std.fs;

// TODO: For all functions, better error handling (stop with catch unreachable)

pub const LoggerSpecification = struct {
    to_std: bool,
    to_file: bool,
};

const Logger = struct {
    spec: LoggerSpecification,
    initialized: bool,
    file: fs.File,
};

var g_logger = Logger {
    .spec = undefined,
    .initialized = false,
    .file = undefined,
};

/// Must be called before using any log function.
/// Little has been done for now.
pub fn init(spec: LoggerSpecification) !void {
    g_logger.spec = spec;

    g_logger.file = try fs.cwd().createFile("forge.log", .{},);
    try g_logger.file.writeAll("");

    g_logger.initialized = true;
}

/// Must be called to close the file
pub fn shutdown() void {
    g_logger.file.close();
}

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }

    const stdio = std.io.getStdErr().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[48;5;9m\u{001B}[38;5;15m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[fatal]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }

    const stdio = std.io.getStdErr().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[38;5;9m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[error]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

pub fn warn(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }

    const stdio = std.io.getStdErr().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[38;5;11m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[warn]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

pub fn info(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }
    
    const stdio = std.io.getStdOut().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[38;5;10m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[info]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }

    const stdio = std.io.getStdOut().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[38;5;12m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[debug]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

pub fn trace(comptime fmt: []const u8, args: anytype) void {
    if (!g_logger.initialized) {
        return;
    }
    
    const stdio = std.io.getStdOut().writer();

    if (g_logger.spec.to_std) {
        stdio.print("\u{001B}[38;5;247m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
    }

    if (g_logger.spec.to_file) {
        g_logger.file.writer().print("[trace]: " ++ fmt ++ "\n", args) catch unreachable;
    }
}

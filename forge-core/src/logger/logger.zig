const std = @import("std");

// TODO: For all functions, better error handling
// TODO: Add different logging options (to files or custom windows (like an editor window))

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdErr().writer();

    stdio.print("\u{001B}[48;5;9m\u{001B}[38;5;15m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdErr().writer();

    stdio.print("\u{001B}[38;5;9m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

pub fn warn(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdErr().writer();

    stdio.print("\u{001B}[38;5;11m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

pub fn info(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdOut().writer();

    stdio.print("\u{001B}[38;5;10m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdOut().writer();

    stdio.print("\u{001B}[38;5;12m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

pub fn trace(comptime fmt: []const u8, args: anytype) void {
    const stdio = std.io.getStdOut().writer();

    stdio.print("\u{001B}[38;5;247m" ++ fmt ++ "\u{001B}[0m\n", args) catch unreachable;
}

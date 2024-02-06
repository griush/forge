const std = @import("std");
const forge = @import("forge");

pub fn main() anyerror!void {
    std.debug.print("Forge-core version: {s}", .{forge.getVersionName() });
}

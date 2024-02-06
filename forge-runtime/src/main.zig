const std = @import("std");
const forge = @import("forge");

pub fn main() anyerror!void {
    forge.logger.fatal("Forge core version: {s}", .{ forge.getVersionName() });
    forge.logger.err("Forge core version: {s}", .{ forge.getVersionName() });
    forge.logger.warn("Forge core version: {s}", .{ forge.getVersionName() });
    forge.logger.info("Forge core version: {s}", .{ forge.getVersionName() });
    forge.logger.debug("Forge core version: {s}", .{ forge.getVersionName() });
    forge.logger.trace("Forge core version: {s}", .{ forge.getVersionName() });
}

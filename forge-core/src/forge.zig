// Cient usage file. All exposed structs, functions and constants will be accessed form here
pub const application = @import("core/application.zig");
pub const engine = @import("core/engine.zig");
pub const logger = @import("core/logger.zig");

const forge_version_name: []const u8 = "0.0.1-alpha";

/// Returns: (string) the current core version.
pub fn getVersionName() []const u8 {
    return forge_version_name;
}

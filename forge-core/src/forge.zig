// Cient usage file. All exposed structs, functions and constants will be accessed form here
// Core
pub const application = @import("core/application.zig");
pub const engine = @import("core/engine.zig");
pub const logger = @import("core/logger.zig");
pub const events = @import("core/events.zig");
pub const input = @import("core/input.zig");

// Math
pub const math = @import("math/math.zig");

// Renderer
pub const renderer = @import("renderer/frontend.zig");

const forge_version_name: [:0]const u8 = "v0.0.1-dev";

/// Returns: (string) the current core version.
pub fn getVersionName() [:0]const u8 {
    return forge_version_name;
}

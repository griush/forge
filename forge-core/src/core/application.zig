const events = @import("events.zig");

pub const Application = struct {
    name: []const u8,
    working_dir: []const u8 = ".",

    on_init: *const fn () void,
    on_update: *const fn (f64) void,
    on_event: *const fn (events.EventType, events.EventPayload) void,
};

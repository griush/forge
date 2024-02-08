const logger = @import("logger.zig");
const std = @import("std");

pub const EventType = enum(u32) {
    // Window events
    WindowClose, // No payload
    WindowResize, // size: [2]u32

    // Key
    KeyPress, // keycode: u32
    KeyRelease, // keycode: u32

    // Mouse
    MouseMove, // delta: [2]f32
    MouseButtonPress, // mouse_code: u32
    MouseButtonRelease, // mouse_code: u32
    MouseScroll, // delta: [2]f32.x
};

pub const EventPayload = union {
    size: [2]u32,
    key_code: u32,
    delta: [2]f32,
    mouse_code: u32,
};

pub const EventCallbackFn = *const fn(EventPayload) bool;

const ClientRegistrations = struct {
    type: EventType,
    callback: EventCallbackFn,
};

var g_client_registrations: std.ArrayList(ClientRegistrations) = undefined;

pub fn init() void {
    g_client_registrations = std.ArrayList(ClientRegistrations).init(std.heap.c_allocator);
}

pub fn shutdown() void {
    g_client_registrations.deinit();
}

pub fn registerEvent(event_type: EventType, callback: EventCallbackFn) void {
    g_client_registrations.append(.{
        .type = event_type,
        .callback = callback,
    }) catch |err| {
        logger.err("Error at 'registerEvent': {s}", .{@errorName(err)});
    };
}

pub fn fireEvent(event_type: EventType, payload: EventPayload) bool {
    for (g_client_registrations.items) |reg| {
        if (reg.type != event_type) {
            continue;
        }

        if (reg.callback(payload)) {
            return true; // Event handled, can exit
        }
    }

    return false;
}

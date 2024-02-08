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
var g_events_initialized: bool = false;

/// Must call shutdown to free allocated memory.
pub fn init() void {
    g_client_registrations = std.ArrayList(ClientRegistrations).init(std.heap.c_allocator);
    g_events_initialized = true;
}

pub fn shutdown() void {
    g_client_registrations.deinit();
    g_events_initialized = false;
}

/// The order of callback registration matters.
/// If a callback returns true (the event has been handled) it will break the loop and all the remaining callbacks will be ingnored.
pub fn registerEvent(event_type: EventType, callback: EventCallbackFn) void {
    if (!g_events_initialized) {
        logger.err("Event registered before event system initialisation", .{});
    }

    g_client_registrations.append(.{
        .type = event_type,
        .callback = callback,
    }) catch |err| {
        logger.err("Error at 'registerEvent': {s}", .{@errorName(err)});
    };
}

pub fn fireEvent(event_type: EventType, payload: EventPayload) bool {
    if (!g_events_initialized) {
        logger.err("Event fired before event system initialisation", .{});
    }

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

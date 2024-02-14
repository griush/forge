const logger = @import("logger.zig");
const input = @import("input.zig");

const std = @import("std");

pub const EventType = enum(u32) {
    // Window events
    WindowClose, // No payload
    WindowResize, // size: [2]i32

    // Key
    KeyPress, // keycode: u32
    KeyRelease, // keycode: u32

    // Mouse
    MouseMove, // delta: [2]f32
    MouseButtonPress, // mouse_code: u32
    MouseButtonRelease, // mouse_code: u32
    MouseScroll, // delta: [2]f32.x

    AllTypes,
};

pub const EventPayload = union {
    size: [2]i32,
    key_code: input.KeyCode,
    delta: [2]f64,
    mouse_code: input.MouseCode,
};

pub const EventCallbackFn = *const fn (EventType, EventPayload) bool;

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
        if (reg.type != event_type and reg.type != EventType.AllTypes) {
            continue;
        }

        if (reg.callback(event_type, payload)) {
            return true; // Event handled, can exit
        }
    }

    return false;
}

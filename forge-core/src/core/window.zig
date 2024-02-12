const c = @import("../c.zig");
const logger = @import("logger.zig");
const event = @import("events.zig");
const input = @import("input.zig");

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    logger.err("GLFW errror ({d}): {s}", .{err, description});
}

fn windowCloseCallback(handle: ?*c.GLFWwindow) callconv(.C) void {
    _ = handle;
    const payload = event.EventPayload{
        // Because this event does not carry payload any value would work here as it should be ignored
        .key_code = input.KeyCode.None,
    };
    _ = event.fireEvent(event.EventType.WindowClose, payload);
}

fn windowSizeCallback(handle: ?*c.GLFWwindow, w: c_int, h: c_int) callconv(.C) void {
    _ = handle;

    const payload = event.EventPayload{
        .size = [_]i32{w, h},
    };

    _ = event.fireEvent(event.EventType.WindowResize, payload);
}

fn keyCallback(
    handle: ?*c.GLFWwindow,
    key: c_int,
    scancode: c_int,
    action: c_int,
    mods: c_int,
) callconv(.C) void {
    _ = handle;
    _ = mods;
    _ = scancode;

    // logger.debug("{d}", .{key});
    //* On my keyboard, the key that opens the calculator throws a '-1' and crashes
    //* Below there is a temp fix.
    // TODO: temp
    var key_code: i32 = key;
    if (key_code == -1) {
        key_code = 0;
    }

    const payload = event.EventPayload{
        .key_code = @enumFromInt(key_code),
    };

    var event_type: event.EventType = undefined;
    if (action == c.GLFW_PRESS or action == c.GLFW_REPEAT) {
        event_type = event.EventType.KeyPress;
    }
    else if (action == c.GLFW_RELEASE) {
        event_type = event.EventType.KeyRelease;
    }
    _ = event.fireEvent(event_type, payload);
}

fn mouseButtonCallback(
    handle: ?*c.GLFWwindow,
    button: c_int,
    action: c_int,
    mods: c_int,
) callconv(.C) void {
    _ = handle;
    _ = mods;

    var mouse_code: i32 = button;
    if (mouse_code == -1) {
        mouse_code = 0;
    }

    const payload = event.EventPayload{
        .mouse_code = @enumFromInt(mouse_code),
    };

    var event_type: event.EventType = undefined;
    if (action == c.GLFW_PRESS or action == c.GLFW_REPEAT) {
        event_type = event.EventType.MouseButtonPress;
    }
    else if (action == c.GLFW_RELEASE) {
        event_type = event.EventType.MouseButtonRelease;
    }
    _ = event.fireEvent(event_type, payload);
}

fn mousePosCallback(handle: ?*c.GLFWwindow, xpos: f64, ypos: f64) callconv(.C) void {
    _ = handle;

    const payload = event.EventPayload {
        .delta = [_]f64{ xpos, ypos },
    };

    _ = event.fireEvent(event.EventType.MouseMove, payload);
}

fn mouseScrollCallback(handle: ?*c.GLFWwindow, xo: f64, yo: f64) callconv(.C) void {
    _ = handle;

    const payload = event.EventPayload{
        .delta = [_]f64 {xo, yo},
    };

    _ = event.fireEvent(event.EventType.MouseScroll, payload);
} 

pub const WindowInitError = error {
    GLFWInitError,
    WindowCreateError,
};

pub const WindowSpecification = struct {
    title: []const u8,
    width: i32,
    height: i32,
};

var g_window_count: u32 = 0;

pub const Window = struct {
    handle: ?*c.GLFWwindow = undefined,

    pub fn init(spec: WindowSpecification) WindowInitError!Window {
        if (g_window_count == 0) {
            _ = c.glfwSetErrorCallback(errorCallback);
            if(c.glfwInit() == 0) {
                return WindowInitError.GLFWInitError;
            }
        }

        var win = Window{
            .handle = undefined,
        };

        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

        win.handle = c.glfwCreateWindow(@as(c_int, spec.width), @as(c_int, spec.height), @ptrCast(spec.title), null, null);
        if (win.handle == null) {
            return WindowInitError.WindowCreateError;
        }

        g_window_count += 1;

        _ = c.glfwSetWindowCloseCallback(win.handle, windowCloseCallback);
        _ = c.glfwSetWindowSizeCallback(win.handle, windowSizeCallback);
        _ = c.glfwSetKeyCallback(win.handle, keyCallback);
        _ = c.glfwSetMouseButtonCallback(win.handle, mouseButtonCallback);
        _ = c.glfwSetCursorPosCallback(win.handle, mousePosCallback);
        _ = c.glfwSetScrollCallback(win.handle, mouseScrollCallback);

        logger.info("Created window: '{s}'", .{spec.title});
        return win;
    }

    pub fn shutdown(self: Window) void {
        c.glfwDestroyWindow(self.handle);
        g_window_count -= 1;

        if (g_window_count == 0) {
            c.glfwTerminate();
        }
    }

    pub fn update(self: Window) void {
        _ = self;
        c.glfwPollEvents();
    }
};

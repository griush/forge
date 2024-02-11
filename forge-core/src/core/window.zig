const c = @import("../c.zig");
const logger = @import("logger.zig");
const event = @import("events.zig");

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    logger.err("GLFW errror ({d}): {s}", .{err, description});
}

fn windowCloseCallback(handle: ?*c.GLFWwindow) callconv(.C) void {
    _ = handle;
    const payload = event.EventPayload{
        .key_code = 0,
    };
    _ = event.fireEvent(event.EventType.WindowClose, payload);
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

    const payload = event.EventPayload{
        .key_code = @as(i32, key)
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

        win.handle = c.glfwCreateWindow(@as(c_int, spec.width), @as(c_int, spec.height), @ptrCast(spec.title), null, null);
        if (win.handle == null) {
            return WindowInitError.WindowCreateError;
        }

        g_window_count += 1;

        c.glfwMakeContextCurrent(win.handle);

        _ = c.glfwSetWindowCloseCallback(win.handle, windowCloseCallback);
        _ = c.glfwSetKeyCallback(win.handle, keyCallback);

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
        // TODO: Temp GL Code
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        c.glClearColor(1.0, 0.0, 1.0, 1.0);

        c.glfwSwapBuffers(self.handle);
        c.glfwPollEvents();
    }
};

const c = @import("../c.zig");
const logger = @import("logger.zig");
const event = @import("events.zig");

// TODO: Support for more than one window

fn windowCloseCallback(handle: ?*c.GLFWwindow) callconv(.C) void {
    _ = handle;
    const payload = event.EventPayload{
        .key_code = 0,
    };
    _ = event.fireEvent(event.EventType.WindowClose, payload);
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
        c.glfwSwapBuffers(self.handle);
        c.glfwPollEvents();
    }
};

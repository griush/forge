const app = @import("application.zig");
const logger = @import("logger.zig");
const events = @import("events.zig");
const window = @import("window.zig");
// std
const std = @import("std");
const time = std.time;

const c = @import("../c.zig");

const RuntimeError = error {
    EngineNotInitialized,
};

const Engine = struct {
    app_handle: app.Application,
    is_running: bool,
    initialized: bool,
    main_window: window.Window,
};

var g_engine = Engine {
    .app_handle = undefined,
    .is_running = false,
    .initialized = false,
    .main_window = undefined,
};

//* Section event callbacks
fn onEvent(t: events.EventType, payload: events.EventPayload) bool {
    g_engine.app_handle.on_event(t, payload);
    return false;
}

fn onWindoCloseEvent(t: events.EventType, payload: events.EventPayload) bool {
    _ = t;
    _ = payload;
    g_engine.is_running = false;
    return true;
}
//* End section

pub fn init(client_app: app.Application) !void {
    g_engine.app_handle = client_app;

    const win_spec = window.WindowSpecification{
        .title = client_app.name,
        .width = 1920,
        .height = 1080,
    };

    // TODO: Not tested but should work
    std.os.chdir(client_app.working_dir) catch |err| {
        logger.err("Error in working_dir: {s}", .{@errorName(err)});
    };

    events.init();

    g_engine.main_window = try window.Window.init(win_spec);
    _ = events.registerEvent(events.EventType.WindowClose, onWindoCloseEvent);
    _ = events.registerEvent(events.EventType.WindowResize, onEvent);
    _ = events.registerEvent(events.EventType.KeyPress, onEvent);
    _ = events.registerEvent(events.EventType.MouseButtonPress, onEvent);
    _ = events.registerEvent(events.EventType.MouseButtonRelease, onEvent);
    _ = events.registerEvent(events.EventType.MouseMove, onEvent);
    _ = events.registerEvent(events.EventType.MouseScroll, onEvent);

    g_engine.initialized = true;

    logger.info("Initialized engine.", .{});
    logger.info("Loaded application: '{s}'", .{client_app.name});
}

pub fn shutdown() void {
    g_engine.main_window.shutdown();
    events.shutdown();
}

pub fn run() RuntimeError!void {
    if (!g_engine.initialized) {
        return RuntimeError.EngineNotInitialized;
    }

    g_engine.is_running = true;

    g_engine.app_handle.on_init();

    // This would only fail on wierd computers, any personal or "normal" computer will work.
    // Form std docs
    var dt_timer = time.Timer.start() catch unreachable;

    while (g_engine.is_running) {
        // TODO: Looks like it's working but test more
        const delta_time: f64 = @as(f64, @floatFromInt(dt_timer.read())) / @as(f64, @floatFromInt(time.ns_per_s));
        dt_timer.reset();

        g_engine.app_handle.on_update(delta_time);

        g_engine.main_window.update();
    }
}

pub fn close() void {
    g_engine.is_running = false;
}

pub fn getMainWindow() window.Window {
    return g_engine.main_window;
}

const app = @import("application.zig");
const logger = @import("logger.zig");
const time = @import("std").time;

const RuntimeError = error {
    EngineNotInitialized,
};

const Engine = struct {
    app_handle: app.Application,
    is_running: bool,
    initialized: bool,
};

var g_engine = Engine {
    .app_handle = undefined,
    .is_running = false,
    .initialized = false,
};

pub fn init(client_app: app.Application) void {
    g_engine.app_handle = client_app;
    g_engine.initialized = true;

    logger.info("Initialized engine.", .{});
    logger.info("Loaded application: '{s}'", .{client_app.name});
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
    }
}

pub fn close() void {
    g_engine.is_running = false;
}

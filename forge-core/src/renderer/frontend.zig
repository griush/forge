const backend = @import("backend.zig");
const logger = @import("../core/logger.zig");

pub const RenderPacket = struct {
    delta_time: f64,
};

var g_backend: backend.RendererBackend = undefined;

pub fn init(app_name: []const u8) bool {
    g_backend = backend.RendererBackend.init(backend.RendererAPI.Vulkan);

    if (!g_backend.init(&g_backend, app_name)) {
        logger.fatal("Renderer initialization failed.", .{});
        return false;
    }

    return true;
}

pub fn shutdown() void {
    g_backend.shutdown(&g_backend);
}

pub fn onResized(width: i32, height: i32) void {
    _ = width;
    _ = height;
}

fn beginFrame(delta_time: f64) bool {
    return g_backend.begin_frame(&g_backend, delta_time);
}

fn endFrame(delta_time: f64) bool {
    return g_backend.end_frame(&g_backend, delta_time);
}

pub fn drawFrame(packet: RenderPacket) bool {
    if (beginFrame(packet.delta_time)) {
        const result = endFrame(packet.delta_time);

        if (!result) {
            logger.err("renderer.endFrame failed.", .{});
            return false;
        }
    }

    return true;
}

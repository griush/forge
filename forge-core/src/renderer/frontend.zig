const backend = @import("backend.zig");
const logger = @import("../core/logger.zig");

const RendererInitError = error{
    BackendInitFailed,
};

const RendererDrawFrameError = error{
    BeginFrameFailed,
    EndFrameFailed,
};

pub const RenderPacket = struct {
    delta_time: f64,
};

var g_backend: backend.RendererBackend = undefined;

pub fn init(app_name: []const u8) RendererInitError!void {
    g_backend = backend.RendererBackend.init(backend.RendererAPI.Vulkan);

    g_backend.init(&g_backend, app_name) catch |err| {
        logger.fatal("Renderer backend initialization failed.\nError: {s}", .{@errorName(err)});
        return RendererInitError.BackendInitFailed;
    };
}

pub fn shutdown() void {
    g_backend.shutdown(&g_backend);
}

pub fn onResize(width: i32, height: i32) void {
    g_backend.resize(&g_backend, width, height);
}

fn beginFrame(delta_time: f64) bool {
    return g_backend.begin_frame(&g_backend, delta_time);
}

fn endFrame(delta_time: f64) bool {
    return g_backend.end_frame(&g_backend, delta_time);
}

pub fn drawFrame(packet: RenderPacket) RendererDrawFrameError!void {
    if (beginFrame(packet.delta_time)) {
        const result = endFrame(packet.delta_time);

        if (!result) {
            logger.err("renderer.endFrame failed.", .{});
            return RendererDrawFrameError.EndFrameFailed;
        }
    } else {
        return RendererDrawFrameError.BeginFrameFailed;
    }
}

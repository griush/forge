const vulkan = @import("vulkan/backend.zig");

pub const RendererAPI = enum {
    Vulkan,
};

pub const RendererBackend = struct {
    frame_number: u64,

    init: *const fn (*RendererBackend, []const u8) vulkan.InitVulkanError!void = undefined,
    shutdown: *const fn (*RendererBackend) void = undefined,

    resize: *const fn (*RendererBackend, i32, i32) void = undefined,

    begin_frame: *const fn (*RendererBackend, f64) bool = undefined,
    end_frame: *const fn (*RendererBackend, f64) bool = undefined,

    pub fn init(api: RendererAPI) RendererBackend {
        var out_backend: RendererBackend = .{
            .frame_number = 0,
        };

        switch (api) {
            .Vulkan => {
                out_backend.init = vulkan.vulkanInit;
                out_backend.shutdown = vulkan.vulkanShutdown;
                out_backend.resize = vulkan.vulkanOnResize;
                out_backend.begin_frame = vulkan.vulkanBeginFrame;
                out_backend.end_frame = vulkan.vulkanEndFrame;
            },
        }

        return out_backend;
    }
};

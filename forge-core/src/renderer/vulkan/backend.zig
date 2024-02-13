const c = @import("c.zig");
const RendererBackend = @import("../backend.zig").RendererBackend;
const logger = @import("../../core/logger.zig");

const VulkanContext = struct {
    instance: c.VkInstance = undefined,
    allocator: ?*c.VkAllocationCallbacks = null,
};

var g_vulkan_context: VulkanContext = .{};

pub fn vulkanInit(backend: *RendererBackend, app_name: []const u8) bool {
    _ = backend;

    // TODO:  Vulkan allocator
    g_vulkan_context.allocator = null;

    const app_info: c.VkApplicationInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .apiVersion = c.VK_API_VERSION_1_3,
        .pApplicationName = @ptrCast(app_name),
        .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "Forge Engine",
        .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
    };

    const instance_create_info: c.VkInstanceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &app_info,
        .enabledExtensionCount = 0,
        .ppEnabledExtensionNames = null,
        .enabledLayerCount = 0,
        .ppEnabledLayerNames = null,
    };

    const result = c.vkCreateInstance(&instance_create_info, g_vulkan_context.allocator, &g_vulkan_context.instance);
    if (result != c.VK_SUCCESS) {
        logger.err("vkCreateInstance failed with result: {d}", .{result});
        return false;
    }

    logger.info("Vulkan initialized.", .{});
    return true;
}

pub fn vulkanShutdown(backend: *RendererBackend) void {
    _ = backend;

    logger.debug("Destroying Vulkan instance...", .{});
    c.vkDestroyInstance(g_vulkan_context.instance, g_vulkan_context.allocator);
}

pub fn vulkanOnResized(backend: *RendererBackend, width: i32, height: i32) void {
    _ = backend;
    _ = width;
    _ = height;
}

pub fn vulkanBeginFrame(backend: *RendererBackend, delta_time: f64) bool {
    _ = backend;
    _ = delta_time;
    return true;
}

pub fn vulkanEndFrame(backend: *RendererBackend, delta_time: f64) bool {
    _ = backend;
    _ = delta_time;
    return true;
}

const c = @import("c.zig"); // Vulkan and glfw (needed for window surface)
const RendererBackend = @import("../backend.zig").RendererBackend;

const logger = @import("../../core/logger.zig");
const engine = @import("../../core/engine.zig");
const window = @import("../../core/window.zig");

const std = @import("std");
const cstd = @import("../../c.zig");

pub const InitVulkanError = error{
    CreateInstanceFailed,
    ValidationLayerRequestedButNotAvailable,
};

const VulkanContext = struct {
    instance: c.VkInstance = undefined,
    allocator: ?*c.VkAllocationCallbacks = null,
};

var g_vulkan_context: VulkanContext = .{};
const g_enableValidationLayers = std.debug.runtime_safety;
const g_validationLayers = [_][*:0]const u8{"VK_LAYER_KHRONOS_validation"};

// Some vulkan helpers
fn checkVkSuccess(result: c.VkResult) !void {
    switch (result) {
        c.VK_SUCCESS => {},
        else => return error.Unexpected,
    }
}

fn checkValidationLayerSupport(allocator: std.mem.Allocator) !bool {
    var layerCount: u32 = undefined;

    try checkVkSuccess(c.vkEnumerateInstanceLayerProperties(&layerCount, null));

    const availableLayers = try allocator.alloc(c.VkLayerProperties, layerCount);
    defer allocator.free(availableLayers);

    try checkVkSuccess(c.vkEnumerateInstanceLayerProperties(&layerCount, availableLayers.ptr));

    for (g_validationLayers) |layerName| {
        var layerFound = false;

        for (availableLayers) |layer_properties| {
            const available_len = std.mem.indexOfScalar(u8, &layer_properties.layerName, 0).?;
            const available_layer_name = layer_properties.layerName[0..available_len];
            if (std.mem.eql(u8, std.mem.span(layerName), available_layer_name)) {
                layerFound = true;
                logger.debug("Requested Vulkan validation layer '{s}' found.", .{layerName});
                break;
            }
        }

        if (!layerFound) {
            logger.err("Required Vulkan validation layer not found: '{s}'", .{layerName});
            return false;
        }
    }

    logger.info("All Vulkan required validation layers are present.", .{});
    return true;
}

/// Caller must free returned memory
fn getRequiredExtensions(allocator: std.mem.Allocator) [][*]const u8 {
    var glfwExtensionCount: u32 = 0;
    var glfwExtensions: [*]const [*:0]const u8 = @ptrCast(c.glfwGetRequiredInstanceExtensions(&glfwExtensionCount));

    var extensions = std.ArrayList([*:0]const u8).init(allocator);
    errdefer extensions.deinit();

    // TODO: Handle this error better.
    // Error is OutOfMemory, so almost unreachable
    extensions.appendSlice(glfwExtensions[0..glfwExtensionCount]) catch unreachable;

    if (g_enableValidationLayers) {
        // TODO: Same as above
        extensions.append(c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME) catch unreachable;
    }

    logger.debug("Vulkan required extensions: {d}", .{extensions.items.len});
    for (extensions.items) |value| {
        logger.debug("  {s}", .{value});
    }

    return extensions.toOwnedSlice() catch unreachable;
}

pub fn vulkanInit(backend: *RendererBackend, app_name: []const u8) InitVulkanError!void {
    _ = backend;

    // TODO:  Vulkan allocator
    g_vulkan_context.allocator = null;

    if (g_enableValidationLayers) {
        const support = checkValidationLayerSupport(std.heap.c_allocator) catch false;
        if (!support) {
            return InitVulkanError.ValidationLayerRequestedButNotAvailable;
        }
    }

    const extensions = getRequiredExtensions(std.heap.c_allocator);
    defer std.heap.c_allocator.free(extensions);

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
        .enabledExtensionCount = @intCast(extensions.len),
        .ppEnabledExtensionNames = extensions.ptr,
        .enabledLayerCount = if (g_enableValidationLayers) @intCast(g_validationLayers.len) else 0,
        .ppEnabledLayerNames = if (g_enableValidationLayers) &g_validationLayers else null,
        .pNext = null,
        .flags = 0,
    };

    checkVkSuccess(c.vkCreateInstance(&instance_create_info, g_vulkan_context.allocator, &g_vulkan_context.instance)) catch {
        logger.err("vkCreateInstance failed.", .{});
        return InitVulkanError.CreateInstanceFailed;
    };

    logger.info("Created Vulkan instance.", .{});

    logger.info("Vulkan initialized.", .{});
}

pub fn vulkanShutdown(backend: *RendererBackend) void {
    _ = backend;

    logger.debug("Destroying Vulkan instance...", .{});
    c.vkDestroyInstance(g_vulkan_context.instance, g_vulkan_context.allocator);
}

pub fn vulkanOnResize(backend: *RendererBackend, width: i32, height: i32) void {
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

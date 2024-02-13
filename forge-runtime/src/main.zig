const forge = @import("forge");
const runtime = @import("runtime.zig");

pub fn main() anyerror!void {
    const logger = forge.logger.LoggerSpecification{
        .to_std = true,
        .to_file = true,
    };

    const app = forge.application.Application{
        .name = "Forge Runtime",
        .working_dir = ".",
        .on_init = runtime.onInit,
        .on_update = runtime.onUpdate,
        .render = runtime.render,
        .on_event = runtime.onEvent,
    };

    // _ = logger;
    try forge.logger.init(logger);
    defer forge.logger.shutdown();

    // _ = app;
    try forge.engine.init(app);
    defer forge.engine.shutdown();

    forge.engine.run() catch |err| {
        forge.logger.err("forge.engine runtime error: {s}", .{@errorName(err)});
    };
}

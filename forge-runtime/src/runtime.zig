const forge = @import("forge");
const math = forge.math;

pub fn onInit() void {
    var v1 = math.Vec3.init(1.0, 2.5, 1.0);
    const v2 = v1.add(math.Vec3{
        .data = [_]f32 {
            0.5, 1.5, -1.0,
        }
    });

    const v3 = v1.normalize();

    forge.logger.debug("v1: {s}", .{v1});
    forge.logger.debug("v1 + (0.5, 1.5): {s}", .{v2});
    forge.logger.debug("v1 normalized: {s}", .{v3});
}

pub fn onUpdate(delta_time: f64) void {
    // this is here so compiler does not complain about unused parameter
    // delete or uncomment when using deltaTime
    _ = delta_time;
}

pub fn onEvent(t: forge.events.EventType, payload: forge.events.EventPayload) void {
    if (t == forge.events.EventType.KeyPress) {
        forge.logger.trace("Pressed {d}", .{payload.key_code});

        // close when ESC pressed
        if (payload.key_code == 256) {
            forge.engine.close();
        }
    }
}

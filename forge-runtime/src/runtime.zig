const forge = @import("forge");

fn onKeyPressEvent(payload: forge.events.EventPayload) bool {
    forge.logger.trace("Key Code: {d}", .{payload.key_code});
    return false;
}

pub fn onInit() void {
    forge.events.registerEvent(forge.events.EventType.KeyPress, onKeyPressEvent);
}

pub fn onUpdate(delta_time: f64) void {
    // this is here so compiler does not complain about unused parameter
    // delete or uncomment when using deltaTime
    _ = delta_time;
}

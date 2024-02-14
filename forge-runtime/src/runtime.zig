const forge = @import("forge");
const math = forge.math;

pub fn onInit() void {}

pub fn onUpdate(delta_time: f64) void {
    // this is here so compiler does not complain about unused parameter
    // delete or uncomment when using deltaTime
    _ = delta_time;
}

pub fn render(delta_time: f64) void {
    _ = delta_time;
    if (forge.input.isKeyPressed(forge.input.KeyCode.W)) {
        forge.engine.getMainWindow().maximize();
    } else if (forge.input.isKeyPressed(forge.input.KeyCode.S)) {
        forge.engine.getMainWindow().restore();
    }
}

pub fn onEvent(t: forge.events.EventType, payload: forge.events.EventPayload) void {
    _ = t;
    _ = payload;
}

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

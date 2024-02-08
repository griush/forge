// Got a little help from:
// https://github.com/andrewrk/tetris/blob/master/src/math3d.zig
// TODO: Vectors and matrices data is f32, consider making f64 or some system to chose data types, even i32...

const std = @import("std");
const c = @import("../c.zig");

// Vec2
pub const Vec2 = struct {
    data: [2]f32,

    //* Helpers
    pub fn x(v: Vec2) f32 {
        return v.data[0];
    }

    pub fn y(v: Vec2) f32 {
        return v.data[1];
    }

    //* Constructors
    // '_in' because of function name shadowning
    pub fn init(x_in: f32, y_in: f32) Vec2 {
        return Vec2 {
            .data = [_]f32 { x_in, y_in, },
        };
    }

    //* Operations
    pub fn add(v: Vec2, other: Vec2) Vec2 {
        return Vec2 {
            .data = [_]f32 {
                v.data[0] + other.data[0],
                v.data[1] + other.data[1],
            },
        };
    }
    
    pub fn sub(v: Vec2, other: Vec2) Vec2 {
        return Vec2 {
            .data = [_]f32 {
                v.data[0] - other.data[0],
                v.data[1] - other.data[1],
            },
        };
    }
    
    pub fn length(v: Vec2) f32 {
        return c.sqrtf(v.dot(v));
    }

    pub fn normalize(v: Vec2) Vec2 {
        return v.scale(1.0 / c.sqrtf(v.dot(v)));
    }

    pub fn scale(v: Vec2, scalar: f32) Vec2 {
        return Vec2 {
            .data = [_]f32 {
                v.data[0] * scalar,
                v.data[1] * scalar,
            },
        };
    }

    pub fn dot(v: Vec2, other: Vec2) f32 {
        return v.data[0] * other.data[0] +
            v.data[1] * other.data[1];
    }

    //* Debug
    pub fn format(
        v: Vec2,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("({d}, {d})", .{
            v.data[0], v.data[1],
        });
    }
};

// Vec3
pub const Vec3 = struct {
    data: [3]f32,

    //* Helpers
    pub fn x(v: Vec3) f32 {
        return v.data[0];
    }

    pub fn y(v: Vec3) f32 {
        return v.data[1];
    }

    pub fn z(v: Vec3) f32 {
        return v.data[2];
    }

    //* Constructors
    // '_in' because of function name shadowning
    pub fn init(x_in: f32, y_in: f32, z_in: f32) Vec3 {
        return Vec3 {
            .data = [_]f32 { x_in, y_in, z_in, },
        };
    }

    //* Operations
    pub fn add(v: Vec3, other: Vec3) Vec3 {
        return Vec3 {
            .data = [_]f32 {
                v.data[0] + other.data[0],
                v.data[1] + other.data[1],
                v.data[2] + other.data[2],
            },
        };
    }
    
    pub fn sub(v: Vec3, other: Vec3) Vec3 {
        return Vec3 {
            .data = [_]f32 {
                v.data[0] - other.data[0],
                v.data[1] - other.data[1],
                v.data[2] - other.data[2],
            },
        };
    }
    
    pub fn length(v: Vec3) f32 {
        return c.sqrtf(v.dot(v));
    }

    pub fn normalize(v: Vec3) Vec3 {
        return v.scale(1.0 / c.sqrtf(v.dot(v)));
    }

    pub fn scale(v: Vec3, scalar: f32) Vec3 {
        return Vec3 {
            .data = [_]f32 {
                v.data[0] * scalar,
                v.data[1] * scalar,
                v.data[2] * scalar,
            },
        };
    }

    pub fn dot(v: Vec3, other: Vec3) f32 {
        return v.data[0] * other.data[0] +
            v.data[1] * other.data[1] +
            v.data[2] * other.data[2];
    }

    //* Debug
    pub fn format(
        v: Vec3,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("({d}, {d}, {d})", .{
            v.data[0], v.data[1], v.data[2],
        });
    }
};

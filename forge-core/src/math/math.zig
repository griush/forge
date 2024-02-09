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

    pub fn fromVec2(in: Vec2) Vec3 {
        return Vec3 {
            .data = [_]f32 { in.x(), in.y(), 0.0 },
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

pub const Mat4 = struct {
    data: [4][4]f32,

    pub const identity = Mat4 {
        .data = [_][4]f32 {
            [_]f32{ 1.0, 0.0, 0.0, 0.0 },
            [_]f32{ 0.0, 1.0, 0.0, 0.0 },
            [_]f32{ 0.0, 0.0, 1.0, 0.0 },
            [_]f32{ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    /// Matrix multiplication
    pub fn mult(m: Mat4, other: Mat4) Mat4 {
        return Mat4 {
            .data = [_][4]f32 {
                [_]f32{
                    m.data[0][0] * other.data[0][0] + m.data[0][1] * other.data[1][0] + m.data[0][2] * other.data[2][0] + m.data[0][3] * other.data[3][0],
                    m.data[0][0] * other.data[0][1] + m.data[0][1] * other.data[1][1] + m.data[0][2] * other.data[2][1] + m.data[0][3] * other.data[3][1],
                    m.data[0][0] * other.data[0][2] + m.data[0][1] * other.data[1][2] + m.data[0][2] * other.data[2][2] + m.data[0][3] * other.data[3][2],
                    m.data[0][0] * other.data[0][3] + m.data[0][1] * other.data[1][3] + m.data[0][2] * other.data[2][3] + m.data[0][3] * other.data[3][3],
                },
                [_]f32{
                    m.data[1][0] * other.data[0][0] + m.data[1][1] * other.data[1][0] + m.data[1][2] * other.data[2][0] + m.data[1][3] * other.data[3][0],
                    m.data[1][0] * other.data[0][1] + m.data[1][1] * other.data[1][1] + m.data[1][2] * other.data[2][1] + m.data[1][3] * other.data[3][1],
                    m.data[1][0] * other.data[0][2] + m.data[1][1] * other.data[1][2] + m.data[1][2] * other.data[2][2] + m.data[1][3] * other.data[3][2],
                    m.data[1][0] * other.data[0][3] + m.data[1][1] * other.data[1][3] + m.data[1][2] * other.data[2][3] + m.data[1][3] * other.data[3][3],
                },
                [_]f32{
                    m.data[2][0] * other.data[0][0] + m.data[2][1] * other.data[1][0] + m.data[2][2] * other.data[2][0] + m.data[2][3] * other.data[3][0],
                    m.data[2][0] * other.data[0][1] + m.data[2][1] * other.data[1][1] + m.data[2][2] * other.data[2][1] + m.data[2][3] * other.data[3][1],
                    m.data[2][0] * other.data[0][2] + m.data[2][1] * other.data[1][2] + m.data[2][2] * other.data[2][2] + m.data[2][3] * other.data[3][2],
                    m.data[2][0] * other.data[0][3] + m.data[2][1] * other.data[1][3] + m.data[2][2] * other.data[2][3] + m.data[2][3] * other.data[3][3],
                },
                [_]f32{
                    m.data[3][0] * other.data[0][0] + m.data[3][1] * other.data[1][0] + m.data[3][2] * other.data[2][0] + m.data[3][3] * other.data[3][0],
                    m.data[3][0] * other.data[0][1] + m.data[3][1] * other.data[1][1] + m.data[3][2] * other.data[2][1] + m.data[3][3] * other.data[3][1],
                    m.data[3][0] * other.data[0][2] + m.data[3][1] * other.data[1][2] + m.data[3][2] * other.data[2][2] + m.data[3][3] * other.data[3][2],
                    m.data[3][0] * other.data[0][3] + m.data[3][1] * other.data[1][3] + m.data[3][2] * other.data[2][3] + m.data[3][3] * other.data[3][3],
                },
            },
        };
    }

    /// Builds a translation 4 * 4 matrix created from a vector of 3 components.
    /// Input matrix multiplied by this translation matrix.
    pub fn translate(m: Mat4, x: f32, y: f32, z: f32) Mat4 {
        return Mat4 {
            .data = [_][4]f32 {
                [_]f32{ m.data[0][0], m.data[0][1], m.data[0][2], m.data[0][3] + m.data[0][0] * x + m.data[0][1] * y + m.data[0][2] * z },
                [_]f32{ m.data[1][0], m.data[1][1], m.data[1][2], m.data[1][3] + m.data[1][0] * x + m.data[1][1] * y + m.data[1][2] * z },
                [_]f32{ m.data[2][0], m.data[2][1], m.data[2][2], m.data[2][3] + m.data[2][0] * x + m.data[2][1] * y + m.data[2][2] * z },
                [_]f32{ m.data[3][0], m.data[3][1], m.data[3][2], m.data[3][3] },
            },
        };
    }

    pub fn translateByVec(m: Mat4, v: Vec3) Mat4 {
        return m.translate(v.data[0], v.data[1], v.data[2]);
    }

    /// Builds a rotation 4 * 4 matrix created from an axis vector and an angle.
    /// Input matrix multiplied by this rotation matrix.
    /// angle: Rotation angle expressed in radians.
    /// axis: Rotation axis, recommended to be normalized.
    pub fn rotate(m: Mat4, angle: f32, axis_unnormalized: Vec3) Mat4 {
        const cos = c.cosf(angle);
        const s = c.sinf(angle);
        const axis = axis_unnormalized.normalize();
        const temp = axis.scale(1.0 - cos);

        const rot = Mat4 {
            .data = [_][4]f32{
                [_]f32{ cos + temp.data[0] * axis.data[0], 0.0 + temp.data[1] * axis.data[0] - s * axis.data[2], 0.0 + temp.data[2] * axis.data[0] + s * axis.data[1], 0.0 },
                [_]f32{ 0.0 + temp.data[0] * axis.data[1] + s * axis.data[2], cos + temp.data[1] * axis.data[1], 0.0 + temp.data[2] * axis.data[1] - s * axis.data[0], 0.0 },
                [_]f32{ 0.0 + temp.data[0] * axis.data[2] - s * axis.data[1], 0.0 + temp.data[1] * axis.data[2] + s * axis.data[0], cos + temp.data[2] * axis.data[2], 0.0 },
                [_]f32{ 0.0, 0.0, 0.0, 0.0 },
            },
        };

        return Mat4 {
            .data = [_][4]f32{
                [_]f32{
                    m.data[0][0] * rot.data[0][0] + m.data[0][1] * rot.data[1][0] + m.data[0][2] * rot.data[2][0],
                    m.data[0][0] * rot.data[0][1] + m.data[0][1] * rot.data[1][1] + m.data[0][2] * rot.data[2][1],
                    m.data[0][0] * rot.data[0][2] + m.data[0][1] * rot.data[1][2] + m.data[0][2] * rot.data[2][2],
                    m.data[0][3],
                },
                [_]f32{
                    m.data[1][0] * rot.data[0][0] + m.data[1][1] * rot.data[1][0] + m.data[1][2] * rot.data[2][0],
                    m.data[1][0] * rot.data[0][1] + m.data[1][1] * rot.data[1][1] + m.data[1][2] * rot.data[2][1],
                    m.data[1][0] * rot.data[0][2] + m.data[1][1] * rot.data[1][2] + m.data[1][2] * rot.data[2][2],
                    m.data[1][3],
                },
                [_]f32{
                    m.data[2][0] * rot.data[0][0] + m.data[2][1] * rot.data[1][0] + m.data[2][2] * rot.data[2][0],
                    m.data[2][0] * rot.data[0][1] + m.data[2][1] * rot.data[1][1] + m.data[2][2] * rot.data[2][1],
                    m.data[2][0] * rot.data[0][2] + m.data[2][1] * rot.data[1][2] + m.data[2][2] * rot.data[2][2],
                    m.data[2][3],
                },
                [_]f32{
                    m.data[3][0] * rot.data[0][0] + m.data[3][1] * rot.data[1][0] + m.data[3][2] * rot.data[2][0],
                    m.data[3][0] * rot.data[0][1] + m.data[3][1] * rot.data[1][1] + m.data[3][2] * rot.data[2][1],
                    m.data[3][0] * rot.data[0][2] + m.data[3][1] * rot.data[1][2] + m.data[3][2] * rot.data[2][2],
                    m.data[3][3],
                },
            },
        };
    }

    /// Builds a scale 4 * 4 matrix created from 3 scalars.
    /// Input matrix multiplied by this scale matrix.
    pub fn scale(m: Mat4, x: f32, y: f32, z: f32) Mat4 {
        return Mat4 {
            .data = [_][4]f32{
                [_]f32{ m.data[0][0] * x, m.data[0][1] * y, m.data[0][2] * z, m.data[0][3] },
                [_]f32{ m.data[1][0] * x, m.data[1][1] * y, m.data[1][2] * z, m.data[1][3] },
                [_]f32{ m.data[2][0] * x, m.data[2][1] * y, m.data[2][2] * z, m.data[2][3] },
                [_]f32{ m.data[3][0] * x, m.data[3][1] * y, m.data[3][2] * z, m.data[3][3] },
            },
        };
    }
    
    pub fn scaleByVec(m: Mat4, v: Vec3) Mat4 {
        return m.scale(v.data[0], v.data[1], v.data[2]);
    }

    pub fn transpose(m: Mat4) Mat4 {
        return Mat4 {
            .data = [_][4]f32{
                [_]f32{ m.data[0][0], m.data[1][0], m.data[2][0], m.data[3][0] },
                [_]f32{ m.data[0][1], m.data[1][1], m.data[2][1], m.data[3][1] },
                [_]f32{ m.data[0][2], m.data[1][2], m.data[2][2], m.data[3][2] },
                [_]f32{ m.data[0][3], m.data[1][3], m.data[2][3], m.data[3][3] },
            },
        };
    }

    /// Creates a matrix for an orthographic parallel viewing volume.
    pub fn ortho(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) Mat4 {
        var m = identity;
        m.data[0][0] = 2.0 / (right - left);
        m.data[1][1] = 2.0 / (top - bottom);
        m.data[2][2] = -2.0 / (far - near);
        m.data[0][3] = -(right + left) / (right - left);
        m.data[1][3] = -(top + bottom) / (top - bottom);
        m.data[2][3] = -(far + near) / (far - near);
        return m;
    }
};

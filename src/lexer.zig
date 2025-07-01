const std = @import("std");

pub const Token = union(enum) {
    num: f64,
    sign: SignType,

    pub fn isNum(token: Token) bool {
        const num_token = Token{ .num = 1 };
        return std.meta.activeTag(token) == std.meta.activeTag(num_token);
    }
    pub fn isSign(token: Token) bool {
        const sign_token = Token{ .sign = SignType.PLUS };
        return std.meta.activeTag(token) == std.meta.activeTag(sign_token);
    }
};

const SignType = enum {
    PLUS,
    MINUS,
    MUL,
    DIV,
};

pub fn run(expr: []u8, gpa: std.mem.Allocator) ![]Token {
    var seq = std.mem.splitSequence(u8, expr, " ");
    var tokens = std.ArrayList(Token).init(gpa);
    while (seq.next()) |chunk| {
        var index: usize = 0;
        if (chunk.len > 0 and (std.ascii.isDigit(chunk[0]) or (chunk[0] == '-' and chunk.len > index + 1))) {
            var number_buf = std.ArrayList(u8).init(gpa);
            defer number_buf.deinit();

            try number_buf.append(chunk[0]);
            index += 1;
            var found_dot = false;
            while (index < chunk.len and !(chunk[index] == ' ')) {
                if (std.ascii.isDigit(chunk[index])) {
                    try number_buf.append(chunk[index]);
                    index += 1;
                } else if (chunk[index] == '.') {
                    if (found_dot) {
                        std.debug.print("Found multiple dots inside number: {s}\n", .{chunk});
                        return error.TwoDotsInNumber;
                    }
                    found_dot = true;
                    try number_buf.append(chunk[index]);
                    index += 1;
                } else {
                    std.debug.print("Unrecognized char: {c} inside number body.\n", .{chunk[index]});
                    return error.UnrecognizedChar;
                }
            }
            const num_token = Token{ .num = try std.fmt.parseFloat(f64, std.mem.trim(u8, try number_buf.toOwnedSlice(), " \n\t")) };
            try tokens.append(num_token);
        }
        if (chunk.len > 0 and (chunk[0] == '+' or chunk[0] == '-' or chunk[0] == '*' or chunk[0] == '/')) {
            const token = try create_sign_token(chunk[0]);
            try tokens.append(token);
        }
    }
    return try tokens.toOwnedSlice();
}
fn create_sign_token(sign: u8) !Token {
    var token: Token = undefined;
    switch (sign) {
        '+' => {
            token = Token{ .sign = SignType.PLUS };
        },
        '-' => {
            token = Token{ .sign = SignType.MINUS };
        },
        '*' => {
            token = Token{ .sign = SignType.MUL };
        },
        '/' => {
            token = Token{ .sign = SignType.DIV };
        },
        else => {
            return error.UnrecognizedSign;
        },
    }
    return token;
}

const std = @import("std");

pub fn input_expression(buf: []u8) ![]u8 {
    const stdin = std.io.getStdIn().reader();

    const result = try stdin.readUntilDelimiterOrEof(buf, '\n');

    if (result == null) {
        return error.NoData;
    }

    const slice = result.?;
    return slice;
}
pub fn clear_screen() !void {
    const out = std.io.getStdOut().writer();
    try out.print("\x1B[2J\x1B[H", .{});
}

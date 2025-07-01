const std = @import("std");
const interface = @import("interface.zig");
const lexer = @import("lexer.zig");
const validator = @import("validator.zig");

pub fn main() !void {
    interface.clear_screen() catch {
        std.debug.print("Could not clear screen. Unexpected I/O Error", .{});
    };

    var buf: [128]u8 = undefined;
    const input = try interface.input_expression(&buf);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const tokens = try lexer.run(input, allocator);
    try validator.validate(tokens);
}

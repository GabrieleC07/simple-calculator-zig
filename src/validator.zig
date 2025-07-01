const std = @import("std");
const lexer = @import("lexer.zig");

pub fn validate(tokens: []lexer.Token) !void {
    const num_token = lexer.Token {.num = 1};
    if (!(tokens[0].isNum())) {
        std.debug.print("Proper token: {}, example token: {}", .{std.meta.activeTag(tokens[0]), std.meta.activeTag(num_token)});
        return error.FirstTokenCannotBeSign;

    }

    var index: usize = 1; // We already ensured token 0 is a Num;
    while (index < tokens.len) {
        



        index += 1;
    } 
   
     

    return;
}

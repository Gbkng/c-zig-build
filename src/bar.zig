const std = @import("std");

const foo = @cImport({
    @cInclude("foo.c");
});

pub fn main() !void {
    foo.foo();
}

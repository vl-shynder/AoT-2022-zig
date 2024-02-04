const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("inputs/day1.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var reader = buf_reader.reader();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var elphes_inventory = std.ArrayList(u32).init(allocator);
    defer elphes_inventory.deinit();

    var buf: [1024]u8 = undefined;

    var cur_count: u32 = 0;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len > 0) {
            const result: u32 = try std.fmt.parseInt(u32, line, 10);
            cur_count += result;
        } else {
            try elphes_inventory.append(cur_count);
            cur_count = 0;
        }
    }

    std.sort.insertion(u32, elphes_inventory.items, {}, std.sort.desc(u32));

    var top_3_sum: u32 = 0;
    std.debug.print("Top results: \n", .{});
    for (elphes_inventory.items[0..3], 0..) |item, i| {
        std.debug.print("{} = {}\n", .{ i, item });
        top_3_sum += item;
    }
    std.debug.print("Combined result: {}\n", .{top_3_sum});
}

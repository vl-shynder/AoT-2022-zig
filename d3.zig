const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("inputs/day3.txt", .{});
    defer file.close();

    var bfr = std.io.bufferedReader(file.reader());
    var reader = bfr.reader();

    var buf: [1024]u8 = undefined;
    var total_properties: u32 = 0;
    total_properties += 1;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // all lines are divisible by 2 without carry
        const p1 = line[0..(line.len / 2)];
        const p2 = line[(line.len / 2)..];

        var same_letters = [_]u8{0} ** 25;
        var used_i: [100]u32 = undefined;
        var ai: u32 = 0;
        outer: for (p1, 0..) |l1, oi| {
            for (p2, 0..) |l2, i| {
                const in_array = isInArray(u32, &used_i, @as(u32, @intCast(i)));
                if (l1 == l2 and !in_array) {
                    used_i[ai] = @as(u32, @intCast(i));
                    ai += 1;
                    if (!isInArray(u8, &same_letters, l1)) {
                        same_letters[oi] = l1;
                        continue :outer;
                    }
                }
            }
        }
        const total_matches = getTotalMatches(&same_letters);
        const total_score = getTotalScore(&same_letters);
        total_properties += total_score;
        std.debug.print("Same latter in lines {s} ---- {s}: {c}, matches = {d}, score = {d}\n", .{ p1, p2, same_letters, total_matches, total_score });
    }

    std.debug.print("Total properties = {}\n", .{total_properties});
}

fn isInArray(comptime value_type: type, arr: []value_type, el: value_type) bool {
    return for (arr) |item| {
        if (item == el) {
            break true;
        }
    } else false;
}

fn getTotalMatches(arr: []u8) u32 {
    var res: u32 = 0;
    for (arr) |item| {
        if (item != 0) {
            res += 1;
        }
    }
    return res;
}

fn getTotalScore(arr: []u8) u32 {
    var res: u32 = 0;
    for (arr) |item| {
        if (item != 0) {
            res += switch (item) {
                'a'...'z' => item - 'a' + 1,
                'A'...'Z' => item - 'A' + 27,
                else => unreachable,
            };
        }
    }
    return res;
}

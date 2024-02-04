const std = @import("std");

const Move = enum(u8) { rock = 1, paper = 2, scissor = 3 };
const Outcome = enum(u8) { lose = 0, draw = 3, win = 6 };

pub fn main() !void {
    var file = try std.fs.cwd().openFile("inputs/day2.txt", .{});
    defer file.close();

    var rd = std.io.bufferedReader(file.reader());
    var reader = rd.reader();

    var buf: [1024]u8 = undefined;
    var score: u32 = 0;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // day 2 part 1 solution
        // const opponent_move = getMove(line[0]);
        // const my_move = getMove(line[2]);
        // const points = calcPoints(my_move, opponent_move);
        // score += points;
        // std.debug.print("move: my = {}, op = {}; points = {}\n", .{ my_move, opponent_move, points });

        // part 2 solution
        const op_move = getMove(line[0]);
        const outcome = getOutcome(line[2]);
        const points = calcPointsFromResult(op_move, outcome);
        score += points;

        std.debug.print("op move = {}, outcome = {}, points = {}\n", .{ op_move, outcome, points });
    }
    std.debug.print("Total score = {}", .{score});
}

fn getMove(move: u8) Move {
    return switch (move) {
        'A', 'X' => Move.rock,
        'B', 'Y' => Move.paper,
        'C', 'Z' => Move.scissor,
        else => unreachable,
    };
}
fn calcPoints(my_move: Move, op_move: Move) u32 {
    var res: u32 = 0;
    if (@intFromEnum(my_move) == @intFromEnum(op_move)) {
        res = 3 + @intFromEnum(my_move);
    } else if (my_move == Move.paper) {
        if (op_move == Move.rock) {
            res = 6 + @intFromEnum(my_move);
        } else {
            res = 0 + @intFromEnum(my_move);
        }
    } else if (my_move == Move.rock) {
        if (op_move == Move.paper) {
            res = 0 + @intFromEnum(my_move);
        } else {
            res = 6 + @intFromEnum(my_move);
        }
    } else if (my_move == Move.scissor) {
        if (op_move == Move.paper) {
            res = 6 + @intFromEnum(my_move);
        } else {
            res = 0 + @intFromEnum(my_move);
        }
    }

    return res;
}
fn getOutcome(val: u8) Outcome {
    return switch (val) {
        'X' => Outcome.lose,
        'Y' => Outcome.draw,
        'Z' => Outcome.win,
        else => unreachable,
    };
}
fn calcPointsFromResult(op_move: Move, outcome: Outcome) u32 {
    var res: u32 = 0;
    if (outcome == Outcome.draw) {
        res = @intFromEnum(op_move) + @intFromEnum(outcome);
    } else if (outcome == Outcome.lose) {
        const my_move = getLoosingMove(op_move);
        res = @intFromEnum(my_move) + @intFromEnum(outcome);
    } else {
        const my_move = getWinningMove(op_move);
        res = @intFromEnum(my_move) + @intFromEnum(outcome);
    }
    return res;
}

fn getLoosingMove(move: Move) Move {
    if (move == Move.paper) {
        return Move.rock;
    }
    if (move == Move.rock) {
        return Move.scissor;
    }
    return Move.paper;
}
fn getWinningMove(move: Move) Move {
    if (move == Move.paper) {
        return Move.scissor;
    }
    if (move == Move.rock) {
        return Move.paper;
    }
    return Move.rock;
}

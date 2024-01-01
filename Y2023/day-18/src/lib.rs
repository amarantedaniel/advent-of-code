#[derive(Clone, Copy)]
enum Direction {
    Up,
    Down,
    Right,
    Left,
}

#[derive(Clone, Copy)]
struct Position {
    row: i64,
    column: i64,
}

struct Command {
    direction: Direction,
    count: i64,
}

pub fn solve_part1(input: &str) -> String {
    let commands = parse(input);
    return solve(&commands).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let commands = parse_hex(input);
    return solve(&commands).to_string();
}

fn solve(commands: &Vec<Command>) -> i64 {
    let vertices = get_polygon_vertices(&commands);
    let border_length: i64 = commands.iter().map(|command| command.count).sum();
    return (apply_shoelace_formula(&vertices) - border_length / 2 + 1) + border_length;
}

fn get_polygon_vertices(commands: &Vec<Command>) -> Vec<Position> {
    let mut points: Vec<Position> = Vec::new();
    let mut current_point = Position { row: 0, column: 0 };
    for command in commands {
        current_point = move_point(current_point, command.direction, command.count);
        points.push(current_point);
    }
    return points;
}

fn apply_shoelace_formula(vertices: &Vec<Position>) -> i64 {
    let mut area = 0;
    let mut j = vertices.len() - 1;
    for i in 0..vertices.len() {
        area += (vertices[j].row + vertices[i].row) * (vertices[j].column - vertices[i].column);
        j = i;
    }
    return (area / 2).abs();
}

fn move_point(point: Position, direction: Direction, count: i64) -> Position {
    return match direction {
        Direction::Up => Position {
            row: point.row - count,
            column: point.column,
        },
        Direction::Down => Position {
            row: point.row + count,
            column: point.column,
        },
        Direction::Right => Position {
            row: point.row,
            column: point.column + count,
        },
        Direction::Left => Position {
            row: point.row,
            column: point.column - count,
        },
    };
}

fn parse(input: &str) -> Vec<Command> {
    return input.lines().map(parse_command).collect();
}

fn parse_command(input: &str) -> Command {
    let parts = input.split(" ").collect::<Vec<_>>();
    return Command {
        direction: match parts[0] {
            "R" => Direction::Right,
            "U" => Direction::Up,
            "L" => Direction::Left,
            "D" => Direction::Down,
            _ => panic!(),
        },
        count: parts[1].parse().unwrap(),
    };
}

fn parse_hex(input: &str) -> Vec<Command> {
    return input.lines().map(parse_command_hex).collect();
}

fn parse_command_hex(input: &str) -> Command {
    let hex_string = input.split(" ").last().unwrap();
    let count_hex = &hex_string[2..hex_string.len() - 2];
    let direction_hex = &hex_string[hex_string.len() - 2..hex_string.len() - 1];
    return Command {
        direction: match direction_hex {
            "0" => Direction::Right,
            "1" => Direction::Down,
            "2" => Direction::Left,
            "3" => Direction::Up,
            _ => panic!(),
        },
        count: i64::from_str_radix(count_hex, 16).unwrap(),
    };
}

use std::collections::{HashSet, VecDeque};

#[derive(Debug, Clone, Copy)]
enum Direction {
    Up,
    Down,
    Right,
    Left,
}

#[derive(Debug, Hash, Eq, PartialEq, Clone, Copy)]
struct Position {
    row: i32,
    column: i32,
}

enum Square {
    Trench,
    GroundLevel,
}

#[derive(Debug)]
struct Command {
    direction: Direction,
    count: u64,
}

pub fn solve_part1(input: &str) -> String {
    let commands = parse(input);
    let borders = generate_borders(&commands);
    // plot(&borders);
    let filled = fill(&borders);
    // plot(&filled);
    return filled.len().to_string();
}

fn generate_borders(commands: &Vec<Command>) -> HashSet<Position> {
    let mut points: HashSet<Position> = HashSet::new();
    let mut current_point = Position { row: 0, column: 0 };
    points.insert(current_point);
    for command in commands {
        for _ in 0..command.count {
            current_point = move_point(current_point, command.direction);
            points.insert(current_point);
        }
    }
    return points;
}

fn fill(borders: &HashSet<Position>) -> HashSet<Position> {
    let mut points = borders.clone();
    let mut queue = VecDeque::new();
    // TODO: remove arbitrary numbers
    let start_point = Position {
        row: -100,
        column: 100,
    };
    queue.push_back(start_point);

    while let Some(point) = queue.pop_front() {
        points.insert(point);
        for row in (point.row - 1)..=(point.row + 1) {
            for column in (point.column - 1)..=(point.column + 1) {
                if !points.contains(&Position { row, column }) {
                    queue.push_back(Position { row, column });
                    points.insert(Position { row, column });
                }
            }
        }
    }

    return points;
}

fn move_point(point: Position, direction: Direction) -> Position {
    return match direction {
        Direction::Up => Position {
            row: point.row - 1,
            column: point.column,
        },
        Direction::Down => Position {
            row: point.row + 1,
            column: point.column,
        },
        Direction::Right => Position {
            row: point.row,
            column: point.column + 1,
        },
        Direction::Left => Position {
            row: point.row,
            column: point.column - 1,
        },
    };
}

fn plot(points: &HashSet<Position>) {
    for row in min_row(&points)..=max_row(&points) {
        for column in min_column(&points)..=max_column(&points) {
            if points.contains(&Position { row, column }) {
                print!("#")
            } else {
                print!(".")
            }
        }
        println!("");
    }
    println!("");
}

fn min_row(points: &HashSet<Position>) -> i32 {
    return points.iter().map(|position| position.row).min().unwrap();
}

fn min_column(points: &HashSet<Position>) -> i32 {
    return points.iter().map(|position| position.column).min().unwrap();
}

fn max_row(points: &HashSet<Position>) -> i32 {
    return points.iter().map(|position| position.row).max().unwrap();
}

fn max_column(points: &HashSet<Position>) -> i32 {
    return points.iter().map(|position| position.column).max().unwrap();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
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

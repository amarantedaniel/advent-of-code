use core::fmt;
use std::collections::HashMap;

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct Point {
    i: usize,
    j: usize,
}

#[derive(Debug, PartialEq, Eq)]
enum Square {
    Start,
    Horizontal,
    Vertical,
    TopRightBend,
    BottomRightBend,
    TopLeftBend,
    BottomLeftBend,
    Empty,
}

impl Square {
    fn has_opening_on_bottom(&self) -> bool {
        return [
            Square::Vertical,
            Square::TopLeftBend,
            Square::TopRightBend,
            Square::Start,
        ]
        .contains(self);
    }

    fn has_opening_on_top(&self) -> bool {
        return [
            Square::Vertical,
            Square::BottomLeftBend,
            Square::BottomRightBend,
            Square::Start,
        ]
        .contains(self);
    }

    fn has_opening_on_left(&self) -> bool {
        return [
            Square::Horizontal,
            Square::BottomRightBend,
            Square::TopRightBend,
            Square::Start,
        ]
        .contains(self);
    }

    fn has_opening_on_right(&self) -> bool {
        return [
            Square::Horizontal,
            Square::BottomLeftBend,
            Square::TopLeftBend,
            Square::Start,
        ]
        .contains(self);
    }
}

impl fmt::Display for Square {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Square::Start => return write!(f, "S"),
            Square::Horizontal => return write!(f, "━"),
            Square::Vertical => return write!(f, "┃"),
            Square::TopRightBend => return write!(f, "┓"),
            Square::BottomRightBend => return write!(f, "┛"),
            Square::TopLeftBend => return write!(f, "┏"),
            Square::BottomLeftBend => return write!(f, "┗"),
            Square::Empty => return write!(f, " "),
        }
    }
}

fn print(pipes: &Vec<Vec<Square>>, current: &Point) {
    for (i, line) in pipes.iter().enumerate() {
        for (j, square) in line.iter().enumerate() {
            if current.i == i && current.j == j {
                print!("{}", "X");
            } else {
                print!("{}", square);
            }
        }
        println!("");
    }
}

fn print_counts(pipes: &Vec<Vec<Square>>, map: &HashMap<Point, u64>) {
    for (i, line) in pipes.iter().enumerate() {
        for (j, square) in line.iter().enumerate() {
            if let Some(count) = map.get(&Point { i: i, j: j }) {
                print!("{}", count);
            } else {
                print!("{}", square);
            }
        }
        println!("");
    }
}

pub fn solve_part1(input: &str) -> String {
    let pipes = parse(input);
    let mut distances: HashMap<Point, u64> = HashMap::new();
    let start_point = find_start_point(&pipes);
    let exits = find_exits(&start_point, &pipes);
    for exit in exits {
        let mut step_counter: u64 = 1;
        let mut previous = start_point;
        let mut current = exit;
        while current != start_point {
            let count = *distances.get(&current).unwrap_or(&u64::MAX);
            if step_counter < count {
                distances.insert(current, step_counter);
            }
            let next = walk(&previous, &current, &pipes);
            previous = current;
            current = next;
            step_counter += 1;
        }
    }
    return distances.values().max().unwrap().to_string();
}

fn walk(previous: &Point, current: &Point, pipes: &Vec<Vec<Square>>) -> Point {
    let exits = find_exits(current, pipes);
    for exit in &exits {
        if exit != previous {
            return exit.clone();
        }
    }
    panic!("")
}

fn find_start_point(pipes: &Vec<Vec<Square>>) -> Point {
    for i in 0..pipes.len() {
        for j in 0..pipes[i].len() {
            match pipes[i][j] {
                Square::Start => return Point { i, j },
                _ => continue,
            }
        }
    }
    panic!("")
}

fn find_exits(point: &Point, pipes: &Vec<Vec<Square>>) -> Vec<Point> {
    let mut result: Vec<Point> = Vec::new();
    let current = &pipes[point.i][point.j];
    if point.i > 0 {
        let top = &pipes[point.i - 1][point.j];
        let exit = Point {
            i: point.i - 1,
            j: point.j,
        };
        if top.has_opening_on_bottom() && current.has_opening_on_top() {
            result.push(exit)
        }
    }
    if point.i < pipes.len() - 1 {
        let bottom = &pipes[point.i + 1][point.j];
        let exit = Point {
            i: point.i + 1,
            j: point.j,
        };
        if bottom.has_opening_on_top() && current.has_opening_on_bottom() {
            result.push(exit)
        }
    }
    if point.j > 0 {
        let left = &pipes[point.i][point.j - 1];
        let exit = Point {
            i: point.i,
            j: point.j - 1,
        };
        if left.has_opening_on_right() && current.has_opening_on_left() {
            result.push(exit)
        }
    }
    if point.j < pipes[point.i].len() - 1 {
        let right = &pipes[point.i][point.j + 1];
        let exit = Point {
            i: point.i,
            j: point.j + 1,
        };
        if right.has_opening_on_left() && current.has_opening_on_right() {
            result.push(exit)
        }
    }
    return result;
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<Vec<Square>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> Vec<Square> {
    return line.chars().map(map_char).collect();
}

fn map_char(character: char) -> Square {
    match character {
        'S' => Square::Start,
        '|' => Square::Vertical,
        '-' => Square::Horizontal,
        'F' => Square::TopLeftBend,
        '7' => Square::TopRightBend,
        'L' => Square::BottomLeftBend,
        'J' => Square::BottomRightBend,
        '.' => Square::Empty,
        _ => panic!(""),
    }
}

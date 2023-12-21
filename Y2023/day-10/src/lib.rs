use std::cmp;
use std::collections::{HashMap, HashSet, VecDeque};

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct Point {
    i: usize,
    j: usize,
}

#[derive(Debug, PartialEq, Eq)]
enum ExpandedSquare {
    Pipe,
    Empty,
    Flooded
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
    let pipes = parse(input);
    let path = find_path(&pipes);
    let mut expanded = expand(&pipes, &path);
    flood(&mut expanded);
    return count_enclosed(&expanded).to_string();
}

fn find_path(pipes: &Vec<Vec<Square>>) -> HashSet<Point> {
    let start_point = find_start_point(&pipes);
    let exit = *find_exits(&start_point, &pipes).first().unwrap();
    let mut points: HashSet<Point> = HashSet::new();
    points.insert(start_point);
    let mut previous = start_point;
    let mut current = exit;
    while current != start_point {
        points.insert(current);
        let next = walk(&previous, &current, &pipes);
        previous = current;
        current = next;
    }
    return points;
}

fn expand(pipes: &Vec<Vec<Square>>, path: &HashSet<Point>) -> Vec<Vec<ExpandedSquare>> {
    let mut result: Vec<Vec<ExpandedSquare>> = Vec::new();
    let mut current_row: Vec<ExpandedSquare> = Vec::new();
    let mut i = 0;
    let mut j = 0;
    let mut ii = 0;
    let mut jj = 0;
    while i < pipes.len() {
        while j < pipes[i].len() {
            if path.contains(&Point { i, j }) {
                current_row.push(render_expanded_pipe(Point { i, j }, ii, jj, &pipes));
            } else {
                current_row.push(ExpandedSquare::Empty);
            }
            jj += 1;
            if jj == 3 {
                jj = 0;
                j += 1;
            }
        }
        result.push(current_row);
        current_row = Vec::new();
        j = 0;
        ii += 1;
        if ii == 3 {
            ii = 0;
            i += 1;
        }
    }
    return result;
}

fn flood(expanded: &mut Vec<Vec<ExpandedSquare>>) {
    let start_point = Point {i: 0, j: 0};
    let mut queue: VecDeque<Point> = VecDeque::new();
    queue.push_back(start_point);
    while !queue.is_empty() {
        let point = queue.pop_front().unwrap();
        expanded[point.i][point.j] = ExpandedSquare::Flooded;
        for i in point.i.saturating_sub(1)..cmp::min(point.i + 2, expanded.len()) {
            for j in point.j.saturating_sub(1)..cmp::min(point.j + 2, expanded[point.i].len()) {
                if &expanded[i][j] == &ExpandedSquare::Empty && !queue.contains(&Point { i, j }) {
                    queue.push_back(Point { i, j })
                }
            }
        }
    }
}

fn count_enclosed(expanded: &Vec<Vec<ExpandedSquare>>) -> u64 {
    let mut count = 0;
    for i in (0..expanded.len()).step_by(3) {
        for j in (0..expanded[i].len()).step_by(3) {
            let mut is_enclosed = true;
            for ii in 0..3 {
                for jj in 0..3 {
                    if expanded[i + ii][j + jj] != ExpandedSquare::Empty {
                        is_enclosed = false
                    }
                }
            }
            if is_enclosed {
                count += 1;
            }
        }
    }
    return count;
}

fn render_expanded_pipe(point: Point, di: usize, dj: usize, pipes: &Vec<Vec<Square>>) -> ExpandedSquare {
    if di == 1 && dj == 1 {
        return ExpandedSquare::Pipe;
    }
    let exits = find_exits(&point, pipes);
    let new_i = (point.i + di).checked_sub(1);
    let new_j = (point.j + dj).checked_sub(1);
    match (new_i, new_j) {
        (Some(i), Some(j)) if exits.contains(&Point { i, j }) => ExpandedSquare::Pipe,
        (_, _) => return ExpandedSquare::Empty,
    }
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

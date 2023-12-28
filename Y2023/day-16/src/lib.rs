use std::{
    cmp,
    collections::{HashSet, VecDeque},
};

enum Square {
    Empty,
    Vertical,
    Horizontal,
    Downward,
    Upward,
}

#[derive(Clone, Copy, Eq, PartialEq, Hash)]
enum Direction {
    North,
    South,
    West,
    East,
}

#[derive(Clone, Copy, Eq, PartialEq, Hash)]
struct Position {
    row: usize,
    column: usize,
}

#[derive(Clone, Copy, Eq, PartialEq, Hash)]
struct Beam {
    direction: Direction,
    position: Position,
}

pub fn solve_part1(input: &str) -> String {
    let map = parse(input);
    let initial_beam = Beam {
        direction: Direction::East,
        position: Position { row: 0, column: 0 },
    };
    return solve(&map, initial_beam).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let map = parse(input);
    let mut result = 0;
    for column in 0..map[0].len() {
        let top_beam = Beam {
            direction: Direction::South,
            position: Position { row: 0, column },
        };
        let top_count = solve(&map, top_beam);
        result = cmp::max(result, top_count);
        let bottom_beam = Beam {
            direction: Direction::North,
            position: Position {
                row: map.len() - 1,
                column,
            },
        };
        let bottom_count = solve(&map, bottom_beam);
        result = cmp::max(result, bottom_count);
    }
    for row in 0..map.len() {
        let left_beam = Beam {
            direction: Direction::East,
            position: Position { row, column: 0 },
        };
        let left_count = solve(&map, left_beam);
        result = cmp::max(result, left_count);
        let right_beam = Beam {
            direction: Direction::West,
            position: Position {
                row,
                column: map[row].len() - 1,
            },
        };
        let right_count = solve(&map, right_beam);
        result = cmp::max(result, right_count);
    }

    return result.to_string();
}

fn solve(map: &Vec<Vec<Square>>, initial_beam: Beam) -> usize {
    let mut queue: VecDeque<Beam> = VecDeque::new();
    let mut visited_beams: HashSet<Beam> = HashSet::new();
    let mut positions: HashSet<Position> = HashSet::new();
    for beam in get_initial_beams(&map, initial_beam) {
        queue.push_back(beam);
    }
    while !queue.is_empty() {
        let beam = queue.pop_front().unwrap();
        if visited_beams.contains(&beam) {
            continue;
        }
        visited_beams.insert(beam);
        positions.insert(beam.position);
        for beam in navigate(&map, beam) {
            queue.push_back(beam);
        }
    }

    return positions.len();
}

fn get_initial_beams(map: &Vec<Vec<Square>>, beam: Beam) -> Vec<Beam> {
    return get_next_directions(&map, &beam, &beam.position)
        .iter()
        .map(|direction| Beam {
            direction: *direction,
            position: beam.position,
        })
        .collect();
}

fn navigate(map: &Vec<Vec<Square>>, beam: Beam) -> Vec<Beam> {
    if let Some(next_position) = get_next_position(map, &beam) {
        let next_directions = get_next_directions(map, &beam, &next_position);
        return next_directions
            .iter()
            .map(|direction| Beam {
                direction: *direction,
                position: next_position,
            })
            .collect();
    }
    return Vec::new();
}

fn get_next_directions(
    map: &Vec<Vec<Square>>,
    beam: &Beam,
    next_position: &Position,
) -> Vec<Direction> {
    let next_square = &map[next_position.row][next_position.column];
    match (beam.direction, next_square) {
        (_, Square::Empty)
        | (Direction::North, Square::Vertical)
        | (Direction::South, Square::Vertical)
        | (Direction::East, Square::Horizontal)
        | (Direction::West, Square::Horizontal) => return vec![beam.direction],
        (Direction::East, Square::Vertical) | (Direction::West, Square::Vertical) => {
            return vec![Direction::North, Direction::South]
        }
        (Direction::North, Square::Horizontal) | (Direction::South, Square::Horizontal) => {
            return vec![Direction::East, Direction::West]
        }
        (Direction::East, Square::Upward) => return vec![Direction::North],
        (Direction::West, Square::Upward) => return vec![Direction::South],
        (Direction::North, Square::Upward) => return vec![Direction::East],
        (Direction::South, Square::Upward) => return vec![Direction::West],
        (Direction::East, Square::Downward) => return vec![Direction::South],
        (Direction::West, Square::Downward) => return vec![Direction::North],
        (Direction::North, Square::Downward) => return vec![Direction::West],
        (Direction::South, Square::Downward) => return vec![Direction::East],
    }
}

fn get_next_position(map: &Vec<Vec<Square>>, beam: &Beam) -> Option<Position> {
    match beam.direction {
        Direction::North => {
            return beam.position.row.checked_sub(1).map(|row| Position {
                row,
                column: beam.position.column,
            })
        }
        Direction::South => {
            let row = beam.position.row + 1;
            if row >= map.len() {
                return None;
            }
            return Some(Position {
                row,
                column: beam.position.column,
            });
        }
        Direction::East => {
            let column = beam.position.column + 1;
            if column >= map[0].len() {
                return None;
            }
            return Some(Position {
                row: beam.position.row,
                column,
            });
        }
        Direction::West => {
            return beam.position.column.checked_sub(1).map(|column| Position {
                row: beam.position.row,
                column,
            })
        }
    }
}

fn parse(input: &str) -> Vec<Vec<Square>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(input: &str) -> Vec<Square> {
    return input
        .chars()
        .map(|char| match char {
            '-' => Square::Horizontal,
            '|' => Square::Vertical,
            '/' => Square::Upward,
            '\\' => Square::Downward,
            _ => Square::Empty,
        })
        .collect();
}

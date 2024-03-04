use std::{collections::HashSet, hash::Hash};

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Square {
    Start,
    Garden,
    Rock,
}

#[derive(Debug, PartialEq, Eq, Clone, Copy, Hash)]
struct Position {
    row: usize,
    column: usize,
}

fn print_map(map: &Vec<Vec<Square>>, positions: &HashSet<Position>) {
    for i in 0..map.len() {
        for j in 0..map[i].len() {
            if positions.contains(&Position { row: i, column: j }) {
                print!("O");
                continue;
            }
            match map[i][j] {
                Square::Start | Square::Garden => print!("."),
                Square::Rock => print!("#"),
            }
        }
        println!("");
    }
    println!("");
}

impl Position {
    fn above(&self) -> Option<Position> {
        return self.row.checked_sub(1).map(|row| Position {
            row,
            column: self.column,
        });
    }

    fn left(&self) -> Option<Position> {
        return self.column.checked_sub(1).map(|column| Position {
            row: self.row,
            column,
        });
    }

    fn below(&self, size: usize) -> Option<Position> {
        let row = self.row + 1;
        let column = self.column;
        if row < size {
            return Some(Position { row, column });
        }
        return None;
    }

    fn right(&self, size: usize) -> Option<Position> {
        let row = self.row;
        let column = self.column + 1;
        if column < size {
            return Some(Position { row, column });
        }
        return None;
    }
}

pub fn solve_part1(input: &str) -> String {
    let map = parse(input);
    let start_position = Position {
        row: map.len() / 2,
        column: map.len() / 2,
    };
    let (even_positions, _) = reachable_positions(start_position, &map, 64);
    return even_positions.to_string();
}

fn reachable_positions(
    start_position: Position,
    map: &Vec<Vec<Square>>,
    limit: i32,
) -> (usize, usize) {
    let mut even_positions: HashSet<Position> = HashSet::new();
    let mut odd_positions: HashSet<Position> = HashSet::new();
    let mut all_visited_positions: HashSet<Position> = HashSet::new();
    let mut positions = HashSet::new();
    positions.insert(start_position);
    even_positions.insert(start_position);
    all_visited_positions.insert(start_position);
    for i in 1..=limit {
        if positions.is_empty() {
            break;
        }
        positions = take_step(&positions, &all_visited_positions, &map);
        if i % 2 == 0 {
            even_positions.extend(&positions);
        } else {
            odd_positions.extend(&positions);
        }
        all_visited_positions.extend(&positions);
    }

    return (even_positions.len(), odd_positions.len());
}

fn take_step(
    positions: &HashSet<Position>,
    past_positions: &HashSet<Position>,
    map: &Vec<Vec<Square>>,
) -> HashSet<Position> {
    positions
        .iter()
        .map(|position| walkable_neighboors(*position, past_positions, map))
        .flatten()
        .collect()
}

fn walkable_neighboors(
    position: Position,
    past_positions: &HashSet<Position>,
    map: &Vec<Vec<Square>>,
) -> HashSet<Position> {
    vec![
        position.above(),
        position.below(map.len()),
        position.left(),
        position.right(map[0].len()),
    ]
    .iter()
    .filter_map(|position| *position)
    .filter(|position| !past_positions.contains(&position))
    .filter(|position| map[position.row][position.column] != Square::Rock)
    .collect()
}

pub fn solve_part2(input: &str) -> String {
    let steps = 26501365;
    let map = parse(input);
    let middle_position = Position {
        row: map.len() / 2,
        column: map.len() / 2,
    };
    let middle_bottom_position = Position {
        row: map.len() - 1,
        column: map.len() / 2,
    };
    let middle_top_position = Position {
        row: 0,
        column: map.len() / 2,
    };
    let middle_left_position = Position {
        row: map.len() / 2,
        column: 0,
    };
    let middle_right_position = Position {
        row: map.len() / 2,
        column: map.len() - 1,
    };
    let (even_positions, odd_positions) = reachable_positions(middle_position, &map, i32::MAX);

    let grids_length = (steps / map.len()) - 1;
    let odd_grids = (grids_length / 2 * 2 + 1).pow(2);
    let even_grids = ((grids_length + 1) / 2 * 2).pow(2);

    let (_, top_grid) = reachable_positions(middle_bottom_position, &map, map.len() as i32 - 1);
    let (_, bottom_grid) = reachable_positions(middle_top_position, &map, map.len() as i32 - 1);
    let (_, right_grid) = reachable_positions(middle_left_position, &map, map.len() as i32 - 1);
    let (_, left_grid) = reachable_positions(middle_right_position, &map, map.len() as i32 - 1);

    let result = (odd_grids * odd_positions)
        + (even_grids * even_positions)
        + top_grid
        + bottom_grid
        + right_grid
        + left_grid;

    println!("{}", result);

    return "".to_string();
}

fn parse(input: &str) -> Vec<Vec<Square>> {
    input.lines().map(parse_line).collect()
}

fn parse_line(input: &str) -> Vec<Square> {
    input
        .chars()
        .map(|char| match char {
            '.' => Square::Garden,
            '#' => Square::Rock,
            'S' => Square::Start,
            _ => panic!(),
        })
        .collect()
}

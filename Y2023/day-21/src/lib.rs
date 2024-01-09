use std::collections::HashSet;

#[derive(PartialEq, Eq, Clone, Copy)]
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

#[derive(Debug, PartialEq, Eq, Clone, Copy, Hash)]
struct InfinitePosition {
    row: i32,
    column: i32,
}

impl InfinitePosition {
    fn from(position: Position) -> InfinitePosition {
        InfinitePosition {
            row: position.row as i32,
            column: position.column as i32,
        }
    }
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

fn print_map(map: &Vec<Vec<Square>>, positions: &HashSet<Position>) {
    for (i, row) in map.iter().enumerate() {
        for (column, square) in row.iter().enumerate() {
            if positions.contains(&Position { row: i, column }) {
                print!("O");
            } else {
                match square {
                    Square::Start => print!("."),
                    Square::Garden => print!("."),
                    Square::Rock => print!("#"),
                }
            }
        }
        println!("");
    }
    println!("");
}

pub fn solve_part1(input: &str) -> String {
    let map = parse(input);
    let mut positions = HashSet::new();
    positions.insert(find_start_position(&map));
    for _ in 0..64 {
        positions = take_step(&positions, &map);
    }
    return positions.len().to_string();
}

pub fn solve_part2(input: &str) -> String {
    let map = parse(input);
    let mut positions = HashSet::new();
    positions.insert(InfinitePosition::from(find_start_position(&map)));
    for _ in 0..10 {
        positions = take_infinite_step(&positions, &map);
    }
    return positions.len().to_string();
}

fn find_start_position(map: &Vec<Vec<Square>>) -> Position {
    for row in 0..map.len() {
        for column in 0..map[row].len() {
            if map[row][column] == Square::Start {
                return Position { row, column };
            }
        }
    }
    panic!()
}

fn take_infinite_step(
    positions: &HashSet<InfinitePosition>,
    map: &Vec<Vec<Square>>,
) -> HashSet<InfinitePosition> {
    positions
        .iter()
        .map(|position| infinite_walkable_neighboors(*position, map))
        .flatten()
        .collect()
}

fn infinite_walkable_neighboors(
    position: InfinitePosition,
    map: &Vec<Vec<Square>>,
) -> HashSet<InfinitePosition> {
    vec![
        InfinitePosition {
            row: position.row - 1,
            column: position.column,
        },
        InfinitePosition {
            row: position.row + 1,
            column: position.column,
        },
        InfinitePosition {
            row: position.row,
            column: position.column - 1,
        },
        InfinitePosition {
            row: position.row,
            column: position.column + 1,
        },
    ]
    .iter()
    .map(|position| *position)
    .filter(|position| get(position, map) != Square::Rock)
    .collect()
}

fn get(position: &InfinitePosition, map: &Vec<Vec<Square>>) -> Square {
    let normalized = normalize(position, map);
    return map[normalized.row][normalized.column];
}

fn normalize(position: &InfinitePosition, map: &Vec<Vec<Square>>) -> Position {
    let row = if position.row >= 0 {
        position.row % (map.len() as i32)
    } else {
        (map.len() as i32) + (position.row % (map.len() as i32))
    };
    let column = if position.column >= 0 {
        position.column % (map[0].len() as i32)
    } else {
        (map[0].len() as i32) + (position.column % (map[0].len() as i32))
    };
    let result = Position {
        row: row as usize,
        column: column as usize,
    };
    println!("{:?}", position);
    println!("{:?}", result);
    return result;
}

fn take_step(positions: &HashSet<Position>, map: &Vec<Vec<Square>>) -> HashSet<Position> {
    positions
        .iter()
        .map(|position| walkable_neighboors(*position, map))
        .flatten()
        .collect()
}

fn walkable_neighboors(position: Position, map: &Vec<Vec<Square>>) -> HashSet<Position> {
    vec![
        position.above(),
        position.below(map.len()),
        position.left(),
        position.right(map[0].len()),
    ]
    .iter()
    .filter_map(|position| *position)
    .filter(|position| map[position.row][position.column] != Square::Rock)
    .collect()
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

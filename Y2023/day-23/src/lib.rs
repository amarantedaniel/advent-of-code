use std::cmp;

#[derive(Debug, Clone, Copy)]
struct Position {
    row: usize,
    column: usize,
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

    fn neighboor(&self, direction: &Direction, maze: &Vec<Vec<Square>>) -> Option<Position> {
        match direction {
            Direction::North => self.above(),
            Direction::East => self.right(maze[0].len()),
            Direction::South => self.below(maze.len()),
            Direction::West => self.left(),
        }
    }

    fn neighboors(&self, maze: &Vec<Vec<Square>>) -> Vec<Position> {
        Direction::all()
            .iter()
            .filter_map(|direction| self.neighboor(direction, maze))
            .collect()
    }
}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Direction {
    North,
    South,
    West,
    East,
}

impl Direction {
    fn all() -> Vec<Direction> {
        vec![
            Direction::North,
            Direction::East,
            Direction::South,
            Direction::West,
        ]
    }
}

#[derive(PartialEq, Eq)]
enum Square {
    Path { visited: bool },
    Forest,
    Slope(Direction),
    Goal,
}

fn print_maze(maze: &Vec<Vec<Square>>) {
    for i in 0..maze.len() {
        for j in 0..maze[i].len() {
            match maze[i][j] {
                Square::Path { visited: true } => print!("O"),
                Square::Path { visited: false } => print!("."),
                Square::Forest => print!("#"),
                Square::Slope(Direction::North) => print!("^"),
                Square::Slope(Direction::East) => print!(">"),
                Square::Slope(Direction::South) => print!("v"),
                Square::Slope(Direction::West) => print!("<"),
                Square::Goal => print!("."),
            }
        }
        println!("");
    }
    println!("");
}

pub fn solve_part1(input: &str) -> String {
    let mut maze = parse(input);
    let height = maze.len();
    let width = maze[0].len();
    maze[height - 1][width - 1] = Square::Goal;
    let result = hike(Position { row: 0, column: 1 }, &mut maze);
    return result.to_string();
}

fn hike(position: Position, maze: &mut Vec<Vec<Square>>) -> u64 {
    match maze[position.row][position.column] {
        Square::Slope(direction) => {
            return 1 + hike(position.neighboor(&direction, maze).unwrap(), maze)
        }
        Square::Path { visited: false } => {
            maze[position.row][position.column] = Square::Path { visited: true };
            let mut count = 0;
            for neighboor in position.neighboors(maze) {
                let attempt = match maze[neighboor.row][neighboor.column] {
                    Square::Path { visited: false } | Square::Slope(_) => 1 + hike(neighboor, maze),
                    _ => 0,
                };
                count = cmp::max(count, attempt)
            }
            maze[position.row][position.column] = Square::Path { visited: false };
            return count;
        }
        Square::Goal => {
            maze[position.row][position.column] = Square::Path { visited: false };
            return 1;
        }
        _ => return 0,
    }
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<Vec<Square>> {
    input.lines().map(parse_line).collect()
}

fn parse_line(line: &str) -> Vec<Square> {
    line.chars().map(parse_char).collect()
}

fn parse_char(character: char) -> Square {
    match character {
        '.' => Square::Path { visited: false },
        '#' => Square::Forest,
        '^' => Square::Slope(Direction::North),
        '>' => Square::Slope(Direction::East),
        'v' => Square::Slope(Direction::South),
        '<' => Square::Slope(Direction::West),
        _ => panic!(),
    }
}

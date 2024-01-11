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

pub fn solve_part1(input: &str) -> String {
    let mut maze = parse(input, true);
    let result = hike(Position { row: 0, column: 1 }, &mut maze);
    return result.map(|result| result - 1).unwrap().to_string();
}

pub fn solve_part2(input: &str) -> String {
    let mut maze = parse(input, false);
    let result = hike(Position { row: 0, column: 1 }, &mut maze);
    return result.map(|result| result - 1).unwrap().to_string();
}

fn hike(position: Position, maze: &mut Vec<Vec<Square>>) -> Option<u64> {
    match maze[position.row][position.column] {
        Square::Slope(direction) => {
            return hike(position.neighboor(&direction, maze).unwrap(), maze)
                .map(|path_size: u64| path_size + 1);
        }
        Square::Path { visited: false } => {
            maze[position.row][position.column] = Square::Path { visited: true };
            let largest_path_size = position
                .neighboors(maze)
                .iter()
                .filter_map(|neighboor| match maze[neighboor.row][neighboor.column] {
                    Square::Path { visited: false } | Square::Slope(_) | Square::Goal => {
                        hike(*neighboor, maze).map(|path_size| path_size + 1)
                    }
                    _ => None,
                })
                .max();
            maze[position.row][position.column] = Square::Path { visited: false };
            return largest_path_size;
        }
        Square::Goal => return Some(0),
        _ => return None,
    }
}

fn parse(input: &str, include_slopes: bool) -> Vec<Vec<Square>> {
    let mut maze = input
        .lines()
        .map(|line| parse_line(line, include_slopes))
        .collect::<Vec<Vec<Square>>>();
    let height = maze.len();
    let width = maze[0].len();
    maze[height - 1][width - 1] = Square::Goal;
    return maze;
}

fn parse_line(line: &str, include_slopes: bool) -> Vec<Square> {
    line.chars()
        .map(|char| {
            if include_slopes {
                parse_char_including_slopes(char)
            } else {
                parse_char_ignoring_slopes(char)
            }
        })
        .collect()
}

fn parse_char_including_slopes(character: char) -> Square {
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

fn parse_char_ignoring_slopes(character: char) -> Square {
    match character {
        '.' => Square::Path { visited: false },
        '#' => Square::Forest,
        '^' => Square::Path { visited: false },
        '>' => Square::Path { visited: false },
        'v' => Square::Path { visited: false },
        '<' => Square::Path { visited: false },
        _ => panic!(),
    }
}

use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

#[derive(Debug, Eq, Hash, PartialEq, Clone, Copy)]
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
}

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
enum Direction {
    North,
    South,
    East,
    West,
    Start,
}

#[derive(Debug, Eq, PartialEq, Clone, Copy)]
struct State {
    node: Node,
    cost: u32,
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct Node {
    position: Position,
    direction: Direction,
    current_steps_forward: i32,
}

impl Node {
    fn top_neighboor(&self) -> Option<Node> {
        return self.find_neighboor(self.position.above(), Direction::North);
    }

    fn left_neighboor(&self) -> Option<Node> {
        return self.find_neighboor(self.position.left(), Direction::West);
    }

    fn bottom_neighboor(&self, size: usize) -> Option<Node> {
        return self.find_neighboor(self.position.below(size), Direction::South);
    }

    fn right_neighboor(&self, size: usize) -> Option<Node> {
        return self.find_neighboor(self.position.right(size), Direction::East);
    }

    fn find_neighboor(&self, position: Option<Position>, direction: Direction) -> Option<Node> {
        return position.map(|position| Node {
            position,
            direction,
            current_steps_forward: if self.direction == direction {
                self.current_steps_forward + 1
            } else {
                1
            },
        });
    }
}

pub fn solve_part1(input: &str) -> String {
    let maze = parse(input);
    let start_state = State {
        node: Node {
            position: Position { row: 0, column: 0 },
            direction: Direction::Start,
            current_steps_forward: 0,
        },
        cost: 0,
    };

    let end_position = Position {
        row: maze.len() - 1,
        column: maze[0].len() - 1,
    };
    let result = find_path(start_state, end_position, &maze);
    return result.unwrap().to_string();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn find_path(start_state: State, end_position: Position, maze: &Vec<Vec<u32>>) -> Option<u32> {
    let mut distances: HashMap<Node, u32> = HashMap::new();
    let mut heap = BinaryHeap::new();
    distances.insert(start_state.node, 0);
    heap.push(start_state);
    while let Some(state) = heap.pop() {
        if state.node.position == end_position {
            return Some(state.cost);
        }
        if &state.cost > distances.get(&state.node).unwrap_or(&u32::MAX) {
            continue;
        }
        for node in find_neighboors(&state.node, &maze) {
            let next = State {
                node,
                cost: state.cost + maze[node.position.row][node.position.column],
            };
            if &next.cost < distances.get(&next.node).unwrap_or(&u32::MAX) {
                heap.push(next);
                distances.insert(next.node, next.cost);
            }
        }
    }

    return None;
}

fn find_neighboors(node: &Node, maze: &Vec<Vec<u32>>) -> Vec<Node> {
    let top_neighboor = node.top_neighboor();
    let bottom_neighboor = node.bottom_neighboor(maze.len());
    let left_neighboor = node.left_neighboor();
    let right_neighboor = node.right_neighboor(maze[0].len());
    let neigbhoors = match (node.direction, node.current_steps_forward) {
        (Direction::North, 3) => vec![left_neighboor, right_neighboor],
        (Direction::North, _) => vec![left_neighboor, top_neighboor, right_neighboor],
        (Direction::South, 3) => vec![left_neighboor, right_neighboor],
        (Direction::South, _) => vec![left_neighboor, bottom_neighboor, right_neighboor],
        (Direction::East, 3) => vec![top_neighboor, bottom_neighboor],
        (Direction::East, _) => vec![top_neighboor, right_neighboor, bottom_neighboor],
        (Direction::West, 3) => vec![top_neighboor, bottom_neighboor],
        (Direction::West, _) => vec![top_neighboor, left_neighboor, bottom_neighboor],
        (Direction::Start, _) => vec![
            top_neighboor,
            left_neighboor,
            bottom_neighboor,
            right_neighboor,
        ],
    };
    return neigbhoors.iter().filter_map(|node| *node).collect();
}

fn parse(input: &str) -> Vec<Vec<u32>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(input: &str) -> Vec<u32> {
    return input.chars().filter_map(|char| char.to_digit(10)).collect();
}

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

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct State {
    node: Node,
    cost: u32,
}

impl State {
    fn top_neighboor(&self, maze: &Vec<Vec<u32>>, min_steps: i32) -> Option<State> {
        return self.get_neighboor(
            maze,
            self.get_min_steps(Direction::North, min_steps),
            |node| node.top_neighboor(),
        );
    }

    fn left_neighboor(&self, maze: &Vec<Vec<u32>>, min_steps: i32) -> Option<State> {
        return self.get_neighboor(
            maze,
            self.get_min_steps(Direction::West, min_steps),
            |node| node.left_neighboor(),
        );
    }

    fn bottom_neighboor(&self, maze: &Vec<Vec<u32>>, min_steps: i32) -> Option<State> {
        return self.get_neighboor(
            maze,
            self.get_min_steps(Direction::South, min_steps),
            |node| node.bottom_neighboor(maze.len()),
        );
    }

    fn right_neighboor(&self, maze: &Vec<Vec<u32>>, min_steps: i32) -> Option<State> {
        return self.get_neighboor(
            maze,
            self.get_min_steps(Direction::East, min_steps),
            |node| node.right_neighboor(maze[0].len()),
        );
    }

    fn get_min_steps(&self, direction: Direction, min_steps: i32) -> i32 {
        return if self.node.direction == direction {
            1
        } else {
            min_steps
        };
    }

    fn get_neighboor<F: Fn(Node) -> Option<Node>>(
        &self,
        maze: &Vec<Vec<u32>>,
        min_steps: i32,
        get_neighboor_node: F,
    ) -> Option<State> {
        let mut neighboor: Option<Node> = Some(self.node);
        let mut cost = 0;
        for _ in 0..min_steps {
            neighboor = get_neighboor_node(neighboor.unwrap());
            match neighboor {
                Some(n) => cost += maze[n.position.row][n.position.column],
                None => return None,
            }
        }
        return neighboor.map(|node| State {
            node,
            cost: self.cost + cost,
        });
    }
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
    return solve(&maze, 1, 3).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let maze = parse(input);
    return solve(&maze, 4, 10).to_string();
}

fn solve(maze: &Vec<Vec<u32>>, min_steps: i32, max_steps: i32) -> u32 {
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
    let result = find_path(start_state, end_position, &maze, min_steps, max_steps);
    return result.unwrap();
}

fn find_path(
    start_state: State,
    end_position: Position,
    maze: &Vec<Vec<u32>>,
    min_steps: i32,
    max_steps: i32,
) -> Option<u32> {
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
        for neighboor in find_neighboors(&state, &maze, max_steps, min_steps) {
            if &neighboor.cost < distances.get(&neighboor.node).unwrap_or(&u32::MAX) {
                heap.push(neighboor);
                distances.insert(neighboor.node, neighboor.cost);
            }
        }
    }
    return None;
}

fn find_neighboors(
    state: &State,
    maze: &Vec<Vec<u32>>,
    max_steps: i32,
    min_steps: i32,
) -> Vec<State> {
    let top_neighboor = state.top_neighboor(maze, min_steps);
    let bottom_neighboor = state.bottom_neighboor(maze, min_steps);
    let left_neighboor = state.left_neighboor(maze, min_steps);
    let right_neighboor = state.right_neighboor(maze, min_steps);
    let neigbhoors = match state.node.direction {
        Direction::North if state.node.current_steps_forward == max_steps => {
            vec![left_neighboor, right_neighboor]
        }
        Direction::North => vec![left_neighboor, top_neighboor, right_neighboor],
        Direction::South if state.node.current_steps_forward == max_steps => {
            vec![left_neighboor, right_neighboor]
        }
        Direction::South => vec![left_neighboor, bottom_neighboor, right_neighboor],
        Direction::East if state.node.current_steps_forward == max_steps => {
            vec![top_neighboor, bottom_neighboor]
        }
        Direction::East => vec![top_neighboor, right_neighboor, bottom_neighboor],
        Direction::West if state.node.current_steps_forward == max_steps => {
            vec![top_neighboor, bottom_neighboor]
        }
        Direction::West => vec![top_neighboor, left_neighboor, bottom_neighboor],
        Direction::Start => vec![
            top_neighboor,
            left_neighboor,
            bottom_neighboor,
            right_neighboor,
        ],
    };
    return neigbhoors.iter().filter_map(|state| *state).collect();
}

fn parse(input: &str) -> Vec<Vec<u32>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(input: &str) -> Vec<u32> {
    return input.chars().filter_map(|char| char.to_digit(10)).collect();
}

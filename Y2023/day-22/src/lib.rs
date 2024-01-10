use std::ops::RangeInclusive;

#[derive(Debug, Clone, Copy)]
struct Position {
    x: u64,
    y: u64,
    z: u64,
}

#[derive(Debug, Clone, Copy)]
struct Brick {
    start_position: Position,
    end_position: Position,
}

impl Brick {
    fn moved_down(&self, number: u64) -> Brick {
        let mut brick = self.clone();
        brick.start_position.z -= number;
        brick.end_position.z -= number;
        return brick;
    }

    fn z_range(&self) -> RangeInclusive<u64> {
        self.start_position.z..=self.end_position.z
    }

    fn x_range(&self) -> RangeInclusive<u64> {
        self.start_position.x..=self.end_position.x
    }

    fn y_range(&self) -> RangeInclusive<u64> {
        self.start_position.y..=self.end_position.y
    }

    fn overlaps(&self, other: &Brick) -> bool {
        range_overlaps(self.z_range(), other.z_range())
            && range_overlaps(self.x_range(), other.x_range())
            && range_overlaps(self.y_range(), other.y_range())
    }
}

fn range_overlaps(range1: RangeInclusive<u64>, range2: RangeInclusive<u64>) -> bool {
    range1.contains(range2.start())
        || range1.contains(range2.end())
        || range2.contains(range1.start())
        || range2.contains(range1.end())
}

pub fn solve_part1(input: &str) -> String {
    let mut bricks = parse(input);
    let queue = drop_bricks(&mut bricks);
    let result = count_desintegrateable(&queue);
    return result.to_string();
}

pub fn solve_part2(input: &str) -> String {
    let mut bricks = parse(input);
    let queue = drop_bricks(&mut bricks);
    let result = find_largest_chain(&queue);
    return result.to_string();
}

fn drop_bricks(bricks: &mut Vec<Brick>) -> Vec<Brick> {
    bricks.sort_by(|b1, b2| b1.start_position.z.cmp(&b2.start_position.z));
    let mut queue = Vec::new();
    queue.push(bricks[0]);
    for i in 1..bricks.len() {
        drop(bricks[i], &mut queue);
    }
    queue.sort_by(|b1, b2| b1.start_position.z.cmp(&b2.start_position.z));
    return queue;
}

fn drop(brick: Brick, stack: &mut Vec<Brick>) {
    let mut brick = brick;
    while let Some(moved_down) = move_down(&brick, stack) {
        brick = moved_down;
    }
    stack.push(brick);
}

fn move_down(brick: &Brick, stack: &Vec<Brick>) -> Option<Brick> {
    let moved_down = brick.moved_down(1);
    if moved_down.start_position.z < 1 {
        return None;
    }
    for other_brick in stack {
        if moved_down.overlaps(other_brick) {
            return None;
        }
    }
    return Some(moved_down);
}

fn count_desintegrateable(bricks: &Vec<Brick>) -> u64 {
    let mut result = 0;
    for i in 0..bricks.len() {
        let mut can_be_desintegrated = true;
        for j in i..bricks.len() {
            if bricks[j].start_position.z > bricks[i].end_position.z + 1 {
                break;
            }
            if can_move_down(&bricks[j], &bricks, &vec![i], j) {
                can_be_desintegrated = false;
                break;
            }
        }
        if can_be_desintegrated {
            result += 1;
        }
    }
    return result;
}

fn find_largest_chain(bricks: &Vec<Brick>) -> u64 {
    let mut largest_chain = 0;
    for i in 0..bricks.len() {
        println!("{}", i);
        let mut current_chain = 0;
        let mut desintegrated = vec![i];
        for j in i..bricks.len() {
            if can_move_down(&bricks[j], &bricks, &desintegrated, j) {
                desintegrated.push(j);
                current_chain += 1;
            }
        }
        largest_chain += current_chain;
    }
    return largest_chain;
}

fn can_move_down(brick: &Brick, stack: &Vec<Brick>, ignore: &Vec<usize>, ignore2: usize) -> bool {
    let moved_down = brick.moved_down(1);
    if moved_down.start_position.z < 1 {
        return false;
    }
    for i in 0..stack.len() {
        if ignore.contains(&i) || i == ignore2 {
            continue;
        }
        if moved_down.overlaps(&stack[i]) {
            return false;
        }
    }
    return true;
}

fn parse(input: &str) -> Vec<Brick> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> Brick {
    let parts = line.split("~").collect::<Vec<_>>();
    return Brick {
        start_position: parse_position(parts[0]),
        end_position: parse_position(parts[1]),
    };
}

fn parse_position(line: &str) -> Position {
    let parts = line
        .split(",")
        .filter_map(|string| string.parse::<u64>().ok())
        .collect::<Vec<_>>();
    return Position {
        x: parts[0],
        y: parts[1],
        z: parts[2],
    };
}

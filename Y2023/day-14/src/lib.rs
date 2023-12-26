use std::collections::{HashMap, VecDeque};

#[derive(PartialEq, Eq, Hash, Clone, Copy)]
enum Rock {
    Empty,
    Movable,
    Unmovable,
}

pub fn solve_part1(input: &str) -> String {
    let mut rocks = parse(input);
    move_rocks_up(&mut rocks);
    return calculate_load(&rocks).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let mut rocks = parse(input);
    let mut states: HashMap<Vec<Vec<Rock>>, i32> = HashMap::new();
    let goal_iteration = 1000000000;
    let mut iteration = 0;
    let mut did_jump = false;
    while iteration < goal_iteration {
        if let Some(previous) = states.get(&rocks) {
            if !did_jump {
                let loop_size = iteration - previous;
                let how_many_loops_fit = (goal_iteration - previous) / loop_size;
                iteration = (how_many_loops_fit * loop_size) + previous;
                did_jump = true;
                continue;
            }
        }
        states.insert(rocks.clone(), iteration);
        run_loop(&mut rocks);
        iteration += 1;
    }
    return calculate_load(&rocks).to_string();
}

fn run_loop(rocks: &mut Vec<Vec<Rock>>) {
    move_rocks_up(rocks);
    move_rocks_left(rocks);
    move_rocks_down(rocks);
    move_rocks_right(rocks);
}

fn move_rocks_up(rocks: &mut Vec<Vec<Rock>>) {
    let mut available_empty_spaces: VecDeque<usize> = VecDeque::new();
    for j in 0..rocks[0].len() {
        for i in 0..rocks.len() {
            match rocks[i][j] {
                Rock::Empty => {
                    available_empty_spaces.push_back(i);
                }
                Rock::Movable => {
                    if let Some(empty_space) = available_empty_spaces.pop_front() {
                        rocks[empty_space][j] = Rock::Movable;
                        rocks[i][j] = Rock::Empty;
                        available_empty_spaces.push_back(i);
                    } else {
                        available_empty_spaces = VecDeque::new();
                    }
                }
                Rock::Unmovable => {
                    available_empty_spaces = VecDeque::new();
                }
            }
        }
        available_empty_spaces = VecDeque::new();
    }
}

fn move_rocks_left(rocks: &mut Vec<Vec<Rock>>) {
    let mut available_empty_spaces: VecDeque<usize> = VecDeque::new();
    for i in 0..rocks.len() {
        for j in 0..rocks[i].len() {
            match rocks[i][j] {
                Rock::Empty => {
                    available_empty_spaces.push_back(j);
                }
                Rock::Movable => {
                    if let Some(empty_space) = available_empty_spaces.pop_front() {
                        rocks[i][empty_space] = Rock::Movable;
                        rocks[i][j] = Rock::Empty;
                        available_empty_spaces.push_back(j);
                    } else {
                        available_empty_spaces = VecDeque::new();
                    }
                }
                Rock::Unmovable => {
                    available_empty_spaces = VecDeque::new();
                }
            }
        }
        available_empty_spaces = VecDeque::new();
    }
}

fn move_rocks_right(rocks: &mut Vec<Vec<Rock>>) {
    let mut available_empty_spaces: VecDeque<usize> = VecDeque::new();
    for i in 0..rocks.len() {
        for j in (0..rocks[i].len()).rev() {
            match rocks[i][j] {
                Rock::Empty => {
                    available_empty_spaces.push_back(j);
                }
                Rock::Movable => {
                    if let Some(empty_space) = available_empty_spaces.pop_front() {
                        rocks[i][empty_space] = Rock::Movable;
                        rocks[i][j] = Rock::Empty;
                        available_empty_spaces.push_back(j);
                    } else {
                        available_empty_spaces = VecDeque::new();
                    }
                }
                Rock::Unmovable => {
                    available_empty_spaces = VecDeque::new();
                }
            }
        }
        available_empty_spaces = VecDeque::new();
    }
}

fn move_rocks_down(rocks: &mut Vec<Vec<Rock>>) {
    let mut available_empty_spaces: VecDeque<usize> = VecDeque::new();
    for j in (0..rocks[0].len()).rev() {
        for i in (0..rocks.len()).rev() {
            match rocks[i][j] {
                Rock::Empty => {
                    available_empty_spaces.push_back(i);
                }
                Rock::Movable => {
                    if let Some(empty_space) = available_empty_spaces.pop_front() {
                        rocks[empty_space][j] = Rock::Movable;
                        rocks[i][j] = Rock::Empty;
                        available_empty_spaces.push_back(i);
                    } else {
                        available_empty_spaces = VecDeque::new();
                    }
                }
                Rock::Unmovable => {
                    available_empty_spaces = VecDeque::new();
                }
            }
        }
        available_empty_spaces = VecDeque::new();
    }
}

fn calculate_load(rocks: &Vec<Vec<Rock>>) -> usize {
    let mut sum = 0;
    for i in 0..rocks.len() {
        for j in 0..rocks[i].len() {
            if rocks[i][j] == Rock::Movable {
                sum += rocks.len() - i;
            }
        }
    }
    return sum;
}

fn parse(input: &str) -> Vec<Vec<Rock>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> Vec<Rock> {
    return line
        .chars()
        .map(|char| match char {
            'O' => Rock::Movable,
            '#' => Rock::Unmovable,
            _ => Rock::Empty,
        })
        .collect();
}

use std::collections::VecDeque;

#[derive(PartialEq)]
enum Rock {
    Empty,
    Movable,
    Unmovable,
}

fn print_map(map: &Vec<Vec<Rock>>) {
    for row in map {
        for rock in row {
            match rock {
                Rock::Empty => print!("."),
                Rock::Movable => print!("O"),
                Rock::Unmovable => print!("#"),
            }
        }
        println!("");
    }
    println!("");
}

pub fn solve_part1(input: &str) -> String {
    let mut rocks = parse(input);
    move_rocks(&mut rocks);
    return calculate_load(&rocks).to_string();
}

fn move_rocks(rocks: &mut Vec<Vec<Rock>>) {
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

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
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

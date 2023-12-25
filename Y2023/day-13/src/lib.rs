fn print_pattern(pattern: &Vec<Vec<char>>) {
    for row in pattern {
        for char in row {
            print!("{}", char);
        }
        println!("");
    }
}

pub fn solve_part1(input: &str) -> String {
    let mut result = 0;
    let patterns = parse(input);
    for pattern in patterns {
        if let Some(reflection_row) = find_reflection_row(&pattern) {
            result += (reflection_row + 1) * 100;
        } else if let Some(reflection_column) = find_reflection_column(&pattern) {
            result += reflection_column + 1
        } else {
            panic!();
        }
    }
    return result.to_string();
}

fn rotate(pattern: &Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut result = vec![vec!['?'; pattern.len()]; pattern[0].len()];

    for i in 0..pattern.len() {
        for j in 0..pattern[i].len() {
            result[j][i] = pattern[i][j];
        }
    }
    return result;
}

fn find_reflection_column(pattern: &Vec<Vec<char>>) -> Option<usize> {
    return find_reflection_row(&rotate(&pattern));
}

fn find_reflection_row(pattern: &Vec<Vec<char>>) -> Option<usize> {
    for i in 0..pattern.len() - 1 {
        if is_reflection_row(i, pattern) {
            return Some(i);
        }
    }
    return None;
}

fn is_reflection_row(index: usize, pattern: &Vec<Vec<char>>) -> bool {
    let mut i = index;
    let mut j = index + 1;
    while j < pattern.len() {
        if pattern[i] != pattern[j] {
            return false;
        }
        if i == 0 {
            break;
        }
        i -= 1;
        j += 1;
    }
    return true;
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<Vec<Vec<char>>> {
    return input.split("\n\n").map(parse_pattern).collect();
}

fn parse_pattern(input: &str) -> Vec<Vec<char>> {
    return input.lines().map(|line| line.chars().collect()).collect();
}

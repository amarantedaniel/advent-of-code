pub fn solve_part1(input: &str) -> String {
    let patterns = parse(input);
    return solve(&patterns, false).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let patterns = parse(input);
    return solve(&patterns, true).to_string();
}

fn solve(patterns: &Vec<Vec<Vec<char>>>, include_smudge: bool) -> usize {
    let mut result = 0;
    for pattern in patterns {
        if let Some(reflection_row) = find_reflection_row(&pattern, include_smudge) {
            result += (reflection_row + 1) * 100;
        } else if let Some(reflection_column) = find_reflection_column(&pattern, include_smudge) {
            result += reflection_column + 1
        } else {
            panic!();
        }
    }
    return result;
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

fn find_reflection_column(pattern: &Vec<Vec<char>>, include_smudge: bool) -> Option<usize> {
    return find_reflection_row(&rotate(&pattern), include_smudge);
}

fn find_reflection_row(pattern: &Vec<Vec<char>>, include_smudge: bool) -> Option<usize> {
    for i in 0..pattern.len() - 1 {
        if is_reflection_row(i, pattern, include_smudge) {
            return Some(i);
        }
    }
    return None;
}

fn is_reflection_row(index: usize, pattern: &Vec<Vec<char>>, include_smudge: bool) -> bool {
    let mut did_find_smudge = !include_smudge;
    let mut i = index;
    let mut j = index + 1;
    while j < pattern.len() {
        let difference = get_difference(&pattern[i], &pattern[j]);
        if difference > 1 {
            return false;
        }
        if difference == 1 {
            if did_find_smudge {
                return false;
            }
            did_find_smudge = true;
        }
        if i == 0 {
            break;
        }
        i -= 1;
        j += 1;
    }
    return did_find_smudge;
}

fn get_difference(first: &Vec<char>, second: &Vec<char>) -> u64 {
    let mut count = 0;
    for (first_char, second_char) in first.iter().zip(second.iter()) {
        if first_char != second_char {
            count += 1;
        }
    }
    return count;
}

fn parse(input: &str) -> Vec<Vec<Vec<char>>> {
    return input.split("\n\n").map(parse_pattern).collect();
}

fn parse_pattern(input: &str) -> Vec<Vec<char>> {
    return input.lines().map(|line| line.chars().collect()).collect();
}

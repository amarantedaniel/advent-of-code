pub fn solve_part1(input: &str) -> String {
    return solve(input, find_min_max_subtraction);
}

pub fn solve_part2(input: &str) -> String {
    return solve(input, find_even_division);
}

fn solve(input: &str, checksum_solver: fn(&Vec<i32>) -> i32) -> String {
    return parse_input(input)
        .iter()
        .fold(0, |checksum, line| checksum + checksum_solver(line))
        .to_string();
}

fn parse_input(input: &str) -> Vec<Vec<i32>> {
    return input
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|s| s.parse::<i32>().unwrap())
                .collect()
        })
        .collect();
}

fn find_min_max_subtraction(array: &Vec<i32>) -> i32 {
    let max = array.iter().max().unwrap();
    let min = array.iter().min().unwrap();
    return max - min;
}

fn find_even_division(array: &Vec<i32>) -> i32 {
    for i in 0..array.len() {
        for j in 0..array.len() {
            if i != j && array[i] % array[j] == 0 {
                return array[i] / array[j];
            }
        }
    }
    return -1;
}
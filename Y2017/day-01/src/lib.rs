pub fn solve_part1(input: &str) -> String {
    let array = format_input(input);
    return solve(&array, 1)
}

pub fn solve_part2(input: &str) -> String {
    let array = format_input(input);
    return solve(&array, array.len() / 2);
}

fn solve(array: &Vec<u32>, next: usize) -> String {
    let mut sum = 0;
    for i in 0..array.len() {
        if array[i] == array[(i + next) % array.len()] {
            sum += array[i];
        }
    }
    return sum.to_string();
}

fn format_input(input: &str) -> Vec<u32> {
    let characters: Vec<char> = input.chars().collect();
    return characters
        .iter()
        .filter_map(|&c| c.to_digit(10))
        .collect();
}
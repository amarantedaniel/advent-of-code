pub fn solve_part1(input: &str) -> String {
    let mut result = 0;
    for numbers in &parse(input) {
        result += solve(numbers).last().unwrap();
    }
    return result.to_string();
}

pub fn solve_part2(input: &str) -> String {
    let mut result = 0;
    for numbers in &parse(input) {
        let reversed = numbers.into_iter().rev().cloned().collect::<Vec<_>>();
        result += solve(&reversed).last().unwrap();
    }
    return result.to_string();
}

fn solve(numbers: &Vec<i64>) -> Vec<i64> {
    let mut result = numbers.clone();
    let next = generate_next(numbers);
    if next.len() == numbers.len() {
        result.push(result.last().unwrap() + next.last().unwrap());
        return result;
    }
    let solved = solve(&next);
    result.push(result.last().unwrap() + solved.last().unwrap());
    return result;
}

fn generate_next(numbers: &Vec<i64>) -> Vec<i64> {
    let mut all_are_zero = true;
    let mut result: Vec<i64> = Vec::new();
    for i in 0..(numbers.len() - 1) {
        let number = numbers[i + 1] - numbers[i];
        if number != 0 {
            all_are_zero = false
        }
        result.push(number);
    }
    if all_are_zero {
        result.push(0);
    }
    return result;
}

fn parse(input: &str) -> Vec<Vec<i64>> {
    return input.lines().map(parse_line).collect::<Vec<_>>();
}

fn parse_line(input: &str) -> Vec<i64> {
    return input
        .split(" ")
        .filter_map(|substring| substring.parse::<i64>().ok())
        .collect();
}

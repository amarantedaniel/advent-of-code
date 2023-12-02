use std::collections::HashMap;

pub fn solve_part1(input: &str) -> String {
    let mut sum = 0;
    for line in input.lines() {
        let first = find_first_digit(line);
        let last = find_last_digit(line);
        sum += first * 10 + last;

    }
    return sum.to_string();
}

fn find_first_digit(line: &str) -> u32 {
    for character in line.chars() {
        if let Some(digit) = character.to_digit(10) {
            return digit;
        }
    }
    return 0;
}

fn find_last_digit(line: &str) -> u32 {
    for character in line.chars().rev() {
        if let Some(digit) = character.to_digit(10) {
            return digit;
        }
    }
    return 0;
}

pub fn solve_part2(input: &str) -> String {
    let mut sum = 0;
    for line in input.lines() {
        let first = find_first_digit_or_spelled_out(line);
        let last = find_last_digit_or_spelled_out(line);
        sum += first * 10 + last;

    }
    return sum.to_string();
}

fn find_first_digit_or_spelled_out(line: &str) -> u32 {
    for (index, character) in line.chars().enumerate() {
        if let Some(digit) = character.to_digit(10) {
            return digit;
        }
        if let Some(digit) = find_spelled_out_digit(line, index) {
            return digit;
        }
    }
    return 0;
}

fn find_last_digit_or_spelled_out(line: &str) -> u32 {
    for (index, character) in line.chars().rev().enumerate() {
        if let Some(digit) = character.to_digit(10) {
            return digit;
        }
        if let Some(digit) = find_spelled_out_digit(line, line.len() - index - 1) {
            return digit;
        }
    }
    return 0;
}

fn find_spelled_out_digit(line: &str, index: usize) -> Option<u32> {
    let map = HashMap::from([
        ("one".to_string(), 1),
        ("two".to_string(), 2),
        ("three".to_string(), 3),
        ("four".to_string(), 4),
        ("five".to_string(), 5),
        ("six".to_string(), 6),
        ("seven".to_string(), 7),
        ("eight".to_string(), 8),
        ("nine".to_string(), 9),
        ("zero".to_string(), 0)
    ]);

    if line.len() - index >= 3 {
        let substring = &line[index..index+3];
        if let Some(digit) = map.get(&substring.to_string()) {
            return Some(*digit);
        }
    } 
    if line.len() - index >= 4 {
        let substring = &line[index..index+4];
        if let Some(digit) = map.get(&substring.to_string()) {
            return Some(*digit);
        }
    }
    if line.len() - index >= 5 {
        let substring = &line[index..index+5];
        if let Some(digit) = map.get(&substring.to_string()) {
            return Some(*digit);
        }
    }
    return None;
}

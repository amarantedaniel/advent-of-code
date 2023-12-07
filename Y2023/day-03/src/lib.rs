use std::collections::HashMap;
use std::cmp;

pub fn solve_part1(input: &str) -> String {
    let matrix = parse_input(input);
    return find_part_numbers(&matrix).iter().sum::<u32>().to_string();
}

fn find_part_numbers(matrix: &Vec<Vec<char>>) -> Vec<u32> {
    let mut start_index: Option<usize> =  None;
    let mut part_numbers = Vec::new();
    for i in 0..matrix.len() {
        for j in 0..matrix[i].len() {
            if matrix[i][j].is_digit(10) {
                if start_index == None {
                    start_index = Some(j);
                }
            } else {
                if let Some(start_index) = start_index {
                    if let Some(number) = read_part_number(&matrix, i, start_index, j) {
                        part_numbers.push(number);
                    }
                }
                start_index = None;
            }
        }
        if let Some(start_index) = start_index {
            if let Some(number) = read_part_number(&matrix, i, start_index, matrix[i].len()) {
                part_numbers.push(number);
            }
        }
        start_index = None;
    }
    return part_numbers;
}

fn read_part_number(matrix: &Vec<Vec<char>>, row: usize, start_index: usize, end_index: usize) -> Option<u32> {
    if (start_index..end_index).any(|z| has_symbols_around(matrix, row, z)) {
        return matrix[row][start_index..end_index].iter().collect::<String>().parse::<u32>().ok();
    }
    return None;
}

fn has_symbols_around(matrix: &Vec<Vec<char>>, row: usize, column: usize) -> bool {
    for ii in  row.saturating_sub(1)..cmp::min(row+2,  matrix.len()) {
        for jj in column.saturating_sub(1)..cmp::min(column+2, matrix[row].len()) {
            if !matrix[ii][jj].is_digit(10) && matrix[ii][jj] != '.' {
                return true;
            }
        }
    }
    return false;
}

pub fn solve_part2(input: &str) -> String {
    let matrix = parse_input(input);
    let gear_numbers =  find_gear_numbers(&matrix);
    let mut gear_map: HashMap<(usize, usize), Vec<u32>> = HashMap::new();
    for gear_number in gear_numbers {
        gear_map
            .entry(gear_number.gear_index)
            .or_insert_with(Vec::new)
            .push(gear_number.number);
    }

    let mut sum = 0;
    for (_, value) in gear_map {
        if  value.len() == 2 {
            sum += value[0] * value[1];
        }
    }
    return sum.to_string();
}

#[derive(Debug)]
struct GearNumber {
    number: u32,
    gear_index: (usize, usize)
}

fn find_gear_numbers(matrix: &Vec<Vec<char>>) -> Vec<GearNumber> {
    let mut start_index: Option<usize> =  None;
    let mut gear_numbers = Vec::new();
    for i in 0..matrix.len() {
        for j in 0..matrix[i].len() {
            if matrix[i][j].is_digit(10) {
                if start_index == None {
                    start_index = Some(j);
                }
            } else {
                if let Some(start_index) = start_index {
                    if let Some(number) = read_gear_number(&matrix, i, start_index, j) {
                        gear_numbers.push(number);
                    }
                }
                start_index = None;
            }
        }
        if let Some(start_index) = start_index {
            if let Some(number) = read_gear_number(&matrix, i, start_index, matrix[i].len()) {
                gear_numbers.push(number);
            }
        }
        start_index = None;
    }
    return gear_numbers;
}

fn read_gear_number(matrix: &Vec<Vec<char>>, row: usize, start_index: usize, end_index: usize) -> Option<GearNumber> {
    for z in start_index..end_index {
        if let Some(gear_index) = find_gear_index(matrix, row, z) {
            let number = matrix[row][start_index..end_index].iter().collect::<String>().parse::<u32>().unwrap();
            return Some(GearNumber { number: number, gear_index: gear_index });
        }
    }
    return None;
}


fn find_gear_index(matrix: &Vec<Vec<char>>, row: usize, column: usize) -> Option<(usize, usize)> {
    for ii in  row.saturating_sub(1)..cmp::min(row+2,  matrix.len()) {
        for jj in column.saturating_sub(1)..cmp::min(column+2, matrix[row].len()) {
            if matrix[ii][jj] == '*' {
                return Some((ii, jj));
            }
        }
    }
    return None;
}

fn parse_input(input: &str) -> Vec<Vec<char>> {
    input
        .lines()
        .map(|line| line.chars().collect())
        .collect()
}
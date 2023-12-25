use std::collections::HashMap;

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
enum Spring {
    Operational,
    Damaged,
    Unknown,
}

impl Spring {
    fn is_damaged_or_unknown(&self) -> bool {
        return self == &Spring::Damaged || self == &Spring::Unknown;
    }

    fn is_operational_or_unknown(&self) -> bool {
        return self == &Spring::Operational || self == &Spring::Unknown;
    }
}

pub fn solve_part1(input: &str) -> String {
    return solve(parse(input, 1)).to_string();
}

pub fn solve_part2(input: &str) -> String {
    return solve(parse(input, 5)).to_string();
}

fn solve(records: Vec<(Vec<Spring>, Vec<usize>)>) -> u64 {
    let mut result = 0;
    for (springs, group_sizes) in records.iter() {
        result += count_solutions(&springs, &group_sizes, &mut HashMap::new());
    }
    return result;
}

fn count_solutions(
    springs: &Vec<Spring>,
    group_sizes: &Vec<usize>,
    mut cache: &mut HashMap<(Vec<Spring>, Vec<usize>), u64>,
) -> u64 {
    if springs.is_empty() {
        return if group_sizes.is_empty() { 1 } else { 0 };
    }

    if let Some(result) = cache.get(&(springs.clone(), group_sizes.clone())) {
        return *result;
    }
    let mut count = 0;
    let spring = springs.first().unwrap();

    if spring.is_operational_or_unknown() {
        count += count_solutions(&springs[1..].to_vec(), group_sizes, &mut cache);
    }

    if spring.is_damaged_or_unknown() && can_fit_damaged_spring(springs, group_sizes) {
        let group_size = group_sizes[0];
        let window_size = if group_size < springs.len() {
            group_size + 1
        } else {
            group_size
        };
        count += count_solutions(
            &springs[window_size..].to_vec(),
            &group_sizes[1..].to_vec(),
            &mut cache,
        );
    }
    cache.insert((springs.clone(), group_sizes.clone()), count);

    return count;
}

fn can_fit_damaged_spring(springs: &Vec<Spring>, group_sizes: &Vec<usize>) -> bool {
    if group_sizes.is_empty() {
        return false;
    }
    let group_size = group_sizes[0];
    if group_size > springs.len() {
        return false;
    }
    let window = &springs[..group_size];
    if window.iter().any(|spring| spring == &Spring::Operational) {
        return false;
    }
    if group_size < springs.len() && springs[group_size] == Spring::Damaged {
        return false;
    }
    return true;
}

fn parse(input: &str, times: u64) -> Vec<(Vec<Spring>, Vec<usize>)> {
    return input.lines().map(|line| parse_line(line, times)).collect();
}

fn parse_line(line: &str, times: u64) -> (Vec<Spring>, Vec<usize>) {
    let parts = line.split(" ").collect::<Vec<_>>();
    return (
        parse_springs(parts[0], times),
        parse_group_sizes(parts[1], times),
    );
}

fn parse_springs(input: &str, times: u64) -> Vec<Spring> {
    let parsed = input
        .chars()
        .map(|char| match char {
            '#' => return Spring::Damaged,
            '?' => return Spring::Unknown,
            _ => return Spring::Operational,
        })
        .collect::<Vec<_>>();

    let copies = (1..times).map(|_| parsed.clone());
    let mut result = parsed.clone();
    for copy in copies {
        result.push(Spring::Unknown);
        result.extend(copy);
    }
    return result;
}

fn parse_group_sizes(input: &str, times: u64) -> Vec<usize> {
    let parsed = input
        .split(",")
        .filter_map(|part| part.parse().ok())
        .collect::<Vec<_>>();
    return (0..times).map(|_| parsed.clone()).flat_map(|v| v).collect();
}

use std::collections::HashMap;

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
enum Spring {
    Operational,
    Damaged,
    Unknown,
}

pub fn solve_part1(input: &str) -> String {
    let condition_records = parse(input, 1);
    let mut result = 0;
    for (springs, group_sizes) in condition_records {
        // let mut cache = HashMap::new();
        let count = count_solutions(&springs, &group_sizes, &mut HashMap::new());
        result += count
    }
    return result.to_string();
}

fn count_solutions(
    springs: &Vec<Spring>,
    group_sizes: &Vec<usize>,
    mut cache: &mut HashMap<(Vec<Spring>, Vec<usize>), u64>,
) -> u64 {
    if let Some(result) = cache.get(&(springs.clone(), group_sizes.clone())) {
        return *result;
    }
    if springs.is_empty() {
        return if group_sizes.is_empty() { 1 } else { 0 };
    }

    if springs[0] == Spring::Operational {
        return count_solutions(&springs[1..].to_vec(), group_sizes, &mut cache);
    }

    if springs[0] == Spring::Damaged {
        if group_sizes.is_empty() {
            return 0;
        }
        let group_size = group_sizes[0];
        if group_size > springs.len() {
            return 0;
        }
        let window = &springs[..group_size];
        if window.iter().any(|spring| spring == &Spring::Operational) {
            return 0;
        }

        if group_size < springs.len() {
            if springs[group_size] != Spring::Damaged {
                return count_solutions(
                    &springs[group_size + 1..].to_vec(),
                    &group_sizes[1..].to_vec(),
                    &mut cache,
                );
            } else {
                return 0;
            }
        } else {
            return count_solutions(
                &springs[group_size..].to_vec(),
                &group_sizes[1..].to_vec(),
                &mut cache,
            );
        }
    }

    let mut count = 0;

    count += count_solutions(&springs[1..].to_vec(), group_sizes, &mut cache);

    if group_sizes.is_empty() {
        return count;
    }
    let group_size = group_sizes[0];

    if group_size > springs.len() {
        return count;
    }
    let window = &springs[..group_size];
    if window.iter().any(|spring| spring == &Spring::Operational) {
        return count;
    }
    if group_size < springs.len() {
        if springs[group_size] != Spring::Damaged {
            count += count_solutions(
                &springs[group_size + 1..].to_vec(),
                &group_sizes[1..].to_vec(),
                &mut cache,
            );
        }
    } else {
        count += count_solutions(
            &springs[group_size..].to_vec(),
            &group_sizes[1..].to_vec(),
            &mut cache,
        );
    }

    cache.insert((springs.clone(), group_sizes.clone()), count);

    return count;
}

pub fn solve_part2(input: &str) -> String {
    let condition_records = parse(input, 5);
    let mut result = 0;
    for (springs, group_sizes) in condition_records.iter() {
        // let mut cache = HashMap::new();
        // let count = count_solutions(&springs, &group_sizes, &mut cache);
        result += count_solutions(&springs, &group_sizes, &mut HashMap::new());
    }
    return result.to_string();
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

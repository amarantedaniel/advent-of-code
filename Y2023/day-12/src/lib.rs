use std::fmt;

#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy)]
enum Spring {
    Operational,
    Damaged,
    Unknown,
}

impl fmt::Display for Spring {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Spring::Operational => write!(f, "."),
            Spring::Damaged => write!(f, "#"),
            Spring::Unknown => write!(f, "?"),
        }
    }
}

fn print(springs: &Vec<Spring>) {
    for spring in springs {
        print!("{}", spring);
    }
    println!("");
}

pub fn solve_part1(input: &str) -> String {
    let condition_records = parse(input);
    let mut result = 0;
    for (springs, group_sizes) in condition_records {
        let count = count_solutions(&springs, &group_sizes);
        println!("{}", count);
        result += count
    }
    return result.to_string();
}

fn count_solutions(springs: &Vec<Spring>, group_sizes: &Vec<usize>) -> u64 {
    // println!("\nrecursion starting");
    // print(springs);
    // println!("group_sizes: {:?}", group_sizes);
    if springs.is_empty() {
        return if group_sizes.is_empty() { 1 } else { 0 };
    }

    if springs[0] == Spring::Operational {
        // println!("will remove {}", Spring::Operational);
        return count_solutions(&springs[1..].to_vec(), group_sizes);
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
                // println!("will remove {:?}", &springs[..group_size + 1]);
                return count_solutions(
                    &springs[group_size + 1..].to_vec(),
                    &group_sizes[1..].to_vec(),
                );
            } else {
                return 0;
            }
        } else {
            // println!("will remove {:?}", &springs[..group_size]);
            return count_solutions(&springs[group_size..].to_vec(), &group_sizes[1..].to_vec());
        }
    }

    let mut count = 0;

    // println!("will remove {}", Spring::Operational);
    count += count_solutions(&springs[1..].to_vec(), group_sizes);

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
            // println!("will remove {:?}", &springs[..group_size + 1]);
            count += count_solutions(
                &springs[group_size + 1..].to_vec(),
                &group_sizes[1..].to_vec(),
            );
        }
    } else {
        // println!("will remove {:?}", &springs[..group_size]);
        count += count_solutions(&springs[group_size..].to_vec(), &group_sizes[1..].to_vec());
    }

    return count;
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<(Vec<Spring>, Vec<usize>)> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> (Vec<Spring>, Vec<usize>) {
    let parts = line.split(" ").collect::<Vec<_>>();
    return (parse_springs(parts[0]), parse_group_sizes(parts[1]));
}

fn parse_springs(input: &str) -> Vec<Spring> {
    return input
        .chars()
        .map(|char| match char {
            '#' => return Spring::Damaged,
            '?' => return Spring::Unknown,
            _ => return Spring::Operational,
        })
        .collect();
}

fn parse_group_sizes(input: &str) -> Vec<usize> {
    return input
        .split(",")
        .filter_map(|part| part.parse().ok())
        .collect();
}

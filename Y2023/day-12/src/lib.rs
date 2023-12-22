#[derive(Debug)]
struct ConditionRecords {
    springs: Vec<Spring>,
    group_sizes: Vec<u64>,
}
#[derive(Debug)]
enum Spring {
    Operational,
    Damaged,
    Unknown,
}

pub fn solve_part1(input: &str) -> String {
    let condition_records = parse(input);
    println!("{:?}", condition_records);
    return input.to_string();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<ConditionRecords> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> ConditionRecords {
    let parts = line.split(" ").collect::<Vec<_>>();
    return ConditionRecords {
        springs: parse_springs(parts[0]),
        group_sizes: parse_group_sizes(parts[1]),
    };
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

fn parse_group_sizes(input: &str) -> Vec<u64> {
    return input
        .split(",")
        .filter_map(|part| part.parse().ok())
        .collect();
}

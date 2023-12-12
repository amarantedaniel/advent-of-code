use std::iter::zip;

#[derive(Debug)]
struct Race {
    time: u32,
    distance: u32,
}

pub fn solve_part1(input: &str) -> String {
    let races = parse(input);
    println!("{:?}", races);
    return input.to_string();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<Race> {
    let parts = input.lines().collect::<Vec<_>>();
    let times = parse_line(parts[0]);
    let distances = parse_line(parts[1]);
    return zip(times, distances)
        .map(|(time, distance)| Race { time, distance })
        .collect();
}

fn parse_line(line: &str) -> Vec<u32> {
    return line
        .split(" ")
        .filter_map(|number| number.parse::<u32>().ok())
        .collect();
}

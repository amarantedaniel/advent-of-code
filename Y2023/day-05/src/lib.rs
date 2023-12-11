#[derive(Debug)]
struct Almanac {
    seeds: Vec<u32>,
    maps: Vec<Map>,
}

#[derive(Debug)]
struct Map {
    rows: Vec<MapRow>,
}

#[derive(Debug)]
struct MapRow {
    source_range_start: u32,
    destination_range_start: u32,
    range_length: u32,
}

pub fn solve_part1(input: &str) -> String {
    let almanac = parse(input);
    println!("{:?}", almanac);
    return input.to_string();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Almanac {
    let lines = input.split("\n\n").collect::<Vec<_>>();
    return Almanac {
        seeds: parse_seeds(lines[0]),
        maps: parse_maps(&lines[1..]),
    };
}

fn parse_seeds(input: &str) -> Vec<u32> {
    return input
        .split(" ")
        .filter_map(|substring| substring.parse::<u32>().ok())
        .collect();
}

fn parse_maps(input: &[&str]) -> Vec<Map> {
    return input.iter().map(|line| parse_map).collect();
}

fn parse_map(input: &str) -> Map {
    return Map {
        rows: input.lines().collect::<Vec<_>>()[1..]
            .iter()
            .map(|line| parse_map_row(line))
            .collect::<Vec<_>>(),
    };
}

fn parse_map_row(input: &str) -> MapRow {
    let parts = input
        .split(" ")
        .filter_map(|number| number.parse::<u32>().ok())
        .collect::<Vec<_>>();
    return MapRow {
        source_range_start: parts[1],
        destination_range_start: parts[0],
        range_length: parts[2],
    };
}

use std::{cmp, ops::Range};

#[derive(Debug)]
struct Almanac {
    seeds: Vec<u64>,
    maps: Vec<Map>,
}

#[derive(Debug)]
struct Map {
    rows: Vec<MapRow>,
}

#[derive(Debug)]
struct MapRow {
    source_range_start: u64,
    destination_range_start: u64,
    range_length: u64,
}

pub fn solve_part1(input: &str) -> String {
    let almanac = parse(input);
    let mut lowest = u64::MAX;
    for seed in almanac.seeds {
        let location = get_location(seed, &almanac.maps);
        lowest = cmp::min(lowest, location);
    }
    return lowest.to_string();
}

fn get_location(seed: u64, maps: &Vec<Map>) -> u64 {
    return maps
        .iter()
        .fold(seed, |current, map| apply_map(map, current));
}

fn apply_map(map: &Map, seed: u64) -> u64 {
    for row in &map.rows {
        if let Some(u64) = apply_row(row, seed) {
            return u64;
        }
    }
    return seed;
}

fn apply_row(row: &MapRow, seed: u64) -> Option<u64> {
    let range = row.source_range_start..(row.source_range_start + row.range_length);
    if range.contains(&seed) {
        return Some(row.destination_range_start + (seed - row.source_range_start));
    }
    return None;
}

pub fn solve_part2(input: &str) -> String {
    let almanac = parse(input);
    for location in 0..u64::MAX {
        let seed_ranges = get_seed_ranges(&almanac.seeds);
        let seed = get_seed(location, &almanac.maps);
        for range in seed_ranges {
            if range.contains(&seed) {
                println!("seed is {:?}", seed);
                println!("location is {:?}", location);
                return "".to_string();
            }
        }
    }
    return "".to_string();
}

fn get_seed_ranges(seed_numbers: &Vec<u64>) -> Vec<Range<u64>> {
    return seed_numbers
        .chunks(2)
        .map(|chunk| (chunk[0]..(chunk[0] + chunk[1])))
        .collect();
}

fn get_seed(location: u64, maps: &Vec<Map>) -> u64 {
    return maps
        .iter()
        .rev()
        .fold(location, |current, map| apply_map_reversed(map, current));
}

fn apply_map_reversed(map: &Map, location: u64) -> u64 {
    for row in &map.rows {
        if let Some(u64) = apply_row_reversed(row, location) {
            return u64;
        }
    }
    return location;
}

fn apply_row_reversed(row: &MapRow, location: u64) -> Option<u64> {
    let range = row.destination_range_start..(row.destination_range_start + row.range_length);
    if range.contains(&location) {
        return Some(row.source_range_start + (location - row.destination_range_start));
    }
    return None;
}

///////// Parser

fn parse(input: &str) -> Almanac {
    let lines = input.split("\n\n").collect::<Vec<_>>();
    return Almanac {
        seeds: parse_seeds(lines[0]),
        maps: parse_maps(&lines[1..]),
    };
}

fn parse_seeds(input: &str) -> Vec<u64> {
    return input
        .split(" ")
        .filter_map(|substring| substring.parse::<u64>().ok())
        .collect();
}

fn parse_maps(input: &[&str]) -> Vec<Map> {
    return input.iter().map(|line| parse_map(line)).collect();
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
        .filter_map(|number| number.parse::<u64>().ok())
        .collect::<Vec<_>>();
    return MapRow {
        source_range_start: parts[1],
        destination_range_start: parts[0],
        range_length: parts[2],
    };
}

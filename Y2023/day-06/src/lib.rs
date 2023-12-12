use std::iter::zip;

#[derive(Debug)]
struct Race {
    time: u64,
    distance: u64,
}

pub fn solve_part1(input: &str) -> String {
    let races = parse_small_races(input);
    return races
        .iter()
        .fold(1, |number_of_ways, race| number_of_ways * solve(&race))
        .to_string();
}

pub fn solve_part2(input: &str) -> String {
    let race = parse_big_race(input);
    return solve(&race).to_string();
}

fn solve(race: &Race) -> u64 {
    let mut win_count = 0;
    for hold_time in 1..race.time {
        let remaining_time = race.time - hold_time;
        let total_distance = remaining_time * hold_time;
        if total_distance > race.distance {
            win_count += 1
        }
    }
    return win_count;
}

fn parse_small_races(input: &str) -> Vec<Race> {
    let parts = input.lines().collect::<Vec<_>>();
    let times = parse_line_for_small_races(parts[0]);
    let distances = parse_line_for_small_races(parts[1]);
    return zip(times, distances)
        .map(|(time, distance)| Race { time, distance })
        .collect();
}

fn parse_line_for_small_races(line: &str) -> Vec<u64> {
    return line
        .split(" ")
        .filter_map(|number| number.parse::<u64>().ok())
        .collect();
}

fn parse_big_race(input: &str) -> Race {
    let parts = input.lines().collect::<Vec<_>>();
    let time = parse_line_for_big_race(parts[0]);
    let distance = parse_line_for_big_race(parts[1]);
    return Race {
        time: time,
        distance: distance,
    };
}

fn parse_line_for_big_race(line: &str) -> u64 {
    return line
        .split(" ")
        .filter(|word| word.parse::<u64>().is_ok())
        .collect::<Vec<_>>()
        .join("")
        .parse::<u64>()
        .unwrap();
}

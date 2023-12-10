use std::cmp;
use std::collections::HashMap;

struct Draw {
    red: u32,
    green: u32,
    blue: u32,
}

pub fn solve_part1(input: &str) -> String {
    let lines = input.lines();
    let mut result = 0;
    for (index, line) in lines.enumerate() {
        let draws = parse_line(line);
        if draws.into_iter().all(|draw| is_possible(draw)) {
            result += index + 1;
        }
    }
    return result.to_string();
}

fn is_possible(draw: Draw) -> bool {
    return draw.red <= 12 && draw.green <= 13 && draw.blue <= 14;
}

pub fn solve_part2(input: &str) -> String {
    let lines = input.lines();
    let mut result = 0;
    for line in lines {
        result += get_product(parse_line(line));
    }
    return result.to_string();
}

fn get_product(draws: Vec<Draw>) -> u32 {
    let minimum = draws.into_iter().fold(Draw::zero(), |minimum, draw| Draw {
        red: cmp::max(minimum.red, draw.red),
        green: cmp::max(minimum.green, draw.green),
        blue: cmp::max(minimum.blue, draw.blue),
    });
    return minimum.red * minimum.blue * minimum.green;
}

fn parse_line(line: &str) -> Vec<Draw> {
    let split = line.split(':').collect::<Vec<_>>();
    return split[1]
        .split(';')
        .map(|draw| parse_draw(draw))
        .collect::<Vec<_>>();
}

fn parse_draw(draw: &str) -> Draw {
    let color_counts = draw.split(',').collect::<Vec<_>>();
    let mut map: HashMap<&str, u32> = HashMap::new();
    for color_count in color_counts {
        let split = color_count.trim().split(' ').collect::<Vec<_>>();
        let count = split[0].parse::<u32>().unwrap();
        let color = split[1];
        map.insert(color, count);
    }
    return Draw::from_map(map);
}

impl Draw {
    fn zero() -> Draw {
        return Draw {
            red: 0,
            green: 0,
            blue: 0,
        };
    }

    fn from_map(map: HashMap<&str, u32>) -> Draw {
        return Draw {
            red: *map.get("red").unwrap_or(&0),
            green: *map.get("green").unwrap_or(&0),
            blue: *map.get("blue").unwrap_or(&0),
        };
    }
}

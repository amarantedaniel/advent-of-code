use std::collections::HashMap;

#[derive(Debug)]
enum Direction {
    Right,
    Left,
}

pub fn solve_part1(input: &str) -> String {
    let (directions, map) = parse(input);
    let mut index = 0;
    let mut current = "AAA".to_string();
    let mut steps = 0;
    loop {
        if current == "ZZZ" {
            break;
        }
        steps += 1;
        let (left, right) = map.get(&current).unwrap();
        match &directions[index] {
            Direction::Right => current = right.to_string(),
            Direction::Left => current = left.to_string(),
        }
        index = (index + 1) % directions.len();
    }
    return steps.to_string();
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> (Vec<Direction>, HashMap<String, (String, String)>) {
    let lines = input.lines().collect::<Vec<_>>();
    let directions = parse_directions(lines[0]);
    let mut map: HashMap<String, (String, String)> = HashMap::new();
    for line in &lines[2..] {
        let elements = parse_line(line);
        map.insert(elements.0, elements.1);
    }
    return (directions, map);
}

fn parse_line(line: &str) -> (String, (String, String)) {
    let parts = line.split("=").map(|part| part.trim()).collect::<Vec<_>>();
    let trimmed_tuple_part = &parts[1][1..(parts[1].len() - 1)];
    let tuple = trimmed_tuple_part.split(", ").collect::<Vec<_>>();
    return (
        parts[0].to_string(),
        (tuple[0].to_string(), tuple[1].to_string()),
    );
}

fn parse_directions(input: &str) -> Vec<Direction> {
    return input
        .chars()
        .map(|char| match char {
            'R' => return Direction::Right,
            'L' => return Direction::Left,
            _ => panic!(""),
        })
        .collect();
}

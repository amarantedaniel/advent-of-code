use std::collections::{HashSet, VecDeque};

#[derive(Debug)]
struct ScratchCard {
    index: usize,
    winning_numbers: HashSet<u32>,
    own_numbers: HashSet<u32>,
}

impl ScratchCard {
    fn matches(&self) -> usize {
        return self.winning_numbers.intersection(&self.own_numbers).count();
    }

    fn calculate_points(&self) -> usize {
        let numbers = self.matches();
        if numbers <= 2 {
            return numbers;
        }
        return (1..numbers).fold(1, |acc, _| acc * 2);
    }
}

pub fn solve_part1(input: &str) -> String {
    return parse(input)
        .iter()
        .fold(0, |sum, scratch_card| sum + scratch_card.calculate_points())
        .to_string();
}

pub fn solve_part2(input: &str) -> String {
    let all_scratch_cards = parse(input);
    let mut count = 0;
    let mut scratch_cards = VecDeque::new();

    for i in 0..all_scratch_cards.len() {
        scratch_cards.push_back(&all_scratch_cards[i]);
    }
    while !scratch_cards.is_empty() {
        count += 1;
        let scratch_card = scratch_cards.pop_front().unwrap();
        let matches = scratch_card.matches();
        for i in scratch_card.index..(scratch_card.index + matches) {
            scratch_cards.push_back(&all_scratch_cards[i + 1]);
        }
    }
    return count.to_string();
}

fn parse(input: &str) -> Vec<ScratchCard> {
    return input
        .lines()
        .enumerate()
        .map(|(index, line)| parse_line(index, line))
        .collect();
}

fn parse_line(index: usize, line: &str) -> ScratchCard {
    let parts = line
        .split(":")
        .last()
        .unwrap()
        .split(":")
        .last()
        .unwrap()
        .split("|")
        .map(parse_numbers)
        .collect::<Vec<_>>();
    return ScratchCard {
        index,
        winning_numbers: HashSet::from_iter(parts[0].iter().copied()),
        own_numbers: HashSet::from_iter(parts[1].iter().copied()),
    };
}

fn parse_numbers(part: &str) -> Vec<u32> {
    return part
        .split(" ")
        .filter_map(|number| number.parse::<u32>().ok())
        .collect::<Vec<_>>();
}

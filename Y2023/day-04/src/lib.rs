use std::collections::{HashMap, HashSet};

#[derive(Debug)]
struct ScratchCard {
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
    let scratch_cards = parse(input);
    let mut card_counts: HashMap<usize, u32> = HashMap::new();
    for (i, scratch_card) in scratch_cards.iter().enumerate() {
        *card_counts.entry(i).or_insert(0) += 1;
        let matches = scratch_card.matches();
        for j in (i + 1)..(i + matches + 1) {
            *card_counts.entry(j).or_insert(0) += *card_counts.get(&i).unwrap();
        }
    }
    return card_counts.values().sum::<u32>().to_string();
}

fn parse(input: &str) -> Vec<ScratchCard> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> ScratchCard {
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

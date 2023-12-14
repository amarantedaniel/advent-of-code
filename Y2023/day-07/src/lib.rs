use std::{cmp::Ordering, collections::HashMap};

#[derive(Debug, PartialEq, Eq)]
enum Card {
    Numeric(u64),
    Joker,
}

impl Card {
    fn number(&self) -> u64 {
        match self {
            Card::Numeric(number) => return *number,
            Card::Joker => return 0,
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
struct Hand {
    cards: Vec<Card>,
    bid: u64,
    hand_type: HandType,
}

#[derive(Debug, PartialEq, Eq, Hash)]
enum HandType {
    FiveOfAKind,
    FourOfAKind,
    FullHouse,
    ThreeOfAKind,
    TwoPairs,
    OnePair,
    HighCard,
}

impl Ord for Card {
    fn cmp(&self, other: &Self) -> Ordering {
        return self.number().cmp(&other.number());
    }
}

impl PartialOrd for Card {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.hand_type.cmp(&other.hand_type) {
            Ordering::Equal => {
                for i in 0..5 {
                    let ordering = self.cards[i].cmp(&other.cards[i]);
                    if ordering != Ordering::Equal {
                        return ordering;
                    }
                }
                return Ordering::Equal;
            }
            ordering => return ordering,
        };
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for HandType {
    fn cmp(&self, other: &Self) -> Ordering {
        let order_map = HashMap::from([
            (HandType::FiveOfAKind, 6),
            (HandType::FourOfAKind, 5),
            (HandType::FullHouse, 4),
            (HandType::ThreeOfAKind, 3),
            (HandType::TwoPairs, 2),
            (HandType::OnePair, 1),
            (HandType::HighCard, 0),
        ]);
        order_map.get(self).cmp(&order_map.get(other))
    }
}

impl PartialOrd for HandType {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

pub fn solve_part1(input: &str) -> String {
    let mut hands = parse(input, false);
    return solve(&mut hands).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let mut hands = parse(input, true);
    return solve(&mut hands).to_string();
}

fn solve(hands: &mut Vec<Hand>) -> u64 {
    hands.sort();
    return hands.iter().enumerate().fold(0, |acc, (index, hand)| {
        acc + ((index + 1) as u64) * hand.bid
    });
}

fn parse(input: &str, include_joker: bool) -> Vec<Hand> {
    return input
        .lines()
        .map(|line| parse_line(line, include_joker))
        .collect();
}

fn parse_line(line: &str, include_joker: bool) -> Hand {
    let parts = line.split(" ").collect::<Vec<_>>();
    let cards = parts[0]
        .chars()
        .map(|char| parse_card(char, include_joker))
        .collect::<Vec<_>>();
    let bid = parts[1].parse::<u64>().unwrap();
    let hand_type = check_hand_type(&cards);
    return Hand {
        cards,
        bid,
        hand_type,
    };
}

fn parse_card(char: char, include_joker: bool) -> Card {
    if let Some(number) = char.to_digit(10) {
        return Card::Numeric(number.into());
    }
    match char {
        'T' => return Card::Numeric(10),
        'J' => {
            return if include_joker {
                Card::Joker
            } else {
                Card::Numeric(11)
            }
        }
        'Q' => return Card::Numeric(12),
        'K' => return Card::Numeric(13),
        'A' => return Card::Numeric(14),
        _ => panic!(""),
    }
}

fn check_hand_type(cards: &Vec<Card>) -> HandType {
    let mut hash_map: HashMap<u64, u64> = HashMap::new();
    let mut joker_count = 0;
    for card in cards {
        match card {
            Card::Numeric(number) => *hash_map.entry(*number).or_insert(0) += 1,
            Card::Joker => joker_count += 1,
        }
    }
    let mut values = hash_map.values().copied().collect::<Vec<_>>();
    let length = values.len();
    if length == 0 {
        return HandType::FiveOfAKind;
    }
    values.sort();
    values[length - 1] += joker_count;
    match values.as_slice() {
        [5] => return HandType::FiveOfAKind,
        [1, 4] => return HandType::FourOfAKind,
        [2, 3] => return HandType::FullHouse,
        [1, 1, 3] => return HandType::ThreeOfAKind,
        [1, 2, 2] => return HandType::TwoPairs,
        [1, 1, 1, 2] => return HandType::OnePair,
        _ => return HandType::HighCard,
    }
}

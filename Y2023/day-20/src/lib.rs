use num::integer::lcm;
use std::collections::{HashMap, VecDeque};

#[derive(Debug, Clone, Copy, Eq, PartialEq)]
enum Signal {
    High,
    Low,
}

impl Signal {
    fn flip(&self) -> Signal {
        match self {
            Signal::High => Signal::Low,
            Signal::Low => Signal::High,
        }
    }
}

#[derive(Debug, Clone)]
struct Module {
    id: String,
    module_type: ModuleType,
    destinations: Vec<String>,
}

#[derive(Debug, Clone)]
enum ModuleType {
    Broadcaster,
    FlipFlop {
        state: Signal,
    },
    Conjunction {
        most_recents: HashMap<String, Signal>,
    },
}

pub fn solve_part1(input: &str) -> String {
    let mut map = parse(input);
    let mut low_pulses_sum = 0;
    let mut high_pulses_sum = 0;
    for _ in 0..1000 {
        let (low_pulses, high_pulses) = solve(&mut map);
        low_pulses_sum += low_pulses;
        high_pulses_sum += high_pulses;
    }
    return (low_pulses_sum * high_pulses_sum).to_string();
}

fn solve(map: &mut HashMap<String, Module>) -> (u64, u64) {
    let broadcaster = map.get(&"broadcaster".to_string()).unwrap();
    let mut queue: VecDeque<(String, Signal, String)> = VecDeque::new();
    queue.push_back(("".to_string(), Signal::Low, broadcaster.id.to_string()));
    let mut high_pulses = 0;
    let mut low_pulses = 0;
    while let Some((prev_id, signal, module_id)) = queue.pop_front() {
        match signal {
            Signal::High => high_pulses += 1,
            Signal::Low => low_pulses += 1,
        };
        // println!("{} -{:?}-> {:?}", prev_id, signal, module_id);
        if let Some(module) = map.get_mut(&module_id) {
            match module.module_type.clone() {
                ModuleType::Broadcaster => {
                    for destination_id in &module.destinations {
                        queue.push_back((module_id.to_string(), signal, destination_id.clone()));
                    }
                }
                ModuleType::FlipFlop { state } => {
                    if signal == Signal::Low {
                        module.module_type = ModuleType::FlipFlop {
                            state: state.flip(),
                        };
                        for destination_id in &module.destinations {
                            queue.push_back((
                                module_id.to_string(),
                                state.flip(),
                                destination_id.clone(),
                            ));
                        }
                    }
                }
                ModuleType::Conjunction { most_recents } => {
                    let mut most_recents = most_recents;
                    most_recents.insert(prev_id, signal);
                    let signal = if all_are_high(&most_recents) {
                        Signal::Low
                    } else {
                        Signal::High
                    };
                    module.module_type = ModuleType::Conjunction { most_recents };
                    for destination_id in &module.destinations {
                        queue.push_back((module_id.to_string(), signal, destination_id.clone()));
                    }
                }
            }
        }
    }
    return (low_pulses, high_pulses);
}

fn all_are_high(signals: &HashMap<String, Signal>) -> bool {
    signals.iter().all(|(_, signal)| signal == &Signal::High)
}

pub fn solve_part2(input: &str) -> String {
    let lk = get_button_count_for("lk".to_string(), input);
    let zv = get_button_count_for("zv".to_string(), input);
    let sp = get_button_count_for("sp".to_string(), input);
    let xt = get_button_count_for("xt".to_string(), input);
    return lcm(lk, lcm(zv, lcm(sp, xt))).to_string();
}

fn get_button_count_for(magic_id: String, input: &str) -> u64 {
    let mut map = parse(input);
    for i in 1..u64::MAX {
        if solve2(magic_id.to_string(), &mut map) {
            return i;
        }
    }
    panic!()
}

fn solve2(magic_id: String, map: &mut HashMap<String, Module>) -> bool {
    let broadcaster = map.get(&"broadcaster".to_string()).unwrap();
    let mut queue: VecDeque<(String, Signal, String)> = VecDeque::new();
    queue.push_back(("".to_string(), Signal::Low, broadcaster.id.to_string()));

    while let Some((prev_id, signal, module_id)) = queue.pop_front() {
        if module_id == magic_id && signal == Signal::Low {
            return true;
        }

        if let Some(module) = map.get_mut(&module_id) {
            match module.module_type.clone() {
                ModuleType::Broadcaster => {
                    for destination_id in &module.destinations {
                        queue.push_back((module_id.to_string(), signal, destination_id.clone()));
                    }
                }
                ModuleType::FlipFlop { state } => {
                    if signal == Signal::Low {
                        module.module_type = ModuleType::FlipFlop {
                            state: state.flip(),
                        };
                        for destination_id in &module.destinations {
                            queue.push_back((
                                module_id.to_string(),
                                state.flip(),
                                destination_id.clone(),
                            ));
                        }
                    }
                }
                ModuleType::Conjunction { most_recents } => {
                    let mut most_recents = most_recents;
                    most_recents.insert(prev_id, signal);
                    let signal = if all_are_high(&most_recents) {
                        Signal::Low
                    } else {
                        Signal::High
                    };
                    module.module_type = ModuleType::Conjunction { most_recents };
                    for destination_id in &module.destinations {
                        queue.push_back((module_id.to_string(), signal, destination_id.clone()));
                    }
                }
            }
        }
    }
    return false;
}

fn parse(input: &str) -> HashMap<String, Module> {
    let modules: Vec<(String, Module)> = input.lines().map(parse_line).collect();
    let mut map: HashMap<String, Module> = input.lines().map(parse_line).collect();
    for (id, module) in &modules {
        for neighboor_id in &module.destinations {
            if let Some(module) = map.get_mut(neighboor_id) {
                if let ModuleType::Conjunction {
                    ref mut most_recents,
                } = module.module_type
                {
                    most_recents.insert(id.to_string(), Signal::Low);
                }
            }
        }
    }
    return map;
}

fn parse_line(input: &str) -> (String, Module) {
    let parts = input.split(" -> ").collect::<Vec<_>>();
    let destinations = parts[1]
        .split(", ")
        .map(|s| s.to_string())
        .collect::<Vec<_>>();
    if parts[0] == "broadcaster" {
        return (
            parts[0].to_string(),
            Module {
                id: parts[0].to_string(),
                module_type: ModuleType::Broadcaster,
                destinations,
            },
        );
    }
    if parts[0].starts_with("%") {
        return (
            parts[0][1..].to_string(),
            Module {
                id: parts[0][1..].to_string(),
                module_type: ModuleType::FlipFlop { state: Signal::Low },
                destinations,
            },
        );
    }
    if parts[0].starts_with("&") {
        return (
            parts[0][1..].to_string(),
            Module {
                id: parts[0][1..].to_string(),
                module_type: ModuleType::Conjunction {
                    most_recents: HashMap::new(),
                },
                destinations,
            },
        );
    }
    panic!()
}

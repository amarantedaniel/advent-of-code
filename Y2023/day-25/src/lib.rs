use std::collections::{HashMap, HashSet, VecDeque};

pub fn solve_part1(input: &str) -> String {
    let graph = parse(input);
    return count_islands(&graph).to_string();
}

fn count_islands(graph: &HashMap<String, HashSet<String>>) -> u64 {
    let mut unvisited_nodes = graph.keys().collect::<HashSet<_>>();
    let mut result = 0;

    while !unvisited_nodes.is_empty() {
        let start_node = unvisited_nodes.iter().next().unwrap();
        result += 1;
        let mut queue: VecDeque<&String> = VecDeque::new();
        queue.push_back(start_node);
        while let Some(node) = queue.pop_front() {
            unvisited_nodes.remove(node);
            for neighboor in graph.get(node).unwrap() {
                if unvisited_nodes.contains(neighboor) {
                    queue.push_back(neighboor);
                }
            }
        }
    }
    return result;
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> HashMap<String, HashSet<String>> {
    let mut result: HashMap<String, HashSet<String>> = HashMap::new();
    for line in input.lines() {
        let parts = line.split(": ").collect::<Vec<_>>();
        let node = parts[0].to_string();
        let neighboors: HashSet<_> = parts[1].split(" ").map(|s| s.trim().to_string()).collect();
        result.insert(node.clone(), neighboors.clone());
        for neighboor in &neighboors {
            result
                .entry(neighboor.to_string())
                .or_insert_with(HashSet::new)
                .insert(node.clone());
        }
    }
    return result;
}

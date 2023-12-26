#[derive(Debug)]
enum Operation {
    Add(Lens),
    Remove(String),
}

#[derive(Debug, Clone)]
struct Lens {
    label: String,
    value: u64,
}

pub fn solve_part1(input: &str) -> String {
    return parse(input)
        .iter()
        .fold(0, |acc, word| acc + calculate_hash(word))
        .to_string();
}

fn calculate_hash(string: &str) -> usize {
    let mut current_value = 0;
    for character in string.chars() {
        current_value += character as usize;
        current_value *= 17;
        current_value %= 256;
    }
    return current_value;
}

pub fn solve_part2(input: &str) -> String {
    let operations = parse_operations(input);
    let boxes = execute_operations(operations);
    let mut result = 0;
    for box_index in 0..boxes.len() {
        for (slot_index, lens) in boxes[box_index].iter().enumerate() {
            result += (box_index as u64 + 1) * (slot_index as u64 + 1) * lens.value;
        }
    }
    return result.to_string();
}

fn execute_operations(operations: Vec<Operation>) -> Vec<Vec<Lens>> {
    let mut boxes: Vec<Vec<Lens>> = vec![Vec::new(); 256];
    for operation in operations {
        match operation {
            Operation::Add(lens) => {
                let box_number = calculate_hash(&lens.label);
                if let Some(index) = find_index(box_number, &lens.label, &boxes) {
                    boxes[box_number][index] = lens;
                } else {
                    boxes[box_number].push(lens);
                }
            }
            Operation::Remove(label) => {
                let box_number = calculate_hash(&label);
                if let Some(index) = find_index(box_number, &label, &boxes) {
                    boxes[box_number].remove(index);
                }
            }
        }
    }
    return boxes;
}

fn find_index(box_number: usize, label: &String, boxes: &Vec<Vec<Lens>>) -> Option<usize> {
    return boxes[box_number]
        .iter()
        .position(|lens| &lens.label == label);
}

fn parse(input: &str) -> Vec<&str> {
    return input.split(",").collect();
}

fn parse_operations(input: &str) -> Vec<Operation> {
    return input.split(",").map(parse_operation).collect();
}

fn parse_operation(input: &str) -> Operation {
    if input.contains("-") {
        let parts = input.split("-").collect::<Vec<_>>();
        return Operation::Remove(parts[0].to_string());
    }
    let parts = input.split("=").collect::<Vec<_>>();
    return Operation::Add(Lens {
        label: parts[0].to_string(),
        value: parts[1].parse().unwrap(),
    });
}

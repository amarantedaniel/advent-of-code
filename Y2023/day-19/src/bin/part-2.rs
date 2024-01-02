use day_01::solve_part2;
use std::fs;

fn main() {
    let file = fs::read_to_string("./input.txt").unwrap();
    println!("{}", solve_part2(&file));
}

#[derive(Clone, Copy, Eq, PartialEq)]
enum Space {
    Empty,
    Galaxy,
}

pub fn solve_part1(input: &str) -> String {
    let galaxies = parse(input);
    return solve(&galaxies, 1).to_string();
}

pub fn solve_part2(input: &str) -> String {
    let galaxies = parse(input);
    return solve(&galaxies, 999999).to_string();
}

fn solve(galaxies: &Vec<Vec<Space>>, expansion_size: i64) -> i64 {
    let coordinates = get_coordinates(&galaxies, expansion_size);
    let mut result = 0;
    for i in 0..coordinates.len() {
        for j in i..coordinates.len() {
            result += get_distance(coordinates[i], coordinates[j]);
        }
    }
    return result;
}

fn get_coordinates(galaxies: &Vec<Vec<Space>>, expansion_size: i64) -> Vec<(i64, i64)> {
    let (empty_rows, empty_columns) = find_expansion_indexes(galaxies);
    let mut coordinates: Vec<(i64, i64)> = Vec::new();
    let mut extra_rows = 0;
    let mut extra_columns = 0;
    for (i, row) in galaxies.iter().enumerate() {
        if empty_rows.contains(&i) {
            extra_rows += expansion_size;
        }
        for (j, space) in row.iter().enumerate() {
            if empty_columns.contains(&j) {
                extra_columns += expansion_size;
            }
            if space == &Space::Galaxy {
                coordinates.push((i as i64 + extra_rows, j as i64 + extra_columns));
            }
        }
        extra_columns = 0;
    }
    return coordinates;
}

fn find_expansion_indexes(galaxies: &Vec<Vec<Space>>) -> (Vec<usize>, Vec<usize>) {
    let mut empty_rows: Vec<usize> = Vec::new();
    let mut empty_columns: Vec<usize> = Vec::new();
    for i in 0..galaxies.len() {
        if galaxies[i].iter().all(|space| space == &Space::Empty) {
            empty_rows.push(i);
        }
    }

    'outer: for j in 0..galaxies[0].len() {
        for i in 0..galaxies.len() {
            if galaxies[i][j] != Space::Empty {
                continue 'outer;
            }
        }

        empty_columns.push(j);
    }
    return (empty_rows, empty_columns);
}

fn get_distance(from: (i64, i64), to: (i64, i64)) -> i64 {
    return (from.0 - to.0).abs() + (from.1 - to.1).abs();
}

fn parse(input: &str) -> Vec<Vec<Space>> {
    return input.lines().map(parse_line).collect();
}

fn parse_line(line: &str) -> Vec<Space> {
    return line
        .chars()
        .map(|char| match char {
            '#' => return Space::Galaxy,
            _ => return Space::Empty,
        })
        .collect();
}

use std::ops::RangeInclusive;

#[derive(Debug, Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}

#[derive(Debug, Clone, Copy)]
struct Hailstone {
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
}

impl Hailstone {
    fn point_pair(&self) -> (Point, Point) {
        let p1 = Point {
            x: self.x,
            y: self.y,
        };
        let p2 = Point {
            x: self.x + self.dx,
            y: self.y + self.dy,
        };
        return (p1, p2);
    }
}

#[derive(Debug, Clone, Copy)]
struct Equation {
    slope: f64,
    y_intercept: f64,
}

impl Equation {
    fn from(p1: Point, p2: Point) -> Equation {
        let slope = (p2.y - p1.y) / (p2.x - p1.x);
        let y_intercept = p1.y + (-1.0 * (slope * p1.x));
        return Equation { slope, y_intercept };
    }
}

pub fn solve_part1(input: &str) -> String {
    let hailstones = parse(input);
    let test_area = 200000000000000.0..=400000000000000.0;
    let mut count = 0;
    for i in 0..(hailstones.len() - 1) {
        for j in (i + 1)..hailstones.len() {
            if has_intersection_in_future(&hailstones[i], &hailstones[j], &test_area) {
                count += 1;
            }
        }
    }
    return count.to_string();
}

fn has_intersection_in_future(
    hailstone1: &Hailstone,
    hailstone2: &Hailstone,
    test_area: &RangeInclusive<f64>,
) -> bool {
    let (p1, p2) = hailstone1.point_pair();
    let (p3, p4) = hailstone2.point_pair();
    let equation1 = Equation::from(p1, p2);
    let equation2 = Equation::from(p3, p4);
    let intersection_point = get_intersection_point(equation1, equation2);
    let is_in_test_area =
        test_area.contains(&intersection_point.x) && test_area.contains(&intersection_point.y);
    let is_in_future = is_intersection_in_future(p1, p2, intersection_point)
        && is_intersection_in_future(p3, p4, intersection_point);
    return is_in_test_area && is_in_future;
}

fn get_intersection_point(eq1: Equation, eq2: Equation) -> Point {
    let x = (eq2.y_intercept - eq1.y_intercept) / (eq1.slope - eq2.slope);
    let y = x * eq1.slope + eq1.y_intercept;
    return Point { x, y };
}

fn is_intersection_in_future(p1: Point, p2: Point, intersection: Point) -> bool {
    return (f64::min(p1.x, intersection.x)..=f64::max(p1.x, intersection.x)).contains(&p2.x)
        && (f64::min(p1.y, intersection.y)..=f64::max(p1.y, intersection.y)).contains(&p2.y);
}

pub fn solve_part2(input: &str) -> String {
    return input.to_string();
}

fn parse(input: &str) -> Vec<Hailstone> {
    input.lines().map(parse_line).collect()
}

fn parse_line(line: &str) -> Hailstone {
    let parts = line.split(" @ ").collect::<Vec<_>>();
    let position_parts = parse_numbers(parts[0]);
    let velocity_parts = parse_numbers(parts[1]);
    return Hailstone {
        x: position_parts[0],
        y: position_parts[1],
        dx: velocity_parts[0],
        dy: velocity_parts[1],
    };
}

fn parse_numbers(line: &str) -> Vec<f64> {
    line.split(", ")
        .filter_map(|element| element.trim().parse().ok())
        .collect()
}

import AdventOfCode

struct Size { let width: Int; let height: Int }
struct Point: Equatable, Hashable { let x: Int; let y: Int }

struct Robot {
    let position: Point
    let velocity: Point

    func move(size: Size) -> Robot {
        return Robot(
            position: Point(
                x: (position.x + velocity.x + size.width) % size.width,
                y: (position.y + velocity.y + size.height) % size.height
            ),
            velocity: velocity
        )
    }
}

struct Day14: AdventDay {
    private func parse(input: String) -> [Robot] {
        let regex = #/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/#
        return input.matches(of: regex).map { match in
            Robot(
                position: Point(x: Int(match.output.1)!, y: Int(match.output.2)!),
                velocity: Point(x: Int(match.output.3)!, y: Int(match.output.4)!)
            )
        }
    }

    private func countQuadrants(robots: [Robot], size: Size) -> Int {
        var a = 0
        var b = 0
        var c = 0
        var d = 0

        for robot in robots {
            if robot.position.x < size.width / 2 && robot.position.y < size.height / 2 {
                a += 1
            }
            if robot.position.x < size.width / 2 && robot.position.y > size.height / 2 {
                b += 1
            }
            if robot.position.x > size.width / 2 && robot.position.y < size.height / 2 {
                c += 1
            }
            if robot.position.x > size.width / 2 && robot.position.y > size.height / 2 {
                d += 1
            }
        }
        return a * b * c * d
    }

    private func hasDuplicates(robots: [Robot]) -> Bool {
        var points: Set<Point> = []
        for robot in robots {
            if points.contains(robot.position) {
                return true
            }
            points.insert(robot.position)
        }
        return false
    }

    func part1(input: String) throws -> Int {
        let size = Size(width: 101, height: 103)
        var robots = parse(input: input)

        for _ in 0..<100 {
            robots = robots.map { robot in
                robot.move(size: size)
            }
        }

        return countQuadrants(robots: robots, size: size)
    }

    func part2(input: String) throws -> Int {
        let size = Size(width: 101, height: 103)
        var robots = parse(input: input)

        for i in 1..<Int.max {
            robots = robots.map { robot in
                robot.move(size: size)
            }
            if !hasDuplicates(robots: robots) {
                return i
            }
        }
        fatalError()
    }
}

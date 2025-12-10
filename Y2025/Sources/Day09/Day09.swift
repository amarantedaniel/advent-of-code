import AdventOfCode

struct Point: Equatable { let x, y: Int }

struct HorizontalLine: Equatable {
    let x1, x2, y: Int
}

struct VerticalLine: Equatable {
    let x, y1, y2: Int
}

struct Day09: AdventDay {
    func part1(input: String) throws -> Int {
        let tiles = input.split(separator: "\n")
            .map { $0.split(separator: ",") }
            .map { Point(x: Int($0[0])!, y: Int($0[1])!) }
        var result = 0
        for t1 in tiles {
            for t2 in tiles where t1 != t2 {
                let sidex = abs(t1.x - t2.x) + 1
                let sidey = abs(t1.y - t2.y) + 1
                let area = sidex * sidey
                result = max(area, result)
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let points = input.split(separator: "\n")
            .map { $0.split(separator: ",") }
            .map { Point(x: Int($0[0])!, y: Int($0[1])!) }
        var hLines: [HorizontalLine] = []
        var vLines: [VerticalLine] = []
        for i in 0..<points.count {
            let start = points[i]
            let destination = points[(i + 1) % points.count]
            if start.x == destination.x {
                vLines.append(.init(x: start.x, y1: start.y, y2: destination.y))
            } else if start.y == destination.y {
                hLines.append(.init(x1: start.x, x2: destination.x, y: start.y))
            } else {
                fatalError()
            }
        }
        var result = 0
        let p1 = Point(x: 2, y: 5)
        let p3 = Point(x: 11, y: 1)
//        for p1 in points {
//            for p3 in points where p1 != p3 {
        let p2 = Point(x: p1.x, y: p3.y)
        let p4 = Point(x: p3.x, y: p1.y)
        let l1 = VerticalLine(x: p1.x, y1: p1.y, y2: p2.y)
        let l2 = HorizontalLine(x1: p2.x, x2: p3.x, y: p2.y)
        let l3 = VerticalLine(x: p3.x, y1: p3.y, y2: p4.y)
        let l4 = HorizontalLine(x1: p4.x, x2: p1.x, y: p4.y)
        var crossed = false
        for line in vLines {
            if isCrossing(vl: line, hl: l2) {
                crossed = true
            }
            if isCrossing(vl: line, hl: l4) {
                crossed = true
            }
        }
        for line in hLines {
            if isCrossing(vl: l1, hl: line) {
                crossed = true
            }
            if isCrossing(vl: l3, hl: line) {
                crossed = true
            }
        }
        if !crossed {
            let sidex = abs(p1.x - p3.x) + 1
            let sidey = abs(p1.y - p3.y) + 1
            let area = sidex * sidey
            result = max(area, result)
        }
//            }
//        }
        return result
    }

    private func isCrossing(vl: VerticalLine, hl: HorizontalLine) -> Bool {
        min(vl.y1, vl.y2) < hl.y
            && max(vl.y1, vl.y2) > hl.y
            && min(hl.x1, hl.x2) < vl.x
            && max(hl.x1, hl.x2) > vl.x
    }
}

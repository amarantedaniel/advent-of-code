import Foundation

typealias BeaconDistance = (Int, Int, Int)

extension Array where Element == BeaconDistance {
    func contains(other: BeaconDistance) -> Bool {
        return contains { $0 == other }
    }
}

func == (lhs: BeaconDistance, rhs: BeaconDistance) -> Bool {
    for axis in [lhs.0, lhs.1, lhs.2] {
        if ![rhs.0, rhs.1, rhs.2].contains(axis) { return false }
    }
    return true
}

struct Scanner: Equatable {
    let beacons: [Beacon]
}

struct Vector {
    let x: Int
    let y: Int
    let z: Int
}

struct Beacon: Hashable, Equatable, CustomStringConvertible {
    let x: Int
    let y: Int
    let z: Int

    func distance(from beacon: Beacon) -> BeaconDistance {
        return (abs(self.x - beacon.x), abs(self.y - beacon.y), abs(self.z - beacon.z))
    }

    static func - (lhs: Beacon, rhs: Beacon) -> Beacon {
        return Beacon(x: lhs.x - rhs.x, y: lhs.y - lhs.x - rhs.y, z: lhs.z - rhs.z)
    }

    func rotated(index: Int) -> Beacon {
        return rotations()[index]
    }

    func rotations() -> [Beacon] {
        return [
            Beacon(x: x, y: y, z: z),
            Beacon(x: x, y: -y, z: -z),
            Beacon(x: x, y: z, z: -y),
            Beacon(x: x, y: -z, z: y),
            Beacon(x: -x, y: y, z: -z),
            Beacon(x: -x, y: -y, z: z),
            Beacon(x: -x, y: z, z: y),
            Beacon(x: -x, y: -z, z: -y),
            Beacon(x: y, y: x, z: -z),
            Beacon(x: y, y: -x, z: z),
            Beacon(x: y, y: z, z: x),
            Beacon(x: y, y: -z, z: -x),
            Beacon(x: -y, y: x, z: z),
            Beacon(x: -y, y: -x, z: -z),
            Beacon(x: -y, y: z, z: -x),
            Beacon(x: -y, y: -z, z: x),
            Beacon(x: z, y: y, z: -x),
            Beacon(x: z, y: -y, z: x),
            Beacon(x: z, y: x, z: y),
            Beacon(x: z, y: -x, z: -y),
            Beacon(x: -z, y: x, z: -y),
            Beacon(x: -z, y: -x, z: y),
            Beacon(x: -z, y: y, z: x),
            Beacon(x: -z, y: -y, z: -x),
        ]
    }

    func applyVector(vector: Vector) -> Beacon {
        return Beacon(x: x + vector.x, y: y + vector.y, z: z + vector.z)
    }

    var description: String {
        "\(x),\(y),\(z)"
    }
}

private func getDistances(from beacon: Beacon, in scanner: Scanner) -> [BeaconDistance] {
    scanner
        .beacons
        .filter { $0 != beacon }
        .map(beacon.distance(from:))
}

private func findSameBeacon(beacon: Beacon, from scanner: Scanner, in otherScanner: Scanner) -> Beacon? {
    let distances = getDistances(from: beacon, in: scanner)
    for beaconA in otherScanner.beacons {
        var count = 0
        for beaconB in otherScanner.beacons where beaconA != beaconB {
            let distance = beaconA.distance(from: beaconB)
            if distances.contains(other: distance) {
                count += 1
            }
        }
        if count == 11 {
            return beaconA
        }
    }
    return nil
}

func getVector(from beaconA: Beacon, to beaconB: Beacon) -> Vector {
    Vector(x: beaconB.x - beaconA.x, y: beaconB.y - beaconA.y, z: beaconB.z - beaconA.z)
}

func getVectors(between beacons: [Beacon]) -> [Vector] {
    var vectors: [Vector] = []
    for i in 1..<beacons.count {
        vectors.append(getVector(from: beacons[i - 1], to: beacons[i]))
    }
    return vectors
}

func doStuff(scanner: Scanner, otherScanner: Scanner) {
    var beaconPairs: [(Beacon, Beacon)] = []
    for beacon in scanner.beacons {
        let otherBeacon = findSameBeacon(beacon: beacon, from: scanner, in: otherScanner)
        if let otherBeacon = otherBeacon {
            beaconPairs.append((beacon, otherBeacon))
        }
    }
    let vectors = getVectors(between: beaconPairs.map(\.0))
    var rotation: Int = -1
    for (index, (rotationA, rotationB)) in zip(beaconPairs[0].1.rotations(), beaconPairs[1].1.rotations()).enumerated() {
        if rotationA.applyVector(vector: vectors[0]) == rotationB {
            rotation = index
        }
    }

    let originalBeacons = beaconPairs.map(\.0)
    let rotatedBeacons = beaconPairs.map(\.1).map { $0.rotated(index: rotation) }
    let vector = getVector(from: rotatedBeacons[0], to: originalBeacons[0])
    let otherBeacons = otherScanner
        .beacons
        .map { $0.rotated(index: rotation) }
        .map { $0.applyVector(vector: vector) }
    print(otherBeacons)
}

func solve1(input: String) -> Int {
    let scanners = Parser.parse(input: input)
    doStuff(scanner: scanners[0], otherScanner: scanners[1])
    return 0
}

func solve2(input _: String) -> Int {
    return 0
}

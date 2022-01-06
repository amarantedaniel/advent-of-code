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

private func getDistances(from beacon: Beacon, in beacons: [Beacon]) -> [BeaconDistance] {
    beacons
        .filter { $0 != beacon }
        .map(beacon.distance(from:))
}

private func findSameBeacon(beacon: Beacon, from beacons: [Beacon], in otherBeacons: [Beacon]) -> Beacon? {
    let distances = getDistances(from: beacon, in: beacons)
    for beaconA in otherBeacons {
        var count = 0
        for beaconB in otherBeacons where beaconA != beaconB {
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

private func findPairs(beacons: [Beacon], otherBeacons: [Beacon]) -> [(Beacon, Beacon)] {
    var beaconPairs: [(Beacon, Beacon)] = []
    for beacon in beacons {
        let otherBeacon = findSameBeacon(beacon: beacon, from: beacons, in: otherBeacons)
        if let otherBeacon = otherBeacon {
            beaconPairs.append((beacon, otherBeacon))
            if beaconPairs.count == 2 {
                return beaconPairs
            }
        }
    }
    return beaconPairs
}

func findRotation(pairs: [(Beacon, Beacon)]) -> Int {
    let vectors = getVectors(between: pairs.map(\.0))
    for (index, (rotationA, rotationB)) in zip(pairs[0].1.rotations(), pairs[1].1.rotations()).enumerated() {
        if rotationA.applyVector(vector: vectors[0]) == rotationB {
            return index
        }
    }
    fatalError()
}

func normalize(beacons: [Beacon], rotation: Int, vector: Vector) -> [Beacon] {
    return beacons
    .map { $0.rotated(index: rotation) }
    .map { $0.applyVector(vector: vector) }
}

func doStuff(beacons: [Beacon], otherBeacons: [Beacon]) -> [Beacon]? {
    let beaconPairs = findPairs(beacons: beacons, otherBeacons: otherBeacons)
    if beaconPairs.isEmpty { return nil }
    let rotation = findRotation(pairs: beaconPairs)
    let vector = getVector(from: beaconPairs[0].1.rotated(index: rotation), to: beaconPairs[0].0)
    let normalizedBeacons = normalize(beacons: otherBeacons, rotation: rotation, vector: vector)
    return Array(Set(beacons).union(normalizedBeacons))
}

func solve1(input: String) -> Int {
    let scanners = Parser.parse(input: input)
    var beacons = scanners[0].beacons
    var pending = Array(scanners.dropFirst())
    while !pending.isEmpty {
        var aux: [Scanner] = []
        for i in 0..<pending.count {
            if let b = doStuff(beacons: beacons, otherBeacons: pending[i].beacons) {
                beacons = b
            } else {
                aux.append(pending[i])
            }
            print("beacons: \(beacons.count)")
            print("i: \(i)")
        }
        pending = aux
        print("pending: \(pending.count)")
    }

    return beacons.count
}

func solve2(input _: String) -> Int {
    return 0
}

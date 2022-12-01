import Foundation
import Shared

extension Array {
    func inserting(_ element: Element, at index: Int) -> Array {
        var array = self
        array[index] = element
        return array
    }

    func appending(_ element: Element) -> Array {
        var array = self
        array.append(element)
        return array
    }

    func removing<T>(index: Int) -> [T?] where Element == T? {
        var array = self
        array[index] = nil
        return array
    }
}

struct Map: Hashable {
    let roomSize: Int
    var hallway: [Amphipod?]
    var room0: [Amphipod]
    var room1: [Amphipod]
    var room2: [Amphipod]
    var room3: [Amphipod]

    private let skipIndexes = [2, 4, 6, 8]

    private let keyPaths = [\Map.room0, \Map.room1, \Map.room2, \Map.room3]

    func legalMoves() -> [(Map, Int)] {
        var moves: [(Map, Int)] = []
        for keyPath in keyPaths where canRemove(keyPath: keyPath) {
            moves.append(contentsOf: moveFromRoomToHallway(keyPath: keyPath))
        }
        moves.append(contentsOf: moveFromHallwayToRoom())
        return moves
    }

    private func moveFromRoomToHallway(keyPath: WritableKeyPath<Map, [Amphipod]>) -> [(Map, Int)] {
        var maps: [(Map, Int)] = []
        let room = self[keyPath: keyPath]
        let amphipod = room.last!
        let remaining = room.dropLast()
        let map = self.updating(keyPath: keyPath, value: Array(remaining))
        for i in availableHallwaySlots(from: keyPath) {
            let energy = ((roomSize - remaining.count) + abs(index(keyPath: keyPath) - i)) * amphipod.energy
            maps.append((map.updating(keyPath: \.hallway, value: hallway.inserting(amphipod, at: i)), energy))
        }
        return maps
    }

    private func availableHallwaySlots(from keyPath: KeyPath<Map, [Amphipod]>) -> [Int] {
        var indexes: [Int] = []
        let initial = index(keyPath: keyPath)
        for index in (initial + 1)..<hallway.count where !skipIndexes.contains(index) {
            if hallway[index] != nil {
                break
            }
            indexes.append(index)
        }
        for index in stride(from: initial - 1, to: -1, by: -1) where !skipIndexes.contains(index) {
            if hallway[index] != nil {
                break
            }
            indexes.append(index)
        }
        return indexes
    }

    private func moveFromHallwayToRoom() -> [(Map, Int)] {
        var maps: [(Map, Int)] = []
        for i in 0..<hallway.count where hallway[i] != nil {
            let amphipod = hallway[i]!
            let goal = index(keyPath: amphipod.room)
            let range = i > goal ? goal...(i - 1) : (i + 1)...goal
            let canGo = hallway[range].allSatisfy { $0 == nil } && canEnter(keyPath: amphipod.room)
            if canGo {
                let map = self
                    .updating(keyPath: \.hallway, value: hallway.removing(index: i))
                    .updating(keyPath: amphipod.room, value: self[keyPath: amphipod.room].appending(amphipod))
                let energy = ((roomSize - self[keyPath: amphipod.room].count) + range.count) * amphipod.energy
                maps.append((map, energy))
            }
        }
        return maps
    }

    private func canEnter(keyPath: KeyPath<Map, [Amphipod]>) -> Bool {
        let room = self[keyPath: keyPath]
        return room.count < roomSize && room.allSatisfy { $0.room == keyPath }
    }

    private func canRemove(keyPath: KeyPath<Map, [Amphipod]>) -> Bool {
        !self[keyPath: keyPath].allSatisfy { $0.room == keyPath }
    }

    private func index(keyPath: KeyPath<Map, [Amphipod]>) -> Int {
        switch keyPath {
        case \.room0: return 2
        case \.room1: return 4
        case \.room2: return 6
        case \.room3: return 8
        default: fatalError()
        }
    }

    private func updating<T>(keyPath: WritableKeyPath<Map, T>, value: T) -> Map {
        var map = self
        map[keyPath: keyPath] = value
        return map
    }

    func isCorrect() -> Bool {
        return hallway.allSatisfy { $0 == nil } &&
            room0.allSatisfy { $0 == .amber } &&
            room1.allSatisfy { $0 == .bronze } &&
            room2.allSatisfy { $0 == .copper } &&
            room3.allSatisfy { $0 == .desert }
    }

    func heuristic() -> Int {
        // TODO: change to energy required to find room
        let a = room0.filter { $0 != .amber }.map(\.energy).reduce(0, +)
        let b = room1.filter { $0 != .bronze }.map(\.energy).reduce(0, +)
        let c = room2.filter { $0 != .copper }.map(\.energy).reduce(0, +)
        let d = room3.filter { $0 != .desert }.map(\.energy).reduce(0, +)
        let e = hallway.compactMap(\ .?.energy).reduce(0, +)
        return a + b + c + d + e
    }
}

enum Amphipod: Character {
    case amber = "A"
    case bronze = "B"
    case copper = "C"
    case desert = "D"

    var energy: Int {
        switch self {
        case .amber: return 1
        case .bronze: return 10
        case .copper: return 100
        case .desert: return 1000
        }
    }

    var room: WritableKeyPath<Map, [Amphipod]> {
        switch self {
        case .amber: return \.room0
        case .bronze: return \.room1
        case .copper: return \.room2
        case .desert: return \.room3
        }
    }
}

func getMinimumEnergy(map: Map) -> Int {
    var visited: Set<Map> = []
    var g: [Map: Int] = [map: 0]
    var heap = Heap<Map, Int>(priority: <)
    heap.insert(map, priority: map.heuristic())

    while !heap.isEmpty {
        let current = heap.extract()!
        if current.isCorrect() {
            return g[current]!
        }
        visited.insert(current)
        for (move, energy) in current.legalMoves() where !visited.contains(move) {
            let gScore = g[current]! + energy
            if gScore < (g[move] ?? Int.max) {
                g[move] = gScore
                heap.insert(move, priority: gScore + move.heuristic())
            }
        }
    }
    fatalError()
}

func solve1(input: String) -> Int {
    let map = Parser.parse(input: input, roomSize: 2)
    return getMinimumEnergy(map: map)
}

func solve2(input: String) -> Int {
    let map = Parser.parse(input: input, roomSize: 4)
    return getMinimumEnergy(map: map)
}

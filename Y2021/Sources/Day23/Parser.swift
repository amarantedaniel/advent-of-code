import Foundation

enum Parser {
    static func parse(input: String, roomSize: Int) -> Map {
        let lines = input.split(separator: "\n")
        let rooms = createRooms(lines: lines[2..<(2 + roomSize)])
        return Map(
            roomSize: roomSize,
            hallway: Array(repeating: nil, count: 11),
            room0: rooms.0,
            room1: rooms.1,
            room2: rooms.2,
            room3: rooms.3
        )
    }

    private static func createRooms(lines: ArraySlice<Substring>) -> ([Amphipod], [Amphipod], [Amphipod], [Amphipod]) {
        let rows = lines.map { substring in
            substring.compactMap(Amphipod.init(rawValue:))
        }
        let room0 = Array(rows.map { $0[0] }.reversed())
        let room1 = Array(rows.map { $0[1] }.reversed())
        let room2 = Array(rows.map { $0[2] }.reversed())
        let room3 = Array(rows.map { $0[3] }.reversed())
        return (room0, room1, room2, room3)
    }
}

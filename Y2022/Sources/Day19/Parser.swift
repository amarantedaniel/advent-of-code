import Foundation

enum Parser {
    static func parse(input: String) -> [Scanner] {
        input
            .components(separatedBy: "\n\n")
            .map { scanner -> Scanner in
                let beacons = scanner
                    .split(separator: "\n")
                    .dropFirst()
                    .map { $0.split(separator: ",") }
                    .map { Beacon(x: Int($0[0])!, y: Int($0[1])!, z: Int($0[2])!) }
                return Scanner(beacons: beacons)
            }
    }
}

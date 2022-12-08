import Foundation
import Shared

private func calculateDirectorySizes(input: String) -> [String: Int] {
    let lines = input
        .split(separator: "\n")
        .dropFirst()
        .filter { $0 != "$ ls" }
    var openDirectories = ["."]
    var directorySizes: [String: Int] = [:]
    for line in lines {
        if line.starts(with: "dir") {
            continue
        } else if line == "$ cd .." {
            openDirectories.removeLast()
        } else if line.starts(with: "$ cd") {
            let directory = line.split(separator: " ").last!
            let fullPath = openDirectories.joined(separator: "/") + "/\(directory)"
            openDirectories.append(fullPath)
        } else {
            let fileSize = Int(line.split(separator: " ").first!)!
            for directory in openDirectories {
                directorySizes.increment(at: directory, amount: fileSize)
            }
        }
    }
    return directorySizes
}

func solve1(input: String) -> Int {
    let directorySizes = calculateDirectorySizes(input: input)
    return directorySizes
        .map(\.value)
        .filter { $0 <= 100000 }
        .reduce(0, +)
}

func solve2(input: String) -> Int {
    let directorySizes = calculateDirectorySizes(input: input)
    let unusedSpace = 70000000 - directorySizes["."]!
    return directorySizes
        .map(\.value)
        .filter { $0 + unusedSpace >= 30000000 }
        .min()!
}

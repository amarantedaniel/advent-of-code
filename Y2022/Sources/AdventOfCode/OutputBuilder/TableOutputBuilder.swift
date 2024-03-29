import Foundation

struct TableOutputBuilder: OutputBuilder {
    var day: String?
    var output: [String] = [
        "| Day | Part | Solution | Time  | Status |",
        "|-----|------|----------|-------|--------|"
    ]
    mutating func set(day: String) {
        self.day = day
    }

    mutating func set(result: Result<AdventDayResult, any Error>, for part: Part) {
        guard let day else { return }
        switch result {
        case let .success(result):
            let duration = result.duration.formatted(.units(allowed: [.milliseconds]))
            output.append(
                "| \(day) | \(part) | \(result.result) | \(duration) | ✅️ |"
            )
        case .failure:
            output.append(
                "| \(day) | \(part) | - | - | ❌ |"
            )
        }
    }

    func build() -> String {
        output.joined(separator: "\n")
    }
}

import Foundation

extension Map: CustomStringConvertible {
    var description: String {
        """
        #############
        #\(hallway.map(\.description).joined())#
        ###\(room0.second.description)#\(room1.second.description)#\(room2.second.description)#\(room3.second.description)###
          #\(room0.first.description)#\(room1.first.description)#\(room2.first.description)#\(room3.first.description)#
          #########
        """
    }
}

extension Array {
    var second: Element? {
        guard count >= 2 else {
            return nil
        }
        return self[1]
    }
}

extension Optional where Wrapped == Amphipod {
    var description: String {
        return String(self?.rawValue ?? ".")
    }
}

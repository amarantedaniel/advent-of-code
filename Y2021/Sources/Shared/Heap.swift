import Foundation

public struct Heap<Element, Priority> {
    var elements: [(Element, Priority)] = []
    var priority: (Priority, Priority) -> Bool

    public init(priority: @escaping (Priority, Priority) -> Bool) {
        self.priority = priority
    }

    public var isEmpty: Bool { elements.isEmpty }
    private var count: Int { elements.count }

    @inline(__always)
    private func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }

    @inline(__always)
    private func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }

    @inline(__always)
    private func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }

    @inline(__always)
    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func isHigherPriority(_ firstIndex: Int, than secondIndex: Int) -> Bool {
        return priority(elements[firstIndex].1, elements[secondIndex].1)
    }

    private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count, isHigherPriority(childIndex, than: parentIndex)
        else { return parentIndex }
        return childIndex
    }

    private func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)),
            and: rightChildIndex(of: parent)
        )
    }

    private mutating func swap(_ firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else { return }
        elements.swapAt(firstIndex, secondIndex)
    }

    public mutating func insert(_ element: Element, priority: Priority) {
        elements.append((element, priority))
        siftUp(elementAtIndex: count - 1)
    }

    private mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index),
              isHigherPriority(index, than: parent)
        else { return }
        swap(index, with: parent)
        siftUp(elementAtIndex: parent)
    }

    public mutating func extract() -> Element? {
        guard !isEmpty else { return nil }
        swap(0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty {
            siftDown(elementAtIndex: 0)
        }
        return element.0
    }

    private mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swap(index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
}

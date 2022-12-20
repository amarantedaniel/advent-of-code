import Foundation

class Node {
    let number: Int64
    weak var next: Node?

    init(number: Int64) {
        self.number = number
    }
}

private func parse(input: String, multiplyBy: Int64) -> [Node] {
    let numbers = input
        .split(separator: "\n")
        .compactMap { Int64($0) }
        .map { Node(number: $0 * multiplyBy) }
    for i in 0 ..< numbers.count - 1 {
        numbers[i].next = numbers[i + 1]
    }
    return numbers
}

func format(start: Node) -> String {
    var result: [String] = []
    var node: Node? = start
    while node != nil {
        result.append(node!.number.description)
        node = node?.next
    }
    return result.joined(separator: ", ")
}

private func adjust(index: Int64, number: Int64, count: Int64) -> Int64 {
    let index2 = (index + number) % (count - 1)
    if number > 0 {
        return index2
    } else {
        if index2 > 0 {
            return index2
        }
        return count - 1 + index2
    }
}

private func delete(node: Node, head: Node) -> (Node, Int64) {
    if node === head {
        return (node.next!, 0)
    }
    var index: Int64 = 1
    var aux: Node? = head
    while aux?.next !== node {
        index += 1
        aux = aux?.next
    }
    aux?.next = aux?.next?.next
    return (head, index)
}

func insert(node: Node, at index: Int64, head: Node) -> Node {
    if index == 0 {
        node.next = head
        return node
    }
    var aux: Node? = head
    for _ in 1 ..< index {
        aux = aux?.next
    }
    node.next = aux?.next
    aux?.next = node
    return head
}

func getResult(head: Node, zero: Node, count: Int64) -> Int64 {
    var result: Int64 = 0
    var index = 0
    var aux: Node? = zero
    while aux?.next !== zero {
        index += 1
        if let next = aux?.next {
            aux = next
        } else {
            aux = head
        }
        if index == 1000 % count || index == 2000 % count || index == 3000 % count {
            result += aux?.number ?? 0
        }
    }
    return result
}

private func shuffle(nodes: [Node], head: Node) -> Node {
    var head = head
    for i in 0 ..< nodes.count {
        let node = nodes[i]
        if node.number == 0 {
            continue
        }
        let (head2, index) = delete(node: node, head: head)
        let index2 = adjust(index: index, number: node.number, count: Int64(nodes.count))
        head = insert(node: node, at: index2, head: head2)
    }
    return head
}

func solve1(input: String) -> Int64 {
    let nodes = parse(input: input, multiplyBy: 1)
    var head = nodes.first!
    head = shuffle(nodes: nodes, head: head)
    let zero = nodes.first { $0.number == 0 }!
    return getResult(head: head, zero: zero, count: Int64(nodes.count))
}

func solve2(input: String) -> Int64 {
    let nodes = parse(input: input, multiplyBy: 811589153)
    var head = nodes.first!
    for _ in 0 ..< 10 {
        head = shuffle(nodes: nodes, head: head)
    }
    let zero = nodes.first { $0.number == 0 }!
    return getResult(head: head, zero: zero, count: Int64(nodes.count))
}

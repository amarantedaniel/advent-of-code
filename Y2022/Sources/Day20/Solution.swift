import Foundation

class Node {
    let number: Int
    weak var next: Node?

    init(number: Int) {
        self.number = number
    }
}

private func parse(input: String) -> [Node] {
    let numbers = input
        .split(separator: "\n")
        .compactMap { Int($0) }
        .map { Node(number: $0) }
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

func solve1(input: String) -> Int {
    let nodes = parse(input: input)
    var head = nodes.first!
//    print(format(start: head))
    for i in 0 ..< nodes.count {
        let node = nodes[i]
        if node.number == 0 {
            continue
        }
        let (head2, index) = delete(node: node, head: head)
        let index2 = adjust(index: index, number: node.number, count: nodes.count)
        head = insert(node: node, at: index2, head: head2)
//        print(format(start: head))
    }
    let zero = nodes.first { $0.number == 0 }!
    print(getResult(head: head, zero: zero, count: nodes.count))
    return 0
}

private func adjust(index: Int, number: Int, count: Int) -> Int {
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

private func delete(node: Node, head: Node) -> (Node, Int) {
    if node === head {
        return (node.next!, 0)
    }
    var index = 1
    var aux: Node? = head
    while aux?.next !== node {
        index += 1
        aux = aux?.next
    }
    aux?.next = aux?.next?.next
    return (head, index)
}

func insert(node: Node, at index: Int, head: Node) -> Node {
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

func getResult(head: Node, zero: Node, count: Int) -> Int {
    var result = 0
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

func solve2(input: String) -> Int {
    0
}

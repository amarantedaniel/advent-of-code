import AdventOfCode

typealias Exploded = (left: Int?, right: Int?)

struct Tree: Equatable, CustomStringConvertible {
    let left: Node
    let right: Node

    var description: String {
        return "[\(left.description),\(right.description)]"
    }

    func extractLeaves() -> (Int, Int) {
        switch (left, right) {
        case let (.leaf(ll), .leaf(rl)):
            return (ll, rl)
        default:
            fatalError()
        }
    }
}

indirect enum Node: Equatable, CustomStringConvertible {
    case leaf(Int)
    case tree(Tree)

    var description: String {
        switch self {
        case let .leaf(number):
            return number.description
        case let .tree(tree):
            return tree.description
        }
    }
}

struct Day18: AdventDay {
    func addTrees(lhs: Tree, rhs: Tree) -> Tree {
        Tree(left: .tree(lhs), right: .tree(rhs))
    }

    func explode(tree: Tree) -> (Tree, Bool) {
        let (result, exploded) = explode(tree: tree, level: 0)
        return (result, exploded != nil)
    }

    func explode(tree: Tree, level: Int) -> (Tree, Exploded?) {
        let (left, leftExplosion) = explode(node: tree.left, level: level)

        if let explosion = leftExplosion {
            if case let .leaf(value) = tree.right, let something = explosion.right {
                return (Tree(left: left, right: .leaf(something + value)), (left: explosion.left, right: nil))
            } else if case let .tree(subtree) = tree.right, let something = explosion.right {
                return (Tree(left: left, right: .tree(appendToLeft(tree: subtree, number: something))), (left: explosion.left, right: nil))
            } else {
                return (Tree(left: left, right: tree.right), explosion)
            }
        }

        let (right, rightExplosion) = explode(node: tree.right, level: level)

        if let explosion = rightExplosion {
            if case let .leaf(value) = tree.left, let something = explosion.left {
                return (Tree(left: .leaf(something + value), right: right), (left: nil, right: explosion.right))
            } else if case let .tree(subtree) = tree.left, let something = explosion.left {
                return (Tree(left: .tree(appendToRight(tree: subtree, number: something)), right: right), (left: nil, right: explosion.right))
            } else {
                return (Tree(left: tree.left, right: right), explosion)
            }
        }
        return (Tree(left: left, right: right), nil)
    }

    private func explode(node: Node, level: Int) -> (Node, Exploded?) {
        switch node {
        case let .leaf(number):
            return (.leaf(number), nil)
        case let .tree(subtree) where level == 3:
            return (.leaf(0), subtree.extractLeaves())
        case let .tree(subtree):
            let (newTree, explosion) = explode(tree: subtree, level: level + 1)
            return (.tree(newTree), explosion)
        }
    }

    private func appendToLeft(tree: Tree, number: Int) -> Tree {
        switch tree.left {
        case let .leaf(value):
            return Tree(left: .leaf(number + value), right: tree.right)
        case let .tree(subtree):
            return Tree(left: .tree(appendToLeft(tree: subtree, number: number)), right: tree.right)
        }
    }

    private func appendToRight(tree: Tree, number: Int) -> Tree {
        switch tree.right {
        case let .leaf(value):
            return Tree(left: tree.left, right: .leaf(number + value))
        case let .tree(subtree):
            return Tree(left: tree.left, right: .tree(appendToRight(tree: subtree, number: number)))
        }
    }

    func split(tree: Tree) -> (Tree, Bool) {
        let (left, didSplitLeft) = split(node: tree.left)
        if didSplitLeft {
            return (Tree(left: left, right: tree.right), didSplitLeft)
        }
        let (right, didSplitRight) = split(node: tree.right)
        if didSplitRight {
            return (Tree(left: left, right: right), didSplitRight)
        }
        return (Tree(left: left, right: right), false)
    }

    private func split(node: Node) -> (Node, Bool) {
        switch node {
        case let .leaf(number) where number > 9:
            let left = number / 2
            let right = number / 2 + number % 2
            return (.tree(Tree(left: .leaf(left), right: .leaf(right))), true)
        case let .leaf(number):
            return (.leaf(number), false)
        case let .tree(subtree):
            let (split, didSplit) = split(tree: subtree)
            return (.tree(split), didSplit)
        }
    }

    func reduce(tree: Tree) -> Tree {
        var tree = tree
        while true {
            let (exploded, didExplode) = explode(tree: tree)
            if didExplode {
                tree = exploded
                continue
            }
            let (split, didSplit) = split(tree: tree)
            if didSplit {
                tree = split
                continue
            }
            return tree
        }
    }

    func processList(trees: [Tree]) -> Tree {
        trees.reduce(trees[0]) {
            reduce(tree: addTrees(lhs: $0, rhs: $1))
        }
    }

    func calculateMagnitude(tree: Tree) -> Int {
        switch (tree.left, tree.right) {
        case let (.leaf(leftNum), .leaf(rightNum)):
            return 3 * leftNum + 2 * rightNum
        case let (.tree(tree), .leaf(num)):
            return 3 * calculateMagnitude(tree: tree) + 2 * num
        case let (.leaf(num), .tree(tree)):
            return 3 * num + 2 * calculateMagnitude(tree: tree)
        case let (.tree(leftTree), .tree(rightTree)):
            return 3 * calculateMagnitude(tree: leftTree) + 2 * calculateMagnitude(tree: rightTree)
        }
    }

    func part1(input: String) -> Int {
        let trees = Parser.parse(input: input)
        let reduced = processList(trees: trees)
        return calculateMagnitude(tree: reduced)
    }

    func part2(input: String) -> Int {
        let trees = Parser.parse(input: input)
        var maximum = 0
        for i in 0..<trees.count {
            for j in 0..<trees.count where i != j {
                let magni1 = calculateMagnitude(tree: reduce(tree: addTrees(lhs: trees[j], rhs: trees[i])))
                let magni2 = calculateMagnitude(tree: reduce(tree: addTrees(lhs: trees[j], rhs: trees[i])))
                maximum = max(max(maximum, magni1), magni2)
            }
        }
        return maximum
    }
}

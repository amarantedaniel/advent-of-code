import Foundation

struct Tree: Equatable, CustomStringConvertible {
    let left: Node
    let right: Node

    var description: String {
        return "[\(left.description),\(right.description)]"
    }

    func extractLeaves() -> (Int, Int) {
        switch (left, right) {
        case (.leaf(let ll), .leaf(let rl)):
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
        case .leaf(let number):
            return number.description
        case .tree(let tree):
            return tree.description
        }
    }

    var leafValue: Int {
        switch self {
        case .leaf(let value):
            return value
        case .tree:
            fatalError()
        }
    }
}

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
        if case .leaf(let value) = tree.right, let something = explosion.right {
            return (Tree(left: left, right: .leaf(something + value)), (left: explosion.left, right: nil))
        } else if case .tree(let subtree) = tree.right, let something = explosion.right {
            return (Tree(left: left, right: .tree(appendToLeft(tree: subtree, number: something))), (left: explosion.left, right: nil))
        } else {
            return (Tree(left: left, right: tree.right), explosion)
        }
    }

    let (right, rightExplosion) = explode(node: tree.right, level: level)

    if let explosion = rightExplosion {
        if case .leaf(let value) = tree.left, let something = explosion.left {
            return (Tree(left: .leaf(something + value), right: right), (left: nil, right: explosion.right))
        } else if case .tree(let subtree) = tree.left, let something = explosion.left {
            return (Tree(left: .tree(appendToRight(tree: subtree, number: something)), right: right), (left: nil, right: explosion.right))
        } else {
            return (Tree(left: tree.left, right: right), explosion)
        }
    }
    return (Tree(left: left, right: right), nil)
}

typealias Exploded = (left: Int?, right: Int?)

private func explode(node: Node, level: Int) -> (Node, Exploded?) {
    switch node {
    case .leaf(let number):
        return (.leaf(number), nil)
    case .tree(let subtree) where level == 3:
        return (.leaf(0), subtree.extractLeaves())
    case .tree(let subtree):
        let (newTree, explosion) = explode(tree: subtree, level: level + 1)
        return (.tree(newTree), explosion)
    }
}

private func appendToLeft(tree: Tree, number: Int) -> Tree {
    switch tree.left {
    case .leaf(let value):
        return Tree(left: .leaf(number + value), right: tree.right)
    case .tree(let subtree):
        return Tree(left: .tree(appendToLeft(tree: subtree, number: number)), right: tree.right)
    }
}

private func appendToRight(tree: Tree, number: Int) -> Tree {
    switch tree.right {
    case .leaf(let value):
        return Tree(left: tree.left, right: .leaf(number + value))
    case .tree(let subtree):
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
    case .leaf(let number) where number > 9:
        let left = number / 2
        let right = number / 2 + number % 2
        return (.tree(Tree(left: .leaf(left), right: .leaf(right))), true)
    case .leaf(let number):
        return (.leaf(number), false)
    case .tree(let subtree):
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
     trees.reduce(trees[0]) { tree1, tree2 in
         let sum = addTrees(lhs: tree1, rhs: tree2)
         let reduced = reduce(tree: sum)
         return reduced
     }
 }

func calculateMagnitude(tree: Tree) -> Int {
    switch (tree.left, tree.right) {
    case (.leaf(let leftNum), .leaf(let rightNum)):
        return 3 * leftNum + 2 * rightNum
    case (.tree(let tree), .leaf(let num)):
        return 3 * calculateMagnitude(tree: tree) + 2 * num
    case (.leaf(let num), .tree(let tree)):
        return 3 * num + 2 * calculateMagnitude(tree: tree)
    case (.tree(let leftTree), .tree(let rightTree)):
        return 3 * calculateMagnitude(tree: leftTree) + 2 * calculateMagnitude(tree: rightTree)
    }
}


func solve1(input: String) -> Int {
    let trees = Parser.parse(input: input)
    let reduced = processList(trees: trees)
    return calculateMagnitude(tree: reduced)
}

func solve2(input: String) -> Int {
    let trees = Parser.parse(input: input)
    var maximum = 0
    for i in 0..<trees.count {
        for j in 0..<trees.count {
            if i != j {
                let magni1 =  calculateMagnitude(tree: processList(trees: [trees[i], trees[j]]))
                let magni2 = calculateMagnitude(tree: processList(trees: [trees[j], trees[i]]))
                maximum = max(max(maximum, magni1), magni2)
            }
        }
    }
    return maximum
}

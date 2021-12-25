import XCTest
@testable import Day18

class SolutionTests: XCTestCase {

    func testExplode() {
        let input1 = "[[[[[9,8],1],2],3],4]"
        let (tree1, _) = explode(tree: Parser.parse(input: input1)[0])
        XCTAssertEqual(tree1.description, "[[[[0,9],2],3],4]")

        let input2 = "[7,[6,[5,[4,[3,2]]]]]"
        let (tree2, _) = explode(tree: Parser.parse(input: input2)[0])
        XCTAssertEqual(tree2.description, "[7,[6,[5,[7,0]]]]")

        let input3 = "[[6,[5,[4,[3,2]]]],1]"
        let (tree3, _) = explode(tree: Parser.parse(input: input3)[0])
        XCTAssertEqual(tree3.description, "[[6,[5,[7,0]]],3]")

        let input4 = "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"
        let (tree4, _) = explode(tree: Parser.parse(input: input4)[0])
        XCTAssertEqual(tree4.description, "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")

        let input5 = "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
        let (tree5, _) = explode(tree: Parser.parse(input: input5)[0])
        XCTAssertEqual(tree5.description, "[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
    }

    func testMultipleOperations() {
        let tree1 = Parser.parse(input: "[[[[4,3],4],4],[7,[[8,4],9]]]")[0]
        let tree2 = Parser.parse(input: "[1,1]")[0]
        let sum = addTrees(lhs: tree1, rhs: tree2)
        XCTAssertEqual(sum.description, "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
        let (explosion1, _) = explode(tree: sum)
        XCTAssertEqual(explosion1.description, "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]")
        let (explosion2, _) = explode(tree: explosion1)
        XCTAssertEqual(explosion2.description, "[[[[0,7],4],[15,[0,13]]],[1,1]]")
        let (split1, _) = split(tree: explosion2)
        XCTAssertEqual(split1.description, "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
        let (split2, _) = split(tree: split1)
        XCTAssertEqual(split2.description, "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]")
        let (explosion3, _) = explode(tree: split2)
        XCTAssertEqual(explosion3.description, "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
    }

    func testReduce() {
        let tree = Parser.parse(input: "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")[0]
        let reduced = reduce(tree: tree)
        XCTAssertEqual(reduced.description, "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
    }

    func testProcessList() {
        let path = Bundle.module.path(forResource: "sample1", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let trees = Parser.parse(input: input)
        XCTAssertEqual(processList(trees: trees).description, "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
    }

    func testCalculateMagnitude() {
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[1,2],[[3,4],5]]")[0]), 143)
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")[0]), 1384)
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[[[1,1],[2,2]],[3,3]],[4,4]]")[0]), 445)
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[[[3,0],[5,3]],[4,4]],[5,5]]")[0]), 791)
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[[[5,0],[7,4]],[5,5]],[6,6]]")[0]), 1137)
        XCTAssertEqual(calculateMagnitude(tree: Parser.parse(input: "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")[0]), 3488)
    }

    func test_solve1_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 3216)
    }

    func test_solve2_withSampleInput() {
        let path = Bundle.module.path(forResource: "sample2", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 3993)
    }

    func test_solve2_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 4643)
    }
}

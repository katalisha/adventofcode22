import XCTest
@testable import RopeBridge

@available(macOS 13.0, *)
final class RopeBridgeTests: XCTestCase {
    func testSampleData1Knot() throws {
        let sampleData = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
        XCTAssertEqual(processData(data: sampleData, sections: 1), 13)
    }
    
    func testSampleData10Knots() throws {
        let sampleData = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
        XCTAssertEqual(processData(data: sampleData, sections: 9), 1)
    }
    
    func testLargeSampleData10Knots() throws {
        let sampleData = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""
        XCTAssertEqual(processData(data: sampleData, sections: 9), 36)
    }
    
    
    func testFileTotalSize1Knot() throws {
        XCTAssertEqual(runFile(sections: 1), 6269)
    }
    
    func testFileTotalSize10Knots() throws {
        XCTAssertEqual(runFile(sections: 9), 2557)
    }
    
//    func testMoveRightTailNoMove() throws {
//        let d = Direction.right
//        let start = Section(head: Point(x: 0, y: 0), tail: Point(x: 0, y: 0))
//        let end = Section(head: Point(x: 1, y: 0), tail: Point(x: 0, y: 0))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveRightTailMoveRight() throws {
//        let d = Direction.right
//        let start = Section(head: Point(x: 1, y: 0), tail: Point(x: 0, y: 0))
//        let end = Section(head: Point(x: 2, y: 0), tail: Point(x: 1, y: 0))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveRightTailMoveDiag() throws {
//        let d = Direction.right
//        let start = Section(head: Point(x: 3, y: 3), tail: Point(x: 2, y: 4))
//        let end = Section(head: Point(x: 4, y: 3), tail: Point(x: 3, y: 3))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveUpTailNoMove() throws {
//        let d = Direction.up
//        let start = Section(head: Point(x: 4, y: 0), tail: Point(x: 3, y: 0))
//        let end = Section(head: Point(x: 4, y: 1), tail: Point(x: 3, y: 0))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveUpTailMoveUp() throws {
//        let d = Direction.up
//        let start = Section(head: Point(x: 4, y: 2), tail: Point(x: 4, y: 1))
//        let end = Section(head: Point(x: 4, y: 3), tail: Point(x: 4, y: 2))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveUpTailMoveDiag() throws {
//        let d = Direction.up
//        let start = Section(head: Point(x: 4, y: 1), tail: Point(x: 3, y: 0))
//        let end = Section(head: Point(x: 4, y: 2), tail: Point(x: 4, y: 1))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveLeftTailNoMove() throws {
//        let d = Direction.left
//        let start = Section(head: Point(x: 4, y: 4), tail: Point(x: 4, y: 3))
//        let end = Section(head: Point(x: 3, y: 4), tail: Point(x: 4, y: 3))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveLeftTailMoveLeft() throws {
//        let d = Direction.left
//        let start = Section(head: Point(x: 2, y: 4), tail: Point(x: 3, y: 4))
//        let end = Section(head: Point(x: 1, y: 4), tail: Point(x: 2, y: 4))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveLeftTailMoveDiag() throws {
//        let d = Direction.left
//        let start = Section(head: Point(x: 3, y: 4), tail: Point(x: 4, y: 3))
//        let end = Section(head: Point(x: 2, y: 4), tail: Point(x: 3, y: 4))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveDownTailNoMove() throws {
//        let d = Direction.down
//        let start = Section(head: Point(x: 1, y: 4), tail: Point(x: 2, y: 3))
//        let end = Section(head: Point(x: 1, y: 3), tail: Point(x: 2, y: 3))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveDownTailMoveDown() throws {
//        let d = Direction.down
//        let start = Section(head: Point(x: 1, y: 3), tail: Point(x: 1, y: 4))
//        let end = Section(head: Point(x: 1, y: 2), tail: Point(x: 1, y: 3))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
//
//    func testMoveDownTailMoveDiag() throws {
//        let d = Direction.down
//        let start = Section(head: Point(x: 1, y: 3), tail: Point(x: 2, y: 4))
//        let end = Section(head: Point(x: 1, y: 2), tail: Point(x: 1, y: 3))
//
//        XCTAssertEqual(calculateMove(direction: d, section: start), end)
//    }
}

import XCTest
@testable import RopeBridge

@available(macOS 13.0, *)
final class RopeBridgeTests: XCTestCase {
    func testSampleDataTotalSize() throws {
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
        XCTAssertEqual(processData(data: sampleData), 13)
    }
    
    func testMoveRightTailNoMove() throws {
        let d = Direction.right
        let start = Rope(head: Point(x: 0, y: 0), tail: Point(x: 0, y: 0))
        let end = Rope(head: Point(x: 1, y: 0), tail: Point(x: 0, y: 0))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveRightTailMoveRight() throws {
        let d = Direction.right
        let start = Rope(head: Point(x: 1, y: 0), tail: Point(x: 0, y: 0))
        let end = Rope(head: Point(x: 2, y: 0), tail: Point(x: 1, y: 0))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveRightTailMoveDiag() throws {
        let d = Direction.right
        let start = Rope(head: Point(x: 3, y: 3), tail: Point(x: 2, y: 4))
        let end = Rope(head: Point(x: 4, y: 3), tail: Point(x: 3, y: 3))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveUpTailNoMove() throws {
        let d = Direction.up
        let start = Rope(head: Point(x: 4, y: 0), tail: Point(x: 3, y: 0))
        let end = Rope(head: Point(x: 4, y: 1), tail: Point(x: 3, y: 0))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveUpTailMoveUp() throws {
        let d = Direction.up
        let start = Rope(head: Point(x: 4, y: 2), tail: Point(x: 4, y: 1))
        let end = Rope(head: Point(x: 4, y: 3), tail: Point(x: 4, y: 2))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveUpTailMoveDiag() throws {
        let d = Direction.up
        let start = Rope(head: Point(x: 4, y: 1), tail: Point(x: 3, y: 0))
        let end = Rope(head: Point(x: 4, y: 2), tail: Point(x: 4, y: 1))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveLeftTailNoMove() throws {
        let d = Direction.left
        let start = Rope(head: Point(x: 4, y: 4), tail: Point(x: 4, y: 3))
        let end = Rope(head: Point(x: 3, y: 4), tail: Point(x: 4, y: 3))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveLeftTailMoveLeft() throws {
        let d = Direction.left
        let start = Rope(head: Point(x: 2, y: 4), tail: Point(x: 3, y: 4))
        let end = Rope(head: Point(x: 1, y: 4), tail: Point(x: 2, y: 4))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveLeftTailMoveDiag() throws {
        let d = Direction.left
        let start = Rope(head: Point(x: 3, y: 4), tail: Point(x: 4, y: 3))
        let end = Rope(head: Point(x: 2, y: 4), tail: Point(x: 3, y: 4))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveDownTailNoMove() throws {
        let d = Direction.down
        let start = Rope(head: Point(x: 1, y: 4), tail: Point(x: 2, y: 3))
        let end = Rope(head: Point(x: 1, y: 3), tail: Point(x: 2, y: 3))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveDownTailMoveDown() throws {
        let d = Direction.down
        let start = Rope(head: Point(x: 1, y: 3), tail: Point(x: 1, y: 4))
        let end = Rope(head: Point(x: 1, y: 2), tail: Point(x: 1, y: 3))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testMoveDownTailMoveDiag() throws {
        let d = Direction.down
        let start = Rope(head: Point(x: 1, y: 3), tail: Point(x: 2, y: 4))
        let end = Rope(head: Point(x: 1, y: 2), tail: Point(x: 1, y: 3))
        
        XCTAssertEqual(calculateMove(direction: d, rope: start), end)
    }
    
    func testFileTotalSize() throws {
        XCTAssertEqual(runFile(), 6269)
    }
    
}

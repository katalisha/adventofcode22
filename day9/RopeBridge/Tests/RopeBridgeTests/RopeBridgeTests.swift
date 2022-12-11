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
        XCTAssertEqual(processData(data: sampleData, knots: 2), 13)
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
        XCTAssertEqual(processData(data: sampleData, knots: 10), 1)
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
        XCTAssertEqual(processData(data: sampleData, knots: 10), 36)
    }
    
    
    func testFileTotalSize1Knot() throws {
        XCTAssertEqual(runFile(knots: 2), 6269)
    }
    
    func testFileTotalSize10Knots() throws {
        XCTAssertEqual(runFile(knots: 10), 2557)
    }
}

import XCTest
@testable import HillClimbing

final class HillClimbingTests: XCTestCase {
    func testExampleStart() throws {
        let sampleData = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""
        XCTAssertEqual(path(data: sampleData, mode: .fromStart), 31)
    }
    
    func testFileStart() throws {

        XCTAssertEqual(fileToPath(mode: .fromStart), 520)
    }
    
    func testExampleAny() throws {
        let sampleData = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""
        XCTAssertEqual(path(data: sampleData, mode: .fromAnyGround), 29)
    }
    
    func testFileAny() throws {

        XCTAssertEqual(fileToPath(mode: .fromAnyGround), 508)
    }
}

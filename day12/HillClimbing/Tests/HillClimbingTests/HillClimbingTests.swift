import XCTest
@testable import HillClimbing

final class HillClimbingTests: XCTestCase {
    func testExample() throws {
        let sampleData = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""
        XCTAssertEqual(path(data: sampleData), 31)
    }
    
    func testFile() throws {

        XCTAssertEqual(fileToPath(), 520)
    }
    
}

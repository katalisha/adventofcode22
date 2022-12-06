import XCTest
@testable import SupplyStacks

final class SupplyStacksTests: XCTestCase {
    func testSampleData9000() throws {
        let sampleData = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2

"""
        XCTAssertEqual(moveCrates(data: sampleData, crane: .cm9000), "CMZ")
    }
    
    func testFile9000() throws {
        XCTAssertEqual(runFile(crane: .cm9000), "TBVFVDZPN")
    }
    
    func testSampleData9001() throws {
        let sampleData = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2

"""
        XCTAssertEqual(moveCrates(data: sampleData, crane: .cm9001), "MCD")
    }
    
    func testFile9001() throws {
        XCTAssertEqual(runFile(crane: .cm9001), "VLCWHTDSZ")
    }
}

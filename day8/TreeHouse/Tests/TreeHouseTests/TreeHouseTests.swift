import XCTest
@testable import TreeHouse

final class TreeHouseTests: XCTestCase {
    func testSampleDataTotalSize() throws {
        let sampleData = """
30373
25512
65332
93549
35390
"""
        XCTAssertEqual(processData(data: sampleData, mode: .totalVisible), 21)
    }
    
    func testFileTotalSize() throws {
        XCTAssertEqual(runFile(mode: .totalVisible), 1715)
    }
    
    func testViewingDistance() throws {
        let sampleData = """
30373
25512
65332
33549
35390
"""
        XCTAssertEqual(processData(data: sampleData, mode: .maxViewingDistance), 8)

    }
    
    func testFileViewingDistance() throws {
        XCTAssertEqual(runFile(mode: .maxViewingDistance), 374400)
    }
}

import XCTest
@testable import RegolithReservoir

@available(macOS 13.0, *)
final class RegolithReservoirTests: XCTestCase {
    func testAbyssExample() throws {
        let sampleData = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""
        XCTAssertEqual(simulateSand(data: sampleData, mode: .abyss), 24)
    }
    
    func testAbyssFile() throws {
        XCTAssertEqual(runFile(mode: .abyss), 994)
    }
    
    func testFloorExample() throws {
        let sampleData = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""
        XCTAssertEqual(simulateSand(data: sampleData, mode: .floor), 93)
    }
    
    func testFloorFile() throws {
        XCTAssertEqual(runFile(mode: .floor), 26283)
    }
}

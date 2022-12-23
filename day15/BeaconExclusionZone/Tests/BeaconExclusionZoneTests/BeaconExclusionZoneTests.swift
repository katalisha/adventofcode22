import XCTest
@testable import BeaconExclusionZone

@available(macOS 13.0, *)
final class BeaconExclusionZoneTests: XCTestCase {
    func testExampleRow() throws {
        let sampleData = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""
        
        XCTAssertEqual(process(data: sampleData, mode: .row(9)), 25)
        XCTAssertEqual(process(data: sampleData, mode: .row(10)), 26)
        XCTAssertEqual(process(data: sampleData, mode: .row(11)), 28)

    }

    func testFileRow() throws {
        XCTAssertEqual(runFile(mode: .row(2000000)), 5525990)
    }
    
    func testExampleTuning() throws {
        let sampleData = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""
        
        XCTAssertEqual(process(data: sampleData, mode: .grid(20)), 56000011)
    }
    
    func testFileTuning() throws {
        XCTAssertEqual(runFile(mode: .grid(4000000)), 11756174628223)
    }
}

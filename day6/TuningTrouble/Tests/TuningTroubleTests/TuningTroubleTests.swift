import XCTest
@testable import TuningTrouble

final class TuningTroubleTests: XCTestCase {
    func testSample1() throws {
        let sampleData = "bvwbjplbgvbhsrlpgdmjqwftvncz"
        XCTAssertEqual(findMarker(data: sampleData), 5)
    }
    
    func testSample2() throws {
        let sampleData = "nppdvjthqldpwncqszvftbrmjlhg"
        XCTAssertEqual(findMarker(data: sampleData), 6)
    }
    
    func testSample3() throws {
        let sampleData = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
        XCTAssertEqual(findMarker(data: sampleData), 10)
    }
    
    func testSample4() throws {
        let sampleData = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
        XCTAssertEqual(findMarker(data: sampleData), 11)
    }
    
    func testFile() throws {
        XCTAssertEqual(runFile(), 1109)
    }

}

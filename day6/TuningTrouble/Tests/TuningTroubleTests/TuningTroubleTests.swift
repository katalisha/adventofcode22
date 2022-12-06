import XCTest
@testable import TuningTrouble

final class TuningTroubleTests: XCTestCase {
    func testSample1() throws {
        let sampleData = "bvwbjplbgvbhsrlpgdmjqwftvncz"
        XCTAssertEqual(findMarker(data: sampleData, .packetStart), 5)
    }
    
    func testSample2() throws {
        let sampleData = "nppdvjthqldpwncqszvftbrmjlhg"
        XCTAssertEqual(findMarker(data: sampleData, .packetStart), 6)
    }
    
    func testSample3() throws {
        let sampleData = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
        XCTAssertEqual(findMarker(data: sampleData, .packetStart), 10)
    }
    
    func testSample4() throws {
        let sampleData = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
        XCTAssertEqual(findMarker(data: sampleData, .packetStart), 11)
    }
    
    func testFile() throws {
        XCTAssertEqual(runFile(.packetStart), 1109)
    }
    
    func testSampleMessage1() throws {
        let sampleData = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
        XCTAssertEqual(findMarker(data: sampleData, .message), 19)
    }
    
    func testSampleMessage2() throws {
        let sampleData = "bvwbjplbgvbhsrlpgdmjqwftvncz"
        XCTAssertEqual(findMarker(data: sampleData, .message), 23)
    }
    
    func testSampleMessage3() throws {
        let sampleData = "nppdvjthqldpwncqszvftbrmjlhg"
        XCTAssertEqual(findMarker(data: sampleData, .message), 23)
    }
    
    func testSampleMessage4() throws {
        let sampleData = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
        XCTAssertEqual(findMarker(data: sampleData, .message), 29)
    }
    
    func testSampleMessage5() throws {
        let sampleData = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
        XCTAssertEqual(findMarker(data: sampleData, .message), 26)
    }
    
    func testMessageFile() throws {
        XCTAssertEqual(runFile(.message), 3965)
    }

}

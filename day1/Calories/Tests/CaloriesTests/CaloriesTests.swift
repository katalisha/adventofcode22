import XCTest
@testable import Calories

final class CaloriesTests: XCTestCase {
    func testTopElf() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(topElves(numberOfElves: 1), 66186)
    }
    
    func testTop3Elves() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(topElves(numberOfElves: 3), 196804)
    }
}


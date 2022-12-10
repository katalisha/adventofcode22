import XCTest
@testable import Calories

final class CaloriesTests: XCTestCase {
    func testTopElf() throws {
        XCTAssertEqual(topElves(1), 66186)
    }
    
    func testTop3Elves() throws {
        XCTAssertEqual(topElves(3), 196804)
    }
}


import XCTest
@testable import MonkeyInTheMiddle

final class MonkeyInTheMiddleTests: XCTestCase {
    func testExample() throws {
        let sampleMonkeys = [
            Monkey(items: [79, 98], operation: { $0 * 19 }, test: { ($0 % 23 == 0) ? 2 : 3 }),
            Monkey(items: [54, 65, 75, 74], operation: { $0 + 6 }, test: { ($0 % 19 == 0) ? 2 : 0 }),
            Monkey(items: [79, 60, 97], operation: { $0 * $0 }, test: { ($0 % 13 == 0) ? 1 : 3 }),
            Monkey(items: [74], operation: { $0 + 3 }, test: { ($0 % 17 == 0) ? 0 : 1 })
        ]
        XCTAssertEqual(observeMonkeys(sampleMonkeys, phew: 3, rounds: 20), 10605)
    }
    
    func testPart1() throws {
        
        let monkeys = [
            Monkey(items: [65, 78], operation: { $0 * 3 }, test: { ($0 % 5 == 0) ? 2 : 3 }),
            Monkey(items: [54, 78, 86, 79, 73, 64, 85, 88], operation: { $0 + 8 }, test: { ($0 % 11 == 0) ? 4 : 7 }),
            Monkey(items: [69, 97, 77, 88, 87], operation: { $0 + 2 }, test: { ($0 % 2 == 0) ? 5 : 3 }),
            Monkey(items: [99], operation: { $0 + 4 }, test: {($0 % 13 == 0) ? 1 : 5 }),
            Monkey(items: [60, 57, 52], operation: { $0 * 19 }, test: { ($0 % 7 == 0) ? 7 : 6}),
            Monkey(items: [91, 82, 85, 73, 84, 53], operation: { $0 + 5 }, test: { ( $0 % 3 == 0) ? 4 : 1 }),
            Monkey(items: [88, 74, 68, 56], operation: { $0 * $0 }, test: { ($0 % 17 == 0) ? 0 : 2}),
            Monkey(items: [54, 82, 72, 71, 53, 99, 67], operation: { $0 + 1 }, test: { ( $0 % 19 == 0) ? 6 : 0})
        ]
        XCTAssertEqual(observeMonkeys(monkeys, phew: 3, rounds: 20), 110264)

    }
    
    func testExampleReallyWorried() throws {
        let sampleMonkeys = [
            Monkey(items: [79, 98], operation: { $0 * 19 }, test: { ($0 % 23 == 0) ? 2 : 3 }),
            Monkey(items: [54, 65, 75, 74], operation: { $0 + 6 }, test: { ($0 % 19 == 0) ? 2 : 0 }),
            Monkey(items: [79, 60, 97], operation: { $0 * $0 }, test: { ($0 % 13 == 0) ? 1 : 3 }),
            Monkey(items: [74], operation: { $0 + 3 }, test: { ($0 % 17 == 0) ? 0 : 1 })
        ]
        XCTAssertEqual(observeMonkeys(sampleMonkeys, phew: 1, rounds: 10000), 2713310158)
    }
    
    func testPart2() throws {
        
        let monkeys = [
            Monkey(items: [65, 78], operation: { $0 * 3 }, test: { ($0 % 5 == 0) ? 2 : 3 }),
            Monkey(items: [54, 78, 86, 79, 73, 64, 85, 88], operation: { $0 + 8 }, test: { ($0 % 11 == 0) ? 4 : 7 }),
            Monkey(items: [69, 97, 77, 88, 87], operation: { $0 + 2 }, test: { ($0 % 2 == 0) ? 5 : 3 }),
            Monkey(items: [99], operation: { $0 + 4 }, test: {($0 % 13 == 0) ? 1 : 5 }),
            Monkey(items: [60, 57, 52], operation: { $0 * 19 }, test: { ($0 % 7 == 0) ? 7 : 6}),
            Monkey(items: [91, 82, 85, 73, 84, 53], operation: { $0 + 5 }, test: { ( $0 % 3 == 0) ? 4 : 1 }),
            Monkey(items: [88, 74, 68, 56], operation: { $0 * $0 }, test: { ($0 % 17 == 0) ? 0 : 2}),
            Monkey(items: [54, 82, 72, 71, 53, 99, 67], operation: { $0 + 1 }, test: { ( $0 % 19 == 0) ? 6 : 0})
        ]
        XCTAssertEqual(observeMonkeys(monkeys, phew: 3, rounds: 20), 110264)

    }
}

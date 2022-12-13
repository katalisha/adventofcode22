import XCTest
@testable import MonkeyInTheMiddle

final class MonkeyInTheMiddleTests: XCTestCase {
    func testExample() throws {
        let sampleMonkeys = [
            Monkey(items: [79, 98], worryCalculation: { $0 * 19 }, decision: Decision(modulo: 23, zeroModulusMonkey: 2, nonZeroModulusMonkey: 3)),
            Monkey(items: [54, 65, 75, 74], worryCalculation: { $0 + 6 }, decision: Decision(modulo: 19, zeroModulusMonkey: 2, nonZeroModulusMonkey: 0)),
            Monkey(items: [79, 60, 97], worryCalculation: { $0 * $0 }, decision: Decision(modulo: 13, zeroModulusMonkey: 1, nonZeroModulusMonkey: 3)),
            Monkey(items: [74], worryCalculation: { $0 + 3 }, decision: Decision(modulo: 17, zeroModulusMonkey: 0, nonZeroModulusMonkey: 1))
        ]
        XCTAssertEqual(observeMonkeys(sampleMonkeys, worryReduction: 3, rounds: 20), 10605)
    }
    
    func testPart1() throws {
        let monkeys = [
            Monkey(items: [65, 78], worryCalculation: { $0 * 3 }, decision: Decision(modulo: 5, zeroModulusMonkey: 2, nonZeroModulusMonkey: 3)),
            Monkey(items: [54, 78, 86, 79, 73, 64, 85, 88], worryCalculation: { $0 + 8 }, decision: Decision(modulo: 11, zeroModulusMonkey: 4, nonZeroModulusMonkey: 7)),
            Monkey(items: [69, 97, 77, 88, 87], worryCalculation: { $0 + 2 }, decision: Decision(modulo: 2, zeroModulusMonkey: 5, nonZeroModulusMonkey: 3)),
            Monkey(items: [99], worryCalculation: { $0 + 4 }, decision: Decision(modulo: 13, zeroModulusMonkey: 1, nonZeroModulusMonkey: 5)),
            Monkey(items: [60, 57, 52], worryCalculation: { $0 * 19 }, decision: Decision(modulo: 7, zeroModulusMonkey: 7, nonZeroModulusMonkey: 6)),
            Monkey(items: [91, 82, 85, 73, 84, 53], worryCalculation: { $0 + 5 }, decision: Decision(modulo: 3, zeroModulusMonkey: 4, nonZeroModulusMonkey: 1)),
            Monkey(items: [88, 74, 68, 56], worryCalculation: { $0 * $0 }, decision: Decision(modulo: 17, zeroModulusMonkey: 0, nonZeroModulusMonkey: 2)),
            Monkey(items: [54, 82, 72, 71, 53, 99, 67], worryCalculation: { $0 + 1 }, decision: Decision(modulo: 19, zeroModulusMonkey: 6, nonZeroModulusMonkey: 0))
        ]
        XCTAssertEqual(observeMonkeys(monkeys, worryReduction: 3, rounds: 20), 110264)
    }

    func testExampleReallyWorried1() throws {
        let rounds = 10000

        let sampleMonkeys = [
            Monkey(items: [79, 98], worryCalculation: { $0 * 19 }, decision: Decision(modulo: 23, zeroModulusMonkey: 2, nonZeroModulusMonkey: 3)),
            Monkey(items: [54, 65, 75, 74], worryCalculation: { $0 + 6 }, decision: Decision(modulo: 19, zeroModulusMonkey: 2, nonZeroModulusMonkey: 0)),
            Monkey(items: [79, 60, 97], worryCalculation: { $0 * $0 }, decision: Decision(modulo: 13, zeroModulusMonkey: 1, nonZeroModulusMonkey: 3)),
            Monkey(items: [74], worryCalculation: { $0 + 3 }, decision: Decision(modulo: 17, zeroModulusMonkey: 0, nonZeroModulusMonkey: 1))
        ]
        XCTAssertEqual(observeMonkeys(sampleMonkeys, worryReduction: nil, rounds: rounds), 2713310158)
    }
    
    func testPart2() throws {
        
        let monkeys = [
            Monkey(items: [65, 78], worryCalculation: { $0 * 3 }, decision: Decision(modulo: 5, zeroModulusMonkey: 2, nonZeroModulusMonkey: 3)),
            Monkey(items: [54, 78, 86, 79, 73, 64, 85, 88], worryCalculation: { $0 + 8 }, decision: Decision(modulo: 11, zeroModulusMonkey: 4, nonZeroModulusMonkey: 7)),
            Monkey(items: [69, 97, 77, 88, 87], worryCalculation: { $0 + 2 }, decision: Decision(modulo: 2, zeroModulusMonkey: 5, nonZeroModulusMonkey: 3)),
            Monkey(items: [99], worryCalculation: { $0 + 4 }, decision: Decision(modulo: 13, zeroModulusMonkey: 1, nonZeroModulusMonkey: 5)),
            Monkey(items: [60, 57, 52], worryCalculation: { $0 * 19 }, decision: Decision(modulo: 7, zeroModulusMonkey: 7, nonZeroModulusMonkey: 6)),
            Monkey(items: [91, 82, 85, 73, 84, 53], worryCalculation: { $0 + 5 }, decision: Decision(modulo: 3, zeroModulusMonkey: 4, nonZeroModulusMonkey: 1)),
            Monkey(items: [88, 74, 68, 56], worryCalculation: { $0 * $0 }, decision: Decision(modulo: 17, zeroModulusMonkey: 0, nonZeroModulusMonkey: 2)),
            Monkey(items: [54, 82, 72, 71, 53, 99, 67], worryCalculation: { $0 + 1 }, decision: Decision(modulo: 19, zeroModulusMonkey: 6, nonZeroModulusMonkey: 0))
        ]
        XCTAssertEqual(observeMonkeys(monkeys, worryReduction: nil, rounds: 10000), 23612457316)
    }
}

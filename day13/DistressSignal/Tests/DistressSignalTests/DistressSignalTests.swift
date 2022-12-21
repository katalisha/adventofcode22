import XCTest
@testable import DistressSignal

@available(macOS 13.0, *)
final class DistressSignalTests: XCTestCase {
    func testExample() throws {
        let sampleData = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""
        XCTAssertEqual(packets(data: sampleData), 13)
    }
    
    func testFile() throws {
        XCTAssertEqual(runFile(), 13)
    }
    
    func testPair1() throws {
        let sampleData = """
[1,1,3,1,1]
[1,1,5,1,1]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), true)
    }
    
    
    func testPair2() throws {
        let sampleData = """
[[1],[2,3,4]]
[[1],4]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), true)
    }
    
    
    func testPair3() throws {
        let sampleData = """
[9]
[[8,7,6]]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), false)
    }
    
    
    func testPair4() throws {
        let sampleData = """
[[4,4],4,4]
[[4,4],4,4,4]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), true)
    }
    
    
    func testPair5() throws {
        let sampleData = """
[7,7,7,7]
[7,7,7]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), false)
    }
    
    
    func testPair6() throws {
        let sampleData = """
[]
[3]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), true)
    }
    
    func testPair7() throws {
        let sampleData = """
[[[]]]
[[]]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), false)
    }
    
    func testPair8() throws {
        let sampleData = """
[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""
        XCTAssertEqual(isPacketPairInOrder(sampleData), false)
    }
    
}

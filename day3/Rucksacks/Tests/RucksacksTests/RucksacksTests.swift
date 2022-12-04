import XCTest
@testable import Rucksacks

final class RucksacksTests: XCTestCase {
    func testSampleDataSupplyMode() throws {
       let sampleData = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw

"""
        XCTAssertEqual(tallyDuplicateSuppliesInRucksacks(data: sampleData), 157)
    }
    
    func testSampleDataBadgeMode() throws {
        let sampleData = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
        XCTAssertEqual(tallyBadges(data: sampleData), 70)
}
    
    
    func testPriority() throws {
        XCTAssertEqual(characterToPriority("a"), 1)
        XCTAssertEqual(characterToPriority("z"), 26)
        XCTAssertEqual(characterToPriority("A"), 27)

    }
    
    func testFileSupplyMode() throws {
        measure(metrics: [XCTMemoryMetric(), XCTCPUMetric()]) {
            XCTAssertEqual(runFile(mode: .supplies), 7997)
        }
    }
    
    func testFileBadgeMode() throws {
        measure(metrics: [XCTMemoryMetric(), XCTCPUMetric()]) {
            XCTAssertEqual(runFile(mode: .badges), 2545)
        }
    }
    
    func testSetIntersect() throws {
        let set1 = Set("vJrwpWtwJgWrhcsFMMfFFhFp")
        let set2 = Set("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL")
        let set3 = Set("PmmdzqPrVvPwwTWBwg")
        XCTAssertEqual(findDuplicates([set1, set2, set3]), Set("r"))
    }
    
    func testMultipleIterations() throws {
        measure(metrics: [XCTMemoryMetric(), XCTCPUMetric()]) {
            for _ in 1...3000 {
                XCTAssertEqual(runFile(mode: .badges), 2545)
            }
        }
    }
}

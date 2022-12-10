import XCTest
@testable import NoSpace

@available(macOS 13.0, *)
final class NoSpaceTests: XCTestCase {
    func testSampleDataTotalSize() throws {
        let sampleData = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""
        
        XCTAssertEqual(calculateTotal(data: sampleData, mode: .totalSize), 95437)
    }
    
    func testFileTotalSize() throws {
        XCTAssertEqual(runFile(.totalSize), 1611443)
    }
    
    func testSampleDataClosest() throws {
        let sampleData = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""
        
        XCTAssertEqual(calculateTotal(data: sampleData, mode: .closest), 24933642)
    }
    
    func testFileClosestSize() throws {
        XCTAssertEqual(runFile(.closest), 2086088)
    }
}

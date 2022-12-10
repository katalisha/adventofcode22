import Foundation

struct Tree {
    let isVisible: Bool
    var viewingDistance: Int
}

struct Result {
    let totalVisible: Int
    let maxViewingDistance: Int
}

protocol TreeGettable {
    func getTree(j: Int) -> Int?
}

public enum Mode {
    case totalVisible
    case maxViewingDistance
}

public func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    return processData(data: data, mode: mode)
}

public func processData(data: String, mode: Mode) -> Int {
    let grid = createGrid(data: data)
    let result = iterateGrid(grid: grid)
    
    switch mode {
    case .maxViewingDistance:
        return result.maxViewingDistance
    case .totalVisible:
        return result.totalVisible
    }
}

func createGrid(data: String) -> [[Int]] {
    var arr = [[Int]]()
    arr.newRow()
    
    for (index, c) in data.enumerated() {
        if c == "\n" {
            if index < data.count - 1 {
                arr.newRow()
            }
        } else {
            let currentRow = arr.count - 1
            arr.appendToRow(row: currentRow, value: c.wholeNumberValue!)
        }
    }
    return arr
}

func iterateGrid(grid: [[Int]]) -> Result {
    var totalVisible: Int = 0
    var maxViewingDistance: Int = 0
    
    for (i, row) in grid.enumerated() {
        for (j, _) in row.enumerated() {
            let treeData = treeData(i: i, j: j, grid: grid)
            
            if treeData.isVisible {
                totalVisible += 1
            }
            
            if treeData.viewingDistance > maxViewingDistance {
                maxViewingDistance = treeData.viewingDistance
            }
        }
    }
    return Result(totalVisible: totalVisible, maxViewingDistance: maxViewingDistance)
}

func treeData(i: Int, j: Int, grid: [[Int]]) -> Tree {
    if grid.isEdge(i: i, j: j) {
        return Tree(isVisible: true, viewingDistance: 0)
    }
    
    let tree = grid[i][j]
        
    let north = checkDirection(tree: tree, j: j, otherTrees: grid[0..<i].reversed())
    let west = checkDirection(tree: tree, j: j, otherTrees: grid[i][0..<j].reversed())

    // hmmm can't get generic type working with wrapping slice in array
    let east = checkDirection(tree: tree, j: j, otherTrees: Array(grid[i][j+1..<grid.count]))
    let south = checkDirection(tree: tree, j: j, otherTrees: Array(grid[i+1..<grid.count]))
    
    return Tree(isVisible: north.isVisible || south.isVisible || east.isVisible || west.isVisible,
                         viewingDistance: north.viewingDistance * south.viewingDistance * east.viewingDistance * west.viewingDistance)
    
}

// tried some Collection<TreeGettable> to allow ArraySlice did not work
func checkDirection(tree: Int, j: Int, otherTrees: [TreeGettable]) -> Tree {
    for (index, otherTreePosition) in otherTrees.enumerated() {
        if otherTreePosition.getTree(j: j)! >= tree {
            return Tree(isVisible: false, viewingDistance: index + 1)
        }
    }
    return Tree(isVisible: true, viewingDistance: otherTrees.count)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

extension Int : TreeGettable {
    func getTree(j: Int) -> Int? {
        return self
    }
}

extension [Int] : TreeGettable {
    func getTree(j: Int) -> Int? {
        return self[j]
    }
}

fileprivate extension Array<Array<Int>> {
    
    func isEdge(i: Int, j: Int) -> Bool {
        return i == 0 ||
        j == 0 ||
        i == (count - 1) ||
        j == (self[i].count - 1)
    }
    
    mutating func newRow() {
        append([])
    }
    
    mutating func appendToRow(row: Int, value: Int) {
        self[row].append(value)
    }
    
    func rowLength(row: Int) -> Int {
        return self[row].count
    }
}

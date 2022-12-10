import Foundation

public func topElves(_ elvesToReturn: Int) -> Int {
    let file = try! readFile()
    
    let result = file.components(separatedBy: "\n\n")
        .map(parseBlockToArray)
        .sorted()
        .reversed() // this is more readable than custom sort
        .prefix(through: elvesToReturn - 1)
        .reduce(0, +)
    
    return result
}

func parseBlockToArray(block: String) -> Int {
    return block
        .components(separatedBy: "\n")
        .map {Int($0) ?? 0}
        .reduce(0, +)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

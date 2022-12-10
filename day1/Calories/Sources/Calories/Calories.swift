import Foundation

public func topElves(_ elvesToReturn: Int) -> Int {
    let file = try! readFile()
    
    
    let result = file.components(separatedBy: "\n\n")
        .map(parseBlockToArray)
        .sorted()
        .reversed()
        .prefix(through: elvesToReturn - 1)
        .reduce(Int(0), +)
    
    return result
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

func parseBlockToArray(block: String) -> Int {
    return block
        .components(separatedBy: "\n")
        .map {Int($0)}  // parse as int
        .compactMap{$0} // remove nils
        .reduce(0, +)   // sum
}


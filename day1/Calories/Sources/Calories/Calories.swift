import Foundation

public func topElves(numberOfElves: Int) -> Int {
    let file = try! readFile()
    
    return file.components(separatedBy: "\n\n")
        .map { block in
            let elfFood = breakBlockIntoArray(block: block)
            return elfFood.reduce(0, +)
        }
        .sorted()
        .reversed()
        .prefix(through: numberOfElves - 1)
        .reduce(0, +)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

func breakBlockIntoArray(block: String) -> [Int] {
    block.components(separatedBy: "\n")
        .map {Int($0)}
        .compactMap{$0}
}


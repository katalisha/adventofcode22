import Foundation

var stacks: [Stack] = []

public enum Crane {
    case cm9000
    case cm9001
}

enum Processing {
    case stack
    case moves
}

struct Stack {
    private var items: [String] = []
    
    init(items: [String]) {
        self.items = items
    }
    
    func peek() -> String? {
        return items.last
    }
    
    mutating func pop() -> String? {
        return (items.count > 0) ? items.popLast() : nil
    }
    
    mutating func pop(_ i: Int) -> [String] {
        let result = Array(items.suffix(i))
        items.removeLast(i)
        return result
    }
    
    mutating func push(_ element: String) {
        items.append(element)
    }
    
    mutating func push(_ elements: [String]) {
        items = items + elements
    }
}

public func runFile(crane: Crane) -> String {
    let data = try! readFile()
    return moveCrates(data: data, crane: crane)
}

public func moveCrates(data: String, crane: Crane) -> String {
    var processing: Processing = .stack
    let crateRegex = try! NSRegularExpression(pattern: "\\[([A-Z])\\]")
    let moveRegex = try! NSRegularExpression(pattern: "move (\\d+) from (\\d+) to (\\d+)")

    var cratesInput: [[String]] = []
    let lines = data.components(separatedBy: "\n")
    lines.forEach { line in
        
        // create empty crate arrays
        if cratesInput.count == 0 {
            let stackCount = Int(line.count/4) + 1
            for _ in 0...stackCount {
                cratesInput.append([])
            }
        }
        
        // empty line indicates switching to move input
        if line == "" && processing == .stack {
            stacks = cratesInput.map { Stack(items: $0.reversed()) }
            processing = .moves
            print(stacks)
        }
        // pracess crates
        else if processing == .stack {
            let crates = crateRegex.matches(in: line, range: NSRange(location: 0, length: line.utf16.count))
            crates.forEach { match in
                let stackIndex = Int(match.range(at: 1).lowerBound/4)
                let range = Range(match.range(at: 1), in: line)!
                let crateId = line[range]
                cratesInput[stackIndex].append(String(crateId))
            }
        }
        // proces moves
        else if processing == .moves {
            if let move = moveRegex.firstMatch(in: line, range: NSRange(location: 0, length: line.utf16.count)) {
                let range1 = Range(move.range(at: 1), in: line)!
                let crates = Int(line[range1])!
                let range2 = Range(move.range(at: 2), in: line)!
                let from = Int(line[range2])!-1
                let range3 = Range(move.range(at: 3), in: line)!
                let to = Int(line[range3])!-1

                makeMove(crates: crates, from: from, to: to, crane: crane)
            }
        }
    }
    
    return stacks.reduce("") { partialResult, stack in
        partialResult + (stack.peek() ?? "")
    }
}

func makeMove(crates: Int, from: Int, to: Int, crane: Crane) -> Void {
    if crane == .cm9000 {
        for _ in 0..<crates {
            let crate = stacks[from].pop()
            stacks[to].push(crate!)
        }
    } else {
        let crates = stacks[from].pop(crates)
        stacks[to].push(crates)
    }
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

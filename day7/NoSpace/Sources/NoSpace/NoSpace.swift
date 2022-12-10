import Foundation
import RegexBuilder


public enum Mode {
    case totalSize
    case closest
}

// could do this as just [Int]
struct Dir {
    let name: String
    var total: Int
}

struct Stack<T> {
    private var items: [T] = []
    
    mutating func push(element: T) {
        items.append(element)
    }
    
    mutating func pop() -> T? {
        return items.popLast()
    }
    
    func peek() -> T? {
        return items.last
    }
}

struct DirectoryData {
    static let maxSize = 100000
    private(set) var dirs = [Dir]()
    private(set) var total: Int = 0
    
    var stack = Stack<Dir>()
    
    mutating func rollUpChildTotal() {
        guard let child = stack.pop() else { return }

        dirs.append(child)

        if let parent = stack.pop() {
            stack.push(element: Dir(name: parent.name, total: parent.total + child.total))
        }
        
        total += ((child.total < DirectoryData.maxSize) ? child.total : 0)
    }
    
    func dirToRemove(totalSpace: Int, requiredSpace: Int) -> Int {
        let usedSpace = dirs.first { d in
            d.name == "/"
        }!.total
        
        let neededSpace = requiredSpace - (totalSpace - usedSpace)
        
        let sortedDirs = dirs.sorted() { e1, e2 in
            e1.total < e2.total
        }
        
        return sortedDirs.first { d in
            d.total > neededSpace
        }!.total
    }
}

@available(macOS 13.0, *)
public func runFile(_ mode: Mode) -> Int {
    let data = try! readFile()
    return calculateTotal(data: data, mode: mode)
}

@available(macOS 13.0, *)
public func calculateTotal(data: String, mode: Mode) -> Int {
    let state = getTotals(data: data)
    
    let totalSpace = 70000000
    let requiredSpace = 30000000
    
    switch(mode) {
    case .closest:
        return state.dirToRemove(totalSpace: totalSpace, requiredSpace: requiredSpace)
    case.totalSize:
        return state.total
    }
}

@available(macOS 13.0, *)
func getTotals(data: String) -> DirectoryData {
    
    var result: DirectoryData = data.components(separatedBy: "\n").reduce(into: DirectoryData()) { state, line in
        switch(line) {
        case "$ cd ..":
            state.rollUpChildTotal()
                                   
        case _ where line.contains("$ cd"):
            let name = getDirName(line)! // must work
            state.stack.push(element: Dir(name: name, total: 0))
            
        default:
            if let total = getTotalFromString(line) {
                var elem = state.stack.pop()!
                elem.total += total
                state.stack.push(element: elem)
            }
        }
    }
    
    while(result.stack.peek() != nil) {
        result.rollUpChildTotal()
    }

    return result
}

@available(macOS 13.0, *)
func getTotalFromString(_ line: String) -> Int? {
    // e.g. "14848514 b.txt"

    let regex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore (.digit)
        }
        transform: { filesize in
            Int(filesize)
       }
    }
    
    let match = line.firstMatch(of: regex)
                                 
    return match?.1
}

@available(macOS 13.0, *)
func getDirName(_ line: String) -> String? {
    // e.g. "$ cd e"

    let regex = Regex {
        Anchor.startOfLine
        "$ cd "
        Capture {
            OneOrMore(.whitespace.inverted)
        }         transform: { name in
            String(name)
       }
        Anchor.endOfLine
    }

    let match = line.firstMatch(of: regex)

    return match?.1
}


func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

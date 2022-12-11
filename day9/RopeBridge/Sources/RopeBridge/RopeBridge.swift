import Foundation
import RegexBuilder

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Rope: Equatable {
    let head: Point
    let tail: Point
}

struct Move {
    let direction: Direction
    let distance: Int
}

enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

@available(macOS 13.0, *)
public func runFile() -> Int {
    let data = try! readFile()
    return processData(data: data)
}

@available(macOS 13.0, *)
func processData(data: String) -> Int {
    var rope = Rope(head: Point(x: 0, y: 0), tail: Point(x: 0, y: 0))
    let pointCount = data.components(separatedBy: "\n")
        .reduce(into: [Point: Int]()) { partialResult, line in
            if let move = parseLine(line: line) {
                for _ in 1...move.distance {
                    rope = calculateMove(direction: move.direction, rope: rope)
                    partialResult[rope.tail, default: 0] += 1
                }
            }
        }
    
    return pointCount.count
}

@available(macOS 13.0, *)
func parseLine(line: String) -> Move? {
    let regex = Regex {
        Capture {
            ChoiceOf {
                "U"
                "D"
                "L"
                "R"
            }
        } transform: { d in
            Direction(rawValue: String(d))
        }
        One(.whitespace)
        Capture {
            OneOrMore(.digit)
        } transform: { n in
            Int(n)
        }
    }
    if let matches = try? regex.wholeMatch(in: line) {
        return Move(direction: matches.1!, distance: matches.2!)
    }
    
    return nil
}

func calculateMove(direction: Direction, rope: Rope) -> Rope {
    var newHead: Point
    var newTail = rope.tail
    
    switch direction {
    case .up:
        newHead = Point(x: rope.head.x, y: rope.head.y + 1)
    case .right:
        newHead = Point(x: rope.head.x + 1, y: rope.head.y)
    case .down:
        newHead = Point(x: rope.head.x, y: rope.head.y - 1)
    case .left:
        newHead = Point(x: rope.head.x - 1, y: rope.head.y)
    }
    
    let horizotalDiff = newHead.x - rope.tail.x
    let verticalDiff = newHead.y - rope.tail.y
    
    switch (horizotalDiff, verticalDiff) {
        case let (h, v) where h < -1 && v < 0,
            let (h, v) where h < 0 && v < -1:
            newTail.x -= 1
            newTail.y -= 1
        
        case let (h, v) where h > 0 && v > 1,
            let (h, v) where h > 1 && v > 0:
            newTail.x += 1
            newTail.y += 1
        
        case let (h, v) where h < -1 && v > 0,
            let (h, v) where h < 0 && v > 1:
            newTail.x -= 1
            newTail.y += 1
            
        case let (h, v) where h > 1 && v < 0,
            let (h, v) where h > 0 && v < -1:
            newTail.x += 1
            newTail.y -= 1
        
        case let (h, _) where h < -1:
            newTail.x -= 1
            
        case let (h, _) where h > 1:
            newTail.x += 1
    
        case let (_, v) where v < -1:
            newTail.y -= 1
            
        case let (_, v) where v > 1:
            newTail.y += 1
            
        default:
            break
    }
    
    return Rope(head: newHead, tail: newTail)
}



func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

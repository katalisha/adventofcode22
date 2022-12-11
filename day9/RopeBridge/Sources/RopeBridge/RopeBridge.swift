import Foundation
import RegexBuilder

struct Point: Hashable {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init() {
        self.x = 0
        self.y = 0
    }
}

typealias Rope = [Point]

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
public func runFile(knots: Int) -> Int {
    let data = try! readFile()
    return processData(data: data, knots: knots)
}

@available(macOS 13.0, *)
func processData(data: String, knots: Int) -> Int {
    var rope = Rope(repeating: Point(), count: knots)
    
    let locationTally = data.components(separatedBy: "\n")
        .reduce(into: [Point(x: 0, y: 0): 1]) { tally, line in
            
            if let move = parseLine(line: line) {
                for _ in 1...move.distance {
                    
                    var previousKnot: Point?
                    
                    rope = rope.map { currentPosition in
                        guard let head = previousKnot else {
                            let newPosition = moveHead(direction: move.direction, currentPosition: currentPosition)
                            previousKnot = newPosition
                            return newPosition
                        }
                        let newTail = moveTail(newHead: head, currentPosition: currentPosition)
                        previousKnot = newTail
                        return newTail
                    }
                    tally[rope.last!, default: 0] += 1
                }
            }
        }
    
    return locationTally.count
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

func moveHead(direction: Direction, currentPosition: Point) -> Point {
    switch direction {
    case .up:
        return Point(x: currentPosition.x, y: currentPosition.y + 1)
    case .right:
        return Point(x: currentPosition.x + 1, y: currentPosition.y)
    case .down:
        return Point(x: currentPosition.x, y:  currentPosition.y - 1)
    case .left:
        return Point(x: currentPosition.x - 1, y: currentPosition.y)
    }
}

func moveTail(newHead: Point, currentPosition: Point) -> Point {
    var newTail = currentPosition
    
    let horizotalDiff = newHead.x - currentPosition.x
    let verticalDiff = newHead.y - currentPosition.y
    
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
    
    return newTail
}



func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

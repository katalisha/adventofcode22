import Foundation
import RegexBuilder

enum Instruction {
    case noop
    case addx(Int)
}

struct Command {
    let instruction: Instruction
    var inCycles: Int
    var running = true
    
    init(instruction: Instruction) {
        self.instruction = instruction
        
        switch instruction {
        case .noop:
            self.inCycles = 0
        case .addx(_):
            self.inCycles = 1
        }
    }
}

@available(macOS 13.0, *)
public func runFile() -> Int {
    let data = try! readFile()
    return processData(data: data)
}

@available(macOS 13.0, *)
public func processData(data: String) -> Int {
    var lines = data.components(separatedBy: "\n").makeIterator()
    var cycle = 1
    var executing: Command!
    var x = 1
    var signalSum = 0
        
    while true {
        
        if executing?.running != true {
            if let line = lines.next(),
               let nextCommand = parseLine(line: line) {
                executing = nextCommand
             } else {
                 break
             }
        }
        
        x = executeCommand(&executing, x: x)

        cycle += 1

        if cycle == 20 || ((cycle - 20) % 40) == 0 {
            signalSum += cycle * x
           print("cycle: \(cycle) x: \(x) = \(cycle * x)")
        }
    }
    return signalSum
}

func executeCommand(_ command: inout Command, x: Int) -> Int {
    guard command.inCycles == 0 else { command.inCycles -= 1; return x }
    
    command.running = false
    switch command.instruction {
    case .noop:
        return x
    case let .addx(i):
        return x + i
    }
}


@available(macOS 13.0, *)
func parseLine(line: String) -> Command? {
    let regex = Regex {
        Capture {
            ChoiceOf {
                "noop"
                "addx"
            }
        }
        ZeroOrMore(" ")
        Capture {
            ZeroOrMore("-")
            ZeroOrMore(.digit)
        } transform: { d in
            Int(d)
        }
    }
    if let matches = try? regex.wholeMatch(in: line) {
        switch matches.1 {
        case "noop":
            return Command(instruction: .noop)
        case "addx":
            return Command(instruction: .addx(matches.2!))
        default:
            return nil
        }
    }
    return nil
}



func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

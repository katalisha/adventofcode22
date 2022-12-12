import Foundation
import RegexBuilder

enum Command {
    case noop
    case addx(Int)
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
    var executing: Command?
    var commandCountDown = 0
    var x = 1
    var signalSum = 0
        
    while true {
        if commandCountDown > 0 {
            commandCountDown -= 1
        } else if let line = lines.next(),
                  let command = parseLine(line: line) {
            commandCountDown = cyclesNeeded(command: command)
            executing = command
        } else {
            break
        }
        

        if let command = executing, commandCountDown == 0 {
            switch command {
            case .noop: break
            case let .addx(i):
                x += i
                print("cycle: \(cycle) addx: \(i) x: \(x)" )

            }
            executing = nil
        }

        cycle += 1

        if cycle == 20 || ((cycle - 20) % 40) == 0 {
            signalSum += cycle * x
           print("cycle: \(cycle) x: \(x) = \(cycle * x)")
        }
    }
    return signalSum
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
            return .noop
        case "addx":
            return .addx(matches.2!)
        default:
            return nil
        }
    }
    return nil
}

func cyclesNeeded(command: Command) -> Int {
    switch command {
    case .noop:
        return 0
    case .addx(_):
        return 1
    }
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

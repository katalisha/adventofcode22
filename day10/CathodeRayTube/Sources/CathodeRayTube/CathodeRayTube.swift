import Foundation
import RegexBuilder

enum Instruction {
    case noop
    case addx(Int)
}

struct Command {
    let instruction: Instruction
    var cyclesRemaining: Int
    var running = true
    
    init(instruction: Instruction) {
        self.instruction = instruction
        
        switch instruction {
        case .noop:
            self.cyclesRemaining = 0
        case .addx(_):
            self.cyclesRemaining = 1
        }
    }
}

struct State {
    private (set) var cycle: Int
    private (set) var registerX: Int
    private (set) var signalSum: Int = 0
    private (set) var output: String = ""
    var command: Command
    var currentPixel: Int {
        get {
            return ((cycle - 1) % 40)
        }
    }
    
    init() {
        self.cycle = 1
        self.registerX = 1
        self.command = Command(instruction: .noop)
        self.command.running = false
    }
    
    mutating func executeCommand() {
        guard command.cyclesRemaining == 0 else { command.cyclesRemaining -= 1; return }
        
        command.running = false
        
        switch command.instruction {
            case .noop:
                break
            case let .addx(i):
                registerX += i
        }
    }
    
    mutating func startCycle() {
        draw()
    }
    
    mutating func endCycle() {
        cycle += 1
        updateSignalSum()
    }
    
    private mutating func draw() {
        if currentPixel <= registerX + 1 &&
            currentPixel >= registerX - 1 {
            output.append("#")
        } else {
            output.append(".")

        }
        if cycle % 40 == 0 {
            output.append("\n")
        }
    }
    
    private mutating func updateSignalSum() {
        if cycle == 20 || ((cycle - 20) % 40) == 0 {
            signalSum += cycle * registerX
        }
    }
}

@available(macOS 13.0, *)
public func signalStrength(data: String?) -> Int {
    let data = try! data ?? readFile()
    let state = processData(data: data)
    return state.signalSum
}

@available(macOS 13.0, *)
public func output(data: String?) -> String {
    let data = try! data ?? readFile()
    let state = processData(data: data)
    return state.output
}

@available(macOS 13.0, *)
func processData(data: String) -> State {
    var lines = data.components(separatedBy: "\n").makeIterator()
    var state = State()
        
    while true {
        if state.command.running != true {
            if let line = lines.next(),
               let nextCommand = parseLine(line: line) {
                state.command = nextCommand
             } else {
                 break
             }
        }
        state.startCycle()
        state.executeCommand()
        state.endCycle()
    }
    return state
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

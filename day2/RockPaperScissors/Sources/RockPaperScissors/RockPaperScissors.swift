import Foundation

public enum FileFormat {
    case generateResult
    case generateSign
}

protocol GameElement {
    func score(opp: Sign) -> Int
}

enum Sign: Int, CaseIterable, GameElement {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    init?(value: String) {
        switch value {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            return nil
        }
    }
    
    func score(opp: Sign) -> Int {
        let result = GameLogic().result(opponent: opp, me: self)
        return self.rawValue + result.rawValue
    }
}

enum Result: Int, CaseIterable, GameElement {
    case win = 6
    case draw = 3
    case loss = 0
    
    init?(value: String) {
        switch value {
        case "X":
            self = .loss
        case "Y":
            self = .draw
        case "Z":
            self = .win
        default:
            return nil
        }
    }
    
    func score(opp: Sign) -> Int {
        let sign = GameLogic().sign(opponent: opp, result: self)
        return sign.rawValue + self.rawValue
    }
}

struct Rule {
    let opponent: Sign
    let me: Sign
    let result: Result
}

struct GameLogic {
    let rules: [Rule] = [
        Rule(opponent: .rock, me: .rock, result: .draw),
        Rule(opponent: .paper, me: .paper, result: .draw),
        Rule(opponent: .scissors, me: .scissors, result: .draw),
        
        Rule(opponent: .rock, me: .scissors, result: .loss),
        Rule(opponent: .scissors, me: .paper, result: .loss),
        Rule(opponent: .paper, me: .rock, result: .loss),
        
        Rule(opponent: .rock, me: .paper, result: .win),
        Rule(opponent: .paper, me: .scissors, result: .win),
        Rule(opponent: .scissors, me: .rock, result: .win)
    ]
    
    func result(opponent: Sign, me: Sign) -> Result {
        let match = rules.first { $0.opponent == opponent && $0.me == me }
        return match!.result
    }
    
    func sign(opponent: Sign, result: Result) -> Sign {
        let match = rules.first { $0.opponent == opponent && $0.result == result }
        return match!.me
    }
}

public func score(fileFormat: FileFormat) -> Int {
    let file = try! readFile()
    return process(data: file, fileFormat: fileFormat)
}

func process(data: String, fileFormat: FileFormat) -> Int {
    return data.components(separatedBy: "\n")
        .reduce(0) { partialResult, line in
            let game = line.components(separatedBy: " ")
            let score = score(game: game, fileFormat: fileFormat)
            return partialResult + (score ?? 0)
        }
}

func score(game: [String], fileFormat: FileFormat) -> Int? {
    guard game.count == 2 else { return nil }
    guard let opp = Sign(value: game[0]) else { return nil }
    let gameElement = parse(game[1], fileFormat: fileFormat)
    return gameElement?.score(opp: opp)
}

func parse(_ string: String, fileFormat: FileFormat) -> GameElement? {
    switch(fileFormat) {
        case .generateResult:
            return Sign(value: string)
        case .generateSign:
            return Result(value: string)
    }
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

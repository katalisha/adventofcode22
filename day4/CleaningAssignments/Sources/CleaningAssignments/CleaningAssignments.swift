import Foundation
import RegexBuilder

public enum Mode {
    case full
    case partial
}

@available(macOS 13.0, *)
public func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    
    return countOverlaps(data: data, mode: mode)
}

@available(macOS 13.0, *)
public func countOverlaps(data: String, mode: Mode) -> Int {
    let lines = data.components(separatedBy: "\n")
    return lines.reduce(0) { tallySubsets, line in

        if compareAreas(line: line, mode: mode) {
            return tallySubsets + 1
        }
        return tallySubsets
    }
}

@available(macOS 13.0, *)
func compareAreas(line: String, mode: Mode) -> Bool {
//    this regex not working
//    let pattern = #/(\d+)\-(\d+),(\d+)\-(\d+)/#
//    let regex = Regex(pattern)

    let regex = Regex {
        Capture {
            OneOrMore(.digit)
        } transform: { area in
            Int(area)
        }
        "-"
        Capture {
            OneOrMore(.digit)
        } transform: { area in
            Int(area)
        }
        ","
        Capture {
            OneOrMore(.digit)
        } transform: { area in
            Int(area)
        }
        "-"
        Capture {
            OneOrMore(.digit)
        } transform: { area in
            Int(area)
        }
    }
    
    if let result = line.wholeMatch(of: regex) {
              
        let area1 = Set(stride(from: result.1!, through: result.2!, by: 1))
        let area2 = Set(stride(from: result.3!, through: result.4!, by: 1))

        if mode == .full {
            return hasFullOverlap(area1, area2)
        } else {
            return hasAnyOverlap(area1, area2)
        }
    }
    return false
}

func hasFullOverlap(_ area1: Set<Int>, _ area2: Set<Int>) -> Bool {
    return area1.isSubset(of: area2) || area1.isSuperset(of: area2)
}

func hasAnyOverlap(_ area1: Set<Int>, _ area2: Set<Int>) -> Bool {
    return area1.intersection(area2).count > 0
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

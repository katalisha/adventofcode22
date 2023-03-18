import Foundation

typealias Scan = Dictionary<String, ScanLine>
typealias Cave = Dictionary<String, Valve>
 
struct ScanLine: Hashable {
    let flowRate: Int
    let name: String
    let neighbours: [String]
}

struct Valve: Hashable {
    let flowRate: Int
    let name: String
    let tunnels: Set<Tunnel>
    var open = false
}

struct Tunnel: CustomStringConvertible, Hashable {
    let endValve: String
    let distance: Int
    
    var description: String {
        return "\(endValve): \(distance)"
    }
}

struct State {
    var cave: Cave
    var minute: Int
    var pressureReleased: Int
    var currentPosition: String
    
    mutating func tick() {
        minute += 1
        pressureReleased += cave.reduce(0, { $0 + (($1.value.open) ? $1.value.flowRate : 0)})
    }
    
    mutating func opening(valveName: String) {
        cave[valveName]!.open = true
        // tick
    }

    mutating func movingTo(valveName: String) {
        currentPosition = valveName
        // todo tick for distance
    }
}

// MARK: Main

@available(macOS 13.0, *)
func runFile() -> Int {
    let data = try! readFile()
    return achieveMaximumFlow(data: data)
}

@available(macOS 13.0, *)
func achieveMaximumFlow(data: String) -> Int {
    let valves = data.components(separatedBy: "\n")
        .compactMap { parseLine(line: $0) }
    
    let originName = "AA"
    
    let cave = buildCave(originName: originName, valves: Dictionary(uniqueKeysWithValues: valves))
    
    let _ = State(cave: cave, minute: 0, pressureReleased: 0, currentPosition: originName)

    
    print(cave)
    return 0
}


// MARK: Pathfinding

func buildCave(originName: String, valves: Scan) -> Cave {
    return Dictionary(uniqueKeysWithValues: valves
        .filter{ $0.key == originName || $0.value.flowRate > 0}
        .map { ($0.value.name,
                Valve(
                    flowRate: $0.value.flowRate,
                    name: $0.key,
                    tunnels: visitNeighbours(
                        neighbourNames: [$0.value.name],
                        distance: 0,
                        visitedNames: [],
                        allValves: valves,
                        tunnels: []
                    )
                )
            )
        }
    )
}

func visitNeighbours(neighbourNames: Set<String>, distance: Int, visitedNames: Set<String>, allValves: Scan, tunnels: Set<Tunnel>) -> Set<Tunnel> {
    let unvistedNeighbourValves = neighbourNames
        .subtracting(visitedNames)
        .compactMap { allValves[$0] }

    guard !unvistedNeighbourValves.isEmpty else { return tunnels }

    let newTunnels = (distance == 0) ? [] :
        unvistedNeighbourValves
            .filter{ $0.flowRate > 0 }
            .map{ Tunnel(endValve: $0.name, distance: distance)}
    
    let nextNeighbourNames = unvistedNeighbourValves.flatMap { $0.neighbours }

    return visitNeighbours(neighbourNames: Set(nextNeighbourNames),
                        distance: distance + 1,
                        visitedNames: visitedNames.union(neighbourNames),
                        allValves: allValves,
                        tunnels: tunnels.union(newTunnels))
}

// MARK: Parsing

@available(macOS 13.0, *)
func parseLine(line: String) -> (String, ScanLine)? {
    let regex = #/Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z]{2},?\s?)+)/#
    guard let match = line.wholeMatch(of: regex) else { return nil }
    let neighbours = match.3.components(separatedBy: ", ")
    let name = String(match.1)
    let flowRate = Int(match.2)!
    
    return (name, ScanLine(flowRate: flowRate, name: name, neighbours: neighbours))
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

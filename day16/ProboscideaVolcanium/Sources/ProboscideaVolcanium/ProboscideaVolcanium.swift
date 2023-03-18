import Foundation

struct Valve: Hashable {
    let flowRate: Int
    let name: String
    let neighbours: [String]
    var open = false
}

struct Tunnel: CustomStringConvertible {
    let endValve: String
    let distance: Int
    
    var description: String {
        return "\(endValve): \(distance)"
    }
}

struct State {
    var valves: Set<Valve>
    let minute: Int
    let pressureReleased: Int
    var currentPosition: String
    
    func tick() -> State {
        return State(valves: valves,
                     minute: minute + 1,
                     pressureReleased: pressureReleased + valves.reduce(0, { $0 + (($1.open) ? $1.flowRate : 0)}),
                     currentPosition: currentPosition)
    }
    
    func opening(valveName: String) -> State {
        var valve = valves.first(where: {$0.name == valveName})!
        var tempValves = valves.subtracting(Set([valve]))
        valve.open = true
        tempValves.insert(valve)

        return State(valves: tempValves,
                     minute: minute,
                     pressureReleased: pressureReleased,
                     currentPosition: currentPosition)
    }

    func movingTo(valveName: String) -> State {
        return State(valves: valves,
                     minute: minute,
                     pressureReleased: pressureReleased,
                     currentPosition: valveName)
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
    
    let state = State(valves: Set(valves), minute: 0, pressureReleased: 0, currentPosition: "AA")
    
    let cave = buildCave(originId: "AA", valves: state.valves)
    
    print(cave)
    return 0
}


// MARK: Pathfinding

func buildCave(originId: String, valves: Set<Valve>) -> Dictionary<String, Array<Tunnel>> {
    return Dictionary(uniqueKeysWithValues: valves
        .filter{ $0.name == originId || $0.flowRate > 0}
        .map { ($0.name, visitNeighbours(neighbours: [$0],
                                         distance: 0,
                                         visited: [],
                                         allValves: valves,
                                         tunnels: [])) }
    )
}

func visitNeighbours(neighbours: Set<Valve>, distance: Int, visited: Set<Valve>, allValves: Set<Valve>, tunnels: [Tunnel]) -> [Tunnel] {
    let possibleEndpoints = neighbours.subtracting(visited)
    guard !possibleEndpoints.isEmpty else { return tunnels }
  
    let newTunnels = (distance == 0) ? [] :
        possibleEndpoints
            .filter{ $0.flowRate > 0 }
            .map{ Tunnel(endValve: $0.name, distance: distance)}
    
    let nextNeighbourIds = possibleEndpoints.flatMap { $0.neighbours }
    
    let nextNeighbours = Set(nextNeighbourIds.compactMap { s in
        allValves.first { v in
            v.name == s
        }
    })
    
    return visitNeighbours(neighbours: nextNeighbours,
                        distance: distance + 1,
                        visited: visited.union(possibleEndpoints),
                        allValves: allValves,
                        tunnels: tunnels + newTunnels)
}

// MARK: Parsing

@available(macOS 13.0, *)
func parseLine(line: String) -> Valve? {
    let regex = #/Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z]{2},?\s?)+)/#
    guard let match = line.wholeMatch(of: regex) else { return nil }
    let neighbours = match.3.components(separatedBy: ", ")
    
    return Valve(flowRate: Int(match.2)!, name: String(match.1), neighbours: neighbours)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

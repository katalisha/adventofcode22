// 3.3 seconds, 1544839 loops
import Foundation

typealias Scan = Dictionary<String, ScanLine>
typealias Cave = Dictionary<String, Valve>
typealias StateQueue = [(State, Set<Tunnel>)]
 
enum VolcanoError: Error {
    case inconsistentState
}

enum StateUpdateResult {
    case changed(state:State)
    case finished(state:State)
}

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

struct Tunnel: Hashable {
    let endValve: String
    let distance: Int
}

struct State {
    let cave: Cave
    let minute: Int
    let totalPressureReleased: Int
    let currentPosition: String
    var currentValve: Valve {
        get { cave[currentPosition]! }
    }
    
    func filterTunnelsToClosedValves(_ tunnels: Set<Tunnel>) -> Set<Tunnel> {
        let openValves = cave.compactMap{ (key: String, value: Valve) in
            return value.open ? key : nil
        }
        return tunnels.filter { !openValves.contains($0.endValve) }
    }
    
    func possibleTunnels() -> Set<Tunnel> {
        return filterTunnelsToClosedValves(currentValve.tunnels)
    }
}

struct StateManager {
    let maxTime: Int
    
    func tick(state: State, cycles: Int = 1) -> StateUpdateResult {
        let maxCycles = min((maxTime - state.minute), cycles)
        let minute = state.minute + maxCycles

        let totalPressureReleased = (state.cave.reduce(0, { $0 + (($1.value.open) ? $1.value.flowRate : 0)}) * maxCycles) + state.totalPressureReleased
        let newState = State(cave: state.cave, minute: minute, totalPressureReleased: totalPressureReleased, currentPosition: state.currentPosition)
        
        if minute >= maxTime {
            return .finished(state: newState)
        }
        return .changed(state: newState)
    }
    
    func opening(state: State, valveName: String) throws -> StateUpdateResult {
        guard (valveName == state.currentPosition && state.currentValve.open == false) else { throw  VolcanoError.inconsistentState }
        let tickResult = tick(state: state)
        
        switch tickResult {
            case .finished(_):
                return tickResult
            case .changed(let state):
                var cave = state.cave
                cave[valveName]!.open = true
                return .changed(state: State(cave: cave,
                                             minute: state.minute,
                                             totalPressureReleased: state.totalPressureReleased,
                                             currentPosition: state.currentPosition))
        }
    }

    func movingTo( state: State, valveName: String) -> StateUpdateResult {
        let tunnelTaken = state.currentValve.tunnels.first(where: { $0.endValve == valveName })!
        let tickResult = tick(state: state, cycles: tunnelTaken.distance)
        
        switch tickResult {
            case .finished(state: _):
                return tickResult
            case .changed(state: let state):
                return .changed(state: State(cave: state.cave,
                                             minute: state.minute,
                                             totalPressureReleased: state.totalPressureReleased,
                                             currentPosition: valveName))

        }
    }
    
    func toNextState(state: State, openingValve: String?) -> StateUpdateResult {
        var result: StateUpdateResult
        
        if let next = openingValve {
            result = movingTo(state: state, valveName: next)
            
            switch result {
            case .changed(state: let state):
                result = try! opening(state: state, valveName: next)
            case .finished(state: _):
                return result
            }
        } else {
            result = tick(state: state)
        }
        return result
    }
    
    func runQueue(initialQueue: StateQueue) throws -> Int {
        var maxPressure = 0
        var queue = initialQueue
        var loops = 0
        
        while let (state, tunnels) = queue.popLast() {

            for t in tunnels {
                loops += 1
                let result = toNextState(state: state, openingValve: t.endValve)
                
                switch result {
                    case .changed(state: let state):
                        // eliminate open tunnels
                        let nextTunnels = state.possibleTunnels()
                        
                        if nextTunnels.count == 0 {
                            let result = tick(state: state, cycles: maxTime - state.minute + 1)
                            // run out the clock for states with no tunnels
                            switch result {
                                case .finished(state: let state):
                                    maxPressure = max(maxPressure, state.totalPressureReleased)
                                default:
                                    throw VolcanoError.inconsistentState
                            }
                        } else {
                            //queue append if more tunnels
                            queue.append((state, nextTunnels))
                        }
                    case .finished(state: let state):
                        maxPressure = max(maxPressure, state.totalPressureReleased)
                        break
                }
            }
        }
        print("loops: \(loops)")
        return maxPressure
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
    let state = State(cave: cave, minute: 0, totalPressureReleased: 0, currentPosition: originName)
    let stateManager = StateManager(maxTime: 30)
    return try! stateManager.runQueue(initialQueue: [(state, cave[originName]!.tunnels)])
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

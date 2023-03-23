// 2.4 seconds, 794196 loops
import Foundation

// MARK: Model

typealias Scan = Dictionary<String, ScanLine>
typealias Cave = Dictionary<String, Valve>
typealias StateStack = [(State, Set<Tunnel>)]
 
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
    
    func removeTunnelsToOpenValves(_ tunnels: Set<Tunnel>) -> Set<Tunnel> {
        let openValves = cave.compactMap{ $0.value.open ? $0.key : nil }
        return tunnels.filter { !openValves.contains($0.endValve) }
    }
    
    func possibleTunnels() -> Set<Tunnel> {
        return removeTunnelsToOpenValves(currentValve.tunnels)
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
        var cave = state.cave
        cave[valveName]!.open = true
        return tick(state: State(cave: cave,
                                 minute: state.minute,
                                 totalPressureReleased: state.totalPressureReleased,
                                 currentPosition: state.currentPosition))
    }

    func movingTo( state: State, valveName: String) throws -> StateUpdateResult {
        guard let tunnelTaken = state.currentValve.tunnels.first(where: { $0.endValve == valveName }) else { throw  VolcanoError.inconsistentState }
        return tick(state: State(cave: state.cave,
                                 minute: state.minute,
                                 totalPressureReleased: state.totalPressureReleased,
                                 currentPosition: valveName),
                    cycles: tunnelTaken.distance)
    }
    
    func toNextState(state: State, openingValve: String) throws -> StateUpdateResult {
        let moveResult = try movingTo(state: state, valveName: openingValve)
        switch moveResult {
            case .finished(state: _):
                return moveResult
            case .changed(state: let state):
                let openResult = try opening(state: state, valveName: openingValve)
                return openResult
        }
    }
    
    func runQueue(initialStack: StateStack) throws -> Int {
        var maxPressure = 0
        var stack = initialStack
        var loops = 0
        
        while let (state, tunnels) = stack.popLast() {

            for t in tunnels {
                loops += 1
                let result = try! toNextState(state: state, openingValve: t.endValve)
                
                switch result {
                    case .finished(state: let state):
                        maxPressure = max(maxPressure, state.totalPressureReleased)
                        break
                    
                    case .changed(state: let state):
                        let nextTunnels = state.possibleTunnels()
                        if nextTunnels.count > 0 {
                            stack.append((state, nextTunnels))
                        } else {
                            let finalResult = tick(state: state, cycles: maxTime - state.minute)
                            guard case let .finished(state) = finalResult else { throw VolcanoError.inconsistentState }
                            maxPressure = max(maxPressure, state.totalPressureReleased)
                        }
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
func achieveMaximumFlow(data: String, originName: String = "AA") -> Int {
    let valves = Dictionary(uniqueKeysWithValues: data
        .components(separatedBy: "\n")
        .compactMap { parseLine(line: $0) })
    
    let cave = buildCave(originName: originName, valves: valves)
    let state = State(cave: cave, minute: 1, totalPressureReleased: 0, currentPosition: originName)
    let stateManager = StateManager(maxTime: 30)
    return try! stateManager.runQueue(initialStack: [(state, cave[originName]!.tunnels)])
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
                        neighbours: [$0.value.name],
                        distance: 0,
                        visited: [],
                        scan: valves,
                        tunnels: []
                    )
                )
            )
        }
    )
}

func visitNeighbours(neighbours: Set<String>, distance: Int, visited: Set<String>, scan: Scan, tunnels: Set<Tunnel>) -> Set<Tunnel> {
    let unvisitedScanData = neighbours
        .subtracting(visited)
        .compactMap { scan[$0] }

    guard !unvisitedScanData.isEmpty else { return tunnels }

    let newTunnels = (distance == 0) ? [] :
        unvisitedScanData
            .filter{ $0.flowRate > 0 }
            .map{ Tunnel(endValve: $0.name, distance: distance)}
    
    let nextNeighbours = Set(unvisitedScanData.flatMap { $0.neighbours })

    return visitNeighbours(neighbours: nextNeighbours,
                        distance: distance + 1,
                        visited: visited.union(neighbours),
                        scan: scan,
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

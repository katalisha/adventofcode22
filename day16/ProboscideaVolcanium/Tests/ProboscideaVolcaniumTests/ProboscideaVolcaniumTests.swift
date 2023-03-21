import XCTest
@testable import ProboscideaVolcanium

@available(macOS 13.0, *)
final class ProboscideaVolcaniumTests: XCTestCase {
    
    let sampleData =  """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""
    
    let sampleScan: Scan = [
        "AA": ScanLine(flowRate: 0, name: "AA", neighbours: ["DD", "II", "BB"]),
        "BB": ScanLine(flowRate: 13, name: "BB", neighbours: ["CC", "AA"]),
        "CC": ScanLine(flowRate: 2, name: "CC", neighbours: ["DD", "BB"]),
        "DD": ScanLine(flowRate: 20, name: "DD", neighbours: ["CC", "AA", "EE"]),
        "EE": ScanLine(flowRate: 3, name: "EE", neighbours: ["FF", "DD"]),
        "FF": ScanLine(flowRate: 0, name: "FF", neighbours: ["EE", "GG"]),
        "GG": ScanLine(flowRate: 0, name: "GG", neighbours: ["FF", "HH"]),
        "HH": ScanLine(flowRate: 22, name: "HH", neighbours: ["GG"]),
        "II": ScanLine(flowRate: 0, name: "II", neighbours: ["AA", "JJ"]),
        "JJ": ScanLine(flowRate: 21, name: "JJ", neighbours: ["II"])]
    
    
    let sampleCave: Cave = ["EE": Valve(flowRate: 3, name: "EE", tunnels: [
        Tunnel(endValve: "DD", distance: 1),
        Tunnel(endValve: "CC", distance: 2),
        Tunnel(endValve: "HH", distance: 3),
        Tunnel(endValve: "BB", distance: 3),
        Tunnel(endValve: "JJ", distance: 4)],
    open: false),
 "CC": Valve(flowRate: 2, name: "CC", tunnels: [
        Tunnel(endValve: "DD", distance: 1),
        Tunnel(endValve: "BB", distance: 1),
        Tunnel(endValve: "EE", distance: 2),
        Tunnel(endValve: "JJ", distance: 4),
        Tunnel(endValve: "HH", distance: 5)],
    open: false),
 "AA": Valve(flowRate: 0, name: "AA", tunnels: [
        Tunnel(endValve: "BB", distance: 1),
        Tunnel(endValve: "DD", distance: 1),
        Tunnel(endValve: "CC", distance: 2),
        Tunnel(endValve: "JJ", distance: 2),
        Tunnel(endValve: "EE", distance: 2),
        Tunnel(endValve: "HH", distance: 5)],
    open: false),
 "BB": Valve(flowRate: 13, name: "BB", tunnels: [
        Tunnel(endValve: "CC", distance: 1),
        Tunnel(endValve: "DD", distance: 2),
        Tunnel(endValve: "EE", distance: 3),
        Tunnel(endValve: "JJ", distance: 3),
        Tunnel(endValve: "HH", distance: 6)],
    open: false),
 "JJ": Valve(flowRate: 21, name: "JJ", tunnels: [
        Tunnel(endValve: "BB", distance: 3),
        Tunnel(endValve: "DD", distance: 3),
        Tunnel(endValve: "EE", distance: 4),
        Tunnel(endValve: "CC", distance: 4),
        Tunnel(endValve: "HH", distance: 7)],
    open: false),
 "HH": Valve(flowRate: 22, name: "HH", tunnels: [
        Tunnel(endValve: "EE", distance: 3),
        Tunnel(endValve: "DD", distance: 4),
        Tunnel(endValve: "CC", distance: 5),
        Tunnel(endValve: "BB", distance: 6),
        Tunnel(endValve: "JJ", distance: 7)],
    open: false),
 "DD": Valve(flowRate: 20, name: "DD", tunnels: [
        Tunnel(endValve: "EE", distance: 1),
        Tunnel(endValve: "CC", distance: 1),
        Tunnel(endValve: "BB", distance: 2),
        Tunnel(endValve: "JJ", distance: 3),
        Tunnel(endValve: "HH", distance: 4)],
    open: false)]
    
    func testExample() throws {
        XCTAssertEqual(achieveMaximumFlow(data: sampleData), 1651)
    }
    
    func testCalcs() throws {
        let stateManager = StateManager(maxTime: 30)
        var state = State(cave: sampleCave, minute: 0, totalPressureReleased: 0, currentPosition: "AA");
        var result = stateManager.toNextState(state: state, openingValve: "DD")
        state = extractState(result: result)
        result = stateManager.toNextState(state: state, openingValve: "BB")
        state = extractState(result: result)
        result = stateManager.toNextState(state: state, openingValve: "JJ")
        state = extractState(result: result)
        result = stateManager.toNextState(state: state, openingValve: "HH")
        state = extractState(result: result)
        result = stateManager.toNextState(state: state, openingValve: "EE")
        state = extractState(result: result)
        result = stateManager.toNextState(state: state, openingValve: "CC")
        state = extractState(result: result)

        
    loop: while(true) {
            result =  stateManager.toNextState(state: state, openingValve: nil)
            
            switch result {
                
            case .changed(state: let newState):
                state = newState
            case .finished(state: let newState):
                state = newState
                break loop
            }
        }
        
        func extractState(result: StateUpdateResult) -> State {
            switch result {
            case .changed(state: let state):
                return state
            case .finished(state: let state):
                return state
            }
        }
        
        XCTAssertEqual(state.totalPressureReleased, 1651)
        
    }
    
    func testFile() throws {
        XCTAssertEqual(runFile(), 1647)
    }
    
    func testBuildCave() throws {
        XCTAssertEqual(buildCave(originName: "AA", valves: sampleScan), sampleCave)
        
    }
}

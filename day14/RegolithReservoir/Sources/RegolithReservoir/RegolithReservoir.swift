import Foundation

enum Mode {
    case abyss
    case floor
}

enum Direction: CaseIterable {
    case down
    case left
    case right
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    
    func move(_ direction: Direction) -> Coordinate {
        switch direction {
        case .down: return Coordinate(x: x, y: y+1)
        case .left: return Coordinate(x: x-1, y: y+1)
        case .right: return Coordinate(x: x+1, y: y+1)
        }
    }
}

struct Cave {
    private var filled: Set<Coordinate>
    private var abyss: Int {
        get { floor - 2 }
    }
    private let floor: Int
    private let hasFloor: Bool
    
    init(rocks: Set<Coordinate>, hasFloor: Bool) {
        self.filled = rocks
        
        if let floorRock = (filled.max { $0.y < $1.y }) {
            self.floor = floorRock.y + 2
        } else {
            self.floor = 2
        }
        self.hasFloor = hasFloor
    }
        
    func canFlow(to: Coordinate) -> Bool {
        return !filled.contains(to) &&
        (hasFloor == false || to.y < floor)
    }
    
    func isInAbyss(position: Coordinate) -> Bool {
        return !hasFloor && position.y > abyss
    }
    
    mutating func addSand(_ sand: Coordinate) {
        filled.insert(sand)
    }
}

@available(macOS 13.0, *)
func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    return simulateSand(data: data, mode: mode)
}

@available(macOS 13.0, *)
func simulateSand(data: String, mode: Mode) -> Int {
    let emitterLocation = Coordinate(x: 500, y: 0)

    let rocks = parse(data: data)
    var cave = Cave(rocks: rocks, hasFloor: (mode == .floor))
    var moveCount = 0
    
    while let sand = runSand(cave: cave, emitterLocation: emitterLocation) {
        moveCount += 1
        cave.addSand(sand)
    }

    return (mode == .floor) ? moveCount + 1 : moveCount
}

func runSand(cave: Cave, emitterLocation: Coordinate) -> Coordinate? {
    var sandLocation = emitterLocation
    var didMove = true
    
    while(didMove) {
        didMove = false
        
        for dir in Direction.allCases {
            let newPosition = sandLocation.move(dir)
            if cave.canFlow(to: newPosition) {
                sandLocation = newPosition
                didMove = true
                break
            }
        }
        if cave.isInAbyss(position: sandLocation) || sandLocation == emitterLocation {
            return nil
        }
    }
    print(sandLocation)
    return sandLocation
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

@available(macOS 13.0, *)
func parse(data: String) -> Set<Coordinate> {
    
    return data.components(separatedBy: "\n")
        .reduce(into: Set<Coordinate>()) { list, line in
            let matches = line.matches(of: #/(\d+)\,(\d+)/#)

            var startingCoordinate: Coordinate?
            
            matches.forEach { match in
                let x = Int(match.output.1)!
                let y = Int(match.output.2)!
                let currentCoordinate = Coordinate(x: x, y: y)
                if let startingCoordinate = startingCoordinate {
                    list.formUnion(fill(from: startingCoordinate, to: currentCoordinate))
                }
                startingCoordinate = currentCoordinate
            }
        }
}

func fill(from: Coordinate, to: Coordinate)  -> Set<Coordinate> {
    var list = Set<Coordinate>()
    list.insert(from)
    
    stride(from: from.x, through: to.x, by: (from.x < to.x) ? 1 : -1)
        .forEach{ newX in
            list.insert(Coordinate(x: newX, y: from.y))
    }
    
    stride(from: from.y, through: to.y, by: (from.y < to.y) ? 1 : -1)
        .forEach{ newY in
            list.insert(Coordinate(x: from.x, y: newY))
    }
    return list
}

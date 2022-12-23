import Foundation

enum Mode {
    case row(Int)
    case grid(Int)
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

struct Beacon: Hashable {
    let position: Coordinate
}

struct Sensor: Hashable {
    let position: Coordinate
    let range: Int
    
    func getEdges() -> Set<Coordinate> {
        var edge = Set<Coordinate>()
        let edgeDistance = range + 1
        for x in (position.x - edgeDistance)...(position.x + edgeDistance) {
            let below = position.y + edgeDistance - abs(position.x - x)
            edge.insert(Coordinate(x: x, y: below))
            
            let above = position.y - edgeDistance - abs(position.x - x)
            edge.insert(Coordinate(x: x, y: above))
        }
        return edge
    }
}

struct GridBoundary {
    let topCorner: Coordinate
    let bottomCorner: Coordinate
    
    init(topCorner: Coordinate, bottomCorner: Coordinate) {
        self.topCorner = topCorner
        self.bottomCorner = bottomCorner
    }
    
    init(coordinate: Coordinate, range: Int) {
        self.topCorner = Coordinate(x: coordinate.x - range, y: coordinate.y - range)
        self.bottomCorner = Coordinate(x: coordinate.x + range, y: coordinate.y + range)
    }
    
    func excludes(space: Coordinate) -> Bool {
        return space.x < topCorner.x ||
            space.x > bottomCorner.x ||
            space.y < topCorner.y ||
            space.y > bottomCorner.y
    }
}

struct Grid {
    let boundary: GridBoundary
    let sensors: Set<Sensor>
    let beacons: Set<Beacon>
}

// MARK: Functions

@available(macOS 13.0, *)
func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    return process(data: data, mode: mode)
}

@available(macOS 13.0, *)
func process(data: String, mode: Mode) -> Int {
    let grid = parse(data: data)

    switch mode {
    case let .row(row):
        return countCoveredInRow(row, grid: grid)
    case let .grid(size):
        return tuningFrequency(size: size, grid: grid)
    }
}

// MARK: Coverage

func tuningFrequency(size: Int, grid: Grid) -> Int {
    let c = 4000000
    let beaconZone = GridBoundary(topCorner: Coordinate(x: 0, y: 0), bottomCorner: Coordinate(x: size, y: size))
    
    for sensor in grid.sensors {
        for space in sensor.getEdges() {
            if beaconZone.excludes(space: space) {
                continue
            }
            
            if !isGridSpaceCovered(space: space, sensors: grid.sensors) {
                return c * space.x + space.y
            }
        }
    }
    return 0
}

@available(macOS 13.0, *)
func countCoveredInRow(_ y: Int, grid: Grid) -> Int {
    var count = 0
    
    for x in grid.boundary.topCorner.x...grid.boundary.bottomCorner.x {
        let space = Coordinate(x: x, y: y)

        if let _ = grid.beacons.first(where: { $0.position == space}) {
            continue
        }
        
        if isGridSpaceCovered(space: space, sensors: grid.sensors) {
            count += 1
        }
    }
    return count
}

func isGridSpaceCovered(space: Coordinate, sensors: Set<Sensor>) -> Bool {
    if let _ = sensors.first(where: { s in
        let verticalDistance = abs(s.position.y - space.y)
        let horizontalDistance = abs(s.position.x - space.x)
        let rangeAtDistance = s.range - verticalDistance
        return horizontalDistance <= rangeAtDistance
    }) { return true }
    
    return false
}

// MARK: Parsing

@available(macOS 13.0, *)
func parse(data: String) -> Grid {
    let startingValue = (sensors: Set<Sensor>(), beacons: Set<Beacon>())
    
    let parsedData = data.components(separatedBy: "\n")
        .reduce(into: startingValue) { partialResult, line in
            if let (sensor, beacon) = parseLine(line: line) {
                partialResult.sensors.insert(sensor)
                partialResult.beacons.insert(beacon)
            }
        }
    let boundary = calculateBoundary(sensors: parsedData.sensors, beacons: parsedData.beacons)
    return Grid(boundary: boundary!, sensors: parsedData.sensors, beacons: parsedData.beacons)
}

func calculateBoundary(sensors: Set<Sensor>, beacons: Set<Beacon>) -> GridBoundary? {
    let sensorResult: GridBoundary? = sensors.reduce(nil) { partialResult, sensor in
        let potentialBoundary = GridBoundary(coordinate: sensor.position, range: sensor.range)
        return findFurthestBoundary(currentBoundary: partialResult, potentialBoundary: potentialBoundary)
    }
    
    let completeResult: GridBoundary? = beacons.reduce(sensorResult) { partialResult, beacon in
        let potentialBoundary = GridBoundary(coordinate: beacon.position, range: 0)
        return findFurthestBoundary(currentBoundary: partialResult, potentialBoundary: potentialBoundary)
    }
    return completeResult
}

func findFurthestBoundary(currentBoundary: GridBoundary?, potentialBoundary: GridBoundary) -> GridBoundary {
    guard let currentMin = currentBoundary?.topCorner,
          let currentMax = currentBoundary?.bottomCorner else {
        return GridBoundary(topCorner: potentialBoundary.topCorner, bottomCorner: potentialBoundary.bottomCorner)
    }
    
    let minX = min(currentMin.x, potentialBoundary.topCorner.x)
    let maxX = max(currentMax.x, potentialBoundary.bottomCorner.x)
    let minY = min(currentMin.y, potentialBoundary.topCorner.y)
    let maxY = max(currentMax.y, potentialBoundary.bottomCorner.y)
    
    return GridBoundary(topCorner: Coordinate(x: minX, y: minY), bottomCorner: Coordinate(x: maxX, y: maxY))
}

@available(macOS 13.0, *)
func parseLine(line: String) -> (Sensor, Beacon)? {
    let regex = #/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/#
    guard let match = line.wholeMatch(of: regex) else { return nil }
    
    let beacon = Beacon(position: Coordinate(x: Int(match.3)!, y: Int(match.4)!))
    let sensorPosition = Coordinate(x: Int(match.1)!, y: Int(match.2)!)
    
    let range = calculateRange(sensor: sensorPosition, beacon: beacon.position)
    let sensor = Sensor(position: sensorPosition, range: range)

    return (sensor, beacon)
}

func calculateRange(sensor: Coordinate, beacon: Coordinate) -> Int {
    return  abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

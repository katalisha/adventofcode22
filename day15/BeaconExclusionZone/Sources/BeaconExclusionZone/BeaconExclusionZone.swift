import Foundation

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
}

struct Grid {
    let boundary: GridBoundary
    let sensors: Set<Sensor>
    let beacons: Set<Beacon>
}

@available(macOS 13.0, *)
func runFile(row: Int) -> Int {
    let data = try! readFile()
    return countCoveredInRow(row, data: data)
}

@available(macOS 13.0, *)
func countCoveredInRow(_ y: Int, data: String) -> Int {
    let grid = parse(data: data)
    var count = 0
    
    for x in grid.boundary.topCorner.x...grid.boundary.bottomCorner.x {
        // exclude beacons
        if let _ = grid.beacons.first(where: { b in
            b.position.x == x && b.position.y == y
        }) { continue }
        
        // check for sensor coverage
        if let _ = grid.sensors.first(where: { s in
            let verticalDistance = abs(s.position.y - y)
            let horizontalDistance = abs(s.position.x - x)
            let rangeAtDistance = s.range - verticalDistance
            return horizontalDistance <= rangeAtDistance
        }) { count += 1 }
    }
    return count
}

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
        return generateEdges(currentBoundary: partialResult, newBoundary: potentialBoundary)
    }
    
    let completeResult: GridBoundary? = beacons.reduce(sensorResult) { partialResult, beacon in
        let potentialBoundary = GridBoundary(coordinate: beacon.position, range: 0)
        return generateEdges(currentBoundary: partialResult, newBoundary: potentialBoundary)
    }
    return completeResult
}

func generateEdges(currentBoundary: GridBoundary?, newBoundary: GridBoundary) -> GridBoundary {
    guard let currentMin = currentBoundary?.topCorner,
          let currentMax = currentBoundary?.bottomCorner else {
        return GridBoundary(topCorner: newBoundary.topCorner, bottomCorner: newBoundary.bottomCorner)
    }
    
    let minX = min(currentMin.x, newBoundary.topCorner.x)
    let maxX = max(currentMax.x, newBoundary.bottomCorner.x)
    let minY = min(currentMin.y, newBoundary.topCorner.y)
    let maxY = max(currentMax.y, newBoundary.bottomCorner.y)
    
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

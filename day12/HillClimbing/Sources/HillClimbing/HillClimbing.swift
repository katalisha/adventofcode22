import Foundation

enum Mode {
    case fromStart
    case fromAnyGround
}

func fileToPath(mode: Mode) -> Int {
    let data = try! readFile()
    return path(data: data, mode: mode)
}

func path(data: String, mode: Mode) -> Int {
    let map = createMap(data: data)
    return lengthOfShortestPath(map: map, mode: mode)
}

func lengthOfShortestPath(map: Map, mode: Mode) -> Int {
    var counter = 0
    var end = false
    var movesAtDepth = (mode == .fromStart) ? Set([map.startLocation]) : Set(map.groundLevel())
    
    repeat
    {
        (movesAtDepth, end) = allPossibleMoves(paths: movesAtDepth, map: map)
        counter += 1
    } while (movesAtDepth.count > 0 && end == false)
    
    return counter
}

func allPossibleMoves(paths: Set<Square>, map: Map) -> (Set<Square>, Bool) {
    var endFound = false

    let nextMoves = paths.reduce(Set<Square>()) { partialResult, s in
        let movesFromS = map.availableMoves(from: s)
        endFound = endFound || movesFromS.contains(map.end)
        return partialResult.union(movesFromS)
    }
    return (nextMoves, endFound)
}

func createMap(data: String) -> Map {
    let startingArray:[[Square]] = [[]]
    var start: Square?
    var end: Square?
    var items = data
        .reduce(into: startingArray, { partialResult, c in
            
            func addSquare(_ c: Character, to lastRow: Int) -> Square {
                let elevation = c.elevation()!
                
                let square = Square(elevation: elevation, i: lastRow, j: (partialResult[lastRow].indices.last ?? -1) + 1 )
                partialResult[lastRow].append(square)
                return square
            }
            
            if let lastRow = partialResult.indices.last {
                switch c {
                    case "\n": partialResult.append([])
                    case "S":
                        let square = addSquare("a", to:lastRow)
                        start = square
                    
                    case "E":
                        end = addSquare("z", to:lastRow)
                        default: _ = addSquare(c, to: lastRow)
                }
            }
        })
    
    if items.last?.count == 0 {
        items.removeLast()
    }
    return Map(startLocation: start!, end: end!, items: items)
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

extension Character {
    func elevation() -> Int? {
        let a = Character("a").asciiValue!

        if let c = self.asciiValue {
            let value = Int(c - a)
            return value

        }
        return nil
    }
}

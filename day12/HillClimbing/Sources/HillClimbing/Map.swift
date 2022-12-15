struct Map {
    let startLocation: Square
    let end: Square
    var items: [[Square]]
    
    func availableMoves(from: Square) -> Set<Square> {
        return Direction.allCases.reduce(into: Set<Square>()) { partialResult, dir in
            if let move = move(to: from, inDirection: dir) {
                partialResult.insert(move)
            }
        }
    }

    func move(to currentLocation: Square, inDirection: Direction) -> Square? {
        var modifier: (i: Int, j: Int)!
        
        switch inDirection {
            case .up: modifier = (i: -1, j: 0)
            case .down: modifier = (i: 1, j:0)
            case .left: modifier = (i: 0, j: -1)
            case .right:modifier = (i: 0, j: 1)
        }
        
        let move = (i: currentLocation.i + modifier.i, j: currentLocation.j + modifier.j)
        
        // out of bounds
        if move.i < 0 ||
            move.i >= items.count ||
            move.j < 0 ||
            move.j >= items[move.i].count {
            return nil
        }
        
        let square = items[move.i][move.j]
        
//        if square.visited {
//            return nil
//        }
        
        // elevation different too great
        if square.elevation - currentLocation.elevation > 1 {
            return nil
        }
        
        return items[move.i][move.j]
    }
}

struct Square {
    let elevation: Int
    let i: Int
    let j: Int
    
    init(elevation: Int, i: Int, j: Int, visited: Bool = false) {
        self.elevation = elevation
        self.i = i
        self.j = j
    }
}

extension Square: CustomStringConvertible, Hashable {
    
    var description: String {
        get {
            return "e: \(elevation.description), i: \(i.description), j: \(j.description)"
        }
    }
}

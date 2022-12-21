public enum Packet: Decodable, Comparable {
    case integer(Int), list([Packet])
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let integer = try? container.decode(Int.self) {
            self = .integer(integer)
        } else {
            self = .list(try! [Packet](from: decoder))
        }
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.integer(let l), .integer(let r)): return l < r
        case (.integer(_), .list(_)): return .list([lhs]) < rhs
        case (.list(_), .integer(_)): return lhs < .list([rhs])
        case (.list(let l), .list(let r)):
            for (l, r) in zip(l, r) {
                if l < r { return true }
                if l > r { return false }
                // if equal check next pair
            }
            return l.count < r.count
        }
    }
}

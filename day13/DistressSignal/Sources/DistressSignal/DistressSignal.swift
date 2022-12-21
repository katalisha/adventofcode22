import Foundation

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

func runFile() -> Int {
    let data = try! readFile()
    return packets(data: data)
}

func packets(data: String) -> Int {
    return data.components(separatedBy: "\n\n")
        .enumerated()
        .reduce(0) { partialResult, pair in
            if (isPacketPairInOrder(pair.element)) {
                return partialResult + pair.offset + 1
            }
            return partialResult
        }
}

func isPacketPairInOrder(_ packetPair: String) -> Bool {
    guard let packets = parse(pair: packetPair) else { return false }
    return packets.lhs < packets.rhs
}

func parse(pair: String) -> (lhs: Packet, rhs: Packet)? {
    let lines = pair.components(separatedBy: "\n")
    guard let lhs = parsePacket(s: lines[0]),
          let rhs = parsePacket(s: lines[1])
    else { return nil}
    
    return (lhs: lhs, rhs: rhs)
}

func parsePacket(s: String) -> Packet? {
    let decoder = JSONDecoder()

    if let data = s.data(using: .utf8) {
        return try? decoder.decode(Packet.self, from: data)
    }
    return nil
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

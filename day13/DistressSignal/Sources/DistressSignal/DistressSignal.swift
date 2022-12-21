import Foundation

enum Mode {
    case sumIndiciesInOrder
    case getDecoderKey
}

func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    return (mode == .sumIndiciesInOrder) ? packetsInOrder(data: data) : decoderKey(data: data)
}

func decoderKey(data: String) -> Int {
    let dividerPackets =  [parsePacket(s: "[[2]]")!, parsePacket(s: "[[6]]")!]
    
    let message = (data.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .compactMap{ parsePacket(s: $0)}
        + dividerPackets)
        .sorted()
    
    let index0 = message.firstIndex(of: dividerPackets[0])! + 1
    let index1 = message.firstIndex(of: dividerPackets[1])! + 1
    
    return index0 * index1
}

func packetsInOrder(data: String) -> Int {
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

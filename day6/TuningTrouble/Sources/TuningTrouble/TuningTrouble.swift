import Foundation

struct Queue {
    let length: Int
    var items: [Character]
    var count: Int
    
    init(length: Int) {
        self.length = length
        self.count = 0
        self.items = []
    }
    
    func hasDupes() -> Bool {
        let found = items.first { c in
            return items.filter { $0 == c }.count > 1
        }
        return found != nil
    }
    
    mutating func add(item: Character) {
        if items.count >= length {
            items.removeFirst()
        }
        items.append(item)
        count += 1
    }
    
    func itemsPassed() -> Int {
        return count
    }
}

public func runFile() -> Int {
    let data = try! readFile()
    return findMarker(data: data)
}

public func findMarker(data: String) -> Int {
    let packetLength = 4
    var q = Queue(length: packetLength)
    var result: Int? = nil
    
    _ = data.first { c in
        q.add(item: c)

        if q.count >= packetLength && !q.hasDupes() {
            result = q.count
            return true
        }
        return false
    }
    
    return result!
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

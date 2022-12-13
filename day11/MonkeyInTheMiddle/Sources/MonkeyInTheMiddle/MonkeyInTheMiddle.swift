import Foundation

typealias Item = Int

enum WorryMode {
    case worryGoesDown(dividedBy: Int)
    case worryGoesUp(mod: Int)
}

struct ThrowItem {
    let toMonkey: Int
    let value: Item
}

struct Decision {
    let modulo: Int
    let zeroModulusMonkey: Int
    let nonZeroModulusMonkey: Int
}

struct Monkey: CustomStringConvertible {
    var items: [Item]
    var worryCalculation: (Item) -> (Item)
    var decision: Decision
    var inspections: Int = 0
    
    var description: String {
        return inspections.description
    }
    
    mutating func catchItem(_ item: Item) {
        items.append(item)
    }
    
    mutating func toMonkey(item: Item) -> Int {
        if item % decision.modulo == 0 {
            return decision.zeroModulusMonkey
        } else {
            return decision.nonZeroModulusMonkey
        }
    }
    
    mutating func takeTurn(worryMode: WorryMode) -> [ThrowItem] {
        let finalWorryLevel = getWorryCalculation(worryMode: worryMode)
        
        let turn = items.map { item in
            inspections += 1
            let inspectingWorryLevel = worryCalculation(item)
            let newItem = finalWorryLevel(inspectingWorryLevel)
            let toMonkey = toMonkey(item: newItem)
            let result = ThrowItem(toMonkey: toMonkey, value: newItem)
            return result
        }
        items = []
        return turn
    }
    
    private func getWorryCalculation(worryMode: WorryMode) -> ((Int) -> (Int)) {
        switch worryMode {
        case let .worryGoesUp(mod: mod):
            return { $0 % mod }
        case let .worryGoesDown(dividedBy: phew):
            return { $0 / phew }
        }
    }
}

func observeMonkeys(_ monkeys: [Monkey], worryReduction: Int?, rounds: Int) -> Int {
    let worryMode = calculateWorryMode(worryReduction: worryReduction, monkeys: monkeys)
    var mutableMokeys = monkeys
    
    for _ in 0..<rounds {
        for(index, _) in mutableMokeys.enumerated() {
            let items = mutableMokeys[index].takeTurn(worryMode: worryMode)
            items.forEach { item in
                mutableMokeys[item.toMonkey].catchItem(item.value)
            }
        }
    }
    mutableMokeys.sort { $0.inspections > $1.inspections }
    return mutableMokeys[0].inspections * mutableMokeys[1].inspections
}

func calculateWorryMode(worryReduction: Int?, monkeys: [Monkey]) -> WorryMode {
    if let worryReduction = worryReduction {
        return .worryGoesDown(dividedBy: worryReduction)
    }
    else {
        let superMod = monkeys.reduce(1) { partialResult, monkey in
            return partialResult * monkey.decision.modulo
        }
        return .worryGoesUp(mod: superMod)
    }
}

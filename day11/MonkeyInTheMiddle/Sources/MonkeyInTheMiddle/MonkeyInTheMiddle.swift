import Foundation

struct Throw {
    let toMonkey: Int
    let value: Int
}

struct Monkey {
    var items: [Int]
    var operation: (Int) -> (Int)
    var test: (Int) -> (Int)
    var inspections = 0
    
    mutating func catchItem(_ item: Int) {
        items.append(item)
    }
    
    mutating func takeTurn(phew: Int) -> [Throw] {
        let turn = items.map { item in
            inspections += 1
            let inspectingWorryLevel = operation(item)
            let finalWorryLevel = inspectingWorryLevel/phew
            let toMonkey = test(finalWorryLevel)
            let result = Throw(toMonkey: toMonkey, value: finalWorryLevel)
            return result
        }
        items = []
        return turn
    }
}

func observeMonkeys(_ monkeys: [Monkey], phew: Int, rounds: Int) -> Int {
    var mutableMokeys = monkeys
    
    for iteration in 0..<rounds {
        print(iteration)
        for(index, _) in mutableMokeys.enumerated() {
            let items = mutableMokeys[index].takeTurn(phew: phew)
            items.forEach { item in
                mutableMokeys[item.toMonkey].catchItem(item.value)
            }
        }
    }
    mutableMokeys.sort { $0.inspections > $1.inspections }
    print(mutableMokeys)
    return mutableMokeys[0].inspections * mutableMokeys[1].inspections
}

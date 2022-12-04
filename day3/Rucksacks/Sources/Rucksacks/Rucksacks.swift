import Foundation

public enum Mode {
    case supplies
    case badges
}

struct Tally {
    var group: [String]
    var badgeTotal: Int
}

public func runFile(mode: Mode) -> Int {
    let data = try! readFile()
    
    if (mode == .supplies) {
        return tallyDuplicateSuppliesInRucksacks(data: data)
    } else {
        return tallyBadges(data: data)
    }
}

public func tallyBadges(data: String) -> Int {
    let groupSize = 3
    var currentGroup: [String] = []
    return data.components(separatedBy: "\n")
        .reduce(0) { tallyBadgeTotal, line in
            currentGroup.append(line)

            guard currentGroup.count == groupSize else { return tallyBadgeTotal }

            let sets = currentGroup.map { rucksack in
                return Set<Character>(rucksack)
            }

            let badge = findDuplicates(sets)
            currentGroup = []
            return tallyBadgeTotal + characterToPriority(badge.first!)!
        }
}

public func tallyDuplicateSuppliesInRucksacks(data: String) -> Int {
    return data.components(separatedBy: "\n")
        .reduce(0) { tallySupplyPriority, line in
            let duplicatedSupplies = compareRucksackCompartments(rucksack: line)

            return duplicatedSupplies.reduce(0) { partialResult, c in
                return partialResult + characterToPriority(c)!
            } + tallySupplyPriority
        }
}

func compareRucksackCompartments(rucksack: String) -> Set<Character> {
    let compartment2Index = Int(rucksack.count/2)

    let compartment1: Set<Character> = Set(rucksack.prefix(compartment2Index))
    let compartment2: Set<Character> = Set(rucksack.suffix(compartment2Index))
    return findDuplicates([compartment1, compartment2])
}

func readFile() throws -> String {
    let path = Bundle.module.url(forResource: "input", withExtension: "txt")
    let data = try String(contentsOf: path!)
    return data
}

func characterToPriority(_ c: Character) -> Int? {
    let elfLowercaseA = 1
    let elfUppercaseA = 27
    let asciiLowercaseA = Int(Character("a").asciiValue!)
    let asciiUppercaseA = Int(Character("A").asciiValue!)
    
    if let ascii = c.asciiValue {
        let modifier: Int = (ascii >= asciiLowercaseA)
            ? elfLowercaseA - asciiLowercaseA
            : elfUppercaseA - asciiUppercaseA
        return Int(ascii) + modifier
    }
    return nil
}

func findDuplicates(_ sets: [Set<Character>]) -> Set<Character> {
    guard sets.count > 0 else { return Set<Character>() }
    
    // this compares the first set to itself - not ideal
    return sets.reduce(sets[0]) { partialResult, next in
        return partialResult.intersection(next)
    }
}

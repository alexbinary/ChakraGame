
import Foundation


struct ChakraGame {
    
    let boards: [ChakraBoard]
    
    let chakraPoints: [Energy: ChakraPoints]
    var intakeColumn: [IntakeColumn] = [IntakeColumn](repeating: IntakeColumn(), count: 3)
}

struct IntakeColumn {
    
    let slots: [Slot] = [Slot](repeating: .empty, count: 3)
}
    
struct ChakraBoard {
    
    let inputSlots: [Slot] = [Slot](repeating: .empty, count: 3)
    
    let chakras: [Chakra] = [
        Chakra(energy: .purple),
        Chakra(energy: .darkBlue),
        Chakra(energy: .lightBlue),
        Chakra(energy: .green),
        Chakra(energy: .yellow),
        Chakra(energy: .orange),
        Chakra(energy: .red),
    ]
    
    let blackZone: [Gem]
}

enum Energy {
    
    case purple
    case darkBlue
    case lightBlue
    case green
    case yellow
    case orange
    case red
    case black
}

enum ChakraPoints: Int {
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

enum ChakraPointsStatus {
    
    case unknown
    case known(ChakraPoints)
}

struct Gem {
    
    let energy: Energy
}

struct Chakra {
    
    let energy: Energy
    let points: ChakraPointsStatus = .unknown
    let slots: [Slot] = [Slot](repeating: .empty, count: 3)
}

enum Slot {
    
    case empty
    case gem(Gem)
}

enum Move {
    
    case takeGemsInput(intakeColumn: Int, intakeSlot: Int, inputSlot: Slot)
}

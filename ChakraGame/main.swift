
import Foundation


struct ChakraGame {
    
    private let boards: [ChakraBoard]
    
    private let chakraPoints: [Energy: ChakraPoints]
    
    private var universeBag: [Gem]
    
    private var intakeSlotContents: [IntakeColumn: [Slot: SlotContent]] = [
        
        .one: [
            .one: .empty,
            .two: .empty,
            .three: .empty,
        ],
        .two: [
            .one: .empty,
            .two: .empty,
            .three: .empty,
        ],
        .three: [
            .one: .empty,
            .two: .empty,
            .three: .empty,
        ],
    ]
    
    init(forNumberOfPlayers numberOfPlayers: Int) {
    
        // create player boards
        
        self.boards = [ChakraBoard](repeating: ChakraBoard(), count: numberOfPlayers)
     
        // affect chakra points
        
        var availableChakraPoints = ChakraPoints.allCases.reduce([]) { points, point in
            points + [ChakraPoints](repeating: point, count: 2)
        }
        
        var chakraPoints: [Energy: ChakraPoints] = [:]
        for energy in Energy.all(includingBlack: false) {
            availableChakraPoints.shuffle()
            chakraPoints[energy] = availableChakraPoints.popLast()!
        }
        
        self.chakraPoints = chakraPoints
        
        // configure universe bag
        
        self.universeBag = Energy.all(includingBlack: true).reduce([]) { (bag, energy) in
            
            bag + [Gem](repeating: Gem(energy: energy), count: 3 * numberOfPlayers)
        }
        
        //
        
        self.refillIntakeSlots()
    }
    
    private mutating func refillIntakeSlots() {
        
        for column in IntakeColumn.allCases {
            for slot in Slot.allCases {
                
                if (intakeSlotContents[column]![slot]! == .empty) {
                    
                    universeBag.shuffle()
                    guard let gem = universeBag.popLast() else { return }
                    intakeSlotContents[column]![slot] = .gem(gem)
                }
            }
        }
    }
    
    private func listPossibleMoves(for board: ChakraBoard) -> [GameMove] {
        
        var moves: [GameMove] = []
        
        // take in input
        
        // take in chakra
        
        // move gems
        
        // meditate
        
        return moves
    }
}

enum Slot: CaseIterable {
    
    case one
    case two
    case three
}

enum SlotContent: Equatable {
    
    case empty
    case gem(Gem)
}

enum IntakeColumn: CaseIterable {
    
    case one
    case two
    case three
}

struct IntakeSlot {
    
    let intakeColumn: IntakeColumn
    let columnSlot: Slot
}

struct ChakraBoard {
    
    let inputSlotContents: [Slot: SlotContent] = [
        .one: .empty,
        .two: .empty,
        .three: .empty,
    ]
    
    let chakras: [Chakra] = [
        Chakra(energy: .purple),
        Chakra(energy: .darkBlue),
        Chakra(energy: .lightBlue),
        Chakra(energy: .green),
        Chakra(energy: .yellow),
        Chakra(energy: .orange),
        Chakra(energy: .red),
    ]
    
    let blackZone: [Gem] = []
}

enum Energy: CaseIterable {
    
    case purple
    case darkBlue
    case lightBlue
    case green
    case yellow
    case orange
    case red
    case black
    
    static func all(includingBlack: Bool) -> Set<Energy> {
        var energies = Set<Energy>(self.allCases)
        if (!includingBlack) {
            energies.remove(.black)
        }
        return energies
    }
}

enum ChakraPoints: Int, CaseIterable {
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

enum ChakraPointsStatus {
    
    case unknown
    case known(ChakraPoints)
}

struct Gem: Equatable {
    
    let energy: Energy
}

struct Chakra {
    
    let energy: Energy
    let points: ChakraPointsStatus = .unknown
    let slotContents: [Slot: SlotContent] = [
        .one: .empty,
        .two: .empty,
        .three: .empty,
    ]
    var completed: Bool {
        return slotContents[.one] == .gem(Gem(energy: energy))
            && slotContents[.two] == .gem(Gem(energy: energy))
            && slotContents[.three] == .gem(Gem(energy: energy))
    }
}

enum GameMove {
    
    case takeGemsInInputSlots([(intakeSlot: IntakeSlot, inputSlot: Slot)])
    case takeGemsInChakra([(intakeSlot: IntakeSlot, chakra: Chakra, slot: Slot)])
    case meditate(Energy?)
    case moveGems(GemMove)
}

struct GemMove {

    let unitMoves: [GemUnitMove]
    
    static let allAllowedMoves: [GemMove] = [
        GemMove(unitMoves: [
            GemUnitMove(direction: .down, count: 3)
        ]),
        GemMove(unitMoves: [
            GemUnitMove(direction: .down, count: 1),
            GemUnitMove(direction: .down, count: 1),
            GemUnitMove(direction: .down, count: 1)
        ]),
        GemMove(unitMoves: [
            GemUnitMove(direction: .down, count: 1),
            GemUnitMove(direction: .down, count: 2)
        ]),
        GemMove(unitMoves: [
            GemUnitMove(direction: .up, count: 2)
        ])
    ]
}

struct GemUnitMove {
    
    let direction: MoveDirection
    let count: Int
}

enum MoveDirection {
    
    case up
    case down
}

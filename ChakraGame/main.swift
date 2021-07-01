
import Foundation


struct Game {
    
    private let playerBoards: [PlayerBoard]
    
    private var lotusBoard: LotusBoard
    
    private var universeBag: [Energy]
    
    
    func printGame() {
        
        print("=== Lotus Board ===")
        
        print("-------")
        for slot in Slot.allCases {
            
            print("|")
            for column in MayaColumn.allCases {
                
//                print("(\(intakeSlotContents[column]![slot]!))")
                print("|")
            }
            print("-------")
        }
        
        print("=============")
    }
    
    
    init(withNumberOfPlayers numberOfPlayers: Int) {
    
        // create player boards
        
        self.playerBoards = [PlayerBoard](repeating: PlayerBoard(), count: numberOfPlayers)
        
        // create lotus board
        
        self.lotusBoard = LotusBoard()
        
        var availablePlenitudeTokens = PlenitudeToken.allCases.reduce([]) { tokens, token in
            tokens + [PlenitudeToken](repeating: token, count: 2)
        }
        
        for color in Color.all(includingBlack: false) {
            
            availablePlenitudeTokens.shuffle()
            let token = availablePlenitudeTokens.popLast()!
            lotusBoard.set(token, on: color)
        }
        
        // configure universe bag
        
        self.universeBag = Color.all(includingBlack: true).reduce([]) { (bag, color) in
            
            bag + [Energy](repeating: Energy(color: color), count: 3 * numberOfPlayers)
        }
        
        //
        
        self.refillMayaSpaces()
    }
    
    
    private mutating func refillMayaSpaces() {
        
        for column in MayaColumn.allCases {
            for slot in Slot.allCases {
                
                let mayaSlot = MayaSlot(mayaColumn: column, columnSlot: slot)
                if (lotusBoard.energy(on: mayaSlot) == nil) {
                    
                    universeBag.shuffle()
                    guard let energy = universeBag.popLast() else { return }
                    lotusBoard.put(energy, on: mayaSlot)
                }
            }
        }
    }
    
    
    private func listPossibleMoves(for board: PlayerBoard) -> [GameMove] {
        
        var moves: [GameMove] = []
        
//        // list possible gem takes
//        
//        var possibleTakes: Set<Set<IntakeSlot>> = []
//        
//        for column in IntakeColumn.allCases {
//            
//            let possibleTakesInColumn = listPossibleTakes(in: column)
//            
//            possibleTakes.formUnion(
//                possibleTakesInColumn.map { take in
//                    Set<IntakeSlot>(take.map { slot in
//                        IntakeSlot(intakeColumn: column, columnSlot: slot)
//                    })
//                }
//            )
//        }
//        
//        // list possible targets for each take
//        
//        let numberOfAvailableInputSlots = board.numberOfAvailableInputSlots
//        
//        if numberOfAvailableInputSlots > 0 {
//        
//            let numberOfPossibleTakesByColumn = numberOfAvailableInputSlots
//            
//            
//        }
//        
//        let possibleTargets = listPossibleInputTargets(forNumberOfGems: take.count ,on: board)
//        
//        for targets in possibleTargets {
//            
//            let permutations = listPermutations(mapping: take, to: targets)
//            
//            possibleTakes.app
//            
//            for permutation in permutations {
//                
//                moves.append(
//                    .takeGemsInInputSlots(
//                        permutation.map {
//                            (intakeSlot: IntakeSlot(intakeColumn: column, columnSlot: $0.in), inputSlot: $0.out)
//                        }
//                    )
//                )
//            }
//        }
//        
//        // list possible gems moves
//        
//        // meditate
        
        return moves
    }
    
    private func listPossibleTakes(in column: MayaColumn) -> Set<Set<Slot>> {
        
        return []
    }
    
    private func listPossibleInputTargets(forNumberOfGems numberOfGems: Int, on board: PlayerBoard) -> Set<Set<Slot>> {
        
        return []
    }
    
    private func listPermutations(mapping inSlots: Set<Slot>, to outSlots: Set<Slot>) -> [[(in: Slot, out: Slot)]] {
        
        return []
    }
    
    private func listPossibleTargets(for gems: [Energy], on board: PlayerBoard) -> [(chakra: Chakra, slot: Slot)] {
        
        return []
    }
}



struct LotusBoard {
    
    
    private var karmaSpaces: [Color: PlenitudeToken] = [:]
    
    private var mayaSpaces: [MayaColumn: [Slot: SlotContent]] = [
        
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
    
    
    public mutating func set(_ plenitudeToken: PlenitudeToken, on color: Color) {
        
        self.karmaSpaces[color] = plenitudeToken
    }
    
    
    public func energy(on mayaSlot: MayaSlot) -> Energy? {
        
        switch self.mayaSpaces[mayaSlot.mayaColumn]![mayaSlot.columnSlot]! {
        
        case .empty:
            return nil
        case .energy(let energy):
            return energy
        }
    }
    
    
    public func isEmpty(_ mayaSlot: MayaSlot) -> Bool {
        
        return energy(on: mayaSlot) == nil
    }
    
    
    public mutating func put(_ energy: Energy, on mayaSlot: MayaSlot) {
        
        self.mayaSpaces[mayaSlot.mayaColumn]![mayaSlot.columnSlot] = .energy(energy)
    }
    
    
    public mutating func take(_ energy: Energy, on mayaSlot: MayaSlot) -> Energy? {
        
        let content = self.mayaSpaces[mayaSlot.mayaColumn]![mayaSlot.columnSlot]!
        var takenEnergy: Energy?
        
        switch content {
        
        case .empty:
            takenEnergy = nil
        case .energy(let energy):
            takenEnergy = energy
        }
        
        self.mayaSpaces[mayaSlot.mayaColumn]![mayaSlot.columnSlot] = .empty
        
        return takenEnergy
    }
}

enum Slot: CaseIterable {
    
    case one
    case two
    case three
}

enum SlotContent: Equatable {
    
    case empty
    case energy(Energy)
}

enum MayaColumn: CaseIterable {
    
    case one
    case two
    case three
}

struct MayaSlot: Hashable {
    
    let mayaColumn: MayaColumn
    let columnSlot: Slot
}

struct PlayerBoard {
    
    let inputSlotContents: [Slot: SlotContent] = [
        
        .one: .empty,
        .two: .empty,
        .three: .empty,
    ]
    
    let chakras: [Chakra] = [
        
        Chakra(color: .purple),
        Chakra(color: .darkBlue),
        Chakra(color: .lightBlue),
        Chakra(color: .green),
        Chakra(color: .yellow),
        Chakra(color: .orange),
        Chakra(color: .red),
    ]
    
    let blackZone: [Energy] = []
    
    var numberOfAvailableInputSlots: Int {
        
        inputSlotContents.values.filter { $0 == .empty } .count
    }
    
    var availableInspirationTokens = 5
}

enum Color: CaseIterable {
    
    case purple
    case darkBlue
    case lightBlue
    case green
    case yellow
    case orange
    case red
    case black
    
    static func all(includingBlack: Bool) -> Set<Color> {
        var colors = Set<Color>(self.allCases)
        if (!includingBlack) {
            colors.remove(.black)
        }
        return colors
    }
}

enum PlenitudeToken: Int, CaseIterable {
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

enum ChakraPointsStatus {
    
    case unknown
    case known(PlenitudeToken)
}

struct Energy: Equatable {
    
    let color: Color
}

struct Chakra {
    
    let color: Color
    let points: ChakraPointsStatus = .unknown
    let slotContents: [Slot: SlotContent] = [
        .one: .empty,
        .two: .empty,
        .three: .empty,
    ]
    var completed: Bool {
        return slotContents[.one] == .energy(Energy(color: color))
            && slotContents[.two] == .energy(Energy(color: color))
            && slotContents[.three] == .energy(Energy(color: color))
    }
}

enum GameMove {
    
    case takeEnergyInInputSlots([(intakeSlot: MayaSlot, inputSlot: Slot)])
    case takeEnergyInChakra([(intakeSlot: MayaSlot, chakra: Chakra, slot: Slot)])
    case meditate(Color?)
    case moveGems(EnergyMove)
}

struct EnergyMove {

    let unitMoves: [EnergyUnitMove]
    
    static let allAllowedMoves: [EnergyMove] = [
        EnergyMove(unitMoves: [
            EnergyUnitMove(direction: .down, count: 3)
        ]),
        EnergyMove(unitMoves: [
            EnergyUnitMove(direction: .down, count: 1),
            EnergyUnitMove(direction: .down, count: 1),
            EnergyUnitMove(direction: .down, count: 1)
        ]),
        EnergyMove(unitMoves: [
            EnergyUnitMove(direction: .down, count: 1),
            EnergyUnitMove(direction: .down, count: 2)
        ]),
        EnergyMove(unitMoves: [
            EnergyUnitMove(direction: .up, count: 2)
        ])
    ]
}

struct EnergyUnitMove {
    
    let direction: MoveDirection
    let count: Int
}

enum MoveDirection {
    
    case up
    case down
}



var game = Game(withNumberOfPlayers: 2)

game.printGame()

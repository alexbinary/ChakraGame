
import Foundation



struct Game {
    
    
    private let playerBoards: [PlayerBoard]
    
    private var lotusBoard: LotusBoard
    
    private var universeBag: [Energy]
    
    
    func printState() {
        
        lotusBoard.printState()
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
        
        for flow in MayaFlow.allCases {
            for slot in MayaSlot.allCases {
                
                let mayaSlot = MayaSpace(flow: flow, slot: slot)
                if (lotusBoard.energy(on: mayaSlot) == nil) {
                    
                    universeBag.shuffle()
                    guard let energy = universeBag.popLast() else { return }
                    lotusBoard.put(energy, on: mayaSlot)
                }
            }
        }
    }
    
    
    private func listPossibleActions(for board: PlayerBoard) -> [PlayerAction] {
        
        var possibleActions: [PlayerAction] = []
        
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
        
        return possibleActions
    }
    
    
    private func listPossibleTakes(in column: MayaFlow) -> Set<Set<Slot>> {
        
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



struct LotusBoard {
    
    
    private var karmaSpaces: [Color: PlenitudeToken] = [:]
    
    private var mayaSpaces: [MayaSpace: Energy?] = [
        
        MayaSpace(flow: .one, slot: .one): nil,
        MayaSpace(flow: .one, slot: .two): nil,
        MayaSpace(flow: .one, slot: .three): nil,
        
        MayaSpace(flow: .two, slot: .one): nil,
        MayaSpace(flow: .two, slot: .two): nil,
        MayaSpace(flow: .two, slot: .three): nil,
        
        MayaSpace(flow: .three, slot: .one): nil,
        MayaSpace(flow: .three, slot: .two): nil,
        MayaSpace(flow: .three, slot: .three): nil,
    ]
    
    
    func printState() {
        
        print("=== Lotus Board ===")
        
        print("")
        print(" ----- Karma -----")
        print("")
        
        for color in Color.allButBlackOrdered {
            
            print("       ", terminator: "")
            print("\(color): ", terminator: "")
            if let points = karmaSpaces[color] {
                print("\(points)", terminator: "")
            } else {
                print("-", terminator: "")
            }
            print("")
        }
        
        print("")
        print(" ----- Maya -----")
        print(" |              |")
        
        for slot in MayaSlot.allCases {
            
            print(" ", terminator: "")
            for flow in MayaFlow.allCases {
            
                print("|", terminator: "")
                
                if let energy = energy(on: MayaSpace(flow: flow, slot: slot)) {
                    print(" \(energy.color) ", terminator: "")
                } else {
                    print(" -- ", terminator: "")
                }
            }
            
            print("|")
            print(" |    |    |    |")
        }
        
        print(" ----------------")
        print("")
        print("===================")
    }
    
    
    public mutating func set(_ plenitudeToken: PlenitudeToken, on color: Color) {
        
        self.karmaSpaces[color] = plenitudeToken
    }
    
    
    public func energy(on mayaSpace: MayaSpace) -> Energy? {
        
        return self.mayaSpaces[mayaSpace] ?? nil
    }
    
    
    public func isEmpty(_ mayaSlot: MayaSpace) -> Bool {
        
        return energy(on: mayaSlot) == nil
    }
    
    
    public mutating func put(_ energy: Energy, on mayaSpace: MayaSpace) {
        
        self.mayaSpaces[mayaSpace] = energy
    }
    
    
    public mutating func take(_ energy: Energy, on mayaSpace: MayaSpace) -> Energy? {
        
        let energy = self.mayaSpaces[mayaSpace] ?? nil
        
        self.mayaSpaces[mayaSpace] = nil
        
        return energy
    }
}



enum Slot: CaseIterable {
    
    case one
    case two
    case three
}



enum MayaSlot: CaseIterable {
    
    case one
    case two
    case three
}



enum SlotContent: Equatable {
    
    case empty
    case energy(Energy)
}



enum MayaFlow: CaseIterable {
    
    case one
    case two
    case three
}



struct MayaSpace: Hashable {
    
    let flow: MayaFlow
    let slot: MayaSlot
}



enum Color: CaseIterable, CustomStringConvertible {
    
    
    case purple
    case darkBlue
    case lightBlue
    case green
    case yellow
    case orange
    case red
    case black
    
    
    var description: String {
        
        switch self {
        
        case .purple:
            return "PU"
        case .darkBlue:
            return "DB"
        case .lightBlue:
            return "LB"
        case .green:
            return "GR"
        case .yellow:
            return "YE"
        case .orange:
            return "OR"
        case .red:
            return "RE"
        case .black:
            return "BL"
        }
    }
    
    
    static func all(includingBlack: Bool) -> Set<Color> {
    
        var colors = Set<Color>(self.allCases)
        if (!includingBlack) {
            colors.remove(.black)
        }
        return colors
    }
    
    
    static var allButBlackOrdered: [Color] {
        
        return [ .purple, .darkBlue, .lightBlue, .green, .yellow, .orange, .red ]
    }
}



enum PlenitudeToken: Int, CaseIterable, CustomStringConvertible {
    
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    
    var description: String { "\(self.rawValue)" }
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
    var harmonized: Bool {
        return slotContents[.one] == .energy(Energy(color: color))
            && slotContents[.two] == .energy(Energy(color: color))
            && slotContents[.three] == .energy(Energy(color: color))
    }
}



enum PlayerAction {
    
    case receiveEnergy
    case channelEnergy
    case meditate
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

game.printState()

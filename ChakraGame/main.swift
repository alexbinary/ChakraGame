
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
        
        // create lotus board, affect plenitude tokens, and fill maya spaces
        
        self.lotusBoard = LotusBoard()
        
        var availablePlenitudeTokens = PlenitudeToken.allCases.reduce([]) { tokens, token in
            tokens + [PlenitudeToken](repeating: token, count: 2)
        }
        
        for color in Color.allButBlack {
            
            availablePlenitudeTokens.shuffle()
            let token = availablePlenitudeTokens.popLast()!
            lotusBoard.set(token, on: color)
        }
        
        // configure universe bag
        
        self.universeBag = Color.allIncludingBlack.reduce([]) { (bag, color) in
            
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
    
    
    private func listPossibleTakeEnergyActions() -> Set<TakeEnergyAction> {
        
        return MayaFlow.allCases.reduce(Set<TakeEnergyAction>()) { actions, flow in
            
            actions.union(listPossibleTakeEnergyActions(in: flow))
        }
    }
    
    
    private func listPossibleTakeEnergyActions(in flow: MayaFlow) -> Set<TakeEnergyAction> {
        
//        public static var allCombinations: Set<TakeEnergyAction> {
//
//            var combinations = Set<TakeEnergyAction>()
//
//            for takeSlot1 in [true, false] {
//                for takeSlot2 in [true, false] {
//                    for takeSlot3 in [true, false] {
//
//                        var slotsToTake = Set<MayaSlot>()
//
//                        if takeSlot1 { slotsToTake.insert(.slotOne) }
//                        if takeSlot2 { slotsToTake.insert(.slotTwo) }
//                        if takeSlot3 { slotsToTake.insert(.slotThree) }
//
//                        let action = TakeEnergyAction(mayaFlow: flow, mayaSlots: slotsToTake)
//
//                        combinations.insert(action)
//                    }
//                }
//            }
//
//            return combinations
//        }
        
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
        
        print("==== Lotus Board =====")
        
        print("")
        print("  ----- Karma -----")
        print("")
        
        for color in Color.allButBlackOrdered {
            
            print("        ", terminator: "")
            print("\(color): ", terminator: "")
            if let points = karmaSpaces[color] {
                print("\(points)", terminator: "")
            } else {
                print("-", terminator: "")
            }
            print("")
        }
        
        print("")
        print(" ------ Maya -------")
        print(" |                 |")
        
        print(" |", terminator: "")
        for slot in MayaSlot.allCases {
        
            print("  ", terminator: "")
            if slot != .one {
                print(" ", terminator: "")
            }
            print(slot, terminator: "")
            print("  ", terminator: "")
        }
        print("|")
        
        print(" |                 |")
        
        for slot in MayaSlot.allCases {
            
            print(" \(slot)", terminator: "")
            for flow in MayaFlow.allCases {
            
                print("", terminator: "")
                
                if let energy = energy(on: MayaSpace(flow: flow, slot: slot)) {
                    print(" \(energy) ", terminator: "")
                } else {
                    print(" --- ", terminator: "")
                }
                
                print("|", terminator: "")
            }
            print("")
            
            print(" |     |     |     |")
        }
        
        print(" -------------------")
        print("")
        print("======================")
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
    
    
    public mutating func takeEnergy(on mayaSpace: MayaSpace) -> Energy? {
        
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



enum MayaSlot: CaseIterable, CustomStringConvertible {
    
    
    case one
    case two
    case three
    
    
    var description: String {
        
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        }
    }
}



enum SlotContent: Equatable {
    
    case empty
    case energy(Energy)
}



enum MayaFlow: CaseIterable, CustomStringConvertible {
    
    
    case one
    case two
    case three
    
    
    var description: String {
        
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        }
    }
}



struct MayaSpace: Hashable, CustomStringConvertible {
    
    
    let flow: MayaFlow
    let slot: MayaSlot
    
    
    public static func allSpaces(in flow: MayaFlow) -> Set<MayaSpace> {
    
        Set<MayaSpace>(MayaSlot.allCases.map { MayaSpace(flow: flow, slot: $0) })
    }
    
    
    var description: String { "Maya(\(flow);\(slot))" }
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
    
    
    static var allIncludingBlackOrdered: [Color] {
        
        return [ .purple, .darkBlue, .lightBlue, .green, .yellow, .orange, .red, .black ]
    }
    
    
    static var allButBlackOrdered: [Color] {
        
        return allIncludingBlackOrdered.filter { $0 != .black }
    }
    
    
    static var allIncludingBlack: Set<Color> {
        
        return Set<Color>(allIncludingBlackOrdered)
    }
    
    
    static var allButBlack: Set<Color> {
        
        return Set<Color>(allButBlackOrdered)
    }
}



struct Energy: Equatable, CustomStringConvertible {
    
    
    let color: Color
    
    
    var description: String { "♦︎\(color)" }
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
    
    case receiveEnergy(TakeEnergyAction)
    case channelEnergy
    case meditate
}



struct TakeEnergyAction: Hashable {
    
    let mayaSpaces: Set<MayaSpace>
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



enum Combinatorics {
    
    
    public static func combinations<T>(of set: Set<T>) -> Set<Set<T>> {
        
        if set.count == 1 {
         
            return Set<Set<T>>([set])
            
        } else {
            
            var allCombinations = Set<Set<T>>()
            
            var diminishedSet = set
            let firstItem = diminishedSet.removeFirst()
           
            for combinationOfDiminishedSet in combinations(of: diminishedSet) {
                
                allCombinations.insert(
                    Set<T>([firstItem])
                )
                allCombinations.insert(
                    combinationOfDiminishedSet.union(Set<T>([firstItem]))
                )
                allCombinations.insert(
                    combinationOfDiminishedSet
                )
            }
            
            return allCombinations
        }
    }
}



var game = Game(withNumberOfPlayers: 2)

game.printState()

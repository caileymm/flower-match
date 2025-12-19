import Foundation

// classes vs structs
// classes are reference types (supports inheritance, shared mutable state across different parts of application)
// structs are value types (doesn't support inheritance, working with data that is logically grouped and does not need to maintain shared state)
struct MemoryGameModel {
    private(set) var cards: Array<Card> // array holds all the cards in the game, private(set) means only the MemoryGameModel can modify array, but outside code (like the ViewModel) can read it
    private(set) var numberOfPairs: Int // stores the total number of matching pairs in the game
    private(set) var matchProgress: Double = 0.0 // tracks how many pairs have been successfully matched (for scoring/progress bar)
    
    var indexOfFirstFaceUp: Int? // optional integer that sotres the index of the first card currently facing up
    var indexOfSecondFaceUp: Int? // optional integer that stores the index of the second card currently facing up, only used when comparing a potential match
    
    // Identifiable protocol requires a unqiue id for each Card object
    struct Card: Identifiable {
        var content: String
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var id: Int
    }
    
    // main game function, executed when a user taps a card
    // since it changes the struct's internal state, it is marked as mutating
    mutating func chooseCard(_ card: Card) {
        // locate the card in teh cards array using id
        for index in cards.indices {
            // if the card is not already face up, then we need to toggle isFaceUp
            if cards[index].id == card.id && !cards[index].isFaceUp {
                cards[index].isFaceUp.toggle()
                // first card chosen
                if indexOfFirstFaceUp == nil {
                    indexOfFirstFaceUp = index
                    // second card chosen
                } else if indexOfSecondFaceUp == nil {
                    indexOfSecondFaceUp = index
                    // check if first and second match
                    // unwrapping with !
                    if cards[indexOfFirstFaceUp!].content ==
                        cards[indexOfSecondFaceUp!].content {
                        matchProgress += 1.0
                        cards[indexOfFirstFaceUp!].isMatched = true
                        cards[indexOfSecondFaceUp!].isMatched = true
                        indexOfFirstFaceUp = nil
                        indexOfSecondFaceUp = nil
                    }
                    // third card chosen -> reset, becomes first card
                    // no matches
                } else {
                    cards[indexOfFirstFaceUp!].isFaceUp.toggle()
                    cards[indexOfSecondFaceUp!].isFaceUp.toggle()
                    cards[indexOfFirstFaceUp!].isMatched = false
                    cards[indexOfSecondFaceUp!].isMatched = false
                    indexOfFirstFaceUp = index
                    indexOfSecondFaceUp = nil
                }
            }
        }
    }
    
    func getMatchProgress() -> Double {
        return matchProgress
    }
    
    mutating func restart() {
        for index in cards.indices {
            cards[index].isMatched = false;
            cards[index].isFaceUp = false;
            matchProgress = 0.0
            indexOfFirstFaceUp = nil
            indexOfSecondFaceUp = nil
        }
        cards.shuffle()
    }
    
    // CONSTRUCTOR used to set up a new game
    // takes desired numberOfPairsOfCards and contentFactory function (that takes an Int)
    init(numberOfPairsOfCards: Int, contentFactory: (Int) -> String) {
        cards = []
        numberOfPairs = numberOfPairsOfCards
        
        for index in 0..<numberOfPairsOfCards {
            let content = contentFactory(index)
            // same content duplicated two but unqique ids
            cards.append(Card(content: content, id: index * 2)) // even cards
            cards.append(Card(content: content, id: index * 2 + 1)) // odd cards
        }
        cards.shuffle()
    }
}

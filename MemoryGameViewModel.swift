/*:
# Lab 5
* Name: Cailey Murad
* Date: 7/23/2024
*/

import SwiftUI

class MemoryGameViewModel: ObservableObject {
    @Published private var model: MemoryGameModel = CreateMemoryGame()
    
    // static = not on instance method
    static func CreateMemoryGame() -> MemoryGameModel {
        return MemoryGameModel(numberOfPairsOfCards: 6, contentFactory: makeContent)
    }
    
    static func makeContent(index: Int) -> String {
        let images = ["flower1", "flower2", "flower3", "flower4", "flower5", "flower6"]
        return images[index]
    }
    
    // cards is private
    var cards: Array<MemoryGameModel.Card> {
        return model.cards
    }
    
    var pairs: Int {
        model.numberOfPairs
    }
    
    func choose(_ card: MemoryGameModel.Card) {
        model.chooseCard(card)
    }
    
    func getMatchProgress() -> Double {
        model.getMatchProgress()
    }
    
    func restart() {
        model.restart()
    }
}

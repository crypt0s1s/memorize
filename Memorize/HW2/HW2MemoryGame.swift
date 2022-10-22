//
//  HW2MemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import Foundation
import SwiftUI

struct HW2MemoryGame<CardContent> where CardContent: Equatable, CardContent: Hashable {
    private(set) var cards: Array<HW2Card>
    private(set) var theme: HW2Theme
    private(set) var score: Int = 0
 
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: HW2Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // If cards match
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                    
                // If cards don't match
                } else {
                    // Reduce score by 1 for each previously seen card
                    score -= cards[chosenIndex].isSeen ? 1 : 0
                    score -= cards[potentialMatchIndex].isSeen ? 1 : 0
                    
                    // Set cards to seen
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(_ title: String, _ emojis: Set<CardContent>, _ colour: Color, _ numberOfCards: Int?, createCardContent: (Int) -> CardContent) {
        theme = HW2Theme(title, emojis, colour, numberOfCards)
        
        cards = Array<HW2Card>()
        for pairIndex in 0..<min(theme.numberOfCards, emojis.count) {
            let content = createCardContent(pairIndex)
            cards.append(HW2Card(content: content, id: pairIndex*2))
            cards.append(HW2Card(content: content, id: pairIndex*2+1))
        }
        
        cards.shuffle()
    }
    
    struct HW2Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        var isSeen: Bool = false
    }
    
    struct HW2Theme {
        var title: String
        var emojis: Set<CardContent>
        var colour: Color
        var numberOfCards: Int

        init(_ title: String, _ emojis: Set<CardContent>, _ colour: Color, _ numberOfCards: Int?) {
            self.title = title
            self.emojis = emojis
            self.colour = colour
            if let numberOfCards {
                self.numberOfCards = numberOfCards
            } else {
                self.numberOfCards = emojis.count
            }
        }
    }
}

//
//  HW2MemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import Foundation
import SwiftUI

struct HW2MemoryGame<CardContent: Hashable> {
    private(set) var cards: [HW2Card]
    private(set) var theme: HW2Theme
    private(set) var score: Int = 0
 
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: HW2Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           cards[chosenIndex].orientation == .down,
           cards[chosenIndex].isMatched == .unmatched
        {
            if let indexOfTheOneAndOnlyFaceUpCard {
                /// Overlapping accesses to 'self', but modification requires exclusive access; consider copying to a local variable
                // Was throwing this error:
                //  matchCards(clicked: &cards[chosenIndex], faceUp: &cards[indexOfTheOneAndOnlyFaceUpCard])

                cards[chosenIndex].orientation = .up
                if cards[chosenIndex].matches(cards[indexOfTheOneAndOnlyFaceUpCard]) {
                    cards[chosenIndex].isMatched = .matched
                    cards[indexOfTheOneAndOnlyFaceUpCard].isMatched = .matched
                    score += 2
                } else {
                    score -= cards[chosenIndex].isSeen ? 1 : 0
                    score -= cards[indexOfTheOneAndOnlyFaceUpCard].isSeen ? 1 : 0
                }

                cards[chosenIndex].isSeen = true
                cards[indexOfTheOneAndOnlyFaceUpCard].isSeen = true
                self.indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].orientation = .down
                }
                self.indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                cards[chosenIndex].orientation = .up
            }
        }
    }

    /// Utilizes local reasoning for better developer understanding and makes
    /// the call site much nicer than nested if statements
    // Tried using this but didn't like the mutating function calling another mutating function
    mutating func matchCards(clicked: inout HW2Card, faceUp: inout HW2Card) {
        if clicked.matches(faceUp) {
            clicked.isMatched = .matched
            faceUp.isMatched = .matched
            score += 2
        } else {
            score -= clicked.isSeen ? 1 : 0
            score -= faceUp.isSeen ? 1 : 0
            clicked.orientation = .down
        }

        /// Since we have seen the cards and it doesnt matter if they were matched
        /// We can set isSeen in any scenario
        // But this does use more resources right? Minimal but still...
        clicked.isSeen = true
        faceUp.isSeen = true
    }
    
    init(_ theme : HW2Theme, createCardContent: (Int) -> CardContent) {
        self.theme = theme
        cards = [HW2Card]()
        for pairIndex in 0..<min(theme.numberOfCards, theme.emojis.count) {
            let content = createCardContent(pairIndex)
            cards.append(HW2Card(content: content))
            cards.append(HW2Card(content: content))
        }
 
        cards.shuffle()
    }
    
    struct HW2Card: Identifiable {
        
        enum MatchStatus {
            case matched, unmatched
        }

        enum CardOrientation {
            case up, down
        }

        var orientation: CardOrientation = .down
        var isMatched: MatchStatus = .unmatched
        var content: CardContent
        var id = UUID()
        var isSeen = false
        
        func matches(_ otherCard: HW2Card) -> Bool {
            self.content == otherCard.content
        }
    }
    
    struct HW2Theme {
        var title: String
        var emojis: Set<CardContent>
        var colour: Color
        var numberOfCards: Int
    }
}

extension HW2MemoryGame.HW2Theme {
    init(_ title: String, _ emojis: Set<CardContent>, _ colour: Color, _ numberOfCards: Int?) {
        self.title = title
        self.emojis = emojis
        self.colour = colour
        self.numberOfCards = numberOfCards ?? emojis.count
    }
}

//
//  HW2MemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import Foundation
import SwiftUI

// No need to force conformance to both Equatable and Hashable as Hashable already conforms
// to Equatable. Can move this constraint into the generic clause for more readability
// HW2MemoryGame<CardContent: Hashable>
struct HW2MemoryGame<CardContent> where CardContent: Equatable, CardContent: Hashable {
    // Same as the other, prefer [HW2Card] over Array<HW2Card>
    private(set) var cards: Array<HW2Card>
    private(set) var theme: HW2Theme
    private(set) var score: Int = 0
 
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: HW2Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            // Swift 5.7 (xcode 14) allows you to shorthand this to just
            // if let indexOfTheOneAndOnlyFaceUpCard {}

            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // Consider moving out the body of this logic into separate functions for readbility

                // If cards match
                
                // Could probably create a convenience property extension that checks if two cards
                // are matched. Making this call site much more readable and no comment would be required.
                //
                // extension Collection where Element: HW2Card {
                //     func matches(_ card: HW2Card) -> Bool {
                //         return self.content == card.content
                //     }   
                // }
                //
                // if cards[chosenIndex].matches(cards[potentialMatchIndex])
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

                // Alternative body:

                matchCards(clicked: &cards[chosenIndex], faceUp: &cards[potentialMatchIndex])
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

    // Alternative body helper functions

    // Utilizes local reasoning for better developer understanding and makes
    // the call site much nicer than nested if statements
    mutating func matchCards(inout clicked: HW2Card, inout faceUp: HW2Card) {
        if clicked.matches(faceUp) {
            clicked.isMatched = isMatched
            faceUp.isMatched = isMatched
            score += 2
        } else {
            score -= clicked.isSeen ? 1 : 0
            score -= faceUp.isSeen ? 1 : 0
        }

        // Since we have seen the cards and it doesnt matter if they were matched
        // We can set isSeen in any scenario
        clicked.isSeen = true
        faceUp.isSeen = true
    }

    // END Alternative body helper functions
    
    init(_ title: String, _ emojis: Set<CardContent>, _ colour: Color, _ numberOfCards: Int?, createCardContent: (Int) -> CardContent) {
        theme = HW2Theme(title, emojis, colour, numberOfCards)
        
        // [HW2Card]()
        cards = Array<HW2Card>()
        for pairIndex in 0..<min(theme.numberOfCards, emojis.count) {
            let content = createCardContent(pairIndex)
            cards.append(HW2Card(content: content, id: pairIndex*2))
            cards.append(HW2Card(content: content, id: pairIndex*2+1))
        }
        
        cards.shuffle()
    }
    
    // Identifiable allows you to create automatic IDs using UUID() as a default
    // This still allows you to overwrite it with your own id in the memberwise initializer
    // var id = UUID()
    struct HW2Card: Identifiable {

        // Could probably move the isFaceUp and isMatched into its own state enum 
        // can then switch on Card state instead of lots of if else (not that much of an issue, maybe cleaner)
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

        // I would just create a convenience init (in an extension) instead, so that we can still use memberwise initializer if we want
        // And then remove the above init
        // This can also be done using 2 initializers instead (not as clean as an extension only convenience)
        // Defining an init inside the struct means the compiler no longer generates a memberwise initializer (designated)
        extension HW2Theme<ContentType> {
            init(_ title: String, _ emojis: Set<ContentType>, _ colour: Color) {
                self.title = title
                self.emojis = emojis
                self.colour = colour
                self.numberOfCards = emojis.count
            }
        }
    }
}

//
//  HW2EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import SwiftUI

class HW2EmojiMemoryGame: ObservableObject {

    static let themes: [(String, Set<String>, Color, Int?)] = [
        ("Transport", ["🚗","🚄","🚃","🚌","🚀","✈️","🏍","🛩","🏎","🚅","🚈"], .gray, nil),
        ("Space", ["🧑‍🚀","🪐","👽","☄️","🛸","🔭","👾","🚀"], .red, nil),
        ("Food", ["🍔","🥕","🌽","🥐","🍉","🥭","🥙","🥗","🥩","🍤","🫑","🎂"], .green, nil),
        ("Flags", ["🇰🇷","🇯🇵","🇰🇵","🇨🇳","🇹🇼","🇦🇺","🇨🇦","🇺🇸","🇧🇪","🇱🇹","🇧🇯","🇸🇪","🏴‍☠️","🇩🇰"], .cyan, 13),
        ("Small", ["1️⃣","2️⃣","3️⃣"], .yellow, 2),
        ("Sport", ["🏀","⚽️","⚾️","🎾","🏐","🥏"], .mint, nil)
    ]
 
    static func createGame() -> HW2MemoryGame<String> {
        let theme = themes.randomElement()!
        let emojis = theme.1.shuffled()

        return HW2MemoryGame<String>(theme.0, theme.1, theme.2, theme.3) {
            pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model: HW2MemoryGame<String> = createGame();
    
    var cards: Array<HW2MemoryGame<String>.HW2Card> {
        model.cards
    }
    
    var theme: HW2MemoryGame<String>.HW2Theme {
        model.theme
    }

    var score: Int {
        model.score
    }

    // MARK: - Intent(s)
    func choose(_ card: HW2MemoryGame<String>.HW2Card) {
        model.choose(card)
    }
 
    func newGame() {
        model = HW2EmojiMemoryGame.createGame()
    }
}

//
//  HW2EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import SwiftUI

class HW2EmojiMemoryGame: ObservableObject {

    typealias GameType = HW2MemoryGame<String>

    static let themes: [GameType.HW2Theme] = [
        GameType.HW2Theme("Transport", ["🚗","🚄","🚃","🚌","🚀","✈️","🏍","🛩","🏎","🚅","🚈"], .gray, nil),
        GameType.HW2Theme("Space", ["🧑‍🚀","🪐","👽","☄️","🛸","🔭","👾","🚀"], .red, nil),
        GameType.HW2Theme("Food", ["🍔","🥕","🌽","🥐","🍉","🥭","🥙","🥗","🥩","🍤","🫑","🎂"], .green, nil),
        GameType.HW2Theme("Flags", ["🇰🇷","🇯🇵","🇰🇵","🇨🇳","🇹🇼","🇦🇺","🇨🇦","🇺🇸","🇧🇪","🇱🇹","🇧🇯","🇸🇪","🏴‍☠️","🇩🇰"], .cyan, 13),
        GameType.HW2Theme("Small", ["1️⃣","2️⃣","3️⃣"], .yellow, 2),
        GameType.HW2Theme("Sport", ["🏀","⚽️","⚾️","🎾","🏐","🥏"], .mint, nil)
    ]
 
    static func createGame() -> GameType {
        guard let theme = themes.randomElement() else {
            let e: Set<String> = ["i"]
            let e2 = e.shuffled()
            return GameType(GameType.HW2Theme("Error", e, .black, 0)) { pairIndex in e2[pairIndex] }
        }

        let emojis = theme.emojis.shuffled()

        return GameType(theme) { pairIndex in
            /// This closure's functionality isn't immediately obvious to other devs,
            /// consider inlining it to the instantation by its named parameter
            // Not quite sure what this means

            emojis[pairIndex]
        }
    }

    @Published private var model = createGame();
    
    /// I'm not the biggest fan with how they taught you to use generics in this course.
    /// I would much prefer the use of protocols for generalization with primary associated types
    /// as these do not clutter the call sites, and allow for the compiler to do a lot of the heavy
    /// lifting, and making it a lot more readable for devs.
    ///
    /// Typealiasing is probably a better alternative and can clean up alot of these
    /// messy definitions.
    ///
    /// Imagine our HW2MemoryGame now has its content type as a generic model: CardContent<Image,String>
    /// This specialization site would require the following declaration:
    ///
    /// Array<HW2MemoryGame<CardContent<Image,String>>>
    /// (I nearly had a heart attack writing that)
    // So what would an implementation of this look like
    var cards: [GameType.HW2Card] {
        model.cards
    }
    
    var theme: GameType.HW2Theme {
        model.theme
    }

    var score: Int {
        model.score
    }
    
    // Note for future you: Computed properties do not update ObservableObjects
    // only @Published variables or manually calling objectWillChange.
    // In this instance it is fine, since they all will get recomputed when 
    // the model @Published updates. But in the case where your computed properties
    // do not reference @Published, they will not trigger view updates

    // MARK: - Intent(s)
    func choose(_ card: GameType.HW2Card) {
        model.choose(card)
    }
 
    func newGame() {
        model = HW2EmojiMemoryGame.createGame()
    }
}

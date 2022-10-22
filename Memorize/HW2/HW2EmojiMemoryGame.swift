//
//  HW2EmojiMemoryGame.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import SwiftUI

class HW2EmojiMemoryGame: ObservableObject {

    static let themes: [(String, Set<String>, Color, Int?)] = [
        // Massive tuples (tuples with more than 2 non-named properties are a code smell)
        // Prefer using a struct to represent the data type, you can use a .init as such 
        // if you do not like the full type name.
        // .init(title: "Transport", emojis: [.....], color: .gray, maxPairs: nil)
        ("Transport", ["🚗","🚄","🚃","🚌","🚀","✈️","🏍","🛩","🏎","🚅","🚈"], .gray, nil),
        ("Space", ["🧑‍🚀","🪐","👽","☄️","🛸","🔭","👾","🚀"], .red, nil),
        ("Food", ["🍔","🥕","🌽","🥐","🍉","🥭","🥙","🥗","🥩","🍤","🫑","🎂"], .green, nil),
        ("Flags", ["🇰🇷","🇯🇵","🇰🇵","🇨🇳","🇹🇼","🇦🇺","🇨🇦","🇺🇸","🇧🇪","🇱🇹","🇧🇯","🇸🇪","🏴‍☠️","🇩🇰"], .cyan, 13),
        ("Small", ["1️⃣","2️⃣","3️⃣"], .yellow, 2),
        ("Sport", ["🏀","⚽️","⚾️","🎾","🏐","🥏"], .mint, nil)
    ]
 
    static func createGame() -> HW2MemoryGame<String> {
        let theme = themes.randomElement()! // Force unwrapping is a code smell. Prefer if let or guard let
        // guard let theme = themes.randomElement() else {
        //     throw SomeError.error
        // }
        // and mark our function as a throwing function 

        // These properties would then be used as named props. i.e. theme.emojis.shuffled()
        let emojis = theme.1.shuffled()

        // Shouldnt need to specialize the type here to be String (compiler should be smart enough because
        // you set it in the return type)
        return HW2MemoryGame<String>(theme.0, theme.1, theme.2, theme.3) { // pairIndex in (move it to here)
            pairIndex in // Closure parameters should be on the same line as the opening brace

            // This closure's functionality isn't immediately obvious to other devs,
            // consider inlining it to the instantation by its named parameter
            emojis[pairIndex]
        }
    }

    // No need to explicitly set type here as function createGame tells compiler already
    @Published private var model: HW2MemoryGame<String> = createGame();
    
    // I'm not the biggest fan with how they taught you to use generics in this course. 
    // I would much prefer the use of protocols for generalization with primary associated types
    // as these do not clutter the call sites, and allow for the compiler to do a lot of the heavy
    // lifting, and making it a lot more readable for devs.
    //
    // Typealiasing is probably a better alternative and can clean up alot of these
    // messy definitions.
    //
    // Imagine our HW2MemoryGame now has its content type as a generic model: CardContent<Image,String>
    // This specialization site would require the following declaration:
    //  
    // Array<HW2MemoryGame<CardContent<Image,String>>>
    // (I nearly had a heart attack writing that)
    //
    //
    // Also side note (an extract from Swift's language guide):
    // 
    // >> The type of a Swift array is written in full as Array< Element >, 
    // >> where Element is the type of values the array is allowed to store. 
    // >> You can also write the type of an array in shorthand form as [Element]. 
    // >> Although the two forms are functionally identical, the shorthand form is preferred 
    // >> and is used throughout this guide when referring to the type of an array.
    var cards: Array<HW2MemoryGame<String>.HW2Card> {
        model.cards
    }
    
    var theme: HW2MemoryGame<String>.HW2Theme {
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
    func choose(_ card: HW2MemoryGame<String>.HW2Card) {
        model.choose(card)
    }
 
    func newGame() {
        model = HW2EmojiMemoryGame.createGame()
    }

    // Example typealias setup for generic inference
    typealias GameType = HW2MemoryGame<String>

    // Using the typealias
    var someProperty: GameType.HW2Theme
}

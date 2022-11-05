//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Joshua Sumskas on 1/10/2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}

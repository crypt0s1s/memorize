//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Joshua Sumskas on 1/10/2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = HW2EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            HW2ContentView(viewModel: game)
        }
    }
}

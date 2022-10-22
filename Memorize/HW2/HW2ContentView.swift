//
//  HW2ContentView.swift
//  Memorize
//
//  Created by Joshua Sumskas on 5/10/2022.
//

import SwiftUI

struct HW2ContentView: View {
    @ObservedObject var viewModel: HW2EmojiMemoryGame

    var body: some View {
        Text(viewModel.theme.title).font(.largeTitle)
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in
                    HW2CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(viewModel.theme.colour)
        .padding(.horizontal)
        
        HStack {
            Spacer()
            resetButton
                .font(.title)
            Spacer()
            Text("Score: \(viewModel.score)")
            Spacer()
        }
    }
    
    var resetButton: some View {
        Button {
            viewModel.newGame()
        } label: {
            Text("New Game")
        }
    }
}

struct HW2CardView: View {
    let card: HW2MemoryGame<String>.HW2Card

    // Not quite sure this is meant to be like this?
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
                    .frame(height: 100)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}

struct HW2_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = HW2EmojiMemoryGame()
        HW2ContentView(viewModel: game)
    }
}

//
//  Assignment1ContentView.swift
//  Memorize
//
//  Created by Joshua Sumskas on 1/10/2022.
//

import SwiftUI

struct Assignment1ContentView: View {
    var spaceEmojis = ["🚀","🧑‍🚀","🪐","👽","🛰","☄️","🛸","🔭","👾"]
    var transportEmojis = ["🚗","🚄","🚃","🚌","🚀","✈️","🏍","🛩","🏎","🚅","🚈"]
    var flagEmojis = ["🇧🇷","🇨🇲","🇨🇴","🇦🇺","🇧🇬","🇨🇳","🇯🇵","🇦🇮","🇧🇶","🏴‍☠️","🇧🇧","🇧🇩","🇧🇪","🇨🇦","🇧🇯","🇨🇱","🇨🇩","🇨🇨","🇨🇷","🇨🇮","🇧🇲","🇰🇵","🇰🇷"]
    var foodEmojis = ["🍔","🥕","🌽","🥐","🍉","🥭","🥙","🥗","🥩","🍤","🫑","🎂"]
    
    var minEmojis = 3
    
    @State var emojiCount = 8
    @State var emojis: [String] = ["🚀","🧑‍🚀","🪐","👽","🛰","☄️","🛸","🔭","👾"]
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: adaptiveSize(cards: Float(emojiCount))))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        Assignment1CardView(content: emoji).aspectRatio(2/3, contentMode: .fill)
                    }
                }.foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            HStack {
                spaceTheme
                Spacer()
                transportTheme
                Spacer()
                flagTheme
                Spacer()
                foodTheme
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    func adaptiveSize (cards: Float) -> CGFloat {
        CGFloat(360 / ceil(cards.squareRoot()))
    }
    
    var spaceTheme: some View {
        Button {
            emojiCount = Int.random(in: minEmojis...spaceEmojis.count)
            emojis = spaceEmojis.shuffled()
        } label: {
            ButtonView(image: "space", caption: "Space")
        }
    }
    
    var transportTheme: some View {
        Button {
            emojiCount = Int.random(in: minEmojis...transportEmojis.count)
            emojis = transportEmojis.shuffled()
        } label: {
            ButtonView(image: "tram", caption: "Transport")
        }
    }
    
    var flagTheme: some View {
        Button {
            emojiCount = Int.random(in: minEmojis...flagEmojis.count)
            emojis = flagEmojis.shuffled()
        } label: {
            ButtonView(image: "flag", caption: "Flags")
        }
    }
    
    var foodTheme: some View {
        Button {
            emojiCount = Int.random(in: minEmojis...foodEmojis.count)
            emojis = foodEmojis.shuffled()
        } label: {
            ButtonView(image: "carrot", caption: "Food")
        }
    }
}

struct ButtonView: View {
    var image: String
    var caption: String
    
    var body: some View {
        VStack {
            Image(systemName: "\(image)")
                .frame(height: 20.0)
                .font(.title)
            Text("\(caption)")
                .font(.caption)
        }
        
    }
}

struct Assignment1CardView: View {
    var content: String
    @State var isFaceUp: Bool = true

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text("\(content)").font(.largeTitle)
            } else {
                shape.fill()
                Image(systemName: "questionmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }.onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}





struct Assignment1ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Assignment1ContentView()
    }
}

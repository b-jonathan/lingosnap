//
//  Flashcard.swift
//  uikitpager
//
//  Created by User on 10/19/24.
//

import SwiftUI

struct Flashcard: View {
    // MARK: Variables
    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State private var isFlipped = false

    let width: CGFloat = 200
    let height: CGFloat = 250
    let durationAndDelay: CGFloat = 0.3

    var frontWord: String
    var backWord: String

    // MARK: Flip Card Function
    private func flipCard() {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }

    // MARK: View Body
    var body: some View {
        ZStack {
            Color.white // Set the background color to white
                .edgesIgnoringSafeArea(.all) // Ignore safe area to fill entire background
            
            CardFront(width: width, height: height, degree: $frontDegree, word: frontWord)
            CardBack(width: width, height: height, degree: $backDegree, word: backWord)
        }
        .onTapGesture {
            flipCard()
        }
    }
}

struct CardFront: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double
    var word: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black) // Front color set to black
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)

            Text(word) // Display the front word
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white) // Text color set to white for contrast
                .multilineTextAlignment(.center) // Center the text
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the space
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardBack: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double
    var word: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 3) // Back border color set to black
                .frame(width: width, height: height)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black) // Back fill color set to black
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)

            Text(word) // Display the back word
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white) // Text color set to white for contrast
                .multilineTextAlignment(.center) // Center the text
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the space
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

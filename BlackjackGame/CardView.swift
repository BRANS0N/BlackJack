//
//  CardView.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 60, height: 90)
                .shadow(radius: 5)

            VStack {
                Text(card.rank.rawValue)
                    .font(.headline)
                Text(card.suit.rawValue)
            }
        }
    }
}

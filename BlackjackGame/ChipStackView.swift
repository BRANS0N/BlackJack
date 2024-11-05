//
//  ChipStackView.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//
// ChipStackView.swift
// ChipStackView.swift

import SwiftUI

struct ChipStackView: View {
    let chips: [Chip]
    let denomination: Int
    let maxVisibleChips: Int = 5  // Maximum number of chips to display visually

    var body: some View {
        ZStack(alignment: .bottom) {
            // Display up to maxVisibleChips
            ForEach(visibleChips.indices, id: \.self) { index in
                Rectangle()
                    .fill(chips[index].color)
                    .frame(width: 40, height: 10)
                    .border(Color.yellow, width: 1)  // Border color set to yellow
                    .offset(y: -CGFloat(index * 5))
            }
            // Display total count if chips exceed maxVisibleChips
            if chips.count > maxVisibleChips {
                Text("\(chips.count)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .offset(y: -CGFloat(maxVisibleChips * 5 + 20))  // Adjusted offset
            } else {
                // Display denomination if chips are within maxVisibleChips
                Text("$\(denomination)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(2)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .offset(y: -CGFloat(chips.count * 5 + 20))  // Adjusted offset
            }
        }
        .frame(width: 40, height: CGFloat(maxVisibleChips * 5 + 25))
    }

    private var visibleChips: [Chip] {
        Array(chips.prefix(maxVisibleChips))
    }
}

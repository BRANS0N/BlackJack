//
//  ChipButtonStyle.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

// ChipButtonStyle.swift

import SwiftUI

struct ChipButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                Circle()
                    .stroke(Color.primary, lineWidth: 1)
            )
            .shadow(color: configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear, radius: configuration.isPressed ? 5 : 0, x: 0, y: configuration.isPressed ? 5 : 0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

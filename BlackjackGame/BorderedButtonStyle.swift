//
//  BorderedButtonStyle.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//
import SwiftUI

struct BorderedButtonStyle: ButtonStyle {
    var fixedWidth: CGFloat = 200  // Adjust width as needed
    var fixedHeight: CGFloat = 50  // Adjust height as needed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: fixedWidth, height: fixedHeight)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.primary, lineWidth: 1)
                    .background(
                        configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear
                    )
            )
            .shadow(color: configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear, radius: configuration.isPressed ? 5 : 0, x: 0, y: configuration.isPressed ? 5 : 0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

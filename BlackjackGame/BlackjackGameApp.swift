//
//  BlackjackGameApp.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//
import SwiftUI

@main
struct BlackjackGameApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(game: BlackjackGameViewModel())
        }
    }
}

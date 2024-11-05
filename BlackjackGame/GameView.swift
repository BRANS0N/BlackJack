//
//  GameView.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

// GameView.swift

import SwiftUI

struct GameView: View {
    @ObservedObject var game: BlackjackGameViewModel
    @State private var gameStarted = false

    var body: some View {
        ZStack {
            if gameStarted {
                gameContent
                    .transition(.move(edge: .bottom))
            } else {
                startScreen
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: gameStarted)
    }
}

extension GameView {
    var startScreen: some View {
        VStack {
            Text("Welcome to Blackjack")
                .font(.largeTitle)
                .padding()

            Text("Wins: \(game.wins)")
                .font(.title2)
                .padding(.top)
            Text("Losses: \(game.losses)")
                .font(.title2)

            Button(action: {
                game.startGame()
                withAnimation {
                    gameStarted = true
                }
            }) {
                Text("Start Game")
                    .font(.title)
                    .padding()
            }
        }
    }

    var gameContent: some View {
        VStack {
            Text("Blackjack")
                .font(.largeTitle)
                .padding()

            HStack {
                Text("Wins: \(game.wins)")
                Spacer()
                Text("Losses: \(game.losses)")
            }
            .font(.headline)
            .padding([.leading, .trailing])

            VStack(alignment: .leading) {
                Text("Dealer's Hand:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(game.dealerCards, id: \.self) { card in
                            CardView(card: card)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeIn(duration: 0.5), value: game.dealerCards.count)
                }
                Text("Dealer's Hand Value: \(game.dealerHandValue)")
            }.padding()

            VStack(alignment: .leading) {
                Text("Your Hand:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(game.playerCards, id: \.self) { card in
                            CardView(card: card)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeIn(duration: 0.5), value: game.playerCards.count)
                }
                Text("Your Hand Value: \(game.playerHandValue)")
            }.padding()

            Text(game.statusMessage)
                .padding()

            if game.isGameOver {
                HStack {
                    Button(action: {
                        game.startGame()
                    }) {
                        Text("New Game")
                            .font(.title)
                            .padding()
                    }
                    Button(action: {
                        game.resetGame()
                        withAnimation {
                            gameStarted = false
                        }
                    }) {
                        Text("Main Menu")
                            .font(.title)
                            .padding()
                    }
                }
            } else {
                HStack {
                    Button(action: {
                        game.hit()
                    }) {
                        Text("Hit")
                            .font(.title)
                            .padding()
                    }
                    .disabled(!game.canHit)

                    Button(action: {
                        game.stand()
                    }) {
                        Text("Stand")
                            .font(.title)
                            .padding()
                    }
                    .disabled(!game.canStand)
                }
                Button(action: {
                    game.resetGame()
                    withAnimation {
                        gameStarted = false
                    }
                }) {
                    Text("Main Menu")
                        .font(.title)
                        .padding()
                }
            }
        }
    }
}

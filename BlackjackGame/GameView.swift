//
//  GameView.swift
//  BlackjackGame
//
//  Created by Branson on 11/5/24.
//
//
//  GameView.swift
//
//  GameView.swift
//  BlackjackGame
//
//  Created by Branson on 11/5/24.
import SwiftUI

struct GameView: View {
    @ObservedObject var game: BlackjackGameViewModel
    @State private var gameStarted = false
    @State private var betting = false

    private var groupedChips: [Int: [Chip]] {
        Dictionary(grouping: game.selectedChips, by: { $0.denomination })
    }

    var body: some View {
        ZStack {
            if gameStarted {
                if betting {
                    bettingView
                        .transition(.move(edge: .bottom))
                } else {
                    gameContent
                        .transition(.move(edge: .bottom))
                }
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
            // Main Menu Button at the Top
            HStack {
                Spacer()
                Button(action: {
                    game.resetGame()
                }) {
                    Text("Main Menu")
                        .font(.title)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }

            Spacer()

            Text("Welcome to Blackjack")
                .font(.largeTitle)
                .padding()

            Text("Balance: $\(game.balance)")
                .font(.title2)
                .padding(.top)

            Text("Wins: \(game.wins)")
                .font(.title2)
            Text("Losses: \(game.losses)")
                .font(.title2)

            Spacer()

            Button(action: {
                game.startGame()
                withAnimation {
                    gameStarted = true
                    betting = true
                }
            }) {
                Text("Start Game")
                    .font(.title)
            }
            .buttonStyle(BorderedButtonStyle())

            Button(action: {
                game.startNewGame()
            }) {
                Text("Start New Game")
                    .font(.title)
            }
            .buttonStyle(BorderedButtonStyle())

            Spacer()
        }
    }

    var bettingView: some View {
        VStack {
            // Main Menu Button at the Top
            HStack {
                Spacer()
                Button(action: {
                    game.resetGame()
                    withAnimation {
                        gameStarted = false
                        betting = false
                    }
                }) {
                    Text("Main Menu")
                        .font(.title2)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }

            Text("Place Your Bet")
                .font(.largeTitle)
                .padding()

            Text("Balance: $\(game.balance)")
                .font(.title2)
                .padding(.bottom)

            Text("Current Bet: $\(game.currentBet)")
                .font(.title2)
                .padding(.bottom)

            // Available Chips
            Text("Select Chips:")
                .font(.headline)
            HStack {
                ForEach(game.availableChips) { chip in
                    Button(action: {
                        game.addChip(chip)
                    }) {
                        Circle()
                            .fill(chip.color)
                            .frame(width: 50, height: 50)
                            .overlay(Text("\(chip.denomination)").foregroundColor(.white))
                    }
                    .padding(5)
                    .buttonStyle(ChipButtonStyle())
                }
            }

            // Selected Chips
            if !game.selectedChips.isEmpty {
                Text("Selected Chips:")
                    .font(.headline)
                    .padding(.top, 20)  // Increased padding to add space

                HStack(spacing: 20) {
                    ForEach(groupedChips.keys.sorted(), id: \.self) { denomination in
                        let chips = groupedChips[denomination] ?? []
                        ChipStackView(chips: chips, denomination: denomination)
                    }
                }
                .padding(.bottom, 10)  // Add padding below the chip stacks
            }

            Spacer()  // Pushes the buttons to the bottom

            HStack {
                Button(action: {
                    if game.placeBet() {
                        withAnimation {
                            betting = false
                        }
                    } else {
                        // Handle invalid bet (e.g., show an alert)
                    }
                }) {
                    Text("Place Bet")
                        .font(.title2)
                }
                .buttonStyle(BorderedButtonStyle())

                Button(action: {
                    game.clearBet()
                }) {
                    Text("Clear")
                        .font(.title2)
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .padding(.bottom, 20)
        }
    }

    var gameContent: some View {
        VStack {
            // Main Menu Button at the Top
            HStack {
                Spacer()
                Button(action: {
                    game.resetGame()
                    withAnimation {
                        gameStarted = false
                        betting = false
                    }
                }) {
                    Text("Main Menu")
                        .font(.title2)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }

            Text("Blackjack")
                .font(.largeTitle)
                .padding()

            HStack {
                Text("Balance: $\(game.balance)")
                Spacer()
                Text("Bet: $\(game.currentBet)")
            }
            .font(.headline)
            .padding([.leading, .trailing])

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

            Spacer()  // Pushes the buttons to the bottom

            if game.isGameOver {
                HStack {
                    Button(action: {
                        game.startGame()
                        withAnimation {
                            betting = true
                        }
                    }) {
                        Text("New Game")
                            .font(.title2)
                    }
                    .buttonStyle(BorderedButtonStyle())

                    Button(action: {
                        game.resetGame()
                        withAnimation {
                            gameStarted = false
                            betting = false
                        }
                    }) {
                        Text("Main Menu")
                            .font(.title2)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.bottom, 20)
            } else {
                HStack {
                    Button(action: {
                        game.hit()
                    }) {
                        Text("Hit")
                            .font(.title2)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(!game.canHit)

                    Button(action: {
                        game.stand()
                    }) {
                        Text("Stand")
                            .font(.title2)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(!game.canStand)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

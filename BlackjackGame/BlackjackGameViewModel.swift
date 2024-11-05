//
//  BlackjackGameViewModel.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

// BlackjackGameViewModel.swift

import SwiftUI

class BlackjackGameViewModel: ObservableObject {
    @Published var game = BlackjackGame()
    @Published var playerCards: [Card] = []
    @Published var dealerCards: [Card] = []
    @Published var playerHandValue: Int = 0
    @Published var dealerHandValue: Int = 0
    @Published var statusMessage: String = ""
    @Published var canHit: Bool = true
    @Published var canStand: Bool = true

    @Published var wins: Int = UserDefaults.standard.integer(forKey: "wins")
    @Published var losses: Int = UserDefaults.standard.integer(forKey: "losses")

    var isGameOver: Bool {
        !canHit && !canStand
    }

    init() {
        // Game starts when the player clicks "Start Game"
    }

    func resetGame() {
        game.resetGame()
        updateUI()
    }

    func startGame() {
        game.resetGame()
        updateUI()

        // Delay the initial deal to allow the game view to transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dealInitialCards()
        }
    }

    func dealInitialCards() {
        game.dealInitialCards()
        updateUI()
    }

    func hit() {
        game.playerHit()
        updateUI()

        if game.playerHand.isBust() {
            statusMessage = "You busted!"
            canHit = false
            canStand = false
            self.updateWinLossCounts(result: .lose)
        }
    }

    func stand() {
        canHit = false
        canStand = false
        game.playerStand(updateUI: {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }, completion: {
            DispatchQueue.main.async {
                self.updateUI()
                self.statusMessage = self.game.result
                self.updateWinLossCounts(result: self.game.gameResult)
            }
        })
    }

    func updateWinLossCounts(result: GameResult) {
        switch result {
        case .win:
            wins += 1
        case .lose:
            losses += 1
        case .tie:
            break
        }
        // Save updated counts to UserDefaults
        UserDefaults.standard.set(wins, forKey: "wins")
        UserDefaults.standard.set(losses, forKey: "losses")
    }

    func updateUI() {
        playerCards = game.playerHand.cards
        playerHandValue = game.playerHand.bestValue()
        statusMessage = game.statusMessage
        canHit = game.isPlayerTurn && !game.playerHand.isBust()
        canStand = game.isPlayerTurn

        if game.isPlayerTurn {
            // Show only the dealer's first card
            if let firstCard = game.dealerHand.cards.first {
                dealerCards = [firstCard]
                dealerHandValue = firstCard.rank.value.first ?? 0
            } else {
                dealerCards = []
                dealerHandValue = 0
            }
        } else {
            // Show all dealer's cards
            dealerCards = game.dealerHand.cards
            dealerHandValue = game.dealerHand.bestValue()
        }
    }
}

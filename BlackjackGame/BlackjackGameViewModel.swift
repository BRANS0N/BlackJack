//
//  BlackjackGameViewModel.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

// BlackjackGameViewModel.swift

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

    @Published var balance: Int = UserDefaults.standard.integer(forKey: "balance")
    @Published var currentBet: Int = 0
    @Published var selectedChips: [Chip] = []
    let availableChips: [Chip] = [
        Chip(denomination: 1),
        Chip(denomination: 5),
        Chip(denomination: 25),
        Chip(denomination: 100)
    ]

    var isGameOver: Bool {
        !canHit && !canStand
    }

    init() {
        // Initialize balance if not set
        if UserDefaults.standard.object(forKey: "balance") == nil {
            balance = 1000
            UserDefaults.standard.set(balance, forKey: "balance")
        }
        game.statusMessage = "Place your bet"
    }

    func resetGame() {
        game.resetGame()
        clearBet()
        updateUI()
    }

    func startGame() {
        game.resetGame()
        updateUI()
    }
    
    func removeSpecificChip(_ chip: Chip) {
        if let index = selectedChips.firstIndex(where: { $0.id == chip.id }) {
            selectedChips.remove(at: index)
            currentBet -= chip.denomination
        }
    }
    
    func startNewGame() {
            wins = 0
            losses = 0
            balance = 1000
            UserDefaults.standard.set(wins, forKey: "wins")
            UserDefaults.standard.set(losses, forKey: "losses")
            UserDefaults.standard.set(balance, forKey: "balance")
            resetGame()
        }

    func addChip(_ chip: Chip) {
        let newBetAmount = currentBet + chip.denomination
        if newBetAmount <= balance {
            selectedChips.append(chip)
            currentBet = newBetAmount
        }
    }

    func removeChip(_ chip: Chip) {
        if let index = selectedChips.firstIndex(of: chip) {
            selectedChips.remove(at: index)
            currentBet -= chip.denomination
        }
    }

    func clearBet() {
        selectedChips.removeAll()
        currentBet = 0
    }

    func placeBet() -> Bool {
        if currentBet > 0 && currentBet <= balance {
            balance -= currentBet
            UserDefaults.standard.set(balance, forKey: "balance")
            dealInitialCards()
            return true
        } else {
            return false
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
            balance += currentBet * 2
        case .lose:
            losses += 1
            // Bet is already deducted
        case .tie:
            balance += currentBet
        }
        // Save updated counts and balance to UserDefaults
        UserDefaults.standard.set(wins, forKey: "wins")
        UserDefaults.standard.set(losses, forKey: "losses")
        UserDefaults.standard.set(balance, forKey: "balance")
        currentBet = 0
        clearBet()
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

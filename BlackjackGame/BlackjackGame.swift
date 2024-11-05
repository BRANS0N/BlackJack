//
//  BlackjackGame.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

// BlackjackGame.swift

import Foundation

class BlackjackGame {
    var deck: Deck
    var playerHand: Hand
    var dealerHand: Hand
    var isPlayerTurn: Bool = true
    var result: String = ""
    var statusMessage: String = ""
    var gameResult: GameResult = .tie  // Use GameResult from GameResult.swift

    init() {
        deck = Deck()
        playerHand = Hand()
        dealerHand = Hand()
    }

    func resetGame() {
        deck = Deck()
        deck.shuffle()
        playerHand = Hand()
        dealerHand = Hand()
        isPlayerTurn = true
        result = ""
        statusMessage = "Your turn"
        gameResult = .tie  // Reset the game result
    }

    func dealInitialCards() {
        // Initial two cards for player and dealer
        if let card = deck.drawCard() { playerHand.addCard(card) }
        if let card = deck.drawCard() { dealerHand.addCard(card) }
        if let card = deck.drawCard() { playerHand.addCard(card) }
        if let card = deck.drawCard() { dealerHand.addCard(card) }
    }

    func playerHit() {
        if let card = deck.drawCard() {
            playerHand.addCard(card)
            if playerHand.isBust() {
                result = "You lose!"
                statusMessage = "You busted!"
                gameResult = .lose
                isPlayerTurn = false
            }
        }
    }

    func playerStand(updateUI: @escaping () -> Void, completion: @escaping () -> Void) {
        isPlayerTurn = false
        dealerTurn(updateUI: updateUI, completion: completion)
    }

    func dealerTurn(updateUI: @escaping () -> Void, completion: @escaping () -> Void) {
        func dealerDraw() {
            if dealerHand.bestValue() < 17, let card = deck.drawCard() {
                dealerHand.addCard(card)
                DispatchQueue.main.async {
                    updateUI()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dealerDraw()
                }
            } else {
                self.determineWinner()
                completion()
            }
        }

        dealerDraw()
    }

    func determineWinner() {
        let playerBest = playerHand.bestValue()
        let dealerBest = dealerHand.bestValue()

        if playerHand.isBust() {
            result = "You lose!"
            gameResult = .lose
        } else if dealerHand.isBust() {
            result = "You win!"
            gameResult = .win
        } else if playerBest > dealerBest {
            result = "You win!"
            gameResult = .win
        } else if playerBest < dealerBest {
            result = "You lose!"
            gameResult = .lose
        } else {
            result = "It's a tie!"
            gameResult = .tie
        }

        statusMessage = result
    }
}

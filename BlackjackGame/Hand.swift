//
//  Hand.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

import Foundation

struct Hand {
    var cards: [Card] = []

    mutating func addCard(_ card: Card) {
        cards.append(card)
    }

    func values() -> [Int] {
        var total = [0]
        for card in cards {
            let cardValues = card.rank.value
            var newTotals: [Int] = []
            for value in cardValues {
                for t in total {
                    newTotals.append(t + value)
                }
            }
            total = newTotals
        }
        return total
    }

    func bestValue() -> Int {
        let validTotals = values().filter { $0 <= 21 }
        return validTotals.max() ?? values().min()!
    }

    func isBust() -> Bool {
        return bestValue() > 21
    }
}

//
//  Deck.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

import Foundation

struct Deck {
    private(set) var cards: [Card] = []

    init() {
        cards = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    mutating func drawCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.removeLast()
    }
}

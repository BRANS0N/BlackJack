//
//  Card.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//

import Foundation

enum Suit: String, CaseIterable, Codable, Hashable {
    case hearts = "H"
    case diamonds = "D"
    case clubs = "C"
    case spades = "S"

    var symbol: String {
        switch self {
        case .hearts: return "♥️"
        case .diamonds: return "♦️"
        case .clubs: return "♣️"
        case .spades: return "♠️"
        }
    }
}

enum Rank: String, CaseIterable, Codable, Hashable {
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
    case ace = "A"

    var value: [Int] {
        switch self {
        case .ace:
            return [1, 11]
        case .jack, .queen, .king:
            return [10]
        default:
            return [Int(self.rawValue)!]
        }
    }
}

struct Card: Codable, Hashable {
    let suit: Suit
    let rank: Rank

    func description() -> String {
        return "\(rank.rawValue)\(suit.symbol)"
    }

    var imageName: String {
        return "\(rank.rawValue)\(suit.rawValue)"
    }
}

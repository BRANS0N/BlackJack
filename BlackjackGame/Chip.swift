//
//  Chip.swift
//  BlackjackGame
//
//  Created by Branson  on 11/5/24.
//


import Foundation
import SwiftUI

struct Chip: Identifiable, Hashable {
    let id = UUID()
    let denomination: Int
    var color: Color {
        switch denomination {
        case 1:
            return .gray
        case 5:
            return .red
        case 25:
            return .green
        case 100:
            return .black
        default:
            return .blue
        }
    }
}

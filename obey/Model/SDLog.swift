//
//  SDLog.swift
//  obey
//
//  Created by Jake Grant on 9/4/24.
//

import Foundation
import SwiftData

@Model
final class SDLog: Identifiable {
    var id = UUID()
    var timestamp = Date.now
    var reward: SDReward?
    var user: SDUser?
    // Surprise mode stats
    var odds: Int?
    var losses: Int?
    var increasedOdds: Bool?

    // Star mode stats
    var starsSpent: Int?
    var starBalance: Int?

    init(
        id: UUID = UUID(),
        timestamp: Date = Date.now,
        odds: Int,
        losses: Int,
        increasedOdds: Bool
    ) {
        self.id = id
        self.timestamp = timestamp
        self.odds = odds
        self.losses = losses
        self.increasedOdds = increasedOdds
    }
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date.now,
        starsSpent: Int,
        starBalance: Int
    ) {
        self.id = id
        self.timestamp = timestamp
        self.starsSpent = starsSpent
        self.starBalance = starBalance
    }
}

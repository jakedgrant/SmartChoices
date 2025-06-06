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
    @Relationship(deleteRule: .nullify, inverse: \SDUser.logs)
    var user: SDUser?

    // Stats
    var odds: Int?
    var losses: Int?
    var increasedOdds: Bool?

    init(
        id: UUID = UUID(),
        timestamp: Date = Date.now,
        reward: SDReward,
        user: SDUser? = nil,
        odds: Int,
        losses: Int,
        increasedOdds: Bool
    ) {
        self.id = id
        self.timestamp = timestamp
        self.reward = reward
        self.user = user
        self.odds = odds
        self.losses = losses
        self.increasedOdds = increasedOdds
    }
}

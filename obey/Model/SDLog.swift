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
	
	// Stats
	var odds: Int?
	var losses: Int?
	var increasedOdds: Bool?
	
	init(
		id: UUID = UUID(),
		timestamp: Date = Date.now,
		reward: SDReward,
		odds: Int,
		losses: Int,
		increasedOdds: Bool
	) {
		self.id = id
		self.timestamp = timestamp
		self.reward = reward
		self.odds = odds
		self.losses = losses
		self.increasedOdds = increasedOdds
	}
	
	init(
		id: UUID = UUID(),
		timestamp: Date = Date.now,
		reward: SDReward,
		stats: RollStat?
	) {
		self.id = id
		self.timestamp = timestamp
		self.reward = reward
		self.odds = stats?.odds
		self.losses = stats?.losses
		self.increasedOdds = stats?.increasedOdds
	}
}

struct RollStat {
	let odds: Int
	let losses: Int
	let increasedOdds: Bool?
}

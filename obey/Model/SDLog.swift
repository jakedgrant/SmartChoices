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
	
	init(
		id: UUID = UUID(),
		timestamp: Date = Date.now,
		reward: SDReward
	) {
		self.id = id
		self.timestamp = timestamp
		self.reward = reward
	}
}

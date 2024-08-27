//
//  RewardQuery.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation

struct RewardQuery: EntityQuery {
	
	func entities(for identifiers: [RewardEntity.ID]) async throws -> [Entity] {
		let db = try RewardDatabase()
		let rewards = db.activeRewards().shuffled()
		
		return rewards.map { RewardEntity(from: $0) }
	}
	
	func suggestedEntities() async throws -> [RewardEntity] {
		let db = try RewardDatabase()
		let rewards = db.allRewards().shuffled()
		
		return rewards.map { RewardEntity(from: $0) }
	}
}

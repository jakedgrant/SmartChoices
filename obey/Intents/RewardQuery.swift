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
		
		return Reward.allCases.map { RewardEntity(from: $0) }
	}
	
	func suggestedEntities() async throws -> [RewardEntity] {
		
		return Reward.allCases.map { RewardEntity(from: $0) }
	}
}

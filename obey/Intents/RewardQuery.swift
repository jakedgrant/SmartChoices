//
//  RewardQuery.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation

struct RewardQuery: EntityQuery {

        var user: UserEntity?

        init(user: UserEntity? = nil) {
                self.user = user
        }

        func entities(for identifiers: [RewardEntity.ID]) async throws -> [Entity] {
                let db = try RewardDatabase()
                var rewards = identifiers.isEmpty ? db.activeRewards() : db.rewards(with: identifiers)

                if let userId = user?.id {
                        rewards = rewards.filter { reward in
                                reward.users?.contains(where: { $0.id == userId }) ?? false
                        }
                }

                return rewards.shuffled().map { RewardEntity(from: $0) }
        }

        func suggestedEntities() async throws -> [RewardEntity] {
                let db = try RewardDatabase()
                var rewards = db.allRewards()

                if let userId = user?.id {
                        rewards = rewards.filter { reward in
                                reward.users?.contains(where: { $0.id == userId }) ?? false
                        }
                }

                return rewards.shuffled().map { RewardEntity(from: $0) }
        }
}

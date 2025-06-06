//
//  LogDatabase.swift
//  obey
//
//  Created by Jake Grant on 9/6/24.
//

import Foundation
import SwiftData

final class LogDatabase: SwiftDatabase {
	typealias T = SDLog
	
	let container: ModelContainer
	
        init(useInMemoryStore: Bool = false) throws {
                let configuration = ModelConfiguration(
                        for: T.self,
                        isStoredInMemoryOnly: useInMemoryStore
                )

                container = try ModelContainer(
                        for: T.self,
                        migrationPlan: ObeyMigrationPlan.self,
                        configurations: configuration
                )
        }
}

extension LogDatabase {
	
	func logs(for reward: SDReward) -> [T] {
		let rewardName = reward.name
		let sort = SortDescriptor<T>(\.timestamp, order: .reverse)
		let predicate = #Predicate<SDLog> { log in
			
			if let logReward = log.reward {
				return logReward.name == rewardName
			} else {
				return false
			}
		}
		
		do {
			return try self.read(predicate: predicate, sortDescriptors: sort)
		} catch {
			print(error.localizedDescription)
			return []
		}
	}
}

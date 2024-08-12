//
//  RewardDatabase.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import Foundation
import SwiftData

final class RewardDatabase: SwiftDatabase {
	typealias T = SDReward
	
	let container: ModelContainer
	
	init(useInMemoryStore: Bool = false) throws {
		let configuration = ModelConfiguration(
			for: T.self,
			isStoredInMemoryOnly: useInMemoryStore
		)
		
		container = try ModelContainer(
			for: T.self,
			configurations: configuration
		)
	}
	
	private let allPredicate = #Predicate<T> { _ in return true }
}

extension RewardDatabase {
	
	func rewards() -> [T] {
		let sort = SortDescriptor<T>(\.name)
		
		do {
			return try self.read(predicate: allPredicate, sortDescriptors: sort)
		} catch {
			print(error.localizedDescription)
			return []
		}
	}
	
//	func reward(with identifier: T.ID) -> T? {
//		let predicate = #Predicate<T> { t in
//			t.id == identifier
//		}
//		
//		let sort = SortDescriptor<T>(\.name)
//		
//		do {
//			return try self.read(predicate: predicate, sortDescriptors: sort).first
//		} catch {
//			print(error.localizedDescription)
//			return nil
//		}
//	}
//	
//	func rewards(with identifiers: [T.ID]) -> [T] {
//		let predicate = #Predicate<T> { t in
//			identifiers.contains(t.id)
//		}
//		
//		let sort = SortDescriptor<T>(\.name)
//		
//		do {
//			return try self.read(predicate: predicate, sortDescriptors: sort)
//		} catch {
//			print(error.localizedDescription)
//			return []
//		}
//	}
}

extension RewardDatabase {
	
	func createDefault() {
		
		let rewards = Reward.allCases.map {
			SDReward(name: $0.description, systemImage: $0.image)
		}
		
		do {
			try create(rewards)
		} catch {
			print("there was an error when trying to create the default rewards... \(error.localizedDescription)")
		}
	}
}

//
//  SwiftDatabase.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import Foundation
import SwiftData

protocol SwiftDatabase<T>: Database {
	associatedtype T = PersistentModel
	var container: ModelContainer { get }
}

extension SwiftDatabase {
	
	func create<T: PersistentModel>(_ item: T) throws {
		let context = ModelContext(container)
		context.insert(item)
		try context.save()
	}
	
	func create<T: PersistentModel>(_ items: [T]) throws {
		let context = ModelContext(container)
		for item in items {
			context.insert(item)
		}
		try context.save()
	}
	
	func read<T: PersistentModel>(predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> [T] {
		let context = ModelContext(container)
		let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
		return try context.fetch(fetchDescriptor)
	}
	
	func update<T: PersistentModel>(_ item: T) throws {
		let context = ModelContext(container)
		context.insert(item)
		try context.save()
	}
	
	func delete<T: PersistentModel>(_ item: T) throws {
		let context = ModelContext(container)
		let idToDelete = item.persistentModelID
		try context.delete(model: T.self, where: #Predicate { item in
			item.persistentModelID == idToDelete
		})
		try context.save()
	}
	
	func deleteAll<T: PersistentModel>(where predicate: Predicate<T>?) throws {
		let context = ModelContext(container)
		try context.delete(model: T.self, where: predicate)
		try context.save()
	}
	
	func count<T: PersistentModel>(where predicate: Predicate<T>?) throws -> Int {
		let context = ModelContext(container)
		let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
		return try context.fetchCount(fetchDescriptor)
	}
}

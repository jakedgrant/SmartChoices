//
//  Database.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import Foundation

protocol Database<T> {
	associatedtype T
	func create(_ item: T) throws
	func create(_ items: [T]) throws
	func read(predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> [T]
	func update(_ item: T) throws
	func delete(_ item: T) throws
	
	func deleteAll(where predicate: Predicate<T>?) throws
	func count(where predicate: Predicate<T>?) throws -> Int
}

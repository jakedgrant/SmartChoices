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
			configurations: configuration
		)
	}
}

//
//  SelectedUserManager.swift
//  obey
//
//  Created by Jake Grant on 6/13/25.
//

import Foundation
import SwiftData

/* Static shared model for UserView */
class SelectedUserManager: ObservableObject {
	static let shared = SelectedUserManager()

	private let defaults = UserDefaults(suiteName: Constants.suiteName)
	@Published var selectedUser: SDUser? {
		didSet {
			defaults?.set(selectedUser?.id.uuidString, forKey: "selectedUserID")
		}
	}
	
	func ensureSelectedUser(context: ModelContext) {
		
		if let idString = defaults?.string(forKey: "selectedUserID"),
		   let uuid = UUID(uuidString: idString) {
			
			let descriptor = FetchDescriptor<SDUser>(
				predicate: #Predicate<SDUser> { $0.id == uuid }
			)
			
			if let user = try? context.fetch(descriptor).first {
				selectedUser = user
				return
			}
		}
		
		if let user = fetchOrCreateFirstUser(context: context) {
			selectedUser = user
		}
	}
	
	private func fetchOrCreateFirstUser(context: ModelContext) -> SDUser? {
		
		let descriptor = FetchDescriptor<SDUser>(
			sortBy: [SortDescriptor(\SDUser.name)]
		)
		
		do {
			
			let users = try context.fetch(descriptor)
			
			if let first = users.first {
				return first
			} else {
				
				let newUser = SDUser(name: "New Kid")
				context.insert(newUser)
				try context.save()
				return newUser
			}
		} catch {
			
			print("Error selecting user - \(error.localizedDescription)")
			return nil
		}
	}
}

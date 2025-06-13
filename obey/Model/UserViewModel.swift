//
//  UserViewModel.swift
//  obey
//
//  Created by Jake Grant on 9/1/24.
//

import Foundation
import RevenueCat
import SwiftData
import SwiftUI

/* Static shared model for UserView */
class UserViewModel: ObservableObject {
	static let shared = UserViewModel()
	
	/* The latest CustomerInfo from RevenueCat. Updated by PurchasesDelegate whenever the Purchases SDK updates the cache */
	@Published var customerInfo: CustomerInfo? {
		didSet {
			
			guard let activeEntitlements = customerInfo?.entitlements.active else {
				unlockActive = false
				return
			}
			
			let entitlementIDs = [Constants.subscriptionEntitlementID, Constants.onetimeEntitlementID]
			
			unlockActive = activeEntitlements.contains { key, value in
				entitlementIDs.contains { $0 == key }
			}
			
			isSubscriber = activeEntitlements.contains { key, _ in
				key == Constants.subscriptionEntitlementID
			}
		}
	}
	
	/* The latest offerings - fetched from MagicWeatherApp.swift on app launch */
	@Published var offerings: Offerings? = nil
	
	/* Set from the didSet method of customerInfo above, based on the entitlement set in Constants.swift */
	@Published var unlockActive: Bool = false
	
	@Published var isSubscriber: Bool = false

	private let defaults = UserDefaults(suiteName: Constants.suiteName)
	@Published var selectedUser: SDUser? {
		didSet {
			defaults?.set(selectedUser?.id.uuidString, forKey: "selectedUserID")
		}
	}
	
	/*
	 How to login and identify your users with the Purchases SDK.
	 
	 These functions mimic displaying a login dialog, identifying the user, then logging out later.
	 
	 Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
	 */
//	#warning("Public-facing usernames aren't optimal for user ID's - you should use something non-guessable, like a non-public database ID. For more information, visit https://docs.revenuecat.com/docs/user-ids.")
	func login(userId: String) async {
		_ = try? await Purchases.shared.logIn(userId)
	}
	
	func logout() async {
		_ = try? await Purchases.shared.logOut()
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

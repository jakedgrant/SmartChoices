//
//  StarBank.swift
//  obey
//

import Foundation

/* Per-child star balance for the star-based reward mode.
 Mutations follow the Roll.perform(for:) pattern: write straight to the
 model and let SwiftData autosave/CloudKit carry it to other devices. */
extension SDUser {

	@discardableResult
	func earnStars(_ amount: Int = Constants.starsPerChoice) -> Int {
		starBalance += amount
		return starBalance
	}

	func canAfford(_ cost: Int) -> Bool {
		starBalance >= cost
	}

	@discardableResult
	func spendStars(_ cost: Int) -> Bool {
		guard canAfford(cost) else {
			return false
		}

		starBalance -= cost
		return true
	}
}

/* Legacy shared-defaults balance, kept only as the fallback for the
 edge case where no user exists yet (e.g. an intent before setup) */
struct StarBank {

	public static var balance: Int {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return 0
		}

		return defaults.integer(forKey: Constants.starBalanceKey)
	}

	@discardableResult
	public static func earn(_ amount: Int = Constants.starsPerChoice) -> Int {
		let newBalance = balance + amount
		update(to: newBalance)
		return newBalance
	}

	public static func canAfford(_ cost: Int) -> Bool {
		balance >= cost
	}

	@discardableResult
	public static func spend(_ cost: Int) -> Bool {
		guard canAfford(cost) else {
			return false
		}

		update(to: balance - cost)
		return true
	}

	private static func update(to value: Int) {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return
		}

		defaults.setValue(value, forKey: Constants.starBalanceKey)
	}
}

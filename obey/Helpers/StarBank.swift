//
//  StarBank.swift
//  obey
//

import Foundation

/* Manages the star balance for the star-based reward mode */
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

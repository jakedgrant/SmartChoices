//
//  Roll.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import Foundation

struct Roll {
	
	public static func perform() -> Bool {
		
		// get odds
		var odds = getOdds()
		if odds < 1 {
			odds = resetOdds()
		}
		
		// get losses
		let losses = getLosses()
		
		let result = Int.random(in: 1...odds)
		
		if result == 1 {
			decreaseOdds()
			resetLosses()
			return true
		} else if losses >= odds {
			
			resetLosses()
			return true
		} else {
			
			updateLosses(to: losses + 1)
			return false
		}
	}
	
	@discardableResult
	public static func resetOdds() -> Int {
		let startingOdds = Constants.startingOdds
		updateOdds(to: startingOdds)
		return startingOdds
	}
	
	private static func getOdds() -> Int {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return 0
		}
		
		return defaults.integer(forKey: "odds")
	}
	
	private static func updateOdds(to value: Int) {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return
		}
		
		defaults.setValue(value, forKey: "odds")
	}
	
	public static func decreaseOdds() {
		var odds = getOdds()
		if odds < Constants.maxOdds {
			odds += 1
			updateOdds(to: odds)
		}
	}
	
	private static func getLosses() -> Int {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return 0
		}
		
		return defaults.integer(forKey: "losses")
	}
	
	private static func updateLosses(to value: Int) {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return
		}
		
		defaults.setValue(value, forKey: "losses")
	}
	
	private static func resetLosses() {
		updateLosses(to: 0)
	}
}

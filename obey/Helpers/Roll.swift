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
		let odds = getOdds()
		guard odds > 1 else {
			return true
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
	
	public static func resetOdds() {
		updateOdds(to: 1)
	}
	
	private static func getOdds() -> Int {
		return UserDefaults(suiteName: Constants.suiteName)?.integer(forKey: "odds") ?? 0
	}
	
	private static func updateOdds(to value: Int) {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return
		}
		
		defaults.setValue(value, forKey: "odds")
	}
	
	private static func decreaseOdds() {
		var odds = getOdds()
		if odds < Constants.maxOdds {
			odds += 1
			updateOdds(to: odds)
		}
	}
	
	private static func getLosses() -> Int {
		return UserDefaults(suiteName: Constants.suiteName)?.integer(forKey: "losses") ?? 0
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

/*private func roll() {
 let result = Int.random(in: 1...odds)
	   if result == 1 {
		   withAnimation {
			   startPoint = -1
			   endPoint = 1
		   }
		   alertState = .winner
		   isShowingRewards = true
		   decreaseOdds()
	   } else {
		   withAnimation {
			   startPoint = 0
			   endPoint = 3
		   }
		   alertState = .unlucky
		   isPresenting = true
	   }
   }
   
   private func decreaseOdds() {
	   if odds < Constants.maxOdds {
		   odds += 1
	   }
   }
 */

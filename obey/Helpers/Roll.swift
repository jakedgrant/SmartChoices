//
//  Roll.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import Foundation

struct Roll {
	
	static let suiteName = "group.com.jacobgrant.obey"
	
	public static func perform() -> Bool {
		
		// get odds
		let odds = getOdds()
		guard odds > 1 else {
			return true
		}
		
		let result = Int.random(in: 1...odds)
		
		if result == 1 {
			decreaseOdds()
			return true
		} else {
			return false
		}
	}
	
	public static func resetOdds() {
		updateOdds(to: 1)
	}
	
	private static func getOdds() -> Int {
		return UserDefaults(suiteName: suiteName)?.integer(forKey: "odds") ?? 0
	}
	
	private static func updateOdds(to value: Int) {
		guard let defaults = UserDefaults(suiteName: suiteName) else {
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

//
//  Constants.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import Foundation

struct Constants {
	static let startingOdds = 5
	static let maxOdds = 15

	// Star rewards
	static let starsPerChoice = 1
	static let defaultStarCost = 5
	static let starCostRange = 1...50

	// Shared defaults keys
	static let rewardModeKey = "rewardMode"
	static let starBalanceKey = "starBalance"
	static let rewardModelVersionKey = "rewardModelVersion"
	static let hasCompletedRewardSetupKey = "hasCompletedRewardSetup"

	static let suiteName = "group.com.jacobgrant.obey"
	
	static let subscriptionEntitlementID = "full_unlock_subscription"
	static let onetimeEntitlementID = "full_unlock_onetime"
	
	static let defaultImageName = "star.circle.fill"
	
	static let startingVersion = "0.0.0"
}


//
//  SDReward.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class SDReward: Identifiable {
	var id = UUID()
	var name: String = ""
	var systemImage: String = Constants.defaultImageName
	var isActive: Bool = true
	/* How many stars the reward costs in star mode.
	 The default value lets SwiftData lightweight-migrate stores that predate star rewards. */
	var starCost: Int = Constants.defaultStarCost

	@Relationship(deleteRule: .nullify, inverse: \SDLog.reward) var logs: [SDLog]? = []

	init(name: String = "", systemImage: String = Constants.defaultImageName, isActive: Bool = true, starCost: Int = Constants.defaultStarCost, logs: [SDLog]? = []) {
		self.name = name
		self.systemImage = systemImage
		self.isActive = isActive
		self.starCost = starCost
		self.logs = logs
	}
}

extension SDReward {
	
	var image: Image {
		Image(systemName: systemImage)
	}
}

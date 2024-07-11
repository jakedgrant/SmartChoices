//
//  RewardEntity.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation
import SwiftUI

struct RewardEntity: AppEntity, Displayable{
	
	static var typeDisplayRepresentation: TypeDisplayRepresentation {
		"Reward"
	}
	
	static var defaultQuery = RewardQuery()
	var id: Reward.ID
	
	@Property(title: "Description")
	var description: String
	
	@Property(title: "Image Name")
	var image: String
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(
			title: "\(description)",
			image: DisplayRepresentation.Image(systemName: image)
		)
	}
	
	init(from reward: Reward) {
		self.id = reward.id
		self.description = reward.description
		self.image = reward.image
	}
}

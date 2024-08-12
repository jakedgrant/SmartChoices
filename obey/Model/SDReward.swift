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
final class SDReward {
	@Attribute(.unique) var name: String
	var systemImage: String
	
	static let defaultImage = "trophy.fill"
	
	init(name: String, systemImage: String? = nil) {
		self.name = name
		self.systemImage = systemImage ?? Self.defaultImage
	}
}

extension SDReward {
	
	var image: Image {
		Image(systemName: systemImage)
	}
}

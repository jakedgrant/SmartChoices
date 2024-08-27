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
	var systemImage: String = "trophy.fill"
	var isActive: Bool = true
	
	init(name: String = "", systemImage: String = "trophy.fill", isActive: Bool = true) {
		self.name = name
		self.systemImage = systemImage
		self.isActive = isActive
	}
}

extension SDReward {
	
	var image: Image {
		Image(systemName: systemImage)
	}
}

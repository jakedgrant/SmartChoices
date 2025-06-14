//
//  RewardListView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/8/24.
//

import SwiftData
import SwiftUI

struct RewardListView: View {
	
        var modelContext: ModelContext

        @State private var topRewards: [SDReward]
        @State private var otherRewards: [SDReward]
        @Environment(\.themeColor) private var themeColor
	
	init(modelContext: ModelContext) {
		
		self.modelContext = modelContext
		
		let fetchDescriptor = FetchDescriptor<SDReward>(predicate: #Predicate<SDReward> { $0.isActive }, sortBy: [])
		do {
			let rewards = try modelContext.fetch(fetchDescriptor).shuffled()
			
			topRewards = Array(rewards.prefix(3))
			otherRewards = Array(rewards.dropFirst(3))
			
		} catch {
			print("uh oh: \(error.localizedDescription)")
			self.topRewards = []
			self.otherRewards = []
		}
	}
	
	var body: some View {
		NavigationStack {
			List {
				Section("Pick a reward") {
					ForEach(topRewards) { reward in
						
                                                Label(reward.name, systemImage: reward.systemImage)
                                                        .foregroundStyle(themeColor)
                                                        .symbolRenderingMode(.hierarchical)
					}
				}
		
				if !otherRewards.isEmpty {
					Section("All other rewards") {
						
						ForEach(otherRewards) { reward in
							
                                                        Label(reward.name, systemImage: reward.systemImage)
                                                                .foregroundStyle(themeColor)
                                                                .symbolRenderingMode(.hierarchical)
						}
					}
				}
			}
			.listStyle(.carousel)
			.containerBackground(Color.yellow.gradient, for: .navigation)
		}
	}
}

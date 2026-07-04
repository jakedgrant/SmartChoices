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

	@AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName)) var rewardModeRawValue: String = RewardMode.surprise.rawValue

	@State private var topRewards: [SDReward]
	@State private var otherRewards: [SDReward]

	var rewardMode: RewardMode {
		RewardMode(rawValue: rewardModeRawValue) ?? .surprise
	}
	
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

						rewardRow(for: reward)
					}
				}

				if !otherRewards.isEmpty {
					Section("All other rewards") {

						ForEach(otherRewards) { reward in

							rewardRow(for: reward)
						}
					}
				}
			}
			.listStyle(.carousel)
			.containerBackground(Color.yellow.gradient, for: .navigation)
		}
	}

	private func rewardRow(for reward: SDReward) -> some View {
		HStack {
			Label(reward.name, systemImage: reward.systemImage)
				.foregroundStyle(Color.accentColor)
				.symbolRenderingMode(.hierarchical)

			Spacer()

			if rewardMode == .stars {
				BadgeLabel("\(reward.starCost)", systemImage: "star.fill")
			}
		}
	}
}

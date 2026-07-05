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
	@Environment(\.themeColor) private var themeColor

	var rewardMode: RewardMode {
		RewardMode(rawValue: rewardModeRawValue) ?? .surprise
	}
	
	init(modelContext: ModelContext) {
		
		self.modelContext = modelContext
		
		let fetchDescriptor = FetchDescriptor<SDReward>(predicate: #Predicate<SDReward> { $0.isActive }, sortBy: [])
		do {
			var rewards = try modelContext.fetch(fetchDescriptor).shuffled()
			
            if let selectedUser = SelectedUserManager.shared.selectedUser {
                rewards = rewards.filter { reward in
                    reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
                }
            }
            
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
				.foregroundStyle(themeColor)
				.symbolRenderingMode(.hierarchical)

			Spacer()

			if rewardMode == .stars {
				BadgeLabel("\(reward.starCost)", systemImage: "star.fill")
			}
		}
	}
}

//
//  ManageRewardsView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import RevenueCatUI
import SwiftData
import SwiftUI
import TipKit

struct ManageRewardsView: View {
	
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var nav: NavigationStateManager
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	
	@Query(sort: \SDReward.name) private var rewards: [SDReward]
	@State private var newRewardName = ""

	@AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName))
	private var rewardModeRawValue: String = RewardMode.surprise.rawValue

	private var rewardMode: RewardMode {
		RewardMode(rawValue: rewardModeRawValue) ?? .surprise
	}
	
	let swipeActionsTip = ManageRewardsSwipeActionsTip()
	
	var body: some View {
		
		List {
			
			Section {
				TipView(swipeActionsTip)
			}
			
			ForEach(rewards) { reward in
				
				NavigationLink(value: reward, label: {

					HStack {
						Label(reward.name, systemImage: reward.systemImage)
							.symbolRenderingMode(.hierarchical)
							.padding(10)

						Spacer()

						if rewardMode == .stars {
							BadgeLabel("\(reward.starCost)", systemImage: "star.fill")
						}
					}
					.opacity(reward.isActive ? 1 : 0.4)
				})
				.swipeActions(edge: .leading, allowsFullSwipe: true) {
					
					if userViewModel.unlockActive {
						Button { reward.isActive.toggle() } label: {
							if reward.isActive {
								Label("Deactivate", systemImage: "circle.slash")
							} else {
								Label("Activate", systemImage: "circle")
							}
						}
						.tint(.accentColor)
					} else {
						EmptyView()
					}
				}
				.swipeActions(edge:.trailing, allowsFullSwipe: true) {
					Button(role: .destructive) {
						deleteReward(reward)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
				
			}
		}
		.navigationTitle(Text("Manage Rewards"))
		.navigationDestination(for: SDReward.self) { AddEditRewardView(reward: $0) }
		
		.safeAreaInset(edge: .bottom) {
			
			Button(action: addReward) {
				Label(allowsAddReward() ? "Add new reward" : "Unlock to add more rewards", systemImage: allowsAddReward() ? "plus" : "lock")
			}
			.buttonStyle(SCButtonStyle())
			.frame(maxWidth: .infinity)
		}
		.fontDesign(.rounded)
	}
}

extension ManageRewardsView {
	
	private func deleteReward(_ reward: SDReward) {
		modelContext.delete(reward)
	}
	
	private func addReward() {
		
		guard allowsAddReward() else {
			nav.path.append(Route.paywall)
			return
		}
		
		let newReward = SDReward(name: newRewardName)
		modelContext.insert(newReward)
		
		nav.path.append(newReward)
	}
	
	private func allowsAddReward() -> Bool {
		
		if userViewModel.unlockActive {
			return true
		}
		
		return rewards.count <= 5
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDReward.self, configurations: config)
	
	for r in Reward.allCases {
		let n = SDReward(name: r.description, systemImage: r.image)
		container.mainContext.insert(n)
	}
	
	return ManageRewardsView()
		.modelContainer(container)
}

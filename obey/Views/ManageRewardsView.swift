//
//  ManageRewardsView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import SwiftData
import SwiftUI

struct ManageRewardsView: View {
	
	@Environment(\.modelContext) var modelContext
	
	@Query private var rewards: [SDReward]
	@State private var newRewardName = ""
	@State private var selectedRewards: [SDReward] = []
	
    var body: some View {
		NavigationStack(path: $selectedRewards) {
			
			ZStack(alignment: .bottomTrailing) {
				
				List {
					
					ForEach(rewards) { reward in
						NavigationLink(value: reward, label: {
							
							Label(reward.name, systemImage: reward.systemImage)
								.symbolRenderingMode(.hierarchical)
								.padding(10)
								.opacity(reward.isActive ? 1 : 0.4)
						})
						.swipeActions(edge: .leading, allowsFullSwipe: true) {
							Button { reward.isActive.toggle() } label: {
								if reward.isActive {
									Label("Deactivate", systemImage: "circle.slash")
								} else {
									Label("Activate", systemImage: "circle")
								}
							}
							.tint(.accentColor)
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
				.toolbar {
					
					ToolbarItem {
						Text("Manage Rewards")
					}
				}
				.navigationDestination(for: SDReward.self, destination: AddEditRewardView.init)
				
				Button(action: addReward) {
					
					Image(systemName: "plus")
						.imageScale(.large)
						.bold()
						.padding(10)
				}
				.labelStyle(.iconOnly)
				.buttonStyle(.borderedProminent)
				.offset(x: -28, y: -1)
				.shadow(radius: 5)

			}
			.fontWidth(.expanded)
		}
    }
}

extension ManageRewardsView {
	
	private func deleteReward(_ reward: SDReward) {
		modelContext.delete(reward)
	}
	
	private func addReward() {
		
		let newReward = SDReward(name: newRewardName)
		modelContext.insert(newReward)
		
		selectedRewards = [newReward]
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

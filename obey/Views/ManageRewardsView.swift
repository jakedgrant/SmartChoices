//
//  ManageRewardsView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import SwiftData
import SwiftUI
import RevenueCatUI

struct ManageRewardsView: View {
	
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var nav: NavigationStateManager
	
	@Query(sort: \SDReward.name) private var rewards: [SDReward]
	@State private var newRewardName = ""
	
	var body: some View {
		
		List(rewards) { reward in
			
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
		.navigationTitle(Text("Manage Rewards"))
		.navigationDestination(for: SDReward.self) { AddEditRewardView(reward: $0) }
		
		.safeAreaInset(edge: .bottom) {
			
			Button(action: addReward) {
				Label("Add new reward", systemImage: "plus")
			}
			.buttonStyle(SCButtonStyle())
			.frame(maxWidth: .infinity)
		}
		.fontDesign(.rounded)
		//			.presentPaywallIfNeeded { customerInfo in
		//				// Returning `true` will present the paywall
		//
		//				let activeEntitlements = customerInfo.entitlements.active
		//				let entitlementIDs = [Constants.subscriptionEntitlementID, Constants.onetimeEntitlementID]
		//
		//				let active = activeEntitlements.contains { key, value in
		//					entitlementIDs.contains { $0 == key }
		//				}
		//
		//				return !active
		//
		//			} purchaseCompleted: { customerInfo in
		//				print("Purchase completed: \(customerInfo.entitlements)")
		//			} restoreCompleted: { customerInfo in
		//				// Paywall will be dismissed automatically if "pro" is now active.
		//				print("Purchases restored: \(customerInfo.entitlements)")
		//			}
	}
}

extension ManageRewardsView {
	
	private func deleteReward(_ reward: SDReward) {
		modelContext.delete(reward)
	}
	
	private func addReward() {
		
		let newReward = SDReward(name: newRewardName)
		modelContext.insert(newReward)
		
		nav.path.append(newReward)
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

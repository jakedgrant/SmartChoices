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
	@Query(sort: \SDUser.name) private var users: [SDUser]
	@State private var selectedUser: SDUser? = nil
	@State private var newRewardName = ""

	let swipeActionsTip = ManageRewardsSwipeActionsTip()

	private var filteredRewards: [SDReward] {
		guard let selectedUser else { return rewards }
		return rewards.filter { reward in
			reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
		}
	}

	var body: some View {

		List {

			Section {
				TipView(swipeActionsTip)
			}

			ForEach(filteredRewards) { reward in

				NavigationLink(value: reward, label: {

					Label(reward.name, systemImage: reward.systemImage)
						.symbolRenderingMode(.hierarchical)
						.padding(10)
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
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
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
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Menu {
					Text("Filter by user")
					Button("All Users") { selectedUser = nil }
					ForEach(users) { user in
						Button(user.name) { selectedUser = user }
					}
				} label: {
					Text(selectedUser?.name ?? "All Users")
				}
			}
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
	let container = try! ModelContainer(for: SDReward.self, SDUser.self, configurations: config)

	for r in Reward.allCases {
		let n = SDReward(name: r.description, systemImage: r.image)
		container.mainContext.insert(n)
	}

	let u1 = SDUser(name: "Preview 1")
	let u2 = SDUser(name: "Preview 2")
	container.mainContext.insert(u1)
	container.mainContext.insert(u2)

	return ManageRewardsView()
		.modelContainer(container)
}

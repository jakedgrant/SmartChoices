//
//  RedeemRewardsView.swift
//  obey
//

import ConfettiSwiftUI
import SwiftData
import SwiftUI

/* Star mode: trade the selected child's earned stars in for one of their rewards */
struct RedeemRewardsView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext

	@ObservedObject private var selectedUserManager = SelectedUserManager.shared

	@Query(filter: #Predicate<SDReward> { $0.isActive }, sort: \SDReward.starCost)
	private var rewards: [SDReward]

	@State private var counter = 0
	@State private var rewardToRedeem: SDReward? = nil

	private var starBalance: Int {
		selectedUserManager.selectedUser?.starBalance ?? 0
	}

	private var userRewards: [SDReward] {
		guard let selectedUser = selectedUserManager.selectedUser else {
			return rewards
		}

		return rewards.filter { reward in
			reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
		}
	}

	private var affordableRewards: [SDReward] {
		userRewards.filter { $0.starCost <= starBalance }
	}

	private var savingUpRewards: [SDReward] {
		userRewards.filter { $0.starCost > starBalance }
	}

	var body: some View {
		NavigationStack {
			List {
				Section {
					HStack {
						Spacer()
						StarBalanceLabel(balance: starBalance)
						Spacer()
					}
					.listRowBackground(Color.clear)
				}

				if !affordableRewards.isEmpty {
					Section("Ready to redeem") {
						ForEach(affordableRewards) { reward in

							Button {
								rewardToRedeem = reward
							} label: {
								row(for: reward)
							}
						}
					}
				}

				if !savingUpRewards.isEmpty {
					Section("Keep saving for") {
						ForEach(savingUpRewards) { reward in

							row(for: reward)
								.opacity(0.4)
						}
					}
				}
			}
			.navigationTitle(Text("Redeem Stars"))
			.navigationBarTitleDisplayMode(.inline)

			.confettiCannon(
				counter: $counter,
				num: 100,
				rainHeight: 700,
				radius: 400
			)

			.alert(
				"Redeem reward",
				isPresented: isConfirmingRedeem,
				presenting: rewardToRedeem
			) { reward in

				Button("Redeem") {
					redeem(reward)
				}
				Button("Not yet", role: .cancel) { }
			} message: { reward in
				Text("Trade \(reward.starCost) stars for \(reward.name)?")
			}

			.toolbar {
				ToolbarItem {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
							.imageScale(.small)
					}
					.buttonStyle(SCCircleButtonStyle(padding: 12))
					.padding(.trailing, -12)
				}
			}
		}
		.fontDesign(.rounded)
	}

	private var isConfirmingRedeem: Binding<Bool> {
		Binding(
			get: { rewardToRedeem != nil },
			set: { isPresented in
				if !isPresented {
					rewardToRedeem = nil
				}
			}
		)
	}

	private func row(for reward: SDReward) -> some View {
		HStack {
			Label(reward.name, systemImage: reward.systemImage)
				.symbolRenderingMode(.hierarchical)
				.padding(10)

			Spacer()

			BadgeLabel("\(reward.starCost)", systemImage: "star.fill")
		}
	}

	private func redeem(_ reward: SDReward) {

		guard let user = selectedUserManager.selectedUser,
			  user.spendStars(reward.starCost) else {
			return
		}

		let log = SDLog(
			starsSpent: reward.starCost,
			starBalance: user.starBalance
		)
		log.reward = reward
		log.user = user

		modelContext.insert(log)

		do {
			try modelContext.save()
		} catch {
			print("error saving log - \(error.localizedDescription)")
		}

		counter += 1

		// let the confetti land before closing
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			dismiss()
		}
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDReward.self, configurations: config)

	for r in Reward.allCases {
		let n = SDReward(name: r.description, systemImage: r.image, starCost: r.starCost)
		container.mainContext.insert(n)
	}

	return RedeemRewardsView()
		.modelContainer(container)
}

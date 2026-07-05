//
//  RedeemRewardsView.swift
//  obey
//

import ConfettiSwiftUI
import SwiftData
import SwiftUI

/* Star mode: trade earned stars in for a reward */
struct RedeemRewardsView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext

	@AppStorage(Constants.starBalanceKey, store: UserDefaults(suiteName: Constants.suiteName))
	private var starBalance: Int = 0

	@Query(filter: #Predicate<SDReward> { $0.isActive }, sort: \SDReward.starCost)
	private var rewards: [SDReward]

	@State private var counter = 0
	@State private var rewardToRedeem: SDReward? = nil

	private var affordableRewards: [SDReward] {
		rewards.filter { $0.starCost <= starBalance }
	}

	private var savingUpRewards: [SDReward] {
		rewards.filter { $0.starCost > starBalance }
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

		guard StarBank.spend(reward.starCost) else {
			return
		}

		let log = SDLog(
			starsSpent: reward.starCost,
			starBalance: StarBank.balance
		)
		log.reward = reward
		log.user = SelectedUserManager.shared.selectedUser

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

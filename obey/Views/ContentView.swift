//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import Recap
import RevenueCat
import SwiftData
import SwiftUI
import TipKit

struct ContentView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	@AppStorage("previousVersionString", store: UserDefaults(suiteName: Constants.suiteName)) var previousVersionString: String = Constants.startingVersion
	@AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName)) var rewardModeRawValue: String = RewardMode.surprise.rawValue
	@AppStorage(Constants.starBalanceKey, store: UserDefaults(suiteName: Constants.suiteName)) var starBalance: Int = 0
	@AppStorage(Constants.hasCompletedRewardSetupKey, store: UserDefaults(suiteName: Constants.suiteName)) var hasCompletedRewardSetup: Bool = false

	@Environment(\.modelContext) var modelContext
	@Query var rewards: [SDReward]

	@State private var isPresenting = false
	@State private var isPresentingStarEarned = false
	@State private var isShowingRewards = false
	@State private var isShowingRedeem = false
	@State private var isShowingSettings = false
	@State private var isShowingRecap = false
	@State private var isShowingOnboarding = false
	@State private var releasePackage: ReleasePackage? = nil

	@State private var startPoint = -1
	@State private var endPoint = 2

	let colors: [Color] = [.red, .orange, .yellow, .green]

	var rewardMode: RewardMode {
		RewardMode(rawValue: rewardModeRawValue) ?? .surprise
	}

	private var canRedeemReward: Bool {
		rewards.contains { $0.isActive && $0.starCost <= starBalance }
	}
	
    var body: some View {
		NavigationStack {
			ZStack {
				
//				LinearGradient(
//					colors: colors,
//					startPoint: UnitPoint(x: 0.5, y: CGFloat(startPoint)),
//					endPoint: UnitPoint(x:0.5, y: CGFloat(endPoint))
//				)
//				.animation(.easeIn, value: endPoint)
//				.ignoresSafeArea()
				
				VStack {

					if rewardMode == .stars {
						Button {
							isShowingRedeem = true
						} label: {
							StarBalanceLabel(balance: starBalance)
						}
						.buttonStyle(.plain)
						.accessibilityHint("Tap to redeem your stars")
					}

					Button("Smart Choice", action: makeSmartChoice)
						.buttonStyle(SCCircleButtonStyle(padding: 80))
						.font(.title2)

						.alert(
							Alert.unlucky.title,
							isPresented: $isPresenting,
							presenting: Alert.unlucky
						) { state in

							Button("Reward Anyway") {
								LastStat.shared.update(odds: odds, losses: losses, increasedOdds: false)
								isShowingRewards = true
							}
							Button(state.cta, role: .cancel) { }
						} message: { state in
							Text(state.subtitle)
						}

						.alert(
							Alert.starEarned.title,
							isPresented: $isPresentingStarEarned,
							presenting: Alert.starEarned
						) { state in

							if canRedeemReward {
								Button("Redeem a reward") {
									isShowingRedeem = true
								}
							}
							Button(state.cta, role: .cancel) { }
						} message: { state in
							Text("You now have \(starBalance) \(starBalance == 1 ? "star" : "stars"). \(state.subtitle)")
						}

						.sheet(isPresented: $isShowingRewards) {
							RewardListView(modelContext: self.modelContext)
						}

						.sheet(isPresented: $isShowingRedeem) {
							RedeemRewardsView()
						}

						.sensoryFeedback(.success, trigger: isShowingRewards) { _, new in
							new == true
						}

						.sensoryFeedback(.increase, trigger: starBalance) { old, new in
							new > old
						}
				}
			}
			
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button {
						isShowingSettings = true
					} label: {
						MenuImageView()
					}
				}
			}
			
			.sheet(isPresented: $isShowingSettings) {
				SettingsView()
			}
			
			.sheet(item: $releasePackage, onDismiss: presentOnboardingIfNeeded) { package in
				ObeyRecap(showing: package.releases)
			}

			.fullScreenCover(isPresented: $isShowingOnboarding) {
				OnboardingView()
					.interactiveDismissDisabled()
			}

			.task {
				await populateRewards()
			}

			.onAppear {
				releasePackage = showReleasePackage

				if releasePackage == nil {
					presentOnboardingIfNeeded()
				}
			}
		}
    }

	private func makeSmartChoice() {
		switch rewardMode {
		case .surprise:
			roll()
		case .stars:
			earnStar()
		}
	}

	private func roll() {
		let result = Roll.perform()
		isPresenting = !result
		isShowingRewards = result
	}

	private func earnStar() {
		withAnimation {
			starBalance += Constants.starsPerChoice
		}
		isPresentingStarEarned = true
	}

	/* New users pick a mode and their starting rewards; existing users are
	 marked as set up by RewardModelMigrator and never see this */
	private func presentOnboardingIfNeeded() {
		if !hasCompletedRewardSetup {
			isShowingOnboarding = true
		}
	}

	private func populateRewards() async {

		// reward setup owns the first population; this is a safety net if the store is ever emptied
		guard hasCompletedRewardSetup, rewards.isEmpty else {
			return
		}

		Reward.allCases.forEach {
			let newReward = SDReward(name: $0.description, systemImage: $0.image, starCost: $0.starCost)
			modelContext.insert(newReward)
		}

		do {
			try modelContext.save()
		} catch {
			print("error saving log - \(error.localizedDescription)")
		}
	}
	
	var showReleasePackage: ReleasePackage? {
		let currentVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		guard let currentVersionString else { return nil }

		let packageToShow = ReleasePackage.display(for: currentVersionString, with: previousVersionString)
		previousVersionString = currentVersionString
		
		return packageToShow
	}
}

#Preview {
	ContentView()
}

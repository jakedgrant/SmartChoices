//
//  OnboardingView.swift
//  obey
//

import SwiftData
import SwiftUI

/* First-launch setup: pick a reward mode, then start with the default rewards or build a custom list */
struct OnboardingView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) var dismiss

	@AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName))
	private var rewardModeRawValue: String = RewardMode.surprise.rawValue

	@AppStorage(Constants.hasCompletedRewardSetupKey, store: UserDefaults(suiteName: Constants.suiteName))
	private var hasCompletedRewardSetup: Bool = false

	@State private var selectedMode: RewardMode = .stars
	@State private var useDefaultRewards = true
	@State private var customRewards: [DraftReward] = []
	@State private var isAddingReward = false

	/* Matches the free reward limit in ManageRewardsView */
	private let maxStartingRewards = 6

	struct DraftReward: Identifiable {
		let id = UUID()
		var name = ""
		var systemImage = Constants.defaultImageName
		var starCost = Constants.defaultStarCost
	}

	var body: some View {
		NavigationStack {
			Form {
				modeSection
				startingRewardsSection
			}
			.navigationTitle(Text("Set Up Rewards"))
			.navigationBarTitleDisplayMode(.inline)

			.safeAreaInset(edge: .bottom) {
				Button(action: finish) {
					Label("Start making Smart Choices", systemImage: "checkmark")
				}
				.buttonStyle(SCButtonStyle())
				.frame(maxWidth: .infinity)
				.disabled(!useDefaultRewards && customRewards.isEmpty)
			}

			.sheet(isPresented: $isAddingReward) {
				AddDraftRewardView(showsStarCost: selectedMode == .stars) { draft in
					customRewards.append(draft)
				}
			}
		}
		.fontDesign(.rounded)
	}

	private var modeSection: some View {
		Section {
			ForEach(RewardMode.allCases) { mode in

				Button {
					selectedMode = mode
				} label: {
					HStack {
						Label(mode.title, systemImage: mode.systemImage)
							.symbolRenderingMode(.hierarchical)
							.padding(10)

						Spacer()

						Image(systemName: selectedMode == mode ? "checkmark.circle.fill" : "circle")
							.foregroundStyle(selectedMode == mode ? Color.accentColor : Color.gray)
					}
				}
				.foregroundStyle(.primary)
			}
		} header: {
			Text("How should rewards work?")
		} footer: {
			Text(selectedMode.explanation)
		}
	}

	private var startingRewardsSection: some View {
		Section {
			Picker("Starting rewards", selection: $useDefaultRewards) {
				Text("Default rewards").tag(true)
				Text("My own rewards").tag(false)
			}
			.pickerStyle(.segmented)

			if useDefaultRewards {

				ForEach(Reward.allCases) { reward in
					rewardRow(name: reward.description, systemImage: reward.image, starCost: reward.starCost)
				}
			} else {

				ForEach(customRewards) { draft in
					rewardRow(name: draft.name, systemImage: draft.systemImage, starCost: draft.starCost)
				}
				.onDelete { offsets in
					customRewards.remove(atOffsets: offsets)
				}

				if customRewards.count < maxStartingRewards {
					Button {
						isAddingReward = true
					} label: {
						Label("Add a reward", systemImage: "plus")
					}
				}
			}
		} header: {
			Text("Starting rewards")
		} footer: {
			Text("You can add, edit, and remove rewards anytime from Settings.")
		}
	}

	private func rewardRow(name: String, systemImage: String, starCost: Int) -> some View {
		HStack {
			Label(name, systemImage: systemImage)
				.symbolRenderingMode(.hierarchical)
				.padding(10)

			Spacer()

			if selectedMode == .stars {
				BadgeLabel("\(starCost)", systemImage: "star.fill")
			}
		}
	}

	private func finish() {

		let newRewards: [SDReward]

		if useDefaultRewards {
			newRewards = Reward.allCases.map {
				SDReward(name: $0.description, systemImage: $0.image, starCost: $0.starCost)
			}
		} else {
			newRewards = customRewards.map {
				SDReward(name: $0.name, systemImage: $0.systemImage, starCost: $0.starCost)
			}
		}

		newRewards.forEach { modelContext.insert($0) }

		do {
			try modelContext.save()
		} catch {
			print("error saving onboarding rewards - \(error.localizedDescription)")
		}

		rewardModeRawValue = selectedMode.rawValue
		hasCompletedRewardSetup = true

		dismiss()
	}
}

/* Sheet for drafting a reward during onboarding, before any reward exists in the store */
private struct AddDraftRewardView: View {
	@Environment(\.dismiss) var dismiss

	let showsStarCost: Bool
	let onAdd: (OnboardingView.DraftReward) -> Void

	@State private var draft = OnboardingView.DraftReward()
	@State private var isShowingIconPicker = false

	var body: some View {
		NavigationStack {
			Form {
				Section("Name") {
					TextField("Reward description", text: $draft.name)
				}

				Section("Icon") {
					Button {
						isShowingIconPicker = true
					} label: {
						IconView(icon: draft.systemImage)
					}
					.sheet(isPresented: $isShowingIconPicker) {
						IconPickerView(selectedImageName: $draft.systemImage)
							.presentationDetents([.medium])
					}
				}

				if showsStarCost {
					Section("Star cost") {
						Stepper(value: $draft.starCost, in: Constants.starCostRange) {
							Label("\(draft.starCost) stars", systemImage: "star.fill")
						}
					}
				}
			}
			.navigationTitle(Text("New Reward"))
			.navigationBarTitleDisplayMode(.inline)

			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}

				ToolbarItem(placement: .confirmationAction) {
					Button("Add") {
						onAdd(draft)
						dismiss()
					}
					.disabled(draft.name.trimmingCharacters(in: .whitespaces).isEmpty)
				}
			}
		}
		.fontDesign(.rounded)
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDReward.self, configurations: config)

	return OnboardingView()
		.modelContainer(container)
}

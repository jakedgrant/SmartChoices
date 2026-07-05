//
//  RollView.swift
//  obey
//
//  Created by Jake Grant on 7/3/25.
//

import SwiftData
import SwiftUI

struct RollView: View {
    @Environment(\.modelContext) var modelContext
    @Query var rewards: [SDReward]

    @AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName)) var rewardModeRawValue: String = RewardMode.surprise.rawValue
    @AppStorage(Constants.starBalanceKey, store: UserDefaults(suiteName: Constants.suiteName)) var starBalance: Int = 0

    var selectedUser: SDUser?

    @State private var isShowingRewards = false
    @State private var isAlerting = false
    @State private var isShowingStarEarned = false

    var rewardMode: RewardMode {
        RewardMode(rawValue: rewardModeRawValue) ?? .surprise
    }

    var body: some View {
        VStack {
            if let selectedUser, !rewards.isEmpty {
                Button("Smart Choice", action: { makeSmartChoice(for: selectedUser) })
                    .bold()
                    .fontDesign(.rounded)

                if rewardMode == .stars {
                    StarBalanceLabel(balance: starBalance)
                        .padding(.top, 8)
                }
            } else {

            }
        }
        .alert(
            Alert.unlucky.title,
            isPresented: $isAlerting,
            presenting: Alert.unlucky
        ) { state in
            Button(state.cta) { }
        } message: { state in
            Text(state.subtitle)
        }
        .alert(
            Alert.starEarned.title,
            isPresented: $isShowingStarEarned,
            presenting: Alert.starEarned
        ) { state in
            Button(state.cta) { }
        } message: { state in
            Text("You now have ^[\(starBalance) star](inflect: true).")
        }
        .sheet(isPresented: $isShowingRewards) {
            RewardListView(modelContext: self.modelContext)
        }
    }

    private func makeSmartChoice(for user: SDUser?) {
        switch rewardMode {
        case .surprise:
            roll(for: user)
        case .stars:
            earnStar()
        }
    }

    private func roll(for user: SDUser?) {

        let result = if let user {
            Roll.perform(for: user)
        } else {
            Roll.perform()
        }

        if result {
            isShowingRewards = true
        } else {
            isAlerting = true
        }
    }

    private func earnStar() {
        withAnimation {
            starBalance += Constants.starsPerChoice
        }
        isShowingStarEarned = true
    }
}

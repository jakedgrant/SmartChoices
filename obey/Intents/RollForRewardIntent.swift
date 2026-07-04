//
//  RollForRewardIntent.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation
import SwiftUI

struct RollForRewardIntent: AppIntent {
	
	static var title: LocalizedStringResource = "Roll for making a Smart Choice reward."
	static var description = IntentDescription("Makes a roll for making a Smart Choice. If the roll is successfull, presents a list of rewards to choose from.")
	
	func perform() async throws -> some IntentResult & ReturnsValue<[RewardEntity]> & ProvidesDialog & ShowsSnippetView {

		var rewards = [RewardEntity]()
		let dialogFull: LocalizedStringResource
		let dialogSupporting: LocalizedStringResource

		switch RewardMode.current {
		case .stars:

			// every smart choice earns a star
			let balance = StarBank.earn()

			let db = try RewardDatabase()
			rewards = db.activeRewards()
				.filter { $0.starCost <= balance }
				.sorted { $0.starCost > $1.starCost }
				.prefix(3)
				.map { RewardEntity(from: $0) }

			dialogFull = "You earned a star!"
			if rewards.isEmpty {
				dialogSupporting = "You now have \(balance) stars. Keep making smart choices to save up for a reward."
			} else {
				dialogSupporting = "You now have \(balance) stars, enough to redeem a reward in the app!"
			}

		case .surprise:

			// roll
			let isWinner = Roll.perform()

			if isWinner {

				let db = try RewardDatabase()
				rewards = db.activeRewards().shuffled().prefix(3).map { RewardEntity(from:$0) }

				let lastReward = rewards.last?.description ?? "something else"
				let rewardsListString = rewards.prefix(2).map { $0.description }.joined(separator: ", ")
				dialogFull = "You win!"
				dialogSupporting = "You can select one of these rewards: \(rewardsListString), or \(lastReward)."
			} else {

				dialogFull = "Maybe next time"
				dialogSupporting = "You made a smart choice and might win a reward next time."
			}
		}

		let snippet = RewardSnippet(rewards: rewards)
		
		let dialog = IntentDialog(
			full: dialogFull,
			supporting: dialogSupporting
		)
		
		return .result(value: rewards, dialog: dialog, view: snippet)
	}
	
	struct RewardSnippet: View {
		
		var rewards: [RewardEntity]
		
		var body: some View {
			if rewards.isEmpty {
				EmptyView()
			} else {
				HorizontalRewardList(items: rewards.prefix(3), showDescription: false)
					.foregroundStyle(Color.teal)
					.padding(.vertical, 4)
			}
		}
	}
}

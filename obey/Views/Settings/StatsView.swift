//
//  StatsView.swift
//  obey
//
//  Created by Jake Grant on 9/14/24.
//

import SwiftData
import SwiftUI

struct StatsView: View {
	@Query var rewards: [SDReward]
	@Query var logs: [SDLog]
	
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	@AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName)) var rewardModeRawValue: String = RewardMode.surprise.rawValue
	@AppStorage(Constants.starBalanceKey, store: UserDefaults(suiteName: Constants.suiteName)) var starBalance: Int = 0

	private var rewardMode: RewardMode {
		RewardMode(rawValue: rewardModeRawValue) ?? .surprise
	}

    var body: some View {

		Group {
			StatLine(text: "Available rewards:", value: rewards.count.description)

			StatLine(text: "Times rewarded:", value: logs.count.description)

			switch rewardMode {
			case .stars:
				StatLine(text: "Star balance:", value: starBalance.description)

			case .surprise:
				Button {
					Roll.resetOdds()
				} label: {
					StatLine(text: "Current odds:", value: odds.description, subtitle: "tap to reset")
				}
				.buttonStyle(.plain)

				StatLine(text: "Current losses:", value: losses.description)
			}
		}
    }
	
	struct StatLine: View {
		let text: String
		let value: String
		var subtitle: String? = nil
		
		var body: some View {
			HStack(alignment: .firstTextBaseline) {
				
				VStack(alignment: .leading) {
					Text(text)
					
					if let subtitle {
						Text(subtitle)
							.font(.footnote)
							.foregroundStyle(.gray)
					}
				}
				Spacer()
				Text(value)
			}
		}
	}
}

#Preview {
    StatsView()
}

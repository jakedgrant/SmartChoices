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
	
	@ObservedObject var selectedUserManager: SelectedUserManager = .shared
    
    @State private var buttonPressCount = 0
	
	private var rewardCountDescription: String {
		if let user = selectedUserManager.selectedUser,
		   let rewards = user.rewards {
			
			return rewards.count.description
		} else {
			
			return rewards.count.description
		}
	}
	
	private var logCountDescription: String {
		if let user = selectedUserManager.selectedUser,
		   let logs = user.logs {
			
			return logs.count.description
		} else {
			
			return logs.count.description
		}
	}
	
	private var oddsDescription: String {
		if let user = selectedUserManager.selectedUser {
			return user.odds.description
		} else {
			return odds.description
		}
	}
	
	private var lossesDescription: String {
		if let user = selectedUserManager.selectedUser {
			return user.losses.description
		} else {
			return losses.description
		}
	}
	
    var body: some View {
        
		Group {
			StatLine(text: "Available rewards:", value: rewardCountDescription)
			
			StatLine(text: "Times rewarded:", value: logCountDescription)
			
			Button {
				if let user = selectedUserManager.selectedUser {
					Roll.resetOdds(for: user)
				} else {
					Roll.resetOdds()
				}
                buttonPressCount += 1
			} label: {
				StatLine(text: "Current odds:", value: oddsDescription, subtitle: "tap to reset")
			}
			.buttonStyle(.plain)
            .sensoryFeedback(.decrease, trigger: buttonPressCount)
			
			StatLine(text: "Current losses:", value: lossesDescription)
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

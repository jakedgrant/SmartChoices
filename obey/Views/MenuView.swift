//
//  MenuView.swift
//  obey
//
//  Created by Jake Grant on 8/26/24.
//

import SwiftUI

struct MenuView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@Binding var isShowingManageRewards: Bool
	
    var body: some View {
		Menu {
			Button {
				Roll.resetOdds()
			}label: {
				Label("Odds are 1 in \(odds)", systemImage: "arrow.counterclockwise.circle")
			}
			.accessibilityHint("Tap to reset odds")
			
			Text("Losses at \(losses)")
			
			Divider()
			
			Button {
				isShowingManageRewards = true
			} label: {
				Label("Manage rewards", systemImage: "list.star")
			}
		} label: {
			Image(systemName: "gear")
		}
    }
}

#Preview {
	MenuView(isShowingManageRewards: .constant(false))
}

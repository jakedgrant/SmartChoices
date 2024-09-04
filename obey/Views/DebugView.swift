//
//  DebugView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct DebugView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@State private var isShowingSettings = false
	
    var body: some View {
		VStack(spacing: 12) {
			
			ViewThatFits {
				HStack(spacing: 12) {
					Text("Odds are 1 in \(odds)")
					Button("Reset Odds") {
						Roll.resetOdds()
					}
				}
				
				VStack {
					Text("Odds are 1 in \(odds)")
					Button("Reset Odds") {
						Roll.resetOdds()
					}
				}
			}
			
			HStack {
				Text("Losses at \(losses)")
			}
			
#if os(iOS)
			Button("Manage rewards") {
				isShowingSettings = true
			}
			.sheet(isPresented: $isShowingSettings) {
				ManageRewardsView()
			}
#endif
		}
    }
}

#Preview {
    DebugView()
}

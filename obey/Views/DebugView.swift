//
//  DebugView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct DebugView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Roll.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Roll.suiteName)) var losses: Int = 0
	
    var body: some View {
		VStack(spacing: 12) {
			
			ViewThatFits {
				HStack(spacing: 12) {
					Text("Odds are 1 in \(odds)")
					Button("Reset Odds") {
						odds = Constants.startingOdds
					}
				}
				
				VStack {
					Text("Odds are 1 in \(odds)")
					Button("Reset Odds") {
						odds = Constants.startingOdds
					}
				}
			}
			
			HStack {
				Text("Losses at \(losses)")
			}
		}
    }
}

#Preview {
    DebugView()
}

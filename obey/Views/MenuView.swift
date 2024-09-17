//
//  MenuView.swift
//  obey
//
//  Created by Jake Grant on 8/26/24.
//

import SwiftUI
import RevenueCat

struct MenuView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@Binding var isShowingSettings: Bool
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	
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
				isShowingSettings = true
			} label: {
				Label("Settings", systemImage: "gear")
			}
			
		} label: {
			MenuImageView()
		}
    }
}

struct MenuImageView: View {
	
	var body: some View {
		
		Image(systemName: "list.bullet")
			.foregroundStyle(Color.white)
			.bold()
			.fontDesign(.rounded)
			.padding()
			.background(SCButtonBackground())
			.overlay(
				Circle()
					.stroke(.black.opacity(0.2), lineWidth: 8.0)
			)
			.clipShape(Circle())
	}
}

#Preview {
	MenuView(isShowingSettings: .constant(false))
}

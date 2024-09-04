//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI
import SwiftData
import RevenueCat

struct ContentView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@State private var isPresenting = false
	@State private var isShowingRewards = false
	@State private var isShowingSettings = false
	
	@State private var startPoint = -1
	@State private var endPoint = 2
	
	let colors: [Color] = [.red, .orange, .yellow, .green]
	
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
					
					Button("Smart Choice", action: roll)
						.buttonStyle(SCCircleButtonStyle(padding: 80))
						.font(.title2)
					
						.alert(
							Alert.unlucky.title,
							isPresented: $isPresenting,
							presenting: Alert.unlucky
						) { state in
							
							Button("Reward Anyway") {
								isShowingRewards = true
							}
							Button(state.cta, role: .cancel) { }
						} message: { state in
							Text(state.subtitle)
						}
					
						.sheet(isPresented: $isShowingRewards) {
							RewardListView()
						}
					
						.sensoryFeedback(.success, trigger: isShowingRewards) { _, new in
							new == true
						}
				}
			}
			
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					MenuView(isShowingSettings: $isShowingSettings)
				}
			}
			
			.sheet(isPresented: $isShowingSettings) {
				SettingsView()
			}
			
			.task {
				await populateRewards()
			}
		}
    }

	private func roll() {
		let result = Roll.perform()
		isPresenting = !result
		isShowingRewards = result
	}
	
	private func populateRewards() async {
		
		do {
			let db = try RewardDatabase()
			let rewards = db.allRewards()
			
			if rewards.isEmpty {
				db.createDefault()
			}
		} catch {
			print("Error when trying to populate rewards \(error.localizedDescription)")
		}
	}
}

#Preview {
	ContentView()
}

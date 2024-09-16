//
//  ContentView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@Environment(\.modelContext) var modelContext
	@Query var rewards: [SDReward]
	
	@State private var isShowingRewards = false
	@State private var isAlerting = false
	@State private var isDebug = false
	
	@State private var rotation = 0.0
	
    var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				
				Button("Smart Choice", action: roll)
					.bold()
					.fontDesign(.rounded)
					.focusable()
					.digitalCrownRotation($rotation) { value in
						withAnimation {
							isDebug = value.offset > 50.0
						}
					}
				
				Spacer()
				
				if isDebug {
					DebugView()
				}
			}
			
			.alert(
				Alert.unlucky.title,
				isPresented: $isAlerting,
				presenting: Alert.unlucky) { state in
					
					Button(state.cta) {	}
				} message: { state in
					Text(state.subtitle)
				}
			
			.sheet(isPresented: $isShowingRewards) {
				RewardListView(modelContext: self.modelContext)
			}
			
			.containerBackground(
				isAlerting
				? Color.accentColor.gradient
				: Color.gray.gradient,
				for: .navigation
			)
			
			.scenePadding()
			
			.task {
				await populateRewards()
			}
		}
    }
	
	private func roll() {
		let result = Int.random(in: 1...odds)
		if result == 1 {
			
			decreaseOdds()
			losses = 0
			isShowingRewards = true
		} else if losses >= odds {
			
			losses = 0
			isShowingRewards = true
		} else {
			
			losses += 1
			isAlerting = true
		}
	}
	
	private func decreaseOdds() {
		if odds < Constants.maxOdds {
			odds += 1
		}
	}
	
	private func populateRewards() async {
		
		if rewards.isEmpty {
			
			Reward.allCases.forEach {
				let newReward = SDReward(name: $0.description, systemImage: $0.image)
				modelContext.insert(newReward)
			}
			
			do {
				try modelContext.save()
			} catch {
				print("error saving log - \(error.localizedDescription)")
			}
		}
	}
}

#Preview {
    ContentView()
}

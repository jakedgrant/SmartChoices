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
	@Environment(\.themeColor) private var themeColor
	
	@State private var isShowingRewards = false
	@State private var isAlerting = false

        var body: some View {
                NavigationStack {
                        TabView {
                                rollView
                                        .tabItem { Label("Roll", systemImage: "die.face.5") }

                                SwitchUserView()
                                        .tabItem { Label("Users", systemImage: "person.crop.circle") }

                                StatsView()
                                        .tabItem { Label("Stats", systemImage: "chart.bar") }
                        }
                        .tabViewStyle(.verticalPage)
			
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
					? themeColor.gradient
					: Color.gray.gradient,
					for: .navigation
				)
			
				.scenePadding()
			
                                .task {
                                        await populateRewards()
                                }
                }
        }

        private var rollView: some View {
                VStack {
                        Spacer()

                        Button("Smart Choice", action: roll)
                                .bold()
                                .fontDesign(.rounded)
                                .focusable()

                        Spacer()
                }
                .containerBackground(themeColor.gradient, for: .tabView)
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

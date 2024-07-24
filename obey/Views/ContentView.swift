//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
	@AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
	
	@State private var isPresenting = false
	@State private var isShowingRewards = false
	
	@State private var startPoint = -1
	@State private var endPoint = 2
	
	let colors: [Color] = [.red, .orange, .yellow, .green]
	
	@State private var isDebug = false
	
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
					Spacer()
					
					Button("Smart Choice", action: roll)
						.buttonStyle(SCButtonStyle())
					
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
					
					Spacer()
					
					if isDebug {
						DebugView()
					}
				}
			}
			
			.onShake {
				withAnimation {
					isDebug.toggle()
				}
			}
			
			.fontWidth(.expanded)
		}
    }

	private func roll() {
		let result = Int.random(in: 1...odds)
		if result == 1 {
			withAnimation {
				startPoint = -1
				endPoint = 1
			}
			
			losses = 0
			decreaseOdds()
			isShowingRewards = true
		} else if losses >= odds {
			withAnimation {
				startPoint = -1
				endPoint = 1
			}
			
			losses = 0
			isShowingRewards = true
		} else {
			withAnimation {
				startPoint = 0
				endPoint = 3
			}
			
			losses += 1
			isPresenting = true
		}
	}
	
	private func decreaseOdds() {
		if odds < Constants.maxOdds {
			odds += 1
		}
	}
}

#Preview {
	ContentView()
}

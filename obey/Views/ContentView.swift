//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@AppStorage("odds", store: UserDefaults(suiteName: Roll.suiteName)) var odds: Int = Constants.startingOdds
	@State private var isPresenting = false
	@State private var isShowingRewards = false
	@State private var alertState = AlertState.empty
	
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
							alertState.title,
							isPresented: $isPresenting,
							presenting: alertState
						) { state in
							Button(state.cta) {
								alertState = .empty
							}
						} message: { state in
							Text(state.subtitle)
						}
					
						.sheet(isPresented: $isShowingRewards) {
							RewardListView()
						}
					
						.sensoryFeedback(.success, trigger: alertState) { _, new in
							new == .winner
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
			alertState = .winner
			isShowingRewards = true
			decreaseOdds()
		} else {
			withAnimation {
				startPoint = 0
				endPoint = 3
			}
			alertState = .unlucky
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

/*
 
 starting odds: 1 in 5
 ending odds: 1 in 15
 
 */

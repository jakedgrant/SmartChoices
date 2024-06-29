//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@AppStorage("odds") var odds: Int = Constants.startingOdds
	@State private var isPresenting = false
	@State private var isShowingRewards = false
	@State private var alertState = AlertState.empty
	
	@State private var isDebug = false
	
    var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				
				Button("Smart Choice", action: { })
					.simultaneousGesture(
						LongPressGesture(minimumDuration: 0.4)
							.onEnded { value in
								roll()
							}
					)
					.bold()
				
					.buttonStyle(GrowingButton())
				
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
			alertState = .winner
			isShowingRewards = true
			decreaseOdds()
		} else {
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

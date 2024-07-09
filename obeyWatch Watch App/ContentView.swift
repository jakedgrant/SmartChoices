//
//  ContentView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import SwiftUI

struct ContentView: View {
	@AppStorage("odds") var odds: Int = Constants.startingOdds
	@State private var isShowingRewards = false
	@State private var isAlerting = false
	@State private var alertState = AlertState.empty
	@State private var isDebug = false
	
	@State private var rotation = 0.0
	
    var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				
				Button("Smart Choice", action: roll)
					.bold()
					.fontWidth(.expanded)
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
				alertState.title,
				isPresented: $isAlerting,
				presenting: alertState) { state in
					Button(state.cta) {
						withAnimation {
							alertState = .empty
						}
					}
				} message: { state in
					Text(state.subtitle)
				}
			
			.sheet(isPresented: $isShowingRewards) {
				RewardListView()
			}
			
			.containerBackground(
				alertState == .empty
				? Color.gray.gradient
				: Color.pink.gradient,
				for: .navigation
			)
			
			.scenePadding()
		}
    }
	
	private func roll() {
		let result = Int.random(in: 1...odds)
		if result == 1 {
			
			decreaseOdds()
			isShowingRewards = true
		} else {
			
			isAlerting = true
			withAnimation {
				alertState = .unlucky
			}
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

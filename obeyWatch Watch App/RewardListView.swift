//
//  RewardListView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/8/24.
//

import SwiftUI

struct RewardListView: View {
	@State var viewModel = ViewModel()
	
	var body: some View {
		NavigationStack {
			List {
				Section("Pick a reward") {
					ForEach(viewModel.topRewards) { reward in
						
						Label(reward.name, systemImage: reward.systemImage)
							.foregroundStyle(Color.accentColor)
							.symbolRenderingMode(.hierarchical)
					}
				}
		
				Section("All other rewards") {
					
					ForEach(viewModel.otherRewards) { reward in
						
						Label(reward.name, systemImage: reward.systemImage)
							.foregroundStyle(Color.accentColor)
							.symbolRenderingMode(.hierarchical)
					}
				}
			}
			.listStyle(.carousel)
			.containerBackground(Color.yellow.gradient, for: .navigation)
		}
	}
}

extension RewardListView {
	@Observable
	final class ViewModel {
		var topRewards: ArraySlice<SDReward> = []
		var otherRewards: ArraySlice<SDReward> = []
		
		init() {
			
			do {
				let db = try RewardDatabase()
				let rewards = db.allRewards().shuffled()
				
				topRewards = rewards.prefix(3)
				otherRewards = rewards.dropFirst(3)
				
			} catch {
				print("error when fetching rewards for display \(error.localizedDescription)")
			}
		}
	}
}

#Preview {
	RewardListView()
}

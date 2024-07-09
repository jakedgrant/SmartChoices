//
//  RewardListView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/8/24.
//

import SwiftUI

struct RewardListView: View {
	let rewards = Reward.allCases.shuffled()
	
	var body: some View {
		NavigationStack {
			List {
				Section("Pick a reward") {
					ForEach(rewards.prefix(3)) { reward in
						
						Label(reward.description, systemImage: reward.image)
							.foregroundStyle(Color.accentColor)
							.symbolRenderingMode(.hierarchical)
					}
				}
		
				Section("All other rewards") {
					
					ForEach(rewards.dropFirst(3)) { reward in
						
						Label(reward.description, systemImage: reward.image)
							.foregroundStyle(Color.accentColor)
							.symbolRenderingMode(.hierarchical)
					}
				}
			}
			.listStyle(.carousel)
			.containerBackground(Color.accentColor.gradient, for: .navigation)
		}
	}
}

#Preview {
	RewardListView()
}

//
//  RewardListView.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import ConfettiSwiftUI
import SwiftUI

struct RewardListView: View {
	@Environment(\.dismiss) var dismiss
	
	@State private var counter = 1
	
    var body: some View {
		NavigationStack {
				
			List {
				ForEach(Reward.allCases) { reward in
					
					Label(reward.description, systemImage: reward.image)
						.symbolRenderingMode(.hierarchical)
						.padding(10)
				}
			}
			
			.confettiCannon(
				counter: $counter,
				num: 100,
				rainHeight: 700,
				radius: 400
			)
			
			.onAppear {
				counter += 1
			}
			
			.navigationBarTitleDisplayMode(.inline)
			
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Rewards")
				}
				
				ToolbarItem {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.symbolRenderingMode(.hierarchical)
					}
				}
			}
		}
		.fontWidth(.expanded)
    }
}

#Preview {
    RewardListView()
}

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
	@State private var showAllRewards = false
	
	let rewards = Reward.allCases.shuffled()
	
    var body: some View {
		
		
		NavigationStack {
			ZStack {
				List {
					Section {
						ForEach(rewards.prefix(3)) { reward in
							
							Label(reward.description, systemImage: reward.image)
								.symbolRenderingMode(.hierarchical)
								.padding(20)
								.background(Color(uiColor: UIColor.tertiarySystemBackground))
								.clipShape(
									RoundedRectangle(cornerRadius: 25)
								)
								.listRowSeparator(.hidden)
								.listRowBackground(Color.clear)
						}
					}
					
					if showAllRewards {
						Section {
							
							ForEach(rewards.dropFirst(3)) { reward in
								
								Label(reward.description, systemImage: reward.image)
									.symbolRenderingMode(.hierarchical)
									.padding(10)
							}
						}
					}
				}
				
				VStack {
					Spacer()
					Button {
						withAnimation {
							showAllRewards.toggle()
						}
					} label: {
						if showAllRewards {
							Image(systemName: "xmark.circle.fill")
								.scaleEffect(2)
								.symbolRenderingMode(.hierarchical)
						} else {
							Text("more rewards")
								.shadow(radius: showAllRewards ? 5: 0)
						}
					}
					.background(Color.clear)
					.frame(maxWidth: .infinity)
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
			
			.interactiveDismissDisabled()
			
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

struct TopRewards<T>: View where T: Displayable{
	
	var items: ArraySlice<T>
	
	var body: some View {
		ForEach(items) { item in
			
			Label(item.description, systemImage: item.image)
				.symbolRenderingMode(.hierarchical)
				.padding(20)
				.background(Color(uiColor: UIColor.tertiarySystemBackground))
				.clipShape(
					RoundedRectangle(cornerRadius: 25)
				)
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
		}
	}
}

struct HorizontalRewardList<T>: View where T: Displayable {
	var items: ArraySlice<T>
	var showDescription: Bool
	
	var body: some View {
		HStack {
			ForEach(items) { item in
				VStack {
					Image(systemName: item.image)
						.symbolRenderingMode(.hierarchical)
					if showDescription {
						Text(item.description)
					}
				}
				.padding(20)
				.background(Color(uiColor: UIColor.tertiarySystemBackground))
				 .clipShape(
					 RoundedRectangle(cornerRadius: 25)
				 )
			}
		}
	}
}

#Preview {
    RewardListView()
}

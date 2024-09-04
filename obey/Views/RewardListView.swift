//
//  RewardListView.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import ConfettiSwiftUI
import SwiftData
import SwiftUI

struct RewardListView: View {
	@Environment(\.dismiss) var dismiss
	@State var viewModel = ViewModel()
	
	var body: some View {
		
		NavigationStack {
			List {
				Section {
					ForEach(viewModel.topRewards) { reward in
						
						Label(reward.name, systemImage: reward.systemImage)
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
				
				if viewModel.showAllRewards {
					Section {
						
						ForEach(viewModel.otherRewards) { reward in
							
							Label(reward.name, systemImage: reward.systemImage)
								.symbolRenderingMode(.hierarchical)
								.padding(10)
						}
					}
				}
			}
			.navigationTitle(Text("Rewards"))
			
			.safeAreaInset(edge: .bottom) {
				Button {
					withAnimation {
						viewModel.showAllRewards.toggle()
					}
				} label: {
					
					Label(viewModel.showAllRewards ? "hide" : "show more rewards",
						  systemImage: viewModel.showAllRewards ? "xmark.circle.fill" : "plus.circle.fill")
				}
				.buttonStyle(SCButtonStyle())
				.background(Color.clear)
				.frame(maxWidth: .infinity)
			}
			
			.confettiCannon(
				counter: $viewModel.counter,
				num: 100,
				rainHeight: 700,
				radius: 400
			)
			
			.onAppear {
				viewModel.counter += 1
			}
			
			.navigationBarTitleDisplayMode(.inline)
			
			.interactiveDismissDisabled()
			
			.toolbar {
				ToolbarItem {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
							.imageScale(.small)
					}
					.buttonStyle(SCCircleButtonStyle(padding: 12))
				}
			}
		}
		.fontDesign(.rounded)
	}
}

extension RewardListView {
	
	@Observable
	final class ViewModel {
		var counter = 1
		var showAllRewards = false
		var topRewards: ArraySlice<SDReward> = []
		var otherRewards: ArraySlice<SDReward> = []
		
		init() {
			
			do {
				let db = try RewardDatabase()
				let rewards = db.activeRewards().shuffled()
				
				topRewards = rewards.prefix(3)
				otherRewards = rewards.dropFirst(3)
				
			} catch {
				print("error when fetching rewards for display \(error.localizedDescription)")
			}
		}
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

#Preview {
	RewardListView()
}

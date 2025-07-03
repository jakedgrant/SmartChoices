//
//  RewardListView.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import ConfettiSwiftUI
import SwiftData
import SwiftUI
import TipKit

struct RewardListView: View {
	@Environment(\.dismiss) var dismiss
	
	var modelContext: ModelContext
	
	@State private var topRewards: [SDReward]
	@State private var otherRewards: [SDReward]
	@State private var showAllRewards = false
	@State private var counter = 1
	
	let logRewardTip = LogRewardTip()
	
	init(modelContext: ModelContext) {
		
		self.modelContext = modelContext
		
		let fetchDescriptor = FetchDescriptor<SDReward>(predicate: #Predicate<SDReward> { $0.isActive }, sortBy: [])
		
		do {
			var rewards = try modelContext.fetch(fetchDescriptor).shuffled()
			
			if let selectedUser = SelectedUserManager.shared.selectedUser {
				rewards = rewards.filter { reward in
					reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
				}
			}
			
			topRewards = Array(rewards.prefix(3))
			otherRewards = Array(rewards.dropFirst(3))
			
		} catch {
			print("uh oh: \(error.localizedDescription)")
			self.topRewards = []
			self.otherRewards = []
		}
	}
	
	var body: some View {
		
		NavigationStack {
			List {
				Section {
					ForEach(topRewards) { reward in
						
						Button {
							log(reward)
						} label: {
							Label(reward.name, systemImage: reward.systemImage)
						}
						.buttonStyle(SCButtonStyle())
						.listRowSeparator(.hidden)
						.listRowBackground(Color.clear)
						.listRowInsets(.init(top: -8, leading: 0, bottom: -8, trailing: 0))
					}
				}
				
				TipView(logRewardTip)
                    .tipBackground(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
				
				if showAllRewards {
					Section {
						
						ForEach(otherRewards) { reward in
							
							Button {
								log(reward)
							} label: {
								Label(reward.name, systemImage: reward.systemImage)
									.symbolRenderingMode(.hierarchical)
									.padding(10)
							}
						}
					}
				}
			}
            .navigationTitle(Text(SDReward.sectionName))
			
			.safeAreaInset(edge: .bottom) {
				if !otherRewards.isEmpty {
					ShowHideButton(isShowing: $showAllRewards)
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
				ToolbarItem {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
							.imageScale(.small)
					}
					.buttonStyle(SCCircleButtonStyle(padding: 12))
					.padding(.trailing, -12)
				}
			}
		}
		.fontDesign(.rounded)
	}
	
	private struct ShowHideButton: View {
		
		@Binding var isShowing: Bool
		
		var body: some View {
			Button {
				withAnimation {
					isShowing.toggle()
				}
			} label: {
				
				Label(isShowing ? "hide" : "show more rewards",
					  systemImage: isShowing ? "xmark.circle.fill" : "plus.circle.fill")
			}
			.buttonStyle(SCButtonStyle())
			.background(Color.clear)
			.frame(maxWidth: .infinity)
		}
	}
	
	private func log(_ reward: SDReward) {
		
		let selectedUser = SelectedUserManager.shared.selectedUser
		let log = SDLog(
			odds: selectedUser?.odds ?? LastStat.shared.odds,
			losses: selectedUser?.losses ?? LastStat.shared.losses,
			increasedOdds: LastStat.shared.increasedOdds
		)
        log.reward = reward
        log.user = selectedUser
		
		modelContext.insert(log)
		
		do {
			try modelContext.save()
		} catch {
			print("error saving log - \(error.localizedDescription)")
		}
		
		dismiss()
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

//#Preview {
//	let config = ModelConfiguration(isStoredInMemoryOnly: true)
//	let container = try! ModelContainer(for: SDReward.self, configurations: config)
//	
//	for r in Reward.allCases {
//		let n = SDReward(name: r.description, systemImage: r.image)
//		container.mainContext.insert(n)
//	}
//	
//	return RewardListView(stats: RollStat(odds: 1, losses: 0, increasedOdds: true))
//		.modelContainer(container)
//}

//
//  ManageRewardsView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import RevenueCatUI
import SwiftData
import SwiftUI
import TipKit

struct ManageRewardsView: View {
	
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var nav: NavigationStateManager
	@Environment(\.themeColor) private var themeColor
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	
	@Query(sort: \SDReward.name) private var rewards: [SDReward]
	@Query(sort: \SDUser.name) private var users: [SDUser]
        @State private var selectedUser: SDUser? = nil
        @State private var newRewardName = ""
        @State private var isShowingAddFlow = false
	
	let swipeActionsTip = ManageRewardsSwipeActionsTip()
	
	private var filteredRewards: [SDReward] {
		guard let selectedUser else { return rewards }
		return rewards.filter { reward in
			reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
		}
	}
	
	var body: some View {
        
        if let name = selectedUser?.name {
            Text("Showing rewards for \(name)")
                .transition(.opacity)
                .italic()
                .foregroundStyle(.secondary)
        }
		
		List {
			
			Section {
				TipView(swipeActionsTip)
                    .tipBackground(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
			}
			
			ForEach(filteredRewards) { reward in
				
				NavigationLink(value: reward, label: {
					
					Label(reward.name, systemImage: reward.systemImage)
						.symbolRenderingMode(.hierarchical)
						.padding(10)
						.opacity(reward.isActive ? 1 : 0.4)
				})
				.swipeActions(edge: .leading, allowsFullSwipe: true) {
					
					if userViewModel.unlockActive {
						Button { reward.isActive.toggle() } label: {
							if reward.isActive {
								Label("Deactivate", systemImage: "circle.slash")
							} else {
								Label("Activate", systemImage: "circle")
							}
						}
						.tint(themeColor)
					} else {
						EmptyView()
					}
				}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Button(role: .destructive) {
						deleteReward(reward)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
				
			}
		}
		.animation(.default, value: selectedUser)
		.navigationTitle(Text("Manage Rewards"))
        .navigationBarTitleDisplayMode(.inline)
		
		.safeAreaInset(edge: .bottom) {
			
			Button(action: addReward) {
				Label(allowsAddReward() ? "Add new reward" : "Unlock to add more rewards", systemImage: allowsAddReward() ? "plus" : "lock")
			}
			.buttonStyle(SCButtonStyle())
			.frame(maxWidth: .infinity)
			.animation(.default, value: rewards.count)
		}
                .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Filter for child", selection: $selectedUser) {
                        Text("All").tag(nil as SDUser?)
                        ForEach(users) { user in
                            Text(user.name).tag(user as SDUser?)
                        }
                    }
                } label: {
                    Image(systemName: selectedUser == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
                        }
                }
                .sheet(isPresented: $isShowingAddFlow) { AddRewardView() }
                .fontDesign(.rounded)
        }
	
	private func imageName(for userId: SDUser.ID?) -> String {
		return userId == selectedUser?.id ? "checkmark" : ""
	}
}

extension ManageRewardsView {
	
	private func deleteReward(_ reward: SDReward) {
		modelContext.delete(reward)
	}
	
        private func addReward() {

                guard allowsAddReward() else {
                        nav.path.append(Route.paywall)
                        return
                }

                isShowingAddFlow = true
        }
	
	private func allowsAddReward() -> Bool {
		
		if userViewModel.unlockActive {
			return true
		}
		
		return rewards.count <= 5
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDReward.self, SDUser.self, configurations: config)
	
	for r in Reward.allCases {
		let n = SDReward(name: r.description, systemImage: r.image)
		container.mainContext.insert(n)
	}
	
	let u1 = SDUser(name: "Preview 1")
	let u2 = SDUser(name: "Preview 2")
	container.mainContext.insert(u1)
	container.mainContext.insert(u2)
	
        return ManageRewardsView()
                .modelContainer(container)
                .environmentObject(NavigationStateManager())
}

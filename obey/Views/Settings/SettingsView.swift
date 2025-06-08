//
//  SettingsView.swift
//  obey
//
//  Created by Jake Grant on 9/3/24.
//

import RevenueCatUI
import SwiftUI
import StoreKit

enum Route {
	case about
	case paywall
	case rewardManage
	case rewardHistory
	case userManage
}

class NavigationStateManager: ObservableObject {
	
	@Published var path = NavigationPath()
}

struct SettingsView: View {
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	
	@State private var isShowingPaywall = false
	@State private var isShowingManageSubscription = false
	@State private var isShowingRecap = false
	
	@StateObject var nav = NavigationStateManager()
	
	var body: some View {
		NavigationStack(path: $nav.path) {
			Form {
				
				Section {
					Button {
						if userViewModel.isSubscriber {
							isShowingManageSubscription = true
						} else if !userViewModel.unlockActive {
							isShowingPaywall = true
						}
					} label: {
						Label(userViewModel.unlockActive ? "Manage subscription" : "Subscribe now!",
							  systemImage: userViewModel.unlockActive ? "dollarsign.arrow.circlepath" : "hands.and.sparkles.fill")
					}
				}
				
				Section("Rewards") {
					NavigationLink(value: Route.rewardManage) {
						Label("Manage rewards", systemImage: "list.star")
					}
					
					NavigationLink(value: Route.rewardHistory) {
						Label("Reward history", systemImage: userViewModel.unlockActive ? "scroll" : "lock" )
					}
				}
				
				Section("Users") {
					NavigationLink(value: Route.userManage) {
						Label("Manage users", systemImage: "person.2")
					}
				}
				
				Section {
					NavigationLink(value: Route.about) {
						Label("About", systemImage: "i.circle")
					}
					
					Button {
						isShowingRecap = true
					} label: {
						Label("What's new?", systemImage: "party.popper")
					}
				}
				
				Section("Stats") {
					StatsView()
				}
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.large)
			
			.navigationDestination(for: Route.self) { routeValue in
				switch routeValue {
				case .about:
					AboutView()
				case .paywall:
					PaywallView()
				case .rewardManage:
					ManageRewardsView()
				case .rewardHistory:
					if userViewModel.unlockActive {
						LogListView()
					} else {
						PaywallView()
					}
				case .userManage:
					ManageUsersView()
				}
			}
			.navigationDestination(for: SDReward.self) { AddEditRewardView(reward: $0) }
			.navigationDestination(for: SDUser.self) { AddEditUserView(user: $0) }
			
			.sheet(isPresented: $isShowingPaywall, content: { PaywallView() })
			
			.sheet(isPresented: $isShowingRecap, content: { ObeyRecap(showing: .update) })
			
			.manageSubscriptionsSheet(isPresented: $isShowingManageSubscription)
			
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
		.environmentObject(nav)
	}
}

#Preview {
	SettingsView()
}

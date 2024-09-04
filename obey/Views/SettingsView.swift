//
//  SettingsView.swift
//  obey
//
//  Created by Jake Grant on 9/3/24.
//

import RevenueCatUI
import SwiftUI
import StoreKit

struct SettingsView: View {
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	
	@State private var isShowingPaywall = false
	@State private var isShowingManageSubscription = false
	
    var body: some View {
		NavigationStack {
			Form {
				
				Section {
					Button { 
						if userViewModel.isSubscriber {
							isShowingManageSubscription = true
						} else if !userViewModel.unlockActive {
							isShowingPaywall = true
						}
					} label: {
						Text(userViewModel.unlockActive ? "Manage subscription" : "Subscribe now!")
					}
				}
				
				Section("Rewards") {
					NavigationLink(destination: ManageRewardsView()) {
						Label("Manage rewards", systemImage: "list.star")
					}
					
					NavigationLink(destination: Text("Unimplemented")) {
						Label("Reward history", systemImage: userViewModel.unlockActive ? "scroll" : "lock" )
					}
				}
				
				Section {
					NavigationLink(destination: Text("Unimplemented")) {
						Label("About", systemImage: "i.circle")
					}
				}
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.large)
			
			.sheet(isPresented: $isShowingPaywall, content: { PaywallView() })
			
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
				}
			}
		}
    }
}

#Preview {
    SettingsView()
}

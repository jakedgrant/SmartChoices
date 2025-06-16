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
    @Environment(\.themeColor) private var themeColor

    @Environment(\.themeColor) private var themeColor

    @ObservedObject private var userViewModel = UserViewModel.shared
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared

    @AppStorage(Constants.rewardModeKey, store: UserDefaults(suiteName: Constants.suiteName))
    private var rewardModeRawValue: String = RewardMode.surprise.rawValue

    private var rewardMode: RewardMode {
        RewardMode(rawValue: rewardModeRawValue) ?? .surprise
    }

    @State private var isShowingPaywall = false
    @State private var isShowingManageSubscription = false
    @State private var isShowingRecap = false

    @StateObject var nav = NavigationStateManager()

    var body: some View {
        NavigationStack(path: $nav.path) {
            Form {
                
                if !userViewModel.unlockActive {
                    Button {
                        isShowingPaywall = true
                    } label: {
                        Label(
                            "Subscribe now to unlock all features and new ways to reward good behavior!",
                            systemImage: "hands.and.sparkles.fill"
                        )
                    }
                    .foregroundStyle(.white)
                    .bold()
                    .listRowBackground(
                        AttentionMeshGradient(.mint, .black.opacity(0.25))
                            .background(.mint)
                    )
                }

                Section {
                    Picker(selection: $rewardModeRawValue) {
                        ForEach(RewardMode.allCases) { mode in
                            Label(mode.title, systemImage: mode.systemImage)
                                .tag(mode.rawValue)
                        }
                    } label: {
                        Label("Reward mode", systemImage: "wand.and.stars")
                    }
                } header: {
                    Text("Rewards")
                } footer: {
                    Text(rewardMode.explanation)
                }

                Section {
                    NavigationLink(value: Route.userManage) {
                        Label("Manage children", systemImage: "person.2")
                    }

                    NavigationLink(value: Route.rewardManage) {
                        Label("Manage rewards", systemImage: "list.star")
                    }

                    NavigationLink(value: Route.rewardHistory) {
                        Label("Reward history", systemImage: userViewModel.unlockActive ? "scroll" : "lock")
                    }
                }
                
                Section("Stats for \(selectedUserManager.selectedUser?.name ?? "All")") {
                    StatsView()
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
                    
                    if userViewModel.unlockActive, userViewModel.isSubscriber {
                        Button {
                            isShowingManageSubscription = true
                        } label: {
                            Label(
                                "Manage subscription",
                                systemImage: "dollarsign.arrow.circlepath"
                            )
                        }
                    }
                }
                
                Section {
                    if userViewModel.unlockActive {
                        Text("All features unlocked - thanks for supporting Smart Choices!")
                            .bold()
                            .foregroundStyle(.white)
                            .listRowBackground(
                                AttentionMeshGradient(themeColor, .black.opacity(0.25))
                                    .background(themeColor)
                            )
                    }
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
                case .userManage:
                    ManageUsersView()
                case .rewardHistory:
                    if userViewModel.unlockActive {
                        LogListView()
                    } else {
                        PaywallView()
                    }
                }
            }
            .navigationDestination(for: SDReward.self) { AddEditRewardView(reward: $0) }
            .navigationDestination(for: SDUser.self) { AddEditUserView(user: $0) }

            .sheet(isPresented: $isShowingPaywall, content: { PaywallView() })

            .sheet(isPresented: $isShowingRecap, content: { ObeyRecap(showing: .update) })

            .manageSubscriptionsSheet(isPresented: $isShowingManageSubscription)

            .toolbar {
                ToolbarItem {
                    CloseButton { dismiss() }
                }
            }
        }
        .tint(themeColor)
        .environmentObject(nav)
    }
}

#Preview {
    SettingsView()
}

//
//  ContentTabView.swift
//  obey
//
//  Created by Jake Grant on 7/3/25.
//

import SwiftData
import SwiftUI

struct ContentTabView: View {
    
    @Environment(\.themeColor) var themeColor
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    @State private var isSwitchingUser = false
    
    var body: some View {
        TabView {
            
            RollView(selectedUser: selectedUserManager.selectedUser)
                .containerBackground(themeColor.gradient, for: .tabView)
            
            List {
                StatsView()
            }
            .navigationTitle("Stats for \(selectedUserManager.selectedUser?.name ?? "All")")
            .tint(themeColor)
        }
        .tabViewStyle(.verticalPage)
        .sheet(isPresented: $isSwitchingUser) {
            SwitchUserView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isSwitchingUser = true
                } label: {
                    Label("Switch Child", systemImage: "person.crop.circle")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

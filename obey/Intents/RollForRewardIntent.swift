//
//  RollForRewardIntent.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation
import SwiftUI

struct RollForRewardIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Roll for making a Smart Choice reward."
    static var description = IntentDescription("Makes a roll for making a Smart Choice. If the roll is successfull, presents a list of rewards to choose from.")
    
    @Parameter(title: "User")
    var user: UserEntity?
    
    func perform() async throws -> some IntentResult & ReturnsValue<[RewardEntity]> & ProvidesDialog & ShowsSnippetView {
        
        let chosenUser: SDUser?
        if let user { // parameter provided
            let db = try UserDatabase()
            chosenUser = db.users(with: [user.id]).first
        } else {
            chosenUser = SelectedUserManager.shared.selectedUser
        }
        
        let isWinner: Bool
        if let chosenUser {
            isWinner = Roll.perform(for: chosenUser)
        } else {
            isWinner = Roll.perform()
        }
        
        var rewards = [RewardEntity]()
        let dialogFull: LocalizedStringResource
        let dialogSupporting: LocalizedStringResource
        
        if isWinner {
            
            let db = try RewardDatabase()
            let list = chosenUser?.rewards?.filter { $0.isActive } ?? db.activeRewards()
            rewards = list.shuffled().prefix(3).map { RewardEntity(from:$0) }
            
            let lastReward = rewards.last?.description ?? "something else"
            let rewardsListString = rewards.prefix(2).map { $0.description }.joined(separator: ", ")
            if let chosenUser {
                dialogFull = "You win, \(chosenUser.name)!"
                dialogSupporting = "You can select one of these rewards: \(rewardsListString), or \(lastReward)."
            } else {
                dialogFull = "You win!"
                dialogSupporting = "You can select one of these rewards: \(rewardsListString), or \(lastReward)."
            }
        } else {
            
            if let chosenUser {
                dialogFull = "Maybe next time, \(chosenUser.name)"
                dialogSupporting = "You made a smart choice and might win a reward next time."
            } else {
                dialogFull = "Maybe next time"
                dialogSupporting = "You made a smart choice and might win a reward next time."
            }
        }
        
        let snippet = RewardSnippet(rewards: rewards, color: chosenUser?.swiftUIColor)
        
        let dialog = IntentDialog(
            full: dialogFull,
            supporting: dialogSupporting
        )
        
        return .result(value: rewards, dialog: dialog, view: snippet)
    }
    
    struct RewardSnippet: View {
        
        var rewards: [RewardEntity]
        var color: Color?
        
        var body: some View {
            if rewards.isEmpty {
                EmptyView()
            } else {
                HorizontalRewardList(items: rewards.prefix(3), showDescription: false)
                    .foregroundStyle(color ?? Color.teal)
                    .padding(.vertical, 4)
            }
        }
    }
}

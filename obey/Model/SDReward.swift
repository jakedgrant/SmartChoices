//
//  SDReward.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class SDReward: Identifiable {
    var id = UUID()
    var name: String = ""
    var systemImage: String = Constants.defaultImageName
    var isActive: Bool = true

    @Relationship(deleteRule: .nullify, inverse: \SDLog.reward)
    var logs: [SDLog]? = []

    @Relationship(deleteRule: .nullify, inverse: \SDUser.rewards)
    var users: [SDUser]? = []

    init(
        name: String = "",
        systemImage: String = Constants.defaultImageName,
        isActive: Bool = true,
        logs: [SDLog]? = [],
        users: [SDUser]? = []
    ) {
        self.name = name
        self.systemImage = systemImage
        self.isActive = isActive
        self.logs = logs
        self.users = users
    }
}

extension SDReward {

    var image: Image {
        Image(systemName: systemImage)
    }
}

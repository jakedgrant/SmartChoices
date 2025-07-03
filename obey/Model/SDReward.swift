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
    
    var users: [SDUser]? = []

    init(
        name: String = "",
        systemImage: String = Constants.defaultImageName,
        isActive: Bool = true,
    ) {
        self.name = name
        self.systemImage = systemImage
        self.isActive = isActive
    }
}

extension SDReward {

    var image: Image {
        Image(systemName: systemImage)
    }
}

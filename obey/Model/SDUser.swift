import Foundation
import SwiftData
import SwiftUI

@Model
final class SDUser: Identifiable {
    var id = UUID()
    var name: String = ""
    var color: CodableColor = CodableColor(.blue)
    var odds: Int = Constants.startingOdds
    var losses: Int = 0

    @Relationship(deleteRule: .nullify, inverse: \SDReward.users)
    var rewards: [SDReward]? = []

    @Relationship(deleteRule: .nullify, inverse: \SDLog.user)
    var logs: [SDLog]? = []

    init(
        name: String = "",
        color: CodableColor = CodableColor(.blue),
        odds: Int = Constants.startingOdds,
        losses: Int = 0,
        rewards: [SDReward]? = [],
        logs: [SDLog]? = []
    ) {
        self.name = name
        self.color = color
        self.odds = odds
        self.losses = losses
        self.rewards = rewards
        self.logs = logs
    }
}

extension SDUser {
    var swiftUIColor: Color { color.color }
}

extension SDUser: Hashable {
    static func == (lhs: SDUser, rhs: SDUser) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

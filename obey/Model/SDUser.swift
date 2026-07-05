import Foundation
import SwiftData
import SwiftUI

@Model
final class SDUser: Identifiable {
    var id = UUID()
    var name: String = ""
    var color: StandardColor = StandardColor.mint
    var odds: Int = Constants.startingOdds
    var losses: Int = 0
    /* Stars earned in star mode. The default value lets SwiftData
     lightweight-migrate stores that predate per-user balances. */
    var starBalance: Int = 0

    @Relationship(deleteRule: .nullify, inverse: \SDReward.users)
    var rewards: [SDReward]? = []

    @Relationship(deleteRule: .nullify, inverse: \SDLog.user)
    var logs: [SDLog]? = []

    init(
        name: String = "",
        color: StandardColor = .mint,
        odds: Int = Constants.startingOdds,
        losses: Int = 0,
        starBalance: Int = 0
    ) {
        self.name = name
        self.color = color
        self.odds = odds
        self.losses = losses
        self.starBalance = starBalance
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

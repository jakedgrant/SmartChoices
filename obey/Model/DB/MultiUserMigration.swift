import Foundation
import SwiftData
import SwiftUI

@Model
final class SDRewardV1 {
    var id = UUID()
    var name: String = ""
    var systemImage: String = Constants.defaultImageName
    var isActive: Bool = true

    @Relationship(deleteRule: .nullify, inverse: \SDLogV1.reward)
    var logs: [SDLogV1]? = []

    init(name: String = "", systemImage: String = Constants.defaultImageName, isActive: Bool = true, logs: [SDLogV1]? = []) {
        self.name = name
        self.systemImage = systemImage
        self.isActive = isActive
        self.logs = logs
    }
}

@Model
final class SDLogV1 {
    var id = UUID()
    var timestamp = Date.now
    var reward: SDRewardV1?

    var odds: Int?
    var losses: Int?
    var increasedOdds: Bool?

    init(id: UUID = UUID(), timestamp: Date = Date.now, reward: SDRewardV1, odds: Int, losses: Int, increasedOdds: Bool) {
        self.id = id
        self.timestamp = timestamp
        self.reward = reward
        self.odds = odds
        self.losses = losses
        self.increasedOdds = increasedOdds
    }
}

enum ObeySchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1,0,0)
    static var models: [any PersistentModel.Type] {
        [SDRewardV1.self, SDLogV1.self]
    }
}

enum ObeySchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2,0,0)
    static var models: [any PersistentModel.Type] {
        [SDReward.self, SDLog.self, SDUser.self]
    }
}

enum ObeyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [ObeySchemaV1.self, ObeySchemaV2.self]
    }

    static var stages: [MigrationStage] { [migrateV1toV2] }

    static let migrateV1toV2 = MigrationStage.custom(fromVersion: ObeySchemaV1.self, toVersion: ObeySchemaV2.self) { context in
        let defaults = UserDefaults(suiteName: Constants.suiteName)
        let odds = defaults?.integer(forKey: "odds") ?? Constants.startingOdds
        let losses = defaults?.integer(forKey: "losses") ?? 0
        let defaultUser = SDUser(name: "Default", color: CodableColor(.blue), odds: odds, losses: losses)
        context.insert(defaultUser)

        let rewards = try context.fetch(FetchDescriptor<SDReward>())
        for reward in rewards {
            var users = reward.users ?? []
            users.append(defaultUser)
            reward.users = users
        }

        let logs = try context.fetch(FetchDescriptor<SDLog>())
        for log in logs {
            log.user = defaultUser
        }

        try context.save()
    }
}

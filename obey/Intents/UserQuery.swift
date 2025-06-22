import AppIntents
import Foundation

struct UserQuery: EntityQuery {
    
    func entities(for identifiers: [UserEntity.ID]) async throws -> [Entity] {
        let db = try UserDatabase()
        let users = db.users(with: identifiers)
        
        return users.map { UserEntity(from: $0) }
    }
    
    func suggestedEntities() async throws -> [UserEntity] {
        let db = try UserDatabase()
        let users = db.allUsers()
        
        return users.map { UserEntity(from: $0) }
    }
}

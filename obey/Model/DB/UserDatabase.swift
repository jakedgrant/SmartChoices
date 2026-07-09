import Foundation
import SwiftData

final class UserDatabase: SwiftDatabase {
    typealias T = SDUser
    
    let container: ModelContainer
    
    init(useInMemoryStore: Bool = false) throws {
        let configuration = ModelConfiguration(
            for: T.self,
            isStoredInMemoryOnly: useInMemoryStore
        )
        container = try ModelContainer(
            for: T.self,
            configurations: configuration
        )
    }
    private let allPredicate = #Predicate<T> { _ in true }
}

extension UserDatabase {
    func allUsers() -> [T] {
        let sort = SortDescriptor<T>(\.name)
        do {
            return try self.read(predicate: allPredicate, sortDescriptors: sort)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func users(with identifiers: [T.ID]) -> [T] {
        let predicate = #Predicate<T> { t in
            identifiers.contains(t.id)
        }
        let sort = SortDescriptor<T>(\.name)
        
        do {
            return try self.read(predicate: predicate, sortDescriptors: sort)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

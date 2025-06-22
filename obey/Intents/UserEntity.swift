import AppIntents
import Foundation
import SwiftUI

struct UserEntity: AppEntity, Displayable {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "User"
    }
    
    static var defaultQuery = UserQuery()
    var id: SDUser.ID
    
    @Property(title: "Name")
    var name: String
    
    var image: String { "person.crop.circle" }
    var description: String { name }
    
    var color: Color
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            image: DisplayRepresentation.Image(systemName: image)
        )
    }
    
    init(from user: SDUser) {
        self.id = user.id
        self.color = user.swiftUIColor
        self.name = user.name
    }
}

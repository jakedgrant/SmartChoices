import Testing
import SwiftUI
@testable import obey

struct ThemeColorEnvironmentTests {
    @Test("Environment color updates when selected user changes")
    func themeColorReflectsSelectedUser() async throws {
        let manager = SelectedUserManager.shared
        defer { manager.selectedUser = nil }
        let redUser = SDUser(name: "Red", color: CodableColor(.red))
        let greenUser = SDUser(name: "Green", color: CodableColor(.green))

        manager.selectedUser = redUser
        var env = EnvironmentValues()
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == .red)

        manager.selectedUser = greenUser
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == .green)
    }

    @Test("Changing user color propagates to environment")
    func themeColorReflectsUserColorChange() async throws {
        let manager = SelectedUserManager.shared
        defer { manager.selectedUser = nil }
        let user = SDUser(name: "Kid", color: CodableColor(.blue))
        manager.selectedUser = user

        var env = EnvironmentValues()
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == .blue)

        user.color = CodableColor(.orange)
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == .orange)
    }
}

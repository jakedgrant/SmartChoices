import Testing
import SwiftUI
@testable import obey

struct ThemeColorEnvironmentTests {
    @MainActor
    @Test("Environment color updates when selected user changes")
    func themeColorReflectsSelectedUser() async throws {
        let manager = SelectedUserManager.shared
        defer { manager.selectedUser = nil }
        let redUser = SDUser(name: "Red", color: .red)
        let greenUser = SDUser(name: "Green", color: .green)

        manager.selectedUser = redUser
        var env = EnvironmentValues()
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == StandardColor.red.color)

        manager.selectedUser = greenUser
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == StandardColor.green.color)
    }

    @MainActor
    @Test("Changing user color propagates to environment")
    func themeColorReflectsUserColorChange() async throws {
        let manager = SelectedUserManager.shared
        defer { manager.selectedUser = nil }
        let user = SDUser(name: "Kid", color: .blue)
        manager.selectedUser = user

        var env = EnvironmentValues()
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == StandardColor.blue.color)

        user.color = .orange
        env.themeColor = manager.selectedUser?.color.color ?? .accentColor
        #expect(env.themeColor == StandardColor.orange.color)
    }
}

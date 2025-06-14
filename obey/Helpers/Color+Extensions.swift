//
//  Color+Extensions.swift
//  obey
//
//  Created by Jake Grant on 6/13/25.
//

import SwiftUI

extension Color {
	static var themeColor: Color {
		SelectedUserManager.shared.selectedUser?.color.color ?? .accentColor
	}
}

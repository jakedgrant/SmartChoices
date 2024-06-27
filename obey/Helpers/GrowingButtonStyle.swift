//
//  GrowingButtonStyle.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding(80)
			.background(.blue)
			.foregroundStyle(.white)
			.clipShape(Circle())
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}


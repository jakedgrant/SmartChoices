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
			.background(Color.accentColor)
			.foregroundStyle(.white)
			.clipShape(Circle())
			.padding()
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.shadow(radius: configuration.isPressed ? 2 : 20)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

#Preview {
	Group {
		Button("This is a button", action: { })
			.buttonStyle(GrowingButton())
			.fontWidth(.expanded)
			.bold()
		
		Button("This is a button with event more text", action: { })
			.buttonStyle(GrowingButton())
			.fontWidth(.expanded)
			.bold()
	}
}


//
//  GrowingButtonStyle.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct SCButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(Color.white)
			.fontWidth(.expanded)
			.bold()
			.padding(80)
			.background(Color.accentColor)
			.clipShape(Circle())
			.padding()
			.shadow(radius: 5,
					x: configuration.isPressed ? 0 : 4,
					y: configuration.isPressed ? 0 : 4)
			.opacity(configuration.isPressed ? 0.7 : 1.0)
			.offset(x: configuration.isPressed ? 4 :0,
					y: configuration.isPressed ? 4: 0)
	}
}

#Preview {
	Group {
		Button("This is a button", action: { })
			.buttonStyle(SCButtonStyle())
			.fontWidth(.expanded)
			.bold()
		
		Button("This is a button with event more text", action: { })
			.buttonStyle(SCButtonStyle())
			.fontWidth(.expanded)
			.bold()
	}
}


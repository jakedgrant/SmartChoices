//
//  GrowingButtonStyle.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct SCButtonBackground: View {
	var isPressed = false
	var body: some View {
		ZStack {
			
			Color.accentColor
			
			LinearGradient(
				colors: isPressed
				? [.black.opacity(0.55)]
				: [.accentColor, .black.opacity(0.35)],
				startPoint: UnitPoint(x: 0.0, y: 0.0),
				endPoint: UnitPoint(x:0.0, y: 1.0)
			)
		}
	}
}

struct SCButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(.white)
			.bold()
			.fontDesign(.rounded)
			.padding(.vertical, 12)
			.padding(.horizontal, 20)
			.background(SCButtonBackground(isPressed: configuration.isPressed))
			.overlay(
				Capsule(style: .circular)
					.stroke(.black.opacity(0.2), lineWidth: 8.0)
			)
			.clipShape(Capsule(style: .circular))
			.padding()
			.opacity(configuration.isPressed ? 0.7 : 1.0)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
	}
}

struct SCCircleButtonStyle: ButtonStyle {
	let padding: CGFloat
	
	func makeBody(configuration: Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(Color.white)
			.bold()
			.fontDesign(.rounded)
			.padding(padding)
			.background(SCButtonBackground(isPressed: configuration.isPressed))
			.overlay(
				Circle()
					.stroke(.black.opacity(0.2), lineWidth: 8.0)
			)
			.clipShape(Circle())
			.padding()
			.opacity(configuration.isPressed ? 0.7 : 1.0)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
	}
}

#Preview {
	Group {
		Button("Regular", action: {})
			.buttonStyle(SCButtonStyle())
		
		Button("This is a button", action: { })
			.buttonStyle(SCCircleButtonStyle(padding: 80))
		
		Button("This is a button with event more text", action: { })
			.buttonStyle(SCCircleButtonStyle(padding: 80))
	}
}


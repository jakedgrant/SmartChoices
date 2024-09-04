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
				? [.black.opacity(0.35), .accentColor]
				: [.accentColor, .black.opacity(0.35)],
				startPoint: UnitPoint(x: 0.0, y: 0.0),
				endPoint: UnitPoint(x:0.0, y: 1.0)
			)
			.animation(.default, value: isPressed)
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
//			.shadow(radius: 5,
//					x: configuration.isPressed ? 0 : 4,
//					y: configuration.isPressed ? 0 : 4)
			.opacity(configuration.isPressed ? 0.7 : 1.0)
//			.offset(x: configuration.isPressed ? 4 :0,
//					y: configuration.isPressed ? 4: 0)
	}
}

struct SCCircleButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(Color.white)
			.bold()
			.fontDesign(.rounded)
			.padding(80)
			.background(SCButtonBackground(isPressed: configuration.isPressed))
			.overlay(
				Circle()
					.stroke(.black.opacity(0.2), lineWidth: 8.0)
			)
			.clipShape(Circle())
			.padding()
//			.shadow(radius: 5,
//					x: configuration.isPressed ? 0 : 4,
//					y: configuration.isPressed ? 0 : 4)
			.opacity(configuration.isPressed ? 0.7 : 1.0)
//			.offset(x: configuration.isPressed ? 4 :0,
//					y: configuration.isPressed ? 4: 0)
	}
}

#Preview {
	Group {
		Button("Regular", action: {})
			.buttonStyle(SCButtonStyle())
		
		Button("This is a button", action: { })
			.buttonStyle(SCCircleButtonStyle())
		
		Button("This is a button with event more text", action: { })
			.buttonStyle(SCCircleButtonStyle())
	}
}


//
//  MenuImageView.swift
//  obey
//
//  Created by Jake Grant on 8/26/24.
//

import SwiftUI
import RevenueCat

struct MenuImageView: View {
	
	var body: some View {
		
		Image(systemName: "list.bullet")
			.foregroundStyle(Color.white)
			.bold()
			.fontDesign(.rounded)
			.padding()
			.background(SCButtonBackground())
			.overlay(
				Circle()
					.stroke(.black.opacity(0.2), lineWidth: 8.0)
			)
			.clipShape(Circle())
	}
}

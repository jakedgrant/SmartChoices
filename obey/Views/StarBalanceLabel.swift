//
//  StarBalanceLabel.swift
//  obey
//

import SwiftUI

struct StarBalanceLabel: View {
	let balance: Int

	var body: some View {
		HStack(spacing: 6) {
			Image(systemName: "star.fill")
				.foregroundStyle(.yellow)

			Text("\(balance)")
				.contentTransition(.numericText())
		}
		.font(.title2)
		.bold()
		.fontDesign(.rounded)
		.padding(.vertical, 8)
		.padding(.horizontal, 16)
		.background(
			Capsule(style: .circular)
				.fill(.gray.opacity(0.2))
		)
		.accessibilityLabel("\(balance) stars")
	}
}

#Preview {
	StarBalanceLabel(balance: 12)
}

//
//  BadgeLabel.swift
//  obey
//
//  Created by Jake Grant on 9/8/24.
//

import SwiftUI

struct BadgeLabel: View {
	@Environment(\.colorScheme) var colorScheme
	
	let text: String?
	let systemImage: String?
	
	init(_ text: String?, systemImage: String?) {
		self.text = text
		self.systemImage = systemImage
	}
	
	var body: some View {
		HStack(spacing: 4) {
			if let systemImage {
				Image(systemName: systemImage)
			}
			if let text {
				Text(text)
			}
		}
		.foregroundStyle(colorScheme == .light ? .black.opacity(0.6) : .white.opacity(0.5))
		.padding(.horizontal, 3)
		.padding(.vertical, 3)
		.background(
			RoundedRectangle(cornerRadius: 4.0, style: .continuous)
				.fill(.gray.opacity(0.2))
			)
	}
}

#Preview {
	BadgeLabel("a badge", systemImage: "tag")
}

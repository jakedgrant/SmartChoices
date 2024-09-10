//
//  LogEntryView.swift
//  obey
//
//  Created by Jake Grant on 9/8/24.
//

import SwiftUI

struct LogEntryView: View {
	
	let timestamp: Date?
	let name: String?
	let systemImage: String?
	
	let odds: Int?
	let losses: Int?
	let increasedOdds: Bool?
	
	var body: some View {
		
		HStack(alignment: .top, spacing: 12) {
			
			ImageView(systemName: systemImage)
			
			VStack(alignment: .leading, spacing: 4) {
					
				Text(name ?? "A reward")
					.bold()
					.font(.headline)
				
				if let timestamp {
					Text(timestamp.formatted(date: .numeric, time: .shortened))
						.font(.subheadline)
						.foregroundStyle(.gray)
				}
				
				OddsView(odds: odds, losses: losses, increasedOdds: increasedOdds)
			}
			
			Spacer()
		}
		.fontDesign(.rounded)
	}
	
	private struct ImageView: View {
		let systemName: String?
		
		var body: some View {
			Image(systemName: systemName ?? Constants.defaultImageName)
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
	
	private struct OddsView: View {
		let odds: Int?
		let losses: Int?
		let increasedOdds: Bool?
		
		var body: some View {
			HStack(spacing: 4) {
				BadgeLabel("1 : \(odds ?? 0)", systemImage: "dice")
				BadgeLabel("\(losses ?? 0)", systemImage: "star.slash")
				
				if increasedOdds == true {
					BadgeLabel(nil, systemImage: "arrow.up")
				}
			}
			.font(.footnote)
		}
	}
}

#Preview {
	List {
		LogEntryView(
			timestamp: .now.addingTimeInterval(-60),
			name: "Pillow fight",
			systemImage: "figure.boxing",
			odds: 5,
			losses: 2,
			increasedOdds: true
		)
		
		LogEntryView(
			timestamp: .now.addingTimeInterval(-60),
			name: "Pillow fight",
			systemImage: "figure.boxing",
			odds: 5,
			losses: 2,
			increasedOdds: true
		)
		
		LogEntryView(
			timestamp: .now.addingTimeInterval(-60),
			name: "Pillow fight",
			systemImage: "figure.boxing",
			odds: 5,
			losses: 2,
			increasedOdds: false
		)
	}
}

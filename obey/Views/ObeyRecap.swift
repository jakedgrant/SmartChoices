//
//  ObeyRecap.swift
//  obey
//
//  Created by Jake Grant on 10/16/24.
//

import Foundation
import Recap
import SwiftUI

// Initialize releases from a markdown file in your app's bundle
extension [Release] {
	static var update: [Release] {
		ReleasesParser(fileName: "Releases").releases
	}
	static var intro: [Release] {
		ReleasesParser(fileName: "Intro").releases
	}
	static var onboarding: [Release] {
		update + intro
	}
}

struct ReleasePackage: Identifiable, Equatable {
	let id: String
	let releases: [Release]
	
	static let update = ReleasePackage(id: "update", releases: .update)
	static let intro = ReleasePackage(id: "intro", releases: .intro)
	static let onboarding = ReleasePackage(id: "onboarding", releases: .onboarding)
	
	static func display(for currentVersionString: String, with previousVersionString: String) -> ReleasePackage? {

		if previousVersionString == Constants.startingVersion {
			return .onboarding
		}

		let currentVersion = SemanticVersion(version: currentVersionString)
		let previousVersion = SemanticVersion(version: previousVersionString)
		
		// Show screen if major or minor version has increased
		let result = currentVersion.major > previousVersion.major || currentVersion.minor > previousVersion.minor
		return result ? .update : nil
	}
}

struct ObeyIntro: View {
	
	var body: some View {
		RecapScreen(releases: .intro)
			.obeyRecapStyle()
	}
}

struct ObeyRecap: View {
	let releases: [Release]
	
	init(showing releases: [Release]) {
		self.releases = releases
	}
	
	var body: some View {
		RecapScreen(releases: releases)
			.obeyRecapStyle()
	}
	
	// https://www.color-name.com/
}

// A view modifier that detects shaking and calls a function of our choosing.
struct ObeyRecapStyle: ViewModifier {
	let mintLight = Color(uiColor: .init(red: 0.00, green: 0.78, blue: 0.74, alpha: 1)) // 0, 200, 189 - #00c8bd
	// 0, 164, 154 - #00a49a - mint Middle
	let mintDark = Color(uiColor: .init(red: 0.00, green: 0.50, blue: 0.46, alpha: 1)) // 0, 128, 118 - #008076

	func body(content: Content) -> some View {
		content
			.recapScreenDismissButtonStyle(LinearGradient(
				colors: [mintLight, mintDark],
				startPoint: UnitPoint(x: 0.0, y: 0.0),
				endPoint: UnitPoint(x:0.0, y: 1.0)
			))
			.recapScreenPageIndicatorColors(selected: mintLight, deselected: .gray)
			.recapScreenIconFillMode(.gradient)
	}
}

// A View extension to make the modifier easier to use.
extension View {
	func obeyRecapStyle() -> some View {
		self.modifier(ObeyRecapStyle())
	}
}

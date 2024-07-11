//
//  OpenAppIntent.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation

struct OpenAppIntent: AppIntent {
		
	static var title: LocalizedStringResource = "Open Smart Choices"
	static var description = IntentDescription("Opens the Smart Choices app.")
	
	func perform() async throws -> some IntentResult {
		return .result()
	}
	
	static var openAppWhenRun: Bool = true
}

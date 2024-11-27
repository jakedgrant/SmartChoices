//
//  ObeyTests.swift
//  ObeyTests
//
//  Created by Jake Grant on 10/18/24.
//

import Testing
@testable import obey

struct ReleasePackageTests {

	@Test(
		"Determine recap package to show",
		arguments: [
			RecapParameters(curr: "1.0", prev: "1.0", result: nil),
			RecapParameters(curr: "1.0", prev: "1.1", result: nil),
			RecapParameters(curr: "1.1", prev: "1.0", result: .update),
			RecapParameters(curr: "1.0", prev: Constants.startingVersion, result: .onboarding),
			RecapParameters(curr: "1.1", prev: Constants.startingVersion, result: .onboarding)
		]
	)
	private func recapToShow(_ params: RecapParameters) async throws {
		let package = ReleasePackage.display(for: params.currentVersion, with: params.previousVersion)
		#expect(package == params.package, "For curr:\(params.currentVersion) compared to prev:\(params.previousVersion) we expected \(params.package?.id ?? "<nil>") but received \(package?.id ?? "<nil>")")
    }
	
	private struct RecapParameters {
		let currentVersion: String
		let previousVersion: String
		let package: ReleasePackage?
		
		init(curr: String, prev: String, result package: ReleasePackage?) {
			self.currentVersion = curr
			self.previousVersion = prev
			self.package = package
		}
	}
}

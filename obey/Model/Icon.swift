//
//  Icon.swift
//  obey
//
//  Created by Jake Grant on 8/18/24.
//

import Foundation

struct Icon {
	let sets: [IconSet]
	
	struct IconSet: Identifiable {
		let id: String
		let name: String
		let iconNames: [String]
	}
	
	static let `default` = Icon(
		sets: [
			IconSet(
				id: "Fitness",
				name: "Fitness",
				iconNames: [
					"figure.walk",
					"figure.run",
					"figure.american.football",
					"figure.archery",
					"figure.baseball",
					"figure.basketball",
					"figure.bowling",
					"figure.climbing",
					"figure.pool.swim",
					"figure.hunting",
					"figure.wrestling",
					"figure.socialdance",
				]
			),
			IconSet(
				id: "Activity",
				name: "Activity",
				iconNames: [
					"dice.fill",
					"figure.and.child.holdinghands",
					"figure.2.and.child.holdinghands",
					"book.pages.fill",
					"balloon.fill",
					"popcorn.fill",
					"sofa.fill",
					"tree.fill",
					"bubbles.and.sparkles.fill",
					"tent.fill",
				]
			),
			IconSet(
				id: "Crafts",
				name: "Crafts",
				iconNames: [
					"hand.wave.fill",
					"pencil.and.scribble",
					"highlighter",
					"scissors",
					"paintbrush.pointed.fill",
				]
			),
			IconSet(
				id: "Media",
				name: "Media",
				iconNames: [
					"tv.inset.filled",
					"ipad",
					"ipad.gen1",
					"flag.2.crossed.fill",
					"arcade.stick.console",
					"arcade.stick",
					"gamecontroller",
				]
			),
		]
	)
}

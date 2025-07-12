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
                                        "soccerball",
                                        "football.fill",
                                        "bicycle",
                                        "figure.badminton",
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
                                        "hands.clap.fill",
                                        "face.smiling",
                                        "music.note",
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
                                        "paintpalette.fill",
                                        "eraser.fill",
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
                                        "mic.fill",
                                        "headphones",
                                        "speaker.wave.2.fill",
                                ]
                        ),
                        IconSet(
                                id: "Toys",
                                name: "Toys",
                                iconNames: [
                                        "puzzlepiece.fill",
                                        "teddybear.fill",
                                        "car.fill",
                                        "airplane",
                                        "rocket.fill",
                                ]
                        ),
                        IconSet(
                                id: "Transportation",
                                name: "Transportation",
                                iconNames: [
                                        "car.2.fill",
                                        "bus.fill",
                                        "train.side.front.car",
                                        "truck.pickup",
                                        "sailboat.fill",
                                        "airplane.departure",
                                ]
                        ),
                        IconSet(
                                id: "Outdoor",
                                name: "Outdoor",
                                iconNames: [
                                        "sun.max.fill",
                                        "cloud.sun.fill",
                                        "campfire.fill",
                                        "backpack.fill",
                                        "binoculars.fill",
                                        "leaf.fill",
                                ]
                        ),
                        IconSet(
                                id: "Learning",
                                name: "Learning",
                                iconNames: [
                                        "graduationcap.fill",
                                        "book.fill",
                                        "books.vertical.fill",
                                        "brain.head.profile",
                                        "book.closed.fill",
                                ]
                        ),
                        IconSet(
                                id: "Rewards",
                                name: "Rewards",
                                iconNames: [
                                        "star.fill",
                                        "gift.fill",
                                        "trophy.fill",
                                        "medal.fill",
                                        "rosette",
                                        "crown.fill",
                                ]
                        ),
                ]
        )
}

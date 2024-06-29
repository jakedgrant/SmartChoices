//
//  Reward.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import Foundation

enum Reward: CaseIterable, Identifiable {
	case book
	case treat
	case tv
	case game
	case parentPlay
	case playDoh
	case swim
	case blanketFort
	case waterGunFight
	case artSupplies
	case iPad
	
	var id: String {
		image
	}
	
	var image: String {
		switch self {
		case .book:  "book.pages.fill"
		case .treat: "birthday.cake.fill"
		case .tv:    "tv.inset.filled"
		case .game:  "gamecontroller.fill"
		case .parentPlay: "figure.and.child.holdinghands"
		case .playDoh: "hand.wave.fill"
		case .swim: "figure.pool.swim"
		case .blanketFort: "tent.fill"
		case .waterGunFight: "figure.hunting"
		case .artSupplies: "paintbrush.pointed.fill"
		case .iPad: "ipad.gen1"
		}
	}
	
	var description: String {
		switch self {
		case .book:  "extra BOOK at bedtime"
		case .treat: "a TREAT"
		case .tv:    "extra TV time"
		case .game:  "play a GAME"
		case .parentPlay: "15 min PLAY with MOM or DAD"
		case .playDoh: "play with PLAYDOH"
		case .swim: "go SWIMMING"
		case .blanketFort: "build a BLANKET FORT"
		case .waterGunFight: "WATER GUN FIGHT"
		case .artSupplies: "new ART SUPPLIES"
		case .iPad: "iPad time"
		}
	}
}

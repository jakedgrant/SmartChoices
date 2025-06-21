//
//  SwitchUserTip.swift
//  obey
//
//  Created by OpenAI on 9/18/24.
//

import TipKit

struct SwitchUserTip: Tip {
    
    static let didAddUserEvent = Event(id: "didAddUserEvent")
    
    var title: Text {
        Text("Switch users")
    }
    
    var message: Text? {
        Text("Tap here to change users")
    }
    
    var image: Image? {
        Image(systemName: "person.3.fill")
            .symbolRenderingMode(.hierarchical)
    }
    
    var rules: [Rule] {
        #Rule(Self.didAddUserEvent) { $0.donations.count > 1 }
    }
}

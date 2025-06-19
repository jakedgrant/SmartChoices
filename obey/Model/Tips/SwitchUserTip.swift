//
//  SwitchUserTip.swift
//  obey
//
//  Created by OpenAI on 9/18/24.
//

import TipKit

struct SwitchUserTip: Tip {
        var title: Text {
                Text("Switch users")
        }

        var message: Text? {
                Text("Tap here to change users. Add more in Settings.")
        }

        var image: Image? {
                Image(systemName: "person.crop.circle")
        }
}

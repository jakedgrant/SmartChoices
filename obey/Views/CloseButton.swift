//
//  CloseButton.swift
//  obey
//
//  Created by Jake Grant on 7/10/25.
//

import SwiftUI

struct CloseButton: View {
    typealias Action = () -> ()
    let action: Action
    
    init(_ action: @escaping Action = { }) {
        self.action = action
    }
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: "xmark")
                .imageScale(.small)
        }
        .buttonStyle(SCCircleButtonStyle(padding: 12))
        .padding(.trailing, -12)
    }
}

//
//  PrimaryButtonStyle.swift
//  MultiPageForm
//
//  Created by Jonathon Albert on 20/10/2022.
//

import SwiftUI

struct PrimaryButtonStyle: ViewModifier {

    var enabled: Bool

    func body(content: Content) -> some View {
        content
            .frame(height: 60.0)
            .background(enabled ? .black : .gray)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(12.0)
    }
}

extension View {
    func primaryButtonStyle(enabled: Bool) -> some View {
        modifier(PrimaryButtonStyle(enabled: enabled))
    }
}

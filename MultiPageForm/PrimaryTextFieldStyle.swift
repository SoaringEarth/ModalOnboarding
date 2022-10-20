//
//  PrimaryTextFieldStyle.swift
//  MultiPageForm
//
//  Created by Jonathon Albert on 20/10/2022.
//

import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.body.bold())
            .frame(height: 60.0)
            .padding(.horizontal)
            .background(.white)
            .foregroundColor(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange, lineWidth: 2)
            )
    }
}

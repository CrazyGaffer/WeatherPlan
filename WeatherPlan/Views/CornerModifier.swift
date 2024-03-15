//
//  CornerModifier.swift
//  WeatherApp
//
//  Created by Roman Krusman on 15.03.2024.
//

import SwiftUI

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    func body(content: Content) -> some View {
        if bottomOffset < 38 {
            content
        } else {
            content
                .cornerRadius(12)
        }
    }
}

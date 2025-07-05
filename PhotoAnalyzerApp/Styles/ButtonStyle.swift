//
//  ButtonStyle.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct ButtonStyleScale: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

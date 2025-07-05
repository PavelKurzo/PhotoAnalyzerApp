//
//  CornerRadius.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner, borderColor: Color? = nil, borderWidth: CGFloat? = nil) -> some View {
        overlay(
            RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 1)
        )
        .clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
}

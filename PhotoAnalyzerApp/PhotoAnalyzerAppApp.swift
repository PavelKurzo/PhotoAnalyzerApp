//
//  PhotoAnalyzerAppApp.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import SwiftData

@main
struct PhotoAnalyzerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: ProjectImage.self)
    }
}

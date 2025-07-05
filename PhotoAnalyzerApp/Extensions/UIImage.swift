//
//  UIImage.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import UIKit

extension UIImage {
    func saveToDocuments(named fileName: String) -> String? {
        guard let data = self.jpegData(compressionQuality: 0.9) else { return nil }
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(fileName)
        
        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("❌ Failed to save image: \(error)")
            return nil
        }
    }
}

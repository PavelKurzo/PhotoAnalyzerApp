//
//  ProjectImage.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import SwiftData

@Model
final class ProjectImage {
    @Attribute(.unique) var id: UUID
    var name: String
    @Attribute(.externalStorage) var imageData: Data
    var hasFace: Bool
    var orientation: Orientation
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, imageData: Data, hasFace: Bool, orientation: Orientation) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.hasFace = hasFace
        self.orientation = orientation
        self.createdAt = Date()
    }
    
    enum Orientation: String, Codable, CaseIterable {
        case vertical, horizontal, square
    }
    
    var uiImage: UIImage? {
        return UIImage(data: imageData)
    }
    
    var isValidImage: Bool {
        return UIImage(data: imageData) != nil
    }
}

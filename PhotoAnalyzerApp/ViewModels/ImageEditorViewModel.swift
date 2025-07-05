//
//  ImageEditorViewModel.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import PhotosUI
import Vision

@MainActor
final class ImageEditorViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var image: UIImage?
    @Published var isProcessing = false
    @Published var hasFace = false
    @Published var generatedName = ""

    private var indexCounter = 1

    let keywords = [
        "Sunset", "Mountain", "Beach", "Forest", "Cityscape",
        "Portrait", "Pet", "Food", "Flower", "Building",
        "Lake", "Art", "Landscape", "Tree", "Cloud",
        "River", "Snow", "Sand", "Road", "Horizon"
    ]

    func loadImageData() async {
        guard let item = selectedItem else { return }

        isProcessing = true
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                
                self.image = uiImage
                
                let faceFound = await Task.detached {
                    FaceDetector.containsFace(in: uiImage)
                }.value
                
                let name = generateName()
                
                self.hasFace = faceFound
                self.generatedName = name
                self.isProcessing = false
            }
        } catch {
            print("Failed to load image:", error)
            self.isProcessing = false
        }
        
        selectedItem = nil
    }

    private func generateName() -> String {
        let word = keywords.randomElement() ?? "photo"
        let name = "\(word.lowercased())-\(indexCounter)"
        indexCounter += 1
        return name
    }

    func determineOrientation() -> ProjectImage.Orientation {
        guard let image = image else { return .square }
        let size = image.size
        if size.width > size.height {
            return .horizontal
        } else if size.height > size.width {
            return .vertical
        } else {
            return .square
        }
    }
    
    func exportImage() -> String? {
        guard let image = image else {
            print("No image to export")
            return nil
        }
        print("Exporting image with name: \(generatedName)")
        return ImageExporter.saveImage(image, name: generatedName)
    }
}

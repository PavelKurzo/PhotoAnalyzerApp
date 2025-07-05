//
//  ImageExporter.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import Photos

final class ImageExporter {
    static func saveImage(_ image: UIImage, name: String) -> String? {
        print("Starting to save image with name: \(name)")
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to JPEG data")
            return nil
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documentsURL.appendingPathComponent("\(name).jpg")
        
        print("Attempting to save image to: \(imageURL.path)")
        
        do {
            try data.write(to: imageURL)
            print("Image saved successfully at: \(imageURL.path)")
            
            if fileManager.fileExists(atPath: imageURL.path) {
                print("File verification: Image file exists at path")
                return imageURL.path
            } else {
                print("File verification: Image file does not exist after saving")
                return nil
            }
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    static func saveImageToPhotos(_ image: UIImage, name: String) {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: image.jpegData(compressionQuality: 1.0)!, options: nil)
        }) { success, error in
            if success {
                print("Image saved to Photos app successfully")
            } else {
                print("Failed to save image to Photos app: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
} 

//
//  FaceDetector.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import Vision
import UIKit

final class FaceDetector {
    static func containsFace(in image: UIImage) -> Bool {
        guard let cgImage = image.cgImage else { return false }

        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
            return !(request.results?.isEmpty ?? true)
        } catch {
            print("No face detected:", error)
            return false
        }
    }
}

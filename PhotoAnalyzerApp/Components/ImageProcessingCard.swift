//
//  ImageProcessingCard.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct ImageProcessingCard: View {
    let image: UIImage?
    let name: String
    let hasFace: Bool
    let isProcessing: Bool
    let onExport: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 400)
                    .overlay(
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Processing...")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                        }
                    )
            }
            
            HStack(spacing: 8) {
                Text(name.isEmpty ? "Generating name..." : name)
                    .font(.title2)
                    .bold()
                
                if isProcessing {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: hasFace ? "person.crop.circle" : "photo")
                        .foregroundStyle(hasFace ? .blue : .green)
                }
            }
            
            if !isProcessing {
                Button(action: onExport) {
                    Text("Export")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .shadow(radius: 10)
    }
}

#Preview {
    VStack(spacing: 40) {
        ImageProcessingCard(
            image: nil,
            name: "",
            hasFace: false,
            isProcessing: true,
            onExport: {}
        )
        .frame(height: 500)
    }
}

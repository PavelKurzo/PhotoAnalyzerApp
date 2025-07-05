//
//  ProjectCardView.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct ProjectCardView: View {
    let project: ProjectImage
    
    var body: some View {
        VStack(spacing: 8) {
            if let uiImage = project.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: heightForOrientation(project.orientation))
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: heightForOrientation(project.orientation))
                    .cornerRadius(8)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundStyle(.gray)
                            Text("Invalid image")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    )
            }
        }
        .overlay {
            VStack {
                Spacer()
                
                HStack(spacing: 4) {
                    Text(project.name)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(project.hasFace ? .face : .landScape)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
            }
         
        }
        .background(.clear)
    }
    
    private func heightForOrientation(_ orientation: ProjectImage.Orientation) -> CGFloat {
        switch orientation {
        case .vertical:
            return 220
        case .horizontal:
            return 140
        case .square:
            return 180 
        }
    }
}

#Preview {
    ProjectCardView(
        project: ProjectImage(
            name: "mountain-1",
            imageData: Data(),
            hasFace: true,
            orientation: .vertical
        )
    )
    .preferredColorScheme(.dark)
}

//
//  ContentView.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProjectImage.createdAt, order: .reverse) private var projects: [ProjectImage]
    
    @StateObject private var editorVM = ImageEditorViewModel()
    @State private var showPhotoPicker = false
    @State private var selectedProject: ProjectImage?
    @State private var searchText = ""
    
    private var filteredProjects: [ProjectImage] {
        if searchText.isEmpty {
            return projects
        } else {
            return projects.filter { project in
                project.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                toolbar()
                
                SearchField(searchText: $searchText)
                
                ProjectListView(projects: filteredProjects) { project in
                    withAnimation {
                        selectedProject = project
                    }
                }
                Spacer()
            }
            .overlay {
                if filteredProjects.isEmpty {
                    if searchText.isEmpty {
                        noProjectsYet()
                    } else {
                        Text("No results found")
                            .font(.system(size: 19, weight: .medium))
                    }
                }
            }
            .padding()
            .blur(radius: (editorVM.image != nil || editorVM.isProcessing || selectedProject != nil) ? 10 : 0)
            
            if editorVM.image != nil || editorVM.isProcessing {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !editorVM.isProcessing {
                            saveImageToProjects()
                        }
                    }
                
                ImageProcessingCard(
                    image: editorVM.image,
                    name: editorVM.generatedName,
                    hasFace: editorVM.hasFace,
                    isProcessing: editorVM.isProcessing,
                    onExport: {
                        saveImageToProjects()
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(), value: editorVM.image)
            }
            
            if let project = selectedProject {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedProject = nil
                    }
                
                ProjectViewCard(project: project)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: selectedProject)
            }
        }
        .photosPicker(isPresented: $showPhotoPicker,
                      selection: $editorVM.selectedItem,
                      matching: .images,
                      photoLibrary: .shared())
        .onChange(of: editorVM.selectedItem) { _, _ in
            if editorVM.selectedItem != nil {
                showPhotoPicker = false
                Task {
                    await editorVM.loadImageData()
                }
            }
        }
    }
    
    private func saveImageToProjects() {
        guard let image = editorVM.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let newProject = ProjectImage(
            name: editorVM.generatedName,
            imageData: imageData,
            hasFace: editorVM.hasFace,
            orientation: editorVM.determineOrientation()
        )
        
        modelContext.insert(newProject)
        
        if let path = editorVM.exportImage() {
            print("Image also saved to: \(path)")
        }
        
        editorVM.image = nil
        editorVM.generatedName = ""
        editorVM.hasFace = false
        editorVM.isProcessing = false
    }
    
    @ViewBuilder
    private func toolbar() -> some View {
        HStack {
            Button {
                showPhotoPicker = true
            } label: {
                Image(.addIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(ButtonStyleScale())
            
            Spacer()
            
            Text("Projects")
                .font(.system(size: 17, weight: .semibold))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func noProjectsYet() -> some View {
        VStack(spacing: 8) {
            Image(.landScape)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 54, height: 54)
            
            Text("No projects yet")
                .font(.system(size: 19, weight: .medium))
            
            Text("Start editing your photos now")
                .font(.system(size: 13))
                .foregroundStyle(.lightGray)
            
            Button {
                showPhotoPicker = true
            } label: {
                Text("Start editing")
                    .foregroundStyle(.black)
                    .font(.system(size: 13))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 74.5)
                    .background {
                        Capsule()
                            .fill(Color.mint)
                    }
            }
            .buttonStyle(ButtonStyleScale())
            .padding(.top, 12)
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

struct ProjectViewCard: View {
    let project: ProjectImage
    @State private var showExportSuccess = false
    @State private var exportMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            if let uiImage = project.uiImage {
                Image(uiImage: uiImage)
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
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Image not available")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
            
            HStack(spacing: 8) {
                Text(project.name)
                    .font(.title2)
                    .bold()
                
                Image(project.hasFace ? .face : .landScape)
                
                Spacer()
                
                Text(project.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if showExportSuccess {
                Text(exportMessage)
                    .font(.caption)
                    .foregroundStyle(.green)
                    .padding(.vertical, 4)
            }
            
            Button(action: exportImage) {
                Text("Export to Photos")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mint)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .shadow(radius: 10)
    }
    
    private func exportImage() {
        guard let image = project.uiImage else { return }
        
        ImageExporter.saveImageToPhotos(image, name: project.name)
        
        if let path = ImageExporter.saveImage(image, name: project.name) {
            exportMessage = "Image saved to Photos and Documents"
            showExportSuccess = true
        } else {
            exportMessage = "Image saved to Photos only"
            showExportSuccess = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showExportSuccess = false
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .modelContainer(for: ProjectImage.self, inMemory: true)
}

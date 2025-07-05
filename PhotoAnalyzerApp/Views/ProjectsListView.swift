//
//  ProjectsListView.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct ProjectListView: View {
    let projects: [ProjectImage]
    var onSelect: (ProjectImage) -> Void
    
    var body: some View {
        ScrollView {
            MasonryGrid(projects: projects, onSelect: onSelect)
                .padding()
        }
    }
}

struct MasonryGrid: View {
    let projects: [ProjectImage]
    var onSelect: (ProjectImage) -> Void
    
    var body: some View {
        let leftColumnProjects = projects.enumerated().compactMap { index, project in
            index % 2 == 0 ? project : nil
        }
        let rightColumnProjects = projects.enumerated().compactMap { index, project in
            index % 2 == 1 ? project : nil
        }
        
        HStack(alignment: .top, spacing: 12) {
            LazyVStack(spacing: 12) {
                ForEach(leftColumnProjects, id: \.id) { project in
                    ProjectCardView(project: project)
                        .onTapGesture {
                            onSelect(project)
                        }
                }
            }
            LazyVStack(spacing: 12) {
                ForEach(rightColumnProjects, id: \.id) { project in
                    ProjectCardView(project: project)
                        .onTapGesture {
                            onSelect(project)
                        }
                }
            }
        }
    }
}

#Preview {
    ProjectListView(
        projects: [],
        onSelect: { project in
            print("Selected project: \(project.name)")
        }
    )
}


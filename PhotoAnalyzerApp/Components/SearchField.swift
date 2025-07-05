//
//  SearchField.swift
//  PhotoAnalyzerApp
//
//  Created by Pavel Kurzo on 05/07/2025.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(.search)
            
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search")
                        .foregroundStyle(.gray)
                        .padding(.leading, 3)
                }
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.regularGray)
        }
    }
}

#Preview {
    SearchField(searchText: .constant(""))
}

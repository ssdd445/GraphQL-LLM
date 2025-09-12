//
//  CharacterDetailContentView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import List
import SwiftUI

struct CharacterDetailContentView: View {
    let character: GetCharacterDetailQuery.Data.Character
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageUrl = character.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 8)
            }
            
            Text(character.name ?? "Unknown")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                CharacterDetailRow(title: "Status", value: character.status)
                CharacterDetailRow(title: "Species", value: character.species)
                CharacterDetailRow(title: "Gender", value: character.gender)
                
                if let created = character.created {
                    CharacterDetailRow(title: "Created", value: formatDate(created))
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

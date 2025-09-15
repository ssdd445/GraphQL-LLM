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
    
    @StateObject private var factViewModel: CharacterFactViewModel
    
    init(
        character: GetCharacterDetailQuery.Data.Character,
        aiService: AIService
    ) {
        self.character = character
        self._factViewModel = StateObject(wrappedValue: CharacterFactViewModel(aiService: aiService))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            characterImage
            
            characterName
            
            characterDetails
        }
    }
    
    private var characterImage: some View {
        Group {
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
        }
    }
    
    private var characterName: some View {
        Text(character.name ?? "Unknown")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    private var characterDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            CharacterDetailRow(title: "Status", value: character.status)
            CharacterDetailRow(title: "Species", value: character.species)
            CharacterDetailRow(title: "Gender", value: character.gender)
            
            if let created = character.created {
                CharacterDetailRow(title: "Created", value: factViewModel.formatDate(created))
            }
            
            factSection
            
            if let error = factViewModel.factError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var factSection: some View {
        Group {
            if factViewModel.generatedFact.isEmpty && !factViewModel.isGeneratingFact {
                generateFactButton
            } else if factViewModel.isGeneratingFact {
                loadingFactView
            } else if !factViewModel.generatedFact.isEmpty {
                generatedFactView
            }
        }
    }
    
    private var generateFactButton: some View {
        Button {
            factViewModel.generateFact(for: character)
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "lightbulb")
                Text("Generate Interesting Fact")
            }
            .foregroundColor(.blue)
        }
    }
    
    private var loadingFactView: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Generating fact...")
                .foregroundColor(.secondary)
        }
    }
    
    private var generatedFactView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Interesting Fact")
                    .font(.headline)
                Spacer()
                Button {
                    factViewModel.generateFact(for: character)
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                }
            }
            Text(factViewModel.generatedFact)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBlue).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

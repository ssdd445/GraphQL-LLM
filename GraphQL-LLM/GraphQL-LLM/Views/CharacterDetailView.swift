//
//  CharacterDetailView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    
    init(
        characterID: String,
        networkService: NetworkServiceProtocol,
        aiService: AIService
    ) {
        self._viewModel = StateObject(
            wrappedValue: CharacterDetailViewModel(
                characterID: characterID,
                networkService: networkService,
                aiService: aiService
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadCharacterDetail()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if let character = viewModel.character {
                    CharacterDetailContentView(
                        character: character,
                        aiService: viewModel.aiService
                    )
                } else {
                    Text("Character not found")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.character?.name ?? "Character")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCharacterDetail()
        }
    }
}

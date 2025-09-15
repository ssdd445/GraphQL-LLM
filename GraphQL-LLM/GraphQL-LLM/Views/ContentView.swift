//
//  ContentView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 11/09/2025.
//

import SwiftUI
import Apollo
import List

struct ContentView: View {
    @StateObject private var viewModel: CharacterListViewModel
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        aiService: AIService = OpenAIService()
    ) {
        self._viewModel = StateObject(wrappedValue: CharacterListViewModel(networkService: networkService, aiService: aiService))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading characters...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadCharacters()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    CharacterListView(
                        characters: viewModel.characters,
                        networkService: viewModel.networkService,
                        aiService: viewModel.aiService
                    )
                }
            }
            .navigationTitle("Characters")
        }
        .task {
            await viewModel.loadCharacters()
        }
    }
}

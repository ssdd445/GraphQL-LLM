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
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self._viewModel = StateObject(wrappedValue: CharacterListViewModel(networkService: networkService))
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
                        networkService: viewModel.networkService
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

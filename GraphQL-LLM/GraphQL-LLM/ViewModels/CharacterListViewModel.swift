//
//  CharacterListViewModel.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//
import List
import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [CharactersListQuery.Data.Characters.Result] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    internal let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadCharacters() async {
        isLoading = true
        errorMessage = nil
        
        do {
            characters = try await networkService.fetchCharactersList()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

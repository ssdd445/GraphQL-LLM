//
//  CharacterDetailViewModel.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import List
import Foundation

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var character: GetCharacterDetailQuery.Data.Character?
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private let characterID: String
    
    init(characterID: String, networkService: NetworkServiceProtocol) {
        self.characterID = characterID
        self.networkService = networkService
    }
    
    func loadCharacterDetail() async {
        isLoading = true
        errorMessage = nil
        
        do {
            character = try await networkService.fetchCharacterDetail(id: characterID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

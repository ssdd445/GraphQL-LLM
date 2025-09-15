//
//  Network.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//
import List
import Apollo
import Foundation

protocol NetworkServiceProtocol {
    func fetchCharactersList() async throws -> [CharactersListQuery.Data.Characters.Result]
    func fetchCharacterDetail(id: String) async throws -> GetCharacterDetailQuery.Data.Character?
}

class NetworkService: NetworkServiceProtocol {
    let apollo: ApolloClient
    
    init(apollo: ApolloClient) {
        self.apollo = apollo
    }
    
    convenience init() {
        let apollo = ApolloClient(url: ConfigService.shared.baseURL)
        self.init(apollo: apollo)
    }
    
    func fetchCharactersList() async throws -> [CharactersListQuery.Data.Characters.Result] {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: CharactersListQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    let results = graphQLResult.data?.characters?.results?.compactMap { $0 } ?? []
                    continuation.resume(returning: results)
                    
                    if let errors = graphQLResult.errors {
                        print("GraphQL errors: \(errors)")
                    }
                    
                case .failure(let error):
                    print("Network error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchCharacterDetail(id: String) async throws -> GetCharacterDetailQuery.Data.Character? {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: GetCharacterDetailQuery(id: id)) { result in
                switch result {
                case .success(let graphQLResult):
                    continuation.resume(returning: graphQLResult.data?.character)
                case .failure(let error):
                    print("Error fetching character detail: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

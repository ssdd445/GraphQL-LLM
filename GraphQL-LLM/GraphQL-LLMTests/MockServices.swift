//
//  MockServices.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 16/09/2025.
//
import List
import XCTest
@testable import GraphQL_LLM

class MockNetworkService: NetworkServiceProtocol {
    var shouldThrowError = false
    var mockCharacterDetail: GetCharacterDetailQuery.Data.Character?
    var mockCharactersList: [CharactersListQuery.Data.Characters.Result] = []
    var fetchCharacterDetailCallCount = 0
    var fetchCharactersListCallCount = 0
    var lastCharacterID: String?
    
    func fetchCharacterDetail(id: String) async throws -> GetCharacterDetailQuery.Data.Character? {
        fetchCharacterDetailCallCount += 1
        lastCharacterID = id
        
        if shouldThrowError {
            throw NetworkError.failedToFetch
        }
        
        guard let character = mockCharacterDetail else {
            throw NetworkError.noData
        }
        
        return character
    }
    
    func fetchCharactersList() async throws -> [CharactersListQuery.Data.Characters.Result] {
        fetchCharactersListCallCount += 1
        
        if shouldThrowError {
            throw NetworkError.failedToFetch
        }
        
        return mockCharactersList
    }
}

class MockAIService: AIService {
    var shouldThrowError = false
    var mockFact = "This is a generated fact"
    var generateFactCallCount = 0
    var lastPromptDescription: String?
    
    func generateFact(for promptDescription: String) async throws -> String {
        generateFactCallCount += 1
        lastPromptDescription = promptDescription
        
        if shouldThrowError {
            throw AIError.failedToGenerate
        }
        
        return mockFact
    }
}

enum NetworkError: Error, LocalizedError {
    case failedToFetch
    case noData
    
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return "Failed to fetch data"
        case .noData:
            return "No data available"
        }
    }
}

enum AIError: Error, LocalizedError {
    case failedToGenerate
    
    var errorDescription: String? {
        return "Failed to generate fact"
    }
}

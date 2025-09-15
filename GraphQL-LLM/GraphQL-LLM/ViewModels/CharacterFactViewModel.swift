//
//  CharacterFactViewModel.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 15/09/2025.
//
import List
import Foundation

@MainActor
class CharacterFactViewModel: ObservableObject {
    @Published var generatedFact: String = ""
    @Published var isGeneratingFact: Bool = false
    @Published var factError: String?
    
    private let aiService: AIService
    
    init(aiService: AIService) {
        self.aiService = aiService
    }
    
    func generateFact(for character: GetCharacterDetailQuery.Data.Character) {
        isGeneratingFact = true
        factError = nil
        
        Task {
            do {
                let fact = try await aiService.generateFact(for: character.promptDescription())
                generatedFact = fact
                isGeneratingFact = false
            } catch {
                factError = error.localizedDescription
                isGeneratingFact = false
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

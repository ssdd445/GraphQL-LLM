//
//  AIService.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 14/09/2025.
//

import Foundation

protocol AIService {
    func generateFact(for person: String) async throws -> String
}

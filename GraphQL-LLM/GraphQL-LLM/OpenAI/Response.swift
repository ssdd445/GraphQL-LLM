//
//  Response.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 15/09/2025.
//

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: Content
    }
    
    struct Content: Codable {
        let parts: [Part]
    }
    
    struct Part: Codable {
        let text: String
    }
}

//
//  OpenAIService.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 14/09/2025.
//
import Foundation

class OpenAIService: AIService {
    private let apiKey: String = ConfigService.shared.apiKey
    func generateFact(for person: String) async throws -> String {
        let url = ConfigService.shared.apiBaseURL
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-goog-api-key")
        
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "Here are some details about a person: \(person). Generate an interesting fact about them."]
                    ]
                ]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? "No body"
            throw NSError(domain: "API Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: ["body": body])
        }
        
        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let text = geminiResponse.candidates.first?.content.parts.first?.text else {
            throw NSError(domain: "Parse Error", code: 0)
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//
//  Extensions.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 14/09/2025.
//
import List
import Foundation

extension GetCharacterDetailQuery.Data.Character {
    func promptDescription() -> String {
        var components: [String] = []
        
        if let name = name {
            components.append("Name: \(name)")
        }
        
        if let status = status {
            components.append("Status: \(status)")
        }
        
        if let species = species {
            components.append("Species: \(species)")
        }
        
        if let gender = gender {
            components.append("Gender: \(gender)")
        }
        
        if let created = created {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let date = formatter.date(from: created) {
                formatter.dateStyle = .medium
                components.append("Created At: \(formatter.string(from: date))")
            }
        }
        
        return components.joined(separator: "\n")
    }
}

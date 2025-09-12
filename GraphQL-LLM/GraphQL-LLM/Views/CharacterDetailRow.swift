//
//  CharacterDetailRow.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import SwiftUI

struct CharacterDetailRow: View {
    let title: String
    let value: String?
    
    var body: some View {
        HStack {
            Text("\(title):")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value ?? "Unknown")
                .fontWeight(.medium)
        }
    }
}

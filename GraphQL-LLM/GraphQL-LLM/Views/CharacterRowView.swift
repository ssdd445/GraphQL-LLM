//
//  CharacterRowView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import List
import SwiftUI

struct CharacterRowView: View {
    let character: CharactersListQuery.Data.Characters.Result
    
    var body: some View {
        HStack {
            CharacterImageView(imageUrl: character.image)
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name ?? "Unknown")
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

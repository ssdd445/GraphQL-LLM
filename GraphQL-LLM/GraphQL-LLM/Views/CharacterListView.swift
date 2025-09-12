//
//  CharacterListView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//

import List
import SwiftUI

struct CharacterListView: View {
    let characters: [CharactersListQuery.Data.Characters.Result]
    let networkService: NetworkServiceProtocol
    
    var body: some View {
        List(characters, id: \.id) { character in
            if let characterId = character.id {
                NavigationLink(
                    destination: CharacterDetailView(
                        characterID: characterId,
                        networkService: networkService
                    )
                ) {
                    CharacterRowView(character: character)
                }
            } else {
                CharacterRowView(character: character)
                    .foregroundColor(.secondary)
            }
        }
    }
}

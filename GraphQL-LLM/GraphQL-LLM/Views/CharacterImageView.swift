//
//  CharacterImageView.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 12/09/2025.
//
import SwiftUI

struct CharacterImageView: View {
    let imageUrl: String?
    
    var body: some View {
        Group {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

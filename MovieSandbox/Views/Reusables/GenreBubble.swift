//
//  GenreBubble.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI

struct GenreBubble: View {
    var genre: Genre
    @Binding var isSelected: Bool
    var body: some View {
        Text("\(genre.name)")
            .padding()
            .background(
                Capsule()
                    .foregroundColor(isSelected ? .green.opacity(0.7) : .gray.opacity(0.5))
                    .frame(width: measureText(genre.name).width + 20, height: measureText(genre.name).height + 10)
            )
            .foregroundColor(.white)
            .onTapGesture {
                isSelected.toggle()            }
    }
}


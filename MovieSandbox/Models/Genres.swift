//
//  Genres.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation


struct Genres: Decodable {
    var genres: [Genre]
}

struct Genre: Decodable, Identifiable, Hashable {
    var id: Int
    var name: String
}

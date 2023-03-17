//
//  Movie.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation
import SwiftUI

struct MovieResponse: Decodable {
    var results: [Movie]
}

struct Movie: Decodable, Identifiable{
    
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_title: String?
    var original_language: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var vote_average: Double?
    
}



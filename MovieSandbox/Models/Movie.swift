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
    var total_pages: Int
    var total_results: Int
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



struct Credits: Decodable {
    var id: Int
    var crew: [Crew]
}

struct Crew: Decodable {
    var name: String?
    var job: String?
    
    func isDirector() -> Bool{
        if self.job == nil {
            return false
        }
        else{
            return job!.lowercased() == "director"
        }
    }
    
}


func getMovieDirector(_ movie: Movie) async -> [String] {
    
    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)/credits?api_key=\(Keys.API_KEY)&language=en-US") else{
        return []
    }
    let r = Request(url: url)
    do {
        let data = try await r.fetch()
        let creditsResponse = decode(data, type: Credits.self)
        if creditsResponse != nil{
            let directors = creditsResponse!.crew.filter { $0.isDirector()}
            print(directors)
            let x = directors.map { $0.name ?? ""}
            print("DIRECTORS FOR \(movie.title ?? "" ) are \(x)")
            return x
        }
    }
    catch{
        print("Error fetching cast for \(movie.title ?? "")")
        return []
    }
    print("FELLTRHOUGH MOVIE DIRECTOR FUNCTION")
    return []
}

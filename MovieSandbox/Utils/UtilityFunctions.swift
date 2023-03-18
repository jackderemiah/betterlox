//
//  UtilityFunctions.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation
import SwiftUI


func measureText(_ string: String) -> CGSize {
        let text = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 17)])
    let size = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size
    }


func movieFromMovieItem(_ movie: MovieItem) -> Movie {
    return Movie(poster_path: movie.poster_path, adult: movie.adult, overview: movie.overview, release_date: movie.release_date, genre_ids: (movie.genre_ids as? [Int]), id: Int(movie.id), original_title: movie.original_title, original_language: movie.original_language, title: movie.title, backdrop_path: movie.backdrop_path, popularity: movie.popularity, voteCount: nil, video: nil, vote_average: movie.vote_average)
}

func movieFromWatchlist(_ movie: Watchlist) -> Movie? {
    var movie = movie.movie as? MovieItem
    if movie != nil {
        return movieFromMovieItem(movie!)
    }else{
        print("ERROR CASTING WATCHLIST MOVIE")
        return nil
    }
    
//    return Movie(poster_path: movie.poster_path, adult: movie.adult, overview: movie.overview, release_date: movie.release_date, genre_ids: (movie.genre_ids as? [Int]), id: Int(movie.id), original_title: movie.original_title, original_language: movie.original_language, title: movie.title, backdrop_path: movie.backdrop_path, popularity: movie.popularity, voteCount: nil, video: nil, vote_average: movie.vote_average)
}

func movieFromWatched(_ movie: Watched) -> Movie? {
    var movie = movie.movie as? MovieItem
    if movie != nil {
        return movieFromMovieItem(movie!)
    }else{
        print("ERROR CASTING WATCHLIST MOVIE")
        return nil
    }
    
//    return Movie(poster_path: movie.poster_path, adult: movie.adult, overview: movie.overview, release_date: movie.release_date, genre_ids: (movie.genre_ids as? [Int]), id: Int(movie.id), original_title: movie.original_title, original_language: movie.original_language, title: movie.title, backdrop_path: movie.backdrop_path, popularity: movie.popularity, voteCount: nil, video: nil, vote_average: movie.vote_average)
}

//
//  HomeView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        NavigationView {
            
            
            VStack(alignment: .leading) {
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack {
//
//                        ForEach(vm.genres) { genre in
//
//                            GenreBubble(genre: genre, isSelected: Binding(
//                                get: {
//                                    vm.selectedGenres.contains(genre)
//                                },
//                                set: {
//                                    if $0 {
//                                        vm.selectedGenres.insert(genre)
//                                    } else {
//                                        vm.selectedGenres.remove(genre)
//                                    }
//                                }
//                            ))
//                        }
//                    }
//                }.padding(.vertical)
               
                Text("Trending").font(.title).bold().foregroundColor(.orange)
                    .padding(.bottom)
                ScrollView(showsIndicators: false){
                   
                    VStack(alignment: .leading){
                        GridView(movies: vm.trendingMovies)
//                        ForEach(vm.trendingMovies){ tM in
//                            if tM.genre_ids != nil {
//                                if vm.selectedGenres.count == 0 {
//                                    if tM.title != nil {
//                                        NavigationLink{
//                                            DetailedMovieView(movie: tM)
//                                        }label:{
//                                          // MovieRow(movie: tM)
//
//                                        }
//
//                                    }
//                                }else if tM.genre_ids!.contains(where: vm.selectedGenres.map{$0.id}.contains) {
//                                    if tM.title != nil {
//                                        NavigationLink{
//                                            DetailedMovieView(movie: tM)
//                                        }label:{
//                                            MovieRow(movie: tM)
//                                        }
//
//                                    }
//                                }
//
//
//                            }else{
//                                if tM.title != nil {
//                                    Text(tM.title!).italic()
//
//                                }
//                            }
                            
                            
                            
//                        }
                        
                        
                        
                    }.frame(alignment: .leading)
                }
                
                
                
            }
            .padding()
            
        }
        
        
    }
    
}


class HomeViewModel: ObservableObject{
    @Published var genres: [Genre] = []
    @Published var trendingMovies: [Movie] = []
    @Published var selectedGenres = Set<Genre>()
    init(){
        let k = Keys()
        Task{
          await fetchGenres()
          await getTrendingMovies()
        }
    }
    
    
    func fetchGenres() async {
        let r = Request(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Keys.API_KEY)&language=en-US")!)
        do{
           let data = try await r.fetch()
            let genres = decode(data, type: Genres.self)
            if genres != nil {
                DispatchQueue.main.async {
                    self.genres = genres!.genres
                }
                
            }
           
            
        }
        catch{
            print("Error getting genres \(error)")
            
        }
    }
    
    func getTrendingMovies() async {
        let r = Request(url: URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(Keys.API_KEY)")!)
        
        do{
           let data = try await r.fetch()
            let movieResponse = decode(data, type: MovieResponse.self)
            if movieResponse != nil {
                DispatchQueue.main.async {
                    self.trendingMovies = movieResponse!.results
                }
               
            }
            
        }
        catch{
            print("Error getting genres \(error)")
            
        }
    }
}

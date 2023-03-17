//
//  ContentView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject var homeVM = HomeViewModel()
    @State private var selection = "home"
    
    var body: some View {
        
        TabView(selection: $selection) {
            HomeView(vm: homeVM)
                .tabItem {
                    Image(systemName: "house.fill")
                       }
                       .tag("home")
                       
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                   }
                       .tag("search")
            
            Text("profile")
                .tabItem {
                    Image(systemName: "person")
                   }
                       .tag("profile")
                       
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

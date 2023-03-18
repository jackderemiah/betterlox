//
//  DetailedMovieView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI
import Foundation
import CoreData

struct DetailedMovieView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var movie: Movie
    @State var poster: UIImage? = nil
    @State var backdrop: UIImage? = nil
    @State var isLoading = false
    @State var recommendations: [Movie]? = nil
    @State var directors: [String] = []
    
    @FetchRequest(entity: Watchlist.entity(), sortDescriptors: [])
    
    private var watchlist: FetchedResults<Watchlist>
    
    @FetchRequest(entity: Watched.entity(), sortDescriptors: [])
    private var watched: FetchedResults<Watched>
    // show recommendations in a horizontal scroll view
    var body: some View {
        
        
        
        ScrollView(showsIndicators: false) {
            
            if isLoading{
                ProgressView("fetching \(movie.title ?? "") data")
            }
            else{
                VStack {
                    HStack{
                        Spacer()
                        Button{
                            if !watchlist.map{Int($0.movie!.id)}.contains(movie.id){
                                print(addItemToWatchlist(movie))
                            }else{
                                print(removeItemFromWatchlist(movie: movie))
                            }
                        }
                        label:{
                            if watchlist.map{Int($0.movie!.id)}.contains(movie.id){
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                            }else{
                                Image(systemName: "star").foregroundColor(.gray)
                            }
                            
                        }
                        
                        Button{
                            if !watched.map{Int($0.movie!.id)}.contains(movie.id){
                                print(addItemToWatched(movie))
                            }else{
                               print(removeItemFromWatched(movie: movie))
                            }
                        }
                    label: {
                        if watched.map{Int($0.movie!.id)}.contains(movie.id){
                            Image(systemName: "eye").foregroundColor(.green)
                        }else{
                            Image(systemName: "eye.slash").foregroundColor(.gray)
                        }
                    }
                    }.padding(.horizontal)
                        .padding(.bottom)
                    if movie.backdrop_path != nil{
                        if let backdrop = backdrop {
                            
                            
                            Image(uiImage: backdrop)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                            
                            
                        } else {
                            Image(systemName: "person")
                            
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.0)
                            
                                .padding(10)
                        }
                    }
                    
                    
                    HStack(alignment: .top){
                        VStack(alignment: .leading, spacing: 10){
                            Text(movie.title ?? "").font(.headline).bold()
                            if movie.release_date?.split(separator: "-").count ?? 0 > 0 {
                                Text(movie.release_date?.split(separator: "-")[0] ?? "")
                            }
                            if directors.count > 0{
                                HStack(alignment: .top){
                                    Text("directed by")
                                    ForEach(directors, id: \.self){ director in
                                        Text(director).font(.caption).bold().foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            
                           
                      
                        }
                        Spacer()
                        if poster != nil {
                            Image(uiImage: poster!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                            
                            
                        }
                        
                    }
                    .padding(10)
                    
                    if movie.overview != nil {
                        movie.overview!.isEmpty ?
                        Text("No description found.")
                            .padding(.vertical)
                        :
                        Text(movie.overview!)
                            .padding(.vertical)
                        
                    }
                    
                    Spacer()
                    VStack(alignment: .leading){
                        if recommendations != nil{
                            
                            
                            Text(recommendations!.count > 0 ? "Recommendations":
                                    "").font(.headline).bold().foregroundColor(.orange)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(recommendations!) { r in
                                        NavigationLink {
                                            DetailedMovieView(movie: r)
                                        }label:{
                                            Text(r.title ?? "").foregroundColor(.white)
                                                .padding()
                                                .background(
                                                    Capsule()
                                                        .foregroundColor(.gray.opacity(0.5))
                                                        .frame(width: measureText(r.title ?? "").width + 20, height: measureText(r.title ?? "").height + 10)
                                                )
                                            
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            .padding(.bottom, 50)
                        }
                    }
                }
            }
            
            
        }
        // ...
        
        
        .onAppear{
            isLoading = true
           
            Task{
                async let x = ImageService.downloadImage(movie.poster_path ?? "", isBackdrop: false)
                async let y = ImageService.downloadImage(movie.backdrop_path ?? "", isBackdrop: true)
                
                
                let requests = await [x,y]
                self.poster = requests[0]
                self.backdrop = requests[1]
                self.recommendations = await getRecommendations()
                self.directors = await getMovieDirector(movie)
                isLoading = false
            }
        }
        
    }
    
    func getRecommendations() async -> [Movie] {
        // https://api.themoviedb.org/3/movie/{movie_id}/recommendations?api_key=968161efed28c0e1929a6116c92f6f45&language=en-US&page=1
        if movie.id != nil {
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)/recommendations?api_key=\(Keys.API_KEY)&language=en-US&page=1")!
            
            let r = Request(url: url)
            do {
                let x = try await r.fetch()
                let results = decode(x, type: MovieResponse.self)
                if results != nil {
                    return results!.results
                }else{
                    return []
                }
                
            }catch{
                print("ERROR")
                return []
            }
        }
        else{
            return []
        }
        
    }
    
    
    private func addItemToWatchlist(_ movie: Movie) -> Bool {
        withAnimation {
            let x = MovieItem(context: viewContext)
            x.id = Int32(movie.id!)
            x.title = movie.title
            x.vote_average = movie.vote_average ?? 0.0
            x.backdrop_path = movie.backdrop_path
            x.release_date = movie.release_date
            x.poster_path = movie.poster_path
            x.genre_ids = movie.genre_ids as NSObject?
            x.overview = movie.overview
            x.popularity = movie.popularity ?? 0.0
            let y = Watchlist(context: viewContext)
            y.movie = x
            
            do {
                try viewContext.save()
                return true
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
                return false
            }
        }
    }
    
   
    private func removeItemFromWatchlist(movie: Movie) -> Bool {
       
      
        let x = watchlist.filter { Int($0.movie!.id) == movie.id}
        if x.count == 1 {
             viewContext.delete(x[0])
        }else{
            print("NO MOVIE IN WATCHLIST")
            return false
        }
        do {
            try viewContext.save()
            return true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            return false
        }
        
    }
    
    
    private func addItemToWatched(_ movie: Movie) -> Bool {
        withAnimation {
            let x = MovieItem(context: viewContext)
            x.id = Int32(movie.id!)
            x.title = movie.title
            x.vote_average = movie.vote_average ?? 0.0
            x.backdrop_path = movie.backdrop_path
            x.release_date = movie.release_date
            x.poster_path = movie.poster_path
            x.genre_ids = movie.genre_ids as NSObject?
            x.overview = movie.overview
            x.popularity = movie.popularity ?? 0.0
            let y = Watched(context: viewContext)
            y.movie = x
            
            do {
                try viewContext.save()
                return true
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
                return false
            }
        }
    }
    
    private func removeItemFromWatched(movie: Movie) -> Bool {
       
      
        let x = watched.filter { Int($0.movie!.id) == movie.id}
        if x.count == 1 {
             viewContext.delete(x[0])
        }else{
            print("NO MOVIE IN WATCHLIST")
            return false
        }
        do {
            try viewContext.save()
            return true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            return false
        }
        
    }
    
}


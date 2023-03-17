//
//  DetailedMovieView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI

struct DetailedMovieView: View {
    var movie: Movie
    @State var poster: UIImage? = nil
    @State var backdrop: UIImage? = nil
    @State var isLoading = false
    @State var recommendations: [Movie] = []
    
    // show recommendations in a horizontal scroll view
    var body: some View {
        
        
        ScrollView {
            
            if isLoading{
                ProgressView("fetching movie data just for you.. hang tight")
            }
            else{
                VStack {
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
                            Text(movie.release_date?.split(separator: "-")[0] ?? "")
                            
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
                    Text("Recommendations").font(.headline).bold().foregroundColor(.orange)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(recommendations) { r in
                                
                                Text(r.title ?? "")
                            }
                        }
                      
                    }
                }
            }
           
        }
            // ...
       
            
                .onAppear{
                    isLoading = true
                    print("ROUNDED \(floor(movie.vote_average ?? 0.0 * 10) / 10)")
                    Task{
                        async let x = ImageService.downloadImage(movie.poster_path ?? "", isBackdrop: false)
                        async let y = ImageService.downloadImage(movie.backdrop_path ?? "", isBackdrop: true)
                        
                        
                        let requests = await [x,y]
                        self.poster = requests[0]
                        self.backdrop = requests[1]
                        self.recommendations = await getRecommendations()
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
    }


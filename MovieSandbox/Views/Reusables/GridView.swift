//
//  GridView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/17/23.
//

import SwiftUI

struct GridView: View {
    let movies: [Movie]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
//        NavigationView{
            
      
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink {
                        DetailedMovieView(movie: movie)
                    }label:{
                        GridMoviePicture(movie: movie)
                    }
                  
                }
            }
        }
//        }
    }
        
}


struct GridMoviePicture: View {
    let movie: Movie
    @State var image: UIImage? = nil
    
    var body: some View{
        VStack{
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
            else{
                Image(systemName: "person")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .opacity(0.0)
            }
              
       
        }
        .onAppear{
            Task{
                
                self.image = await ImageService.downloadImage(movie.poster_path ?? "", isBackdrop: false)
            }
        }
         
    }
    
      
}

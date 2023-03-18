//
//  MovieRow.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI

struct MovieRow: View {
    var movie: Movie
    @State var poster: UIImage? = nil
    var body: some View {
        HStack{
            if poster != nil{
                Image(uiImage: poster!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
            }else{
                Image(systemName: "person")
                    
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .opacity(0.0)
                    .padding(.trailing)
            }
           
            Text(movie.title ?? "").bold().foregroundColor(.gray.opacity(0.95))
            
        }.padding()
           
            
        .onAppear{
            Task{
                self.poster = await ImageService.downloadImage(movie.poster_path ?? "", isBackdrop: false)
            }
        }
    }
}

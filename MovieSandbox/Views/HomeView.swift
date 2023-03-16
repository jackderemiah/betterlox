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
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(vm.genres) { genre in
                        
                        GenreBubble(genre: genre, isSelected: Binding(
                                                   get: {
                                                       vm.selectedGenres.contains(genre)
                                                   },
                                                   set: {
                                                       if $0 {
                                                           vm.selectedGenres.insert(genre)
                                                       } else {
                                                           vm.selectedGenres.remove(genre)
                                                       }
                                                   }
                                               ))
                        
                    }
                }
            }
            
            
            VStack(alignment: .leading){
                Text("Trending movies").font(.title).bold()
                
                ForEach(vm.trendingMovies){ tM in
                    if tM.genre_ids != nil {
                        if vm.selectedGenres.count == 0 {
                            if tM.title != nil {
                                Text(tM.title!).italic()
                               
                            }
                        }else if tM.genre_ids!.contains(where: vm.selectedGenres.map{$0.id}.contains) {
                                if tM.title != nil {
                                    Text(tM.title!).italic()
                                   
                                }
                            }
                        
                       
                    }else{
                        if tM.title != nil {
                            Text(tM.title!).italic()
                            
                        }
                    }
                   
                   
                    
                }
                
                
                
            }
            Spacer()
            
        }
        .padding()
    }
    
   
    }

   


//
//  SearchView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm = SearchViewModel()
    @State var searchText: String = ""
    var body: some View {
        
            NavigationView{
                ScrollView{
                
                HStack{
                    SearchBox(searchText: $searchText)
                    Button{
                        Task{
                            await vm.search(searchText)
                        }
                    }label: {
                        Image(systemName: "paperplane.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                
                VStack(alignment: .leading){
                    if !vm.isloading {
                        ForEach(vm.results){ movie in
                            if movie.title != nil {
                                NavigationLink{
                                    DetailedMovieView(movie: movie)
                                }label:{
                                    MovieRow(movie: movie)
                                       
                                }
                                
                            }
                                
                        }
                    }else{
                        ProgressView().frame(width: 50, height: 50)
                    }
                    
                }.frame(width: UIScreen.main.bounds.size.width * 0.95)
                
            }
        }
    }
     
    
}

class SearchViewModel: ObservableObject {
    @Published var results: [Movie] = []
    @Published var isloading: Bool = false
    func search(_ text: String) async {
        var text = text
        if text.isEmpty {
            return
        }
        DispatchQueue.main.async {
            self.isloading = true
        }
        let components = text.split(separator: " ")
        print(components)
       
        if components.count > 1 {
            text = components.joined(separator: "+")
        }
        
       guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Keys.API_KEY)&language=en-US&query=\(text)")
            
        else{
           return
       }
        
        let r = Request(url: url)
        do{
            
           let data = try await r.fetch()
            let movieResponse = decode(data, type: MovieResponse.self)
            if movieResponse != nil {
                DispatchQueue.main.async {
                    
                    self.results = movieResponse!.results
                    self.isloading = false
                }
                
            }else{
                print("response was empty")
                self.results = []
                self.isloading = false
            }
            
        }
        catch{
            print("Error getting search results \(error)")
            self.results = []
        }
    }
    
}

struct SearchBox: View {
    @Binding var searchText: String
    var body: some View {
        ZStack(alignment:.topLeading) {
            Rectangle()
                .foregroundColor(Color(uiColor: .darkGray).opacity(0.5))
                .frame(width: 200, height: 50)
                .cornerRadius(10)
            TextField("Search movies", text: $searchText)
                .padding()
                .frame(maxWidth: 200)
        }

    }
   
}

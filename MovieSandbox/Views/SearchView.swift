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
            
      
                VStack(alignment: .leading){
                    
                    
                    ScrollView{
                        
                        HStack{
                            SearchBox(searchText: $searchText, callback: { await vm.search(searchText) } )
                            Button{
                                Task{
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    await vm.search(searchText)
                                   
                                }
                            }label: {
                                Image(systemName: "paperplane.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.orange)
                                    .padding(.bottom)
                            }
                        }
                        
//                        List {
                           
                                VStack(alignment: .leading){
                                    ForEach(vm.results) { movie in
                                   
                                        NavigationLink {
                                            DetailedMovieView(movie: movie)
                                        }label:{
                                            MovieRow(movie: movie)
                                        }
                                        
                                   
                                }
                             
                            }
                            .frame(maxWidth: .infinity)
                           
//                        }
                        GeometryReader { reader -> Color in
                                                let minY = reader.frame(in: .global).minY
                                                let height = UIScreen.main.bounds.height
                            if minY < height && vm.results.count > 0{
                                                    // Load more items
                                                    print("REACHED THE BOTTOM OF THE SCROLL VIEW, load more")
                                                }
                                                return Color.clear
                                            }
                                            .frame(height: 1)
                    }
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
        print("URL \(url)")
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
    var callback: () async -> Void
    var body: some View {
        ZStack(alignment:.topLeading){
            Rectangle()
                .fill(Color(uiColor: .darkGray).opacity(0.5))
               
            HStack{
                Image(systemName: "magnifyingglass.circle")
                    .foregroundColor(Color(.darkGray))
                TextField("Search movies",text: $searchText)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                    .onSubmit {
                        Task {
                            await callback()
                        }
                       
                    }
                if searchText.count > 0 {
                    Button{
                        searchText = ""
                    }label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(.darkGray))
                        
                    }
                }else{
                    Button{
                        print("")
                    }label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(.clear))
                        
                    }
                }
                
                
                
            }.padding()
                .zIndex(1)
            
        }.frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
            .padding(.bottom, 20)


    }
   
}


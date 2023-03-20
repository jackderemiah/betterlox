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
    @State var fetchingMoreMovies: Bool = false
    var body: some View {
        
        NavigationView{
            
      
                VStack(alignment: .leading){
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
                    
                    ScrollView{
                        
                      
                        
//                        List {
                           
                                VStack(alignment: .leading){
                                    ForEach(vm.results) { movie in
                                   
                                        NavigationLink {
                                            DetailedMovieView(movie: movie)
                                        }label:{
                                            MovieRow(movie: movie)
                                        }
                                        
                                   
                                }
                                    if fetchingMoreMovies{
                                        ProgressView("fetching more movies ...")
                                            .frame(alignment: .centerLastTextBaseline)
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
                                
                                                Task{
//                                                    DispatchQueue.main.async {
                                                        if vm.page < vm.total_pages{
                                                            fetchingMoreMovies = true
                                                            
                                                            await vm.searchNewPage(searchText)
                                                            fetchingMoreMovies = false
                                                        }else{
                                                            print("FINAL PAGE!")
                                                            fetchingMoreMovies = false
                                                        }
                                                        
//                                                    }
                                                   
                                                }
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
    @Published var page: Int = 1
    @Published var total_pages: Int = 1
    @Published var query: String = ""
    @Published var newQuery: Bool = false
    func search(_ text: String) async {
        
        var text = text
       
        if text.isEmpty {
            return
        }
        
        DispatchQueue.main.async {
            self.isloading = true
            self.page = 1
        }
        
        var components = text.split(separator: " ")
        components = components.filter{$0 != " " || $0 != ""}
        print(components)
       
        if components.count > 1 {
            text = components.joined(separator: "+")
        }
        
       guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Keys.API_KEY)&language=en-US&query=\(text)&page=\(1)")
           
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
                    self.total_pages = movieResponse!.total_pages
                    self.results = movieResponse!.results
                    self.isloading = false
                }
                
            }else{
                DispatchQueue.main.async {
                    print("response was empty")
                    self.results = []
                    self.isloading = false
                }
               
            }
            
        }
        catch{
            print("Error getting search results \(error)")
            self.results = []
            self.isloading = false
        }
    }
    
    
    func searchNewPage(_ text: String) async {
        var text = text
       
        if text.isEmpty {
            return
        }
         
       
       
        DispatchQueue.main.async {
            self.isloading = true
            self.page += 1
            print("PAGE \(self.page)")
            if self.page > self.total_pages {
                print("hit the last page!")
                
                self.isloading = false
                
                return
            }
        }
        
       
        
        let components = text.split(separator: " ")
        print(components)
       
        if components.count > 1 {
            text = components.joined(separator: "+")
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Keys.API_KEY)&language=en-US&query=\(text)&page=\(self.page)")
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

                    if self.page > 1{
                        print(movieResponse!.results.count)
                      
                        let count = self.results.filter { movie in
                            movieResponse?.results.map { $0.id }.contains(movie.id) ?? false
                        }.count
                        
                       
                        if count == 0 {
                            self.results.append(contentsOf: movieResponse!.results)
                        }
                       
                        self.isloading = false
                    }else{
                        self.results = movieResponse!.results
                        self.isloading = false
                    }
                   
                }
                
            }else{
                DispatchQueue.main.async {
                    print("response was empty")
                    self.results = []
                    self.isloading = false
                }
               
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
                .cornerRadius(12)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.04)
                .padding(.top, 10)
               
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


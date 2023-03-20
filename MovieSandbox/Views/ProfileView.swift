//
//  ProfileView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/17/23.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: MovieItem.entity(), sortDescriptors: [])
    
    private var movies: FetchedResults<MovieItem>
   
    var body: some View {
        NavigationView {
            
        
        VStack(alignment: .leading){

        WatchListView()
            
        WatchedView()
        }.frame(maxWidth: .infinity)
            .padding()
        }
    }
    

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { movies[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItem(movie: MovieItem) {
       
            viewContext.delete(movie)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
       
    }
}


struct WatchListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Watchlist.entity(), sortDescriptors: [])
    private var watchlistMovies: FetchedResults<Watchlist>
    var body: some View{
        Text("Watchlist").font(.title).bold().foregroundColor(.orange)
            .padding(.bottom)
        List {
            ForEach(watchlistMovies) { movie in
               
                NavigationLink{
                    DetailedMovieView(movie: movieFromWatchlist(movie)!)
                }label:{
                    HStack{
                        MovieRow(movie: movieFromWatchlist(movie)!)
                    }
                }
               
               
                
            }
            .onDelete(perform: deleteItems)
        }
        



       
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { watchlistMovies[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct WatchedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Watched.entity(), sortDescriptors: [])
    private var watched: FetchedResults<Watched>
    var body: some View{
       
            
        
        Text("Watched").font(.title).bold().foregroundColor(.orange)
            .padding(.bottom)
        List {
            ForEach(watched) { movie in
               
                NavigationLink{
                    Text("Write a review for \(movieFromWatched(movie)?.title ?? "")")
                }label: {
                    HStack{
                        MovieRow(movie: movieFromWatched(movie)!)
                    }
                }
              
               
                
            }
            .onDelete(perform: deleteItems)
        }
        



     
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { watched[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

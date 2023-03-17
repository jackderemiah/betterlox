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
    @State var movieNatives: [Movie] = []
    var body: some View {
        
        List {
            ForEach(movies) { movie in
               
                
                HStack{
                    MovieRow(movie: movieFromMovieItem(movie))
                }
               
                
            }
            .onDelete(perform: deleteItems)
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

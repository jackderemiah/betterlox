//
//  ContentView.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var homeVM = HomeViewModel()
    @State private var selection = "home"
    
    var body: some View {
        
        TabView(selection: $selection) {
            HomeView(vm: homeVM)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle")
                       }
                       .tag("home")
                       
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                   }
                       .tag("search")
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                   }
                       .tag("profile")
                       
        }
     
       
    }
        
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

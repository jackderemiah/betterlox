//
//  MovieSandboxApp.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import SwiftUI
import Foundation
import CoreData

@main
struct MovieSandboxApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

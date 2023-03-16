//
//  Keys.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation

import Foundation

// Load environment variables from the .env file
class Keys {
   static var API_KEY: String = ""
    init() {
        
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil),
                  let env = try? String(contentsOf: url) else {
                      fatalError("Failed to load .env file")
                  }
        
        // Parse the environment variables into a dictionary
        let envDict = env
            .split(separator: "\n")
            .compactMap { line -> (String, String)? in
                let parts = line.split(separator: "=")
                guard parts.count == 2 else { return nil }
                return (String(parts[0]), String(parts[1]))
            }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }
        
        // Access individual environment variables
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"]
        Keys.API_KEY = String(envDict["API_KEY"]!)
    }
}

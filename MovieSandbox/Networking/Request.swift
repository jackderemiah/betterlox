//
//  Request.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation


enum RequestError: Error{
    case network
    case response
    case other
}
struct Request {
    var url: URL
    
    func createRequest() -> URLRequest{
        let x = URLRequest(url: self.url)
        
        return x
    }
    
    func fetch() async throws -> Data {
        let r = self.createRequest()
        let (data, response) = try await URLSession.shared.data(for: r)
        guard let response = response as? HTTPURLResponse else { throw RequestError.response }
        
        return data
    }
    
}

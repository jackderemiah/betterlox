//
//  Decoding.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation



func decode<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        
        do {
            let x = try JSONDecoder().decode(T.self, from: data)
            return x
        }
        catch{
            print("ERROR decoding \(error)")
            return nil
        }
        
        
}


func encode<T: Codable>(_ value: T) -> Data? {
    do {
        let x = try JSONEncoder().encode(value)
        return x
    }
    catch{
        print("ERROR encoding \(error)")
        return nil
    }
}

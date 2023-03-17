//
//  ImageService.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation
import SwiftUI

var cache = NSCache<AnyObject, AnyObject>()
class ImageService {
    
    static let BACKDROP_BASE_URL: String = "https://image.tmdb.org/t/p/original"
    static let POSTER_BASE_URL: String = "https://image.tmdb.org/t/p/w500"
   
    static func downloadImage(_ path: String, isBackdrop: Bool) async -> UIImage? {
        if path.isEmpty {
            return nil
        }
        
        var urlString = ""
        
        if isBackdrop {
            urlString = BACKDROP_BASE_URL+path
           
        }else{
            urlString = POSTER_BASE_URL + path
        }
      
        guard let url = URL(string: urlString) else {
            print("image was nil")
                  return nil
        }
        let x = cache.object(forKey: path as AnyObject)
        
        if x != nil{
            print("pulling \(path) from cache")
            return UIImage(data: x as! Data)
        }
        print("FETCHING ! \(urlString)")
        let r = Request(url: url)
        do {
            let data = try await r.fetch()
            let image = UIImage(data: data)
            cache.setObject(data as AnyObject, forKey: path as AnyObject)
            return image
        }catch{
            print("error getting image")
            return nil
        }
    }
    
    
    
    
}

//
//  ImageCacheManager.swift
//  TipTap
//
//  Created by Toqsoft on 29/02/24.
//
import UIKit

class ImageLoader {
    
    static let shared = ImageLoader() // Singleton instance
    
    private init() {} // Private initializer to enforce singleton pattern
    
    private let cache = NSCache<NSURL, UIImage>() // Cache for storing images
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if image is cached
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
          //  print("Image loaded from cache")
            return
        }
        
        // If not cached, download image
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                // Cache image
                self.cache.setObject(image, forKey: url as NSURL)
                completion(image)
            //    print("Image downloaded and cached")
            } else {
                print("Failed to create image from data")
                completion(nil)
            }
        }.resume()
    }
}


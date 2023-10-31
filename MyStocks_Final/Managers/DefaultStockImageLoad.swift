//
//  DefaultStockImageLoad.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 20.09.2023.
//

import UIKit

protocol ImageLoadProtocol: AnyObject {
    func fetchImage(urlString: String) async throws -> UIImage?
}

let imageCache = NSCache<AnyObject, AnyObject>()

final class DefaultStockImageLoad: UIImageView, ImageLoadProtocol {
    func fetchImage(urlString: String) async throws -> UIImage? {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return imageFromCache
        }

        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as AnyObject)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
                    return image
                }
            } catch {
                print("couldn't load image from URL string: \(urlString), error: \(error)")
            }
        } else {
            print("Invalid URL string: \(urlString)")
        }
        
        return nil
    }
}

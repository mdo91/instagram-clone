//
//  CustomImageView.swift
//  instegramClone
//
//  Created by Mdo on 10/02/2021.
//

import Foundation
import UIKit
var imageCache = [String: UIImage]()

class CustomImageView:UIImageView{
    
    func loadImage(with urlString:String){
        
        
        var lastImageUrlUsedToLoadImage:String?
        
        //set image to nil
        
        self.image = nil
        
        lastImageUrlUsedToLoadImage = urlString
        
     
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error{
                print("loadImage.error \(error.localizedDescription)")
            }
            
            if lastImageUrlUsedToLoadImage != url.absoluteString{
                return
            }
            
            guard let data = data else{ return}
            
            let photoImage = UIImage(data: data)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async { [weak self] in
               
                self?.image = photoImage
            }
            
        }).resume()
    }
}

//
//  Extensions.swift
//  instegramClone
//
//  Created by Mdo on 10/01/2021.
//

import Foundation
import UIKit
import FirebaseDatabase

extension UIColor{
    static func rgb(red:CGFloat,green: CGFloat, blue: CGFloat)-> UIColor{
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
extension UIView{
    
    
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                bottom:NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop:CGFloat,
                paddingLeft:CGFloat,
                paddingBottom:CGFloat,
                paddingRight:CGFloat,
                width:CGFloat,
                height:CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        
        }
        
        if width != 0 {
            
            widthAnchor.constraint(equalToConstant: width).isActive = true
         
        }
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension UIImageView{
    

    func loadImage(for url: String){
        self.image = nil
        if let cachedImage = imageCache[url]{
            self.image = cachedImage
            return
        }
        
        let urlFireBase = URL(string: url)!
        
        DispatchQueue.global().async {
          //  self.image = nil
            let data = try? Data(contentsOf: urlFireBase)
            let image = UIImage(data: data!)
           
            
            DispatchQueue.main.async { [weak self] in
  
                self?.image = image
                
            }
            
        }
    }
    
}
extension Database{
    static func fetchUser(with uid: String, completion: @escaping (User)->()){
        
        USER_REF.child(uid).observeSingleEvent(of: .value) { (dataSnap) in
            // there we do action
            
            guard let dictionary  = dataSnap.value as? Dictionary<String,AnyObject> else{
                return
            }
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    static func fetchPost(with postId: String, completionHandler: @escaping (Post) -> Void){
        
        POSTS_REF.child(postId).observeSingleEvent(of: .value) { (dataSnap) in
            
            print("============================================")
            print("\(postId)")
            print("============================================")
            
            guard let dictionary = dataSnap.value as? Dictionary<String,AnyObject> else{
                return
            }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in
                
                let post = Post(postId: postId, user: user, dictonary: dictionary)
                
                completionHandler(post)
            }
            
            
        }
   
    }
}

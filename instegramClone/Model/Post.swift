//
//  Post.swift
//  instegramClone
//
//  Created by Mdo on 09/02/2021.
//

import Foundation



struct Post:Hashable{

    
    
    var caption:String!
    var likes:Int!
    var imageURL:String!
    var ownerUid:String!
    var creationDate:Date!
    var postId:String
    var user: User?
    
    init(postId:String, user: User, dictonary:Dictionary<String,AnyObject>) {
        
        self.user = user
        
        self.postId = postId
        
        if let caption = dictonary["caption"] as? String{
            self.caption = caption
        }
        
        if let likes = dictonary["likes"] as? Int{
            self.likes = likes
        }
        
        if let imageURL = dictonary["imageURL"] as? String{
            self.imageURL = imageURL
        }
        
        if let ownerUid = dictonary["ownerUid"] as? String{
            self.ownerUid = ownerUid
        }
        
        if let creationDate = dictonary["creationDate"] as? Double{
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        
    }
    
}
extension Post{
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.postId == rhs.postId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.postId)
    }
}

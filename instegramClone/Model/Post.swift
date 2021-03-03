//
//  Post.swift
//  instegramClone
//
//  Created by Mdo on 09/02/2021.
//

import Foundation
import FirebaseAuth


class Post: Equatable{

    
    
    var caption:String!
    var likes:Int!
    var imageURL:String!
    var ownerUid:String!
    var creationDate:Date!
    var postId:String
    var user: User?
    var didLike = false
  //  var likeStatus = Like(didLike: false)
  
    
    
    
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
    
    func adjustLikes(addLike:Bool, completionHandler: @escaping (Int)->()){
        print("likes \(likes!)")
        guard let currentUid = Auth.auth().currentUser?.uid else { return}
        
        if addLike{

            // update user-likes structure
            
            USER_LIKES_REF.child(currentUid).updateChildValues([postId:1]) { (error, dbRef) in
                
                // update post-like structrue
                self.sendNotificationToServer()
                
                POSTS_LIKES_REF.child(self.postId).updateChildValues([currentUid:1]) { (error, dbRef) in
                    
                    self.likes = self.likes + 1
                    self.didLike = true
                    
                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                    completionHandler(self.likes)
                }
            }

        }else{
            
            USER_LIKES_REF.child(currentUid).child(self.postId).observeSingleEvent(of: .value) { (dataSnapShot) in
               
                
                var notificationID = "1"
                
                if let notificationId = dataSnapShot.value as? String{
                    notificationID = notificationId
                }
                
               // guard let notificationId = dataSnapShot.value as? String else{ return }
                
                NOTIFICATIONS_REF.child(self.ownerUid).child(notificationID).removeValue { (error, dataBaseRef) in
                    

                    USER_LIKES_REF.child(currentUid).child(self.postId).removeValue { (error, dbRef) in
                        
                        POSTS_LIKES_REF.child(self.postId).child(currentUid).removeValue { (error, dbRef) in
                            
                            guard self.likes > 0 else{ return }
                            self.likes = self.likes - 1
                            self.didLike = false
                            
                            POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                            completionHandler(self.likes)
                            
                        }
                        
                    }
                }
            }

        }
        
   
    }
    
    private func sendNotificationToServer(){
        
     guard let currentUid = Auth.auth().currentUser?.uid else{ return }
        
        // notification values
        
        if currentUid != self.ownerUid{
            
            let creationDate = Int(NSDate().timeIntervalSince1970)
            
            let values = ["checked":0,
                          "creationDate":creationDate,
                          "uid":currentUid,
                          "type":LIKE_INT_VALUE,
                          "postId":self.postId] as [String : Any]
            
            print("sendLikeNotificationToserver \(values)")
            // notification database ref
            let notificationRef = NOTIFICATIONS_REF.child(self.ownerUid).childByAutoId()
            
            // upload notification values to database
            
            notificationRef.updateChildValues(values) { (error, dbRef) in
                USER_LIKES_REF.child(currentUid).child(self.postId).setValue(notificationRef.key)
            }
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

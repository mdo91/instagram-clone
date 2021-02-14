//
//  User.swift
//  instegramClone
//
//  Created by Mdo on 13/01/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
public class User{
    
    var userName: String!
    var name:String!
    var profileImageUrl: String!
    var uid: String!
    
    var isfollowed = false
   // var isUnFollowed = false
    
    init(uid:String,dictionary: Dictionary<String,AnyObject>) {
        
        if let username = dictionary["username"] as? String{
            self.userName = username
        }
        
        if let name = dictionary["name"] as? String{
            self.name = name
        }
        
        if let profileImageUrl = dictionary["profileImageURL"] as? String{
            self.profileImageUrl = profileImageUrl
        }
        
        
        
        self.uid = uid
    }
    
    
    
    //MARK: - follow
    
    public func follow(){
        
        //user ID
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = self.uid else { return }
        
        self.isfollowed = true
        
        // add followed user to current user
        
        Database.database().reference().child("user-following").child(currentUser).updateChildValues([uid:1])
        
        // add current user to followed-user (object)
        
        Database.database().reference().child("user-followers").child(uid).updateChildValues([currentUser:1])
        
        //TODO: add notifications
        
        // add followed user posts to home screen
        
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { (dataSnap) in
            // there we update the values
            
            let postId = dataSnap.key
            
            USER_FEED_REF.child(currentUser).child(postId).updateChildValues([postId:1])
        }
        
        
        
        
        
        //retrive data
    }
    
    //MARK: - unfollow
    
    public func unfollow(){
        //user ID
        print("User.unfollow")
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = self.uid else { return }
        
        self.isfollowed = false
        print("unfollow.uid \(uid)")
        print("currentUser.id \(currentUser)")
        Database.database().reference().child("user-following").child(currentUser).child(uid).removeValue()
       
        Database.database().reference().child("user-followers").child(uid).child(currentUser).removeValue()
          
        
      //  USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
        
      //  USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue()
        
        
        // remove followed Users posts from feed
        
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { (dataSnapt) in
            //
            let postId = dataSnapt.key
            
            USER_FEED_REF.child(currentUser).child(postId).removeValue()
        }
        
        
    }
    
    
    func checkIfUserFollowed(completion: @escaping (Bool) -> ()){
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("user-following").child(currentUser).observeSingleEvent(of: .value) { (dataSnap) in
            //
            print("checkIfUserFollowed. user \(String(describing: self.uid))")
            print("checkIfUserFollowed.dataSpan \(dataSnap)")
            if dataSnap.hasChild(self.uid){
                self.isfollowed  = true
                completion(true)
                print("checkIfUserFollowed.followed")
            }else{
                
                self.isfollowed = false
                completion(false)
                print("checkIfUserFollowed.unfollowed")
            }
        }
        
    }
    
}

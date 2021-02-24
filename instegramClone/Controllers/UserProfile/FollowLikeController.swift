//
//  FollowController.swift
//  instegramClone
//
//  Created by Mdo on 16/01/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "FollowCell"
class FollowLikeController: UITableViewController, FollowCellDelegate {

    

    
    //MARK- properties
    enum ViewingMode:Int{
        
        case Following
        case Followers
        case Likes
        
        init(index: Int) {
            
            switch index {
            case 0: self = .Following
            case 1: self = .Followers
            case 2: self = .Likes
            
            default: self = .Following
                
            }
        }
    }
    
    var userData:[User?] = [User?]()
    var user:User?
    var viewMode:ViewingMode!
    var postId: String?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowLikeCell.self, forCellReuseIdentifier: reuseIdentifier)
      //   tableView.allowsSelection = false
        navigationBarTitleConfig()
        tableView.separatorColor = .clear
        retrieveUsers(by:self.viewMode)
    }
    
    
    
    //MARK: - UITableView delegates
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowLikeCell
        if let user = userData[indexPath.row]{
            
            cell.user = user
            cell.delegate = self
        }
        cell.isUserInteractionEnabled = true
        cell.selectionStyle  = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userData[indexPath.row]
        
        let profileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profileController.user = user
        profileController.searchUser = true
        print("user name \(String(describing: user?.name)) \(String(describing: user?.uid))")
        navigationController?.pushViewController(profileController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    
    
    //MARK: - navBar title configurations
    
    private func navigationBarTitleConfig(){
        
        switch viewMode {
        case .Followers: self.navigationItem.title = "Followers"
        case .Following: self.navigationItem.title = "Following"
        case .Likes: self.navigationItem.title = "Likes"
        default: break
        }

        
    }
    
    
    //MARK: - retrieve users
    
    private func retrieveUsers(by viewMode: ViewingMode){
        var userID = ""
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        userID = currentUser
        let ref: DatabaseReference! = getDatabaseReference()
        
        if let userId = user?.uid{
            userID = userId
        }
        
        switch viewMode {
        case .Followers, .Following:
                
                ref.child(userID).observeSingleEvent(of: .value) { (snapShot) in
                    guard let allObjects = snapShot.children.allObjects as? [DataSnapshot] else { return }
                    allObjects.forEach { (data) in
                        let uid = data.key
                        self.fetchUser(with: uid)
                    }
                }
            
        case .Likes:
            
            guard let postId = self.postId else { return }
            
            ref.child(postId).observe(.childAdded) { (dataSnap) in
               
                let uid = dataSnap.key
                self.fetchUser(with: uid)
 
            }
        
        }

     
    }
    
    private func getDatabaseReference() -> DatabaseReference?{
        switch self.viewMode {
        case .Followers: return Database.database().reference().child("user-followers")
        case .Following: return Database.database().reference().child("user-following")
        case .Likes: return Database.database().reference().child("post-likes")
        default: return nil
        }
    }
    
    //MARK: - helpers
    
    private func fetchUser(with uid:String){
        Database.fetchUser(with: uid) { (user) in
            print(user)
            self.userData.append(user)
            self.tableView.reloadData()
            
        }
    }
    
    
    //MARK: - handleFollowTappedDelegate
    
    func handleFollowTappedDelegate(for cell: FollowLikeCell) {
        print("handleFollowTappedDelegate")
        
        guard let user = cell.user else {
            return
        }
        
        if user.isfollowed {
            print("user.isfollowed")
            user.unfollow()
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }else{
            print("user unfollowed")
            user.follow()
            
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.backgroundColor = .white
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
}

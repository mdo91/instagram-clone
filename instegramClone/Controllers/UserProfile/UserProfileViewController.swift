//
//  UserProfileViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"
class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate  {

    
    
   
    
    //MARK: - vars & outlets
    
    var user: User?{
        didSet{
           // print("user \(String(describing: user?.uid))")
        }
    }
    
    var posts = [Post]()
    
    var searchUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
         print("UserProfileViewController.viewDidLoad")

        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: UserPostCell.reuseIdentifier)
        
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
       

        self.collectionView.backgroundColor = .white
        
        configureUserData()
        
        fetchPosts(completed: {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionView.reloadData()
            }
        })


        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.posts.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostCell.reuseIdentifier, for: indexPath) as? UserPostCell else{
            fatalError("could not init \(UserPostCell.self)")
        }
    
        // Configure the cell
        cell.photoImageView.image = nil
        cell.post = self.posts[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ( view.frame.width - 2 ) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        
        header.delegate = self
        header.user = self.user
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feedController = FeedCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.singlePost = true
        feedController.post = self.posts[indexPath.item]
        navigationController?.pushViewController(feedController, animated: true)
        
    }
    

    
    
    //MARK: - fetch user posts
    
    private func fetchPosts(completed: @escaping ()-> Void ){
        
        var uid: String!
        if let user = user{
            uid = user.uid
        }else{
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            uid = currentUid
        }
        
       postsCount(for: uid) { (count) in
       
        self.posts = [Post]()
        
       
        USER_POSTS_REF.child(uid).observe(.childAdded) { (data) in
            //
           
            let postId = data.key

            POSTS_REF.child(postId).observeSingleEvent(of: .value) { [weak self](data) in
               
                
                Database.fetchPost(with: postId) { [weak self] (post) in
                   
                    if let posts = self?.posts, posts.contains(post){
                        print("post postDate \(post.postId ) \( posts.contains(post))")
                        
                    }else{
                        self?.posts.append(post)
                    }
                            
                    self?.posts.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate > post2.creationDate
                    })

                    if self?.posts.count == count  {
                            
                            completed()
                        }
                    }
                }
        }
        
       }
       
    }
    
    //MARK: - return posts count
    
    private func postsCount(for uid:String, completion: @escaping (Int)-> Void){
        
       // self.posts = [Post]()
        USER_POSTS_REF.child(uid).observe(.value) { (data) in
            

            completion(data.children.allObjects.count)
            
        }
    }
    
    //MARK: - retieveUserData
    
    private func retieveUserData(){
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { [weak self] snapData in
            
           // print("snapData \(snapData.value.debugDescription)")
         
            
            guard let `self` = self else { return }
            
            guard let dictionary = snapData.value as? Dictionary<String,AnyObject> else { return }
            let uid = snapData.key
            
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
          //  print("user image profile  \(user.profileImageUrl)")
           
            self.navigationItem.title = user.userName!
            self.collectionView.reloadData()
        }
        
    }
    
    //MARK: - configureUserDara
    
    private func configureUserData(){
        if !searchUser{
            retieveUserData()
        }else{
            self.navigationItem.title = self.user?.userName
            print("configureUserData.user.uid \(String(describing: user?.uid))")
           // self.collectionView.reloadData()
        }
        
    }
    
    
    
    
    //MARK: - protocol header delegates
    
    func handleEditFollowTapped(for header: UserProfileHeader) {
        
        
        if header.editProfileButton.titleLabel?.text == "Edit Profile"{
            // present edit profile
        }else{
            //handle user follow/unfollow
            
            if header.editProfileButton.titleLabel?.text == "Follow"{
                header.editProfileButton.setTitle("Following", for: .normal)
                header.user?.follow()
            }else {
                
                header.editProfileButton.setTitle("Follow", for: .normal)
                header.user?.unfollow()
            }
        }
        
    }
    
    func setUserStats(for header: UserProfileHeader) {
     //   print("setUserStats")
        var numberOfFollowers: Int!
        var numberOfFollowing:Int!
        
        //user-followers
        
        guard let uid = header.user?.uid else { return}
        
        // get number of followers
        
        Database.database().reference().child("user-followers").child(uid).observeSingleEvent(of:.value) { (dataSnap) in
            //
            
         //   print("dataSnap 222 \(dataSnap)")
            if let dataSnap = dataSnap.value as? Dictionary<String,AnyObject> {
                numberOfFollowers = dataSnap.count
            }else{
                numberOfFollowers = 0
                
            }
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers!)\n",
                                                    attributes: [NSAttributedString.Key.font:
                                                                UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSMutableAttributedString(string: "followers",
                                                            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor :
                                                                            UIColor.lightGray]))
            
            header.followersLable.attributedText = attributedText
        }

        Database.database().reference().child("user-following").child(uid).observeSingleEvent(of: .value) { (dataSnap) in
           // print("user-following.dataSnap \(dataSnap)")
            if let dataSnap = dataSnap.value  as? Dictionary<String,AnyObject>{
                numberOfFollowing = dataSnap.count
            }else{
                numberOfFollowing = 0
            }
            
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n",
                                                    attributes: [NSAttributedString.Key.font:
                                                                UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSMutableAttributedString(string: "following",
                                                            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor :
                                                                            UIColor.lightGray]))
            
            header.followingLable.attributedText = attributedText
        }
        
        postsCount(for: uid) { (count) in
            
            let attributedText = NSMutableAttributedString(string: "\(count)\n",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSMutableAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor :UIColor.lightGray]))
            
            header.postsLable.attributedText = attributedText
            
        }
}
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        
        print("handleFollowersTapped...")
        
        let followController = FollowController()
        followController.followTitle = true
      //  print("handleFollowersTapped.userId \(String(describing: user?.uid))")
        followController.user = self.user
        navigationController?.pushViewController(followController, animated: true)
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        print("handleFollowingTapped delegate")
       // print("handleFollowingTapped.userId \(String(describing: user?.uid))")
        let followController = FollowController()
        followController.user = self.user
        navigationController?.pushViewController(followController, animated: true)
    }

}

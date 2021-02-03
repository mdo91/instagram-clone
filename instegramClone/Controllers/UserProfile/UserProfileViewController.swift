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

    
    
   // var headerReferenceSize = CGSize(width:200,height:200)
    
    //MARK: - vars & outlets
    
    var user: User?{
        didSet{
         
        }
        
    }
    
    var searchUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
         print("UserProfileViewController.viewDidLoad")

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
       

        self.collectionView.backgroundColor = .white
        
        configureUserData()


        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        
        header.delegate = self
        header.user = self.user
        
        return header
    }
    

    
    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width , height: 200)
//    }

    
    
    //MARK: - retieveUserData
    
    private func retieveUserData(){
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { [weak self] snapData in
            
            print("snapData \(snapData.value.debugDescription)")
         
            
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
        print("setUserStats")
        var numberOfFollowers: Int!
        var numberOfFollowing:Int!
        
        //user-followers
        
        guard let uid = header.user?.uid else { return}
        
        // get number of followers
        
        Database.database().reference().child("user-followers").child(uid).observe(.value) { (dataSnap) in
            //
            
            print("dataSnap 222 \(dataSnap)")
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
        
        
        
    }
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        
        print("delegatehandleFollowersTapped...")
        
        let followController = FollowController()
        followController.followTitle = true
        followController.user = self.user
        navigationController?.pushViewController(followController, animated: true)
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        print("handleFollowersTapped delegate")
        let followController = FollowController()
        followController.user = self.user
        navigationController?.pushViewController(followController, animated: true)
    }

}

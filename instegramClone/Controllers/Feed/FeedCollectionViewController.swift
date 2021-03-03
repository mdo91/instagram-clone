//
//  FeedCollectionViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {

    


    //MAKR: - vars & properties
    
    var posts = [Post]()
    
    var singlePost = false
    
    var post:Post?
    
    //MARK: - viewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        
        //config referesh controll
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleReferesh), for: .valueChanged)
        
        self.collectionView.refreshControl = refreshControl
        
        
        configureLogoutButton()
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor  = .white
        configNavigationBar()
        
        
        
        // send request if we are not showing a single post
        if !singlePost{
            fetchPosts()
        }else{
            self.collectionView.reloadData()
        }
        
        updateUserFeed()

    }
    
    
    //MARK: - logout action button
    
    private func configureLogoutButton(){
        
        if !singlePost{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutActionButton))
        }
        
        let rightButtonBar  = UIBarButtonItem(image: UIImage(named: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        navigationItem.rightBarButtonItem = rightButtonBar
    }
    
    @objc private func logoutActionButton(){
        
     //   print("logoutActionButton")
        
        let alertViewController = UIAlertController(title: "Instagram", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Log Out", style: .destructive) { action in
            
            do{
                try Auth.auth().signOut()
                
                // push loginViewController
                
                let loginViewController = LoginVC()
                let navigationController = UINavigationController(rootViewController: loginViewController)
               
                self.view.window?.rootViewController = navigationController
                self.navigationController?.popViewController(animated: true)
                //self.present(navigationController, animated: true)
            }
            catch{
                print("Error unable to sign the user out..")
            }
        }
        alertViewController.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - configNav bar
    
    private func configNavigationBar(){
        
        self.navigationItem.title = "Feed"
    }
    
    //MARK: - hanlders
    
    @objc private func handleShowMessages(){
        
        let messagesController = MessagesController()
        self.navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
    @objc private func handleReferesh(){
        
        posts.removeAll(keepingCapacity: false)
       // updateUserFeed()
        fetchPosts()
    //    self.collectionView.reloadData()
        
    }
    
    //MARK: - collectionView delegates
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !singlePost{
            return self.posts.count
        }else{
            return 1
        }
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else{
            
            fatalError("could not init \(FeedCell.self)")
        }
        
        if let post = post{
            cell.post = post
        }else{
            print("posts \(posts.count)")
            if posts.count > 0{
                cell.post = posts[indexPath.row]
            }
           
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
    
    //MARK: - API
    
    private func fetchPosts(){
        guard let currentUid = Auth.auth().currentUser?.uid else { return}
        USER_FEED_REF.child(currentUid).observe(.childAdded) { [weak self] (snapShot) in
            
            let postId = snapShot.key

            
            Database.fetchPost(with: postId) { (post) in

                self?.posts.append(post)
                
                self?.posts.sort(by: { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                })
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
          
        }
        
    }
    
    private func updateUserFeed(){
        guard let currentUid = Auth.auth().currentUser?.uid else{ return }
        
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { (snapShot) in

            let followingUserId = snapShot.key
            
            USER_POSTS_REF.child(followingUserId).observe(.childAdded) { (dataSnap) in
  
                let postId = dataSnap.key
                
                USER_FEED_REF.child(postId).updateChildValues([postId:1])
                
                
            }
        }
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { (snapShot) in
            
            let postId =  snapShot.key
            USER_FEED_REF.child(currentUid).updateChildValues([postId:1])
        }
    }
    


}
extension FeedCollectionViewController{
    
    //MARK: - Feed Cell Delegates
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        
        guard let post = cell.post else {return}
        guard let postId =  cell.post?.postId  else{ return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }
        
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of:.value) { (dataSnap) in
            //
           
            if dataSnap.hasChild(postId){
                post.didLike = true
                cell.likeButton.setImage(UIImage(named:"like_selected")!, for: .normal)
            }else{
                
                cell.likeButton.setImage(UIImage(named:"like_unselected")!, for: .normal)
            }
            
        }
        
    }
    
    func handleUserNameTapped(for cell: FeedCell) {
        
        let post = cell.post

        let profileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profileController.searchUser = true
        profileController.user = post?.user
        
        navigationController?.pushViewController(profileController, animated: true)
        
    }
    
    func handleOptionTapped(for cell: FeedCell) {
        
    }
    
    func handleLikeTapped(for cell: FeedCell,isDouble:Bool) {
        
        guard let post = cell.post else { return }
      //  guard let postId = cell.post?.postId else { return}
        print("post.didLike \(post.didLike)")
        if post.didLike {
            
            if !isDouble{
                post.adjustLikes(addLike: false, completionHandler: {  likes in
                 
                    cell.likeButton.setImage(UIImage(named:"like_unselected")!, for: .normal)
                    cell.likesLable.text = "\(likes) Likes"
                    
                    
                })
            }
           
           
        }else{
            
            post.adjustLikes(addLike: true, completionHandler: { likes in
                
            cell.likeButton.setImage(UIImage(named:"like_selected")!, for: .normal)
            cell.likesLable.text = "\(likes) Likes"
         
                
                
                
            })
            
        }
        
   
    }
    
    func handleShowLikes(for cell: FeedCell) {
       
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        
    }
    
    func handleShowLikesForCell(for cell: FeedCell) {
        print("handleShowLikesForCell")
        guard let post = cell.post else { return }
        
        
        let followLikesController = FollowLikeController()
        followLikesController.viewMode = FollowLikeController.ViewingMode(index: 2)
        followLikesController.postId = post.postId
        
        navigationController?.pushViewController(followLikesController, animated: true)
    }
    
    func configureCommentIndicatorView(for cell: FeedCell) {
        
    }
    
    func handleMessageButtonTapped(for cell: FeedCell) {
        
    }
}

//
//  UploadPostViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import CoreImage
import FirebaseDatabase
class UploadPostViewController: UIViewController, UITextViewDelegate, UITabBarControllerDelegate {
    
    
    //MARK: - properties
    
    var selectedImage:UIImage?
    
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    lazy var captionTextView:UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.groupTableViewBackground
        textView.font = UIFont.systemFont(ofSize: 12)
        shareButton.isEnabled = false
        textView.delegate = self
    
        
        return textView
    }()
    
    lazy var activityIndicator :UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var shareButton :UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 49/255, green: 204/255, blue: 244/255, alpha: 0.5)
        button.setTitle("Share", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        
        
        return button
    }()
    
    
 
    
    
   //MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
        configUI()
    }
    
    
    //MARK: - configUI
    
    private func configUI(){
        view.backgroundColor  = .white
        view.addSubview(photoImageView)
        view.addSubview(captionTextView)
        view.addSubview(shareButton)
        let barItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barItem
        
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        shareButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
        photoImageView.image = selectedImage
    }
    

    //MARK: - handle share button action
    
    @objc private func shareAction(){
        
        guard let text = captionTextView.text,
              let image = photoImageView.image,
              let userId = Auth.auth().currentUser?.uid else{
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        shareButton.backgroundColor = UIColor(red: 49/255, green: 204/255, blue: 244/255, alpha: 0.4)
        shareButton.isEnabled = false
        
        //image upload data
        
        guard let imageUploadData = image.jpegData(compressionQuality: 0.5) else { return}
        
        // creattionDate
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // updateStorage
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("post_images").child(filename).putData(imageUploadData, metadata: nil) { (storageMetaData, error) in
            if let error = error{
                
                print("Error storting data \(error.localizedDescription)")
            }
            
            //imageURL
            
            Storage.storage().reference().child("post_images").child(filename)
                .downloadURL { (url, error) in
                    if let error = error{
                        print("Error download URL \(error.localizedDescription)")
                    }
                    guard let downloadURL = url?.absoluteString else{ return }
                    
                    let dictionaryValues : [String:Any] = ["caption":text,
                    
                                                           "creationDate":creationDate,
                                                           "likes":0,
                                                           "imageURL":downloadURL,
                                                           "ownerUid":userId] as [String:Any]
                    // generate post id
                    
                    let postId = POSTS_REF.childByAutoId()
                    guard let postID = postId.key else {return}
                    self.updateUserFeed(with: postID)
                    
                    //upload info to database
                    
                    postId.updateChildValues(dictionaryValues) { [weak self](error, dataBaseRef) in
                        
                        if let error = error {
                            
                            print("ERROR updateChildValues \(error.localizedDescription)")
                        }
                        
                        //update user-posts structure
                        
                        USER_POSTS_REF.child(userId).updateChildValues([postId.key!:1])
                        
                        
                        self?.dismiss(animated: true) {
                            self?.activityIndicator.stopAnimating()
                            self?.activityIndicator.isHidden = true
                            self?.tabBarController?.selectedIndex = 0
                        }
                    }
                    
                    
                }
        }
        
        
    }
    
    //MARK: - TextView delegate
    
    func textViewDidChange(_ textView: UITextView) {
      //  print("text is changing..")
        
        guard !textView.text.isEmpty else{
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor(red: 49/255, green: 204/255, blue: 244/255, alpha: 0.4)
            
            return
        }
        
        shareButton.backgroundColor = UIColor(red: 49/255, green: 204/255, blue: 244/255, alpha: 1)
        shareButton.isEnabled = true

    }
    
    //MARK: - API requests
    
    private func updateUserFeed(with postId: String){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // database value
        
        let values = [postId:1]
        
        // update follower feed
        
        USER_FOLLOWER_REF.child(currentUid).observe(.childAdded) { (dataSnap) in
            
            let followerUid = dataSnap.key
            USER_FEED_REF.child(followerUid).updateChildValues(values)
        }
        
        // update current user feed
        USER_FEED_REF.child(currentUid).updateChildValues(values)
        
        
    }
    


}

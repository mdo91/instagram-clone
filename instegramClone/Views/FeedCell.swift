//
//  FeedCell.swift
//  instegramClone
//
//  Created by Mdo on 11/02/2021.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseDatabase

class FeedCell:UICollectionViewCell{
    
    //MARK: - properties
    
    
    
    weak var delegate: FeedCellDelegate?
    
    var post:Post?{
        
        didSet{
            guard let ownerUid = post?.ownerUid else {
                return
            }
            guard let imageURL = post?.imageURL else { return}
           
            
            Database.fetchUser(with: ownerUid) { [weak self](user) in
                guard let url = URL(string: user.profileImageUrl)else { return}
                self?.photoImageView.kf.setImage(with: url)
                self?.userNameButton.setTitle(user.userName, for: .normal)
              //  guard let user = user else { return}
                self?.configurePostCaptionUser(for: user)
                
            }
            
            guard let url = URL(string: imageURL) else { return}
            self.postImageView.kf.setImage(with: url)
            self.configurePostLikesUser()
            
            configLikeButton()
       
        }
    }
    
    static let reuseIdentifier = String(describing: FeedCell.self)
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var userNameButton :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.tintColor = .black
        button.addTarget(self, action: #selector(userNameButtonActionHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var optionsButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(optionsButtonActionHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView :UIImageView = {
         let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var likeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
      //  button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(likeButtonActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    lazy var commentButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(commentButtonActionHandler), for: .touchUpInside)
     //   button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    lazy var messageButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(messageButtonActionHandler), for: .touchUpInside)
       // button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    lazy var saveButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .black
       // button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
        
    }()
    
    lazy var likesLable:UILabel = {
       let lable = UILabel()
        lable.text = ""
        lable.font = UIFont.boldSystemFont(ofSize: 13)
        let gestureRegcognizer = UITapGestureRecognizer(target: self, action: #selector(likeLableActionHandler))
        gestureRegcognizer.numberOfTapsRequired = 1
        lable.isUserInteractionEnabled = true
        lable.addGestureRecognizer(gestureRegcognizer)
        return lable
    }()
    
    lazy var captionLable:UILabel = {
       let lable = UILabel()
      //  lable.text = "Username"
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " Some test caption for now", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)]))
        
        lable.attributedText = attributedText
       // lable.font = UIFont.boldSystemFont(ofSize: 13)
        return lable
    }()
    
    lazy var postTimeLable:UILabel = {
       let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 12)
        lable.textColor = .lightGray
        lable.text = "2 DAYS AGO"
        return lable
    }()
    
    
    
    
    //MARK: - cell life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
        //configurePostCaptionUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View configuration
    
    private func configUI(){
        
        addSubview(photoImageView)
        addSubview(userNameButton)
        addSubview(optionsButton)
        addSubview(postImageView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        photoImageView.layer.cornerRadius = 40 / 2
        userNameButton.anchor(top: nil, left: photoImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userNameButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        
        postImageView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postImageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        configActionButtons()
        
        addSubview(likesLable)
        likesLable.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(captionLable)
        captionLable.anchor(top: likesLable.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(postTimeLable)
        postTimeLable.anchor(top: captionLable.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    //MARK: - configure action buttons
    
    private func configActionButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,messageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(saveButton)
        stackView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        saveButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 20, height: 24)
        
    }
    
    private func configurePostCaptionUser(for user: User){
        
        guard let post = self.post else {
            return
        }
        

        let attributedText = NSMutableAttributedString(string: user.userName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " " + post.caption, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)]))
        
        self.captionLable.attributedText = attributedText
  
    }
    
    private func configurePostLikesUser(){
        
        guard let post = self.post else {
            return
        }
        
        let value = post.likes <= 1 ? "\(post.likes ?? 0) Like" : "\(post.likes ?? 0) Likes"
        
        self.likesLable.text = value
        
    }
    
    //MARK: - handlers
    
    @objc func optionsButtonActionHandler(){
        delegate?.handleOptionTapped(for: self)
    }
    
    @objc func userNameButtonActionHandler(){
        
        delegate?.handleUserNameTapped(for: self)
        
    }
    
    @objc func likeButtonActionHandler(){
        
        delegate?.handleLikeTapped(for: self)
    }
    
    @objc func commentButtonActionHandler(){
        delegate?.handleCommentTapped(for: self)
        
    }
    
    @objc func messageButtonActionHandler(){
        delegate?.handleMessageButtonTapped(for: self)
    }
    @objc func likeLableActionHandler(){
        delegate?.handleShowLikesForCell(for: self)
    }
    
    //MARK: - config like button
    
    private func configLikeButton(){
        
        delegate?.handleConfigureLikeButton(for: self)
    }
}

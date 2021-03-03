//
//  ChatCell.swift
//  instegramClone
//
//  Created by Mdo on 01/03/2021.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatCell: UICollectionViewCell{
    
    //MARK: - properties
    
    static let reuseIdentifier = String(describing:ChatCell.self )
    
    var message:Message?{
        didSet{
            
            guard let messageText = message?.messageText else { return }
            textView.text = messageText
            print("ChatCell.messageText \(messageText)")
            
            guard let chatPartnerID = message?.getChatPartnerId() else { return }
            
            Database.fetchUser(with: chatPartnerID) { (user) in
                guard let profileImageURL = user.profileImageUrl else{ return}
                let url = URL(string: profileImageURL)!
                self.photoImageView.kf.setImage(with: url)
                
            }
            
        }
    }
    
    var bubblLeftAnchor:NSLayoutConstraint?
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleRightAnchor:NSLayoutConstraint?
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var bubbleView:UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textView:UITextView =  {
       let textView = UITextView()
        textView.text = "Sample text lable"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    //MARK: - view life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config UI
    
    private func configUI(){
        addSubview(bubbleView)
        addSubview(photoImageView)
        addSubview(textView)
        
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: -4, paddingRight: 0, width: 32, height: 32)
        photoImageView.layer.cornerRadius = 32 / 2
        photoImageView.layer.masksToBounds = true
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor,constant: -8)
        bubbleRightAnchor?.isActive = true
        bubblLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: photoImageView.rightAnchor,constant: 8)
        bubblLeftAnchor?.isActive = false
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant:200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor,constant: 8).isActive = true
    }
    
}


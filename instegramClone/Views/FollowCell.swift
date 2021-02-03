//
//  FollowCell.swift
//  instegramClone
//
//  Created by Mdo on 16/01/2021.
//

import Foundation
import UIKit


class FollowCell: UITableViewCell {
    
    //MARK: - Properties
    
    let profileImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var followButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading..", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    
        button.addTarget(self, action: #selector(handleFollowButtonAction), for: .touchUpInside)
        return button
    }()
    
    var user: User?{
        didSet{
            

            guard let imageURL = user?.profileImageUrl else { return}
            self.profileImageView.loadImage(with: imageURL)
             self.textLabel?.text = user?.userName
             self.detailTextLabel?.text = user?.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        self.contentView.addSubview(followButton)
       // addSubview(followButton)
        
        followButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
        followButton.layer.cornerRadius = 3
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.textLabel?.text = "User name"
        self.detailTextLabel?.text = "Full name"
        
        self.textLabel?.text = "Name"
        self.detailTextLabel?.text = "user Name"
        
      //  followButton.addTarget(self, action: #selector(handleFollowButtonAction), for: .touchUpInside)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //textLable
        self.textLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y - 2 , width: self.textLabel!.frame.width, height: self.textLabel!.frame.height)
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        //detailLable
        self.detailTextLabel?.frame = CGRect(x: 68, y: self.detailTextLabel!.frame.origin.y, width: self.frame.width - 108, height: self.detailTextLabel!.frame.height)
        self.detailTextLabel?.textColor = .lightGray
        self.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    //MARK: - handlers
    
    @objc func handleFollowButtonAction(){
        print("handleFollowButtonAction tapped")
    }
    
}

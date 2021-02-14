//
//  SearchUserCell.swift
//  instegramClone
//
//  Created by Mdo on 14/01/2021.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import UIKit

public class SearchUserCell:UITableViewCell{
    
    //MARK: - Properties
    
    let profileImageView:CustomImageView = {
       let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var user: User?{
        didSet{
            
            self.textLabel?.text = user?.userName
            self.detailTextLabel?.text = user?.name
            guard let imageURL = user?.profileImageUrl else { return}
            self.profileImageView.loadImage(with: imageURL)
        }
    }
    
    //MARK: - vars
    
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // add imageView
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        
        self.textLabel?.text = "User name"
        self.detailTextLabel?.text = "Full name"
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - layoutSubViews
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //textLable
        self.textLabel?.frame = CGRect(x: 68, y: self.textLabel!.frame.origin.y - 2 , width: self.textLabel!.frame.width, height: self.textLabel!.frame.height)
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        //detailLable
        self.detailTextLabel?.frame = CGRect(x: 68, y: self.detailTextLabel!.frame.origin.y, width: self.frame.width - 108, height: self.detailTextLabel!.frame.height)
        self.detailTextLabel?.textColor = .lightGray
        self.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
}

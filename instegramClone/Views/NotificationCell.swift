//
//  NotificationCell.swift
//  instegramClone
//
//  Created by Mdo on 19/02/2021.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    
    //MARK: - properties & vars
    
    static let reuseIdentifier = String(describing:NotificationCell.self)
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let notificationLable:UILabel = {
      let lable = UILabel()
        lable.numberOfLines = 2
      //  lable.text = ""
        lable.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "mdo91",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        
        attributedText.append(NSMutableAttributedString(string: " commented on your post", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        attributedText.append(NSMutableAttributedString(string: " 2d.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor :UIColor.lightGray]))
        
        lable.attributedText = attributedText
        
        return lable
        
    }()
    
    lazy var followButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading..", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    
        button.addTarget(self, action: #selector(handleFollowButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    
    //MARK: - object life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configUI
    
    private func configUI(){
        
        addSubview(photoImageView)
        photoImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        photoImageView.layer.cornerRadius = 40 / 2
        
        addSubview(followButton)
        
        followButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
        followButton.layer.cornerRadius = 3
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followButton.isHidden = true
        addSubview(notificationLable)
        
        notificationLable.anchor(top: nil, left: photoImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        notificationLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(postImageView)
        postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
        postImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    //MARK: - handlers
    
    @objc func handleFollowButtonAction(){
        print("handleFollowButtonAction..")
        
    }
    
    
    
}

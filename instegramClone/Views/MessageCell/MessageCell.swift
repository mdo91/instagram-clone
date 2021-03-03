//
//  MessageCell.swift
//  instegramClone
//
//  Created by Mdo on 26/02/2021.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseDatabase

class MessageCell:UITableViewCell{
    
    //MARK: - properties
    
    var message:Message? {
        didSet{
            guard let messageText = message?.messageText else {
                return
            }
            detailTextLabel?.text = messageText
            
            if let seconds = message?.creationDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timesTampLable.text = dateFormatter.string(from: seconds)
            }
            
            configUserData()
        }
    }
    
    static let reuseIdentifier = String(describing: MessageCell.self)
    

    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var timesTampLable:UILabel = {
       let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = .darkGray
        
        return lable
    }()


    //MARK: - cell view life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = CGRect(x: 68, y:(self.textLabel!.frame.origin.y) - 2, width: self.textLabel!.frame.width, height: self.textLabel!.frame.height)
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.detailTextLabel?.frame = CGRect(x: 68, y: (self.detailTextLabel!.frame.origin.y) + 2, width: self.frame.width - 108, height: self.detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .lightGray
        
        self.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK - configUI
    
    private func configUI(){
        
        addSubview(photoImageView)
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        photoImageView.layer.cornerRadius = 50 / 2
        photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(timesTampLable)
        
        timesTampLable.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        timesTampLable.text = "20h"
        self.textLabel?.text = "mdo91"
        self.detailTextLabel?.text = "some text to be shown "
        
    }
    
    private func configUserData(){
        
        guard let chatPartnerID = message?.getChatPartnerId() else {
            return
        }
        
        Database.fetchUser(with: chatPartnerID) { (user) in
            let url = URL(string: user.profileImageUrl)!
            self.photoImageView.kf.setImage(with: url)
            self.textLabel?.text = user.userName
        }
    }
}

//
//  NewMessageCell.swift
//  instegramClone
//
//  Created by Mdo on 27/02/2021.
//

import Foundation
import UIKit

class NewMessageCell:UITableViewCell{
    
    //MARK: - properties
    
    static let reuseIdentifier = String(describing: NewMessageCell.self)
    
    var user:User?{
        
        didSet{
            
            guard let name = user?.name else{ return }
            guard let userName = user?.userName else { return}
            guard let image = user?.profileImageUrl else { return }
            let url = URL(string: image)!
            photoImageView.kf.setImage(with: url)
            textLabel?.text = userName
            detailTextLabel?.text = name
            
        }
    }
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    
    //MARK: - cell life cycle
    
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
        //self.textLabel?.text = "mdo91"
        //self.detailTextLabel?.text = "mdo sm"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configUI
    
    private func configUI(){
        
        addSubview(photoImageView)
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        photoImageView.layer.cornerRadius = 50 / 2
        photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
}

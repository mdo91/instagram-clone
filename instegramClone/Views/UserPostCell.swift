//
//  UserPostCell.swift
//  instegramClone
//
//  Created by Mdo on 10/02/2021.
//

import Foundation
import UIKit
import Kingfisher
class UserPostCell:UICollectionViewCell{
    
    
    //MARK: - Properties
    
    static let reuseIdentifier = String(describing: UserPostCell.self)
    
    var post:Post?{
        didSet{
            guard let imageURL = post?.imageURL else{ return }
            //photoImageView.image  = nil
            let url = URL(string: imageURL)!
            photoImageView.kf.setImage(with: url)
        }
    }
    
    lazy var photoImageView :CustomImageView = {
         let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    
    //MARK: - cell life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UI
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configUI
    
    private func configUI(){
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
}

//
//  SelectPhotoHeader.swift
//  instegramClone
//
//  Created by Mdo on 04/02/2021.
//

import Foundation
import UIKit

class SelectPhotoHeader:UICollectionViewCell{
    
    
    //MARK: - properties
    
    static var reuseIdentifier = String(describing:SelectPhotoHeader.self)
    
    lazy var photoImageView :UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
     //   imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    //MARK: - Object life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UIConfig
    
    private func UIConfig(){
        
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    }
}

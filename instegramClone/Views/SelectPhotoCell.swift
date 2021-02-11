//
//  SelectPhotoHeader.swift
//  instegramClone
//
//  Created by Mdo on 04/02/2021.
//

import Foundation
import UIKit


class SelectPhotoCell:UICollectionViewCell{
    
    
    //MARK: - properties
    static var reuseIdentifier = String(describing:SelectPhotoCell.self)
    
    lazy var photoImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    var image:UIImage?{
        
        didSet{
          //  addIndicator(image: image)
            addImage(image: image) { [weak self] in
                self?.photoImageView.image = self?.image
            }
        }
    }
    
    
    //MARK: - object life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubview(photoImageView)
        addSubview(activityIndicator)
        
       
        self.photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
      //  photoImageView.isHidden = true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true

     
        
        
       // addIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - addAnimatedIndicator
    
    private func addImage(image : UIImage?, finished:@escaping ()->Void){
        
        self.activityIndicator.isHidden  = false
        self.activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            finished()
        }

    }
}

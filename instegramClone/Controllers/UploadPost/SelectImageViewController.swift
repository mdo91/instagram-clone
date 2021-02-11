//
//  SelectImageViewController.swift
//  instegramClone
//
//  Created by Mdo on 04/02/2021.
//

import Foundation
import UIKit
import Photos

class SelectImageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    //MARK: - properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage:UIImage?
    var header:SelectPhotoHeader?
    var rightBarButton:UIBarButtonItem?
    var imagesLoaded = false
    
    //MARK: - viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: SelectPhotoCell.reuseIdentifier)
        
        collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectPhotoHeader.reuseIdentifier)
        
        collectionView.backgroundColor = .white
                
        navigationBarButtons()
        fetchPhotos()
    }
    
    
    
    //MARK: - UICollectionView protocols
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoCell.reuseIdentifier, for: indexPath) as? SelectPhotoCell else{
            
            fatalError("could not init \(SelectPhotoCell.self)")
        }
        cell.image = self.images[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelectPhotoHeader.reuseIdentifier, for: indexPath) as? SelectPhotoHeader else{
            
            fatalError("could not init \(SelectPhotoHeader.self)")
        }
        self.header = header
        
        if let selectedImage = self.selectedImage{
            
           // header.photoImageView.image = selectedImage
            
            if let index = self.images.firstIndex(of:selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options:nil) {  (image, info) in
                    
             //       guard let `self` = self else{return}
                    
                    header.photoImageView.image = image
                }
                
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        print("collectionView.selectedImage \(self.selectedImage.debugDescription)")
        self.collectionView.reloadData()
        
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true) 
    }
    
    
    //MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    
    //MARK: - Handlers
    
    @objc func handleNext(){
        
        print("handleNext")
        let uploadViewController = UploadPostViewController()
        uploadViewController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(uploadViewController, animated: true)
    }
    
    @objc func handleCancel(){
        
        print("handleCancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - navBar buttons configrations
    
    func navigationBarButtons(){
        
            if !imagesLoaded{
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.startAnimating()
                rightBarButton = UIBarButtonItem(customView: activityIndicator)
            }else{
                rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.handleNext))
            }
             
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.rightBarButtonItem?.target = self
            self.navigationItem.rightBarButtonItem?.action = #selector(self.handleNext)
            self.navigationItem.setRightBarButton(self.rightBarButton, animated: true)

        
        
        
        
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        navigationController?.navigationBar.tintColor = .black
        
        
    }
    
    //MARK: - fetch images
    
    private func getAssetFetchOptions() -> PHFetchOptions{
        
        let options = PHFetchOptions()
        
        // set limit
        options.fetchLimit = 50
        
        //sort by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        //set sort descriptors
        
        options.sortDescriptors = [sortDescriptor]
        
        //return options
        
        return options
        
        
    }
    
    private func fetchPhotos(){
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        // Fetch Images on background thread
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                
             //   print("fetchPhotos.allPhotos \(count)")
                
                let imagesManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imagesManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self](image, info) in
                    
                    //
                    
                    if let image = image{
                        
                        
                        
                        // append image to data source
                        self?.images.append(image)
                        
                        //append asset to data source
                        self?.assets.append(asset)
                        
                        // set selectedImage with the first image on the index
                        if self?.selectedImage == nil{
                            self?.selectedImage = image
                        }
                        
                        //check if iteration has ended
                        
                        if count == allPhotos.count - 1 {
                            
                        //reload collectionView on the main thread
                            DispatchQueue.main.async { [weak self] in
                                self?.collectionView.reloadData()
                                self!.imagesLoaded = true
                                self?.navigationBarButtons()
                            }
                        }
                        
                    }
                }
                
            }
        }
        
    }
    
}

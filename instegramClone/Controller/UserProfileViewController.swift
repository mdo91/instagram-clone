//
//  UserProfileViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit

private let reuseIdentifier = "Cell"
class UserProfileViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    

    


}

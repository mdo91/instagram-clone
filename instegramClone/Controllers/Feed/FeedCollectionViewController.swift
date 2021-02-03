//
//  FeedCollectionViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"

class FeedCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogoutButton()

    }
    
    
    //MARK: - logout action button
    
    private func configureLogoutButton(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutActionButton))
    }
    
    @objc private func logoutActionButton(){
        
     //   print("logoutActionButton")
        
        let alertViewController = UIAlertController(title: "Instagram", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Log Out", style: .destructive) { action in
            
            do{
                try Auth.auth().signOut()
                
                // push loginViewController
                
                let loginViewController = LoginVC()
                let navigationController = UINavigationController(rootViewController: loginViewController)
               
                self.view.window?.rootViewController = navigationController
                self.navigationController?.popViewController(animated: true)
                //self.present(navigationController, animated: true)
            }
            catch{
                print("Error unable to sign the user out..")
            }
        }
        alertViewController.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }


}

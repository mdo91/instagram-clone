//
//  MainTabBarViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import Firebase
class MainTabBarViewController: UITabBarController {

    //MARK: - outlets & vars
    
    
    //MARK: - viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainTabBarViewController.viewDidLoad")
       

        // Do any additional setup after loading the view.
        
        // call config
     //   userIsLogginIn()
        configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    //MARK: - configureViewControllers
    
    public func configureViewControllers(){
        
        // home
        let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        
        //search
        
        let searchVC = constructNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchViewController())
        
        // post
       let uploadVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: UploadPostViewController())
        
        // notification
        let notificationVC = constructNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_unselected")!, rootViewController: NotificationViewController())
        
        //profile
        
        let profileVC = constructNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_unselected")!, rootViewController: UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // adding to tab-bar
        
        viewControllers = [feedVC, searchVC, uploadVC, notificationVC, profileVC]
        tabBar.tintColor = .black
        
        
    }
    
    
    //MARK: - configureNavController
    
    private func constructNavController(unselectedImage:UIImage, selectedImage:UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        
        // define nav controller
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.tabBarItem.image = unselectedImage
        navigationController.navigationBar.tintColor = .black
        
        
        return navigationController
    }
    
    //MARK: - check if user is logged in
    // the following code login moved to scene delegate
    func userIsLogginIn(){
        
        if Auth.auth().currentUser == nil{
            print("no current user")
            
            DispatchQueue.main.async {
                let loginViewController = LoginVC()
                let navigationController = UINavigationController(rootViewController: loginViewController)
 
               
                self.view.window?.rootViewController = navigationController
               
            }
        }
        return
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        
      //  userIsLogginIn()
    }
}

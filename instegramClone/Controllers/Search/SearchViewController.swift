//
//  SearchViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import  FirebaseDatabase
//private let reuseIdentifier = "Cell"
//private let headerIdentifier = "UserProfileHeader"
private let reuseIdentifier = "SearchUserCell"
class SearchViewController: UITableViewController {
    
    //MARK: - Properties
    
    //MARK: - vars
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        // Insets
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        configureNavController()
        retrieveUsers()

    }
    
    
    //MARK: - tableView Delegates
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        
        cell.user = self.users[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        
        let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        userProfileController.searchUser = true
        self.navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    //MARK: - navController
    
    private func configureNavController(){
        self.navigationItem.title = "Explore"
    }
    
    //MARK: - API Calls
    
    private func retrieveUsers(){
        
        Database.database().reference().child("users").observe(.childAdded) { [weak self ](dataSnap) in
            
            guard let `self` = self else { return }
            let uid = dataSnap.key
            guard let dataDictionary = dataSnap.value as? Dictionary<String,AnyObject> else {return}
            
            let user = User(uid: uid, dictionary: dataDictionary)
            
            self.users.append(user)
          //  self.users.append(dataSnap.value)
            self.tableView.reloadData()
            
            
        }
    }



}

//
//  FollowController.swift
//  instegramClone
//
//  Created by Mdo on 16/01/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "FollowCell"
class FollowController: UITableViewController {
    
    //MARK- properties
    var followTitle = false
    var userData:[User?] = [User?]()
    var user:User?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
      //   tableView.allowsSelection = false
        navigationBarTitleConfig()
        tableView.separatorColor = .clear
        retrieveUsers()
    }
    
    
    
    //MARK: - UITableView delegates
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        if let user = userData[indexPath.row]{
            
            cell.user = user
        }
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    
    //MARK: - navBar title configurations
    
    private func navigationBarTitleConfig(){
        
        if followTitle{
            self.navigationItem.title = "Followers"
        }else{
            self.navigationItem.title = "Following"
        }
        
    }
    
    
    //MARK: - retrieve users
    
    private func retrieveUsers(){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        var ref: DatabaseReference!
        if followTitle{
            // set reference
            ref = Database.database().reference().child("user-followers")
        }else{
            // set reference
            ref = Database.database().reference().child("user-following")
        }
        
        ref.child(currentUser).observe(.childAdded) { [self] (dataSnap) in
            // start getting data
            
           // print("dataSnap \(dataSnap.key)")
            
            let userId = dataSnap.key
            Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (dataSnap) in
                guard let dictionary = dataSnap.value as? Dictionary<String,AnyObject> else{ return}
                
                let user = User(uid: userId, dictionary: dictionary)
                
                userData.append(user)
                print("user ... \(userData)")
                tableView.reloadData()
                
            }
          //  userData.append(dataSnap)
        }
    }
}

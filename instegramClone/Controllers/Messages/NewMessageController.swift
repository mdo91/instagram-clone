//
//  NewMessageController.swift
//  instegramClone
//
//  Created by Mdo on 27/02/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewMessageController:UITableViewController{
    
    //MAKR: - properties
    
    var users = [User]()
    var messageController: MessagesController?
  
    
    
    //MARK: - viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: NewMessageCell.reuseIdentifier)
        
        // nav bar config
        configNavigationBar()
        fetchUsers()
    }
    
    
    //MARK: - UITableViewController delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewMessageCell.reuseIdentifier, for: indexPath) as? NewMessageCell else{
            fatalError("could not init \(NewMessageCell.self)")
        }
        cell.user = self.users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell is selected")
        
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            print("user.name \(user.name)")
            self.messageController?.showChatController(forUser: user)
        }
    }
    
    //MARK: - handlers
    
    @objc func handleNewMessage(){
        
    }
    
    //MARK: - config navigationbar
    
    private func configNavigationBar(){
        
        navigationItem.title = "New Message"
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    
    //MARK: - API
    
    private func fetchUsers(){
        
        USER_REF.observe(.childAdded) { (snapShot) in
            // do action
            let uid = snapShot.key
            if uid != Auth.auth().currentUser?.uid {
                Database.fetchUser(with: uid) { (user) in
                    //
                    self.users.append(user)
                    self.tableView.reloadData()
                    
                }
            }
         //   print("fetchUsers.snapShot \(snapShot)")
        }
        
        
    }
}

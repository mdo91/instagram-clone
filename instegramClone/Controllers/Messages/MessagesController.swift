//
//  MessagesController.swift
//  instegramClone
//
//  Created by Mdo on 26/02/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
class MessagesController:UITableViewController{
    
    
    //MAKR: - properties
    var messages = [Message]()
    var messagesDictionary : [String:Message] = [String:Message]()
    
    
    //MARK: - viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        
        // nav bar config
        configNavigationBar()
        fetchMessages()
    }
    
    
    //MARK: - UITableViewController delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as? MessageCell else{
            fatalError("could not init \(MessageCell.self)")
        }
        cell.message = messages[indexPath.row]
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell is selected")
        let message = messages[indexPath.row]
        let partnerID = message.getChatPartnerId()
        Database.fetchUser(with: partnerID) { (user) in
            self.showChatController(forUser: user)
        }
    }
    
    //MARK: - handlers
    
    @objc func handleNewMessage(){
        
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
       self.present(navigationController, animated: true, completion: nil)
    //    self.navigationController?.pushViewController(newMessageController, animated: true)
        
    }
    
    public func showChatController(forUser user: User){
        
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        self.navigationController?.pushViewController(chatController, animated: true)
        
    }
    
    
    
    //MARK: - config navigationbar
    
    private func configNavigationBar(){
        
        navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
    
    
    //MARK: - API
    
    private func fetchMessages(){
        
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        USER_MESSAGES_REF.child(currentUid).observe(.childAdded) { (dataShot) in
            
            let uid = dataShot.key
            USER_MESSAGES_REF.child(currentUid).child(uid).observe(.childAdded) { (dataSnapShot) in
                let messageId = dataSnapShot.key
                self.fetchMessage(withMessageId: messageId)
            }
        }
    }
    
    private func fetchMessage(withMessageId messageId:String ){
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (dataSnap) in
            guard let dictionary = dataSnap.value as? Dictionary<String,AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            let chatPartnerID = message.getChatPartnerId()
            self.messagesDictionary[chatPartnerID] = message
            self.messages = Array(self.messagesDictionary.values)
           // self.messages.append(message)
            self.tableView.reloadData()
            
        }
        
    }

    
    
    
    
    
    
}

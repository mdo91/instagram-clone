//
//  ChatController.swift
//  instegramClone
//
//  Created by Mdo on 01/03/2021.
//

import Foundation
import UIKit
import FirebaseAuth
class ChatController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    //MARK: - properties
    
    var user: User?
    var messages = [Message]()
    var accessoryHeight:NSLayoutConstraint?
    var numOfLinesConstant = 1
    
    var height = 70
    
    lazy var containerView : UIView = {
     //   self.accessoryHeight.
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 65))

        container.addSubview(messageTextField)
        messageTextField.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)

        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonActionHandler), for: .touchUpInside)

        container.addSubview(sendButton)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.backgroundColor = .lightGray
        container.addSubview(separatorView)
        separatorView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

        return container
    }()
    
    lazy var messageTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message.."
        textField.delegate = self
        
     
        return textField
    }()
    
    override var inputAccessoryView: UIView?{
        get{
           // containerView.sizeToFit()
           // containerView.invalidateIntrinsicContentSize()
            return containerView
        }
        set{
            
        }
    
    }
    
    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    
    
    //MARK: viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseIdentifier)
        navigationBarConfig()
        observeMessages()
       // containerView.translatesAutoresizingMaskIntoConstraints = true
        

       // accessoryHeight?.constant = 70
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - navigationBar config
    
    private func navigationBarConfig(){
        guard let user = self.user else{ return }
        
        navigationItem.title = user.name
        
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(infoBarButtonAction), for: .touchUpInside)
        let infoButton = UIBarButtonItem(customView: button)
        infoButton.tintColor = .black
        navigationItem.rightBarButtonItem = infoButton

    }
    
    //MARK: - handlers
    
    @objc func infoBarButtonAction(){
        
        print("infoBarButtonAction..")
        
    }
    
    @objc func sendButtonActionHandler(){
        
        uploadMessagesToServer()
        messageTextField.text = nil
        
    }
    
    private func configUI(){
        
    }
    
    private func estimateFrameForText(_ text:String) -> CGRect{
        let size = CGSize(width: 200,height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func configureMessge(cell:ChatCell, message:Message){
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText).width + 32
        cell.frame.size.height = estimateFrameForText(message.messageText).height + 20
        
        if message.fromId == currentUid{
            cell.bubbleRightAnchor?.isActive = true
            cell.bubblLeftAnchor?.isActive = false
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
            cell.textView.textColor = .white
            cell.photoImageView.isHidden = true
        }else{
            cell.bubbleRightAnchor?.isActive = false
            cell.bubblLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
            cell.photoImageView.isHidden = false
        }

        
        
    }
    
    
    //MARK: - API
    
    private func uploadMessagesToServer(){
        guard let messageText = messageTextField.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else{ return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
        guard let uid = user.uid else {return}
        let messageValues = ["creationDate":creationDate,
                             "fromId":currentUid,
                             "toId":uid,
        "messageText":messageText] as [String:Any]
        
        let messageRef = MESSAGES_REF.childByAutoId()
        messageRef.updateChildValues(messageValues)
        guard let messageKey = messageRef.key else {
            return
        }
        print("uploadMessagesToServer.currentUid \(currentUid)")
        print("uploadMessagesToServer.uid \(uid)")
        print("uploadMessagesToServer.messageRef \([messageKey:1])")
        
        
        
        USER_MESSAGES_REF.child(currentUid).child(uid).updateChildValues([messageKey: 1])
        USER_MESSAGES_REF.child(uid).child(currentUid).updateChildValues([messageKey:1])
        
    }
    private func observeMessages(){
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = self.user?.uid else { return }
        
        USER_MESSAGES_REF.child(currentId).child(chatPartnerId).observe(.childAdded) { (snapShot) in
            let messageId = snapShot.key
            self.fetchMessage(withMessageId: messageId)
        }
        
    }
    
    private func fetchMessage(withMessageId messageId:String ){
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (dataSnap) in
            guard let dictionary = dataSnap.value as? Dictionary<String,AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView.reloadData()
            
        }
        
    }


  

    
}
//MARK: - UICollectionView Delegate

extension ChatController{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height :CGFloat = 80
        let message = messages[indexPath.row]
        height = estimateFrameForText(message.messageText).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.reuseIdentifier, for: indexPath) as? ChatCell else{
            fatalError("could not init \(ChatCell.self)")
            
        }
            cell.message = self.messages[indexPath.row]
            configureMessge(cell: cell, message: self.messages[indexPath.item])
      
        return cell
    }

    
}
extension ChatController: UITextFieldDelegate{
    
    //MARK: - TextField delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.messageTextField{
            guard let numberOfLines = textField.text?.count  else { return false }
            guard numberOfLines / 34 != 0 else {
                return true
            }
  
           
            let amountOfLinesToBeShown = numberOfLines
            if numOfLinesConstant != numberOfLines / 34{

                numOfLinesConstant = numberOfLines / 34
                let maxHeight = Int(messageTextField.font!.lineHeight) + amountOfLinesToBeShown

                print("maxHeight \(maxHeight)")
                
                
                UIView.animate(withDuration: 0.5) { [self] in
                    
                  //  DispatchQueue.main.async {
                        
                        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: maxHeight)
                    containerView.setNeedsLayout()
                    print("containerView \(containerView.frame.height)")
                    self.inputAccessoryView = containerView
                    inputAccessoryView?.setNeedsLayout()
   
                }
            }
            
            print("containerView \(containerView.frame.height)")
  
            return true
            
        }else{
            return false
        }

    }
    
}

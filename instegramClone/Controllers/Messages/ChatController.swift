//
//  ChatController.swift
//  instegramClone
//
//  Created by Mdo on 01/03/2021.
//

import Foundation
import UIKit
import FirebaseAuth
class ChatController:UICollectionViewController,UICollectionViewDelegateFlowLayout, MessageInputAccesoryViewDelegate{

    
    
    //MARK: - properties
    
    var user: User?
    var messages = [Message]()
    var accessoryHeight:NSLayoutConstraint?
    var numOfLinesConstant = 1
    
    var height = 70
    
    lazy var containerView : MessageInputAccessoryView = {
     //   self.accessoryHeight.
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let containerView = MessageInputAccessoryView(frame: frame)
        containerView.delegate = self

        return containerView
    }()
    
    lazy var messageTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message.."
        textField.delegate = self
        
     
        return textField
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            
            containerView.backgroundColor = .white

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.configUI()
        }
       
        
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
        
        configUI()

        
    }
    
    private func configUI(){
        
        
        let contentHeight = self.collectionView.contentSize.height
        let heightAfterInserts = self.collectionView.frame.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
        
        if contentHeight > heightAfterInserts{
            self.collectionView.setContentOffset(CGPoint(x: 0, y: self.collectionView.contentSize.height - self.collectionView.frame.size.height / 2.5), animated: true)
        }
    
    }
    
    private func estimateFrameForText(_ text:String) -> CGRect{
        let size = CGSize(width: 200,height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func configureMessge(cell:ChatCell, message:Message){
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        cell.bubbleWidthAnchor?.constant = CGFloat(Int(estimateFrameForText(message.messageText).width + 32))
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
    
    //MARK: - accessory protcols
    

    
    func handleUploadMessage(message: String) {
        let properties = ["messageText": message] as [String: AnyObject]
        uploadMessageToServer(withProperties: properties)
        
        self.containerView.clearMessageTextView()
    }
    
    func handleSelectImage() {
        
    }
    
    
    //MARK: - API
    
    private func uploadMessageToServer(withProperties properties: [String: AnyObject]) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)

        // UPDATE: - Safely unwrapped uid to work with Firebase 5
        guard let uid = user.uid else { return }

        var values: [String: AnyObject] = ["toId": user.uid as AnyObject, "fromId": currentUid as AnyObject, "creationDate": creationDate as AnyObject, "read": false as AnyObject]

        properties.forEach({values[$0] = $1})
        
        let messageRef = MESSAGES_REF.childByAutoId()
        
        // UPDATE: - Safely unwrapped messageKey to work with Firebase 5
        guard let messageKey = messageRef.key else { return }
        
        messageRef.updateChildValues(values) { (err, ref) in
            USER_MESSAGES_REF.child(currentUid).child(uid).updateChildValues([messageKey: 1])
            USER_MESSAGES_REF.child(uid).child(currentUid).updateChildValues([messageKey: 1])
        }
        
      //  uploadMessageNotification(isImageMessage: false, isVideoMessage: false, isTextMessage: true)
    }
    
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
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { [self] (dataSnap) in
            guard let dictionary = dataSnap.value as? Dictionary<String,AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView.reloadData()
            self.configUI()
           
            
        }
        
    }
    
    func moveToFrame(contentOffset : CGFloat) {

        let frame: CGRect = CGRect(x : self.collectionView.contentOffset.x ,y : contentOffset ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        print("moveToFrame contentOffset\(contentOffset) frame \(frame.debugDescription)")
        
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }

}
//MARK: - UICollectionView Delegate

extension ChatController{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height :CGFloat = 80
        let message = messages[indexPath.row]
        print("collectionView.messageText \(message.messageText)")
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
        cell.message = self.messages[indexPath.item]
        configureMessge(cell: cell, message: self.messages[indexPath.item])
      
        return cell
    }
    


    
}
extension ChatController: UITextFieldDelegate{
    
    //MARK: - TextField delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 2) {
        }

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

                UIView.animate(withDuration: 0.5) { [self] in

                    containerView.frame = CGRect(x: 0, y: 0, width: 100, height: maxHeight)
                    containerView.setNeedsLayout()
                    print("containerView \(containerView.frame.height)")
                    self.inputAccessoryView = containerView
                    inputAccessoryView?.setNeedsLayout()
   
                }
            }

            return true
            
        }else{
            return false
        }

    }
    
}

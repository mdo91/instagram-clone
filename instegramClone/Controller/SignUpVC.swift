//
//  SignUpVC.swift
//  instegramClone
//
//  Created by Mdo on 10/01/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SingUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //MARK: - variables & outlets
   // var ref:DatabaseReference!
    var ref: DatabaseReference!
    var imageSelected = false
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhotoProfile), for: .touchUpInside)
        return button
    }()
    
    let emailTextField:UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let userNameTextField:UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "User Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField:UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let FullNameTextField:UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Full name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let signUpButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red:149/255, green: 204 / 255, blue: 244/255, alpha: 1)
        
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                                                                         NSAttributedString.Key.foregroundColor: UIColor.lightGray ])
        let attributedTitle2 = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                                                                         NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1) ])
        attributedTitle.append(attributedTitle2)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(alreadyHaveAccountButtonAction), for: .touchUpInside)
        
        return button
        
    }()
    
    //MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - backgroundColor
        self.view.backgroundColor = .white
        self.view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor,
                               left: nil,
                               bottom: nil,
                               right: nil,
                               paddingTop: 40,
                               paddingLeft: 0,
                               paddingBottom: 0,
                               paddingRight: 0,
                               width: 140,
                               height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        configureViewComponents()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        ref = Database.database().reference()
        
   //     Auth.auth()
        
       // ref = Database.database().reference()
       
    }
    
    //MARK: - Button action
    
    @objc private func alreadyHaveAccountButtonAction(){
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func handleSignUp(){
        print("handleSignUp")
        guard let email = emailTextField.text  else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = FullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return}
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error{
                print("handleSignUp.Auth error: \(error.localizedDescription)")
            }
            

            
            // image
            guard let profileImage = self.plusPhotoButton.imageView?.image else { return}
            // Upload data
            
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            
            // place image in fireBase storage
            // set up a uniqe Id
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("profile-images").child(fileName
            )
            .putData(uploadData, metadata: nil) { (metaData, error) in
                // error
                
                if let error = error {
                    print("error in uploading data \(error.localizedDescription)")
                    
                }
                
                guard let metaData = metaData else{
                    print("metaData error")
                    return
                }
                
                
                
                // profile image url
                
                Storage.storage().reference().child("profile-images").child(fileName
                ).downloadURL { [self] (url, error) in
                    if let error = error {
                        print("error download URL \(error.localizedDescription)")
                    }
                    guard let downloadURL = url?.absoluteString else{
                        
                        return
                    }
                    
                    let dictionaryValues = ["name":name,
                                            "username":userName,
                                            "password":password,
                                            "email":email,
                                            "profileImageURL":downloadURL] as [String : Any]
                    guard let authUser = Auth.auth().currentUser else{
                        print("Unable to get user ID")
                        return}
                //    let test = ["none":"none"]
                    let values = [authUser.uid: dictionaryValues]
                    

                    //TODO: replace test with values
                    
                    
                    ref.child("users").updateChildValues(values) { (error, dataBaseRef) in
                        // handle data
                        
                        if let error = error{
                            print("error 22 \(error.localizedDescription)")
                        }
                        
                        print("sucess")
                        
                        
                    }
                   
                }
                    
            }
            
        }
            
    }
    
    @objc private func formValidation(){
        
        guard emailTextField.hasText,
              passwordTextField.hasText,
              userNameTextField.hasText,
              FullNameTextField.hasText,
              imageSelected == true
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red:149/255, green: 204 / 255, blue: 244/255, alpha: 1)
            return
        }
        signUpButton.isEnabled = true
      //  signUpButton.backgroundColor = UIColor.red
        signUpButton.backgroundColor = UIColor(red:17/255, green: 154 / 255, blue: 237 / 255, alpha: 1)
        
        
    }
    
    @objc private func handleSelectPhotoProfile(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - UIConfigrations
    
    private func configureViewComponents(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,FullNameTextField,userNameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        
        
        view.addSubview(stackView)
 
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 40,
                         paddingBottom: 0,
                         paddingRight: 40,
                         width: 0,
                         height: 240)
    }
    
    
    //MARK: - UIImagePicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //selected image
        
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
            
        }
        
        // configure plusPhotoButton with selected Image
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        imageSelected = true
        formValidation()
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

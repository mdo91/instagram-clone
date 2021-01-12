//
//  LoginVC.swift
//  instegramClone
//
//  Created by Mdo on 10/01/2021.
//

import UIKit
import FirebaseAuth

class LoginVC:UIViewController{
   
    
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil,
                             left: nil,
                             bottom: nil,
                             right: nil,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 200,
                             height: 50)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor =  UIColor(red:0/255, green: 120 / 255, blue: 175/255, alpha: 1)
        return view
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
    
    let passwordTextField:UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let loginBottom:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red:149/255, green: 204 / 255, blue: 244/255, alpha: 1)
        
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton : UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                        attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                                    NSAttributedString.Key.foregroundColor:
                                                                    UIColor.lightGray ])
        let attributedTitle2 = NSMutableAttributedString(string: "Sign Up",
                                                         attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                                      NSAttributedString.Key.foregroundColor:
                                                                     UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1) ])
        attributedTitle.append(attributedTitle2)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(signUpActionButton), for: .touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginVC.viewDidLoad")
        navigationController?.navigationBar.isHidden  = true
        view.backgroundColor = .white
      //  self.view.addSubview(emailTextField)
        
//        emailTextField.anchor(top: view.topAnchor,
//                              left: view.leftAnchor,
//                              bottom: nil,
//                              right: view.rightAnchor,
//                              paddingTop: 40,
//                              paddingLeft: 20,
//                              paddingBottom: 0,
//                              paddingRight: 20,
//                              width: 0,
//                              height: 40)
        view.addSubview(logoContainerView)
        configureViewComponents()
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil,
                                     left: view.leftAnchor,
                                     bottom: view.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingTop: 0,
                                     paddingLeft: 0,
                                     paddingBottom: 0,
                                     paddingRight: 0,
                                     width: 0,
                                     height: 50)
        
    }
    @objc private func formValidation(){
        
        guard emailTextField.hasText,
              passwordTextField.hasText else {
            loginBottom.isEnabled = false
            loginBottom.backgroundColor = UIColor(red:149/255, green: 204 / 255, blue: 244/255, alpha: 1)
            return
        }

            self.loginBottom.isEnabled = true
            self.loginBottom.backgroundColor = UIColor(red:17/255, green: 154 / 255, blue: 237 / 255, alpha: 1)
            
 
    }
    @objc private func signUpActionButton(){
        
        print("LoginVC.signUpActionButton")
        let signUpViewController = SingUpVC()
        
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc func handleLogin(){
        print("handleLogin clicked")
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("error \(error.localizedDescription)")
                
                
            }
            
            print("success login...")
        }
        
    }
    
    private func configureViewComponents(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginBottom])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        
        
        view.addSubview(stackView)

        
        logoContainerView.anchor(top: view.topAnchor,
                                 left: view.leftAnchor,
                                 bottom: nil,
                                 right: view.rightAnchor,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 0,
                                 height: 150)
        
        stackView.anchor(top: logoContainerView.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 20,
                         paddingBottom: 0,
                         paddingRight: 20,
                         width: 0,
                         height: 140)
    }
    
}

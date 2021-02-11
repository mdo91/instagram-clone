//
//  UserProfileHeader.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
public class UserProfileHeader: UICollectionViewCell {
    
    
    //MARK: - vars & outlets
    
    weak var delegate:UserProfileHeaderDelegate?
    
    var user:User?{
        didSet{
           
            configureProfileButton()
            setUserStats(for: user)
            nameLable.text = user?.name
            if let imageURL = user?.profileImageUrl {
                profileImageView.loadImage(with: imageURL)
            }

        }
    }
    
    let profileImageView :CustomImageView = {
         let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nameLable :UILabel = {
       let lable = UILabel()
        lable.text = "Mahmut Aoata"
        lable.font = UIFont.boldSystemFont(ofSize: 12)
        return lable
    }()
    
    let postsLable:UILabel = {
      let lable = UILabel()
        lable.numberOfLines = 0
      //  lable.text = ""
        lable.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "\n",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSMutableAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor :UIColor.lightGray]))
        
        lable.attributedText = attributedText
        
        return lable
        
    }()
    
    lazy var followersLable:UILabel = {
      let lable = UILabel()
        lable.numberOfLines = 0
       // lable.text = ""
        lable.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "\n",attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "followers",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        lable.attributedText = attributedText
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowersLableAction))
        gestureRecognizer.numberOfTapsRequired = 1
        lable.isUserInteractionEnabled = true
        lable.addGestureRecognizer(gestureRecognizer)
        return lable
    }()
    
    lazy var followingLable:UILabel = {
      let lable = UILabel()
        lable.numberOfLines = 0
       // lable.text = ""
        lable.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "\n",attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSMutableAttributedString(string: "following",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        lable.attributedText = attributedText
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowingLableAction))
        gestureRecognizer.numberOfTapsRequired = 1
        lable.isUserInteractionEnabled = true
        lable.addGestureRecognizer(gestureRecognizer)
        return lable
    }()
    
    let editProfileButton :UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("Loading..", for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
       
        return button
    }()
    
    let gridButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named:"grid")!, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let listButton: UIButton = {
        
        let button = UIButton(type:.system)
        button.setImage(UIImage(named:"list")!, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
        
    }()
    let bookMarkButton: UIButton = {
        
        let button = UIButton(type:.system)
        button.setImage(UIImage(named:"ribbon")!, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(nameLable)
        profileImageView.anchor(top: self.topAnchor,
                                left: self.leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 16,
                                paddingLeft: 12,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 80, height: 80)
        nameLable.anchor(top: profileImageView.bottomAnchor,
                         left: self.leftAnchor,
                         bottom: nil,
                         right: nil,
                         paddingTop: 12,
                         paddingLeft: 12,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 0,
                         height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [postsLable,followersLable,followingLable])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(editProfileButton)
        stackView.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        editProfileButton.anchor(top: postsLable.bottomAnchor, left: postsLable.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        
        
        profileImageView.layer.cornerRadius = 80 / 2
        
        configureBottomToolbar()
        configureActionsForProfileButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - configure bottom toolbar
    
    private func configureBottomToolbar(){
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        addSubview(topDividerView)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        addSubview(bottomDividerView)
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    
    //MARK: - Configure edit profile button
    
    private func configureProfileButton(){
      
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let uid = self.user?.uid else { return}
        
        if uid == currentUser {
            editProfileButton.setTitle("Edit Profile", for: .normal)
          //  editProfileButtom.addTarget(self, action: #selector(), for: .normal)
        }else{
            
            editProfileButton.setTitleColor(.white, for: .normal)
            editProfileButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            user?.checkIfUserFollowed(completion: { userStatus in
                
                if userStatus{
                    self.editProfileButton.setTitle("Following", for: .normal)
                }else{
                    self.editProfileButton.setTitle("Follow", for: .normal)
                }
                
            })
            
           
            
           
        }
        
    }
    
//    //MARK: - configure actions for ProfileButton
//
    private func configureActionsForProfileButton(){
        
        editProfileButton.addTarget(self, action: #selector(handleEditFollowTapped), for: .touchUpInside)
        }
    
    //MARK: - handlers
    
    @objc func handleEditFollowTapped(){
        print("handleEditFollowTapped action...")
        delegate?.handleEditFollowTapped(for: self)
    }
    
    @objc func handleFollowingTapped(){
        delegate?.handleFollowingTapped(for: self)
    }
    
    @objc func handleFollowersTapped(){
        delegate?.handleFollowersTapped(for: self)
    }
    
     func setUserStats(for user: User?){
        
      //  print("setUserStats.user \(user?.uid)")
        delegate?.setUserStats(for: self)
    }
    
    func setUserStats(uid:String){
   
    }
    
    @objc func handleFollowersLableAction(){
        
        print("handleFollowersLableAction")
        delegate?.handleFollowersTapped(for: self)
        
    }
    
    @objc func handleFollowingLableAction(){
        print("handleFollowingLableAction")
        delegate?.handleFollowingTapped(for: self)
    }
   
    
}

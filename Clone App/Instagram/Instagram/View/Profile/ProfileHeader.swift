//
//  ProfileHeader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    private lazy var postFollowStackView: UIStackView = initialPostFollowStackView()
    private lazy var postLabel: UILabel = initialPostLabel()
    private lazy var followersLabel: UILabel = initialFollowersLabel()
    private lazy var followingLabel: UILabel = initialFollowingLabel()
    private lazy var profileIV: UIImageView = initialProfileIV()
    private let nameLabel: UILabel = initialNameLabel()
    private lazy var editProfileFollowButton: UIButton = initialEditProfileFollowButton()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implement")
    }
}




//MARK: - Initial subviews
extension ProfileHeader {
    
    func initialProfileIV() -> UIImageView {
        let iv = UIImageView()
        AuthService.fetchCurrentUserInfo() { userInfo in
            guard let userInfo = userInfo else { return }
            DispatchQueue.main.async {
                AuthService.fetchUserProfile(userProfile: userInfo.profileURL) { image in
                    guard let image = image else { return }
                    iv.image = image
                }
            }

        }

        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 80/2
        return iv
    }
    
    
    
    static func initialNameLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        AuthService.fetchCurrentUserInfo() { userInfo in
            guard let userInfo = userInfo  else { return }
            lb.text = userInfo.username
        }
        return lb
    }
    
     func initialPostFollowStackView() -> UIStackView {
         let sv = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
         sv.translatesAutoresizingMaskIntoConstraints = false
         sv.distribution = .fillEqually
         return sv
    }
        
    
    //MARK: - lazy properties initialize
    func initialEditProfileFollowButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.tintColor = UIColor.white
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapEditProfileFollow(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func initialPostLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 7, label: "posts")
        return label
    }
    
    func initialFollowersLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 21, label: "followers")
        return label
    }
    
    func initialFollowingLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 19, label: "following")
        return label
    }

}
 
//MARK: - event handler
extension ProfileHeader {
    
    @objc func didTapEditProfileFollow(_ sender: Any) {
        print("tapped ")
    }
}



//MARK: - Setup subviews
extension ProfileHeader {
    func setupSubview() {
        addSubviews()
        setupSubviewsConstraints()
    }
    
    func addSubviews() {
        addSubview(profileIV)
        addSubview(postFollowStackView)
        addSubview(nameLabel)
        addSubview(editProfileFollowButton)
        
    }
    
    func setupSubviewsConstraints() {
        setupPostIVConstraints()
        setupNameLabelConstraints()
        setupEditProfileFollowButtonConstraints()
        setupPostFollowStackViewConstraints()
    }
    
}

//MARK: - Setup subviews constraints
extension ProfileHeader {
    
    func setupPostIVConstraints() {
        NSLayoutConstraint.activate([
            profileIV.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileIV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileIV.widthAnchor.constraint(equalToConstant: 80),
            profileIV.heightAnchor.constraint(equalToConstant: 80)])
    }
    
    func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileIV.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileIV.leadingAnchor, constant: 12)])
    }
    
    func setupEditProfileFollowButtonConstraints() {
        NSLayoutConstraint.activate([
            editProfileFollowButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            editProfileFollowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            editProfileFollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)])
    }
    
    func setupPostFollowStackViewConstraints() {
        NSLayoutConstraint.activate([
            postFollowStackView.centerYAnchor.constraint(equalTo: profileIV.centerYAnchor),
            postFollowStackView.leadingAnchor.constraint(equalTo: profileIV.trailingAnchor, constant: 12),
            postFollowStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)])
    }
    
}


//MARK: - Helpers
extension ProfileHeader {
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n" ,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}

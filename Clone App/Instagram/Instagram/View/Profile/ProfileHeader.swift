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
    private let profileIV: UIImageView = initialProfileIV()
    private let nameLabel: UILabel = initialNameLabel()
    
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
    
    static func initialProfileIV() -> UIImageView {
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
}



//MARK: - Setup subviews
extension ProfileHeader {
    func setupSubview() {
        addSubviews()
        setupSubviewsConstraints()
    }
    
    func addSubviews() {
        addSubview(profileIV)
        addSubview(nameLabel)
    }
    
    func setupSubviewsConstraints() {
        setupPostIVConstraints()
        setupNameLabelConstraints()
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
    
}

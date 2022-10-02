//
//  FeedCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/01.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let profileImageView: UIImageView = initialProfileImageVIew()
    private lazy var usernameButton: UIButton = initialUsernameButton()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - setupCellUI
extension FeedCell {
    
    func setupUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(usernameButton)
        
        setupProfileImageViewConstraints()
        setupUsernameButtonConstraints()
    }
}

//MARK: - Helpers
extension FeedCell {
    
    //MARK: - Initial properties
    static func initialProfileImageVIew() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(imageLiteralResourceName: "girl-1")
        iv.layer.cornerRadius = 40/2
        return iv
    }
    
    func initialUsernameButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ksa_qs", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(didTapUsername(_:)), for: .touchUpInside)
        return btn
    }
}


//MARK: - Setup subview's constraints
extension FeedCell {
    
    func setupProfileImageViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    func setupUsernameButtonConstraints() {
        NSLayoutConstraint.activate([
            usernameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)])
    }
}


//MARK: - Setup event handler
extension FeedCell {
    
    @objc func didTapUsername(_ sender: Any) {
        print("DEBUG : did tap username")
    }
}

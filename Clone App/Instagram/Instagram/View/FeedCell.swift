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
        
        setupProfileImageViewConstraints()
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
}

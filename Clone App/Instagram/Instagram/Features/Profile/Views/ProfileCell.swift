//
//  ProfileCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/27.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    let postIV: UIImageView = initialPostIV()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implement")
    }
    
    override func prepareForReuse() {
        postIV.image = nil
    }
}

//MARK: - Initial subviews
extension ProfileCell {
    
    static func initialPostIV() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }
}

//MARK: - Setup subviews
extension ProfileCell {
    func setupSubview() {
        addSubview(postIV)
        
        setupPostIVConstraints()
    }
}

//MARK: - Setup subviews constraints
extension ProfileCell {
    func setupPostIVConstraints() {
        NSLayoutConstraint.activate([postIV.topAnchor.constraint(equalTo: topAnchor),
                                     postIV.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     postIV.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     postIV.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}

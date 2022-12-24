//
//  CommentCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    let profileImageView = initialProfileImageView()
    let commentLabel = initialCommentLabel()
    
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not use.")
    }
}

//MARK: - Helpers
extension CommentCell {
    
    func configureUI() {
        
        addSubviews()
        constraintsSubviews()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(commentLabel)
    }
    
    func constraintsSubviews() {
        profileImageViewConstraints()
        commentLabelConstraints()
    }
}

//MARK: - Initial subViews
extension CommentCell {
    
    static func initialProfileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemPink
        iv.layer.cornerRadius = 40/2
        return iv
    }
    
    static func initialCommentLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        let attrStr = NSMutableAttributedString(string: "username ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attrStr.append(NSAttributedString(string: "Some test comment need...", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        lb.attributedText = attrStr
        
        return lb
    }
}

//MARK: - Constraint subview's auto layout
extension CommentCell {
    
    func profileImageViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    func commentLabelConstraints() {
        NSLayoutConstraint.activate([
            commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            commentLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)])
    }
}

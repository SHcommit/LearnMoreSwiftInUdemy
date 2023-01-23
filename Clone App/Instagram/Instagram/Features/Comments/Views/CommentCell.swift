//
//  CommentCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    var profileImageView: UIImageView!
    var commentLabel: UILabel!
    
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not use.")
    }
}

//MARK: - ConfigureSubviewsCase
extension CommentCell: ConfigureSubviewsCase {
    
    func configureSubviews() {
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        profileImageView = UIImageView()
        commentLabel = UILabel()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(commentLabel)
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }
    
    
}

//MARK: - SetupSubviewsLayouts
extension CommentCell: SetupSubviewsLayouts {
    
    func setupSubviewsLayouts() {
        
        /// Setup profileImageView layout
        UtilsUI.setupLayout(detail: profileImageView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .systemPink
            $0.layer.cornerRadius = 40/2
        }
        
        /// Setup commentLabel layout
        UtilsUI.setupLayout(detail: commentLabel) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(
                string: "username ",
                attributes:
                    [.font: UIFont.boldSystemFont(ofSize: 14)])
            attrStr.append(NSAttributedString(string: "Some test comment need...", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            $0.attributedText = attrStr
            $0.numberOfLines = 0
        }
    }
    
    
}

//MARK: - SetupSubviewsComstraints
extension CommentCell: SetupSubviewsConstraints {
    
    func setupSubviewsConstraints() {
        
        /// Setup profileImageView constraints
        UtilsUI.setupConstraints(with: profileImageView) {
            [$0.leading.constraint(equalTo: leading, constant: 8),
             $0.top.constraint(equalTo: top, constant: 8),
             $0.width.constraint(equalToConstant: 40),
             $0.height.constraint(equalToConstant: 40)]
        }
        
        /// Setup commentLabel constraints
        UtilsUI.setupConstraints(with: commentLabel) {
            [$0.leading.constraint(equalTo: profileImageView.trailing,
                                   constant: 8),
             $0.trailing.constraint(equalTo: trailing, constant:  -8),
             $0.top.constraint(equalTo: profileImageView.centerY,
                               constant: -8)]
        }
    }

}


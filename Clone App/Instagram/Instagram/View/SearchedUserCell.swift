//
//  SearchedUserCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/03.
//

import UIKit


class SearchedUserCell: UITableViewCell {
    
    //MARK: - Properties
    private let profileImageView: UIImageView = initProfileImageView()
    private let usernameLabel: UILabel = initUsernameLabel()
    private let fullnameLabel: UILabel = initFullnameLabel()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - View Helpers
extension SearchedUserCell {
    
    func configureSubview() {
        addSubviews()
        setupSubviewConstraints()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
    }
    
    func setupSubviewConstraints() {
        setupProfileImageViewConstriants()
        setupUsernameLabelConstraints()
        setupFullnameLabelConstraints()
    }
}

//MARK: - Initialize subviews
extension SearchedUserCell {
    
    static func initProfileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor  = .lightGray
        iv.image = .imageLiteral(name: "girl-1")
        iv.layer.cornerRadius = SEARCHED_USER_CELL_PROFILE_WIDTH/2
        
        return iv
    }
    
    static func initUsernameLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.text = "Jessy"
        return lb
    }
    
    static func initFullnameLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = .lightGray
        lb.text = "Jessy Kim"
        return lb
    }
    
}

//MARK: - Setup subivew constraints
extension SearchedUserCell {
    
    func setupProfileImageViewConstriants() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
            profileImageView.widthAnchor.constraint(equalToConstant: SEARCHED_USER_CELL_PROFILE_WIDTH),
            profileImageView.heightAnchor.constraint(equalToConstant: SEARCHED_USER_CELL_PROFILE_WIDTH)])
    }
    
    func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7),
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: SEARCHED_USER_CELL_PROFILE_MARGIN*3)])
    }
    
    func setupFullnameLabelConstraints() {
        NSLayoutConstraint.activate([
            fullnameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7),
            fullnameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SEARCHED_USER_CELL_PROFILE_MARGIN*3)])
    }
}

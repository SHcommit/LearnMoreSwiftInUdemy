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
    private lazy var nameStackView: UIStackView = initNameStackView()
    var userVM: UserInfoViewModel? {
        didSet {
            configureText()
            configureImage()
        }
    }
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
}

//MARK: - View Helpers
extension SearchedUserCell {
    
    func configureText() {
        guard let userVM = userVM else { return }
        usernameLabel.text = userVM.username()
        fullnameLabel.text = userVM.fullname()
    }
    
    func configureImage() {
        guard let userVM = userVM else { return }
        self.profileImageView.image = userVM.image()
    }
    
    func configureSubview() {
        addSubviews()
        setupSubviewConstraints()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(nameStackView)
    }
    
    func setupSubviewConstraints() {
        setupProfileImageViewConstriants()
        setupNameStackViewConstraints()
    }
}

//MARK: - Initialize subviews
extension SearchedUserCell {
    
    static func initProfileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor  = .white
        iv.layer.cornerRadius = SEARCHED_USER_CELL_PROFILE_WIDTH/2
        
        return iv
    }
    
    static func initUsernameLabel() -> UILabel {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: SEARCHED_USER_CELL_FONT_SIZE)
        return lb
    }
    
    static func initFullnameLabel() -> UILabel {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: SEARCHED_USER_CELL_FONT_SIZE)
        lb.textColor = .lightGray
        return lb
    }
    
    func initNameStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = SEARCHED_USER_CELL_STACKVIEW_SPACING
        sv.alignment = .leading
        
        return sv
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
    
    func setupNameStackViewConstraints() {
        NSLayoutConstraint.activate([
            nameStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
            nameStackView.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
}

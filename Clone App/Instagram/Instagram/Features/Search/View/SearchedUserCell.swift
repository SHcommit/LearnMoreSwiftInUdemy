//
//  SearchedUserCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/03.
//

import UIKit


class SearchedUserCell: UITableViewCell {
    
    //MARK: - Properties
    fileprivate var profileImageView: UIImageView!
    fileprivate var usernameLabel: UILabel!
    fileprivate var fullnameLabel: UILabel!
    fileprivate var nameStackView: UIStackView!
    internal var vm: SearchedCellViewModel? {
        didSet {
            configureText()
            configureImage()
        }
    }
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
}

//MARK: - View Configure
extension SearchedUserCell {
    
    func configureText() {
        guard let userVM = vm else { return }
        usernameLabel.text = userVM.username()
        fullnameLabel.text = userVM.fullname()
    }
    
    func configureImage() {
        guard let userVM = vm else { return }
        self.profileImageView.image = userVM.image()
    }

}

//MARK: - ConfigureSubviewsCase
extension SearchedUserCell: ConfigureSubviewsCase {
    
    func configureSubviews() {
        createSubviews()
        addSubviews()
        setupLayouts()
    }
    
    func createSubviews() {
        profileImageView = UIImageView()
        usernameLabel = UILabel()
        fullnameLabel = UILabel()
        nameStackView = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(nameStackView)
    }
    
    func setupLayouts() {
        setupSubviewsLayouts()
        setupSubviewsConstraints()
    }

}

//MARK: - SetupSubviewsLayouts
extension SearchedUserCell: SetupSubviewsLayouts{
    
    func setupSubviewsLayouts() {
        setupProfileImageView()
        setupUsernameLabel()
        setupFullnameLabel()
        setupNameStackView()
    }
    
    private func setupProfileImageView() {
        UIConfig.setupLayout(detail: profileImageView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = SEARCHED_USER_CELL_PROFILE_WIDTH/2
        }
    }
    
    private func setupUsernameLabel() {
        UIConfig.setupLayout(detail: usernameLabel) {
            $0.font = UIFont.boldSystemFont(ofSize: SEARCHED_USER_CELL_FONT_SIZE)
        }
    }
    
    private func setupFullnameLabel() {
        UIConfig.setupLayout(detail: fullnameLabel) {
            $0.font = UIFont.systemFont(ofSize: SEARCHED_USER_CELL_FONT_SIZE)
            $0.textColor = .lightGray
        }
    }
    
    private func setupNameStackView() {
        UIConfig.setupLayout(detail: nameStackView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = SEARCHED_USER_CELL_STACKVIEW_SPACING
            $0.alignment = .leading
        }
    }
    
}

//MARK: - SetupSubviewsConstraints
extension SearchedUserCell: SetupSubviewsConstraints {
    
    func setupSubviewsConstraints() {
        setupProfileImageViewConstriants()
        setupNameStackViewConstraints()
    }
    
    func setupProfileImageViewConstriants() {
        UIConfig.setupConstraints(with: profileImageView) {
            [$0.leading.constraint(equalTo: leading,
                                   constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
             $0.top.constraint(equalTo: top, constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
             $0.width.constraint(equalToConstant: SEARCHED_USER_CELL_PROFILE_WIDTH),
             $0.height.constraint(equalToConstant: SEARCHED_USER_CELL_PROFILE_WIDTH)]
        }
    }
    
    func setupNameStackViewConstraints() {
        UIConfig.setupConstraints(with: nameStackView) {
            [$0.leading.constraint(equalTo: profileImageView.trailing,
                                      constant: SEARCHED_USER_CELL_PROFILE_MARGIN),
             $0.centerY.constraint(equalTo: centerY)]
            
        }

    }
}

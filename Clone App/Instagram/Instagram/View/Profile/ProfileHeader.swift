//
//  ProfileHeader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/27.
//

import UIKit
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: UserInfoModel)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    private lazy var postFollowStackView: UIStackView = initialPostFollowStackView()
    private lazy var postLabel: UILabel = initialPostLabel()
    private lazy var followersLabel: UILabel = initialFollowersLabel()
    private lazy var followingLabel: UILabel = initialFollowingLabel()
    private lazy var profileIV: UIImageView = initialProfileIV()
    private var nameLabel: UILabel = initialNameLabel()
    private lazy var editProfileFollowButton: UIButton = initialEditProfileFollowButton()
    
    private lazy var buttonStackView: UIStackView = initialButtonStackView()
    private lazy var gridBtn: UIButton = initialGridBtn()
    private lazy var listBtn: UIButton = initialListBtn()
    private lazy var bookMarkBtn: UIButton = initialBookMarkBtn()
    
    weak var delegate: ProfileHeaderDelegate?
    var vm: ProfileHeaderViewModel? {
        didSet {
            setupBindings()
        }
    }
    var subscriptions = Set<AnyCancellable>()
    
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

//MARK: - Helpers
extension ProfileHeader {
    
    func setupBindings() {
        vm?.$user
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                configureUI()
            }.store(in: &subscriptions)
        vm?.$profileImage
            .receive(on: RunLoop.main)
            .sink { [unowned self] image in
                profileIV.image = image
            }.store(in: &subscriptions)
        vm?.$userStats
            .receive(on: RunLoop.main)
            .sink{ [unowned self] stats in
                followersLabel.attributedText = vm?.numberOfFollowers()
                followingLabel.attributedText = vm?.numberOfFollowing()
            }.store(in: &subscriptions)
    }
    
    func configureUI() {
        guard let vm = vm else { return }
        nameLabel.text = vm.username()
        editProfileFollowButton.setTitle(vm.followButtonText(), for: .normal)
        editProfileFollowButton.setTitleColor(vm.followButtonTextColor(), for: .normal)
        editProfileFollowButton.backgroundColor = vm.followButtonBackgroundColor()
        postLabel.attributedText = vm.numberOfPosts()
        followersLabel.attributedText = vm.numberOfFollowers()
        followingLabel.attributedText = vm.numberOfFollowing()
    }
    
}

//MARK: - event handler
extension ProfileHeader {
    
    @objc func didTapEditProfileFollow(_ sender: Any) {
        guard let vm = vm else { return }
        delegate?.header(self, didTapActionButtonFor: vm.getUserInfo())
    }
    
    @objc func didTapGridBtn(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        button.tintColor = .systemPink
        listBtn.tintColor = .black
        bookMarkBtn.tintColor = .black
        
    }
    
    @objc func didTapListBtn(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        button.tintColor = .systemPink
        gridBtn.tintColor = .black
        bookMarkBtn.tintColor = .black
        
    }
    
    @objc func didTapBookMarkBtn(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        button.tintColor = .systemPink
        gridBtn.tintColor = .black
        listBtn.tintColor = .black
        
    }
}

//MARK: - Initial subviews
extension ProfileHeader {
    
    static func initialNameLabel() -> UILabel {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }
    
    
    //MARK: - lazy properties initialize
    func initialProfileIV() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 80/2
        iv.backgroundColor = .lightGray
        return iv
    }
    
    func initialGridBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(.imageLiteral(name: "grid"), for: .normal)
        btn.tintColor = .systemPink
        btn.addTarget(self, action: #selector(didTapGridBtn(_:)), for: .touchUpInside)
        return btn
    }
    
    func initialListBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(.imageLiteral(name: "list"), for: .normal)
        btn.setImage(.imageLiteral(name: "list"), for: .highlighted)
        btn.tintColor = .black
        btn.isSelected = false
        btn.addTarget(self, action: #selector(didTapListBtn(_:)), for: .touchUpInside)
        return btn
    }
    
    func initialBookMarkBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(.imageLiteral(name: "ribbon"), for: .normal)
        btn.setImage(.imageLiteral(name: "ribbon"), for: .highlighted)
        btn.addTarget(self, action: #selector(didTapBookMarkBtn(_:)), for: .touchUpInside)
        btn.isSelected = false
        btn.tintColor = .black
        return btn
    }
    
    func initialButtonStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [gridBtn, listBtn, bookMarkBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        return sv
    }
    
    func initialPostFollowStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        return sv
   }
    
    func initialEditProfileFollowButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
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
        return label
    }
    
    func initialFollowersLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    func initialFollowingLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
        addSubview(buttonStackView)
        
    }
    
    func setupSubviewsConstraints() {
        setupPostIVConstraints()
        setupNameLabelConstraints()
        setupEditProfileFollowButtonConstraints()
        setupPostFollowStackViewConstraints()
        setupButtonStackViewConstraints()
        setupTopDivider()
        setupBottomDivider()
    }
    
    func setupTopDivider() {
        let topDivider = UIView()
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        topDivider.backgroundColor = .lightGray
        addSubview(topDivider)
        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            topDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 0.5)])
    }
    
    func setupBottomDivider() {
        let bottomDivider = UIView()
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.backgroundColor = .lightGray
        addSubview(bottomDivider)
        NSLayoutConstraint.activate([
            bottomDivider.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5)])
    }
    
}

//MARK: - Setup subviews constraints
extension ProfileHeader {
    
    func setupButtonStackViewConstraints() {
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)])
    }
    
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


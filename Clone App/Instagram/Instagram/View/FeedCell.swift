//
//  FeedCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/01.
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let profileImageView: UIImageView = initialProfileImageVIew()
    private let postImageView: UIImageView = initialPostImageView()
    private let likeLabel: UILabel = initialLikeLabel()
    private let captionLabel: UILabel = initialCaptionLabel()
    private let postTimeLabel: UILabel = initialPostTimeLabel()
    private lazy var usernameButton: UIButton = initialUsernameButton()
    private lazy var likeButton: UIButton = initialLikeButton()
    private lazy var commentButton: UIButton = initialCommentButton()
    private lazy var shareButton: UIButton = initialShareButton()
    
    private var isSelectedLikeButton: Bool = false
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
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
        addSubviews()
        setupSubViewsConstraints()
    }
    
    func addSubviews() {
        addSubview(profileImageView)
        addSubview(usernameButton)
        addSubview(postImageView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(likeLabel)
        addSubview(captionLabel)
        addSubview(postTimeLabel)
    }
}

//MARK: - Helpers
extension FeedCell {
    
    func configure() {
        guard let viewModel = viewModel else { return }
        captionLabel.text = viewModel.caption
        usernameButton.setTitle(viewModel.username, for: .normal)
        let date = Date(timeIntervalSince1970: TimeInterval(viewModel.postTime.seconds))
        postTimeLabel.text = "\(date)"
    }
    
    func configureProfileImage() {
        guard let viewModel = viewModel else { return }
        profileImageView.image = viewModel.postedUserProfile
    }
    
    func configurePostImage() {
        guard let viewModel = viewModel else { return }
        postImageView.image = viewModel.image
    }
    
    //MARK: - Initial properties
    static func initialProfileImageVIew() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40/2
        iv.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        return iv
    }
    
    func initialUsernameButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ksa_qs", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(didTapUsername(_:)), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        return btn
    }
    
    static func initialPostImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.setContentCompressionResistancePriority(UILayoutPriority(998), for: .vertical)
        return iv
    }
    
    func initialLikeButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
        btn.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        btn.tintColor = .black
        return btn
    }
    
    func initialCommentButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.imageLiteral(name: "comment"), for: .normal)
        btn.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        btn.tintColor = .black
        return btn
    }
    
    func initialShareButton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.imageLiteral(name: "send2"), for: .normal)
        btn.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        btn.tintColor = .black
        return btn
    }
    
    static func initialLikeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1 like"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        return label
    }
    
    static func initialCaptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        return label
    }
    
    static func initialPostTimeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 days ago"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        return label
    }
}


//MARK: - Setup subview's constraints
extension FeedCell {
    
    func setupSubViewsConstraints() {
        setupProfileImageViewConstraints()
        setupUsernameButtonConstraints()
        setupPostImageViewConstarints()
        setupLikeButtonConstraints()
        setupCommentButtonConstraints()
        setupShareButtonConstraints()
        setupLikeLabelConstraints()
        setupCaptionLabelConstraints()
        setupPostTimeLabelConstraints()
    }
    
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
    
    func setupPostImageViewConstarints() {
        NSLayoutConstraint.activate([
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    func setupLikeButtonConstraints() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 12),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    func setupCommentButtonConstraints() {
        NSLayoutConstraint.activate([
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 12)])
    }
    
    func setupShareButtonConstraints() {
        NSLayoutConstraint.activate([
            shareButton.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 12)])
    }
    
    func setupLikeLabelConstraints() {
        NSLayoutConstraint.activate([
            likeLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 12),
            likeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    func setupCaptionLabelConstraints() {
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    func setupPostTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            postTimeLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12),
            postTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            postTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}


//MARK: - Setup event handler
extension FeedCell {
    
    @objc func didTapUsername(_ sender: Any) {
        print("DEBUG : did tap username")
    }
    
    @objc func didTapLikeButton(_ sender: Any) {
        guard isSelectedLikeButton else{
            isSelectedLikeButton = true
            likeButton.setImage(.imageLiteral(name: "like_selected"), for: .normal)
            return
        }
        isSelectedLikeButton = false
        likeButton.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
    }
}

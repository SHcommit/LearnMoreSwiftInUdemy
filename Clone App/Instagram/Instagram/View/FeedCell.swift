//
//  FeedCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/01.
//

import UIKit
import Firebase
import Combine

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

    var didTapCommentPublisher = PassthroughSubject<UINavigationController?,Never>()
    var didTapLikePublisher = PassthroughSubject<UIButton,Never>()
    private var subscriptions = Set<AnyCancellable>()
    var feedControllerNavigationController: UINavigationController?
    
    var viewModel: FeedCellViewModelType?
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    //
    // 임시적으로 흰색으로 만듬. cache 추후 적용시켜야함
    //
    //
    override func prepareForReuse() {
        profileImageView.image = nil
        postImageView.image = nil
        subscriptions.forEach { $0.cancel() }
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
    
    func setupBinding(with navigationController: UINavigationController?) {
        feedControllerNavigationController = navigationController
        
        let input = FeedCellViewModelInput(didTapComment: didTapCommentPublisher.eraseToAnyPublisher(),
                               didTapLike: didTapLikePublisher.eraseToAnyPublisher())
        
        let output = viewModel?.transform(input: input)
        output? .sink { state in
            self.render(state)
        }.store(in: &subscriptions)
    }
    
}

//MARK: - Setup event handler
extension FeedCell {
    
    @objc func didTapUsername(_ sender: Any) {
        print("DEBUG : did tap username")
    }
    
    @objc func didTapLikeButton(_ sender: Any) {
        didTapLikePublisher.send(likeButton)
    }
    
    @objc func didTapComment(_ sender: Any) {
        didTapCommentPublisher.send(feedControllerNavigationController)
    }
    
}


//MARK: - Helpers
extension FeedCell {
    
    func render(_ state: FeedCellState) {
        switch state {
        case .none:
            break
        case .present(let navigationController):
            guard let post = self.viewModel?.post else { return }
            let controller = CommentController(viewModel: CommentViewModel(post: post))
            navigationController?.pushViewController(controller, animated: true)
            break
        case .updateLikeLabel:
            self.likeLabel.text = self.viewModel?.postLikes
            break
        }
    }
    
    func configure() {
        guard var viewModel = viewModel else { return }
        captionLabel.text = viewModel.caption
        usernameButton.setTitle(viewModel.username, for: .normal)
        likeLabel.text = viewModel.postLikes
        let date = Date(timeIntervalSince1970: TimeInterval(viewModel.postTime.seconds))
        postTimeLabel.text = "\(date)"
        viewModel.didLike = false
        
        Task(priority: .high) {
            let didLike = await PostService.checkIfUserLikedPost(post: viewModel.post)
            viewModel.didLike = didLike
            DispatchQueue.main.async {
                if didLike {
                    self.likeButton.setImage(.imageLiteral(name: "like_selected"), for: .normal)
                    self.likeButton.tintColor = .red
                }else {
                    self.likeButton.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
                    self.likeButton.tintColor = .black
                }
            }
        }
        Task(priority: .high) {
            await viewModel.fetchPostImage()
            await viewModel.fetchUserProfile()
            DispatchQueue.main.async {
                self.configurePostImage()
                self.configureProfileImage()
            }
        }
    }
    
    func configureProfileImage() {
        guard let viewModel = viewModel else { return }
        profileImageView.image = viewModel.postedUserProfile
    }
    
    func configurePostImage() {
        guard let viewModel = viewModel else { return }
        postImageView.image = viewModel.image
    }
}

//MARK: - Init properites
extension FeedCell {
    
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
        btn.addTarget(self, action: #selector(didTapComment(_:)), for: .touchUpInside)
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

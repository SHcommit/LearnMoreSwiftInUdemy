//
//  FeedCell.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/01.
//

import UIKit
import Firebase
import Combine

protocol FeedCellDelegate: AnyObject {
  //코디네이터에 속한거로 인디케이터 표시할라했는데 안먹혀서 델리게이트만듬..
  func wantsToShowIndicator()
  func wantsToHideIndicator()
}

class FeedCell: UICollectionViewCell {
  
  //MARK: - Properties
  weak var coordinator: FeedFlowCoordinator?
  weak var delegate: FeedCellDelegate?
  fileprivate var profileImageView: UIImageView!
  fileprivate var postImageView: UIImageView!
  fileprivate var likeLabel: UILabel!
  fileprivate var captionLabel: UILabel!
  fileprivate var postTimeLabel: UILabel!
  fileprivate var usernameButton: UIButton!
  fileprivate var likeButton: UIButton!
  fileprivate var commentButton: UIButton!
  fileprivate var shareButton: UIButton!
  fileprivate var didTapUserProfile = PassthroughSubject<String,Never>()
  fileprivate var didTapCommentPublisher = PassthroughSubject<Void,Never>()
  fileprivate var didTapLikePublisher = PassthroughSubject<(UIButton,FeedCellDelegate?),Never>()
  fileprivate var subscriptions = Set<AnyCancellable>()
  
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
    configureSubviews()
  }
  
  func setupBinding() {
    
    let input = FeedCellViewModelInput(
      didTapProfile: didTapUserProfile.eraseToAnyPublisher(),
      didTapComment: didTapCommentPublisher.eraseToAnyPublisher(),
      didTapLike: didTapLikePublisher.eraseToAnyPublisher())
    
    let output = viewModel?.transform(input: input)
    output?
      .receive(on: RunLoop.main)
      .sink { state in
        self.render(state)
      }.store(in: &subscriptions)
  }
  
}

//MARK: - Setup event handler
extension FeedCell {
  
  @objc func didTapUsername(sender: AnyObject?) {
    didTapUserProfile.send(viewModel?.userUID ?? "")
  }
  
  @objc func didTapLikeButton(_ sender: Any) {
    delegate?.wantsToShowIndicator()
    didTapLikePublisher.send((likeButton,delegate))
  }
  
  @objc func didTapComment(_ sender: Any) {
    didTapCommentPublisher.send()
  }
  
}


//MARK: - Helpers
extension FeedCell {
  
  func render(_ state: FeedCellState) {
    switch state {
    case .none:
      break
    case .deleteIndicator:
      delegate?.wantsToHideIndicator()
      break
    case .showComment:
      guard let post = self.viewModel?.post else { return }
      coordinator?.gotoCommentPage(with: post)
    case .updateLikeLabel:
      self.likeLabel.text = self.viewModel?.postLikes
      break
    case .showProfile(let selectedUser):
      coordinator?.gotoProfilePage(with: selectedUser)
      break
    case .fail(let result):
      print("DEBUG: \(result)")
      break
    }
  }
  
  func configure() {
    let apiClient = ServiceProvider.defaultProvider()
    guard var viewModel = viewModel else { return }
    captionLabel.text = viewModel.caption
    usernameButton.setTitle(viewModel.username, for: .normal)
    likeLabel.text = viewModel.postLikes
    let date = Date(timeIntervalSince1970: TimeInterval(viewModel.postTime.seconds))
    postTimeLabel.text = "\(date)"
    viewModel.didLike = false
    
    Task(priority: .high) {
      let didLike = await apiClient.postCase.checkIfUserLikedPost(post: viewModel.post)
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

//MARK: - ConfigureSubviewsCase
extension FeedCell: ConfigureSubviewsCase {
  func configureSubviews() {
    createSubviews()
    addSubviews()
    setupLayouts()
  }
  
  func createSubviews() {
    profileImageView = UIImageView()
    usernameButton = UIButton(type: .system)
    postImageView = UIImageView()
    likeLabel = UILabel()
    commentButton = UIButton()
    shareButton = UIButton(type: .system)
    likeButton = UIButton(type: .system)
    captionLabel = UILabel()
    postTimeLabel = UILabel()
  }
  
  func addSubviews() {
    _=[profileImageView, usernameButton, postImageView,
       likeLabel, commentButton, shareButton, likeButton,
       captionLabel, postTimeLabel].map{addSubview($0)}
  }
  
  func setupLayouts() {
    setupSubviewsLayouts()
    setupSubviewsConstraints()
  }
  
  
}

//MARK: - SetupSubviewsLayouts
extension FeedCell: SetupSubviewsLayouts {
  
  func setupSubviewsLayouts() {
    
    ///Setup profileImageView layout
    UtilsUI.setupLayout(detail: profileImageView) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
      $0.isUserInteractionEnabled = true
      $0.backgroundColor = .lightGray
      $0.layer.cornerRadius = 40/2
      $0.setContentCompressionResistancePriority(
        UILayoutPriority(999), for: .vertical)
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapUsername))
      $0.isUserInteractionEnabled = true
      $0.addGestureRecognizer(tap)
    }
    
    /// Setup usernameButton layout
    UtilsUI.setupLayout(detail: usernameButton) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setTitleColor(.black, for: .normal)
      $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
      $0.addTarget(self, action: #selector(self.didTapUsername), for: .touchUpInside)
      $0.setContentCompressionResistancePriority(
        UILayoutPriority(999), for: .vertical)
    }
    
    /// Setup postImageView layout
    UtilsUI.setupLayout(detail: postImageView) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
      $0.isUserInteractionEnabled = true
      $0.setContentCompressionResistancePriority(
        UILayoutPriority(998), for: .vertical)
    }
    
    /// Setup likeButton layout
    UtilsUI.setupLayout(detail: likeButton) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
      $0.addTarget(self, action: #selector(self.didTapLikeButton(_:)), for: .touchUpInside)
      $0.setContentCompressionResistancePriority(
        UILayoutPriority(999), for: .vertical)
      $0.tintColor = .black
    }
    
    /// Setup commentButton layout
    UtilsUI.setupLayout(detail: commentButton) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(.imageLiteral(name: "comment"), for: .normal)
      $0.addTarget(self, action: #selector(self.didTapComment(_:)), for: .touchUpInside)
      $0.setContentCompressionResistancePriority(
        UILayoutPriority(999), for: .vertical)
      $0.tintColor = .black
    }
    
    /// Setup commentButton layout
    UtilsUI.setupLayout(detail: shareButton) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(.imageLiteral(name: "send2"), for: .normal)
      $0.addTarget(self, action: #selector(self.didTapLikeButton(_:)), for: .touchUpInside)
      $0.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
      $0.tintColor = .black
      
    }
    
    /// Setup likeLabel layout
    UtilsUI.setupLayout(detail: likeLabel) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.boldSystemFont(ofSize: 12)
      $0.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
      
    }
    
    /// Setup captionLabel layout
    UtilsUI.setupLayout(detail: captionLabel) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.boldSystemFont(ofSize: 12)
      $0.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
    }
    
    /// Setup postTimeLabel layout
    UtilsUI.setupLayout(detail: postTimeLabel) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.boldSystemFont(ofSize: 12)
      $0.textColor = .lightGray
      $0.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
    }
  }
  
  
}

//MARK: - SetupSubviewsConstraints
extension FeedCell: SetupSubviewsConstraints {
  
  func setupSubviewsConstraints() {
    
    ///Setup profileImageView constraints
    UtilsUI.setupConstraints(with: profileImageView) {
      return [$0.top.constraint(equalTo: top, constant: 12),
              $0.leading.constraint(equalTo: leading, constant: 12),
              $0.width.constraint(equalToConstant: 40),
              $0.height.constraint(equalToConstant: 40)]
    }
    
    ///Setup usernameButton constraints
    UtilsUI.setupConstraints(with: usernameButton) {
      return [$0.centerY.constraint(equalTo: profileImageView.centerY),
              $0.leading.constraint(equalTo: profileImageView.trailing, constant: 8)]
    }
    
    ///Setup postImageView constraints
    UtilsUI.setupConstraints(with: postImageView) {
      return [$0.leading.constraint(equalTo: leading),
              $0.top.constraint(equalTo: profileImageView.bottom, constant: 12),
              $0.trailing.constraint(equalTo: trailing)]
    }
    
    ///Setup likeButton constraints
    UtilsUI.setupConstraints(with: likeButton) {
      return [$0.top.constraint(equalTo: postImageView.bottom,
                                constant: 12),
              $0.leading.constraint(equalTo: leading, constant: 12)]
    }
    
    ///Setup commentButton constraints
    UtilsUI.setupConstraints(with: commentButton) {
      return [$0.centerY.constraint(equalTo: likeButton.centerY),
              $0.leading.constraint(equalTo: likeButton.trailing,
                                    constant: 12)]
    }
    
    ///Setup shareButton constraints
    UtilsUI.setupConstraints(with: shareButton) {
      return [$0.centerY.constraint(equalTo: commentButton.centerY),
              $0.leading.constraint(equalTo: commentButton.trailing,
                                    constant: 12)]
    }
    
    ///Setup likeLabel constraints
    UtilsUI.setupConstraints(with: likeLabel) {
      return [$0.top.constraint(equalTo: likeButton.bottom,
                                constant: 12),
              $0.leading.constraint(equalTo: leading, constant: 12)]
    }
    
    ///Setup captionLabel constraints
    UtilsUI.setupConstraints(with: captionLabel) {
      return [$0.top.constraint(equalTo: likeLabel.bottom,
                                constant: 12),
              $0.leading.constraint(equalTo: leading, constant: 12)]
    }
    
    ///Setup postTimeLabel constraints
    UtilsUI.setupConstraints(with: postTimeLabel) {
      return [$0.top.constraint(equalTo: captionLabel.bottom,
                                constant: 12),
              $0.leading.constraint(equalTo: leading, constant: 12),
              $0.bottom.constraint(equalTo: bottom)]
    }
  }
  
  
}

//
//  CommentViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/23.
//

import UIKit
import Combine

class CommentViewModel {
  
  //MARK: - Properties
  fileprivate var _post: PostModel
  fileprivate var _comments = [CommentModel]()
  
  //MARK: - CombineProperties
  let newComment = PassthroughSubject<Void,Never>()
  var specificUser = PassthroughSubject<UserModel,Never>()
  
  //MARK: - Service
  fileprivate let apiClient: ServiceProviderType
  
  //MARK: - Lifecycles
  init(post: PostModel, apiClient: ServiceProviderType) {
    _post = post
    self.apiClient = apiClient
    fetchComments()
  }
}

//MARK: - CommentViewModelComputedPropery
extension CommentViewModel: CommentViewModelComputedPropery {
  
  var count: Int {
    return _comments.count
  }
  
  
  var post: PostModel {
    get {
      return _post
    }
    set {
      _post = newValue
    }
  }
  
  var comments: [CommentModel] {
    get {
      return _comments
    }
    set {
      _comments = newValue
    }
  }
  
}

//MARK: - CommentViewModelType
extension CommentViewModel: CommentViewModelType {
  
  func transform(input: Input) -> Output {
    let newComment = newCommentChains()
    
    let appear = appearChains(with: input)
    
    let reloadData = reloadDataChains(with: input)
    
    let cell = cellForItemChains(with: input)
    
    let didSelected = didSelectedChains(with: input)
    
    let specificUser = fetchedSepcifigUserInfoFromDidTapProfile()
    
    return Publishers
      .Merge6(appear.eraseToAnyPublisher(),
              reloadData.eraseToAnyPublisher(),
              cell.eraseToAnyPublisher(),
              newComment.eraseToAnyPublisher(),
              didSelected.eraseToAnyPublisher(),
              specificUser.eraseToAnyPublisher())
      .eraseToAnyPublisher()
  }
  
  func size(forWidth width: CGFloat, index: Int) -> CGSize  {
    let lb = UILabel()
    lb.numberOfLines = 0
    lb.text = comments[index].comment
    lb.lineBreakMode = .byWordWrapping
    lb.widthAnchor.constraint(equalToConstant: width).isActive = true
    return lb.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
  }
  
}

//MARK: - CommentViewModelInputCase
extension CommentViewModel: CommentViewModelInputCase {
  
  func newCommentChains() -> Output {
    return newComment
      .receive(on: RunLoop.main)
      .map{ _ -> State in return .updateUI }
      .eraseToAnyPublisher()
  }
  
  func appearChains(with input: Input) -> Output {
    return input
      .appear
      .receive(on: RunLoop.main)
      .map{ _ -> State in return .updateUI }
      .eraseToAnyPublisher()
    
  }
  
  func reloadDataChains(with input: Input) -> Output {
    return input
      .reloadData
      .receive(on: RunLoop.main)
      .map { _ -> State in
        return .updateUI
      }.eraseToAnyPublisher()
  }
  
  func cellForItemChains(with input: Input) -> Output {
    return input
      .cellForItem
      .receive(on: RunLoop.main)
      .map { [unowned self] info -> State in
        let attributedString = NSMutableAttributedString(string: "\(_comments[info.index].username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(
          NSAttributedString(string: _comments[info.index].comment,
                             attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        
        info.cell.commentLabel.attributedText = attributedString
        fetchUserImage(with: info.cell.profileImageView, index: info.index)
        return .none
      }.eraseToAnyPublisher()
  }
  
  func didSelectedChains(with input: Input) -> Output {
    return input
      .didSelected
      .receive(on: RunLoop.main)
      .map { [unowned self] cellInfo -> State in
        let uid = _comments[cellInfo.index].uid
        fetchUserInfo(with: uid)
        return .none
      }.eraseToAnyPublisher()
  }
  
  func fetchedSepcifigUserInfoFromDidTapProfile() -> Output {
    specificUser.map { specialUser -> State in
      return .showProfile(specialUser)
    }.eraseToAnyPublisher()
  }
  
  
}

//MARK: - CommentViewModelNetworkServiceType
extension CommentViewModel: CommentViewModelNetworkServiceType {
  
  func fetchUserInfo(with uid: String) {
    Task(priority: .high) {
      guard let userInfo = try await apiClient.userCase.fetchUserInfo(type: UserModel.self, withUid: uid) else {
        return
      }
      DispatchQueue.main.async {
        self.specificUser.send(userInfo)
      }
    }
  }
  
  func uploadComment(withInputModel input: UploadCommentInputModel) {
    do {
      try apiClient.commentCase.uploadComment(inputModel: input)
    }catch {
      guard let error = error as? CommentServiceError else { return }
      switch error {
      case .failedEncoding:
        print("DEBUG: \(CommentServiceError.failedEncoding.errorDescription)")
      case .failedDecoding:
        print("DEBGU: none")
      }
    }
  }
  
  func fetchComments() {
    guard let postId = post.postId else { return }
    apiClient.commentCase.fetchComment(postID: postId) { comments in
      self.comments = comments
      self.newComment.send()
    }
  }
  
  func fetchUserImage(with imageView: UIImageView, index: Int) {
    Task(priority: .medium) {
      do {
        let image = try await fetchProfileFromImageService(index: index)
        DispatchQueue.main.async {
          imageView.image = image
        }
      }catch {
        fetchImageErrorHandling(error: error)
      }
    }
  }
  
  func fetchProfileFromImageService(index: Int) async throws -> UIImage {
    return try await apiClient.imageCase.fetchUserProfile(userProfile: _comments[index].profileImageUrl)
  }
  
  func fetchImageErrorHandling(error: Error) {
    switch error {
    case FetchUserError.invalidUserProfileImage:
      print("DEBUG: Failure invalid user profile image instance")
      break
    default:
      print("DEBUG: Failure occured unexpected error: \(error.localizedDescription)")
    }
    
  }
  
}
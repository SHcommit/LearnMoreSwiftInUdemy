//
//  PostViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit
import Firebase
import Combine

class FeedViewModel {
    //MARK: - Properties
    private var postModel: PostModel
    private var postImage: UIImage?
    private var userProfile: UIImage?
    var likeChanged = PassthroughSubject<Void,Never>()
    
    //MARK: - LifeCycles
    init(post: PostModel) {
        self.postModel = post
    }
}

//MARK: - FeedCellViewModelComputedProperty
extension FeedViewModel: FeedCellViewModelComputedProperty {
    
    var userUID: String {
        get {
            return postModel.ownerUid
        }
    }
     
    var post: PostModel {
        get {
            return postModel
        }
        set {
            self.postModel = newValue
        }
    }
    
    var image: UIImage? {
        get {
            guard let postImage = postImage else {
                return nil
            }
            return postImage
        }
    }
    
    var postedUserProfile: UIImage? {
        get {
            guard let profile = userProfile else {
                print("DEBUG: postVM's userProfile can't bind.")
                return nil
            }
            return profile
        }
    }
    
    var caption: String {
        get {
            return post.caption
        }
    }
    
    var username: String {
        get {
            return post.ownerUsername
        }
    }
    
    var postTime: Timestamp {
        get {
            return post.timestamp
        }
    }
    
    var ownerImageUrl: String {
        get {
            return post.ownerImageUrl
        }
    }
    
    var likes: Int {
        get {
            return post.likes
        }
    }
    
    var postLikes: String {
        get {
            return likes < 2 ? "\(likes) like" : "\(likes) likes"
        }
    }
    
    var didLike: Bool {
        get {
            guard let didLike = post.didLike else { return false }
            return didLike
        }
        set {
            postModel.didLike = newValue
        }
    }

    func setupLike(button: UIButton) {
        if !didLike {
            button.setImage(.imageLiteral(name: "like_selected"), for: .normal)
            button.tintColor = .red
            post.likes += 1
        }else {
            button.setImage(.imageLiteral(name: "like_unselected"), for: .normal)
            button.tintColor = .black
            post.likes -= 1
        }
    }
}

//MARK: - FeedCellViewModelAPIs
extension FeedViewModel: FeedCellViewModelAPIs {
    
    func fetchPostImage() async {
        do {
            let image = try await UserProfileImageService.fetchUserProfile(userProfile: post.imageUrl)
            DispatchQueue.main.async {
                self.postImage = image
            }
        } catch {
            print("DEBUG: Unexccept Error occured: \(error.localizedDescription)")
        }
    }
    
    func fetchUserProfile() async {
        do {
            guard let image = try? await UserProfileImageService.fetchUserProfile(userProfile: post.ownerImageUrl) else { throw FetchUserError.invalidUserProfileImage }
            DispatchQueue.main.async {
                self.userProfile = image
            }
        } catch FetchUserError.invalidUserProfileImage {
            print("DEBUG: Failure fetch owner profile image in PostViewModel")
        } catch {
            print("DEBUG: Unexccept Error occured: \(error.localizedDescription)")
        }
    }
}

//MARK: - FeedCellViewModelType
extension FeedViewModel: FeedCellViewModelType {
    func transform(input: FeedCellViewModelInput) -> FeedCellViewModelOutput {
        let didTapUserProfile = didTapUserProfileChains(with: input)
        let didTapComment = didTapCommentChains(with: input)
        let didTapLike = didTapLikeChains(with: input)
        let likeSubscription = likeSubscriptionChains()
        return Publishers
            .Merge4(didTapLike,didTapComment,likeSubscription,didTapUserProfile)
            .eraseToAnyPublisher()
    }
}

//MARK: - FeedCellViewModelSubscriptionChains
extension FeedViewModel: FeedCellViewModelSubscriptionChains {
    
    func didTapUserProfileChains(with input: FeedCellViewModelInput) -> FeedCellViewModelOutput {
        input.didTapProfile
            .map{ uid -> FeedCellState in
                return .fetchUserInfo(uid)
            }.eraseToAnyPublisher()
    }
    
    func didTapCommentChains(with input: FeedCellViewModelInput) -> FeedCellViewModelOutput {
        input.didTapComment
            .map { navigationController -> FeedCellState in
                return .present(navigationController)
            }.eraseToAnyPublisher()

    }
    
    func didTapLikeChains(with input: FeedCellViewModelInput) -> FeedCellViewModelOutput {
        input.didTapLike
            .subscribe(on: RunLoop.main)
            .map{ [unowned self] likeButton -> FeedCellState in
                guard let didLike = post.didLike else { return .none}
                Task(priority: .high) {
                    if !didLike {
                        await PostService.likePost(post: post)
                        NotificationService.uploadNotification(to: UploadNotificationModel(uid: post.ownerUid,
                                                                                           profileImageUrl: post.ownerImageUrl,
                                                                                           username: post.ownerUsername),
                                                               type: .like, post: post)
                    }else {
                        await PostService.unlikePost(post: post)
                    }
                    DispatchQueue.main.async { [self] in
                        setupLike(button: likeButton)
                        post.didLike?.toggle()
                        likeChanged.send()
                    }
                }
                return .none
            }.eraseToAnyPublisher()

    }
    
    func likeSubscriptionChains() -> FeedCellViewModelOutput {
        likeChanged.map { _ -> FeedCellState in
            return .updateLikeLabel
        }.eraseToAnyPublisher()

    }
    
}

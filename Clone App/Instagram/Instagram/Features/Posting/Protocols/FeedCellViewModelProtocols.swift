//
//  FeedCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/03.
//

import UIKit
import Firebase
import Combine

protocol FeedCellViewModelConvenience {
    typealias Input = FeedCellViewModelInput
    typealias Output = FeedCellViewModelOutput
    typealias State = FeedCellState
}

protocol FeedCellViewModelComputedProperty {
    var image: UIImage? { get }
    var postedUserProfile: UIImage? { get }
    var caption: String { get }
    var username: String { get }
    var postTime: Timestamp { get }
    var ownerImageUrl: String { get }
    var likes: Int { get }
    var postLikes: String { get }
    var didLike: Bool { get set }
    var post: PostModel { get set }
    var userUID: String { get }
}

protocol FeedCellViewModelAPIs {
    func fetchPostImage() async
    func fetchUserProfile() async
}

struct FeedCellViewModelInput {
    var didTapProfile: AnyPublisher<String,Never>
    var didTapComment: AnyPublisher<Void,Never>
    var didTapLike: AnyPublisher<(UIButton, FeedCellDelegate?),Never>
}

typealias FeedCellViewModelOutput = AnyPublisher<FeedCellState,Never>
enum FeedCellState {
    case none
    case showComment
    case showProfile(UserModel)
    case updateLikeLabel
    case deleteIndicator
    case fail(String)
}

protocol FeedCellViewModelType: FeedCellViewModelComputedProperty, FeedCellViewModelAPIs, FeedCellViewModelConvenience {
    func transform(input: Input) -> Output
    
    /// Api
    
}

protocol FeedCellViewModelSubscriptionChains: FeedCellViewModelConvenience {
    func didTapCommentChains(with input: Input) -> Output
    func didTapLikeChains(with input: Input) -> Output
    func likeSubscriptionChains() -> Output
    func didTapUserProfileChains(with input: Input) -> Output
}

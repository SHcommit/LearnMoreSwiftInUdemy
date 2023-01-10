//
//  FeedCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/03.
//

import UIKit
import Firebase
import Combine

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
}

protocol FeedCellViewModelAPIs {
    func fetchPostImage() async
    func fetchUserProfile() async
}

struct FeedCellViewModelInput {
    var didTapComment: AnyPublisher<UINavigationController?,Never>
    var didTapLike: AnyPublisher<UIButton,Never>
}

typealias FeedCellViewModelOutput = AnyPublisher<FeedCellState,Never>
enum FeedCellState {
    case none
    case present(UINavigationController?)
    case updateLikeLabel
}

protocol FeedCellViewModelType: FeedCellViewModelComputedProperty, FeedCellViewModelAPIs {
    func transform(input: FeedCellViewModelInput) -> FeedCellViewModelOutput
}

protocol FeedCellViewModelSubscriptionChains {
    func didTapCommentChains(with input: FeedCellViewModelInput) -> FeedCellViewModelOutput
    func didTapLikeChains(with input: FeedCellViewModelInput) -> FeedCellViewModelOutput
    func likeSubscriptionChains() -> FeedCellViewModelOutput
}

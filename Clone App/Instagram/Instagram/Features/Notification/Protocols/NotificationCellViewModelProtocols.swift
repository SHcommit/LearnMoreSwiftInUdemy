//
//  NotificationCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

//MARK: - NotificationCell delegate

enum NotificationCellDelegateType {
    case wantsToViewPost
    case wantsToUnfollow
    case wantsToFollow
}

struct NotificationCellDelegate {
    typealias Element = (cell: NotificationCell, uid: String, type: NotificationCellDelegateType)
    
    private var pub = PassthroughSubject<Element,Never>()
    
    func completion() {
        pub.send(completion: .finished)
    }
    
    func send(with element: Element) {
        pub.send(element)
    }
    func receive() -> AnyPublisher<Element,Never> {
        return pub
            .eraseToAnyPublisher()
    }
}


//MARK: - NotificationCellViewModel Combine types
struct NotificationCellViewModelInput {
    var initialization: AnyPublisher<(profile: UIImageView, post: UIImageView),Never>
}

typealias NotificationCellViewModelOutput = AnyPublisher<NotificationCellState,Never>

enum NotificationCellState {
    case none
    case configure(NSAttributedString)
    case updatedFollow
}

protocol NotificationCellVMComputedProperties {
    
    var postImageUrl: URL? { get }
    
    var profileImageUrl: URL? { get }
    
    var specificUsernameToNotify: String { get }
    
    var notificationMessage: NSAttributedString { get }
    
    var shouldHidePostImage: Bool { get }
    
    var notification: NotificationModel { get set }
    
    var followButtonText: String { get }
    
    var followButtonBackgroundColor: UIColor { get }
    
    var followButtonTextColor: UIColor { get }
    
    var userIsFollowed: Bool { get set }
}

protocol NotificationCellViewModelType: NotificationCellVMComputedProperties {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput
}

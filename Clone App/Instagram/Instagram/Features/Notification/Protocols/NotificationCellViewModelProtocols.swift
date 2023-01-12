//
//  NotificationCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

//MARK: - NotificationCell delegate
struct NotificationCellDelegate {
    typealias Element = (cell: NotificationCell, uid: String, type: NotificationType)
    
    private var pub = PassthroughSubject<Element,Never>()
    
    func send(with element: Element) {
        pub.send(element)
    }
    func receive() -> AnyPublisher<Element,Never> {
        return pub
            .receive(on: DispatchQueue.main)
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
}

protocol NotificationCellVMComputedProperties {
    
    var postImageUrl: URL? { get }
    
    var profileImageUrl: URL? { get }
    
    var specificUsernameToNotify: String { get }
    
    var notificationMessage: NSAttributedString { get }
    
    var shouldHidePostImage: Bool { get }
    
    var notification: NotificationModel { get }
    
    var followButtonText: String { get }
    
    var followButtonBackgroundColor: UIColor { get }
    
    var followButtonTextColor: UIColor { get }
}

protocol NotificationCellViewModelType: NotificationCellVMComputedProperties {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput
}

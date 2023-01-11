//
//  NotificationCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationCellViewModelInput {
    var initialization: AnyPublisher<UIImageView,Never>
}

typealias NotificationCellViewModelOutput = AnyPublisher<NotificationCellState,Never>

enum NotificationCellState {
    case none
    case updateImage(UIImage)
    case configure
}

protocol NotificationCellVMComputedProperties {
    
    var postImageUrl: URL? { get }
    
    var profileImageUrl: URL? { get }
}

protocol NotificationCellViewModelType: NotificationCellVMComputedProperties {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput
}

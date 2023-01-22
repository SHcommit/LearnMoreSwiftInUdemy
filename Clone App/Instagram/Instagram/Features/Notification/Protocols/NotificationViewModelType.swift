//
//  NotificationsViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

protocol NotificationViewModelConvenience {
    typealias Input = NotificationViewModelInput
    typealias Output = NotificationViewModelOutput
    typealias State = NotificationControllerState
}

struct NotificationViewModelInput {
    var appear: AnyPublisher<Void,Never>
    var specificCellInit: AnyPublisher<(cell: NotificationCell, index: Int),Never>
    var refresh: AnyPublisher<Void,Never>
    var didSelectCell: AnyPublisher<String,Never>
    var didSelectedPost: AnyPublisher<String,Never>
}

typealias NotificationViewModelOutput = AnyPublisher<NotificationControllerState,Never>

enum NotificationControllerState {
    case none
    case appear
    case updateTableView
    case refresh
    case endIndicator
    case showProfile(UserModel)
    case showPost(PostModel)
}

protocol NotificationVMComputedProperties {
    var count: Int { get }
    
    var notifications: [NotificationModel] { get set }
}

protocol NotificationViewModelType: NotificationVMComputedProperties, NotificationViewModelConvenience {
    func transform(with input: Input) -> Output
}


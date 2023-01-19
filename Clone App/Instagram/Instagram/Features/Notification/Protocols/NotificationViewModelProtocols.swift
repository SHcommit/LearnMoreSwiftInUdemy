//
//  NotificationsViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationViewModelInput {
    var appear: AnyPublisher<Void,Never>
    var specificCellInit: AnyPublisher<(cell: NotificationCell, index: Int),Never>
    var refresh: AnyPublisher<Void,Never>
}

typealias NotificationViewModelOutput = AnyPublisher<NotificationControllerState,Never>

enum NotificationControllerState {
    case none
    case appear
    case updateTableView
    case refresh
}

protocol NotificationVMComputedProperties {
    var count: Int { get }
    
    var notifications: [NotificationModel] { get set }
}

protocol NotificationViewModelType: NotificationVMComputedProperties {
    func transform(with input: NotificationViewModelInput) -> NotificationViewModelOutput
}


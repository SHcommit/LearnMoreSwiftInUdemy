//
//  NotificationsViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationsViewModelInput {
    var viewWillAppear: AnyPublisher<Void,Never>
    var specificCellInit: AnyPublisher<(cell: NotificationCell, index: Int),Never>
}

typealias NotificationViewModelOutput = AnyPublisher<NotificationsControllerState,Never>

enum NotificationsControllerState {
    case none
    case updateTableView
}

protocol NotificationsVMComputedProperties {
    var count: Int { get }
}

protocol NotificationsViewModelType: NotificationsVMComputedProperties {
    func transform(with input: NotificationsViewModelInput) -> NotificationViewModelOutput
}

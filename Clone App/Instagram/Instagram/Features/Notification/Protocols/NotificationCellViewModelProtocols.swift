//
//  NotificationCellViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationCellViewModelInput {
    var viewWillAppear: AnyPublisher<Void,Never>
}

typealias NotificationCellViewModelOutput = AnyPublisher<NotificationsCellState,Never>

enum NotificationsCellState {
    case none
    case updateTableView
}

protocol NotificationCellVMComputedProperties {
    var count: Int { get }
    
    var postImageUrl: URL? { get }
    
    var profileImageUrl: URL? { get }
}

protocol NotificationCellViewModelType: NotificationCellVMComputedProperties {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput
}

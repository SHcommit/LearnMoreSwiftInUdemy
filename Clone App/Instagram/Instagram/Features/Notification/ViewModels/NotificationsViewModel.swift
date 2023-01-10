//
//  NotificationsViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationsViewModel {
    //MARK: - Properties
    private var notifications = CurrentValueSubject<[NotificationModel],Never>([NotificationModel]())
    
    //MARK: - Lifecycels
    init() {
        configure()
    }
}

//MARK: - Helpers
extension  NotificationsViewModel {
    func configure() {
        fetchNotifications()
    }
}

//MARK: - NotificationViewModelType
extension NotificationsViewModel: NotificationsViewModelType {
    func transform(with input: NotificationsViewModelInput) -> NotificationViewModelOutput {
        let updateTableView = input
            .viewWillAppear
            .map{ _ -> NotificationsControllerState in
            return .updateTableView
            }.eraseToAnyPublisher()
        
        let noti = notifications.map { _ -> NotificationsControllerState in
            return .updateTableView
        }.eraseToAnyPublisher()
        
        return Publishers.Merge(updateTableView, noti).eraseToAnyPublisher()
        
    }
}

extension NotificationsViewModel: NotificationsVMComputedProperties {
    
    var count: Int {
        notifications.value.count
    }
    
    
}

//MARK: - APIs
extension NotificationsViewModel {
    func fetchNotifications() {
        Task(priority: .high) {
            do {
                let list = try await NotificationService.fetchNotifications()
                self.notifications.value = list
            }catch {
                fetchNotificationsErrorHandling(with: error)
            }
        }
    }
    func fetchNotificationsErrorHandling(with error: Swift.Error) {
        guard let error = error as? NotificationServiceError else { return }
        switch error {
        case .invalidNotificationList:
            print("DEBUG: \(error)")
        case .invalidCurrentUser:
            print("DEBUG: \(error)")
        case .invalidDocuments:
            print("DEBUG: \(error)")
        }
        
    }
}




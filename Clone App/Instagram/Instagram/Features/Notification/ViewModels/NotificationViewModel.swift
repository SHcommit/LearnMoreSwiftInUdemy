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
    private var _notifications = CurrentValueSubject<[NotificationModel],Never>([NotificationModel]())
    
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
    
    func transform(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        let appear = appearChains(with: input)
        let noti = notificationsChains(with: input)
        let specificCellInit = specificCellInit(with: input)
        return Publishers
            .Merge3(appear, noti, specificCellInit)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - NotificationsVMComputedProperties
extension NotificationsViewModel: NotificationsVMComputedProperties {
    
    var count: Int {
        get {
            _notifications.value.count
        }
    }
    
    var notifications: [NotificationModel] {
        return _notifications.value
    }
    
}

//MARK: - NotificationViewModelType subscription chains
extension NotificationsViewModel {
    
    func appearChains(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        return input
            .appear
            .subscribe(on: DispatchQueue.main)
            .map{ _ -> NotificationsControllerState in
            return .none
            }.eraseToAnyPublisher()
    }
    
    func notificationsChains(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        return _notifications
            .subscribe(on: DispatchQueue.main)
            .map { _ -> NotificationsControllerState in
            return .updateTableView
        }.eraseToAnyPublisher()
    }
    
    func specificCellInit(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        return input
            .specificCellInit
            .subscribe(on: DispatchQueue.main)
            .map { (cell, index) -> NotificationsControllerState in
                cell.vm = NotificationCellViewModel(notification: _notifications.value[index])
                cell.setupBindings()
                cell.didTapFollowButton()
                return .none
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - APIs
extension NotificationsViewModel {
    
    func fetchNotifications() {
        Task(priority: .high) {
            do {
                let list = try await NotificationService.fetchNotifications()
                self._notifications.value = list
                try self.checkIfUserIsFollowed()
            } catch {
                switch error {
                case is NotificationServiceError:
                    fetchNotificationsErrorHandling(with: error)
                case is CheckUserFollowedError:
                    fetchNotificationsFollowErrorHandling(with: error)
                default:
                    print("DEBUG: Unknown error occured: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func checkIfUserIsFollowed() throws {
        _notifications.value.forEach{ notification in
            Task(priority: .high) {
                guard notification.type == .follow else { return }
                let isFollowed = try await UserService.checkIfUserIsFollowd(uid: notification.specificUserInfo.uid)
                guard let idx = _notifications.value.firstIndex(where: {$0.id == notification.id}) else {
                    return
                }
                self._notifications.value[idx].specificUserInfo.userIsFollowed = isFollowed
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
    
    func fetchNotificationsFollowErrorHandling(with error: Error) {
        guard let error = error as? CheckUserFollowedError else {
            return
        }
        switch error {
        case .invalidSpecificUserInfo: return print("DEBUG: \(error.errorDescription)")
        case .invalidCurrentUserUIDInUserDefaultsStandard: return print("DEBUG: \(error.errorDescription)")
        }
    }
    
}

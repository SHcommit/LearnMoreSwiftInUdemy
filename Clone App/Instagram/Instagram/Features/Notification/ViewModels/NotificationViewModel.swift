//
//  NotificationsViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

class NotificationsViewModel {
    
    //MARK: - Properties
    fileprivate var _notifications = CurrentValueSubject<[NotificationModel],Never>([NotificationModel]())
    
    //MARK: - Lifecycels
    init() {
        configure()
    }
    
}

//MARK: - Helpers
extension  NotificationsViewModel {
    
    fileprivate func configure() {
        fetchNotifications()
    }
    
}

//MARK: - NotificationViewModelType
extension NotificationsViewModel: NotificationsViewModelType {
    
    func transform(with input: NotificationViewModelInput) -> NotificationViewModelOutput {
        let appear = appearChains(with: input)
        let noti = notificationsChains(with: input)
        let specificCellInit = specificCellInit(with: input)
        let refresh = refreshChains(with: input)
        return Publishers
            .Merge4(appear, noti, specificCellInit,refresh)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - NotificationsVMComputedProperties
extension NotificationsViewModel: NotificationsVMComputedProperties {
    
    var count: Int {
        _notifications.value.count
    }
    
    var notifications: [NotificationModel] {
        get {
            return _notifications.value
        }
        set {
            _notifications.value = newValue
        }
    }
    
}

//MARK: - NotificationViewModelType subscription chains
extension NotificationsViewModel {
    
    private func appearChains(with input: NotificationViewModelInput) -> NotificationViewModelOutput {
        return input
            .appear
            .subscribe(on: DispatchQueue.main)
            .map{ _ -> NotificationControllerState in
            return .appear
            }.eraseToAnyPublisher()
    }
    
    private func notificationsChains(with input: NotificationViewModelInput) -> NotificationViewModelOutput {
        return _notifications
            .subscribe(on: DispatchQueue.main)
            .map { _ -> NotificationControllerState in
            return .updateTableView
        }.eraseToAnyPublisher()
    }
    
    private func specificCellInit(with input: NotificationViewModelInput) -> NotificationViewModelOutput {
        return input
            .specificCellInit
            .subscribe(on: DispatchQueue.main)
            .map { [unowned self] (cell, index) -> NotificationControllerState in
                cell.vm = NotificationCellViewModel(notification: _notifications.value[index])
                cell.setupBindings()
                cell.didTapFollowButton()
                return .none
            }.eraseToAnyPublisher()
    }
    
    private func refreshChains(with input: NotificationViewModelInput) -> NotificationViewModelOutput {
        return input
            .refresh
            .subscribe(on: DispatchQueue.main)
            .map { [unowned self] _ -> NotificationControllerState in
                notifications.removeAll()
                configure()
                return .refresh
            }.eraseToAnyPublisher()
    }
}

//MARK: - APIs
extension NotificationsViewModel {
    
    private func fetchNotifications() {
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
    
    private func checkIfUserIsFollowed() throws {
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
    
    private func fetchNotificationsErrorHandling(with error: Swift.Error) {
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
    
    private func fetchNotificationsFollowErrorHandling(with error: Error) {
        guard let error = error as? CheckUserFollowedError else {
            return
        }
        switch error {
        case .invalidSpecificUserInfo: return print("DEBUG: \(error.errorDescription)")
        case .invalidCurrentUserUIDInUserDefaultsStandard: return print("DEBUG: \(error.errorDescription)")
        }
    }
    
}

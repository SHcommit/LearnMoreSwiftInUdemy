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
    
    func transform(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        let viewWillAppear = viewWillAppearChains(with: input)
        let noti = notificationsChains(with: input)
        let specificCellInit = specificCellInit(with: input)
        return Publishers.Merge3(viewWillAppear, noti, specificCellInit).eraseToAnyPublisher()
    }
    
}

//MARK: - NotificationsVMComputedProperties
extension NotificationsViewModel: NotificationsVMComputedProperties {
    
    var count: Int {
        get {
            notifications.value.count
        }
    }
    
}

//MARK: - NotificationViewModelType subscription chains
extension NotificationsViewModel {
    
    func viewWillAppearChains(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        return input
            .viewWillAppear
            .subscribe(on: DispatchQueue.main)
            .map{ _ -> NotificationsControllerState in
            return .none
            }.eraseToAnyPublisher()
    }
    
    func notificationsChains(with input: NotificationsViewModelInput) -> NotificationsViewModelOutput {
        return notifications
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
                cell.vm = NotificationCellViewModel(notification: notifications.value[index])
                cell.setupBindings()
                cell.didTapFollowButton()
                return .none
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

//MARK: - APIs
extension NotificationsViewModel {
    
    func fetchNotifications() {
        Task(priority: .high) {
            do {
                let list = try await NotificationService.fetchNotifications()
                self.notifications.value = list
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
        notifications.value.forEach{ notification in
            Task(priority: .high) {
                guard notification.type == .follow else { return }
                let isFollowed = try await UserService.checkIfUserIsFollowd(uid: notification.specificUserInfo.uid)
                guard let idx = notifications.value.firstIndex(where: {$0.id == notification.id}) else {
                    return
                }
                self.notifications.value[idx].specificUserInfo.userIsFollowed = isFollowed
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

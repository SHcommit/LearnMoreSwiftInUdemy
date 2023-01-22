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
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    fileprivate let fetchedNotifiedUserInfo = PassthroughSubject<UserModel,Never>()
    fileprivate let failedFetchedNotifiedUserInfo = PassthroughSubject<Void,Never>()
    fileprivate let fetchNotifiedPostInfo = PassthroughSubject<PostModel,Never>()
    
    //MARK: - Lifecycels
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
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
extension NotificationsViewModel: NotificationViewModelType {
    
    func transform(with input: Input) -> Output {
        
        let appear = appearChains(with: input)
        let noti = notificationsChains(with: input)
        let specificCellInit = specificCellInit(with: input)
        let refresh = refreshChains(with: input)
        let didSelectedCell = didSelectCellChains(with: input)
        let didSelectedPost = didSelectPostChains(with: input)
        let fetchedNotifiedUserUpstream = fetchNotifiedUserUpstreamChains()
        let failedNotifiedUpstream = failNotifiedUpstreamChains()
        let fetchedNotifiedPostUpstream = fetchNotifiedPostUpstreamChains()
        let didSelectedSubscription = didSelectedCell.merge(with: didSelectedPost).eraseToAnyPublisher()
        
        return Publishers
            .Merge8(appear, noti, specificCellInit, refresh,
                    didSelectedSubscription , fetchedNotifiedUserUpstream,
                    fetchedNotifiedPostUpstream, failedNotifiedUpstream)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - NotificationsVMComputedProperties
extension NotificationsViewModel: NotificationVMComputedProperties {
    
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
extension NotificationsViewModel: NotificationViewModelConvenience {
    
    private func appearChains(with input: Input) -> Output {
        return input
            .appear
            .subscribe(on: DispatchQueue.main)
            .map{ _ -> State in
            return .appear
            }.eraseToAnyPublisher()
    }
    
    private func notificationsChains(with input: Input) -> Output {
        return _notifications
            .subscribe(on: DispatchQueue.main)
            .map { _ -> State in
            return .updateTableView
        }.eraseToAnyPublisher()
    }
    
    private func specificCellInit(with input: Input) -> Output {
        return input
            .specificCellInit
            .subscribe(on: DispatchQueue.main)
            .map { [unowned self] (cell, index) -> State in
                cell.vm = NotificationCellViewModel(notification: _notifications.value[index], apiClient: apiClient)
                cell.setupBindings()
                cell.didTapFollowButton()
                return .none
            }.eraseToAnyPublisher()
    }
    
    private func refreshChains(with input: Input) -> Output {
        return input
            .refresh
            .subscribe(on: DispatchQueue.main)
            .map { [unowned self] _ -> State in
                notifications.removeAll()
                configure()
                return .refresh
            }.eraseToAnyPublisher()
    }
    
    private func didSelectCellChains(with input: Input) -> Output {
        return input
            .didSelectCell
            .map{ [unowned self] uid -> State in
                self.fetchNotifiedUserInfo(with: uid)
                return .none
            }.eraseToAnyPublisher()
    }
    
    private func fetchNotifiedUserUpstreamChains() -> Output {
        return fetchedNotifiedUserInfo
            .map{ notifiedSender -> State in
            return .showProfile(notifiedSender)
        }.eraseToAnyPublisher()
    }
    
    private func failNotifiedUpstreamChains() -> Output {
        return failedFetchedNotifiedUserInfo
            .map{ _ -> State in
            return .endIndicator
        }.eraseToAnyPublisher()
    }
    
    private func fetchNotifiedPostUpstreamChains() -> Output {
        return fetchNotifiedPostInfo
            .map{ post -> State in
                return .showPost(post)
            }.eraseToAnyPublisher()
    }
    
    private func didSelectPostChains(with input: Input) -> Output {
        return input.didSelectedPost
            .subscribe(on: DispatchQueue.main)
            .map { uid -> State in
            self.fetchNotifiedPost(uid)
            return .none
        }.eraseToAnyPublisher()
    }
}

//MARK: - APIs
extension NotificationsViewModel {
    
    private func fetchNotifiedPost(_ uid: String) {
        Task(priority: .high) {
            do {
                var fetchedPost = try await apiClient.postCase.fetchPost(withPostId: uid)
                //애매한데.. 단일 포스트 fetch할 때 안 받아지는 건지 다시 한번 살펴봐야겠음.
                fetchedPost.postId = uid
                let updatedPost = fetchedPost
                DispatchQueue.main.async {
                    self.fetchNotifiedPostInfo.send(updatedPost)
                }
            }catch {
                DispatchQueue.main.async {
                    self.failedFetchedNotifiedUserInfo.send()
                }
            }
        }
    }
    
    private func fetchNotifiedUserInfo(with uid: String) {
        Task(priority: .high) {
            guard let user = try? await apiClient
                .userCase
                .fetchUserInfo(type: UserModel.self, withUid: uid) else {
                DispatchQueue.main.async {
                    self.failedFetchedNotifiedUserInfo.send()
                }
                return
            }
            DispatchQueue.main.async {
                self.fetchedNotifiedUserInfo.send(user)
            }
        }
    }
    
    private func fetchNotifications() {
        Task(priority: .high) {
            do {
                let list = try await apiClient.notificationCase.fetchNotifications()
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
                let isFollowed = try await apiClient.userCase.checkIfUserIsFollowd(uid: notification.specificUserInfo.uid)
                guard let idx = _notifications.value.firstIndex(where: {$0.id == notification.id}) else {
                    return
                }
                self._notifications.value[idx].specificUserInfo.userIsFollowed = isFollowed
            }
        }
    }
    
}

//MARK: - APIs Error Handling
extension NotificationsViewModel {
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

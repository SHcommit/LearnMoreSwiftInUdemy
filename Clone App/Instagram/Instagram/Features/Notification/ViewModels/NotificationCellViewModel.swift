//
//  NotificationCellViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

class NotificationCellViewModel {
    
    //MARK: - Properties
    private var _notification: NotificationModel
    var subscriptions = Set<AnyCancellable>()
    private var isUpdatedFollow = PassthroughSubject<Void,Never>()
    
    //MARK: - Usecase
    fileprivate let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(notification: NotificationModel, apiClient: ServiceProviderType) {
        self._notification = notification
        self.apiClient = apiClient
    }
    
}

//MARK: - NotificationCellVMComputedProperties
extension NotificationCellViewModel: NotificationCellVMComputedProperties {
    
    var userIsFollowed: Bool {
        get {
            _notification.specificUserInfo.userIsFollowed
        }
        set {
            _notification.specificUserInfo.userIsFollowed = newValue
        }
    }
    
    var postImageUrl: URL? {
        return URL(string: _notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: _notification.specificUserInfo.profileImageUrl)
    }
    
    var specificUsernameToNotify: String {
        return _notification.specificUserInfo.username
    }
    
    var notificationMessage: NSAttributedString {
        let username = specificUsernameToNotify
        let message = _notification.type.description
        let attrText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: " 1min",
                                           attributes: [.font:UIFont.boldSystemFont(ofSize: 12),
                                                        .foregroundColor: UIColor.lightGray]))
        return attrText
    }
    
    var shouldHidePostImage: Bool {
        return self._notification.type == .follow
    }
    
    var notification: NotificationModel {
        get {
            return _notification
        }
        set {
            _notification = newValue
        }
    }
    
    var followButtonText: String {
        notification.specificUserInfo.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.specificUserInfo.userIsFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.specificUserInfo.userIsFollowed ? .black : .white
    }
       
}

//MARK: - NotificationCellViewModelType
extension NotificationCellViewModel: NotificationCellViewModelType {
    
    func transform(with input: Input) -> Output {
        let initializaiton = initializationChains(with: input)
        
        let updatedFollow = isUpdatedFollowChains()
        
        return initializaiton
            .merge(with: updatedFollow)
            .eraseToAnyPublisher()
    }
    
}

//MARK: NotificationCellViewModelType subscription chains
extension NotificationCellViewModel: NotificationCellViewModelConvenience {
    
    fileprivate func initializationChains(with input: Input) -> Output {
        return input.initialization
            .first()
            .map {[unowned self] ivs -> State in
                _=[(ivs.profile, profileImageUrl!),
                   (ivs.post, postImageUrl)]
                    .map{ updateImageView($0.0, withUrl: $0.1)}
                ///Notification내부에서 팔로우하거나 끊기는 가능한데 유저 노티피 탭 한 이후 서치에서 특정 상대 검색후 팔로우하고 다시 노티피케이션으로 오면 prepare만 동작한다. 이땐 서버에서 내가 사용자 팔로우했는지 갱신 여부 안받아오기 때문에 아래 함수로 받아오게 했다.
                checkIfUserIsFollowed()
                return .configure(self.notificationMessage)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    fileprivate func isUpdatedFollowChains() -> Output {
        return isUpdatedFollow
            .map{ _ -> State in
                return .updatedFollow
            }.eraseToAnyPublisher()
    }
    
}

//MARK: - APIs
extension NotificationCellViewModel {
    
    private enum NotificationCellFetchImageError: Error, CustomStringConvertible{
        
        case network(URLError)
        case invalidData
        case unknown
        
        var description: String {
            switch self {
            case .network(let error): return "Network error occured: \(error.localizedDescription)"
            case .invalidData: return "Invalid data"
            case .unknown: return "Unknown error occured"
            }
        }
    }
    
    private func fetchImage(with url: URL) -> AnyPublisher<UIImage,NotificationCellFetchImageError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap{ data,_ -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NotificationCellFetchImageError.invalidData
                }
                return image
            }.mapError{
                switch $0 {
                case is URLError:
                    return NotificationCellFetchImageError.network($0 as! URLError)
                default:
                    return $0 as! NotificationCellFetchImageError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func checkIfUserIsFollowed() {
        Task(priority: .high) {
            do {
                let isFollowed = try await apiClient.userCase.checkIfUserIsFollowd(uid: _notification.specificUserInfo.uid)
                DispatchQueue.main.async {
                    self._notification
                        .specificUserInfo
                        .userIsFollowed = isFollowed
                    self.isUpdatedFollow.send()
                }
            } catch {
                print("DEBUG: \(error)")
            }
        }
    }
    
}

//MARK: - Helpers
extension NotificationCellViewModel {
    
    private func updateImageView(_ imageView: UIImageView, withUrl url: URL?) {
        guard let url = url else { return }
        self.fetchImage(with: url)
            .sink {
                switch $0 {
                case .finished: break
                case .failure(let error):  print("DEBUG:\(error)")
                }
            } receiveValue: { image in
                imageView.image = image
            }.store(in: &self.subscriptions)
    }
    
}

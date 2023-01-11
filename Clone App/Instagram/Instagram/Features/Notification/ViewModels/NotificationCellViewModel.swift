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
    private let notification: NotificationModel
    var subscriptions = Set<AnyCancellable>()
    //MARK: - Lifecycles
    init(notification: NotificationModel) {
        self.notification = notification
    }
    
}

//MARK: - NotificationCellVMComputedProperties
extension NotificationCellViewModel: NotificationCellVMComputedProperties {
    
    var postImageUrl: URL? {
        get {
            return URL(string: notification.postImageUrl ?? "")
        }
    }
    
    var profileImageUrl: URL? {
        get {
            URL(string: notification.specificUserInfo.profileImageUrl)
        }
    }
    
    var specificUsernameToNotify: String {
        get {
            notification.specificUserInfo.username
        }
    }
    
    var notificationMessage: NSAttributedString {
        get {
            let username = specificUsernameToNotify
            let message = notification.type.description
            let attrText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            attrText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            attrText.append(NSAttributedString(string: " 1min",
                                               attributes: [.font:UIFont.boldSystemFont(ofSize: 12),
                                                            .foregroundColor: UIColor.lightGray]))
            return attrText
        }
    }
       
}

//MARK: - NotificationCellViewModelType
extension NotificationCellViewModel: NotificationCellViewModelType {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput {
        let initializaiton = initializationChains(with: input)
        return initializaiton
    }
}

//MARK: NotificationCellViewModelType subscription chains
extension NotificationCellViewModel {
    
    func initializationChains(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput {
        return input.initialization
            .first()
            .map {[unowned self] ivs -> NotificationCellState in
                _=[(ivs.profile, profileImageUrl!),
                   (ivs.post, postImageUrl!)]
                    .map{ updateImageView($0.0, withUrl: $0.1)}
                
                return .configure(self.notificationMessage)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
}

//MARK: - Helpers
extension NotificationCellViewModel {
    private func updateImageView(_ imageView: UIImageView, withUrl url: URL) {
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

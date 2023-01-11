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
            .map { ivs -> NotificationCellState in
                self.fetchImage(with: self.profileImageUrl!)
                    .sink {
                        print("DEBUG: \($0)")
                    } receiveValue: { image in
                        ivs.profile.image = image
                    }.store(in: &self.subscriptions)
                self.fetchImage(with: self.postImageUrl!)
                    .sink { print("DEBUG: \($0)")
                        
                    } receiveValue: { image in
                        ivs.post.image = image
                        print("haha")
                    }.store(in: &self.subscriptions)
                
                return .configure(self.specificUsernameToNotify)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - APIs
extension NotificationCellViewModel {
    
    enum NotificationCellFetchImageError: Error, CustomStringConvertible{
        
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
    
    
    func fetchImage(with url: URL) -> AnyPublisher<UIImage,NotificationCellFetchImageError> {
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

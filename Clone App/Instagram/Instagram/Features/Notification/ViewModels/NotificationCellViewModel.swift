//
//  NotificationCellViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import UIKit
import Combine

struct NotificationCellViewModel {
    
    //MARK: - Properties
    private let notification: NotificationModel
    
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
            .map { iv -> NotificationCellState in
                URLSession.shared.dataTask(with: profileImageUrl!) { data,_,error in
                    guard error == nil else{
                        print("DEBUG: data task error")
                        return
                    }
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        iv.image = UIImage(data: data)!
                    }
                }.resume()
                return .configure(specificUsernameToNotify)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

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


extension NotificationCellViewModel: NotificationCellVMComputedProperties {
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        URL(string: notification.specificUserInfo.profileImageUrl)
    }
       
}

extension NotificationCellViewModel: NotificationCellViewModelType {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput {
        
        return input
            .initialization
            .map { iv -> NotificationCellState in
                print("a")
                URLSession.shared.dataTask(with: profileImageUrl!) { data,_,error in
                    guard error != nil else{
                        print("DEBUG: data task error")
                        return
                    }
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        iv.image = UIImage(data: data)!
                    }
                    
                }
                
                return .none
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

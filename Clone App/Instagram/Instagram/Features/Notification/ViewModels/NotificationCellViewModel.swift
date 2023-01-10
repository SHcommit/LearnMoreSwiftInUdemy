//
//  NotificationCellViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import Foundation

struct NotificationCellViewModel {
    //MARK: - Properties
    private let notification: NotificationModel
    //MARK: - Lifecycles
    init(notification: NotificationModel) {
        self.notification = notification
    }
    
}


extension NotificationCellViewModel: NotificationCellVMComputedProperties {
    var count: Int {
        <#code#>
    }
    
    var postImageUrl: URL? {
        <#code#>
    }
    
    var profileImageUrl: URL? {
        <#code#>
    }
    
    
}

extension NotificationCellViewModel: NotificationCellViewModelType {
    func transform(with input: NotificationCellViewModelInput) -> NotificationCellViewModelOutput {
        <#code#>
    }
    
    
}

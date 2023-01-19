//
//  NotificationServiceType.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import Foundation

enum NotificationServiceError: Error{
    case invalidDocuments
    case invalidCurrentUser
    case invalidNotificationList
}
extension NotificationServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidDocuments: return "Failed user's user-notifications list get"
        case .invalidCurrentUser: return  "Failed current user's uid bind"
        case .invalidNotificationList: return "Invalid notification's queryShot decoded list."
        }
    }
}

protocol NotificationServiceType {
    
    func uploadNotification(toUid uid: String,to uploadUserInfo: UploadNotificationModel, type: NotificationType, post: PostModel?)
    
    func fetchNotifications() async throws -> [NotificationModel]
    
}

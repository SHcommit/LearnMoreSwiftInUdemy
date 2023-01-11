//
//  NotificationModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import Foundation
import Firebase

enum NotificationType: Int, Codable {
    case like
    case follow
    case comment
}

extension NotificationType: CustomStringConvertible {
    var description: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return "started following you"
        case .comment: return "commented on your post"
        }
    }
    
    
}

struct NotificationModel: Codable {
    var postImageUrl: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let specificUserInfo: UploadNotificationModel
}

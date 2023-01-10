//
//  NotificationService.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import Foundation
import Firebase

struct NotificationService {
    
    static func uploadNotification(toUser uid: String, type: NotificationType, post: PostModel? = nil) {
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { return }
        var data = NotificationModel(uid: currentUid, timestamp: Timestamp(date: Date()), type: NotificationType(rawValue: type.rawValue) ?? .follow)
        if let post = post {
            data.postId = post.postId
            data.postImageUrl = post.imageUrl
        }
        do {
            _ = try COLLECTION_NOTIFICATION.document(uid).collection("user-notifications").addDocument(from: data)
        }catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        
    }
    
    static func fetchNotifications() {
        
    }
}

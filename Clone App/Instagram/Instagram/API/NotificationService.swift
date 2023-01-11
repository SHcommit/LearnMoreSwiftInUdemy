//
//  NotificationService.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import Foundation
import Firebase
import Combine

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

struct NotificationService {
    
    static func uploadNotification(toUid uid: String,to uploadUserInfo: UploadNotificationModel, type: NotificationType, post: PostModel? = nil) {
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { return }
        guard uid != currentUid else { return }
        let doc = COLLECTION_NOTIFICATION.document(uid).collection("user-notifications").document()
        var data = NotificationModel(timestamp: Timestamp(date: Date()),
                                     type: NotificationType(rawValue: type.rawValue) ?? .like,
                                     id: doc.documentID,
                                     specificUserInfo:
                                        UploadNotificationModel(uid: uploadUserInfo.uid,
                                                                profileImageUrl: uploadUserInfo.profileImageUrl,
                                                                username: uploadUserInfo.username))
        
        if let post = post {
            data.postId = post.postId
            data.postImageUrl = post.imageUrl
        }
        do {
            _ = try doc.setData(from: data)
        }catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        
    }
    
    static func fetchNotifications() async throws -> [NotificationModel] {
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { throw NotificationServiceError.invalidCurrentUser }
        guard let snapShot = try? await COLLECTION_NOTIFICATION.document(currentUid).collection("user-notifications").getDocuments() else {throw NotificationServiceError.invalidDocuments }
        let list = try? snapShot.documents.map{ try $0.data(as: NotificationModel.self)}
        guard let list = list else {
            throw NotificationServiceError.invalidNotificationList
        }
        return list
    }
}

//
//  NotificationService.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/10.
//

import Foundation
import Firebase
import Combine

struct NotificationService: NotificationServiceType {
  
  func uploadNotification(toUid uid: String, to uploadUserInfo: UploadNotificationModel, type: NotificationType, post: PostModel? = nil) {
    guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { return }
    guard uid != currentUid else { return }
    let doc = FSConstants.ref(.notifications).document(uid)
      .collection("user-notifications")
      .document()
    var data = NotificationModel(timestamp: Timestamp(date: Date()),
                                 type: NotificationType(rawValue: type.rawValue) ?? .like,
                                 id: doc.documentID,
                                 specificUserInfo: uploadUserInfo)
    
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
  
  func fetchNotifications() async throws -> [NotificationModel] {
    guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { throw NotificationServiceError.invalidCurrentUser }
    guard let snapShot = try? await FSConstants.ref(.notifications)
      .document(currentUid)
      .collection("user-notifications")
      .getDocuments() else {
      throw NotificationServiceError.invalidDocuments
    }
    let list = try? snapShot.documents.map{ try $0.data(as: NotificationModel.self)}
    guard let list = list else {
      throw NotificationServiceError.invalidNotificationList
    }
    return list
  }
}

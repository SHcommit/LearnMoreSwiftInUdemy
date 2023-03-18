//
//  NotificationServiceModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import Foundation

struct UploadNotificationModel: Codable {
  let uid: String
  let profileImageUrl: String
  let username: String
  var userIsFollowed: Bool
}

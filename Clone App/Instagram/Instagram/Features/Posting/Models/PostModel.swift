//
//  PostModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit
import Firebase

struct PostModel: Codable {
  var caption: String
  var timestamp: Timestamp
  var likes: Int
  var imageUrl: String
  var ownerUid: String
  var postId: String?
  var ownerImageUrl: String
  var ownerUsername: String
  var didLike: Bool?
}

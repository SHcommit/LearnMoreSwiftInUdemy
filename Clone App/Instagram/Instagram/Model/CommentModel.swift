//
//  CommentModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/24.
//

import Foundation
import Firebase


struct UploadCommentInputModel {
    let comment: String
    let postID: String
    let user: UserInfoModel
}

struct CommentModel: Codable {
    let uid: String
    let comment: String
    let timestamp: Timestamp
    let username: String
    let profileImageUrl: String
}

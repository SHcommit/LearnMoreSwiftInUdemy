//
//  PostService.swift
//  Instagram
//
//  Created by 양승현 on 2022/11/12.
//

import UIKit
import Firebase

enum FetchPostError: Error {
    case failToRequestPostData
    case failToRequestUploadImage
}

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage ) async throws {
        let ud = UserDefaults.standard
        ud.synchronize()
        guard let userUID = ud.string(forKey: CURRENT_USER_UID) else { throw FetchUserError.invalidGetDocumentUserUID }
        guard let url = try? await UserProfileImageService.uploadImage(image: image) else { throw FetchPostError.failToRequestUploadImage }
        let data = ["caption": caption,
                    "timestamp": Timestamp(date: Date()),
                    "likes": 0, "iamgeUrl": url,
                    "ownerUid": userUID] as [String: Any]
        guard let _ = try? await COLLECTION_POSTS.addDocument(data: data) else { throw FetchPostError.failToRequestPostData}
        
    }
}

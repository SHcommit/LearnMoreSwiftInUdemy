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
    case invalidPostsGetDocuments
    case failToEncodePost
}

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage ) async throws {
        let ud = UserDefaults.standard
        ud.synchronize()
        guard let userUID = ud.string(forKey: CURRENT_USER_UID) else { throw FetchUserError.invalidGetDocumentUserUID }
        guard let url = try? await UserProfileImageService.uploadImage(image: image) else { throw FetchPostError.failToRequestUploadImage }
        let post = PostModel(caption: caption, timestamp: Timestamp(date: Date()), likes: 0, imageUrl: url, ownerUid: userUID)
        let encodedPost = UserService.encodeToNSDictionary(codableType: post)
        guard let _ = try? await COLLECTION_POSTS.addDocument(data: encodedPost) else { throw FetchPostError.failToRequestPostData}
        
    }
    
    static func fetchPosts() async throws -> [PostModel]{
        guard let documents = try? await COLLECTION_POSTS.getDocuments().documents else { throw FetchPostError.invalidPostsGetDocuments }
        let posts = try documents.map {
            var post = try $0.data(as: PostModel.self)
            post.postId = $0.documentID
            return post
        }
        return posts
        
    }
}

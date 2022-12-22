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
    case invalidUserPostData
}

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, ownerProfileUrl ownerUrl: String, ownerUsername ownerName: String) async throws {
        let ud = UserDefaults.standard
        ud.synchronize()
        guard let userUID = ud.string(forKey: CURRENT_USER_UID) else { throw FetchUserError.invalidGetDocumentUserUID }
        let url = try await uploadImage(with: image)
        let post = PostModel(caption: caption, timestamp: Timestamp(date: Date()), likes: 0, imageUrl: url, ownerUid: userUID, ownerImageUrl: ownerUrl, ownerUsername: ownerName)
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

extension PostService {
    // uploadPost에 사용됨.
    private static func uploadImage(with image: UIImage) async throws -> String {
        do {
            let url = try await UserProfileImageService.uploadImage(image: image)
            return url
        }catch {
            uploadImageErrorHandling(with: error as! ImageServiceError)
            throw FetchPostError.failToRequestUploadImage
        }
    }
    
    static func uploadImageErrorHandling(with error: ImageServiceError){
        switch error {
        case .invalidUserProfileImage:
            print("DEBUG: \(ImageServiceError.invalidUserProfileImage) : \(error.localizedDescription)")
        case .failedFetchUserProfileImage:
            print("DEBUG: \(ImageServiceError.failedFetchUserProfileImage) : \(error.localizedDescription)")
        case .failedPutImageDataAsync:
            print("DEBUG: \(ImageServiceError.failedPutImageDataAsync) : \(error.localizedDescription)")
        case .failedGetImageInstance:
            print("DEBUG: \(ImageServiceError.failedGetImageInstance) : \(error.localizedDescription)")
        }
    }
}

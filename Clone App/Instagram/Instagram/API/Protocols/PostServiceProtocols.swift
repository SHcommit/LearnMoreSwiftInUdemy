//
//  PostServiceProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/22.
//

import UIKit

enum FetchPostError: Error {
    case failToRequestPostData
    case failToRequestUploadImage
    case invalidPostsGetDocuments
    case failToEncodePost
    case invalidUserPostData
}

protocol PostServiceType {
    static func uploadPost(caption: String, image: UIImage, ownerProfileUrl ownerUrl: String, ownerUsername ownerName: String) async throws
    
    static func fetchPosts() async throws -> [PostModel]
    
    static func uploadImage(with image: UIImage) async throws -> String
    
}

protocol ProstServiceErrorType {
    static func uploadImageErrorHandling(with error: ImageServiceError)
}

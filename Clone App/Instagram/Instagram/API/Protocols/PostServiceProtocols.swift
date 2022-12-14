//
//  PostServiceProtocols.swift
//  Instagram
//
//  Created by μμΉν on 2022/12/22.
//

import UIKit

enum FetchPostError: Error {
    case failToRequestPostData
    case failToRequestUploadImage
    case invalidPostsGetDocuments
    case failToEncodePost
    case invalidUserPostData
    
    var errorDescription: String {
        switch self {
        case .failToRequestPostData:
            return "Failed to request post data"
        case .failToRequestUploadImage:
            return "Failed to request upload image"
        case .invalidPostsGetDocuments:
            return "Invalid to get posts docuemnt"
        case .failToEncodePost:
            return "Failed to endoce post"
        case .invalidUserPostData:
            return "Inalid user post data"
        }
    }
}

protocol PostServiceType {
    static func uploadPost(caption: String, image: UIImage, ownerProfileUrl ownerUrl: String, ownerUsername ownerName: String) async throws
    
    static func fetchPosts() async throws -> [PostModel]
    
    static func uploadImage(with image: UIImage) async throws -> String
    
    static func fetchSpecificUserPostsInfo(forUser uid: String) async throws -> [PostModel]
    
}

protocol ProstServiceErrorType {
    static func uploadImageErrorHandling(with error: ImageServiceError)
}

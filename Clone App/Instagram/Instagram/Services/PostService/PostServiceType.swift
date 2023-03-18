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
  
  func fetchPosts() async throws -> [PostModel]
  
  func fetchPost(withPostId id: String) async throws -> PostModel
  
  func fetchSpecificUserPostsInfo(forUser uid: String) async throws -> [PostModel]
  
  func uploadPost(caption: String, image: UIImage, ownerProfileUrl ownerUrl: String, ownerUsername ownerName: String) async throws
  
  
  func uploadImage(with image: UIImage) async throws -> String
  
  func likePost(post: PostModel) async
  
  func unlikePost(post: PostModel) async
  
  func checkIfUserLikedPost(post: PostModel) async -> Bool
  
}

protocol ProstServiceErrorType {
  func uploadImageErrorHandling(with error: ImageServiceError)
}

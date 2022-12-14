//
//  ImageServiceProtocols.swift
//  Instagram
//
//  Created by μμΉν on 2022/12/22.
//

import UIKit

enum ImageServiceError: Error {
    case invalidUserProfileImage
    case failedFetchUserProfileImage
    case failedPutImageDataAsync
    case failedGetImageInstance
    
    var errorDescription: String {
        switch self {
        case .invalidUserProfileImage: return "Invalid user profile image instalce"
        case .failedFetchUserProfileImage: return "Failed to fetch user profile image in firebase's storage"
        case .failedPutImageDataAsync: return "Failed to put image data async in firebase's storage"
        case .failedGetImageInstance: return "Failed to get user's image in firestore's storage"
        }
    }
}

protocol UserProfileImageServiceType {
    //MARK: - Firebase storage upload image
    static func uploadImage(image: UIImage) async throws -> String
    //MARK: - Firebase storage download image
    static func fetchUserProfile(userProfile url: String) async throws -> UIImage
    
}

//
//  ImageUploader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import FirebaseStorage

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

//MARK: - Firebase storage upload image
struct UserProfileImageService {
    
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw ImageServiceError.invalidUserProfileImage }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: " /profile_images/\(filename)")
        guard let _ = try? await ref.putDataAsync(imageData) else { throw ImageServiceError.failedPutImageDataAsync }
        return (try await ref.downloadURL()).absoluteString
    }
}

//MARK: - Firebase storage download image
extension UserProfileImageService {
    
    static func fetchUserProfile(userProfile url: String) async throws -> UIImage {
        guard let data = try? await STORAGE.reference(forURL: url).data(maxSize: USERPROFILEIMAGEMEGABYTE) else {
            throw ImageServiceError.failedFetchUserProfileImage}
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.failedGetImageInstance }
        return image
    }
    
}

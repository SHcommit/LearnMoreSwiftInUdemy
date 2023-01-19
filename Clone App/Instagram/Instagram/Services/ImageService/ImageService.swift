//
//  ImageUploader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import FirebaseStorage

struct UserProfileImageService: UserProfileImageServiceType {
    
    func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw ImageServiceError.invalidUserProfileImage }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: " /profile_images/\(filename)")
        guard let _ = try? await ref.putDataAsync(imageData) else { throw ImageServiceError.failedPutImageDataAsync }
        return (try await ref.downloadURL()).absoluteString
    }
    
    func fetchUserProfile(userProfile url: String) async throws -> UIImage {
        guard let data = try? await STORAGE.reference(forURL: url).data(maxSize: USERPROFILEIMAGEMEGABYTE) else {
            throw ImageServiceError.failedFetchUserProfileImage}
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.failedGetImageInstance }
        return image
    }
    
}

//
//  ImageUploader.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import FirebaseStorage

//MARK: - Firebase storage upload image
struct UserProfileImageService {
    
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw AuthError.invalidCurrentImage }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: " /profile_images/\(filename)")
        try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}

//MARK: - Firebase storage download image
extension UserProfileImageService {
    
    static func fetchUserProfile(userProfile url: String) async throws -> UIImage {
        let data = try await STORAGE.reference(forURL: url).data(maxSize: USERPROFILEIMAGEMEGABYTE)
        guard let image = UIImage(data: data) else { throw FetchUserError.invalidUserProfileImage }
        return image
    }
    
}

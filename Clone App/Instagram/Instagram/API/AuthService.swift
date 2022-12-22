//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//
/**
    TODO: api async, await로 전부 바꿀것! 
 */
import Firebase
import FirebaseFirestore

enum AuthError: Error {
    case invalidProfileImage
    case failedUploadImage
    case failedUserAccount
    case invalidSetUserDataOnFireStore
    
    var errorDescription: String {
        switch self {
        case .invalidProfileImage: return "Invalid profile image instance"
        case .failedUploadImage: return "Failed to upload user's profile image on firebase's storage"
        case .failedUserAccount: return "Failed to create user account in firebase's Auth"
        case .invalidSetUserDataOnFireStore: return "Invalid to set user data in fireStore's USERS document"
        }
    }
}

struct AuthService {
    
    static func handleIsLoginAccount(email: String, pw: String) async throws -> AuthDataResult? {
        return try await AUTH.signIn(withEmail: email, password: pw)
    }
    
    static func registerUser(withUserInfo info: RegistrationViewModel) async throws {
        guard let image = info.profileImage else { throw AuthError.invalidProfileImage }
        guard let imageUrl = try? await UserProfileImageService.uploadImage(image: image) else { throw AuthError.failedUploadImage }
        guard let result = try? await AUTH.createUser(withEmail: info.email, password: info.password) else { throw AuthError.failedUserAccount }
        let userUID = result.user.uid
        let user = info.getUserInfoModel(uid: userUID, url: imageUrl)
        let encodedUserModel = encodeToNSDictionary(codableType: user)
        guard let _ = try? await COLLECTION_USERS.document(userUID).setData(encodedUserModel) else { throw AuthError.invalidSetUserDataOnFireStore}
    }
    
}

//MAKR: Extension
extension AuthService {
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}

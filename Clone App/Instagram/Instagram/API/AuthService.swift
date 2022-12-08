//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import Firebase
import FirebaseFirestore

enum AuthError: Error {
    case invalidUserIDPW
    case badImage
    case invalidCurrentImage
    case invalidDownloadUrl
    case invalidUserAccount
    case invalidSetUserDataOnFireStore
}

struct AuthService {
    
    static func handleIsLoginAccount(email: String, pw: String) async throws -> AuthDataResult? {
        return try await AUTH.signIn(withEmail: email, password: pw)
    }
    
    static func registerUser(withUserInfo info: RegistrationViewModel) async throws {
        guard let image = info.profileImage else { throw AuthError.badImage }
        guard let imageUrl = try? await UserProfileImageService.uploadImage(image: image) else { throw AuthError.badImage }
        guard let result = try? await AUTH.createUser(withEmail: info.email, password: info.password) else { throw AuthError.invalidUserAccount }
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

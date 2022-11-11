//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import Firebase
import FirebaseFirestore

enum AuthError {
    case invalidUserIDPW
}

struct AuthService {
    
    static func handleIsLoginAccount(email: String, pw: String) async throws -> AuthDataResult? {
        return try await AUTH.signIn(withEmail: email, password: pw)
    }
    
    static func registerUser(withUserInfo info: RegistrationViewModel, completion: @escaping (Error?)->Void) {
        guard let image = info.profileImage else { return }
        
        UserProfileImageService.uploadImage(image: image) { imageUrl in
            AUTH.createUser(withEmail: info.email.value, password: info.password.value) { result, error in
                guard error == nil else { print("Fail uploadImage: \(error?.localizedDescription)"); return }
                guard let uid = result?.user.uid else { return }
                let userModel = info.getUserInfoModel(uid: uid, url: imageUrl)
                let encodedUserModel = encodeToNSDictionary(codableType: userModel)
                COLLECTION_USERS.document(uid).setData(encodedUserModel, completion: completion)
            }
        }
    }
    
}

//MAKR: Extension
extension AuthService {
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}

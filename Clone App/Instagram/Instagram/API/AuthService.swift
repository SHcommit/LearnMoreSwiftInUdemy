//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import Firebase
import FirebaseFirestore

struct AuthService {
    
    static func handleIsLoginAccount(email: String, pw: String, completion: @escaping (AuthDataResult?,Error?)-> Void) {
        Auth.auth().signIn(withEmail: email, password: pw, completion: completion)
    }
    
    static func registerUser(withUserInfo info: RegistrationViewModel, completion: @escaping (Error?)->Void) {
        guard let image = info.profileImage else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            Auth.auth().createUser(withEmail: info.email.value, password: info.password.value) { result, error in
                guard error == nil else { print("Fail uploadImage"); return }
                guard let uid = result?.user.uid else { return }

                let userModel = info.getUserInfoModel(uid: uid, url: imageUrl)
                let encodedUserModel = encodeToNSDictionary(codableType: userModel)
                Firestore.firestore().collection("users").document(uid).setData(encodedUserModel, completion: completion)
            }
        }
    }
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
}

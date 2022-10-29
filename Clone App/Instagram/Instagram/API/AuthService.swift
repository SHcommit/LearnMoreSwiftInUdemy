//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import Firebase

struct AuthService {
    
    static func handleIsLoginAccount(email: String, pw: String, completion: @escaping (AuthDataResult?,Error?)-> Void) {
        Auth.auth().signIn(withEmail: email, password: pw, completion: completion)
    }
    
    static func registerUser(withUserInfo info: RegistrationViewModel, completion: @escaping (Error?)->Void) {
        guard let image = info.profileImage else { return }
        ImageUploader.uploadImage(image: image) { imageUrl in
            Auth.auth().createUser(withEmail: info.email.value, password: info.password.value) { result, error in
                
                if let error = error  {
                    print("DEBUG : Failure uploadImage \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                //이거도 codable로바꿔야겠다 나중에,, Authentication에 RegistrationViewModel!! 이거
                let data : [String : Any] = ["email" : info.email.value,
                                           "fullname" : info.fullname.value,
                                           "profileImgaeUrl": imageUrl,
                                           "uid" : uid,
                                           "username" : info.username.value]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
            
        }
    }
}

//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//

import Firebase
import FirebaseFirestore

let firestoreUsers = "users"

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
                Firestore.firestore().collection(firestoreUsers).document(uid).setData(encodedUserModel, completion: completion)
            }
        }
    }
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
    static func updateCurrentUserInfo(CodableType info: UserInfoModel) {
        let encodedUserModel = encodeToNSDictionary(codableType: info)
        Firestore.firestore().collection(firestoreUsers).document(info.uid).updateData(encodedUserModel)
        
    }
    
    static func fetchCurrentUserInfo(completion: @escaping (UserInfoModel?)->Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { completion((nil)); return }
        let db = Firestore.firestore()
        let userCollection = db.collection(firestoreUsers)
        userCollection.document(userUID).getDocument() { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            do {
                completion(try document.data(as: UserInfoModel.self))
            }catch let e {
                print("Fail decode user document field : \(e.localizedDescription)")
            }
            completion(nil)
        }
    }
    
    static func fetchUserProfile(userProfile url: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: url)
        
        storageReference.getData(maxSize: userProfileMegaByte) { data, error in
            guard error == nil else { return }
            guard let data = data else { completion(nil); return }
            completion(UIImage(data: data))
        }
    }
    

}

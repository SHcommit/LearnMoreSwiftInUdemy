//
//  UserService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/31.
//

import Firebase
import FirebaseFirestore


struct UserService {
    
    static func updateCurrentUserInfo(CodableType info: UserInfoModel) {
        let encodedUserModel = encodeToNSDictionary(codableType: info)
        COLLECTION_USERS.document(info.uid).updateData(encodedUserModel)
        
    }
    
    static func fetchCurrentUserInfo(completion: @escaping (UserInfoModel?)->Void) {
        guard let userUID = CURRENT_USER?.uid else { completion((nil)); return }
        COLLECTION_USERS.document(userUID).getDocument() { documentSnapshot, error in
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
        let storageReference = STORAGE.reference(forURL: url)
        
        storageReference.getData(maxSize: USERPROFILEIMAGEMEGABYTE) { data, error in
            guard error == nil else { return }
            guard let data = data else { completion(nil); return }
            completion(UIImage(data: data))
        }
    }

}

//MAKR: Extension
extension UserService {
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}
//
//  UserService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/31.
//

import Firebase
import FirebaseFirestore

enum FetchUserError: Error {
    case invalidGetDocumentUserUID
    case invalidUserInfo
    case invalidUserProfileImage
    case invalidUserStats
}

enum SystemError: Error {
    case invalidAppDelegateInstance
    case invalidCurrentUserUID
}

//MARK: - Firestore user default info
struct UserService {
    
    static func updateCurrentUserInfo(CodableType info: UserInfoModel) async throws {
        let encodedUserModel = encodeToNSDictionary(codableType: info)
        let userDocument = COLLECTION_USERS.document(info.uid)
        try await userDocument.updateData(encodedUserModel)
    }
    
    static func fetchUserInfo(withUid uid: String) async throws -> UserInfoModel? {
        let result = try await COLLECTION_USERS.document(uid).getDocument()
        if result.exists {
            return try result.data(as: UserInfoModel.self)
        }else {
            throw FetchUserError.invalidGetDocumentUserUID
        }
    }
    
    static func fetchCurrentUserInfo() async throws -> UserInfoModel? {
        let currentUserUID = try await currentUserLogindUID()
        return try await fetchUserInfo(withUid: currentUserUID)
    }
    
    static func currentUserLogindUID() async throws -> String {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else { throw SystemError.invalidAppDelegateInstance }
        appDelegate.pList.synchronize()
        guard let userUID = appDelegate.pList.string(forKey: CURRENT_USER_UID) else { throw SystemError.invalidCurrentUserUID }
        return userUID
    }

}

//MAKR: Extension
extension UserService {
    
    static func encodeToNSDictionary(codableType info: Codable) -> [String : Any] {
        guard let dataDictionary = info.encodeToDictionary else { fatalError() }
        return dataDictionary
    }
    
}

//MARK: - SearchController API
extension UserService {
    
    static func fetchUserList(completion: @escaping ([UserInfoModel]?) -> Void) {
        COLLECTION_USERS.getDocuments { document, error in
            guard let documents = document?.documents else { return }
            do{
                var users = [UserInfoModel]()
                documents.map {
                    let user: UserInfoModel? = try? $0.data(as: UserInfoModel.self)
                    guard let user = user else { return }
                    users.append(user)
                }
                completion(users)
            }catch let e {
                completion(nil)
                print("DEBUG: can't parsing fireStore's all user info. \(e.localizedDescription)")
            }
            
        }
    }
    
}

//MARK: - ProfileController API.
extension UserService {
    
    static func follow(uid: String, completion: @escaping(FiresotreCompletion)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.pList.synchronize()
        guard let currentUid = appDelegate.pList.string(forKey: CURRENT_USER_UID) else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { _ in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
            
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FiresotreCompletion)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.pList.synchronize()
        guard let currentUid = appDelegate.pList.string(forKey: CURRENT_USER_UID) else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete() { _ in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
            
        }
    }
    
    
    static func checkIfUserIsFollowd(uid: String, completion: @escaping(Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.pList.synchronize()
        guard let currentUid = appDelegate.pList.string(forKey: CURRENT_USER_UID) else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument() { document, _ in
            guard let isFollowd = document?.exists else { return }
            completion(isFollowd)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(Userstats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments() { document, error in
            let followers = document?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments() { document, error in
                let following = document?.documents.count ?? 0
                
                completion(Userstats(followers: followers, following: following))
            }
        }
    }
}

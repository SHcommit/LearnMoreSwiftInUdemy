//
//  UserService.swift
//  Instagram
//
//  Created by μμΉν on 2022/10/31.
//

import Firebase
import FirebaseFirestore

//MARK: - Firestore user default info
struct UserService: ServiceExtensionType, UserServiceDefaultType {
    
    static func updateCurrentUserInfo(CodableType info: UserInfoModel) async throws {
        let encodedUserModel = encodeToNSDictionary(info: info)
        let userDocument = COLLECTION_USERS.document(info.uid)
        try await userDocument.updateData(encodedUserModel)
    }
    
    static func fetchUserInfo<T: Codable>(type: T.Type, withUid uid: String) async throws -> T? {
        guard let result = try? await COLLECTION_USERS.document(uid).getDocument() else {
            throw FetchUserError.invalidGetDocumentUserUID
        }
        if !result.exists { throw FetchUserError.invalidGetDocumentUserUID }
        return try result.data(as: type.self)
    }
    
    static func fetchCurrentUserInfo<T: Codable>(type: T.Type) async throws -> T? {
        let currentUserUID = try currentUserLogindUID()
        return try await fetchUserInfo(type: type.self, withUid: currentUserUID)
    }
    
    static func currentUserLogindUID() throws -> String {
        let ud = UserDefaults.standard
        ud.synchronize()
        guard let userUID = ud.string(forKey: CURRENT_USER_UID) else { throw FetchUserError.invalidCurrentUserUIDInUserDefaultsStandard }
        return userUID
    }

}

//MARK: - SearchController API
extension UserService: UserServiceAboutSearchType {
    
    static func fetchUserList<T: Codable>(type: T.Type) async throws -> [T]? {
        let docuemts = try await COLLECTION_USERS.getDocuments().documents
        return try docuemts.map{
            try $0.data(as: type.self)
        }
    }
    
}

//MARK: - ProfileController API.
extension UserService: UserServiceAboutProfileType {
    
    static func follow(someone uid: String) async throws {
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { throw FollowServiceError.invalidCurrentUserUIDInUserDefaultsStandard }
        return await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                guard let _ = try? await COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
                    .document(uid).setData([:]) else { throw FollowServiceError.failedFollowingToSetData }
            }
            
            group.addTask {
                guard let _ = try? await COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).setData([:]) else {
                    throw FollowServiceError.failedFollowerToSetData }
            }
        }
    }
    
    static func unfollow(someone uid: String) async throws {
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else { throw
            UnFollowServiceError.invalidCurrentUserUIDInUserDefaultsStandard }
        return await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                guard let _ = try? await COLLECTION_FOLLOWING
                    .document(currentUid).collection("user-following")
                    .document(uid).delete() else {
                    throw UnFollowServiceError.failedUnFollowSpecificUserFromLoginUser
                }
            }
            group.addTask {
                guard let _ = try? await COLLECTION_FOLLOWERS
                    .document(uid).collection("user-followers")
                    .document(currentUid).delete() else {
                    throw UnFollowServiceError.failedUnFollowLoginUserFromSpecificUser
                }
            }
        }
    }
    
    static func checkIfUserIsFollowd(uid: String) async throws -> Bool {
        
        guard let currentUid = Utils.pList.string(forKey: CURRENT_USER_UID) else {
            throw CheckUserFollowedError.invalidCurrentUserUIDInUserDefaultsStandard }
        guard let docSanps = try? await COLLECTION_FOLLOWING
            .document(currentUid).collection("user-following")
            .document(uid).getDocument() else {
            throw CheckUserFollowedError.invalidSpecificUserInfo }
        return docSanps.exists
    }
    
    static func fetchUserStats(uid: String) async throws -> Userstats {
    
        guard let followerQuery = try? await COLLECTION_FOLLOWERS
            .document(uid).collection("user-followers")
            .getDocuments() else {
            throw FetchUserStatsError.invalidSpecificUserFollowersDocument
        }
        guard let followingQuery = try? await COLLECTION_FOLLOWING
            .document(uid).collection("user-following")
            .getDocuments() else {
            throw FetchUserStatsError.invalidSpecificUSerFollowingDocuemnt
        }
        return Userstats(followers: followerQuery.count, following: followingQuery.count)
    }
    
}

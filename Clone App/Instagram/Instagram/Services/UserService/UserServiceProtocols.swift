//
//  UserServiceProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/22.
//

import Foundation

enum FetchUserError: Error {
    case invalidCurrentUserUIDInUserDefaultsStandard
    case invalidGetDocumentUserUID
    case invalidUserInfo
    case invalidUserProfileImage
    case invalidUserStats
    //userAllList
    case invalidDocuemnts
    case invalidUserData
    case invalidUsers
}

enum FollowServiceError: Error {
    case invalidCurrentUserUIDInUserDefaultsStandard
    case failedFollowingToSetData
    case failedFollowerToSetData
    
    var errorDescription: String {
        switch self {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            return "Invalid current user's uid in userDefaults standard"
        case .failedFollowingToSetData:
            return "Failed following to set data in Firestore's Following"
        case .failedFollowerToSetData:
            return "Failed follower to set data in Firestore's Follower"
        }
        
    }
}

// 내가(로그인한)_ 상대방의 팔로우를 끊지 못하거나 상대방입장에서 팔로우 수 안 줄어드는 에러
enum UnFollowServiceError: Error {
    case invalidCurrentUserUIDInUserDefaultsStandard
    case failedUnFollowSpecificUserFromLoginUser
    case failedUnFollowLoginUserFromSpecificUser
    
    var errorDescription: String {
        switch self {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            return "Invalid current user's uid in userDefaults standard"
        case .failedUnFollowSpecificUserFromLoginUser:
            return "Failed to delete current user's following specific user info "
        case .failedUnFollowLoginUserFromSpecificUser:
            return "Failed to delete specific user's followers in current user's info"
        }
    }
}

enum CheckUserFollowedError: Error {
    case invalidCurrentUserUIDInUserDefaultsStandard
    case invalidSpecificUserInfo
    
    var errorDescription: String {
        switch self {
        case .invalidCurrentUserUIDInUserDefaultsStandard:
            return "Invalid current user's uid in userDefaults standard"
        case .invalidSpecificUserInfo:
            return "Invalid specific user info in current user's following info"
        }
    }
}

enum FetchUserStatsError: Error {
    case invalidSpecificUserFollowersDocument
    case invalidSpecificUSerFollowingDocuemnt
    
    var errorDescription: String {
        switch self {
        case .invalidSpecificUserFollowersDocument:
            return "Invalid specific user's followers document"
        case .invalidSpecificUSerFollowingDocuemnt:
            return "Invalid specific user's following document"
        }
    }
}

protocol UserServiceType: UserServiceDefaultType, UserServiceAboutSearchType, UserServiceAboutProfileType { }


protocol UserServiceDefaultType {
    
    func updateCurrentUserInfo(CodableType info: UserInfoModel) async throws
    
    func fetchUserInfo<T: Codable>(type: T.Type, withUid uid: String) async throws -> T?
    
    func fetchCurrentUserInfo<T: Codable>(type: T.Type) async throws -> T?
    
    func currentUserLogindUID() throws -> String
    
}

protocol UserServiceAboutSearchType {
    
    func fetchUserList<T: Codable>(type: T.Type) async throws -> [T]?
    
}

protocol UserServiceAboutProfileType {
    
    func follow(someone uid: String) async throws
    
    func unfollow(someone uid: String) async throws
    
    func checkIfUserIsFollowd(uid: String) async throws -> Bool
    
    func fetchUserStats(uid: String) async throws -> Userstats
    
}

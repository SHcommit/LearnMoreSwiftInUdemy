//
//  AuthServiceProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/22.
//

import Foundation
import Firebase

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

protocol AuthServiceType: ServiceExtensionType {
    
    static func handleIsLoginAccount(email: String, pw: String) async throws -> AuthDataResult?
    
    static func registerUser(with info: RegistrationViewModel) async throws
    
}

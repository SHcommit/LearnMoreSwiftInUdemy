//
//  AuthService.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/10.
//
/**
 TODO: api async, await로 전부 바꿀것!
 */
import Firebase
import FirebaseFirestore

struct AuthService: ServiceExtensionType, AuthServiceType {
  
  func handleIsLoginAccount(email: String, pw: String) async throws -> AuthDataResult? {
    return try await AUTH.signIn(withEmail: email, password: pw)
  }
  
  func registerUser(with info: RegistrationViewModel) async throws {
    guard let image = info.profileImage else { throw AuthError.invalidProfileImage }
    guard let imageUrl = try? await UserProfileImageService().uploadImage(image: image) else { throw AuthError.failedUploadImage }
    guard let result = try? await AUTH.createUser(withEmail: info.email, password: info.password) else { throw AuthError.failedUserAccount }
    let userUID = result.user.uid
    let user = info.getUserInfoModel(uid: userUID, url: imageUrl)
    let encodedUserModel = encodeToNSDictionary(info: user)
    guard let _ = try? await FSConstants.ref(.users).document(userUID).setData(encodedUserModel) else { throw AuthError.invalidSetUserDataOnFireStore}
  }
  
}

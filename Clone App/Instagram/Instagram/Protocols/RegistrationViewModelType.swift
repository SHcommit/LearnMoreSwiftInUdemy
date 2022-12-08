//
//  RegistrationViewModelType.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine

protocol RegistrationViewModelType {
    
    /// 사용자의 특정 event를 input 타입으로 분리. RegistrationViewController로 부터 특정 event publish.
    func bind(with input: RegistrationViewModelInput)
    
    /// Return UserInfoModel
    func getUserInfoModel(uid: String, url: String) -> UserInfoModel
}


protocol RegistrationViewModelUserFormType {
    
    func isValidUserForm() -> AnyPublisher<Bool,Never>
    
    /// Check all TextField is not empty with zip operation :)
    func checkIsValidTextFields(isValid: Bool, button: UIButton)
    
    /// Button's isEnable true. when isValidUserForm isValidUserForm publish true
    func validUserForm(with button: UIButton)
    
    /// Button's isEnable false. when isValidUserForm isValidUserForm publish false
    func notValidUserForm(with button: UIButton)
    
}

protocol RegistrationViewModelNetworkServiceType {
    
    //MARK: APIs
    /// Wrapper func in AuthService.registerUser(withUserInfo:)
    func registerUserFromSignUp() async throws
    
    /// Register User form from async func registerUserFormSignUp()
    func registerUser()
    
    //MARK: - API error handling
    /// Error handling from registerUserFormSIgnUp func
    func registerUserFromSignUpErrorHandling(error: Error)
    
}

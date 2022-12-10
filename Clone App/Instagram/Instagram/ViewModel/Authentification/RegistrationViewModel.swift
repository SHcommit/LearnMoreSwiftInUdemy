//
//  RegistrationViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/06.
//

import UIKit
import Combine

class RegistrationViewModel {
    
    //MARK: - Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var username: String = ""
    @Published var profileImage: UIImage? = UIImage()
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
}

//MARK: - RegistrationViewModelType
extension RegistrationViewModel: RegistrationViewModelType {
    
    func getUserInfoModel(uid: String, url: String) -> UserInfoModel {
        return UserInfoModel(email: email, fullname: fullname,
                             profileURL: url, uid: uid,
                             username: username)
    }
    
    func bind(with input: RegistrationViewModelInput) {
        
        input.signUpTap
            .receive(on: RunLoop.main)
            .sink { [unowned self] navigationController in
                navigationController?.startIndicator(indicator: indicator)
                registerUser()
                navigationController?.endIndicator(indicator: indicator)
                navigationController?.popViewController(animated: true)
            }.store(in: &subscriptions)

        input.photoPickerTap
            .receive(on: RunLoop.main)
            .sink { viewController in
                let picker = UIImagePickerController()
                picker.delegate = viewController
                picker.allowsEditing = true
                viewController.present(picker, animated: true)
            }.store(in: &subscriptions)
            
    }
    
}

//MARK: - RegistrationViewModelUserFormType
extension RegistrationViewModel: RegistrationViewModelUserFormType {
    
    func isValidUserForm() -> AnyPublisher<Bool, Never> {
        $email
            .zip($fullname, $username, $password)
            .map { (emailText, fullnameText, usernameText, passwordText) in
                return !emailText.isEmpty && !fullnameText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    func checkIsValidTextFields(isValid: Bool, button: UIButton) {
        isValid ? validUserForm(with: button) : notValidUserForm(with: button)
    }
    
    func validUserForm(with button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
        button.titleLabel?.textColor.withAlphaComponent(1)
    }
    
    func notValidUserForm(with button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        button.titleLabel?.textColor.withAlphaComponent(0.2)
    }
    
}

//MARK: - RegistrationViewModelNetworkServiceType
extension RegistrationViewModel: RegistrationViewModelNetworkServiceType {
    
    func registerUser() {
        Task() { [weak self] in
            do {
                try await self?.registerUserFromSignUp()
            } catch {
                self?.registerUserFromSignUpErrorHandling(error: error)
            }
        }
    }
    
    
    func registerUserFromSignUp() async throws {
        try await AuthService.registerUser(withUserInfo: self)
    }
    
    func registerUserFromSignUpErrorHandling(error: Error) {
        switch error {
        case AuthError.badImage:
            print("DEBUG: Failure bind registerUser's info.profileImage")
        case AuthError.invalidUserAccount:
            print("DEBUG: Failure create user account")
        case AuthError.invalidSetUserDataOnFireStore:
            print("DEBUG: Failure add user Info in firestore")
        default:
            print("DEBUG: Unexcept error occured: \(error.localizedDescription)")
        }

    }
    
}

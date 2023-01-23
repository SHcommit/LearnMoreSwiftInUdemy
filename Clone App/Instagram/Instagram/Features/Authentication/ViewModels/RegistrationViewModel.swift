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
    fileprivate let successRegistration = PassthroughSubject<Void,Never>()
    fileprivate let apiClient: ServiceProviderType
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
    }
    
}

//MARK: - RegistrationViewModelType
extension RegistrationViewModel: RegistrationViewModelType {
    
    func getUserInfoModel(uid: String, url: String) -> UserModel {
        return UserModel(email: email, fullname: fullname,
                             profileURL: url, uid: uid,
                             username: username)
    }
    
    func transform(with input: Input) -> Output {
        
        let successRegistrationSubscription = successRegistration
            .map { _ -> State in
                return .showLogin
            }.eraseToAnyPublisher()
        
        let signUpTapSubscription = input.signUpTap
            .map { _ -> State in
                self.registerUser()
                return .none
            }.eraseToAnyPublisher()

        let photoPickerTapSubscription = input.photoPickerTap
            .map { _ -> State in
                return .showPicker
            }.eraseToAnyPublisher()
        
        return Publishers
            .Merge3(
                successRegistrationSubscription,
                signUpTapSubscription,
                photoPickerTapSubscription)
            .eraseToAnyPublisher()
            
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
                successRegistration.send()
            } catch {
                self?.registerUserFromSignUpErrorHandling(error: error)
            }
        }
    }
    
    
    func registerUserFromSignUp() async throws {
        try await apiClient.authCase.registerUser(with: self)
    }
    
    func registerUserFromSignUpErrorHandling(error: Error) {
        switch error {
        case AuthError.invalidProfileImage:
            print("DEBUG: \(AuthError.invalidProfileImage) : \( error.localizedDescription)")
        case AuthError.failedUserAccount:
            print("DEBUG: \(AuthError.failedUserAccount) : \(error.localizedDescription)")
        case AuthError.invalidSetUserDataOnFireStore:
            print("DEBUG: Failure add user Info in firestore")
        default:
            print("DEBUG: Unexcept error occured: \(error.localizedDescription)")
        }

    }
    
}

//
//  LoginViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/07.
//

import UIKit
import Combine

final class LoginViewModel {
    
    //MARK: - Properties
    @Published var email: String = ""
    @Published var passwd: String = ""
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
}

//MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    func transform(with input: LoginViewModelInput) -> LoginViewModelOutput {
        subscriptions.forEach{ $0.cancel() }
        subscriptions.removeAll()
        
        //MARK: - Publiser's operator chains
        let login = loginChains(with: input)
        let signUp = signUpChains(with: input)
        let emailNotification = emailNotificationChains(with: input)
        let passwdNotification = passwdNotificationChains(with: input)
        let isValidForm = isValidFormChains(with: input)
        
        //MARK: - Merge publishers
        let sceneOutput: LoginViewModelOutput = Publishers.Merge(login,signUp).eraseToAnyPublisher()
        let textNotificationOutput: LoginViewModelOutput = Publishers.Merge(emailNotification,passwdNotification).eraseToAnyPublisher()
        let outputPublishers = Publishers.Merge(sceneOutput, textNotificationOutput).eraseToAnyPublisher()
        
        return Publishers.Merge(outputPublishers, isValidForm).eraseToAnyPublisher()
    }

}

//MARK: - LoginViweModelInputCase
extension LoginViewModel: LoginViewModelInputCase {
    
    func loginChains(with input: LoginViewModelInput) -> LoginViewModelOutput {
        return input.login
            .receive(on: RunLoop.main)
            .tryMap { [unowned self] viewType -> LoginControllerState in
                guard
                    let presentingVC = viewType.presentingVC as? MainHomeTabController,
                    let currentVC = viewType.currentVC as? LoginController
                else {
                    throw LoginViewModelErrorType.loginPublishedOutputStreamNil
                }
                presentingVC.view.isHidden = false
                loginInputAccount()
                return .loginSuccess
            }.mapError{ error -> LoginViewModelErrorType in
                return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func signUpChains(with input: LoginViewModelInput) -> LoginViewModelOutput {
        return input.signUp
            .receive(on: RunLoop.main)
            .tryMap { navigationController -> LoginControllerState in
                let registrationVC = RegistrationController()
                guard let navigationController = navigationController else {
                    throw LoginViewModelErrorType.signUpPublisedOutputStreamNil
                }
                navigationController.pushViewController(registrationVC, animated: true)
                return .endIndicator
            }.mapError{ error -> LoginViewModelErrorType in
                return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func emailNotificationChains(with input: LoginViewModelInput) -> LoginViewModelOutput {
        return input.emailNotification
            .receive(on: RunLoop.main)
            .map { [unowned self] text -> LoginControllerState in
                email = text
                return .none
            }.mapError{ error -> LoginViewModelErrorType in
                return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func passwdNotificationChains(with input: LoginViewModelInput) -> LoginViewModelOutput {
        return input.passwdNotification
            .receive(on: RunLoop.main)
            .map { [unowned self] text -> LoginControllerState in
                passwd = text
                return .none
            }.mapError{ error -> LoginViewModelErrorType in
                return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func isValidFormChains(with input: LoginViewModelInput) -> LoginViewModelOutput {
        return isValidUserForm()
            .tryMap { isValid -> LoginControllerState in
                return .checkIsValid(isValid)
            }.mapError{ error -> LoginViewModelErrorType in
                 return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func isValidUserForm() -> AnyPublisher<Bool, LoginViewModelErrorType> {
        $email
            .receive(on: RunLoop.main)
            .combineLatest($passwd)
            .tryMap { (emailText, passwdText) in
                return !emailText.isEmpty && !passwdText.isEmpty
            }.mapError{ error -> LoginViewModelErrorType in
                return error as? LoginViewModelErrorType ?? .failed
            }.eraseToAnyPublisher()
    }
    
}


//MARK: - LoginViewModelAPIType
extension LoginViewModel: LoginViewModelNetworkServiceType {
    
    func loginInputAccount() {
        Task() {
            do {
                guard let authDataResult = try await AuthService.handleIsLoginAccount(email: email, pw: passwd) else { throw FetchUserError.invalidUserInfo }
                DispatchQueue.main.async {
                    let ud = UserDefaults.standard
                    ud.synchronize()
                    ud.set(authDataResult.user.uid, forKey: CURRENT_USER_UID)
                }
            }catch FetchUserError.invalidUserInfo {
                print("DEBUG: Fail to bind userInfo")
            }catch {
                print("DEBUG: Failure an occured error: \(error.localizedDescription) ")
            }
        }
    }

}

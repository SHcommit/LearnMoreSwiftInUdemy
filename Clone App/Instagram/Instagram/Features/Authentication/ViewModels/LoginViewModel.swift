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
    let succeedLogin = PassthroughSubject<Bool,Never>()
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private let apiClient: ServiceProviderType
    
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType) {
        self.apiClient = apiClient
    }
}

//MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    func transform(with input: Input) -> Output {
        subscriptions.forEach{ $0.cancel() }
        subscriptions.removeAll()
        
        //MARK: - Publiser's operator chains
        let loginEvent = loginChains(with: input)
        let signUp = signUpChains(with: input)
        let emailNotification = emailNotificationChains(with: input)
        let passwdNotification = passwdNotificationChains(with: input)
        let isValidForm = isValidFormChains(with: input)
        let succeedLoginSubscription = succeedLoginSubscriptionChains()
        
        return Publishers
            .Merge6(
                loginEvent,
                signUp,
                emailNotification,
                passwdNotification,
                isValidForm,
                succeedLoginSubscription).eraseToAnyPublisher()
    }

}

//MARK: - LoginViweModelInputCase
extension LoginViewModel: LoginViewModelInputCase {
    
    func loginChains(with input: Input) -> Output {
        return input.login
            .receive(on: RunLoop.main)
            .tryMap { [unowned self] viewType -> State in
                loginAndOwnerUidStoreInUserDefaults()
                return .none
            }.mapError{ error -> ErrorCase in
                return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func signUpChains(with input: Input) -> Output {
        return input.signUp
            .receive(on: RunLoop.main)
            .tryMap { _ -> State in
                return .showRegister
            }.mapError{ error -> ErrorCase in
                return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func emailNotificationChains(with input: Input) -> Output {
        return input.emailNotification
            .receive(on: RunLoop.main)
            .map { [unowned self] text -> State in
                email = text
                return .none
            }.mapError{ error -> ErrorCase in
                return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func passwdNotificationChains(with input: Input) -> Output {
        return input.passwdNotification
            .receive(on: RunLoop.main)
            .map { [unowned self] text -> State in
                passwd = text
                return .none
            }.mapError{ error -> ErrorCase in
                return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func isValidFormChains(with input: Input) -> Output {
        return isValidUserForm()
            .tryMap { isValid -> State in
                return .checkIsValid(isValid)
            }.mapError{ error -> ErrorCase in
                 return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    func isValidUserForm() -> AnyPublisher<Bool, ErrorCase> {
        $email
            .receive(on: RunLoop.main)
            .combineLatest($passwd)
            .tryMap { (emailText, passwdText) in
                return !emailText.isEmpty && !passwdText.isEmpty
            }.mapError{ error -> ErrorCase in
                return error as? ErrorCase ?? .failed
            }.eraseToAnyPublisher()
    }
    
    private func succeedLoginSubscriptionChains() -> Output {
        return succeedLogin
            .subscribe(on: RunLoop.main)
            .setFailureType(to: ErrorCase.self)
            .tryMap{ isSucceed -> State in
                if isSucceed {
                    return .showFeed
                }
                return .endIndicator
            }
            .mapError{$0 as! ErrorCase}
            .eraseToAnyPublisher()
    }
    
}


//MARK: - LoginViewModelAPIType
extension LoginViewModel: LoginViewModelNetworkServiceType {
    
    func loginAndOwnerUidStoreInUserDefaults() {
        Task(priority: .high) {
            do {
                guard let authDataResult = try await apiClient
                    .authCase
                    .handleIsLoginAccount(email: email, pw: passwd) else { throw FetchUserError.invalidUserInfo
                }
                DispatchQueue.main.async {
                    let ud = UserDefaults.standard
                    ud.synchronize()
                    ud.set(authDataResult.user.uid, forKey: CURRENT_USER_UID)
                }
                succeedLogin.send(true)
            }catch FetchUserError.invalidUserInfo {
                succeedLogin.send(false)
                print("DEBUG: Fail to bind userInfo")
            }catch {
                succeedLogin.send(false)
                print("DEBUG: Failure an occured error: \(error.localizedDescription) ")
            }
        }
    }

}

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
    weak var authDelegate: AuthentificationDelegate?
    @Published var email: String = ""
    @Published var passwd: String = ""
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
}

//MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    
    func isValidUserForm() -> AnyPublisher<Bool, Never> {
        $email
            .zip($passwd)
            .map { (emailText, passwdText) in
                return !emailText.isEmpty && !passwdText.isEmpty
            }.eraseToAnyPublisher()
    }
    
    func checkIsValidTextFields(withLogin button: UIButton) {
        isValidUserForm()
            .receive(on: RunLoop.main)
            .sink{ isValied in
                if isValied {
                    button.isEnabled = true
                    button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
                    button.titleLabel?.textColor.withAlphaComponent(1)
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
                    button.titleLabel?.textColor.withAlphaComponent(0.2)
                }
            }.store(in: &subscriptions)
    }
    
    func login(with input: LoginViewModelInput) {
        subscriptions.forEach{ $0.cancel() }
        subscriptions.removeAll()
        
        input
            .tapLogin
            .receive(on: RunLoop.main)
            .sink { [unowned self] presentingVC in
                guard let vc = presentingVC as? MainHomeTabController else { return }
                vc.view.isHidden = false
                loginInputAccount(mainHomeTab: vc)
            }.store(in: &subscriptions)
    }

}

//MARK: - LoginViewModelAPIType
extension LoginViewModel: LoginViewModelAPIType {
    
    func loginInputAccount(mainHomeTab vc: MainHomeTabController) {
        Task() {
            do {
                guard let authDataResult = try await AuthService.handleIsLoginAccount(email: email, pw: passwd) else { throw FetchUserError.invalidUserInfo }
                await authDelegate?.authenticationCompletion(uid: authDataResult.user.uid)
                await vc.endIndicator(indicator: indicator)
            }catch FetchUserError.invalidUserInfo {
                print("DEBUG: Fail to bind userInfo")
            }catch {
                print("DEBUG: Failure an occured error: \(error.localizedDescription) ")
            }
        }
    }

}

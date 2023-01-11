//
//  LoginViewModelProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine

protocol AuthentificationDelegate: class {
    
    /// 회원이라면 메인화면으로 돌아간다.
    /// 이때 Firebase  에서 지원하는 Auth.auth().currentUser는 잘 동작하지 않는다.
    /// 초기에는 동작하지만 중간에 사용자가 로그아웃 후 다른 계정으로 로그인 할 경우 currentuser의 캐시가 변경되지 않는다고 한다.
    /// 그래서 영구 저장소에 저장하고 갱신하기 위해 로그인된 유저의 uid를 따로 반환한다.
    func authenticationCompletion(uid: String) async
    
}

/**
 TODO : LoginController의 Input이 에러일 경우에 대한 error type.
 
 - case loginPublishedOutputStreamNil : presentingVC or currentVC가 nil일 때
 - case signUpPublisedOutputStreamNil : navigationController가 nil일 때
 - case failed : etc
 */
enum LoginViewModelErrorType: Error {
    
    case loginPublishedOutputStreamNil,
         signUpPublisedOutputStreamNil,
         failed
    
    var errorDiscription: String {
        switch self {
        case .failed:
            return "DEBUG: Invalid code"
        case .signUpPublisedOutputStreamNil:
            return "DEBUG: SignUp's published output is nil"
        case .loginPublishedOutputStreamNil:
            return "DEBUG: Login's published output is nil"
        }
    }
}

typealias LoginVMInputLoginOutputType = (presentingVC: UIViewController?, currentVC: UIViewController?)

/**
 TODO : LoginController에서 발생할 수 있는 이벤트.
 
 - Param login : 로그인 버튼 클릭할 때
 - Param signUp : 회원가입 버튼 클릭할 때
 - Param emailNotification : 이메일 작성할 때
 - Param passwdNotification : 패스워드 작성할 때
 
 # Notes: #
 1. 특별하게 Never란 없다는 마음가짐으로 Never Type를 publisher의 타입으로 사용하지 않았다.
 */
struct LoginViewModelInput {
    
    //MARK: - InputEvent
    var login: AnyPublisher<LoginVMInputLoginOutputType,LoginViewModelErrorType>
    
    var signUp: AnyPublisher<UINavigationController?,LoginViewModelErrorType>
    
    var emailNotification: AnyPublisher<String, LoginViewModelErrorType>
    
    var passwdNotification: AnyPublisher<String, LoginViewModelErrorType>
    
}

/**
 TODO : LoginController의 Input을 구현하는 함수들
 
 - Param loginChains : login Input의 publiser stream operator chains
 - Param signUpChains : SignUp Input의 publiser stream operator chains
 - Param emailNotificationChains : EmailNotification Input의 publisher stream operator chains
 - Param passwdNotificationChains : PasswdNotification Input의 publisher stream operator chains
 - Param isValidFormChains : IsValidForm Input의 publiser stream oeprator chains
 - Param isValidUserForm : 사용자 로그인 ,비번 입력했는지 여부
 */
protocol LoginViewModelInputCase {
    
    func loginChains(with input: LoginViewModelInput) -> LoginViewModelOutput
    
    func signUpChains(with input: LoginViewModelInput) -> LoginViewModelOutput
    
    func emailNotificationChains(with input: LoginViewModelInput) -> LoginViewModelOutput
    
    func passwdNotificationChains(with input: LoginViewModelInput) -> LoginViewModelOutput
    
    func isValidFormChains(with input: LoginViewModelInput) -> LoginViewModelOutput
    
    /// 사용자가 로그인, 비밀번호 칸을 두개 다 입력 했는지 체크 여부 반환한다.
    /// 추후 비밀번호 최소 입력 개수를 제한하고 알림창을 띄우는 기능을 추가할 것이다.
    func isValidUserForm() -> AnyPublisher<Bool,LoginViewModelErrorType>
    
}

typealias LoginViewModelOutput = AnyPublisher<LoginControllerState,LoginViewModelErrorType>

enum LoginControllerState {
    case checkIsValid(Bool),
         none,
         endIndicator
}

protocol LoginViewModelType {

    func transform(with input: LoginViewModelInput) -> LoginViewModelOutput
    
}

protocol LoginViewModelNetworkServiceType {
    
    /// Async, Await을 통해 회원 여부 판단을 request하는 server api관련 wrapper func.
    func loginInputAccount(currentVC: LoginController )
    
}

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


protocol LoginViewModelType {
    
    /// 사용자가 로그인, 비밀번호 칸을 두개 다 입력 했는지 체크 여부 반환한다.
    /// 추후 비밀번호 최소 입력 개수를 제한하고 알림창을 띄우는 기능을 추가할 것이다.
    func isValidUserForm() -> AnyPublisher<Bool,Never>
    
    /// 입력한 email, pw 두 userForm을 통해 회원인지 아닌지 확인한다.
    func checkIsValidTextFields(withLogin button: UIButton)
    
    /// LoginController에서 ViewModel로 login 입력이 들어온다.
    func login(with input: LoginViewModelInput)
    
}

protocol LoginViewModelNetworkServiceType {
    
    /// Async, Await을 통해 회원 여부 판단을 request하는 server api관련 wrapper func.
    func loginInputAccount(mainHomeTab vc: MainHomeTabController)
    
}

//
//  AuthenticationViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import Foundation


struct LoginViewModel {
    //MARK: - Properties
    var email = Dynamic("")
    var password = Dynamic("")
    
    var isValiedUserForm: Bool {
        get {
            return !(email.value.isEmpty) && !(password.value.isEmpty)
        }
    }
}

struct RegistrationViewModel {
    
}


// T value가 변할 때마다 listener?(value) 클로저를 실행한다.
// 이때 이 값을 TextField UI에 갱신할 것이다.
class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(callback: @escaping Listener) {
        listener = callback
    }
    
    init(_ value: T) {
        self.value = value
    }
    
}

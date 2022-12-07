//
//  RegistrationViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/06.
//

import UIKit


class RegistrationViewModel {
    
    //MARK: - Properties
    var email = Dynamic("")
    var password = Dynamic("")
    var fullname = Dynamic("")
    var username = Dynamic("")
    var profileImage: UIImage?
    
    //MARK: - Helpers
    var isValiedUserForm: Bool {
        get {
            return !(email.value.isEmpty) && !(password.value.isEmpty)
            && !(fullname.value.isEmpty) && !(username.value.isEmpty)
        }
    }
    
    func getUserInfoModel(uid: String, url: String) -> UserInfoModel {
        return UserInfoModel(email: email.value,
                                 fullname: fullname.value,
                                 profileURL: url,
                                 uid: uid,
                                 username: username.value)
    }
    
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

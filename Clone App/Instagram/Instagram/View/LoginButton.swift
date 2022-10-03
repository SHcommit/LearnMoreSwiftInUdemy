//
//  LoginButton.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import UIKit

class LoginButton: UIButton {
    
    //MARK: - Life cycle
    init(title: String) {
        super.init(frame: .zero)
        initialLoginButton(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드로는 사용 안할거여서 구현 안했음!")
    }
}

//MARK: - initialize
extension LoginButton {
    
    func initialLoginButton(_ title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        setTitle(title, for: .normal)
        backgroundColor = UIColor.systemPink.withAlphaComponent(0.4)
        titleLabel?.font = .systemFont(ofSize: 17)
        setTitleColor(.systemPink, for: .highlighted)
    }
}

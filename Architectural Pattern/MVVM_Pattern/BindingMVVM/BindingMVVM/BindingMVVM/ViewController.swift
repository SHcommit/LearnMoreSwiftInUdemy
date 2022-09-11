//
//  ViewController.swift
//  BindingMVVM
//
//  Created by 양승현 on 2022/09/11.
//

import UIKit

class ViewController: UIViewController {
    private var loginVM = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}

//MARK: - setupUI
extension ViewController {
    private func setupUI() {
        
        let usernameTextField = BindingTextField()
        usernameTextField.placeholder = "Enter username"
        usernameTextField.backgroundColor = UIColor.lightGray
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.bind{ [weak self] text in
            print(text)
            self?.loginVM.username = text
        }
        
        let passwordTextField = BindingTextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Enter password"
        passwordTextField.backgroundColor = UIColor.lightGray
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.bind{ [weak self] text in
            self?.loginVM.password = text
        }
        
        
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.gray
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField,passwordTextField,loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

//MARK: - event Handler
extension ViewController {
    
    @objc func login() {
        print("username: \(loginVM.username)\n password: \(loginVM.password)")
        print()
    }
    
}

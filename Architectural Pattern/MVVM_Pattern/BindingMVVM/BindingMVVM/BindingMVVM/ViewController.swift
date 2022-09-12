//
//  ViewController.swift
//  BindingMVVM
//
//  Created by 양승현 on 2022/09/11.
//

import UIKit

class ViewController: UIViewController {
    private var loginVM = LoginViewModel()
    
    lazy var usernameTextField: UITextField = {
        let usernameTextField = BindingTextField()
        usernameTextField.placeholder = "Enter username"
        usernameTextField.backgroundColor = UIColor.lightGray
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.bind{ [weak self] text in
            print(text)
            self?.loginVM.username.value = text
        }
        
        return usernameTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        
        let passwordTextField = BindingTextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Enter password"
        passwordTextField.backgroundColor = UIColor.lightGray
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.bind{ [weak self] text in
            self?.loginVM.password.value = text
        }
        
        return passwordTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginVM.username.bind{ [weak self] text in
            self?.usernameTextField.text = text
        }
        
        
        loginVM.password.bind { [weak self] text in
            self?.passwordTextField.text = text
        }
        
        setupUI()
    }


}

//MARK: - setupUI
extension ViewController {
    private func setupUI() {
        
        
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.gray
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let fetchLoginInfoButton = UIButton()
        fetchLoginInfoButton.setTitle("Fetch Login Info", for: .normal)
        fetchLoginInfoButton.backgroundColor = UIColor.gray
        fetchLoginInfoButton.addTarget(self, action: #selector(fetchLoginInfo), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField,passwordTextField,loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(fetchLoginInfoButton)
        fetchLoginInfoButton.translatesAutoresizingMaskIntoConstraints = false
        fetchLoginInfoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fetchLoginInfoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        fetchLoginInfoButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 20).isActive = true
        
        
    }
}

//MARK: - event Handler
extension ViewController {
    
    @objc func login() {
        print("username: \(loginVM.username.value)\npassword: \(loginVM.password.value)")
        print()
    }
    
    @objc func fetchLoginInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.loginVM.username.value = "marydo"
            self?.loginVM.password.value = "haha"
            print("username: \(self?.loginVM.username.value)\npassword: \(self?.loginVM.password.value)")
        }

    }
    
}

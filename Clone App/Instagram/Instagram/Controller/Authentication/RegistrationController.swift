//
//  RegistrationController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    private lazy var photoButton: UIButton = initialPhotoButton()
    private lazy var userInputStackView: UIStackView = initialUserInputStackView()
    private var emailTextField: CustomTextField = initialEmailTextField()
    private var passwordTextField: CustomTextField = initialPasswordTextField()
    private var fullnameTextField: CustomTextField = initialFullnameTextField()
    private var usernameTextField: CustomTextField = initialUsernameTextField()
    private lazy var signUpButton: LoginButton = initialSignUpButton()
    private var readyLogInLineStackView: UIStackView = initialReadyLogInLineStackView()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}


//MARK: - Helpers
extension RegistrationController {
    
    func setupUI() {
        setupViewGradientBackground()
        addSubviews()
        setupSubviewsConstraints()
    }
    
    func addSubviews() {
        view.addSubview(photoButton)
        view.addSubview(userInputStackView)
        view.addSubview(signUpButton)
        view.addSubview(readyLogInLineStackView)
    }
    
    func setupSubviewsConstraints() {
        setupPhotoButtonConstraints()
        setupUserInputStackViewConstraints()
        setupSignUpButtonConstraints()
        setupReadyLogInLineStackViewConstraints()
    }
}

//MARK: - Initial subviews
extension RegistrationController {
    
    func initialPhotoButton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage.imageLiteral(name: "plus_photo").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(didTapPhotoButton(_:)), for: .touchUpInside)
        return btn
    }
    
    func initialUserInputStackView()-> UIStackView {
        let sv = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalCentering
        
        return sv
    }
    
    static func initialEmailTextField() -> CustomTextField {
        let email = CustomTextField(placeHolder: "Email")
        email.keyboardType = .emailAddress
        email.setHeight(50)
        return email
    }
    
    static func initialPasswordTextField() -> CustomTextField {
        let pw = CustomTextField(placeHolder: "Password")
        pw.isSecureTextEntry = true
        pw.setHeight(50)
        return pw
    }
    
    static func initialFullnameTextField() -> CustomTextField {
        let tf = CustomTextField(placeHolder: "Fullname")
        tf.setHeight(50)
        return tf
        
    }
    
    static func initialUsernameTextField() -> CustomTextField {
        let tf = CustomTextField(placeHolder: "Username")
        tf.setHeight(50)
        return tf
    }
    
    func initialSignUpButton() -> LoginButton {
        let btn = LoginButton(title: "Sign Up")
        btn.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        return btn
    }
    
    static func initialReadyLogInLineStackView() -> UIStackView {
        let helpLine = UserHelpLabelAndButton(first: "Already have an account? ", second: "Log In")
        helpLine.addTargetSecondButton(eventHandler: #selector(didTapLoginButton(_:)))
        
        let sv = UIStackView(arrangedSubviews: helpLine.getProperties)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        
        return sv
    }
}


//MARK: - Setup subview's constraints
extension RegistrationController {
    
    func setupPhotoButtonConstraints() {
        NSLayoutConstraint.activate([
            photoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: 140),
            photoButton.heightAnchor.constraint(equalToConstant: 140)])
    }
    
    func setupUserInputStackViewConstraints() {
        NSLayoutConstraint.activate([
            userInputStackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 32),
            userInputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            userInputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
    
    func setupSignUpButtonConstraints() {
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: userInputStackView.bottomAnchor, constant: 10),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            signUpButton.heightAnchor.constraint(equalToConstant: signUpButton.frame.height+40)])
    }
    
    func setupReadyLogInLineStackViewConstraints() {
        NSLayoutConstraint.activate([
            readyLogInLineStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            readyLogInLineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
}

//MARK: - Setup event handler
extension RegistrationController {

    @objc func didTapLoginButton(_ sender: Any) {
        print("로그인 버튼 터치")
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        print("사인업 버튼 터치")
    }
    
    @objc func didTapPhotoButton(_ sender: Any) {
        print("포토 이미지 클릭")
    }
}

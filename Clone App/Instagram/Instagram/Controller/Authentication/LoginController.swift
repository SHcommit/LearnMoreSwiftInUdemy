//
//  LoginController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit
import Firebase
import Combine

class LoginController: UIViewController {
    
    //MARK: - Properties
    private let instagramIcon: UIImageView = initialInstagramIcon()
    private lazy var emailTextField: UITextField = initialEmailTextField()
    private lazy var passwdTextField: UITextField = initialPasswdTextField()
    private lazy var loginButton: LoginButton = initialLoginButton()
    private lazy var forgotHelpLineStackView: UIStackView = initialForgotStackView()
    private lazy var signUpLineStackView: UIStackView = initialSignUpLineStackView()
    
    var viewModel: LoginViewModel = LoginViewModel()
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    private var tapLogin: PassthroughSubject<UIViewController,Never> = PassthroughSubject<UIViewController,Never>()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
}

//MARK: - View helpers
extension LoginController {
    
    func setupUI() {
        setupNavigationBar()
        setupViewGradientBackground()
        addSubviews()
        setupSubviewsConstarints()
    }
    
    func addSubviews() {
        view.addSubview(instagramIcon)
        view.addSubview(emailTextField)
        view.addSubview(passwdTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotHelpLineStackView)
        view.addSubview(signUpLineStackView)
    }
    
}

//MARK: - Setup event handler
extension LoginController {
    
    @objc func didTapLoginButton(_ sender: Any) {
        startIndicator(indicator: indicator)
        guard let presentingViewController = presentingViewController else { return }
        tapLogin.send(presentingViewController)
    }
    
    @objc func didTapHelpButton(_ sender: Any) {
        print("핼프버튼 터치")
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        let registrationVC = RegistrationController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }

}

//MARK: - Helpers
extension LoginController {
    
    func setupBindings() {
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        let input = LoginViewModelInput(tapLogin: tapLogin.eraseToAnyPublisher())
        viewModel.login(with: input)
        
        CombineUtils.textfieldNotificationPublisher(withTF: emailTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                viewModel.email = text
                viewModel.checkIsValidTextFields(withLogin: loginButton)
            }.store(in: &subscriptions)
            
        CombineUtils.textfieldNotificationPublisher(withTF: passwdTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                viewModel.passwd = text
                viewModel.checkIsValidTextFields(withLogin: loginButton)
            }.store(in: &subscriptions)

    }
    
}

//MARK: - Setup Navigation
extension LoginController {
    func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupNavigationBar() {
        setupNavigationAppearance()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
}

//MARK: - Initial subviews
extension LoginController {
    
    static func initialInstagramIcon() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .imageLiteral(name: "Instagram_logo_white")
        return iv
    }
    
    func initialEmailTextField() -> CustomTextField {
        let tf = CustomTextField(placeHolder: "Email")
        tf.keyboardType = .emailAddress
        tf.setHeight(50)
        return tf
    }
    
    func initialPasswdTextField() -> CustomTextField {
        let tf = CustomTextField(placeHolder: "Password")
        tf.isSecureTextEntry = true
        tf.setHeight(50)
        return tf
    }
    
    func initialLoginButton() -> LoginButton {
        let btn = LoginButton(title: "Log in")
        btn.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        return btn
    }
    
    func initialForgotStackView() -> UIStackView {

        let lineViews = UserHelpLabelAndButton(first: "Forgot your password ", second: "Get help signing in.")
        lineViews.addTargetSecondButton(eventHandler: #selector(didTapHelpButton(_:)))
        
        let stackView = UIStackView(arrangedSubviews: lineViews.getProperties)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }
    
    func initialSignUpLineStackView() -> UIStackView {
        let questAccountAndSignUpLine = UserHelpLabelAndButton(first: "Don't have an account? ", second: "Sign Up")
        questAccountAndSignUpLine.addTargetSecondButton(eventHandler: #selector(didTapSignUpButton(_:)))
        
        let sv = UIStackView(arrangedSubviews: questAccountAndSignUpLine.getProperties)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalCentering
        sv.axis = .horizontal
        
        return sv
    }
    
}

//MARK: - Setup subivew's constraints
extension LoginController {
    
    func setupSubviewsConstarints() {
        setupInstagramIconConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordTextFieldConstraints()
        setupLoginButtonConstraints()
        setupForgotLineStackViewConstraints()
        setupSignUpLineStackViewConstraints()
    }
    
    func setupInstagramIconConstraints() {
        NSLayoutConstraint.activate([
            instagramIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            instagramIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupEmailTextFieldConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: instagramIcon.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
    
    func setupPasswordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            passwdTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
    
    func setupLoginButtonConstraints() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwdTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: loginButton.frame.height + 40)])
    }
    
    func setupForgotLineStackViewConstraints() {
        NSLayoutConstraint.activate([
            forgotHelpLineStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            forgotHelpLineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupSignUpLineStackViewConstraints() {
        NSLayoutConstraint.activate([
            signUpLineStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signUpLineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
}

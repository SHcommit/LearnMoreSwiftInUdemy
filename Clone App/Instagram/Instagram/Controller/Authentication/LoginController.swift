//
//  LoginController.swift
//  Instagram
//
//  Created by μμΉν on 2022/10/02.
//

import UIKit
import Firebase
import Combine

class LoginController: UIViewController {
    
    //MARK: - Properties
    weak var authDelegate: AuthentificationDelegate?
    private let instagramIcon: UIImageView = initialInstagramIcon()
    private lazy var emailTextField: UITextField = initialEmailTextField()
    private lazy var passwdTextField: UITextField = initialPasswdTextField()
    private lazy var loginButton: LoginButton = initialLoginButton()
    private lazy var forgotHelpLineStackView: UIStackView = initialForgotStackView()
    private lazy var signUpLineStackView: UIStackView = initialSignUpLineStackView()
    
    //MARK: - Combine Properties
    var viewModel: LoginViewModelType
    private var login = PassthroughSubject<LoginVMInputLoginOutputType, LoginViewModelErrorType>()
    private var signUp = PassthroughSubject<UINavigationController?, LoginViewModelErrorType>()
    private var emailNotification = PassthroughSubject<String, LoginViewModelErrorType>()
    private var passwdNotification = PassthroughSubject<String, LoginViewModelErrorType>()
    
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    
    //MARK: - Life cycles
    init(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        login.send((presentingViewController, self))
    }
    
    @objc func didTapHelpButton(_ sender: Any) {
        print("νΌνλ²νΌ ν°μΉ")
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        signUp.send(navigationController)
    }

}

//MARK: - LoginViewModel bind
extension LoginController {
    
    func setupBindings() {
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        setupEmailTextFieldPublisherWithTextDidChanged()
        setupPasswdTextFieldPublisherWithTextDidChanged()
        
        let input = LoginViewModelInput(login: login.eraseToAnyPublisher(),
                                        signUp: signUp.eraseToAnyPublisher(),
                                        emailNotification: emailNotification.eraseToAnyPublisher(),
                                        passwdNotification: passwdNotification.eraseToAnyPublisher())
        
        let output = viewModel.transform(with: input)
        output.sink { [unowned self] result in
            switch result {
            case.finished:
                break
            case .failure(let error):
                outputErrorHandling(with: error)
                break
            }
        } receiveValue: { state in
            self.render(in: state)
        }.store(in: &subscriptions)

    }
    
    func render(in state: LoginControllerState) {
        switch state {
        case .none:
            break
        case .endIndicator:
            endIndicator(indicator: indicator)
            break
        case .checkIsValid(let isValid):
            endIndicator(indicator: indicator)
            loginButtonSwitchHandler(with: isValid)
            break
        }
    }
    
}

//MARK: - Helpers
extension LoginController {
    
    //MARK: - otuputErrorHandling
    func outputErrorHandling(with error: LoginViewModelErrorType) {
        switch error {
        case .failed:
            print(LoginViewModelErrorType.failed.errorDiscription + " : \(error.localizedDescription)")
            break
        case .loginPublishedOutputStreamNil:
            print(LoginViewModelErrorType.loginPublishedOutputStreamNil.errorDiscription + " : \(error.localizedDescription)")
            break
        case .signUpPublisedOutputStreamNil:
            print(LoginViewModelErrorType.signUpPublisedOutputStreamNil.errorDiscription + " : \(error.localizedDescription)")
            break
        }
    }
    
    //MARK: - setupBindings Helpers
    func loginButtonSwitchHandler(with isValid: Bool) {
        if isValid {
            enableLoginButton()
        }else {
            disableLoginButton()
        }
    }
    
    func enableLoginButton() {
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
        loginButton.titleLabel?.textColor.withAlphaComponent(1)
    }
    
    func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        loginButton.titleLabel?.textColor.withAlphaComponent(0.2)
    }
    
    func setupEmailTextFieldPublisherWithTextDidChanged() {
        CombineUtils.textfieldNotificationPublisher(withTF: emailTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                emailNotification.send(text)
            }.store(in: &subscriptions)
    }
    
    func setupPasswdTextFieldPublisherWithTextDidChanged() {
        CombineUtils.textfieldNotificationPublisher(withTF: passwdTextField)
            .receive(on: RunLoop.main)
            .sink{ [unowned self] text in
                passwdNotification.send(text)
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

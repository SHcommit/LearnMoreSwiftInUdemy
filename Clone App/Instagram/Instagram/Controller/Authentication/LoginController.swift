//
//  LoginController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit
import Firebase

protocol AuthentificationDelegate: class {
    func authenticationCompletion(uid: String) async
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    weak var authDelegate: AuthentificationDelegate?
    private let instagramIcon: UIImageView = initialInstagramIcon()
    private lazy var emailTextField: CustomTextField = initialEmailTextField()
    private lazy var passwdTextField: CustomTextField = initialPasswdTextField()
    private lazy var loginButton: LoginButton = initialLoginButton()
    private lazy var forgotHelpLineStackView: UIStackView = initialForgotStackView()
    private lazy var signUpLineStackView: UIStackView = initialSignUpLineStackView()
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var vm = LoginViewModel()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFieldBindingByViewModel()
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
        let email = vm.email.value
        let pw = vm.password.value
        guard let vc = self.presentingViewController as? MainHomeTabController else {
            return
        }
        async {
            do {
                guard let authDataResult = try await AuthService.handleIsLoginAccount(email: email, pw: pw) else { throw FetchUserError.invalidUserInfo }
                endIndicator(indicator: indicator)
                vc.view.isHidden = false
                await authDelegate?.authenticationCompletion(uid: authDataResult.user.uid)
            }catch FetchUserError.invalidUserInfo {
                print("DEBUG: Fail to bind userInfo")
            }catch {
                print("DEBUG: Failure an occured error: \(error.localizedDescription) ")
            }
        }
        
        
//        { [self] result,error in
//            if let error = error {
//                print("Fail login.")
//                return
//            }
//            guard let result = result else { return }
//            endIndicator(indicator: indicator)
//            vc.view.isHidden = false
//            await authDelegate?.authenticationCompletion(uid: result.user.uid)
//        }
        endIndicator(indicator: indicator)
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
    
    //vm의 값이 바뀌면 현재 연결된 UITextField의 쳐져있는 값도 변경.
    func setupTextFieldBindingByViewModel() {
        vm.email.bind{ [weak self] text in
            self?.emailTextField.text = text
        }
        vm.password.bind{ [weak self] text in
            self?.passwdTextField.text = text
        }
    }
    
    func changeValidTextFields() {
        if vm.isValiedUserForm {
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
                self.loginButton.titleLabel?.textColor.withAlphaComponent(1)
            }
        } else {
            DispatchQueue.main.async {
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
                self.loginButton.titleLabel?.textColor.withAlphaComponent(0.2)
            }
        }
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
        tf.bind{ [weak self] text in
            self?.vm.email.value = text
            self?.changeValidTextFields()
        }
        return tf
    }
    
    func initialPasswdTextField() -> CustomTextField {
        let tf = CustomTextField(placeHolder: "Password")
        tf.isSecureTextEntry = true
        tf.setHeight(50)
        tf.bind { [weak self] text in
            self?.vm.password.value = text
            self?.changeValidTextFields()
        }
        
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

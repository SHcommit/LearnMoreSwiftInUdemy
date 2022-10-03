//
//  LoginController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    private let instagramIcon: UIImageView = initialInstagramIcon()
    private var emailTextField: UITextField = initialEmailTextField()
    private var passwdTextField: UITextField = initialPasswdTextField()
    private lazy var loginButton: UIButton = initialLoginButton()
    private lazy var forgotHelpLineStackView: UIStackView = initialForgotStackView()
    private lazy var signUpLineStackView: UIStackView = initialSignUpLineStackView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


//MARK: - Helpers
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
    
    static func setupTextfieldMargins(tf : UITextField) {
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.rightViewMode = .always
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

//MARK: - Setup ViewController UI
extension LoginController {
    func setupViewGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        let gradientColors: [CGColor] = [
                .init(red: 1.00, green: 0.37, blue: 0.43, alpha: 1.00),
                .init(red: 1.00, green: 0.75, blue: 0.46, alpha: 1.00),
                .init(red: 1.00, green: 0.76, blue: 0.44, alpha: 1.00)]
        
        gradient.colors = gradientColors
        view.layer.addSublayer(gradient)
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
    
    static func initialEmailTextField() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.backgroundColor = .init(red: 0.58, green: 0.69, blue: 0.75, alpha: 0.45)
        setupTextfieldMargins(tf: tf)
        return tf
    }
    
    static func initialPasswdTextField() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.backgroundColor = .init(red: 0.58, green: 0.69, blue: 0.75, alpha: 0.45)
        setupTextfieldMargins(tf: tf)
        
        return tf
    }
    
    func initialLoginButton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Log in", for: .normal)
        btn.backgroundColor = UIColor.systemPink.withAlphaComponent(0.4)
        btn.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 17)
        
        return btn
    }
    
    func initialForgotStackView() -> UIStackView {
        let forgotLoginTextLabel: UILabel = initialForgetLoginTextlabel()
        let helpTextLabel: UIButton = initialHelpButton()
        
        let stackView = UIStackView(arrangedSubviews: [forgotLoginTextLabel,helpTextLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }
    
    func initialForgetLoginTextlabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "Forget your password?"
        lb.font = .systemFont(ofSize: 13)
        
        return lb
    }
    
    func initialHelpButton() -> UIButton {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Get help signing in. ", for: .normal)
        btn.addTarget(self, action: #selector(didTapHelpButton(_:)), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        return btn
    }
    
    func initialSignUpLineStackView() -> UIStackView {
        let questionAccount = initialQuestionAccountTextlabel()
        let signUp = initialSignUpButton()
        
        let sv = UIStackView(arrangedSubviews: [questionAccount, signUp])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalCentering
        sv.axis = .horizontal
        
        return sv
    }
    
    func initialQuestionAccountTextlabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "Don't have an account? "
        lb.font = .systemFont(ofSize: 13)
        
        return lb
    }
    
    func initialSignUpButton() -> UIButton {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Sign Up", for: .normal)
        btn.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        return btn
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
            instagramIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            instagramIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupEmailTextFieldConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: instagramIcon.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: emailTextField.frame.height + 50)])
    }
    
    func setupPasswordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            passwdTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwdTextField.heightAnchor.constraint(equalToConstant: passwdTextField.frame.height + 50)])
    }
    
    func setupLoginButtonConstraints() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwdTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
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


//MARK: - Setup event handler
extension LoginController {
    
    @objc func didTapLoginButton(_ sender: Any) {
        print("로그인버튼 터치")
    }
    
    @objc func didTapHelpButton(_ sender: Any) {
        print("핼프버튼 터치")
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        print("싸인업 터치")
    }
}

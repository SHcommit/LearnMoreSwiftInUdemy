//
//  RegistrationController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit
import Combine

class RegistrationController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    private lazy var photoButton: UIButton = initialPhotoButton()
    private lazy var userInputStackView: UIStackView = initialUserInputStackView()
    private var emailTextField: UITextField = initialEmailTextField()
    private var passwordTextField: UITextField = initialPasswordTextField()
    private var fullnameTextField: UITextField = initialFullnameTextField()
    private var usernameTextField: UITextField = initialUsernameTextField()
    private lazy var signUpButton: LoginButton = initialSignUpButton()
    private var readyLogInLineStackView: UIStackView = initialReadyLogInLineStackView()
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var viewModel = RegistrationViewModel(apiClient: ServiceProvider.defaultProvider())
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    private var appear = PassthroughSubject<Void,Never>()
    private var signUpTap = PassthroughSubject<UINavigationController?,Never>()
    private var photoPickerTap = PassthroughSubject<RegistrationController, Never>()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
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
    
    func setupBinding() {
        
        let input = RegistrationViewModelInput(appear: appear.eraseToAnyPublisher(), signUpTap: signUpTap.eraseToAnyPublisher(), photoPickerTap: photoPickerTap.eraseToAnyPublisher())
        
        viewModel.bind(with: input)
        
        CombineUtils.textfieldNotificationPublisher(withTF: emailTextField)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                viewModel.email = text
            }.store(in: &subscriptions)
        CombineUtils.textfieldNotificationPublisher(withTF: passwordTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                viewModel.password = text
            }.store(in: &subscriptions)
        CombineUtils.textfieldNotificationPublisher(withTF: fullnameTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                viewModel.fullname = text
            }.store(in: &subscriptions)
        CombineUtils.textfieldNotificationPublisher(withTF: usernameTextField)
            .receive(on: RunLoop.main)
            .sink { [unowned self] text in
                viewModel.username = text
            }.store(in: &subscriptions)
        
        viewModel.isValidUserForm()
            .receive(on: RunLoop.main)
            .sink { [unowned self] isValid in
                viewModel.checkIsValidTextFields(isValid: isValid, button: signUpButton)
            }.store(in: &subscriptions)
    }
    
    func updatePhotoButtonState(_ image: UIImage) {
        photoButton.setImage(image, for: .normal)
        photoButton.layer.cornerRadius = photoButton.bounds.width / 2
        photoButton.layer.borderWidth = 1.5
        photoButton.layer.borderColor = UIColor.white.cgColor
        photoButton.clipsToBounds = true
        dismiss(animated: true)
    }

}

//MARK: - Setup event handler
extension RegistrationController {

    @objc func didTapLoginButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        signUpTap.send(navigationController)
    }
    
    @objc func didTapPhotoButton(_ sender: Any) {
        photoPickerTap.send(self)
        
    }
}


//MARK: - UIImagePickerController delegate
extension RegistrationController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        viewModel.profileImage = selectedImage
        updatePhotoButtonState(selectedImage)
        
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
        if #available(iOS 12.0, *) {
            pw.textContentType = .oneTimeCode
        }
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
            readyLogInLineStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            readyLogInLineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
}

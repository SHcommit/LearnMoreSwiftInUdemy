//
//  RegistrationController.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/02.
//

import UIKit

class RegistrationController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    private lazy var photoButton: UIButton = initialPhotoButton()
    private lazy var userInputStackView: UIStackView = initialUserInputStackView()
    private var emailTextField: CustomTextField = initialEmailTextField()
    private var passwordTextField: CustomTextField = initialPasswordTextField()
    private var fullnameTextField: CustomTextField = initialFullnameTextField()
    private var usernameTextField: CustomTextField = initialUsernameTextField()
    private lazy var signUpButton: LoginButton = initialSignUpButton()
    private var readyLogInLineStackView: UIStackView = initialReadyLogInLineStackView()
    
    private var vm = RegistrationViewModel()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLabelsBinding()
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
    
    func setupLabelsBinding() {
        emailTextField.bind { [weak self] text in
            self?.changeValidTextFields()
            self?.vm.email.value = text
        }
        passwordTextField.bind { [weak self] text in
            self?.changeValidTextFields()
            self?.vm.password.value = text
        }
        fullnameTextField.bind { [weak self] text in
            self?.changeValidTextFields()
            self?.vm.fullname.value = text
        }
        usernameTextField.bind { [weak self] text in
            self?.changeValidTextFields()
            self?.vm.username.value = text
        }
        
    }
    
    func updatePhotoButtonState(_ image: UIImage) {
        photoButton.setImage(image, for: .normal)
        photoButton.layer.cornerRadius = photoButton.bounds.width / 2
        photoButton.layer.borderWidth = 1.5
        photoButton.layer.borderColor = UIColor.white.cgColor
        photoButton.clipsToBounds = true
        dismiss(animated: true)
    }
    
    func changeValidTextFields() {
        if vm.isValiedUserForm {
            DispatchQueue.main.async {
                self.signUpButton.isEnabled = true
                self.signUpButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.6)
                self.signUpButton.titleLabel?.textColor.withAlphaComponent(1)
            }
        } else {
            DispatchQueue.main.async {
                self.signUpButton.isEnabled = false
                self.signUpButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
                self.signUpButton.titleLabel?.textColor.withAlphaComponent(0.2)
            }
        }
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
        //pw.isSecureTextEntry = true
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

//MARK: - Setup event handler
extension RegistrationController {

    @objc func didTapLoginButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSignUpButton(_ sender: Any) {
        print("사인업 버튼 터치")
    }
    
    @objc func didTapPhotoButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
}


//MARK: - UIImagePickerController delegate
extension RegistrationController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        updatePhotoButtonState(selectedImage)
        
    }
}

//
//  CustomTextField.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import UIKit

class CustomTextField: UITextField {
  
  var textChanged: (String) -> Void = { _ in }
  
  init(placeHolder: String) {
    super.init(frame: .zero)
    setupCustomTextField(placeHolder)
    addTargetTextField(textFieldDidChanged: #selector(textFieldDidChanged(_:)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implement init(coder:)")
  }
  
}

//MARK: - Helpers
extension CustomTextField {
  
  func setupCustomTextField(_ placeHolder: String) {
    translatesAutoresizingMaskIntoConstraints = false
    textColor = .white
    attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 1, alpha: 0.7)])
    font = UIFont.systemFont(ofSize: 17)
    backgroundColor = .init(white: 1, alpha: 0.1)
    keyboardAppearance = .dark
    setupTextfieldMargins()
  }
  
  func setupTextfieldMargins() {
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    leftViewMode = .always
    rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    rightViewMode = .always
  }
  
  func setHeight(_ height: CGFloat) {
    heightAnchor.constraint(equalToConstant: frame.height + height).isActive = true
  }
  
}

extension CustomTextField: BindingTextField{
  func bind(callback: @escaping (String) -> Void) {
    textChanged = callback
  }
  
  func addTargetTextField(textFieldDidChanged: Selector) {
    addTarget(self, action: textFieldDidChanged, for: .editingChanged)
  }
  
  @objc func textFieldDidChanged(_ textField: UITextField) {
    guard let text = textField.text else {
      return
    }
    textChanged(text)
  }
}

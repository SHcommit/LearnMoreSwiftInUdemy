//
//  CustomTextField.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        setupCustomTextField(placeHolder)
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
    
    
}

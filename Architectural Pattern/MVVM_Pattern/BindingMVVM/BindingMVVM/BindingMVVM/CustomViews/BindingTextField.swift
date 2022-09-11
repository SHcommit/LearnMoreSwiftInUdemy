//
//  BindingTextField.swift
//  BindingMVVM
//
//  Created by 양승현 on 2022/09/12.
//

import UIKit

class BindingTextField: UITextField {
    
    //MARK: - properties
    var textChanged: (String) -> Void = { _ in }
    
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    //MARK: - common logics
    //이건 UI -> VM으로 바인딩될때 이 함수로 확인 가능
    func bind(callback: @escaping (String) -> Void) {
        self.textChanged = callback
    }
    
}

//MARK: - Event Handler
extension BindingTextField {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if let text = textField.text {
            textChanged(text)
        }
    }
}

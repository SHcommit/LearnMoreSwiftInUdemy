//
//  BindingTextField.swift
//  Instagram
//
//  Created by μμΉν on 2022/10/04.
//

import UIKit

protocol BindingTextField where Self: UITextField{

//MARK: - Helpers

    func bind(callback: @escaping (String)->Void)
    func addTargetTextField(textFieldDidChanged: Selector)

//MARK: - Setup event handler
    func textFieldDidChanged(_ textField: UITextField)
}

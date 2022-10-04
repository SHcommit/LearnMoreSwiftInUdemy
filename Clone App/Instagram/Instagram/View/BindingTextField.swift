//
//  BindingTextField.swift
//  Instagram
//
//  Created by 양승현 on 2022/10/04.
//

import UIKit

protocol BindingTextField where Self: UITextField{
    
    //MARK: - Properties


//MARK: - Helpers

    func bind(callback: @escaping (String)->Void)
    
    func addTargetTextField(textFieldDidChanged: Selector)


//MARK: - Setup event handler

    
    func textFieldDidChanged(_ textField: UITextField)
}

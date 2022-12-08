//
//  RegistrationViewModelInput.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine

struct RegistrationViewModelInput {
    
    /// Emit ViewWilAppear event to viewModel
    let appear: AnyPublisher<Void,Never>
    
    /// Emit signUp event to viewModel when user did tap SignUp button.
    let signUpTap: AnyPublisher<UINavigationController?,Never>
    
}

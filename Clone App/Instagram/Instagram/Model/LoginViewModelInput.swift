//
//  LoginViewModelInput.swift
//  Instagram
//
//  Created by 양승현 on 2022/12/08.
//

import UIKit
import Combine


///define UI events
struct LoginViewModelInput {
    var tapLogin: AnyPublisher<UIViewController,Never>
}

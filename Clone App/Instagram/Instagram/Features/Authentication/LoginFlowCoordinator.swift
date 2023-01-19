//
//  LoginFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class LoginFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: LoginViewModelType
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: LoginViewModelType) {
        self.presenter = presenter
        self.vm = vm
    }
    
    //MARK: - Action
    func start() {
        <#code#>
    }
    
    func finish() {
        <#code#>
    }
    
}

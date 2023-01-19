//
//  LoginFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class LoginFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var loginController: LoginController!
    var vm: LoginViewModelType
    
    fileprivate let apiClient: ServiceProviderType
    //MARK: - Lifecycles
    init(apiClient: ServiceProviderType) {
        presenter = UINavigationController()
        self.apiClient = apiClient
        vm = LoginViewModel(apiClient: apiClient)
        loginController = LoginController(viewModel: vm)
    }
    
    //MARK: - Action
    func start() {
        loginController.coordinator = self
        presenter.viewControllers = [loginController]
        presenter.pushViewController(loginController, animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}

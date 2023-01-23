//
//  LoginFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class LoginFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var rootCoordinator: ApplicationFlowCoordinator?
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
        //로그인의 경우 이 coordinator가 중첩 실행 할 경우 x. 그래서 다이렉트로 AppCoord Instance를 얻기로 했다.
        rootCoordinator = (parentCoordinator as! ApplicationFlowCoordinator)
        loginController.coordinator = self
        presenter.viewControllers = [loginController]
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}

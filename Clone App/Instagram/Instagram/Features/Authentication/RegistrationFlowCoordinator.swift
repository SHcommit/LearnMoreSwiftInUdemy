//
//  RegistrationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class RegisterFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var parentCoordinator: FlowCoordinator?
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: RegistrationViewModelType
    var registrationController: RegistrationController!
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: RegistrationViewModelType) {
        self.presenter = presenter
        self.vm = vm
        registrationController = RegistrationController()
    }
    
    //MARK: - Action
    func start() {
        registrationController.coordinator = self
        presenter.pushViewController(registrationController, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
    deinit{ print("DEBUG: registrationCoordiantor deallocated.") }
    
}

extension RegisterFlowCoordinator {
    
    func gotoLoginPage() {
        presenter.popViewController(animated: true)
    }
}

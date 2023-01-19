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
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: RegistrationViewModelType) {
        self.presenter = presenter
        self.vm = vm
    }
    
    //MARK: - Action
    func start() {
        print("DEBUG: start logic need!2")
    }
    
    func finish() {
        parentCoordinator?.removeChild(target: self)
        removeAllChild()
    }
    
}

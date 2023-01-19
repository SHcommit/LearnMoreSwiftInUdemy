//
//  ProfileFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class ProfileFlowCoordinator: FlowCoordinator {

    //MARK: - Properties
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: ProfileViewModelType
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: ProfileViewModelType) {
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

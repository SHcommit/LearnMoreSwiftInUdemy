//
//  NotificationFlowCoordinator.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/19.
//

import UIKit

class NotificationFlowCoordinator: FlowCoordinator {
    
    //MARK: - Properties
    var childCoordinators = [FlowCoordinator]()
    var presenter: UINavigationController
    var vm: NotificationCellViewModelType
    
    //MARK: - Lifecycles
    init(presenter: UINavigationController, vm: NotificationCellViewModelType) {
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
